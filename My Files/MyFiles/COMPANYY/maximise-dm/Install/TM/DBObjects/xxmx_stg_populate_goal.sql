--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------	
--**   1.0  14-SEP-2023  Soundarya Kamatagi   Added script for Sub-Entity 'Goal'
--**
--******************************************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL',
pt_import_data_file_name => 'XXMX_HCM_GOAL.dat',
pt_control_file_name => 'XXMX_HCM_GOAL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ACCESS',
pt_import_data_file_name => 'XXMX_GOAL_ACCESS.dat',
pt_control_file_name => 'XXMX_GOAL_ACCESS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ACTION',
pt_import_data_file_name => 'XXMX_GOAL_ACTION.dat',
pt_control_file_name => 'XXMX_GOAL_ACTION.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ALIGNMENT',
pt_import_data_file_name => 'XXMX_GOAL_ALIGNMENT.dat',
pt_control_file_name => 'XXMX_GOAL_ALIGNMENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_MEASUREMENT',
pt_import_data_file_name => 'XXMX_GOAL_MEASUREMENT.dat',
pt_control_file_name => 'XXMX_GOAL_MEASUREMENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;


/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_PLAN_GOAL',
pt_import_data_file_name => 'XXMX_GOAL_PLAN_GOAL.dat',
pt_control_file_name => 'XXMX_GOAL_PLAN_GOAL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_TARGET_OUTCOME',
pt_import_data_file_name => 'XXMX_GTARGET_OUTCOME.dat',
pt_control_file_name => 'XXMX_GTARGET_OUTCOME.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;



/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_TARGET_OUTCOME_PROFILE_ITEM',
pt_import_data_file_name => 'XXMX_GTARGT_OUTCME_PROFILE_ITM.dat',
pt_control_file_name => 'XXMX_GTARGT_OUTCME_PROFILE_ITM.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

