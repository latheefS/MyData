--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change.csve  Changed By          Change Description
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
pt_import_data_file_name => 'XXMX_RA_CUST_INV_LINES.csv',
pt_control_file_name => 'XXMX_RA_CUST_INV_LINES.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_RA_CUST_INV_DISTS.csv',
pt_control_file_name => 'XXMX_RA_CUST_INV_DISTS.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_RA_INV_SALESCREDITS.csv',
pt_control_file_name => 'XXMX_RA_INV_SALESCREDITS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/