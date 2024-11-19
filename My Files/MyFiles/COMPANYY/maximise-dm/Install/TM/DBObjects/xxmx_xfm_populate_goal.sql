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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'Goal',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ACCESS',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalAccess',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ACTION',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalAction',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_ALIGNMENT',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalAlignment',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_MEASUREMENT',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalMeasurement',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_PLAN_GOAL',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalPlanGoal',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_TARGET_OUTCOME',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalTargetOutcome',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL',
pt_i_SubEntity=> 'GOAL_TARGET_OUTCOME_PROFILE_ITEM',
pt_fusion_template_name=> 'Goal.dat',
pt_fusion_template_sheet_name => 'GoalTargetOutcomeProfileItem',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
