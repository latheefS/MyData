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
pt_fusion_template_sheet_name => 'FA_MASS_ADDITIONS',
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
pt_fusion_template_sheet_name => 'FA_MASSADD_DISTRIBUTIONS',
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
pt_fusion_template_sheet_name => 'FA_MC_MASS_RATES',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/