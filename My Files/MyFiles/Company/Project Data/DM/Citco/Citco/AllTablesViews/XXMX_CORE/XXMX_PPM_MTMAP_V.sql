--------------------------------------------------------
--  DDL for View XXMX_PPM_MTMAP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_MTMAP_V" ("ENV", "ATTRIBUTE1_NUMBER", "SEGMENT1", "NAME", "CLOUD_MASTER_TEMPL_ID") AS 
  select distinct
'DEV4' env,
a.attribute1_number,b.segment1,b.name,
decode(
name,'WBS Master 01 - Trust Americas',300000064148483
,'WBS Master 02 - Trust EurAsia',300000064526191
,'WBS Master 04 - Funds Services',300000064526279
,'WBS Master 05 - CTL',300000064148401
,'WBS Master 08 - GSGS',300000064148258,
null
) cloud_master_templ_id
from xxmx_ppm_projects_Stg a, pa_projects_all@xxmx_extract b
where b.project_id = a.attribute1_number
;
