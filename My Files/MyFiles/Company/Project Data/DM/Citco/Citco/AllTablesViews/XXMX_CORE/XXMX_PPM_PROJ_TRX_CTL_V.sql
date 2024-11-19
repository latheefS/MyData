--------------------------------------------------------
--  DDL for View XXMX_PPM_PROJ_TRX_CTL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PROJ_TRX_CTL_V" ("PROJECT_ID", "START_DATE_ACTIVE", "CHARGEABLE_FLAG", "BILLABLE_INDICATOR", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_LOGIN", "TASK_ID", "PERSON_ID", "EXPENDITURE_CATEGORY", "EXPENDITURE_TYPE", "NON_LABOR_RESOURCE", "END_DATE_ACTIVE", "SCHEDULED_EXP_ONLY", "EMPLOYEES_ONLY_FLAG", "WORKPLAN_RES_ONLY_FLAG", "TASK_NUMBER", "TASK_NAME") AS 
  select ptc."PROJECT_ID",ptc."START_DATE_ACTIVE",ptc."CHARGEABLE_FLAG",ptc."BILLABLE_INDICATOR",ptc."CREATION_DATE",
  ptc."CREATED_BY",ptc."LAST_UPDATE_DATE",ptc."LAST_UPDATED_BY",ptc."LAST_UPDATE_LOGIN",ptc."TASK_ID",ptc."PERSON_ID",
  ptc."EXPENDITURE_CATEGORY",ptc."EXPENDITURE_TYPE",ptc."NON_LABOR_RESOURCE",ptc."END_DATE_ACTIVE",
  ptc."SCHEDULED_EXP_ONLY",ptc."EMPLOYEES_ONLY_FLAG",ptc."WORKPLAN_RES_ONLY_FLAG", pt.task_number, REGEXP_REPLACE(pt.task_name, '[^[:print:]]','') task_name
  FROM  
                    apps.pa_transaction_controls@xxmx_extract    ptc
				  , apps.pa_tasks@xxmx_extract                   pt
                WHERE  ptc.project_id                              = pt.project_id
                AND ptc.task_id                                 = pt.task_id
                AND to_date('30-JUN-2022','DD-MON-YYYY')  BETWEEN TRUNC(nvl(ptc.start_date_active,sysdate-1)) 
                      AND TRUNC(nvl(ptc.end_date_active,sysdate+1))
  union all
  select ptc."PROJECT_ID",ptc."START_DATE_ACTIVE",ptc."CHARGEABLE_FLAG",ptc."BILLABLE_INDICATOR",ptc."CREATION_DATE",ptc."CREATED_BY",ptc."LAST_UPDATE_DATE",ptc."LAST_UPDATED_BY",ptc."LAST_UPDATE_LOGIN",ptc."TASK_ID",ptc."PERSON_ID",ptc."EXPENDITURE_CATEGORY",ptc."EXPENDITURE_TYPE",ptc."NON_LABOR_RESOURCE",ptc."END_DATE_ACTIVE",ptc."SCHEDULED_EXP_ONLY",ptc."EMPLOYEES_ONLY_FLAG",ptc."WORKPLAN_RES_ONLY_FLAG", null, null
  FROM  
                    apps.pa_transaction_controls@xxmx_extract     ptc
                WHERE  ptc.task_id                   IS NULL
                AND to_date('30-JUN-2022','DD-MON-YYYY')  BETWEEN TRUNC(nvl(ptc.start_date_active,sysdate-1)) 
                                                              AND TRUNC(nvl(ptc.end_date_active,sysdate+1))
;
