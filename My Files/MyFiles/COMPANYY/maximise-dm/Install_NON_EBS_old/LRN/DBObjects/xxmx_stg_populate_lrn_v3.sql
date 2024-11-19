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
pt_i_SubEntity=> 'COURSE_V3',
pt_import_data_file_name => 'XXMX_OLC_COURSE_V3.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_V3.ctl',
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
pt_i_SubEntity=> 'COURSE_DEFAULT_ACCESS_V3',
pt_import_data_file_name => 'XXMX_OLC_COURSE_ACC_V3.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_ACC_V3.ctl',
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
pt_i_SubEntity=> 'OFFERING_V3',
pt_import_data_file_name => 'XXMX_OLC_OFFER_V3.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_V3.ctl',
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
pt_i_SubEntity=> 'EVALUATION_ACTIVITY_V3',
pt_import_data_file_name => 'XXMX_OLC_EVAL_ACT_V3.dat',
pt_control_file_name => 'XXMX_OLC_EVAL_ACT_V3.ctl',
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
pt_i_SubEntity=> 'OFFERING_ACTIVITY_SECTION_V3',
pt_import_data_file_name => 'XXMX_OLC_OFFER_ACT_V3.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_ACT_V3.ctl',
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
pt_i_SubEntity=> 'INSTRUCTOR_LED_ACTIVITY_V3',
pt_import_data_file_name => 'XXMX_OLC_INSTR_LED_V3.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_LED_V3.ctl',
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
pt_i_SubEntity=> 'ADHOC_RESOURCE_V3',
pt_import_data_file_name => 'XXMX_OLC_ADHOC_V3.dat',
pt_control_file_name => 'XXMX_OLC_ADHOC_V3.ctl',
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
pt_i_SubEntity=> 'CLASSROOM_RESERVATION_V3',
pt_import_data_file_name => 'XXMX_OLC_CLASS_RESV_V3.dat',
pt_control_file_name => 'XXMX_OLC_CLASS_RESV_V3.ctl',
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
pt_i_SubEntity=> 'INSTRUCTOR_RESERVATION_V3',
pt_import_data_file_name => 'XXMX_OLC_INSTR_RESV_V3.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_RESV_V3.ctl',
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
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_V3',
pt_import_data_file_name => 'XXMX_OLC_SELFPACE_V3.dat',
pt_control_file_name => 'XXMX_OLC_SELFPACE_V3.ctl',
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
pt_i_SubEntity=> 'OFFERING_DEFAULT_ACCESS_V3',
pt_import_data_file_name => 'XXMX_OLC_OFFER_ACC_V3.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_ACC_V3.ctl',
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
pt_i_SubEntity=> 'COURSE_V3_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_COURSE_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_COURSE_V3_TL.ctl',
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
pt_i_SubEntity=> 'OFFERING_V3_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_OFFER_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_V3_TL.ctl',
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
pt_i_SubEntity=> 'OFFER_ACT_SEC_V3_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_OFFER_ACT_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_OFFER_ACT_V3.ctl',
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
pt_i_SubEntity=> 'INSTR_LED_ACTIVITY_V3_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_INSTR_ACT_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_INSTR_ACT_V3_TL.ctl',
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
pt_i_SubEntity=> 'SELFPACED_ACTIVITY_V3_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_SELFPACE_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_SELFPACE_V3_TL.ctl',
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
pt_i_SubEntity=> 'EVALUATION_ACTIVITY_V3_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_EVAL_ACT_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_EVAL_ACT_V3_TL.ctl',
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
pt_i_SubEntity=> 'SPECIALIZATION_V3',
pt_import_data_file_name => 'XXMX_OLC_SPEC_V3.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_V3.ctl',
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
pt_i_SubEntity=> 'SPEC_DEFAULT_ACCESS_V3',
pt_import_data_file_name => 'XXMX_OLC_SPEC_DEF_ACC_V3.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_DEF_ACC_V3.ctl',
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
pt_i_SubEntity=> 'SPECIALIZATION_SECTION_V3',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN_V3.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN_V3.ctl',
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
pt_i_SubEntity=> 'SPEC_SECTION_ACTIVITY_V3',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN_ACT_V3.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN_ACT_V3.ctl',
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
pt_i_SubEntity=> 'SPECIALIZATION_V3_TRANSLATION',
pt_import_data_file_name => 'XXMX_OLC_SPEC_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_V3_TL.ctl',
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
pt_i_SubEntity=> 'SPECIALIZATION_V3_SXN_TRNSLN',
pt_import_data_file_name => 'XXMX_OLC_SPEC_SXN_V3_TL.dat',
pt_control_file_name => 'XXMX_OLC_SPEC_SXN_V3_TL.ctl',
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
pt_i_SubEntity=> 'LEARNING_RECORD_ACT_ATTEMPT_V3',
pt_import_data_file_name => 'XXMX_OLC_LEARN_RCD_ACT_V3.dat',
pt_control_file_name => 'XXMX_OLC_LEARN_RCD_ACT_V3.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/