-- ****************
-- **STD PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_STD',
pt_fusion_template_name=> 'PoHeadersInterfaceOrder.csv',
pt_fusion_template_sheet_name => 'PoHeadersInterfaceOrder',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **STD PO Lines
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINES_STD',
pt_fusion_template_name=> 'PoLinesInterfaceOrder.csv',
pt_fusion_template_sheet_name => 'PoLinesInterfaceOrder',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **STD PO Line Locations
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINE_LOCATIONS_STD',
pt_fusion_template_name=> 'PoLineLocationsInterfaceOrder.csv',
pt_fusion_template_sheet_name => 'PoLineLocationsInterfaceOrder',
pt_fusion_template_sheet_order=>3,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **********************
-- **STD PO Distributions
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_DISTRIBUTIONS_STD',
pt_fusion_template_name=> 'PoDistributionsInterfaceOrder.csv',
pt_fusion_template_sheet_name => 'PoDistributionsInterfaceOrder',
pt_fusion_template_sheet_order=>4,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


-- ****************
-- **BPA PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_HEADERS_BPA',
pt_fusion_template_name=> 'PoHeadersInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoHeadersInterfaceBlanket',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **BPA PO Lines
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_LINES_BPA',
pt_fusion_template_name=> 'PoLinesInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoLinesInterfaceBlanket',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **BPA PO Line Locations
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_LINE_LOCATIONS_BPA',
pt_fusion_template_name=> 'PoLineLocationsInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoLineLocationsInterfaceBlanket',
pt_fusion_template_sheet_order=>3,
pt_common_load_column=>'PO_HEADER_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **BPA Org Assign
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ORG_ASSIGN_BPA',
pt_fusion_template_name=> 'PoGAOrgAssignInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoGAOrgAssignInterfaceBlanket',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **BPA Attribute Values 
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ATTR_VALUES_BPA',
pt_fusion_template_name=> 'PoAttrValuesInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoAttrValuesInterfaceBlanket',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **BPA Translated Values 
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ATTR_TLP_BPA',
pt_fusion_template_name=> 'PoAttrValuesTlpInterfaceBlanket.csv',
pt_fusion_template_sheet_name => 'PoAttrValuesTlpInterfaceBlanket',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **CPA PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_CPA',
pt_i_SubEntity=> 'PO_HEADERS_CPA',
pt_fusion_template_name=> 'PoHeadersInterfaceContract.csv',
pt_fusion_template_sheet_name => 'PoHeadersInterfaceContract',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'VENDOR_NUM',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **CPA Org Assign
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_CPA',
pt_i_SubEntity=> 'PO_ORG_ASSIGN_CPA',
pt_fusion_template_name=> 'PoGAOrgAssignInterfaceContract.csv',
pt_fusion_template_sheet_name => 'PoGAOrgAssignInterfaceContract',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/