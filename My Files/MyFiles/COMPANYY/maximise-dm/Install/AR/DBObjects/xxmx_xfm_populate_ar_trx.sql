-- ****************
-- **TRANSACTIONS
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'LINES',
pt_fusion_template_name=> 'RaInterfaceLinesAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceLinesAll',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'INTERFACE_LINE_CONTEXT',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'DISTRIBUTIONS',
pt_fusion_template_name=> 'RaInterfaceDistributionsAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceDistributionsAll',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'INTERFACE_LINE_CONTEXT',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'SALESCREDITS',
pt_fusion_template_name=> 'RaInterfaceSalesCreditsAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceSalesCreditsAll',
pt_fusion_template_sheet_order=>3,
pt_common_load_column=>'INTERFACE_LINE_CONTEXT',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
