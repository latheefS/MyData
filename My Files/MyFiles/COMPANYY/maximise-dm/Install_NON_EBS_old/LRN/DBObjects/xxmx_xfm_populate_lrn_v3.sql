--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  18-FEB-2022  Shireesha TR        Created.
--**
--******************************************************************************
--
--

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'CourseV3',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_DEFAULT_ACCESS_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'CourseDefaultAccessV3',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'OfferingV3',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'EVALUATION_ACTIVITY_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'EvaluationActivityV3',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_ACTIVITY_SECTION_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'OfferingActivitySectionV3',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'InstructorLedActivityV3',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'ADHOC_RESOURCE_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'AdhocResourceV3',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'CLASSROOM_RESERVATION_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'ClassroomReservationV3',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_RESERVATION_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'InstructorReservationV3',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'SelfPacedActivityV3',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_DEFAULT_ACCESS_V3',
pt_fusion_template_name=> 'CourseV3.dat',
pt_fusion_template_sheet_name => 'OfferingDefaultAccessV3',
pt_fusion_template_sheet_order=>11,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_V3_TRANSLATION',
pt_fusion_template_name=> 'CourseV3Translation.dat',
pt_fusion_template_sheet_name => 'CourseV3Translation',
pt_fusion_template_sheet_order=>12,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_V3_TRANSLATION',
pt_fusion_template_name=> 'OfferingV3Translation.dat',
pt_fusion_template_sheet_name => 'OfferingV3Translation',
pt_fusion_template_sheet_order=>13,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFER_ACT_SEC_V3_TRNSLN',
pt_fusion_template_name=> 'OfferingActivitySectionV3Translation.dat',
pt_fusion_template_sheet_name => 'OfferingActivitySectionV3Translation',
pt_fusion_template_sheet_order=>14,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTR_LED_ACTIVITY_V3_TRNSLN',
pt_fusion_template_name=> 'InstructorLedActivityV3Translation.dat',
pt_fusion_template_sheet_name => 'InstructorLedActivityV3Translation',
pt_fusion_template_sheet_order=>15,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_V3_TRNSLN',
pt_fusion_template_name=> 'SelfPacedActivityV3Translation.dat',
pt_fusion_template_sheet_name => 'SelfPacedActivityV3Translation',
pt_fusion_template_sheet_order=>16,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'EVALUATION_ACTIVITY_V3_TRNSLN',
pt_fusion_template_name=> 'EvaluationActivityV3Translation.dat',
pt_fusion_template_sheet_name => 'EvaluationActivityV3Translation',
pt_fusion_template_sheet_order=>17,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_V3',
pt_fusion_template_name=> 'SpecializationV3.dat',
pt_fusion_template_sheet_name => 'SpecializationV3',
pt_fusion_template_sheet_order=>18,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPEC_DEFAULT_ACCESS_V3',
pt_fusion_template_name=> 'SpecializationV3.dat',
pt_fusion_template_sheet_name => 'SpecializationDefaultAccessV3',
pt_fusion_template_sheet_order=>19,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_V3',
pt_fusion_template_name=> 'SpecializationV3.dat',
pt_fusion_template_sheet_name => 'SpecializationSectionV3',
pt_fusion_template_sheet_order=>20,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPEC_SECTION_ACTIVITY_V3',
pt_fusion_template_name=> 'SpecializationV3.dat',
pt_fusion_template_sheet_name => 'SpecializationSectionActivityV3',
pt_fusion_template_sheet_order=>21,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_V3_TRANSLATION',
pt_fusion_template_name=> 'SpecializationV3Translation.dat',
pt_fusion_template_sheet_name => 'SpecializationV3Translation',
pt_fusion_template_sheet_order=>22,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_V3_SXN_TRNSLN',
pt_fusion_template_name=> 'SpecializationSectionV3Translation.dat',
pt_fusion_template_sheet_name => 'SpecializationSectionV3Translation',
pt_fusion_template_sheet_order=>23,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'LEARNING_RECORD_ACT_ATTEMPT_V3',
pt_fusion_template_name=> 'LearningRecordActivityAttemptV3.dat',
pt_fusion_template_sheet_name => 'LearningRecordActivityAttemptV3',
pt_fusion_template_sheet_order=>24,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/