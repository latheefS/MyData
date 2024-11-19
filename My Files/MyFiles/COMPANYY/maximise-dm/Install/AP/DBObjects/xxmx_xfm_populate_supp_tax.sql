--******************************************************************************
--**
--** xxmx_xfm_populate_supp_tax.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  31-AUG-2023  Sinchana Ramesh   Created for Cloudbridge.
--**
--******************************************************************************


-- *********************
-- **SUPPLIER TAX PROFILE CONTROLS
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_TAX',
pt_i_SubEntity=> 'PARTY_TAX_PROFILE_CTL',
pt_fusion_template_name=> 'TaxImplementationData.csv',
pt_fusion_template_sheet_name => 'TaxImplementationData',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'PARTY_NAME',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *********************
-- **SUPPLIER TAX REGISTRATIONS
-- *********************


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_TAX',
pt_i_SubEntity=> 'TAX_REGISTRATIONS',
pt_fusion_template_name=> 'TaxImplementationData.csv',
pt_fusion_template_sheet_name => 'TaxImplementationData',
pt_fusion_template_sheet_order=>3,
pt_common_load_column=>'PARTY_NAME',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

