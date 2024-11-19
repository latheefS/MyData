--------------------------------------------------------
--  DDL for View XXMX_TRANSACTIONS_XFM_RECON_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_TRANSACTIONS_XFM_RECON_V" ("R_COST", "PROJECT_NUMBER", "TASK_NUMBER", "DENOM_CURRENCY_CODE", "BILL_OR_REV") AS 
  select r_cost,project_number,task_number,denom_currency_code,bill_or_rev from (
with inv_cost as (
select sum(r_cost) r_cost, project_number, task_number,denom_currency_code,bill_or_rev
from (
select sum(denom_raw_cost) r_cost, project_number, task_number, denom_currency_code,'BILLING' bill_or_rev  
from xxmx_ppm_prj_lbrcost_xfm
--where attribute3 is not null
group by project_number, task_number,denom_currency_code
UNION
select sum(denom_raw_cost) r_cost, project_number, task_number, denom_currency_code,'REVENUE'  
from xxmx_ppm_prj_lbrcost_xfm
--where attribute3 is not null
group by project_number, task_number,denom_currency_code
union
select sum(denom_raw_cost), project_number, task_number, denom_currency_code,'BILLING'
from xxmx_ppm_prj_misccost_xfm
--where attribute3 is not null
group by project_number, task_number,denom_currency_code
union
select sum(denom_raw_cost), project_number, task_number, denom_currency_code,'REVENUE' 
from xxmx_ppm_prj_misccost_xfm
--where attribute3 is not null
group by project_number, task_number,denom_currency_code
union
select sum(bill_trns_amount), project_number, task_number,bill_Trns_currency_code,'BILLING'  
from xxmx_ppm_prj_billevent_xfm
--where attribute6 is not null
where attribute10 = 'BILLING'
group by project_number, task_number,bill_Trns_currency_code
union
select sum(bill_trns_amount), project_number, task_number,bill_Trns_currency_code,'REVENUE'  
from xxmx_ppm_prj_billevent_xfm
--where attribute6 is not null
where attribute10 = 'REVENUE'
group by project_number, task_number,bill_Trns_currency_code
)
group by project_number, task_number,denom_currency_code,bill_or_rev
)
select * from inv_cost
where 1=1
--project_number = '4090502'
)
;
