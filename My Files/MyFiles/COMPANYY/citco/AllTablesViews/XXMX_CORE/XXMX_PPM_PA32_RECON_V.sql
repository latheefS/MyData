--------------------------------------------------------
--  DDL for View XXMX_PPM_PA32_RECON_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PA32_RECON_V" ("PROJECT_NUMBER", "TASK_NUMBER", "BILL_TRANS_CURRENCY_CODE", "DEFERRED_INCOME", "ACCRUED_INCOME") AS 
  select a."PROJECT_NUMBER",a."TASK_NUMBER",a."BILL_TRANS_CURRENCY_CODE",a."DEFERRED_INCOME",a."ACCRUED_INCOME" from XXMX_PPM_AI_DI_V a, xxmx_pa0032_prod b
where a.project_number =  b.project_number
and a.task_number = b.task_number
and abs(a.deferred_income - b.deferred_income_trans) < 1
and abs(a.accrued_income - b.accrued_income_trans) < 1
;
