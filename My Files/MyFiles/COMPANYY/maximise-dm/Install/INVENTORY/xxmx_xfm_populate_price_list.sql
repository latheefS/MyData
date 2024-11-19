--******************************************************************************
--**
--** xxmx_xfm_populate_price_list.sql HISTORY
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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_HEADER_IMP',
pt_fusion_template_name=> 'PriceListsInterface.csv',
pt_fusion_template_sheet_name => 'PriceListsInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_ACCESS_SETS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_ACCESS_SETS_IMP',
pt_fusion_template_name=> 'PriceListsSetsInterface.csv',
pt_fusion_template_sheet_name => 'PriceListsSetsInterface',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_ITEMS_IMP',
pt_fusion_template_name=> 'PriceListItemsInterface.csv',
pt_fusion_template_sheet_name => 'PriceListItemsInterface',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_CHARGES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_CHARGES_IMP',
pt_fusion_template_name=> 'PriceListChargesInterface.csv',
pt_fusion_template_sheet_name => 'PriceListChargesInterface',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_COMP_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_COMP_ITEMS_IMP',
pt_fusion_template_name=> 'PLComponentItemsInterface.csv',
pt_fusion_template_sheet_name => 'PLComponentItemsInterface',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_COVERED_ITEMS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_COVERED_ITEMS_IMP',
pt_fusion_template_name=> 'PLCoveredItemsInterface.csv',
pt_fusion_template_sheet_name => 'PLCoveredItemsInterface',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_TIER_HDR_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_TIER_HDR_IMP',
pt_fusion_template_name=> 'TierHeadersInterface.csv',
pt_fusion_template_sheet_name => 'TierHeadersInterface',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_TIER_LINES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_TIER_LINES_IMP',
pt_fusion_template_name=> 'TierLinesInterface.csv',
pt_fusion_template_sheet_name => 'TierLinesInterface',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PRICE_LIST_MATRIX_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_MATRIX_IMP',
pt_fusion_template_name=> 'MatrixDimensionsInterface.csv',
pt_fusion_template_sheet_name => 'MatrixDimensionsInterface',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** PRICE_LIST_MATRIX_RULES_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'PRICE_LIST',
pt_i_SubEntity=> 'PRICE_LIST_MATRIX_RULES_IMP',
pt_fusion_template_name=> 'MatrixRulesInterface.csv',
pt_fusion_template_sheet_name => 'MatrixRulesInterface',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

