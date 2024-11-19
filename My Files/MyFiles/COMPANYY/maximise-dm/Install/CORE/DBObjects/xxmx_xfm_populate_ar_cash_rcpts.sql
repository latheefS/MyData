-- ******************
-- **AR CASH RECEIPTS
-- ******************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CASH_RECEIPTS',
pt_i_SubEntity=> 'CASH_RECEIPTS',
pt_fusion_template_name=> 'ArPaymentsInterfaceAll.csv',
pt_fusion_template_sheet_name => 'Record 1 - Transmission Header',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
