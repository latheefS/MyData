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
--** FILENAME  :  xxmx_ar_customers_dbi.sql
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


--
--
PROMPT
PROMPT
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Customers Data Migration
PROMPT **
PROMPT *************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Dropping Tables
PROMPT *********************
PROMPT
PROMPT
EXEC DropTable ('XXMX_HZ_CUST_ACCT_SITES_XFM')
EXEC DropTable ('XXMX_HZ_CUST_SITE_USES_XFM')
EXEC DropTable ('XXMX_HZ_CUST_ACCT_RELATE_XFM')
EXEC DropTable ('XXMX_HZ_PARTY_CLASSIFS_XFM')
EXEC DropTable ('XXMX_HZ_ORG_CONTACTS_XFM')
EXEC DropTable ('XXMX_HZ_CONTACT_POINTS_XFM')
EXEC DropTable ('XXMX_HZ_ORG_CONTACT_ROLES_XFM')
EXEC DropTable ('XXMX_HZ_CUST_ACCOUNTS_XFM')
EXEC DropTable ('XXMX_HZ_CUST_ACCT_CONTACTS_XFM')
EXEC DropTable ('XXMX_IBY_CUST_BANK_ACCTS_XFM')
EXEC DropTable ('XXMX_RA_CUST_RCPT_METHODS_XFM')
EXEC DropTable ('XXMX_HZ_LOCATIONS_XFM')
EXEC DropTable ('XXMX_HZ_PARTY_SITES_XFM')
EXEC DropTable ('XXMX_HZ_PARTY_SITE_USES_XFM')
EXEC DropTable ('XXMX_HZ_PARTIES_XFM')
EXEC DropTable ('XXMX_HZ_PERSON_LANGUAGE_XFM')
EXEC DropTable ('XXMX_HZ_CUST_PROFILES_XFM')
EXEC DropTable ('XXMX_HZ_RELATIONSHIPS_XFM')
EXEC DropTable ('XXMX_HZ_ROLE_RESPS_XFM')
EXEC DropTable ('XXMX_AR_CUST_BANKS_XFM')

PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_acct_sites_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_acct_sites_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),
      BATCH_ID           NUMBER,	 	  
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     ACCOUNT_NUMBER VARCHAR2(30), 
     CUST_SITE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     SITE_ORIG_SYSTEM VARCHAR2(30), 
     SITE_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PARTY_SITE_NUMBER VARCHAR2(30), 
     ACCT_SITE_LANGUAGE VARCHAR2(4), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CUSTOMER_CATEGORY_CODE VARCHAR2(30), 
     TRANSLATED_CUSTOMER_NAME VARCHAR2(360), 
     SET_CODE VARCHAR2(30), 
     START_DATE DATE, 
     END_DATE DATE, 
     KEY_ACCOUNT_FLAG VARCHAR2(1), 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(500),
     XXMX_STATUS VARCHAR2(1),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_site_uses_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_site_uses_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
     BATCH_ID           NUMBER,	 	  
     ACCOUNT_NUMBER VARCHAR2(30),    
     PARTY_SITE_NUMBER VARCHAR2(30),      
     CUST_SITE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     CUST_SITEUSE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITEUSE_ORIG_SYS_REF VARCHAR2(240), 
     SITE_USE_CODE VARCHAR2(30), 
     PRIMARY_FLAG VARCHAR2(1), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     LOCATION VARCHAR2(150), 
     SET_CODE VARCHAR2(30), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(500),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_acct_relate_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_acct_relate_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	  MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),
       BATCH_ID           NUMBER,	 	  
     INSERT_UPDATE_CODE VARCHAR2(30), 
     CUST_ACCT_REL_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ACCT_REL_ORIG_SYS_REF VARCHAR2(240), 
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     RELATED_CUST_ORIG_SYSTEM VARCHAR2(30), 
     RELATED_CUST_ORIG_SYS_REF VARCHAR2(240), 
     RELATIONSHIP_TYPE VARCHAR2(30), 
     CUSTOMER_RECIPROCAL_FLAG VARCHAR2(1), 
     BILL_TO_FLAG VARCHAR2(1), 
     SHIP_TO_FLAG VARCHAR2(1), 
     SET_CODE VARCHAR2(30), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(500),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_party_classifs_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_party_classifs_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	  MIGRATION_SET_ID NUMBER, 
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),
      BATCH_ID           NUMBER,	 	  
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CLASSIFIC_ORIG_SYSTEM VARCHAR2(30), 
     CLASSIFIC_ORIG_SYSTEM_REF VARCHAR2(240), 
     CLASS_CATEGORY VARCHAR2(30), 
     CLASS_CODE VARCHAR2(30), 
     START_DATE_ACTIVE DATE, 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     PRIMARY_FLAG VARCHAR2(1), 
     END_DATE_ACTIVE DATE, 
     RANK NUMBER, 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_org_contacts_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_org_contacts_xfm 
   ( 
	  FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),
       BATCH_ID           NUMBER,	 	  
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CONTACT_NUMBER VARCHAR2(30), 
     DEPARTMENT_CODE VARCHAR2(30), 
     DEPARTMENT VARCHAR2(60), 
     JOB_TITLE VARCHAR2(100), 
     JOB_TITLE_CODE VARCHAR2(30), 
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
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PS_ORIG_SYSTEM VARCHAR2(30), 
     PS_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_contact_points_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_contact_points_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
      BATCH_ID           NUMBER,	 	 
     CP_ORIG_SYSTEM VARCHAR2(30), 
     CP_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     SITE_ORIG_SYSTEM VARCHAR2(30), 
     SITE_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PRIMARY_FLAG VARCHAR2(1), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CONTACT_POINT_TYPE VARCHAR2(30), 
     CONTACT_POINT_PURPOSE VARCHAR2(30), 
     EMAIL_ADDRESS VARCHAR2(320), 
     EMAIL_FORMAT VARCHAR2(30), 
     PHONE_AREA_CODE VARCHAR2(10), 
     PHONE_COUNTRY_CODE VARCHAR2(10), 
     PHONE_EXTENSION VARCHAR2(20), 
     PHONE_LINE_TYPE VARCHAR2(30), 
     PHONE_NUMBER VARCHAR2(40), 
     URL VARCHAR2(2000), 
     PHONE_CALLING_CALENDAR VARCHAR2(30), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_org_contact_roles_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_org_contact_roles_xfm 
   ( FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),
	   BATCH_ID           NUMBER,	 
     INTERFACE_ROW_ID VARCHAR2(80),
     INSERT_UPDATE_CODE VARCHAR2(30), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CONTACT_ROLE_ORIG_SYSTEM VARCHAR2(30), 
     CONTACT_ROLE_ORIG_SYS_REF VARCHAR2(240), 
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     ROLE_TYPE VARCHAR2(30), 
     ROLE_LEVEL VARCHAR2(1), 
     PRIMARY_FLAG VARCHAR2(1), 
     PRIMARY_CONTACT_PER_ROLE_TYPE VARCHAR2(1), 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_accounts_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_accounts_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
      BATCH_ID           NUMBER,	 	 
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     ACCOUNT_NUMBER VARCHAR2(30), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CUSTOMER_TYPE VARCHAR2(30), 
     CUSTOMER_CLASS_CODE VARCHAR2(30), 
     ACCOUNT_NAME VARCHAR2(240), 
     ACCOUNT_ESTABLISHED_DATE DATE, 
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
     ACCOUNT_TERMINATION_DATE DATE, 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
     XXMX_STATUS VARCHAR2(1),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_acct_contacts_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_acct_contacts_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),	
      BATCH_ID           NUMBER,	 	 
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CUST_SITE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     CUST_CONTACT_ORIG_SYSTEM VARCHAR2(30), 
     CUST_CONTACT_ORIG_SYS_REF VARCHAR2(240), 
     ROLE_TYPE VARCHAR2(30), 
     PRIMARY_FLAG VARCHAR2(1), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     SOURCE_CODE VARCHAR2(150), 
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
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_iby_cust_bank_accts_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_iby_cust_bank_accts_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
	  BATCH_ID           NUMBER,	 
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CUST_SITE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     BANK_ACCOUNT_NAME VARCHAR2(80), 
     PRIMARY_FLAG VARCHAR2(1), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     BANK_ACCOUNT_NUM VARCHAR2(30), 
     BANK_ACCOUNT_CURRENCY_CODE VARCHAR2(15), 
     BANK_ACCOUNT_INACTIVE_DATE DATE, 
     BANK_ACCOUNT_DESCRIPTION VARCHAR2(240), 
     BANK_NAME VARCHAR2(60), 
     BANK_BRANCH_NAME VARCHAR2(60), 
     BANK_NUM VARCHAR2(25), 
     BANK_BRANCH_DESCRIPTION VARCHAR2(240), 
     BANK_BRANCH_ADDRESS1 VARCHAR2(35), 
     BANK_BRANCH_ADDRESS2 VARCHAR2(35), 
     BANK_BRANCH_ADDRESS3 VARCHAR2(35), 
     BANK_BRANCH_CITY VARCHAR2(25), 
     BANK_BRANCH_STATE VARCHAR2(25), 
     BANK_BRANCH_ZIP VARCHAR2(20), 
     BANK_BRANCH_PROVINCE VARCHAR2(25), 
     BANK_BRANCH_COUNTRY VARCHAR2(25), 
     BANK_BRANCH_AREA_CODE VARCHAR2(10), 
     BANK_BRANCH_PHONE VARCHAR2(15), 
     BANK_ACCOUNT_ATT_CATEGORY VARCHAR2(30), 
     BANK_ACCOUNT_ATTRIBUTE1 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE10 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE11 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE12 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE13 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE14 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE15 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE2 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE3 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE4 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE5 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE6 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE7 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE8 VARCHAR2(150), 
     BANK_ACCOUNT_ATTRIBUTE9 VARCHAR2(150), 
     BANK_BRANCH_ATT_CATEGORY VARCHAR2(30), 
     BANK_BRANCH_ATTRIBUTE1 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE10 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE11 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE12 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE13 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE14 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE15 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE2 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE3 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE4 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE5 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE6 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE7 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE8 VARCHAR2(150), 
     BANK_BRANCH_ATTRIBUTE9 VARCHAR2(150), 
     BANK_NUMBER VARCHAR2(30), 
     BANK_BRANCH_ADDRESS4 VARCHAR2(35), 
     BANK_BRANCH_COUNTY VARCHAR2(25), 
     BANK_BRANCH_EFT_USER_NUMBER VARCHAR2(30), 
     BANK_ACCOUNT_CHECK_DIGITS VARCHAR2(30), 
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
     ORG_ID NUMBER, 
     BANK_HOME_COUNTRY VARCHAR2(2), 
     LOCALINSTR VARCHAR2(35), 
     SERVICE_LEVEL VARCHAR2(35), 
     PURPOSE_CODE VARCHAR2(30), 
     BANK_CHARGE_BEARER_CODE VARCHAR2(30), 
     DEBIT_ADVICE_DELIVERY_METHOD VARCHAR2(30), 
     DEBIT_ADVICE_EMAIL VARCHAR2(155), 
     DEBIT_ADVICE_FAX VARCHAR2(100), 
     EFT_SWIFT_CODE VARCHAR2(30), 
     COUNTRY_CODE VARCHAR2(2), 
     FOREIGN_PAYMENT_USE_FLAG VARCHAR2(1), 
     PRIMARY_ACCT_OWNER_FLAG VARCHAR2(1), 
     BANK_ACCOUNT_NAME_ALT VARCHAR2(320), 
     BANK_ACCOUNT_TYPE VARCHAR2(25), 
     ACCOUNT_SUFFIX VARCHAR2(30), 
     AGENCY_LOCATION_CODE VARCHAR2(30), 
     IBAN VARCHAR2(50), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(200),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
   
   --------------------------------------------------------
--  DDL for Table xxmx_ra_cust_rcpt_methods_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_ra_cust_rcpt_methods_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
	  BATCH_ID           NUMBER,	 
     CUST_ORIG_SYSTEM VARCHAR2(30), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     PAYMENT_METHOD_NAME VARCHAR2(30), 
     PRIMARY_FLAG VARCHAR2(1), 
     CUST_SITE_ORIG_SYSTEM VARCHAR2(30), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     ORG_ID NUMBER, 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(250),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
   
   --------------------------------------------------------
--  DDL for Table xxmx_hz_locations_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_locations_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
     MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),  
       BATCH_ID           NUMBER,	 	  
     LOCATION_ORIG_SYSTEM VARCHAR2(30), 
     LOCATION_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     COUNTRY VARCHAR2(2), 
     ADDRESS1 VARCHAR2(240), 
     ADDRESS2 VARCHAR2(240), 
     ADDRESS3 VARCHAR2(240), 
     ADDRESS4 VARCHAR2(240), 
     CITY VARCHAR2(60), 
     STATE VARCHAR2(60), 
     PROVINCE VARCHAR2(60), 
     COUNTY VARCHAR2(60), 
     POSTAL_CODE VARCHAR2(60), 
     POSTAL_PLUS4_CODE VARCHAR2(10), 
     LOCATION_LANGUAGE VARCHAR2(4), 
     DESCRIPTION VARCHAR2(2000), 
     SHORT_DESCRIPTION VARCHAR2(240), 
     SALES_TAX_GEOCODE VARCHAR2(30), 
     SALES_TAX_INSIDE_CITY_LIMITS VARCHAR2(1), 
     TIMEZONE_CODE VARCHAR2(50), 
     ADDRESS1_STD VARCHAR2(240), 
     ADAPTER_CONTENT_SOURCE VARCHAR2(30), 
     ADDR_VALID_STATUS_CODE VARCHAR2(30), 
     DATE_VALIDATED DATE, 
     ADDRESS_EFFECTIVE_DATE DATE, 
     ADDRESS_EXPIRATION_DATE DATE, 
     VALIDATED_FLAG VARCHAR2(1), 
     DO_NOT_VALIDATE_FLAG VARCHAR2(1), 
     INTERFACE_STATUS VARCHAR2(30), 
     ERROR_ID NUMBER, 
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
     GNR_STATUS VARCHAR2(4), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_party_sites_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_party_sites_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50), 
      BATCH_ID           NUMBER,	 	 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     SITE_ORIG_SYSTEM VARCHAR2(30), 
     SITE_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOCATION_ORIG_SYSTEM VARCHAR2(30), 
     LOCATION_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     PARTY_SITE_NAME VARCHAR2(240), 
     PARTY_SITE_NUMBER VARCHAR2(30), 
     START_DATE_ACTIVE DATE, 
     END_DATE_ACTIVE DATE, 
     MAILSTOP VARCHAR2(60), 
     IDENTIFYING_ADDRESS_FLAG VARCHAR2(1), 
     PARTY_SITE_LANGUAGE VARCHAR2(4), 
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
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_party_site_uses_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_party_site_uses_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),  
     BATCH_ID           NUMBER,	 	 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     SITE_ORIG_SYSTEM VARCHAR2(30), 
     SITE_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     SITE_USE_TYPE VARCHAR2(30), 
     PRIMARY_FLAG VARCHAR2(1), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     START_DATE DATE, 
     END_DATE DATE, 
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
     SITEUSE_ORIG_SYSTEM VARCHAR2(30), 
     SITEUSE_ORIG_SYSTEM_REF VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_parties_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_parties_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
	  BATCH_ID           NUMBER,	 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     PARTY_TYPE VARCHAR2(30), 
     PARTY_NUMBER VARCHAR2(30), 
     SALUTATION VARCHAR2(60), 
     PARTY_USAGE_CODE VARCHAR2(30), 
     JGZZ_FISCAL_CODE VARCHAR2(60), 
     ORGANIZATION_NAME VARCHAR2(360), 
     DUNS_NUMBER_C VARCHAR2(30), 
     PERSON_FIRST_NAME VARCHAR2(150), 
     PERSON_LAST_NAME VARCHAR2(150), 
     PERSON_LAST_NAME_PREFIX VARCHAR2(30), 
     PERSON_SECOND_LAST_NAME VARCHAR2(150), 
     PERSON_MIDDLE_NAME VARCHAR2(60), 
     PERSON_NAME_SUFFIX VARCHAR2(30), 
     PERSON_TITLE VARCHAR2(60), 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_person_language_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_person_language_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),
      BATCH_ID           NUMBER,	 	 
     PARTY_ORIG_SYSTEM VARCHAR2(30), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LANGUAGE_NAME VARCHAR2(30), 
     NATIVE_LANGUAGE_FLAG VARCHAR2(1), 
     PRIMARY_LANGUAGE_INDICATOR VARCHAR2(1), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_cust_profiles_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_cust_profiles_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	  MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	  MIGRATION_STATUS	VARCHAR2(50),   
	  BATCH_ID           NUMBER,	 
     INSERT_UPDATE_FLAG VARCHAR2(1),
     PARTY_ORIG_SYSTEM VARCHAR2(240), 
     PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CUST_ORIG_SYSTEM VARCHAR2(240), 
     CUST_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     CUST_SITE_ORIG_SYSTEM VARCHAR2(240), 
     CUST_SITE_ORIG_SYS_REF VARCHAR2(240), 
     CUSTOMER_PROFILE_CLASS_NAME VARCHAR2(30), 
     COLLECTOR_NAME VARCHAR2(30), 
     CREDIT_ANALYST_NAME VARCHAR2(240), 
     CREDIT_REVIEW_CYCLE VARCHAR2(20), 
     LAST_CREDIT_REVIEW_DATE DATE, 
     NEXT_CREDIT_REVIEW_DATE DATE, 
     CREDIT_BALANCE_STATEMENTS VARCHAR2(1), 
     CREDIT_CHECKING VARCHAR2(1), 
     CREDIT_HOLD VARCHAR2(1), 
     DISCOUNT_TERMS VARCHAR2(1), 
     DUNNING_LETTERS VARCHAR2(1), 
     INTEREST_CHARGES VARCHAR2(1), 
     STATEMENTS VARCHAR2(1), 
     TOLERANCE NUMBER, 
     TAX_PRINTING_OPTION VARCHAR2(30), 
     ACCOUNT_STATUS VARCHAR2(30), 
     AUTOCASH_HIERARCHY_NAME VARCHAR2(30), 
     CREDIT_RATING VARCHAR2(30), 
     DISCOUNT_GRACE_DAYS NUMBER, 
     INTEREST_PERIOD_DAYS NUMBER, 
     OVERRIDE_TERMS VARCHAR2(1), 
     PAYMENT_GRACE_DAYS NUMBER, 
     PERCENT_COLLECTABLE NUMBER, 
     RISK_CODE VARCHAR2(30), 
     STANDARD_TERM_NAME VARCHAR2(15), 
     STATEMENT_CYCLE_NAME VARCHAR2(15), 
     CHARGE_ON_FINANCE_CHARGE_FLAG VARCHAR2(1), 
     GROUPING_RULE_NAME VARCHAR2(40), 
     CURRENCY_CODE VARCHAR2(15), 
     AUTO_REC_MIN_RECEIPT_AMOUNT NUMBER, 
     INTEREST_RATE NUMBER, 
     MAX_INTEREST_CHARGE NUMBER, 
     MIN_DUNNING_AMOUNT NUMBER, 
     MIN_DUNNING_INVOICE_AMOUNT NUMBER, 
     MIN_FC_BALANCE_AMOUNT NUMBER, 
     MIN_FC_INVOICE_AMOUNT NUMBER, 
     MIN_STATEMENT_AMOUNT NUMBER, 
     OVERALL_CREDIT_LIMIT NUMBER, 
     TRX_CREDIT_LIMIT NUMBER, 
     ATTRIBUTE_CATEGORY VARCHAR2(30), 
     ATTRIBUTE1 VARCHAR2(150), 
     ATTRIBUTE10 VARCHAR2(150), 
     ATTRIBUTE11 VARCHAR2(150), 
     ATTRIBUTE12 VARCHAR2(150), 
     ATTRIBUTE13 VARCHAR2(150), 
     ATTRIBUTE14 VARCHAR2(150), 
     ATTRIBUTE15 VARCHAR2(150), 
     ATTRIBUTE2 VARCHAR2(150), 
     ATTRIBUTE3 VARCHAR2(150), 
     ATTRIBUTE4 VARCHAR2(150), 
     ATTRIBUTE5 VARCHAR2(150), 
     ATTRIBUTE6 VARCHAR2(150), 
     ATTRIBUTE7 VARCHAR2(150), 
     ATTRIBUTE8 VARCHAR2(150), 
     ATTRIBUTE9 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE_CATEGORY VARCHAR2(30), 
     AMOUNT_ATTRIBUTE1 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE10 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE11 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE12 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE13 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE14 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE15 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE2 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE3 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE4 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE5 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE6 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE7 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE8 VARCHAR2(150), 
     AMOUNT_ATTRIBUTE9 VARCHAR2(150), 
     AUTO_REC_INCL_DISPUTED_FLAG VARCHAR2(1), 
     CLEARING_DAYS NUMBER, 
     ORG_ID NUMBER, 
     CONS_INV_FLAG VARCHAR2(1), 
     CONS_INV_TYPE VARCHAR2(30), 
     LOCKBOX_MATCHING_OPTION VARCHAR2(30), 
     AUTOCASH_HIERARCHY_NAME_ADR VARCHAR2(30), 
     CREDIT_CLASSIFICATION VARCHAR2(30), 
     CONS_BILL_LEVEL VARCHAR2(30), 
     LATE_CHARGE_CALCULATION_TRX VARCHAR2(30), 
     CREDIT_ITEMS_FLAG VARCHAR2(1), 
     DISPUTED_TRANSACTIONS_FLAG VARCHAR2(1), 
     LATE_CHARGE_TYPE VARCHAR2(30), 
     INTEREST_CALCULATION_PERIOD VARCHAR2(30), 
     HOLD_CHARGED_INVOICES_FLAG VARCHAR2(1), 
     MULTIPLE_INTEREST_RATES_FLAG VARCHAR2(1), 
     CHARGE_BEGIN_DATE DATE, 
     EXCHANGE_RATE_TYPE VARCHAR2(30), 
     MIN_FC_INVOICE_OVERDUE_TYPE VARCHAR2(30), 
     MIN_FC_INVOICE_PERCENT NUMBER, 
     MIN_FC_BALANCE_OVERDUE_TYPE VARCHAR2(30), 
     MIN_FC_BALANCE_PERCENT NUMBER, 
     INTEREST_TYPE VARCHAR2(30), 
     INTEREST_FIXED_AMOUNT NUMBER, 
     PENALTY_TYPE VARCHAR2(30), 
     PENALTY_RATE NUMBER, 
     MIN_INTEREST_CHARGE NUMBER, 
     PENALTY_FIXED_AMOUNT NUMBER, 
     AUTOMATCH_RULE_NAME VARCHAR2(30), 
     MATCH_BY_AUTOUPDATE_FLAG VARCHAR2(1), 
     PRINTING_OPTION_CODE VARCHAR2(30), 
     TXN_DELIVERY_METHOD VARCHAR2(30), 
     STMT_DELIVERY_METHOD VARCHAR2(30), 
     XML_INV_FLAG VARCHAR2(1), 
     XML_DM_FLAG VARCHAR2(1), 
     XML_CB_FLAG VARCHAR2(1), 
     XML_CM_FLAG VARCHAR2(1), 
     CMK_CONFIG_FLAG VARCHAR2(1), 
     SERVICE_PROVIDER_NAME VARCHAR2(256), 
     PARTNER_ID VARCHAR2(100), 
     PARTNER_ID_TYPE_CODE VARCHAR2(100), 
     AR_OUTBOUND_TRANSACTION_FLAG VARCHAR2(1), 
     AR_INBOUND_CONFIRM_BOD_FLAG VARCHAR2(1), 
     ACCOUNT_NUMBER VARCHAR2(30), 
     PARTY_NUMBER VARCHAR2(30), 
     PREF_CONTACT_METHOD VARCHAR2(30), 
     INTEREST_SCHEDULE_ID NUMBER,
     PENALTY_SCHEDULE_ID  NUMBER,
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100), 
     OU_NAME VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300)
   );
   
   --------------------------------------------------------
--  DDL for Table xxmx_hz_relationships_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_relationships_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),  
     BATCH_ID           NUMBER,	 	 
     SUB_ORIG_SYSTEM VARCHAR2(30), 
     SUB_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     OBJ_ORIG_SYSTEM VARCHAR2(30), 
     OBJ_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     RELATIONSHIP_TYPE VARCHAR2(30), 
     RELATIONSHIP_CODE VARCHAR2(30), 
     START_DATE DATE, 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     END_DATE DATE, 
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
     SUBJECT_TYPE VARCHAR2(30), 
     OBJECT_TYPE VARCHAR2(30), 
     REL_ORIG_SYSTEM VARCHAR2(30), 
     REL_ORIG_SYSTEM_REFERENCE VARCHAR2(240), 
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
--------------------------------------------------------
--  DDL for Table xxmx_hz_role_resps_xfm
--------------------------------------------------------

  CREATE TABLE xxmx_hz_role_resps_xfm 
   ( 
     FILE_SET_ID       VARCHAR2(30),
	 MIGRATION_SET_ID NUMBER,
     MIGRATION_SET_NAME VARCHAR2(150),
	 MIGRATION_STATUS	VARCHAR2(50),  
     BATCH_ID           NUMBER,	 	 
     INSERT_UPDATE_CODE VARCHAR2(30), 
     INSERT_UPDATE_FLAG VARCHAR2(1), 
     CUST_CONTACT_ORIG_SYSTEM VARCHAR2(30), 
     CUST_CONTACT_ORIG_SYS_REF VARCHAR2(240), 
     ROLE_RESP_ORIG_SYSTEM VARCHAR2(30), 
     ROLE_RESP_ORIG_SYS_REF VARCHAR2(240), 
     RESPONSIBILITY_TYPE VARCHAR2(30), 
     PRIMARY_FLAG VARCHAR2(1), 
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
     LOAD_REQUEST_ID NUMBER, 
     CREATION_DATE DATE, 
     CREATED_BY VARCHAR2(100), 
     LAST_UPDATE_DATE DATE, 
     LAST_UPDATED_BY VARCHAR2(100),
	 LOAD_BATCH VARCHAR2(300),
	 PARTY_ORIG_SYSTEM_REFERENCE VARCHAR2(240)
   );
   
   
-------------------------------------------
-- DDL for xxmx_ar_cust_banks_xfm
-------------------------------------------
CREATE TABLE xxmx_ar_cust_banks_xfm   
(
   FILE_SET_ID       				   VARCHAR2(30),
   MIGRATION_SET_ID                   NUMBER   ,     
   MIGRATION_SET_NAME                 VARCHAR2(150) ,
   MIGRATION_STATUS                   VARCHAR2(50)  ,
   BATCH_ID           				  NUMBER,	 
   CUST_ORIG_SYSTEM                   VARCHAR2(30)  ,
   CUST_ORIG_SYSTEM_REFERENCE         VARCHAR2(240) ,
   CUST_SITE_ORIG_SYSTEM              VARCHAR2(30)  ,
   CUST_SITE_ORIG_SYS_REF             VARCHAR2(240) ,
   BANK_ACCOUNT_NAME                  VARCHAR2(80)  ,
   PRIMARY_FLAG                       VARCHAR2(1)   ,
   START_DATE                         DATE          ,
   END_DATE                           DATE          ,
   ATTRIBUTE_CATEGORY                 VARCHAR2(30)  ,
   ATTRIBUTE1                         VARCHAR2(150) ,
   ATTRIBUTE2                         VARCHAR2(150) ,
   ATTRIBUTE3                         VARCHAR2(150) ,
   ATTRIBUTE4                         VARCHAR2(150) ,
   ATTRIBUTE5                         VARCHAR2(150) ,
   ATTRIBUTE6                         VARCHAR2(150) ,
   ATTRIBUTE7                         VARCHAR2(150) ,
   ATTRIBUTE8                         VARCHAR2(150) ,
   ATTRIBUTE9                         VARCHAR2(150) ,
   ATTRIBUTE10                        VARCHAR2(150) ,
   ATTRIBUTE11                        VARCHAR2(150) ,
   ATTRIBUTE12                        VARCHAR2(150) ,
   ATTRIBUTE13                        VARCHAR2(150) ,
   ATTRIBUTE14                        VARCHAR2(150) ,
   ATTRIBUTE15                        VARCHAR2(150) ,
   BANK_ACCOUNT_NUM                   VARCHAR2(30)  ,
   BANK_ACCOUNT_CURRENCY_CODE         VARCHAR2(15)  ,
   BANK_ACCOUNT_INACTIVE_DATE         DATE          ,
   BANK_ACCOUNT_DESCRIPTION           VARCHAR2(240) ,
   BANK_NAME                          VARCHAR2(60)  ,
   BANK_BRANCH_NAME                   VARCHAR2(60)  ,
   BANK_NUM                           VARCHAR2(25)  ,
   BANK_BRANCH_DESCRIPTION            VARCHAR2(240) ,
   BANK_BRANCH_ADDRESS1               VARCHAR2(35)  ,
   BANK_BRANCH_ADDRESS2               VARCHAR2(35)  ,
   BANK_BRANCH_ADDRESS3               VARCHAR2(35)  ,
   BANK_BRANCH_CITY                   VARCHAR2(25)  ,
   BANK_BRANCH_STATE                  VARCHAR2(25)  ,
   BANK_BRANCH_ZIP                    VARCHAR2(20)  ,
   BANK_BRANCH_PROVINCE               VARCHAR2(25)  ,
   BANK_BRANCH_COUNTRY                VARCHAR2(25)  ,
   BANK_BRANCH_AREA_CODE              VARCHAR2(10)  ,
   BANK_BRANCH_PHONE                  VARCHAR2(15)  ,
   BANK_ACCOUNT_ATT_CATEGORY          VARCHAR2(30)  ,
   BANK_ACCOUNT_ATTRIBUTE1            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE10           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE11           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE12           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE13           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE14           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE15           VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE2            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE3            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE4            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE5            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE6            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE7            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE8            VARCHAR2(150) ,
   BANK_ACCOUNT_ATTRIBUTE9            VARCHAR2(150) ,
   BANK_BRANCH_ATT_CATEGORY           VARCHAR2(30)  ,
   BANK_BRANCH_ATTRIBUTE1             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE10            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE11            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE12            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE13            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE14            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE15            VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE2             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE3             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE4             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE5             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE6             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE7             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE8             VARCHAR2(150) ,
   BANK_BRANCH_ATTRIBUTE9             VARCHAR2(150) ,
   BANK_NUMBER                        VARCHAR2(30)  ,
   BANK_BRANCH_ADDRESS4               VARCHAR2(35)  ,
   BANK_BRANCH_COUNTY                 VARCHAR2(25)  ,
   BANK_BRANCH_EFT_USER_NUMBER        VARCHAR2(30)  ,
   BANK_ACCOUNT_CHECK_DIGITS          VARCHAR2(30)  ,
   GLOBAL_ATTRIBUTE_CATEGORY          VARCHAR2(30)  ,
   GLOBAL_ATTRIBUTE1                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE2                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE3                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE4                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE5                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE6                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE7                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE8                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE9                  VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE10                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE11                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE12                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE13                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE14                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE15                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE16                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE17                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE18                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE19                 VARCHAR2(150) ,
   GLOBAL_ATTRIBUTE20                 VARCHAR2(150) ,
   ORG_ID                             NUMBER        ,
   BANK_HOME_COUNTRY                  VARCHAR2(2)   ,
   LOCALINSTR                         VARCHAR2(35)  ,
   SERVICE_LEVEL                      VARCHAR2(35)  ,
   PURPOSE_CODE                       VARCHAR2(30)  ,
   BANK_CHARGE_BEARER_CODE            VARCHAR2(30)  ,
   DEBIT_ADVICE_DELIVERY_METHOD       VARCHAR2(30)  ,
   DEBIT_ADVICE_EMAIL                 VARCHAR2(155) ,
   DEBIT_ADVICE_FAX                   VARCHAR2(100) ,
   EFT_SWIFT_CODE                     VARCHAR2(30)  ,
   COUNTRY_CODE                       VARCHAR2(2)   ,
   FOREIGN_PAYMENT_USE_FLAG           VARCHAR2(1)   ,
   PRIMARY_ACCT_OWNER_FLAG            VARCHAR2(1)   ,
   BANK_ACCOUNT_NAME_ALT              VARCHAR2(320) ,
   BANK_ACCOUNT_TYPE                  VARCHAR2(25)  ,
   ACCOUNT_SUFFIX                     VARCHAR2(30)  ,
   AGENCY_LOCATION_CODE               VARCHAR2(30)  ,
   IBAN                               VARCHAR2(50)  ,
   LOAD_REQUEST_ID                    NUMBER        ,
   CREATION_DATE                      DATE          ,
   CREATED_BY                         VARCHAR2(100) ,
   LAST_UPDATE_DATE                   DATE          ,
   LAST_UPDATED_BY                    VARCHAR2(100),
   LOAD_BATCH 						VARCHAR2(300),
   PARTY_ORIG_SYSTEM_REFERENCE		VARCHAR2(240)
);   
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_acct_sites_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_acct_sites_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_site_uses_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_site_uses_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_acct_relate_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_acct_relate_xfm
          TO XXMX_CORE;
		  --
--
PROMPT
PROMPT Granting permissions on xxmx_hz_party_classifs_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_party_classifs_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_org_contacts_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_org_contacts_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_contact_points_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_contact_points_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_org_contact_roles_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_org_contact_roles_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_accounts_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_accounts_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_acct_contacts_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_acct_contacts_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_iby_cust_bank_accts_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_iby_cust_bank_accts_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_ra_cust_rcpt_methods_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_ra_cust_rcpt_methods_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_locations_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_locations_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_party_sites_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_party_sites_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_party_site_uses_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_party_site_uses_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_parties_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_parties_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_person_language_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_person_language_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_cust_profiles_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_cust_profiles_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_relationships_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_relationships_xfm
          TO XXMX_CORE;
--
--
PROMPT
PROMPT Granting permissions on xxmx_hz_role_resps_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_hz_role_resps_xfm
          TO XXMX_CORE;
--
--

--
--
PROMPT
PROMPT Granting permissions on xxmx_ar_cust_banks_xfm to the XXMX_CORE Schema 
PROMPT
--
GRANT ALL ON xxmx_ar_cust_banks_xfm
          TO XXMX_CORE;
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
