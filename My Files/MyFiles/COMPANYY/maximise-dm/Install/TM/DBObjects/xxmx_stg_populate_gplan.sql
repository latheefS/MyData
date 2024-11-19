--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------	
--**   1.0  15-SEP-2023  Soundarya Kamatagi   Added script for Sub-Entity 'Goal Plan'
--**
--******************************************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL_PLAN',
pt_import_data_file_name => 'XXMX_HCM_GPLAN.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL PLAN GOAL',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_GP_GOALS.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_GP_GOALS.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS REQUEST',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_MASS_REQ.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_MASS_REQ.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'ELIGIBILITY PROFILE OBJECT',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_EO_PROF.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_EO_PROF.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS REQUEST ASSIGNMENT',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_MR_ASGN.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_MR_ASGN.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS REQUEST HIERARCHY',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_MR_HIER.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_MR_HIER.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'MASS REQUEST EXEMPTION',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_MR_EXEM.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_MR_EXEM.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL PLAN DOC TYPES',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_DTYPE.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_DTYPE.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN',
pt_i_SubEntity=> 'GOAL_PLAN_ASSIGNMENT',
pt_import_data_file_name => 'XXMX_HCM_GPLAN_ASGN.dat',
pt_control_file_name => 'XXMX_HCM_GPLAN_ASGN.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
