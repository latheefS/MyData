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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIERS',
pt_i_SubEntity=> 'SUPPLIERS',
pt_import_data_file_name => 'XXMX_AP_SUPPLIERS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPPLIERS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_ADDRESSES',
pt_i_SubEntity=> 'SUPPLIER_ADDRESSES',
pt_import_data_file_name => 'XXMX_AP_SUPP_ADDRS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_ADDRS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_SITES',
pt_i_SubEntity=> 'SUPPLIER_SITES',
pt_import_data_file_name=> 'XXMX_AP_SUPPLIER_SITES_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPPLIER_SITES_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_SITES',
pt_i_SubEntity=> 'SUPPLIER_THIRD_PARTY_RELS',
pt_import_data_file_name=> 'XXMX_AP_SUPP_3RD_PTY_RELS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_3RD_PTY_RELS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_CONTACT',
pt_i_SubEntity=> 'SUPPLIER_CONTACTS',
pt_import_data_file_name => 'XXMX_AP_SUPP_CONTACTS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_CONTACTS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_CONTACT',
pt_i_SubEntity=> 'SUPPLIER_CONT_ADDRS',
pt_import_data_file_name => 'XXMX_AP_SUPP_CONT_ADDRS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_CONT_ADDRS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_SITE_ASSIGNS',
pt_i_SubEntity=> 'SUPPLIER_SITE_ASSIGNS',
pt_import_data_file_name => 'XXMX_AP_SUPP_SITE_ASSIGNS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_SITE_ASSIGNS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_i_SubEntity=> 'SUPPLIER_PAYEES',
pt_import_data_file_name => 'XXMX_AP_SUPP_PAYEES_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_PAYEES_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_i_SubEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_import_data_file_name => 'XXMX_AP_SUPP_BANK_ACCTS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_BANK_ACCTS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AP',
pt_i_BusinessEntity=> 'SUPPLIER_BANK_ACCOUNTS',
pt_i_SubEntity=> 'SUPPLIER_PMT_INSTRS',
pt_import_data_file_name => 'XXMX_AP_SUPP_PMT_INSTRS_STG.csv',
pt_control_file_name => 'XXMX_AP_SUPP_PMT_INSTRS_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
