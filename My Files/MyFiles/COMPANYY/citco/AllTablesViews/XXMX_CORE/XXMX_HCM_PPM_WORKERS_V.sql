--------------------------------------------------------
--  DDL for View XXMX_HCM_PPM_WORKERS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_PPM_WORKERS_V" ("INCURRED_BY_PERSON_ID", "MIN_EX_DATE", "MAX_EX_DATE", "WORKER_TYPE") AS 
  select   incurred_by_person_id, min ( expenditure_item_date) min_ex_date, max(expenditure_item_date) max_ex_date, 'LEAVER' worker_type
from xxmx_pa_expenditure_items_all a, xxmx_pa_expenditures_all b
,(select period_of_service_id,person_id,actual_termination_date from per_periods_of_service@xxmx_extract c 
   where period_of_service_id = (select max(period_of_service_id) from per_periods_of_service@xxmx_extract
                                  where person_id = c.person_id)
   ) c
where a.expenditure_type = 'Labor'
and a.expenditure_id =  b.expenditure_id
and c.person_id =  b.incurred_by_person_id 
and c.actual_termination_date is not null
group by incurred_by_person_id
union
select   incurred_by_person_id, min ( expenditure_item_date), max(expenditure_item_date), 'ACTIVE'
from xxmx_pa_expenditure_items_all a, xxmx_pa_expenditures_all  b
,(select period_of_service_id,person_id,actual_termination_date from per_periods_of_service@xxmx_extract c 
   where period_of_service_id = (select max(period_of_service_id) from per_periods_of_service@xxmx_extract
                                  where person_id = c.person_id)
   ) c
where a.expenditure_type = 'Labor'
and a.expenditure_id =  b.expenditure_id
and c.person_id =  b.incurred_by_person_id 
and c.actual_termination_date is null
group by incurred_by_person_id
;
