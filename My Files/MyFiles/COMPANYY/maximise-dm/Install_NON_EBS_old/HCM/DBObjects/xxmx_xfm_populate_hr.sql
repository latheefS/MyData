--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  24-FEB-2022  Shireesha TR        Created.
--**
--******************************************************************************
--
--

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'BANKS_AND_BRANCHES',
pt_i_SubEntity=> 'BANKS',
pt_fusion_template_name=> 'Bank.dat',
pt_fusion_template_sheet_name => 'Bank',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'BANKS_AND_BRANCHES',
pt_i_SubEntity=> 'BANK_BRANCHES',
pt_fusion_template_name=> 'BankBranch.dat',
pt_fusion_template_sheet_name => 'BankBranch',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'ORGANIZATION',
pt_i_SubEntity=> 'THIRD_PARTY_PYMTHD', 
pt_fusion_template_name=> 'ThirdPartyOrganizationPaymentMethod.dat',
pt_fusion_template_sheet_name => 'ThirdPartyOrganizationPaymentMethod',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'Person',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_EMAIL',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonEmail',
pt_fusion_template_sheet_order=>11,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PER_CITIZENSHIPS',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonCitizenship',
pt_fusion_template_sheet_order=>12,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ETHNICITIES',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonEthnicity',
pt_fusion_template_sheet_order=>13,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_LEGISLATIVE',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonLegislative',
pt_fusion_template_sheet_order=>14,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_MAT_ABSENCE',
pt_fusion_template_name=> 'PersonAbsenceEntry.dat',
pt_fusion_template_sheet_name => 'PersonMaternityAbsenceEntry',
pt_fusion_template_sheet_order=>15,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ABSENCE',
pt_fusion_template_name=> 'PersonAbsenceEntry.dat',
pt_fusion_template_sheet_name => 'PersonAbsenceEntry',
pt_fusion_template_sheet_order=>16,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_VISA',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonVisa',
pt_fusion_template_sheet_order=>14,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_IMAGES',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonImage',
pt_fusion_template_sheet_order=>17,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_DISABILITY',
pt_fusion_template_name=> 'PersonDisability.dat',
pt_fusion_template_sheet_name => 'PersonDisability',
pt_fusion_template_sheet_order=>18,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_PHONE',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonPhone',
pt_fusion_template_sheet_order=>19,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_PHONE',
pt_fusion_template_name=> 'Contact.dat',
pt_fusion_template_sheet_name => 'ContactPhone',
pt_fusion_template_sheet_order=>20,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_NID',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonNationalIdentifier',
pt_fusion_template_sheet_order=>21,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_PASSPORT',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonPassport',
pt_fusion_template_sheet_order=>22,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_CONTACTS',
pt_fusion_template_name=> 'Contact.dat',
pt_fusion_template_sheet_name => 'Contact',
pt_fusion_template_sheet_order=>24,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_ADDRESS',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonAddress',
pt_fusion_template_sheet_order=>24,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_NAMES',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonName',
pt_fusion_template_sheet_order=>26,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'PERSON_RELIGION',
pt_fusion_template_name=> 'Worker.dat',
pt_fusion_template_sheet_name => 'PersonReligion',
pt_fusion_template_sheet_order=>27,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_RELATIONSHIP',
pt_fusion_template_name=> 'Contact.dat',
pt_fusion_template_sheet_name => 'ContactRelationship',
pt_fusion_template_sheet_order=>27,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'PERSON',
pt_i_SubEntity=> 'CONTACT_ADDRESS',
pt_fusion_template_name=> 'Contact.dat',
pt_fusion_template_sheet_name => 'ContactAddress',
pt_fusion_template_sheet_order=>28,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'EXTERNAL_BANK_ACCOUNTS',
pt_fusion_template_name=> 'ExternalBankAccount.dat', 
pt_fusion_template_sheet_name => 'ExternalBankAccount',
pt_fusion_template_sheet_order=>30,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSIGNMENT_GRADESTEP',
pt_fusion_template_name=> 'WorkerCurrent.dat', 
pt_fusion_template_sheet_name => 'AssignmentGradeSteps',
pt_fusion_template_sheet_order=>31,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSIGNMENT_WRKMSURE',
pt_fusion_template_name=> 'WorkerCurrent.dat', 
pt_fusion_template_sheet_name => 'AssignmentWorkMeasure',
pt_fusion_template_sheet_order=>32,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_ASG_SUPERVISOR',
pt_fusion_template_name=> 'AssignmentSupervisor.dat', 
pt_fusion_template_sheet_name => 'AssignmentSupervisor',
pt_fusion_template_sheet_order=>33,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_PAYMENT_METHOD',
pt_fusion_template_name=> 'PersonalPaymentMethod.dat', 
pt_fusion_template_sheet_name => 'PersonalPaymentMethod',
pt_fusion_template_sheet_order=>35,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASSGINMENT_PAYROLL',
pt_fusion_template_name=> 'AssignedPayroll.dat', 
pt_fusion_template_sheet_name => 'AssignedPayroll',
pt_fusion_template_sheet_order=>36,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_ASSIGNMENTS',
pt_fusion_template_name=> 'Worker.dat', 
pt_fusion_template_sheet_name => 'Assignment',
pt_fusion_template_sheet_order=>37,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_POS',
pt_fusion_template_name=> 'Worker.dat', 
pt_fusion_template_sheet_name => 'WorkRelationship',
pt_fusion_template_sheet_order=>38,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'PERSON_SENIORITYDT',
pt_fusion_template_name=> 'Worker.dat', 
pt_fusion_template_sheet_name => 'PersonSeniorityDate',
pt_fusion_template_sheet_order=>39,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'WORKER',
pt_i_SubEntity=> 'ASG_SALARY',
pt_fusion_template_name=> 'Salary.dat', 
pt_fusion_template_sheet_name => 'Salary',
pt_fusion_template_sheet_order=>40,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
