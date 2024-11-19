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

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'PERFORMANCE_DOCUMENT',
pt_import_data_file_name => 'XXMX_HCM_PERFORMANCE_DOC_STG.dat',
pt_control_file_name => 'XXMX_HCM_PERFORMANCE_DOC.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'ATTACHMENT',
pt_import_data_file_name => 'XXMX_HCM_ATTACHMENT_STG.dat',
pt_control_file_name => 'XXMX_HCM_ATTACHMENT.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'PARTICIPANT',
pt_import_data_file_name => 'XXMX_HCM_PARTICIPANT_STG.dat',
pt_control_file_name => 'XXMX_HCM_PARTICIPANT.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'TM',
pt_i_BusinessEntity=> 'PERFORMANCE_DOCUMENT',
pt_i_SubEntity=> 'RATINGS_COMMENTS',
pt_import_data_file_name => 'XXMX_HCM_RATINGS_COMMENTS_STG.dat',
pt_control_file_name => 'XXMX_HCM_RATINGS_COMMENTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
