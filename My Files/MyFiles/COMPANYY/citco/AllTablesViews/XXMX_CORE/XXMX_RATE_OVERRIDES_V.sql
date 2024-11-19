--------------------------------------------------------
--  DDL for View XXMX_RATE_OVERRIDES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_RATE_OVERRIDES_V" ("PROJECT_NUMBER", "PROJECT_STATUS", "PROJECT_TYPE", "PROJECT_DESCRIPTION", "TASK_PROJECT_NUMBER", "TASK_PROJECT_STATUS", "TASK_PROJECT_TYPE", "TASK_PROJECT_DESCRIPTION", "TASK_NAME", "TASK_NUMBER", "JOB_NAME", "RATE", "BILL_RATE_UNIT", "RATE_CURRENCY_CODE", "START_DATE_ACTIVE", "END_DATE_ACTIVE", "DISCOUNT_PERCENTAGE", "MARKUP_PERCENTAGE", "EXPENDITURE_TYPE", "NON_LABOR_RESOURCE", "OVERRIDE_TYPE", "PERSON_NUMBER") AS 
  SELECT 
        "PROJECT_NUMBER","PROJECT_STATUS","PROJECT_TYPE","PROJECT_DESCRIPTION","TASK_PROJECT_NUMBER","TASK_PROJECT_STATUS","TASK_PROJECT_TYPE","TASK_PROJECT_DESCRIPTION","TASK_NAME","TASK_NUMBER","JOB_NAME","RATE","BILL_RATE_UNIT","RATE_CURRENCY_CODE","START_DATE_ACTIVE","END_DATE_ACTIVE","DISCOUNT_PERCENTAGE","MARKUP_PERCENTAGE","EXPENDITURE_TYPE","NON_LABOR_RESOURCE","OVERRIDE_TYPE","PERSON_NUMBER"
   FROM (select 
(select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id = pjbro.project_id) project_number,
(select project_status_code
    from  pa_projects_all@xxmx_extract 
    where project_id = pjbro.project_id) project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = pjbro.project_id) project_type,
(select description
    from  pa_projects_all@xxmx_extract 
    where project_id = pjbro.project_id)  project_description,
(select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pjbro.task_id)) task_project_number,
(select project_status_code
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pjbro.task_id)) task_project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                         from  pa_tasks@xxmx_extract where task_id = pjbro.task_id)) task_project_type,
(select pa.description
    from  pa_projects_all@xxmx_extract pa
    where pa.project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pjbro.task_id))  task_project_description,
(select task_name from  pa_tasks@xxmx_extract where task_id = pjbro.task_id)  task_name,
(select task_number from  pa_tasks@xxmx_extract
x_extract where task_id = pjbro.task_id)  task_number,
(select distinct to_job_name from  PA_JOB_RELATIONSHIPS_V@xxmx_extract where to_job_id = pjbro.job_id)  job_name
,pjbro.rate
,NULL  BILL_RATE_UNIT
,pjbro.rate_currency_code
,pjbro.start_date_active
,pjbro.end_date_active
,pjbro.discount_percentage
,NULL markup_percentage
,NULL expenditure_type
,NULL  non_labor_resource
,'Job Override' override_type
,NULL person_number
from
 PA_JOB_BILL_RATE_OVERRIDES@xxmx_extract pjbro
union
select 
(select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id = pebro.project_id) project_number,
(select project_status_code
    from  pa_projects_all@xxmx_extract 
    where project_id = pebro.project_id) project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = pebro.project_id) project_type,
(select description
    from  pa_projects_all@xxmx_extract 
    where project_id = pebro.project_id)  project_description,
(select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pebro.task_id)) task_project_number,
(select project_status_code
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pebro.task_id)) task_project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                         from  pa_tasks@xxmx_extract where task_id = pebro.task_id)) task_project_type,
(select pa.description
    from  pa_projects_all@xxmx_extract pa
    where pa.project_id = ( select project_id 
                            from  pa_tasks@xxmx_extract where task_id = pebro.task_id))  task_project_description,
(select task_name from  pa_tasks@xxmx_extract where task_id = pebro.task_id)  task_name,
(select task_number from  pa_tasks@xxmx_extract where task_id = pebro.task_id)  task_number
,NULL job_code
,pebro.rate
,pebro.bill_rate_unit
,pebro.rate_currency_code
,pebro.start_date_active
,pebro.end_date_active
,pebro.discount_percentage
,NULL markup_percentage
,NULL expenditure_type
,NULL                                                                   non_labor_resource
,'Emp Override' override_type
,(select nvl(papf.employee_number, papf.npw_number) 
       from  per_all_people_f@xxmx_extract papf
           , per_jobs@xxmx_extract pj
		   , per_all_assignments_f@xxmx_extract paaf  
      where papf.person_id = pebro.person_id 
	    and pj.job_id      = paaf.job_id
	    and papf.person_id = paaf.person_id 
		and rownum         = 1 )                                        person_number
from
 PA_EMP_BILL_RATE_OVERRIDES@xxmx_extract pebro --39722  Rows
union
select 
(select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id = pnbro.project_id)  project_number,
(select project_status_code 
    from  pa_projects_all@xxmx_extract 
    where project_id = pnbro.project_id)  project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = pnbro.project_id) project_type,    
(select description 
    from  pa_projects_all@xxmx_extract 
    where project_id = pnbro.project_id)  project_description,
( select segment1 
    from  pa_projects_all@xxmx_extract 
    where project_id in 
        (select project_id 
            from  pa_tasks@xxmx_extract 
            where task_id = pnbro.task_id))"Task - Project Number",
( select project_status_code 
    from  pa_projects_all@xxmx_extract 
    where project_id in 
        (select project_id 
            from  pa_tasks@xxmx_extract 
            where task_id = pnbro.task_id)) task_project_status,
(select project_type
    from  pa_projects_all@xxmx_extract 
    where project_id = ( select project_id 
                         from  pa_tasks@xxmx_extract where task_id = pnbro.task_id)) task_project_type,            
( select description 
    from  pa_projects_all@xxmx_extract 
    where project_id in 
        (select project_id 
            from  pa_tasks@xxmx_extract 
            where task_id = pnbro.task_id))"Task - Project Description",
(select task_name
    from  pa_tasks@xxmx_extract
    where task_id = pnbro.task_id)  task_name,
(select task_number
    from  pa_tasks@xxmx_extract
    where task_id = pnbro.task_id)  task_number,
NULL  job_name    ,
pnbro.bill_rate rate,
NULL bill_rate_unit,
pnbro.rate_currency_code,
pnbro.start_date_active,
pnbro.end_date_active,
pnbro.discount_percentage,
pnbro.markup_percentage,
pnbro.expenditure_type,
pnbro.non_labor_resource,
'NonLabor Override' override_type
,NULL person_number
FROM  pa_nl_bill_rate_overrides@xxmx_extract pnbro) ovr
WHERE EXISTS(SELECT 1 FROM xxmx_ppm_projects_stg p
              WHERE p.project_number = nvl(ovr.project_number,ovr.task_project_number)
			  )
--AND EXISTS(SELECT 1 FROM xxmx_ppm_projects_stg stg
--              WHERE stg.project_number= ovr.project_number )                
  AND  to_date('30-NOV-2023','DD-MON-YYYY') BETWEEN TRUNC(nvl(ovr.start_date_active,sysdate-1))
                         AND TRUNC(nvl(ovr.end_date_active,sysdate+1))
;
