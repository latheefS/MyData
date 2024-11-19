--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1,
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_fa_massadd_stg_dbi.sql
--**
--** FILEPATH  :  $XXMX_TOP/install/sql
--**
--** VERSION   :  1.2
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              Fixed Assets Data Migration.
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
--**            $XXMX_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
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
--**  1.0  08-JAN-2021  Ian S. Vickerstaff  Created for Maximise. 
--**  
--**  1.1  20-JAN-2021  Ian S. Vickerstaff  Grants added. 
--**  
--**  1.2  14-JUL-2021  Ian S. Vickerstaff  Header comment updates. 
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
--

PROMPT
PROMPT
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise FA Data Migration
PROMPT **
PROMPT *************************************************************
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
PROMPT Dropping Table xxmx_fa_mass_additions_stg
PROMPT
--
DROP TABLE xxmx_stg.xxmx_fa_mass_additions_stg;
--
PROMPT
PROMPT Dropping Table xxmx_fa_mass_addition_dist_stg
PROMPT
--
DROP TABLE xxmx_stg.xxmx_fa_mass_addition_dist_stg;
--
--
PROMPT
PROMPT Dropping Table xxmx_fa_mass_rates_stg
PROMPT
--
DROP TABLE xxmx_stg.xxmx_fa_mass_rates_stg;
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_fa_mass_additions_stg
PROMPT
--
/*
** CREATE TABLE: xxmx_fa_mass_additions_stg
*/
--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--
CREATE TABLE xxmx_stg.xxmx_fa_mass_additions_stg 
   ( 
      FILE_SET_ID   VARCHAR2(20),	
      MIGRATION_SET_ID NUMBER,
      MIGRATION_SET_NAME VARCHAR2(100), 
      MIGRATION_STATUS VARCHAR2(50), 
      OPERATING_UNIT VARCHAR2(240), 
      LEDGER_NAME VARCHAR2(30), 
      MASS_ADDITION_ID NUMBER(18,0), 
      ASSET_CATEGORY_ID NUMBER(18,0), 
      PREPARER_ID NUMBER(18,0), 
      CREATE_BATCH_ID NUMBER(18,0), 
      CASH_GENERATING_UNIT_ID NUMBER(18,0), 
      PO_VENDOR_ID NUMBER(18,0), 
      INVOICE_ID NUMBER(18,0), 
      PARENT_MASS_ADDITION_ID NUMBER(18,0), 
      PARENT_ASSET_ID NUMBER(18,0), 
      AP_DISTRIBUTION_LINE_NUMBER NUMBER(18,0), 
      POST_BATCH_ID NUMBER(18,0), 
      ADD_TO_ASSET_ID NUMBER(18,0), 
      ASSET_KEY_CCID NUMBER(18,0), 
      LOAD_REQUEST_ID NUMBER(18,0), 
      MERGE_PARENT_MASS_ADDITIONS_ID NUMBER(18,0), 
      SPLIT_PARENT_MASS_ADDITIONS_ID NUMBER(18,0), 
      PROJECT_ASSET_LINE_ID NUMBER(18,0), 
      PROJECT_ID NUMBER(18,0), 
      TASK_ID NUMBER(18,0), 
      ASSET_ID NUMBER(18,0), 
      INVOICE_DISTRIBUTION_ID NUMBER(18,0), 
      PO_DISTRIBUTION_ID NUMBER(18,0), 
      REQUEST_ID NUMBER(18,0), 
      WORKER_ID NUMBER(18,0), 
      PROCESS_ORDER NUMBER(18,0), 
      INVOICE_PAYMENT_ID NUMBER(18,0), 
      OBJECT_VERSION_NUMBER NUMBER(9,0), 
      METHOD_ID NUMBER(18,0), 
      FLAT_RATE_ID NUMBER(18,0), 
      CONVENTION_TYPE_ID NUMBER(18,0), 
      BONUS_RULE_ID NUMBER(18,0), 
      CEILING_TYPE_ID NUMBER(18,0), 
      PRIOR_METHOD_ID NUMBER(18,0), 
      PRIOR_FLAT_RATE_ID NUMBER(18,0), 
      WARRANTY_ID NUMBER(18,0), 
      ITC_AMOUNT_ID NUMBER(18,0), 
      LEASE_ID NUMBER(18,0), 
      LESSOR_ID NUMBER(18,0), 
      PERIOD_COUNTER_FULLY_RESERVED NUMBER(18,0), 
      PERIOD_COUNTER_EXTENDED NUMBER(18,0), 
      PROJECT_ORGANIZATION_ID NUMBER(18,0), 
      TASK_ORGANIZATION_ID NUMBER(18,0), 
      EXPENDITURE_ORGANIZATION_ID NUMBER(18,0), 
      PROJECT_TXN_DOC_ENTRY_ID NUMBER(18,0), 
      EXPENDITURE_TYPE_ID NUMBER(18,0), 
      LEASE_SCHEDULE_ID NUMBER(18,0), 
      SHIP_TO_CUST_LOCATION_ID NUMBER(18,0), 
      SHIP_TO_LOCATION_ID NUMBER(18,0), 
      INTERFACE_LINE_NUM NUMBER,
      BOOK_TYPE_CODE VARCHAR2(30),
      TRANSACTION_NAME VARCHAR2(240), 
      ASSET_NUMBER VARCHAR2(30), 
      DESCRIPTION VARCHAR2(80), 
      TAG_NUMBER VARCHAR2(15), 
      MANUFACTURER_NAME VARCHAR2(360), 
      SERIAL_NUMBER VARCHAR2(35), 
      MODEL_NUMBER VARCHAR2(40), 
      ASSET_TYPE VARCHAR2(11), 
      FIXED_ASSETS_COST NUMBER, 
      DATE_PLACED_IN_SERVICE DATE, 
      PRORATE_CONVENTION_CODE VARCHAR2(10), 
      FIXED_ASSETS_UNITS NUMBER, 
      CATEGORY_SEGMENT1 VARCHAR2(30), 
      CATEGORY_SEGMENT2 VARCHAR2(30), 
      CATEGORY_SEGMENT3 VARCHAR2(30), 
      CATEGORY_SEGMENT4 VARCHAR2(30), 
      CATEGORY_SEGMENT5 VARCHAR2(30), 
      CATEGORY_SEGMENT6 VARCHAR2(30), 
      CATEGORY_SEGMENT7 VARCHAR2(30),
      POSTING_STATUS VARCHAR2(15), 
      QUEUE_NAME VARCHAR2(30), 
      FEEDER_SYSTEM_NAME VARCHAR2(40), 
      PARENT_ASSET_NUMBER VARCHAR2(30), 
      ADD_TO_ASSET_NUMBER VARCHAR2(30), 
      ASSET_KEY_SEGMENT1 VARCHAR2(30), 
      ASSET_KEY_SEGMENT2 VARCHAR2(30), 
      ASSET_KEY_SEGMENT3 VARCHAR2(30), 
      ASSET_KEY_SEGMENT4 VARCHAR2(30), 
      ASSET_KEY_SEGMENT5 VARCHAR2(30), 
      ASSET_KEY_SEGMENT6 VARCHAR2(30), 
      ASSET_KEY_SEGMENT7 VARCHAR2(30), 
      ASSET_KEY_SEGMENT8 VARCHAR2(30), 
      ASSET_KEY_SEGMENT9 VARCHAR2(30), 
      ASSET_KEY_SEGMENT10 VARCHAR2(30), 
      INVENTORIAL VARCHAR2(3), 
      PROPERTY_TYPE_CODE VARCHAR2(30),
      PROPERTY_1245_1250_CODE VARCHAR2(4), 
      IN_USE_FLAG VARCHAR2(3), 
      OWNED_LEASED VARCHAR2(15),
      NEW_USED VARCHAR2(4), 
      MATERIAL_INDICATOR_FLAG VARCHAR2(1), 
      COMMITMENT VARCHAR2(30), 
      INVESTMENT_LAW VARCHAR2(30), 
      AMORTIZE_FLAG VARCHAR2(3), 
      AMORTIZATION_START_DATE DATE, 
      DEPRECIATE_FLAG VARCHAR2(3), 
      SALVAGE_TYPE VARCHAR2(30), 
      SALVAGE_VALUE NUMBER,
      PERCENT_SALVAGE_VALUE NUMBER, 
      YTD_DEPRN NUMBER, 
      DEPRN_RESERVE NUMBER,
      BONUS_YTD_DEPRN NUMBER, 
      BONUS_DEPRN_RESERVE NUMBER,	
      YTD_IMPAIRMENT NUMBER, 
      IMPAIRMENT_RESERVE NUMBER, 
      METHOD_CODE VARCHAR2(12), 
      LIFE_IN_MONTHS NUMBER(4,0), 
      BASIC_RATE NUMBER, 
      ADJUSTED_RATE NUMBER, 
      UNIT_OF_MEASURE VARCHAR2(25), 
      PRODUCTION_CAPACITY NUMBER, 
      CEILING_NAME VARCHAR2(30), 
      BONUS_RULE VARCHAR2(30), 
      CASH_GENERATING_UNIT VARCHAR2(30), 
      DEPRN_LIMIT_TYPE VARCHAR2(30), 
      ALLOWED_DEPRN_LIMIT NUMBER, 
      ALLOWED_DEPRN_LIMIT_AMOUNT NUMBER, 
      PAYABLES_COST NUMBER,
      PAYABLES_CODE_COMBINATION_ID NUMBER(18,0), 
      CLEARING_ACCT_SEGMENT1 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT2 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT3 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT4 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT5 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT6 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT7 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT8 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT9 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT10 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT11 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT12 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT13 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT14 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT15 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT16 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT17 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT18 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT19 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT20 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT21 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT22 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT23 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT24 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT25 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT26 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT27 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT28 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT29 VARCHAR2(25), 
      CLEARING_ACCT_SEGMENT30 VARCHAR2(25), 
      ATTRIBUTE1 VARCHAR2(150), 
      ATTRIBUTE2 VARCHAR2(150), 
      ATTRIBUTE3 VARCHAR2(150), 
      ATTRIBUTE4 VARCHAR2(150), 
      ATTRIBUTE5 VARCHAR2(150), 
      ATTRIBUTE6 VARCHAR2(150), 
      ATTRIBUTE7 VARCHAR2(150), 
      ATTRIBUTE8 VARCHAR2(150), 
      ATTRIBUTE9 VARCHAR2(150), 
      ATTRIBUTE10 VARCHAR2(150), 
      ATTRIBUTE11 VARCHAR2(150), 
      ATTRIBUTE12 VARCHAR2(150), 
      ATTRIBUTE13 VARCHAR2(150), 
      ATTRIBUTE14 VARCHAR2(150), 
      ATTRIBUTE15 VARCHAR2(150), 
      ATTRIBUTE16 VARCHAR2(150), 
      ATTRIBUTE17 VARCHAR2(150), 
      ATTRIBUTE18 VARCHAR2(150), 
      ATTRIBUTE19 VARCHAR2(150), 
      ATTRIBUTE20 VARCHAR2(150), 
      ATTRIBUTE21 VARCHAR2(150), 
      ATTRIBUTE22 VARCHAR2(150), 
      ATTRIBUTE23 VARCHAR2(150), 
      ATTRIBUTE24 VARCHAR2(150), 
      ATTRIBUTE25 VARCHAR2(150), 
      ATTRIBUTE26 VARCHAR2(150), 
      ATTRIBUTE27 VARCHAR2(150), 
      ATTRIBUTE28 VARCHAR2(150), 
      ATTRIBUTE29 VARCHAR2(150), 
      ATTRIBUTE30 VARCHAR2(150), 
      ATTRIBUTE_NUMBER1 NUMBER, 
      ATTRIBUTE_NUMBER2 NUMBER, 
      ATTRIBUTE_NUMBER3 NUMBER, 
      ATTRIBUTE_NUMBER4 NUMBER, 
      ATTRIBUTE_NUMBER5 NUMBER, 
      ATTRIBUTE_DATE1 DATE, 
      ATTRIBUTE_DATE2 DATE, 
      ATTRIBUTE_DATE3 DATE, 
      ATTRIBUTE_DATE4 DATE, 
      ATTRIBUTE_DATE5 DATE, 
      ATTRIBUTE_CATEGORY_CODE VARCHAR2(30), 
      CONTEXT VARCHAR2(250), 
      TH_ATTRIBUTE1 VARCHAR2(150), 
      TH_ATTRIBUTE2 VARCHAR2(150), 
      TH_ATTRIBUTE3 VARCHAR2(150), 
      TH_ATTRIBUTE4 VARCHAR2(150), 
      TH_ATTRIBUTE5 VARCHAR2(150), 
      TH_ATTRIBUTE6 VARCHAR2(150), 
      TH_ATTRIBUTE7 VARCHAR2(150), 
      TH_ATTRIBUTE8 VARCHAR2(150), 
      TH_ATTRIBUTE9 VARCHAR2(150), 
      TH_ATTRIBUTE10 VARCHAR2(150), 
      TH_ATTRIBUTE11 VARCHAR2(150), 
      TH_ATTRIBUTE12 VARCHAR2(150), 
      TH_ATTRIBUTE13 VARCHAR2(150), 
      TH_ATTRIBUTE14 VARCHAR2(150), 
      TH_ATTRIBUTE15 VARCHAR2(150), 
      TH_ATTRIBUTE_NUMBER1 NUMBER, 
      TH_ATTRIBUTE_NUMBER2 NUMBER, 
      TH_ATTRIBUTE_NUMBER3 NUMBER, 
      TH_ATTRIBUTE_NUMBER4 NUMBER, 
      TH_ATTRIBUTE_NUMBER5 NUMBER, 
      TH_ATTRIBUTE_DATE1 DATE, 
      TH_ATTRIBUTE_DATE2 DATE, 
      TH_ATTRIBUTE_DATE3 DATE, 
      TH_ATTRIBUTE_DATE4 DATE, 
      TH_ATTRIBUTE_DATE5 DATE, 
      TH_ATTRIBUTE_CATEGORY_CODE VARCHAR2(30), 
      TH2_ATTRIBUTE1 VARCHAR2(150), 
      TH2_ATTRIBUTE2 VARCHAR2(150), 
      TH2_ATTRIBUTE3 VARCHAR2(150), 
      TH2_ATTRIBUTE4 VARCHAR2(150), 
      TH2_ATTRIBUTE5 VARCHAR2(150), 
      TH2_ATTRIBUTE6 VARCHAR2(150), 
      TH2_ATTRIBUTE7 VARCHAR2(150), 
      TH2_ATTRIBUTE8 VARCHAR2(150), 
      TH2_ATTRIBUTE9 VARCHAR2(150), 
      TH2_ATTRIBUTE10 VARCHAR2(150), 
      TH2_ATTRIBUTE11 VARCHAR2(150), 
      TH2_ATTRIBUTE12 VARCHAR2(150), 
      TH2_ATTRIBUTE13 VARCHAR2(150), 
      TH2_ATTRIBUTE14 VARCHAR2(150), 
      TH2_ATTRIBUTE15 VARCHAR2(150), 
      TH2_ATTRIBUTE_NUMBER1 NUMBER, 
      TH2_ATTRIBUTE_NUMBER2 NUMBER, 
      TH2_ATTRIBUTE_NUMBER3 NUMBER, 
      TH2_ATTRIBUTE_NUMBER4 NUMBER, 
      TH2_ATTRIBUTE_NUMBER5 NUMBER, 
      TH2_ATTRIBUTE_DATE1 DATE, 
      TH2_ATTRIBUTE_DATE2 DATE, 
      TH2_ATTRIBUTE_DATE3 DATE, 
      TH2_ATTRIBUTE_DATE4 DATE, 
      TH2_ATTRIBUTE_DATE5 DATE, 
      TH2_ATTRIBUTE_CATEGORY_CODE VARCHAR2(30), 
      AI_ATTRIBUTE1 VARCHAR2(150), 
      AI_ATTRIBUTE2 VARCHAR2(150), 
      AI_ATTRIBUTE3 VARCHAR2(150), 
      AI_ATTRIBUTE4 VARCHAR2(150), 
      AI_ATTRIBUTE5 VARCHAR2(150), 
      AI_ATTRIBUTE6 VARCHAR2(150), 
      AI_ATTRIBUTE7 VARCHAR2(150), 
      AI_ATTRIBUTE8 VARCHAR2(150), 
      AI_ATTRIBUTE9 VARCHAR2(150), 
      AI_ATTRIBUTE10 VARCHAR2(150), 
      AI_ATTRIBUTE11 VARCHAR2(150), 
      AI_ATTRIBUTE12 VARCHAR2(150), 
      AI_ATTRIBUTE13 VARCHAR2(150), 
      AI_ATTRIBUTE14 VARCHAR2(150), 
      AI_ATTRIBUTE15 VARCHAR2(150),
      AI_ATTRIBUTE_NUMBER1 NUMBER, 
      AI_ATTRIBUTE_NUMBER2 NUMBER, 
      AI_ATTRIBUTE_NUMBER3 NUMBER, 
      AI_ATTRIBUTE_NUMBER4 NUMBER, 
      AI_ATTRIBUTE_NUMBER5 NUMBER, 
      AI_ATTRIBUTE_DATE1 DATE, 
      AI_ATTRIBUTE_DATE2 DATE, 
      AI_ATTRIBUTE_DATE3 DATE, 
      AI_ATTRIBUTE_DATE4 DATE, 
      AI_ATTRIBUTE_DATE5 DATE, 
      AI_ATTRIBUTE_CATEGORY_CODE VARCHAR2(30), 
      MASS_PROPERTY_FLAG VARCHAR2(1),
      GROUP_ASSET_NUMBER VARCHAR2(30), 
      REDUCTION_RATE NUMBER, 
      REDUCE_ADDITION_FLAG VARCHAR2(1),
      REDUCE_ADJUSTMENT_FLAG VARCHAR2(1), 
      REDUCE_RETIREMENT_FLAG VARCHAR2(1), 
      RECOGNIZE_GAIN_LOSS VARCHAR2(30),
      RECAPTURE_RESERVE_FLAG VARCHAR2(1), 
      LIMIT_PROCEEDS_FLAG VARCHAR2(1), 
      TERMINAL_GAIN_LOSS VARCHAR2(30), 
      TRACKING_METHOD VARCHAR2(30), 
      EXCESS_ALLOCATION_OPTION VARCHAR2(30), 
      DEPRECIATION_OPTION VARCHAR2(30), 
      MEMBER_ROLLUP_FLAG VARCHAR2(1), 
      ALLOCATE_TO_FULLY_RSV_FLAG VARCHAR2(1), 
      OVER_DEPRECIATE_OPTION VARCHAR2(30), 
      PREPARER_EMAIL_ADDRESS VARCHAR2(240), 
      MERGED_CODE VARCHAR2(3), 
      PARENT_INT_LINE_NUM NUMBER,
      SUM_UNITS VARCHAR2(3), 
      NEW_MASTER_FLAG VARCHAR2(3), 
      UNITS_TO_ADJUST NUMBER(18,0), 
      SHORT_FISCAL_YEAR_FLAG VARCHAR2(3), 
      CONVERSION_DATE DATE, 
      ORIGINAL_DEPRN_START_DATE DATE, 
      GLOBAL_ATTRIBUTE1 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE2 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE3 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE4 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE5 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE6 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE7 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE8 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE9 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE10 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE11 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE12 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE13 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE14 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE15 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE16 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE17 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE18 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE19 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE20 VARCHAR2(150), 
      GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
      GLOBAL_ATTRIBUTE_DATE1 DATE, 
      GLOBAL_ATTRIBUTE_DATE2 DATE, 
      GLOBAL_ATTRIBUTE_DATE3 DATE, 
      GLOBAL_ATTRIBUTE_DATE4 DATE, 
      GLOBAL_ATTRIBUTE_DATE5 DATE,
      GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30), 
      NBV_AT_SWITCH NUMBER, 
      PERIOD_NAME_FULLY_RESERVED VARCHAR2(15), 
      PERIOD_NAME_EXTENDED VARCHAR2(15), 
      PRIOR_DEPRN_LIMIT_TYPE VARCHAR2(30), 
      PRIOR_DEPRN_LIMIT NUMBER, 
      PRIOR_DEPRN_LIMIT_AMOUNT NUMBER, 
      PRIOR_METHOD_CODE VARCHAR2(12), 
      PRIOR_LIFE_IN_MONTHS NUMBER(18,0), 
      PRIOR_BASIC_RATE NUMBER,
      PRIOR_ADJUSTED_RATE NUMBER, 
      ASSET_SCHEDULE_NUM NUMBER(18,0), 
      LEASE_NUMBER VARCHAR2(30), 
      REVAL_RESERVE NUMBER, 
      REVAL_LOSS_BALANCE NUMBER, 
      REVAL_AMORTIZATION_BASIS NUMBER, 
      IMPAIR_LOSS_BALANCE NUMBER, 
      REVAL_CEILING NUMBER, 
      FAIR_MARKET_VALUE NUMBER, 
      LAST_PRICE_INDEX_VALUE NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER6 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER7 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER8 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER9 NUMBER, 
      GLOBAL_ATTRIBUTE_NUMBER10 NUMBER, 
      GLOBAL_ATTRIBUTE_DATE6 DATE, 
      GLOBAL_ATTRIBUTE_DATE7 DATE, 
      GLOBAL_ATTRIBUTE_DATE8 DATE, 
      GLOBAL_ATTRIBUTE_DATE9 DATE, 
      GLOBAL_ATTRIBUTE_DATE10 DATE, 
      BK_GLOBAL_ATTRIBUTE1 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE2 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE3 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE4 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE5 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE6 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE7 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE8 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE9 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE10 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE11 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE12 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE13 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE14 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE15 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE16 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE17 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE18 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE19 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE20 VARCHAR2(150), 
      BK_GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
      BK_GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
      BK_GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
      BK_GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
      BK_GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
      BK_GLOBAL_ATTRIBUTE_DATE1 DATE, 
      BK_GLOBAL_ATTRIBUTE_DATE2 DATE, 
      BK_GLOBAL_ATTRIBUTE_DATE3 DATE, 
      BK_GLOBAL_ATTRIBUTE_DATE4 DATE, 
      BK_GLOBAL_ATTRIBUTE_DATE5 DATE, 
      BK_GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30), 
      TH_GLOBAL_ATTRIBUTE1 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE2 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE3 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE4 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE5 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE6 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE7 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE8 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE9 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE10 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE11 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE12 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE13 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE14 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE15 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE16 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE17 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE18 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE19 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE20 VARCHAR2(150), 
      TH_GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
      TH_GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
      TH_GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
      TH_GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
      TH_GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
      TH_GLOBAL_ATTRIBUTE_DATE1 DATE, 
      TH_GLOBAL_ATTRIBUTE_DATE2 DATE, 
      TH_GLOBAL_ATTRIBUTE_DATE3 DATE, 
      TH_GLOBAL_ATTRIBUTE_DATE4 DATE, 
      TH_GLOBAL_ATTRIBUTE_DATE5 DATE, 
      TH_GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30), 
      AI_GLOBAL_ATTRIBUTE1 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE2 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE3 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE4 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE5 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE6 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE7 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE8 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE9 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE10 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE11 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE12 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE13 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE14 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE15 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE16 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE17 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE18 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE19 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE20 VARCHAR2(150), 
      AI_GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
      AI_GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
      AI_GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
      AI_GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
      AI_GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
      AI_GLOBAL_ATTRIBUTE_DATE1 DATE, 
      AI_GLOBAL_ATTRIBUTE_DATE2 DATE, 
      AI_GLOBAL_ATTRIBUTE_DATE3 DATE, 
      AI_GLOBAL_ATTRIBUTE_DATE4 DATE, 
      AI_GLOBAL_ATTRIBUTE_DATE5 DATE, 
      AI_GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30),
      VENDOR_NAME VARCHAR2(360), 
      VENDOR_NUMBER VARCHAR2(30), 
      PO_NUMBER VARCHAR2(30), 
      INVOICE_NUMBER VARCHAR2(50), 
      INVOICE_VOUCHER_NUMBER VARCHAR2(50), 
      INVOICE_DATE DATE,
      PAYABLES_UNITS NUMBER,
      INVOICE_LINE_NUMBER NUMBER, 
      INVOICE_LINE_TYPE VARCHAR2(30), 
      INVOICE_LINE_DESCRIPTION VARCHAR2(240), 
      INVOICE_PAYMENT_NUMBER NUMBER(18,0),
      PROJECT_NUMBER VARCHAR2(25), 
      PROJECT_TASK_NUMBER VARCHAR2(100), 
      FULLY_RESERVE_ON_ADD_FLAG VARCHAR2(1), 
      DEPRN_ADJUSTMENT_FACTOR NUMBER, 
      REVALUED_COST NUMBER, 
      BACKLOG_DEPRN_RESERVE NUMBER, 
      YTD_BACKLOG_DEPRN NUMBER, 
      REVAL_AMORT_BALANCE NUMBER, 
      YTD_REVAL_AMORTIZATION NUMBER, 
      ADJUSTED_COST NUMBER, 
      LAST_UPDATED_BY VARCHAR2(64), 
      REVIEWER_COMMENTS VARCHAR2(60), 
      INVOICE_CREATED_BY VARCHAR2(64), 
      INVOICE_UPDATED_BY VARCHAR2(64), 
      PAYABLES_BATCH_NAME VARCHAR2(50), 	
      SPLIT_MERGED_CODE VARCHAR2(3),	
      SPLIT_CODE VARCHAR2(3), 	
      DIST_NAME VARCHAR2(25), 	
      CREATED_BY VARCHAR2(64), 
      LAST_UPDATE_LOGIN VARCHAR2(32), 	
      MERGE_INVOICE_NUMBER VARCHAR2(50), 
      MERGE_VENDOR_NUMBER VARCHAR2(30), 	
      PREPARER_NAME VARCHAR2(240), 
      PREPARER_NUMBER VARCHAR2(30), 	
      PERIOD_FULL_RESERVE VARCHAR2(30), 
      PERIOD_EXTD_DEPRN VARCHAR2(30), 	
      WARRANTY_NUMBER VARCHAR2(15), 	
      ATTACHMENT_FLAG VARCHAR2(1), 
      ERROR_MSG VARCHAR2(2000), 
      LOW_VALUE_ASSET_FLAG VARCHAR2(1), 
      CREATE_EXPENSED_ASSET_FLAG VARCHAR2(1), 
      CAP_THRESHOLD_CHECK_FLAG VARCHAR2(1), 	
      LINE_TYPE_LOOKUP_CODE VARCHAR2(25), 	
      INTANGIBLE_ASSET_FLAG VARCHAR2(1), 	
      CREATE_BATCH_DATE DATE, 	
      LAST_UPDATE_DATE TIMESTAMP (6), 	
      CREATION_DATE TIMESTAMP (6), 	 
      ACCOUNTING_DATE DATE, 	
      GROUP_ASSET_ID NUMBER, 
      YTD_REVAL_DEPRN_EXPENSE NUMBER, 
      UNREVALUED_COST NUMBER, 
      FULLY_RSVD_REVALS_COUNTER NUMBER, 
      DEPRN_EXPENSE_SEGMENT6 VARCHAR2(25)
);
    
--
PROMPT
PROMPT Creating Table xxmx_fa_mass_addition_dist_stg
PROMPT
--
/*
** CREATE TABLE: xxmx_fa_mass_addition_dist_stg
*/
--
CREATE TABLE  xxmx_stg.xxmx_fa_mass_addition_dist_stg 
   ( 
    FILE_SET_ID   VARCHAR2(20),	
    MIGRATION_SET_ID NUMBER,
	MIGRATION_SET_NAME VARCHAR2(100), 
	MIGRATION_STATUS VARCHAR2(50), 
	OPERATING_UNIT VARCHAR2(240), 
	LEDGER_NAME VARCHAR2(30), 
	MASSADD_DIST_ID NUMBER, 
	MASS_ADDITION_ID NUMBER, 
   INTERFACE_LINE_NUM NUMBER,
	UNITS NUMBER, 
   EMPLOYEE_EMAIL_ADDRESS VARCHAR2(240), 
   LOCATION_SEGMENT1 VARCHAR2(30), 
	LOCATION_SEGMENT2 VARCHAR2(30), 
	LOCATION_SEGMENT3 VARCHAR2(30), 
	LOCATION_SEGMENT4 VARCHAR2(30), 
	LOCATION_SEGMENT5 VARCHAR2(30), 
	LOCATION_SEGMENT6 VARCHAR2(30), 
	LOCATION_SEGMENT7 VARCHAR2(30), 
	DEPRN_EXPENSE_CCID NUMBER, 
	LOCATION_ID NUMBER, 
	EMPLOYEE_ID NUMBER, 
	LOAD_REQUEST_ID NUMBER(18,0), 
	CREATION_DATE TIMESTAMP (6), 
	CREATED_BY VARCHAR2(64), 
	LAST_UPDATE_DATE TIMESTAMP (6), 
	LAST_UPDATED_BY VARCHAR2(64), 
	LAST_UPDATE_LOGIN VARCHAR2(32), 
	OBJECT_VERSION_NUMBER NUMBER(9,0), 
	DEPRN_EXPENSE_SEGMENT1 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT2 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT3 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT4 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT5 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT6 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT7 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT8 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT9 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT10 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT11 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT12 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT13 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT14 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT15 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT16 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT17 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT18 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT19 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT20 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT21 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT22 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT23 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT24 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT25 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT26 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT27 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT28 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT29 VARCHAR2(25), 
	DEPRN_EXPENSE_SEGMENT30 VARCHAR2(25), 
	DEPRN_SOURCE_CODE VARCHAR2(300)
   );
--
PROMPT
PROMPT Creating Table xxmx_fa_mass_rates_stg
PROMPT
--
/*
** CREATE TABLE: xxmx_fa_mass_rates_stg
*/
--
CREATE TABLE  xxmx_stg.xxmx_fa_mass_rates_stg 
    (
    FILE_SET_ID   VARCHAR2(20),	
    MIGRATION_SET_ID NUMBER,
	MIGRATION_SET_NAME VARCHAR2(100), 
	MIGRATION_STATUS VARCHAR2(50), 
	OPERATING_UNIT VARCHAR2(240), 
	LEDGER_NAME VARCHAR2(30), 
	SET_OF_BOOKS_ID NUMBER(18,0), 
   INTERFACE_LINE_NUM NUMBER,
	MASS_ADDITION_ID NUMBER(18,0), 
	PARENT_MASS_ADDITION_ID NUMBER(18,0), 
   CURRENCY_CODE VARCHAR2(15),
	FIXED_ASSETS_COST NUMBER, 
	EXCHANGE_RATE NUMBER, 
	LOAD_REQUEST_ID NUMBER(18,0), 
	CREATED_BY VARCHAR2(64), 
	CREATION_DATE TIMESTAMP (6), 
	LAST_UPDATED_BY VARCHAR2(64), 
	LAST_UPDATE_DATE TIMESTAMP (6), 
	LAST_UPDATE_LOGIN VARCHAR2(32), 
	OBJECT_VERSION_NUMBER NUMBER(9,0)
   );

--
PROMPT ***********************
PROMPT **Provide Grants
PROMPT ***********************
--
GRANT ALL ON xxmx_stg.xxmx_fa_mass_additions_stg TO xxmx_core;
--
GRANT ALL ON xxmx_stg.xxmx_fa_mass_addition_dist_stg TO xxmx_core;
--
GRANT ALL ON xxmx_stg.xxmx_fa_mass_rates_stg TO xxmx_core;
--
--
PROMPT ***********************
PROMPT **Synonym Creations
PROMPT *********************** 
--

Create or replace public synonym xxmx_fa_mass_rates_stg FOR xxmx_stg.xxmx_fa_mass_rates_stg;
Create or replace public synonym xxmx_fa_mass_addition_dist_stg FOR xxmx_stg.xxmx_fa_mass_addition_dist_stg;
Create or replace public synonym xxmx_fa_mass_additions_stg FOR xxmx_stg.xxmx_fa_mass_additions_stg;
--
--
PROMPT
PROMPT ***********************************************************************
PROMPT **
PROMPT Completed ** Installing Database Objects for Maximise FA Data Migration
PROMPT **
PROMPT ***********************************************************************
PROMPT 