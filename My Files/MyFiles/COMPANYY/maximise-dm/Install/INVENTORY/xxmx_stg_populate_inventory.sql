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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INVENTORY_TRANSACTION_IMP',
pt_import_data_file_name => 'XXMX_SCM_INV_TXNS_STG.csv',
pt_control_file_name => 'XXMX_SCM_INV_TXNS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- ****************
-- **Inventory Lots 
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INVENTORY_LOTS_IMP',
pt_import_data_file_name => 'XXMX_SCM_INV_TXN_LOTS_STG.csv',
pt_control_file_name => 'XXMX_SCM_INV_TXN_LOTS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- **************************
-- **Inventory Serial Numbers 
-- **************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'INV_SERIAL_NUM_IMP',
pt_import_data_file_name => 'XXMX_SCM_INV_SER_NUMS_STG.csv',
pt_control_file_name => 'XXMX_SCM_INV_SER_NUMS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

-- *****************
-- **Inventory Costs 
-- *****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'IM',
pt_i_BusinessEntity=> 'INVENTORY_TRANSACTIONS',
pt_i_SubEntity=> 'TRANSACTION_COSTS_IMP',
pt_import_data_file_name => 'XXMX_SCM_INV_TXN_COSTS_STG.csv',
pt_control_file_name => 'XXMX_SCM_INV_TXN_COSTS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

