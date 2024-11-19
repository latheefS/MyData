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
--** FILENAME  : xxmx_scm_po_rcpt_stg_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Soundarya Kamatagi
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Cloudbridge
--**              Scm Po Receipts Headers Data Migration.
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
--**   1.0  08-FEB-2023  Soundarya Kamatagi  Created PO Receipt STG tables for Cloudbridge.
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
PROMPT ** Installing Extract Database Objects for Cloudbridge PO Receipt Data Migration
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

PROMPT
PROMPT Dropping Table XXMX_SCM_PO_RCPT_HDR_STG
PROMPT
--
EXEC DropTable('XXMX_SCM_PO_RCPT_HDR_STG')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_RCPT_TXN_STG									
PROMPT
--
EXEC DropTable('XXMX_SCM_PO_RCPT_TXN_STG')
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--

PROMPT
PROMPT Creating Table XXMX_SCM_PO_RCPT_HDR_STG
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- ***************************
-- **PO RECEIPT HEADERS Table 
-- ***************************
CREATE TABLE XXMX_STG.XXMX_SCM_PO_RCPT_HDR_STG
   (
	FILE_SET_ID                                   VARCHAR2(30),
	MIGRATION_SET_ID                              NUMBER,
	MIGRATION_SET_NAME                            VARCHAR2(100),
	MIGRATION_STATUS                              VARCHAR2(50),
	HEADER_INTERFACE_NUMBER                       VARCHAR2(30),
	RECEIPT_SOURCE_CODE                           VARCHAR2(25),
	ASN_TYPE                                      VARCHAR2(25),
    TRANSACTION_TYPE				              VARCHAR2(25),
    NOTICE_CREATION_DATE                          DATE,
    SHIPMENT_NUMBER                               VARCHAR2(30),  
    RECEIPT_NUMBER                                VARCHAR2(30),
    VENDOR_NAME                                   VARCHAR2(240),
    VENDOR_NUM                                    VARCHAR2(30),
    VENDOR_SITE_CODE                              VARCHAR2(35),
    FROM_ORGANIZATION_CODE                        VARCHAR2(18),   
    SHIP_TO_ORGANIZATION_CODE                     NUMBER,
    LOCATION_CODE 			                      VARCHAR2(60),
    BILL_OF_LADING			                      VARCHAR2(25),		
    PACKING_SLIP			                      VARCHAR2(25),		
    SHIPPED_DATE			                      DATE,
    CARRIER_NAME			                      VARCHAR2(25),		
    EXPECTED_RECEIPT_DATE	                      DATE,   
    NUM_OF_CONTAINERS                      		  NUMBER,  
    WAY_BILL_AIRBILL_NUM                      	  VARCHAR2(20),
    COMMENTS                      				  VARCHAR2(240),
    GROSS_WEIGHT                                  NUMBER, 
    GROSS_WEIGHT_UNIT_OF_MEASURE                  VARCHAR2(3),
    NET_WEIGHT                       			  NUMBER, 
    NET_WEIGHT_UNIT_OF_MEASURE                    VARCHAR2(3),
    TAR_WEIGHT                                    NUMBER, 
    TAR_WEIGHT_UNIT_OF_MEASURE                    VARCHAR2(3),	
    PACKAGING_CODE			                      VARCHAR2(5),
    CARRIER_METHOD			                      VARCHAR2(2),
    CARRIER_EQUIPMENT  		                      VARCHAR2(10),
    SPECIAL_HANDLING_CODE	                      VARCHAR2(3),
    HAZARD_CODE			                          VARCHAR2(1),
    HAZARD_CLASS 			                      VARCHAR2(4),
    HAZARD_DESCRIPTION 		                      VARCHAR2(80),
    FREIGHT_TERMS			                      VARCHAR2(25),
    FREIGHT_BILL_NUMBER		                      VARCHAR2(35),
    INVOICE_NUM			                      	  VARCHAR2(30),
    INVOICE_DATE			                      DATE,   
    TOTAL_INVOICE_AMOUNT	                      NUMBER,  
    TAX_NAME				                      VARCHAR2(15),
    TAX _AMOUNT				                      NUMBER,
    FREIGHT AMOUNT			                      NUMBER,
    CURRENCY_CODE  								  VARCHAR2(15),
    CONVERSION_RATE_TYPE  						  VARCHAR2(30),
    CONVERSION_RATE  							  NUMBER,
    CONVERSION_RATE_DATE                          DATE,
    PAYMENT_TERMS_NAME                            VARCHAR2(50),
    EMPLOYEE_NAME                                 VARCHAR2(240),
    TRANSACTION_DATE  		                      DATE,
    CUSTOMER_ACCOUNT_NUMBER                       NUMBER,
    CUSTOMER_PARTY_NAME  	                      VARCHAR2(30),
    CUSTOMER_PARTY_NUMBER  	                      NUMBER,
    BUSINESS_UNIT  			                      VARCHAR2(240),
    RA_OUTSOURCER_PARTY_NAME                      VARCHAR2(240),
    RECEIPT_ADVICE_NUMBER                         VARCHAR2(80),
    RA_DOCUMENT_CODE  							  VARCHAR2(25),
    RA_DOCUMENT_NUMBER  						  VARCHAR2(80),
    RA_DOC_REVISION_NUMBER  					  VARCHAR2(80),	
    RA_DOC_REVISION_DATE                          DATE,
    RA_DOC_CREATION_DATE                          DATE,
    RA_DOC_LAST_UPDATE_DATE                       DATE,
    RA_OUTSOURCER_CONTACT_NAME  				  VARCHAR2(240),
    RA_VENDOR_SITE_NAME  						  VARCHAR2(240),
    RA_NOTE_TO_RECEIVER  						  VARCHAR2(480),
    RA_DOO_SOURCE_SYSTEM_NAME  					  VARCHAR2(80),
    ATTRIBUTE_CATEGORY						      VARCHAR2(30),
    ATTRIBUTE1								      VARCHAR2(150),
    ATTRIBUTE2								      VARCHAR2(150),
    ATTRIBUTE3								      VARCHAR2(150),
    ATTRIBUTE4								      VARCHAR2(150),
    ATTRIBUTE5								      VARCHAR2(150),
    ATTRIBUTE6								      VARCHAR2(150),
    ATTRIBUTE7								      VARCHAR2(150),
    ATTRIBUTE8								      VARCHAR2(150),
    ATTRIBUTE9								      VARCHAR2(150),
    ATTRIBUTE10								      VARCHAR2(150),
    ATTRIBUTE11								      VARCHAR2(150),
    ATTRIBUTE12								      VARCHAR2(150),
    ATTRIBUTE13								      VARCHAR2(150),
    ATTRIBUTE14								      VARCHAR2(150),
    ATTRIBUTE15								      VARCHAR2(150),
    ATTRIBUTE16								      VARCHAR2(150),
    ATTRIBUTE17								      VARCHAR2(150),
    ATTRIBUTE18								      VARCHAR2(150),
    ATTRIBUTE19								      VARCHAR2(150),
    ATTRIBUTE20								      VARCHAR2(150),
    ATTRIBUTE_NUMBER1						      NUMBER,
    ATTRIBUTE_NUMBER2						      NUMBER,
    ATTRIBUTE_NUMBER3						      NUMBER,
    ATTRIBUTE_NUMBER4						      NUMBER,
    ATTRIBUTE_NUMBER5						      NUMBER,
    ATTRIBUTE_NUMBER6						      NUMBER,
    ATTRIBUTE_NUMBER7						      NUMBER,
    ATTRIBUTE_NUMBER8						      NUMBER,
    ATTRIBUTE_NUMBER9						      NUMBER,
    ATTRIBUTE_NUMBER10						      NUMBER,
    ATTRIBUTE_DATE1							      DATE,
    ATTRIBUTE_DATE2							      DATE,
    ATTRIBUTE_DATE3							      DATE,
    ATTRIBUTE_DATE4							      DATE,
    ATTRIBUTE_DATE5							      DATE,
    ATTRIBUTE_TIMESTAMP1					      TIMESTAMP,
    ATTRIBUTE_TIMESTAMP2					      TIMESTAMP,
    ATTRIBUTE_TIMESTAMP3					      TIMESTAMP,
    ATTRIBUTE_TIMESTAMP4					      TIMESTAMP,
    ATTRIBUTE_TIMESTAMP5					      TIMESTAMP,
    GL_DATE								          DATE,
    RECEIPT_HEADER_ID						      NUMBER,
    EXTERNAL_SYS_TXN_REFERENCE		  			  VARCHAR2(300),
    EMPLOYEE_ID								      NUMBER
);


--
--
PROMPT
PROMPT Creating Table XXMX_SCM_PO_RCPT_TXN_STG
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)

--
--
-- ******************************
-- **PO RECEIPT TRANSACTION Table
-- ******************************
CREATE TABLE XXMX_STG.XXMX_SCM_PO_RCPT_TXN_STG
   (
	    FILE_SET_ID                                     VARCHAR2(30),
	    MIGRATION_SET_ID                                NUMBER,
	    MIGRATION_SET_NAME                              VARCHAR2(100),
	    MIGRATION_STATUS                                VARCHAR2(50),
        INTERFACE_LINE_NUM					            VARCHAR2(30),
        TRANSACTION_TYPE                                VARCHAR2(25),
        AUTO_TRANSACT_CODE                              VARCHAR2(25),
        TRANSACTION_DATE                                DATE,
        SOURCE_DOCUMENT_CODE                            VARCHAR2(25),
        RECEIPT_SOURCE_CODE                             VARCHAR2(25),
        HEADER_INTERFACE_NUM                            VARCHAR2(30),
        PARENT_TRANSACTION_ID                           NUMBER,
        PARENT_INTF_LINE_NUM                            NUMBER,
        TO_ORGANIZATION_CODE                            VARCHAR2(18),
        ITEM_NUM                                        VARCHAR2(300),
        ITEM_DESCRIPTION                                VARCHAR2(240),
        ITEM_REVISION                                   VARCHAR2(18),
        DOCUMENT_NUM                                    NUMBER,
        DOCUMENT_LINE_NUM                               NUMBER,
        DOCUMENT_SHIPMENT_LINE_NUM                      NUMBER,
        DOCUMENT_DISTRIBUTION_NUM                       NUMBER,
        BUSINESS_UNIT                                   VARCHAR2(30),
        SHIPMENT_NUM                                    NUMBER, 
        EXPECTED_RECEIPT_DATE                           DATE,
        SUBINVENTORY                                    VARCHAR2(10),
        LOCATOR                                         VARCHAR2(18),
        QUANTITY                                        NUMBER,
        UNIT_OF_MEASURE                                 VARCHAR2(30),
        PRIMARY_QUANTITY                                NUMBER,
        PRIMARY_UNIT_OF_MEASURE                         VARCHAR2(30),
        SECONDARY_QUANTITY                              NUMBER, 
        SECONDARY_UNIT_OF_MEASURE                       VARCHAR2(3),              
        VENDOR_NAME                                     VARCHAR2(240),
        VENDOR_NUM                                      VARCHAR2(30),
        VENDOR_SITE_CODE                                VARCHAR2(15),
        CUSTOMER_PARTY_NAME                             VARCHAR2(360),
        CUSTOMER_PARTY_NUMBER                           VARCHAR2(30),
        CUSTOMER_ACCOUNT_NUMBER                         NUMBER,
        SHIP_TO_LOCATION_CODE                           VARCHAR2(30),
        LOCATION_CODE                                   VARCHAR2(60),
        REASON_NAME                                     VARCHAR2(30),
        DELIVER_TO_PERSON_NAME                          VARCHAR2(240),
        DELIVER_TO_LOCATION_CODE                        VARCHAR2(60),
        RECEIPT_EXCEPTION_FLAG                          VARCHAR2(1),
        ROUTING_HEADER_ID                               NUMBER,
        DESTINATION_TYPE_CODE                           VARCHAR2(25),
        INTERFACE_SOURCE_CODE                           VARCHAR2(30),
        INTERFACE_SOURCE_LINE_ID                        NUMBER,
        AMOUNT                                          NUMBER,
        CURRENCY_CODE                                   VARCHAR2(15),
        CURRENCY_CONVERSION_TYPE                        VARCHAR2(30), 
        CURRENCY_CONVERSION_RATE                        NUMBER,
        CURRENCY_CONVERSION_DATE                        DATE,
        INSPECTION_STATUS_CODE                          VARCHAR2(25),
        INSPECTION_QUALITY_CODE                         VARCHAR2(25),
        FROM_ORGANIZATION_CODE                          VARCHAR2(18),
        FROM_SUBINVENTORY                               VARCHAR2(10),
        FROM_LOCATOR                                    VARCHAR2(81),
        FREIGHT_CARRIER_NAME                            VARCHAR2(360),
        BILL_OF_LADING                                  VARCHAR2(25),
        PACKING_SLIP                                    VARCHAR2(25),
        SHIPPED_DATE                                    DATE,
        NUM_OF_CONTAINERS                               NUMBER,
        WAYBILL_AIRBILL_NUM                             VARCHAR2(20),
        RMA_REFERENCE                                   VARCHAR2(30),
        COMMENTS                                        VARCHAR2(240),
        TRUCK_NUM                                       VARCHAR2(35),
        CONTAINER_NUM                                   VARCHAR2(35),
        SUBSTITUTE_ITEM_NUM                             VARCHAR2(300),
        NOTICE_UNIT_PRICE                               NUMBER,
        ITEM_CATEGORY                                   VARCHAR2(81),
        INTRANSIT_OWNING_ORG_CODE                       VARCHAR2(18),
        ROUTING_CODE                                    VARCHAR2(30),
        BARCODE_LABEL                                   VARCHAR2(35),
        COUNTRY_OF_ORIGIN_CODE                          VARCHAR2(2),
        CREATE_DEBIT_MEMO_FLAG                          VARCHAR2(1),
        LICENSE_PLATE_NUMBER                            NUMBER,
        TRANSFER_LICENSE_PLATE_NUMBER                   NUMBER,
        LPN_GROUP_NUM                                   VARCHAR2(30),
        ASN_LINE_NUM                                    NUMBER,
        EMPLOYEE_NAME                                   VARCHAR2(240),
        SOURCE_TRANSACTION_NUM                          VARCHAR2(25),
        PARENT_SOURCE_TRANSACTION_NUM                   VARCHAR2(25),
        PARENT_INTERFACE_TXN_ID                         NUMBER,
        MATCHING_BASIS                                  VARCHAR2(30),	
        RA_OUTSOURCER_PARTY_NAME                        VARCHAR2(240),
        RA_DOCUMENT_NUMBER                              VARCHAR2(80),
        RA_DOCUMENT_LINE_NUMBER                         VARCHAR2(80),	
        RA_NOTE_TO_RECEIVER                             VARCHAR2(480),
        RA_VENDOR_SITE_NAME                             VARCHAR2(240),
        ATTRIBUTE_CATEGORY                              VARCHAR2(30),
        ATTRIBUTE1                                      VARCHAR2(150),
        ATTRIBUTE2                                      VARCHAR2(150),
        ATTRIBUTE3                                      VARCHAR2(150),
        ATTRIBUTE4                                      VARCHAR2(150),
        ATTRIBUTE5                                      VARCHAR2(150),
        ATTRIBUTE6                                      VARCHAR2(150),
        ATTRIBUTE7                                      VARCHAR2(150),
        ATTRIBUTE8                                      VARCHAR2(150),
        ATTRIBUTE9                                      VARCHAR2(150),
        ATTRIBUTE10                                     VARCHAR2(150),
        ATTRIBUTE11                                     VARCHAR2(150),
        ATTRIBUTE12                                     VARCHAR2(150),
        ATTRIBUTE13                                     VARCHAR2(150),
        ATTRIBUTE14                                     VARCHAR2(150),
        ATTRIBUTE15                                     VARCHAR2(150),
        ATTRIBUTE16                                     VARCHAR2(150),
        ATTRIBUTE17                                     VARCHAR2(150),
        ATTRIBUTE18                                     VARCHAR2(150),
        ATTRIBUTE19                                     VARCHAR2(150),
        ATTRIBUTE20                                     VARCHAR2(150),
        ATTRIBUTE_NUMBER1                               NUMBER,
        ATTRIBUTE_NUMBER2                               NUMBER,
        ATTRIBUTE_NUMBER3                               NUMBER,
        ATTRIBUTE_NUMBER4                               NUMBER,
        ATTRIBUTE_NUMBER5                               NUMBER,
        ATTRIBUTE_NUMBER6                               NUMBER,
        ATTRIBUTE_NUMBER7                               NUMBER,
        ATTRIBUTE_NUMBER8                               NUMBER,
        ATTRIBUTE_NUMBER9                               NUMBER,
        ATTRIBUTE_NUMBER10                              NUMBER,
        ATTRIBUTE_DATE1                                 DATE,
        ATTRIBUTE_DATE2                                 DATE,
        ATTRIBUTE_DATE3                                 DATE,
        ATTRIBUTE_DATE4                                 DATE,
        ATTRIBUTE_DATE5                                 DATE,
        ATTRIBUTE_TIMESTAMP1                            TIMESTAMP,
        ATTRIBUTE_TIMESTAMP2                            TIMESTAMP,
        ATTRIBUTE_TIMESTAMP3                            TIMESTAMP,
        ATTRIBUTE_TIMESTAMP4                            TIMESTAMP,
        ATTRIBUTE_TIMESTAMP5                            TIMESTAMP,
        CONSIGNED_FLAG                                  VARCHAR2(1),
        SOLDTO_LEGAL_ENTITY                             VARCHAR2(240),
        CONSUMED_QUANTITY                               NUMBER,			
        DEFAULT_TAXATION_COUNTRY                        VARCHAR2(2 CHAR),
        TRX_BUSINESS_CATEGORY                           VARCHAR2(240),		
        DOCUMENT_FISCAL_CLASSIFICATION                  VARCHAR2(240),
        USER_DEFINED_FISC_CLASS                         VARCHAR2(30),
        PRODUCT_FISC_CLASS_NAME                         VARCHAR2(30),
        INTENDED_USE                                    VARCHAR2(240 CHAR),	
        PRODUCT_CATEGORY                                VARCHAR2(240 CHAR),		
        TAX_CLASSIFICATION_CODE                         VARCHAR2(50 CHAR),
        PRODUCT_TYPE                                    VARCHAR2(240 CHAR),
        FIRST_PTY_NUMBER                                VARCHAR2(30 CHAR),
        THIRD_PTY_NUMBER                                VARCHAR2(30 CHAR),
        TAX_INVOICE_NUMBER                              VARCHAR2(150 CHAR),
        TAX_INVOICE_DATE                                DATE,
        FINAL_DISCHARGE_LOC_CODE                        VARCHAR2(60  CHAR),
        ASSESSABLE_VALUE                                NUMBER,
        PHYSICAL_RETURN_REQD                            VARCHAR2(1),
        EXTERNAL_SYSTEM_PACKING_UNIT                    VARCHAR2(150 CHAR),
        EWAY_BILL_NUMBER                                NUMBER,
        EWAY_BILL_DATE                                  DATE,
        RECALL_NOTICE_NUMBER                            NUMBER,
        RECALL_NOTICE_LINE_NUMBER                       NUMBER,
        EXTERNAL_SYS_TXN_REFERENCE                      VARCHAR2(300 CHAR),
        DEFAULT_LOTSER_FROM_ASN                         VARCHAR2(1 CHAR),
        EMPLOYEE_ID                                     NUMBER
);



PROMPT
PROMPT
PROMPT ********************
PROMPT ** Creating Synonyms
PROMPT ********************
--
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_RCPT_HDR_STG FOR XXMX_STG.XXMX_SCM_PO_RCPT_HDR_STG;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_PO_RCPT_TXN_STG FOR XXMX_STG.XXMX_SCM_PO_RCPT_TXN_STG;
	 
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions 
PROMPT
--
GRANT ALL ON XXMX_STG.XXMX_SCM_PO_RCPT_HDR_STG TO XXMX_CORE;
GRANT ALL ON XXMX_STG.XXMX_SCM_PO_RCPT_TXN_STG TO XXMX_CORE;
--
--
--
PROMPT
PROMPT
PROMPT ***********************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge Scm Po Receipt Data Migration
PROMPT **                                
PROMPT ***********************************************************************************
PROMPT
PROMPT
--
--