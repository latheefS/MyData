--******************************************************************************
--**
--** xxmx_xfm_populate_discount_list.sql HISTORY
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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_HEADER_IMPORT',
pt_fusion_template_name=> 'DiscountListsInterface.csv',
pt_fusion_template_sheet_name => 'DiscountListsInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** Discount List Access Sets Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_ACCESS_SETS_IMP',
pt_fusion_template_name=> 'DiscountListSetsInterface.csv',
pt_fusion_template_sheet_name => 'DiscountListSetsInterface',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Discount List Items Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DISCOUNT_LIST_ITEMS_IMP',
pt_fusion_template_name=> 'DiscountListItemsInterface.csv',
pt_fusion_template_sheet_name => 'DiscountListItemsInterface',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Pricing Terms Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'PRICING_TERMS_IMP',
pt_fusion_template_name=> 'PricingTermsInterface.csv',
pt_fusion_template_sheet_name => 'PricingTermsInterface',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **Discount List Matrix Dimension Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_MATRIX_DIMENSION_IMP',
pt_fusion_template_name=> 'MatrixDimensionsInterface.csv',
pt_fusion_template_sheet_name => 'MatrixDimensionsInterface',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** Discount List Matrix Rules Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'OM',
pt_i_BusinessEntity=> 'DISCOUNT_LISTS',
pt_i_SubEntity=> 'DL_MATRIX_RULES_IMP',
pt_fusion_template_name=> 'MatrixRulesInterface.csv',
pt_fusion_template_sheet_name => 'MatrixRulesInterface',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


