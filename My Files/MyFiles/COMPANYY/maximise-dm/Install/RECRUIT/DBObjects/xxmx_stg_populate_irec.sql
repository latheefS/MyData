
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  01-FEB-2022  Shireesha TR        Created.
--**
--******************************************************************************
--
--


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_ADDRESS',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_ADDRESS.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_ADDRESS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;


/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_EMAIL',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_EMAIL.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_EMAIL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_NAME',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_NAME.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_NAME.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_PHONE',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_PHONE.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_PHONE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;


/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'ATTACHMENT',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_ATTMT.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_ATTMT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_POOL.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_POOL.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;



/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL_OWNER',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_POOL_OWNER.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_POOL_OWNER.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL_MEMBER',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_POOL_MEMBR.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_POOL_MEMBR.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'POOL_INTERACTION',
pt_import_data_file_name => 'XXMX_HCM_IREC_CAN_POOL_INTERACT.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CAN_POOL_INTERACT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'TALENT_COMMUNITY_DETAILS',
pt_import_data_file_name => 'XXMX_HCM_IREC_CP_TAL_COMM_DET.dat',
pt_control_file_name => 'XXMX_HCM_IREC_CP_TAL_COMM_DET.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN


xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REFERRAL',
pt_i_SubEntity=> 'JOB_REFERRAL',
pt_import_data_file_name => 'XXMX_HCM_IREC_REFERRAL.dat',
pt_control_file_name => 'XXMX_HCM_IREC_REFERRAL.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;



/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN


xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'PROSPECT',
pt_i_SubEntity=> 'PROSPECT',
pt_import_data_file_name => 'XXMX_HCM_IREC_PROSPECT.dat',
pt_control_file_name => 'XXMX_HCM_IREC_PROSPECT.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN


xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'GEOGRAPHY_HIERARCHY',
pt_i_SubEntity=> 'GEOGRAPHY_HIERARCHY',
pt_import_data_file_name => 'XXMX_HCM_IREC_GEO_HIER.dat',
pt_control_file_name => 'XXMX_HCM_IREC_GEO_HIER.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN


xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'GEOGRAPHY_HIERARCHY',
pt_i_SubEntity=> 'GEOGRAPHY_HIERARCHY_NODE',
pt_import_data_file_name => 'XXMX_HCM_IREC_GEO_HIER_NODE.dat',
pt_control_file_name => 'XXMX_HCM_IREC_GEO_HIER_NODE.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JOB_REQUISITION',
pt_import_data_file_name => 'XXMX_HCM_IREC_JOB_REQ.dat',
pt_control_file_name => 'XXMX_HCM_IREC_JOB_REQ.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JR_HIRING_TEAM',
pt_import_data_file_name => 'XXMX_HCM_IREC_JR_HIRE_TEAM.dat',
pt_control_file_name => 'XXMX_HCM_IREC_JR_HIRE_TEAM.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);


END ;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JR_POSTING_DETAIL',
pt_import_data_file_name => 'XXMX_HCM_IREC_JR_POST_DET.dat',
pt_control_file_name => 'XXMX_HCM_IREC_JR_POST_DET.ctl', 
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/