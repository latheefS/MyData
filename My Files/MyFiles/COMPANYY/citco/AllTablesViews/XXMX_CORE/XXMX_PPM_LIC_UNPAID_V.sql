--------------------------------------------------------
--  DDL for View XXMX_PPM_LIC_UNPAID_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_LIC_UNPAID_V" ("INVOICE_ID", "INVOICE_NUM", "AR_INVOICE_NUMBER", "AR_INVOICE_DATE", "COST_TYPE", "EXPENDITURE_ITEM_ID", "SYSTEM_REFERENCE2", "SYSTEM_REFERENCE3") AS 
  select distinct INVOICE_ID,INVOICE_NUM, AR_INVOICE_NUMBER, AR_INVOICE_DATE, COST_TYPE, expenditure_item_id , system_reference2, system_reference3 from (
  with pcd as (
select pei.*, pcd.system_reference2, pcd.system_reference3
   from pa_cost_distribution_lines_all@xxmx_extract  pcd
    ,xxmx_ppm_closedar_exp_items pei
where pcd.expenditure_item_id =  pei.expenditure_item_id
and pcd.system_reference2 is not null
),
  pcd_open as (
select pei.*, pcd.system_reference2, pcd.system_reference3
   from pa_cost_distribution_lines_all@xxmx_extract  pcd
    ,xxmx_ppm_openar_exp_items pei
where pcd.expenditure_item_id =  pei.expenditure_item_id
and pcd.system_reference2 is not null
)
select lic.*, pcd.ar_invoice_number, pcd.invoice_date  AR_INVOICE_DATE, 'CLOSED_AR' cost_type       , pcd.expenditure_item_id, pcd.system_reference2, pcd.system_reference3
from XXMX_PPM_LICFEE_UNPAID_INV lic
    ,apps.ap_invoices_all@xxmx_extract a
    ,pcd
    ,pa_expenditure_items_all@xxmx_extract b
    --,ap_invoice_distributions_all@xxmx_extract invd
where lic.invoice_id =  a.invoice_id
and pcd.system_reference2 =  a.invoice_id
and b.expenditure_item_id = pcd.expenditure_item_id
union all
select lic.*, pcd_open.ar_invoice_number,  pcd_open.invoice_date  AR_INVOICE_DATE, 'OPEN_AR' cost_type , pcd_open.expenditure_item_id, pcd_open.system_reference2, pcd_open.system_reference3
from XXMX_PPM_LICFEE_UNPAID_INV lic
    ,apps.ap_invoices_all@xxmx_extract a
    ,pcd_open
    ,pa_expenditure_items_all@xxmx_extract b
    --,ap_invoice_distributions_all@xxmx_extract invd
where lic.invoice_id =  a.invoice_id
and pcd_open.system_reference2 =  a.invoice_id
and b.expenditure_item_id = pcd_open.expenditure_item_id
)
;
