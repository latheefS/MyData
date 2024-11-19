
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_AR_CASH_RECEIPTS_SCOPE_V" ("ORG_ID", "OPERATING_UNIT_NAME", "CASH_RECEIPT_ID", "RECEIPT_NUMBER", "CUSTOMER_ID", "STATUS1", "STATUS2", "DISPLAY", "EXCHANGE_RATE", "EXCHANGE_RATE_TYPE", "MIGRATED_RECEIPT_TYPE", "RECEIPT_AMOUNT_ORIGINAL", "RECEIPT_AMOUNT_APPLIED", "RECEIPT_AMOUNT_REMAINING") AS 
  WITH
-- ================================================================================
-- | VERSION1 |
-- ================================================================================
--
-- FILENAME
-- xxmx_ar_cash_receipts_scope_v.sql
--
-- DESCRIPTION
-- Create the custmer scope view
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ----------------------------
-- 29/06/2022 Michal Arrowsmith initial version
-- 13/07/2022 Michal Arrowsmith add original receipt amount
-- 22/12/2022 Michal Arrowsmith change the condition
--                              AND NVL(xsou.migration_enabled_flag, 'N') = 'Y'
--                              to
--                              AND NVL(xsou.cust_migration_enabled_flag, 'N') = 'Y'
-- 28/02/2024 Milind Shanbhag   Added APPLIED receipts
-- =============================================================================*/
     eligible_org_id_list
     AS
          (
           SELECT  DISTINCT
                   haou.organization_id                                AS org_id
                  ,haou.name                                           AS operating_unit_name
           FROM    hr_all_organization_units@XXMX_EXTRACT    haou
                  ,hr_organization_information@XXMX_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'OPERATING_UNIT'
           AND     haou.name            IN (
                                            SELECT xsou.source_operating_unit_name
                                            FROM    xxmx_source_operating_units  xsou
                                            WHERE  1 = 1
                                            AND    NVL(xsou.cust_migration_enabled_flag, 'N') = 'Y'
                                           )
          )
--FULLY APPLIED
SELECT  
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer                          as customer_id
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,arcra.exchange_rate
    ,arcra.exchange_rate_type
    ,'Fully Applied'                                  as migrated_receipt_type
    ,min(arcra.amount)                                as receipt_amount_original
    ,sum(arraa.amount_applied)                        as receipt_amount_applied
    ,min(arcra.amount)-sum(arraa.amount_applied)      as receipt_amount_remaining
FROM 
    eligible_org_id_list                                   eoil,
    ar.ar_cash_receipts_all@XXMX_EXTRACT                 arcra,
    ar.ar_receivable_applications_all@XXMX_EXTRACT       arraa
                ,ra_customer_trx_all@XXMX_EXTRACT               racta
WHERE    1 = 1
AND      arcra.org_id                    = eoil.org_id
AND      arraa.cash_receipt_id           = arcra.cash_receipt_id
and   arraa.applied_customer_trx_id   = racta.customer_trx_id
and racta.trx_number in (select p.invoice_number from xxmx_ppm_migrated_open_receipts p)
--and  arcra.receipt_number = 'CUW23305FJLF0FHF'
and  arraa.display = 'Y'
and      arcra.status='APP' and arraa.status='APP' 
group by
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,arcra.exchange_rate
    ,arcra.exchange_rate_type
    ,racta.trx_number
having round(sum(arraa.amount_applied * nvl(arraa.trans_to_receipt_rate,1)),2) = min(arcra.amount)
UNION
--APPLIED
SELECT  
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer                          as customer_id
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,arcra.exchange_rate
    ,arcra.exchange_rate_type
    ,decode(min(arcra.amount)-sum(arraa.amount_applied),
        0,'Fully Applied',
        'Partially Applied')                           as migrated_receipt_type
    ,min(arcra.amount)                                as receipt_amount_original
    ,sum(arraa.amount_applied)                        as receipt_amount_applied
    ,min(arcra.amount)-sum(arraa.amount_applied)      as receipt_amount_remaining
FROM 
    eligible_org_id_list                                   eoil,
    ar.ar_cash_receipts_all@XXMX_EXTRACT                 arcra,
    ar.ar_receivable_applications_all@XXMX_EXTRACT       arraa
                ,ra_customer_trx_all@XXMX_EXTRACT               racta
WHERE    1 = 1
AND      arcra.org_id                    = eoil.org_id
AND      arraa.cash_receipt_id           = arcra.cash_receipt_id
and   arraa.applied_customer_trx_id   = racta.customer_trx_id
and racta.trx_number in (select p.invoice_number from xxmx_ppm_migrated_open_receipts p)
--and  arcra.receipt_number = 'CUW23305FJLF0FHF'
and  arraa.display = 'Y'
and      arcra.status='APP' and arraa.status='APP' 
group by
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,arcra.exchange_rate
    ,arcra.exchange_rate_type
    ,racta.trx_number
--having min(arcra.amount)-sum(arraa.amount_applied)=0
having sum(arraa.amount_applied)!=0
UNION
-- UNAPPLIED
SELECT  
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer                          as customer_id
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,exchange_rate
    ,exchange_rate_type
    ,decode(min(arcra.amount)-sum(arraa.amount_applied),
        0,'Unapplied',
        'Partially Applied')                            as migrated_receipt_type
    ,min(arcra.amount)                                as receipt_amount_original
    ,sum(arraa.amount_applied)                        as receipt_amount_applied
    ,min(arcra.amount)-sum(arraa.amount_applied)      as receipt_amount_remaining
FROM 
    eligible_org_id_list                                   eoil,
    ar.ar_cash_receipts_all@XXMX_EXTRACT                 arcra,
    ar.ar_receivable_applications_all@XXMX_EXTRACT       arraa
WHERE    1 = 1
AND      arcra.org_id                    = eoil.org_id
AND      arraa.cash_receipt_id           = arcra.cash_receipt_id
and      arcra.status='UNAPP' and arraa.status='UNAPP' 
group by
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,exchange_rate
    ,exchange_rate_type
having sum(arraa.amount_applied)>0
union
-- ON-ACCOUNT
SELECT  
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer                                      as customer_id
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,exchange_rate
    ,exchange_rate_type
    ,'On-Account'                                     as migrated_receipt_type
    ,min(arcra.amount)                                as receipt_amount_original
    ,sum(arraa.amount_applied)                        as receipt_amount_applied
    ,min(arcra.amount)-sum(arraa.amount_applied)      as receipt_amount_remaining
FROM 
    eligible_org_id_list                                   eoil,
    ar.ar_cash_receipts_all@XXMX_EXTRACT                 arcra,
    ar.ar_receivable_applications_all@XXMX_EXTRACT       arraa
WHERE    1 = 1
AND      arcra.org_id                    = eoil.org_id
AND      arraa.cash_receipt_id = arcra.cash_receipt_id
and      arcra.status='APP'   and arraa.status='ACC'
group by
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer
    ,arcra.status
    ,arraa.status
    ,arraa.display
    ,exchange_rate
    ,exchange_rate_type
having sum(arraa.amount_applied)>0
union
-- UN-IDENTIFIED
SELECT  
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer                                      as customer_id
    ,arcra.status
    ,null
    ,null
    ,exchange_rate
    ,exchange_rate_type
    ,'Unidentified'                                   as migrated_receipt_type
    ,min(arcra.amount)                                as receipt_amount_original
    ,0                                                as receipt_amount_applied
    ,min(arcra.amount)                                as receipt_amount_remaining
FROM 
    eligible_org_id_list                                   eoil,
    ar_cash_receipts_all@XXMX_EXTRACT                 arcra
WHERE    1 = 1
AND      arcra.org_id                    = eoil.org_id
and      arcra.status='UNID' 
group by
     eoil.org_id
    ,eoil.operating_unit_name
    ,arcra.cash_receipt_id
    ,arcra.receipt_number
    ,arcra.pay_from_customer
    ,arcra.status
    ,null
    ,null
    ,exchange_rate
    ,exchange_rate_type
having sum(arcra.amount)>0;


  GRANT SELECT ON "XXMX_CORE"."XXMX_AR_CASH_RECEIPTS_SCOPE_V" TO "XXMX_READONLY";
