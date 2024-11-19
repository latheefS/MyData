--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  01-FEB-2022  Shireesha TR    	 Created.
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
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE',
pt_fusion_template_name=> 'Candidate.dat',
pt_fusion_template_sheet_name => 'Candidate',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_ADDRESS',
pt_fusion_template_name=> 'CandidateAddress.dat',
pt_fusion_template_sheet_name => 'CandidateAddress',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_EMAIL',
pt_fusion_template_name=> 'CandidateEmail.dat',
pt_fusion_template_sheet_name => 'CandidateEmail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_NAME',
pt_fusion_template_name=> 'CandidateName.dat',
pt_fusion_template_sheet_name => 'CandidateName',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'CANDIDATE_PHONE',
pt_fusion_template_name=> 'CandidatePhone.dat',
pt_fusion_template_sheet_name => 'CandidatePhone',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE',
pt_i_SubEntity=> 'ATTACHMENT',
pt_fusion_template_name=> 'Attachment.dat',
pt_fusion_template_sheet_name => 'Attachment',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL',
pt_fusion_template_name=> 'CandidatePool.dat',
pt_fusion_template_sheet_name => 'CandidatePool',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL_OWNER',
pt_fusion_template_name=> 'CandidatePoolOwner.dat',
pt_fusion_template_sheet_name => 'CandidatePoolOwner',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'CANDIDATE_POOL_MEMBER',
pt_fusion_template_name=> 'CandidatePoolMember.dat',
pt_fusion_template_sheet_name => 'CandidatePoolMember',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'POOL_INTERACTION',
pt_fusion_template_name=> 'PoolInteraction.dat',
pt_fusion_template_sheet_name => 'PoolInteraction',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'CANDIDATE_POOL',
pt_i_SubEntity=> 'TALENT_COMMUNITY_DETAILS',
pt_fusion_template_name=> 'TalentCommunityDetails.dat',
pt_fusion_template_sheet_name => 'TalentCommunityDetails',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/


DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REFERRAL',
pt_i_SubEntity=> 'JOB_REFERRAL',
pt_fusion_template_name=> 'Referral.dat',
pt_fusion_template_sheet_name => 'Referral',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);



END ;


/

DECLARE
pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'PROSPECT',
pt_i_SubEntity=> 'PROSPECT',
pt_fusion_template_name=> 'Prospect.dat',
pt_fusion_template_sheet_name => 'Prospect',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);



END ;


/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JOB_REQUISITION',
pt_fusion_template_name=> 'JobRequisition.dat',
pt_fusion_template_sheet_name => 'JobRequisition',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;

/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JR_HIRING_TEAM',
pt_fusion_template_name=> 'HiringTeam.dat',
pt_fusion_template_sheet_name => 'HiringTeam',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'JOB_REQUISITION',
pt_i_SubEntity=> 'JR_POSTING_DETAIL',
pt_fusion_template_name=> 'PostingDetails.dat',
pt_fusion_template_sheet_name => 'PostingDetails',
pt_fusion_template_sheet_order=>16,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'GEOGRAPHY_HIERARCHY',
pt_i_SubEntity=> 'GEOGRAPHY_HIERARCHY',
pt_fusion_template_name=> 'GeographyHierarchy.dat',
pt_fusion_template_sheet_name => 'GeographyHierarchy',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'IREC',
pt_i_BusinessEntity=> 'GEOGRAPHY_HIERARCHY',
pt_i_SubEntity=> 'GEOGRAPHY_HIERARCHY_NODE',
pt_fusion_template_name=> 'GeographyHierarchyNode.dat',
pt_fusion_template_sheet_name => 'GeographyHierarchyNode',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


	      



