--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  09-NOV-2022  Shaik Latheef       Created for Maximise.
--**
--******************************************************************************


-- *********************
-- **GL Historical Rates
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'HISTORICAL_RATES',
pt_i_SubEntity=> 'HISTORICAL_RATES',
pt_fusion_template_name=> 'GlHistoricalRatesInterface.csv',
pt_fusion_template_sheet_name => 'GlHistoricalRatesInterface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

