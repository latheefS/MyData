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
--** FILENAME  :  xxmx_ap_suppliers_stg_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the package specification for the Patech
--**              common Procedures and Functions package.
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
--**   1.0  09-JUL-2020  Ian S. Vickerstaff  Created from original V1 Solutions
--**                                         Limited version.
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
--**  For example, having a variable in code simply named x_id is not very
--**  useful.  Don't laugh, I've seen it done.
--**
--**  If you came across such a variable hundreds of lines down in a packaged
--**  procedure or function, you could assume the variable's data type was
--**  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
--**  but you would have to check in the declaration section to be sure.
--**
--**  However, if the purpose of the x_id variable was not to store an Oracle
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
--**       1) Parameter prefixes always start with p.
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
--**       1) Global data elements will always start with a g whether
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
--
--
PROMPT
PROMPT
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Cloudbridge GL Data Migration
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
PROMPT Dropping Table xxmx_ap_supp_addrs_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_ADDRS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_bank_accts_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_BANK_ACCTS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_cont_addrs_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_CONT_ADDRS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_contacts_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_CONTACTS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_payees_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_PAYEES_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_pmt_instrs_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_PMT_INSTRS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_site_assigns_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_SITE_ASSIGNS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supplier_sites_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPPLIER_SITES_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_suppliers_stg
--
EXEC DropTable ('XXMX_AP_SUPPLIERS_STG')
--
--
PROMPT
PROMPT Dropping Table xxmx_ap_supp_3rd_pty_rels_stg
PROMPT
--
EXEC DropTable ('XXMX_AP_SUPP_3RD_PTY_RELS_STG')
--
--
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_addrs_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_addrs_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_ADDRS_STG 
   ( 
     file_set_id                    	VARCHAR2(30),
     migration_set_id 					NUMBER,
     migration_set_name 				VARCHAR2(100),                 
	  migration_status 					VARCHAR2(50),
	  location_id						NUMBER,
     SUPPLIER_ID                  NUMBER,
	  supplier_site_id					NUMBER,
	  party_site_id						NUMBER,
     IMPORT_ACTION 					VARCHAR2(10), 
     SUPPLIER_NAME 					VARCHAR2(360), 
     ADDRESS_NAME 					VARCHAR2(240), 
     ADDRESS_NAME_NEW 				VARCHAR2(240), 
     COUNTRY 							VARCHAR2(60), 
     ADDRESS1 						VARCHAR2(240), 
     ADDRESS2 						VARCHAR2(240), 
     ADDRESS3 						VARCHAR2(240), 
     ADDRESS4 						VARCHAR2(240), 
     PHONETIC_ADDRESS_LINE 			VARCHAR2(560), 
     ADDRESS_ELEMENT_ATTRIBUTE_1 		VARCHAR2(150), 
     ADDRESS_ELEMENT_ATTRIBUTE_2 		VARCHAR2(150), 
     ADDRESS_ELEMENT_ATTRIBUTE_3 		VARCHAR2(150), 
     ADDRESS_ELEMENT_ATTRIBUTE_4 		VARCHAR2(150), 
     ADDRESS_ELEMENT_ATTRIBUTE_5 		VARCHAR2(150), 
     BUILDING 						VARCHAR2(240), 
     FLOOR_NUMBER 					VARCHAR2(40), 
     CITY 							VARCHAR2(60), 
     STATE 							VARCHAR2(60), 
     PROVINCE 						VARCHAR2(60), 
     COUNTY 							VARCHAR2(60), 
     POSTAL_CODE 						VARCHAR2(60), 
     POSTAL_PLUS_4_CODE 				VARCHAR2(10), 
     ADDRESSEE 						VARCHAR2(360), 
     GLOBAL_LOCATION_NUMBER 			VARCHAR2(40), 
     LANGUAGE 						VARCHAR2(4), 
     INACTIVE_DATE 					DATE, 
     PHONE_COUNTRY_CODE 				VARCHAR2(10), 
     PHONE_AREA_CODE 					VARCHAR2(10), 
     PHONE 							VARCHAR2(40), 
     PHONE_EXTENSION 					VARCHAR2(20), 
     FAX_COUNTRY_CODE 				VARCHAR2(10), 
     FAX_AREA_CODE 					VARCHAR2(10), 
     FAX 								VARCHAR2(15), 
     RFQ_OR_BIDDING 					VARCHAR2(1), 
     ORDERING 						VARCHAR2(1), 
     PAY 								VARCHAR2(1), 
     ATTRIBUTE_CATEGORY 				VARCHAR2(30), 
     ATTRIBUTE1 						VARCHAR2(150), 
     ATTRIBUTE2 						VARCHAR2(150), 
     ATTRIBUTE3 						VARCHAR2(150), 
     ATTRIBUTE4 						VARCHAR2(150), 
     ATTRIBUTE5 						VARCHAR2(150), 
     ATTRIBUTE6 						VARCHAR2(150), 
     ATTRIBUTE7 						VARCHAR2(150), 
     ATTRIBUTE8 						VARCHAR2(150), 
     ATTRIBUTE9 						VARCHAR2(150), 
     ATTRIBUTE10 						VARCHAR2(150), 
     ATTRIBUTE11 						VARCHAR2(150), 
     ATTRIBUTE12 						VARCHAR2(150), 
     ATTRIBUTE13 						VARCHAR2(150), 
     ATTRIBUTE14 						VARCHAR2(150), 
     ATTRIBUTE15 						VARCHAR2(150), 
     ATTRIBUTE16 						VARCHAR2(150), 
     ATTRIBUTE17 						VARCHAR2(150), 
     ATTRIBUTE18 						VARCHAR2(150), 
     ATTRIBUTE19 						VARCHAR2(150), 
     ATTRIBUTE20 						VARCHAR2(150), 
     ATTRIBUTE21 						VARCHAR2(150), 
     ATTRIBUTE22 						VARCHAR2(150), 
     ATTRIBUTE23 						VARCHAR2(150), 
     ATTRIBUTE24 						VARCHAR2(150), 
     ATTRIBUTE25 						VARCHAR2(150), 
     ATTRIBUTE26 						VARCHAR2(150), 
     ATTRIBUTE27 						VARCHAR2(150), 
     ATTRIBUTE28 						VARCHAR2(150), 
     ATTRIBUTE29 						VARCHAR2(150), 
     ATTRIBUTE30 						VARCHAR2(150), 
     ATTRIBUTE_NUMBER1 				NUMBER, 
     ATTRIBUTE_NUMBER2 				NUMBER, 
     ATTRIBUTE_NUMBER3 				NUMBER, 
     ATTRIBUTE_NUMBER4 				NUMBER, 
     ATTRIBUTE_NUMBER5 				NUMBER, 
     ATTRIBUTE_NUMBER6 				NUMBER, 
     ATTRIBUTE_NUMBER7 				NUMBER, 
     ATTRIBUTE_NUMBER8 				NUMBER, 
     ATTRIBUTE_NUMBER9 				NUMBER, 
     ATTRIBUTE_NUMBER10				NUMBER, 
     ATTRIBUTE_NUMBER11				NUMBER, 
     ATTRIBUTE_NUMBER12				NUMBER, 
     ATTRIBUTE_DATE1 					DATE, 
     ATTRIBUTE_DATE2 					DATE, 
     ATTRIBUTE_DATE3 					DATE, 
     ATTRIBUTE_DATE4 					DATE, 
     ATTRIBUTE_DATE5 					DATE, 
     ATTRIBUTE_DATE6 					DATE, 
     ATTRIBUTE_DATE7 					DATE, 
     ATTRIBUTE_DATE8 					DATE, 
     ATTRIBUTE_DATE9 					DATE, 
     ATTRIBUTE_DATE10 				DATE, 
     ATTRIBUTE_DATE11 				DATE, 
     ATTRIBUTE_DATE12 				DATE, 
     EMAIL_ADDRESS 					VARCHAR2(320), 
     DELIVERY_CHANNEL 				VARCHAR2(30), 
     BANK_INSTRUCTION_1 				VARCHAR2(30), 
     BANK_INSTRUCTION_2 				VARCHAR2(30), 
     BANK_INSTRUCTION 				VARCHAR2(30), 
     SETTLEMENT_PRIORITY 				VARCHAR2(30), 
     PAYMENT_TEXT_MESSAGE_1 			VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_2 			VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_3 			VARCHAR2(150), 
     PAYEE_SERVICE_LEVEL 				VARCHAR2(30), 
     PAY_EACH_DOCUMENT_ALONE 			VARCHAR2(1), 
     BANK_CHARGE_BEARER 				VARCHAR2(30), 
     PAYMENT_REASON 					VARCHAR2(30), 
     PAYMENT_REASON_COMMENTS 			VARCHAR2(240), 
     DELIVERY_METHOD 					VARCHAR2(30), 
     REMITTANCE_E_MAIL 				VARCHAR2(255), 
     REMITTANCE_FAX 					VARCHAR2(15),
	 LOAD_BATCH                         VARCHAR2(300)
     -- CREATION_DATE 					DATE, 
     -- CREATED_BY 						VARCHAR2(100), 
     -- LAST_UPDATE_DATE 				DATE, 
     -- LAST_UPDATED_BY 					VARCHAR2(100)	 
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_bank_accts_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_bank_accts_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_BANK_ACCTS_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	  migration_status VARCHAR2(50),
     TEMP_EXT_PARTY_ID NUMBER, 
     TEMP_EXT_BANK_ACCT_ID NUMBER, 
     BANK_NAME VARCHAR2(360), 
     BRANCH_NAME VARCHAR2(360), 
     XXMX_BRANCH_NUMBER  VARCHAR2(30),
     COUNTRY_CODE VARCHAR2(2), 
     BANK_ACCOUNT_NAME VARCHAR2(80), 
     BANK_ACCOUNT_NUM VARCHAR2(100), 
     CURRENCY_CODE VARCHAR2(15), 
     FOREIGN_PAYMENT_USE_FLAG VARCHAR2(1), 
     START_DATE DATE, 
     END_DATE DATE, 
     IBAN VARCHAR2(50), 
     CHECK_DIGITS VARCHAR2(30), 
     BANK_ACCOUNT_NAME_ALT VARCHAR2(320), 
     BANK_ACCOUNT_TYPE VARCHAR2(25), 
     ACCOUNT_SUFFIX VARCHAR2(30), 
     DESCRIPTION VARCHAR2(240), 
     AGENCY_LOCATION_CODE VARCHAR2(30), 
     EXCHANGE_RATE_AGREEMENT_NUM VARCHAR2(80), 
     EXCHANGE_RATE_AGREEMENT_TYPE VARCHAR2(80), 
     EXCHANGE_RATE NUMBER, 
     SECONDARY_ACCOUNT_REFERENCE VARCHAR2(30), 
     SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360),
     SUPPLIER_SITE_ID NUMBER,
     SUPPLIER_SITE VARCHAR2(15),
     ATTRIBUTE_CATEGORY VARCHAR2(150), 
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
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(100),
	 LOAD_BATCH       VARCHAR2(300)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_cont_addrs_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_cont_addrs_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_CONT_ADDRS_STG 
   ( 
     file_set_id                    VARCHAR2(30), 
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10), 
	 SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360), 
	 SUPPLIER_SITE_ID NUMBER,
     ADDRESS_NAME VARCHAR2(240), 
     FIRST_NAME VARCHAR2(150), 
     LAST_NAME VARCHAR2(150), 
     EMAIL_ADDRESS VARCHAR2(320),
	 LOAD_BATCH    VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_contacts_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_contacts_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_CONTACTS_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10), 
	 SUPPLIER_CONTACT_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360), 
     PREFIX VARCHAR2(30), 
     FIRST_NAME VARCHAR2(150), 
     FIRST_NAME_NEW VARCHAR2(150), 
     MIDDLE_NAME VARCHAR2(60), 
     LAST_NAME VARCHAR2(150), 
     LAST_NAME_NEW VARCHAR2(150), 
     JOB_TITLE VARCHAR2(100), 
     PRIMARY_ADMIN_CONTACT VARCHAR2(1), 
     EMAIL_ADDRESS VARCHAR2(360), 
     EMAIL_ADDRESS_NEW VARCHAR2(360), 
     PHONE_COUNTRY_CODE VARCHAR2(10), 
     AREA_CODE VARCHAR2(10), 
     PHONE VARCHAR2(40), 
     PHONE_EXTENSION VARCHAR2(40), 
     FAX_COUNTRY_CODE VARCHAR2(10), 
     FAX_AREA_CODE VARCHAR2(10), 
     FAX VARCHAR2(40), 
     MOBILE_COUNTRY_CODE VARCHAR2(10), 
     MOBILE_AREA_CODE VARCHAR2(10), 
     MOBILE VARCHAR2(40), 
     INACTIVE_DATE DATE, 
     ATTRIBUTE_CATEGORY VARCHAR2(30), 
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
     ATTRIBUTE30 VARCHAR2(255), 
     ATTRIBUTE_NUMBER1 NUMBER, 
     ATTRIBUTE_NUMBER2 NUMBER, 
     ATTRIBUTE_NUMBER3 NUMBER, 
     ATTRIBUTE_NUMBER4 NUMBER, 
     ATTRIBUTE_NUMBER5 NUMBER, 
     ATTRIBUTE_NUMBER6 NUMBER, 
     ATTRIBUTE_NUMBER7 NUMBER, 
     ATTRIBUTE_NUMBER8 NUMBER, 
     ATTRIBUTE_NUMBER9 NUMBER, 
     ATTRIBUTE_NUMBER10 NUMBER, 
     ATTRIBUTE_NUMBER11 NUMBER, 
     ATTRIBUTE_NUMBER12 NUMBER, 
     ATTRIBUTE_DATE1 DATE, 
     ATTRIBUTE_DATE2 DATE, 
     ATTRIBUTE_DATE3 DATE, 
     ATTRIBUTE_DATE4 DATE, 
     ATTRIBUTE_DATE5 DATE, 
     ATTRIBUTE_DATE6 DATE, 
     ATTRIBUTE_DATE7 DATE, 
     ATTRIBUTE_DATE8 DATE, 
     ATTRIBUTE_DATE9 DATE, 
     ATTRIBUTE_DATE10 DATE, 
     ATTRIBUTE_DATE11 DATE, 
     ATTRIBUTE_DATE12 DATE, 
     USER_ACCOUNT_ACTION VARCHAR2(50), 
     ROLE1 VARCHAR2(150), 
     ROLE2 VARCHAR2(150), 
     ROLE3 VARCHAR2(150), 
     ROLE4 VARCHAR2(150), 
     ROLE5 VARCHAR2(150), 
     ROLE6 VARCHAR2(150), 
     ROLE7 VARCHAR2(150), 
     ROLE8 VARCHAR2(150), 
     ROLE9 VARCHAR2(150), 
     ROLE10 VARCHAR2(150),
	 LOAD_BATCH   VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_payees_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_payees_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_PAYEES_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     TEMP_EXT_PAYEE_ID NUMBER, 
     BUSINESS_UNIT VARCHAR2(240), 
     VENDOR_CODE VARCHAR2(30), 
     VENDOR_SITE_CODE VARCHAR2(15), 
     EXCLUSIVE_PAYMENT_FLAG VARCHAR2(1), 
     DEFAULT_PAYMENT_METHOD_CODE VARCHAR2(30), 
     DELIVERY_CHANNEL_CODE VARCHAR2(30), 
     SETTLEMENT_PRIORITY VARCHAR2(30), 
     REMIT_ADVICE_DELIVERY_METHOD VARCHAR2(30), 
     REMIT_ADVICE_EMAIL VARCHAR2(255), 
     REMIT_ADVICE_FAX VARCHAR2(100), 
     BANK_INSTRUCTION1_CODE VARCHAR2(30), 
     BANK_INSTRUCTION2_CODE VARCHAR2(30), 
     BANK_INSTRUCTION_DETAILS VARCHAR2(255), 
     PAYMENT_REASON_CODE VARCHAR2(30), 
     PAYMENT_REASON_COMMENTS VARCHAR2(240), 
     PAYMENT_TEXT_MESSAGE1 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE2 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE3 VARCHAR2(150), 
     BANK_CHARGE_BEARER VARCHAR2(30), 
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100), 
     SUPPLIER_NAME VARCHAR2(360),
     SUPPLIER_ID NUMBER,
     SUPPLIER_SITE_ID NUMBER,
     SUPPLIER_SITE VARCHAR2(15),
	 LOAD_BATCH    VARCHAR2(300)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_pmt_instrs_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_pmt_instrs_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_PMT_INSTRS_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     TEMP_EXT_PARTY_ID NUMBER, 
     TEMP_EXT_BANK_ACCT_ID NUMBER, 
     TEMP_PMT_INSTR_USE_ID NUMBER, 
     PRIMARY_FLAG VARCHAR2(1), 
     ACCT_ASSIG_START_DATE DATE, 
     ACCT_ASSIG_END_DATE DATE, 
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(100),
     SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360),
     SUPPLIER_SITE_ID NUMBER,
     SUPPLIER_SITE VARCHAR2(15),
	 LOAD_BATCH  VARCHAR2(300)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_site_assigns_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_site_assigns_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_SITE_ASSIGNS_STG 
   ( 
     file_set_id                    VARCHAR2(30),     
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10), 
	 SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360), 
	 SUPPLIER_SITE_ID NUMBER,
     SUPPLIER_SITE VARCHAR2(15), 
     PROCUREMENT_BU VARCHAR2(240), 
     CLIENT_BU VARCHAR2(240), 
     BILL_TO_BU VARCHAR2(240), 
     SHIP_TO_LOCATION VARCHAR2(60), 
     BILL_TO_LOCATION VARCHAR2(60), 
     USE_WITHHOLDING_TAX VARCHAR2(1), 
     WITHHOLDING_TAX_GROUP VARCHAR2(25), 
     LIABILITY_DISTRIBUTION VARCHAR2(800), 
     PREPAYMENT_DISTRIBUTION VARCHAR2(800), 
     BILLS_PAYABLE_DISTRIBUTION VARCHAR2(800), 
     DISTRIBUTION_SET VARCHAR2(50), 
     INACTIVE_DATE DATE,
	 LOAD_BATCH  VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supplier_sites_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supplier_sites_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPPLIER_SITES_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10),
     SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360), 
     PROCUREMENT_BU VARCHAR2(240), 
	 PARTY_SITE_ID NUMBER,
     ADDRESS_NAME VARCHAR2(240), 
	 SUPPLIER_SITE_ID NUMBER,
     SUPPLIER_SITE VARCHAR2(15), 
     SUPPLIER_SITE_NEW VARCHAR2(15), 
     INACTIVE_DATE DATE, 
     SOURCING_ONLY VARCHAR2(1), 
     PURCHASING VARCHAR2(1), 
     PROCUREMENT_CARD VARCHAR2(1), 
     PAY VARCHAR2(1), 
     PRIMARY_PAY VARCHAR2(1), 
     INCOME_TAX_REPORTING_SITE VARCHAR2(1), 
     ALTERNATE_SITE_NAME VARCHAR2(320), 
     CUSTOMER_NUMBER VARCHAR2(25), 
     B2B_COMMUNICATION_METHOD VARCHAR2(10), 
     B2B_SUPPLIER_SITE_CODE VARCHAR2(256), 
     COMMUNICATION_METHOD VARCHAR2(25), 
     E_MAIL VARCHAR2(2000), 
     FAX_COUNTRY_CODE VARCHAR2(10), 
     FAX_AREA_CODE VARCHAR2(10), 
     FAX VARCHAR2(15), 
     HOLD_PURCHASING_DOCUMENTS VARCHAR2(1), 
     HOLD_REASON VARCHAR2(240), 
     CARRIER VARCHAR2(360), 
     MODE_OF_TRANSPORT VARCHAR2(30), 
     SERVICE_LEVEL VARCHAR2(30), 
     FREIGHT_TERMS VARCHAR2(25), 
     PAY_ON_RECEIPT VARCHAR2(25), 
     FOB VARCHAR2(25), 
     COUNTRY_OF_ORIGIN VARCHAR2(2), 
     BUYER_MANAGED_TRANSPORTATION VARCHAR2(1), 
     PAY_ON_USE VARCHAR2(1), 
     AGING_ONSET_POINT VARCHAR2(1), 
     AGING_PERIOD_DAYS NUMBER(5,0), 
     CONSUMPTION_ADVICE_FREQUENCY VARCHAR2(30), 
     CONSUMPTION_ADVICE_SUMMARY VARCHAR2(30), 
     DEFAULT_PAY_SITE VARCHAR2(15), 
     INVOICE_SUMMARY_LEVEL VARCHAR2(25), 
     GAPLESS_INVOICE_NUMBERING VARCHAR2(1), 
     SELLING_COMPANY_IDENTIFIER VARCHAR2(10), 
     CREATE_DEBIT_MEMO_FROM_RETURN VARCHAR2(25), 
     SHIP_TO_EXCEPTION_ACTION VARCHAR2(25), 
     RECEIPT_ROUTING NUMBER(18,0), 
     OVER_RECEIPT_TOLERANCE NUMBER, 
     OVER_RECEIPT_ACTION VARCHAR2(25), 
     EARLY_RECEIPT_TOLERANCE NUMBER, 
     LATE_RECEIPT_TOLERANCE NUMBER, 
     ALLOW_SUBSTITUTE_RECEIPTS VARCHAR2(1), 
     ALLOW_UNORDERED_RECEIPTS VARCHAR2(1), 
     RECEIPT_DATE_EXCEPTION VARCHAR2(25), 
     INVOICE_CURRENCY VARCHAR2(15), 
     INVOICE_AMOUNT_LIMIT NUMBER, 
     INVOICE_MATCH_OPTION VARCHAR2(25), 
     MATCH_APPROVAL_LEVEL VARCHAR2(1), 
     PAYMENT_CURRENCY VARCHAR2(15), 
     PAYMENT_PRIORITY NUMBER, 
     PAY_GROUP VARCHAR2(25), 
     QUANTITY_TOLERANCES VARCHAR2(255), 
     AMOUNT_TOLERANCE VARCHAR2(255), 
     HOLD_ALL_INVOICES VARCHAR2(1), 
     HOLD_UNMATCHED_INVOICES VARCHAR2(1), 
     HOLD_UNVALIDATED_INVOICES VARCHAR2(1), 
     PAYMENT_HOLD_BY NUMBER(18,0), 
     PAYMENT_HOLD_DATE DATE, 
     PAYMENT_HOLD_REASON VARCHAR2(240), 
     PAYMENT_TERMS VARCHAR2(50), 
     TERMS_DATE_BASIS VARCHAR2(25), 
     PAY_DATE_BASIS VARCHAR2(25), 
     BANK_CHARGE_DEDUCTION_TYPE VARCHAR2(25), 
     ALWAYS_TAKE_DISCOUNT VARCHAR2(1), 
     EXCLUDE_FREIGHT_FROM_DISCOUNT VARCHAR2(1), 
     EXCLUDE_TAX_FROM_DISCOUNT VARCHAR2(1), 
     CREATE_INTEREST_INVOICES VARCHAR2(1), 
     VAT_CODE VARCHAR2(30), 
     TAX_REGISTRATION_NUMBER VARCHAR2(20), 
     PAYMENT_METHOD VARCHAR2(30), 
     DELIVERY_CHANNEL VARCHAR2(30), 
     BANK_INSTRUCTION_1 VARCHAR2(30), 
     BANK_INSTRUCTION_2 VARCHAR2(30), 
     BANK_INSTRUCTION VARCHAR2(255), 
     SETTLEMENT_PRIORITY VARCHAR2(30), 
     PAYMENT_TEXT_MESSAGE_1 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_2 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_3 VARCHAR2(150), 
     BANK_CHARGE_BEARER VARCHAR2(30), 
     PAYMENT_REASON VARCHAR2(30), 
     PAYMENT_REASON_COMMENTS VARCHAR2(240), 
     DELIVERY_METHOD VARCHAR2(30), 
     REMITTANCE_E_MAIL VARCHAR2(255), 
     REMITTANCE_FAX VARCHAR2(15), 
     ATTRIBUTE_CATEGORY VARCHAR2(30), 
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
     ATTRIBUTE_DATE1 DATE, 
     ATTRIBUTE_DATE2 DATE, 
     ATTRIBUTE_DATE3 DATE, 
     ATTRIBUTE_DATE4 DATE, 
     ATTRIBUTE_DATE5 DATE, 
     ATTRIBUTE_DATE6 DATE, 
     ATTRIBUTE_DATE7 DATE, 
     ATTRIBUTE_DATE8 DATE, 
     ATTRIBUTE_DATE9 DATE, 
     ATTRIBUTE_DATE10 DATE, 
     ATTRIBUTE_TIMESTAMP1 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP2 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP3 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP4 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP5 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP6 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP7 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP8 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP9 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP10 TIMESTAMP (6), 
     ATTRIBUTE_NUMBER1 NUMBER, 
     ATTRIBUTE_NUMBER2 NUMBER, 
     ATTRIBUTE_NUMBER3 NUMBER, 
     ATTRIBUTE_NUMBER4 NUMBER, 
     ATTRIBUTE_NUMBER5 NUMBER, 
     ATTRIBUTE_NUMBER6 NUMBER, 
     ATTRIBUTE_NUMBER7 NUMBER, 
     ATTRIBUTE_NUMBER8 NUMBER, 
     ATTRIBUTE_NUMBER9 NUMBER, 
     ATTRIBUTE_NUMBER10 NUMBER, 
     GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30), 
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
     GLOBAL_ATTRIBUTE_DATE1 DATE, 
     GLOBAL_ATTRIBUTE_DATE2 DATE, 
     GLOBAL_ATTRIBUTE_DATE3 DATE, 
     GLOBAL_ATTRIBUTE_DATE4 DATE, 
     GLOBAL_ATTRIBUTE_DATE5 DATE, 
     GLOBAL_ATTRIBUTE_DATE6 DATE, 
     GLOBAL_ATTRIBUTE_DATE7 DATE, 
     GLOBAL_ATTRIBUTE_DATE8 DATE, 
     GLOBAL_ATTRIBUTE_DATE9 DATE, 
     GLOBAL_ATTRIBUTE_DATE10 DATE, 
     GLOBAL_ATTRIBUTE_TIMESTAMP1 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP2 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP3 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP4 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP5 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP6 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP7 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP8 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP9 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP10 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER6 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER7 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER8 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER9 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER10 NUMBER, 
     REQUIRED_ACKNOWLEDGEMENT VARCHAR2(30), 
     ACKNOWLEDGE_WITHIN_DAYS NUMBER(*,0), 
     INVOICE_CHANNEL VARCHAR2(30), 
     PAYEE_SERVICE_LEVEL_CODE VARCHAR2(30), 
     EXCLUSIVE_PAYMENT_FLAG VARCHAR2(1),
	 LOAD_BATCH  VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_suppliers_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_suppliers_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPPLIERS_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10), 
	 SUPPLIER_ID NUMBER,
     SUPPLIER_NAME VARCHAR2(360), 
     SUPPLIER_NAME_NEW VARCHAR2(360), 
     SUPPLIER_NUMBER VARCHAR2(30), 
     ALTERNATE_NAME VARCHAR2(360), 
     TAX_ORGANIZATION_TYPE VARCHAR2(25), 
     SUPPLIER_TYPE VARCHAR2(30), 
     INACTIVE_DATE DATE, 
     BUSINESS_RELATIONSHIP VARCHAR2(30), 
     PARENT_SUPPLIER VARCHAR2(360), 
     ALIAS VARCHAR2(360), 
     DUNS_NUMBER VARCHAR2(30), 
     ONE_TIME_SUPPLIER VARCHAR2(1), 
     CUSTOMER_NUMBER VARCHAR2(25), 
     SIC VARCHAR2(25), 
     NATIONAL_INSURANCE_NUMBER VARCHAR2(30), 
     CORPORATE_WEB_SITE VARCHAR2(150), 
     CHIEF_EXECUTIVE_TITLE VARCHAR2(240), 
     CHIF_EXECUTIVE_NAME VARCHAR2(240), 
     BUSINESS_CLASSIFICATION VARCHAR2(1), 
     TAXPAYER_COUNTRY VARCHAR2(3), 
     TAXPAYER_ID VARCHAR2(30), 
     FEDERAL_REPORTABLE VARCHAR2(1), 
     FEDERAL_INCOME_TAX_TYPE VARCHAR2(10), 
     STATE_REPORTABLE VARCHAR2(1), 
     TAX_REPORTING_NAME VARCHAR2(80), 
     NAME_CONTROL VARCHAR2(4), 
     TAX_VERIFICATION_DATE DATE, 
     USE_WITHHOLDING_TAX VARCHAR2(1), 
     WITHHOLDING_TAX_GROUP VARCHAR2(25), 
     SUPPLIER_VAT_CODE VARCHAR2(30), 
     TAX_REGISTRATION_NUMBER VARCHAR2(20), 
     AUTO_TAX_CALC_OVERRIDE VARCHAR2(1), 
     SUPPLIER_PAYMENT_METHOD VARCHAR2(30), 
     DELIVERY_CHANNEL VARCHAR2(30), 
     BANK_INSTRUCTION_1 VARCHAR2(30), 
     BANK_INSTRUCTION_2 VARCHAR2(30), 
     BANK_INSTRUCTION VARCHAR2(30), 
     SETTLEMENT_PRIORITY VARCHAR2(255), 
     PAYMENT_TEXT_MESSAGE_1 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_2 VARCHAR2(150), 
     PAYMENT_TEXT_MESSAGE_3 VARCHAR2(150), 
     BANK_CHARGE_BEARER VARCHAR2(30), 
     PAYMENT_REASON VARCHAR2(30), 
     PAYMENT_REASON_COMMENTS VARCHAR2(30), 
     PAYMENT_FORMAT VARCHAR2(30), 
     ATTRIBUTE_CATEGORY VARCHAR2(30), 
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
     ATTRIBUTE_DATE1 DATE, 
     ATTRIBUTE_DATE2 DATE, 
     ATTRIBUTE_DATE3 DATE, 
     ATTRIBUTE_DATE4 DATE, 
     ATTRIBUTE_DATE5 DATE, 
     ATTRIBUTE_DATE6 DATE, 
     ATTRIBUTE_DATE7 DATE, 
     ATTRIBUTE_DATE8 DATE, 
     ATTRIBUTE_DATE9 DATE, 
     ATTRIBUTE_DATE10 DATE, 
     ATTRIBUTE_TIMESTAMP1 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP2 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP3 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP4 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP5 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP6 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP7 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP8 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP9 TIMESTAMP (6), 
     ATTRIBUTE_TIMESTAMP10 TIMESTAMP (6), 
     ATTRIBUTE_NUMBER1 NUMBER, 
     ATTRIBUTE_NUMBER2 NUMBER, 
     ATTRIBUTE_NUMBER3 NUMBER, 
     ATTRIBUTE_NUMBER4 NUMBER, 
     ATTRIBUTE_NUMBER5 NUMBER, 
     ATTRIBUTE_NUMBER6 NUMBER, 
     ATTRIBUTE_NUMBER7 NUMBER, 
     ATTRIBUTE_NUMBER8 NUMBER, 
     ATTRIBUTE_NUMBER9 NUMBER, 
     ATTRIBUTE_NUMBER10 NUMBER, 
     GLOBAL_ATTRIBUTE_CATEGORY VARCHAR2(30), 
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
     GLOBAL_ATTRIBUTE_DATE1 DATE, 
     GLOBAL_ATTRIBUTE_DATE2 DATE, 
     GLOBAL_ATTRIBUTE_DATE3 DATE, 
     GLOBAL_ATTRIBUTE_DATE4 DATE, 
     GLOBAL_ATTRIBUTE_DATE5 DATE, 
     GLOBAL_ATTRIBUTE_DATE6 DATE, 
     GLOBAL_ATTRIBUTE_DATE7 DATE, 
     GLOBAL_ATTRIBUTE_DATE8 DATE, 
     GLOBAL_ATTRIBUTE_DATE9 DATE, 
     GLOBAL_ATTRIBUTE_DATE10 DATE, 
     GLOBAL_ATTRIBUTE_TIMESTAMP1 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP2 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP3 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP4 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP5 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP6 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP7 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP8 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP9 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_TIMESTAMP10 TIMESTAMP (6), 
     GLOBAL_ATTRIBUTE_NUMBER1 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER2 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER3 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER4 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER5 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER6 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER7 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER8 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER9 NUMBER, 
     GLOBAL_ATTRIBUTE_NUMBER10 NUMBER, 
     REGISRTY_ID VARCHAR2(30), 
     SERVICE_LEVEL_CODE VARCHAR2(30), 
     EXCLUSIVE_PAYMENT_FLAG VARCHAR2(1), 
     REMIT_ADVICE_DELIVERY_METHOD VARCHAR2(30), 
     REMIT_ADVICE_EMAIL VARCHAR2(255), 
     REMIT_ADVICE_FAX VARCHAR2(100),
     DATAFOX_COMPANY_ID          VARCHAR2(30),
	 LOAD_BATCH                  VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT Creating Table xxmx_ap_supp_3rd_pty_rels_stg
PROMPT
--
--------------------------------------------------------
--  DDL for Table xxmx_ap_supp_3rd_pty_rels_stg
--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)
--------------------------------------------------------

  CREATE TABLE XXMX_STG.XXMX_AP_SUPP_3RD_PTY_RELS_STG 
   ( 
     file_set_id                    VARCHAR2(30),
     migration_set_id NUMBER,
     migration_set_name VARCHAR2(100),                 
	 migration_status VARCHAR2(50),
     IMPORT_ACTION VARCHAR2(10), 
     SUPPLIER_NAME VARCHAR2(360), 
     SUPPLIER_SITE VARCHAR2(15), 
	 RELATIONSHIP_ID NUMBER,
     PROCUREMENT_BU VARCHAR2(240), 
     DEFAULT_RELATIONSHIP_FLAG VARCHAR2(1), 
     REMIT_TO_SUPPLIER VARCHAR2(240), 
     REMIT_TO_ADDRESS VARCHAR2(15), 
     FROM_DATE DATE, 
     TO_DATE DATE, 
     DESCRIPTION VARCHAR2(1000),
    LOAD_BATCH  VARCHAR2(300)
     -- CREATION_DATE DATE, 
     -- CREATED_BY VARCHAR2(100), 
     -- LAST_UPDATE_DATE DATE, 
     -- LAST_UPDATED_BY VARCHAR2(100)
   );
--
--
PROMPT
PROMPT
PROMPT *****************
PROMPT ** Completed
PROMPT *****************
--
--
--
