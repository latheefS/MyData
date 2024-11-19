--*****************************************************************************
--**
--**                 		   Copyright (c) 2022 Version 1
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
--** FILENAME  :  xxmx_ppm_projects_stg_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Cloudbridge
--**              PPM Projects Data Migration.
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
--** -----  -----------  ------------------  ----------------------------------------------------
--**   1.0  10-JAN-2023    Shaik Latheef  	 Created PPM Projects STG tables for Cloudbridge.
--** 
--***********************************************************************************************
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
--
PROMPT
PROMPT
PROMPT **************************************************************************************
PROMPT **
PROMPT ** Installing Extract Database Objects for Cloudbridge PPM Projects Data Migration
PROMPT **
PROMPT **************************************************************************************
PROMPT
PROMPT
--
PROMPT 
PROMPT  DROP Sequence
PROMPT
--
EXEC DROPSEQUENCE ('XXMX_PPM_PRJ_TRX_CONTROL_SEQ')
--
--
PROMPT 
PROMPT Creating Sequence
PROMPT
--
--
Create sequence XXMX_PPM_PRJ_TRX_CONTROL_SEQ
INCREMENT BY 1 START WITH 1 ;
--
Create or replace PUBLIC synonym XXMX_PPM_PRJ_TRX_CONTROL_SEQ for XXMX_PPM_PRJ_TRX_CONTROL_SEQ;
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
EXEC DropTable ('XXMX_PPM_PROJECTS_STG')
EXEC DropTable ('XXMX_PPM_PRJ_TASKS_STG')
EXEC DropTable ('XXMX_PPM_PRJ_TRX_CONTROL_STG')
EXEC DropTable ('XXMX_PPM_PRJ_TEAM_MEM_STG')
EXEC DropTable ('XXMX_PPM_PRJ_CLASS_STG')
EXEC DropTable ('XXMX_PPM_PLANRBS_HEADER_STG')
EXEC DropTable ('XXMX_PPM_RESOURCES_STG')
EXEC DropTable ('XXMX_PPM_PRJ_BILLEVENT_STG')
EXEC DropTable ('XXMX_PPM_PRJ_MISCCOST_STG')
EXEC DropTable ('XXMX_PPM_PRJ_LBRCOST_STG')
EXEC DropTable ('XXMX_PPM_PRJ_SUPCOST_STG')
EXEC DropTable ('XXMX_PPM_PRJ_NONLABCOST_STG')
--
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PROJECTS_STG
PROMPT
--

--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- ****************
-- **Projects Table
-- ****************
CREATE TABLE  XXMX_PPM_PROJECTS_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	PROJECT_NAME							VARCHAR2(240),
	PROJECT_NUMBER							VARCHAR2(25),
	SOURCE_TEMPLATE_NUMBER					NUMBER(18),
	SOURCE_TEMPLATE_NAME					VARCHAR2(240),
	SOURCE_APPLICATION_CODE					VARCHAR2(30),
	SOURCE_PROJECT_REFERENCE				VARCHAR2(25),
	SCHEDULE_NAME							VARCHAR2(200),
	EPS_NAME								VARCHAR2(200),
	PROJECT_PLAN_VIEW_ACCESS				VARCHAR2(30),
	SCHEDULE_TYPE							VARCHAR2(30),
	ORGANIZATION_NAME						VARCHAR2(240),
	LEGAL_ENTITY_NAME						VARCHAR2(240),
	DESCRIPTION								VARCHAR2(2000),
	PROJECT_MANAGER_NUMBER					VARCHAR2(30),
	PROJECT_MANAGER_NAME					VARCHAR2(240),
	PROJECT_MANAGER_EMAIL					VARCHAR2(240),
	PROJECT_START_DATE						DATE,
	PROJECT_FINISH_DATE						DATE,
	CLOSED_DATE								DATE,
	PRJ_PLAN_BASELINE_NAME					VARCHAR2(100),
	PRJ_PLAN_BASELINE_DESC					VARCHAR2(1000),
	PRJ_PLAN_BASELINE_DATE					DATE,
	PROJECT_STATUS_NAME						VARCHAR2(80),
	PROJECT_PRIORITY_CODE					VARCHAR2(30),
	OUTLINE_DISPLAY_LEVEL					NUMBER(18),
	PLANNING_PROJECT_FLAG					VARCHAR2(1),
	SERVICE_TYPE_CODE						VARCHAR2(30),
	WORK_TYPE_NAME							VARCHAR2(240),
	LIMIT_TO_TXN_CONTROLS_CODE				VARCHAR2(30),
	BUDGETARY_CONTROL_FLAG					VARCHAR2(1),
	PROJECT_CURRENCY_CODE					VARCHAR2(15), 
	CURRENCY_CONV_RATE_TYPE					VARCHAR2(15),
	CURRENCY_CONV_DATE_TYPE_CODE			VARCHAR2(1), 
	CURRENCY_CONV_DATE						DATE,
	CINT_ELIGIBLE_FLAG						VARCHAR2(1),
	CINT_RATE_SCH_NAME						VARCHAR2(30),
	CINT_STOP_DATE							DATE,
	ASSET_ALLOCATION_METHOD_CODE			VARCHAR2(30),
	CAPITAL_EVENT_PROCESSING_CODE			VARCHAR2(30),
	ALLOW_CROSS_CHARGE_FLAG					VARCHAR2(1),
	CC_PROCESS_LABOR_FLAG					VARCHAR2(1),
	LABOR_TP_SCHEDULE_NAME					VARCHAR2(50),
	LABOR_TP_FIXED_DATE						DATE,
	CC_PROCESS_NL_FLAG						VARCHAR2(1),
	NL_TP_SCHEDULE_NAME						VARCHAR2(50),
	NL_TP_FIXED_DATE						DATE,
	BURDEN_SCHEDULE_NAME					VARCHAR2(30),
	BURDEN_SCH_FIXED_DATED					DATE,
	KPI_NOTIFICATION_ENABLED				VARCHAR2(5),
	KPI_NOTIFICATION_RECIPIENTS				VARCHAR2(30),
	KPI_NOTIFICATION_INCLUDE_NOTES			VARCHAR2(5),
	COPY_TEAM_MEMBERS_FLAG					VARCHAR2(1),
	COPY_CLASSIFICATIONS_FLAG				VARCHAR2(1),
	COPY_ATTACHMENTS_FLAG					VARCHAR2(1),
	COPY_DFF_FLAG							VARCHAR2(1),
	COPY_TASKS_FLAG							VARCHAR2(1),
	COPY_TASK_ATTACHMENTS_FLAG				VARCHAR2(1),
	COPY_TASK_DFF_FLAG						VARCHAR2(1),
	COPY_TASK_ASSIGNMENTS_FLAG				VARCHAR2(1),
	COPY_TRANSACTION_CONTROLS_FLAG			VARCHAR2(1),
	COPY_ASSETS_FLAG						VARCHAR2(1),
	COPY_ASSET_ASSIGNMENTS_FLAG				VARCHAR2(1),
	COPY_COST_OVERRIDES_FLAG				VARCHAR2(1),
	OPPORTUNITY_ID							NUMBER(18),
	OPPORTUNITY_NUMBER						VARCHAR2(240),
	OPPORTUNITY_CUSTOMER_NUMBER				VARCHAR2(240),
	OPPORTUNITY_CUSTOMER_ID					NUMBER(18),
	OPPORTUNITY_AMT							NUMBER,
	OPPORTUNITY_CURRCODE					VARCHAR2(15), 
	OPPORTUNITY_WIN_CONF_PERCENT			NUMBER,
	OPPORTUNITY_NAME						VARCHAR2(240),
	OPPORTUNITY_DESC						VARCHAR2(1000),
	OPPORTUNITY_CUSTOMER_NAME				VARCHAR2(900),
	OPPORTUNITY_STATUS						VARCHAR2(240),
	ATTRIBUTE_CATEGORY						VARCHAR2(30), 
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	ATTRIBUTE11								VARCHAR2(150),
	ATTRIBUTE12								VARCHAR2(150),
	ATTRIBUTE13								VARCHAR2(150),
	ATTRIBUTE14								VARCHAR2(150),
	ATTRIBUTE15								VARCHAR2(150),
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
	ATTRIBUTE21								VARCHAR2(150),
	ATTRIBUTE22								VARCHAR2(150),
	ATTRIBUTE23								VARCHAR2(150),
	ATTRIBUTE24								VARCHAR2(150),
	ATTRIBUTE25								VARCHAR2(150),
	ATTRIBUTE26								VARCHAR2(150),
	ATTRIBUTE27								VARCHAR2(150),
	ATTRIBUTE28								VARCHAR2(150),
	ATTRIBUTE29								VARCHAR2(150),
	ATTRIBUTE30								VARCHAR2(150),
	ATTRIBUTE31								VARCHAR2(150),
	ATTRIBUTE32								VARCHAR2(150),
	ATTRIBUTE33								VARCHAR2(150),
	ATTRIBUTE34								VARCHAR2(150),
	ATTRIBUTE35								VARCHAR2(150),
	ATTRIBUTE36								VARCHAR2(150),
	ATTRIBUTE37								VARCHAR2(150),
	ATTRIBUTE38								VARCHAR2(150),
	ATTRIBUTE39								VARCHAR2(150),
	ATTRIBUTE40								VARCHAR2(150),
	ATTRIBUTE41								VARCHAR2(150),
	ATTRIBUTE42								VARCHAR2(150),
	ATTRIBUTE43								VARCHAR2(150),
	ATTRIBUTE44								VARCHAR2(150),
	ATTRIBUTE45								VARCHAR2(150),
	ATTRIBUTE46								VARCHAR2(150),
	ATTRIBUTE47								VARCHAR2(150),
	ATTRIBUTE48								VARCHAR2(150),
	ATTRIBUTE49								VARCHAR2(150),
	ATTRIBUTE50								VARCHAR2(150),
	ATTRIBUTE1_NUMBER						NUMBER,
	ATTRIBUTE2_NUMBER						NUMBER,
	ATTRIBUTE3_NUMBER						NUMBER,
	ATTRIBUTE4_NUMBER						NUMBER,
	ATTRIBUTE5_NUMBER						NUMBER,
	ATTRIBUTE6_NUMBER						NUMBER,
	ATTRIBUTE7_NUMBER						NUMBER,
	ATTRIBUTE8_NUMBER						NUMBER,
	ATTRIBUTE9_NUMBER						NUMBER,
	ATTRIBUTE10_NUMBER						NUMBER,
	ATTRIBUTE11_NUMBER						NUMBER,
	ATTRIBUTE12_NUMBER						NUMBER,
	ATTRIBUTE13_NUMBER						NUMBER,
	ATTRIBUTE14_NUMBER						NUMBER,
	ATTRIBUTE15_NUMBER						NUMBER,
	ATTRIBUTE1_DATE							DATE,
	ATTRIBUTE2_DATE							DATE,
	ATTRIBUTE3_DATE							DATE,
	ATTRIBUTE4_DATE							DATE,
	ATTRIBUTE5_DATE							DATE,
	ATTRIBUTE6_DATE							DATE,
	ATTRIBUTE7_DATE							DATE,
	ATTRIBUTE8_DATE							DATE,
	ATTRIBUTE9_DATE							DATE,
	ATTRIBUTE10_DATE						DATE,
	ATTRIBUTE11_DATE						DATE,
	ATTRIBUTE12_DATE						DATE,
	ATTRIBUTE13_DATE						DATE,
	ATTRIBUTE14_DATE						DATE,
	ATTRIBUTE15_DATE						DATE,
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	XFACE_REC_ID 							NUMBER(18,0),
	ORG_ID									NUMBER(18,0),
	COPY_GROUP_SPACE_FLAG					VARCHAR2(1 ), 
	PROJECT_ID 								VARCHAR2(30 ), 
	PROJ_OWNING_ORG							VARCHAR2(240 ), 
	BATCH_ID 								VARCHAR2(80 ), 
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6),
	LOAD_STATUS 							VARCHAR2(10 ), 
	IMPORT_STATUS 							VARCHAR2(10 ),
	LOAD_REQUEST_ID 						NUMBER(18,0), 
	REQUEST_ID 								NUMBER(18,0), 
	OBJECT_VERSION_NUMBER					NUMBER(9,0) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_TASKS_STG
PROMPT
--

-- *************
-- **Tasks Table
-- *************
CREATE TABLE  XXMX_PPM_PRJ_TASKS_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	PROJECT_NAME							VARCHAR2(240),
	PROJECT_NUMBER							VARCHAR2(25),
	TASK_NAME								VARCHAR2(255),
	TASK_NUMBER								VARCHAR2(100), 
	SOURCE_TASK_REFERENCE					VARCHAR2(25),
	FINANCIAL_TASK							VARCHAR(1),
	TASK_DESCRIPTION						VARCHAR2(2000), 
	PARENT_TASK_NUMBER						VARCHAR2(100), 
	PLANNING_START_DATE						DATE,
	PLANNING_END_DATE						DATE,
	PLANNED_EFFORT							NUMBER,
	PLANNED_DURATION						NUMBER,
	MILESTONE_FLAG							VARCHAR2(1), 
	CRITICAL_FLAG							VARCHAR2(1), 
	CHARGEABLE_FLAG							VARCHAR2(1), 
	BILLABLE_FLAG							VARCHAR2(1), 
	CAPITALIZABLE_FLAG 						VARCHAR2(1 ), 
	LIMIT_TO_TXN_CONTROLS_FLAG				VARCHAR2(1),
	SERVICE_TYPE_CODE 						VARCHAR2(30),
	WORK_TYPE_ID							NUMBER(18),
	MANAGER_PERSON_ID						NUMBER(18),
	ALLOW_CROSS_CHARGE_FLAG					VARCHAR2(1),
	CC_PROCESS_LABOR_FLAG					VARCHAR2(1), 
	CC_PROCESS_NL_FLAG						VARCHAR2(1),
	RECEIVE_PROJECT_INVOICE_FLAG			VARCHAR(1),
	ORGANIZATION_NAME						VARCHAR2(240),
	REQMNT_CODE								VARCHAR2(30),
	SPRINT									VARCHAR2(30),
	PRIORITY								NUMBER(18),
	SCHEDULE_MODE 							VARCHAR2(240),
	BASELINE_START_DATE						DATE,
	BASELINE_FINISH_DATE					DATE,
	BASELINE_EFFORT							NUMBER,
	BASELINE_DURATION 						NUMBER,
	BASELINE_ALLOCATION						NUMBER,
	BASELINE_LABOR_COST_AMOUNT				NUMBER,
	BASELINE_LABOR_BILLED_AMOUNT			NUMBER,
	BASELINE_EXPENSE_COST_AMOUNT			NUMBER,
	CONSTRAINT_TYPE_CODE					VARCHAR2(240),
	CONSTRAINT_DATE							DATE,
	ATTRIBUTE_CATEGORY						VARCHAR2(30), 
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	ATTRIBUTE11								VARCHAR2(150),
	ATTRIBUTE12								VARCHAR2(150),
	ATTRIBUTE13								VARCHAR2(150),
	ATTRIBUTE14								VARCHAR2(150),
	ATTRIBUTE15								VARCHAR2(150),
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
	ATTRIBUTE21								VARCHAR2(150),
	ATTRIBUTE22								VARCHAR2(150),
	ATTRIBUTE23								VARCHAR2(150),
	ATTRIBUTE24								VARCHAR2(150),
	ATTRIBUTE25								VARCHAR2(150),
	ATTRIBUTE26								VARCHAR2(150),
	ATTRIBUTE27								VARCHAR2(150),
	ATTRIBUTE28								VARCHAR2(150),
	ATTRIBUTE29								VARCHAR2(150),
	ATTRIBUTE30								VARCHAR2(150),
	ATTRIBUTE31								VARCHAR2(150),
	ATTRIBUTE32								VARCHAR2(150),
	ATTRIBUTE33								VARCHAR2(150),
	ATTRIBUTE34								VARCHAR2(150),
	ATTRIBUTE35								VARCHAR2(150),
	ATTRIBUTE36								VARCHAR2(150),
	ATTRIBUTE37								VARCHAR2(150),
	ATTRIBUTE38								VARCHAR2(150),
	ATTRIBUTE39								VARCHAR2(150),
	ATTRIBUTE40								VARCHAR2(150),
	ATTRIBUTE41								VARCHAR2(150),
	ATTRIBUTE42								VARCHAR2(150),
	ATTRIBUTE43								VARCHAR2(150),
	ATTRIBUTE44								VARCHAR2(150),
	ATTRIBUTE45								VARCHAR2(150),
	ATTRIBUTE46								VARCHAR2(150),
	ATTRIBUTE47								VARCHAR2(150),
	ATTRIBUTE48								VARCHAR2(150),
	ATTRIBUTE49								VARCHAR2(150),
	ATTRIBUTE50								VARCHAR2(150),
	ATTRIBUTE1_NUMBER						NUMBER,
	ATTRIBUTE2_NUMBER						NUMBER,
	ATTRIBUTE3_NUMBER						NUMBER,
	ATTRIBUTE4_NUMBER						NUMBER,
	ATTRIBUTE5_NUMBER						NUMBER,
	ATTRIBUTE6_NUMBER						NUMBER,
	ATTRIBUTE7_NUMBER						NUMBER,
	ATTRIBUTE8_NUMBER						NUMBER,
	ATTRIBUTE9_NUMBER						NUMBER,
	ATTRIBUTE10_NUMBER						NUMBER,
	ATTRIBUTE11_NUMBER						NUMBER,
	ATTRIBUTE12_NUMBER						NUMBER,
	ATTRIBUTE13_NUMBER						NUMBER,
	ATTRIBUTE14_NUMBER						NUMBER,
	ATTRIBUTE15_NUMBER						NUMBER,
	ATTRIBUTE1_DATE							DATE,
	ATTRIBUTE2_DATE							DATE,
	ATTRIBUTE3_DATE							DATE,
	ATTRIBUTE4_DATE							DATE,
	ATTRIBUTE5_DATE							DATE,
	ATTRIBUTE6_DATE							DATE,
	ATTRIBUTE7_DATE							DATE,
	ATTRIBUTE8_DATE							DATE,
	ATTRIBUTE9_DATE							DATE,
	ATTRIBUTE10_DATE						DATE,
	ATTRIBUTE11_DATE						DATE,
	ATTRIBUTE12_DATE						DATE,
	ATTRIBUTE13_DATE						DATE,
	ATTRIBUTE14_DATE						DATE,
	ATTRIBUTE15_DATE						DATE,
	SOURCE_APPLICATION_CODE     			VARCHAR2(240),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	OPERATING_UNIT 							VARCHAR2(240 ), 
	LEDGER_NAME 							VARCHAR2(30 ),
	BATCH_ID 								VARCHAR2(80 ), 
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6),
	LOAD_STATUS 							VARCHAR2(10 ), 
	IMPORT_STATUS 							VARCHAR2(10 )
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_TRX_CONTROL_STG
PROMPT
--

-- ****************************
-- **Transaction Controls Table
-- ****************************
CREATE TABLE  XXMX_PPM_PRJ_TRX_CONTROL_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	TXN_CTRL_REFERENCE 						VARCHAR2(240), 
	PROJECT_NAME							VARCHAR2(240),
	PROJECT_NUMBER							VARCHAR2(25),
	TASK_NUMBER								VARCHAR2(100),
	TASK_NAME								VARCHAR2(255),
	EXPENDITURE_CATEGORY_NAME				VARCHAR2(240),
	EXPENDITURE_TYPE						VARCHAR2(240),
	NON_LABOR_RESOURCE						VARCHAR2(240),
	PERSON_NUMBER							VARCHAR2(30),
	PERSON_NAME								VARCHAR2(2000),
	PERSON_EMAIL							VARCHAR2(360),
	PERSON_TYPE								VARCHAR2(20),
	JOB_NAME								VARCHAR2(240),
	ORGANIZATION_NAME						VARCHAR2(240),
	CHARGEABLE_FLAG							VARCHAR2(1),
	BILLABLE_FLAG							VARCHAR2(1),
	CAPITALIZABLE_FLAG						VARCHAR2(1),
	START_DATE_ACTIVE						DATE,
	END_DATE_ACTIVE							DATE,
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ), 
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_TEAM_MEM_STG
PROMPT
--

-- ********************
-- **Team Members Table
-- ********************
CREATE TABLE  XXMX_PPM_PRJ_TEAM_MEM_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	PROJECT_NAME							VARCHAR2(240),
	TEAM_MEMBER_NUMBER						NUMBER(30),
	TEAM_MEMBER_NAME						VARCHAR2(240),
	TEAM_MEMBER_EMAIL						VARCHAR2(240),
	PROJECT_ROLE							VARCHAR2(240),
	START_DATE_ACTIVE						DATE,
	END_DATE_ACTIVE							DATE,
	ALLOCATION								NUMBER,
	LABOR_EFFORT							NUMBER,
	COST_RATE								NUMBER,
	BILL_RATE								NUMBER,
	TRACK_TIME								VARCHAR2(1),
	ASSIGNMENT_TYPE_CODE					VARCHAR2(30),
	BILLABLE_PERCENT						NUMBER,
	BILLABLE_PERCENT_REASON_CODE			VARCHAR2(30),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ), 
	BATCH_NAME 								VARCHAR2(240 ), 
	PROJECT_NUMBER 							VARCHAR2(25 ),
	ORGANIZATION_NAME 						VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 	
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_CLASS_STG
PROMPT
--

-- *****************************
-- **Party Classifications Table
-- *****************************
CREATE TABLE  XXMX_PPM_PRJ_CLASS_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	PROJECT_NAME 							VARCHAR2(240), 
	CLASS_CATEGORY							VARCHAR2(240),
	CLASS_CODE								VARCHAR2(240),
	CODE_PERCENTAGE							NUMBER,
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	PROJECT_NUMBER 							VARCHAR2(25 ),
	ORGANIZATION_NAME 						VARCHAR2(240 ),
	BATCH_ID 								VARCHAR2(80 ), 
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PLANRBS_HEADER_STG
PROMPT
--

-- ******************
-- **RBS Header Table
-- ******************
CREATE TABLE  XXMX_PPM_PLANRBS_HEADER_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	RBS_HEADER_NAME							VARCHAR2(240),
	DESCRIPTION								VARCHAR2(2000),
	PROJECT_UNIT_NAME						VARCHAR2(240),
	JOB_SET_NAME							VARCHAR2(80),
	ALLOW_CHANGE_IN_PROJECT_FLAG			VARCHAR2(1),
	AUTO_ADD_RES_FLAG						VARCHAR2(1),
	START_DATE_ACTIVE						DATE,
	END_DATE_ACTIVE							DATE,
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ),
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_RESOURCES_STG
PROMPT
--

-- *****************
-- **Resources Table
-- *****************
CREATE TABLE  XXMX_PPM_RESOURCES_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	RBS_HEADER_NAME							VARCHAR2(240),
	RES_FORMAT_NAME 						VARCHAR2(240),
	ALIAS									VARCHAR2(240),
	LEVEL1_RES_NAME							VARCHAR2(300),
	LEVEL2_RES_NAME							VARCHAR2(300),
	LEVEL3_RES_NAME							VARCHAR2(300), 
	RESOURCE_CLASS_NAME						VARCHAR2(240),
	SPREAD_CURVE_NAME						VARCHAR2(240),
	PROJECT_NUMBER							VARCHAR2(25),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ),
	BATCH_NAME 								VARCHAR2(240 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_BILLEVENT_STG
PROMPT
--

-- **********************
-- **Billing Events Table
-- **********************
CREATE TABLE  XXMX_PPM_PRJ_BILLEVENT_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	SOURCENAME  							VARCHAR2(80), 
	SOURCEREF 								VARCHAR2(80), 
	ORGANIZATION_NAME 						VARCHAR2(240), 
	CONTRACT_TYPE 							VARCHAR2(150), 
	CONTRACT_NUMBER							VARCHAR2(120),
	CONTRACT_LINE_NUMBER					VARCHAR2(150), 
	EVENT_TYPE								VARCHAR2(240),
	EVENT_DESCRIPTION						VARCHAR2(240), 
	EVENT_COMPLETION_DATE 					DATE,
	BILL_TRNS_CURRENCY_CODE 				VARCHAR2(15), 
	BILL_TRNS_AMOUNT						NUMBER,
	PROJECT_NUMBER  						VARCHAR2(25), 
	TASK_NUMBER   							VARCHAR2(100), 
	BILL_HOLD_FLAG  						VARCHAR2(1), 
	REVENUE_HOLD_FLAG  						VARCHAR2(1),  
	ATTRIBUTE_CATEGORY 						VARCHAR2(30), 
	ATTRIBUTE1 								VARCHAR2(150), 
	ATTRIBUTE2								VARCHAR2(150), 
	ATTRIBUTE3								VARCHAR2(150), 
	ATTRIBUTE4								VARCHAR2(150), 
	ATTRIBUTE5								VARCHAR2(150), 
	ATTRIBUTE6								VARCHAR2(150), 
	ATTRIBUTE7								VARCHAR2(150), 
	ATTRIBUTE8								VARCHAR2(150), 
	ATTRIBUTE9								VARCHAR2(150), 
	ATTRIBUTE10 							VARCHAR2(150), 
	ATTRIBUTE11								VARCHAR2(240), 
	ATTRIBUTE12								VARCHAR2(240), 
	ATTRIBUTE13								VARCHAR2(240), 
	ATTRIBUTE14								VARCHAR2(240), 
	ATTRIBUTE15								VARCHAR2(240), 
	ATTRIBUTE16								VARCHAR2(240), 
	ATTRIBUTE17								VARCHAR2(240), 
	ATTRIBUTE18								VARCHAR2(240), 
	ATTRIBUTE19								VARCHAR2(240), 
	ATTRIBUTE20								VARCHAR2(240), 
	ATTRIBUTE21 							VARCHAR2(1000), 
	ATTRIBUTE22								VARCHAR2(1000), 
	ATTRIBUTE23								VARCHAR2(1000), 
	ATTRIBUTE24								VARCHAR2(1000), 
	ATTRIBUTE25								VARCHAR2(1000), 
	ATTRIBUTE26								VARCHAR2(1000), 
	ATTRIBUTE27								VARCHAR2(1000), 
	ATTRIBUTE28								VARCHAR2(1000), 
	ATTRIBUTE29								VARCHAR2(1000), 
	ATTRIBUTE30								VARCHAR2(1000), 
	ATTRIBUTE_NUMBER1						NUMBER,
	ATTRIBUTE_NUMBER2						NUMBER,
	ATTRIBUTE_NUMBER3						NUMBER,
	ATTRIBUTE_NUMBER4						NUMBER,
	ATTRIBUTE_NUMBER5						NUMBER,
	ATTRIBUTE_NUMBER6						NUMBER,
	ATTRIBUTE_NUMBER7						NUMBER,
	ATTRIBUTE_NUMBER8						NUMBER,
	ATTRIBUTE_NUMBER9						NUMBER,
	ATTRIBUTE_NUMBER10						NUMBER,
	ATTRIBUTE_DATE1							DATE,
	ATTRIBUTE_DATE2							DATE,
	ATTRIBUTE_DATE3							DATE,
	ATTRIBUTE_DATE4							DATE,
	ATTRIBUTE_DATE5							DATE,
	ATTRIBUTE_DATE6							DATE,
	ATTRIBUTE_DATE7							DATE,
	ATTRIBUTE_DATE8							DATE,
	ATTRIBUTE_DATE9							DATE,
	ATTRIBUTE_DATE10						DATE,
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP,
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP,
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP,
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP,
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP,
	REVERSE_ACCRUAL_FLAG					VARCHAR2(1),
	ITEM_EVENT_FLAG							VARCHAR2(1),
	QUANTITY								NUMBER,
	ITEM_NUMBER								VARCHAR2(300),
	UNIT_OF_MEASURE							VARCHAR2(25),
	UNIT_PRICE								NUMBER,
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ),
	BATCH_NAME 								VARCHAR2(240 ),
	INT_REC_ID 								NUMBER, 
	LOAD_REQUEST_ID 						NUMBER, 
	LOAD_STATUS 							VARCHAR2(10 ), 
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_MISCCOST_STG
PROMPT
--

-- **************************
-- **Miscellaneous Cost Table
-- **************************
CREATE TABLE  XXMX_PPM_PRJ_MISCCOST_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	TRANSACTION_TYPE						VARCHAR2 (240),
	BUSINESS_UNIT							VARCHAR2 (240),
	ORG_ID									NUMBER,
	USER_TRANSACTION_SOURCE					VARCHAR2 (240),
	TRANSACTION_SOURCE_ID					NUMBER,
	DOCUMENT_NAME							VARCHAR2 (240),
	DOCUMENT_ID								NUMBER,
	DOC_ENTRY_NAME							VARCHAR2 (240),
	DOC_ENTRY_ID							NUMBER,
	BATCH_NAME								VARCHAR2 (50),
	BATCH_ENDING_DATE						DATE,
	BATCH_DESCRIPTION						VARCHAR2 (250),
	EXPENDITURE_ITEM_DATE					DATE,
	PERSON_NUMBER							VARCHAR2 (30),
	PERSON_NAME								VARCHAR2 (2000),
	PERSON_ID								NUMBER,
	HCM_ASSIGNMENT_NAME						VARCHAR2 (80),
	HCM_ASSIGNMENT_ID						NUMBER,
	PROJECT_NUMBER							VARCHAR2 (25),
	PROJECT_NAME							VARCHAR2 (240),
	PROJECT_ID								NUMBER,
	TASK_NUMBER								VARCHAR2 (100),
	TASK_NAME								VARCHAR2 (255),
	TASK_ID									NUMBER,
	EXPENDITURE_TYPE						VARCHAR2 (240),
	EXPENDITURE_TYPE_ID						NUMBER,
	ORGANIZATION_NAME						VARCHAR2 (240),
	ORGANIZATION_ID							NUMBER,
	CONTRACT_NUMBER							VARCHAR2 (120),
	CONTRACT_NAME							VARCHAR2 (240),
	CONTRACT_ID								NUMBER,
	FUNDING_SOURCE_NUMBER					VARCHAR2 (240),
	FUNDING_SOURCE_NAME						VARCHAR2 (240),
	FUNDING_SOURCE_ID						VARCHAR2(150),
	QUANTITY								NUMBER,
	UNIT_OF_MEASURE_NAME					VARCHAR2 (80),
	UNIT_OF_MEASURE							VARCHAR2 (30),
	WORK_TYPE								VARCHAR2 (240),
	WORK_TYPE_ID							NUMBER,
	BILLABLE_FLAG							VARCHAR2 (1),
	CAPITALIZABLE_FLAG						VARCHAR2 (1),
	ACCRUAL_FLAG							VARCHAR2 (1),
	ORIG_TRANSACTION_REFERENCE				VARCHAR2 (120),
	UNMATCHED_NEGATIVE_TXN_FLAG				VARCHAR2 (1),
	REVERSED_ORIG_TXN_REFERENCE				VARCHAR2 (120),
	EXPENDITURE_COMMENT						VARCHAR2 (240),
	GL_DATE									DATE,
	DENOM_CURRENCY_CODE						VARCHAR2 (15),
	DENOM_CURRENCY							VARCHAR2 (80),
	DENOM_RAW_COST							NUMBER,
	DENOM_BURDENED_COST						NUMBER,
	RAW_COST_CR_CCID						NUMBER,
	RAW_COST_CR_ACCOUNT						VARCHAR2 (2000),
	RAW_COST_DR_CCID						NUMBER,
	RAW_COST_DR_ACCOUNT						VARCHAR2 (2000),
	BURDENED_COST_CR_CCID					NUMBER,
	BURDENED_COST_CR_ACCOUNT				VARCHAR2 (2000),
	BURDENED_COST_DR_CCID					NUMBER,
	BURDENED_COST_DR_ACCOUNT				VARCHAR2 (2000),
	BURDEN_COST_CR_CCID						NUMBER,
	BURDEN_COST_CR_ACCOUNT					VARCHAR2 (2000),
	BURDEN_COST_DR_CCID						NUMBER,
	BURDEN_COST_DR_ACCOUNT					VARCHAR2 (2000),
	ACCT_CURRENCY_CODE						VARCHAR2 (15),
	ACCT_CURRENCY							VARCHAR2 (80),
	ACCT_RAW_COST							NUMBER,
	ACCT_BURDENED_COST						NUMBER,
	ACCT_RATE_TYPE							VARCHAR2 (30),
	ACCT_RATE_DATE							DATE,
	ACCT_RATE_DATE_TYPE						VARCHAR2(4),
	ACCT_EXCHANGE_RATE						NUMBER,
	ACCT_EXCHANGE_ROUNDING_LIMIT			NUMBER,
	CONVERTED_FLAG							VARCHAR2(1), 
	CONTEXT_CATEGORY						VARCHAR2(40),
	USER_DEF_ATTRIBUTE1						VARCHAR2(150),
	USER_DEF_ATTRIBUTE2						VARCHAR2(150),
	USER_DEF_ATTRIBUTE3						VARCHAR2(150),
	USER_DEF_ATTRIBUTE4						VARCHAR2(150),
	USER_DEF_ATTRIBUTE5						VARCHAR2(150),
	USER_DEF_ATTRIBUTE6						VARCHAR2(150),
	USER_DEF_ATTRIBUTE7						VARCHAR2(150),
	USER_DEF_ATTRIBUTE8						VARCHAR2(150),
	USER_DEF_ATTRIBUTE9						VARCHAR2(150),
	USER_DEF_ATTRIBUTE10					VARCHAR2(150),
	RESERVED_ATTRIBUTE1 					VARCHAR2(150),
	RESERVED_ATTRIBUTE2						VARCHAR2(150),
	RESERVED_ATTRIBUTE3						VARCHAR2(150),
	RESERVED_ATTRIBUTE4						VARCHAR2(150),
	RESERVED_ATTRIBUTE5						VARCHAR2(150),
	RESERVED_ATTRIBUTE6						VARCHAR2(150),
	RESERVED_ATTRIBUTE7						VARCHAR2(150),
	RESERVED_ATTRIBUTE8						VARCHAR2(150),
	RESERVED_ATTRIBUTE9						VARCHAR2(150),
	RESERVED_ATTRIBUTE10					VARCHAR2(150),
	ATTRIBUTE_CATEGORY						VARCHAR2(30),
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ),
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_LBRCOST_STG
PROMPT
--

-- ******************
-- **Labor Cost Table
-- ******************
CREATE TABLE  XXMX_PPM_PRJ_LBRCOST_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	TRANSACTION_TYPE						VARCHAR2 (240),
	BUSINESS_UNIT							VARCHAR2 (240),
	ORG_ID									NUMBER,
	USER_TRANSACTION_SOURCE					VARCHAR2 (240),
	TRANSACTION_SOURCE_ID					NUMBER,
	DOCUMENT_NAME							VARCHAR2 (240),
	DOCUMENT_ID								NUMBER,
	DOC_ENTRY_NAME							VARCHAR2 (240),
	DOC_ENTRY_ID							NUMBER,
	BATCH_NAME								VARCHAR2 (50),
	BATCH_ENDING_DATE						DATE,
	BATCH_DESCRIPTION						VARCHAR2 (250),
	EXPENDITURE_ITEM_DATE					DATE,
	PERSON_NUMBER							VARCHAR2 (30),
	PERSON_NAME								VARCHAR2 (2000),
	PERSON_ID								NUMBER,
	HCM_ASSIGNMENT_NAME						VARCHAR2 (80),
	HCM_ASSIGNMENT_ID						NUMBER,
	PROJECT_NUMBER							VARCHAR2 (25),
	PROJECT_NAME							VARCHAR2 (240),
	PROJECT_ID								NUMBER,
	TASK_NUMBER								VARCHAR2 (100),
	TASK_NAME								VARCHAR2 (255),
	TASK_ID									NUMBER,
	EXPENDITURE_TYPE						VARCHAR2 (240),
	EXPENDITURE_TYPE_ID						NUMBER,
	ORGANIZATION_NAME						VARCHAR2 (240),
	ORGANIZATION_ID							NUMBER,
	CONTRACT_NUMBER							VARCHAR2 (120),
	CONTRACT_NAME							VARCHAR2 (240),
	CONTRACT_ID								NUMBER,
	FUNDING_SOURCE_NUMBER					VARCHAR2 (240),
	FUNDING_SOURCE_NAME						VARCHAR2 (240),
	FUNDING_SOURCE_ID						VARCHAR2(150),
	QUANTITY								NUMBER,
	UNIT_OF_MEASURE_NAME					VARCHAR2 (80),
	UNIT_OF_MEASURE							VARCHAR2 (30),
	WORK_TYPE								VARCHAR2 (240),
	WORK_TYPE_ID							NUMBER,
	PROJECT_ROLE_NAME						VARCHAR2 (240),
	PROJECT_ROLE_ID							NUMBER,
	BILLABLE_FLAG							VARCHAR2 (1),
	CAPITALIZABLE_FLAG						VARCHAR2 (1),
	ORIG_TRANSACTION_REFERENCE				VARCHAR2 (120),
	UNMATCHED_NEGATIVE_TXN_FLAG				VARCHAR2 (1),
	REVERSED_ORIG_TXN_REFERENCE				VARCHAR2 (120),
	EXPENDITURE_COMMENT						VARCHAR2 (240),
	GL_DATE									DATE,
	DENOM_CURRENCY_CODE						VARCHAR2 (15),
	DENOM_CURRENCY							VARCHAR2 (80),
	DENOM_RAW_COST							NUMBER,
	DENOM_BURDENED_COST						NUMBER,
	RAW_COST_CR_CCID						NUMBER,
	RAW_COST_CR_ACCOUNT						VARCHAR2 (2000),
	RAW_COST_DR_CCID						NUMBER,
	RAW_COST_DR_ACCOUNT						VARCHAR2 (2000),
	BURDENED_COST_CR_CCID					NUMBER,
	BURDENED_COST_CR_ACCOUNT				VARCHAR2 (2000),
	BURDENED_COST_DR_CCID					NUMBER,
	BURDENED_COST_DR_ACCOUNT				VARCHAR2 (2000),
	BURDEN_COST_CR_CCID						NUMBER,
	BURDEN_COST_CR_ACCOUNT					VARCHAR2 (2000),
	BURDEN_COST_DR_CCID						NUMBER,
	BURDEN_COST_DR_ACCOUNT					VARCHAR2 (2000),
	ACCT_CURRENCY_CODE						VARCHAR2 (15),
	ACCT_CURRENCY							VARCHAR2 (80),
	ACCT_RAW_COST							NUMBER,
	ACCT_BURDENED_COST						NUMBER,
	ACCT_RATE_TYPE							VARCHAR2 (30),
	ACCT_RATE_DATE							DATE,
	ACCT_RATE_DATE_TYPE						VARCHAR2(4),
	ACCT_EXCHANGE_RATE						NUMBER,
	ACCT_EXCHANGE_ROUNDING_LIMIT			NUMBER,
	CONVERTED_FLAG							VARCHAR2(1), 
	CONTEXT_CATEGORY						VARCHAR2(40),
	USER_DEF_ATTRIBUTE1						VARCHAR2(150),
	USER_DEF_ATTRIBUTE2						VARCHAR2(150),
	USER_DEF_ATTRIBUTE3						VARCHAR2(150),
	USER_DEF_ATTRIBUTE4						VARCHAR2(150),
	USER_DEF_ATTRIBUTE5						VARCHAR2(150),
	USER_DEF_ATTRIBUTE6						VARCHAR2(150),
	USER_DEF_ATTRIBUTE7						VARCHAR2(150),
	USER_DEF_ATTRIBUTE8						VARCHAR2(150),
	USER_DEF_ATTRIBUTE9						VARCHAR2(150),
	USER_DEF_ATTRIBUTE10					VARCHAR2(150),
	RESERVED_ATTRIBUTE1 					VARCHAR2(150),
	RESERVED_ATTRIBUTE2						VARCHAR2(150),
	RESERVED_ATTRIBUTE3						VARCHAR2(150),
	RESERVED_ATTRIBUTE4						VARCHAR2(150),
	RESERVED_ATTRIBUTE5						VARCHAR2(150),
	RESERVED_ATTRIBUTE6						VARCHAR2(150),
	RESERVED_ATTRIBUTE7						VARCHAR2(150),
	RESERVED_ATTRIBUTE8						VARCHAR2(150),
	RESERVED_ATTRIBUTE9						VARCHAR2(150),
	RESERVED_ATTRIBUTE10					VARCHAR2(150),
	ATTRIBUTE_CATEGORY						VARCHAR2(30),
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	ACCRUAL_FLAG 							VARCHAR2(1 ),
	BATCH_ID 								VARCHAR2(80 ),
	EXP_BATCH_NAME 							VARCHAR2(240 ), 
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_SUPCOST_STG
PROMPT
--

-- *********************
-- **Supplier Cost Table
-- *********************
CREATE TABLE  XXMX_PPM_PRJ_SUPCOST_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	TRANSACTION_TYPE						VARCHAR2 (240),
	BUSINESS_UNIT							VARCHAR2 (240),
	ORG_ID									NUMBER,
	USER_TRANSACTION_SOURCE					VARCHAR2 (240),
	TRANSACTION_SOURCE_ID					NUMBER,
	DOCUMENT_NAME							VARCHAR2 (240),
	DOCUMENT_ID								NUMBER,
	DOC_ENTRY_NAME							VARCHAR2 (240),
	DOC_ENTRY_ID							NUMBER,
	BATCH_NAME								VARCHAR2 (50),
	BATCH_ENDING_DATE						DATE,
	BATCH_DESCRIPTION						VARCHAR2 (250),
	EXPENDITURE_ITEM_DATE					DATE,
	PROJECT_NUMBER							VARCHAR2 (25),
	PROJECT_NAME							VARCHAR2 (240),
	PROJECT_ID								NUMBER,
	TASK_NUMBER								VARCHAR2 (100),
	TASK_NAME								VARCHAR2 (255),
	TASK_ID									NUMBER,
	EXPENDITURE_TYPE						VARCHAR2 (240),
	EXPENDITURE_TYPE_ID						NUMBER,
	ORGANIZATION_NAME						VARCHAR2 (240),
	ORGANIZATION_ID							NUMBER,
	CONTRACT_NUMBER							VARCHAR2 (120),
	CONTRACT_NAME							VARCHAR2 (240),
	CONTRACT_ID								NUMBER,
	FUNDING_SOURCE_NUMBER					VARCHAR2 (240),
	FUNDING_SOURCE_NAME						VARCHAR2 (240),
	FUNDING_SOURCE_ID						VARCHAR2(150),
	QUANTITY								NUMBER,
	UNIT_OF_MEASURE_NAME					VARCHAR2 (80),
	UNIT_OF_MEASURE							VARCHAR2 (30),
	WORK_TYPE								VARCHAR2 (240),
	WORK_TYPE_ID							NUMBER,
	BILLABLE_FLAG							VARCHAR2 (1),
	CAPITALIZABLE_FLAG						VARCHAR2 (1),
	SUPPLIER_NUMBER							VARCHAR2(30),
	SUPPLIER_NAME							VARCHAR2(360),
	VENDOR_ID								NUMBER,
	ORIG_TRANSACTION_REFERENCE				VARCHAR2 (120),
	UNMATCHED_NEGATIVE_TXN_FLAG				VARCHAR2 (1),
	REVERSED_ORIG_TXN_REFERENCE				VARCHAR2 (120),
	EXPENDITURE_COMMENT						VARCHAR2 (240),
	GL_DATE									DATE,
	DENOM_CURRENCY_CODE						VARCHAR2 (15),
	DENOM_CURRENCY							VARCHAR2 (80),
	DENOM_RAW_COST							NUMBER,
	DENOM_BURDENED_COST						NUMBER,
	RAW_COST_CR_CCID						NUMBER,
	RAW_COST_CR_ACCOUNT						VARCHAR2 (2000),
	RAW_COST_DR_CCID						NUMBER,
	RAW_COST_DR_ACCOUNT						VARCHAR2 (2000),
	BURDENED_COST_CR_CCID					NUMBER,
	BURDENED_COST_CR_ACCOUNT				VARCHAR2 (2000),
	BURDENED_COST_DR_CCID					NUMBER,
	BURDENED_COST_DR_ACCOUNT				VARCHAR2 (2000),
	BURDEN_COST_CR_CCID						NUMBER,
	BURDEN_COST_CR_ACCOUNT					VARCHAR2 (2000),
	BURDEN_COST_DR_CCID						NUMBER,
	BURDEN_COST_DR_ACCOUNT					VARCHAR2 (2000),
	ACCT_CURRENCY_CODE						VARCHAR2 (15),
	ACCT_CURRENCY							VARCHAR2 (80),
	ACCT_RAW_COST							NUMBER,
	ACCT_BURDENED_COST						NUMBER,
	ACCT_RATE_TYPE							VARCHAR2 (30),
	ACCT_RATE_DATE							DATE,
	ACCT_RATE_DATE_TYPE						VARCHAR2(4),
	ACCT_EXCHANGE_RATE						NUMBER,
	ACCT_EXCHANGE_ROUNDING_LIMIT			NUMBER,
	CONVERTED_FLAG							VARCHAR2(1), 
	CONTEXT_CATEGORY						VARCHAR2(40),
	USER_DEF_ATTRIBUTE1						VARCHAR2(150),
	USER_DEF_ATTRIBUTE2						VARCHAR2(150),
	USER_DEF_ATTRIBUTE3						VARCHAR2(150),
	USER_DEF_ATTRIBUTE4						VARCHAR2(150),
	USER_DEF_ATTRIBUTE5						VARCHAR2(150),
	USER_DEF_ATTRIBUTE6						VARCHAR2(150),
	USER_DEF_ATTRIBUTE7						VARCHAR2(150),
	USER_DEF_ATTRIBUTE8						VARCHAR2(150),
	USER_DEF_ATTRIBUTE9						VARCHAR2(150),
	USER_DEF_ATTRIBUTE10					VARCHAR2(150),
	RESERVED_ATTRIBUTE1 					VARCHAR2(150 ),
	RESERVED_ATTRIBUTE2						VARCHAR2(150),
	RESERVED_ATTRIBUTE3						VARCHAR2(150),
	RESERVED_ATTRIBUTE4						VARCHAR2(150),
	RESERVED_ATTRIBUTE5						VARCHAR2(150),
	RESERVED_ATTRIBUTE6						VARCHAR2(150),
	RESERVED_ATTRIBUTE7						VARCHAR2(150),
	RESERVED_ATTRIBUTE8						VARCHAR2(150),
	RESERVED_ATTRIBUTE9						VARCHAR2(150),
	RESERVED_ATTRIBUTE10					VARCHAR2(150),
	ATTRIBUTE_CATEGORY						VARCHAR2(30),
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	ACCRUAL_FLAG 							VARCHAR2(1 ),
	BATCH_ID 								VARCHAR2(80 ),
	EXP_BATCH_NAME 							VARCHAR2(240 ), 
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );
--
--
PROMPT
PROMPT Creating Table XXMX_PPM_PRJ_NONLABCOST_STG
PROMPT
--

-- **********************
-- **Non-Labor Cost Table
-- **********************
CREATE TABLE  XXMX_PPM_PRJ_NONLABCOST_STG
    (
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	LOAD_BATCH								VARCHAR2(300),
	---
	TRANSACTION_TYPE						VARCHAR2 (240),
	BUSINESS_UNIT							VARCHAR2 (240),
	ORG_ID									NUMBER,
	USER_TRANSACTION_SOURCE					VARCHAR2 (240),
	TRANSACTION_SOURCE_ID					NUMBER,
	DOCUMENT_NAME							VARCHAR2 (240),
	DOCUMENT_ID								NUMBER,
	DOC_ENTRY_NAME							VARCHAR2 (240),
	DOC_ENTRY_ID							NUMBER,
	BATCH_NAME								VARCHAR2 (50),
	BATCH_ENDING_DATE						DATE,
	BATCH_DESCRIPTION						VARCHAR2 (250),
	EXPENDITURE_ITEM_DATE					DATE,
	PERSON_NUMBER							VARCHAR2 (30),
	PERSON_NAME								VARCHAR2 (2000),
	PERSON_ID								NUMBER,
	HCM_ASSIGNMENT_NAME						VARCHAR2 (80),
	HCM_ASSIGNMENT_ID						NUMBER,
	PROJECT_NUMBER							VARCHAR2 (25),
	PROJECT_NAME							VARCHAR2 (240),
	PROJECT_ID								NUMBER,
	TASK_NUMBER								VARCHAR2 (100),
	TASK_NAME								VARCHAR2 (255),
	TASK_ID									NUMBER,
	EXPENDITURE_TYPE						VARCHAR2 (240),
	EXPENDITURE_TYPE_ID						NUMBER,
	ORGANIZATION_NAME						VARCHAR2 (240),
	ORGANIZATION_ID							NUMBER,
	CONTRACT_NUMBER							VARCHAR2 (120),
	CONTRACT_NAME							VARCHAR2 (240),
	CONTRACT_ID								NUMBER,
	FUNDING_SOURCE_NUMBER					VARCHAR2 (240),
	FUNDING_SOURCE_NAME						VARCHAR2 (240),
	FUNDING_SOURCE_ID						VARCHAR2(150),
	NON_LABOR_RESOURCE						VARCHAR2 (240),
	NON_LABOR_RESOURCE_ID		 			NUMBER,
	NON_LABOR_RESOURCE_ORG					VARCHAR2 (240),
	NON_LABOR_RESOURCE_ORG_ID				NUMBER,
	QUANTITY								NUMBER,
	UNIT_OF_MEASURE_NAME					VARCHAR2 (80),
	UNIT_OF_MEASURE							VARCHAR2 (30),
	WORK_TYPE								VARCHAR2 (240),
	WORK_TYPE_ID							NUMBER,
	BILLABLE_FLAG							VARCHAR2 (1),
	CAPITALIZABLE_FLAG						VARCHAR2 (1),
	ORIG_TRANSACTION_REFERENCE				VARCHAR2 (120),
	UNMATCHED_NEGATIVE_TXN_FLAG				VARCHAR2 (1),
	REVERSED_ORIG_TXN_REFERENCE				VARCHAR2 (120),
	EXPENDITURE_COMMENT						VARCHAR2 (240),
	GL_DATE									DATE,
	DENOM_CURRENCY_CODE						VARCHAR2 (15),
	DENOM_CURRENCY							VARCHAR2 (80),
	DENOM_RAW_COST							NUMBER,
	DENOM_BURDENED_COST						NUMBER,
	RAW_COST_CR_CCID						NUMBER,
	RAW_COST_CR_ACCOUNT						VARCHAR2 (2000),
	RAW_COST_DR_CCID						NUMBER,
	RAW_COST_DR_ACCOUNT						VARCHAR2 (2000),
	BURDENED_COST_CR_CCID					NUMBER,
	BURDENED_COST_CR_ACCOUNT				VARCHAR2 (2000),
	BURDENED_COST_DR_CCID					NUMBER,
	BURDENED_COST_DR_ACCOUNT				VARCHAR2 (2000),
	BURDEN_COST_CR_CCID						NUMBER,
	BURDEN_COST_CR_ACCOUNT					VARCHAR2 (2000),
	BURDEN_COST_DR_CCID						NUMBER,
	BURDEN_COST_DR_ACCOUNT					VARCHAR2 (2000),
	ACCT_CURRENCY_CODE						VARCHAR2 (15),
	ACCT_CURRENCY							VARCHAR2 (80),
	ACCT_RAW_COST							NUMBER,
	ACCT_BURDENED_COST						NUMBER,
	ACCT_RATE_TYPE							VARCHAR2 (30),
	ACCT_RATE_DATE							DATE,
	ACCT_RATE_DATE_TYPE						VARCHAR2(4),
	ACCT_EXCHANGE_RATE						NUMBER,
	ACCT_EXCHANGE_ROUNDING_LIMIT			NUMBER,
	CONVERTED_FLAG							VARCHAR2(1), 
	CONTEXT_CATEGORY						VARCHAR2(40),
	USER_DEF_ATTRIBUTE1						VARCHAR2(150),
	USER_DEF_ATTRIBUTE2						VARCHAR2(150),
	USER_DEF_ATTRIBUTE3						VARCHAR2(150),
	USER_DEF_ATTRIBUTE4						VARCHAR2(150),
	USER_DEF_ATTRIBUTE5						VARCHAR2(150),
	USER_DEF_ATTRIBUTE6						VARCHAR2(150),
	USER_DEF_ATTRIBUTE7						VARCHAR2(150),
	USER_DEF_ATTRIBUTE8						VARCHAR2(150),
	USER_DEF_ATTRIBUTE9						VARCHAR2(150),
	USER_DEF_ATTRIBUTE10					VARCHAR2(150),
	RESERVED_ATTRIBUTE1 					VARCHAR2(150 ),
	RESERVED_ATTRIBUTE2						VARCHAR2(150),
	RESERVED_ATTRIBUTE3						VARCHAR2(150),
	RESERVED_ATTRIBUTE4						VARCHAR2(150),
	RESERVED_ATTRIBUTE5						VARCHAR2(150),
	RESERVED_ATTRIBUTE6						VARCHAR2(150),
	RESERVED_ATTRIBUTE7						VARCHAR2(150),
	RESERVED_ATTRIBUTE8						VARCHAR2(150),
	RESERVED_ATTRIBUTE9						VARCHAR2(150),
	RESERVED_ATTRIBUTE10					VARCHAR2(150),
	ATTRIBUTE_CATEGORY						VARCHAR2(30),
	ATTRIBUTE1								VARCHAR2(150),
	ATTRIBUTE2								VARCHAR2(150),
	ATTRIBUTE3								VARCHAR2(150),
	ATTRIBUTE4								VARCHAR2(150),
	ATTRIBUTE5								VARCHAR2(150),
	ATTRIBUTE6								VARCHAR2(150),
	ATTRIBUTE7								VARCHAR2(150),
	ATTRIBUTE8								VARCHAR2(150),
	ATTRIBUTE9								VARCHAR2(150),
	ATTRIBUTE10								VARCHAR2(150),
	---
	/*BELOW EXCLUDED FROM FBDI TEMPLATE*/
	BATCH_ID 								VARCHAR2(80 ),
	EXP_BATCH_NAME 							VARCHAR2(240 ), 
	CREATED_BY 								VARCHAR2(64 ), 
	CREATION_DATE 							TIMESTAMP (6), 
	LAST_UPDATE_LOGIN 						VARCHAR2(64 ), 
	LAST_UPDATED_BY 						VARCHAR2(64 ), 
	LAST_UPDATE_DATE 						TIMESTAMP (6) 
    );	

--
--
PROMPT
PROMPT
PROMPT ********************
PROMPT ** Creating Synonyms
PROMPT ********************
--
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PROJECTS_STG FOR XXMX_STG.XXMX_PPM_PROJECTS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_TASKS_STG FOR XXMX_STG.XXMX_PPM_PRJ_TASKS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_TRX_CONTROL_STG FOR XXMX_STG.XXMX_PPM_PRJ_TRX_CONTROL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_TEAM_MEM_STG FOR XXMX_STG.XXMX_PPM_PRJ_TEAM_MEM_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_CLASS_STG FOR XXMX_STG.XXMX_PPM_PRJ_CLASS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PLANRBS_HEADER_STG FOR XXMX_STG.XXMX_PPM_PLANRBS_HEADER_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_RESOURCES_STG FOR XXMX_STG.XXMX_PPM_RESOURCES_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_BILLEVENT_STG FOR XXMX_STG.XXMX_PPM_PRJ_BILLEVENT_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_MISCCOST_STG FOR XXMX_STG.XXMX_PPM_PRJ_MISCCOST_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_LBRCOST_STG FOR XXMX_STG.XXMX_PPM_PRJ_LBRCOST_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_SUPCOST_STG FOR XXMX_STG.XXMX_PPM_PRJ_SUPCOST_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PPM_PRJ_NONLABCOST_STG FOR XXMX_STG.XXMX_PPM_PRJ_NONLABCOST_STG;
--
	 
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
GRANT ALL ON XXMX_STG.XXMX_PPM_PROJECTS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_TASKS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_TRX_CONTROL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_TEAM_MEM_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_CLASS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PLANRBS_HEADER_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_RESOURCES_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_BILLEVENT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_MISCCOST_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_LBRCOST_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_SUPCOST_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PPM_PRJ_NONLABCOST_STG TO XXMX_CORE;
Grant all on XXMX_STG.xxmx_ppm_prj_trx_control_seq to XXMX_CORE;
--
--
--
PROMPT
PROMPT
PROMPT ****************************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge PPM Projects Data Migration
PROMPT **                                
PROMPT ****************************************************************************************
PROMPT
PROMPT
--
--