--------------------------------------------------------
--  DDL for View XXMX_LICENSE_FEE_APINV_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" ("PROJECT_NUMBER", "TASK_NUMBER", "EXPENDITURE_ITEM_DATE", "VENDOR_NAME", "VENDOR_SITE_CODE", "INVOICE_NUMBER", "INVOICE_DATE", "INVOICE_CURRENCY_CODE", "INVOICE_AMOUNT", "AMOUNT_PAID", "PAYMENT_STATUS_FLAG") AS 
  with inv as (
select  ei.project_number,ei.task_number,system_reference2 invoice_id, expenditure_item_date from xxmx_pa_expenditure_items_all ei
, xxmx_pa_cost_distribution_lines_all pcd
where 
ei.expenditure_type like 'Lic%'
and  ei.expenditure_item_id =  pcd.expenditure_item_id
)
SELECT distinct  
    inv.project_number,
    inv.task_number,
    inv.expenditure_item_date,
    b.vendor_name vendor_name,
       c.vendor_site_code,
       a.invoice_num invoice_number,
       a.invoice_date,
       a.invoice_currency_code,
       a.invoice_amount,
       a.amount_paid,
       a.payment_status_flag  -- --'Y' -- Fully Paid, 'P' -- Partially Paid , 'N'-- Not Paid             
  FROM apps.ap_invoices_all@xxmx_extract a,
       apps.ap_suppliers@xxmx_extract b,
       apps.ap_supplier_sites_all@xxmx_extract c,
       --apps.ap_payment_schedules_all@xxmx_extract d,
       --apps.ap_invoice_payments_all@xxmx_extract ap,
      -- ap_checks_all@xxmx_extract ac,
      -- Ap_Invoices_all@xxmx_extract al,
       --ap_checks_all@xxmx_extract asd,
       inv
WHERE     a.vendor_id = b.vendor_id
       AND a.vendor_site_id = c.vendor_site_id
       AND b.vendor_id = c.vendor_id
       --AND a.invoice_id = d.invoice_id
      -- AND ap.invoice_id = a.invoice_id
     --  AND ac.CHECK_ID = ap.CHECK_ID
       --and ac.check_id=asd.check_id
       --and ap.check_id=asd.check_id
       --and a.invoice_id=al.invoice_id
       --and d.invoice_id=al.invoice_id
       and a.invoice_id =  inv.invoice_id
;
  GRANT DELETE ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT INSERT ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT UPDATE ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT REFERENCES ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT READ ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT ON COMMIT REFRESH ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT QUERY REWRITE ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT DEBUG ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
  GRANT MERGE VIEW ON "XXMX_CORE"."XXMX_LICENSE_FEE_APINV_V" TO "XXMX_READONLY";
