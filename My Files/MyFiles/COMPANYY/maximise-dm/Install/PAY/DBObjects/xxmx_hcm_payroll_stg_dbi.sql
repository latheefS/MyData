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
--** FILENAME  :  xxmx_hcm_payroll_stg_dbi.sql
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
--**              Payroll Data Migration.
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
--**   1.0  22-AUG-2023  Shaik Latheef  	 Created Payroll STG tables for Cloudbridge. 
--**  
--**--******************************************************************************
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
PROMPT ******************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Cloudbridge Payroll Data Migration
PROMPT **
PROMPT ******************************************************************
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
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_PAE_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_PAE_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_PAE_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_PAE_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_ASOC_PAE_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_ASOC_PAE_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_ASOC_DTL_PAE_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_ASOC_DTL_PAE_STG')
EXEC DropTable ('XXMX_PAY_CARD_COMP_PAE_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_SD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_SD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_SD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_SD_STG')
EXEC DropTable ('XXMX_PAY_CARD_COMP_SD_STG')
EXEC DropTable ('XXMX_PAY_CARD_ASSOC_SD_STG')
EXEC DropTable ('XXMX_PAY_CARD_ASSOC_DTL_SD_STG')
EXEC DropTable ('XXMX_PAY_COMP_ASSOC_SD_STG')
EXEC DropTable ('XXMX_PAY_COMP_ASSOC_DTL_SD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_SL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_SL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_SL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_SL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_ASOC_SL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_ASOC_SL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_SL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_SL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_ASOC_SL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_ASOC_SL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_COMP_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_COMP_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_DTL_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_DTL_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ENTVAL_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ENTVAL_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_VALDF_BP_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_VALDF_BP_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_COMP_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_COMP_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_DTL_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_DTL_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ENTVAL_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ENTVAL_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_VALDF_NSD_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_VALDF_NSD_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARDS_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARDS_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_COMP_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_COMP_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASOC_DTL_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASOC_DTL_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ENTVAL_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ENTVAL_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_VALDF_PGL_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_VALDF_PGL_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_BALANCE_HEADERS_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_BALANCE_HEADERS_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_BALANCE_LINES_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_BALANCE_LINES_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ELEMENTS_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ELEMENTS_STG')
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_ELEM_ENTRIES_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ELEM_ENTRIES_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_CALC_CARD_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CALC_CARD_CO_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_COMP_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_COMP_CO_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_COMP_DTL_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_COMP_DTL_CO_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_CARD_ASSOC_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CARD_ASSOC_CO_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_ASSOC_DTL_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ASSOC_DTL_CO_STG')
--
--

--
PROMPT
PROMPT Dropping Table XXMX_PAY_ENTER_VAL_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_ENTER_VAL_CO_STG')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_PAY_CAL_VALDEF_CO_STG
PROMPT
--
EXEC DropTable ('XXMX_PAY_CAL_VALDEF_CO_STG')
EXEC DROPTABLE('XXMX_PAY_CALC_VALDEF_SL_STG')
EXEC DROPTABLE('XXMX_PAY_ENTER_VAL_SL_STG')
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
PROMPT Creating Table XXMX_PAY_CALC_CARDS_PAE_STG
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- *****************************
-- ** PAE Calculation Card Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_PAE_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	DIR_CARD_COMP_ID						VARCHAR2(150),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(150),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	PAYROLL_RELATIONSHIP_NUM				VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT				VARCHAR2(250),
	DIR_REP_CARD_USAGE_ID					VARCHAR2(150),
	DIR_CARD_DEFINITION_NAME             			 VARCHAR2(150),
	EMPLOYEE_CLASSIFICATION					VARCHAR2(80),
	JOB_HOLDER_DATE							DATE,
	ENROLL_ASSESMENT						VARCHAR2(80),
	CLASSIFICATION_CHGPRC_DT				DATE,
	ACT_POSTPONEMENT_TYPE					VARCHAR2(80),
	ACT_POSTPONEMENT_RULE					VARCHAR2(80),
	ACT_POSTPONEMENT_END_DATE				DATE,
	ACT_QUALIFYING_SCHEME					VARCHAR2(80),
	QUALIFYING_SCHEME_JOIN_DT				DATE,
	QUALIFYING_SCHEME_START_DT				DATE,
	QUALIFYING_SCHEME_JOIN_METHOD			VARCHAR2(80),
	TRANSFER_QUALIFYING_SCHEME				VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_REASON			VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_DATE			DATE,
	OPT_OUT_PERIOD_END_DATE					DATE,
	OPT_OUT_REFUND_DUE						VARCHAR2(80),
	HISTORIC_PEN_PAY_ROLL_ID				VARCHAR2(150),
	REASON_FOR_EXCLUSION					VARCHAR2(80),
	COMPONENT_SEQUENCE						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(250),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	OVERRIDING_WORKER_POSTPONEMENT			VARCHAR2(150),
	OVERRIDING_ELIGIBLE_JH_POSTPMNT			VARCHAR2(150),
	OVERRIDING_QUALIFYING_SCHEME			VARCHAR2(150),
	OVERRIDING_STAGING_DATE					DATE,
	LETTER_STATUS							VARCHAR2(150),
	LETTER_TYPE_DATE						DATE,
	SUBSEQUENT_COMMS_REQ					VARCHAR2(150),
	LETTER_TYPE_GENERATED					VARCHAR2(150),
	WULS_TAKEN_DATE							DATE,
	TAX_PROTECTION_APPLIED					VARCHAR2(150),
	PROC_AUTO_REENROLMENT_DATE				DATE,
	HISTORIC_PEN_PAYROLL_ID					VARCHAR2(150),
	QUALIFYING_SCHEME_ID					NUMBER,
	CARD_SEQUENCE						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(60),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** PAE Component Detail Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_PAE_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	DIR_CARD_COMP_ID						VARCHAR2(150),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(150),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	PAYROLL_RELATIONSHIP_NUM				VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT				VARCHAR2(250),
	DIR_REP_CARD_USAGE_ID					VARCHAR2(150),
	DIR_CARD_DEFINITION_NAME             			 VARCHAR2(150),
	EMPLOYEE_CLASSIFICATION					VARCHAR2(80),
	JOB_HOLDER_DATE							DATE,
	ENROLL_ASSESMENT						VARCHAR2(80),
	CLASSIFICATION_CHGPRC_DT				DATE,
	ACT_POSTPONEMENT_TYPE					VARCHAR2(80),
	ACT_POSTPONEMENT_RULE					VARCHAR2(80),
	ACT_POSTPONEMENT_END_DATE				DATE,
	ACT_QUALIFYING_SCHEME					VARCHAR2(80),
	QUALIFYING_SCHEME_JOIN_DT				DATE,
	QUALIFYING_SCHEME_START_DT				DATE,
	QUALIFYING_SCHEME_JOIN_METHOD			VARCHAR2(80),
	TRANSFER_QUALIFYING_SCHEME				VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_REASON			VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_DATE			DATE,
	OPT_OUT_PERIOD_END_DATE					DATE,
	OPT_OUT_REFUND_DUE						VARCHAR2(80),
	HISTORIC_PEN_PAY_ROLL_ID				VARCHAR2(150),
	REASON_FOR_EXCLUSION					VARCHAR2(80),
	COMPONENT_SEQUENCE						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(250),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	OVERRIDING_WORKER_POSTPONEMENT			VARCHAR2(150),
	OVERRIDING_ELIGIBLE_JH_POSTPMNT			VARCHAR2(150),
	OVERRIDING_QUALIFYING_SCHEME			VARCHAR2(150),
	OVERRIDING_STAGING_DATE					DATE,
	LETTER_STATUS							VARCHAR2(150),
	LETTER_TYPE_DATE						DATE,
	SUBSEQUENT_COMMS_REQ					VARCHAR2(150),
	LETTER_TYPE_GENERATED					VARCHAR2(150),
	WULS_TAKEN_DATE							DATE,
	TAX_PROTECTION_APPLIED					VARCHAR2(150),
	PROC_AUTO_REENROLMENT_DATE				DATE,
	HISTORIC_PEN_PAYROLL_ID					VARCHAR2(150),
	QUALIFYING_SCHEME_ID					NUMBER,
	CARD_SEQUENCE						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(60),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- **********************************
-- ** PAE Component Association Table
-- **********************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_ASOC_PAE_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociation',
	---
	DIR_CARD_COMP_ID						VARCHAR2(150),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(150),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	PAYROLL_RELATIONSHIP_NUM				VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT				VARCHAR2(250),
	DIR_REP_CARD_USAGE_ID					VARCHAR2(150),
	DIR_CARD_DEFINITION_NAME             			 VARCHAR2(150),
	EMPLOYEE_CLASSIFICATION					VARCHAR2(80),
	JOB_HOLDER_DATE							DATE,
	ENROLL_ASSESMENT						VARCHAR2(80),
	CLASSIFICATION_CHGPRC_DT				DATE,
	ACT_POSTPONEMENT_TYPE					VARCHAR2(80),
	ACT_POSTPONEMENT_RULE					VARCHAR2(80),
	ACT_POSTPONEMENT_END_DATE				DATE,
	ACT_QUALIFYING_SCHEME					VARCHAR2(80),
	QUALIFYING_SCHEME_JOIN_DT				DATE,
	QUALIFYING_SCHEME_START_DT				DATE,
	QUALIFYING_SCHEME_JOIN_METHOD			VARCHAR2(80),
	TRANSFER_QUALIFYING_SCHEME				VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_REASON			VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_DATE			DATE,
	OPT_OUT_PERIOD_END_DATE					DATE,
	OPT_OUT_REFUND_DUE						VARCHAR2(80),
	HISTORIC_PEN_PAY_ROLL_ID				VARCHAR2(150),
	REASON_FOR_EXCLUSION					VARCHAR2(80),
	COMPONENT_SEQUENCE						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(250),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	OVERRIDING_WORKER_POSTPONEMENT			VARCHAR2(150),
	OVERRIDING_ELIGIBLE_JH_POSTPMNT			VARCHAR2(150),
	OVERRIDING_QUALIFYING_SCHEME			VARCHAR2(150),
	OVERRIDING_STAGING_DATE					DATE,
	LETTER_STATUS							VARCHAR2(150),
	LETTER_TYPE_DATE						DATE,
	SUBSEQUENT_COMMS_REQ					VARCHAR2(150),
	LETTER_TYPE_GENERATED					VARCHAR2(150),
	WULS_TAKEN_DATE							DATE,
	TAX_PROTECTION_APPLIED					VARCHAR2(150),
	PROC_AUTO_REENROLMENT_DATE				DATE,
	HISTORIC_PEN_PAYROLL_ID					VARCHAR2(150),
	QUALIFYING_SCHEME_ID					NUMBER,
	CARD_SEQUENCE						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(60),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************************
-- ** PAE Component Association Detail Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_ASOC_DTL_PAE_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociationDetail',
	---
	DIR_CARD_COMP_ID						VARCHAR2(150),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(150),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	PAYROLL_RELATIONSHIP_NUM				VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT				VARCHAR2(250),
	DIR_REP_CARD_USAGE_ID					VARCHAR2(150),
	DIR_CARD_DEFINITION_NAME             			 VARCHAR2(150),
	EMPLOYEE_CLASSIFICATION					VARCHAR2(80),
	JOB_HOLDER_DATE							DATE,
	ENROLL_ASSESMENT						VARCHAR2(80),
	CLASSIFICATION_CHGPRC_DT				DATE,
	ACT_POSTPONEMENT_TYPE					VARCHAR2(80),
	ACT_POSTPONEMENT_RULE					VARCHAR2(80),
	ACT_POSTPONEMENT_END_DATE				DATE,
	ACT_QUALIFYING_SCHEME					VARCHAR2(80),
	QUALIFYING_SCHEME_JOIN_DT				DATE,
	QUALIFYING_SCHEME_START_DT				DATE,
	QUALIFYING_SCHEME_JOIN_METHOD			VARCHAR2(80),
	TRANSFER_QUALIFYING_SCHEME				VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_REASON			VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_DATE			DATE,
	OPT_OUT_PERIOD_END_DATE					DATE,
	OPT_OUT_REFUND_DUE						VARCHAR2(80),
	HISTORIC_PEN_PAY_ROLL_ID				VARCHAR2(150),
	REASON_FOR_EXCLUSION					VARCHAR2(80),
	COMPONENT_SEQUENCE						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(250),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	OVERRIDING_WORKER_POSTPONEMENT			VARCHAR2(150),
	OVERRIDING_ELIGIBLE_JH_POSTPMNT			VARCHAR2(150),
	OVERRIDING_QUALIFYING_SCHEME			VARCHAR2(150),
	OVERRIDING_STAGING_DATE					DATE,
	LETTER_STATUS							VARCHAR2(150),
	LETTER_TYPE_DATE						DATE,
	SUBSEQUENT_COMMS_REQ					VARCHAR2(150),
	LETTER_TYPE_GENERATED					VARCHAR2(150),
	WULS_TAKEN_DATE							DATE,
	TAX_PROTECTION_APPLIED					VARCHAR2(150),
	PROC_AUTO_REENROLMENT_DATE				DATE,
	HISTORIC_PEN_PAYROLL_ID					VARCHAR2(150),
	QUALIFYING_SCHEME_ID					NUMBER,
	CARD_SEQUENCE						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(60),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_PAE_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	DIR_CARD_COMP_ID						VARCHAR2(150),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(150),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	PAYROLL_RELATIONSHIP_NUM				VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT				VARCHAR2(250),
	DIR_REP_CARD_USAGE_ID					VARCHAR2(150),
	DIR_CARD_DEFINITION_NAME             			 VARCHAR2(150),
	EMPLOYEE_CLASSIFICATION					VARCHAR2(80),
	JOB_HOLDER_DATE							DATE,
	ENROLL_ASSESMENT						VARCHAR2(80),
	CLASSIFICATION_CHGPRC_DT				DATE,
	ACT_POSTPONEMENT_TYPE					VARCHAR2(80),
	ACT_POSTPONEMENT_RULE					VARCHAR2(80),
	ACT_POSTPONEMENT_END_DATE				DATE,
	ACT_QUALIFYING_SCHEME					VARCHAR2(80),
	QUALIFYING_SCHEME_JOIN_DT				DATE,
	QUALIFYING_SCHEME_START_DT				DATE,
	QUALIFYING_SCHEME_JOIN_METHOD			VARCHAR2(80),
	TRANSFER_QUALIFYING_SCHEME				VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_REASON			VARCHAR2(80),
	QUALIFYING_SCHEME_LEAVE_DATE			DATE,
	OPT_OUT_PERIOD_END_DATE					DATE,
	OPT_OUT_REFUND_DUE						VARCHAR2(80),
	HISTORIC_PEN_PAY_ROLL_ID				VARCHAR2(150),
	REASON_FOR_EXCLUSION					VARCHAR2(80),
	COMPONENT_SEQUENCE						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(250),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	OVERRIDING_WORKER_POSTPONEMENT			VARCHAR2(150),
	OVERRIDING_ELIGIBLE_JH_POSTPMNT			VARCHAR2(150),
	OVERRIDING_QUALIFYING_SCHEME			VARCHAR2(150),
	OVERRIDING_STAGING_DATE					DATE,
	LETTER_STATUS							VARCHAR2(150),
	LETTER_TYPE_DATE						DATE,
	SUBSEQUENT_COMMS_REQ					VARCHAR2(150),
	LETTER_TYPE_GENERATED					VARCHAR2(150),
	WULS_TAKEN_DATE							DATE,
	TAX_PROTECTION_APPLIED					VARCHAR2(150),
	PROC_AUTO_REENROLMENT_DATE				DATE,
	HISTORIC_PEN_PAYROLL_ID					VARCHAR2(150),
	QUALIFYING_SCHEME_ID					NUMBER,
	CARD_SEQUENCE						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(60),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );

-- ****************************
-- ** SD Calculation Card Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_SD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** SD Component Detail Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_SD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_SD_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );

--
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_ASSOC_SD_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_ASSOC_DTL_SD_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociationDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_ASSOC_DTL_SD_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociationDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );

CREATE TABLE XXMX_STG.XXMX_PAY_COMP_ASSOC_SD_STG
(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(80),
	DIR_INFORMATION_CATEGORY				VARCHAR2(80),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(2000),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	TAX_CODE								VARCHAR2(80),
	TAX_BASIS								VARCHAR2(80),
	PREVIOUS_TAXABLE_PAY					VARCHAR2(80),
	PREVIOUS_TAX_PAID						VARCHAR2(360),
	AUTHORITY 								VARCHAR2(20),
	AUTHORITY_DATE							DATE,
	PENSIONER								VARCHAR2(30),
	P45_ACTION								VARCHAR2(240),
	REPORT_NIYTD							VARCHAR2(700),
	EMPLOYMENT_FILED_HMRC					VARCHAR2(30),
	NUMBER_OF_PERIODS_CVD					VARCHAR2(30),
	PREV_HMRC_PAY_ROLL_ID					VARCHAR2(80),
	SEND_HMRC_PAYROLL_ID_CHG				VARCHAR2(300),
	HMRC_PAYROLL_ID_CHG_FILED				VARCHAR2(80),
	EXCLUDE_FROM_AL							VARCHAR2(80),
	DATE_LEFT_REPORTED_HMRC					VARCHAR2(80),
	CERTIFICATE								VARCHAR2(80),
	RENEWAL_DATE							DATE,
	NUMBER_OF_HRS_WORKED					NUMBER,
	P45_DATE_ISSUED							DATE,
	DATE_LEFT_FILED_PA						VARCHAR2(80),
	EMPLOYMENT_FILED_HMRC_PA				VARCHAR2(80),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	DIR_REP_CARD_USAGE_ID						VARCHAR2(150),
	CONTEXT1							VARCHAR2(150),
	CONTEXT2							VARCHAR2(150),
	PAYROLL_RELATIONSHIP_NUM					VARCHAR2(150),
	REPLACEMENTTAXREPORTINGUNIT					VARCHAR2(250),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );

--
-- ****************************
-- ** SL Calculation Card Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- **************************
-- ** SL Card Component Table
-- **************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** SL Card Association Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_ASOC_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** SL Component Detail Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *********************************
-- ** SL Component Association Table
-- *********************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_ASOC_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *********************************
-- ** SL EnterableCalculationValue Table
-- *********************************
CREATE TABLE XXMX_STG.XXMX_PAY_ENTER_VAL_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
        VALUEDEFINITIONNAME						VARCHAR2(200),
        VALUE1								VARCHAR2(200),
        VALUEDEFNID							VARCHAR2(200),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--

-- *********************************
-- ** SL CalculationValueDefinition Table
-- *********************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_VALDEF_SL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	TEACHER_REPAYMENT						VARCHAR2(150),
        VALUEDEFINITIONNAME						VARCHAR2(200),
        VALUE1								VARCHAR2(200),
        VALUEDEFNID							VARCHAR2(200),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** BP Calculation Card Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- **************************
-- ** BP Card Component Table
-- **************************
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** BP Card Association Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ***********************************
-- ** BP Card Association Detail Table
-- ***********************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_DTL_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociationDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** BP Component Detail Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ***************************************
-- ** BP Enterable Calculation Value Table
-- ***************************************
CREATE TABLE XXMX_STG.XXMX_PAY_ENTVAL_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'EnterableCalculationValue',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************************
-- ** BP Calculation Value Definition Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_VALDF_BP_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationValueDefinition',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(2000),
	DIR_CARD_ID								VARCHAR2(150),
	DIR_CARD_COMP_ID						VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(200),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** NSD Calculation Card Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ***************************
-- ** NSD Card Component Table
-- ***************************
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** NSD Card Association Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ************************************
-- ** NSD Card Association Detail Table
-- ************************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_DTL_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociationDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** NSD Component Detail Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************************
-- ** NSD Enterable Calculation Value Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_ENTVAL_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'EnterableCalculationValue',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************************
-- ** NSD Calculation Value Definition Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_VALDF_NSD_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationValueDefinition',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(200),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(200),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	VALUE_DEFINITION_NAME					VARCHAR2(200),
	SOURCE_ID								VARCHAR2(200),
	COMPONENT_SEQUENCE						VARCHAR2(20),
	DIR_CARD_ID								VARCHAR2(200),
	DIR_CARD_COMP_ID						VARCHAR2(200),
	MEMBER_OF_5050_SECTION					VARCHAR2(150),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(150),
	CARD_SEQUENCE							VARCHAR2(150),
	DIR_INFORMATION_CATEGORY				VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
	VALUE1									VARCHAR2(150),
	VALUE_DEFN_ID							VARCHAR2(150),
	NS_STATEMENT							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** PGL Calculation Card Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARDS_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationCard',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ***************************
-- ** PGL Card Component Table
-- ***************************
CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardComponent',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** PGL Card Association Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociation',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ************************************
-- ** PGL Card Association Detail Table
-- ************************************
CREATE TABLE XXMX_STG.XXMX_PAY_ASOC_DTL_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CardAssociationDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************
-- ** PGL Component Detail Table
-- *****************************
CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ComponentDetail',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************************
-- ** PGL Enterable Calculation Value Table
-- ****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_ENTVAL_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'EnterableCalculationValue',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *****************************************
-- ** PGL Calculation Value Definition Table
-- *****************************************
CREATE TABLE XXMX_STG.XXMX_PAY_CALC_VALDF_PGL_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'CalculationValueDefinition',
	---
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	DIR_CARD_DEFINITION_NAME				VARCHAR2(100),
	DIR_CARD_COMP_DEF_NAME					VARCHAR2(100),
	DIR_INFORMATION_CATEGORY				VARCHAR2(100),
	DIR_CARD_COMP_ID						VARCHAR2(240),
	TAX_REPORTING_UNIT_NAME					VARCHAR2(80),
	DIR_CARD_ID								VARCHAR2(120),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	PLAN_TYPE								VARCHAR2(60),
	START_DATE								DATE,
	START_DATE_NOTICE						VARCHAR2(80),
	SourceId							VARCHAR2(150),
	Context1							VARCHAR2(150),
	Context2							VARCHAR2(150),
	Context3							VARCHAR2(150),
	Context4							VARCHAR2(150),
	Context5							VARCHAR2(150),
	Context6							VARCHAR2(150),
	Subpriority							VARCHAR2(150),
	DisplaySequence							VARCHAR2(150),
	CARD_SEQUENCE 							VARCHAR2(150),
	PAYROLLRELATIONSHIPNUMBER 					VARCHAR2(150),	
	PAYROLLSTATUTORYUNITNAME					 VARCHAR2(150),
	PARENTCOMPONENTSEQUENCE 					VARCHAR2(2000),
	PARENTDIRCARDCOMPDEFNAME 					VARCHAR2(200) , 
	PARENTDIRCARDCOMPID 						VARCHAR2(150) ,
	COMPONENT_SEQUENCE  						VARCHAR2(2000),
	REPLACEMENTTAXREPORTINGUNIT  					VARCHAR2(150),
	DIR_REP_CARD_ID							VARCHAR2(150),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ****************************
-- ** Pay Balances Header Table
-- ****************************
CREATE TABLE XXMX_STG.XXMX_PAY_BALANCE_HEADERS_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'InitializeBalanceBatchHeader',
	---
	LEGISLATIVE_DATA_GROUP_NAME				NUMBER(18),
	BATCH									VARCHAR2(240),
	HEADER_UPLOAD_DATE						VARCHAR2(30),
	SOURCE_SYSTEM_ID						NUMBER(18),
	SOURCE_SYSTEM_OWNER						NUMBER(5),
	LINE_SEQUENCE							VARCHAR2(5),
	ASSIGNMENT_NUMBER						VARCHAR2(250),
	BALANCE_DATE							VARCHAR2(240),
	BALANCE_NAME							VARCHAR2(30),
	CONTEXT_ONE_NAME						NUMBER(18),
	CONTEXT_ONE_VALUE						NUMBER(18),
	CONTEXT_TWO_NAME						NUMBER(18),
	CONTEXT_TWO_VALUE						NUMBER(18),
	CONTEXT_THREE_NAME						NUMBER(18),
	CONTEXT_THREE_VALUE						NUMBER(18),
	CONTEXT_FOUR_NAME						VARCHAR2(30),
	CONTEXT_FOUR_VALUE						NUMBER(18),
	CONTEXT_FIVE_NAME						NUMBER,
	CONTEXT_FIVE_VALUE						NUMBER,
	CONTEXT_SIX_NAME						NUMBER,
	CONTEXT_SIX_VALUE						NUMBER,
	DIMENSION_NAME							NUMBER,
	LEGAL_EMPLOYER_NAME						NUMBER,
	TAX_UNIT_NAME							VARCHAR2(30),
	PAYROLL_NAME							NUMBER,
	PAYROLL_RELATIONSHIP_NUMBER				NUMBER,
	TERM_NUMBER								VARCHAR2(30),
	LINE_UPLOAD_DATE						VARCHAR2(30),
	VALUE									VARCHAR2(30),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- ***************************
-- ** PAY Balances Lines Table
-- ***************************
CREATE TABLE XXMX_STG.XXMX_PAY_BALANCE_LINES_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'InitializeBalanceBatchLine',
	---
	LEGISLATIVE_DATA_GROUP_NAME				NUMBER(18),
	BATCH									VARCHAR2(240),
	HEADER_UPLOAD_DATE						VARCHAR2(30),
	SOURCE_SYSTEM_ID						NUMBER(18),
	SOURCE_SYSTEM_OWNER						NUMBER(5),
	LINE_SEQUENCE							VARCHAR2(5),
	ASSIGNMENT_NUMBER						VARCHAR2(250),
	BALANCE_DATE							VARCHAR2(240),
	BALANCE_NAME							VARCHAR2(30),
	CONTEXT_ONE_NAME						NUMBER(18),
	CONTEXT_ONE_VALUE						NUMBER(18),
	CONTEXT_TWO_NAME						NUMBER(18),
	CONTEXT_TWO_VALUE						NUMBER(18),
	CONTEXT_THREE_NAME						NUMBER(18),
	CONTEXT_THREE_VALUE						NUMBER(18),
	CONTEXT_FOUR_NAME						VARCHAR2(30),
	CONTEXT_FOUR_VALUE						NUMBER(18),
	CONTEXT_FIVE_NAME						NUMBER,
	CONTEXT_FIVE_VALUE						NUMBER,
	CONTEXT_SIX_NAME						NUMBER,
	CONTEXT_SIX_VALUE						NUMBER,
	DIMENSION_NAME							NUMBER,
	LEGAL_EMPLOYER_NAME						NUMBER,
	TAX_UNIT_NAME							VARCHAR2(30),
	PAYROLL_NAME							NUMBER,
	PAYROLL_RELATIONSHIP_NUMBER				NUMBER,
	TERM_NUMBER								VARCHAR2(30),
	LINE_UPLOAD_DATE						VARCHAR2(30),
	VALUE									VARCHAR2(30),
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- *********************
-- ** PAY Elements Table
-- *********************
CREATE TABLE XXMX_STG.XXMX_PAY_ELEMENTS_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ElementEntry',
	---
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	ELEMENT_NAME							VARCHAR2(240),
	ENTRY_TYPE								VARCHAR2(80),
	MULTIPLE_ENTRY_COUNT					VARCHAR2(10),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	INPUT_VALUE_NAME						VARCHAR2(240),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SCREEN_ENTRY_VALUE						VARCHAR2(200),
	ELEMENT_TYPE_ID							NUMBER,
	LEGISLATIVE_DATA_GROUP_ID				NUMBER,
	HR_ASSIGNMENT_ID						NUMBER,
	ELEMENT_ENTRY_ID						NUMBER,
	REASON									VARCHAR2(240),
	SUB_PRIORITY							VARCHAR2(240),
	REPLACE_LAST_EFFECTIVE_END_DATE			DATE,
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );
--
--
-- **************************
-- ** PAY Element Entry Table
-- **************************
CREATE TABLE XXMX_STG.XXMX_PAY_ELEM_ENTRIES_STG
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID						NUMBER,
	MIGRATION_SET_NAME						VARCHAR2(150),
	MIGRATION_STATUS						VARCHAR2(50),
	BG_NAME									VARCHAR2(240),
	BG_ID									NUMBER(15),
	BATCH_NAME								VARCHAR2(300),
	METADATA								VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME								VARCHAR2(150) DEFAULT 'ElementEntryValue',
	---
	LEGISLATIVE_DATA_GROUP_NAME				VARCHAR2(240),
	ASSIGNMENT_NUMBER						VARCHAR2(80),
	ELEMENT_NAME							VARCHAR2(240),
	ENTRY_TYPE								VARCHAR2(80),
	MULTIPLE_ENTRY_COUNT					VARCHAR2(10),
	SOURCE_SYSTEM_OWNER						VARCHAR2(2000),
	SOURCE_SYSTEM_ID						VARCHAR2(2000),
	INPUT_VALUE_NAME						VARCHAR2(240),
	EFFECTIVE_START_DATE					DATE,
	EFFECTIVE_END_DATE						DATE,
	SCREEN_ENTRY_VALUE						VARCHAR2(200),
	ELEMENT_TYPE_ID							VARCHAR2(240),
	LEGISLATIVE_DATA_GROUP_ID				VARCHAR2(240),
	HR_ASSIGNMENT_ID						VARCHAR2(240),
	ELEMENT_ENTRY_ID						VARCHAR2(240),
	REASON									VARCHAR2(240),
	SUB_PRIORITY							VARCHAR2(240),
	REPLACE_LAST_EFFECTIVE_END_DATE			DATE,
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
	ATTRIBUTE16								VARCHAR2(150),
	ATTRIBUTE17								VARCHAR2(150),
	ATTRIBUTE18								VARCHAR2(150),
	ATTRIBUTE19								VARCHAR2(150),
	ATTRIBUTE20								VARCHAR2(150),
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
	ATTRIBUTE_NUMBER1						NUMBER(18),
	ATTRIBUTE_NUMBER2						NUMBER(18),
	ATTRIBUTE_NUMBER3						NUMBER(18),
	ATTRIBUTE_NUMBER4						NUMBER(18),
	ATTRIBUTE_NUMBER5						NUMBER(18),
	ATTRIBUTE_NUMBER6						NUMBER(18),
	ATTRIBUTE_NUMBER7						NUMBER(18),
	ATTRIBUTE_NUMBER8						NUMBER(18),
	ATTRIBUTE_NUMBER9						NUMBER(18),
	ATTRIBUTE_NUMBER10						NUMBER(18),
	ATTRIBUTE_TIMESTAMP1					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9					TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6)
    );


CREATE TABLE XXMX_STG.XXMX_PAY_CALC_CARD_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);



CREATE TABLE XXMX_STG.XXMX_PAY_CARD_COMP_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);

CREATE TABLE XXMX_STG.XXMX_PAY_COMP_DTL_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);

CREATE TABLE XXMX_STG.XXMX_PAY_CARD_ASSOC_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);

CREATE TABLE XXMX_STG.XXMX_PAY_ASSOC_DTL_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);

CREATE TABLE XXMX_STG.XXMX_PAY_ENTER_VAL_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
);

CREATE TABLE XXMX_STG.XXMX_PAY_CAL_VALDEF_CO_STG
(
FILE_SET_ID                    VARCHAR2(30)  , 
MIGRATION_SET_ID               NUMBER         ,
MIGRATION_SET_NAME             VARCHAR2(150)  ,
MIGRATION_STATUS               VARCHAR2(150)  ,
BG_NAME                        VARCHAR2(240)  ,
BG_ID                          NUMBER(15)     ,
METADATA                       VARCHAR2(20)   ,
OBJECTNAME                     VARCHAR2(200)  ,
EFFECTIVESTARTDATE             DATE           ,
EFFECTIVEENDDATE               DATE           ,
SOURCESYSTEMID                 VARCHAR2(2000) ,
SOURCESYSTEMOWNER              VARCHAR2(30)   ,
LEGISLATIVEDATAGROUPNAME       VARCHAR2(240)  ,
DIRCARDDEFINITIONNAME          VARCHAR2(80)   ,
DIRCARDCOMPDEFNAME             VARCHAR2(80)   ,
DIRINFORMATIONCATEGORY         VARCHAR2(80)   ,
DIRCARDCOMPID                  VARCHAR2(240)  ,
TAXREPORTINGUNITNAME           VARCHAR2(240)  ,
DIRCARDID                      VARCHAR2(120)  ,
ASSIGNMENTNUMBER               VARCHAR2(50)   ,
UNDERPAYMENTREASON             VARCHAR2(120)  ,
FREQUENCY                      VARCHAR2(120)  ,
DATEOFISSUE                    DATE           ,
DATEOFRECEIPT                  DATE           ,
ISSUINGAUTHORITY               VARCHAR2(120)  ,
PAYEEFORORDERAMOUNT            VARCHAR2(120)  ,
CALCULATIONTYPE                VARCHAR2(120)  ,
PRIMARYEARNINGSPAYROLL         VARCHAR2(120)  ,
VALUEDEFINITIONNAME            VARCHAR2(120)  ,
SOURCEID                       VARCHAR2(200)  ,
VALUE1                         VARCHAR2(150)  ,
VALUEDEFNID                    VARCHAR2(150)  ,
PARENTDIRCARDCOMPID            VARCHAR2(240)  ,
CONTEXT1                       VARCHAR2(240)  ,
THIRDPARTYPAYEE                VARCHAR2(240)  ,
REPORTING_REFERENCE            VARCHAR2(240),
ATTRIBUTE_CATEGORY             VARCHAR2(240) , 
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
ATTRIBUTE11                    VARCHAR2(150)  ,
ATTRIBUTE12                    VARCHAR2(150)  ,
ATTRIBUTE13                    VARCHAR2(150)  ,
ATTRIBUTE14                    VARCHAR2(150)  ,
ATTRIBUTE15                    VARCHAR2(150)  
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

--
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_PAE_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_PAE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_PAE_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_PAE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_ASOC_PAE_STG FOR XXMX_STG.XXMX_PAY_COMP_ASOC_PAE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_ASOC_DTL_PAE_STG FOR XXMX_STG.XXMX_PAY_COMP_ASOC_DTL_PAE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_SD_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_SD_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_SL_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_SL_STG FOR XXMX_STG.XXMX_PAY_COMP_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_ASOC_SL_STG FOR XXMX_STG.XXMX_PAY_CARD_ASOC_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_SL_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_ASOC_SL_STG FOR XXMX_STG.XXMX_PAY_COMP_ASOC_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_BP_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_BP_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_BP_STG FOR XXMX_STG.XXMX_PAY_ASOC_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_DTL_BP_STG FOR XXMX_STG.XXMX_PAY_ASOC_DTL_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_BP_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ENTVAL_BP_STG FOR XXMX_STG.XXMX_PAY_ENTVAL_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_VALDF_BP_STG FOR XXMX_STG.XXMX_PAY_CALC_VALDF_BP_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_NSD_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_NSD_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_NSD_STG FOR XXMX_STG.XXMX_PAY_ASOC_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_DTL_NSD_STG FOR XXMX_STG.XXMX_PAY_ASOC_DTL_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_NSD_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ENTVAL_NSD_STG FOR XXMX_STG.XXMX_PAY_ENTVAL_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_VALDF_NSD_STG FOR XXMX_STG.XXMX_PAY_CALC_VALDF_NSD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARDS_PGL_STG FOR XXMX_STG.XXMX_PAY_CALC_CARDS_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_PGL_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_PGL_STG FOR XXMX_STG.XXMX_PAY_ASOC_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASOC_DTL_PGL_STG FOR XXMX_STG.XXMX_PAY_ASOC_DTL_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_PGL_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ENTVAL_PGL_STG FOR XXMX_STG.XXMX_PAY_ENTVAL_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_VALDF_PGL_STG FOR XXMX_STG.XXMX_PAY_CALC_VALDF_PGL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_BALANCE_HEADERS_STG FOR XXMX_STG.XXMX_PAY_BALANCE_HEADERS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_BALANCE_LINES_STG FOR XXMX_STG.XXMX_PAY_BALANCE_LINES_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ELEMENTS_STG FOR XXMX_STG.XXMX_PAY_ELEMENTS_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ELEM_ENTRIES_STG FOR XXMX_STG.XXMX_PAY_ELEM_ENTRIES_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_SD_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_ASSOC_SD_STG FOR XXMX_STG.XXMX_PAY_CARD_ASSOC_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_ASSOC_DTL_SD_STG FOR XXMX_STG.XXMX_PAY_CARD_ASSOC_DTL_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_ASSOC_DTL_SD_STG FOR XXMX_STG.XXMX_PAY_COMP_ASSOC_DTL_SD_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_ASSOC_SD_STG FOR XXMX_STG.XXMX_PAY_COMP_ASSOC_SD_STG ;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_PAE_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_PAE_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_CARD_CO_STG FOR XXMX_STG.XXMX_PAY_CALC_CARD_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_COMP_CO_STG FOR XXMX_STG.XXMX_PAY_CARD_COMP_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_COMP_DTL_CO_STG FOR XXMX_STG.XXMX_PAY_COMP_DTL_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CARD_ASSOC_CO_STG FOR XXMX_STG.XXMX_PAY_CARD_ASSOC_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ASSOC_DTL_CO_STG FOR XXMX_STG.XXMX_PAY_ASSOC_DTL_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ENTER_VAL_CO_STG FOR XXMX_STG.XXMX_PAY_ENTER_VAL_CO_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CAL_VALDEF_CO_STG FOR XXMX_STG.XXMX_PAY_CAL_VALDEF_CO_STG;

CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_ENTER_VAL_SL_STG FOR XXMX_STG.XXMX_PAY_ENTER_VAL_SL_STG;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_PAY_CALC_VALDEF_SL_STG FOR XXMX_STG.XXMX_PAY_CALC_VALDEF_SL_STG;
--
--

--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
--
	 
--
--
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_PAE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_PAE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_ASOC_PAE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_ASOC_DTL_PAE_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_SL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_SL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_ASOC_SL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_SL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_ASOC_SL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_DTL_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ENTVAL_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_VALDF_BP_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_DTL_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ENTVAL_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_VALDF_NSD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARDS_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASOC_DTL_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ENTVAL_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_VALDF_PGL_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_BALANCE_HEADERS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_BALANCE_LINES_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ELEMENTS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ELEM_ENTRIES_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_ASSOC_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_ASSOC_DTL_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_ASSOC_DTL_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_ASSOC_SD_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_PAE_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CAL_VALDEF_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ENTER_VAL_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ASSOC_DTL_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_ASSOC_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_COMP_DTL_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CARD_COMP_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_CARD_CO_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_ENTER_VAL_SL_STG to XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_PAY_CALC_VALDEF_SL_STG to XXMX_CORE;
--
--

--
--
PROMPT
PROMPT
PROMPT ****************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge Payroll Data Migration
PROMPT **                                
PROMPT ****************************************************************************
PROMPT
PROMPT
--
--