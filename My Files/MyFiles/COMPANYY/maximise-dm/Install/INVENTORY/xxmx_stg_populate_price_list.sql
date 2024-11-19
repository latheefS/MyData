--******************************************************************************
--**
--** xxmx_stg_populate_price_list.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  25-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **PRICE_LIST_HEADER_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_HEADER_IMP',
pt_import_data_file_name => 'XXMX_SCM_PRICE_LIST_HDR_STG.csv',
pt_control_file_name => 'XXMX_SCM_PRICE_LIST_HDR_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_ACCESS_SETS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_ACCESS_SETS_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_ACCESS_SETS_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_ACCESS_SETS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_ITEMS_IMP',
pt_import_data_file_name => 'XXMX_SCM_PRICE_LIST_ITEMS_STG.csv',
pt_control_file_name => 'XXMX_SCM_PRICE_LIST_ITEMS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- ************************
-- **PRICE_LIST_CHARGES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_CHARGES_IMP',
pt_import_data_file_name => 'XXMX_SCM_PRICE_LIST_CHARGES_STG.csv',
pt_control_file_name => 'XXMX_SCM_PRICE_LIST_CHARGES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_COMP_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_COMP_ITEMS_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_COMPONENT_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_COMPONENT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_COVERED_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_COVERED_ITEMS_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_COVERED_ITEMS_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_COVERED_ITEMS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_TIER_HDR_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_TIER_HDR_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_TIER_HDR_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_TIER_HDR_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_TIER_LINES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_TIER_LINES_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_TIER_LINE_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_TIER_LINE_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_MATRIX_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_MATRIX_IMP',
pt_import_data_file_name => 'XXMX_SCM_PRICE_LIST_MATRIX_STG.csv',
pt_control_file_name => 'XXMX_SCM_PRICE_LIST_MATRIX_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_MATRIX_RULES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_MATRIX_RULES_IMP',
pt_import_data_file_name => 'XXMX_SCM_PL_MATRIX_RULES_STG.csv',
pt_control_file_name => 'XXMX_SCM_PL_MATRIX_RULES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

