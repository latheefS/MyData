--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  15-Jan-2022  Pallavi Kanajar     Created.
--**
--******************************************************************************
--
--
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'PROJECTS',
pt_import_data_file_name => 'XXMX_PPM_PROJECTS.dat',
pt_control_file_name => 'XXMX_PPM_PROJECTS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TASKS',
pt_import_data_file_name => 'XXMX_PPM_TASKS.dat',
pt_control_file_name => 'XXMX_PPM_TASKS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);

BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TEAM_MEMBERS',
pt_import_data_file_name => 'XXMX_PPM_TEAM_MEMBERS.dat',
pt_control_file_name => 'XXMX_PPM_TEAM_MEMBERS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'CLASSIFICATIONS',
pt_import_data_file_name => 'XXMX_PPM_CLASSIFICATIONS.dat',
pt_control_file_name => 'XXMX_PPM_CLASSIFICATIONS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TRX_CONTROL',
pt_import_data_file_name => 'XXMX_PPM_TRX_CONTROL.dat',
pt_control_file_name => 'XXMX_PPM_TRX_CONTROL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- Project Resource BreakDown Structure

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RBS_HEADERS',
pt_import_data_file_name => 'XXMX_PPM_RBS_HEADERS.dat',
pt_control_file_name => 'XXMX_PPM_RBS_HEADERS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RESOURCES',
pt_import_data_file_name => 'XXMX_PPM_RESOURCES.dat',
pt_control_file_name => 'XXMX_PPM_RESOURCES.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- Project Cost
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'MISC_COSTS',
pt_import_data_file_name => 'XXMX_PPM_MISC_COSTS.dat',
pt_control_file_name => 'XXMX_PPM_MISC_COSTS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'LABOUR_COST',
pt_import_data_file_name => 'XXMX_PPM_LABOUR_COST.dat',
pt_control_file_name => 'XXMX_PPM_LABOUR_COST.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'SUPPLIER_COST',
pt_import_data_file_name => 'XXMX_PPM_SUPPLIER_COST.dat',
pt_control_file_name => 'XXMX_PPM_SUPPLIER_COST.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'NON_LBR_COST',
pt_import_data_file_name => 'XXMX_PPM_NON_LBR_COST.dat',
pt_control_file_name => 'XXMX_PPM_NON_LBR_COST.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


-- Billing Events
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_BILL_EVNT',
pt_i_SubEntity=> 'BILLING_EVENTS',
pt_import_data_file_name => 'XXMX_PPM_BILLING_EVENTS.dat',
pt_control_file_name => 'XXMX_PPM_BILLING_EVENTS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/