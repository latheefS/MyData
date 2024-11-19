--******************************************************************************
--**
--** xxmx_xfm_populate_inventory.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  22-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Inventory Transactions
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INVENTORY_TRANSACTION_IMP',
pt_fusion_template_name=> 'InvTransactionsInterface.csv',
pt_fusion_template_sheet_name => 'InvTransactionsInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **Inventory Lots 
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INVENTORY_LOTS_IMP',
pt_fusion_template_name=> 'InvTransactionLotsInterface.csv',
pt_fusion_template_sheet_name => 'InvTransactionLotsInterface',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************************
-- **Inventory Serial Numbers 
-- **************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INV_SERIAL_NUM_IMP',
pt_fusion_template_name=> 'InvSerialNumbersInterface.csv',
pt_fusion_template_sheet_name => 'InvSerialNumbersInterface',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *****************
-- **Inventory Costs 
-- *****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'TRANSACTION_COSTS_IMP',
pt_fusion_template_name=> 'CstTransCostInterface.csv',
pt_fusion_template_sheet_name => 'CstTransCostInterface',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/