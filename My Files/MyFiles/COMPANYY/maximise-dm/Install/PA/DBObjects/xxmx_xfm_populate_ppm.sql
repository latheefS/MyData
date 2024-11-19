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
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'PROJECTS',
pt_fusion_template_name=> 'PjfProjectsAllXface.csv',
pt_fusion_template_sheet_name => 'PjfProjectsAllXface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TASKS',
pt_fusion_template_name=> 'PjfProjElementsXface.csv',
pt_fusion_template_sheet_name => 'PjfProjElementsXface',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TRX_CONTROL',
pt_fusion_template_name=> 'PjfTxnControlsStage.csv',
pt_fusion_template_sheet_name => 'PjfTxnControlsStage',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'TEAM_MEMBERS',
pt_fusion_template_name=> 'PjfProjectPartiesInt.csv',
pt_fusion_template_sheet_name => 'PjfProjectPartiesInt',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/




DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_FOUNDATION',
pt_i_SubEntity=> 'CLASSIFICATIONS',
pt_fusion_template_name=> 'PjfProjectClassesInt.csv',
pt_fusion_template_sheet_name => 'PjfProjectClassesInt',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Resource Breakdown STRUCTURE

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RBS_HEADERS',
pt_fusion_template_name=> 'PjfRbsHeaderInt.csv',
pt_fusion_template_sheet_name => 'PjfRbsHeaderInt',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_RBS',
pt_i_SubEntity=> 'RESOURCES',
pt_fusion_template_name=> 'PjfRbsElementInt.csv',
pt_fusion_template_sheet_name => 'PjfRbsElementInt',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Project Billing Events

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_EVENTS',
pt_i_SubEntity=> 'BILLING_EVENTS',
pt_fusion_template_name=> 'PjbBillingEventsXface.csv',
pt_fusion_template_sheet_name => 'PjbBillingEventsXface',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- Project Costs

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'MISC_COSTS',
pt_fusion_template_name=> 'PjcTxnXfaceStageAll_misc.csv',
pt_fusion_template_sheet_name => 'PjcTxnXfaceStageAll_misc',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'LABOUR_COST',
pt_fusion_template_name=> 'PjcTxnXfaceStageAll_labor.csv',
pt_fusion_template_sheet_name => 'PjcTxnXfaceStageAll_labor',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'SUPPLIER_COST',
pt_fusion_template_name=> 'PjcTxnXfaceStageAll_supplier.csv',
pt_fusion_template_sheet_name => 'PjcTxnXfaceStageAll_supplier',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN
xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'PPM',
pt_i_Application=> 'PRJ',
pt_i_BusinessEntity=> 'PRJ_COST',
pt_i_SubEntity=> 'NON_LBR_COST',
pt_fusion_template_name=> 'PjcTxnXfaceStageAll_nonlabor.csv',
pt_fusion_template_sheet_name => 'PjcTxnXfaceStageAll_nonlabor',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



