--*****************************************************************************
--**
--**                 		   Copyright (c) 2020 Version 1
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
--** FILENAME  :  xxmx_hcm_performance_document_ext_dbi.sql
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
--** PURPOSE   :  This script installs the XXMX_CORE DB Objects for the Cloudbridge
--**              Performance Document Data Migration.
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
--**   1.0  12-SEP-2023  Shaik Latheef  	 Created Performance Document STG 
--**                                         tables for Cloudbridge. 
--**  
--**--**************************************************************************
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
PROMPT **********************************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Cloudbridge Performance Document Data Migration
PROMPT **
PROMPT **********************************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--
--
PROMPT
PROMPT Dropping Table XXMX_HCM_PERFORMANCE_DOC_EXT
PROMPT
--
EXEC DropTable ('XXMX_HCM_PERFORMANCE_DOC_EXT')
--
--
PROMPT
PROMPT Dropping Table XXMX_HCM_ATTACHMENT_EXT
PROMPT
--
EXEC DropTable ('XXMX_HCM_ATTACHMENT_EXT')
--
--
PROMPT
PROMPT Dropping Table XXMX_HCM_PARTICIPANT_EXT
PROMPT
--
EXEC DropTable ('XXMX_HCM_PARTICIPANT_EXT')
--
--
PROMPT
PROMPT Dropping Table XXMX_HCM_RATINGS_COMMENTS_EXT
PROMPT
--
EXEC DropTable ('XXMX_HCM_RATINGS_COMMENTS_EXT')
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
PROMPT Creating Table XXMX_HCM_PERFORMANCE_DOC_EXT
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- **************************************
-- ** Performance Document Complete Table
-- **************************************
CREATE TABLE XXMX_CORE.XXMX_HCM_PERFORMANCE_DOC_EXT
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'PerfDocComplete',
	---
	PERSON_NUMBER							VARCHAR2(255),
	PERSON_ID								NUMBER,
	ASSIGNMENT_NUMBER						VARCHAR2(50),
	ASSIGNMENT_ID							NUMBER,
	CUSTOMARY_NAME							VARCHAR2(250),
	EVALUATION_ID							NUMBER,
	MANAGER_ID								NUMBER,
	MANAGER_ASSIGNMENT_ID					NUMBER,
	WORKER_NAME								VARCHAR2(250),
	MANAGER_NAME							VARCHAR2(250),
	DEPARTMENT								VARCHAR2(80),
	JOB										VARCHAR2(80),
	STATUS									VARCHAR2(30),
	START_DATE								DATE,
	END_DATE								DATE,
	ASSIGNMENT_NAME							VARCHAR2(250),
	ASSIGNMENT_STATUS						VARCHAR2(80),
	OPERATION								VARCHAR2(80),
	REVIEW_PERIOD							VARCHAR2(80),
	MANAGER_ASSIGNMENT_NUMBER				VARCHAR2(30),
	TMPL_PERIOD_ID							NUMBER,
	TEMPLATE_DEFN_ID						NUMBER,
	POSITION								VARCHAR2(80),
	BUSINESS_UNIT							VARCHAR2(80),
	GRADE									VARCHAR2(80),
	EMAIL									VARCHAR2(80),
	SHORT_NAME								VARCHAR2(10),
	LEGAL_EMPLOYER							VARCHAR2(80),
	LOCATION								VARCHAR2(80),
	ACTION_REASON							VARCHAR2(30),
	SOURCE_SYSTEM_OWNER	                    VARCHAR2(50),
    SOURCE_SYSTEM_ID                        VARCHAR2(2000),
	---
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
	ATTRIBUTE_DATE1							DATE,
	ATTRIBUTE_DATE2							DATE,
	ATTRIBUTE_DATE3							DATE,
	ATTRIBUTE_DATE4							DATE,
	ATTRIBUTE_DATE5							DATE,
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6)
    )
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HCM_PERFORMANCE_DOC_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HCM_PERFORMANCE_DOC_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  
--
--
PROMPT
PROMPT Creating Table XXMX_HCM_ATTACHMENT_EXT
PROMPT
--
-- *******************
-- ** Attachment Table
-- *******************
CREATE TABLE XXMX_CORE.XXMX_HCM_ATTACHMENT_EXT
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'Attachment',
	---
	ATTACHMENT_DOCUMENT_ID					NUMBER,
	TITLE									VARCHAR2(80),
	FILES									BLOB,
	FILE_NAME								VARCHAR2(255),
	DATA_TYPE_CODE							VARCHAR2(80),
	MIME_TYPE								VARCHAR2(80),
	ENTITY_NAME								VARCHAR2(255),
	URL_OR_TEXT_OR_FILENAME					VARCHAR2(255),
	DESCRIPTION								VARCHAR2(250),
	EVALUATION_ID							NUMBER,
	CUSTOMARY_NAME							VARCHAR2(250),
	SHORT_NAME								VARCHAR2(10),
	ASSIGNMENT_ID							NUMBER,
	ASSIGNMENT_NUMBER						VARCHAR2(50),
	TMPL_PERIOD_ID							NUMBER,
	SOURCE_SYSTEM_OWNER	                    VARCHAR2(50),
    SOURCE_SYSTEM_ID                    	VARCHAR2(2000),
	---
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
	ATTRIBUTE_DATE1							DATE,
	ATTRIBUTE_DATE2							DATE,
	ATTRIBUTE_DATE3							DATE,
	ATTRIBUTE_DATE4							DATE,
	ATTRIBUTE_DATE5							DATE,
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6)
    )
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HCM_ATTACHMENT_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HCM_ATTACHMENT_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
--
--
PROMPT
PROMPT Creating Table XXMX_HCM_PARTICIPANT_EXT
PROMPT
--
-- ********************
-- ** Participant Table
-- ********************
CREATE TABLE XXMX_CORE.XXMX_HCM_PARTICIPANT_EXT
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'Participant',
	---
	EVALUATION_ID							NUMBER,
	CUSTOMARY_NAME							VARCHAR2(250),
	ASSIGNMENT_ID							NUMBER,
	PARTICIPANT_ROLE_TYPE_CODE				VARCHAR2(30),
	TMPL_PERIOD_ID							NUMBER,
	SHORT_NAME								VARCHAR2(10),
	ASSIGNMENT_NUMBER						VARCHAR2(50),
	EVAL_PARTICIPANT_ID						NUMBER,
	PARTICIPANT_PERSON_ID					NUMBER,
	PARTICIPANT_PERSON_NUMBER				VARCHAR2(30),
	SEND_REQUEST							VARCHAR2(30),
	DUE_DATE								DATE,
	MESSAGE									VARCHAR2(500),
	SELECTED_BY								VARCHAR2(80),
	FORCE_DELETE							VARCHAR2(50),
	SOURCE_SYSTEM_OWNER	                    VARCHAR2(50),
    SOURCE_SYSTEM_ID                        VARCHAR2(2000),
	---
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
	ATTRIBUTE_DATE1							DATE,
	ATTRIBUTE_DATE2							DATE,
	ATTRIBUTE_DATE3							DATE,
	ATTRIBUTE_DATE4							DATE,
	ATTRIBUTE_DATE5							DATE,
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6)
    )
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HCM_PARTICIPANT_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HCM_PARTICIPANT_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
--
--
PROMPT
PROMPT Creating Table XXMX_HCM_RATINGS_COMMENTS_EXT
PROMPT
--
-- *****************************
-- ** Ratings And Comments Table
-- *****************************
CREATE TABLE XXMX_CORE.XXMX_HCM_RATINGS_COMMENTS_EXT
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'RatingsAndComments',
	---
	EVAL_RATING_ID							NUMBER,
	EVALUATION_ID							NUMBER,
	EVAL_PARTICIPANT_ID						NUMBER,
	EVAL_SECTION_ID							NUMBER,
	PARTICIPANT_PERSON_ID					NUMBER,
	ASSIGNMENT_ID							NUMBER,
	ASSIGNMENT_NUMBER						VARCHAR2(50),
	SECTION_NAME							VARCHAR2(255),
	SECTION_TYPE_CODE						VARCHAR2(30),
	PARTICIPANT_PERSON_NUMBER				VARCHAR2(30),
	CUSTOMARY_NAME							VARCHAR2(250),
	SHORT_NAME								VARCHAR2(10),
	COMMENTS								VARCHAR2(255),
	RATING_NAME								VARCHAR2(255),
	SECTION_RATING_MODEL_ID					NUMBER,
	TMPL_PERIOD_ID							NUMBER,
	PARTICIPANT_ROLE_TYPE_CODE				VARCHAR2(240),
	RATING_LEVEL_ID							NUMBER,
	EVAL_ROLE_ID							NUMBER,
	SOURCE_SYSTEM_OWNER	                    VARCHAR2(50),
    SOURCE_SYSTEM_ID                        VARCHAR2(2000),
	---
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
	ATTRIBUTE_DATE1							DATE,
	ATTRIBUTE_DATE2							DATE,
	ATTRIBUTE_DATE3							DATE,
	ATTRIBUTE_DATE4							DATE,
	ATTRIBUTE_DATE5							DATE,
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6)
    )
  ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_HCM_RATINGS_COMMENTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_HCM_RATINGS_COMMENTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
--
--
PROMPT
PROMPT
PROMPT ********************************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge Performance Document Data Migration
PROMPT **                                
PROMPT ********************************************************************************************
PROMPT
PROMPT
--
--