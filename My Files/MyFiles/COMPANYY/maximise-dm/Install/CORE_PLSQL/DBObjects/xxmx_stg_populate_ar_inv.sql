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


-- *******************
-- **AR Invoices Lines
-- *******************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'LINES',
pt_import_data_file_name => 'XXMX_AR_TRX_LINES_STG.dat',
pt_control_file_name => 'XXMX_AR_TRX_LINES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************************
-- **AR Invoice Distributions
-- **************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'DISTRIBUTIONS',
pt_import_data_file_name => 'XXMX_AR_TRX_DISTS_STG.dat',
pt_control_file_name => 'XXMX_AR_TRX_DISTS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *************************
-- **AR Invoice Salescredits
-- *************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'SALESCREDITS',
pt_import_data_file_name => 'XXMX_AR_TRX_SALESCREDITS_STG.dat',
pt_control_file_name => 'XXMX_AR_TRX_SALESCREDITS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/