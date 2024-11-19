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
--** FILENAME  :  xxmx_hcm_lrn_stg_tab.sql
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
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              HCM Learning Data Migration.
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
--**   1.0  29-JUL-2021  Shaik Latheef  	 Created Learning STG tables for Maximise.
--**   
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
PROMPT ********************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Learning Data Migration
PROMPT **
PROMPT ********************************************************************
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

EXEC DropTable ('XXMX_OLC_LEG_LEARN_STG')					
EXEC DropTable ('XXMX_OLC_LEG_LEARN_TL_STG')				
EXEC DropTable ('XXMX_OLC_NONCAT_LEARN_STG')				
EXEC DropTable ('XXMX_OLC_NONCAT_LEARN_TL_STG')			
EXEC DropTable ('XXMX_OLC_CLASS_RES_STG')					
EXEC DropTable ('XXMX_OLC_CLASS_RES_TL_STG')				
EXEC DropTable ('XXMX_OLC_INSTR_RES_STG')					
EXEC DropTable ('XXMX_OLC_COURSE_STG')						
EXEC DropTable ('XXMX_OLC_OFFER_STG')						
EXEC DropTable ('XXMX_OLC_INSTR_LED_STG')				
EXEC DropTable ('XXMX_OLC_ADHOC_STG')						
EXEC DropTable ('XXMX_OLC_CLASS_RESV_STG')				
EXEC DropTable ('XXMX_OLC_INSTR_RESV_STG')				
EXEC DropTable ('XXMX_OLC_SELFPACE_STG')					
EXEC DropTable ('XXMX_OLC_OFFER_ACC_STG')				
EXEC DropTable ('XXMX_OLC_COURSE_ACC_STG')				
EXEC DropTable ('XXMX_OLC_COURSE_TL_STG')				
EXEC DropTable ('XXMX_OLC_OFFER_TL_STG')					
EXEC DropTable ('XXMX_OLC_INSTR_ACT_TL_STG')			
EXEC DropTable ('XXMX_OLC_SELFPACE_TL_STG')				
EXEC DropTable ('XXMX_OLC_COURSE_PRICE_STG')			
EXEC DropTable ('XXMX_OLC_COURSE_PRICE_COMP_STG')		
EXEC DropTable ('XXMX_OLC_OFFER_CUST_PRICE_STG')		
EXEC DropTable ('XXMX_OLC_OFFER_CUST_PRICE_COMP_STG')		
EXEC DropTable ('XXMX_OLC_SPEC_STG')						
EXEC DropTable ('XXMX_OLC_SPEC_DEF_ACC_STG')			
EXEC DropTable ('XXMX_OLC_SPEC_SXN_STG')					
EXEC DropTable ('XXMX_OLC_SPEC_SXN_ACT_STG')			
EXEC DropTable ('XXMX_OLC_SPEC_TL_STG')					
EXEC DropTable ('XXMX_OLC_SPEC_SXN_TL_STG')				
EXEC DropTable ('XXMX_OLC_GLOB_ACC_GRP_STG')			
EXEC DropTable ('XXMX_OLC_COMM_RS_STG')					
EXEC DropTable ('XXMX_OLC_LEARN_RCD_STG')				
EXEC DropTable ('XXMX_OLC_LEARN_RCD_ACT_ATT_STG')		

--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--

-- ****************************
-- **Legacy Learning Item Table
-- ****************************
CREATE TABLE XXMX_OLC_LEG_LEARN_STG
   (
   	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'LegacyLearningItem',
	--
	LEARNING_ITEM_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250),
	SHORT_DESCRIPTION					VARCHAR2(4000),
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30),
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Legacy Learning Item Translation Table
-- ****************************************
CREATE TABLE XXMX_OLC_LEG_LEARN_TL_STG
   (	
   	FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'LegacyLearningItemTranslation',
	--
	LEARNING_ITEM_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250),
	SHORT_DESCRIPTION					VARCHAR2(4000),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Noncatalog Learning Item Table
-- ********************************
CREATE TABLE XXMX_OLC_NONCAT_LEARN_STG
   (	
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'NoncatalogLearningItem',
	--
	LEARNING_ITEM_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							VARCHAR2(4000),
	DURATION							NUMBER,
	PRICE								NUMBER,
	CURRENCY_CODE						VARCHAR2(30),
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	NON_CATALOG_URL						VARCHAR2(4000),
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Noncatalog Learning Item Translation Table
-- ********************************************
CREATE TABLE XXMX_OLC_NONCAT_LEARN_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'NoncatalogLearningItemTranslation',
	--
	LEARNING_ITEM_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250),
	DESCRIPTION							VARCHAR2(4000),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Classroom Resource Table
-- **************************
CREATE TABLE XXMX_OLC_CLASS_RES_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ClassroomResource',
	--
	CLASSROOM_RESOURCE_ID				NUMBER,
	CLASSROOM_RESOURCE_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							VARCHAR2(4000) NOT NULL ENABLE,
	CAPACITY							NUMBER(9),
	CONTACT_ID							NUMBER,
	CONTACT_NUMBER						VARCHAR2(30),
	LOCATION_ID							NUMBER,
	LOCATION_CODE						VARCHAR2(150) NOT NULL ENABLE,
	SET_CODE							VARCHAR2(30),
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Classroom Resource Translation Table
-- **************************************
CREATE TABLE XXMX_OLC_CLASS_RES_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ClassroomResourceTranslation',
	--
	CLASSROOM_RESOURCE_ID				NUMBER,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	CLASSROOM_RESOURCE_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							VARCHAR2(4000),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Instructor Resource Table
-- ***************************
CREATE TABLE XXMX_OLC_INSTR_RES_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InstructorResource',
    --
	INSTRUCTOR_RESOURCE_ID				NUMBER,
	INSTRUCTOR_RESOURCE_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	PERSON_ID							NUMBER,
	PERSON_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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

-- **************
-- **Course Table
-- **************
CREATE TABLE XXMX_OLC_COURSE_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Course',
	--
	COURSE_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	COURSE_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	SHORT_DESCRIPTION					VARCHAR2(4000),
	SYLLABUS							CLOB,
	PUBLISH_START_DATE					DATE,
	PUBLISH_END_DATE					DATE,
	MINIMUM_EXPECTED_EFFORT				NUMBER,
	MAXIMUM_EXPECTED_EFFORT				NUMBER,
	CURRENCY_CODE						VARCHAR2(30),
	MINIMUM_PRICE						NUMBER,
	MAXIMUM_PRICE						NUMBER,
	COVER_ART_FILE						CLOB,
	COVER_ART_FILE_NAME					VARCHAR2(255),
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Offering Table
-- ****************
CREATE TABLE XXMX_OLC_OFFER_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Offering',
	--
	OFFERING_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							CLOB,
	DESCRIPTION_TEXT					VARCHAR2(4000),
	OFFERING_TYPE						VARCHAR2(30) NOT NULL ENABLE,
	PUBLISH_START_DATE					DATE,
	PUBLISH_END_DATE					DATE,
	OFFERING_START_DATE					DATE,
	OFFERING_END_DATE					DATE,
	PRIMARY_LOCATION_ID					NUMBER,
	PRIMARY_LOCATION_NUMBER				VARCHAR2(30),
	LANGUAGE_CODE						VARCHAR2(30) NOT NULL ENABLE,
	FACILITATOR_TYPE					VARCHAR2(30),
	PRIMARY_INSTRUCTOR_ID				NUMBER,
	PRIMARY_INSTRUCTOR_NUMBER			VARCHAR2(30),
	TRAINING_SUPPLIER_ID				NUMBER,
	TRAINING_SUPPLIER_NUMBER			VARCHAR2(30),
	COORDINATOR_ID						NUMBER,
	COORDINATOR_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	ENABLE_CAPACITY						VARCHAR2(1),
	MINIMUM_CAPACITY					NUMBER,
	MAXIMUM_CAPACITY					NUMBER,
	ENABLE_WAITLIST						VARCHAR2(1),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	QSTNR_REQUIRED_FOR_COMPLETION		VARCHAR2(1),
	COURSE_ID							NUMBER,
	COURSE_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Instructor Led Activity Table
-- *******************************
CREATE TABLE XXMX_OLC_INSTR_LED_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InstructorLedActivity',
	--
	ACTIVITY_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_POSITION					NUMBER,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							CLOB,
	ACTIVITY_DATE						DATE NOT NULL ENABLE,
	ACTIVITY_START_TIME					VARCHAR2(50) NOT NULL ENABLE,
	ACTIVITY_END_TIME					VARCHAR2(50) NOT NULL ENABLE,
	TIME_ZONE							VARCHAR2(30) NOT NULL ENABLE,
	EXPECTED_EFFORT						NUMBER,
	SELF_COMPLETE_FLAG					VARCHAR2(1) DEFAULT 'N',
	OFFERING_ID							NUMBER,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	VIRTUAL_CLASSROOM_URL				VARCHAR2(500),
	CLASSROOM_RESOURCE_ID				NUMBER,
	CLASSROOM_RESOURCE_NUMBER			VARCHAR2(30),
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	DESCRIPTION_TEXT					VARCHAR2(4000),
	VIRTUAL_PROVIDER_ID					NUMBER,
	VIRTUAL_PROVIDER_NUMBER				VARCHAR2(30),
	VIRTUAL_PROVIDER_PRODUCT			VARCHAR2(30),
	--
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
-- **Adhoc Resource Table
-- **********************
CREATE TABLE XXMX_OLC_ADHOC_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'AdhocResource',
	--
	ADHOC_RESOURCE_ID					NUMBER,
	ADHOC_RESOURCE_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	NAME								VARCHAR2(100) NOT NULL ENABLE,
	DESCRIPTION							VARCHAR2(4000),
	QUANTITY							NUMBER,
	ACTIVITY_ID							NUMBER,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Classroom Reservation Table
-- *****************************
CREATE TABLE XXMX_OLC_CLASS_RESV_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'ClassroomReservation',
	--
	CLASSROOM_RESERVATION_ID			NUMBER,
	CLASSROOM_RESERVATION_NUMBER		VARCHAR2(30) NOT NULL ENABLE,
	CLASSROOM_RESOURCE_ID				NUMBER,
	CLASSROOM_RESOURCE_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_ID							NUMBER,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Instructor Reservation Table
-- ******************************
CREATE TABLE XXMX_OLC_INSTR_RESV_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InstructorReservation',
	--
	INSTRUCTOR_RESERVATION_ID			NUMBER,
	INSTRUCTOR_RESERVATION_NUMBER		VARCHAR2(30) NOT NULL ENABLE,
	INSTRUCTOR_RESOURCE_ID				NUMBER,
	INSTRUCTOR_RESOURCE_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_ID							NUMBER,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Self Paced Activity Table
-- ***************************
CREATE TABLE XXMX_OLC_SELFPACE_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SelfPacedActivity',
	--
	ACTIVITY_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_POSITION					NUMBER NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							CLOB,
	EXPECTED_EFFORT						NUMBER,
	SELF_COMPLETE_FLAG					VARCHAR2(30) DEFAULT 'N',
	CONTENT_ID							NUMBER,
	CONTENT_NUMBER						VARCHAR2(30),
	OFFERING_ID							NUMBER,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	DESCRIPTION_TEXT					VARCHAR2(2000),
	--
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
-- **Offering Default Access Table
-- *******************************
CREATE TABLE XXMX_OLC_OFFER_ACC_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OfferingDefaultAccess',
	--
	DEFAULT_ACCESS_ID					NUMBER,
	DEFAULT_ACCESS_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	SELF_VIEW_MODE						VARCHAR2(30) NOT NULL ENABLE,
	SELF_INITIAL_STATUS					VARCHAR2(30) NOT NULL ENABLE,
	SELF_ENROLL_FORM					VARCHAR2(30) DEFAULT 'N',
	SELF_ACTIVATE_APPROVE				VARCHAR2(30),
	SELF_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	SELF_QUESTIONNAIRE_CODE				VARCHAR2(30),
	SELF_PREREQ_TYPE					VARCHAR2(30),
	SELF_WITHDRAW_PREREQ_DAYS			NUMBER,
	MGR_INITIAL_STATUS					VARCHAR2(30) NOT NULL ENABLE,
	MGR_ACTIVATE_APPROVE				VARCHAR2(30),
	MGR_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	MGR_QUESTIONNAIRE_CODE				VARCHAR2(240),
	MGR_WITHDRAW_PREREQ_DAYS			NUMBER,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	OFFERING_ID							NUMBER,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	--
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
-- **Course Default Access Table
-- *****************************
CREATE TABLE XXMX_OLC_COURSE_ACC_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CourseDefaultAccess',
	--
	DEFAULT_ACCESS_ID					NUMBER,
	DEFAULT_ACCESS_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	COURSE_ID                           NUMBER,
	COURSE_NUMBER                       VARCHAR2(30) NOT NULL ENABLE,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	FOLLOW_COMMUNITY					VARCHAR2(30) DEFAULT 'N',
	FOLLOW_SPECIALIZATION				VARCHAR2(30) DEFAULT 'N',
	SELF_VIEW_MODE						VARCHAR2(30) NOT NULL ENABLE,
	SELF_INITIAL_STATUS					VARCHAR2(30) NOT NULL ENABLE,
	SELF_ENROLL_FORM					VARCHAR2(30) DEFAULT 'N',
	SELF_ACTIVATE_APPROVE				VARCHAR2(30),
	SELF_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	SELF_QUESTIONNAIRE_CODE				VARCHAR2(240),
	SELF_PREREQ_TYPE					VARCHAR2(30),
	SELF_WITHDRAW_PREREQ_DAYS			NUMBER,
	MGR_INITIAL_STATUS					VARCHAR2(30) NOT NULL ENABLE,
	MGR_ACTIVATE_APPROVE				VARCHAR2(30),
	MGR_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	MGR_QUESTIONNAIRE_CODE				VARCHAR2(240),
	MGR_WITHDRAW_PREREQ_DAYS			NUMBER,
	MGR_MARK_COMPLETE					VARCHAR2(30) DEFAULT 'N',
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Course Translation Table
-- **************************
CREATE TABLE XXMX_OLC_COURSE_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CourseTranslation',
	--
	COURSE_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	COURSE_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250),
	SHORT_DESCRIPTION					VARCHAR2(4000),
	SYLLABUS							CLOB,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	SYLLABUS_TEXT						VARCHAR2(4000),
	--
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
-- **Offering Translation Table
-- ****************************
CREATE TABLE XXMX_OLC_OFFER_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OfferingTranslation',
	--
	OFFERING_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE, 
	TITLE								VARCHAR2(240), 
	DESCRIPTION							CLOB,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	DESCRIPTION_TEXT					VARCHAR2(4000), 
	--
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
-- **Instructor Led Activity Translation Table
-- *******************************************
CREATE TABLE XXMX_OLC_INSTR_ACT_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'InstructorLedActivityTranslation',
	--
	ACTIVITY_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(240), 
	DESCRIPTION							CLOB,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	DESCRIPTION_TEXT					VARCHAR2(4000), 
	--
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
-- **Self Paced Activity Translation Table
-- ***************************************
CREATE TABLE XXMX_OLC_SELFPACE_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SelfPacedActivityTranslation',
	--
	ACTIVITY_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(240), 
	DESCRIPTION							CLOB,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	DESCRIPTION_TEXT					VARCHAR2(4000), 
	--
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
-- **Course Offering Pricing Defaults Table
-- ****************************************
CREATE TABLE XXMX_OLC_COURSE_PRICE_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CourseOfferingPricingDefaults',
	--
	PRICING_RULE_ID						NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	PRICING_RULE_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	CURRENCY_CODE						VARCHAR2(30) NOT NULL ENABLE,
	OFFERING_TYPE						VARCHAR2(30),
	COURSE_ID							NUMBER,
	COURSE_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Course Offering Pricing Component Table
-- *****************************************
CREATE TABLE XXMX_OLC_COURSE_PRICE_COMP_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CourseOfferingPricingComponent',
	--
	PRICING_COMPONENT_ID				NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	PRICING_COMPONENT_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	PRICING_COMPONENT_TYPE				VARCHAR2(30),
	PRICE								NUMBER NOT NULL ENABLE,
	INCLUDE_IN_SELF_SERVICE_PRICING		VARCHAR2(30) DEFAULT 'N',
	REQUIRED							VARCHAR2(30) DEFAULT 'N',
	PRICING_RULE_ID						NUMBER,
	PRICING_RULE_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Offering Custom Pricing Table
-- *******************************
CREATE TABLE XXMX_OLC_OFFER_CUST_PRICE_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OfferingCustomPricing',
	--
	PRICING_RULE_ID						NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	PRICING_RULE_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	CURRENCY_CODE						VARCHAR2(30) NOT NULL ENABLE,
	OFFERING_ID							NUMBER,
	OFFERING_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Offering Custom Pricing Component Table
-- *****************************************
CREATE TABLE XXMX_OLC_OFFER_CUST_PRICE_COMP_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'OfferingCustomPricingComponent',
	--
	PRICING_COMPONENT_ID				NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	PRICING_COMPONENT_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	PRICING_COMPONENT_TYPE				VARCHAR2(30),
	PRICE								NUMBER NOT NULL ENABLE,
	INCLUDE_IN_SELF_SERVICE_PRICING		VARCHAR2(30) DEFAULT 'N',
	REQUIRED							VARCHAR2(30),
	PRICING_RULE_ID						NUMBER,
	PRICING_RULE_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Table
-- **********************
CREATE TABLE XXMX_OLC_SPEC_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'Specialization',
	--
	SPECIALIZATION_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	SPECIALIZATION_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	SHORT_DESCRIPTION					VARCHAR2(4000),
	DESCRIPTION							CLOB,
	PUBLISH_START_DATE					DATE,
	PUBLISH_END_DATE					DATE,
	COVER_ART_FILE						BLOB,
	COVER_ART_FILE_NAME					VARCHAR2(255),
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	MINIMUM_EXPECTED_EFFORT				NUMBER,
	MAXIMUM_EXPECTED_EFFORT				NUMBER,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Default Access Table
-- *************************************
CREATE TABLE XXMX_OLC_SPEC_DEF_ACC_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SpecializationDefaultAccess',
	--
	DEFAULT_ACCESS_ID					NUMBER,
	DEFAULT_ACCESS_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	FOLLOW_COMMUNITY					VARCHAR2(30) DEFAULT 'N',
	SELF_VIEW_MODE						VARCHAR2(30),
	SELF_INITIAL_STATUS					VARCHAR2(30),
	SELF_ENROLL_FORM					VARCHAR2(30) DEFAULT 'N',
	SELF_ACTIVATE_APPROVE				VARCHAR2(30),
	SELF_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	SELF_QUESTIONNAIRE_CODE				VARCHAR2(30),
	SELF_PREREQ_TYPE					VARCHAR2(30),
	SELF_WITHDRAW_PREREQ_DAYS			NUMBER,
	MGR_INITIAL_STATUS					VARCHAR2(30),
	MGR_ACTIVATE_APPROVE				VARCHAR2(30),
	MGR_ENROLL_QUESTIONNAIRE			VARCHAR2(30) DEFAULT 'N',
	MGR_QUESTIONNAIRE_CODE				VARCHAR2(240),
	MGR_WITHDRAW_PREREQ_DAYS			NUMBER,
	MGR_MARK_COMPLETE					VARCHAR2(30) DEFAULT 'N',
	SPECIALIZATION_ID					NUMBER,
	SPECIALIZATION_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Section Table
-- ******************************
CREATE TABLE XXMX_OLC_SPEC_SXN_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SpecializationSection',
	--
	SPECIALIZATION_SECTION_ID			NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	SPECIALIZATION_SECTION_NUMBER		VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250) NOT NULL ENABLE,
	DESCRIPTION							CLOB,
	DESCRIPTION_TEXT					VARCHAR2(4000),
	COMPLETION_RULE_TYPE				VARCHAR2(30),
	NUM_OF_ACTIVITIES_TO_COMPLETE		NUMBER,
	SEQUENCE_RULE_TYPE					VARCHAR2(30),
	SEQUENCE_RULE_SECTION_NUMBER		VARCHAR2(30),
	INIT_ASSIGN_STATUS_ACTIVITIES		VARCHAR2(30),
	SECTION_POSITION					NUMBER NOT NULL ENABLE,
	SPECIALIZATION_ID					NUMBER,
	SPECIALIZATION_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Section Activity Table
-- ***************************************
CREATE TABLE XXMX_OLC_SPEC_SXN_ACT_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SpecializationSectionActivity',
	--
	ACTIVITY_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	SPECIALIZATION_SECTION_ID			NUMBER,
	SPECIALIZATION_SECTION_NUMBER		VARCHAR2(30) NOT NULL ENABLE,
	COURSE_LEARNING_ITEM_ID				NUMBER,
	COURSE_LEARNING_ITEM_NUMBER			VARCHAR2(30),
    COMPLETION_TYPE						VARCHAR2(30) DEFAULT 'N',
    SEQUENCE_RULE_TYPE					VARCHAR2(30),
    SEQUENCE_RULE_ACTIVITY_NUMBER		VARCHAR2(30),
    ACTIVITY_POSITION					NUMBER NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Translation Table
-- **********************************
CREATE TABLE XXMX_OLC_SPEC_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SpecializationTranslation',
	--
	SPECIALIZATION_ID					NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	SPECIALIZATION_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	TITLE								VARCHAR2(250),
	DESCRIPTION							CLOB,
	SHORT_DESCRIPTION					VARCHAR2(4000),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Specialization Section Translation Table
-- ******************************************
CREATE TABLE XXMX_OLC_SPEC_SXN_TL_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'SpecializationSectionTranslation',
	--
	SPECIALIZATION_SECTION_ID           NUMBER,
	EFFECTIVE_START_DATE                DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE                  DATE,
	LANGUAGE							VARCHAR2(4) NOT NULL ENABLE,
	SPECIALIZATION_SECTION_NUMBER       VARCHAR2(30) NOT NULL ENABLE,
	TITLE                               VARCHAR2(250),
	DESCRIPTION                         CLOB,
	DESCRIPTION_TEXT                    VARCHAR2(4000),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Global Access Group Relation Table
-- ************************************
CREATE TABLE XXMX_OLC_GLOB_ACC_GRP_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'GlobalAccessGroupRelation',
	--
	RELATION_ID							NUMBER,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	RELATION_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	GLOBAL_ACCESS_GROUP_ID				NUMBER,
	GLOBAL_ACCESS_GROUP_NUMBER			VARCHAR2(30) NOT NULL ENABLE,
	LEARNING_ITEM_ID					NUMBER,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	PRIORITY							NUMBER NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Community Relation Table
-- **************************
CREATE TABLE XXMX_OLC_COMM_RS_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'CommunityRelation',
	--
	RELATION_ID							NUMBER,
	RELATION_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	EFFECTIVE_START_DATE				DATE NOT NULL ENABLE,
	EFFECTIVE_END_DATE					DATE,
	COMMUNITY_ID						NUMBER,
	COMMUNITY_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	LEARNING_ITEM_ID					NUMBER,
	LEARNING_ITEM_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
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
-- **Learning Record Table
-- ***********************
CREATE TABLE XXMX_OLC_LEARN_RCD_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'LearningRecord',
	--
	LEARNING_RECORD_ID					NUMBER,
	LEARN_RECORD_EFFECTIVE_START_DATE	DATE,
	LEARN_RECORD_EFFECTIVE_END_DATE		DATE,
	LEARNING_RECORD_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	ASSIGNMENT_NUMBER					VARCHAR2(30),
	LEARNING_ITEM_TYPE					VARCHAR2(30),
	LEARNING_ITEM_NUMBER				VARCHAR2(30),
	ASSIGNMENT_TYPE						VARCHAR2(30),
	ASSIGNMENT_SUB_TYPE					VARCHAR2(30),
	ASSIGNMENT_SOURCE_TYPE				VARCHAR2(30),
	ASSIGNMENT_SOURCE_ID				NUMBER,
	ASSIGNMENT_SOURCE_INFO				VARCHAR2(240),
	ASSIGNED_BY_PERSON_NUMBER			VARCHAR2(30),
	ASSIGNMENT_ATTRIBUTION_TYPE			VARCHAR2(30),
	ASSIGNMENT_ATTRIBUTION_NUMBER		VARCHAR2(30),
	ASSIGNMENT_ATTRIBUTION_CODE			VARCHAR2(30),
	LEARNER_NUMBER						VARCHAR2(30),
	LEARNING_RECORD_STATUS				VARCHAR2(30),
	LEARNING_RECORD_SOURCE_TYPE			VARCHAR2(30),
	LEARNING_RECORD_SOURCE_ID			NUMBER,
	LEARNING_RECORD_SOURCE_INFO			VARCHAR2(240),
	LEARNING_RECORD_START_DATE			DATE,
	LEARNING_RECORD_DUE_DATE			DATE,
	LEARNING_RECORD_WITHDRAWN_DATE		DATE,
	LEARNING_RECORD_DELETED_DATE		DATE,
	LEARNING_RECORD_COMPLETION_DATE		DATE,
	LEARNING_RECORD_VALID_FROM_DATE		DATE,
	LEARNING_REC_EXPIRY_DATE			DATE,
	LEARNING_REC_TOT_ACT_EFFORT			NUMBER,
	LEARNING_REC_TOT_ACT_EFFORT_UOM		VARCHAR2(30),
	REQUEST_DETAIL_START_DATE			DATE,
	REQUEST_DETAIL_COMPLETION_DATE		DATE,
	REQUEST_DETAIL_COMMENTS				VARCHAR2(4000),
	REQUEST_DETAIL_PO_NUMBER			VARCHAR2(30),
	LEARNING_RECORD_REASON_CODE			VARCHAR2(30),
	LEARNING_RECORD_COMMENTS			VARCHAR2(4000),
	LEARNING_RECORD_REQUEST_APPV_DATE	DATE,
	ACTUAL_SCORE						NUMBER,
	CPE_POINTS							NUMBER,
	CPE_TYPE							VARCHAR2(30),
	--
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
-- **Learning Record Activity Attempt Table
-- ****************************************
CREATE TABLE XXMX_OLC_LEARN_RCD_ACT_ATT_STG
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'LearningRecordActivityAttempt',
	--
	ACTIVITY_ATTEMPT_ID					NUMBER,
	LEARNING_RECORD_ID					NUMBER,
	LEARNING_RECORD_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_ID							NUMBER,
	ACTIVITY_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	ACTIVITY_ATTEMPT_STATUS				VARCHAR2(30),
	ACTIVITY_ATTEMPT_DATE				DATE,
	ACTIVITY_ATTEMPT_REASON_CODE		VARCHAR2(30),
	ACTIVITY_ATTEMPT_ACTUAL_SCORE		NUMBER,
	ACTIVITY_ATTEMPT_ACTUAL_EFFORT		VARCHAR2(30),
	ACTIVITY_ATTEMPT_NOTE				VARCHAR2(4000),
	--
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


CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_LEG_LEARN_STG FOR XXMX_OLC_LEG_LEARN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_LEG_LEARN_TL_STG FOR XXMX_OLC_LEG_LEARN_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_NONCAT_LEARN_STG FOR XXMX_OLC_NONCAT_LEARN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_NONCAT_LEARN_TL_STG FOR XXMX_OLC_NONCAT_LEARN_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_CLASS_RES_STG FOR XXMX_OLC_CLASS_RES_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_CLASS_RES_TL_STG FOR XXMX_OLC_CLASS_RES_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_INSTR_RES_STG FOR XXMX_OLC_INSTR_RES_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COURSE_STG FOR XXMX_OLC_COURSE_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_OFFER_STG FOR XXMX_OLC_OFFER_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_INSTR_LED_STG FOR XXMX_OLC_INSTR_LED_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_ADHOC_STG FOR XXMX_OLC_ADHOC_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_CLASS_RESV_STG FOR XXMX_OLC_CLASS_RESV_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_INSTR_RESV_STG FOR XXMX_OLC_INSTR_RESV_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SELFPACE_STG FOR XXMX_OLC_SELFPACE_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_OFFER_ACC_STG FOR XXMX_OLC_OFFER_ACC_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COURSE_ACC_STG FOR XXMX_OLC_COURSE_ACC_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COURSE_TL_STG FOR XXMX_OLC_COURSE_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_OFFER_TL_STG FOR XXMX_OLC_OFFER_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_INSTR_ACT_TL_STG FOR XXMX_OLC_INSTR_ACT_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SELFPACE_TL_STG FOR XXMX_OLC_SELFPACE_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COURSE_PRICE_STG FOR XXMX_OLC_COURSE_PRICE_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COURSE_PRICE_COMP_STG FOR XXMX_OLC_COURSE_PRICE_COMP_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_OFFER_CUST_PRICE_STG FOR XXMX_OLC_OFFER_CUST_PRICE_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_OFFER_CUST_PRICE_COMP_STG FOR XXMX_OLC_OFFER_CUST_PRICE_COMP_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_STG FOR XXMX_OLC_SPEC_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_DEF_ACC_STG FOR XXMX_OLC_SPEC_DEF_ACC_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_SXN_STG FOR XXMX_OLC_SPEC_SXN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_SXN_ACT_STG FOR XXMX_OLC_SPEC_SXN_ACT_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_TL_STG FOR XXMX_OLC_SPEC_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_SPEC_SXN_TL_STG FOR XXMX_OLC_SPEC_SXN_TL_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_GLOB_ACC_GRP_STG FOR XXMX_OLC_GLOB_ACC_GRP_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_COMM_RS_STG FOR XXMX_OLC_COMM_RS_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_LEARN_RCD_STG FOR XXMX_OLC_LEARN_RCD_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_OLC_LEARN_RCD_ACT_ATT_STG FOR XXMX_OLC_LEARN_RCD_ACT_ATT_STG;


--
--
PROMPT
PROMPT
PROMPT *****************
PROMPT ** Creating Index
PROMPT *****************
--
--


CREATE INDEX XXMX_OLC_LEG_LEARN_STG_PK ON XXMX_OLC_LEG_LEARN_STG (LEARNING_ITEM_NUMBER, OWNED_BY_PERSON_NUMBER);
CREATE INDEX XXMX_OLC_LEG_LEARN_TL_STG_UK ON XXMX_OLC_LEG_LEARN_TL_STG (LEARNING_ITEM_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_NONCAT_LEARN_STG_PK ON XXMX_OLC_NONCAT_LEARN_STG (LEARNING_ITEM_NUMBER, OWNED_BY_PERSON_NUMBER);
CREATE INDEX XXMX_OLC_NONCAT_LEARN_TL_STG_PK ON XXMX_OLC_NONCAT_LEARN_TL_STG (LEARNING_ITEM_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_CLASS_RES_STG_PK ON XXMX_OLC_CLASS_RES_STG (CLASSROOM_RESOURCE_NUMBER, CONTACT_NUMBER, LOCATION_CODE, OWNED_BY_PERSON_NUMBER, SET_CODE);
CREATE INDEX XXMX_OLC_CLASS_RES_TL_STG_PK ON XXMX_OLC_CLASS_RES_TL_STG (CLASSROOM_RESOURCE_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_INSTR_RES_STG_PK ON XXMX_OLC_INSTR_RES_STG (INSTRUCTOR_RESOURCE_NUMBER, PERSON_NUMBER, OWNED_BY_PERSON_NUMBER);
CREATE INDEX XXMX_OLC_COURSE_STG_PK ON XXMX_OLC_COURSE_STG (COURSE_NUMBER, OWNED_BY_PERSON_NUMBER);
CREATE INDEX XXMX_OLC_OFFER_STG_PK ON XXMX_OLC_OFFER_STG (OFFERING_NUMBER, COORDINATOR_NUMBER, OWNED_BY_PERSON_NUMBER, PRIMARY_INSTRUCTOR_NUMBER, PRIMARY_LOCATION_NUMBER, TRAINING_SUPPLIER_NUMBER);
CREATE INDEX XXMX_OLC_INSTR_LED_STG_PK ON XXMX_OLC_INSTR_LED_STG (ACTIVITY_NUMBER, OFFERING_NUMBER, CLASSROOM_RESOURCE_NUMBER, VIRTUAL_PROVIDER_NUMBER);
CREATE INDEX XXMX_OLC_ADHOC_STG_PK ON XXMX_OLC_ADHOC_STG (ADHOC_RESOURCE_NUMBER, ACTIVITY_NUMBER);
CREATE INDEX XXMX_OLC_CLASS_RESV_STG_PK ON XXMX_OLC_CLASS_RESV_STG (CLASSROOM_RESERVATION_NUMBER, ACTIVITY_NUMBER, CLASSROOM_RESOURCE_NUMBER);
CREATE INDEX XXMX_OLC_INSTR_RESV_STG_PK ON XXMX_OLC_INSTR_RESV_STG (INSTRUCTOR_RESERVATION_NUMBER, ACTIVITY_NUMBER, INSTRUCTOR_RESOURCE_NUMBER);
CREATE INDEX XXMX_OLC_SELFPACE_STG_PK ON XXMX_OLC_SELFPACE_STG (ACTIVITY_NUMBER, OFFERING_NUMBER, CONTENT_NUMBER);
CREATE INDEX XXMX_OLC_OFFER_ACC_STG_PK ON XXMX_OLC_OFFER_ACC_STG (DEFAULT_ACCESS_NUMBER, OFFERING_NUMBER);
CREATE INDEX XXMX_OLC_COURSE_ACC_STG_PK ON XXMX_OLC_COURSE_ACC_STG (DEFAULT_ACCESS_NUMBER, COURSE_NUMBER);
CREATE INDEX XXMX_OLC_COURSE_TL_STG_PK ON XXMX_OLC_COURSE_TL_STG (COURSE_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_OFFER_TL_STG_PK ON XXMX_OLC_OFFER_TL_STG (OFFERING_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_INSTR_ACT_TL_STG_PK ON XXMX_OLC_INSTR_ACT_TL_STG (ACTIVITY_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_SELFPACE_TL_STG_PK ON XXMX_OLC_SELFPACE_TL_STG (ACTIVITY_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_COURSE_PRICE_STG_PK ON XXMX_OLC_COURSE_PRICE_STG (PRICING_RULE_NUMBER, COURSE_NUMBER);
CREATE INDEX XXMX_OLC_COURSE_PRICE_COMP_STG_PK ON XXMX_OLC_COURSE_PRICE_COMP_STG (PRICING_COMPONENT_NUMBER, PRICING_RULE_NUMBER);
CREATE INDEX XXMX_OLC_OFFER_CUST_PRICE_STG_PK ON XXMX_OLC_OFFER_CUST_PRICE_STG (PRICING_RULE_NUMBER, OFFERING_NUMBER);
CREATE INDEX XXMX_OLC_OFFER_CUST_PRICE_COMP_STG_PK ON XXMX_OLC_OFFER_CUST_PRICE_COMP_STG (PRICING_COMPONENT_NUMBER, PRICING_RULE_NUMBER);
CREATE INDEX XXMX_OLC_SPEC_STG_PK ON XXMX_OLC_SPEC_STG (SPECIALIZATION_NUMBER, OWNED_BY_PERSON_NUMBER);
CREATE INDEX XXMX_OLC_SPEC_DEF_ACC_STG_PK ON XXMX_OLC_SPEC_DEF_ACC_STG (DEFAULT_ACCESS_NUMBER, SPECIALIZATION_NUMBER);
CREATE INDEX XXMX_OLC_SPEC_SXN_STG_PK ON XXMX_OLC_SPEC_SXN_STG (SPECIALIZATION_SECTION_NUMBER, SPECIALIZATION_NUMBER);
CREATE INDEX XXMX_OLC_SPEC_SXN_ACT_STG_PK ON XXMX_OLC_SPEC_SXN_ACT_STG (ACTIVITY_NUMBER, SPECIALIZATION_SECTION_NUMBER, COURSE_LEARNING_ITEM_NUMBER);
CREATE INDEX XXMX_OLC_SPEC_TL_STG_PK ON XXMX_OLC_SPEC_TL_STG (SPECIALIZATION_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_SPEC_SXN_TL_STG_PK ON XXMX_OLC_SPEC_SXN_TL_STG (SPECIALIZATION_SECTION_NUMBER, LANGUAGE);
CREATE INDEX XXMX_OLC_GLOB_ACC_GRP_STG_PK ON XXMX_OLC_GLOB_ACC_GRP_STG (RELATION_NUMBER, GLOBAL_ACCESS_GROUP_NUMBER, LEARNING_ITEM_NUMBER);
CREATE INDEX XXMX_OLC_COMM_RS_STG_PK ON XXMX_OLC_COMM_RS_STG (RELATION_NUMBER, COMMUNITY_NUMBER, LEARNING_ITEM_NUMBER);
CREATE INDEX XXMX_OLC_LEARN_RCD_STG_PK ON XXMX_OLC_LEARN_RCD_STG (LEARNING_RECORD_NUMBER);
CREATE INDEX XXMX_OLC_LEARN_RCD_ACT_ATT_STG_PK ON XXMX_OLC_LEARN_RCD_ACT_ATT_STG (ACTIVITY_NUMBER, LEARNING_RECORD_NUMBER);


--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--


GRANT ALL ON XXMX_OLC_LEG_LEARN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_LEG_LEARN_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_NONCAT_LEARN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_NONCAT_LEARN_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_CLASS_RES_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_OLC_CLASS_RES_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_INSTR_RES_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COURSE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_OFFER_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_INSTR_LED_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_ADHOC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_CLASS_RESV_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_INSTR_RESV_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SELFPACE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_OFFER_ACC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COURSE_ACC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COURSE_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_OFFER_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_INSTR_ACT_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SELFPACE_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COURSE_PRICE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COURSE_PRICE_COMP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_OFFER_CUST_PRICE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_OFFER_CUST_PRICE_COMP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_DEF_ACC_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_SXN_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_SXN_ACT_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_SPEC_SXN_TL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_GLOB_ACC_GRP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_COMM_RS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_LEARN_RCD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_OLC_LEARN_RCD_ACT_ATT_STG TO XXMX_CORE;


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
