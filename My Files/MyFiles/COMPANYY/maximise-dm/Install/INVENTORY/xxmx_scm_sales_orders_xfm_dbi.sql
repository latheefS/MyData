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
--** FILENAME  : xxmx_scm_sales_orders_xfm_dbi.sql
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
--** PURPOSE   :  This script installs the XXMX_XFM DB Objects for the Cloudbridge
--**              SCM SALES ORDERS Data Migration.
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
--** -----  -----------  ------------------  -------------------------------------------
--**   1.0  20-AUG-2024  Sinchana Ramesh     Created SALES ORDERS XFM tables for Cloudbridge.
--**
--**************************************************************************************
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

PROMPT
PROMPT
PROMPT *****************************************************************************
PROMPT **
PROMPT ** Installing Extract Database Objects for Cloudbridge Sales Orders Data Migration
PROMPT **
PROMPT *****************************************************************************
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
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_PROJECTS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_PROJECTS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_TERMS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_TERMS_INT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM')
--
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
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM
PROMPT

--
-- **************
-- ** Order Headers Import
-- **************

CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM 
(
    FILE_SET_ID                                                 VARCHAR2(30),
    MIGRATION_SET_ID                                            NUMBER,
    MIGRATION_SET_NAME                                          VARCHAR2(100),
    MIGRATION_STATUS                                            VARCHAR2(50),
    BATCH_NAME                                                  VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                               VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                                   VARCHAR2(30),
    SOURCE_TRANSACTION_NUMBER                                   VARCHAR2(50),
    SOURCE_TRANSACTION_REVISION_NUMBER                          NUMBER(18,0),
    BUYING_PARTY_IDENTIFIER                                     NUMBER(18,0),
    BUYING_PARTY_NAME                                           VARCHAR2(360),
    BUYING_PARTY_FIRST_NAME                                     VARCHAR2(150),
    BUYING_PARTY_LAST_NAME                                      VARCHAR2(150),
    BUYING_PARTY_MIDDLE_NAME                                    VARCHAR2(60),
    BUYING_PARTY_NAME_SUFFIX                                    VARCHAR2(30),
    BUYING_PARTY_TITLE                                          VARCHAR2(60),
    BUYING_PARTY_NUMBER                                         VARCHAR2(30),
    BUYING_PARTY_ORIG_SYS_REFERENCE                             VARCHAR2(255),
    BUYING_PARTY_CONTACT_IDENTIFIER                             NUMBER(18,0),
    BUYING_PARTY_CONTACT_NAME                                   VARCHAR2(360),
    BUYING_PARTY_CONTACT_FIRST_NAME                             VARCHAR2(150),
    BUYING_PARTY_CONTACT_LAST_NAME                              VARCHAR2(150),
    BUYING_PARTY_CONTACT_MIDDLE_NAME                            VARCHAR2(60),
    BUYING_PARTY_CONTACT_NAME_SUFFIX                            VARCHAR2(30),
    BUYING_PARTY_CONTACT_TITLE                                  VARCHAR2(60),
    BUYING_PARTY_TYPE                                           VARCHAR2(30),
    BUYING_PARTY_CONTACT_NUMBER                                 VARCHAR2(30),
    BUYING_PARTY_CONTACT_ORIG_SYS_REFERENCE                     VARCHAR2(255),
    PREFERRED_SOLD_TO_CONTACT_POINT_IDENTIFIER                  NUMBER(18,0),
    PREFERRED_SOLD_TO_CONTACT_POINT_ORIG_SYS_REFERENCE          VARCHAR2(240),
    CUSTOMER_PO_NUMBER                                          VARCHAR2(50),
    TRANSACTIONAL_CURRENCY_CODE                                 VARCHAR2(1000),
    TRANSACTIONAL_CURRENCY_NAME                                 VARCHAR2(1000),
    CURRENCY_CONVERSION_TYPE                                    VARCHAR2(1000),
    CURRENCY_CONVERSION_RATE                                    NUMBER,
    CURRENCY_CONVERSION_DATE                                    DATE,
    TRANSACTION_ON                                              DATE,
    REQUESTING_BUSINESS_UNIT_IDENTIFIER                         NUMBER(18,0),
    REQUESTING_BUSINESS_UNIT                                    VARCHAR2(240),
    TRANSACTION_TYPE_CODE                                       VARCHAR2(30),
    TRANSACTION_DOCUMENT_TYPE_CODE                              VARCHAR2(50),
    REQUEST_CANCEL_DATE                                         TIMESTAMP,
    COMMENTS                                                    VARCHAR2(2000),
    REQUESTING_LEGAL_ENTITY_IDENTIFIER                          NUMBER(18,0),
    REQUESTING_LEGAL_ENTITY                                     VARCHAR2(240),
    ORIG_SYS_DOCUMENT_REFERENCE                                 VARCHAR2(50),
    PARTIAL_SHIP_ALLOWED_FLAG                                   VARCHAR2(1),
    CANCEL_REASON_CODE                                          VARCHAR2(1000),
    CANCEL_REASON                                               VARCHAR2(1000),
    PRICED_ON                                                   TIMESTAMP(6),
    FREEZE_PRICING                                              VARCHAR2(1),
    FREEZE_SHIPPING_CHARGE                                      VARCHAR2(1),
    FREEZE_TAX                                                  VARCHAR2(1),
    OPERATION_MODE                                              VARCHAR2(30),
    CREATE_CUSTOMER_INFORMATION_FLAG                            VARCHAR2(1),
    REVISION_SOURCE_TRANSACTION_SYSTEM                          VARCHAR2(30),
    BUYING_PARTY_PERSON_EMAIL                                   VARCHAR2(320),
    BUYING_PARTY_ORGANIZATION_EMAIL                             VARCHAR2(320),
    BUYING_PARTY_CONTACT_EMAIL                                  VARCHAR2(320),
    SUBMIT_FLAG                                                 VARCHAR2(1),
    CREDIT_AUTHORIZED_IN_SOURCE                                 VARCHAR2(1),
    SALES_CHANNEL_IDENTIFIER                                    VARCHAR2(30),
    SALES_CHANNEL                                               VARCHAR2(80),
    PRIMARY_SALES_PERSON_IDENTIFIER                             NUMBER(18),
    PRIMARY_SALES_PERSON                                        VARCHAR2(360),
    SALES_AGREEMENT_IDENTIFIER                                  NUMBER(18),
    SALES_AGREEMENT_NUMBER                                      VARCHAR2(150)
);
--
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM
PROMPT

--
-- **************
-- ** Order Lines Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM 
(
    FILE_SET_ID                                                     VARCHAR2(30),
    MIGRATION_SET_ID                                                NUMBER,
    MIGRATION_SET_NAME                                              VARCHAR2(100),
    MIGRATION_STATUS                                                VARCHAR2(50),
    BATCH_NAME                                                      VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                                   VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                                       VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                              VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER                          VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_NUMBER                              VARCHAR2(50),
    SOURCE_TRANSACTION_LINE_NUMBER                                  VARCHAR2(50),
    PRODUCT_IDENTIFIER                                              NUMBER(18),
    PRODUCT_NUMBER                                                  VARCHAR2(300),
    PRODUCT_DESCRIPTION                                             VARCHAR2(240),
    SOURCE_SYS_PRODUCT_REFERENCE                                    VARCHAR2(150),
    ORDERED_QUANTITY                                                NUMBER,
    ORDERED_UOM_CODE                                                VARCHAR2(3),
    ORDERED_UOM                                                     VARCHAR2(25),
    REQUESTED_FULFILLMENT_ORGANIZATION_IDENTIFIER                   NUMBER(18),
    REQUESTED_FULFILLMENT_ORGANIZATION_CODE                         VARCHAR2(18),
    REQUESTED_FULFILLMENT_ORGANIZATION_NAME                         VARCHAR2(240),
    BUSINESS_UNIT_IDENTIFIER                                        NUMBER(18),
    BUSINESS_UNIT_NAME                                              VARCHAR2(240),
    REQUESTING_BUSINESS_UNIT_IDENTIFIER                             NUMBER(18),
    REQUESTING_BUSINESS_UNIT_NAME                                   VARCHAR2(240),
    SUBSTITUTION_ALLOWED_FLAG                                       VARCHAR2(1),
    CUSTOMER_PO_NUMBER                                              VARCHAR2(50),
    CUSTOMER_PO_LINE_NUMBER                                         VARCHAR2(50),
    CUSTOMER_PO_SCHEDULE_NUMBER                                     VARCHAR2(50),
    CUSTOMER_PRODUCT_IDENTIFIER                                     NUMBER(18),
    CUSTOMER_PRODUCT_NUMBER                                         VARCHAR2(150),
    CUSTOMER_PRODUCT_DESCRIPTION                                    VARCHAR2(240),
    TRANSACTION_LINE_TYPE_CODE                                      VARCHAR2(30),
    TRANSACTION_LINE_TYPE                                           VARCHAR2(240),
    PARENT_LINE_REFERENCE                                           VARCHAR2(50),
    ROOT_PARENT_LINE_REFERENCE                                      VARCHAR2(50),
    SHIPPING_INSTRUCTIONS                                           VARCHAR2(1000),
    PACKING_INSTRUCTIONS                                            VARCHAR2(1000),
    INVOICING_RULE_CODE                                             VARCHAR2(1000),
    INVOICING_RULE                                                  VARCHAR2(30),
    ACCOUNTING_RULE_CODE                                            VARCHAR2(1000),
    ACCOUNTING_RULE                                                 VARCHAR2(30),
    REQUESTED_SHIP_DATE                                             DATE,
    REQUESTED_ARRIVAL_DATE                                          DATE,
    SCHEDULE_SHIP_DATE                                              DATE,
    SCHEDULE_ARRIVAL_DATE                                           DATE,
    DEMAND_CLASS_CODE                                               VARCHAR2(1000),
    DEMAND_CLASS                                                    VARCHAR2(1000),
    SHIPPING_CARRIER_CODE                                           VARCHAR2(1000),
    SHIPPING_CARRIER                                                VARCHAR2(1000),
    PAYMENT_TERM_CODE                                               VARCHAR2(1000),
    PAYMENT_TERM                                                    VARCHAR2(1000),
    TRANSACTION_CATEGORY_CODE                                       VARCHAR2(30),
    SHIPPING_SERVICE_LEVEL_CODE                                     VARCHAR2(1000),
    SHIPPING_SERVICE_LEVEL                                          VARCHAR2(1000),
    SHIPPING_MODE_CODE                                              VARCHAR2(1000),
    SHIPPING_MODE                                                   VARCHAR2(1000),
    SHIPMENT_PRIORITY_CODE                                          VARCHAR2(1000),
    SHIPMENT_PRIORITY                                               VARCHAR2(1000),
    INVENTORY_ORGANIZATION_IDENTIFIER                               NUMBER(18),
    INVENTORY_ORGANIZATION_CODE                                     VARCHAR2(18),
    INVENTORY_ORGANIZATION_NAME                                     VARCHAR2(240),
    FREIGHT_TERMS_CODE                                              VARCHAR2(1000),
    FREIGHT_TERMS                                                   VARCHAR2(1000),
    REQUEST_CANCEL_DATE                                             TIMESTAMP,
    ORIGINAL_PRODUCT_IDENTIFIER                                     NUMBER(18),
    ORIGINAL_PRODUCT_NUMBER                                         VARCHAR2(300),
    ORIGINAL_PRODUCT_DESCRIPTION                                    VARCHAR2(240),
    PARTIAL_SHIP_ALLOWED_FLAG                                       VARCHAR2(1),
    FULFILLMENT_LINE_IDENTIFIER                                     NUMBER(18),
    COMMENTS                                                        VARCHAR2(2000),
    UNIT_LIST_PRICE                                                 NUMBER,
    UNIT_SELLING_PRICE                                              NUMBER,
    EXTENDED_AMOUNT                                                 NUMBER,
    EARLIEST_ACCEPTABLE_SHIP_DATE                                   DATE,
    LATEST_ACCEPTABLE_SHIP_DATE                                     DATE,
    EARLIEST_ACCEPTABLE_ARRIVAL_DATE                                DATE,
    LATEST_ACCEPTABLE_ARRIVAL_DATE                                  DATE,
    PROMISE_SHIP_DATE                                               DATE,
    PROMISE_ARRIVAL_DATE                                            DATE,
    SUBINVENTORY_CODE                                               VARCHAR2(10),
    SUBINVENTORY                                                    VARCHAR2(10),
    SHIP_SET_NAME                                                   VARCHAR2(50),
    TAX_EXEMPT_FLAG                                                 VARCHAR2(1),
    TAX_CLASSIFICATION_CODE                                         VARCHAR2(1000),
    TAX_CLASSIFICATION                                              VARCHAR2(1000),
    TAX_EXEMPTION_CERTIFICATE_NUMBER                                VARCHAR2(80),
    TAX_EXEMPT_REASON_CODE                                          VARCHAR2(1000),
    TAX_EXEMPT_REASON                                               VARCHAR2(1000),
    DEFAULT_TAXATION_COUNTRY                                        VARCHAR2(2),
    DEFAULT_TAX_COUNTRY_SHORT_NAME                                  VARCHAR2(2),
    FIRST_PARTY_TAX_REGISTRATION                                    NUMBER(18),
    FIRST_PARTY_TAX_REGISTRATION_NUMBER                             VARCHAR2(50),
    THIRD_PARTY_TAX_REGISTRATION                                    NUMBER(18),
    THIRD_PARTY_TAX_REGISTRATION_NUMBER                             VARCHAR2(50),
    DOCUMENT_SUBTYPE                                                VARCHAR2(240),
    DOCUMENT_SUBTYPE_NAME                                           VARCHAR2(240),
    PRODUCT_FISCAL_CATEGORY_IDENTIFIER                              NUMBER(18),
    PRODUCT_FISCAL_CATEGORY_NAME                                    VARCHAR2(250),
    PRODUCT_TYPE                                                    VARCHAR2(240),
    PRODUCT_TYPE_NAME                                               VARCHAR2(80),
    PRODUCT_CATEGORY                                                VARCHAR2(240),
    PRODUCT_CATEGORY_NAME                                           VARCHAR2(240),
    TRANSACTION_BUSINESS_CATEGORY                                   VARCHAR2(240),
    TRANSACTION_BUSINESS_CATEGORY_NAME                              VARCHAR2(240),
    ASSESSABLE_VALUE                                                NUMBER,
    USER_DEFINED_FISCAL_CLASS                                       VARCHAR2(30),
    USER_DEFINED_FISCAL_CLASS_NAME                                  VARCHAR2(240),
    INTENDED_USE_CLASSIFICATION_IDENTIFIER                          NUMBER(18),
    INTENDED_USE_CLASSIFICATION_NAME                                VARCHAR2(240),
    FOB_POINT_CODE                                                  VARCHAR2(1000),
    FOB_POINT                                                       VARCHAR2(1000),
    ORIG_SYS_DOCUMENT_REFERENCE                                     VARCHAR2(50),
    ORIG_SYS_DOCUMENT_LINE_REFERENCE                                VARCHAR2(50),
    CANCEL_REASON_CODE                                              VARCHAR2(1000),
    CANCEL_REASON                                                   VARCHAR2(1000),
    SUBSTITUTION_REASON_CODE                                        VARCHAR2(30),
    SUBSTITUTION_REASON                                             VARCHAR2(240),
    RETURN_REASON_CODE                                              VARCHAR2(1000),
    RETURN_REASON                                                   VARCHAR2(1000),
    QUANTITY_PER_MODEL                                              NUMBER,
    UNIT_QUANTITY                                                   NUMBER,
    SORT_LINE_NUMBER                                                NUMBER(9,0),
    CONTRACT_START_DATE                                             DATE,
    CONTRACT_END_DATE                                               DATE,
    TOTAL_CONTRACT_QUANTITY                                         NUMBER,
    TOTAL_CONTRACT_AMOUNT                                           NUMBER,
    REQUIRED_FULFILLMENT_DATE                                       DATE,
    COMPONENT_ID_PATH                                               VARCHAR2(2000),
    IS_VALID_CONFIGURATION                                          VARCHAR2(1),
    CONFIGURATOR_PATH                                               VARCHAR2(2000),
    CONFIG_HEADER_IDENTIFIER                                        NUMBER(18,0),
    CONFIG_REVISION_NUMBER                                          NUMBER(18,0),
    OPERATION_MODE                                                  VARCHAR2(30),
    CREDIT_AUTHORIZATION_REFERENCE                                  VARCHAR2(240),
    CREDIT_AUTHORIZATION_EXPIRATION_DATE                            DATE,
    SERVICE_DURATION                                                NUMBER,
    SERVICE_DURATION_CODE                                           VARCHAR2(10),
    SERVICE_DURATION_UOM                                            VARCHAR2(25),
    PRIMARY_SALES_PERSON_IDENTIFIER                                 NUMBER(18),
    PRIMARY_SALES_PERSON                                            VARCHAR2(360),
    ASSET_GROUP_NUMBER                                              VARCHAR2(30),
    CANCELLATION_EFFECTIVE_DATE                                     DATE,
    SALES_AGREEMENT_IDENTIFIER                                      NUMBER(18),
    SALES_AGREEMENT_NUMBER                                          VARCHAR2(150),
    IDENTIFIER_FOR_COVERED_PRODUCT                                  NUMBER(18),
    NUMBER_FOR_COVERED_PRODUCT                                      VARCHAR2(300),
    DESCRIPTION_FOR_COVERED_PRODUCT                                 VARCHAR2(240),
    SOURCE_SYSTEM_REFERENCE_FOR_COVERED_PRODUCT                     VARCHAR2(255),
    IDENTIFIER_FOR_COVERED_CUSTOMER_PRODUCT                         NUMBER(18),
    NUMBER_FOR_COVERED_CUSTOMER_PRODUCT                             VARCHAR2(150),
    DESCRIPTION_FOR_COVERED_CUSTOMER_PRODUCT                        VARCHAR2(240),
    INVENTORY_TRANSACTION_FLAG                                      VARCHAR2(1),
    SUBSCRIPTION_PROFILE_IDENTIFIER                                 NUMBER(18),
    SUBSCRIPTION_PROFILE_NAME                                       VARCHAR2(300),
    EXTERNAL_PRICE_BOOK_NAME                                        VARCHAR2(80),
    ACTION_TYPE_CODE                                                VARCHAR2(30),
    ACTION_TYPE                                                     VARCHAR2(80),
    END_REASON_CODE                                                 VARCHAR2(30),
    END_REASON                                                      VARCHAR2(80),
    END_CREDIT_METHOD_CODE                                          VARCHAR2(30),
    END_CREDIT_METHOD                                               VARCHAR2(80),
    END_DATE                                                        TIMESTAMP(6),
    PROCESS_NAME                                                    VARCHAR2(80),
    DEMAND_SOURCE_LINE_REFERENCE                                    VARCHAR2(400),
    REQUESTED_RATE_PLAN_ID                                          VARCHAR2(120),
    REQUESTED_RATE_PLAN_NUMBER                                      NUMBER(18),
    CANCEL_BACKORDERS                                               VARCHAR2(1),
    ENFORCE_SINGLE_SHIPMENT                                         VARCHAR2(1)
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM
PROMPT

--
-- **************
-- ** Order Addresses Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM 
(
    FILE_SET_ID                                          VARCHAR2(30),
    MIGRATION_SET_ID                                     NUMBER,
    MIGRATION_SET_NAME                                   VARCHAR2(100),
    MIGRATION_STATUS                                     VARCHAR2(50),
    BATCH_NAME                                           VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                        VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                            VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER               VARCHAR2(50),
    ADDRESS_USE_TYPE                                     VARCHAR2(30),
    PARTY_IDENTIFIER                                     NUMBER(18,0),
    PARTY_NUMBER                                         VARCHAR2(30),
    PARTY_NAME                                           VARCHAR2(360),
    CUSTOMER_IDENTIFIER                                  NUMBER(18,0),
    CUSTOMER_NUMBER                                      VARCHAR2(30),
    CUSTOMER_NAME                                        VARCHAR2(360),
    REQUESTED_SUPPLIER_CODE                              VARCHAR2(1000),
    REQUESTED_SUPPLIER_NUMBER                            VARCHAR2(154),
    REQUESTED_SUPPLIER_NAME                              VARCHAR2(1000),
    PARTY_SITE_IDENTIFIER                                NUMBER(18,0),
    ACCOUNT_SITE_IDENTIFIER                              NUMBER(18,0),
    REQUESTED_SUPPLIER_SITE_IDENTIFIER                   NUMBER(18,0),
    ADDRESS_ORIG_SYS_REFERENCE                           VARCHAR2(255),
    ADDRESS_LINE1                                        VARCHAR2(240),
    ADDRESS_LINE2                                        VARCHAR2(240),
    ADDRESS_LINE3                                        VARCHAR2(240),
    ADDRESS_LINE4                                        VARCHAR2(240),
    CITY                                                 VARCHAR2(60),
    POSTAL_CODE                                          VARCHAR2(60),
    STATE                                                VARCHAR2(60),
    PROVINCE                                             VARCHAR2(60),
    COUNTY                                               VARCHAR2(60),
    COUNTRY                                              VARCHAR2(60),
    SHIP_TO_REQUEST_REGION                               VARCHAR2(255),
    PARTY_CONTACT_IDENTIFIER                             NUMBER(18,0),
    PARTY_CONTACT_NUMBER                                 VARCHAR2(30),
    PARTY_CONTACT_NAME                                   VARCHAR2(360),
    ACCOUNT_CONTACT_IDENTIFIER                           NUMBER(18,0),
    ACCOUNT_CONTACT_NUMBER                               VARCHAR2(30),
    ACCOUNT_CONTACT_NAME                                 VARCHAR2(360),
    CONTACT_ORIG_SYS_REFERENCE                           VARCHAR2(255),
    LOCATION_IDENTIFIER                                  NUMBER(18),
    PREFERRED_CONTACT_POINT_IDENTIFIER                   NUMBER(18),
    PREFERRED_CONTACT_ORIG_SYS_REFERENCE                 VARCHAR2(240),
    FIRST_NAME                                           VARCHAR2(150),
    LAST_NAME                                            VARCHAR2(150),
    MIDDLE_NAME                                          VARCHAR2(60),
    NAME_SUFFIX                                          VARCHAR2(30),
    TITLE                                                VARCHAR2(60),
    CONTACT_FIRST_NAME                                   VARCHAR2(150),
    CONTACT_LAST_NAME                                    VARCHAR2(150),
    CONTACT_MIDDLE_NAME                                  VARCHAR2(60),
    CONTACT_NAME_SUFFIX                                  VARCHAR2(30),
    CONTACT_TITLE                                        VARCHAR2(60),
    PARTY_TYPE                                           VARCHAR2(30),
    DESTINATION_SHIPPING_ORGANIZATION_IDENTIFIER         NUMBER(18),
    DESTINATION_SHIPPING_ORGANIZATION_CODE               VARCHAR2(18),
    DESTINATION_SHIPPING_ORGANIZATION_NAME               VARCHAR2(240),
    PARTY_PERSON_EMAIL                                   VARCHAR2(320),
    PARTY_ORGANIZATION_EMAIL                             VARCHAR2(320),
    PARTY_CONTACT_EMAIL                                  VARCHAR2(320)
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM
PROMPT

--
-- **************
-- ** Order Transaction Attributes Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM 
(
    FILE_SET_ID                                        VARCHAR2(30),
    MIGRATION_SET_ID                                   NUMBER,
    MIGRATION_SET_NAME                                 VARCHAR2(100),
    MIGRATION_STATUS                                   VARCHAR2(50),
    BATCH_NAME                                         VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                      VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                          VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_ID                         VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_ID                     VARCHAR2(50),
    SOURCE_TRANSACTION_LINE_ATTRIBUTE_ID               VARCHAR2(50),
    TRANSACTION_ATTRIBUTE_CODE                         VARCHAR2(100),
    TRANSACTION_ATTRIBUTE_NAME                         VARCHAR2(100),
    TRANSACTION_ATTRIBUTE_ID                           NUMBER(18),
    CHARACTER_VALUE                                    VARCHAR2(2000),
    NUMBER_VALUE                                       NUMBER,
    DATE_VALUE                                         DATE,
    TIMESTAMP_VALUE                                    TIMESTAMP
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM
PROMPT

--
-- **************
-- ** Order Sales Credits Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM 
(
    FILE_SET_ID                                        VARCHAR2(30),
    MIGRATION_SET_ID                                   NUMBER,
    MIGRATION_SET_NAME                                 VARCHAR2(100),
    MIGRATION_STATUS                                   VARCHAR2(50),
    BATCH_NAME                                         VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                      VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                          VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                 VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER             VARCHAR2(50),
    SOURCE_TRANSACTION_SALES_CREDIT_IDENTIFIER         VARCHAR2(50),
    SALES_PERSON_IDENTIFIER                            NUMBER(18),
    SALES_PERSON                                       VARCHAR2(360),
    SALES_CREDIT_TYPE_CODE                             VARCHAR2(1000),
    SALES_CREDIT_TYPE_REFERENCE                        VARCHAR2(1000),
    PERCENT                                            NUMBER
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM
PROMPT

--
-- **************
-- ** Order Payments Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM (
    FILE_SET_ID                                         VARCHAR2(30),
    MIGRATION_SET_ID                                    NUMBER,
    MIGRATION_SET_NAME                                  VARCHAR2(100),
    MIGRATION_STATUS                                    VARCHAR2(50),
    BATCH_NAME                                          VARCHAR2(300),
    SOURCE_TRANSACTION_SYSTEM                            VARCHAR2(30),
    SOURCE_TRANSACTION_IDENTIFIER                        VARCHAR2(50),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER               VARCHAR2(50),
    PAYMENT_METHOD_CODE                                  VARCHAR2(1000),
    PAYMENT_METHOD                                       VARCHAR2(1000),
    PAYMENT_TRANSACTION_IDENTIFIER                       NUMBER(18),
    PAYMENT_SET_IDENTIFIER                               NUMBER(18),
    SOURCE_TRANSACTION_PAYMENT_IDENTIFIER                VARCHAR2(50),
    PAYMENT_TYPE                                         VARCHAR2(30),
    PAYMENT_TYPE_CODE                                    VARCHAR2(30),
    CREDIT_CARD_TOKEN_NUMBER                             VARCHAR2(30),
    CREDIT_CARD_EXPIRATION_DATE                          DATE,
    CREDIT_CARD_FIRST_NAME                               VARCHAR2(40),
    CREDIT_CARD_LAST_NAME                                VARCHAR2(40),
    CREDIT_CARD_ISSUER_CODE                             VARCHAR2(30),
    CREDIT_CARD_MASKED_NUMBER                            VARCHAR2(30),
    CREDIT_CARD_AUTHORIZATION_REQUEST_IDENTIFIER         VARCHAR2(30),
    CREDIT_CARD_VOICE_AUTHORIZATION_CODE                 VARCHAR2(100),
    PAYMENT_SERVER_ORDER_NUMBER                          VARCHAR2(80),
    AUTHORIZED_AMOUNT                                    NUMBER
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM
PROMPT

--
-- **************
-- ** Order Lot Serials Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM 
(
    FILE_SET_ID                                      VARCHAR2(30),
    MIGRATION_SET_ID                                 NUMBER,
    MIGRATION_SET_NAME                               VARCHAR2(100),
    MIGRATION_STATUS                                 VARCHAR2(50),
    BATCH_NAME                                       VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                    VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                        VARCHAR2(50),
    SOURCE_TRANSACTION_LINE_ID                       VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_ID                   VARCHAR2(50),
    SOURCE_TRANSACTION_LOT_ID                        VARCHAR2(50),
    LOT_NUMBER                                       VARCHAR2(320),
    SERIAL_NUMBER_FROM                               VARCHAR2(120),
    SERIAL_NUMBER_TO                                 VARCHAR2(120),
    ITEM_REVISION_NUMBER                             VARCHAR2(120),
    LOCATOR_ID                                       NUMBER(18),
    LOCATOR                                          VARCHAR2(2000),
    QUANTITY                                         NUMBER
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM
PROMPT

--
-- **************
-- ** Order Document References Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM 
(
    FILE_SET_ID                                      VARCHAR2(30),
    MIGRATION_SET_ID                                 NUMBER,
    MIGRATION_SET_NAME                               VARCHAR2(100),
    MIGRATION_STATUS                                 VARCHAR2(50),
    BATCH_NAME                                       VARCHAR2(300),
    SOURCE_TRANSACTION_LINE_IDENTIFIER               VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER           VARCHAR2(50),
    SOURCE_TRANSACTION_IDENTIFIER                    VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                        VARCHAR2(50),
    DOCUMENT_REFERENCE_TYPE                          VARCHAR2(30),
    DOCUMENT_IDENTIFIER                              VARCHAR2(50),
    DOCUMENT_SOURCE_SYSTEM                           VARCHAR2(50),
    DOCUMENT_NUMBER                                  VARCHAR2(150),
    DOCUMENT_ADDITIONAL_NUMBER                       VARCHAR2(150),
    DOCUMENT_LINE_IDENTIFIER                         VARCHAR2(50),
    DOCUMENT_ADDITIONAL_LINE_IDENTIFIER              VARCHAR2(50),
    DOCUMENT_LINE_NUMBER                             VARCHAR2(150),
    DOCUMENT_ADDITIONAL_LINE_NUMBER                  VARCHAR2(150),
    DOCUMENT_SUB_LINE_IDENTIFIER                     VARCHAR2(50),
    DOCUMENT_ADDITIONAL_SUB_LINE_IDENTIFIER          VARCHAR2(50),
    DOCUMENT_SUB_LINE_NUMBER                         VARCHAR2(150),
    DOCUMENT_ADDITIONAL_SUB_LINE_NUMBER              VARCHAR2(150)
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM
PROMPT

--
-- **************
-- ** Order Charges Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM 
(
    FILE_SET_ID                                         VARCHAR2(30),
    MIGRATION_SET_ID                                    NUMBER,
    MIGRATION_SET_NAME                                  VARCHAR2(100),
    MIGRATION_STATUS                                    VARCHAR2(50),
    BATCH_NAME                                          VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                        VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                            VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER               VARCHAR2(50),
    SOURCE_CHARGE_IDENTIFIER                             VARCHAR2(120),
    CHARGE_DEFINITION_CODE                               VARCHAR2(30),
    CHARGE_DEFINITION                                    VARCHAR2(80),
    CHARGE_TYPE_CODE                                    VARCHAR2(30),
    CHARGE_TYPE                                         VARCHAR2(80),
    CHARGE_SUBTYPE_CODE                                 VARCHAR2(30),
    CHARGE_SUBTYPE                                      VARCHAR2(80),
    SEQUENCE_NUMBER                                     NUMBER(9,0),
    PRICE_TYPE_CODE                                     VARCHAR2(30),
    PRICE_TYPE                                          VARCHAR2(240),
    PRICED_QUANTITY                                     NUMBER,
    PRICED_QUANTITY_UOM_CODE                            VARCHAR2(3),
    PRICED_QUANTITY_UOM                                 VARCHAR2(25),
    PRIMARY_FLAG                                        VARCHAR2(1),
    APPLY_TO                                            VARCHAR2(30),
    ROLLUP_FLAG                                         VARCHAR2(1),
    CHARGE_CURRENCY_CODE                                VARCHAR2(1000),
    CHARGE_CURRENCY_NAME                                VARCHAR2(1000),
    PRICE_PERIODICITY_CODE                              VARCHAR2(30),
    GSA_UNIT_PRICE                                      NUMBER,
    TRANSACTIONAL_CURRENCY_CODE                         VARCHAR2(1000),
    TRANSACTIONAL_UOM_CODE                              VARCHAR2(3),
    AVERAGE_UNIT_SELLING_PRICE                          NUMBER,
    TIER_APPLIES_TO_CODE                                VARCHAR2(30),
    TIER_APPLIES_TO_NAME                                VARCHAR2(30),
    BLOCK_ALLOWANCE                                     NUMBER,
    BLOCK_SIZE                                          NUMBER
);
--
--

PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM
PROMPT

--
-- **************
-- ** Order Charge Components Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM 
(
    FILE_SET_ID                                     VARCHAR2(30),
    MIGRATION_SET_ID                                NUMBER,
    MIGRATION_SET_NAME                              VARCHAR2(100),
    MIGRATION_STATUS                                VARCHAR2(50),
    BATCH_NAME                                      VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                       VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER              VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER          VARCHAR2(50),
    SOURCE_CHARGE_COMPONENT_IDENTIFIER              VARCHAR2(50),
    SEQUENCE_NUMBER                                 NUMBER(9,0),
    SOURCE_PARENT_CHARGE_COMP_IDENTIFIER            VARCHAR2(50),
    CHARGE_CURRENCY_CODE                            VARCHAR2(1000),
    CHARGE_CURRENCY_NAME                            VARCHAR2(1000),
    CHARGE_CURRENCY_EXTENDED_AMOUNT                 NUMBER,
    CHARGE_CURRENCY_UNIT_PRICE                      NUMBER,
    HEADER_CURRENCY_CODE                            VARCHAR2(1000),
    HEADER_CURRENCY_NAME                            VARCHAR2(1000),
    HEADER_CURRENCY_EXTENDED_AMOUNT                 NUMBER,
    HEADER_CURRENCY_UNIT_PRICE                      NUMBER,
    PRICE_ELEMENT_CODE                              VARCHAR2(30),
    PRICE_ELEMENT                                   VARCHAR2(240),
    PRICE_ELEMENT_USAGE_CODE                        VARCHAR2(30),
    PRICE_ELEMENT_USAGE                             VARCHAR2(240),
    ROLLUP_FLAG                                     VARCHAR2(1),
    TRANSACTIONAL_CURRENCY_CODE                     VARCHAR2(1000),
    EXPLANATION                                     VARCHAR2(1000),
    SOURCE_MANUAL_PRICE_ADJUSTMENT_IDENTIFIER       VARCHAR2(50),
    DURATION_CHARGE_TOTAL                           NUMBER,
    DURATION_HEADER_TOTAL                           NUMBER
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM
PROMPT

--
-- **************
-- ** Order Billing Plans Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM 
(
    FILE_SET_ID                                     VARCHAR2(30),
    MIGRATION_SET_ID                                NUMBER,
    MIGRATION_SET_NAME                              VARCHAR2(100),
    MIGRATION_STATUS                                VARCHAR2(50),
    BATCH_NAME                                      VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                       VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER              VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER          VARCHAR2(50),
    BILLING_PLAN_TYPE_CODE                          VARCHAR2(30),
    PERIODICITY_CODE                                VARCHAR2(30),
    NUMBER_OF_BILLING_PERIODS                       NUMBER(9,0),
    BILLING_PERIOD_START_DATE                       DATE,
    BILLING_PERIOD_END_DATE                         DATE,
    BILLING_TRANSACTION_DATE                        DATE,
    BILLING_PERIOD_NUMBER                           NUMBER(9,0),
    OVERRIDE_PERIOD                                 NUMBER(9,0),
    OVERRIDE_PERIOD_QUANTITY                        NUMBER,
    OVERRIDE_PERIOD_AMOUNT                          NUMBER,
    CANCELLATION_EFFECTIVE_DATE                     DATE,
    SOURCE_BILLING_PLAN_IDENTIFIER                  VARCHAR2(50)
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM
PROMPT

--
-- **************
-- ** Order Manual Price Adjustment Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM 
(
    FILE_SET_ID                                        VARCHAR2(30),
    MIGRATION_SET_ID                                   NUMBER,
    MIGRATION_SET_NAME                                 VARCHAR2(100),
    MIGRATION_STATUS                                   VARCHAR2(50),
    BATCH_NAME                                         VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                      VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                          VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                 VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER             VARCHAR2(50),
    ADJUSTMENT_AMOUNT                                  NUMBER,
    ADJUSTMENT_TYPE_CODE                               VARCHAR2(30),
    ADJUSTMENT_TYPE                                    VARCHAR2(30),
    ADJUSTMENT_ELEMENT_BASIS_CODE                      VARCHAR2(30),
    ADJUSTMENT_ELEMENT_BASIS                           VARCHAR2(30),
    REASON_CODE                                        VARCHAR2(30),
    REASON                                             VARCHAR2(30),
    COMMENTS                                           VARCHAR2(1000),
    SEQUENCE                                           NUMBER(9),
    CHARGE_DEFINITION_CODE                             VARCHAR2(30),
    CHARGE_DEFINITION                                  VARCHAR2(30),
    PRICE_PERIODICITY_CODE                             VARCHAR2(30),
    PRICE_PERIODICITY                                  VARCHAR2(30),
    CHARGE_ROLLUP_FLAG                                 VARCHAR2(1),
    SOURCE_MANUAL_PRICE_ADJ_IDENTIFIER                 VARCHAR2(50),
    EFFECTIVITY_TYPE_CODE                              VARCHAR2(30),
    EFFECTIVITY_TYPE                                   VARCHAR2(80),
    PERIOD_FROM                                        NUMBER,
    PERIOD_UNTIL                                       NUMBER,
    NUMBER_OF_PERIODS                                  NUMBER
);

--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM
PROMPT

--
-- **************
-- ** Order Header Extensible Flexfields Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM 
(
    FILE_SET_ID                                       VARCHAR2(30),
    MIGRATION_SET_ID                                  NUMBER,
    MIGRATION_SET_NAME                                VARCHAR2(100),
    MIGRATION_STATUS                                  VARCHAR2(50),
    BATCH_NAME                                        VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                     VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                         VARCHAR2(30),
    CONTEXT_CODE                                      VARCHAR2(80),
    ATTRIBUTE_CHAR1                                   VARCHAR2(150),
    ATTRIBUTE_CHAR2                                   VARCHAR2(150),
    ATTRIBUTE_CHAR3                                   VARCHAR2(150),
    ATTRIBUTE_CHAR4                                   VARCHAR2(150),
    ATTRIBUTE_CHAR5                                   VARCHAR2(150),
    ATTRIBUTE_CHAR6                                   VARCHAR2(150),
    ATTRIBUTE_CHAR7                                   VARCHAR2(150),
    ATTRIBUTE_CHAR8                                   VARCHAR2(150),
    ATTRIBUTE_CHAR9                                   VARCHAR2(150),
    ATTRIBUTE_CHAR10                                  VARCHAR2(150),
    ATTRIBUTE_CHAR11                                  VARCHAR2(150),
    ATTRIBUTE_CHAR12                                  VARCHAR2(150),
    ATTRIBUTE_CHAR13                                  VARCHAR2(150),
    ATTRIBUTE_CHAR14                                  VARCHAR2(150),
    ATTRIBUTE_CHAR15                                  VARCHAR2(150),
    ATTRIBUTE_CHAR16                                  VARCHAR2(150),
    ATTRIBUTE_CHAR17                                  VARCHAR2(150),
    ATTRIBUTE_CHAR18                                  VARCHAR2(150),
    ATTRIBUTE_CHAR19                                  VARCHAR2(150),
    ATTRIBUTE_CHAR20                                  VARCHAR2(150),
    ATTRIBUTE_NUMBER1                                 NUMBER,
    ATTRIBUTE_NUMBER2                                 NUMBER,
    ATTRIBUTE_NUMBER3                                 NUMBER,
    ATTRIBUTE_NUMBER4                                 NUMBER,
    ATTRIBUTE_NUMBER5                                 NUMBER,
    ATTRIBUTE_NUMBER6                                 NUMBER,
    ATTRIBUTE_NUMBER7                                 NUMBER,
    ATTRIBUTE_NUMBER8                                 NUMBER,
    ATTRIBUTE_NUMBER9                                 NUMBER,
    ATTRIBUTE_NUMBER10                                NUMBER,
    ATTRIBUTE_DATE1                                   DATE,
    ATTRIBUTE_DATE2                                   DATE,
    ATTRIBUTE_DATE3                                   DATE,
    ATTRIBUTE_DATE4                                   DATE,
    ATTRIBUTE_DATE5                                   DATE,
    ATTRIBUTE_TIMESTAMP1                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5                              TIMESTAMP
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM
PROMPT

--
-- **************
-- ** Order Line Extensible Flexfields Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM 
(
    FILE_SET_ID                                       VARCHAR2(30),
    MIGRATION_SET_ID                                  NUMBER,
    MIGRATION_SET_NAME                                VARCHAR2(100),
    MIGRATION_STATUS                                  VARCHAR2(50),
    BATCH_NAME                                        VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                     VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                         VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_ID                        VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_ID                    VARCHAR2(50),
    CONTEXT_CODE                                      VARCHAR2(80),
    ATTRIBUTE_CHAR1                                   VARCHAR2(150),
    ATTRIBUTE_CHAR2                                   VARCHAR2(150),
    ATTRIBUTE_CHAR3                                   VARCHAR2(150),
    ATTRIBUTE_CHAR4                                   VARCHAR2(150),
    ATTRIBUTE_CHAR5                                   VARCHAR2(150),
    ATTRIBUTE_CHAR6                                   VARCHAR2(150),
    ATTRIBUTE_CHAR7                                   VARCHAR2(150),
    ATTRIBUTE_CHAR8                                   VARCHAR2(150),
    ATTRIBUTE_CHAR9                                   VARCHAR2(150),
    ATTRIBUTE_CHAR10                                  VARCHAR2(150),
    ATTRIBUTE_CHAR11                                  VARCHAR2(150),
    ATTRIBUTE_CHAR12                                  VARCHAR2(150),
    ATTRIBUTE_CHAR13                                  VARCHAR2(150),
    ATTRIBUTE_CHAR14                                  VARCHAR2(150),
    ATTRIBUTE_CHAR15                                  VARCHAR2(150),
    ATTRIBUTE_CHAR16                                  VARCHAR2(150),
    ATTRIBUTE_CHAR17                                  VARCHAR2(150),
    ATTRIBUTE_CHAR18                                  VARCHAR2(150),
    ATTRIBUTE_CHAR19                                  VARCHAR2(150),
    ATTRIBUTE_CHAR20                                  VARCHAR2(150),
    ATTRIBUTE_NUMBER1                                 NUMBER,
    ATTRIBUTE_NUMBER2                                 NUMBER,
    ATTRIBUTE_NUMBER3                                 NUMBER,
    ATTRIBUTE_NUMBER4                                 NUMBER,
    ATTRIBUTE_NUMBER5                                 NUMBER,
    ATTRIBUTE_NUMBER6                                 NUMBER,
    ATTRIBUTE_NUMBER7                                 NUMBER,
    ATTRIBUTE_NUMBER8                                 NUMBER,
    ATTRIBUTE_NUMBER9                                 NUMBER,
    ATTRIBUTE_NUMBER10                                NUMBER,
    ATTRIBUTE_DATE1                                   DATE,
    ATTRIBUTE_DATE2                                   DATE,
    ATTRIBUTE_DATE3                                   DATE,
    ATTRIBUTE_DATE4                                   DATE,
    ATTRIBUTE_DATE5                                   DATE,
    ATTRIBUTE_TIMESTAMP1                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4                              TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5                              TIMESTAMP
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_PROJECTS_INT_XFM
PROMPT

--
-- **************
-- ** Order Line Projects Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_PROJECTS_INT_XFM 
(
    FILE_SET_ID                                       VARCHAR2(30),
    MIGRATION_SET_ID                                  NUMBER,
    MIGRATION_SET_NAME                                VARCHAR2(100),
    MIGRATION_STATUS                                  VARCHAR2(50),
    BATCH_NAME                                        VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                     VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                         VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER                VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER            VARCHAR2(50),
    PROJECT_NUMBER                                    VARCHAR2(25),
    PROJECT_NAME                                      VARCHAR2(240),
    PROJECT_ID                                        NUMBER(18),
    TASK_NUMBER                                       VARCHAR2(100),
    TASK_NAME                                         VARCHAR2(255),
    TASK_ID                                           NUMBER(18),
    EXPENDITURE_ITEM_DATE                             DATE,
    EXPENDITURE_TYPE                                  VARCHAR2(240),
    EXPENDITURE_TYPE_ID                               NUMBER(18),
    EXPENDITURE_ORGANIZATION                          VARCHAR2(240),
    EXPENDITURE_ORGANIZATION_ID                       NUMBER(18),
    CONTRACT_NUMBER                                   VARCHAR2(240),
    CONTRACT_ID                                       NUMBER(18),
    FUNDING_SOURCE_NUMBER                             VARCHAR2(240),
    FUNDING_SOURCE_ID                                 VARCHAR2(150),
    BILLABLE_FLAG                                     VARCHAR2(1),
    CAPITALIZABLE_FLAG                                VARCHAR2(1),
    CONTRACT_LINE_ID                                  NUMBER(18, 0),
    WORK_TYPE                                         VARCHAR2(240),
    WORK_TYPE_ID                                      NUMBER(18, 0),
    FUNDING_ALLOCATION_ID                             NUMBER(18, 0),
    USER_DEFINED_ATTRIBUTE_1                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_2                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_3                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_4                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_5                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_6                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_7                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_8                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_9                          VARCHAR2(150),
    USER_DEFINED_ATTRIBUTE_10                         VARCHAR2(150),
    RESERVED_ATTRIBUTE_2                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_3                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_4                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_5                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_6                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_7                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_8                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_9                              VARCHAR2(150),
    RESERVED_ATTRIBUTE_10                             VARCHAR2(150)
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_TERMS_INT_XFM
PROMPT

--
-- **************
-- ** Order Terms Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_TERMS_INT_XFM 
(
    FILE_SET_ID                                     VARCHAR2(30),
    MIGRATION_SET_ID                                NUMBER,
    MIGRATION_SET_NAME                              VARCHAR2(100),
    MIGRATION_STATUS                                VARCHAR2(50),
    BATCH_NAME                                      VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                       VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER              VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER          VARCHAR2(50),
    SOURCE_ORDER_TERM_IDENTIFIER                    VARCHAR2(50),
    TERM_START_DATE                                 TIMESTAMP (6),
    TERM_END_DATE                                   TIMESTAMP (6),
    TERM_PERIOD                                     VARCHAR2 (15),
    TERM_PERIOD_NAME                                VARCHAR2 (25),
    TERM_DURATION                                   NUMBER,
    TERM_APPLICATION_METHOD_CODE                    VARCHAR2 (30),
    TERM_APPLICATION_METHOD_NAME                    VARCHAR2 (80),
    TERM_APPLICATION_VALUE_PERCENT                  NUMBER
);
--
--
PROMPT
PROMPT CREATING TABLE XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM
PROMPT

--
-- **************
-- ** Order Charge Tiers Import
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM 
(
    FILE_SET_ID                                     VARCHAR2(30),
    MIGRATION_SET_ID                                NUMBER,
    MIGRATION_SET_NAME                              VARCHAR2(100),
    MIGRATION_STATUS                                VARCHAR2(50),
    BATCH_NAME                                      VARCHAR2(300),
    SOURCE_TRANSACTION_IDENTIFIER                   VARCHAR2(50),
    SOURCE_TRANSACTION_SYSTEM                       VARCHAR2(30),
    SOURCE_TRANSACTION_LINE_IDENTIFIER              VARCHAR2(50),
    SOURCE_TRANSACTION_SCHEDULE_IDENTIFIER          VARCHAR2(50),
    SOURCE_CHARGE_IDENTIFIER                        VARCHAR2(120),
    SOURCE_ORDER_CHARGE_TIER_IDENTIFIER             VARCHAR2(50),
    TIER_SEQUENCE_NUMBER                            NUMBER,
    APPLICATION_METHOD_CODE                         VARCHAR2(30),
    APPLICATION_METHOD                              VARCHAR2(80),
    TIER_FROM                                       NUMBER,
    TIER_TO                                         NUMBER,
    BLOCK_SIZE                                      NUMBER,
    ADJUSTMENT_AMOUNT                               NUMBER
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
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_PROJECTS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_PROJECTS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_TERMS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_TERMS_INT_XFM;
--
CREATE OR REPLACE PUBLIC SYNONYM XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM for XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM;
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
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_ADDRESSES_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_PAYMENTS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGES_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_PROJECTS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_TERMS_INT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_XFM TO XXMX_CORE;
--
--
--
PROMPT
PROMPT
PROMPT ***********************************************************************************
PROMPT **
PROMPT ** Completed Installing Database Objects for Cloudbridge Sales Orders Data Migration
PROMPT **
PROMPT ***********************************************************************************
PROMPT
PROMPT
--
--
