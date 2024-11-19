--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------	
--**   1.0  15-SEP-2023  Soundarya Kamatagi   Added script for Bus-Entity 'Goal Plan'
--**
--******************************************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL_PLAN',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'GoalPlan',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL_PLAN_GOAL',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'GoalPlanGoal',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS_REQUEST',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'MassRequest',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'ELIGIBILITY_PROFILE_OBJECT',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'EligibilityProfileObject',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS_REQUEST_ASSIGNMENT',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'MassRequestAssignment',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS_REQUEST_HIERARCHY',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'MassRequestHierarchy',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS_REQUEST_EXEMPTION',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'MassRequestExemption',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'Goal_Plan_Doc_Types',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'GoalPlanDocTypes',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'Goal_Plan_Assignment',
pt_fusion_template_name=> 'GoalPlan.dat',
pt_fusion_template_sheet_name => 'GoalPlanAssignment',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/