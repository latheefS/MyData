--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  23-FEB-2022  Shireesha TR        Created.
--**   2.0  13-JAN-2023  Ayush Rathore		 Added script for Sub-Entity 'Workrelationship'
--**   3.0  29-MAY-2023  Soundarya Kamatagi   Added script for Bus-Entity 'Location'
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
pt_import_data_file_name => 'XXMX_BANKS_STG.csv',
pt_control_file_name => 'XXMX_BANKS_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_THIRD_ORG.csv',
pt_control_file_name => 'XXMX_THIRD_ORG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_PERSONS_STG.csv',
pt_control_file_name => 'XXMX_PER_PERSONS_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_NID_F_STG.csv',
pt_control_file_name => 'XXMX_PER_NID_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_THIRD_ADDR.csv',
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
pt_import_data_file_name => 'XXMX_BANK_BRANCHES_STG.csv',
pt_control_file_name => 'XXMX_BANK_BRANCHES_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_CONTACTS_STG.csv',
pt_control_file_name => 'XXMX_PER_CONTACTS_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_i_SubEntity=> 'CONTACT_NAME',
pt_import_data_file_name => 'XXMX_PER_CONTACT_NAMES_STG.csv',
pt_control_file_name => 'XXMX_PER_CONTACT_NAMES_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_THIRD_PAYMTHD.csv',
pt_control_file_name => 'XXMX_THIRD_PAYMTHD.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ADDRESS_F_STG.csv',
pt_control_file_name => 'XXMX_PER_ADDRESS_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ADDR_USG_F_STG.csv',
pt_control_file_name => 'XXMX_PER_ADDR_USG_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_NAMES_F_STG.csv',
pt_control_file_name => 'XXMX_PER_NAMES_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_RELIGION_STG.csv',
pt_control_file_name => 'XXMX_PER_RELIGION_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_DISABILITY_STG.csv',
pt_control_file_name => 'XXMX_PER_DISABILITY_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_IMAGES_STG.csv',
pt_control_file_name => 'XXMX_PER_IMAGES_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_VISA_F_STG.csv',
pt_control_file_name => 'XXMX_PER_VISA_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_SENIORITYDT_STG.csv',
pt_control_file_name => 'XXMX_PER_SENIORITYDT_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ABSENCE_STG.csv',
pt_control_file_name => 'XXMX_PER_ABSENCE_STG.ctl',
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
pt_import_data_file_name => 'XXMX_PER_MAT_ABSENCE_STG.csv',
pt_control_file_name => 'XXMX_PER_MAT_ABSENCE_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_LEG_F_STG.csv',
pt_control_file_name => 'XXMX_PER_LEG_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ETHNICITIES_STG.csv',
pt_control_file_name => 'XXMX_PER_ETHNICITIES_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_PHONES_STG.csv',
pt_control_file_name => 'XXMX_PER_PHONES_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_CITIZENSHIPS_STG.csv',
pt_control_file_name => 'XXMX_CITIZENSHIPS_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_EMAIL_F_STG.csv',
pt_control_file_name => 'XXMX_PER_EMAIL_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_POS_WR_STG.csv',
pt_control_file_name => 'XXMX_PER_POS_WR_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ASSIGNMENTS_M_STG.csv',
pt_control_file_name => 'XXMX_PER_ASSIGNMENTS_M_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ASG_SUP_F_STG.csv',
pt_control_file_name => 'XXMX_PER_ASG_SUP_F_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_PASSPORT_STG.csv',
pt_control_file_name => 'XXMX_PER_PASSPORT_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_ASG_PAYROLL_STG.csv',
pt_control_file_name => 'XXMX_ASG_PAYROLL_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_PAY_METHOD_STG.csv',
pt_control_file_name => 'XXMX_PER_PAY_METHOD_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_ASG_WORKMSURE_STG.csv',
pt_control_file_name => 'XXMX_ASG_WORKMSURE_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_ASG_SALARY_STG.csv',
pt_control_file_name => 'XXMX_PER_ASG_SALARY_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_ASG_GRADESTEP_STG.csv',
pt_control_file_name => 'XXMX_ASG_GRADESTEP_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_EXT_BANK_ACC_STG.csv',
pt_control_file_name => 'XXMX_EXT_BANK_ACC_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_CONTACT_REL_STG.csv',
pt_control_file_name => 'XXMX_PER_CONTACT_REL_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_CONTACT_ADDR_STG.csv',
pt_control_file_name => 'XXMX_PER_CONTACT_ADDR_STG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_PER_CONTACT_PHONE_STG.csv',
pt_control_file_name => 'XXMX_PER_CONTACT_PHONE_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

--** START of code: sub entity added by Ayush Rathore --
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_WORKRELATIONSHIP',
pt_import_data_file_name => 'XXMX_PER_WORKREL_STG.csv',
pt_control_file_name => 'XXMX_PER_WORKREL_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
--** END of code: sub entity added by Ayush Rathore --
/




--** START of code: HR Location added by Soundarya Kamatagi --
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'LOCATION',
pt_i_SubEntity=> 'LOCATION',
pt_import_data_file_name => 'XXMX_HCM_HR_LOCATION_STG.csv',
pt_control_file_name => 'XXMX_HCM_HR_LOCATION_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
--** END of code: HR Location added by Soundarya Kamatagi  --
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'ABSENCE_ACCRUAL',
pt_import_data_file_name => 'XXMX_PER_ABSENCE_ACCRUAL_STG.csv',
pt_control_file_name => 'XXMX_PER_ABSENCE_ACCRUAL_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'WORK_SCHEDULE',
pt_import_data_file_name => 'XXMX_PER_ASG_WORK_SCH_STG.csv',
pt_control_file_name => 'XXMX_PER_ASG_WORK_SCH_STG.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

Commit;
/