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

-- *****************
-- **HZ Parties
-- *****************
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTIES',
pt_fusion_template_name=> 'HzImpPartiesT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_PARTIES_T',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *****************
-- **HZ Party Sites
-- *****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_SITES',
pt_fusion_template_name=> 'HzImpPartySitesT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_PARTYSITES_T',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *********************
-- **HZ Party Site Uses
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_SITES_USES',
pt_fusion_template_name=> 'HzImpPartySiteUsesT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_PARTYSITEUSES_T',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Accounts
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_ACCOUNTS',
pt_fusion_template_name=> 'HzImpAccountsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ACCOUNTS_T',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Account Sites
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_ACCOUNTS_SITES',
pt_fusion_template_name=> 'HzImpAcctSitesT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ACCTSITES_T',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *******************************
-- **HZ Customer Account Site Uses
-- *******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ACCOUNT_SITES_USES',
pt_fusion_template_name=> 'HzImpAcctSiteUsesT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ACCTSITEUSES_T',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***********************************
-- **HZ Customer Account Relationships
-- ***********************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_ACCT_RELATIONSHIPS',
pt_fusion_template_name=> 'HzImpAccountRels.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ACCOUNTRELS',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *********************
-- **HZ Account Contacts
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_ACCT_CONTACT',
pt_fusion_template_name=> 'HzImpAcctContactsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ACCTCONTACTS_T',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ****************************
-- **HZ Customer Contact Points
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CONTACT_POINTS',
pt_fusion_template_name=> 'HzImpContactPtsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_CONTACTPTS_T',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Contact Roles
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CONTACT_ROLES',
pt_fusion_template_name=> 'HzImpContactRoles.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_CONTACTROLES',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Contacts
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ORG_CONTACTS',
pt_fusion_template_name=> 'HzImpContactsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_CONTACTS_T',
pt_fusion_template_sheet_order=>11,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **HZ Party Locations
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'LOCATIONS',
pt_fusion_template_name=> 'HzImpLocationsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_LOCATIONS_T',
pt_fusion_template_sheet_order=>12,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Relationships
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'RELATIONSHIPS',
pt_fusion_template_name=> 'HzImpRelshipsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_RELSHIPS_T',
pt_fusion_template_sheet_order=>13,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ************************************************
-- **HZ Customer Account Roles and Responsibilities
-- ************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ROLES_AND_RESPONSIBILITIES',
pt_fusion_template_name=> 'HzImpRoleResp.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_ROLERESP',
pt_fusion_template_sheet_order=>14,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *****************************
-- **HZ Customer Classifications 
-- *****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_CLASSIFICATIONS',
pt_fusion_template_name=> 'HzImpClassificsT.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_CLASSIFICS_T',
pt_fusion_template_sheet_order=>15,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **HZ Person Language
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PERSON_LANGUAGE',
pt_fusion_template_name=> 'HzImpPersonLang.csv',
pt_fusion_template_sheet_name => 'HZ_IMP_PERSONLANG',
pt_fusion_template_sheet_order=>16,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Profiles
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_PROFILES',
pt_fusion_template_name=> 'RaCustomerProfilesIntAll.csv',
pt_fusion_template_sheet_name => 'RA_CUSTOMER_PROFILES_INT_ALL',
pt_fusion_template_sheet_order=>17,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *****************************
-- **HZ Customer Receipt Methods
-- *****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_RECEIPT_METHODS',
pt_fusion_template_name=> 'RaCustPayMethodIntAll.csv',
pt_fusion_template_sheet_name => 'RA_CUST_PAY_METHOD_INT_ALL',
pt_fusion_template_sheet_order=>18,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Bank Accounts
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_BANKS',
pt_fusion_template_name=> 'RaCustomerBanksIntAll.csv',
pt_fusion_template_sheet_name => 'RA_CUSTOMER_BANKS_INT_ALL',
pt_fusion_template_sheet_order=>19,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/