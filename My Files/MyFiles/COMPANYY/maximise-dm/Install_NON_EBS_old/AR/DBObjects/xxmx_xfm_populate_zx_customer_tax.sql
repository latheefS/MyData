--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  18-MAY-2022  Shaik Latheef       Created.
--**
--******************************************************************************

-- ****************************
-- **Customer Party Tax Profile
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMERS_TAX',
pt_i_SubEntity=> 'TAX_PROFILE',
pt_fusion_template_name=> 'PartyTaxProfileControls.csv',
pt_fusion_template_sheet_name => 'PartyTaxProfileControls',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ****************************
-- **Customer Tax Registrations
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMERS_TAX',
pt_i_SubEntity=> 'TAX_REGISTRATION',
pt_fusion_template_name=> 'TaxRegistrations.csv',
pt_fusion_template_sheet_name => 'TaxRegistrations',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ********************************
-- **Customer Party Classifications
-- ********************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'ZX',
pt_i_BusinessEntity=> 'CUSTOMERS_TAX',
pt_i_SubEntity=> 'PARTY_CLASSIFIC',
pt_fusion_template_name=> 'PartyClassifications.csv',
pt_fusion_template_sheet_name => 'PartyClassifications',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/