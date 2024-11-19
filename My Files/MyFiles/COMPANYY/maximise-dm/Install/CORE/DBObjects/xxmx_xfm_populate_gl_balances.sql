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


-- ************
-- **GL Open Balances
-- ************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'OPEN_BAL',
pt_fusion_template_name=> 'GlInterface.csv',
pt_fusion_template_sheet_name => 'GlInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


-- ************
-- **GL Summary Balances
-- ************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'SUMM_BAL',
pt_fusion_template_name=> 'GlInterface.csv',
pt_fusion_template_sheet_name => 'GlInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************
-- **GL Detail Balances
-- ************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'BALANCES',
pt_i_SubEntity=> 'DETAIL_BAL',
pt_fusion_template_name=> 'GlInterface.csv',
pt_fusion_template_sheet_name => 'GlInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
