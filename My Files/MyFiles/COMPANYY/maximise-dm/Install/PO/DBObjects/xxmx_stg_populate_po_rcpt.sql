--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-FEB-2023  Soundarya Kamatagi  Created for Maximise.
--**
--******************************************************************************


-- *********************
-- **PO RECEIPT HEADERS
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDER_RECEIPT',
pt_i_SubEntity=> 'PO_RECEIPT_HEADERS',
pt_import_data_file_name => 'XXMX_SCM_PO_RCPT_HDR_STG.csv',
pt_control_file_name => 'XXMX_SCM_PO_RCPT_HDR_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **PO RECEIPT TRANSACTION
-- ************************



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDER_RECEIPT',
pt_i_SubEntity=> 'PO_RECEIPT_TRANSACTIONS',
pt_import_data_file_name => 'XXMX_SCM_PO_RCPT_TXN_STG.csv',
pt_control_file_name => 'XXMX_SCM_PO_RCPT_TXN_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/