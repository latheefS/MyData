CREATE OR REPLACE VIEW XXMX_dm_entity_Table_map_v
AS
select distinct application_suite, application, business_entity, 
sub_entity,'EXTRACT' STAGE,stg_table table_name
from xxmx_migration_metadata
WHERE NVL(enabled_flag,'N') = 'Y'
UNION  
select distinct application_suite, application, business_entity, 
sub_entity,'TRANSFORM',xfm_Table
from xxmx_migration_metadata
WHERE NVL(enabled_flag,'N') = 'Y';
/