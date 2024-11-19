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
pt_i_SubEntity=> 'LEGACY_LEARNING_ITEM',
pt_fusion_template_name=> 'LegacyLearningItem.dat',
pt_fusion_template_sheet_name => 'LegacyLearningItem',
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
pt_i_SubEntity=> 'LEGACY_LEARNING_ITEM_TRANSLATION',
pt_fusion_template_name=> 'LegacyLearningItemTranslation.dat',
pt_fusion_template_sheet_name => 'LegacyLearningItemTranslation',
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
pt_i_SubEntity=> 'NON_CATALOG_LEARNING_ITEM',
pt_fusion_template_name=> 'NoncatalogLearningItem.dat',
pt_fusion_template_sheet_name => 'NoncatalogLearningItem',
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
pt_i_SubEntity=> 'NON_CATALOG_LEARNING_ITEM_TRANSLATION',
pt_fusion_template_name=> 'NoncatalogLearningItemTranslation.dat',
pt_fusion_template_sheet_name => 'NoncatalogLearningItemTranslation',
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
pt_i_SubEntity=> 'CLASSROOM_RESOURCE',
pt_fusion_template_name=> 'ClassroomResource.dat',
pt_fusion_template_sheet_name => 'ClassroomResource',
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
pt_i_SubEntity=> 'CLASSROOM_RESOURCE_TRANSLATION',
pt_fusion_template_name=> 'ClassroomResourceTranslation.dat',
pt_fusion_template_sheet_name => 'ClassroomResourceTranslation',
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
pt_i_SubEntity=> 'INSTRUCTOR_RESOURCE',
pt_fusion_template_name=> 'InstructorResource.dat',
pt_fusion_template_sheet_name => 'InstructorResource',
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
pt_i_SubEntity=> 'COURSE',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'Course',
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
pt_i_SubEntity=> 'OFFERING',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'Offering',
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
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'InstructorLedActivity',
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
pt_i_SubEntity=> 'ADHOC_RESOURCE',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'AdhocResource',
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
pt_i_SubEntity=> 'CLASSROOM_RESERVATION',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'ClassroomReservation',
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
pt_i_SubEntity=> 'INSTRUCTOR_RESERVATION',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'InstructorReservation',
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
pt_i_SubEntity=> 'SELFPACED_ACTIVITY',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'SelfPacedActivity',
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
pt_i_SubEntity=> 'OFFERING_DEFAULT_ACCESS',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'OfferingDefaultAccess',
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
pt_i_SubEntity=> 'COURSE_DEFAULT_ACCESS',
pt_fusion_template_name=> 'Course.dat',
pt_fusion_template_sheet_name => 'CourseDefaultAccess',
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
pt_i_SubEntity=> 'COURSE_TRANSLATION',
pt_fusion_template_name=> 'CourseTranslation.dat',
pt_fusion_template_sheet_name => 'CourseTranslation',
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
pt_i_SubEntity=> 'OFFERING_TRANSLATION',
pt_fusion_template_name=> 'OfferingTranslation.dat',
pt_fusion_template_sheet_name => 'OfferingTranslation',
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
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY_TRNSLN',
pt_fusion_template_name=> 'InstructorLedActivityTranslation.dat',
pt_fusion_template_sheet_name => 'InstructorLedActivityTranslation',
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
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_TRNSLN',
pt_fusion_template_name=> 'SelfPacedActivityTranslation.dat',
pt_fusion_template_sheet_name => 'SelfPacedActivityTranslation',
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
pt_i_SubEntity=> 'COURSE_OFFG_PRICING_DEFAULTS',
pt_fusion_template_name=> 'CourseOfferingPricingDefaults.dat',
pt_fusion_template_sheet_name => 'CourseOfferingPricingDefaults',
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
pt_i_SubEntity=> 'COURSE_OFFG_PRICING_COMPONENT',
pt_fusion_template_name=> 'CourseOfferingPricingDefaults.dat',
pt_fusion_template_sheet_name => 'CourseOfferingPricingComponent',
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
pt_i_SubEntity=> 'OFFERING_CUSTOM_PRICING',
pt_fusion_template_name=> 'OfferingCustomPricing.dat',
pt_fusion_template_sheet_name => 'OfferingCustomPricing',
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
pt_i_SubEntity=> 'OFFERING_CUSTOM_PRICING_COMPONENT',
pt_fusion_template_name=> 'OfferingCustomPricing.dat',
pt_fusion_template_sheet_name => 'OfferingCustomPricingComponent',
pt_fusion_template_sheet_order=>24,
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
pt_i_SubEntity=> 'SPECIALIZATION',
pt_fusion_template_name=> 'Specialization.dat',
pt_fusion_template_sheet_name => 'Specialization',
pt_fusion_template_sheet_order=>25,
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
pt_i_SubEntity=> 'SPECIALIZATION_SECTION',
pt_fusion_template_name=> 'Specialization.dat',
pt_fusion_template_sheet_name => 'SpecializationSection',
pt_fusion_template_sheet_order=>26,
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
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_ACTIVITY',
pt_fusion_template_name=> 'Specialization.dat',
pt_fusion_template_sheet_name => 'SpecializationSectionActivity',
pt_fusion_template_sheet_order=>27,
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
pt_i_SubEntity=> 'SPECIALIZATION_DEFAULT_ACCESS',
pt_fusion_template_name=> 'Specialization.dat',
pt_fusion_template_sheet_name => 'SpecializationDefaultAccess',
pt_fusion_template_sheet_order=>28,
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
pt_i_SubEntity=> 'SPECIALIZATION_TRANSLATION',
pt_fusion_template_name=> 'SpecializationTranslation.dat',
pt_fusion_template_sheet_name => 'SpecializationTranslation',
pt_fusion_template_sheet_order=>29,
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
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_TRNSLN',
pt_fusion_template_name=> 'SpecializationSectionTranslation.dat',
pt_fusion_template_sheet_name => 'SpecializationSectionTranslation',
pt_fusion_template_sheet_order=>30,
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
pt_i_SubEntity=> 'GLOBAL_ACCESS_GROUP_RELATION',
pt_fusion_template_name=> 'GlobalAccessGroupRelation.dat',
pt_fusion_template_sheet_name => 'GlobalAccessGroupRelation',
pt_fusion_template_sheet_order=>31,
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
pt_i_SubEntity=> 'COMMUNITY_RELATION',
pt_fusion_template_name=> 'CommunityRelation.dat',
pt_fusion_template_sheet_name => 'CommunityRelation',
pt_fusion_template_sheet_order=>32,
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
pt_i_SubEntity=> 'LEARNING_RECORD',
pt_fusion_template_name=> 'LearningRecord.dat',
pt_fusion_template_sheet_name => 'LearningRecord',
pt_fusion_template_sheet_order=>33,
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
pt_i_SubEntity=> 'LEARNING_RECORD_ACTIVITY_ATTEMPT',
pt_fusion_template_name=> 'LearningRecordActivityAttempt.dat',
pt_fusion_template_sheet_name => 'LearningRecordActivityAttempt',
pt_fusion_template_sheet_order=>34,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/