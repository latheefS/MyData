create or replace view  XXMX_FILE_GROUPS_V as
   SELECT DISTINCT APPLICATION_SUITE,
                   APPLICATION,
                   BUSINESS_ENTITY,
                   FILE_GROUP_NUMBER
   FROM  XXMX_MIGRATION_METADATA
   WHERE ENABLED_FLAG = 'Y';