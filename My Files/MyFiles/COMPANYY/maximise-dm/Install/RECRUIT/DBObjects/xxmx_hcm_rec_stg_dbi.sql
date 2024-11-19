--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_hcm_irec_stg_tab.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.1
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Shaik Latheef 
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              HCM Pay Data Migration.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  29-SEP-2021  Shaik Latheef  	 Created Recruiting STG tables for Maximise.
--**   1.1  11-FEB-2022  Shireesha  	     Updated table datatypes for Maximise.
--******************************************************************************
--**
--**  Data Element Prefixes
--**  =====================
--**
--**  Utilizing prefixes for data and object names enhances the readability of code
--**  and allows for the context of a data element to be identified (and hopefully
--**  understood) without having to refer to the data element declarations section.
--**
--**  For example, having a variable in code simply named "x_id" is not very
--**  useful.  Don't laugh, I've seen it done.
--**
--**  If you came across such a variable hundreds of lines down in a packaged
--**  procedure or function, you could assume the variable's data type was
--**  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
--**  but you would have to check in the declaration section to be sure.
--**
--**  However, if the purpose of the "x_id" variable was not to store an Oracle
--**  internal ID but perhaps some kind of client data identifier e.g. an
--**  Employee ID (and you could not tell this from the name) then the data type
--**  could easily be be VARCHAR2.  Again, you would have to navigate to the
--**  declaration section to be sure of the data type.
--**
--**  Also, the variable name does not give any developer who may need to modify
--**  the code (apart from the original author that is) any context as to the
--**  meaning of the variable.  Even the original author may struggle to remember
--**  what this variable is used for if s/he had to modify their own code months
--**  or years in the future.
--**
--**  This Package utilises prefixes of upto 6 characters for all data elements
--**  wherever possible.
--**
--**  The construction of Prefixes is governed by the following rules:
--**
--**       Parameters
--**       ----------
--**       1) Parameter prefixes always start with "p".
--**       
--**       2) The second character in a parameter prefix denotes its
--**          data type:
--**       
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**       
--**       3) The third and/or fourth characters in a parameter prefix
--**          denote the direction in which value in the paramater is
--**          communicated:
--**       
--**               i  = Input parameter (readable value only)
--**               o  = Output parameter (value assignable)
--**               io = Input/Output parameter (readable/assignable)
--**       
--**          For clarity, the direction indicators are separated from
--**          the first two characters by an underscore. e.g. pv_i_
--**
--**       Global Data Elements
--**       --------------------
--**       1) Global data elements will always start with a "g" whether
--**          defined in the package body (and therefore only global within
--**          the package itself), or defined in the package specification
--**          (and therefore referencable outside of the package).
--**      
--**          The subequent characters in a global prefix will follow the same
--**          conventions as per local constants and variables as explained
--**          below.
--**      
--**       Local Data Elements
--**       -------------------
--**       1) The first character of a local data element's prefix (or second
--**          character for global) denotes the data element's assignability:
--**      
--**               c = Denotes a constant.
--**              
--**               v = Denotes a variable.
--**      
--**       2) The second character or a local data element's prefix (or third
--**          character for global) denotes its data type (as with parameters):
--**      
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**
--**  Prefix Examples
--**  ===============
--**
--**       Prefix    Indication
--**       --------  ----------------------------------------
--**       pb_i_     Input Parameter of type BOOLEAN
--**       pd_i_     Input Parameter of type DATE
--**       pi_i_     Input Parameter of type INTEGER
--**       pn_i_     Input Parameter of type NUMBER
--**       pr_i_     Input Parameter of type REAL
--**       pv_i_     Input Parameter of type VARCHAR2
--**       pt_i_     Input Parameter of type %TYPE
--**
--**       pb_o_     Output Parameter of type BOOLEAN
--**       pd_o_     Output Parameter of type DATE
--**       pi_o_     Output Parameter of type INTEGER
--**       pn_o_     Output Parameter of type NUMBER
--**       pr_o_     Output Parameter of type REAL
--**       pv_o_     Output Parameter of type VARCHAR2
--**       pt_o_     Output Parameter of type %TYPE
--**
--**       pb_io_    Input/Output Parameter of type BOOLEAN
--**       pd_io_    Input/Output Parameter of type DATE
--**       pi_io_    Input/Output Parameter of type INTEGER
--**       pn_io_    Input/Output Parameter of type NUMBER
--**       pr_io_    Input/Output Parameter of type REAL
--**       pv_io_    Input/Output Parameter of type VARCHAR2
--**       pt_io_    Input/Output Parameter of type %TYPE
--**
--**       gcb_      Global Constant of type BOOLEAN
--**       gcd_      Global Constant of type DATE
--**       gci_      Global Constant of type INTEGER
--**       gcn_      Global Constant of type NUMBER
--**       gcr_      Global Constant of type REAL
--**       gcv_      Global Constant of type VARCHAR2
--**       gct_      Global Constant of type %TYPE
--**
--**       gvb_      Global Variable of type BOOLEAN
--**       gvd_      Global Variable of type DATE
--**       gvi_      Global Variable of type INTEGER
--**       gvn_      Global Variable of type NUMBER
--**       gvr_      Global Variable of type REAL
--**       gvv_      Global Variable of type VARCHAR2
--**       gvt_      Global Variable of type %TYPE
--**
--**       cb_       Constant of type BOOLEAN
--**       cd_       Constant of type DATE
--**       ci_       Constant of type INTEGER
--**       cn_       Constant of type NUMBER
--**       cr_       Constant of type REAL
--**       cv_       Constant of type VARCHAR2
--**       ct_       Constant of type %TYPE
--**
--**       vb_       Variable of type BOOLEAN
--**       vd_       Variable of type DATE
--**       vi_       Variable of type INTEGER
--**       vn_       Variable of type NUMBER
--**       vr_       Variable of type REAL
--**       vv_       Variable of type VARCHAR2
--**       vt_       Variable of type %TYPE
--**
--**  PL/SQL Construct Suffixes
--**  =========================
--**
--**  Specific suffixes have been employed for PL/SQL Constructs:
--**
--**       _cur      Cursor Names
--**       _rt       PL/SQL Record Type Declarations
--**       _tt       PL/SQL Table Type Declarations
--**       _tbl      PL/SQL Table Declarations
--**       _rec      PL/SQL Record Declarations (or implicit
--**                 cursor record declarations)
--**
--**  Other Data Element Naming Conventions
--**  =====================================
--**
--**  Data elements names should have meaning which indicate their purpose or
--**  usage whilst adhering to the Oracle name length limit of 30 characters.
--**
--**  To compensate for longer data element prefixes, the rest of a data element
--**  name is constructed without underscores.  However to aid in maintaining
--**  readability and meaning, data elements names will contain concatenated
--**  words with initial letters capitalised in a similar manner to JAVA naming
--**  conventions.
--**
--**  By using the above conventions you can create meaningful data element
--**  names such as:
--**
--**       pn_i_POHeaderID
--**       ---------------
--**       This clearly identifies that the data element is an inbound only
--**       (non assignable) parameter of type NUMBER which holds an Oracle
--**       internal PO Header identifier.
--**
--**       pb_o_CreateOutputFileAsCSV
--**       --------------------------
--**       This clearly identifies that the data element is an output only
--**       parameter of type BOOLEAN that contains a flag which indicates
--**       that output of the calling process should be formatted as a CSV
--**       file.
--**
--**       gcv_PackageName
--**       ---------------
--**       This data element is a global constant of type VARCHAR2.
--**
--**       gvv_ProcOrFuncName
--**       ------------------
--**       This data element is a global variable or type VARCHAR2.
--**
--**       vt_APInvoiceID
--**       --------------
--**       This data element is a variable whose type is determined from a
--**       database table column and is meant to hold the Oracle internal
--**       identifier for a Payables Invoice Header.
--**
--**       vt_APInvoiceLineID
--**       ------------------
--**       Similar to the previous example but this clearly identified that the
--**       data element is intended to hold the Oracle internal identifier for
--**       a Payables Invoice Line.
--**
--**  Similarly for PL/SQL Constructs:
--**
--**       APInvoiceHeaders_cur
--**
--**       APInvoiceHeader_rec
--**
--**       TYPE EmployeeData_rt IS RECORD OF
--**            (
--**             employee_number   VARCHAR2(20)
--**            ,employee_name     VARCHAR2(30)
--**            );
--**
--**       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
--**   
--**       EmployeeData_tbl        EmployeeData_tt;
--**      
--**  Careful and considerate use of the above rules when naming data elements
--**  can be a boon to other developers who may need to understand and/or modify
--**  your code in future.  In conjunction with good commenting practices of
--**  course.
--**
--******************************************************************************
--


PROMPT
PROMPT
PROMPT *********************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Recruiting Data Migration
PROMPT **
PROMPT *********************************************************************
PROMPT
PROMPT

--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
PROMPT
PROMPT
--
--

EXEC DropTable ('XXMX_HCM_IREC_JOB_REQ_SEC_PROFL_STG')
--	Job Requisition Security Profile Table
EXEC DropTable ('XXMX_HCM_IREC_CON_LIB_STG')
--	Content Library Table
EXEC DropTable ('XXMX_HCM_IREC_CL_POST_DESC_CNTXT_STG')
--	CL-Posting Description Context Table
EXEC DropTable ('XXMX_HCM_IREC_CON_LIB_VER_STG')							
--	Content Library Version Table
EXEC DropTable ('XXMX_HCM_IREC_CL_ATTMT_STG')							
--	CL-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_CON_LIB_TRNSLN_STG')
--	Content Library Translation Table
EXEC DropTable ('XXMX_HCM_IREC_CON_LIB_VER_TRNSLN_STG')
--	Content Library Version Translation Table
EXEC DropTable ('XXMX_HCM_IREC_GEO_HIER_STG')
--	Geography Hierarchy Table
EXEC DropTable ('XXMX_HCM_IREC_GEO_HIER_NODE_STG')
	--	Geography Hierarchy Node Table
EXEC DropTable ('XXMX_HCM_IREC_JOB_REQ_STG')
--	Job Requisition Table
EXEC DropTable ('XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_STG')
--	JR-Background Check Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JR_ASSMT_CONFIG_STG')
--	JR-Assessment Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JR_ASSMT_SCRN_PKG_STG')
--	JR-Assessment Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JR_TAX_CRED_CONFIG_STG')
--	JR-Tax Credit Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JR_TAX_CRED_SCRN_PKG_STG')
--	JR-Tax Credit Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JR_BKG_CHECK_CONFIG_STG')
--	JR-Background Check Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_V2_STG')
--	JR-Background Check Screening Package V2 Table
EXEC DropTable ('XXMX_HCM_IREC_JR_APPL_SPEC_QSTN_STG')
--	JR-Application Specific Question Table
EXEC DropTable ('XXMX_HCM_IREC_JR_ATTMT_STG')
--	JR-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_JR_HIRE_TEAM_STG')
--	JR-Hiring Team Table
EXEC DropTable ('XXMX_HCM_IREC_JR_INTRVW_QSTNR_STG')
--	JR-Interview Questionnaire Table
EXEC DropTable ('XXMX_HCM_IREC_JR_JOB_PROFL_STG')
--	JR-Job Profile Table
EXEC DropTable ('XXMX_HCM_IREC_JR_OTHER_LOC_STG')
--	JR-Other Location Table
EXEC DropTable ('XXMX_HCM_IREC_JR_POST_DET_STG')
--	JR-Posting Details Table
EXEC DropTable ('XXMX_HCM_IREC_JR_OTHER_WORK_LOC_STG')
--	JR-Other Work Location Table
EXEC DropTable ('XXMX_HCM_IREC_JR_LANG_STG')
--	JR-Language Table
EXEC DropTable ('XXMX_HCM_IREC_JR_MEDIA_LINK_STG')
--	JR-Media Link Table
EXEC DropTable ('XXMX_HCM_IREC_JR_MEDIA_LINK_LANG_STG')
--	JR-Media Link Language Table
EXEC DropTable ('XXMX_HCM_IREC_JOB_REQ_TRNSLN_STG')
--	Job Requisition Translation Table
EXEC DropTable ('XXMX_HCM_IREC_JOB_REQ_TEMPL_STG')	
--	Job Requisition Template Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_TEMPL_MEDIA_LINK_STG')
--	JRT-Template Media Link Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_MEDIA_LINK_LANG_STG')
--	JRT-Media Link Language Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_STG')
--	JRT-Background Check Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_ASSMT_CONFIG_STG')	
--	JRT-Assessment Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_ASSMT_SCRN_PKG_STG')
--	JRT-Assessment Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_TAX_CRED_CONFIG_STG')
--	JRT-Tax Credit Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_TAX_CRED_SCRN_PKG_STG')
--	JRT-Tax Credit Screening Package Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_BKG_CHECK_CONFIG_STG')
--	JRT-Background Check Configuration Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_V2_STG')
--	JRT-Background Check Screening Package V2 Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_APPL_SPEC_QSTN_STG')
--	JRT-Application Specific Question Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_ATTMT_STG')
--	JRT-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_HIRE_TEAM_STG')	
--	JRT-Hiring Team Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_INTRVW_QSTNR_STG')	
--	JRT-Interview Questionnaire Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_JOB_PROFL_STG')	
--	JRT-Job Profile Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_OTHER_LOC_STG')	
--	JRT-Other Location Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_OTHER_WORK_LOC_STG')
--	JRT-Other Work Location Table
EXEC DropTable ('XXMX_HCM_IREC_JRT_LANG_STG')
--	JRT-Language Table
EXEC DropTable ('XXMX_HCM_IREC_JOB_REQ_TEMPL_TRNSLN_STG')
--	Job Requisition Template Translation Table
EXEC DropTable ('XXMX_HCM_IREC_MEDIA_LINK_TRNSLN_STG')	
--	Media Link Translation Table
EXEC DropTable ('XXMX_HCM_IREC_TEMPL_MEDIA_LINK_TRNSLN_STG')
--	Template Media Link Translation Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_STG')
--	Candidate
EXEC DropTable ('XXMX_HCM_IREC_CAN_INTERACT_STG')	
--	Candidate Interaction Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PREF_STG')	
--	Candidate Preference Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PREFD_JOB_FAM_STG')	
--	Candidate Preferred Job Family Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PREFD_LOC_STG')		
--	Candidate Preferred Location Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PREFD_ORG_STG')	
--	Candidate Preferred Organization Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_NAT_IDENFR_STG')
--	Candidate National Identifier Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PROFL_STG')
--	Candidate Profile Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_ADDRESS_STG')
--	Candidate Address Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_EMAIL_STG')
--	Candidate Email Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_NAME_STG')
--	Candidate Name Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_PHONE_STG')
--	Candidate Phone Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_ATTMT_STG')
--	CAN-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_EXTRA_INFO_STG')
--	Candidate Extra Info Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_POOL_STG')
--	Candidate Pool Table
EXEC DropTable ('XXMX_HCM_IREC_CP_TAL_COMM_DET_STG')
--	CP-Talent Community Detail Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_POOL_MEMBR_STG')
--	Candidate Pool Member Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_POOL_INTERACT_STG')	
--	CP-Interaction Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_POOL_OWNER_STG')
--	Candidate Pool Owner Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_POOL_TRNSLN_STG')
--	Candidate Pool Translation Table
EXEC DropTable ('XXMX_HCM_IREC_REFERRAL_STG')
--	Referral Table
EXEC DropTable ('XXMX_HCM_IREC_REF_ATTMT_STG')
--	REF-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_PROSPECT_STG')
--	Prospect Table
EXEC DropTable ('XXMX_HCM_IREC_PROSPECT_INTERACT_STG')
	--	Prospect Interaction Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_JOB_APPL_STG')
--	Candidate Job Application Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_CAN_PER_INFO_STG')
	--	CJA-Candidate Personal Information Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_CAN_PREFD_LOC_STG')
	--	CJA-Candidate Preferred Location Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_QSTNR_PARTCPNT_STG')
--	CJA-Questionnaire Participant Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_QSTNR_RESP_STG')
--	CJA-Questionnaire Response Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_QSTN_RESP_STG')
	--	CJA-Question Response Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_ATTMT_STG')
--	CJA-Attachment Table
EXEC DropTable ('XXMX_HCM_IREC_CJA_CAN_INTERACT_STG')
--	CJA-Candidate Interaction Table;
EXEC DropTable ('XXMX_HCM_IREC_CAN_JOB_APPL_PROFL_STG')
--	Candidate Job Application Profile Table
EXEC DropTable ('XXMX_HCM_IREC_CAN_JOB_APPL_EXTRA_INFO_STG')
--	Candidate Job Application Extra Info Table



--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--

-- ****************************************
-- **Job Requisition Security Profile Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JOB_REQ_SEC_PROFL_STG
   (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID 						NUMBER,
	MIGRATION_SET_NAME 						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME   								VARCHAR2(240),
	BG_ID            						NUMBER(15),	
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'JobRequisitionSecurityProfile',
	---
	REQ_SECURITY_PROFILE_ID					NUMBER(18),
	NAME									VARCHAR2(240),
	SECURE_BY_HCM_IRECRUITING_TYPE_FLAG		VARCHAR2(30) DEFAULT 'N',
	SECURE_BY_ORGANIZATION_FLAG				VARCHAR2(30) DEFAULT 'N',
	SECURE_BY_LOCATION_FLAG					VARCHAR2(30) DEFAULT 'N',
	SECURE_BY_JOB_FAMILY_FLAG				VARCHAR2(30) DEFAULT 'N',
	SECURE_BY_JOB_FUNCTION_FLAG				VARCHAR2(30) DEFAULT 'N',
	ENABLED_FLAG							VARCHAR2(30) DEFAULT 'N',
	VIEW_ALL_FLAG							VARCHAR2(30) DEFAULT 'N',
	GUID									VARCHAR2(32),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 						VARCHAR2(30),
	ATTRIBUTE1 								VARCHAR2(150),
	ATTRIBUTE2 								VARCHAR2(150),
	ATTRIBUTE3 								VARCHAR2(150),
	ATTRIBUTE4 								VARCHAR2(150),
	ATTRIBUTE5 								VARCHAR2(150),
	ATTRIBUTE6 								VARCHAR2(150),
	ATTRIBUTE7 								VARCHAR2(150),
	ATTRIBUTE8 								VARCHAR2(150),
	ATTRIBUTE9 								VARCHAR2(150),
	ATTRIBUTE10 							VARCHAR2(150),
	ATTRIBUTE_NUMBER1 						NUMBER, 
	ATTRIBUTE_NUMBER2 						NUMBER, 
	ATTRIBUTE_NUMBER3 						NUMBER, 
	ATTRIBUTE_NUMBER4 						NUMBER, 
	ATTRIBUTE_NUMBER5 						NUMBER, 
	ATTRIBUTE_DATE1 						DATE, 
	ATTRIBUTE_DATE2 						DATE, 
	ATTRIBUTE_DATE3 						DATE, 
	ATTRIBUTE_DATE4 						DATE, 
	ATTRIBUTE_DATE5 						DATE
   );
   
   
-- ***********************
-- **Content Library Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CON_LIB_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ContentLibrary',
	---
	DESCRIPTION_ID						NUMBER(18),
	CODE								VARCHAR2(30),
	CATEGORY							VARCHAR2(30),
	STATUS								VARCHAR2(30),
	VISIBILITY							VARCHAR2(30),
	NAME								VARCHAR2(240),
	CAPTURE_INTERACTION					VARCHAR2(1),
	INTERACTION_CONTENT        VARCHAR2(80),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **************************************
-- **CL-Posting Description Context Table
-- **************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CL_POST_DESC_CNTXT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'PostingDescriptionContext',
	---
	OBJECT_CTX_ID						NUMBER(18),
	DESCRIPTION_ID						NUMBER(18),
	CODE								VARCHAR2(30),
	LOCATION_ID							NUMBER(18),
	LOCATION_NAME						VARCHAR2(360),
	JOB_FAMILY_ID						NUMBER(18),
	JOB_FAMILY_CODE						VARCHAR2(240),
	JOB_FAMILY_NAME						VARCHAR2(240),
	DIMENSION_TYPE_CODE					VARCHAR2(30),
	RECRUITING_TYPE_CODE				VARCHAR2(30),
	JOB_FUNCTION_CODE					VARCHAR2(30),
	ORGANIZATION_ID						NUMBER(18),
	ORGANIZATION_CODE					VARCHAR2(500),
	ORGANIZATION_NAME					VARCHAR2(4000),
	CLASSIFICATION_CODE					VARCHAR2(40),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *******************************
-- **Content Library Version Table
-- *******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ContentLibraryVersion',
	---
	DESC_VERSION_ID						NUMBER(18),
	DESCRIPTION_ID						NUMBER(18),
	CONTENT								CLOB,
	START_DATE							TIMESTAMP,
	STATUS								VARCHAR2(30),
	CODE								VARCHAR2(30),
	SHORT_DESCRIPTION					CLOB,
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *********************
-- **CL-Attachment Table
-- *********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CL_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	DESC_VERSION_ID						NUMBER(18),
	TITLE								VARCHAR2(80),
	TFILE								CLOB,
	DATA_TYPE_CODE						VARCHAR2(80),
	CODE								VARCHAR2(30),
	START_DATE							DATE,
	URL_OR_FILENAME						VARCHAR2(2048),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************************
-- **Content Library Translation Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CON_LIB_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ContentLibraryTranslation',
	---
	DESCRIPTION_ID						NUMBER(18),
	LANGUAGE							VARCHAR2(4),
	CODE								VARCHAR2(30),
	NAME								VARCHAR2(240),
	INTERACTION_CONTENT					CLOB,
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *******************************************
-- **Content Library Version Translation Table
-- *******************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ContentLibraryVersionTranslation',
	---
	DESC_VERSION_ID						NUMBER(18),
	LANGUAGE							VARCHAR2(4),
	CONTENT								CLOB,
	CODE								VARCHAR2(30),
	START_DATE							DATE,
	SHORT_DESCRIPTION					CLOB,
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***************************
-- **Geography Hierarchy Table
-- ***************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_GEO_HIER_STG
   (
FILE_SET_ID                    VARCHAR2(30)   ,
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(50)   ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA							VARCHAR2(150) DEFAULT 'MERGE',
OBJECTNAME							VARCHAR2(150) DEFAULT 'GeographyHierarchy',
LOCATION_CODE                  VARCHAR2(60)   ,
ADDRESS_LINE_1                 VARCHAR2(240)  ,
ADDRESS_LINE_2                 VARCHAR2(240)  ,
ADDRESS_LINE_3                 VARCHAR2(240)  ,
COUNTRY                        VARCHAR2(60)   ,
POSTAL_CODE                    VARCHAR2(30)   ,
REGION_1                       VARCHAR2(120)  ,
REGION_2                       VARCHAR2(120)  ,
REGION_3                       VARCHAR2(120)  ,
HIERARCHY_ID                   NUMBER(18)     ,
NAME                           VARCHAR2(240)  ,
START_DATE                     TIMESTAMP(6)   ,
STATUS_CODE                    VARCHAR2(30)   ,
START_ON_ACTIVATION_FLAG       VARCHAR2(30)   ,
GUID                           VARCHAR2(32)   ,
SOURCE_SYSTEM_ID               VARCHAR2(2000) ,
SOURCE_SYSTEM_OWNER            VARCHAR2(256)  ,
ATTRIBUTE_CATEGORY             VARCHAR2(30)   ,
ATTRIBUTE1                     VARCHAR2(150)  ,
ATTRIBUTE2                     VARCHAR2(150)  ,
ATTRIBUTE3                     VARCHAR2(150)  ,
ATTRIBUTE4                     VARCHAR2(150)  ,
ATTRIBUTE5                     VARCHAR2(150)  ,
ATTRIBUTE6                     VARCHAR2(150)  ,
ATTRIBUTE7                     VARCHAR2(150)  ,
ATTRIBUTE8                     VARCHAR2(150)  ,
ATTRIBUTE9                     VARCHAR2(150)  ,
ATTRIBUTE10                    VARCHAR2(150)  ,
ATTRIBUTE_NUMBER1              NUMBER         ,
ATTRIBUTE_NUMBER2              NUMBER         ,
ATTRIBUTE_NUMBER3              NUMBER         ,
ATTRIBUTE_NUMBER4              NUMBER         ,
ATTRIBUTE_NUMBER5              NUMBER         ,
ATTRIBUTE_DATE1                DATE           ,
ATTRIBUTE_DATE2                DATE           ,
ATTRIBUTE_DATE3                DATE           ,
ATTRIBUTE_DATE4                DATE           ,
ATTRIBUTE_DATE5                DATE      ,
BATCH_NAME                     VARCHAR2(300)
   );
   
   
-- ********************************
-- **Geography Hierarchy Node Table
-- ********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_GEO_HIER_NODE_STG
   (
	FILE_SET_ID               VARCHAR2(30),   
   MIGRATION_SET_ID          NUMBER      ,   
   MIGRATION_SET_NAME        VARCHAR2(150),  
   MIGRATION_STATUS          VARCHAR2(50)  , 
   BG_NAME                   VARCHAR2(240) , 
   BG_ID                     NUMBER(15)    , 
   METADATA                  VARCHAR2(150) , 
   OBJECTNAME                VARCHAR2(150) , 
   LOCATION_CODE             VARCHAR2(60)  , 
   ADDRESS_LINE_1            VARCHAR2(240) , 
   ADDRESS_LINE_2            VARCHAR2(240) , 
   ADDRESS_LINE_3            VARCHAR2(240) , 
   COUNTRY                   VARCHAR2(60)  , 
   POSTAL_CODE               VARCHAR2(30)  , 
   REGION_1                  VARCHAR2(120) , 
   REGION_2                  VARCHAR2(120) , 
   REGION_3                  VARCHAR2(120) , 
   GEOGRAPHY_ID              NUMBER(18)    , 
   GEOGRAPHY_NODE_ID         NUMBER(18)    , 
   HIERARCHY_ID              NUMBER(18)    , 
   NAME                      VARCHAR2(240) , 
   COUNTRY_CODE              VARCHAR2(2)   , 
   LEVEL1                    VARCHAR2(240) , 
   LEVEL2                    VARCHAR2(240) , 
   GEOGRAPHY_ELEMENT1        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT2        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT3        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT4        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT5        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT6        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT7        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT8        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT9        VARCHAR2(360) , 
   GEOGRAPHY_ELEMENT10       VARCHAR2(360) , 
   DELETE_FLAG               VARCHAR2(30)  , 
   GUID                      VARCHAR2(32)  , 
   SOURCE_SYSTEM_ID          VARCHAR2(2000), 
   SOURCE_SYSTEM_OWNER       VARCHAR2(256) , 
   ATTRIBUTE_CATEGORY        VARCHAR2(30)  , 
   ATTRIBUTE1                VARCHAR2(150) , 
   ATTRIBUTE2                VARCHAR2(150) , 
   ATTRIBUTE3                VARCHAR2(150) , 
   ATTRIBUTE4                VARCHAR2(150) , 
   ATTRIBUTE5                VARCHAR2(150) , 
   ATTRIBUTE6                VARCHAR2(150) , 
   ATTRIBUTE7                VARCHAR2(150) , 
   ATTRIBUTE8                VARCHAR2(150) , 
   ATTRIBUTE9                VARCHAR2(150) , 
   ATTRIBUTE10               VARCHAR2(150) , 
   ATTRIBUTE_NUMBER1         NUMBER        , 
   ATTRIBUTE_NUMBER2         NUMBER        , 
   ATTRIBUTE_NUMBER3         NUMBER        , 
   ATTRIBUTE_NUMBER4         NUMBER        , 
   ATTRIBUTE_NUMBER5         NUMBER        , 
   ATTRIBUTE_DATE1           DATE          , 
   ATTRIBUTE_DATE2           DATE          , 
   ATTRIBUTE_DATE3           DATE          , 
   ATTRIBUTE_DATE4           DATE          , 
   ATTRIBUTE_DATE5           DATE          ,
BATCH_NAME VARCHAR2(300)   
   );
   
   
-- ***********************
-- **Job Requisition Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JOB_REQ_STG
(  
 FILE_SET_ID                                  VARCHAR2(30)   , 
 MIGRATION_SET_ID                             NUMBER          ,
 MIGRATION_SET_NAME                           VARCHAR2(150)   ,
 MIGRATION_STATUS                             VARCHAR2(50)    ,
 BG_NAME                                      VARCHAR2(240)   ,
 BG_ID                                        NUMBER(15)      ,
 METADATA                                     VARCHAR2(150)  DEFAULT 'MERGE'  ,
 OBJECTNAME                                   VARCHAR2(150)  DEFAULT 'JobRequisition'  ,
 --
 REQUISITION_ID                               NUMBER(18)      ,
 REQUISITION_NUMBER                           VARCHAR2(240)   ,
 RECRUITING_TYPE                              VARCHAR2(30)    ,
 JOB_ID                                       NUMBER(18)      ,
 NUMBER_OF_OPENINGS                           NUMBER(5)       ,
 UNLIMITED_OPENINGS_FLAG                      VARCHAR2(5)     ,
 REQUISITION_TITLE                            VARCHAR2(250)   ,
 INTERNAL_REQUISITION_TITLE                   VARCHAR2(240)   ,
 BUSINESS_JUSTIFICATION                       VARCHAR2(30)    ,
 HIRING_MANAGER_ID                            NUMBER(18)      ,
 RECRUITER_ID                                 NUMBER(18)      ,
 PRIMARY_WORK_LOCATION_ID                     NUMBER(18)      ,
 GRADE_ID                                     NUMBER(18)      ,
 ORGANIZATION_ID                              NUMBER(18)      ,
 JOB_FAMILY_ID                                NUMBER(18)      ,
 JOB_FUNCTION                                 VARCHAR2(30)    ,
 LEGAL_EMPLOYER_ID                            NUMBER(18)      ,
 BUSINESS_UNIT_ID                             NUMBER(18)      ,
 DEPARTMENT_ID                                NUMBER(18)      ,
 SOURCING_BUDGET                              NUMBER          ,
 TRAVEL_BUDGET                                NUMBER          ,
 RELOCATION_BUDGET                            NUMBER          ,
 EMPLOYEE_REFERRAL_BONUS                      NUMBER          ,
 BUDGET_CURRENCY                              VARCHAR2(30)    ,
 MAXIMUM_SALARY                               NUMBER          ,
 MINIMUM_SALARY                               NUMBER          ,
 PAY_FREQUENCY                                VARCHAR2(30)    ,
 SALARY_CURRENCY                              VARCHAR2(30)    ,
 WORKER_TYPE                                  VARCHAR2(30)    ,
 REGULAR_OR_TEMPORARY                         VARCHAR2(30)    ,
 MANAGEMENT_LEVEL                             VARCHAR2(30)    ,
 FULLTIME_OR_PARTTIME                         VARCHAR2(30)    ,
 JOB_SHIFT                                    VARCHAR2(30)    ,
 JOB_TYPE                                     VARCHAR2(30)    ,
 EDUCATION_LEVEL                              VARCHAR2(30)    ,
 CONTACT_NAME_EXTERNAL                        VARCHAR2(240)   ,
 CONTACT_EMAIL_EXTERNAL                       VARCHAR2(240)   ,
 EXTERNAL_SHORT_DESCRIPTION                   CLOB            ,
 EXTERNAL_DESCRIPTION                         CLOB            ,
 EXTERNAL_EMPLOYER_DESCRIPTION_ID             NUMBER(18)      ,
 EXTERNAL_ORG_DESCRIPTION_ID                  NUMBER(18)      ,
 CONTACT_NAME_INTERNAL                        VARCHAR2(240)   ,
 CONTACT_EMAIL_INTERNAL                       VARCHAR2(240)   ,
 INTERNAL_SHORT_DESCRIPTION                   CLOB            ,
 INTERNAL_DESCRIPTION                         CLOB            ,
 INTERNAL_EMPLOYER_DESCRIPTION_ID             NUMBER(18)      ,
 INTERNAL_ORG_DESCRIPTION_ID                  NUMBER(18)      ,
 DISPLAY_IN_ORG_CHART_FLAG                    VARCHAR2(1)     ,
 CURRENT_PHASE_ID                             NUMBER(18)      ,
 CURRENT_STATE_ID                             NUMBER(18)      ,
 COMMENTS                                     CLOB            ,
 JOB_CODE                                     VARCHAR2(30)    ,
 HIRING_MANAGER_PERSON_NUMBER                 NUMBER(30)      ,
 HIRING_MANAGER_ASSIGNMENT_NUMBER             NUMBER(30)      ,
 RECRUITER_PERSON_NUMBER                      NUMBER(30)      ,
 RECRUITER_ASSIGNMENT_NUMBER                  VARCHAR2(30)    ,
 PRIMARY_LOCATION_NAME                        VARCHAR2(360)   ,
 GRADE_CODE                                   VARCHAR2(30)    ,
 ORGANIZATION_CODE                            VARCHAR2(60)    ,
 JOB_FAMILY_NAME                              VARCHAR2(240)   ,
 LEGAL_EMPLOYER_NAME                          VARCHAR2(240)   ,
 BUSINESS_UNIT_SHORT_CODE                     VARCHAR2(150)   ,
 DEPARTMENT_NAME                              VARCHAR2(240)   ,
 CURRENT_PHASE_CODE                           VARCHAR2(30)    ,
 CURRENT_STATE_CODE                           VARCHAR2(30)    ,
 PRIMARY_WORK_LOCATION_CODE                   VARCHAR2(150)   ,
 BUDGET_CURRENCY_NAME                         VARCHAR2(80)    ,
 SALARY_CURRENCY_NAME                         VARCHAR2(80)    ,
 EXTERNAL_EMP_DESCRIPTION_CODE                VARCHAR2(30)    ,
 EXTERNAL_ORG_DESCRIPTION_CODE                VARCHAR2(30)    ,
 INTERNAL_EMP_DESCRIPTION_CODE                VARCHAR2(30)    ,
 INTERNAL_ORG_DESCRIPTION_CODE                VARCHAR2(30)    ,
 SUBMISSIONS_PROCESS_TEMPLATE_ID              NUMBER(18)      ,
 ORGANIZATION_NAME                            VARCHAR2(4000)  ,
 CLASSIFICATION_CODE                          VARCHAR2(40)    ,
 PRIMARY_LOCATION_ID                          NUMBER(18)      ,
 BASE_LANGUAGE_CODE                           VARCHAR2(30)    ,
 CANDIDATE_SELECTION_PROCESS_CODE             VARCHAR2(30)    ,
 JOB_FAMILY_CODE                              VARCHAR2(240)   ,
 EXTERNAL_APPLY_FLOW_ID                       NUMBER(18)      ,
 EXTERNAL_APPLY_FLOW_CODE                     VARCHAR2(30)    ,
 PIPELINE_REQUISITION_FLAG                    VARCHAR2(30)    ,
 PIPELINE_REQUISITION_ID                      NUMBER(18)      ,
 APPLY_WHEN_NOT_POSTED_FLAG                   VARCHAR2(30)    ,
 PIPELINE_REQUISITION_NUMBER                  VARCHAR2(240)   ,
 POSITION_ID                                  NUMBER(18)      ,
 POSITION_CODE                                VARCHAR2(30)    ,
 REQUISITION_TEMPLATE_ID                      NUMBER(18)      ,
 CODE                                         VARCHAR2(240)   ,
 AUTOMATIC_FILL_FLAG                          VARCHAR2(30)    ,
 SEND_NOTIFICATIONS_FLAG                      VARCHAR2(30)    ,
 EXTERNAL_DESCRIPTION_ID                      NUMBER(18)      ,
 INTERNAL_DESCRIPTION_ID                      NUMBER(18)      ,
 EXTERNAL_DESCRIPTION_CODE                    VARCHAR2(30)    ,
 INTERNAL_DESCRIPTION_CODE                    VARCHAR2(30)    ,
 AUTO_OPEN_REQUISITION                        VARCHAR2(30)    ,
 POSTING_EXPIRE_IN_DAYS                       NUMBER          ,
 AUTO_UNPOST_REQUISITION                      VARCHAR2(30)    ,
 UNPOST_FORMULA_ID                            NUMBER(18)      ,
 UNPOST_FORMULA_CODE                          VARCHAR2(80)    ,
 GUID                                         VARCHAR2(32)    ,
 SOURCE_SYSTEM_ID                             VARCHAR2(2000)  ,
 SOURCE_SYSTEM_OWNER                          VARCHAR2(256)   ,
 ATTRIBUTE_CATEGORY                           VARCHAR2(30)    ,
 ATTRIBUTE1                                   VARCHAR2(150)   ,
 ATTRIBUTE2                                   VARCHAR2(150)   ,
 ATTRIBUTE3                                   VARCHAR2(150)   ,
 ATTRIBUTE4                                   VARCHAR2(150)   ,
 ATTRIBUTE5                                   VARCHAR2(150)   ,
 ATTRIBUTE6                                   VARCHAR2(150)   ,
 ATTRIBUTE7                                   VARCHAR2(150)   ,
 ATTRIBUTE8                                   VARCHAR2(150)   ,
 ATTRIBUTE9                                   VARCHAR2(150)   ,
 ATTRIBUTE10                                  VARCHAR2(150)   ,
 ATTRIBUTE_NUMBER1                            NUMBER          ,
 ATTRIBUTE_NUMBER2                            NUMBER          ,
 ATTRIBUTE_NUMBER3                            NUMBER          ,
 ATTRIBUTE_NUMBER4                            NUMBER          ,
 ATTRIBUTE_NUMBER5                            NUMBER          ,
 ATTRIBUTE_DATE1                              DATE            ,
 ATTRIBUTE_DATE2                              DATE            ,
 ATTRIBUTE_DATE3                              DATE            ,
 ATTRIBUTE_DATE4                              DATE            ,
 ATTRIBUTE_DATE5                              DATE ,
BATCH_NAME                                   VARCHAR2(300)
); 

   
-- *********************************************
-- **JR-Background Check Screening Package Table
-- *********************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckScreeningPackage',
	---
	ACCOUNT_ID							NUMBER(18),
	ADDED_BY							VARCHAR2(64),
	ADDED_DATE							DATE,
	PROVISIONING_ID						NUMBER(18),
	REQ_SP_ASSGMNT_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SCR_PKG_CODE						VARCHAR2(30),
	SCR_PKG_NAME						VARCHAR2(500),
	REQUISITION_NUMBER					VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************************
-- **JR-Assessment Configuration Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'AssessmentConfiguration',
	---
	ASSESSMENT_CONFIG_ID				NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	PROVISIONING_ID						NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	MULTI_PHASE_CSP_FLAG				VARCHAR2(1),
	PARTNER_NAME						VARCHAR2(300),
	REQUISITION_NUMBER					VARCHAR2(240),
	ACCOUNT_ID							NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***************************************
-- **JR-Assessment Screening Package Table
-- ***************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'AssessmentScreeningPackage',
	---
	REQ_PACKAGE_ID						NUMBER(18),
	ASSESSMENT_CONFIG_ID				NUMBER(18),
	TRIGGER_TYPE_CODE					VARCHAR2(30),
	PACKAGE_CODE						VARCHAR2(30),
	PACKAGE_SEQUENCE					NUMBER(4),
	PHASE_ID							NUMBER(18),
	STATE_ID							NUMBER(18),
	PARTNER_NAME						VARCHAR2(300),
	REQUISITION_NUMBER					VARCHAR2(240),
	PROVISIONING_ID						NUMBER(18),
	ACCOUNT_ID							NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PACKAGE_NAME						VARCHAR2(500),
	PHASE_CODE							VARCHAR2(30),
	STATE_CODE							VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************************
-- **JR-Tax Credit Configuration Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TaxCreditConfiguration',
	---
	TC_REQ_CONFIG_ID					NUMBER(18),
	ACCOUNT_ID							NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PARTNER_NAME						VARCHAR2(300),
	PROVISIONING_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***************************************
-- **JR-Tax Credit Screening Package Table
-- ***************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TaxCreditScreeningPackage',
	---
	TC_REQ_PACKAGE_ID					NUMBER(18),
	TC_REQ_CONFIG_ID					NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	ACCOUNT_ID							NUMBER(18),
	PARTNER_NAME						VARCHAR2(300),
	PACKAGE_CODE						VARCHAR2(30),
	TRIGGER_TYPE_CODE					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	PROVISIONING_ID						NUMBER(18),
	PACKAGE_NAME						VARCHAR2(500),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *****************************************
-- **JR-Background Check Configuration Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckConfiguration',
	---
	ACCOUNT_ID							NUMBER(18),
	REQ_ACCOUNT_ID						NUMBER(18),
	MULTIPLE_REQUEST_FLAG				VARCHAR2(1),
	PROVISIONING_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ************************************************
-- **JR-Background Check Screening Package V2 Table
-- ************************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_V2_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckScreeningPackageV2',
	---
	ACCOUNT_ID							NUMBER(18),
	ADDED_BY							VARCHAR2(64),
	ADDED_DATE							DATE,
	PROVISIONING_ID						NUMBER(18),
	REQ_SP_ASSGMNT_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SCR_PKG_CODE						VARCHAR2(30),
	SCR_PKG_NAME						VARCHAR2(500),
	REQUISITION_NUMBER					VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PHASE_ID							NUMBER(18),
	STATE_ID							NUMBER(18),
	ENTERING_PHASE_FLAG					VARCHAR2(1),
	LEAVING_PHASE_FLAG					VARCHAR2(1),
	REQ_ACCOUNT_ID						NUMBER(18),
	PHASE_CODE							VARCHAR2(30),
	STATE_CODE							VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************************
-- **JR-Application Specific Question Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_APPL_SPEC_QSTN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ApplicationSpecificQuestion',
	---
	QSTNR_QUESTION_ID					NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	QSTNR_TYPE_CODE						VARCHAR2(64),
	QUESTION_ID							NUMBER(18),
	QUESTION_CODE						VARCHAR2(240),
	QSTN_VERSION_NUM					NUMBER(18),
	ADHOC_FLAG							VARCHAR2(30) DEFAULT 'N',
	SEQUENCE_NUMBER						NUMBER(9),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *********************
-- **JR-Attachment Table
-- *********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	TITLE								VARCHAR2(80),
	TFILE								CLOB,
	DATA_TYPE_CODE						VARCHAR2(80),
	URL_OR_FILENAME						VARCHAR2(200),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************
-- **JR-Hiring Team Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_HIRE_TEAM_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'HiringTeam',
	---
	TEAM_MEMBER_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	ASSIGNMENT_ID						NUMBER(18),
	MEMBER_TYPE							VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_NUMBER						VARCHAR2(30),
	ASSIGNMENT_NUMBER					VARCHAR2(30),
	REQUISITION_NUMBER					VARCHAR2(240),
	COLLABORATOR_TYPE					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                         VARCHAR2(300)
   );
   
   
-- **********************************
-- **JR-Interview Questionnaire Table
-- **********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_INTRVW_QSTNR_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InterviewQuestionnaire',
	---
	REQ_QSTNR_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	TEMPLATE_FLAG						VARCHAR2(30) DEFAULT 'N',
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	QSTNR_VERSION_NUM					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************
-- **JR-Job Profile Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_JOB_PROFL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'JobProfile',
	---
	PROFILE_ITEM_ID						NUMBER(18),
	CONTENT_ITEM_ID						NUMBER(18),
	CONTENT_TYPE_ID						NUMBER(18),
	COUNTRY_ID							NUMBER(18),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	IMPORTANCE							NUMBER(18),
	INTEREST_LEVEL						VARCHAR2(30),
	MANDATORY							VARCHAR2(30),
	PROFILE_ID							NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	SOURCE_TYPE							VARCHAR2(30),
	STATE_PROVINCE_ID					NUMBER(18),
	STATE_GEOGRAPHY_CODE				VARCHAR2(360),
	STATE_COUNTRY_CODE					VARCHAR2(2),
	COUNTRY_GEOGRAPHY_CODE				VARCHAR2(30),
	COUNTRY_COUNTRY_CODE				VARCHAR2(2),
	CONTENT_TYPE						VARCHAR2(240),
	CONTENT_ITEM						VARCHAR2(700),
	SECTION_ID							NUMBER(18),
	SECTION_NAME						VARCHAR2(300),
	ITEM_DATE_1							DATE,
	ITEM_DATE_2							DATE,
	ITEM_DATE_3							DATE,
	ITEM_DATE_4							DATE,
	ITEM_DATE_5							DATE,
	ITEM_DATE_6							DATE,
	ITEM_DATE_7							DATE,
	ITEM_DATE_8							DATE,
	ITEM_DATE_9							DATE,
	ITEM_DATE_10						DATE,
	ITEM_DECIMAL_1						NUMBER(15),
	ITEM_DECIMAL_2						NUMBER(15),
	ITEM_DECIMAL_3						NUMBER(15),
	ITEM_DECIMAL_4						NUMBER(15),
	ITEM_DECIMAL_5						NUMBER(15),
	ITEM_NUMBER_1						NUMBER(18),
	ITEM_NUMBER_2						NUMBER(18),
	ITEM_NUMBER_3						NUMBER(18),
	ITEM_NUMBER_4						NUMBER(18),
	ITEM_NUMBER_5						NUMBER(18),
	ITEM_NUMBER_6						NUMBER(18),
	ITEM_NUMBER_7						NUMBER(18),
	ITEM_NUMBER_8						NUMBER(18),
	ITEM_NUMBER_9						NUMBER(18),
	ITEM_NUMBER_10						NUMBER(18),
	ITEM_TEXT_20001						VARCHAR2(2000),
	ITEM_TEXT_20002						VARCHAR2(2000),
	ITEM_TEXT_20003						VARCHAR2(2000),
	ITEM_TEXT_20004						VARCHAR2(2000),
	ITEM_TEXT_20005						VARCHAR2(2000),
	ITEM_TEXT_2401						VARCHAR2(240),
	ITEM_TEXT_2402						VARCHAR2(240),
	ITEM_TEXT_2403						VARCHAR2(240),
	ITEM_TEXT_2404						VARCHAR2(240),
	ITEM_TEXT_2405						VARCHAR2(240),
	ITEM_TEXT_2406						VARCHAR2(240),
	ITEM_TEXT_2407						VARCHAR2(240),
	ITEM_TEXT_2408						VARCHAR2(240),
	ITEM_TEXT_2409						VARCHAR2(240),
	ITEM_TEXT_24010						VARCHAR2(240),
	ITEM_TEXT_24011						VARCHAR2(240),
	ITEM_TEXT_24012						VARCHAR2(240),
	ITEM_TEXT_24013						VARCHAR2(240),
	ITEM_TEXT_24014						VARCHAR2(240),
	ITEM_TEXT_24015						VARCHAR2(240),
	ITEM_TEXT_301						VARCHAR2(30),
	ITEM_TEXT_302						VARCHAR2(30),
	ITEM_TEXT_303						VARCHAR2(30),
	ITEM_TEXT_304						VARCHAR2(30),
	ITEM_TEXT_305						VARCHAR2(30),
	ITEM_TEXT_306						VARCHAR2(30),
	ITEM_TEXT_307						VARCHAR2(30),
	ITEM_TEXT_308						VARCHAR2(30),
	ITEM_TEXT_309						VARCHAR2(30),
	ITEM_TEXT_3010						VARCHAR2(30),
	ITEM_TEXT_3011						VARCHAR2(30),
	ITEM_TEXT_3012						VARCHAR2(30),
	ITEM_TEXT_3013						VARCHAR2(30),
	ITEM_TEXT_3014						VARCHAR2(30),
	ITEM_TEXT_3015						VARCHAR2(30),
	ITEM_CLOB_1							CLOB,
	ITEM_CLOB_2							CLOB,
	ITEM_CLOB_3							CLOB,
	ITEM_CLOB_4							CLOB,
	ITEM_CLOB_5							CLOB,
	QUALIFIER_ID_1						NUMBER(18),
	QUALIFIER_ID_2						NUMBER(18),
	RATING_LEVEL_ID_1					NUMBER(18),
	RATING_LEVEL_ID_2					NUMBER(18),
	RATING_LEVEL_ID_3					NUMBER(18),
	RATING_MODEL_ID_1					NUMBER(18),
	RATING_MODEL_ID_2					NUMBER(18),
	RATING_MODEL_ID_3					NUMBER(18),
	RATING_MODEL_CODE_1					VARCHAR2(30),
	RATING_MODEL_CODE_2					VARCHAR2(30),
	RATING_MODEL_CODE_3					VARCHAR2(30),
	RATING_LEVEL_CODE_1					VARCHAR2(30),
	RATING_LEVEL_CODE_2					VARCHAR2(30),
	RATING_LEVEL_CODE_3					VARCHAR2(30),
	QUALIFIER_CODE_1					VARCHAR2(30),
	QUALIFIER_CODE_2					VARCHAR2(30),
	QUALIFIER_SET_CODE_1				VARCHAR2(30),
	QUALIFIER_SET_CODE_2				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************
-- **JR-Other Location Table
-- *************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_OTHER_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OtherLocation',
	---
	REQ_LOCATION_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	OTHER_LOCATION_NAME					VARCHAR2(360),
	OTHER_LOCATION_ID					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **************************
-- **JR-Posting Details Table
-- **************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_POST_DET_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'PostingDetails',
	---
	PUBLISHED_JOB_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	START_DATE							DATE,
	END_DATE							DATE,
	EXTERNAL_OR_INTERNAL				VARCHAR2(30),
	POSTING_STATUS						VARCHAR2(30),
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                          VARCHAR2(300)
   );
   
   
-- ******************************
-- **JR-Other Work Location Table
-- ******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_OTHER_WORK_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OtherWorkLocation',
	---
	REQ_WORK_LOCATION_ID				NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	OTHER_WORK_LOCATION_ID				NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	OTHER_WORK_LOCATION_CODE			VARCHAR2(150),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *******************
-- **JR-Language Table
-- *******************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_LANG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Language',
	---
	LANGUAGE_CODE						VARCHAR2(4),
	REQ_LANGUAGE_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *********************
-- **JR-Media Link Table
-- *********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MediaLink',
	---
	REQ_MEDIA_LINK_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SEQUENCE_NUMBER						NUMBER(9),
	SHOW_ON_OFFERS_FLAG					VARCHAR2(30),
	VISIBILITY_CODE						VARCHAR2(30),
	MEDIA_TYPE_CODE						VARCHAR2(30),
	THUMBNAIL_URL						VARCHAR2(1000),
	TITLE								VARCHAR2(240),
	URL									VARCHAR2(1000),
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ******************************
-- **JR-Media Link Language Table
-- ******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_LANG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MediaLinkLanguage',
	---
	LANGUAGE_CODE						VARCHAR2(4),
	MEDIA_LINK_LANGUAGE_ID				NUMBER(18),
	SEQUENCE_NUMBER						NUMBER(9),
	REQUISITION_NUMBER					VARCHAR2(240),
	MEDIA_LINK_ID						NUMBER(18),
	REQ_MEDIA_LINK_ID					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************************
-- **Job Requisition Translation Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'JobRequisitionTranslation',
	---
	REQUISITION_ID						NUMBER(18),
	LANGUAGE							VARCHAR2(4),
	REQUISITION_TITLE					VARCHAR2(240),
	INTERNAL_REQUISITION_TITLE			VARCHAR2(240),
	INTERNAL_SHORT_DESCRIPTION			CLOB,
	INTERNAL_DESCRIPTION				CLOB,
	EXTERNAL_SHORT_DESCRIPTION			CLOB,
	EXTERNAL_DESCRIPTION				CLOB,
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ********************************
-- **Job Requisition Template Table
-- ********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_STG
   (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID 						NUMBER,
	MIGRATION_SET_NAME 						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME   								VARCHAR2(240),
	BG_ID            						NUMBER(15),	
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'JobRequisitionTemplate',
	---	
	REQUISITION_ID							NUMBER(18),
	CODE									VARCHAR2(100),
	RECRUITING_TYPE							VARCHAR2(30),
	JOB_ID									NUMBER(18),
	REQUISITION_TITLE						VARCHAR2(240),
	INTERNAL_REQUISITION_TITLE				VARCHAR2(240),
	HIRING_MANAGER_ID						NUMBER(18),
	RECRUITER_ID							NUMBER(18),
	PRIMARY_WORK_LOCATION_ID				NUMBER(18),
	GRADE_ID								NUMBER(18),
	ORGANIZATION_ID							NUMBER(18),
	JOB_FAMILY_ID							NUMBER(18),
	JOB_FUNCTION							NUMBER(18),
	LEGAL_EMPLOYER_ID						NUMBER(18),
	BUSINESS_UNIT_ID						NUMBER(18),
	DEPARTMENT_ID							NUMBER(18),
	SOURCING_BUDGET							VARCHAR2(100),
	TRAVEL_BUDGET							VARCHAR2(100),
	RELOCATION_BUDGET						VARCHAR2(100),
	EMPLOYEE_REFERRAL_BONUS					VARCHAR2(100),
	BUDGET_CURRENCY							VARCHAR2(30),
	MAXIMUM_SALARY					    	NUMBER,
	MINIMUM_SALARY							NUMBER,
	PAY_FREQUENCY							VARCHAR2(30),
	SALARY_CURRENCY							VARCHAR2(30),
	WORKER_TYPE								VARCHAR2(30),
	REGULAR_OR_TEMPORARY					VARCHAR2(30),
	MANAGEMENT_LEVEL						VARCHAR2(30),
	FULLTIME_OR_PARTTIME					VARCHAR2(30),
	JOB_SHIFT								VARCHAR2(30),
	JOB_TYPE								VARCHAR2(30),
	EDUCATION_LEVEL							VARCHAR2(30),
	CONTACT_NAME_EXTERNAL					VARCHAR2(240),
	CONTACT_EMAIL_EXTERNAL					VARCHAR2(240),
	EXTERNAL_SHORT_DESCRIPTION				CLOB,
	EXTERNAL_DESCRIPTION					CLOB,
	EXTERNAL_EMPLOYER_DESCRIPTION_ID		NUMBER(18),
	EXTERNAL_ORGANIZATION_DESCRIPTION_ID	NUMBER(18),
	CONTACT_NAME_INTERNAL					VARCHAR2(240),
	CONTACT_EMAIL_INTERNAL					VARCHAR2(240),
	INTERNAL_SHORT_DESCRIPTION				CLOB,
	INTERNAL_DESCRIPTION					CLOB,
	INTERNAL_EMPLOYER_DESCRIPTION_ID		NUMBER(18),
	INTERNAL_ORGANIZATION_DESCRIPTION_ID	NUMBER(18),
	CURRENT_STATE_ID						NUMBER(18),
	JOB_CODE								VARCHAR2(30),
	HIRING_MANAGER_PERSON_NUMBER			NUMBER(30),
	RECRUITER_PERSON_NUMBER					NUMBER(30),
	PRIMARY_LOCATION_NAME					NUMBER(30),
	GRADE_CODE								VARCHAR2(30),
	ORGANIZATION_CODE						VARCHAR2(60),
	JOB_FAMILY_NAME							VARCHAR2(240),
	LEGAL_EMPLOYER_NAME						VARCHAR2(240),
	BUSINESS_UNIT_SHORT_CODE				VARCHAR2(150),
	DEPARTMENT_NAME							VARCHAR2(240),
	CURRENT_STATE_CODE						VARCHAR2(30),
	PRIMARY_WORK_LOCATION_CODE				VARCHAR2(150),
	BUDGET_CURRENCY_NAME					VARCHAR2(80),
	SALARY_CURRENCY_NAME					VARCHAR2(80),
	EXTERNAL_EMPLOYER_DESCRIPTION_CODE		VARCHAR2(30),
	EXTERNAL_ORGANIZATION_DESCRIPTION_CODE	VARCHAR2(30),
	INTERNAL_EMPLOYER_DESCRIPTION_CODE		VARCHAR2(30),
	INTERNAL_ORGANIZATION_DESCRIPTION_CODE	VARCHAR2(30),
	ORGANIZATION_NAME						VARCHAR2(4000),
	CLASSIFICATION_CODE						VARCHAR2(40),
	PRIMARY_LOCATION_ID						NUMBER(18),
	BASE_LANGUAGE_CODE						VARCHAR2(30),
	SUBMISSIONS_PROCESS_TEMPLATE_ID			NUMBER(18),
	CANDIDATE_SELECTION_PROCESS_CODE		VARCHAR2(30),
	JOB_FAMILY_CODE							VARCHAR2(240),
	EXTERNAL_APPLY_FLOW_ID					NUMBER(18),
	EXTERNAL_APPLY_FLOW_CODE				VARCHAR2(30),
	REQ_USAGE_TYPE							VARCHAR2(100),
	TEMPLATE_NAME							VARCHAR2(30),
	INTERNAL_DESCRIPTION_ID					NUMBER(18),
	EXTERNAL_DESCRIPTION_ID					NUMBER(18),
	INTERNAL_DESCRIPTION_CODE				VARCHAR2(30),
	EXTERNAL_DESCRIPTION_CODE				VARCHAR2(30),
	AUTO_OPEN_REQUISITION					VARCHAR2(30),
	POSTING_EXPIRE_IN_DAYS					NUMBER,
	APPLY_WHEN_NOT_POSTED_FLAG				VARCHAR2(30),
	AUTOMATIC_FILL_FLAG						VARCHAR2(30),
	DISPLAY_IN_ORG_CHART_FLAG				VARCHAR2(1),
	AUTO_UNPOST_REQUISITION					VARCHAR2(30),
	UNPOST_FORMULA_ID						NUMBER(18),
	UNPOST_FORMULA_CODE						VARCHAR2(80),
	GUID									VARCHAR2(32),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(256),
	---	
	ATTRIBUTE_CATEGORY 						VARCHAR2(30),
	ATTRIBUTE1 								VARCHAR2(150),
	ATTRIBUTE2 								VARCHAR2(150),
	ATTRIBUTE3 								VARCHAR2(150),
	ATTRIBUTE4 								VARCHAR2(150),
	ATTRIBUTE5 								VARCHAR2(150),
	ATTRIBUTE6 								VARCHAR2(150),
	ATTRIBUTE7 								VARCHAR2(150),
	ATTRIBUTE8 								VARCHAR2(150),
	ATTRIBUTE9 								VARCHAR2(150),
	ATTRIBUTE10 							VARCHAR2(150),
	ATTRIBUTE_NUMBER1 						NUMBER, 
	ATTRIBUTE_NUMBER2 						NUMBER, 
	ATTRIBUTE_NUMBER3 						NUMBER, 
	ATTRIBUTE_NUMBER4 						NUMBER, 
	ATTRIBUTE_NUMBER5 						NUMBER, 
	ATTRIBUTE_DATE1 						DATE, 
	ATTRIBUTE_DATE2 						DATE, 
	ATTRIBUTE_DATE3 						DATE,  
	ATTRIBUTE_DATE4 						DATE, 
	ATTRIBUTE_DATE5 						DATE
   );
   
   
-- *******************************
-- **JRT-Template Media Link Table
-- *******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_TEMPL_MEDIA_LINK_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TemplateMediaLink',
	---
	REQ_MEDIA_LINK_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SEQUENCE_NUMBER						NUMBER(9),
	SHOW_ON_OFFERS_FLAG					VARCHAR2(30),
	VISIBILITY_CODE						VARCHAR2(30),
	THUMBNAIL_URL						VARCHAR2(1000),
	MEDIA_TYPE_CODE						VARCHAR2(30),
	TITLE								VARCHAR2(240),
	URL									VARCHAR2(1000),
	CODE								VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *******************************
-- **JRT-Media Link Language Table
-- *******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_MEDIA_LINK_LANG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MediaLinkLanguage',
	---
	LANGUAGE_CODE						VARCHAR2(4),
	MEDIA_LINK_ID						NUMBER(18),
	MEDIA_LINK_LANGUAGE_ID				NUMBER(18),
	SEQUENCE_NUMBER						NUMBER(9),
	CODE								VARCHAR2(240),
	REQ_MEDIA_LINK_ID					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************************************
-- **JRT-Background Check Screening Package Table
-- **********************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckScreeningPackage',
	---
	ACCOUNT_ID							NUMBER(18),
	ADDED_BY							VARCHAR2(64),
	ADDED_DATE							DATE,
	PROVISIONING_ID						NUMBER(18),
	REQ_SP_ASSGMNT_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SCR_PKG_CODE						VARCHAR2(30),
	SCR_PKG_NAME						VARCHAR2(500),
	CODE								VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ************************************
-- **JRT-Assessment Configuration Table
-- ************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'AssessmentConfiguration',
	---
	ASSESSMENT_CONFIG_ID				NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	PROVISIONING_ID						NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	MULTI_PHASE_CSP_FLAG				VARCHAR2(1),
	PARTNER_NAME						VARCHAR2(300),
	CODE								VARCHAR2(240),
	ACCOUNT_ID							NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************************
-- **JRT-Assessment Screening Package Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'AssessmentScreeningPackage',
	---
	REQ_PACKAGE_ID						NUMBER(18),
	ASSESSMENT_CONFIG_ID				NUMBER(18),
	TRIGGER_TYPE_CODE					VARCHAR2(30),
	PACKAGE_CODE						VARCHAR2(30),
	PACKAGE_SEQUENCE					NUMBER(4),
	PHASE_ID							NUMBER(18),
	STATE_ID							NUMBER(18),
	PARTNER_NAME						VARCHAR2(300),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	PROVISIONING_ID						NUMBER(18),
	ACCOUNT_ID							NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PACKAGE_NAME						VARCHAR2(500),
	PHASE_CODE							VARCHAR2(30),
	STATE_CODE							VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ************************************
-- **JRT-Tax Credit Configuration Table
-- ************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TaxCreditConfiguration',
	---
	TC_REQ_CONFIG_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	PROVISIONING_ID						NUMBER(18),
	ACCOUNT_ID							NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PARTNER_NAME						VARCHAR2(300),
	CODE								VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************************
-- **JRT-Tax Credit Screening Package Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_SCRN_PKG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TaxCreditScreeningPackage',
	---
	TC_REQ_PACKAGE_ID					NUMBER(18),
	TC_REQ_CONFIG_ID					NUMBER(18),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	ACCOUNT_ID							NUMBER(18),
	PARTNER_NAME						VARCHAR2(300),
	PACKAGE_CODE						VARCHAR2(30),
	TRIGGER_TYPE_CODE					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	PROVISIONING_ID						NUMBER(18),
	PACKAGE_NAME						VARCHAR2(500),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ******************************************
-- **JRT-Background Check Configuration Table
-- ******************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_CONFIG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckConfiguration',
	---
	ACCOUNT_ID							NUMBER(18),
	REQ_ACCOUNT_ID						NUMBER(18),
	MULTIPLE_REQUEST_FLAG				VARCHAR2(1),
	PROVISIONING_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************************************
-- **JRT-Background Check Screening Package V2 Table
-- *************************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_V2_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'BackgroundCheckScreeningPackageV2',
	---
	ACCOUNT_ID							NUMBER(18),
	ADDED_BY							VARCHAR2(64),
	ADDED_DATE							DATE,
	PROVISIONING_ID						NUMBER(18),
	REQ_SP_ASSGMNT_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	SCR_PKG_CODE						VARCHAR2(30),
	SCR_PKG_NAME						VARCHAR2(500),
	CODE								VARCHAR2(240),
	PARTNER_NAME						VARCHAR2(300),
	ACCOUNT_USER_NAME					VARCHAR2(100),
	PHASE_ID							NUMBER(18),
	STATE_ID							NUMBER(18),
	ENTERING_PHASE_FLAG					VARCHAR2(1),
	LEAVING_PHASE_FLAG					VARCHAR2(1),
	REQ_ACCOUNT_ID						NUMBER(18),
	PHASE_CODE							VARCHAR2(30),
	STATE_CODE							VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *****************************************
-- **JRT-Application Specific Question Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_APPL_SPEC_QSTN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ApplicationSpecificQuestion',
	---
	QSTNR_QUESTION_ID					NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	QSTNR_TYPE_CODE						VARCHAR2(64),
	QUESTION_ID							NUMBER(18),
	QUESTION_CODE						VARCHAR2(240),
	QSTN_VERSION_NUM					NUMBER(18),
	ADHOC_FLAG							VARCHAR2(30),
	SEQUENCE_NUMBER						NUMBER(9),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************
-- **JRT-Attachment Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	TITLE								VARCHAR2(80),
	TFILE								CLOB,
	DATA_TYPE_CODE						VARCHAR2(80),
	URL_OR_FILENAME						VARCHAR2(200),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************
-- **JRT-Hiring Team Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_HIRE_TEAM_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'HiringTeam',
	---
	TEAM_MEMBER_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	ASSIGNMENT_ID						NUMBER(18),
	MEMBER_TYPE							VARCHAR2(30),
	CODE								VARCHAR2(240),
	PERSON_NUMBER						VARCHAR2(30),
	ASSIGNMENT_NUMBER					VARCHAR2(30),
	COLLABORATOR_TYPE					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************************
-- **JRT-Interview Questionnaire Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_INTRVW_QSTNR_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InterviewQuestionnaire',
	---
	REQ_QSTNR_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	CODE								VARCHAR2(240),
	TEMPLATE_FLAG						VARCHAR2(30),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	QSTNR_VERSION_NUM					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***********************
-- **JRT-Job Profile Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_JOB_PROFL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'JobProfile',
	---
	PROFILE_ITEM_ID						NUMBER(18),
	CONTENT_ITEM_ID						NUMBER(18),
	CONTENT_TYPE_ID						NUMBER(18),
	COUNTRY_ID							NUMBER(18),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	IMPORTANCE							NUMBER(18),
	INTEREST_LEVEL						VARCHAR2(30),
	MANDATORY							VARCHAR2(30),
	PROFILE_ID							NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	SOURCE_TYPE							VARCHAR2(30),
	STATE_PROVINCE_ID					NUMBER(18),
	STATE_GEOGRAPHY_CODE				VARCHAR2(360),
	STATE_COUNTRY_CODE					VARCHAR2(2),
	COUNTRY_GEOGRAPHY_CODE				VARCHAR2(30),
	COUNTRY_COUNTRY_CODE				VARCHAR2(2),
	CONTENT_TYPE						VARCHAR2(240),
	CONTENT_ITEM						VARCHAR2(700),
	SECTION_ID							NUMBER(18),
	SECTION_NAME						VARCHAR2(300),
	ITEM_DATE_1							DATE,
	ITEM_DATE_2							DATE,
	ITEM_DATE_3							DATE,
	ITEM_DATE_4							DATE,
	ITEM_DATE_5							DATE,
	ITEM_DATE_6							DATE,
	ITEM_DATE_7							DATE,
	ITEM_DATE_8							DATE,
	ITEM_DATE_9							DATE,
	ITEM_DATE_10						DATE,
	ITEM_DECIMAL_1						NUMBER(15),
	ITEM_DECIMAL_2						NUMBER(15),
	ITEM_DECIMAL_3						NUMBER(15),
	ITEM_DECIMAL_4						NUMBER(15),
	ITEM_DECIMAL_5						NUMBER(15),
	ITEM_NUMBER_1						NUMBER(18),
	ITEM_NUMBER_2						NUMBER(18),
	ITEM_NUMBER_3						NUMBER(18),
	ITEM_NUMBER_4						NUMBER(18),
	ITEM_NUMBER_5						NUMBER(18),
	ITEM_NUMBER_6						NUMBER(18),
	ITEM_NUMBER_7						NUMBER(18),
	ITEM_NUMBER_8						NUMBER(18),
	ITEM_NUMBER_9						NUMBER(18),
	ITEM_NUMBER_10						NUMBER(18),
	ITEM_TEXT_20001						VARCHAR2(2000),
	ITEM_TEXT_20002						VARCHAR2(2000),
	ITEM_TEXT_20003						VARCHAR2(2000),
	ITEM_TEXT_20004						VARCHAR2(2000),
	ITEM_TEXT_20005						VARCHAR2(2000),
	ITEM_TEXT_2401						VARCHAR2(240),
	ITEM_TEXT_2402						VARCHAR2(240),
	ITEM_TEXT_2403						VARCHAR2(240),
	ITEM_TEXT_2404						VARCHAR2(240),
	ITEM_TEXT_2405						VARCHAR2(240),
	ITEM_TEXT_2406						VARCHAR2(240),
	ITEM_TEXT_2407						VARCHAR2(240),
	ITEM_TEXT_2408						VARCHAR2(240),
	ITEM_TEXT_2409						VARCHAR2(240),
	ITEM_TEXT_24010						VARCHAR2(240),
	ITEM_TEXT_24011						VARCHAR2(240),
	ITEM_TEXT_24012						VARCHAR2(240),
	ITEM_TEXT_24013						VARCHAR2(240),
	ITEM_TEXT_24014						VARCHAR2(240),
	ITEM_TEXT_24015						VARCHAR2(240),
	ITEM_TEXT_301						VARCHAR2(30),
	ITEM_TEXT_302						VARCHAR2(30),
	ITEM_TEXT_303						VARCHAR2(30),
	ITEM_TEXT_304						VARCHAR2(30),
	ITEM_TEXT_305						VARCHAR2(30),
	ITEM_TEXT_306						VARCHAR2(30),
	ITEM_TEXT_307						VARCHAR2(30),
	ITEM_TEXT_308						VARCHAR2(30),
	ITEM_TEXT_309						VARCHAR2(30),
	ITEM_TEXT_3010						VARCHAR2(30),
	ITEM_TEXT_3011						VARCHAR2(30),
	ITEM_TEXT_3012						VARCHAR2(30),
	ITEM_TEXT_3013						VARCHAR2(30),
	ITEM_TEXT_3014						VARCHAR2(30),
	ITEM_TEXT_3015						VARCHAR2(30),
	ITEM_CLOB_1							CLOB,
	ITEM_CLOB_2							CLOB,
	ITEM_CLOB_3							CLOB,
	ITEM_CLOB_4							CLOB,
	ITEM_CLOB_5							CLOB,
	QUALIFIER_ID_1						NUMBER(18),
	QUALIFIER_ID_2						NUMBER(18),
	RATING_LEVEL_ID_1					NUMBER(18),
	RATING_LEVEL_ID_2					NUMBER(18),
	RATING_LEVEL_ID_3					NUMBER(18),
	RATING_MODEL_ID_1					NUMBER(18),
	RATING_MODEL_ID_2					NUMBER(18),
	RATING_MODEL_ID_3					NUMBER(18),
	RATING_MODEL_CODE_1					VARCHAR2(30),
	RATING_MODEL_CODE_2					VARCHAR2(30),
	RATING_MODEL_CODE_3					VARCHAR2(30),
	RATING_LEVEL_CODE_1					VARCHAR2(30),
	RATING_LEVEL_CODE_2					VARCHAR2(30),
	RATING_LEVEL_CODE_3					VARCHAR2(30),
	QUALIFIER_CODE_1					VARCHAR2(30),
	QUALIFIER_CODE_2					VARCHAR2(30),
	QUALIFIER_SET_CODE_1				VARCHAR2(30),
	QUALIFIER_SET_CODE_2				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **************************
-- **JRT-Other Location Table
-- **************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OtherLocation',
	---
	REQ_LOCATION_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	OTHER_LOCATION_NAME					VARCHAR2(360),
	OTHER_LOCATION_ID					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *******************************
-- **JRT-Other Work Location Table
-- *******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_WORK_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OtherWorkLocation',
	---
	REQ_WORK_LOCATION_ID				NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	OTHER_WORK_LOCATION_ID				NUMBER(18),
	CODE								VARCHAR2(240),
	OTHER_WORK_LOCATION_CODE			VARCHAR2(150),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ********************
-- **JRT-Language Table
-- ********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JRT_LANG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Language',
	---
	LANGUAGE_CODE						VARCHAR2(4),
	REQ_LANGUAGE_ID						NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	CODE								VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ********************************************
-- **Job Requisition Template Translation Table
-- ********************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'JobRequisitionTemplateTranslation',
	---
	REQUISITION_ID						NUMBER(18),
	LANGUAGE							VARCHAR2(4),
	REQUISITION_TITLE					VARCHAR2(240),
	INTERNAL_REQUISITION_TITLE			VARCHAR2(240),
	INTERNAL_SHORT_DESCRIPTION			CLOB,
	INTERNAL_DESCRIPTION				CLOB,
	EXTERNAL_SHORT_DESCRIPTION			CLOB,
	EXTERNAL_DESCRIPTION				CLOB,
	CODE								VARCHAR2(240),
	TEMPLATE_NAME						VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ******************************
-- **Media Link Translation Table
-- ******************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_MEDIA_LINK_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MediaLinkTranslation',
	---
	LANGUAGE							VARCHAR2(4),
	MEDIA_LINK_ID						NUMBER(18),
	TITLE								VARCHAR2(240),
	SEQUENCE_NUMBER						NUMBER(9),
	REQUISITION_NUMBER					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ***************************************
-- **Template Media Link Translation Table
-- ***************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_TEMPL_MEDIA_LINK_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TemplateMediaLinkTranslation',
	---
	LANGUAGE							VARCHAR2(4),
	MEDIA_LINK_ID						NUMBER(18),
	TITLE								VARCHAR2(240),
	SEQUENCE_NUMBER						NUMBER(9),
	CODE								VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *****************
-- **Candidate Table
-- *****************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Candidate',
	---
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	OBJECT_STATUS						VARCHAR2(30),
	PREF_PHONE_CNT_TYPE_CODE			VARCHAR2(30),
	AVAILABILITY_DATE					DATE,
	SEARCH_DATE							DATE,
	CAND_LAST_MODIFIED_DATE				DATE,
	ADDED_BY_FLOW_CODE					VARCHAR2(30),
	CONFIRMED_FLAG						VARCHAR2(1),
	VISIBLE_TO_CANDIDATE_FLAG			VARCHAR2(1),
	START_DATE							DATE,
	DATE_OF_BIRTH						DATE,
	DATE_OF_DEATH						DATE,
	COUNTRY_OF_BIRTH					VARCHAR2(240),
	REGION_OF_BIRTH						VARCHAR2(240),
	TOWN_OF_BIRTH						VARCHAR2(240),
	OPT_IN_MKT_EMAILS_DATE				DATE,
	OPT_IN_MKT_EMAILS_FLAG				VARCHAR2(30),
	CAND_PREF_LANGUAGE_CODE				VARCHAR2(4),
	SOURCE								VARCHAR2(32),
	SOURCE_MEDIUM						VARCHAR2(32),
	ADD_TO_POOL_NAME					VARCHAR2(240),
	POOL_OWNER_PERSON_NUMBER			VARCHAR2(30),
	POOL_OWNER_PERSON_ID				NUMBER(18),
	CATEGORY_CODE						VARCHAR2(80),
	PHONE_VERIFIED_FLAG					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                          VARCHAR2(300)
   );
   
   
-- *****************************
-- **Candidate Interaction Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_INTERACT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateInteraction',
	---
	ADDED_BY_PERSON_ID					NUMBER(18),
	PERSON_ID							NUMBER(18),
	INTERACTION_DATE					DATE,
	INTERACTION_ID						NUMBER(18),
	INTERACTION_TYPE_CODE				VARCHAR2(30),
	TEXT								CLOB,
	CANDIDATE_NUMBER					VARCHAR2(30),
	ADDED_BY_PERSON_NUMBER				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************
-- **Candidate Preference Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PREF_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePreference',
	---
	CAND_PREF_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	OPT_IN_TC_EMAILS_DATE				DATE,
	OPT_IN_TC_EMAILS_FLAG				VARCHAR2(30),
	SITE_NUMBER							VARCHAR2(240),
	TC_CONFIRMED_DATE					DATE,
	TC_CONFIRMED_FLAG					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **************************************
-- **Candidate Preferred Job Family Table
-- **************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_JOB_FAM_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePreferredJobFamily',
	---
	PREF_JOB_FAMILY_ID					NUMBER(18),
	CAND_PREF_ID						NUMBER(18),
	JOB_FAMILY_ID						NUMBER(18),
	JOB_FAMILY_CODE						VARCHAR2(240),
	JOB_FAMILY_NAME						VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	SITE_NUMBER							VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ************************************
-- **Candidate Preferred Location Table
-- ************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePreferredLocation',
	---
	PREF_LOC_ID							NUMBER(18),
	CAND_PREF_ID						NUMBER(18),
	LOCATION_ID							NUMBER(18),
	LOCATION_NAME						VARCHAR2(360),
	CANDIDATE_NUMBER					VARCHAR2(30),
	SITE_NUMBER							VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************************
-- **Candidate Preferred Organization Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_ORG_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePreferredOrganization',
	---
	CAND_PREF_ID						NUMBER(18),
	ORGANIZATION_ID						NUMBER(18),
	ORGANIZATION_NAME					VARCHAR2(4000),
	ORGANIZATION_CODE					VARCHAR2(500),
	CLASSIFICATION_CODE					VARCHAR2(40),
	PREF_ORG_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	SITE_NUMBER							VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************************
-- **Candidate National Identifier Table
-- *************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_NAT_IDENFR_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateNationalIdentifier',
	---
	NATIONAL_IDENTIFIER_ID				NUMBER(18),
	NATIONAL_IDENTIFIER_NUMBER			VARCHAR2(30),
	NATIONAL_IDENTIFIER_TYPE			VARCHAR2(30),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	EXPIRATION_DATE						DATE,
	ISSUE_DATE							DATE,
	LEGISLATION_CODE					VARCHAR2(30),
	PLACE_OF_ISSUE						VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************
-- **Candidate Profile Table
-- *************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PROFL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateProfile',
	---
	PROFILE_ITEM_ID						NUMBER(18),
	CONTENT_ITEM_ID						NUMBER(18),
	CONTENT_TYPE_ID						NUMBER(18),
	COUNTRY_ID							NUMBER(18),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	IMPORTANCE							NUMBER(18),
	INTEREST_LEVEL						VARCHAR2(30),
	MANDATORY							VARCHAR2(30),
	SOURCE_TYPE							VARCHAR2(30),
	STATE_PROVINCE_ID					NUMBER(18),
	STATE_GEOGRAPHY_CODE				VARCHAR2(360),
	STATE_COUNTRY_CODE					VARCHAR2(20),
	COUNTRY_GEOGRAPHY_CODE				VARCHAR2(30),
	COUNTRY_COUNTRY_CODE				VARCHAR2(2),
	CONTENT_TYPE						VARCHAR2(240),
	CONTENT_ITEM						VARCHAR2(700),
	PERSON_ID							NUMBER,
	CANDIDATE_NUMBER					VARCHAR2(30),
	SECTION_ID							NUMBER(18),
	SECTION_CONTEXT						VARCHAR2(300),
	ITEM_DATE_1							DATE,
	ITEM_DATE_2							DATE,
	ITEM_DATE_3							DATE,
	ITEM_DATE_4							DATE,
	ITEM_DATE_5							DATE,
	ITEM_DATE_6							DATE,
	ITEM_DATE_7							DATE,
	ITEM_DATE_8							DATE,
	ITEM_DATE_9							DATE,
	ITEM_DATE_10						DATE,
	ITEM_DECIMAL_1						NUMBER(15),
	ITEM_DECIMAL_2						NUMBER(15),
	ITEM_DECIMAL_3						NUMBER(15),
	ITEM_DECIMAL_4						NUMBER(15),
	ITEM_DECIMAL_5						NUMBER(15),
	ITEM_NUMBER_1						NUMBER(18),
	ITEM_NUMBER_2						NUMBER(18),
	ITEM_NUMBER_3						NUMBER(18),
	ITEM_NUMBER_4						NUMBER(18),
	ITEM_NUMBER_5						NUMBER(18),
	ITEM_NUMBER_6						NUMBER(18),
	ITEM_NUMBER_7						NUMBER(18),
	ITEM_NUMBER_8						NUMBER(18),
	ITEM_NUMBER_9						NUMBER(18),
	ITEM_NUMBER_10						NUMBER(18),
	ITEM_TEXT_20001						VARCHAR2(2000),
	ITEM_TEXT_20002						VARCHAR2(2000),
	ITEM_TEXT_20003						VARCHAR2(2000),
	ITEM_TEXT_20004						VARCHAR2(2000),
	ITEM_TEXT_20005						VARCHAR2(2000),
	ITEM_TEXT_2401						VARCHAR2(240),
	ITEM_TEXT_2402						VARCHAR2(240),
	ITEM_TEXT_2403						VARCHAR2(240),
	ITEM_TEXT_2404						VARCHAR2(240),
	ITEM_TEXT_2405						VARCHAR2(240),
	ITEM_TEXT_2406						VARCHAR2(240),
	ITEM_TEXT_2407						VARCHAR2(240),
	ITEM_TEXT_2408						VARCHAR2(240),
	ITEM_TEXT_2409						VARCHAR2(240),
	ITEM_TEXT_24010						VARCHAR2(240),
	ITEM_TEXT_24011						VARCHAR2(240),
	ITEM_TEXT_24012						VARCHAR2(240),
	ITEM_TEXT_24013						VARCHAR2(240),
	ITEM_TEXT_24014						VARCHAR2(240),
	ITEM_TEXT_24015						VARCHAR2(240),
	ITEM_TEXT_301						VARCHAR2(30),
	ITEM_TEXT_302						VARCHAR2(30),
	ITEM_TEXT_303						VARCHAR2(30),
	ITEM_TEXT_304						VARCHAR2(30),
	ITEM_TEXT_305						VARCHAR2(30),
	ITEM_TEXT_306						VARCHAR2(30),
	ITEM_TEXT_307						VARCHAR2(30),
	ITEM_TEXT_308						VARCHAR2(30),
	ITEM_TEXT_309						VARCHAR2(30),
	ITEM_TEXT_3010						VARCHAR2(30),
	ITEM_TEXT_3011						VARCHAR2(30),
	ITEM_TEXT_3012						VARCHAR2(30),
	ITEM_TEXT_3013						VARCHAR2(30),
	ITEM_TEXT_3014						VARCHAR2(30),
	ITEM_TEXT_3015						VARCHAR2(30),
	ITEM_CLOB_1							CLOB,
	ITEM_CLOB_2							CLOB,
	ITEM_CLOB_3							CLOB,
	ITEM_CLOB_4							CLOB,
	ITEM_CLOB_5							CLOB,
	QUALIFIER_ID_1						NUMBER(18),
	QUALIFIER_ID_2						NUMBER(18),
	QUALIFIER_CODE_1					VARCHAR2(30),
	QUALIFIER_CODE_2					VARCHAR2(30),
	QUALIFIER_SET_CODE_1				VARCHAR2(30),
	QUALIFIER_SET_CODE_2				VARCHAR2(30),
	RATING_LEVEL_ID_1					NUMBER(18),
	RATING_LEVEL_ID_2					NUMBER(18),
	RATING_LEVEL_ID_3					NUMBER(18),
	RATING_MODEL_ID_1					NUMBER(18),
	RATING_MODEL_ID_2					NUMBER(18),
	RATING_MODEL_ID_3					NUMBER(18),
	RATING_MODEL_CODE_1					VARCHAR2(30),
	RATING_MODEL_CODE_2					VARCHAR2(30),
	RATING_MODEL_CODE_3					VARCHAR2(30),
	RATING_LEVEL_CODE_1					VARCHAR2(30),
	RATING_LEVEL_CODE_2					VARCHAR2(30),
	RATING_LEVEL_CODE_3					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************
-- **Candidate Address Table
-- *************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_ADDRESS_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateAddress',
	---
	PERSON_ADDR_USAGE_ID				NUMBER(18),
	EFFECTIVE_START_DATE				DATE,
	EFFECTIVE_END_DATE					DATE,
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	ADDRESS_TYPE						VARCHAR2(30),
	ADDRESS_LINE_1						VARCHAR2(240),
	ADDRESS_LINE_2						VARCHAR2(240),
	ADDRESS_LINE_3						VARCHAR2(240),
	ADDRESS_LINE_4						VARCHAR2(240),
	TOWN_OR_CITY						VARCHAR2(30),
	REGION_1							VARCHAR2(120),
	REGION_2							VARCHAR2(120),
	REGION_3							VARCHAR2(120),
	COUNTRY								VARCHAR2(60),
	COUNTRY_CODE						VARCHAR2(60),
	POSTAL_CODE							VARCHAR2(30),
	LONG_POSTAL_CODE					VARCHAR2(30),
	ADDL_ADDRESS_ATTRIBUTE_1			VARCHAR2(150),
	ADDL_ADDRESS_ATTRIBUTE_2			VARCHAR2(150),
	ADDL_ADDRESS_ATTRIBUTE_3			VARCHAR2(150),
	ADDL_ADDRESS_ATTRIBUTE_4			VARCHAR2(150),
	ADDL_ADDRESS_ATTRIBUTE_5			VARCHAR2(150),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                          VARCHAR2(300)
   );
   
   
-- ***********************
-- **Candidate Email Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_EMAIL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateEmail',
	---
	EMAIL_ADDRESS_ID					NUMBER(18),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	EMAIL_TYPE							VARCHAR2(30),
	EMAIL_ADDRESS						VARCHAR2(240),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	PRIMARY_EMAIL_FLAG					VARCHAR2(30),
	USE_FOR_COMMUNICATION				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                          VARCHAR2(300)
   );
   
   
-- **********************
-- **Candidate Name Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_NAME_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateName',
	---
	PERSON_NAME_ID						NUMBER(18),
	EFFECTIVE_START_DATE				DATE,
	EFFECTIVE_END_DATE					DATE,
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	NAME_TYPE							VARCHAR2(30),
	LEGISLATION_CODE					VARCHAR2(4) ,
	CHAR_SET_CONTEXT					VARCHAR2(4),
	FIRST_NAME							VARCHAR2(150),
	LAST_NAME							VARCHAR2(150),
	MIDDLE_NAMES						VARCHAR2(80),
	SUFFIX								VARCHAR2(80),
	HONORS								VARCHAR2(80),
	KNOWN_AS							VARCHAR2(80),
	PRE_NAME_ADJUNCT					VARCHAR2(150),
	MILITARY_RANK						VARCHAR2(80),
	PREVIOUS_LAST_NAME					VARCHAR2(150),
	TITLE								VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME                          VARCHAR2(300)
   );
   
   
-- ***********************
-- **Candidate Phone Table
-- ***********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_PHONE_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePhone',
	---
	PHONE_ID							NUMBER(18),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	PHONE_NUMBER						VARCHAR2(60),
	PHONE_TYPE							VARCHAR2(30),
	COUNTRY_CODE_NUMBER					VARCHAR2(30),
	AREA_CODE							VARCHAR2(30),
	EXTENSION							VARCHAR2(60),
	LEGISLATION_CODE					VARCHAR2(4),
	SPEED_DIAL_NUMBER					VARCHAR2(60),
	VALIDITY							VARCHAR2(30),
	PRIMARY_PHONE_FLAG					VARCHAR2(30),
	USE_FOR_COMMUNICATION				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
   
-- **********************
-- **CAN-Attachment Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	TITLE								VARCHAR2(80) ,
	DATA_TYPE_CODE						VARCHAR2(80) ,
	URL_OR_FILENAME						VARCHAR2(200),
	CANDIDATE_NUMBER					VARCHAR2(30) ,
	PERSON_ID							NUMBER(18)   ,
	CATEGORY							VARCHAR2(80) ,
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
-- ****************************
-- **Candidate Extra Info Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_EXTRA_INFO_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateExtraInfo',
	---
	PERSON_EXTRA_INFO_ID				NUMBER(18),
	EFFECTIVE_START_DATE				DATE,
	EFFECTIVE_END_DATE					DATE,
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	INFORMATION_TYPE					VARCHAR2(40),
	PEI_INFORMATION_CATEGORY			VARCHAR2(30),
	CATEGORY_CODE						VARCHAR2(80),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************
-- **Candidate Pool Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_POOL_STG
(          
	FILE_SET_ID				  VARCHAR2(30),
	MIGRATION_SET_ID 		  NUMBER,
	MIGRATION_SET_NAME 		  VARCHAR2(150),
	MIGRATION_STATUS		  VARCHAR2(50),
	BG_NAME   				  VARCHAR2(240),
	BG_ID            		  NUMBER(15),	
	METADATA				  VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME				  VARCHAR2(150) DEFAULT 'CandidatePool',
	--
	POOL_ID                   NUMBER(18)    , 
	POOL_NAME                 VARCHAR2(240) , 
	POOL_TYPE_CODE            VARCHAR2(30)  , 
	DESCRIPTION               VARCHAR2(4000), 
	OWNER_PERSON_ID           NUMBER(18)    , 
	STATUS                    VARCHAR2(30)  , 
	JOB_ID                    NUMBER(18)    , 
	OWNER_PERSON_NUMBER       VARCHAR2(30)  , 
	JOB_SET_CODE              VARCHAR2(30)  , 
	JOB_CODE                  VARCHAR2(30)  , 
	DEPARTMENT_NAME           VARCHAR2(240) , 
	OWNERSHIP_TYPE            VARCHAR2(30)  , 
	GUID                      VARCHAR2(32)  , 
	SOURCE_SYSTEM_ID          VARCHAR2(2000), 
	SOURCE_SYSTEM_OWNER       VARCHAR2(256) , 
	---
	ATTRIBUTE_CATEGORY        VARCHAR2(30)  , 
	ATTRIBUTE1                VARCHAR2(150) , 
	ATTRIBUTE2                VARCHAR2(150) , 
	ATTRIBUTE3                VARCHAR2(150) , 
	ATTRIBUTE4                VARCHAR2(150) , 
	ATTRIBUTE5                VARCHAR2(150) , 
	ATTRIBUTE6                VARCHAR2(150) , 
	ATTRIBUTE7                VARCHAR2(150) , 
	ATTRIBUTE8                VARCHAR2(150) , 
	ATTRIBUTE9                VARCHAR2(150) , 
	ATTRIBUTE10               VARCHAR2(150) , 
	ATTRIBUTE_NUMBER1         NUMBER        , 
	ATTRIBUTE_NUMBER2         NUMBER        , 
	ATTRIBUTE_NUMBER3         NUMBER        , 
	ATTRIBUTE_NUMBER4         NUMBER        , 
	ATTRIBUTE_NUMBER5         NUMBER        , 
	ATTRIBUTE_DATE1           DATE          , 
	ATTRIBUTE_DATE2           DATE          , 
	ATTRIBUTE_DATE3           DATE          , 
	ATTRIBUTE_DATE4           DATE          , 
	ATTRIBUTE_DATE5           DATE          ,
BATCH_NAME VARCHAR2(300)	
);

   
-- **********************************
-- **CP-Talent Community Detail Table
-- **********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CP_TAL_COMM_DET_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'TalentCommunityDetail',
	---
	OBJECT_CTX_ID						NUMBER(18) ,
	POOL_ID								NUMBER(18) ,
	POOL_NAME							VARCHAR2(240),
	STATUS								VARCHAR2(30),
	LOCATION_ID							NUMBER(18),
	LOCATION_NAME						VARCHAR2(360),
	JOB_FAMILY_ID						NUMBER(18),
	JOB_FAMILY_CODE						VARCHAR2(240),
	JOB_FAMILY_NAME						varchar2(240),
	SITE_NUMBER							VARCHAR2(240),
	DIMENSION_TYPE_CODE					VARCHAR2(30),
	ORGANIZATION_ID						NUMBER(18),
	ORGANIZATION_NAME					VARCHAR2(4000),
	ORGANIZATION_CODE					VARCHAR2(500),
	CLASSIFICATION_CODE					VARCHAR2(40),
	PERSON_TYPE_CODE					VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
-- *****************************
-- **Candidate Pool Member Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_POOL_MEMBR_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePoolMember',
	---
	CURRENT_PHASE_ID					NUMBER(18),
	CURRENT_STATE_ID					NUMBER(18),
	POOL_MEMBER_ID						NUMBER(18),
	POOL_ID								NUMBER(18),
	POOL_NAME							VARCHAR2(240),
	STATUS								VARCHAR2(120),
	MEMBER_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	CURRENT_PHASE_CODE					VARCHAR2(30),
	CURRENT_STATE_CODE					VARCHAR2(30),
	SOURCE								VARCHAR2(20),
	ADDED_BY_PERSON_ID					NUMBER(18),
	ADDED_BY_PERSON_NUMBER				VARCHAR2(30),
	ADDED_FROM_POOL_ID					NUMBER(18),
	ADDED_FROM_POOL_NAME				VARCHAR2(240),
	ADDED_FROM_POOL_STATUS				VARCHAR2(120),
	ADDED_FROM_REQUISITION_ID			NUMBER(18),
	ADDED_FROM_REQUISITION_NUMBER		VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
   
-- **********************
-- **CP-Interaction Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_POOL_INTERACT_STG
   (
	FILE_SET_ID						VARCHAR2(30),
	MIGRATION_SET_ID 				NUMBER,
	MIGRATION_SET_NAME 				VARCHAR2(150),
	MIGRATION_STATUS				VARCHAR2(50),
	BG_NAME   						VARCHAR2(240),
	BG_ID            				NUMBER(15),	
	METADATA						VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME						VARCHAR2(150) DEFAULT 'Interaction',
	---
	ADDED_BY_PERSON_ID				NUMBER(18),
	POOL_ID							NUMBER(18) ,
	INTERACTION_DATE				DATE ,
	INTERACTION_ID					NUMBER(18),
	INTERACTION_TYPE_CODE			VARCHAR2(30),
	MEMBER_ID						NUMBER(18),
	TEXT							CLOB,
	POOL_NAME						VARCHAR2(240),
	STATUS							VARCHAR2(120),
	ADDED_BY_PERSON_NUMBER			VARCHAR2(30),
	CANDIDATE_NUMBER				VARCHAR2(30),
	POOL_MEMBER_ID					NUMBER(18),
	GUID							VARCHAR2(32),
	SOURCE_SYSTEM_ID				VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER				VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 				VARCHAR2(30),
	ATTRIBUTE1 						VARCHAR2(150),
	ATTRIBUTE2 						VARCHAR2(150),
	ATTRIBUTE3 						VARCHAR2(150),
	ATTRIBUTE4 						VARCHAR2(150),
	ATTRIBUTE5 						VARCHAR2(150),
	ATTRIBUTE6 						VARCHAR2(150),
	ATTRIBUTE7 						VARCHAR2(150),
	ATTRIBUTE8 						VARCHAR2(150),
	ATTRIBUTE9 						VARCHAR2(150),
	ATTRIBUTE10 					VARCHAR2(150),
	ATTRIBUTE_NUMBER1 				NUMBER, 
	ATTRIBUTE_NUMBER2 				NUMBER, 
	ATTRIBUTE_NUMBER3 				NUMBER, 
	ATTRIBUTE_NUMBER4 				NUMBER, 
	ATTRIBUTE_NUMBER5 				NUMBER, 
	ATTRIBUTE_DATE1 				DATE, 
	ATTRIBUTE_DATE2 				DATE, 
	ATTRIBUTE_DATE3 				DATE,  
	ATTRIBUTE_DATE4 				DATE, 
	ATTRIBUTE_DATE5 				DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
-- ****************************
-- **Candidate Pool Owner Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_POOL_OWNER_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePoolOwner',
	---
	POOL_OWNER_ID						NUMBER(18),
	POOL_ID								NUMBER(18),
	OWNER_PERSON_ID						NUMBER(18),
	OWNER_PERSON_NUMBER					VARCHAR2(30),
	POOL_NAME							VARCHAR2(240),
	POOL_STATUS							VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
   
-- **********************************
-- **Candidate Pool Translation Table
-- **********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_POOL_TRNSLN_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePoolTranslation',
	---
	DESCRIPTION							VARCHAR2(4000),
	LANGUAGE							VARCHAR2(4),
	POOL_ID								NUMBER(18),
	POOL_NAME							VARCHAR2(240),
	POOL_STATUS							VARCHAR2(30),
	BASE_POOL_NAME						VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************
-- **Referral Table
-- ****************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_REFERRAL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Referral',
	---
	REFERRAL_ID							NUMBER(18),
	REFERRER_PERSON_ID					NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	AGENT_ID							NUMBER(18),
	CANDIDATE_PERSON_ID					NUMBER(18),
	NOTES_CANDIDATE						VARCHAR2(1000),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	PERSON_NUMBER						VARCHAR2(30),
	REFERRER_PERSON_NUMBER				VARCHAR2(30),
	AGENCY_NAME							VARCHAR2(240),
	AGENT_NAME							VARCHAR2(301),
	PERSON_ID							NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
   
-- **********************
-- **REF-Attachment Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_REF_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	REFERRAL_ID							NUMBER(18),
	TITLE								VARCHAR2(80),
	TFILE								CLOB,
	DATA_TYPE_CODE						VARCHAR2(80),
	URL_OR_FILENAME						VARCHAR2(200),
	CATEGORY							VARCHAR2(80),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	PERSON_NUMBER						VARCHAR2(30),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************
-- **Prospect Table
-- ****************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_PROSPECT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Prospect',
	---
	ADDED_BY_PERSON_ID					NUMBER(18),
	CANDIDATE_PERSON_ID					NUMBER(18),
	CONTEXT_TYPE_CODE					VARCHAR2(30),
	PROSPECT_ID							NUMBER(18),
	PROSPECT_STATUS_CODE				VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	INACTIVATE_FLAG						VARCHAR2(30),
	ADDED_FROM_REQUISITION_NUMBER		VARCHAR2(240),
	ADDED_FROM_REQUISITION_ID			NUMBER(18),
	ADDED_FROM_POOL_NAME				VARCHAR2(240),
	ADDED_FROM_POOL_STATUS				VARCHAR2(30),
	ADDED_FROM_POOL_ID					NUMBER(18),
	SEND_INVITE_FLAG					VARCHAR2(30),
	ADDED_BY_PERSON_NUMBER				VARCHAR2(30),
	SOURCE								VARCHAR2(30),
	SOURCE_MEDIUM						VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE,
	BATCH_NAME VARCHAR2(300)
   );
   
-- ****************************
-- **Prospect Interaction Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_PROSPECT_INTERACT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ProspectInteraction',
	---
	ADDED_BY_PERSON_ID					NUMBER(18),
	PROSPECT_ID							NUMBER(18),
	INTERACTION_DATE					DATE,
	INTERACTION_ID						NUMBER(18),
	INTERACTION_TYPE_CODE				VARCHAR2(30),
	PERSON_ID							NUMBER(18),
	TEXT								VARCHAR2(100),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	ADDED_BY_PERSON_NUMBER				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *********************************
-- **Candidate Job Application Table
-- *********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateJobApplication',
	---
	SUBMISSION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	CONFIRMED_BY_CANDIDATE_NUMBER		VARCHAR2(30),
	CONFIRMED_BY_PERSON_ID				NUMBER(18),
	SUBMISSION_CONFIRMED_DATE			DATE,
	SUBMISSION_DATE						DATE,
	CURRENT_PHASE_ID					NUMBER(18),
	CURRENT_STATE_ID					NUMBER(18),
	CURRENT_PHASE_CODE					VARCHAR2(30),
	CURRENT_STATE_CODE					VARCHAR2(30),
	INACTIVATE_FLAG						VARCHAR2(30),
	SUBMISSION_LANGUAGE_CODE			VARCHAR2(4),
	SOURCE								VARCHAR2(30),
	SOURCE_MEDIUM						VARCHAR2(30),
	REJECTION_REASON_ID					NUMBER(18),
	REJECTION_REASON_CODE				VARCHAR2(30),
	REJECTION_REASON_COMMENTS			VARCHAR2(255),
	RETURN_TO_PRIOR_PHASE_FLAG			VARCHAR2(30) DEFAULT 'N',
	RETURN_TO_PRIOR_STATE_FLAG			VARCHAR2(30) DEFAULT 'N',
	CATEGORY_CODE						VARCHAR2(80),
	SUPPRESS_NOTIFICATION_FLAG			VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ******************************************
-- **CJA-Candidate Personal Information Table
-- ******************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PER_INFO_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePersonalInformation',
	---
	RESPONSE_ID							NUMBER(18),
	SUBMISSION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	LEGISLATION_CODE					VARCHAR2(30),
	ACCOMMODATION_REQUEST				VARCHAR2(100),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ****************************************
-- **CJA-Candidate Preferred Location Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PREFD_LOC_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidatePreferredLocation',
	---
	JA_PREF_LOCATION_ID					NUMBER(18),
	LOCATION_ID							NUMBER(18),
	LOCATION_NAME						VARCHAR2(4000),
	SUBMISSION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *************************************
-- **CJA-Questionnaire Participant Table
-- *************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_PARTCPNT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'QuestionnaireParticipant',
	---
	QSTNR_PARTICIPANT_ID				NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	SUBJECT_ID							NUMBER(18),
	SUBMITTED_DATE_TIME					TIMESTAMP,
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	QSTNR_VERSION_NUM					NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************************
-- **CJA-Questionnaire Response Table
-- **********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_RESP_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'QuestionnaireResponse',
	---
	ATTEMPT_NUM							NUMBER(18),
	QSTNR_PARTICIPANT_ID				NUMBER(18),
	QSTNR_RESPONSE_ID					NUMBER(18),
	QSTNR_VERSION_NUM					NUMBER(18),
	SUBMITTED_DATE_TIME					TIMESTAMP,
	QUESTIONNAIRE_ID					NUMBER(18),
	SUBJECT_ID							NUMBER(18),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *****************************
-- **CJA-Question Response Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_QSTN_RESP_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'QuestionResponse',
	---
	ANSWER_TEXT							VARCHAR2(4000),
	QSTN_RESPONSE_ID					NUMBER(18),
	QSTNR_QUESTION_ID					NUMBER(18),
	QSTNR_RESPONSE_ID					NUMBER(18),
	QUESTION_ID							NUMBER(18),
	QSTNR_SECTION_ID					NUMBER(18),
	QUESTION_CODE						VARCHAR2(240),
	QSTN_VERSION_NUM					NUMBER(18),
	ATTEMPT_NUM							NUMBER(18),
	QSTNR_VERSION_NUM					NUMBER(18),
	QUESTIONNAIRE_ID					NUMBER(18),
	SUBJECT_ID							NUMBER(18),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	SECTION_SEQ_NUM						NUMBER(18),
	ANSWER_CODE							VARCHAR2(100),
	ANSWER_CODES						VARCHAR2(100),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- **********************
-- **CJA-Attachment Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_ATTMT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHED_DOCUMENT_ID				NUMBER(18),
	SUBMISSION_ID						NUMBER(18),
	TITLE								VARCHAR2(80),
	TFILE								CLOB,
	DATA_TYPE_CODE						VARCHAR2(80),
	URL_OR_FILENAME						VARCHAR2(200),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	CATEGORY							VARCHAR2(80) ,
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *********************************
-- **CJA-Candidate Interaction Table
-- *********************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CJA_CAN_INTERACT_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateInteraction',
	---
	ADDED_BY_PERSON_ID					NUMBER(18),
	SUBMISSION_ID						NUMBER(18),
	INTERACTION_DATE					DATE,
	INTERACTION_ID						NUMBER(18),
	INTERACTION_TYPE_CODE				VARCHAR2(30),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	TEXT								CLOB,
	ADDED_BY_PERSON_NUMBER				VARCHAR2(30),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- *****************************************
-- **Candidate Job Application Profile Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_PROFL_STG
   (
	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240),
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateJobApplicationProfile',
	---
	PROFILE_ITEM_ID						NUMBER(18),
	CONTENT_ITEM_ID						NUMBER(18),
	CONTENT_TYPE_ID						NUMBER(18),
	COUNTRY_ID							NUMBER(18),
	DATE_FROM							DATE,
	DATE_TO								DATE,
	IMPORTANCE							NUMBER(18),
	INTEREST_LEVEL						VARCHAR2(30),
	MANDATORY							VARCHAR2(30),
	PARENT_PROFILE_ITEM_ID				NUMBER(18),
	PROFILE_ID							NUMBER(18),
	SOURCE_ID							NUMBER(18),
	SOURCE_TYPE							VARCHAR2(30),
	STATE_PROVINCE_ID					NUMBER(18),
	STATE_GEOGRAPHY_CODE				VARCHAR2(360),
	STATE_COUNTRY_CODE					VARCHAR2(2),
	COUNTRY_GEOGRAPHY_CODE				VARCHAR2(30),
	COUNTRY_COUNTRY_CODE				VARCHAR2(2),
	CONTENT_TYPE						VARCHAR2(240),
	CONTENT_ITEM						VARCHAR2(700),
	SUBMISSION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	CANDIDATE_NUMBER					VARCHAR2(30),
	SECTION_ID							NUMBER(18),
	SECTION_CONTEXT						VARCHAR2(300),
	ITEM_DATE_1							DATE,
	ITEM_DATE_2							DATE,
	ITEM_DATE_3							DATE,
	ITEM_DATE_4							DATE,
	ITEM_DATE_5							DATE,
	ITEM_DATE_6							DATE,
	ITEM_DATE_7							DATE,
	ITEM_DATE_8							DATE,
	ITEM_DATE_9							DATE,
	ITEM_DATE_10						DATE,
	ITEM_DECIMAL_1						NUMBER(15),
	ITEM_DECIMAL_2						NUMBER(15),
	ITEM_DECIMAL_3						NUMBER(15),
	ITEM_DECIMAL_4						NUMBER(15),
	ITEM_DECIMAL_5						NUMBER(15),
	ITEM_NUMBER_1						NUMBER(18),
	ITEM_NUMBER_2						NUMBER(18),
	ITEM_NUMBER_3						NUMBER(18),
	ITEM_NUMBER_4						NUMBER(18),
	ITEM_NUMBER_5						NUMBER(18),
	ITEM_NUMBER_6						NUMBER(18),
	ITEM_NUMBER_7						NUMBER(18),
	ITEM_NUMBER_8						NUMBER(18),
	ITEM_NUMBER_9						NUMBER(18),
	ITEM_NUMBER_10						NUMBER(18),
	ITEM_TEXT_20001						VARCHAR2(2000),
	ITEM_TEXT_20002						VARCHAR2(2000),
	ITEM_TEXT_20003						VARCHAR2(2000),
	ITEM_TEXT_20004						VARCHAR2(2000),
	ITEM_TEXT_20005						VARCHAR2(2000),
	ITEM_TEXT_2401						VARCHAR2(240),
	ITEM_TEXT_2402						VARCHAR2(240),
	ITEM_TEXT_2403						VARCHAR2(240),
	ITEM_TEXT_2404						VARCHAR2(240),
	ITEM_TEXT_2405						VARCHAR2(240),
	ITEM_TEXT_2406						VARCHAR2(240),
	ITEM_TEXT_2407						VARCHAR2(240),
	ITEM_TEXT_2408						VARCHAR2(240),
	ITEM_TEXT_2409						VARCHAR2(240),
	ITEM_TEXT_24010						VARCHAR2(240),
	ITEM_TEXT_24011						VARCHAR2(240),
	ITEM_TEXT_24012						VARCHAR2(240),
	ITEM_TEXT_24013						VARCHAR2(240),
	ITEM_TEXT_24014						VARCHAR2(240),
	ITEM_TEXT_24015						VARCHAR2(240),
	ITEM_TEXT_301						VARCHAR2(30),
	ITEM_TEXT_302						VARCHAR2(30),
	ITEM_TEXT_303						VARCHAR2(30),
	ITEM_TEXT_304						VARCHAR2(30),
	ITEM_TEXT_305						VARCHAR2(30),
	ITEM_TEXT_306						VARCHAR2(30),
	ITEM_TEXT_307						VARCHAR2(30),
	ITEM_TEXT_308						VARCHAR2(30),
	ITEM_TEXT_309						VARCHAR2(30),
	ITEM_TEXT_3010						VARCHAR2(30),
	ITEM_TEXT_3011						VARCHAR2(30),
	ITEM_TEXT_3012						VARCHAR2(30),
	ITEM_TEXT_3013						VARCHAR2(30),
	ITEM_TEXT_3014						VARCHAR2(30),
	ITEM_TEXT_3015						VARCHAR2(30),
	ITEM_CLOB_1							CLOB,
	ITEM_CLOB_2							CLOB,
	ITEM_CLOB_3							CLOB,
	ITEM_CLOB_4							CLOB,
	ITEM_CLOB_5							CLOB,
	QUALIFIER_ID_1						NUMBER(18),
	QUALIFIER_ID_2						NUMBER(18),
	QUALIFIER_CODE_1					VARCHAR2(30),
	QUALIFIER_CODE_2					VARCHAR2(30),
	QUALIFIER_SET_CODE_1				VARCHAR2(30),
	QUALIFIER_SET_CODE_2				VARCHAR2(30),
	RATING_LEVEL_ID_1					NUMBER(18),
	RATING_LEVEL_ID_2					NUMBER(18),
	RATING_LEVEL_ID_3					NUMBER(18),
	RATING_MODEL_ID_1					NUMBER(18),
	RATING_MODEL_ID_2					NUMBER(18),
	RATING_MODEL_ID_3					NUMBER(18),
	RATING_MODEL_CODE_1					VARCHAR2(30),
	RATING_MODEL_CODE_2					VARCHAR2(30),
	RATING_MODEL_CODE_3					VARCHAR2(30),
	RATING_LEVEL_CODE_1					VARCHAR2(30),
	RATING_LEVEL_CODE_2					VARCHAR2(30),
	RATING_LEVEL_CODE_3					VARCHAR2(30),
	SOURCE_KEY_1						NUMBER(18),
	SOURCE_KEY_2						NUMBER(18),
	SOURCE_KEY_3						NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );
   
   
-- ********************************************
-- **Candidate Job Application Extra Info Table
-- ********************************************
CREATE TABLE XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_EXTRA_INFO_STG
   (	
   	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID 					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CandidateJobApplicationExtraInfo',
	---			
	CATEGORY_CODE						VARCHAR2(80),
	EFF_LINE_ID							NUMBER(18),
	PEI_INFORMATION_CATEGORY			VARCHAR2(30),
	SUBMISSION_ID						NUMBER(18),
	REQUISITION_NUMBER					VARCHAR2(240),
	CANDIDATE_NUMBER					VARCHAR2(30),
	REQUISITION_ID						NUMBER(18),
	PERSON_ID							NUMBER(18),
	GUID								VARCHAR2(32),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	---
	ATTRIBUTE_CATEGORY 					VARCHAR2(30),
	ATTRIBUTE1 							VARCHAR2(150),
	ATTRIBUTE2 							VARCHAR2(150),
	ATTRIBUTE3 							VARCHAR2(150),
	ATTRIBUTE4 							VARCHAR2(150),
	ATTRIBUTE5 							VARCHAR2(150),
	ATTRIBUTE6 							VARCHAR2(150),
	ATTRIBUTE7 							VARCHAR2(150),
	ATTRIBUTE8 							VARCHAR2(150),
	ATTRIBUTE9 							VARCHAR2(150),
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE,  
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
   );



--------------------------
---SYNONYMS AND GRANTS
--------------------------

--
--
PROMPT
PROMPT
PROMPT ****************************
PROMPT ** CREATE OR REPLACE SYNONYM
PROMPT ****************************
--
--


CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JOB_REQ_SEC_PROFL_STG FOR XXMX_STG.XXMX_HCM_IREC_JOB_REQ_SEC_PROFL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CON_LIB_STG FOR XXMX_STG.XXMX_HCM_IREC_CON_LIB_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CL_POST_DESC_CNTXT_STG FOR XXMX_STG.XXMX_HCM_IREC_CL_POST_DESC_CNTXT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CON_LIB_VER_STG FOR XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CL_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_CL_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CON_LIB_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_CON_LIB_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CON_LIB_VER_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_GEO_HIER_STG FOR XXMX_STG.XXMX_HCM_IREC_GEO_HIER_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_GEO_HIER_NODE_STG FOR XXMX_STG.XXMX_HCM_IREC_GEO_HIER_NODE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JOB_REQ_STG FOR XXMX_STG.XXMX_HCM_IREC_JOB_REQ_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_ASSMT_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_ASSMT_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_TAX_CRED_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_TAX_CRED_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_BKG_CHECK_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_V2_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_V2_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_APPL_SPEC_QSTN_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_APPL_SPEC_QSTN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_HIRE_TEAM_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_HIRE_TEAM_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_INTRVW_QSTNR_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_INTRVW_QSTNR_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_JOB_PROFL_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_JOB_PROFL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_OTHER_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_OTHER_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_POST_DET_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_POST_DET_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_OTHER_WORK_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_OTHER_WORK_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_LANG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_LANG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_MEDIA_LINK_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JR_MEDIA_LINK_LANG_STG FOR XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_LANG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JOB_REQ_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JOB_REQ_TEMPL_STG FOR XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_TEMPL_MEDIA_LINK_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_TEMPL_MEDIA_LINK_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_MEDIA_LINK_LANG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_MEDIA_LINK_LANG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_ASSMT_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_ASSMT_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_TAX_CRED_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_TAX_CRED_SCRN_PKG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_SCRN_PKG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_BKG_CHECK_CONFIG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_CONFIG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_V2_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_V2_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_APPL_SPEC_QSTN_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_APPL_SPEC_QSTN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_HIRE_TEAM_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_HIRE_TEAM_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_INTRVW_QSTNR_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_INTRVW_QSTNR_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_JOB_PROFL_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_JOB_PROFL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_OTHER_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_OTHER_WORK_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_WORK_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JRT_LANG_STG FOR XXMX_STG.XXMX_HCM_IREC_JRT_LANG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_JOB_REQ_TEMPL_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_MEDIA_LINK_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_MEDIA_LINK_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_TEMPL_MEDIA_LINK_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_TEMPL_MEDIA_LINK_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_INTERACT_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_INTERACT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PREF_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PREF_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PREFD_JOB_FAM_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_JOB_FAM_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PREFD_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PREFD_ORG_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_ORG_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_NAT_IDENFR_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_NAT_IDENFR_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PROFL_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PROFL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_ADDRESS_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_ADDRESS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_EMAIL_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_EMAIL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_NAME_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_NAME_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_PHONE_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_PHONE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_EXTRA_INFO_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_EXTRA_INFO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_POOL_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_POOL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CP_TAL_COMM_DET_STG FOR XXMX_STG.XXMX_HCM_IREC_CP_TAL_COMM_DET_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_POOL_MEMBR_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_POOL_MEMBR_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_POOL_INTERACT_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_POOL_INTERACT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_POOL_OWNER_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_POOL_OWNER_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_POOL_TRNSLN_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_POOL_TRNSLN_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_REFERRAL_STG FOR XXMX_STG.XXMX_HCM_IREC_REFERRAL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_REF_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_REF_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_PROSPECT_STG FOR XXMX_STG.XXMX_HCM_IREC_PROSPECT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_PROSPECT_INTERACT_STG FOR XXMX_STG.XXMX_HCM_IREC_PROSPECT_INTERACT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_JOB_APPL_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_CAN_PER_INFO_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PER_INFO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_CAN_PREFD_LOC_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PREFD_LOC_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_QSTNR_PARTCPNT_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_PARTCPNT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_QSTNR_RESP_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_RESP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_QSTN_RESP_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_QSTN_RESP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_ATTMT_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_ATTMT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CJA_CAN_INTERACT_STG FOR XXMX_STG.XXMX_HCM_IREC_CJA_CAN_INTERACT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_JOB_APPL_PROFL_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_PROFL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_HCM_IREC_CAN_JOB_APPL_EXTRA_INFO_STG FOR XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_EXTRA_INFO_STG;



--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--


GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JOB_REQ_SEC_PROFL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CON_LIB_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CL_POST_DESC_CNTXT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CL_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CON_LIB_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CON_LIB_VER_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_GEO_HIER_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_GEO_HIER_NODE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JOB_REQ_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_ASSMT_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_TAX_CRED_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_BKG_CHECK_SCRN_PKG_V2_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_APPL_SPEC_QSTN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_HIRE_TEAM_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_INTRVW_QSTNR_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_JOB_PROFL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_OTHER_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_POST_DET_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_OTHER_WORK_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_LANG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JR_MEDIA_LINK_LANG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_TEMPL_MEDIA_LINK_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_MEDIA_LINK_LANG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_ASSMT_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_TAX_CRED_SCRN_PKG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_CONFIG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_BKG_CHECK_SCRN_PKG_V2_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_APPL_SPEC_QSTN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_HIRE_TEAM_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_INTRVW_QSTNR_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_JOB_PROFL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_OTHER_WORK_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JRT_LANG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_JOB_REQ_TEMPL_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_MEDIA_LINK_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_TEMPL_MEDIA_LINK_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_INTERACT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PREF_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_JOB_FAM_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PREFD_ORG_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_NAT_IDENFR_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PROFL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_ADDRESS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_EMAIL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_NAME_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_PHONE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_EXTRA_INFO_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_POOL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CP_TAL_COMM_DET_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_POOL_MEMBR_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_POOL_INTERACT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_POOL_OWNER_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_POOL_TRNSLN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_REFERRAL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_REF_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_PROSPECT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_PROSPECT_INTERACT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PER_INFO_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_CAN_PREFD_LOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_PARTCPNT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_QSTNR_RESP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_QSTN_RESP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_ATTMT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CJA_CAN_INTERACT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_PROFL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_HCM_IREC_CAN_JOB_APPL_EXTRA_INFO_STG TO XXMX_CORE;




--
--
--
--
PROMPT
PROMPT
PROMPT **********************************
PROMPT **                                
PROMPT ** End of Database Object Creation
PROMPT **                                
PROMPT **********************************
PROMPT
PROMPT
--
--

