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
--** FILENAME  :  xxmx_scm_po_xfm_dbi.sql
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
--** PURPOSE   :  This script installs the XXMX_XFM DB Objects for the Maximise
--**              Purchase Orders Data Migration.
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
--**   1.0  07-OCT-2021  Shaik Latheef  	 Created Purchase Orders XFM tables for Maximise.
--**   1.1  08-NOV-2021  Shaik Latheef  	 Renamed Purchase Orders XFM tables and added few attributes.
--**   1.2  12-NOV-2021  Shaik Latheef  	 Renamed Purchase Orders Filename and added few attributes.
--**   1.3  16-NOV-2021  Shaik Latheef  	 Added BPA and CPA tables.
--**
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
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise PO Data Migration
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
PROMPT Dropping Table XXMX_SCM_PO_HEADERS_STD_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_HEADERS_STD_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_LINES_STD_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_LINES_STD_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_HEADERS_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_HEADERS_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_LINES_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_LINES_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_ATTR_VALUES_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_ATTR_VALUES_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_HEADERS_CPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_HEADERS_CPA_XFM;
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM
PROMPT
--
DROP TABLE XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM;
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
PROMPT Creating Table XXMX_SCM_PO_HEADERS_STD_XFM
PROMPT
--

--Migration_set_id is generated in the maximise Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- **********************
-- **STD PO Headers Table
-- **********************
CREATE TABLE XXMX_SCM_PO_HEADERS_STD_XFM
	(
	FILE_SET_ID								VARCHAR2(30),
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	INTERFACE_HEADER_KEY					VARCHAR2(50),
	ACTION									VARCHAR2(25),
	BATCH_ID								NUMBER,
	INTERFACE_SOURCE_CODE					VARCHAR2(25),
	APPROVAL_ACTION							VARCHAR2(25),
	DOCUMENT_NUM							VARCHAR2(30),
	DOCUMENT_TYPE_CODE						VARCHAR2(25),
	STYLE_DISPLAY_NAME						VARCHAR2(240),
	PRC_BU_NAME								VARCHAR2(240),
	REQ_BU_NAME								VARCHAR2(240),
	SOLDTO_LE_NAME							VARCHAR2(240),
	BILLTO_BU_NAME							VARCHAR2(240),
	AGENT_NAME								VARCHAR2(2000),
	CURRENCY_CODE							VARCHAR2(15),
	RATE									NUMBER,
	RATE_TYPE								VARCHAR2(30),
	RATE_DATE								DATE,
	COMMENTS								VARCHAR2(240),
	BILL_TO_LOCATION						VARCHAR2(60),
	SHIP_TO_LOCATION						VARCHAR2(60),
	VENDOR_NAME								VARCHAR2(360),
	VENDOR_NUM								VARCHAR2(30),
	VENDOR_SITE_CODE						VARCHAR2(15),
	VENDOR_CONTACT							VARCHAR2(360),
	VENDOR_DOC_NUM							VARCHAR2(25),
	FOB										VARCHAR2(30),
	FREIGHT_CARRIER							VARCHAR2(360),
	FREIGHT_TERMS							VARCHAR2(30),
	PAY_ON_CODE								VARCHAR2(25),
	PAYMENT_TERMS							VARCHAR2(50),
	ORIGINATOR_ROLE							VARCHAR2(25),
	CHANGE_ORDER_DESC						VARCHAR2(2000),
	ACCEPTANCE_REQUIRED_FLAG				VARCHAR2(1),
	ACCEPTANCE_WITHIN_DAYS					NUMBER,
	SUPPLIER_NOTIF_METHOD					VARCHAR2(25),
	FAX										VARCHAR2(60),
	EMAIL_ADDRESS							VARCHAR2(2000),
	CONFIRMING_ORDER_FLAG					VARCHAR2(1),
	NOTE_TO_VENDOR							VARCHAR2(1000),
	NOTE_TO_RECEIVER						VARCHAR2(1000),
	DEFAULT_TAXATION_COUNTRY				VARCHAR2(2),
	TAX_DOCUMENT_SUBTYPE					VARCHAR2(240),
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
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6),
	AGENT_EMAIL_ADDRESS						VARCHAR2(240),
	MODE_OF_TRANSPORT						VARCHAR2(30),
	SERVICE_LEVEL							VARCHAR2(80),
	FIRST_PTY_REG_NUM						VARCHAR2(50),
	THIRD_PTY_REG_NUM						VARCHAR2(50),
	BUYER_MANAGED_TRANSPORT_FLAG			VARCHAR2(1),
	MASTER_CONTRACT_NUMBER					VARCHAR2(120),
	MASTER_CONTRACT_TYPE					VARCHAR2(150),
	CC_EMAIL_ADDRESS						VARCHAR2(2000),
	BCC_EMAIL_ADDRESS						VARCHAR2(2000),
	PO_HEADER_ID							VARCHAR2(30)
    );
	
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINES_STD_XFM
PROMPT
--

-- ********************
-- **STD PO Lines Table
-- ********************
CREATE TABLE  XXMX_SCM_PO_LINES_STD_XFM
    (
	FILE_SET_ID								VARCHAR2(30),	
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
    INTERFACE_LINE_KEY						VARCHAR2(50),
	INTERFACE_HEADER_KEY					VARCHAR2(50),
	ACTION									VARCHAR2(25),
	LINE_NUM								NUMBER,
	LINE_TYPE								VARCHAR2(30),
	ITEM									VARCHAR2(300),
	ITEM_DESCRIPTION						VARCHAR2(240),
	ITEM_REVISION							VARCHAR2(18),
	CATEGORY								VARCHAR2(2000),
	AMOUNT									NUMBER,
	QUANTITY								NUMBER,
	UNIT_OF_MEASURE							VARCHAR2(25),
	UNIT_PRICE								NUMBER,
	SECONDARY_QUANTITY						NUMBER,
	SECONDARY_UNIT_OF_MEASURE				VARCHAR2(18),
	VENDOR_PRODUCT_NUM						VARCHAR2(25),
	NEGOTIATED_BY_PREPARER_FLAG				VARCHAR2(1),
	HAZARD_CLASS							VARCHAR2(40),
	UN_NUMBER								VARCHAR2(25),
	NOTE_TO_VENDOR							VARCHAR2(1000),
	NOTE_TO_RECEIVER						VARCHAR2(1000),
	LINE_ATTRIBUTE_CATEGORY_LINES			VARCHAR2(30),
	LINE_ATTRIBUTE1							VARCHAR2(150),
	LINE_ATTRIBUTE2							VARCHAR2(150),
	LINE_ATTRIBUTE3							VARCHAR2(150),
	LINE_ATTRIBUTE4							VARCHAR2(150),
	LINE_ATTRIBUTE5							VARCHAR2(150),
	LINE_ATTRIBUTE6							VARCHAR2(150),
	LINE_ATTRIBUTE7							VARCHAR2(150),
	LINE_ATTRIBUTE8							VARCHAR2(150),
	LINE_ATTRIBUTE9							VARCHAR2(150),
	LINE_ATTRIBUTE10						VARCHAR2(150),
	LINE_ATTRIBUTE11						VARCHAR2(150),
	LINE_ATTRIBUTE12						VARCHAR2(150),
	LINE_ATTRIBUTE13						VARCHAR2(150),
	LINE_ATTRIBUTE14						VARCHAR2(150),
	LINE_ATTRIBUTE15						VARCHAR2(150),
	LINE_ATTRIBUTE16						VARCHAR2(150),
	LINE_ATTRIBUTE17						VARCHAR2(150),
	LINE_ATTRIBUTE18						VARCHAR2(150),
	LINE_ATTRIBUTE19						VARCHAR2(150),
	LINE_ATTRIBUTE20						VARCHAR2(150),
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
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6),
	UNIT_WEIGHT								NUMBER,
	WEIGHT_UOM_CODE							VARCHAR2(3),
	WEIGHT_UNIT_OF_MEASURE					VARCHAR2(25),
	UNIT_VOLUME								NUMBER,
	VOLUME_UOM_CODE							VARCHAR2(3),
	VOLUME_UNIT_OF_MEASURE					VARCHAR2(25),
	TEMPLATE_NAME							VARCHAR2(30),
	ITEM_ATTRIBUTE_CATEGORY					VARCHAR2(30),
	ITEM_ATTRIBUTE1							VARCHAR2(150),
	ITEM_ATTRIBUTE2							VARCHAR2(150),
	ITEM_ATTRIBUTE3							VARCHAR2(150),
	ITEM_ATTRIBUTE4							VARCHAR2(150),
	ITEM_ATTRIBUTE5							VARCHAR2(150),
	ITEM_ATTRIBUTE6							VARCHAR2(150),
	ITEM_ATTRIBUTE7							VARCHAR2(150),
	ITEM_ATTRIBUTE8							VARCHAR2(150),
	ITEM_ATTRIBUTE9							VARCHAR2(150),
	ITEM_ATTRIBUTE10						VARCHAR2(150),
	ITEM_ATTRIBUTE11						VARCHAR2(150),
	ITEM_ATTRIBUTE12						VARCHAR2(150),
	ITEM_ATTRIBUTE13						VARCHAR2(150),
	ITEM_ATTRIBUTE14						VARCHAR2(150),
	ITEM_ATTRIBUTE15						VARCHAR2(150),
	SOURCE_AGREEMENT_PRC_BU_NAME			VARCHAR2(240),
	SOURCE_AGREEMENT						VARCHAR2(30),
	SOURCE_AGREEMENT_LINE					NUMBER,
	DISCOUNT_TYPE							VARCHAR2(25),
	DISCOUNT								NUMBER,
	DISCOUNT_REASON							VARCHAR2(240),
	MAX_RETAINAGE_AMOUNT					NUMBER,
	PO_HEADER_ID							VARCHAR2(30),
	PO_LINE_ID								VARCHAR2(30)
    );
	
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM
PROMPT
--
	 
-- *****************************
-- **STD PO Line Locations Table
-- *****************************
CREATE TABLE  XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM
    (
	FILE_SET_ID								VARCHAR2(30),	
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
	INTERFACE_LINE_LOCATION_KEY				VARCHAR2(50),
	INTERFACE_LINE_KEY						VARCHAR2(50),
	SHIPMENT_NUM							NUMBER,
	SHIP_TO_LOCATION						VARCHAR2(60),
	SHIP_TO_ORGANIZATION_CODE				VARCHAR2(18),
	AMOUNT									NUMBER,
	QUANTITY								NUMBER,
	NEED_BY_DATE							DATE,
	PROMISED_DATE							DATE,
	SECONDARY_QUANTITY						NUMBER,
	SECONDARY_UNIT_OF_MEASURE				VARCHAR2(18),
	DESTINATION_TYPE_CODE					VARCHAR2(25),
	ACCRUE_ON_RECEIPT_FLAG					VARCHAR2(1),
	ALLOW_SUBSTITUTE_RECEIPTS_FLAG			VARCHAR2(1),
	ASSESSABLE_VALUE						NUMBER,
	DAYS_EARLY_RECEIPT_ALLOWED				NUMBER,
	DAYS_LATE_RECEIPT_ALLOWED				NUMBER,
	ENFORCE_SHIP_TO_LOCATION_CODE			VARCHAR2(25),
	INSPECTION_REQUIRED_FLAG				VARCHAR2(1),
	RECEIPT_REQUIRED_FLAG					VARCHAR2(1),
	INVOICE_CLOSE_TOLERANCE					NUMBER,
	RECEIPT_CLOSE_TOLERANCE					NUMBER,
	QTY_RCV_TOLERANCE						NUMBER,
	QTY_RCV_EXCEPTION_CODE					VARCHAR2(25),
	RECEIPT_DAYS_EXCEPTION_CODE				VARCHAR2(25),
	RECEIVING_ROUTING						VARCHAR2(30),
	NOTE_TO_RECEIVER						VARCHAR2(1000),
	INPUT_TAX_CLASSIFICATION_CODE			VARCHAR2(30),
	LINE_INTENDED_USE						VARCHAR2(240),
	PRODUCT_CATEGORY						VARCHAR2(240),
	PRODUCT_FISC_CLASSIFICATION 			VARCHAR2(240),
	PRODUCT_TYPE							VARCHAR2(240),
	TRX_BUSINESS_CATEGORY_CODE				VARCHAR2(240),
	USER_DEFINED_FISC_CLASS					VARCHAR2(30),
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
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6),
	FREIGHT_CARRIER							VARCHAR2(360),
	MODE_OF_TRANSPORT						VARCHAR2(80),
	SERVICE_LEVEL							VARCHAR2(80),
	FINAL_DISCHARGE_LOCATION_CODE			VARCHAR2(60),
	REQUESTED_SHIP_DATE						DATE,
	PROMISED_SHIP_DATE						DATE,
	REQUESTED_DELIVERY_DATE					DATE,
	PROMISED_DELIVERY_DATE					DATE,
	RETAINAGE_RATE							NUMBER,
	INVOICE_MATCH_OPTION					VARCHAR2(25),
	PO_HEADER_ID							VARCHAR2(30),
	PO_LINE_ID								VARCHAR2(30),
	LINE_LOCATION_ID						VARCHAR2(30)
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM
PROMPT
--	
	 
-- ****************************
-- **STD PO Distributions Table
-- ****************************
CREATE TABLE  XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM
    (
	FILE_SET_ID								VARCHAR2(30),	
	MIGRATION_SET_ID                		NUMBER,
	MIGRATION_SET_NAME              		VARCHAR2(100),
	MIGRATION_STATUS               			VARCHAR2(50),
   	INTERFACE_DISTRIBUTION_KEY				VARCHAR2(50),
	INTERFACE_LINE_LOCATION_KEY				VARCHAR2(50),
	DISTRIBUTION_NUM						NUMBER,
	DELIVER_TO_LOCATION						VARCHAR2(60),
	DELIVER_TO_PERSON_FULL_NAME				VARCHAR2(2000),
	DESTINATION_SUBINVENTORY				VARCHAR2(10),
	AMOUNT_ORDERED							NUMBER,
	QUANTITY_ORDERED						NUMBER,
	CHARGE_ACCOUNT_SEGMENT1					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT2					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT3					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT4					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT5					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT6					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT7					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT8					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT9					VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT10				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT11				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT12				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT13				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT14				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT15				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT16				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT17				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT18				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT19				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT20				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT21				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT22				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT23				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT24				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT25				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT26				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT27				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT28				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT29				VARCHAR2(25),
	CHARGE_ACCOUNT_SEGMENT30				VARCHAR2(25),
	DESTINATION_CONTEXT						VARCHAR2(30),
	PROJECT									VARCHAR2(240),
	TASK									VARCHAR2(100),
	PJC_EXPENDITURE_ITEM_DATE				DATE,
	EXPENDITURE_TYPE						VARCHAR2(240),
	EXPENDITURE_ORGANIZATION				VARCHAR2(240),
	PJC_BILLABLE_FLAG						VARCHAR2(1),
	PJC_CAPITALIZABLE_FLAG					VARCHAR2(1),
	PJC_WORK_TYPE							VARCHAR2(240),
	PJC_RESERVED_ATTRIBUTE1					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE2					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE3					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE4					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE5					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE6					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE7					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE8					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE9					VARCHAR2(150),
	PJC_RESERVED_ATTRIBUTE10				VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE1					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE2					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE3					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE4					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE5					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE6					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE7					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE8					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE9					VARCHAR2(150),
	PJC_USER_DEF_ATTRIBUTE10				VARCHAR2(150),
	RATE									NUMBER,
	RATE_DATE								DATE,
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
	ATTRIBUTE_TIMESTAMP10					TIMESTAMP(6),
	DELIVER_TO_PERSON_EMAIL_ADDR			VARCHAR2(240),
	BUDGET_DATE								DATE,
	PJC_CONTRACT_NUMBER						VARCHAR2(120),
	PJC_FUNDING_SOURCE						VARCHAR2(360),
	PO_HEADER_ID							VARCHAR2(30),
	PO_LINE_ID								VARCHAR2(30),
	LINE_LOCATION_ID						VARCHAR2(30),
	PO_DISTRIBUTION_ID						VARCHAR2(30)
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_HEADERS_BPA_XFM
PROMPT
--	
	
-- **********************
-- **BPA PO Headers Table
-- **********************
CREATE TABLE XXMX_SCM_PO_HEADERS_BPA_XFM
	(
	FILE_SET_ID										VARCHAR2(30),
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_HEADER_KEY							VARCHAR2(50),
	ACTION											VARCHAR2(25),
	BATCH_ID										NUMBER,
	INTERFACE_SOURCE_CODE							VARCHAR2(25),
	APPROVAL_ACTION									VARCHAR2(25),
	DOCUMENT_NUM									VARCHAR2(30),
	DOCUMENT_TYPE_CODE								VARCHAR2(25),
	STYLE_DISPLAY_NAME								VARCHAR2(240),
	PRC_BU_NAME										VARCHAR2(240),
	AGENT_NAME										VARCHAR2(2000),
	CURRENCY_CODE									VARCHAR2(15),
	COMMENTS 										VARCHAR2(240),
	VENDOR_NAME										VARCHAR2(360),
	VENDOR_NUM										VARCHAR2(30),
	VENDOR_SITE_CODE								VARCHAR2(15),
	VENDOR_CONTACT									VARCHAR2(360),
	VENDOR_DOC_NUM									VARCHAR2(25),
	FOB												VARCHAR2(30),
	FREIGHT_CARRIER									VARCHAR2(360),
	FREIGHT_TERMS									VARCHAR2(30),
	PAY_ON_CODE										VARCHAR2(25),
	PAYMENT_TERMS									VARCHAR2(50),
	ORIGINATOR_ROLE									VARCHAR2(25),
	CHANGE_ORDER_DESC								VARCHAR2(2000),
	ACCEPTANCE_REQUIRED_FLAG						VARCHAR2(1),
	ACCEPTANCE_WITHIN_DAYS							NUMBER,
	SUPPLIER_NOTIF_METHOD							VARCHAR2(25),
	FAX												VARCHAR2(60),
	EMAIL_ADDRESS									VARCHAR2(2000),
	CONFIRMING_ORDER_FLAG							VARCHAR2(1),
	AMOUNT_AGREED 									NUMBER,
	AMOUNT_LIMIT 									NUMBER,
	MIN_RELEASE_AMOUNT 								NUMBER,
	EFFECTIVE_DATE									DATE,
	EXPIRATION_DATE 								DATE,
	NOTE_TO_VENDOR 									VARCHAR2(1000),
	NOTE_TO_RECEIVER 								VARCHAR2(1000),
	GENERATE_ORDERS_AUTOMATIC 						VARCHAR2(1),
	SUBMIT_APPROVAL_AUTOMATIC						VARCHAR2(1),
	GROUP_REQUISITIONS								VARCHAR2(1),
	GROUP_REQUISITION_LINES							VARCHAR2(1),
	USE_SHIP_TO										VARCHAR2(1),
	USE_NEED_BY_DATE								VARCHAR2(1),
	CAT_ADMIN_AUTH_ENABLED_FLAG						VARCHAR2(1),
	RETRO_PRICE_APPLY_UPDATES_FLAG					VARCHAR2(1),
	RETRO_PRICE_COMM_UPDATES_FLAG					VARCHAR2(1),
	ATTRIBUTE_CATEGORY								VARCHAR2(30),
	ATTRIBUTE1										VARCHAR2(150),
	ATTRIBUTE2										VARCHAR2(150),
	ATTRIBUTE3										VARCHAR2(150),
	ATTRIBUTE4										VARCHAR2(150),
	ATTRIBUTE5										VARCHAR2(150),
	ATTRIBUTE6										VARCHAR2(150),
	ATTRIBUTE7										VARCHAR2(150),
	ATTRIBUTE8										VARCHAR2(150),
	ATTRIBUTE9										VARCHAR2(150),
	ATTRIBUTE10										VARCHAR2(150),
	ATTRIBUTE11										VARCHAR2(150),
	ATTRIBUTE12										VARCHAR2(150),
	ATTRIBUTE13										VARCHAR2(150),
	ATTRIBUTE14										VARCHAR2(150),
	ATTRIBUTE15										VARCHAR2(150),
	ATTRIBUTE16										VARCHAR2(150),
	ATTRIBUTE17										VARCHAR2(150),
	ATTRIBUTE18										VARCHAR2(150),
	ATTRIBUTE19										VARCHAR2(150),
	ATTRIBUTE20										VARCHAR2(150),
	ATTRIBUTE_DATE1									DATE,
	ATTRIBUTE_DATE2									DATE,
	ATTRIBUTE_DATE3									DATE,
	ATTRIBUTE_DATE4									DATE,
	ATTRIBUTE_DATE5									DATE,
	ATTRIBUTE_DATE6									DATE,
	ATTRIBUTE_DATE7									DATE,
	ATTRIBUTE_DATE8									DATE,
	ATTRIBUTE_DATE9									DATE,
	ATTRIBUTE_DATE10								DATE,
	ATTRIBUTE_NUMBER1								NUMBER(18),
	ATTRIBUTE_NUMBER2								NUMBER(18),
	ATTRIBUTE_NUMBER3								NUMBER(18),
	ATTRIBUTE_NUMBER4								NUMBER(18),
	ATTRIBUTE_NUMBER5								NUMBER(18),
	ATTRIBUTE_NUMBER6								NUMBER(18),
	ATTRIBUTE_NUMBER7								NUMBER(18),
	ATTRIBUTE_NUMBER8								NUMBER(18),
	ATTRIBUTE_NUMBER9								NUMBER(18),
	ATTRIBUTE_NUMBER10								NUMBER(18),
	ATTRIBUTE_TIMESTAMP1							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10							TIMESTAMP(6),	
	AGENT_EMAIL_ADDRESS								VARCHAR2(240),
	MODE_OF_TRANSPORT								VARCHAR2(80),
	SERVICE_LEVEL									VARCHAR2(80),
	AGING_PERIOD_DAYS								NUMBER(5),
	AGING_ONSET_POINT								VARCHAR2(30),
	CONSUMPTION_ADVICE_FREQUENCY					VARCHAR2(30),
	CONSUMPTION_ADVICE_SUMMARY						VARCHAR2(30),
	DEFAULT_CONSIGNMENT_LINE_FLAG					VARCHAR2(1),
	PAY_ON_USE_FLAG 								VARCHAR2(1),
	BILLING_CYCLE_CLOSING_DATE						DATE,
	CONFIGURED_ITEM_FLAG							VARCHAR2(1),
	USE_SALES_ORDER_NUMBER_FLAG						VARCHAR2(1),
	BUYER_MANAGED_TRANSPORT_FLAG					VARCHAR2(1),
	ALLOW_ORDER_FRM_UNASSIGND_SITES				VARCHAR2(1),
	OUTSIDE_PROCESS_ENABLED_FLAG					VARCHAR2(1),
	MASTER_CONTRACT_NUMBER							VARCHAR2(120),
	MASTER_CONTRACT_TYPE							VARCHAR2(150),	
	PO_HEADER_ID									NUMBER	
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINES_BPA_XFM
PROMPT
--

-- ********************
-- **BPA PO Lines Table
-- ********************
CREATE TABLE  XXMX_SCM_PO_LINES_BPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_LINE_KEY								VARCHAR2(50),
	INTERFACE_HEADER_KEY							VARCHAR2(50),	
	ACTION											VARCHAR2(25),	
	LINE_NUM										NUMBER,
	LINE_TYPE										VARCHAR2(30),
	ITEM											VARCHAR2(300),
	ITEM_DESCRIPTION								VARCHAR2(240),	
	ITEM_REVISION									VARCHAR2(18),	
	CATEGORY										VARCHAR2(2000),	
	COMMITTED_AMOUNT								NUMBER,	
	UNIT_OF_MEASURE									VARCHAR2(25),
	UNIT_PRICE										NUMBER,
	ALLOW_PRICE_OVERRIDE_FLAG						VARCHAR2(1),
	NOT_TO_EXCEED_PRICE								NUMBER,
	VENDOR_PRODUCT_NUM								VARCHAR2(25),
	NEGOTIATED_BY_PREPARER_FLAG						VARCHAR2(1),
	NOTE_TO_VENDOR									VARCHAR2(1000),
	NOTE_TO_RECEIVER								VARCHAR2(1000),
	MIN_RELEASE_AMOUNT								NUMBER,	
	EXPIRATION_DATE									DATE,
	SUPPLIER_PART_AUXID 							VARCHAR2(255),
	SUPPLIER_REF_NUMBER								VARCHAR2(150),
	ATTRIBUTE_CATEGORY								VARCHAR2(30),
	ATTRIBUTE1										VARCHAR2(150),
	ATTRIBUTE2										VARCHAR2(150),
	ATTRIBUTE3										VARCHAR2(150),
	ATTRIBUTE4										VARCHAR2(150),
	ATTRIBUTE5										VARCHAR2(150),
	ATTRIBUTE6										VARCHAR2(150),
	ATTRIBUTE7										VARCHAR2(150),
	ATTRIBUTE8										VARCHAR2(150),
	ATTRIBUTE9										VARCHAR2(150),
	ATTRIBUTE10										VARCHAR2(150),
	ATTRIBUTE11										VARCHAR2(150),
	ATTRIBUTE12										VARCHAR2(150),
	ATTRIBUTE13										VARCHAR2(150),
	ATTRIBUTE14										VARCHAR2(150),
	ATTRIBUTE15										VARCHAR2(150),
	ATTRIBUTE16										VARCHAR2(150),
	ATTRIBUTE17										VARCHAR2(150),
	ATTRIBUTE18										VARCHAR2(150),
	ATTRIBUTE19										VARCHAR2(150),
	ATTRIBUTE20										VARCHAR2(150),
	ATTRIBUTE_DATE1									DATE,
	ATTRIBUTE_DATE2									DATE,
	ATTRIBUTE_DATE3									DATE,
	ATTRIBUTE_DATE4									DATE,
	ATTRIBUTE_DATE5									DATE,
	ATTRIBUTE_DATE6									DATE,
	ATTRIBUTE_DATE7									DATE,
	ATTRIBUTE_DATE8									DATE,
	ATTRIBUTE_DATE9									DATE,
	ATTRIBUTE_DATE10								DATE,
	ATTRIBUTE_NUMBER1								NUMBER(18),
	ATTRIBUTE_NUMBER2								NUMBER(18),
	ATTRIBUTE_NUMBER3								NUMBER(18),
	ATTRIBUTE_NUMBER4								NUMBER(18),
	ATTRIBUTE_NUMBER5								NUMBER(18),
	ATTRIBUTE_NUMBER6								NUMBER(18),
	ATTRIBUTE_NUMBER7								NUMBER(18),
	ATTRIBUTE_NUMBER8								NUMBER(18),
	ATTRIBUTE_NUMBER9								NUMBER(18),
	ATTRIBUTE_NUMBER10								NUMBER(18),
	ATTRIBUTE_TIMESTAMP1							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10							TIMESTAMP(6),		
	AGING_PERIOD_DAYS								NUMBER(5),
	CONSIGNMENT_LINE_FLAG							VARCHAR2(1),	
	UNIT_WEIGHT										NUMBER,
	WEIGHT_UOM_CODE									VARCHAR2(3),
	WEIGHT_UNIT_OF_MEASURE 							VARCHAR2(25),
	UNIT_VOLUME										NUMBER,
	VOLUME_UOM_CODE									VARCHAR2(3),
	VOLUME_UNIT_OF_MEASURE 							VARCHAR2(25),
	TEMPLATE_NAME									VARCHAR2(30),
	ITEM_ATTRIBUTE_CATEGORY							VARCHAR2(30),
	ITEM_ATTRIBUTE1									VARCHAR2(150),								
	ITEM_ATTRIBUTE2									VARCHAR2(150),
	ITEM_ATTRIBUTE3									VARCHAR2(150),
	ITEM_ATTRIBUTE4									VARCHAR2(150),
	ITEM_ATTRIBUTE5									VARCHAR2(150),
	ITEM_ATTRIBUTE6									VARCHAR2(150),
	ITEM_ATTRIBUTE7									VARCHAR2(150),
	ITEM_ATTRIBUTE8									VARCHAR2(150),
	ITEM_ATTRIBUTE9									VARCHAR2(150),
	ITEM_ATTRIBUTE10								VARCHAR2(150),
	ITEM_ATTRIBUTE11								VARCHAR2(150),
	ITEM_ATTRIBUTE12								VARCHAR2(150),
	ITEM_ATTRIBUTE13								VARCHAR2(150),
	ITEM_ATTRIBUTE14								VARCHAR2(150),
	ITEM_ATTRIBUTE15								VARCHAR2(150),
	PARENT_ITEM										VARCHAR2(300),
	TOP_MODEL										VARCHAR2(300),
	SUPPLIER_PARENT_ITEM							VARCHAR2(300),
	SUPPLIER_TOP_MODEL								VARCHAR2(300),
	AMOUNT											NUMBER,
	PRICE_BREAK_LOOKUP_CODE							VARCHAR2(25),
	QUANTITY_COMMITTED								NUMBER,
	ALLOW_DESCRIPTION_UPDATE_FLAG					VARCHAR2(1),	
	PO_HEADER_ID									VARCHAR2(30),
	PO_LINE_ID										VARCHAR2(30)	
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM
PROMPT
--
	 
-- *****************************
-- **BPA PO Line Locations Table
-- *****************************
CREATE TABLE  XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_LINE_LOCATION_KEY						VARCHAR2(50),
	INTERFACE_LINE_KEY								VARCHAR2(50),
	SHIPMENT_NUM									NUMBER,
	SHIP_TO_LOCATION								VARCHAR2(60),
	SHIP_TO_ORGANIZATION_CODE						VARCHAR2(18),
	QUANTITY										NUMBER,
	PRICE_OVERRIDE 									NUMBER,
	PRICE_DISCOUNT									NUMBER,
	START_DATE										DATE,
	END_DATE										DATE,
	ATTRIBUTE_CATEGORY								VARCHAR2(30),
	ATTRIBUTE1										VARCHAR2(150),
	ATTRIBUTE2										VARCHAR2(150),
	ATTRIBUTE3										VARCHAR2(150),
	ATTRIBUTE4										VARCHAR2(150),
	ATTRIBUTE5										VARCHAR2(150),
	ATTRIBUTE6										VARCHAR2(150),
	ATTRIBUTE7										VARCHAR2(150),
	ATTRIBUTE8										VARCHAR2(150),
	ATTRIBUTE9										VARCHAR2(150),
	ATTRIBUTE10										VARCHAR2(150),
	ATTRIBUTE11										VARCHAR2(150),
	ATTRIBUTE12										VARCHAR2(150),
	ATTRIBUTE13										VARCHAR2(150),
	ATTRIBUTE14										VARCHAR2(150),
	ATTRIBUTE15										VARCHAR2(150),
	ATTRIBUTE16										VARCHAR2(150),
	ATTRIBUTE17										VARCHAR2(150),
	ATTRIBUTE18										VARCHAR2(150),
	ATTRIBUTE19										VARCHAR2(150),
	ATTRIBUTE20										VARCHAR2(150),
	ATTRIBUTE_DATE1									DATE,
	ATTRIBUTE_DATE2									DATE,
	ATTRIBUTE_DATE3									DATE,
	ATTRIBUTE_DATE4									DATE,
	ATTRIBUTE_DATE5									DATE,
	ATTRIBUTE_DATE6									DATE,
	ATTRIBUTE_DATE7									DATE,
	ATTRIBUTE_DATE8									DATE,
	ATTRIBUTE_DATE9									DATE,
	ATTRIBUTE_DATE10								DATE,
	ATTRIBUTE_NUMBER1								NUMBER(18),
	ATTRIBUTE_NUMBER2								NUMBER(18),
	ATTRIBUTE_NUMBER3								NUMBER(18),
	ATTRIBUTE_NUMBER4								NUMBER(18),
	ATTRIBUTE_NUMBER5								NUMBER(18),
	ATTRIBUTE_NUMBER6								NUMBER(18),
	ATTRIBUTE_NUMBER7								NUMBER(18),
	ATTRIBUTE_NUMBER8								NUMBER(18),
	ATTRIBUTE_NUMBER9								NUMBER(18),
	ATTRIBUTE_NUMBER10								NUMBER(18),
	ATTRIBUTE_TIMESTAMP1							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10							TIMESTAMP(6),
	PO_HEADER_ID									VARCHAR2(30),
	PO_LINE_ID										VARCHAR2(30),
	LINE_LOCATION_ID								VARCHAR2(30)
    );	

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM
PROMPT
--
	
-- ***************************
-- **BPA Org Assignments Table
-- ***************************
CREATE TABLE  XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_BU_ASSIGNMENT_KEY						VARCHAR2(50),
	INTERFACE_HEADER_KEY							VARCHAR2(50),
	REQ_BU_NAME 									VARCHAR2(240),
	ORDERED_LOCALLY_FLAG							VARCHAR2(1),
	VENDOR_SITE_CODE 								VARCHAR2(15),
	SHIP_TO_LOCATION								VARCHAR2(60),
	BILL_TO_BU_NAME									VARCHAR2(240),
	BILL_TO_LOCATION								VARCHAR2(60),
	ENABLED											VARCHAR2(1)
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_ATTR_VALUES_BPA_XFM
PROMPT
--

-- ****************************
-- **BPA Attribute Values Table
-- ****************************
CREATE TABLE  XXMX_SCM_PO_ATTR_VALUES_BPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_ATTRIBUTE_KEY							VARCHAR2(50),										
	INTERFACE_LINE_KEY								VARCHAR2(50),
	THUMBNAIL_IMAGE									VARCHAR2(700),
	PICTURE											VARCHAR2(700),
	MANUFACTURER_PART_NUM							VARCHAR2(700),
	ROUNDING_FACTOR									NUMBER,
	AVAILABILITY									VARCHAR2(700),
	LEAD_TIME										NUMBER,
	UNSPSC											VARCHAR2(700),
	ATTACHMENT_URL									VARCHAR2(700),
	SUPPLIER_URL									VARCHAR2(700),
	MANUFACTURER_URL								VARCHAR2(700),
	ATTRIBUTE_CATEGORY								VARCHAR2(30),
	ATTRIBUTE1										VARCHAR2(150),
	ATTRIBUTE2										VARCHAR2(150),
	ATTRIBUTE3										VARCHAR2(150),
	ATTRIBUTE4										VARCHAR2(150),
	ATTRIBUTE5										VARCHAR2(150),
	ATTRIBUTE6										VARCHAR2(150),
	ATTRIBUTE7										VARCHAR2(150),
	ATTRIBUTE8										VARCHAR2(150),
	ATTRIBUTE9										VARCHAR2(150),
	ATTRIBUTE10										VARCHAR2(150),
	ATTRIBUTE11										VARCHAR2(150),
	ATTRIBUTE12										VARCHAR2(150),
	ATTRIBUTE13										VARCHAR2(150),
	ATTRIBUTE14										VARCHAR2(150),
	ATTRIBUTE15										VARCHAR2(150),
	ATTRIBUTE16										VARCHAR2(150),
	ATTRIBUTE17										VARCHAR2(150),
	ATTRIBUTE18										VARCHAR2(150),
	ATTRIBUTE19										VARCHAR2(150),
	ATTRIBUTE20										VARCHAR2(150),
	ATTRIBUTE_DATE1									DATE,
	ATTRIBUTE_DATE2									DATE,
	ATTRIBUTE_DATE3									DATE,
	ATTRIBUTE_DATE4									DATE,
	ATTRIBUTE_DATE5									DATE,
	ATTRIBUTE_DATE6									DATE,
	ATTRIBUTE_DATE7									DATE,
	ATTRIBUTE_DATE8									DATE,
	ATTRIBUTE_DATE9									DATE,
	ATTRIBUTE_DATE10								DATE,
	ATTRIBUTE_NUMBER1								NUMBER(18),
	ATTRIBUTE_NUMBER2								NUMBER(18),
	ATTRIBUTE_NUMBER3								NUMBER(18),
	ATTRIBUTE_NUMBER4								NUMBER(18),
	ATTRIBUTE_NUMBER5								NUMBER(18),
	ATTRIBUTE_NUMBER6								NUMBER(18),
	ATTRIBUTE_NUMBER7								NUMBER(18),
	ATTRIBUTE_NUMBER8								NUMBER(18),
	ATTRIBUTE_NUMBER9								NUMBER(18),
	ATTRIBUTE_NUMBER10								NUMBER(18),
	ATTRIBUTE_TIMESTAMP1							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10							TIMESTAMP(6),
	PACKAGING_STRING								VARCHAR2(240)
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM
PROMPT
--

-- ***************************************
-- **BPA Translated Attribute Values Table
-- ***************************************
CREATE TABLE  XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_ATTRIBUTE_KEY							VARCHAR2(50),
	INTERFACE_LINE_KEY								VARCHAR2(50),
	DESCRIPTION										VARCHAR2(240),
	MANUFACTURER									VARCHAR2(700),
	ALIAS											VARCHAR2(700),
	COMMENTS										VARCHAR2(700),
	LONG_DESCRIPTION								VARCHAR2(4000),
	LANGUAGE										VARCHAR2(4)
    );	

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_HEADERS_CPA_XFM
PROMPT
--
	 
-- **********************
-- **CPA PO Headers Table
-- **********************
CREATE TABLE XXMX_SCM_PO_HEADERS_CPA_XFM
	(
	FILE_SET_ID										VARCHAR2(30),
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_HEADER_KEY							VARCHAR2(50),	
	ACTION											VARCHAR2(25),
	BATCH_ID										NUMBER,
	INTERFACE_SOURCE_CODE 							VARCHAR2(25),
	APPROVAL_ACTION									VARCHAR2(25),
	DOCUMENT_NUM									VARCHAR2(30),
	DOCUMENT_TYPE_CODE								VARCHAR2(25),
	STYLE_DISPLAY_NAME								VARCHAR2(240),
	PRC_BU_NAME										VARCHAR2(240),
	AGENT_NAME 										VARCHAR2(2000),
	CURRENCY_CODE									VARCHAR2(15),
	COMMENTS										VARCHAR2(240),
	VENDOR_NAME										VARCHAR2(360),
	VENDOR_NUM 										VARCHAR2(30),
	VENDOR_SITE_CODE								VARCHAR2(15),
	VENDOR_CONTACT									VARCHAR2(360),
	VENDOR_DOC_NUM									VARCHAR2(25),
	FOB												VARCHAR2(30),
	FREIGHT_CARRIER									VARCHAR2(360),
	FREIGHT_TERMS									VARCHAR2(30),
	PAY_ON_CODE										VARCHAR2(25),
	PAYMENT_TERMS									VARCHAR2(50),
	ORIGINATOR_ROLE									VARCHAR2(25),
	CHANGE_ORDER_DESC								VARCHAR2(2000),
	ACCEPTANCE_REQUIRED_FLAG						VARCHAR2(1),
	ACCEPTANCE_WITHIN_DAYS							NUMBER,
	SUPPLIER_NOTIF_METHOD 							VARCHAR2(25),
	FAX												VARCHAR2(60),
	EMAIL_ADDRESS									VARCHAR2(2000),
	CONFIRMING_ORDER_FLAG							VARCHAR2(1),
	AMOUNT_AGREED									NUMBER,
	AMOUNT_LIMIT									NUMBER,
	MIN_RELEASE_AMOUNT								NUMBER,
	EFFECTIVE_DATE									DATE,
	EXPIRATION_DATE									DATE,
	NOTE_TO_VENDOR									VARCHAR2(1000),
	NOTE_TO_RECEIVER								VARCHAR2(1000),
	GENERATE_ORDERS_AUTOMATIC						VARCHAR2(1),
	SUBMIT_APPROVAL_AUTOMATIC						VARCHAR2(1),
	GROUP_REQUISITIONS								VARCHAR2(1),
	GROUP_REQUISITION_LINES							VARCHAR2(1),
	USE_SHIP_TO										VARCHAR2(1),
	USE_NEED_BY_DATE								DATE,
	ATTRIBUTE_CATEGORY								VARCHAR2(30),
	ATTRIBUTE1										VARCHAR2(150),
	ATTRIBUTE2										VARCHAR2(150),
	ATTRIBUTE3										VARCHAR2(150),
	ATTRIBUTE4										VARCHAR2(150),
	ATTRIBUTE5										VARCHAR2(150),
	ATTRIBUTE6										VARCHAR2(150),
	ATTRIBUTE7										VARCHAR2(150),
	ATTRIBUTE8										VARCHAR2(150),
	ATTRIBUTE9										VARCHAR2(150),
	ATTRIBUTE10										VARCHAR2(150),
	ATTRIBUTE11										VARCHAR2(150),
	ATTRIBUTE12										VARCHAR2(150),
	ATTRIBUTE13										VARCHAR2(150),
	ATTRIBUTE14										VARCHAR2(150),
	ATTRIBUTE15										VARCHAR2(150),
	ATTRIBUTE16										VARCHAR2(150),
	ATTRIBUTE17										VARCHAR2(150),
	ATTRIBUTE18										VARCHAR2(150),
	ATTRIBUTE19										VARCHAR2(150),
	ATTRIBUTE20										VARCHAR2(150),
	ATTRIBUTE_DATE1									DATE,
	ATTRIBUTE_DATE2									DATE,
	ATTRIBUTE_DATE3									DATE,
	ATTRIBUTE_DATE4									DATE,
	ATTRIBUTE_DATE5									DATE,
	ATTRIBUTE_DATE6									DATE,
	ATTRIBUTE_DATE7									DATE,
	ATTRIBUTE_DATE8									DATE,
	ATTRIBUTE_DATE9									DATE,
	ATTRIBUTE_DATE10								DATE,
	ATTRIBUTE_NUMBER1								NUMBER(18),
	ATTRIBUTE_NUMBER2								NUMBER(18),
	ATTRIBUTE_NUMBER3								NUMBER(18),
	ATTRIBUTE_NUMBER4								NUMBER(18),
	ATTRIBUTE_NUMBER5								NUMBER(18),
	ATTRIBUTE_NUMBER6								NUMBER(18),
	ATTRIBUTE_NUMBER7								NUMBER(18),
	ATTRIBUTE_NUMBER8								NUMBER(18),
	ATTRIBUTE_NUMBER9								NUMBER(18),
	ATTRIBUTE_NUMBER10								NUMBER(18),
	ATTRIBUTE_TIMESTAMP1							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP2							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP3							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP4							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP5							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP6							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP7							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP8							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP9							TIMESTAMP(6),
	ATTRIBUTE_TIMESTAMP10							TIMESTAMP(6),
	AGENT_EMAIL_ADDR								VARCHAR2(240),
	MODE_OF_TRANSPORT								VARCHAR2(80),
	SERVICE_LEVEL									VARCHAR2(80),
	USE_SALES_ORDER_NUMBER_FLAG						VARCHAR2(1),
	BUYER_MANAGED_TRANSPORT_FLAG					VARCHAR2(1),
	CONFIGURED_ITEM_FLAG							VARCHAR2(1),
	ALLOW_ORDER_FRM_UNASSIGND_SITES				VARCHAR2(1),
	OUTSIDE_PROCESS_ENABLED_FLAG					VARCHAR2(1),
	DISABLE_AUTOSOURCING_FLAG						VARCHAR2(1),
	MASTER_CONTRACT_NUMBER							VARCHAR2(120),
	MASTER_CONTRACT_TYPE							VARCHAR2(150),
	PO_HEADER_ID									VARCHAR2(30)
    );

--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM
PROMPT
--
	
-- ***************************
-- **CPA Org Assignments Table
-- ***************************
CREATE TABLE  XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM
    (
	FILE_SET_ID										VARCHAR2(30),	
	MIGRATION_SET_ID                				NUMBER,
	MIGRATION_SET_NAME              				VARCHAR2(100),
	MIGRATION_STATUS               					VARCHAR2(50),
	INTERFACE_BU_ASSIGNMENT_KEY						VARCHAR2(50),
	INTERFACE_HEADER_KEY							VARCHAR2(50),
	REQ_BU_NAME										VARCHAR2(240),
	ORDERED_LOCALLY_FLAG							VARCHAR2(1),
	VENDOR_SITE_CODE								VARCHAR2(15),
	SHIP_TO_LOCATION								VARCHAR2(60),
	BILL_TO_BU_NAME									VARCHAR2(240),
	BILL_TO_LOCATION								VARCHAR2(60),
	ENABLED											VARCHAR2(1)
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
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_HEADERS_STD_XFM FOR XXMX_XFM.XXMX_SCM_PO_HEADERS_STD_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINES_STD_XFM FOR XXMX_XFM.XXMX_SCM_PO_LINES_STD_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM FOR XXMX_XFM.XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM FOR XXMX_XFM.XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_HEADERS_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_HEADERS_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINES_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_LINES_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_ATTR_VALUES_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_ATTR_VALUES_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_HEADERS_CPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_HEADERS_CPA_XFM;
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM FOR XXMX_XFM.XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM;
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
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_HEADERS_STD_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_LINES_STD_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_DISTRIBUTIONS_STD_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_HEADERS_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_LINES_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_LINE_LOCATIONS_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_GA_ORG_ASSIGN_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_ATTR_VALUES_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_ATTR_VALUES_TLP_BPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_HEADERS_CPA_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_XFM TO XXMX_CORE;
--
--

--
--
PROMPT
PROMPT
PROMPT ***********************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Maximise PO Data Migration
PROMPT **                                
PROMPT ***********************************************************************
PROMPT
PROMPT
--
--