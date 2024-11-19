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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'DAILY_RATES',
pt_i_SubEntity=> 'DAILY_RATES',
pt_fusion_template_name=> 'GlDailyRatesInterface.csv',
pt_fusion_template_sheet_name => 'GlDailyRatesInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

