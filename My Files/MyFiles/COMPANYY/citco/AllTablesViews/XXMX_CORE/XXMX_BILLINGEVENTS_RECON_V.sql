--------------------------------------------------------
--  DDL for View XXMX_BILLINGEVENTS_RECON_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_BILLINGEVENTS_RECON_V" ("PROJECT_NUMBER", "TASK_NUMBER", "BILLING", "REVENUE", "DEFERRED_INCOME_TRANS_STG", "DEFERRED_INCOME_TRANS", "ACCRUED_INCOME_TRANS_STG", "ACCRUED_INCOME_TRANS", "BILL_TRANS_CURRENCY_CODE", "DATA_SOURCE", "DEFERRED_INCOME_TRANS_DIFF", "ACCRUED_INCOME_TRANS_DIFF") AS 
  select c."PROJECT_NUMBER",c."TASK_NUMBER",c."BILLING",c."REVENUE",c."DEFERRED_INCOME_TRANS_STG",c."DEFERRED_INCOME_TRANS",c."ACCRUED_INCOME_TRANS_STG",c."ACCRUED_INCOME_TRANS",c."BILL_TRANS_CURRENCY_CODE",c."DATA_SOURCE",
        c. deferred_income_Trans_stg - deferred_income_trans deferred_income_trans_diff,
        c.accrued_income_Trans_stg -  accrued_income_Trans accrued_income_Trans_diff
 from (
  select  a.PROJECT_NUMBER
      ,a.TASK_NUMBER
      --,AMOUNT
      ,regexp_substr(a.AMOUNT,'[^~]+',1,1) billing
      ,regexp_substr(a.AMOUNT,'[^~]+',1,2) revenue
    --  ,b.BILLED_TO_DATE_TRANS pa0032_BILLED_TO_DATE_TRANS
    --  ,b.EARNED_TO_DATE_TRANS pa0032_EARNED_TO_DATE_TRANS  
, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2)  )
  else  0 
  end 
deferred_income_Trans_stg
,b.deferred_income_trans
, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1)  )
  else  0 
  end   accrued_income_Trans_stg
,b.accrued_income_trans
      ,bill_trans_currency_code
      ,'EXIST_IN_BOTH' data_source
from (
      select PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code, listagg(R_COST, '~') within group (order by project_number, task_number,BILL_OR_REV ) Amount 
        from XXMX_TRANSACTIONS_STG_RECON_V 
        group by PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code)
     a
    ,xxmx_pa0032_prod b
where 1                = 1  
 -- and b.project_number = '4090502' --and b.TASK_NUMBER<>'FADMIN'
  and a.PROJECT_NUMBER = b.PROJECT_NUMBER
  and a.TASK_NUMBER   = b.TASK_NUMBER
  and a.denom_currency_Code   = b.bill_trans_currency_code
union all
 select  a.PROJECT_NUMBER
      ,a.TASK_NUMBER
      --,AMOUNT
      ,regexp_substr(a.AMOUNT,'[^~]+',1,1) billing
      ,regexp_substr(a.AMOUNT,'[^~]+',1,2) revenue
    --  ,b.BILLED_TO_DATE_TRANS pa0032_BILLED_TO_DATE_TRANS
    --  ,b.EARNED_TO_DATE_TRANS pa0032_EARNED_TO_DATE_TRANS  
, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2)  )
  else  0 
  end 
deferred_income_Trans_stg
,0 deferred_income_trans
, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1)  )
  else  0 
  end   accrued_income_Trans_stg
,0 accrued_income_trans
,a.denom_currency_Code bill_trans_currency_code
 ,'XXMX_ONLY' data_source
from (
      select PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code, listagg(R_COST, '~') within group (order by project_number, task_number,BILL_OR_REV ) Amount 
        from XXMX_TRANSACTIONS_STG_RECON_V 
        group by PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code)
     a
   -- ,xxmx_pa0032_prod b
where 1                = 1 
and not exists ( select 1 from xxmx_pa0032_prod b  
  where a.PROJECT_NUMBER = b.PROJECT_NUMBER
  and a.TASK_NUMBER   = b.TASK_NUMBER
  and a.denom_currency_Code   = b.bill_trans_currency_code
    )
union all
 select  b.PROJECT_NUMBER
      ,b.TASK_NUMBER
      --,AMOUNT
      --,regexp_substr(a.AMOUNT,'[^~]+',1,1) 
      ,'0' billing
      --,regexp_substr(a.AMOUNT,'[^~]+',1,2)  
      , '0' revenue
    --  ,b.BILLED_TO_DATE_TRANS pa0032_BILLED_TO_DATE_TRANS
    --  ,b.EARNED_TO_DATE_TRANS pa0032_EARNED_TO_DATE_TRANS  
/*, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2)  )
  else  0 
  end */
,0 deferred_income_Trans_stg
,b.deferred_income_trans
/* case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1))   > 0 then ( regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1)  )
  else  0 
  end   */
  ,0 accrued_income_Trans_stg
,b.accrued_income_trans
,b.bill_trans_currency_code
 ,'PA0032_ONLY' data_source
from /*(
      select PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code, listagg(R_COST, '~') within group (order by project_number, task_number,BILL_OR_REV ) Amount 
        from XXMX_TRANSACTIONS_STG_RECON_V 
        group by PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code)
     a
    ,*/xxmx_pa0032_prod b
where 1                = 1 
and not exists ( select 1 from XXMX_TRANSACTIONS_STG_RECON_V a
  where a.PROJECT_NUMBER = b.PROJECT_NUMBER
  and a.TASK_NUMBER   = b.TASK_NUMBER
  and a.denom_currency_Code   = b.bill_trans_currency_code
    )
 -- and b.project_number = '4090502' --and b.TASK_NUMBER<>'FADMIN'
  --and a.PROJECT_NUMBER = b.PROJECT_NUMBER
  --and a.TASK_NUMBER   = b.TASK_NUMBER
  --and a.denom_currency_Code   = b.bill_trans_currency_code


 -- and a.project_number = '4058678'
 -- and a.task_number = 'FADMIN' 
 /* union all
  select  a.PROJECT_NUMBER
      ,a.TASK_NUMBER
      --,AMOUNT
      ,regexp_substr(a.AMOUNT,'[^~]+',1,1) billing
      ,regexp_substr(a.AMOUNT,'[^~]+',1,2) revenue
    --  ,b.BILLED_TO_DATE_TRANS pa0032_BILLED_TO_DATE_TRANS
    --  ,b.EARNED_TO_DATE_TRANS pa0032_EARNED_TO_DATE_TRANS     

, case 
  when ( regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2))   > 0 then  (regexp_substr(a.AMOUNT,'[^~]+',1,1) - regexp_substr(a.AMOUNT,'[^~]+',1,2)  )
  else  0 
  end 
deferred_income_Trans_stg
,b.deferred_income_trans
, case 
  when  (regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1))   > 0 then  (regexp_substr(a.AMOUNT,'[^~]+',1,2) - regexp_substr(a.AMOUNT,'[^~]+',1,1)  )
  else  0 
  end   accrued_income_Trans_stg
,b.accrued_income_trans
      ,bill_trans_currency_code
from (
      select PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code, listagg(R_COST, '~') within group (order by project_number, task_number,BILL_OR_REV ) Amount 
        from XXMX_TRANSACTIONS_STG_RECON_V 
        group by PROJECT_NUMBER, TASK_NUMBER,denom_currency_Code)
     a
    ,xxmx_pa0032_prod b
where 1                = 1  
 -- and b.project_number = '4090502' --and b.TASK_NUMBER<>'FADMIN'
  and a.PROJECT_NUMBER = b.PROJECT_NUMBER(+)
  and a.TASK_NUMBER   = b.TASK_NUMBER(+)
  and a.denom_currency_Code    = b.bill_trans_currency_code*/
  ) c
;
