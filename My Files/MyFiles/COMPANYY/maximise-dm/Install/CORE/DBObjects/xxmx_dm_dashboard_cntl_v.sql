
  CREATE OR REPLACE  VIEW "XXMX_CORE"."XXMX_DM_DASHBOARD_CNTL_V" ("ITERATION", "MIGRATION_SET_ID", "BUSINESS_ENTITY", "SUB_ENTITY", "EXTRACT_COUNT", "TRANSFORM_COUNT", "LOAD_COUNT", "FUSION_ERROR_COUNT", "CREATION_DATE", "LAST_UPDATED_DATE", "APPLICATION_SUITE", "APPLICATION", "REQUEST_ID", "IMPORT_SUCCESS_COUNT", "EXTRACT_START_TIME", "EXTRACT_END_TIME", "TRANSFORM_START_TIME", "TRANSFORM_END_TIME", "IMPORT_START_TIME", "IMPORT_END_TIME") AS 
  Select b.ITERATION
        ,b.migration_set_id
     , b.business_entity
     , b.sub_entity
     , extract_count
     , nvl(transform_count,0) as transform_count
     , load_count
     , Fusion_error_count
     , Creation_Date
     , Last_updated_date
     , Application_suite
     , Application
     ,REQUEST_ID
     ,IMPORT_SUCCESS_COUNT
     ,EXTRACT_START_TIME
     ,EXTRACT_END_TIME
     ,TRANSFORM_START_TIME
     ,TRANSFORM_END_TIME
     ,IMPORT_START_TIME
     ,IMPORT_END_TIME    
from (select Business_Entity,ITERATION
            , Sub_entity
            , max(Migration_set_id) migration_set_id
      from xxmx_dm_dashboard_cntl
            Group by Business_Entity
                , Sub_entity,ITERATION) a
    , xxmx_dm_dashboard_cntl b
where a.migration_set_id = b.migration_set_id
and a.Sub_entity = b.Sub_entity
and a.business_entity = b.business_entity
and a.iteration=b.iteration;