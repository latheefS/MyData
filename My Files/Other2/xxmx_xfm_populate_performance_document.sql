--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  30-AUG-2023  Shaik Latheef       Created for Cloudbridge.
--**
--******************************************************************************


-- **********************
-- **Performance Document
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'PERFORMANCE_DOCUMENT',
pt_fusion_template_name=> 'PerfDocComplete.dat',
pt_fusion_template_sheet_name => 'PerfDocComplete',
pt_fusion_template_sheet_order=>1,
pt_common_load_column=>'',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'ATTACHMENT',
pt_fusion_template_name=> 'PerfDocComplete.dat',
pt_fusion_template_sheet_name => 'Attachment',
pt_fusion_template_sheet_order=>2,
pt_common_load_column=>'',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'PARTICIPANT',
pt_fusion_template_name=> 'PerfDocComplete.dat',
pt_fusion_template_sheet_name => 'Participant',
pt_fusion_template_sheet_order=>3,
pt_common_load_column=>'',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'RATINGS_COMMENTS',
pt_fusion_template_name=> 'PerfDocComplete.dat',
pt_fusion_template_sheet_name => 'RatingsAndComments',
pt_fusion_template_sheet_order=>4,
pt_common_load_column=>'',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
