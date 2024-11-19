--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  16-FEB-2022  Shaik Latheef       Created for Maximise.
--**
--******************************************************************************


-- ****************
-- **MASS_ADDITIONS
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_ADDITIONS',
pt_import_data_file_name => 'XXMX_FA_MASS_ADDITIONS.dat',
pt_control_file_name => 'XXMX_FA_MASS_ADDITIONS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **MASS_DISTRIBUTION
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_DISTRIBUTION',
pt_import_data_file_name => 'XXMX_FA_MASS_ADDITION_DIST.dat',
pt_control_file_name => 'XXMX_FA_MASS_ADDITION_DIST.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **MASS_RATES
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_RATES',
pt_import_data_file_name => 'XXMX_FA_MC_MASS_RATES.dat',
pt_control_file_name => 'XXMX_FA_MC_MASS_RATES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/