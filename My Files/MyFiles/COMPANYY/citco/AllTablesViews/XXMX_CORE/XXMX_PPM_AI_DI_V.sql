--------------------------------------------------------
--  DDL for View XXMX_PPM_AI_DI_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_AI_DI_V" ("PROJECT_NUMBER", "TASK_NUMBER", "BILL_TRANS_CURRENCY_CODE", "DEFERRED_INCOME", "ACCRUED_INCOME") AS 
  select project_number, task_number, bill_trans_currency_code, abs(deferred_income) deferred_income
, abs(accrued_income) accrued_income
from (
select project_number, task_number, bill_trans_currency_code, nvl(sum(bill_trans_raw_revenue),0) amount,  'accrued_income' rec_type
from (
select project_number, task_number,bill_trans_currency_code, bill_trans_raw_revenue from XXMX_PPM_prj_LBRCOST_recon where cost_type  ='UNBILLED'
union 
select project_number, task_number,bill_trans_currency_code, bill_trans_raw_revenue from XXMX_PPM_prj_miscCOST_recon where cost_type  ='UNBILLED'
union
select project_number, task_number,bill_trns_currency_code, bill_trns_amount  from XXMX_PPM_prj_billevent_recon where attribute10  ='REVENUE'
and attribute7 in ('REVACC','UNBILLED')
) 
--where project_number = '4048807'
group by project_number, task_number, bill_trans_currency_code
union
select project_number, task_number,bill_trns_currency_code,nvl(bill,0)-nvl(rev,0),
case 
when nvl(bill,0)-nvl(rev,0) < 0 then 'accrued_income' else 'deferred_income' 
end 
from (
select project_number, task_number,bill_trns_currency_code, bill_trns_amount, attribute10  from XXMX_PPM_prj_billevent_recon where attribute7  in ('OPEN_AR','CLOSED_AR')
--and project_number = '4048807'
) 
pivot(sum(bill_trns_amount) for attribute10 in ('BILLING' as bill,'REVENUE' as rev))
)
pivot(sum(nvl(amount,0)) for rec_type in ('deferred_income' as deferred_income,'accrued_income' as accrued_income))
;
