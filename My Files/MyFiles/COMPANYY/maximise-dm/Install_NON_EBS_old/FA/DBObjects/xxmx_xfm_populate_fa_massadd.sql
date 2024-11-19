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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_ADDITIONS',
pt_fusion_template_name=> 'FaMassAdditions.csv',
pt_fusion_template_sheet_name => 'FaMassAdditions',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************
-- **MASS_DISTRIBUTION
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_DISTRIBUTION',
pt_fusion_template_name=> 'FaMassaddDistributions.csv',
pt_fusion_template_sheet_name => 'FaMassaddDistributions',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


-- ****************
-- **MASS_RATES
-- ****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'FA',
pt_i_BusinessEntity=> 'FIXED_ASSETS',
pt_i_SubEntity=> 'MASS_RATES',
pt_fusion_template_name=> 'FaMcMassRates.csv',
pt_fusion_template_sheet_name => 'FaMcMassRates',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/