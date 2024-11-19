--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  31-AUG-2023  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- *********************
-- **SUPPLIER TAX PROFILE CONTROLS
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_TAX',
pt_i_SubEntity=> 'PARTY_TAX_PROFILE_CTL',
pt_import_data_file_name => 'XXMX_AP_SUPP_TAX_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_TAX_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *********************
-- **SUPPLIER TAX REGISTRATIONS
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_TAX',
pt_i_SubEntity=> 'TAX_REGISTRATIONS',
pt_import_data_file_name => 'XXMX_AP_SUPP_REG_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_REG_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/