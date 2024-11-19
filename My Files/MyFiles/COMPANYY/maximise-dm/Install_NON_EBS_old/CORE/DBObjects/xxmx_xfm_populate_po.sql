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
pt_fusion_template_name=> 'PoHeadersInterface.csv',
pt_fusion_template_sheet_name => 'PO_HEADERS_INTERFACE',
pt_fusion_template_sheet_order=>1,
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
pt_fusion_template_name=> 'PoLinesInterface.csv',
pt_fusion_template_sheet_name => 'PO_LINES_INTERFACE',
pt_fusion_template_sheet_order=>2,
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
pt_fusion_template_name=> 'PoLineLocationsInterface.csv',
pt_fusion_template_sheet_name => 'PO_LINE_LOCATIONS_INTERFACE',
pt_fusion_template_sheet_order=>3,
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
pt_fusion_template_name=> 'PoDistributionsInterface.csv',
pt_fusion_template_sheet_name => 'PO_DISTRIBUTIONS_INTERFACE',
pt_fusion_template_sheet_order=>4,
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
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_BPA',
pt_fusion_template_name=> 'PoHeadersInterface.csv',
pt_fusion_template_sheet_name => 'PO_HEADERS_INTERFACE',
pt_fusion_template_sheet_order=>1,
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
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINES_BPA',
pt_fusion_template_name=> 'PoLinesInterface.csv',
pt_fusion_template_sheet_name => 'PO_LINES_INTERFACE',
pt_fusion_template_sheet_order=>2,
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
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINE_LOCATIONS_BPA',
pt_fusion_template_name=> 'PoLineLocationsInterface.csv',
pt_fusion_template_sheet_name => 'PO_LINE_LOCATIONS_INTERFACE',
pt_fusion_template_sheet_order=>3,
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
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_CPA',
pt_fusion_template_name=> 'PoHeadersInterface.csv',
pt_fusion_template_sheet_name => 'PO_HEADERS_INTERFACE',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/