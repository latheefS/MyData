--******************************************************************************
--**
--** xxmx_xfm_populate_po_rcpt.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-FEB-2023  Soundarya Kamatagi   Created for Maximise.
--**
--******************************************************************************


-- *********************
-- **PO RECEIPT HEADERS
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDER_RECEIPT',
pt_i_SubEntity=> 'PO_RECEIPT_HEADERS',
pt_fusion_template_name=> 'RcvHeadersInterface.csv',
pt_fusion_template_sheet_name => 'RcvHeadersInterface',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'HEADER_INTERFACE_NUMBER',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



-- ************************
-- **PO RECEIPT TRANSACTION
-- ************************


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDER_RECEIPT',
pt_i_SubEntity=> 'PO_RECEIPT_TRANSACTIONS',
pt_fusion_template_name=> 'RcvTransactionsInterface.csv',
pt_fusion_template_sheet_name => 'RcvTransactionsInterface',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'HEADER_INTERFACE_NUMBER',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

