--------------------------------------------------------
--  DDL for Procedure XXMX_POPULATE_TAB_COL_METADATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_POPULATE_TAB_COL_METADATA" 
(
p_app_suite                                              in varchar2,
p_app                                                    in varchar2,
p_business_ent_seq                                       in number,
p_business_ent                                           in varchar2,
p_sub_ent_seq                                            in number,
p_sub_ent                                                in varchar2,
p_stg_pkg                                                in varchar2,
p_stg_proc                                               in varchar2,
p_data_file_name                                         in varchar2,
p_data_file_ext                                          in varchar2,
p_stg_table_name                                         in varchar2,
p_xfm_table_name                                         in varchar2 
)
is 
    v_sql varchar2(1000);
    v_stg_table_name varchar2(100);
    v_xfm_table_name varchar2(100);
    v_stg_table_id number;
    v_xfm_table_id number;
    v_exists number;
    v_fusion_template_sheet_name varchar2(30);
    v_message varchar2(300);
    v_metadata_id number;
    no_stg_table_exists exception;
    no_xfm_table_exists exception;
    other_error exception;
begin
    -- Check that STG table exists
    v_stg_table_name := upper(p_stg_table_name);
    begin
        select 1 into v_exists from all_objects where owner='XXMX_STG' and object_type='TABLE' and object_name=v_stg_table_name;
        dbms_output.put_line('Table '||v_stg_table_name||' exists');
    exception
        when no_data_found then
            raise no_stg_table_exists;
        when others then
            v_message:=substr(sqlerrm,1,300);
            raise other_error;
    end;
    -- Check that XFM table exists
    v_xfm_table_name:=upper(p_xfm_table_name);
    begin
        select 1 into v_exists from all_objects where owner='XXMX_XFM' and object_type='TABLE' and object_name=v_xfm_table_name;
        dbms_output.put_line('Table '||upper(v_xfm_table_name)||' exists');
    exception
        when no_data_found then
            v_sql := 'create table xxmx_xfm.'||v_xfm_table_name||' as select * from xxmx_stg.'||p_stg_table_name;
            dbms_output.put_line(v_sql);
            begin
                execute immediate v_sql;
                dbms_output.put_line('Table '||v_xfm_table_name||' created');
            exception
                when others then
                    v_message:=substr(sqlerrm,1,300);
                    raise other_error;
            end;
        when others then
            v_message:=substr(sqlerrm,1,300);
            raise other_error;
    end;
    -- Check metadata table & populate
    begin
        select metadata_id into v_metadata_id from  xxmx_migration_metadata where stg_table=v_stg_table_name and xfm_table=v_xfm_table_name;
        dbms_output.put_line('xxmx_migration_metadata exists with metadata_id='||v_metadata_id);
    exception
        when no_data_found then
            dbms_output.put_line('Missing info in xxmx_migration_metadata creating record');
            v_metadata_id := xxmx_migration_metadata_ids_s.nextval;
            begin
                insert into xxmx_migration_metadata 
                    (METADATA_ID,APPLICATION_SUITE,APPLICATION,BUSINESS_ENTITY_SEQ,BUSINESS_ENTITY,
                     SUB_ENTITY_SEQ,SUB_ENTITY,ENTITY_PACKAGE_NAME,STG_PROCEDURE_NAME,STG_TABLE,XFM_TABLE,
                     DATA_FILE_NAME,DATA_FILE_EXTENSION,FILE_GROUP_NUMBER,ENABLED_FLAG) 
                    values 
                    (v_metadata_id,p_app_suite,p_app,p_business_ent_seq,p_business_ent,
                     p_sub_ent_seq,p_sub_ent,p_stg_pkg,p_stg_proc,p_stg_table_name,p_xfm_table_name,
                     p_data_file_name,p_data_file_ext,1,'Y');
                dbms_output.put_line('xxmx_migration_metadata created with metadata_id='||v_metadata_id);
            exception
                when others then
                    v_message:=substr(sqlerrm,1,300);
                    raise other_error;
            end;
        when others then
            v_message:=substr(sqlerrm,1,300);
            raise other_error;
    end;
    -- Seq
    v_stg_table_id := XXMX_STG_TABLE_IDS_S.nextval;
    v_xfm_table_id := XXMX_XFM_TABLE_IDS_S.nextval;
    -- Populate STG
    insert into XXMX_STG_TABLES
        (stg_table_id,metadata_id,schema_name,table_name,import_data_file_name,
         control_file_name,control_file_delimiter,control_file_optional_quotes,purge_flag,
         xfm_table_id)
        values
        (v_stg_table_id,v_metadata_id,'XXMX_STG',v_stg_table_name,
         v_stg_table_name||'.dat',v_stg_table_name||'.ctl',',','"','Y',v_xfm_table_id);
    insert into XXMX_STG_TABLE_COLUMNS 
        (stg_table_id,stg_table_column_id,stg_column_seq,cv40_field_name,column_name,data_type,data_length,MANDATORY,enabled_flag,include_in_control_file,
        xfm_table_id,xfm_table_column_id,creation_date,created_by,last_update_date,last_updated_by) 
        select v_stg_table_id,XXMX_STG_TABLE_COLUMN_IDS_S.nextval,column_id,column_name,column_name,data_type,data_length,'Y','Y','Y',
        v_xfm_table_id,column_id,sysdate,'SCRIPT',sysdate,'SCRIPT'
        from all_tab_columns where table_name=v_stg_table_name;
    --populate XFM
    case p_sub_ent 
        when 'USERS'  then v_fusion_template_sheet_name:='Users.dat';
        when 'RESP'   then v_fusion_template_sheet_name:='Roles.dat';
        when 'ACCESS' then v_fusion_template_sheet_name:='Access.dat';
        else v_fusion_template_sheet_name:=p_sub_ent||'.dat';
    end case;
    insert into XXMX_XFM_TABLES
        (xfm_table_id,metadata_id,schema_name,table_name,fusion_template_name,fusion_template_sheet_name,fusion_template_sheet_order,field_delimiter,purge_flag)
        values
        (v_xfm_table_id,v_metadata_id,'XXMX_XFM',v_xfm_table_name,v_fusion_template_sheet_name,p_sub_ent,1,',','Y');
    Insert into XXMX_XFM_TABLE_COLUMNS
        (XFM_TABLE_ID,XFM_TABLE_COLUMN_ID,XFM_COLUMN_SEQ,FUSION_TEMPLATE_FIELD_NAME,COLUMN_NAME,DATA_TYPE,DATA_LENGTH,MANDATORY,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,
        INCLUDE_IN_OUTBOUND_FILE,ENABLED_FLAG) 
        select v_xfm_table_id,XXMX_XFM_TABLE_COLUMN_IDS_S.nextval,STG_COLUMN_SEQ,column_name,column_name,DATA_TYPE,DATA_LENGTH,MANDATORY,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,
                'Y','Y'
        from XXMX_STG_TABLE_COLUMNS
        where stg_table_id=v_stg_table_id;
    --
    update xxmx_stg_table_columns u set u.xfm_table_column_id=(select xfm_table_column_id from xxmx_xfm_table_columns where xfm_table_id=v_xfm_table_id and upper(column_name)=upper(u.column_name) ) 
        where u.stg_table_id=v_stg_table_id ;
    --
    commit;

exception
    when no_stg_table_exists then
        raise_application_error(-20341,'Table '||upper(p_stg_table_name)||' does not exists');
    when no_xfm_table_exists then
        raise_application_error(-20341,'Table '||upper(v_xfm_table_name)||' does not exists');
    when other_error then
        raise_application_error(-20341,v_message);
    when others then
        raise_application_error(-20341,sqlerrm);
end xxmx_populate_tab_col_metadata;

/
