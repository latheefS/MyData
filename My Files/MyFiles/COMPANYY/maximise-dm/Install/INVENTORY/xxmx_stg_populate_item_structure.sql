--******************************************************************************
--**
--** xxmx_stg_populate_item_structure.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  22-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************

-- ************************
-- ** STRUCTURE_HEADERS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'STRUCTURE_HEADERS_IMP',
pt_import_data_file_name => 'XXMX_SCM_STRUCTURE_HEADERS_STG.csv',
pt_control_file_name => 'XXMX_SCM_STRUCTURE_HEADERS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- ************************
-- ** COMPONENTS_IMPORT
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'COMPONENTS_IMPORT',
pt_import_data_file_name => 'XXMX_SCM_COMPONENTS_IMP_STG.csv',
pt_control_file_name => 'XXMX_SCM_COMPONENTS_IMP_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- ************************
-- ** SUBSTITUTE_COMPONENTS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'SUBSTITUTE_COMPONENTS_IMP',
pt_import_data_file_name => 'XXMX_SCM_SUBSTITUTE_COMP_STG.csv',
pt_control_file_name => 'XXMX_SCM_SUBSTITUTE_COMP_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- ************************
-- ** REFERENCE_DESIGNATORS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'REFERENCE_DESIGNATORS_IMP',
pt_import_data_file_name => 'XXMX_SCM_REF_DESIGN_STG.csv',
pt_control_file_name => 'XXMX_SCM_REF_DESIGN_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/