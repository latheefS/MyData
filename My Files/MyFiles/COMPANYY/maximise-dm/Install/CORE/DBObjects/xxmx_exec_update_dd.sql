Declare

Begin

UPDATE xxmx_xfm_update_columns
SET COLUMN_NAME = UPPER(TRIM(COLUMN_NAME))
,TABLE_NAME = UPPER(TRIM(TABLE_NAME))
,Fusion_template_field_name= TRIM(Fusion_template_field_name);

--Update Data Dictionary Tables 
 xxmx_dynamic_sql_pkg.xfm_update_columns(p_table_name => NULL);              

END;
/
Commit ;
/