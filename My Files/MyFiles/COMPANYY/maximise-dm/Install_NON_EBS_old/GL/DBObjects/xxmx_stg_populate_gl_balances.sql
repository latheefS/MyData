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


-- *************
-- **GL Open Balances
-- *************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'OPEN_BAL',
pt_import_data_file_name => 'XXMX_GL_OPEN_BALANCES.dat',
pt_control_file_name => 'XXMX_GL_OPEN_BALANCES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


-- *************
-- **GL Summary Balances
-- *************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'SUMM_BAL',
pt_import_data_file_name => 'XXMX_GL_SUMMARY_BALANCES.dat',
pt_control_file_name => 'XXMX_GL_SUMMARY_BALANCES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


-- *************
-- **GL Detail Balances
-- *************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'DETAIL_BAL',
pt_import_data_file_name => 'XXMX_GL_DETAIL_BALANCES.dat',
pt_control_file_name => 'XXMX_GL_DETAIL_BALANCES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/