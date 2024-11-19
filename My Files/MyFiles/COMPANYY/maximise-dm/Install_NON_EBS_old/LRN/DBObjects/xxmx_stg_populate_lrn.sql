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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'LEGACY_LEARNING_ITEM',
pt_import_data_file_name => 'XXMX_OLC_LEG_LEARN.dat',
pt_control_file_name => 'XXMX_OLC_LEG_LEARN.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'LEGACY_LEARNING_ITEM_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_LEG_LEARN_TL.dat',
pt_control_file_name => 'XXMX_OLC_LEG_LEARN_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'NON_CATALOG_LEARNING_ITEM',
pt_import_data_file_name => 'XXMX_OLC_NONCAT_LEARN.dat',
pt_control_file_name => 'XXMX_OLC_NONCAT_LEARN.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'NON_CATALOG_LEARNING_ITEM_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_NONCAT_LEARN_TL.dat',
pt_control_file_name => 'XXMX_OLC_NONCAT_LEARN_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'CLASSROOM_RESOURCE',
pt_import_data_file_name => 'XXMX_OLC_CLASS_RES.dat',
pt_control_file_name => 'XXMX_OLC_CLASS_RES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'CLASSROOM_RESOURCE_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_CLASS_RES_TL.dat',
pt_control_file_name => 'XXMX_OLC_CLASS_RES_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_RESOURCE',
pt_import_data_file_name => 'XXMX_OLC_INSTR_RES.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_RES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE',
pt_import_data_file_name => 'XXMX_OLC_COURSE.dat',
pt_control_file_name => 'XXMX_OLC_COURSE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING',
pt_import_data_file_name => 'XXMX_OLC_OFFER.dat',
pt_control_file_name => 'XXMX_OLC_OFFER.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY',
pt_import_data_file_name => 'XXMX_OLC_INSTR_LED.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_LED.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'ADHOC_RESOURCE',
pt_import_data_file_name => 'XXMX_OLC_ADHOC.dat',
pt_control_file_name => 'XXMX_OLC_ADHOC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'CLASSROOM_RESERVATION',
pt_import_data_file_name => 'XXMX_OLC_CLASS_RESV.dat',
pt_control_file_name => 'XXMX_OLC_CLASS_RESV.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_RESERVATION',
pt_import_data_file_name => 'XXMX_OLC_INSTR_RESV.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_RESV.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SELFPACED_ACTIVITY',
pt_import_data_file_name => 'XXMX_OLC_SELFPACE.dat',
pt_control_file_name => 'XXMX_OLC_SELFPACE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_DEFAULT_ACCESS',
pt_import_data_file_name => 'XXMX_OLC_OFFER_ACC.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_ACC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_DEFAULT_ACCESS',
pt_import_data_file_name => 'XXMX_OLC_COURSE_ACC.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_ACC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_COURSE_TL.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_OFFER_TL.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_INSTR_ACT_TL.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_ACT_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_SELFPACE_TL.dat',
pt_control_file_name => 'XXMX_OLC_SELFPACE_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_OFFG_PRICING_DEFAULTS',
pt_import_data_file_name => 'XXMX_OLC_COURSE_PRICE.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_PRICE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COURSE_OFFG_PRICING_COMPONENT',
pt_import_data_file_name => 'XXMX_OLC_COURSE_PRICE_COMP.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_PRICE_COMP.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_CUSTOM_PRICING',
pt_import_data_file_name => 'XXMX_OLC_OFFER_CUST_PRICE.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_CUST_PRICE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'OFFERING_CUSTOM_PRICING_COMPONENT',
pt_import_data_file_name => 'XXMX_OLC_OFFER_CUST_PRICE_COMP.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_CUST_PRICE_COMP.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION',
pt_import_data_file_name => 'XXMX_OLC_SPEC.dat',
pt_control_file_name => 'XXMX_OLC_SPEC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_DEFAULT_ACCESS',
pt_import_data_file_name => 'XXMX_OLC_SPEC_DEF_ACC.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_DEF_ACC.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_SECTION',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_ACTIVITY',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN_ACT.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN_ACT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_SPEC_TL.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN_TL.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN_TL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'GLOBAL_ACCESS_GROUP_RELATION',
pt_import_data_file_name => 'XXMX_OLC_GLOB_ACC_GRP.dat',
pt_control_file_name => 'XXMX_OLC_GLOB_ACC_GRP.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'COMMUNITY_RELATION',
pt_import_data_file_name => 'XXMX_OLC_COMM_RS.dat',
pt_control_file_name => 'XXMX_OLC_COMM_RS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'LEARNING_RECORD',
pt_import_data_file_name => 'XXMX_OLC_LEARN_RCD.dat',
pt_control_file_name => 'XXMX_OLC_LEARN_RCD.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'OLC',
pt_i_Application=> 'LRN',
pt_i_BusinessEntity=> 'LEARNING',
pt_i_SubEntity=> 'LEARNING_RECORD_ACTIVITY_ATTEMPT',
pt_import_data_file_name => 'XXMX_OLC_LEARN_RCD_ACT_ATT.dat',
pt_control_file_name => 'XXMX_OLC_LEARN_RCD_ACT_ATT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/