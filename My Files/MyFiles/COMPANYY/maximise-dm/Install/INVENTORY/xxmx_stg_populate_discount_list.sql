--******************************************************************************
--**
--** xxmx_stg_populate_discount_list.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  30-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Discount List Header Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_HEADER_IMPORT',
pt_import_data_file_name => 'XXMX_SCM_QP_DISCOUNT_LISTS_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_DISCOUNT_LISTS_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** Discount List Access Sets Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_ACCESS_SETS_IMP',
pt_import_data_file_name => 'XXMX_SCM_QP_DISCOUNT_LIST_SETS_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_DISCOUNT_LIST_SETS_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Discount List Items Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DISCOUNT_LIST_ITEMS_IMP',
pt_import_data_file_name => 'XXMX_SCM_QP_DISCOUNT_LIST_ITEMS_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_DISCOUNT_LIST_ITEMS_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Pricing Terms Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'PRICING_TERMS_IMP',
pt_import_data_file_name => 'XXMX_SCM_QP_PRICING_TERMS_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_PRICING_TERMS_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Discount List Matrix Dimension Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_MATRIX_DIMENSION_IMP',
pt_import_data_file_name => 'XXMX_SCM_QP_MATRIX_DIMENSIONS_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_MATRIX_DIMENSIONS_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** Discount List Matrix Rules Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_MATRIX_RULES_IMP',
pt_import_data_file_name => 'XXMX_SCM_QP_MATRIX_RULES_INT_STG.csv',
pt_control_file_name => 'XXMX_SCM_QP_MATRIX_RULES_INT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


