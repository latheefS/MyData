-- ****************
-- **TRANSACTIONS
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'LINES',
pt_import_data_file_name => 'XXMX_AR_TRX_LINES_STG.csv',
pt_control_file_name => 'XXMX_AR_TRX_LINES_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'DISTRIBUTIONS',
pt_import_data_file_name => 'XXMX_AR_TRX_DISTS_STG.csv',
pt_control_file_name => 'XXMX_AR_TRX_DISTS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'SALESCREDITS',
pt_import_data_file_name => 'XXMX_AR_TRX_SALESCREDITS_STG.csv',
pt_control_file_name => 'XXMX_AR_TRX_SALESCREDITS_STG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
