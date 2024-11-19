--------------------------------------------------------
--  DDL for View XXMX_TEMP_FILE_NAMES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_TEMP_FILE_NAMES_V" ("APPLICATION_SUITE", "BUSINESS_ENTITY", "SUB_ENTITY", "FUSION_FILE_NAME", "FILE_NAME") AS 
  select distinct APPLICATION_SUITE,BUSINESS_ENTITY,SUB_ENTITY,
        (SElect fusion_template_name
            from xxmx_xfm_Tables
            where table_name = UPPER(mm.xfm_table)) FUSION_FILE_NAME,
        CASE  WHEN INSTR(TRIM(data_file_name),'.csv',1) = 0 then
            TRIM(data_file_name)||'.csv'
            ELSE
            TRIM(data_file_name)
            END FILE_NAME
        from XXMX_MIGRATION_METADATA mm
        where mm.stg_table is not null
        AND mm.enabled_flag = 'Y'
        AND application_suite IN ( 'FIN','SCM' , 'PPM' )
        and exists ( select 1 from xxmx_csv_file_temp where UPPER(file_name) like '%'||UPPER(TRIM(data_file_name))||'%')
  UNION ALL
    select distinct
        APPLICATION_SUITE,
        BUSINESS_ENTITY,
        SUB_ENTITY,
        nvl((
            select fusion_template_name
                from xxmx_xfm_tables
                where table_name = UPPER(meta_data.xfm_table)
            )
        ,'Worker.dat')                                       as FUSION_FILE_NAME,
        case
            when business_entity='USERS' then
            (    select fusion_template_name
                from xxmx_xfm_tables
                where table_name = UPPER(meta_data.xfm_table) )
            else
                case
                    when INSTR(TRIM(data_file_name),'.dat',1) = 0 then
                        TRIM(data_file_name)||'.dat'
                    else
                        TRIM(data_file_name)
                end
        end                                                         as FILE_NAME
    from     XXMX_MIGRATION_METADATA    meta_data
    where    meta_data.enabled_flag = 'Y'
    AND      meta_data.application_suite IN( 'HCM','IREC')
    and      meta_data.data_file_name IS NOT NULL
    and exists ( select 1 from xxmx_hdl_file_temp where UPPER(file_name) like '%'||UPPER(TRIM(data_file_name))||'%')
  union all
    -- CUSTOM AR CASH_RECEIPTS
    select distinct 'FIN','CASH_RECEIPTS','CASH_RECEIPTS',file_name,file_name from xxmx_csv_file_temp where file_name like 'BATCH-%'
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_TEMP_FILE_NAMES_V" TO "XXMX_READONLY";
