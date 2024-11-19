--******************************************************************************
--**
--** xxmx_stg_populate_item.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  22-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **ITEMS_IMPORT
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEMS_IMPORT',
pt_import_data_file_name => 'XXMX_SCM_SYS_ITEMS_STG.csv',
pt_control_file_name => 'XXMX_SCM_SYS_ITEMS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_REVISIONS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REVISIONS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_REV_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_REV_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_CATEGORIES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_CATEGORIES_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_CAT_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_CAT_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- ************************
-- **ITEM_ASSOCIATIONS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_ASSOCIATIONS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_ASSOC_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_ASSOC_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_RELATIONSHIPS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_RELATIONSHIPS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_REL_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_REL_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_EFF_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_EFF_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_TRANS_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_EFF_TL_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_EFF_TL_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_REVISION_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REVISION_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_REV_EFF_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_REV_EFF_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_REV_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REV_TRANS_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_REV_EFF_TL_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_REV_EFF_TL_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_SUPPLIER_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_SUPPLIER_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_SUPP_EFF_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_SUPP_EFF_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_SUPP_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_SUPP_TRANS_EXT_FLEXFIELDS_IMP',
pt_import_data_file_name => 'XXMX_SCM_ITEM_SUPP_EFF_TL_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_SUPP_EFF_TL_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_STYLE_VAR_ATTR_VAL
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_STYLE_VAR_ATTR_VAL',
pt_import_data_file_name => 'XXMX_SCM_ITEM_STYL_ATTR_STG.csv',
pt_control_file_name => 'XXMX_SCM_ITEM_STYL_ATTR_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **TRADING_PARTNER_ITEMS_IMPORT
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'TRADING_PARTNER_ITEMS_IMPORT',
pt_import_data_file_name => 'XXMX_SCM_TP_ITEMS_STG.csv',
pt_control_file_name => 'XXMX_SCM_TP_ITEMS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/