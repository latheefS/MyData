-- ****************
-- **STD PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_STD',
pt_import_data_file_name => 'XXMX_SCM_PO_HEADERS_STD.csv',
pt_control_file_name => 'XXMX_SCM_PO_HEADERS_STD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **STD PO Lines
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINES_STD',
pt_import_data_file_name => 'XXMX_SCM_PO_LINES_STD.csv',
pt_control_file_name => 'XXMX_SCM_PO_LINES_STD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **STD PO Line Locations
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_LINE_LOCATIONS_STD',
pt_import_data_file_name => 'XXMX_SCM_PO_LINE_LOCATIONS_STD.csv',
pt_control_file_name => 'XXMX_SCM_PO_LINE_LOCATIONS_STD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **********************
-- **STD PO Distributions
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_DISTRIBUTIONS_STD',
pt_import_data_file_name => 'XXMX_SCM_PO_DISTRIBUTIONS_STD.csv',
pt_control_file_name => 'XXMX_SCM_PO_DISTRIBUTIONS_STD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **BPA PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_HEADERS_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_HEADERS_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_HEADERS_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **BPA PO Lines
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_LINES_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_LINES_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_LINES_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **BPA PO Line Locations
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_LINE_LOCATIONS_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_LINE_LOCATIONS_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_LINE_LOCATIONS_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **BPA Org Assign 
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ORG_ASSIGN_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_GA_ORG_ASSIGN_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_GA_ORG_ASSIGN_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **BPA Attribute Values 
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ATTR_VALUES_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_ATTR_VALUES_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_ATTR_VALUES_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***********************
-- **BPA Translated Values 
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_BPA',
pt_i_SubEntity=> 'PO_ATTR_TLP_BPA',
pt_import_data_file_name => 'XXMX_SCM_PO_ATTR_VALUES_TLP_BPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_ATTR_VALUES_TLP_BPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **CPA PO Headers
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_CPA',
pt_i_SubEntity=> 'PO_HEADERS_CPA',
pt_import_data_file_name => 'XXMX_SCM_PO_HEADERS_CPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_HEADERS_CPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **CPA Org Assign
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS_CPA',
pt_i_SubEntity=> 'PO_ORG_ASSIGN_CPA',
pt_import_data_file_name => 'XXMX_SCM_PO_GA_ORG_ASSIGN_CPA.csv',
pt_control_file_name => 'XXMX_SCM_PO_GA_ORG_ASSIGN_CPA.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

