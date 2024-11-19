--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change.csve  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  18-MAY-2022  Shaik Latheef       Created.
--**
--******************************************************************************

-- ****************************
-- **Customer Party Tax Profile
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMER_TAX',
pt_i_SubEntity=> 'TAX_PROFILE',
pt_import_data_file_name => 'XXMX_ZX_TAX_PROFILE.csv',
pt_control_file_name => 'XXMX_ZX_TAX_PROFILE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************************
-- **Customer Tax Registrations
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMER_TAX',
pt_i_SubEntity=> 'TAX_REGISTRATION',
pt_import_data_file_name => 'XXMX_ZX_TAX_REGISTRATION.csv',
pt_control_file_name => 'XXMX_ZX_TAX_REGISTRATION.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ********************************
-- **Customer Party Classifications
-- ********************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMER_TAX',
pt_i_SubEntity=> 'PARTY_CLASSIFICATION',
pt_import_data_file_name => 'XXMX_ZX_PARTY_CLASSIFIC.csv',
pt_control_file_name => 'XXMX_ZX_PARTY_CLASSIFIC.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/