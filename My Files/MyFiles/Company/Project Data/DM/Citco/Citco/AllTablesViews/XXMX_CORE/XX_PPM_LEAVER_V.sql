--------------------------------------------------------
--  DDL for View XX_PPM_LEAVER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XX_PPM_LEAVER_V" ("PERSON_ID", "EX_DATE", "WORKER_TYPE") AS 
  select B.incurred_by_person_id PERSON_ID,TO_CHAR(A.expenditure_item_date,'DD-MON-RRRR') EX_DATE,'LEAVER' WORKER_TYPE
from xxmx_pa_expenditure_items_all a, pa_expenditures_all@xxmx_extract  b
where a.expenditure_id =  b.expenditure_id
and a.expenditure_type = 'Labor'
and a.billable_flag = 'Y'
AND a.expenditure_item_id <>  nvl(a.attribute1,-1)
AND a.bill_amount             <> 0
and exists (select 1 from per_periods_of_service@xxmx_extract c where c.person_id =  b.incurred_by_person_id and actual_termination_date is not null)
;
