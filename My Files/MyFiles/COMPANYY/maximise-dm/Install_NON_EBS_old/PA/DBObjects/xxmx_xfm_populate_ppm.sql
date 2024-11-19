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
PROMPT
PROMPT
PROMPT **************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Core Functionality
PROMPT **
PROMPT **************************************************************
PROMPT
PROMPT
--
--
DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'PROJECTS',
pt_fusion_template_name=> 'Projects.csv',
pt_fusion_template_sheet_name => 'Projects',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TASKS',
pt_fusion_template_name=> 'PjfProjElementsXface.csv',
pt_fusion_template_sheet_name => 'Tasks',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TRX_CONTROL',
pt_fusion_template_name=> 'PjcTxnControlsStage.csv',
pt_fusion_template_sheet_name => 'TransactionControls',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'TEAM_MEMBERS',
pt_fusion_template_name=> 'PjfProjectPartiesInt.csv',
pt_fusion_template_sheet_name => 'ProjectTeamMembers',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PROJECTS',
pt_i_SubEntity=> 'CLASSIFICATIONS',
pt_fusion_template_name=> 'ProjectClassifications.csv',
pt_fusion_template_sheet_name => 'ProjectClassifications',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Resource Breakdown STRUCTURE

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RBS_HEADERS',
pt_fusion_template_name=> 'PlanningRBSHeader.csv',
pt_fusion_template_sheet_name => 'PlanningRBSHeader',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RESOURCES',
pt_fusion_template_name=> 'Resources.csv',
pt_fusion_template_sheet_name => 'Resources',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Project Billing Events

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_BILL_EVNT',
pt_i_SubEntity=> 'BILLING_EVENTS',
pt_fusion_template_name=> 'ProjectBillingEvents.csv',
pt_fusion_template_sheet_name => 'ProjectBillingEvents',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Project Costs

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'MISC_COSTS',
pt_fusion_template_name=> 'Pjctxnxfacestageall.csv',
pt_fusion_template_sheet_name => 'Pjctxnxfacestageall',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'LABOUR_COST',
pt_fusion_template_name=> 'Pjctxnxfacestageall.csv',
pt_fusion_template_sheet_name => 'Pjctxnxfacestageall',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'SUPPLIER_COST',
pt_fusion_template_name=> 'Pjctxnxfacestageall.csv',
pt_fusion_template_sheet_name => 'Pjctxnxfacestageall',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'PPM',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'NON_LBR_COST',
pt_fusion_template_name=> 'Pjctxnxfacestageall.csv',
pt_fusion_template_sheet_name => 'Pjctxnxfacestageall',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



