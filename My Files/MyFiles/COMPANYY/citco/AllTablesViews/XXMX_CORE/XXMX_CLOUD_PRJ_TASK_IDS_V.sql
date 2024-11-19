--------------------------------------------------------
--  DDL for View XXMX_CLOUD_PRJ_TASK_IDS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CLOUD_PRJ_TASK_IDS_V" ("PROJECT_NUMBER", "PROJECT_TASK_NUMBER", "CREATE_UPDATE", "PROJECT_CHARGEABLE_FLAG", "PROJECT_BILLABLE_FLAG", "PROJECT_ID", "PROJECT_ELEMENT_ID") AS 
  select a.project_number,a.project_Task_number, 'Update' create_update,
decode(project_chargeable_flag,'Y','true','N','false') project_chargeable_flag,
decode(project_billable_flag,'Y','true','N','false') project_billable_flag,
b.project_id,
b.project_element_id
from XXMX_tasks_flag_xfm a, XXMX_CLOUD_PRJ_TASK_IDS b
where  a.project_number =  b.project_number
and a.project_task_number =  b.element_number
;
