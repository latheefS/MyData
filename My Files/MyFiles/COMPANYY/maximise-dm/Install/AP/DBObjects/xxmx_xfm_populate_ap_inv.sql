--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  16-FEB-2022  Shaik Latheef       Created.
--**
--******************************************************************************

-- *************
-- **AP Invoices
-- *************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'INVOICES',
pt_i_SubEntity=> 'INVOICE_HEADERS',
pt_fusion_template_name=> 'ApInvoicesInterface.csv',
pt_fusion_template_sheet_name => 'ApInvoicesInterface',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'INVOICE_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ******************
-- **AP Invoice Lines
-- ******************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'INVOICES',
pt_i_SubEntity=> 'INVOICE_LINES',
pt_fusion_template_name=> 'ApInvoiceLinesInterface.csv',
pt_fusion_template_sheet_name => 'ApInvoiceLinesInterface',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'INVOICE_ID',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/