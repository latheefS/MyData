--------------------------------------------------------
--  DDL for View XXMX_TRANSACTIONS_STG_RECON_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_TRANSACTIONS_STG_RECON_V" ("R_COST", "PROJECT_NUMBER", "TASK_NUMBER", "DENOM_CURRENCY_CODE", "BILL_OR_REV") AS 
  select "R_COST","PROJECT_NUMBER","TASK_NUMBER","DENOM_CURRENCY_CODE","BILL_OR_REV" from (
with inv_cost as (
select sum(r_cost) r_cost, project_number, task_number,DENOM_CURrency_code,bill_or_rev
from (
select sum(denom_raw_cost) r_cost, project_number, task_number, DENOM_CURrency_code,'BILLING' bill_or_rev  from XXMX_PPM_prj_LBRCOST_stg
--where attribute3 is not null
group by project_number, task_number,DENOM_CURrency_code
UNION
select sum(denom_raw_cost) r_cost, project_number, task_number, DENOM_CURrency_code,'REVENUE'  from XXMX_PPM_prj_LBRCOST_stg
--where attribute3 is not null
group by project_number, task_number,DENOM_CURrency_code
union
select sum(denom_raw_cost), project_number, task_number, DENOM_CURrency_code,'BILLING' from XXMX_PPM_prj_miscCOST_stg
--where attribute3 is not null
group by project_number, task_number,DENOM_CURrency_code
union
select sum(denom_raw_cost), project_number, task_number, DENOM_CURrency_code,'REVENUE' from XXMX_PPM_prj_miscCOST_stg
--where attribute3 is not null
group by project_number, task_number,DENOM_CURrency_code
union
select sum(bill_trns_amount), project_number, task_number,bill_Trns_currency_code,'BILLING'  from XXMX_PPM_prj_BILLEVENT_stg
--where attribute6 is not null
where attribute10 = 'BILLING'
group by project_number, task_number,bill_Trns_currency_code
union
select sum(bill_trns_amount), project_number, task_number,bill_Trns_currency_code,'REVENUE'  from XXMX_PPM_prj_BILLEVENT_stg
--where attribute6 is not null
where attribute10 = 'REVENUE'
group by project_number, task_number,bill_Trns_currency_code
)
group by project_number, task_number,DENOM_CURrency_code,bill_or_rev
)
select * from inv_cost
where 1=1
--project_number = '4090502'
)
;
