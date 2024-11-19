--------------------------------------------------------
--  DDL for View XXMX_DM_ENTITY_TABLE_MAP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_DM_ENTITY_TABLE_MAP_V" ("APPLICATION_SUITE", "APPLICATION", "BUSINESS_ENTITY", "SUB_ENTITY", "STAGE", "TABLE_NAME") AS 
  select distinct application_suite, application, business_entity, 
sub_entity,'EXTRACT' STAGE,stg_table table_name
from xxmx_migration_metadata
where enabled_flag = 'Y'
and stg_table is not null
UNION  
select distinct application_suite, application, business_entity, 
sub_entity,'TRANSFORM',xfm_table
from xxmx_migration_metadata
where enabled_flag = 'Y'
and xfm_table is not null
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_DM_ENTITY_TABLE_MAP_V" TO "XXMX_READONLY";
