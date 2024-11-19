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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'GOAL_PLAN_SET',
pt_import_data_file_name => 'XXMX_HCM_GPSET.dat',
pt_control_file_name => 'XXMX_HCM_GPSET.ctl',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'GOAL_PLAN_SET_PLAN ',
pt_import_data_file_name => 'XXMX_HCM_GPSET_PLAN.dat',
pt_control_file_name => 'XXMX_HCM_GPSET_PLAN.ctl',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST',
pt_import_data_file_name => 'XXMX_HCM_GPSET_MASS_REQ.dat',
pt_control_file_name => 'XXMX_HCM_GPSET_MASS_REQ.ctl',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'ELIGIBILITY_PROFILE_OBJECT',
pt_import_data_file_name => 'XXMX_HCM_GPSET_EO_PROF.dat',
pt_control_file_name => 'XXMX_HCM_GPSET_EO_PROF.ctl',
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
pt_i_BusinessEntity=>'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST_HIERARCHY',
pt_import_data_file_name => 'XXMX_HCM_GPSET_MR_HIER.dat',
pt_control_file_name => 'XXMX_HCM_GPSET_MR_HIER.ctl',
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
pt_i_BusinessEntity=> 'GOAL_PLAN_SET',
pt_i_SubEntity=> 'MASS_REQUEST_EXEMPTION',
pt_import_data_file_name => 'XXMX_HCM_GPSET_MR_EXEM.dat',
pt_control_file_name => 'XXMX_HCM_GPSET_MR_EXEM.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;



/
