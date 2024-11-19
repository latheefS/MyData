-- **************
-- **AP Suppliers
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIERS',
pt_fusion_template_name=> 'PozSuppliersInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUPPLIERS_INT',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ************************
-- **AP Suppliers Addresses
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_ADDRESSES',
pt_fusion_template_name=> 'PozSupplierAddressesInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUP_ADDRESSES_INT',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **AP Suppliers Sites
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_SITES',
pt_fusion_template_name=> 'PozSupplierSitesInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUPPLIER_SITES_INT',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **AP Suppliers Sites
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_THIRD_PARTY_RELS',
pt_fusion_template_name=> 'PozSupThirdPartyInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUP_THIRDPARTY_INT',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***********************
-- **AP Supplier Contacts
-- ***********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_CONTACTS',
pt_fusion_template_name=> 'PozSupContactsInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUP_CONTACTS_INT',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *******************************
-- **AP Supplier Contact Addresses
-- *******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_CONT_ADDRS',
pt_fusion_template_name=> 'PozSupContactAddressesInt.csv',
pt_fusion_template_sheet_name => 'POZ_SUP_CONTACT_ADDRESSES_INT',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ******************************
-- **AP Supplier Site Assignments
-- ******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_SITE_ASSIGNS',
pt_fusion_template_name=> 'PozSiteAssignmentsInt.csv',
pt_fusion_template_sheet_name => 'POZ_SITE_ASSIGNMENTS_INT',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *************************************
-- **AP Supplier Bank Accounts -- Payees
-- *************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_PAYEES',
pt_fusion_template_name=> 'IbyTempExtPayees.csv',
pt_fusion_template_sheet_name => 'IBY_TEMP_EXT_PAYEES',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **AP Supplier Bank Accounts
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_fusion_template_name=> 'IbyTempExtBankAccts.csv',
pt_fusion_template_sheet_name => 'IBY_TEMP_EXT_BANK_ACCTS',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ****************************************************
-- **AP Supplier Bank Accounts -- Payement Instructions
-- ****************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIER_PMT_INSTRS',
pt_fusion_template_name=> 'IbyTempPmtInstrUses.csv',
pt_fusion_template_sheet_name => 'IBY_TEMP_PMT_INSTR_USES',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/