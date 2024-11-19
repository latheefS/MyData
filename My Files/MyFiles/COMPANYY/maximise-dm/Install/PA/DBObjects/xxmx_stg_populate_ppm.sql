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
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'PROJECTS',
pt_import_data_file_name => 'XXMX_PPM_PROJECTS.csv',
pt_control_file_name => 'XXMX_PPM_PROJECTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TASKS',
pt_import_data_file_name => 'XXMX_PPM_PRJ_TASKS.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_TASKS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TRX_CONTROL',
pt_import_data_file_name => 'XXMX_PPM_PRJ_TRX_CONTROL.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_TRX_CONTROL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);

BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TEAM_MEMBERS',
pt_import_data_file_name => 'XXMX_PPM_PRJ_TEAM_MEM.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_TEAM_MEM.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'CLASSIFICATIONS',
pt_import_data_file_name => 'XXMX_PPM_PRJ_CLASS.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_CLASS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/




-- Project Resource BreakDown Structure

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RBS_HEADERS',
pt_import_data_file_name => 'XXMX_PPM_PLANRBS_HEADER.csv',
pt_control_file_name => 'XXMX_PPM_PLANRBS_HEADER.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RESOURCES',
pt_import_data_file_name => 'XXMX_PPM_RESOURCES.csv',
pt_control_file_name => 'XXMX_PPM_RESOURCES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- Billing Events
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_EVENTS',
pt_i_SubEntity=> 'BILLING_EVENTS',
pt_import_data_file_name => 'XXMX_PPM_PRJ_BILLEVENT.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_BILLEVENT.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

-- Project Cost
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'MISC_COSTS',
pt_import_data_file_name => 'XXMX_PPM_PRJ_MISCCOST.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_MISCCOST.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'LABOUR_COST',
pt_import_data_file_name => 'XXMX_PPM_PRJ_LBRCOST.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_LBRCOST.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'SUPPLIER_COST',
pt_import_data_file_name => 'XXMX_PPM_PRJ_SUPCOST.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_SUPCOST.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'NON_LBR_COST',
pt_import_data_file_name => 'XXMX_PPM_PRJ_NONLABCOST.csv',
pt_control_file_name => 'XXMX_PPM_PRJ_NONLABCOST.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);
END ;
/


