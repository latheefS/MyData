--------------------------------------------------------
--  DDL for View XXMX_PPM_CREATE_TEAM_MEM_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_CREATE_TEAM_MEM_V" ("PROJECT_ID", "PROJECT_NUMBER", "TEAM_MEMBER_NUMBER", "PERSON_ID", "PROJECT_ROLE", "START_DATE_ACTIVE") AS 
  select "PROJECT_ID","PROJECT_NUMBER","TEAM_MEMBER_NUMBER","PERSON_ID","PROJECT_ROLE","START_DATE_ACTIVE" from (
select 
(select project_id from xxmx_ppm_fusion_project_ids t where t.segment1 =  a.project_number and rownum = 1 ) project_id
, a.project_number, a.team_member_number, b.person_id, a. project_role 
, a.start_date_Active
from xxmx_ppm_prj_team_mem_xfm a, xxmx_ppm_pers_det b
where not exists (
select 1 from xxmx_ppm_create_team_mem b
where a.team_member_number = b. team_member_number
and a.project_number =  b.project_number
and a.start_date_active =  to_date(b.start_date_active,'yyyy/mm/dd')
and a.project_role =  b.project_role
)
and a.team_member_number =  b.person_number
and a.project_number  <> '4011228' )
where  project_id is not null
;
