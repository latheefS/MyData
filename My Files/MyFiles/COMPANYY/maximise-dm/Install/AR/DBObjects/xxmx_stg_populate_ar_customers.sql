--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change.csve  Changed By          Change Description
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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTIES',
pt_import_data_file_name => 'XXMX_HZ_PARTIES.csv',
pt_control_file_name => 'XXMX_HZ_PARTIES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *****************
-- **HZ Party Sites
-- *****************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_SITES',
pt_import_data_file_name => 'XXMX_HZ_PARTY_SITES.csv',
pt_control_file_name => 'XXMX_HZ_PARTY_SITES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *********************
-- **HZ Party Site Uses
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_SITES_USES',
pt_import_data_file_name => 'XXMX_HZ_PARTY_SITE_USES.csv',
pt_control_file_name => 'XXMX_HZ_PARTY_SITE_USES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Accounts
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_ACCOUNTS',
pt_import_data_file_name => 'XXMX_HZ_CUST_ACCOUNTS.csv',
pt_control_file_name => 'XXMX_HZ_CUST_ACCOUNTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Account Sites
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_ACCOUNTS_SITES',
pt_import_data_file_name => 'XXMX_HZ_CUST_ACCT_SITES.csv',
pt_control_file_name => 'XXMX_HZ_CUST_ACCT_SITES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *******************************
-- **HZ Customer Account Site Uses
-- *******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ACCOUNT_SITES_USES',
pt_import_data_file_name => 'XXMX_HZ_CUST_SITE_USES.csv',
pt_control_file_name => 'XXMX_HZ_CUST_SITE_USES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***********************************
-- **HZ Customer Account Relationships
-- ***********************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_ACCT_RELATIONSHIPS',
pt_import_data_file_name => 'XXMX_HZ_CUST_ACCT_RELATE.csv',
pt_control_file_name => 'XXMX_HZ_CUST_ACCT_RELATE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *********************
-- **HZ Account Contacts
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_ACCT_CONTACT',
pt_import_data_file_name => 'XXMX_HZ_CUST_ACCT_CONTACTS.csv',
pt_control_file_name => 'XXMX_HZ_CUST_ACCT_CONTACTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ****************************
-- **HZ Customer Contact Points
-- ****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CONTACT_POINTS',
pt_import_data_file_name => 'XXMX_HZ_CONTACT_POINTS.csv',
pt_control_file_name => 'XXMX_HZ_CONTACT_POINTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Contact Roles
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CONTACT_ROLES',
pt_import_data_file_name => 'XXMX_HZ_ORG_CONTACT_ROLES.csv',
pt_control_file_name => 'XXMX_HZ_ORG_CONTACT_ROLES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Contacts
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ORG_CONTACTS',
pt_import_data_file_name => 'XXMX_HZ_ORG_CONTACTS.csv',
pt_control_file_name => 'XXMX_HZ_ORG_CONTACTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **HZ Party Locations
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'LOCATIONS',
pt_import_data_file_name => 'XXMX_HZ_LOCATIONS.csv',
pt_control_file_name => 'XXMX_HZ_LOCATIONS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Relationships
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'RELATIONSHIPS',
pt_import_data_file_name => 'XXMX_HZ_RELATIONSHIPS.csv',
pt_control_file_name => 'XXMX_HZ_RELATIONSHIPS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ************************************************
-- **HZ Customer Account Roles and Responsibilities
-- ************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'ROLES_AND_RESPONSIBILITIES',
pt_import_data_file_name => 'XXMX_HZ_ROLE_RESPS.csv',
pt_control_file_name => 'XXMX_HZ_ROLE_RESPS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *****************************
-- **HZ Customer Classifications 
-- *****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PARTY_CLASSIFICATIONS',
pt_import_data_file_name => 'XXMX_HZ_PARTY_CLASSIFS.csv',
pt_control_file_name => 'XXMX_HZ_PARTY_CLASSIFS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ********************
-- **HZ Person Language
-- ********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'PERSON_LANGUAGE',
pt_import_data_file_name => 'XXMX_HZ_PERSON_LANGUAGE.csv',
pt_control_file_name => 'XXMX_HZ_PERSON_LANGUAGE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- **********************
-- **HZ Customer Profiles
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUSTOMER_PROFILES',
pt_import_data_file_name => 'XXMX_HZ_CUST_PROFILES.csv',
pt_control_file_name => 'XXMX_HZ_CUST_PROFILES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *****************************
-- **HZ Customer Receipt Methods
-- *****************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_RECEIPT_METHODS',
pt_import_data_file_name => 'XXMX_RA_CUST_RCPT_METHODS.csv',
pt_control_file_name => 'XXMX_RA_CUST_RCPT_METHODS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- ***************************
-- **HZ Customer Bank Accounts
-- ***************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'CUSTOMERS',
pt_i_SubEntity=> 'CUST_BANKS',
pt_import_data_file_name => 'XXMX_AR_CUST_BANKS.csv',
pt_control_file_name => 'XXMX_AR_CUST_BANKS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/