--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2021 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_ar_trx_scope_v.sql
--**
--** FILEPATH  :  ????
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the Scope View for the Maximise AR Transactions
--**              Data Migration.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    None
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-FEB-2021  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  24-FEB-2021  Ian S. Vickerstaff  Additional columns added.
--**
--**   1.2  09-MAR-2021  Ian S. Vickerstaff  WHERE clause modifications.
--**
--**   1.3  27-APR-2021  Ian S. Vickerstaff  WHERE clause modifications.
--**
--**   1.4  10-MAY-2021  Ian S. Vickerstaff  View restructured to include Payment
--**                                         Schedule details.
--**
--**   1.5  12-MAY-2021  Ian S. Vickerstaff  Additional columns added to Payment
--**                                         Schedule Details.
--**
--**   1.6  23-JUN-2021  Ian S. Vickerstaff  Changes to Payment Schedule Details
--**                                         WHERE clause.
--**
--**   1.7  08-JUL-2021  Ian S. Vickerstaff  Change to join to Temporary Customer
--**                                         Stg table.
--**
--**   1.8  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT *****************
PROMPT ** Creating Views
PROMPT *****************
--
--
PROMPT
PROMPT Creating View xxmx_ar_trx_scope_v
PROMPT
--
/*
*****************************
** VIEW : xxmx_ar_trx_scope_v
*****************************
*/
--

  CREATE OR REPLACE FORCE  VIEW "XXMX_AR_TRX_SCOPE_V" ("ORG_ID", "CUSTOMER_TRX_ID", "TRX_NUMBER", "TRX_TYPE", "SEEDED_TRX_TYPE_NAME", "TRX_TYPE_NAME", "OPEN_RECEIVABLES_FLAG", "AMOUNT_DUE_ORIGINAL", "AMOUNT_DUE_REMAINING", "AMOUNT_LINE_ITEMS_ORIGINAL", "AMOUNT_LINE_ITEMS_REMAINING", "FREIGHT_ORIGINAL", "FREIGHT_REMAINING", "TAX_ORIGINAL", "TAX_REMAINING", "AMOUNT_DUE_ORIG_EXCL_TAX", "AMOUNT_DUE_REM_EXCL_TAX", "AMOUNT_PAID", "PARTIALLY_PAID_FLAG") AS 
  WITH
     eligible_org_id_list
     AS
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
                                            FROM    xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.migration_enabled_flag, 'N') = 'Y'
                                           )
          )
    ,payment_schedule_details
     AS
          (
           SELECT    apsa.org_id
                    ,apsa.customer_trx_id
                    ,apsa.class
                    ,SUM(NVL(apsa.amount_due_original,0))          AS amount_due_original
                    ,SUM(NVL(apsa.amount_due_remaining,0))         AS amount_due_remaining
                    ,SUM(NVL(apsa.amount_line_items_original,0))   AS amount_line_items_original
                    ,SUM(NVL(apsa.amount_line_items_remaining,0))  AS amount_line_items_remaining
                    ,SUM(NVL(apsa.freight_original,0))             AS freight_original
                    ,SUM(NVL(apsa.freight_remaining,0))            AS freight_remaining
                    ,SUM(NVL(apsa.tax_original,0))                 AS tax_original
                    ,SUM(NVL(apsa.tax_remaining,0))                AS tax_remaining
                    ,(
                        SUM(NVL(apsa.amount_due_original,0))
                      - SUM(NVL(apsa.tax_original,0))
                     )                                             AS amount_due_orig_excl_tax
                    ,(
                        SUM(NVL(apsa.amount_due_remaining,0))
                      - SUM(NVL(apsa.tax_remaining,0))
                     )                                             AS amount_due_rem_excl_tax
                    ,(
                        SUM(NVL(apsa.amount_due_original,0))
                      - SUM(NVL(apsa.amount_due_remaining,0))
                     )                                             AS amount_paid
                    ,CASE
                          WHEN SUM(NVL(apsa.amount_due_original,0)) <> SUM(NVL(apsa.amount_due_remaining,0))
                          THEN 'Y'
                          ELSE 'N'
                     END                                      AS partially_paid_flag                        
           FROM      apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT  apsa
           WHERE     1 = 1
           AND       EXISTS (
                             SELECT  'X'
                             FROM    apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT  apsa2
                             WHERE   1 = 1
                             AND     apsa2.customer_trx_id       = apsa.customer_trx_id
                             AND     apsa2.status                = 'OP'
                             AND     apsa2.amount_due_remaining <> 0
                            )
           GROUP BY  apsa.org_id
                    ,apsa.customer_trx_id
                    ,apsa.class
          )
     SELECT   eoil.org_id
             ,rcta.customer_trx_id
             ,rcta.trx_number
             ,rctta.type                               AS trx_type
             ,flv.meaning                              AS seeded_trx_type_name
             ,rctta.name                               AS trx_type_name
             ,rctta.accounting_affect_flag             AS open_receivables_flag
             ,psd.amount_due_original                  AS amount_due_original
             ,psd.amount_due_remaining                 AS amount_due_remaining
             ,psd.amount_line_items_original           AS amount_line_items_original 
             ,psd.amount_line_items_remaining          AS amount_line_items_remaining
             ,psd.freight_original                     AS freight_original           
             ,psd.freight_remaining                    AS freight_remaining          
             ,psd.tax_original                         AS tax_original
             ,psd.tax_remaining                        AS trx_tax_remaining
             ,psd.amount_due_orig_excl_tax             AS amount_due_orig_excl_tax
             ,psd.amount_due_rem_excl_tax              AS amount_due_rem_excl_tax
             ,psd.amount_paid                          AS amount_paid
             ,psd.partially_paid_flag                  AS partially_paid_flag
     FROM     eligible_org_id_list                     eoil
             ,ra_customer_trx_all@MXDM_NVIS_EXTRACT    rcta
             ,fnd_application_tl@MXDM_NVIS_EXTRACT     fat
             ,fnd_lookup_values@MXDM_NVIS_EXTRACT      flv
             ,ra_cust_trx_types_all@MXDM_NVIS_EXTRACT  rctta
             ,payment_schedule_details                 psd
     WHERE    1 = 1
     AND      rcta.org_id               = eoil.org_id
     AND      rcta.complete_flag        = 'Y'
     AND      rctta.org_id              = rcta.org_id
     AND      rctta.cust_trx_type_id    = rcta.cust_trx_type_id
     AND      fat.application_name      = 'Receivables'
     AND      flv.view_application_id   = fat.application_id
     AND      flv.lookup_type           = 'INV/CM'
     AND      flv.lookup_code           = rctta.type
     AND      psd.org_id                = rcta.org_id
     AND      psd.customer_trx_id       = rcta.customer_trx_id
     AND      psd.class                 = rctta.type
     AND      EXISTS (
                      SELECT 'X'
                      FROM    xxmx_customer_scope_temp_stg  xcsts
                      WHERE  1 = 1
                      AND    xcsts.cust_account_id = rcta.bill_to_customer_id
                     );
/