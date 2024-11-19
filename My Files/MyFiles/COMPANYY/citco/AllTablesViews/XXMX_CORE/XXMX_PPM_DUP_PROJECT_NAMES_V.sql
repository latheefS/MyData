--------------------------------------------------------
--  DDL for View XXMX_PPM_DUP_PROJECT_NAMES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_DUP_PROJECT_NAMES_V" ("NUMBER_OF_RECS", "PROJECT_NAME") AS 
  select count(*) number_of_recs, project_name from xxmx_ppm_projects_xfm
group by project_name
having count(*) > 1
;
