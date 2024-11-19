--------------------------------------------------------
--  DDL for View XXMX_PPM_AMT_BY_OU_CUR_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_AMT_BY_OU_CUR_V" ("SUM(AMT)", "EXP_BATCH_NAME", "BILL_TRNS_CURRENCY_CODE", "ORGANIZATION_NAME") AS 
  select "SUM(AMT)","EXP_BATCH_NAME","BILL_TRNS_CURRENCY_CODE","ORGANIZATION_NAME" from (
with e as (
 select sum(bill_trns_amount) amt , attribute10 exp_batch_name,BILL_TRNS_currency_code,organization_name 
 from XXMX_PPM_prj_BILLEVENT_xfm
 where 1=1
 --and attribute10 = 'OPEN_AR_6'
 --and BILL_TRNS_currency_code = 'USD'
 --and organization_name like 'VG7620' 
 group by  attribute10 ,BILL_TRNS_currency_code,organization_name
 ), lbc as (
select sum(b.denom_raw_cost) amt, b.exp_batch_name,b.denom_currency_code BILL_TRNS_currency_code,a.organization_name
from XXMX_PPM_projects_Stg a, XXMX_PPM_prj_lbrcost_xfm b
 where 1=1
 and a.project_number =  b.project_number
 --and b.exp_batch_name = 'OPEN_AR_6'
 --and a.organization_name = 'VG7620' 
 --and b.denom_currency_code = 'USD'
  group by  b.exp_batch_name ,b.denom_currency_code,a.organization_name
 )
 , msc as (
   select sum(b.denom_raw_cost) amt,  b.exp_batch_name,b.denom_currency_code BILL_TRNS_currency_code,a.organization_name 
   from XXMX_PPM_projects_Stg a, XXMX_PPM_prj_misccost_xfm b
 where 1=1
 and a.project_number =  b.project_number
 --and b.exp_batch_name = 'OPEN_AR_6'
 --and a.organization_name like 'VG7620' 
 --and b.denom_currency_code = 'USD'
 group by  b.exp_batch_name ,b.denom_currency_code,a.organization_name
 )
 select sum(amt), exp_batch_name,BILL_TRNS_currency_code,organization_name
 from (
 select nvl(e.amt,0) amt,        e.exp_batch_name,e.BILL_TRNS_currency_code,e.organization_name
 from e 
 union all
  select nvl(e.amt,0) ,
        e.exp_batch_name,e.BILL_TRNS_currency_code,e.organization_name
 from lbc e
 union all
   select nvl(e.amt,0),
        e.exp_batch_name,e.BILL_TRNS_currency_code,e.organization_name
 from msc e)
 group by exp_batch_name,BILL_TRNS_currency_code,organization_name
 )
;
