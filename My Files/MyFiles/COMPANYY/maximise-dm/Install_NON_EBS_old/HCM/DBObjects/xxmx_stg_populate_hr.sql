--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  23-FEB-2022  Shireesha TR        Created.
--**
--******************************************************************************
--
--

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'BANKS_AND_BRANCHES',
pt_i_SubEntity=> 'BANKS',
pt_import_data_file_name => 'XXMX_BANKS.dat',
pt_control_file_name => 'XXMX_BANKS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'ORGANIZATION',
pt_i_SubEntity=> 'THIRD_PARTY_ORG',
pt_import_data_file_name => 'XXMX_THIRD_ORG.dat',
pt_control_file_name => 'XXMX_THIRD_ORG.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON',
pt_import_data_file_name => 'XXMX_PER_PERSONS.dat',
pt_control_file_name => 'XXMX_PER_PERSONS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_NID',
pt_import_data_file_name => 'XXMX_PER_NID_F.dat',
pt_control_file_name => 'XXMX_PER_NID_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'ORGANIZATION',
pt_i_SubEntity=> 'THIRD_PARTY_ADDR',
pt_import_data_file_name => 'XXMX_THIRD_ADDR.dat',
pt_control_file_name => 'XXMX_THIRD_ADDR.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'BANKS_AND_BRANCHES',
pt_i_SubEntity=> 'BANK_BRANCHES',
pt_import_data_file_name => 'XXMX_BANK_BRANCHES.dat',
pt_control_file_name => 'XXMX_BANK_BRANCHES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_CONTACTS',
pt_import_data_file_name => 'XXMX_PER_CONTACTS.dat',
pt_control_file_name => 'XXMX_PER_CONTACTS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'ORGANIZATION',
pt_i_SubEntity=> 'THIRD_PARTY_PYMTHD',
pt_import_data_file_name => 'XXMX_THIRD_PAYMTHD.dat',
pt_control_file_name => 'XXMX_THIRD_PAYMTHD.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ADDRESS',
pt_import_data_file_name => 'XXMX_PER_ADDRESS_F.dat',
pt_control_file_name => 'XXMX_PER_ADDRESS_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ADDRESS_USAGE',
pt_import_data_file_name => 'XXMX_PER_ADDR_USG_F.dat',
pt_control_file_name => 'XXMX_PER_ADDR_USG_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_NAMES',
pt_import_data_file_name => 'XXMX_PER_NAMES_F.dat',
pt_control_file_name => 'XXMX_PER_NAMES_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_RELIGION',
pt_import_data_file_name => 'XXMX_PER_RELIGION.dat',
pt_control_file_name => 'XXMX_PER_RELIGION.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_DISABILITY',
pt_import_data_file_name => 'XXMX_PER_DISABILITY.dat',
pt_control_file_name => 'XXMX_PER_DISABILITY.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_IMAGES',
pt_import_data_file_name => 'XXMX_PER_IMAGES.dat',
pt_control_file_name => 'XXMX_PER_IMAGES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_VISA',
pt_import_data_file_name => 'XXMX_PER_VISA_F.dat',
pt_control_file_name => 'XXMX_PER_VISA_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_SENIORITYDT',
pt_import_data_file_name => 'XXMX_PER_SENIORITYDT.dat',
pt_control_file_name => 'XXMX_PER_SENIORITYDT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ABSENCE',
pt_import_data_file_name => 'XXMX_PER_ABSENCE.dat',
pt_control_file_name => 'XXMX_PER_ABSENCE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_MAT_ABSENCE',
pt_import_data_file_name => 'XXMX_PER_MAT_ABSENCE.dat',
pt_control_file_name => 'XXMX_PER_MAT_ABSENCE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_LEGISLATIVE',
pt_import_data_file_name => 'XXMX_PER_LEG_F.dat',
pt_control_file_name => 'XXMX_PER_LEG_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ETHNICITIES',
pt_import_data_file_name => 'XXMX_PER_ETHNICITIES.dat',
pt_control_file_name => 'XXMX_PER_ETHNICITIES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_PHONE',
pt_import_data_file_name => 'XXMX_PER_PHONES.dat',
pt_control_file_name => 'XXMX_PER_PHONES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PER_CITIZENSHIPS',
pt_import_data_file_name => 'XXMX_CITIZENSHIPS.dat',
pt_control_file_name => 'XXMX_CITIZENSHIPS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_EMAIL',
pt_import_data_file_name => 'XXMX_PER_EMAIL_F.dat',
pt_control_file_name => 'XXMX_PER_EMAIL_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_POS',
pt_import_data_file_name => 'XXMX_PER_POS_WR.dat',
pt_control_file_name => 'XXMX_PER_POS_WR.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_ASSIGNMENTS',
pt_import_data_file_name => 'XXMX_PER_ASSIGNMENTS_M.dat',
pt_control_file_name => 'XXMX_PER_ASSIGNMENTS_M.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_ASG_SUPERVISOR',
pt_import_data_file_name => 'XXMX_PER_ASG_SUP_F.dat',
pt_control_file_name => 'XXMX_PER_ASG_SUP_F.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_PASSPORT',
pt_import_data_file_name => 'XXMX_PER_PASSPORT.dat',
pt_control_file_name => 'XXMX_PER_PASSPORT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSGINMENT_PAYROLL',
pt_import_data_file_name => 'XXMX_ASG_PAYROLL.dat',
pt_control_file_name => 'XXMX_ASG_PAYROLL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_PAYMENT_METHOD',
pt_import_data_file_name => 'XXMX_PER_PAY_METHOD.dat',
pt_control_file_name => 'XXMX_PER_PAY_METHOD.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSIGNMENT_WRKMSURE',
pt_import_data_file_name => 'XXMX_ASG_WORKMSURE.dat',
pt_control_file_name => 'XXMX_ASG_WORKMSURE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASG_SALARY',
pt_import_data_file_name => 'XXMX_PER_ASG_SALARY.dat',
pt_control_file_name => 'XXMX_PER_ASG_SALARY.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSIGNMENT_GRADESTEP',
pt_import_data_file_name => 'XXMX_ASG_GRADESTEP.dat',
pt_control_file_name => 'XXMX_ASG_GRADESTEP.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'EXTERNAL_BANK_ACCOUNTS',
pt_import_data_file_name => 'XXMX_EXT_BANK_ACC.dat',
pt_control_file_name => 'XXMX_EXT_BANK_ACC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_RELATIONSHIP',
pt_import_data_file_name => 'XXMX_PER_CONTACT_REL.dat',
pt_control_file_name => 'XXMX_PER_CONTACT_REL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_ADDRESS',
pt_import_data_file_name => 'XXMX_PER_CONTACT_ADDR.dat',
pt_control_file_name => 'XXMX_PER_CONTACT_ADDR.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_PHONE',
pt_import_data_file_name => 'XXMX_PER_CONTACT_PHONE.dat',
pt_control_file_name => 'XXMX_PER_CONTACT_PHONE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

Commit;
/