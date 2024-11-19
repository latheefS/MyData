--******************************************************************************
--**
--** xxmx_xfm_populate_item.sql HISTORY
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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEMS_IMPORT',
pt_fusion_template_name=> 'EgpSystemItemsInterface.csv',
pt_fusion_template_sheet_name => 'EgpSystemItemsInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_REVISIONS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REVISIONS_IMP',
pt_fusion_template_name=> 'EgpItemRevisionsInterface.csv',
pt_fusion_template_sheet_name => 'EgpItemRevisionsInterface',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_CATEGORIES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_CATEGORIES_IMP',
pt_fusion_template_name=> 'EgpItemCategoriesInterface.csv',
pt_fusion_template_sheet_name => 'EgpItemCategoriesInterface',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_ASSOCIATIONS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_ASSOCIATIONS_IMP',
pt_fusion_template_name=> 'EgoItemAssociationsIntf.csv',
pt_fusion_template_sheet_name => 'EgoItemAssociationsIntf',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_RELATIONSHIPS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_RELATIONSHIPS_IMP',
pt_fusion_template_name=> 'EgpItemRelationshipsIntf.csv',
pt_fusion_template_sheet_name => 'EgpItemRelationshipsIntf',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemIntfEffb.csv',
pt_fusion_template_sheet_name => 'EgoItemIntfEffb',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_TRANS_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemIntfEfftl.csv',
pt_fusion_template_sheet_name => 'EgoItemIntfEfftl',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_REVISION_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REVISION_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemRevisionIntfEffb.csv',
pt_fusion_template_sheet_name => 'EgoItemRevisionIntfEffb',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_REV_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_REV_TRANS_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemRevisionIntfEfftl.csv',
pt_fusion_template_sheet_name => 'EgoItemRevisionIntfEfftl',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** ITEM_SUPPLIER_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_SUPPLIER_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemSupplierIntfEffb.csv',
pt_fusion_template_sheet_name => 'EgoItemSupplierIntfEffb',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_SUPP_TRANS_EXT_FLEXFIELDS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_SUPP_TRANS_EXT_FLEXFIELDS_IMP',
pt_fusion_template_name=> 'EgoItemSupplierIntfEfftl.csv',
pt_fusion_template_sheet_name => 'EgoItemSupplierIntfEfftl',
pt_fusion_template_sheet_order=>11,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **ITEM_STYLE_VAR_ATTR_VAL
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'ITEM_STYLE_VAR_ATTR_VAL',
pt_fusion_template_name=> 'EgoStyleVariantAttrvsIntf.csv',
pt_fusion_template_sheet_name => 'EgoStyleVariantAttrvsIntf',
pt_fusion_template_sheet_order=>12,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **TRADING_PARTNER_ITEMS_IMPORT
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM',
pt_i_SubEntity=> 'TRADING_PARTNER_ITEMS_IMPORT',
pt_fusion_template_name=> 'EgpTradingPartnerItemsIntf.csv',
pt_fusion_template_sheet_name => 'EgpTradingPartnerItemsIntf',
pt_fusion_template_sheet_order=>13,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/