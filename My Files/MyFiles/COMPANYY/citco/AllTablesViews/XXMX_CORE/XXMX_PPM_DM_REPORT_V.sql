--------------------------------------------------------
--  DDL for View XXMX_PPM_DM_REPORT_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_DM_REPORT_V" ("DATA_OBJECT", "EXTRACT", "TRANSFORM", "LOAD_SCOPE") AS 
  select "DATA_OBJECT","EXTRACT","TRANSFORM","LOAD_SCOPE" from (
select  data_object,sum(number_of_records) number_of_records, decode(stage,0,'EXTRACT',1,'TRANSFORM',2, 'LOAD_SCOPE') stage
from (
select count(*) number_of_records, 'PROJECTS' data_object, 0 stage from xxmx_stg.xxmx_ppm_projects_Stg
union
select count(*) number_of_records, 'PROJECTS' data_object, 1 stage from xxmx_ppm_projects_xfm
union
select count(*) number_of_records, 'PROJECTS' data_object, 2 stage from xxmx_ppm_projects_xfm
/*union
select count(*) number_of_records, 'TASKS' data_object, 0 stage from xxmx_ppm_prj_Tasks_Stg
union
select count(*) number_of_records, 'TASKS' data_object, 1 stage from xxmx_ppm_prj_Tasks_xfm
union
select count(*) number_of_records, 'TASKS' data_object, 2 stage from xxmx_ppm_prj_Tasks_xfm*/
union
select count(*) number_of_records, 'TEAM_MEMBERS' data_object, 0 stage from xxmx_ppm_prj_team_mem_stg
union
select count(*) number_of_records, 'TEAM_MEMBERS' data_object, 1 stage from xxmx_ppm_prj_team_mem_xfm
union
select count(*) number_of_records, 'TEAM_MEMBERS' data_object, 2 stage from xxmx_ppm_prj_team_mem_xfm
union
select count(*) number_of_records, 'CLASSIFICATIONS' data_object, 0 stage from xxmx_ppm_prj_class_stg
union
select count(*) number_of_records, 'CLASSIFICATIONS' data_object, 1 stage from xxmx_ppm_prj_class_xfm
union
select count(*) number_of_records, 'CLASSIFICATIONS' data_object, 2 stage from xxmx_ppm_prj_class_xfm
union
select count(*) , 'COST_LABOR' transaction_type, 0 stage from XXMX_PPM_prj_LBRCOST_stg
union
select count(*), 'COST_LABOR',1 from XXMX_PPM_prj_LBRCOST_xfm
union
select count(*), 'COST_MISC',0 from XXMX_PPM_prj_miscCOST_stg
union
select count(*), 'COST_MISC',1 from XXMX_PPM_prj_misccOST_xfm
union
select count(*), 'COST_LABOR',2 from XXMX_PPM_prj_LBRCOST_xfm
union
select count(*), 'COST_MISC',2 from XXMX_PPM_prj_misccOST_xfm
union
select count(*), 'EVENTS',0 from xxmx_ppm_prj_billevent_stg 
union
select count(*), 'EVENTS',1 from xxmx_ppm_prj_billevent_xfm 
union
select count(*), 'EVENTS',2 from xxmx_ppm_prj_billevent_xfm where contract_line_number is not null
union
select count(*), 'LICENSE_FEE',0 from XXMX_PPM_LIC_UNPAID_STG 
union
select count(*), 'LICENSE_FEE',1 from XXMX_XFM.XXMX_PPM_LIC_UNPAID_xfm 
union
select count(*), 'LICENSE_FEE',2 from XXMX_XFM.XXMX_PPM_LIC_UNPAID_xfm
where distribution_line_number is not null
union
select count(*), 'TASK_FLAG',0 from xxmx_tasks_flag_stg 
union
select count(*), 'TASK_FLAG',1 from xxmx_tasks_flag_xfm 
union
select count(*), 'TASK_FLAG',2 from xxmx_tasks_flag_xfm
)
group by data_object, stage
order by stage asc
)
pivot
(
  SUM(number_of_records)
  for stage in ('EXTRACT' as extract,'TRANSFORM' as transform,'LOAD_SCOPE' as load_scope)
)
ORDER BY decode(data_object,'PROJECTS',0,'TASKS',1,'TEAM_MEMBERS',2,'CLASSIFICATIONS',3,'COST_LABOR',4, 'COST_MISC',5,'EVENTS',6,'LICENSE_FEE',7,'TASK_FLAG',8 ) asc
;
