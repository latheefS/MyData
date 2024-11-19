--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------	
--**   1.0  22-SEP-2023  Soundarya Kamatagi   Added script for Bussiness-Entity 'GOAL PLAN SET'
--**
--******************************************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'GOAL_PLAN_SET',
pt_fusion_template_name=> 'GoalPlanSet.dat',
pt_fusion_template_sheet_name => 'GoalPlanSet',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'GOAL_PLAN_SET_PLAN ',
pt_fusion_template_name=> 'GoalPlanSet.dat',
pt_fusion_template_sheet_name => 'GoalPlanSetPlan',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST',
pt_fusion_template_name=> 'GoalPlanSet.dat',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'ELIGIBILITY_PROFILE_OBJECT',
pt_fusion_template_name=> 'GoalPlanSet.dat',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST_HIERARCHY',
pt_fusion_template_name=> 'GoalPlanSet.dat',
pt_fusion_template_sheet_name => 'MassRequestHierarchy',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST_EXEMPTION',
pt_fusion_template_name=> 'GoalPlanSet.dat',
pt_fusion_template_sheet_name => 'MassRequestExemption',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
