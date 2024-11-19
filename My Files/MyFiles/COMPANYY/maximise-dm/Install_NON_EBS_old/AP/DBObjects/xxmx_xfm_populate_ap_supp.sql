--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  16-FEB-2022  Shaik Latheef       Created.
--**
--******************************************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIERS',
pt_fusion_template_name=> 'PozSuppliersInt.csv',
pt_fusion_template_sheet_name => 'PozSuppliersInt',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_ADDRESSES',
pt_fusion_template_name=> 'PozSupplierAddressesInt.csv',
pt_fusion_template_sheet_name => 'PozSupplierAddressesInt',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_SITES',
pt_fusion_template_name=> 'PozSupplierSitesInt.csv',
pt_fusion_template_sheet_name => 'PozSupplierSitesInt',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_THIRD_PARTY_RELS',
pt_fusion_template_name=> 'PozSupThirdPartyInt.csv',
pt_fusion_template_sheet_name => 'PozSupThirdPartyInt',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_CONTACTS',
pt_fusion_template_name=> 'PozSupContactsInt.csv',
pt_fusion_template_sheet_name => 'PozSupContactsInt',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_CONT_ADDRS',
pt_fusion_template_name=> 'PozSupContactAddressesInt.csv',
pt_fusion_template_sheet_name => 'PozSupContactAddressesInt',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_SITE_ASSIGNS',
pt_fusion_template_name=> 'PozSiteAssignmentsInt.csv',
pt_fusion_template_sheet_name => 'PozSiteAssignmentsInt',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_PAYEES',
pt_fusion_template_name=> 'IbyTempExtPayees.csv',
pt_fusion_template_sheet_name => 'IbyTempExtPayees',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_fusion_template_name=> 'IbyTempExtBankAccts.csv',
pt_fusion_template_sheet_name => 'IbyTempExtBankAccts',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_PMT_INSTRS',
pt_fusion_template_name=> 'IbyTempPmtInstrUses.csv',
pt_fusion_template_sheet_name => 'IbyTempPmtInstrUses',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/