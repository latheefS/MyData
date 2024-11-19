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
--** FILENAME  :  xxmx_ar_cash_receipts_xfm_dbi.sql
--**
--** FILEPATH  :  $XXMX_TOP/install/sql
--**
--** VERSION   :  1.4
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
--**   1.0  22-OCT-2020  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  16-FEB-2021  Ian S. Vickerstaff  Updated to add RT5 and RT8 tables.
--**
--**   1.2  24-FEB-2021  Ian S. Vickerstaff  Updated to add OUT table.
--**
--**   1.3  25-FEB-2021  Ian S. Vickerstaff  Column updates. 
--**
--**   1.4  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
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
PROMPT ***************************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise AR Cash Receipts Data Migration
PROMPT **
PROMPT ***************************************************************************
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
PROMPT Dropping Table xxmx_ar_cash_rcpts_rt5_xfm
PROMPT
--
DROP TABLE xxmx_ar_cash_rcpts_rt5_xfm;
--
PROMPT
PROMPT Dropping Table xxmx_ar_cash_rcpts_rt6_xfm
PROMPT
--
DROP TABLE xxmx_ar_cash_rcpts_rt6_xfm;
--
PROMPT
PROMPT Dropping Table xxmx_ar_cash_rcpts_rt8_xfm
PROMPT
--
DROP TABLE xxmx_ar_cash_rcpts_rt8_xfm;
--
PROMPT
PROMPT Dropping Table xxmx_ar_cash_receipts_out
PROMPT
--
DROP TABLE xxmx_ar_cash_receipts_out;
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
/*
** TABLE: xxmx_ar_cash_rcpts_rt5_xfm
*/
--
PROMPT
PROMPT Creating Table xxmx_ar_cash_rcpts_rt5_xfm
PROMPT
--
CREATE TABLE xxmx_ar_cash_rcpts_rt5_xfm
     (
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER          NOT NULL 
     ,migration_set_name              VARCHAR2(240)   NOT NULL 
	 ,migration_status 				  VARCHAR2(50)
     ,transform_status                VARCHAR2(50)    NOT NULL 
     ,record_type                     VARCHAR2(2)     NOT NULL 
     ,record_seq                      NUMBER          NOT NULL 
     ,source_operating_unit_name      VARCHAR2(240)   NOT NULL 
     ,fusion_business_unit_name       VARCHAR2(240)            
     ,currency_code                   VARCHAR2(15)    
     ,receipt_method                  VARCHAR2(30)    
     ,lockbox_number                  VARCHAR2(30)    
     ,deposit_date                    DATE            
     ,deposit_time                    VARCHAR2(8)     
     ,lockbox_batch_count             NUMBER          
     ,lockbox_record_count            NUMBER          
     ,lockbox_amount                  NUMBER          
     ,destination_bank_account        VARCHAR2(25)   
     ,bank_origination_number         VARCHAR2(25)     
     ,attribute1                      VARCHAR2(150)   
     ,attribute2                      VARCHAR2(150)   
     ,attribute3                      VARCHAR2(150)   
     ,attribute4                      VARCHAR2(150)   
     ,attribute5                      VARCHAR2(150)   
     ,attribute6                      VARCHAR2(150)   
     ,attribute7                      VARCHAR2(150)   
     ,attribute8                      VARCHAR2(150)   
     ,attribute9                      VARCHAR2(150)   
     ,attribute10                     VARCHAR2(150)   
     ,attribute11                     VARCHAR2(150)   
     ,attribute12                     VARCHAR2(150)   
     ,attribute13                     VARCHAR2(150)   
     ,attribute14                     VARCHAR2(150)   
     ,attribute15                     VARCHAR2(150)   
     );
--
/*
** TABLE: xxmx_ar_cash_rcpts_rt6_xfm
*/
--
PROMPT
PROMPT Creating Table xxmx_ar_cash_rcpts_rt6_xfm
PROMPT
--
CREATE TABLE xxmx_ar_cash_rcpts_rt6_xfm
     (
	  file_set_id                     VARCHAR2(30)
     ,migration_set_id                NUMBER          NOT NULL 
     ,migration_set_name              VARCHAR2(100)   NOT NULL 
	  ,migration_status 				  VARCHAR2(50)
     ,transform_status                VARCHAR2(50)    NOT NULL 
     ,record_type                     VARCHAR2(2)     NOT NULL 
     ,record_seq                      NUMBER          NOT NULL 
     ,source_operating_unit_name      VARCHAR2(240)
     ,fusion_business_unit_name       VARCHAR2(240)            
     ,batch_name                      VARCHAR2(25)             
     ,item_number                     NUMBER                   
     ,remittance_amount               NUMBER                   
     ,transit_routing_number          VARCHAR2(25)             
     ,customer_bank_account           VARCHAR2(30)             
     ,receipt_number                  VARCHAR2(30)             
     ,receipt_date                    DATE                     
     ,currency_code                   VARCHAR2(15)             
     ,exchange_rate_type              VARCHAR2(30)             
     ,exchange_rate                   NUMBER                   
     ,customer_number                 VARCHAR2(30)             
     ,bill_to_location                VARCHAR2(40)             
     ,customer_bank_branch_name       VARCHAR2(320)            
     ,customer_bank_name              VARCHAR2(320)            
     ,receipt_method                  VARCHAR2(30)             
     ,remittance_bank_branch_name     VARCHAR2(320)            
     ,remittance_bank_name            VARCHAR2(320)            
     ,lockbox_number                  VARCHAR2(30)             
     ,deposit_date                    DATE                     
     ,deposit_time                    VARCHAR2(8)              
     ,anticipated_clearing_date       DATE                     
     ,invoice1                        VARCHAR2(50)             
     ,invoice1_installment            NUMBER                   
     ,matching1_date                  DATE                     
     ,invoice_currency_code1          VARCHAR2(15)             
     ,trans_to_receipt_rate1          NUMBER                   
     ,amount_applied1                 NUMBER                   
     ,amount_applied_from1            NUMBER                   
     ,customer_reference1             VARCHAR2(100)            
     ,invoice2                        VARCHAR2(50)             
     ,invoice2_installment            NUMBER                   
     ,matching2_date                  DATE                     
     ,invoice_currency_code2          VARCHAR2(15)             
     ,trans_to_receipt_rate2          NUMBER                   
     ,amount_applied2                 NUMBER                   
     ,amount_applied_from2            NUMBER                   
     ,customer_reference2             VARCHAR2(100)            
     ,invoice3                        VARCHAR2(50)             
     ,invoice3_installment            NUMBER                   
     ,matching3_date                  DATE                     
     ,invoice_currency_code3          VARCHAR2(15)             
     ,trans_to_receipt_rate3          NUMBER                   
     ,amount_applied3                 NUMBER                   
     ,amount_applied_from3            NUMBER                   
     ,customer_reference3             VARCHAR2(100)            
     ,invoice4                        VARCHAR2(50)             
     ,invoice4_installment            NUMBER                   
     ,matching4_date                  DATE                     
     ,invoice_currency_code4          VARCHAR2(15)             
     ,trans_to_receipt_rate4          NUMBER                   
     ,amount_applied4                 NUMBER                   
     ,amount_applied_from4            NUMBER                   
     ,customer_reference4             VARCHAR2(100)            
     ,invoice5                        VARCHAR2(50)             
     ,invoice5_installment            NUMBER                   
     ,matching5_date                  DATE                     
     ,invoice_currency_code5          VARCHAR2(15)             
     ,trans_to_receipt_rate5          NUMBER                   
     ,amount_applied5                 NUMBER                   
     ,amount_applied_from5            NUMBER                   
     ,customer_reference5             VARCHAR2(100)            
     ,invoice6                        VARCHAR2(50)             
     ,invoice6_installment            NUMBER                   
     ,matching6_date                  DATE                     
     ,invoice_currency_code6          VARCHAR2(15)             
     ,trans_to_receipt_rate6          NUMBER                   
     ,amount_applied6                 NUMBER                   
     ,amount_applied_from6            NUMBER                   
     ,customer_reference6             VARCHAR2(100)            
     ,invoice7                        VARCHAR2(50)             
     ,invoice7_installment            NUMBER                   
     ,matching7_date                  DATE                     
     ,invoice_currency_code7          VARCHAR2(15)             
     ,trans_to_receipt_rate7          NUMBER                   
     ,amount_applied7                 NUMBER                   
     ,amount_applied_from7            NUMBER                   
     ,customer_reference7             VARCHAR2(100)            
     ,invoice8                        VARCHAR2(50)             
     ,invoice8_installment            NUMBER                   
     ,matching8_date                  DATE                     
     ,invoice_currency_code8          VARCHAR2(15)             
     ,trans_to_receipt_rate8          NUMBER                   
     ,amount_applied8                 NUMBER                   
     ,amount_applied_from8            NUMBER                   
     ,customer_reference8             VARCHAR2(100)            
     ,comments                        VARCHAR2(240)            
     ,attribute1                      VARCHAR2(150)            
     ,attribute2                      VARCHAR2(150)            
     ,attribute3                      VARCHAR2(150)            
     ,attribute4                      VARCHAR2(150)            
     ,attribute5                      VARCHAR2(150)            
     ,attribute6                      VARCHAR2(150)            
     ,attribute7                      VARCHAR2(150)            
     ,attribute8                      VARCHAR2(150)            
     ,attribute9                      VARCHAR2(150)            
     ,attribute10                     VARCHAR2(150)            
     ,attribute11                     VARCHAR2(150)            
     ,attribute12                     VARCHAR2(150)            
     ,attribute13                     VARCHAR2(150)            
     ,attribute14                     VARCHAR2(150)            
     ,attribute15                     VARCHAR2(150)            
     ,attribute_category              VARCHAR2(30)             
     );
--
/*
** TABLE: xxmx_ar_cash_rcpts_rt8_xfm
*/
--
PROMPT
PROMPT Creating Table xxmx_ar_cash_rcpts_rt8_xfm
PROMPT
--
CREATE TABLE xxmx_ar_cash_rcpts_rt8_xfm
     (
	  file_set_id                    VARCHAR2(30)
     ,migration_set_id                NUMBER          NOT NULL 
     ,migration_set_name              VARCHAR2(240)   NOT NULL 
	 ,migration_status 				  VARCHAR2(50)
     ,transform_status                VARCHAR2(50)    NOT NULL 
     ,record_type                     VARCHAR2(2)     NOT NULL 
     ,record_seq                      NUMBER          NOT NULL 
     ,source_operating_unit_name      VARCHAR2(240)   NOT NULL 
     ,fusion_business_unit_name       VARCHAR2(240)            
     ,currency_code                   VARCHAR2(15)    
     ,receipt_method                  VARCHAR2(30)    
     ,lockbox_number                  VARCHAR2(30)    
     ,deposit_date                    DATE            
     ,deposit_time                    VARCHAR2(8)     
     ,lockbox_batch_count             NUMBER          
     ,lockbox_record_count            NUMBER          
     ,lockbox_amount                  NUMBER          
     ,destination_bank_account        VARCHAR2(25)   
     ,bank_origination_number         VARCHAR2(25)     
     ,attribute1                      VARCHAR2(150)   
     ,attribute2                      VARCHAR2(150)   
     ,attribute3                      VARCHAR2(150)   
     ,attribute4                      VARCHAR2(150)   
     ,attribute5                      VARCHAR2(150)   
     ,attribute6                      VARCHAR2(150)   
     ,attribute7                      VARCHAR2(150)   
     ,attribute8                      VARCHAR2(150)   
     ,attribute9                      VARCHAR2(150)   
     ,attribute10                     VARCHAR2(150)   
     ,attribute11                     VARCHAR2(150)   
     ,attribute12                     VARCHAR2(150)   
     ,attribute13                     VARCHAR2(150)   
     ,attribute14                     VARCHAR2(150)   
     ,attribute15                     VARCHAR2(150)   
     );
--
/*
** TABLE: xxmx_ar_cash_receipts_out
*/
--
PROMPT
PROMPT Creating Table xxmx_ar_cash_receipts_out
PROMPT
--
CREATE TABLE xxmx_ar_cash_receipts_out
     (
	  file_set_id                    VARCHAR2(30)
     ,migration_set_id                NUMBER 
     ,migration_set_name              VARCHAR2(240)
	 ,migration_status 				  VARCHAR2(50)
     ,transmission_name               VARCHAR2(50)
	 ,lockbox_number                  VARCHAR2(30)
     ,record_seq                      NUMBER
     ,column_1                        VARCHAR2(2000)
     ,column_2                        VARCHAR2(2000)
     ,column_3                        VARCHAR2(2000)
     ,column_4                        VARCHAR2(2000)
     ,column_5                        VARCHAR2(2000)
     ,column_6                        VARCHAR2(2000)
     ,column_7                        VARCHAR2(2000)
     ,column_8                        VARCHAR2(2000)
     ,column_9                        VARCHAR2(2000)
     ,column_10                       VARCHAR2(2000)
     ,column_11                       VARCHAR2(2000)
     ,column_12                       VARCHAR2(2000)
     ,column_13                       VARCHAR2(2000)
     ,column_14                       VARCHAR2(2000)
     ,column_15                       VARCHAR2(2000)
     ,column_16                       VARCHAR2(2000)
     ,column_17                       VARCHAR2(2000)
     ,column_18                       VARCHAR2(2000)
     ,column_19                       VARCHAR2(2000)
     ,column_20                       VARCHAR2(2000)
     ,column_21                       VARCHAR2(2000)
     ,column_22                       VARCHAR2(2000)
     ,column_23                       VARCHAR2(2000)
     ,column_24                       VARCHAR2(2000)
     ,column_25                       VARCHAR2(2000)
     ,column_26                       VARCHAR2(2000)
     ,column_27                       VARCHAR2(2000)
     ,column_28                       VARCHAR2(2000)
     ,column_29                       VARCHAR2(2000)
     ,column_30                       VARCHAR2(2000)
     ,column_31                       VARCHAR2(2000)
     ,column_32                       VARCHAR2(2000)
     ,column_33                       VARCHAR2(2000)
     ,column_34                       VARCHAR2(2000)
     ,column_35                       VARCHAR2(2000)
     ,column_36                       VARCHAR2(2000)
     ,column_37                       VARCHAR2(2000)
     ,column_38                       VARCHAR2(2000)
     ,column_39                       VARCHAR2(2000)
     ,column_40                       VARCHAR2(2000)
     ,column_41                       VARCHAR2(2000)
     ,column_42                       VARCHAR2(2000)
     ,column_43                       VARCHAR2(2000)
     ,column_44                       VARCHAR2(2000)
     ,column_45                       VARCHAR2(2000)
     ,column_46                       VARCHAR2(2000)
     ,column_47                       VARCHAR2(2000)
     ,column_48                       VARCHAR2(2000)
     ,column_49                       VARCHAR2(2000)
     ,column_50                       VARCHAR2(2000)
     ,column_51                       VARCHAR2(2000)
     ,column_52                       VARCHAR2(2000)
     ,column_53                       VARCHAR2(2000)
     ,column_54                       VARCHAR2(2000)
     ,column_55                       VARCHAR2(2000)
     ,column_56                       VARCHAR2(2000)
     ,column_57                       VARCHAR2(2000)
     ,column_58                       VARCHAR2(2000)
     ,column_59                       VARCHAR2(2000)
     ,column_60                       VARCHAR2(2000)
     ,column_61                       VARCHAR2(2000)
     ,column_62                       VARCHAR2(2000)
     ,column_63                       VARCHAR2(2000)
     ,column_64                       VARCHAR2(2000)
     ,column_65                       VARCHAR2(2000)
     ,column_66                       VARCHAR2(2000)
     ,column_67                       VARCHAR2(2000)
     ,column_68                       VARCHAR2(2000)
     ,column_69                       VARCHAR2(2000)
     ,column_70                       VARCHAR2(2000)
     ,column_71                       VARCHAR2(2000)
     ,column_72                       VARCHAR2(2000)
     ,column_73                       VARCHAR2(2000)
     ,column_74                       VARCHAR2(2000)
     ,column_75                       VARCHAR2(2000)
     ,column_76                       VARCHAR2(2000)
     ,column_77                       VARCHAR2(2000)
     ,column_78                       VARCHAR2(2000)
     ,column_79                       VARCHAR2(2000)
     ,column_80                       VARCHAR2(2000)
     ,column_81                       VARCHAR2(2000)
     ,column_82                       VARCHAR2(2000)
     ,column_83                       VARCHAR2(2000)
     ,column_84                       VARCHAR2(2000)
     ,column_85                       VARCHAR2(2000)
     ,column_86                       VARCHAR2(2000)
     ,column_87                       VARCHAR2(2000)
     ,column_88                       VARCHAR2(2000)
     ,column_89                       VARCHAR2(2000)
     ,column_90                       VARCHAR2(2000)
     ,column_91                       VARCHAR2(2000)
     ,column_92                       VARCHAR2(2000)
     ,column_93                       VARCHAR2(2000)
     ,column_94                       VARCHAR2(2000)
     ,column_95                       VARCHAR2(2000)
     ,column_96                       VARCHAR2(2000)
     ,column_97                       VARCHAR2(2000)
     ,column_98                       VARCHAR2(2000)
     ,column_99                       VARCHAR2(2000)
     ,column_100                      VARCHAR2(2000)
     ,column_101                      VARCHAR2(2000)
     ,column_102                      VARCHAR2(2000)
     ,column_103                      VARCHAR2(2000)
     ,column_104                      VARCHAR2(2000)
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
PROMPT Granting permissions on xxmx_ar_cash_rcpts_rt5_xfm to the XXMX_CORE Schema
PROMPT
--
GRANT ALL ON xxmx_ar_cash_rcpts_rt5_xfm
          TO XXMX_CORE;
--
PROMPT
PROMPT Granting permissions on xxmx_ar_cash_rcpts_rt6_xfm to the XXMX_CORE Schema
PROMPT
--
GRANT ALL ON xxmx_ar_cash_rcpts_rt6_xfm
          TO XXMX_CORE;
--
PROMPT
PROMPT Granting permissions on xxmx_ar_cash_rcpts_rt8_xfm to the XXMX_CORE Schema
PROMPT
--
GRANT ALL ON xxmx_ar_cash_rcpts_rt8_xfm
          TO XXMX_CORE;
--
PROMPT
PROMPT Granting permissions on xxmx_ar_cash_receipts_out to the XXMX_CORE Schema
PROMPT
--
GRANT ALL ON xxmx_ar_cash_receipts_out
          TO XXMX_CORE;
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