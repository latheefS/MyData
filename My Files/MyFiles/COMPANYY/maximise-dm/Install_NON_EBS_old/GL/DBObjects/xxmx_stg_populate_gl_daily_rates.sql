--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  08-JUNE-2022  Shaik Latheef      Created for Maximise.
--**
--******************************************************************************


-- ****************
-- **GL Daily Rates
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'DAILY_RATES',
pt_i_SubEntity=> 'DAILY_RATES',
pt_import_data_file_name => 'XXMX_GL_DAILY_RATES.dat',
pt_control_file_name => 'XXMX_GL_DAILY_RATES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/