--------------------------------------------------------
--  File created - Friday-January-12-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View XXMX_CUSTOMER_SCOPE_ISV_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CUSTOMER_SCOPE_ISV_V" ("ORG_ID", "CUST_ACCOUNT_ID", "ACCOUNT_NUMBER", "ACCOUNT_PARTY_ID", "ACCOUNT_STATUS", "CUST_ACCT_SITE_ID", "CUST_ACCT_SITE_STATUS", "PARTY_SITE_ID", "SITE_PARTY_ID", "LOCATION_ID") AS 
  WITH
     xxmx_parameters
     AS
          (
           SELECT  xxmx_core.xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'AR'
                             ,'CUSTOMERS'
                             ,'ALL'
                             ,'MONTHS_TO_MIGRATE'
                             )                                         AS customer_months_to_migrate
                  ,xxmx_core.xxmx_utilities_pkg.get_single_parameter_value
                             (
                              'FIN'
                             ,'AR'
                             ,'CUSTOMERS'
                             ,'ALL'
                             ,'NO_ACTIVITY_CUSTOMER_MONTHS'
                             )                                         AS no_activity_customer_months
           FROM    dual
          )
     --
    ,xxmx_parameter_conversions
     AS
          /*
          ** ABS function is used in the calls to the ADD_MONTHS function to remove any existing
          ** negative signs from the values retrieved for the MONTHS_TO_MIGRATE parameters.  The
          ** ABSolute value is then multiplied by -1 to get a past date.  This is to allow for
          ** users assigning a positive or negative value to the parameter.
          */
          (
           SELECT  ADD_MONTHS(
                              SYSDATE
                             ,(ABS(xp.customer_months_to_migrate) * -1)
                             )                                          AS customer_scope_start_date
                  ,ADD_MONTHS(
                              SYSDATE
                             ,(ABS(xp.no_activity_customer_months) * -1)
                             )                                          AS no_activity_threshold_date
           FROM   xxmx_parameters xp
          )
    ,eligible_org_id_list
     AS
          /* Organizations in Scope */
          (
           SELECT  DISTINCT
                   haou.organization_id                                AS org_id
                  ,haou.name                                           AS operating_unit_name
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM   xxmx_core.xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.migration_enabled_flag, 'N') = 'Y'
                                           )
          )
    ,open_balance_trxs
     AS
          /* This query identifies all AR Transactions that have an open balance */
          (
           SELECT  rcta.org_id
                  ,rcta.customer_trx_id
           FROM    eligible_org_id_list                             eoil
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT       rcta
           WHERE   1 = 1
           AND     rcta.org_id                  = eoil.org_id
           AND     NVL(rcta.complete_flag, 'N') = 'Y'
           AND     EXISTS (
                           SELECT 'X'
                           FROM   apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT  apsa
                           WHERE  1 = 1
                           AND    apsa.status               = 'OP'
                           AND    apsa.amount_due_remaining > 0
                           AND    apsa.org_id               = rcta.org_id
                           AND    apsa.customer_trx_id      = rcta.customer_trx_id
                          )
          )
    ,incomplete_trx_custs_and_sites
     AS
          /* This query identifies all Customer Account ID and Customer Account Site IDs  */
          /* which are assigned to Incomplete AR Transactions that were created within    */
          /* the Customer Scope Date Range (e.g. last 18 months)                          */
          /*                                                                              */
          /* UNION ALL is used to make this query faster.  The "consolidated_list" query  */
          /* will UNION the results of this query with other query results to compact the */
          /* CUSTOMER_ID / CUST_ACCT_SITE_ID list to distinct values.                     */
          (
           /* SOLD-TO Customer and Site for Incomplete Trxs created on or after the Scope Date */
           SELECT  itcas_rcta.org_id
                  ,itcas_rcta.sold_to_customer_id                    AS customer_id
                  ,itcas_hcsua.cust_acct_site_id
           FROM    eligible_org_id_list                           itcas_eoil
                  ,xxmx_parameter_conversions                     itcas_xpc
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     itcas_rcta
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   itcas_hcsua
           WHERE   1 = 1
           AND     itcas_rcta.org_id                   = itcas_eoil.org_id
           AND     NVL(itcas_rcta.complete_flag, 'N') <> 'Y'
           AND     TRUNC(itcas_rcta.last_update_date) >= itcas_xpc.customer_scope_start_date
           AND     itcas_hcsua.site_use_id             = itcas_rcta.sold_to_site_use_id
           UNION ALL
           /* SHIP-TO Customer and Site for Incomplete Trxs created on or after the Scope Date */
           SELECT  itcas_rcta1.org_id
                  ,itcas_rcta1.ship_to_customer_id                    AS customer_id
                  ,itcas_hcsua1.cust_acct_site_id
           FROM    eligible_org_id_list                           itcas_eoil1
                  ,xxmx_parameter_conversions                     itcas_xpc1
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     itcas_rcta1
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   itcas_hcsua1
           WHERE   1 = 1
           AND     itcas_rcta1.org_id                   = itcas_eoil1.org_id
           AND     NVL(itcas_rcta1.complete_flag, 'N') <> 'Y'
           AND     TRUNC(itcas_rcta1.last_update_date) >= itcas_xpc1.customer_scope_start_date
           AND     itcas_hcsua1.site_use_id             = itcas_rcta1.ship_to_site_use_id
           UNION ALL
           /* BILL-TO Customer and Site for Incomplete Trxs created on or after the Scope Date */
           SELECT  itcas_rcta2.org_id
                  ,itcas_rcta2.bill_to_customer_id                    AS customer_id
                  ,itcas_hcsua2.cust_acct_site_id
           FROM    eligible_org_id_list                           itcas_eoil2
                  ,xxmx_parameter_conversions                     itcas_xpc2
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     itcas_rcta2
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   itcas_hcsua2
           WHERE   1 = 1
           AND     itcas_rcta2.org_id                   = itcas_eoil2.org_id
           AND     NVL(itcas_rcta2.complete_flag, 'N') <> 'Y'
           AND     TRUNC(itcas_rcta2.last_update_date) >= itcas_xpc2.customer_scope_start_date
           AND     itcas_hcsua2.site_use_id             = itcas_rcta2.bill_to_site_use_id
          )
    ,complete_trx_custs_and_sites
     AS
          /* This query identifies all Customer Account IDs and Customer Account Site IDs */
          /* which are assigned to Complete AR Transactions that have an Open Balance     */
          /* irrespective of when they were created.                                      */
          /*                                                                              */
          /* UNION ALL is used to make this query faster.  The "consolidated_list" query  */
          /* will UNION the results of this query with other query results to compact the */
          /* CUSTOMER_ID / CUST_ACCT_SITE_ID list to distinct values.                     */
          (
           /* SOLD-TO Customer and Site for Trxs with an Open Balance */
           SELECT  ctcas_rcta.org_id
                  ,ctcas_rcta.sold_to_customer_id                    AS customer_id
                  ,ctcas_hcsua.cust_acct_site_id
           FROM    open_balance_trxs                              ctcas_obt
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     ctcas_rcta
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   ctcas_hcsua
           WHERE   1 = 1
           AND     ctcas_rcta.org_id             = ctcas_obt.org_id
           AND     ctcas_rcta.customer_trx_id    = ctcas_obt.customer_trx_id
           AND     ctcas_hcsua.site_use_id       = ctcas_rcta.sold_to_site_use_id
           UNION ALL
           /* SHIP-TO Customer and Site for Trxs with an Open Balance  */
           SELECT  ctcas_rcta1.org_id
                  ,ctcas_rcta1.ship_to_customer_id                    AS customer_id
                  ,ctcas_hcsua1.cust_acct_site_id
           FROM    open_balance_trxs                              ctcas_obt1
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     ctcas_rcta1
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   ctcas_hcsua1
           WHERE   1 = 1
           AND     ctcas_rcta1.org_id             = ctcas_obt1.org_id
           AND     ctcas_rcta1.customer_trx_id    = ctcas_obt1.customer_trx_id
           AND     ctcas_hcsua1.site_use_id       = ctcas_rcta1.ship_to_site_use_id
           UNION ALL
           /* BILL-TO Customer and Site for Trxs with an Open Balance */
           SELECT  ctcas_rcta2.org_id
                  ,ctcas_rcta2.bill_to_customer_id                    AS customer_id
                  ,ctcas_hcsua2.cust_acct_site_id
           FROM    open_balance_trxs                              ctcas_obt2
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     ctcas_rcta2
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   ctcas_hcsua2
           WHERE   1 = 1
           AND     ctcas_rcta2.org_id             = ctcas_obt2.org_id
           AND     ctcas_rcta2.customer_trx_id    = ctcas_obt2.customer_trx_id
           AND     ctcas_hcsua2.site_use_id       = ctcas_rcta2.bill_to_site_use_id
          )
    ,customers_with_open_payments
     AS
          /* This query identifies all Customers which have Open Cash Receipts entered   */
          /* for them.  For each Customer Account ID it will also retrieve the Customer  */
          /* Account Site Ids for all (A)ctive Sites.                                    */
          /*                                                                             */
          /* The Customer and Site Status is included for use in the "consolidated_list" */
          /* UNION query below but only active sites should be included here.            */
          (
           SELECT  cwop_apsa.org_id
                  ,cwop_apsa.customer_id
                  ,cwop_hcasa.cust_acct_site_id
           FROM    xxmx_parameter_conversions                       cwop_xpc
                  ,eligible_org_id_list                             cwop_eoil
                  ,apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT      cwop_acra
                  ,apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT  cwop_apsa
                  ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT    cwop_hcasa
           WHERE   1 = 1
           AND     cwop_acra.org_id                     = cwop_eoil.org_id
           AND     cwop_acra.type                       = 'CASH'                        /* Ensure only CASH Receipts are evaluated                          */
           AND     cwop_apsa.org_id                     = cwop_acra.org_id                   /* Payment Schedule to Cash Receipts Joins                          */
           AND     cwop_apsa.cash_receipt_id            = cwop_acra.cash_receipt_id          /* Payment Schedule to Cash Receipts Joins                          */
           AND     cwop_apsa.class                      = 'PMT'                         /* Payment Schedule Class for Cash Receipts                         */
           AND     (                                                                                                                                   
                       cwop_apsa.status                  = 'OP'                         /* Payment Schedule is OPen                                         */
                    OR (                                                                                                                               
                            cwop_apsa.status            = 'CL'                          /* OR Payment Scheulde is CLosed                                    */
                        AND cwop_apsa.last_update_date >= cwop_xpc.customer_scope_start_date /* AND was created/last updated after the Customer Scope start Date */
                       )
                   )
           AND     cwop_hcasa.org_id                    = cwop_apsa.org_id                   /* Account Site Org to Payment Schedule Org Join                    */
           AND     cwop_hcasa.cust_account_id           = cwop_apsa.customer_id              /* Account Site to Account (Payment Schedule customer) Join         */
           AND     cwop_hcasa.status                    = 'A'                           /* Only Active Sites for the Account are included                   */
          )
    ,adjusted_trx_customers
     AS
          /* This query identifies Customers and Sites that have transactions   */
          /* which have had adjustments made within the migration scope period. */
          (
           /* SOLD-TO Customer and Site for Trxs with an Adjustment created on or after the Scope Date */
           SELECT  atc_rcta.org_id
                  ,atc_rcta.sold_to_customer_id                    AS customer_id
                  ,atc_hcsua.cust_acct_site_id
           FROM    xxmx_parameter_conversions                     atc_xpc
                  ,eligible_org_id_list                           atc_eoil
                  ,apps.ar_adjustments_all@MXDM_NVIS_EXTRACT      atc_aaa
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     atc_rcta
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   atc_hcsua
           WHERE   1 = 1
           AND     atc_aaa.org_id                   = atc_eoil.org_id
           AND     TRUNC(atc_aaa.last_update_date) >= atc_xpc.customer_scope_start_date
           AND     atc_rcta.org_id                  = atc_aaa.org_id
           AND     atc_rcta.customer_trx_id         = atc_aaa.customer_trx_id
           AND     atc_hcsua.site_use_id            = atc_rcta.sold_to_site_use_id
           UNION ALL
           /* SHIP-TO Customer and Site for Trxs with an Adjustment created on or after the Scope Date */
           SELECT  atc_rcta1.org_id
                  ,atc_rcta1.ship_to_customer_id                    AS customer_id
                  ,atc_hcsua1.cust_acct_site_id
           FROM    xxmx_parameter_conversions                     atc_xpc1
                  ,eligible_org_id_list                           atc_eoil1
                  ,apps.ar_adjustments_all@MXDM_NVIS_EXTRACT      atc_aaa1
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     atc_rcta1
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   atc_hcsua1
           WHERE   1 = 1
           AND     atc_aaa1.org_id                   = atc_eoil1.org_id
           AND     TRUNC(atc_aaa1.last_update_date) >= atc_xpc1.customer_scope_start_date
           AND     atc_rcta1.org_id                  = atc_aaa1.org_id
           AND     atc_rcta1.customer_trx_id         = atc_aaa1.customer_trx_id
           AND     atc_hcsua1.site_use_id            = atc_rcta1.ship_to_site_use_id
           UNION ALL
           /* BILL-TO Customer and Site for Trxs with an Adjustment created on or after the Scope Date */
           SELECT  atc_rcta2.org_id
                  ,atc_rcta2.bill_to_customer_id                    AS customer_id
                  ,atc_hcsua2.cust_acct_site_id
           FROM    xxmx_parameter_conversions                     atc_xpc2
                  ,eligible_org_id_list                           atc_eoil2
                  ,apps.ar_adjustments_all@MXDM_NVIS_EXTRACT      atc_aaa2
                  ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     atc_rcta2
                  ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   atc_hcsua2
           WHERE   1 = 1
           AND     atc_aaa2.org_id                   = atc_eoil2.org_id
           AND     TRUNC(atc_aaa2.last_update_date) >= atc_xpc2.customer_scope_start_date
           AND     atc_rcta2.org_id                  = atc_aaa2.org_id
           AND     atc_rcta2.customer_trx_id         = atc_aaa2.customer_trx_id
           AND     atc_hcsua2.site_use_id            = atc_rcta2.bill_to_site_use_id
          )
    ,customers_with_no_activity
     AS
          /* This query identifies Active Customers and Sites that have been recently  */
          /* created but which have had no activity (i.e. No AR Transactions created   */
          /* and no Payments made).  We do not have to do any checking for Adjustments */
          /* because if the Customer has no Transactions then Adjustments can not have */
          /* been created.                                                             */
          (
           SELECT  cwna_hcasa.org_id
                  ,cwna_hca.cust_account_id                            AS customer_id
                  ,cwna_hcasa.cust_acct_site_id
           FROM    xxmx_parameter_conversions                     cwna_xpc
                  ,eligible_org_id_list                           cwna_eoil
                  ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT        cwna_hca
                  ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT  cwna_hcasa
           WHERE   1 = 1
           AND     NVL(cwna_hca.status, 'I')           = 'A'
           AND     TRUNC(cwna_hca.last_update_date)   >= cwna_xpc.no_activity_threshold_date
           AND     cwna_hcasa.cust_account_id          = cwna_hca.cust_account_id
           AND     NVL(cwna_hcasa.status, 'I')         = 'A'
           AND     cwna_hcasa.org_id                   = cwna_eoil.org_id
           AND     TRUNC(cwna_hcasa.last_update_date) >= cwna_xpc.no_activity_threshold_date
           /* Customer is not on any AR Transactions */
           AND     NOT EXISTS (
                               SELECT  'X'
                               FROM    apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT     cwna_rcta
                               WHERE   1 = 1
                               AND     cwna_rcta.org_id                  = cwna_eoil.org_id
                               AND     (
                                           cwna_rcta.bill_to_customer_id = cwna_hca.cust_account_id
                                        OR cwna_rcta.ship_to_customer_id = cwna_hca.cust_account_id
                                        OR cwna_rcta.sold_to_customer_id = cwna_hca.cust_account_id
                                       )
                              )
           /* Customer has not made any payments */
           AND     NOT EXISTS (
                               SELECT  'X'
                               FROM    apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT      cwna_acra
                                      ,apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT  cwna_apsa
                               WHERE   1 = 1
                               AND     cwna_acra.org_id                     = cwna_eoil.org_id
                               AND     cwna_acra.type                       = 'CASH'                        
                               AND     cwna_apsa.org_id                     = cwna_acra.org_id                   
                               AND     cwna_apsa.cash_receipt_id            = cwna_acra.cash_receipt_id          
                               AND     cwna_apsa.class                      = 'PMT'                         
                               AND     (                                                               
                                           cwna_apsa.status                  = 'OP'                         
                                        OR (                                                           
                                                cwna_apsa.status            = 'CL'                          
                                            AND cwna_apsa.last_update_date >= cwna_xpc.customer_scope_start_date 
                                           )
                                       )
                               AND     cwna_apsa.customer_id                = cwna_hca.cust_account_id              
                              )
          )
    ,consolidated_customer_list
     AS
          /* This query UNIONS the results of the above queries to produce a  */
          /* compacted list of DISTINCT Customer ID and Customer Account IDs: */
          /*                                                                  */
          /* 1) incomplete_trx_custs_and_sites                                */
          /* 2) complete_trx_custs_and_sites                                  */
          /* 3) customers_with_open_payments                                  */
          /* 4) customers_created_or_updated                                  */
          /* 5) customers_with_no_activity                                    */
          (
           SELECT  itcas.org_id
                  ,itcas.customer_id
                  ,itcas.cust_acct_site_id
           FROM    incomplete_trx_custs_and_sites  itcas
           UNION
           SELECT  ctcas.org_id
                  ,ctcas.customer_id
                  ,ctcas.cust_acct_site_id
           FROM    complete_trx_custs_and_sites    ctcas
           UNION
           SELECT  cwop.org_id
                  ,cwop.customer_id
                  ,cwop.cust_acct_site_id
           FROM    customers_with_open_payments    cwop
           UNION
           SELECT  atc.org_id
                  ,atc.customer_id
                  ,atc.cust_acct_site_id
           FROM    adjusted_trx_customers          atc
           UNION
           SELECT  cwna.org_id
                  ,cwna.customer_id
                  ,cwna.cust_acct_site_id
           FROM    customers_with_no_activity      cwna
          )
SELECT  /*+ RULE */
        hcasa.org_id
       ,hca.cust_account_id
       ,hca.account_number
       ,hca.party_id              AS account_party_id
       ,hca.status                AS account_status
       ,hcasa.cust_acct_site_id
       ,hcasa.status              AS cust_acct_site_status
       ,hcasa.party_site_id
       ,hps.party_id              AS site_party_id
       ,hps.location_id
FROM    consolidated_customer_list                     ccl
       ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT        hca
       ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT  hcasa
       ,apps.hz_party_sites@MXDM_NVIS_EXTRACT          hps
WHERE   1 = 1
AND     hca.cust_account_id       = ccl.customer_id
AND     hcasa.org_id+0            = ccl.org_id
AND     hcasa.cust_account_id+0   = hca.cust_account_id
AND     hcasa.cust_acct_site_id+0 = ccl.cust_acct_site_id
AND     hps.party_site_id         = hcasa.party_site_id
AND     NOT EXISTS (
                    SELECT 1
                    FROM   xxmx_customer_exclusions xce
                    WHERE  1 = 1
                    AND    xce.cust_account_id = hca.cust_account_id
                   )
;
REM INSERTING into XXMX_CORE.XXMX_CUSTOMER_SCOPE_ISV_V
SET DEFINE OFF;
