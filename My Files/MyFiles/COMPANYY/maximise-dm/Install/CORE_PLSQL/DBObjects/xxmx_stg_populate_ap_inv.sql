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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'INVOICES',
pt_i_SubEntity=> 'INVOICE_HEADERS',
pt_import_data_file_name => 'XXMX_AP_INVOICES_STG.dat',
pt_control_file_name => 'XXMX_AP_INVOICES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ******************
-- **AP Invoice Lines
-- ******************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'INVOICES',
pt_i_SubEntity=> 'INVOICE_LINES',
pt_import_data_file_name => 'XXMX_AP_INVOICE_LINES_STG.dat',
pt_control_file_name => 'XXMX_AP_INVOICE_LINES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/