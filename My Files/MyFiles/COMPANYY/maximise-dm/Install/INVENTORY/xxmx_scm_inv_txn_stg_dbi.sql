--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
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
--** FILENAME  :  xxmx_scm_inv_txn_stg_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Sinchana Ramesh
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the CloudBridge
--**              Inventory Transaction Data Migration.
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
--**   1.0  19-JUL-2024  Sinchana Ramesh     Created Inventory Transaction STG tables for CloudBridge.
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
PROMPT ******************************************************************
PROMPT **
PROMPT ** Installing Database Objects for CloudBridge INV TXN Data Migration
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
PROMPT Dropping Table XXMX_SCM_INV_TXNS_STG
PROMPT
--
DROP TABLE XXMX_SCM_INV_TXNS_STG;
--
PROMPT
PROMPT Dropping Table XXMX_SCM_INV_TXN_LOTS_STG
PROMPT
--
DROP TABLE XXMX_SCM_INV_TXN_LOTS_STG;
--
PROMPT
PROMPT Dropping Table XXMX_SCM_INV_SER_NUMS_STG
PROMPT
--
DROP TABLE XXMX_SCM_INV_SER_NUMS_STG;
--
PROMPT
PROMPT Dropping Table XXMX_SCM_INV_TXN_COSTS_STG
PROMPT
--
DROP TABLE XXMX_SCM_INV_TXN_COSTS_STG;
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_INV_TXNS_STG
PROMPT

--Migration_set_id is generated in the CloudBridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--

-- ******************************
-- **Inventory Transactions Table
-- ******************************
CREATE TABLE XXMX_STG.XXMX_SCM_INV_TXNS_STG
    (
    FILE_SET_ID                                 VARCHAR2(30),
    MIGRATION_SET_ID                            NUMBER,
    MIGRATION_SET_NAME                          VARCHAR2(100),
    MIGRATION_STATUS                            VARCHAR2(50),
    ORGANIZATION_NAME                           VARCHAR2(240),
    TRANSACTION_GROUP_ID                        NUMBER,
    TRANSACTION_GROUP_SEQ                       NUMBER,
    TRANSACTION_BATCH_ID                        NUMBER,
    TRANSACTION_BATCH_SEQ                       NUMBER,
    PROCESS_FLAG                                VARCHAR2(30),
    INVENTORY_ITEM                              VARCHAR2(2000),
    ITEM_NUMBER                                 VARCHAR2(300),
    REVISION                                    VARCHAR2(30),
    INV_LOTSERIAL_INTERFACE_NUM                 VARCHAR2(30),
    SUBINVENTORY_CODE                           VARCHAR2(10),
    LOCATOR_NAME                                VARCHAR2(2000),
    LOC_SEGMENT1                                VARCHAR2(40),
    LOC_SEGMENT2                                VARCHAR2(40),
    LOC_SEGMENT3                                VARCHAR2(40),
    LOC_SEGMENT4                                VARCHAR2(40),
    LOC_SEGMENT5                                VARCHAR2(40),                               
    LOC_SEGMENT6                                VARCHAR2(40),
    LOC_SEGMENT7                                VARCHAR2(40),
    LOC_SEGMENT8                                VARCHAR2(40),
    LOC_SEGMENT9                                VARCHAR2(40),
    LOC_SEGMENT10                               VARCHAR2(40),
    LOC_SEGMENT11                               VARCHAR2(40),
    LOC_SEGMENT12                               VARCHAR2(40),
    LOC_SEGMENT13                               VARCHAR2(40),
    LOC_SEGMENT14                               VARCHAR2(40),
    LOC_SEGMENT15                               VARCHAR2(40),
    LOC_SEGMENT16                               VARCHAR2(40),
    LOC_SEGMENT17                               VARCHAR2(40),
    LOC_SEGMENT18                               VARCHAR2(40),
    LOC_SEGMENT19                               VARCHAR2(40),
    LOC_SEGMENT20                               VARCHAR2(40),
    TRANSACTION_QUANTITY                        NUMBER,
    TRANSACTION_UOM                             VARCHAR2(3),
    TRANSACTION_UNIT_OF_MEASURE                 VARCHAR2(25),
    RESERVATION_QUANTITY                        NUMBER,
    TRANSACTION_DATE                            DATE,
    TRANSACTION_SOURCE_TYPE_NAME                VARCHAR2(30),
    TRANSACTION_TYPE_NAME                       VARCHAR2(80),
    TRANSFER_ORGANIZATION_TYPE                  VARCHAR2(30),
    TRANSFER_ORGANIZATION_NAME                  VARCHAR2(240),
    TRANSFER_SUBINVENTORY                       VARCHAR2(10),
    XFER_LOC_SEGMENT1                           VARCHAR2(40),
    XFER_LOC_SEGMENT2                           VARCHAR2(40),
    XFER_LOC_SEGMENT3                           VARCHAR2(40),
    XFER_LOC_SEGMENT4                           VARCHAR2(40),
    XFER_LOC_SEGMENT5                           VARCHAR2(40),
    XFER_LOC_SEGMENT6                           VARCHAR2(40),
    XFER_LOC_SEGMENT7                           VARCHAR2(40),
    XFER_LOC_SEGMENT8                           VARCHAR2(40),
    XFER_LOC_SEGMENT9                           VARCHAR2(40),
    XFER_LOC_SEGMENT10                          VARCHAR2(40),
    XFER_LOC_SEGMENT11                          VARCHAR2(40),
    XFER_LOC_SEGMENT12                          VARCHAR2(40),
    XFER_LOC_SEGMENT13                          VARCHAR2(40),
    XFER_LOC_SEGMENT14                          VARCHAR2(40),
    XFER_LOC_SEGMENT15                          VARCHAR2(40),
    XFER_LOC_SEGMENT16                          VARCHAR2(40),
    XFER_LOC_SEGMENT17                          VARCHAR2(40),
    XFER_LOC_SEGMENT18                          VARCHAR2(40),
    XFER_LOC_SEGMENT19                          VARCHAR2(40),
    XFER_LOC_SEGMENT20                          VARCHAR2(40),
    PRIMARY_QUANTITY                            NUMBER,
    SECONDARY_TRANSACTION_QUANTITY              NUMBER,
    SECONDARY_UOM_CODE                          VARCHAR2(3),
    SECONDARY_UNIT_OF_MEASURE                   VARCHAR2(25),
    SOURCE_CODE                                 VARCHAR2(30),
    SOURCE_HEADER_ID                            NUMBER,
    SOURCE_LINE_ID                              NUMBER,
    TRANSACTION_SOURCE_NAME                     VARCHAR2(120),
    DSP_SEGMENT1                                VARCHAR2(40),
    DSP_SEGMENT2                                VARCHAR2(40),
    DSP_SEGMENT3                                VARCHAR2(40),
    DSP_SEGMENT4                                VARCHAR2(40),
    DSP_SEGMENT5                                VARCHAR2(40),
    DSP_SEGMENT6                                VARCHAR2(40),
    DSP_SEGMENT7                                VARCHAR2(40),
    DSP_SEGMENT8                                VARCHAR2(40),
    DSP_SEGMENT9                                VARCHAR2(40),
    DSP_SEGMENT10                               VARCHAR2(40),
    DSP_SEGMENT11                               VARCHAR2(40),
    DSP_SEGMENT12                               VARCHAR2(40),
    DSP_SEGMENT13                               VARCHAR2(40),
    DSP_SEGMENT14                               VARCHAR2(40),
    DSP_SEGMENT15                               VARCHAR2(40),
    DSP_SEGMENT16                               VARCHAR2(40),
    DSP_SEGMENT17                               VARCHAR2(40),
    DSP_SEGMENT18                               VARCHAR2(40),
    DSP_SEGMENT19                               VARCHAR2(40),
    DSP_SEGMENT20                               VARCHAR2(40),
    DSP_SEGMENT21                               VARCHAR2(40),
    DSP_SEGMENT22                               VARCHAR2(40),
    DSP_SEGMENT23                               VARCHAR2(40),
    DSP_SEGMENT24                               VARCHAR2(40),
    DSP_SEGMENT25                               VARCHAR2(40),
    DSP_SEGMENT26                               VARCHAR2(40),
    DSP_SEGMENT27                               VARCHAR2(40),
    DSP_SEGMENT28                               VARCHAR2(40),
    DSP_SEGMENT29                               VARCHAR2(40),
    DSP_SEGMENT30                               VARCHAR2(40),
    TRANSACTION_ACTION_NAME                     VARCHAR2(80),
    TRANSACTION_MODE                            VARCHAR2(30),
    LOCK_FLAG                                   VARCHAR2(30),
    TRANSACTION_REFERENCE                       VARCHAR2(240),
    REASON_NAME                                 VARCHAR2(80),
    CURRENCY_NAME                               VARCHAR2(80),
    CURRENCY_CODE                               VARCHAR2(30),
    CURRENCY_CONVERSION_TYPE                    VARCHAR2(30),
    CURRENCY_CONVERSION_RATE                    NUMBER,
    CURRENCY_CONVERSION_DATE                    DATE,
    TRANSACTION_COST                            NUMBER,
    TRANSFER_COST                               NUMBER,
    NEW_AVERAGE_COST                            NUMBER,
    VALUE_CHANGE                                NUMBER,
    PERCENTAGE_CHANGE                           NUMBER,
    DST_SEGMENT1                                VARCHAR2(25),
    DST_SEGMENT2                                VARCHAR2(25),
    DST_SEGMENT3                                VARCHAR2(25),
    DST_SEGMENT4                                VARCHAR2(25),
    DST_SEGMENT5                                VARCHAR2(25),
    DST_SEGMENT6                                VARCHAR2(25),
    DST_SEGMENT7                                VARCHAR2(25),
    DST_SEGMENT8                                VARCHAR2(25),
    DST_SEGMENT9                                VARCHAR2(25),
    DST_SEGMENT10                               VARCHAR2(25),
    DST_SEGMENT11                               VARCHAR2(25),
    DST_SEGMENT12                               VARCHAR2(25),
    DST_SEGMENT13                               VARCHAR2(25),
    DST_SEGMENT14                               VARCHAR2(25),
    DST_SEGMENT15                               VARCHAR2(25),
    DST_SEGMENT16                               VARCHAR2(25),
    DST_SEGMENT17                               VARCHAR2(25),
    DST_SEGMENT18                               VARCHAR2(25),
    DST_SEGMENT19                               VARCHAR2(25),
    DST_SEGMENT20                               VARCHAR2(25),
    DST_SEGMENT21                               VARCHAR2(25),
    DST_SEGMENT22                               VARCHAR2(25),
    DST_SEGMENT23                               VARCHAR2(25),
    DST_SEGMENT24                               VARCHAR2(25),
    DST_SEGMENT25                               VARCHAR2(25),
    DST_SEGMENT26                               VARCHAR2(25),
    DST_SEGMENT27                               VARCHAR2(25),
    DST_SEGMENT28                               VARCHAR2(25),
    DST_SEGMENT29                               VARCHAR2(25),
    DST_SEGMENT30                               VARCHAR2(25),
    LOCATION_TYPE                               VARCHAR2(30),
    EMPLOYEE_CODE                               VARCHAR2(10),
    RECEIVING_DOCUMENT                          VARCHAR2(10),
    LINE_ITEM_NUM                               NUMBER,
    SHIPMENT_NUMBER                             VARCHAR2(30),
    TRANSPORTATION_COST                         NUMBER,
    CONTAINERS                                  NUMBER,
    WAYBILL_AIRBILL                             VARCHAR2(20),
    EXPECTED_ARRIVAL_DATE                       DATE,
    REQUIRED_FLAG                               VARCHAR2(1),
    SHIPPABLE_FLAG                              VARCHAR2(1),
    SHIPPED_QUANTITY                            NUMBER,
    VALIDATION_REQUIRED                         NUMBER,
    NEGATIVE_REQ_FLAG                           NUMBER,
    OWNING_TP_TYPE                              VARCHAR2(30),
    TRANSFER_OWNING_TP_TYPE                     VARCHAR2(30),
    OWNING_ORGANIZATION_NAME                    VARCHAR2(240),
    XFR_OWNING_ORGANIZATION_NAME                VARCHAR2(240),
    TRANSFER_PERCENTAGE                         NUMBER,
    PLANNING_TP_TYPE                            VARCHAR2(30),
    TRANSFER_PLANNING_TP_TYPE                   VARCHAR2(30),
    ROUTING_REVISION                            VARCHAR2(3),
    ROUTING_REVISION_DATE                       DATE,
    ALTERNATE_BOM_DESIGNATOR                    VARCHAR2(10),
    ALTERNATE_ROUTING_DESIGNATOR                VARCHAR2(10),
    ORGANIZATION_TYPE                           VARCHAR2(30),
    USSGL_TRANSACTION_CODE                      VARCHAR2(30),
    WIP_ENTITY_TYPE                             NUMBER,
    SCHEDULE_UPDATE_CODE                        NUMBER,
    SETUP_TEARDOWN_CODE                         NUMBER,
    PRIMARY_SWITCH                              NUMBER,
    MRP_CODE                                    NUMBER,
    OPERATION_SEQ_NUM                           NUMBER,
    WIP_SUPPLY_TYPE                             NUMBER,
    RELIEVE_RESERVATIONS_FLAG                   VARCHAR2(1),
    RELIEVE_HIGH_LEVEL_RSV_FLAG                 VARCHAR2(1),
    TRANSFER_PRICE                              NUMBER,
    BUILD_BREAK_TO_UOM                          VARCHAR2(3),
    BUILD_BREAK_TO_UNIT_OF_MEASURE              VARCHAR2(25),
    ATTRIBUTE_CATEGORY                          VARCHAR2(30),
    ATTRIBUTE1                                  VARCHAR2(150),
    ATTRIBUTE2                                  VARCHAR2(150),
    ATTRIBUTE3                                  VARCHAR2(150),
    ATTRIBUTE4                                  VARCHAR2(150),
    ATTRIBUTE5                                  VARCHAR2(150),
    ATTRIBUTE6                                  VARCHAR2(150),
    ATTRIBUTE7                                  VARCHAR2(150),
    ATTRIBUTE8                                  VARCHAR2(150),
    ATTRIBUTE9                                  VARCHAR2(150),
    ATTRIBUTE10                                 VARCHAR2(150),
    ATTRIBUTE11                                 VARCHAR2(150),
    ATTRIBUTE12                                 VARCHAR2(150),
    ATTRIBUTE13                                 VARCHAR2(150),
    ATTRIBUTE14                                 VARCHAR2(150),
    ATTRIBUTE15                                 VARCHAR2(150),
    ATTRIBUTE16                                 VARCHAR2(150),
    ATTRIBUTE17                                 VARCHAR2(150),
    ATTRIBUTE18                                 VARCHAR2(150),
    ATTRIBUTE19                                 VARCHAR2(150),
    ATTRIBUTE20                                 VARCHAR2(150),
    ATTRIBUTE_NUMBER1                           NUMBER,
    ATTRIBUTE_NUMBER2                           NUMBER,
    ATTRIBUTE_NUMBER3                           NUMBER,
    ATTRIBUTE_NUMBER4                           NUMBER,
    ATTRIBUTE_NUMBER5                           NUMBER,
    ATTRIBUTE_NUMBER6                           NUMBER,
    ATTRIBUTE_NUMBER7                           NUMBER,
    ATTRIBUTE_NUMBER8                           NUMBER,
    ATTRIBUTE_NUMBER9                           NUMBER,
    ATTRIBUTE_NUMBER10                          NUMBER,
    ATTRIBUTE_DATE1                             DATE,
    ATTRIBUTE_DATE2                             DATE,
    ATTRIBUTE_DATE3                             DATE,
    ATTRIBUTE_DATE4                             DATE,
    ATTRIBUTE_DATE5                             DATE,
    ATTRIBUTE_TIMESTAMP1                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5                        TIMESTAMP,
    TRANSACTION_COST_IDENTIFIER                 VARCHAR2(100),
    DEFAULT_TAXATION_COUNTRY                    VARCHAR2(2),
    DOCUMENT_SUB_TYPE                           VARCHAR2(240),
    TRX_BUSINESS_CATEGORY                       VARCHAR2(240),
    USER_DEFINED_FISC_CLASS                     VARCHAR2(30),
    TAX_INVOICE_NUMBER                          VARCHAR2(150),
    TAX_INVOICE_DATE                            DATE,
    PRODUCT_CATEGORY                            VARCHAR2(240),
    PRODUCT_TYPE                                VARCHAR2(240),
    ASSESSABLE_VALUE                            NUMBER,
    TAX_CLASSIFICATION_CODE                     VARCHAR2(50),
    EXEMPT_CERTIFICATE_NUMBER                   VARCHAR2(80),
    EXEMPT_REASON_CODE                          VARCHAR2(30),
    INTENDED_USE                                VARCHAR2(240),
    FIRST_PTY_NUMBER                            VARCHAR2(30),
    THIRD_PTY_NUMBER                            VARCHAR2(30),
    FINAL_DISCHARGE_LOC_CODE                    VARCHAR2(60),
    CATEGORY_NAME                               VARCHAR2(250),
    OWNING_ORGANIZATION_ID                      NUMBER,
    XFR_OWNING_ORGANIZATION_ID                  NUMBER,
    PRC_BU_NAME                                 VARCHAR2(240),
    VENDOR_NAME                                 VARCHAR2(240),
    VENDOR_NUMBER                               VARCHAR2(30),
    CONSIGNMENT_AGREEMENT_NUM                   VARCHAR2(30),
    USE_CURRENT_COST                            VARCHAR2(1),
    EXTERNAL_SYSTEM_PACKING_UNIT                VARCHAR2(150),
    TRANSFER_LOCATOR_NAME                       VARCHAR2(2000),
    INV_PROJECT                                 VARCHAR2(25),
    INV_TASK                                    VARCHAR2(100),
    COUNTRY_OF_ORIGIN_NAME                      VARCHAR2(80),
    TRANSFER_INV_PROJECT                        VARCHAR2(25),
    TRANSFER_INV_TASK                           VARCHAR2(100),
    PJC_PROJECT_NUMBER                          VARCHAR2(25),
    PJC_TASK_NUMBER                             VARCHAR2(100),
    PJC_EXPENDITURE_TYPE_NAME                   VARCHAR2(240),
    PJC_EXPENDITURE_ITEM_DATE                   DATE,
    PJC_EXPENDITURE_ORG_NAME                    VARCHAR2(240),
    PJC_CONTRACT_NUMBER                         VARCHAR2(120),
    PJC_FUNDING_SOURCE_NAME                     VARCHAR2(360),
    REQUESTER_NAME                              VARCHAR2(240),
    REQUESTER_NUMBER                            VARCHAR2(30),
    EXTERNAL_SYS_TXN_REFERENCE                  VARCHAR2(300),
    SOURCE_LOT_FLAG                             VARCHAR2(3),
    LOT_TXN_GROUP_NAME                          VARCHAR2(30),
    REPRESENTATIVE_LOT_NUMBER                   VARCHAR2(80)
    );
---
PROMPT
PROMPT Creating Table XXMX_SCM_INV_TXN_LOTS_STG
PROMPT
---
-- **********************
-- **Inventory Lots Table
-- **********************
CREATE TABLE XXMX_STG.XXMX_SCM_INV_TXN_LOTS_STG
    (
    FILE_SET_ID                                 VARCHAR2(30),
    MIGRATION_SET_ID                            NUMBER,
    MIGRATION_SET_NAME                          VARCHAR2(100),
    MIGRATION_STATUS                            VARCHAR2(50),
    INVENTORY_LOT_INTERFACE_NUMBER              VARCHAR2(240),      
    INVENTORY_SERIAL_INTERFACE_NUMBER           VARCHAR2(30),
    SOURCE_CODE                                 VARCHAR2(30),
    SOURCE_LINE_ID                              NUMBER,
    LOT_NUMBER                                  VARCHAR2(80),
    DESCRIPTION                                 VARCHAR2(256),
    LOT_EXPIRATION_DATE                         DATE,
    TRANSACTION_QUANTITY                        NUMBER,
    PRIMARY_QUANTITY                            NUMBER,
    ORIGINATION_TYPE                            VARCHAR2(30),
    ORIGINATION_DATE                            DATE,
    STATUS_CODE                                 VARCHAR2(80),
    RETEST_DATE                                 DATE,
    EXPIRATION_ACTION_NAME                      VARCHAR2(80),
    EXPIRATION_ACTION_CODE                      VARCHAR2(32),
    EXPIRATION_ACTION_DATE                      DATE,
    HOLD_DATE                                   DATE,
    MATURITY_DATE                               DATE,
    DATE_CODE                                   VARCHAR2(150),
    GRADE_CODE                                  VARCHAR2(150),
    CHANGE_DATE                                 DATE,
    AGE                                         NUMBER,
    REASON_CODE                                 VARCHAR2(4),
    REASON_NAME                                 VARCHAR2(30),
    PROCESS_FLAG                                VARCHAR2(1),
    SUPPLIER_LOT_NUMBER                         VARCHAR2(150),
    TERRITORY_CODE                              VARCHAR2(30),
    TERRITORY_SHORT_NAME                        VARCHAR2(80),
    ITEM_SIZE                                   NUMBER,
    COLOR                                       VARCHAR2(150),
    LOT_VOLUME                                  NUMBER,
    VOLUME_UOM_NAME                             VARCHAR2(25),
    VOLUME_UOM                                  VARCHAR2(3),
    PLACE_OF_ORIGIN                             VARCHAR2(150),
    BEST_BY_DATE                                DATE,
    LOT_LENGTH                                  NUMBER,
    LENGTH_UOM                                  VARCHAR2(3),
    LENGTH_UOM_NAME                             VARCHAR2(25),
    RECYCLED_CONTENT                            NUMBER,
    LOT_THICKNESS                               NUMBER,
    THICKNESS_UOM                               VARCHAR2(3),
    LOT_WIDTH                                   NUMBER,
    WIDTH_UOM                                   VARCHAR2(3),
    WIDTH_UOM_NAME                              VARCHAR2(25),
    CURL_WRINKLE_FOLD                           VARCHAR2(150),
    VENDOR_NAME                                 VARCHAR2(240),
    PRODUCT_CODE                                VARCHAR2(5),
    PRODUCT_TRANSACTION_ID                      NUMBER,
    SECONDARY_TRANSACTION_QUANTITY              NUMBER,
    SUBLOT_NUM                                  VARCHAR2(32),
    PARENT_LOT_NUMBER                           VARCHAR2(80),
    PARENT_OBJECT_TYPE                          NUMBER,
    PARENT_OBJECT_NUMBER                        VARCHAR2(240),
    PARENT_OBJECT_TYPE2                         NUMBER,
    PARENT_OBJECT_NUMBER2                       VARCHAR2(240),
    LOT_ATTRIBUTE_CATEGORY                      VARCHAR2(30),
    C_ATTRIBUTE1                                VARCHAR2(150),
    C_ATTRIBUTE2                                VARCHAR2(150),
    C_ATTRIBUTE3                                VARCHAR2(150),
    C_ATTRIBUTE4                                VARCHAR2(150),
    C_ATTRIBUTE5                                VARCHAR2(150),
    C_ATTRIBUTE6                                VARCHAR2(150),
    C_ATTRIBUTE7                                VARCHAR2(150),
    C_ATTRIBUTE8                                VARCHAR2(150),
    C_ATTRIBUTE9                                VARCHAR2(150),
    C_ATTRIBUTE10                               VARCHAR2(150),
    C_ATTRIBUTE11                               VARCHAR2(150),
    C_ATTRIBUTE12                               VARCHAR2(150),
    C_ATTRIBUTE13                               VARCHAR2(150),
    C_ATTRIBUTE14                               VARCHAR2(150),
    C_ATTRIBUTE15                               VARCHAR2(150),
    C_ATTRIBUTE16                               VARCHAR2(150),
    C_ATTRIBUTE17                               VARCHAR2(150),
    C_ATTRIBUTE18                               VARCHAR2(150),
    C_ATTRIBUTE19                               VARCHAR2(150),
    C_ATTRIBUTE20                               VARCHAR2(150),
    D_ATTRIBUTE1                                DATE,
    D_ATTRIBUTE2                                DATE,
    D_ATTRIBUTE3                                DATE,
    D_ATTRIBUTE4                                DATE,
    D_ATTRIBUTE5                                DATE,
    D_ATTRIBUTE6                                DATE,
    D_ATTRIBUTE7                                DATE,
    D_ATTRIBUTE8                                DATE,
    D_ATTRIBUTE9                                DATE,
    D_ATTRIBUTE10                               DATE,
    N_ATTRIBUTE1                                NUMBER,
    N_ATTRIBUTE2                                NUMBER,
    N_ATTRIBUTE3                                NUMBER,
    N_ATTRIBUTE4                                NUMBER,
    N_ATTRIBUTE5                                NUMBER,
    N_ATTRIBUTE6                                NUMBER,
    N_ATTRIBUTE7                                NUMBER,
    N_ATTRIBUTE8                                NUMBER,
    N_ATTRIBUTE9                                NUMBER,
    N_ATTRIBUTE10                               NUMBER,
    T_ATTRIBUTE1                                TIMESTAMP,
    T_ATTRIBUTE2                                TIMESTAMP,
    T_ATTRIBUTE3                                TIMESTAMP,
    T_ATTRIBUTE4                                TIMESTAMP,
    T_ATTRIBUTE5                                TIMESTAMP,
    ATTRIBUTE_CATEGORY                          VARCHAR2(30),
    ATTRIBUTE1                                  VARCHAR2(150),
    ATTRIBUTE2                                  VARCHAR2(150),
    ATTRIBUTE3                                  VARCHAR2(150),
    ATTRIBUTE4                                  VARCHAR2(150),
    ATTRIBUTE5                                  VARCHAR2(150),
    ATTRIBUTE6                                  VARCHAR2(150),
    ATTRIBUTE7                                  VARCHAR2(150),
    ATTRIBUTE8                                  VARCHAR2(150),
    ATTRIBUTE9                                  VARCHAR2(150),
    ATTRIBUTE10                                 VARCHAR2(150),
    ATTRIBUTE11                                 VARCHAR2(150),
    ATTRIBUTE12                                 VARCHAR2(150),
    ATTRIBUTE13                                 VARCHAR2(150),
    ATTRIBUTE14                                 VARCHAR2(150),
    ATTRIBUTE15                                 VARCHAR2(150),
    ATTRIBUTE16                                 VARCHAR2(150),
    ATTRIBUTE17                                 VARCHAR2(150),
    ATTRIBUTE18                                 VARCHAR2(150),
    ATTRIBUTE19                                 VARCHAR2(150),
    ATTRIBUTE20                                 VARCHAR2(150),
    ATTRIBUTE_NUMBER1                           NUMBER,
    ATTRIBUTE_NUMBER2                           NUMBER,
    ATTRIBUTE_NUMBER3                           NUMBER,
    ATTRIBUTE_NUMBER4                           NUMBER,
    ATTRIBUTE_NUMBER5                           NUMBER,
    ATTRIBUTE_NUMBER6                           NUMBER,
    ATTRIBUTE_NUMBER7                           NUMBER,
    ATTRIBUTE_NUMBER8                           NUMBER,
    ATTRIBUTE_NUMBER9                           NUMBER,
    ATTRIBUTE_NUMBER10                          NUMBER,
    ATTRIBUTE_DATE1                             DATE,
    ATTRIBUTE_DATE2                             DATE,
    ATTRIBUTE_DATE3                             DATE,
    ATTRIBUTE_DATE4                             DATE,
    ATTRIBUTE_DATE5                             DATE,
    ATTRIBUTE_TIMESTAMP1                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5                        TIMESTAMP
    );
---
PROMPT
PROMPT Creating Table XXMX_SCM_INV_SER_NUMS_STG
PROMPT
---
-- ********************************
-- **Inventory Serial Numbers Table
-- ********************************
CREATE TABLE XXMX_STG.XXMX_SCM_INV_SER_NUMS_STG
    (
    FILE_SET_ID                                 VARCHAR2(30),
    MIGRATION_SET_ID                            NUMBER,
    MIGRATION_SET_NAME                          VARCHAR2(100),
    MIGRATION_STATUS                            VARCHAR2(50),
    INV_SERIAL_INTERFACE_NUM                    VARCHAR2(30),
    SOURCE_CODE                                 VARCHAR2(30),
    SOURCE_LINE_ID                              NUMBER,
    FM_SERIAL_NUMBER                            VARCHAR2(80),
    TO_SERIAL_NUMBER                            VARCHAR2(80),
    ERROR_CODE                                  VARCHAR2(240),
    PROCESS_FLAG                                NUMBER,
    PARENT_SERIAL_NUMBER                        VARCHAR2(80),
    SERIAL_ATTRIBUTE_CATEGORY                   VARCHAR2(30),
    TERRITORY_CODE                              VARCHAR2(30),
    ORIGINATION_DATE                            DATE,
    VENDOR_SERIAL_NUMBER                        VARCHAR2(80),
    VENDOR_LOT_NUMBER                           VARCHAR2(30),
    TIME_SINCE_NEW                              NUMBER,
    CYCLES_SINCE_NEW                            NUMBER,
    TIME_SINCE_OVERHAUL                         NUMBER,
    CYCLES_SINCE_OVERHAUL                       NUMBER,
    TIME_SINCE_REPAIR                           NUMBER,
    CYCLES_SINCE_REPAIR                         NUMBER,
    TIME_SINCE_VISIT                            NUMBER,
    CYCLES_SINCE_VISIT                          NUMBER,
    TIME_SINCE_MARK                             NUMBER,
    CYCLES_SINCE_MARK                           NUMBER,
    NUMBER_OF_REPAIRS                           NUMBER,
    STATUS_NAME                                 VARCHAR2(30),
    STATUS_CODE                                 VARCHAR2(80),
    PRODUCT_CODE                                VARCHAR2(5),
    PRODUCT_TRANSACTION_ID                      NUMBER,
    PARENT_OBJECT_TYPE                          NUMBER,
    PARENT_OBJECT_NUMBER                        VARCHAR2(240),
    PARENT_OBJECT_TYPE2                         NUMBER,
    PARENT_OBJECT_NUMBER2                       VARCHAR2(240),
    C_ATTRIBUTE1                                VARCHAR2(150),
    C_ATTRIBUTE2                                VARCHAR2(150),
    C_ATTRIBUTE3                                VARCHAR2(150),
    C_ATTRIBUTE4                                VARCHAR2(150),
    C_ATTRIBUTE5                                VARCHAR2(150),
    C_ATTRIBUTE6                                VARCHAR2(150),
    C_ATTRIBUTE7                                VARCHAR2(150),
    C_ATTRIBUTE8                                VARCHAR2(150),
    C_ATTRIBUTE9                                VARCHAR2(150),
    C_ATTRIBUTE10                               VARCHAR2(150),
    C_ATTRIBUTE11                               VARCHAR2(150),
    C_ATTRIBUTE12                               VARCHAR2(150),
    C_ATTRIBUTE13                               VARCHAR2(150),
    C_ATTRIBUTE14                               VARCHAR2(150),
    C_ATTRIBUTE15                               VARCHAR2(150),
    C_ATTRIBUTE16                               VARCHAR2(150),
    C_ATTRIBUTE17                               VARCHAR2(150),
    C_ATTRIBUTE18                               VARCHAR2(150),
    C_ATTRIBUTE19                               VARCHAR2(150),
    C_ATTRIBUTE20                               VARCHAR2(150),
    D_ATTRIBUTE1                                DATE,
    D_ATTRIBUTE2                                DATE,
    D_ATTRIBUTE3                                DATE,
    D_ATTRIBUTE4                                DATE,
    D_ATTRIBUTE5                                DATE,
    D_ATTRIBUTE6                                DATE,
    D_ATTRIBUTE7                                DATE,
    D_ATTRIBUTE8                                DATE,
    D_ATTRIBUTE9                                DATE,
    D_ATTRIBUTE10                               DATE,
    N_ATTRIBUTE1                                NUMBER,
    N_ATTRIBUTE2                                NUMBER,
    N_ATTRIBUTE3                                NUMBER,
    N_ATTRIBUTE4                                NUMBER,
    N_ATTRIBUTE5                                NUMBER,
    N_ATTRIBUTE6                                NUMBER,
    N_ATTRIBUTE7                                NUMBER,
    N_ATTRIBUTE8                                NUMBER,
    N_ATTRIBUTE9                                NUMBER,
    N_ATTRIBUTE10                               NUMBER,
    T_ATTRIBUTE1                                TIMESTAMP,
    T_ATTRIBUTE2                                TIMESTAMP,
    T_ATTRIBUTE3                                TIMESTAMP,
    T_ATTRIBUTE4                                TIMESTAMP,
    T_ATTRIBUTE5                                TIMESTAMP,
    ATTRIBUTE_CATEGORY                          VARCHAR2(30),
    ATTRIBUTE1                                  VARCHAR2(150),
    ATTRIBUTE2                                  VARCHAR2(150),
    ATTRIBUTE3                                  VARCHAR2(150),
    ATTRIBUTE4                                  VARCHAR2(150),
    ATTRIBUTE5                                  VARCHAR2(150),
    ATTRIBUTE6                                  VARCHAR2(150),
    ATTRIBUTE7                                  VARCHAR2(150),
    ATTRIBUTE8                                  VARCHAR2(150),
    ATTRIBUTE9                                  VARCHAR2(150),
    ATTRIBUTE10                                 VARCHAR2(150),
    ATTRIBUTE11                                 VARCHAR2(150),
    ATTRIBUTE12                                 VARCHAR2(150),
    ATTRIBUTE13                                 VARCHAR2(150),
    ATTRIBUTE14                                 VARCHAR2(150),
    ATTRIBUTE15                                 VARCHAR2(150),
    ATTRIBUTE16                                 VARCHAR2(150),
    ATTRIBUTE17                                 VARCHAR2(150),
    ATTRIBUTE18                                 VARCHAR2(150),
    ATTRIBUTE19                                 VARCHAR2(150),
    ATTRIBUTE20                                 VARCHAR2(150),
    ATTRIBUTE_NUMBER1                           NUMBER,
    ATTRIBUTE_NUMBER2                           NUMBER,
    ATTRIBUTE_NUMBER3                           NUMBER,
    ATTRIBUTE_NUMBER4                           NUMBER,
    ATTRIBUTE_NUMBER5                           NUMBER,
    ATTRIBUTE_NUMBER6                           NUMBER,
    ATTRIBUTE_NUMBER7                           NUMBER,
    ATTRIBUTE_NUMBER8                           NUMBER,
    ATTRIBUTE_NUMBER9                           NUMBER,
    ATTRIBUTE_NUMBER10                          NUMBER,
    ATTRIBUTE_DATE1                             DATE,
    ATTRIBUTE_DATE2                             DATE,
    ATTRIBUTE_DATE3                             DATE,
    ATTRIBUTE_DATE4                             DATE,
    ATTRIBUTE_DATE5                             DATE,
    ATTRIBUTE_TIMESTAMP1                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4                        TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5                        TIMESTAMP
    );
--- 
PROMPT
PROMPT Creating Table XXMX_STG.XXMX_SCM_INV_TXN_COSTS_STG
PROMPT
---
-- *************************
-- **Transaction Costs Table
-- *************************
CREATE TABLE XXMX_STG.XXMX_SCM_INV_TXN_COSTS_STG
    (
    FILE_SET_ID                             VARCHAR2(30),
    MIGRATION_SET_ID                        NUMBER,
    MIGRATION_SET_NAME                      VARCHAR2(100),
    MIGRATION_STATUS                        VARCHAR2(50),
    TRANSACTION_COST_IDENTIFIER             VARCHAR2(30),
    COST_COMPONENT_CODE                     VARCHAR2(30),
    COST                                    NUMBER
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
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_INV_TXNS_STG FOR XXMX_STG.XXMX_SCM_INV_TXNS_STG;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_INV_TXN_LOTS_STG FOR XXMX_STG.XXMX_SCM_INV_TXN_LOTS_STG;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_INV_SER_NUMS_STG FOR XXMX_STG.XXMX_SCM_INV_SER_NUMS_STG;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_INV_TXN_COSTS_STG FOR XXMX_STG.XXMX_SCM_INV_TXN_COSTS_STG;
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
GRANT ALL ON XXMX_STG.XXMX_SCM_INV_TXNS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_SCM_INV_TXN_LOTS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_SCM_INV_SER_NUMS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_SCM_INV_TXN_COSTS_STG TO XXMX_CORE;
--
--

--
--
PROMPT
PROMPT
PROMPT ****************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for CloudBridge INV TXN Data Migration
PROMPT **                                
PROMPT ****************************************************************************
PROMPT
PROMPT
--
--