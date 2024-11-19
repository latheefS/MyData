--*****************************************************************************
--**
--**                 		   Copyright (c) 2024 Version 1
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
--** FILENAME  :  xxmx_scm_po_val_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Meenakshi Rajendran
--**
--** PURPOSE   :  This script installs the XXMX_VAL DB Objects for the Cloudbridge
--**              Purchase Orders Data Validation.
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
--**   Vsn  Change Date  Changed By          		Change Description
--** -----  -----------  ------------------  		----------------------------
--**   1.0  21-DEC-2023  Meenakshi Rajendran  	 	Created Purchase Orders VAL 
--**                                         		tables for Cloudbridge. 
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
PROMPT ******************************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Cloudbridge Purchase Orders Data Validation
PROMPT **
PROMPT ******************************************************************************
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
EXEC DropTable ('XXMX_SCM_PO_HEADERS_STD_VAL')
EXEC DropTable ('XXMX_SCM_PO_LINES_STD_VAL')
EXEC DropTable ('XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL')
EXEC DropTable ('XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL')
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_HEADERS_STD_VAL
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- **********************************
-- ** STD PO Headers Validation Table
-- **********************************
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_HEADER_KEY         VARCHAR2(50),
    ACTION                       VARCHAR2(25),
    BATCH_ID                     NUMBER,
    INTERFACE_SOURCE_CODE        VARCHAR2(25),
    APPROVAL_ACTION              VARCHAR2(25),
    DOCUMENT_NUM                 VARCHAR2(30),
    DOCUMENT_TYPE_CODE           VARCHAR2(25),
    STYLE_DISPLAY_NAME           VARCHAR2(240),
    PRC_BU_NAME                  VARCHAR2(240),
    REQ_BU_NAME                  VARCHAR2(240),
    SOLDTO_LE_NAME               VARCHAR2(240),
    BILLTO_BU_NAME               VARCHAR2(240),
    AGENT_NAME                   VARCHAR2(2000),
    CURRENCY_CODE                VARCHAR2(15),
    RATE                         NUMBER,
    RATE_TYPE                    VARCHAR2(30),
    RATE_DATE                    DATE,
    COMMENTS                     VARCHAR2(240),
    BILL_TO_LOCATION             VARCHAR2(60),
    SHIP_TO_LOCATION             VARCHAR2(60),
    VENDOR_NAME                  VARCHAR2(360),
    VENDOR_NUM                   VARCHAR2(30),
    VENDOR_SITE_CODE             VARCHAR2(15),
    VENDOR_CONTACT               VARCHAR2(360),
    VENDOR_DOC_NUM               VARCHAR2(25),
    FOB                          VARCHAR2(30),
    FREIGHT_CARRIER              VARCHAR2(360),
    FREIGHT_TERMS                VARCHAR2(30),
    PAY_ON_CODE                  VARCHAR2(25),
    PAYMENT_TERMS                VARCHAR2(50),
    ORIGINATOR_ROLE              VARCHAR2(25),
    CHANGE_ORDER_DESC            VARCHAR2(2000),
    ACCEPTANCE_REQUIRED_FLAG     VARCHAR2(1),
    ACCEPTANCE_WITHIN_DAYS       NUMBER,
    SUPPLIER_NOTIF_METHOD        VARCHAR2(25),
    FAX                          VARCHAR2(60),
    EMAIL_ADDRESS                VARCHAR2(2000),
    CONFIRMING_ORDER_FLAG        VARCHAR2(1),
    NOTE_TO_VENDOR               VARCHAR2(1000),
    NOTE_TO_RECEIVER             VARCHAR2(1000),
    DEFAULT_TAXATION_COUNTRY     VARCHAR2(2),
    TAX_DOCUMENT_SUBTYPE         VARCHAR2(240),
    AGENT_EMAIL_ADDRESS          VARCHAR2(240),
    PO_HEADER_ID                 VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINES_STD_VAL
PROMPT
--
-- ********************************
-- ** STD PO Lines Validation Table
-- ********************************
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_LINE_KEY           VARCHAR2(50),
    INTERFACE_HEADER_KEY         VARCHAR2(50),
    ACTION                       VARCHAR2(25),
    LINE_NUM                     NUMBER,
    LINE_TYPE                    VARCHAR2(30),
    ITEM                         VARCHAR2(300),
    ITEM_DESCRIPTION             VARCHAR2(240),
    ITEM_REVISION                VARCHAR2(18),
    CATEGORY                     VARCHAR2(2000),
    AMOUNT                       NUMBER,
    QUANTITY                     NUMBER,
    UNIT_OF_MEASURE              VARCHAR2(25),
    UNIT_PRICE                   NUMBER,
    SECONDARY_QUANTITY           NUMBER,
    SECONDARY_UNIT_OF_MEASURE    VARCHAR2(18),
    VENDOR_PRODUCT_NUM           VARCHAR2(25),
    NEGOTIATED_BY_PREPARER_FLAG  VARCHAR2(1),
    HAZARD_CLASS                 VARCHAR2(40),
    UN_NUMBER                    VARCHAR2(25),
    NOTE_TO_VENDOR               VARCHAR2(1000),
    NOTE_TO_RECEIVER             VARCHAR2(1000),
    UNIT_WEIGHT                  NUMBER,
    WEIGHT_UOM_CODE              VARCHAR2(3),
    WEIGHT_UNIT_OF_MEASURE       VARCHAR2(25),
    UNIT_VOLUME                  NUMBER,
    VOLUME_UOM_CODE              VARCHAR2(3),
    VOLUME_UNIT_OF_MEASURE       VARCHAR2(25),
    TEMPLATE_NAME                VARCHAR2(30),
    SOURCE_AGREEMENT_PRC_BU_NAME VARCHAR2(240),
    SOURCE_AGREEMENT             VARCHAR2(30),
    SOURCE_AGREEMENT_LINE        NUMBER,
    DISCOUNT_TYPE                VARCHAR2(25),
    DISCOUNT                     NUMBER,
    DISCOUNT_REASON              VARCHAR2(240),
    MAX_RETAINAGE_AMOUNT         NUMBER,
    PO_HEADER_ID                 VARCHAR2(30),
    PO_LINE_ID                   VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
   );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL
PROMPT
--
-- *****************************************
-- ** STD PO Line Locations Validation Table
-- *****************************************
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL
   (VALIDATION_ERROR_MESSAGE       VARCHAR2(3000),
    FILE_SET_ID                    VARCHAR2(30),
    MIGRATION_SET_ID               NUMBER,
    MIGRATION_SET_NAME             VARCHAR2(100),
    MIGRATION_STATUS               VARCHAR2(50),
    INTERFACE_LINE_LOCATION_KEY    VARCHAR2(50),
    INTERFACE_LINE_KEY             VARCHAR2(50),
    SHIPMENT_NUM                   NUMBER,
    SHIP_TO_LOCATION               VARCHAR2(60),
    SHIP_TO_ORGANIZATION_CODE      VARCHAR2(18),
    AMOUNT                         NUMBER,
    QUANTITY                       NUMBER,
    NEED_BY_DATE                   DATE,
    PROMISED_DATE                  DATE,
    SECONDARY_QUANTITY             NUMBER,
    SECONDARY_UNIT_OF_MEASURE      VARCHAR2(18),
    DESTINATION_TYPE_CODE          VARCHAR2(25),
    ACCRUE_ON_RECEIPT_FLAG         VARCHAR2(1),
    ALLOW_SUBSTITUTE_RECEIPTS_FLAG VARCHAR2(1),
    ASSESSABLE_VALUE               NUMBER,
    DAYS_EARLY_RECEIPT_ALLOWED     NUMBER,
    DAYS_LATE_RECEIPT_ALLOWED      NUMBER,
    ENFORCE_SHIP_TO_LOCATION_CODE  VARCHAR2(25),
    INSPECTION_REQUIRED_FLAG       VARCHAR2(1),
    RECEIPT_REQUIRED_FLAG          VARCHAR2(1),
    INVOICE_CLOSE_TOLERANCE        NUMBER,
    RECEIPT_CLOSE_TOLERANCE        NUMBER,
    QTY_RCV_TOLERANCE              NUMBER,
    QTY_RCV_EXCEPTION_CODE         VARCHAR2(25),
    RECEIPT_DAYS_EXCEPTION_CODE    VARCHAR2(25),
    RECEIVING_ROUTING              VARCHAR2(30),
    NOTE_TO_RECEIVER               VARCHAR2(1000),
    INPUT_TAX_CLASSIFICATION_CODE  VARCHAR2(30),
    LINE_INTENDED_USE              VARCHAR2(240),
    PRODUCT_CATEGORY               VARCHAR2(240),
    PRODUCT_FISC_CLASSIFICATION    VARCHAR2(240),
    PRODUCT_TYPE                   VARCHAR2(240),
    TRX_BUSINESS_CATEGORY_CODE     VARCHAR2(240),
    USER_DEFINED_FISC_CLASS        VARCHAR2(30),
    FREIGHT_CARRIER                VARCHAR2(360),
    MODE_OF_TRANSPORT              VARCHAR2(80),
    SERVICE_LEVEL                  VARCHAR2(80),
    FINAL_DISCHARGE_LOCATION_CODE  VARCHAR2(60),
    REQUESTED_SHIP_DATE            DATE,
    PROMISED_SHIP_DATE             DATE,
    REQUESTED_DELIVERY_DATE        DATE,
    PROMISED_DELIVERY_DATE         DATE,
    RETAINAGE_RATE                 NUMBER,
    INVOICE_MATCH_OPTION           VARCHAR2(25),
    PO_HEADER_ID                   VARCHAR2(30),
    PO_LINE_ID                     VARCHAR2(30),
    LINE_LOCATION_ID               VARCHAR2(30),
    LOAD_BATCH                     VARCHAR2(300)
   );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL
PROMPT
--
-- ****************************************
-- ** STD PO Distributions Validation Table
-- ****************************************
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL
   (VALIDATION_ERROR_MESSAGE     VARCHAR2(3000),
    FILE_SET_ID                  VARCHAR2(30),
    MIGRATION_SET_ID             NUMBER,
    MIGRATION_SET_NAME           VARCHAR2(100),
    MIGRATION_STATUS             VARCHAR2(50),
    INTERFACE_DISTRIBUTION_KEY   VARCHAR2(50),
    INTERFACE_LINE_LOCATION_KEY  VARCHAR2(50),
    DISTRIBUTION_NUM             NUMBER,
    DELIVER_TO_LOCATION          VARCHAR2(60),
    DELIVER_TO_PERSON_FULL_NAME  VARCHAR2(2000),
    DESTINATION_SUBINVENTORY     VARCHAR2(10),
    AMOUNT_ORDERED               NUMBER,
    QUANTITY_ORDERED             NUMBER,
    CHARGE_ACCOUNT_SEGMENT1      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT2      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT3      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT4      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT5      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT6      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT7      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT8      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT9      VARCHAR2(25),
    CHARGE_ACCOUNT_SEGMENT10     VARCHAR2(25),
    DESTINATION_CONTEXT          VARCHAR2(30),
    PROJECT                      VARCHAR2(240),
    TASK                         VARCHAR2(100),
    PJC_EXPENDITURE_ITEM_DATE    DATE,
    EXPENDITURE_TYPE             VARCHAR2(240),
    EXPENDITURE_ORGANIZATION     VARCHAR2(240),
    PJC_BILLABLE_FLAG            VARCHAR2(1),
    PJC_CAPITALIZABLE_FLAG       VARCHAR2(1),
    PJC_WORK_TYPE                VARCHAR2(240),
    RATE                         NUMBER,
    RATE_DATE                    DATE,
    DELIVER_TO_PERSON_EMAIL_ADDR VARCHAR2(240),
    BUDGET_DATE                  DATE,
    PJC_CONTRACT_NUMBER          VARCHAR2(120),
    PJC_FUNDING_SOURCE           VARCHAR2(360),
    PO_HEADER_ID                 VARCHAR2(30),
    PO_LINE_ID                   VARCHAR2(30),
    LINE_LOCATION_ID             VARCHAR2(30),
    PO_DISTRIBUTION_ID           VARCHAR2(30),
    LOAD_BATCH                   VARCHAR2(300)
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
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL FOR XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL FOR XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL FOR XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL FOR XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL;
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
GRANT ALL ON XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_VAL TO XXMX_CORE;
GRANT ALL ON XXMX_CORE.XXMX_SCM_PO_LINES_STD_VAL TO XXMX_CORE;
GRANT ALL ON XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_VAL TO XXMX_CORE;
GRANT ALL ON XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_VAL TO XXMX_CORE;
--
--

--
--
PROMPT
PROMPT
PROMPT ****************************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge Purchase Orders Data Validation
PROMPT **                                
PROMPT ****************************************************************************************
PROMPT
PROMPT
--
--