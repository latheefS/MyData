--------------------------------------------------------
--  File created - Wednesday-September-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package XXMX_AR_CASH_RECEIPTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE  PACKAGE "XXMX_AR_CASH_RECEIPTS_PKG" 
AS
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2020 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1,
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_ar_cash_receipts_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Ian S. Vickerstaff
     **
     ** PURPOSE   :  This script installs the package specification for the Version1
     **              AR Cash Receipts Migration package.
     **
     ** NOTES     :
     **
     ******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **
     ** If this script is to be executed as part of an installation script, ensure
     ** that the installation script performs the following tasks prior to calling
     ** this script.
     **
     ** Task  Description
     ** ----  ---------------------------------------------------------------------
     ** 1.    Run the installation script to create all necessary database objects:
     **
     **            $XXMX_TOP/install/sql/xxxmx_ar_cash_receipts_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxxmx_ar_cash_receipts_xfm_dbi.sql
     **
     ** If this script is not to be executed as part of an installation script,
     ** ensure that the tasks above are, or have been, performed prior to executing
     ** this script.
     **
     ******************************************************************************
     **
     ** CALLING INSTALLATION SCRIPTS
     ** ----------------------------
     **
     ** The following installation scripts call this script:
     **
     ** File Path                                     File Name
     ** --------------------------------------------  ------------------------------
     ** N/A                                           N/A
     **
     ******************************************************************************
     **
     ** CALLED INSTALLATION SCRIPTS
     ** ---------------------------
     **
     ** The following installation scripts are called by this script:
     **
     ** File Path                                    File Name
     ** -------------------------------------------  ------------------------------
     ** N/A                                          N/A
     **
     ******************************************************************************
     **
     ** PARAMETERS
     ** ----------
     **
     ** Parameter                       IN OUT  Type
     ** -----------------------------  ------  ------------------------------------
     ** [parameter_name]                IN OUT
     **
     ******************************************************************************
     **
     ** [previous_filename] HISTORY
     ** -----------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxcust_common_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-JUL-2020  Ian S. Vickerstaff  Created from original V1 Solutions
     **                                         Limited version.
     **   2.0  22-FEB-2021  Ian S. Vickerstaff  Rewritten to accomodate Lockbox
     **                                         Header and Trailer Record Types.
     **   2.1  ??-???-????  Dave Higham         Commented out code for generation
     **                                         of Record Types 5 and 8.
     **   2.2  06-SEP-2021  Ian S. Vickerstaff  Added LTRIM, RTRIM and call to
     **                                         "convert_string" function when
     **                                         selecting Receipt Location.
     ******************************************************************************
     **
     **  Data Element Prefixes
     **  =====================
     **
     **  Utilizing prefixes for data and object names enhances the readability of code
     **  and allows for the context of a data element to be identified (and hopefully
     **  understood) without having to refer to the data element declarations section.
     **
     **  For example, having a variable in code simply named "x_id" is not very
     **  useful.  Don't laugh, I've seen it done.
     **
     **  If you came across such a variable hundreds of lines down in a packaged
     **  procedure or function, you could assume the variable's data type was
     **  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
     **  but you would have to check in the declaration section to be sure.
     **
     **  However, if the purpose of the "x_id" variable was not to store an Oracle
     **  internal ID but perhaps some kind of client data identifier e.g. an
     **  Employee ID (and you could not tell this from the name) then the data type
     **  could easily be be VARCHAR2.  Again, you would have to navigate to the
     **  declaration section to be sure of the data type.
     **
     **  Also, the variable name does not give any developer who may need to modify
     **  the code (apart from the original author that is) any context as to the
     **  meaning of the variable.  Even the original author may struggle to remember
     **  what this variable is used for if s/he had to modify their own code months
     **  or years in the future.
     **
     **  This Package utilises prefixes of upto 6 characters for all data elements
     **  wherever possible.
     **
     **  The construction of Prefixes is governed by the following rules:
     **
     **       Parameters
     **       ----------
     **       1) Parameter prefixes always start with "p".
     **
     **       2) The second character in a parameter prefix denotes its
     **          data type:
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **       3) The third and/or fourth characters in a parameter prefix
     **          denote the direction in which value in the paramater is
     **          communicated:
     **
     **               i  = Input parameter (readable value only)
     **               o  = Output parameter (value assignable)
     **               io = Input/Output parameter (readable/assignable)
     **
     **          For clarity, the direction indicators are separated from
     **          the first two characters by an underscore. e.g. pv_i_
     **
     **       Global Data Elements
     **       --------------------
     **       1) Global data elements will always start with a "g" whether
     **          defined in the package body (and therefore only global within
     **          the package itself), or defined in the package specification
     **          (and therefore referencable outside of the package).
     **
     **          The subequent characters in a global prefix will follow the same
     **          conventions as per local constants and variables as explained
     **          below.
     **
     **       Local Data Elements
     **       -------------------
     **       1) The first character of a local data element's prefix (or second
     **          character for global) denotes the data element's assignability:
     **
     **               c = Denotes a constant.
     **
     **               v = Denotes a variable.
     **
     **       2) The second character or a local data element's prefix (or third
     **          character for global) denotes its data type (as with parameters):
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **  Prefix Examples
     **  ===============
     **
     **       Prefix    Indication
     **       --------  ----------------------------------------
     **       pb_i_     Input Parameter of type BOOLEAN
     **       pd_i_     Input Parameter of type DATE
     **       pi_i_     Input Parameter of type INTEGER
     **       pn_i_     Input Parameter of type NUMBER
     **       pr_i_     Input Parameter of type REAL
     **       pv_i_     Input Parameter of type VARCHAR2
     **       pt_i_     Input Parameter of type %TYPE
     **
     **       pb_o_     Output Parameter of type BOOLEAN
     **       pd_o_     Output Parameter of type DATE
     **       pi_o_     Output Parameter of type INTEGER
     **       pn_o_     Output Parameter of type NUMBER
     **       pr_o_     Output Parameter of type REAL
     **       pv_o_     Output Parameter of type VARCHAR2
     **       pt_o_     Output Parameter of type %TYPE
     **
     **       pb_io_    Input/Output Parameter of type BOOLEAN
     **       pd_io_    Input/Output Parameter of type DATE
     **       pi_io_    Input/Output Parameter of type INTEGER
     **       pn_io_    Input/Output Parameter of type NUMBER
     **       pr_io_    Input/Output Parameter of type REAL
     **       pv_io_    Input/Output Parameter of type VARCHAR2
     **       pt_io_    Input/Output Parameter of type %TYPE
     **
     **       gcb_      Global Constant of type BOOLEAN
     **       gcd_      Global Constant of type DATE
     **       gci_      Global Constant of type INTEGER
     **       gcn_      Global Constant of type NUMBER
     **       gcr_      Global Constant of type REAL
     **       gcv_      Global Constant of type VARCHAR2
     **       gct_      Global Constant of type %TYPE
     **
     **       gvb_      Global Variable of type BOOLEAN
     **       gvd_      Global Variable of type DATE
     **       gvi_      Global Variable of type INTEGER
     **       gvn_      Global Variable of type NUMBER
     **       gvr_      Global Variable of type REAL
     **       gvv_      Global Variable of type VARCHAR2
     **       gvt_      Global Variable of type %TYPE
     **
     **       cb_       Constant of type BOOLEAN
     **       cd_       Constant of type DATE
     **       ci_       Constant of type INTEGER
     **       cn_       Constant of type NUMBER
     **       cr_       Constant of type REAL
     **       cv_       Constant of type VARCHAR2
     **       ct_       Constant of type %TYPE
     **
     **       vb_       Variable of type BOOLEAN
     **       vd_       Variable of type DATE
     **       vi_       Variable of type INTEGER
     **       vn_       Variable of type NUMBER
     **       vr_       Variable of type REAL
     **       vv_       Variable of type VARCHAR2
     **       vt_       Variable of type %TYPE
     **
     **  PL/SQL Construct Suffixes
     **  =========================
     **
     **  Specific suffixes have been employed for PL/SQL Constructs:
     **
     **       _cur      Cursor Names
     **       _rt       PL/SQL Record Type Declarations
     **       _tt       PL/SQL Table Type Declarations
     **       _tbl      PL/SQL Table Declarations
     **       _rec      PL/SQL Record Declarations (or implicit
     **                 cursor record declarations)
     **
     **  Other Data Element Naming Conventions
     **  =====================================
     **
     **  Data elements names should have meaning which indicate their purpose or
     **  usage whilst adhering to the Oracle name length limit of 30 characters.
     **
     **  To compensate for longer data element prefixes, the rest of a data element
     **  name is constructed without underscores.  However to aid in maintaining
     **  readability and meaning, data elements names will contain concatenated
     **  words with initial letters capitalised in a similar manner to JAVA naming
     **  conventions.
     **
     **  By using the above conventions you can create meaningful data element
     **  names such as:
     **
     **       pn_i_POHeaderID
     **       ---------------
     **       This clearly identifies that the data element is an inbound only
     **       (non assignable) parameter of type NUMBER which holds an Oracle
     **       internal PO Header identifier.
     **
     **       pb_o_CreateOutputFileAsCSV
     **       --------------------------
     **       This clearly identifies that the data element is an output only
     **       parameter of type BOOLEAN that contains a flag which indicates
     **       that output of the calling process should be formatted as a CSV
     **       file.
     **
     **       gct_PackageName
     **       ---------------
     **       This data element is a global constant of type VARCHAR2.
     **
     **       ct_ProcOrFuncName
     **       -----------------
     **       This data element is a local constant of type VARCHAR2.
     **
     **       vt_APInvoiceID
     **       --------------
     **       This data element is a variable whose type is determined from a
     **       database table column and is meant to hold the Oracle internal
     **       identifier for a Payables Invoice Header.
     **
     **       vt_APInvoiceLineID
     **       ------------------
     **       Similar to the previous example but this clearly identified that the
     **       data element is intended to hold the Oracle internal identifier for
     **       a Payables Invoice Line.
     **
     **  Similarly for PL/SQL Constructs:
     **
     **       APInvoiceHeaders_cur
     **
     **       APInvoiceHeader_rec
     **
     **       TYPE EmployeeData_rt IS RECORD OF
     **            (
     **             employee_number   VARCHAR2(20)
     **            ,employee_name     VARCHAR2(30)
     **            );
     **
     **       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
     **
     **       EmployeeData_tbl        EmployeeData_tt;
     **
     **  Careful and considerate use of the above rules when naming data elements
     **  can be a boon to other developers who may need to understand and/or modify
     **  your code in future.  In conjunction with good commenting practices of
     **  course.
     **
     ******************************************************************************
     */
     --
     /*
     ***********************************
     ** PROCEDURE : ar_cash_receipts_stg
     ***********************************
     */
     --
     PROCEDURE ar_cash_receipts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: ar_cash_receipts_xfm
     **********************************
     */
     --
     PROCEDURE ar_cash_receipts_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ***********************
     ** PROCEDURE : stg_main
     ***********************
     */
     --
     PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
     --
     --
     /*
     ********************
     ** PROCEDURE : purge
     ********************
     */
     --
     PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
     --
     --
END xxmx_ar_cash_receipts_pkg;
/


  CREATE OR REPLACE  PACKAGE BODY "XXMX_AR_CASH_RECEIPTS_PKG"
AS
     --
     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ar_cash_receipts_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CASH_RECEIPTS';
     gct_DfltBankOriginationNum                CONSTANT VARCHAR2(10)                                 := 'RADIUS';  -- SMBC default value
     gct_AmountAsPence                         CONSTANT VARCHAR2(1)                                  := 'N';       -- SMBC default value
     --
     /*
     Global Progress Indicator Variable for use in all Procedures/Functions within this package
     */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
     gvv_ApplicationErrorMessage                        VARCHAR2(2048);
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Migration Set Name
     */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
     gvn_RowCount                                       NUMBER;
     --
     /*
     ** Global variables for transform procedures
     */
     --
     gvb_MissingSetup                                   BOOLEAN;
     --
     /*
     **********************************
     ** PROCEDURE: ar_cash_receipts_stg
     **********************************
     */
     --
     PROCEDURE ar_cash_receipts_stg
                                 (
                                          pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                                         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                                 )
     IS
          --
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          -- Cursor to get the detail ar_cash_receipts
          --
          CURSOR ARCashReceipts_cur
          IS
               --
               WITH bank_account_banks
               AS
                    (
                     SELECT  cbbv.bank_name
                            ,cbbv.branch_number        AS sort_code
                            ,cbbv.bank_branch_name
                            ,ieba.ext_bank_account_id
                     FROM    apps.iby_ext_bank_accounts@MXDM_NVIS_EXTRACT   ieba
                            ,apps.ce_bank_branches_v@MXDM_NVIS_EXTRACT      cbbv
                     WHERE   1 = 1
                     AND     cbbv.branch_party_id = ieba.branch_id
                    )
               SELECT    '6'                                                       AS record_type
                        ,ROWNUM                                                    AS record_seq
                        ,xacrsv.operating_unit_name                                AS operating_unit_name
                        ,''                                                        AS batch_name
                        ,ROWNUM                                                    AS item_number
                        ,xacrsv.receipt_amount_remaining
                         * DECODE(gct_AmountAsPence,'Y',100,1)                     AS remittance_amount
                        ,''                                                        AS transit_routing_number
                        ,''                                                        AS customer_bank_account
                        ,acra.receipt_number                                       AS receipt_number
                        ,acra.receipt_date                                         AS receipt_date
                        ,acra.currency_code                                        AS currency_code
                        ,xacrsv.exchange_rate_type                                 AS exchange_rate_type
                        ,xacrsv.exchange_rate                                      AS exchange_rate
                        ,hca.account_number                                        AS customer_number
                        --,hcsu.location                                             AS bill_to_location
                        ,LTRIM(
                               RTRIM(
                                     xxmx_utilities_pkg.convert_string
                                          (
                                           pv_i_StringToConvert     => hcsu.location
                                          ,pv_i_ConvertCommaToSpace => 'N'
                                          ,pi_i_SubstrStartPos      => 1
                                          ,pi_i_SubstrLength        => 0  /* 0 disables the SUBSTR functionality */ 
                                          ,pv_i_UseBinarySubstr     => 'N'
                                          )
                                     )
                               )                                                   AS bill_to_location                        
                        ,customer_banks.bank_branch_name                           AS customer_bank_branch_name
                        ,customer_banks.bank_name                                  AS customer_bank_name
                        ,xacrsv.receipt_method_name                                AS receipt_method_name
                        ,remittance_banks.bank_branch_name                         AS remittance_bank_branch_name
                        ,remittance_banks.bank_name                                AS remittance_bank_name
                        ,acra.deposit_date                                         AS deposit_date
                        ,''                                                        AS deposit_time
                        ,acra.anticipated_clearing_date                            AS anticipated_clearing_date
                        ,''                                                        AS invoice1
                        ,''                                                        AS invoice_installment
                        ,''                                                        AS matching_date
                        ,''                                                        AS invoice_currency_code1
                        ,''                                                        AS trans_to_receipt_rate1
                        ,''                                                        AS amount_applied1
                        ,''                                                        AS amount_applied_from1
                        ,''                                                        AS customer_reference1
                        ,''                                                        AS invoice2
                        ,''                                                        AS invoice2_installment
                        ,''                                                        AS matching2_date
                        ,''                                                        AS invoice_currency_code2
                        ,''                                                        AS trans_to_receipt_rate2
                        ,''                                                        AS amount_applied2
                        ,''                                                        AS amount_applied_from2
                        ,''                                                        AS customer_reference2
                        ,''                                                        AS invoice3
                        ,''                                                        AS invoice3_installment
                        ,''                                                        AS matching3_date
                        ,''                                                        AS invoice_currency_code3
                        ,''                                                        AS trans_to_receipt_rate3
                        ,''                                                        AS amount_applied3
                        ,''                                                        AS amount_applied_from3
                        ,''                                                        AS customer_reference3
                        ,''                                                        AS invoice4
                        ,''                                                        AS invoice4_installment
                        ,''                                                        AS matching4_date
                        ,''                                                        AS invoice_currency_code4
                        ,''                                                        AS trans_to_receipt_rate4
                        ,''                                                        AS amount_applied4
                        ,''                                                        AS amount_applied_from4
                        ,''                                                        AS customer_reference4
                        ,''                                                        AS invoice5
                        ,''                                                        AS invoice5_installment
                        ,''                                                        AS matching5_date
                        ,''                                                        AS invoice_currency_code5
                        ,''                                                        AS trans_to_receipt_rate5
                        ,''                                                        AS amount_applied5
                        ,''                                                        AS amount_applied_from5
                        ,''                                                        AS customer_reference5
                        ,''                                                        AS invoice6
                        ,''                                                        AS invoice6_installment
                        ,''                                                        AS matching6_date
                        ,''                                                        AS invoice_currency_code6
                        ,''                                                        AS trans_to_receipt_rate6
                        ,''                                                        AS amount_applied6
                        ,''                                                        AS amount_applied_from6
                        ,''                                                        AS customer_reference6
                        ,''                                                        AS invoice7
                        ,''                                                        AS invoice7_installment
                        ,''                                                        AS matching7_date
                        ,''                                                        AS invoice_currency_code7
                        ,''                                                        AS trans_to_receipt_rate7
                        ,''                                                        AS amount_applied7
                        ,''                                                        AS amount_applied_from7
                        ,''                                                        AS customer_reference7
                        ,''                                                        AS invoice8
                        ,''                                                        AS invoice8_installment
                        ,''                                                        AS matching8_date
                        ,''                                                        AS invoice_currency_code8
                        ,''                                                        AS trans_to_receipt_rate8
                        ,''                                                        AS amount_applied8
                        ,''                                                        AS amount_applied_from8
                        ,''                                                        AS customer_reference8
                        ,xxmx_utilities_pkg.convert_string
                               (
                                pv_i_StringToConvert     => acra.comments
                               ,pv_i_ConvertCommaToSpace => 'N'
                               ,pi_i_SubstrStartPos      => 1
                               ,pi_i_SubstrLength        => 240
                               ,pv_i_UseBinarySubstr     => 'Y'
                               )                                                   AS comments                        
--                        ,substrb(acra.comments, 1, 240)                            AS comments
                        ,NULL                                                      AS attribute1
                        ,NULL                                                      AS attribute2
                        ,NULL                                                      AS attribute3
                        ,NULL                                                      AS attribute4
                        ,NULL                                                      AS attribute5
                        ,NULL                                                      AS attribute6
                        ,NULL                                                      AS attribute7
                        ,NULL                                                      AS attribute8
                        ,NULL                                                      AS attribute9
                        ,NULL                                                      AS attribute10
                        ,NULL                                                      AS attribute11
                        ,NULL                                                      AS attribute12
                        ,NULL                                                      AS attribute13
                        ,NULL                                                      AS attribute14
                        ,NULL                                                      AS attribute15
                        ,NULL                                                      AS attribute_category
               FROM      xxmx_ar_cash_receipts_scope_v                xacrsv
                        ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT hcsu  -- new
                        ,apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT  acra
                        ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT      hca
                        ,bank_account_banks                           remittance_banks
                        ,bank_account_banks                           customer_banks
               WHERE     1 =  1
               AND       acra.org_id                             = xacrsv.org_id
               AND       acra.cash_receipt_id                    = xacrsv.cash_receipt_id
               AND       hca.cust_account_id                     = xacrsv.customer_id
               AND       remittance_banks.ext_bank_account_id(+) = acra.remittance_bank_account_id
               AND       customer_banks.ext_bank_account_id(+)   = acra.customer_bank_account_id
               AND       hcsu.site_use_id(+)                     = acra.customer_site_use_id               
               ORDER BY  xacrsv.cash_receipt_id;
/*
               --
               WITH bank_account_banks
               AS
                    (
                     SELECT  abb.bank_name
                            ,abb.bank_num           AS sort_code
                            ,abb.bank_branch_name
                            ,abaa.bank_account_id
                     FROM    apps.ap_bank_accounts_all@MXDM_NVIS_EXTRACT   abaa
                            ,apps.ap_bank_branches@MXDM_NVIS_EXTRACT       abb
                     WHERE   1 = 1
                     AND     abb.bank_branch_id = abaa.bank_branch_id
                    )
               SELECT    '6'                                                       AS record_type
                        ,ROWNUM                                                    AS record_seq
                        ,xacrsv.operating_unit_name                                AS operating_unit_name
                        ,''                                                        AS batch_name
                        ,ROWNUM                                                    AS item_number
                        ,acra.amount*decode(gct_AmountAsPence,'Y',100,1)           AS remittance_amount
                        ,''                                                        AS transit_routing_number
                        ,''                                                        AS customer_bank_account
                        ,acra.receipt_number                                       AS receipt_number
                        ,acra.receipt_date                                         AS receipt_date
                        ,acra.currency_code                                        AS currency_code
                        ,xacrsv.exchange_rate_type                                 AS exchange_rate_type
                        ,xacrsv.exchange_rate                                      AS exchange_rate
                        ,hca.account_number                                        AS customer_number
                        ,(
                          SELECT  MAX(hcsu.location)
                          FROM    hz_cust_accounts@MXDM_NVIS_EXTRACT        hca1
                                 ,hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT  hcas
                                 ,hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   hcsu
                          WHERE   1 = 1
                          AND     hca1.cust_account_id   = hcas.cust_account_id(+)
                          AND     hcas.cust_acct_site_id = hcsu.cust_acct_site_id
                          AND     hcsu.site_use_code     = 'BILL_TO'
                          AND     hcsu.primary_flag      = 'Y'
                          AND     hca1.account_number    = hca.account_number
                         )                                                         AS bill_to_location
                        ,customer_banks.bank_branch_name                           AS customer_bank_branch_name
                        ,customer_banks.bank_name                                  AS customer_bank_name
                        ,xacrsv.receipt_method_name                                AS receipt_method_name
                        ,remittance_banks.bank_branch_name                         AS remittance_bank_branch_name
                        ,remittance_banks.bank_name                                AS remittance_bank_name
                        ,acra.deposit_date                                         AS deposit_date
                        ,''                                                        AS deposit_time
                        ,acra.anticipated_clearing_date                            AS anticipated_clearing_date
                        ,''                                                        AS invoice1
                        ,''                                                        AS invoice_installment
                        ,''                                                        AS matching_date
                        ,''                                                        AS invoice_currency_code1
                        ,''                                                        AS trans_to_receipt_rate1
                        ,''                                                        AS amount_applied1
                        ,''                                                        AS amount_applied_from1
                        ,''                                                        AS customer_reference1
                        ,''                                                        AS invoice2
                        ,''                                                        AS invoice2_installment
                        ,''                                                        AS matching2_date
                        ,''                                                        AS invoice_currency_code2
                        ,''                                                        AS trans_to_receipt_rate2
                        ,''                                                        AS amount_applied2
                        ,''                                                        AS amount_applied_from2
                        ,''                                                        AS customer_reference2
                        ,''                                                        AS invoice3
                        ,''                                                        AS invoice3_installment
                        ,''                                                        AS matching3_date
                        ,''                                                        AS invoice_currency_code3
                        ,''                                                        AS trans_to_receipt_rate3
                        ,''                                                        AS amount_applied3
                        ,''                                                        AS amount_applied_from3
                        ,''                                                        AS customer_reference3
                        ,''                                                        AS invoice4
                        ,''                                                        AS invoice4_installment
                        ,''                                                        AS matching4_date
                        ,''                                                        AS invoice_currency_code4
                        ,''                                                        AS trans_to_receipt_rate4
                        ,''                                                        AS amount_applied4
                        ,''                                                        AS amount_applied_from4
                        ,''                                                        AS customer_reference4
                        ,''                                                        AS invoice5
                        ,''                                                        AS invoice5_installment
                        ,''                                                        AS matching5_date
                        ,''                                                        AS invoice_currency_code5
                        ,''                                                        AS trans_to_receipt_rate5
                        ,''                                                        AS amount_applied5
                        ,''                                                        AS amount_applied_from5
                        ,''                                                        AS customer_reference5
                        ,''                                                        AS invoice6
                        ,''                                                        AS invoice6_installment
                        ,''                                                        AS matching6_date
                        ,''                                                        AS invoice_currency_code6
                        ,''                                                        AS trans_to_receipt_rate6
                        ,''                                                        AS amount_applied6
                        ,''                                                        AS amount_applied_from6
                        ,''                                                        AS customer_reference6
                        ,''                                                        AS invoice7
                        ,''                                                        AS invoice7_installment
                        ,''                                                        AS matching7_date
                        ,''                                                        AS invoice_currency_code7
                        ,''                                                        AS trans_to_receipt_rate7
                        ,''                                                        AS amount_applied7
                        ,''                                                        AS amount_applied_from7
                        ,''                                                        AS customer_reference7
                        ,''                                                        AS invoice8
                        ,''                                                        AS invoice8_installment
                        ,''                                                        AS matching8_date
                        ,''                                                        AS invoice_currency_code8
                        ,''                                                        AS trans_to_receipt_rate8
                        ,''                                                        AS amount_applied8
                        ,''                                                        AS amount_applied_from8
                        ,''                                                        AS customer_reference8
                        ,xxmx_utilities_pkg.convert_string
                               (
                                pv_i_StringToConvert     => acra.comments
                               ,pv_i_ConvertCommaToSpace => 'N'
                               ,pi_i_SubstrStartPos      => 1
                               ,pi_i_SubstrLength        => 240
                               ,pv_i_UseBinarySubstr     => 'Y'
                               )                                                   AS comments                        
--                        ,substrb(acra.comments, 1, 240)                            AS comments
                        ,NULL                                                      AS attribute1
                        ,NULL                                                      AS attribute2
                        ,NULL                                                      AS attribute3
                        ,NULL                                                      AS attribute4
                        ,NULL                                                      AS attribute5
                        ,NULL                                                      AS attribute6
                        ,NULL                                                      AS attribute7
                        ,NULL                                                      AS attribute8
                        ,NULL                                                      AS attribute9
                        ,NULL                                                      AS attribute10
                        ,NULL                                                      AS attribute11
                        ,NULL                                                      AS attribute12
                        ,NULL                                                      AS attribute13
                        ,NULL                                                      AS attribute14
                        ,NULL                                                      AS attribute15
                        ,NULL                                                      AS attribute_category
               FROM      xxmx_ar_cash_receipts_scope_v                xacrsv
                        ,apps.ar_cash_receipts_all@MXDM_NVIS_EXTRACT  acra
                        ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT      hca
                        ,bank_account_banks                           remittance_banks
                        ,bank_account_banks                           customer_banks
               WHERE     1 =  1
               AND       acra.org_id                         = xacrsv.org_id
               AND       acra.cash_receipt_id                = xacrsv.cash_receipt_id
               AND       hca.cust_account_id                 = xacrsv.customer_id
               AND       remittance_banks.bank_account_id(+) = acra.remittance_bank_account_id
               AND       customer_banks.bank_account_id(+)   = acra.customer_bank_account_id
               ORDER BY  xacrsv.cash_receipt_id;
*/
--
          --** END CURSOR **
          --
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE ARCashReceipts_tt IS TABLE OF ARCashReceipts_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_cash_receipts_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_cash_receipts_stg';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          --
          --
          /*
          ****************************
          ** Record Table Declarations
          ****************************
          */
          --
          --
          --
          /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          ARCashReceipts_tbl              ARCashReceipts_tt;
          --
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          --** DSF 26/10/2020 - Modified all Utilities Package Procedure/Function Calls to pass new "gct_BusinessEntity" global constant
          --**                  to the "pt_i_BusinessEntity" parameter.
          --
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => pt_i_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          gvv_ProgressIndicator := '-0020';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          /*
          ** Delete any DATA messages from previous executions
          ** for the Business Entity and Business Entity Level.
          **
          ** There should not be any DATA messages issued from
          ** within Extract procedures so this is here as an
          ** example that can be copied into Transform/enrichment
          ** procedures as those procedures SHOULD be issuing
          ** data messages as part of any validation they perform.
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => pt_i_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'DATA'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          gvv_ProgressIndicator := '-0030';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'
                                                 ||gct_PackageName
                                                 ||'.'
                                                 ||ct_ProcOrFuncName
                                                 ||'" initiated.'
                    ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '-0040';
          --
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Extracting "'
                                                 ||pt_i_SubEntity
                                                 ||'":'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite       => gct_ApplicationSuite
                    ,pt_i_Application            => gct_Application
                    ,pt_i_BusinessEntity         => gct_BusinessEntity
                    ,pt_i_SubEntity              => pt_i_SubEntity
                    ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                    ,pt_i_StagingTable           => ct_StgTable
                    ,pt_i_ExtractStartDate       => SYSDATE
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Staging Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details initialised.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '-0050';
               --
               --
               --** Extract the AR Cash Receipts and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Extracting data into "'
                                                 ||ct_StgTable
                                                 ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_ProgressIndicator := '-0060';
               --
               OPEN ARCashReceipts_cur;
               --
               gvv_ProgressIndicator := '-0060';
               --
               LOOP
                    --
                    FETCH        ARCashReceipts_cur
                    BULK COLLECT
                    INTO         ARCashReceipts_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => ARCashReceipts_tbl.count ||
                                                      ' rows found to add to Staging Table "'
                                                      ||ct_StgTable || '"'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    EXIT WHEN ARCashReceipts_tbl.count=0;
                    --
                    gvv_ProgressIndicator := '-0070';
                    --
                    FORALL ARCashReceipts_idx IN 1..ARCashReceipts_tbl.count
                         --
                         INSERT
                         INTO xxmx_ar_cash_receipts_stg
                                  (
                                   migration_set_id
                                  ,migration_set_name
                                  ,record_type
                                  ,record_seq
                                  ,operating_unit_name
                                  ,batch_name
                                  ,item_number
                                  ,remittance_amount
                                  ,transit_routing_number
                                  ,customer_bank_account
                                  ,receipt_number
                                  ,receipt_date
                                  ,currency_code
                                  ,exchange_rate_type
                                  ,exchange_rate
                                  ,customer_number
                                  ,bill_to_location
                                  ,customer_bank_branch_name
                                  ,customer_bank_name
                                  ,receipt_method
                                  ,remittance_bank_branch_name
                                  ,remittance_bank_name
                                  ,deposit_date
                                  ,deposit_time
                                  ,anticipated_clearing_date
                                  ,invoice1
                                  ,invoice1_installment
                                  ,matching1_date
                                  ,invoice_currency_code1
                                  ,trans_to_receipt_rate1
                                  ,amount_applied1
                                  ,amount_applied_from1
                                  ,customer_reference1
                                  ,invoice2
                                  ,invoice2_installment
                                  ,matching2_date
                                  ,invoice_currency_code2
                                  ,trans_to_receipt_rate2
                                  ,amount_applied2
                                  ,amount_applied_from2
                                  ,customer_reference2
                                  ,invoice3
                                  ,invoice3_installment
                                  ,matching3_date
                                  ,invoice_currency_code3
                                  ,trans_to_receipt_rate3
                                  ,amount_applied3
                                  ,amount_applied_from3
                                  ,customer_reference3
                                  ,invoice4
                                  ,invoice4_installment
                                  ,matching4_date
                                  ,invoice_currency_code4
                                  ,trans_to_receipt_rate4
                                  ,amount_applied4
                                  ,amount_applied_from4
                                  ,customer_reference4
                                  ,invoice5
                                  ,invoice5_installment
                                  ,matching5_date
                                  ,invoice_currency_code5
                                  ,trans_to_receipt_rate5
                                  ,amount_applied5
                                  ,amount_applied_from5
                                  ,customer_reference5
                                  ,invoice6
                                  ,invoice6_installment
                                  ,matching6_date
                                  ,invoice_currency_code6
                                  ,trans_to_receipt_rate6
                                  ,amount_applied6
                                  ,amount_applied_from6
                                  ,customer_reference6
                                  ,invoice7
                                  ,invoice7_installment
                                  ,matching7_date
                                  ,invoice_currency_code7
                                  ,trans_to_receipt_rate7
                                  ,amount_applied7
                                  ,amount_applied_from7
                                  ,customer_reference7
                                  ,invoice8
                                  ,invoice8_installment
                                  ,matching8_date
                                  ,invoice_currency_code8
                                  ,trans_to_receipt_rate8
                                  ,amount_applied8
                                  ,amount_applied_from8
                                  ,customer_reference8
                                  ,comments
                                  ,attribute1
                                  ,attribute2
                                  ,attribute3
                                  ,attribute4
                                  ,attribute5
                                  ,attribute6
                                  ,attribute7
                                  ,attribute8
                                  ,attribute9
                                  ,attribute10
                                  ,attribute11
                                  ,attribute12
                                  ,attribute13
                                  ,attribute14
                                  ,attribute15
                                  ,attribute_category
                                  )
                         VALUES
                                  (
                                   pt_i_MigrationSetID                                                 -- migration_set_id
                                  ,gvt_MigrationSetName                                                -- migration_set_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).record_type                  -- record_type
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).record_seq                   -- record_seq
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).operating_unit_name          -- operating_unit_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).batch_name                   -- batch_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).item_number                  -- item_number
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).remittance_amount            -- remittance_amount
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).transit_routing_number       -- transit_routing_number
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_bank_account        -- customer_bank_account
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).receipt_number               -- receipt_number
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).receipt_date                 -- receipt_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).currency_code                -- currency_code
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).exchange_rate_type           -- exchange_rate_type
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).exchange_rate                -- exchange_rate
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_number              -- customer_number
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).bill_to_location             -- bill_to_location
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_bank_branch_name    -- customer_bank_branch_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_bank_name           -- customer_bank_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).receipt_method_name          -- receipt_method
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).remittance_bank_branch_name  -- remittance_bank_branch_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).remittance_bank_name         -- remittance_bank_name
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).deposit_date                 -- deposit_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).deposit_time                 -- deposit_time
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).anticipated_clearing_date    -- anticipated_clearing_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice1                     -- invoice1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_installment          -- invoice1_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching_date                -- matching1_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code1       -- invoice_currency_code1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate1       -- trans_to_receipt_rate1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied1              -- amount_applied1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from1         -- amount_applied_from1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference1          -- customer_reference1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice2                     -- invoice2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice2_installment         -- invoice2_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching2_date               -- matching2_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code2       -- invoice_currency_code2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate2       -- trans_to_receipt_rate2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied2              -- amount_applied2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from2         -- amount_applied_from2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference2          -- customer_reference2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice3                     -- invoice3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice3_installment         -- invoice3_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching3_date               -- matching3_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code3       -- invoice_currency_code3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate3       -- trans_to_receipt_rate3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied3              -- amount_applied3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from3         -- amount_applied_from3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference3          -- customer_reference3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice4                     -- invoice4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice4_installment         -- invoice4_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching4_date               -- matching4_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code4       -- invoice_currency_code4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate4       -- trans_to_receipt_rate4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied4              -- amount_applied4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from4         -- amount_applied_from4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference4          -- customer_reference4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice5                     -- invoice5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice5_installment         -- invoice5_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching5_date               -- matching5_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code5       -- invoice_currency_code5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate5       -- trans_to_receipt_rate5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied5              -- amount_applied5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from5         -- amount_applied_from5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference5          -- customer_reference5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice6                     -- invoice6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice6_installment         -- invoice6_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching6_date               -- matching6_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code6       -- invoice_currency_code6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate6       -- trans_to_receipt_rate6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied6              -- amount_applied6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from6         -- amount_applied_from6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference6          -- customer_reference6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice7                     -- invoice7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice7_installment         -- invoice7_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching7_date               -- matching7_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code7       -- invoice_currency_code7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate7       -- trans_to_receipt_rate7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied7              -- amount_applied7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from7         -- amount_applied_from7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference7          -- customer_reference7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice8                     -- invoice8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice8_installment         -- invoice8_installment
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).matching8_date               -- matching8_date
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).invoice_currency_code8       -- invoice_currency_code8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).trans_to_receipt_rate8       -- trans_to_receipt_rate8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied8              -- amount_applied8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).amount_applied_from8         -- amount_applied_from8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).customer_reference8          -- customer_reference8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).comments                     -- comments
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute1                   -- attribute1
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute2                   -- attribute2
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute3                   -- attribute3
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute4                   -- attribute4
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute5                   -- attribute5
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute6                   -- attribute6
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute7                   -- attribute7
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute8                   -- attribute8
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute9                   -- attribute9
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute10                  -- attribute10
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute11                  -- attribute11
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute12                  -- attribute12
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute13                  -- attribute13
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute14                  -- attribute14
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute15                  -- attribute15
                                  ,ARCashReceipts_tbl(ARCashReceipts_idx).attribute_category           -- attribute_category
                                  );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '-0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '-0090';
               --
               CLOSE ARCashReceipts_cur;
               --
               /*
               ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               ** is reached.
               */
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '    - '
                                               ||gvn_RowCount
                                               ||' rows inserted into "'
                                               ||ct_StgTable
                                               ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Extraction complete.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '-0100';
               --
               --** DSF 26/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_ProgressIndicator :='-0110';
               --
               --** DH  16/04/2021 - call custom package for any customisations to be processed.
               --
               xxmx_utilities_pkg.log_module_message
                  (
                   pt_i_ApplicationSuite    => gct_ApplicationSuite
                  ,pt_i_Application         => gct_Application
                  ,pt_i_BusinessEntity      => gct_BusinessEntity
                  ,pt_i_SubEntity           => pt_i_SubEntity
                  ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                  ,pt_i_Phase               => ct_Phase
                  ,pt_i_PackageName         => gct_PackageName
                  ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                  ,pt_i_Severity            => 'NOTIFICATION'               
                  ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                  ,pt_i_ModuleMessage       => 'Calling procedure "xxmx_ar_cash_receipts_cm_pkg.upd_cash_receipt_dffs_stg".'
                  ,pt_i_OracleError       => NULL
                  );
               --               
              -- xxmx_ar_cash_receipts_cm_pkg.upd_cash_receipt_dffs_stg(pt_i_MigrationSetID);
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity               => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Procedure "'
                                                 ||gct_PackageName
                                                 ||'.'
                                                 ||ct_ProcOrFuncName
                                                 ||'" completed.'
                    ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    IF ARCashReceipts_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARCashReceipts_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               --
               WHEN OTHERS
               THEN
                    --
                    --
                    IF ARCashReceipts_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARCashReceipts_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
               --
          --** END Exception Handler
          --
     END ar_cash_receipts_stg;
     --
     --
     /*
     **********************************
     ** PROCEDURE: ar_cash_receipts_xfm
     **********************************
     */
     --
     PROCEDURE ar_cash_receipts_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          -- Cursor to get the pre-transform data
          --
          CURSOR StgTable_cur
                      (
                       pt_MigrationSetID               xxmx_gl_balances_stg.migration_set_id%TYPE
                      )
          IS
               --
               SELECT    migration_set_id             AS migration_set_id
                        ,migration_set_name           AS migration_set_name
                        ,record_type                  AS record_type
                        ,operating_unit_name          AS operating_unit_name
                        ,batch_name                   AS batch_name
                        ,item_number                  AS item_number
                        ,remittance_amount            AS remittance_amount
                        ,transit_routing_number       AS transit_routing_number
                        ,customer_bank_account        AS customer_bank_account
                        ,receipt_number               AS receipt_number
                        ,receipt_date                 AS receipt_date
                        ,currency_code                AS currency_code
                        ,exchange_rate_type           AS exchange_rate_type
                        ,exchange_rate                AS exchange_rate
                        ,customer_number              AS customer_number
                        ,bill_to_location             AS bill_to_location
                        ,customer_bank_branch_name    AS customer_bank_branch_name
                        ,customer_bank_name           AS customer_bank_name
                        ,receipt_method               AS receipt_method
                        ,remittance_bank_branch_name  AS remittance_bank_branch_name
                        ,remittance_bank_name         AS remittance_bank_name
                        ,deposit_date                 AS deposit_date
                        ,deposit_time                 AS deposit_time
                        ,anticipated_clearing_date    AS anticipated_clearing_date
                        ,invoice1                     AS invoice1
                        ,invoice1_installment         AS invoice1_installment
                        ,matching1_date               AS matching1_date
                        ,invoice_currency_code1       AS invoice_currency_code1
                        ,trans_to_receipt_rate1       AS trans_to_receipt_rate1
                        ,amount_applied1              AS amount_applied1
                        ,amount_applied_from1         AS amount_applied_from1
                        ,customer_reference1          AS customer_reference1
                        ,invoice2                     AS invoice2
                        ,invoice2_installment         AS invoice2_installment
                        ,matching2_date               AS matching2_date
                        ,invoice_currency_code2       AS invoice_currency_code2
                        ,trans_to_receipt_rate2       AS trans_to_receipt_rate2
                        ,amount_applied2              AS amount_applied2
                        ,amount_applied_from2         AS amount_applied_from2
                        ,customer_reference2          AS customer_reference2
                        ,invoice3                     AS invoice3
                        ,invoice3_installment         AS invoice3_installment
                        ,matching3_date               AS matching3_date
                        ,invoice_currency_code3       AS invoice_currency_code3
                        ,trans_to_receipt_rate3       AS trans_to_receipt_rate3
                        ,amount_applied3              AS amount_applied3
                        ,amount_applied_from3         AS amount_applied_from3
                        ,customer_reference3          AS customer_reference3
                        ,invoice4                     AS invoice4
                        ,invoice4_installment         AS invoice4_installment
                        ,matching4_date               AS matching4_date
                        ,invoice_currency_code4       AS invoice_currency_code4
                        ,trans_to_receipt_rate4       AS trans_to_receipt_rate4
                        ,amount_applied4              AS amount_applied4
                        ,amount_applied_from4         AS amount_applied_from4
                        ,customer_reference4          AS customer_reference4
                        ,invoice5                     AS invoice5
                        ,invoice5_installment         AS invoice5_installment
                        ,matching5_date               AS matching5_date
                        ,invoice_currency_code5       AS invoice_currency_code5
                        ,trans_to_receipt_rate5       AS trans_to_receipt_rate5
                        ,amount_applied5              AS amount_applied5
                        ,amount_applied_from5         AS amount_applied_from5
                        ,customer_reference5          AS customer_reference5
                        ,invoice6                     AS invoice6
                        ,invoice6_installment         AS invoice6_installment
                        ,matching6_date               AS matching6_date
                        ,invoice_currency_code6       AS invoice_currency_code6
                        ,trans_to_receipt_rate6       AS trans_to_receipt_rate6
                        ,amount_applied6              AS amount_applied6
                        ,amount_applied_from6         AS amount_applied_from6
                        ,customer_reference6          AS customer_reference6
                        ,invoice7                     AS invoice7
                        ,invoice7_installment         AS invoice7_installment
                        ,matching7_date               AS matching7_date
                        ,invoice_currency_code7       AS invoice_currency_code7
                        ,trans_to_receipt_rate7       AS trans_to_receipt_rate7
                        ,amount_applied7              AS amount_applied7
                        ,amount_applied_from7         AS amount_applied_from7
                        ,customer_reference7          AS customer_reference7
                        ,invoice8                     AS invoice8
                        ,invoice8_installment         AS invoice8_installment
                        ,matching8_date               AS matching8_date
                        ,invoice_currency_code8       AS invoice_currency_code8
                        ,trans_to_receipt_rate8       AS trans_to_receipt_rate8
                        ,amount_applied8              AS amount_applied8
                        ,amount_applied_from8         AS amount_applied_from8
                        ,customer_reference8          AS customer_reference8
                        ,comments                     AS comments
                        ,attribute1                   AS attribute1
                        ,attribute2                   AS attribute2
                        ,attribute3                   AS attribute3
                        ,attribute4                   AS attribute4
                        ,attribute5                   AS attribute5
                        ,attribute6                   AS attribute6
                        ,attribute7                   AS attribute7
                        ,attribute8                   AS attribute8
                        ,attribute9                   AS attribute9
                        ,attribute10                  AS attribute10
                        ,attribute11                  AS attribute11
                        ,attribute12                  AS attribute12
                        ,attribute13                  AS attribute13
                        ,attribute14                  AS attribute14
                        ,attribute15                  AS attribute15
                        ,attribute_category           AS attribute_category


               FROM      xxmx_ar_cash_receipts_stg
               WHERE     1 = 1
               AND       migration_set_id = pt_MigrationSetID
               ORDER BY  operating_unit_name;
               --
          --** END CURSOR StgTable_cur
          --
          CURSOR SourceOperatingUnits_cur
                      (
                       pt_MigrationSetID               xxmx_ar_cash_rcpts_rt6_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT source_operating_unit_name
               FROM    xxmx_ar_cash_rcpts_rt6_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID;
               --
          --** END CURSOR SourceOperatingUnits_cur
          --
          CURSOR LockboxHeadersGen_cur
                      (
                       pt_MigrationSetID               xxmx_ar_cash_rcpts_rt6_xfm.migration_set_id%TYPE
                      )
          IS
               --
               WITH
               lockbox_summary
               AS
                    (
                     SELECT    migration_set_id             AS migration_set_id
                              ,migration_set_name           AS migration_set_name
                              ,transform_status             AS transform_status
                              ,source_operating_unit_name   AS source_operating_unit_name
                              ,fusion_business_unit_name    AS fusion_business_unit_name
                              ,lockbox_number               AS lockbox_number
                              ,COUNT(*)                     AS lockbox_record_count
                              ,SUM(remittance_amount)       AS lockbox_amount
                     FROM      xxmx_ar_cash_rcpts_rt6_xfm
                     WHERE     1 = 1
                     AND       migration_set_id      = pt_i_MigrationSetID
                     AND       transform_status      = 'TRANSFORMED'
                     GROUP BY  migration_set_id
                              ,migration_set_name
                              ,transform_status
                              ,source_operating_unit_name
                              ,fusion_business_unit_name
                              ,lockbox_number
                    )
               SELECT  migration_set_id             AS migration_set_id
                      ,migration_set_name           AS migration_set_name
                      ,transform_status             AS transform_status
                      ,ROWNUM                       AS header_trailer_seq
                      ,source_operating_unit_name   AS source_operating_unit_name
                      ,fusion_business_unit_name    AS fusion_business_unit_name
                      ,lockbox_number               AS lockbox_number
                      ,lockbox_record_count         AS lockbox_record_count
                      ,lockbox_amount               AS lockbox_amount
               FROM    lockbox_summary
               WHERE   1 = 1
               ORDER BY  lockbox_summary.source_operating_unit_name;
               --
          --** END CURSOR LockboxHeadersGen_cur
          --
          CURSOR RecordConsolidation_cur
                      (
                       pt_MigrationSetID               xxmx_ar_cash_rcpts_rt6_xfm.migration_set_id%TYPE
                      )
          IS
               --
               WITH
               xfm_tables
               AS
                   (
                    /*********************************************************/
                    /* COMMENTED OUT AS SOLUTION NOW USES RECORD TYPE 6 ONLY */
                    /*********************************************************/
                    /* Record Type 5 (Lockbox Header) Records */
                    -- 
                    --SELECT    migration_set_id                     AS migration_set_id
                    --         ,migration_set_name                   AS migration_set_name
                    --         ,lockbox_number                       AS lockbox_number                                                          
                    --         ,record_seq                                     
                    --         ,record_type                          AS column_1  
                    --         ,currency_code                        AS column_2  
                    --         ,receipt_method                       AS column_3  
                    --         ,lockbox_number                       AS column_4  
                    --         ,TO_CHAR(deposit_date, 'RRMMDD')      AS column_5  
                    --         ,TO_CHAR(deposit_time, 'HH24:MI:SS')  AS column_6  
                    --         ,TO_CHAR(lockbox_batch_count)         AS column_7  
                    --         ,TO_CHAR(lockbox_record_count)        AS column_8  
                    --         ,TO_CHAR(lockbox_amount)              AS column_9  
                    --         ,destination_bank_account             AS column_10 
                    --         ,bank_origination_number              AS column_11 
                    --         ,attribute1                           AS column_12 
                    --         ,attribute2                           AS column_13 
                    --         ,attribute3                           AS column_14 
                    --         ,attribute4                           AS column_15 
                    --         ,attribute5                           AS column_16 
                    --         ,attribute6                           AS column_17 
                    --         ,attribute7                           AS column_18 
                    --         ,attribute8                           AS column_19 
                    --         ,attribute9                           AS column_20 
                    --         ,attribute10                          AS column_21 
                    --         ,attribute11                          AS column_22 
                    --         ,attribute12                          AS column_23 
                    --         ,attribute13                          AS column_24 
                    --         ,attribute14                          AS column_25 
                    --         ,attribute15                          AS column_26 
                    --         ,'END'                                AS column_27 
                    --         ,NULL                                 AS column_28 
                    --         ,NULL                                 AS column_29 
                    --         ,NULL                                 AS column_30 
                    --         ,NULL                                 AS column_31 
                    --         ,NULL                                 AS column_32 
                    --         ,NULL                                 AS column_33 
                    --         ,NULL                                 AS column_34 
                    --         ,NULL                                 AS column_35 
                    --         ,NULL                                 AS column_36 
                    --         ,NULL                                 AS column_37 
                    --         ,NULL                                 AS column_38 
                    --         ,NULL                                 AS column_39 
                    --         ,NULL                                 AS column_40 
                    --         ,NULL                                 AS column_41 
                    --         ,NULL                                 AS column_42 
                    --         ,NULL                                 AS column_43 
                    --         ,NULL                                 AS column_44 
                    --         ,NULL                                 AS column_45 
                    --         ,NULL                                 AS column_46 
                    --         ,NULL                                 AS column_47 
                    --         ,NULL                                 AS column_48 
                    --         ,NULL                                 AS column_49 
                    --         ,NULL                                 AS column_50 
                    --         ,NULL                                 AS column_51 
                    --         ,NULL                                 AS column_52 
                    --         ,NULL                                 AS column_53 
                    --         ,NULL                                 AS column_54 
                    --         ,NULL                                 AS column_55 
                    --         ,NULL                                 AS column_56 
                    --         ,NULL                                 AS column_57 
                    --         ,NULL                                 AS column_58 
                    --         ,NULL                                 AS column_59 
                    --         ,NULL                                 AS column_60 
                    --         ,NULL                                 AS column_61 
                    --         ,NULL                                 AS column_62 
                    --         ,NULL                                 AS column_63 
                    --         ,NULL                                 AS column_64 
                    --         ,NULL                                 AS column_65 
                    --         ,NULL                                 AS column_66 
                    --         ,NULL                                 AS column_67 
                    --         ,NULL                                 AS column_68 
                    --         ,NULL                                 AS column_69 
                    --         ,NULL                                 AS column_70 
                    --         ,NULL                                 AS column_71 
                    --         ,NULL                                 AS column_72 
                    --         ,NULL                                 AS column_73 
                    --         ,NULL                                 AS column_74 
                    --         ,NULL                                 AS column_75 
                    --         ,NULL                                 AS column_76 
                    --         ,NULL                                 AS column_77 
                    --         ,NULL                                 AS column_78 
                    --         ,NULL                                 AS column_79 
                    --         ,NULL                                 AS column_80 
                    --         ,NULL                                 AS column_81 
                    --         ,NULL                                 AS column_82 
                    --         ,NULL                                 AS column_83 
                    --         ,NULL                                 AS column_84 
                    --         ,NULL                                 AS column_85 
                    --         ,NULL                                 AS column_86 
                    --         ,NULL                                 AS column_87 
                    --         ,NULL                                 AS column_88 
                    --         ,NULL                                 AS column_89 
                    --         ,NULL                                 AS column_90 
                    --         ,NULL                                 AS column_91 
                    --         ,NULL                                 AS column_92 
                    --         ,NULL                                 AS column_93 
                    --         ,NULL                                 AS column_94 
                    --         ,NULL                                 AS column_95 
                    --         ,NULL                                 AS column_96 
                    --         ,NULL                                 AS column_97 
                    --         ,NULL                                 AS column_98 
                    --         ,NULL                                 AS column_99 
                    --         ,NULL                                 AS column_100
                    --         ,NULL                                 AS column_101
                    --         ,NULL                                 AS column_102
                    --         ,NULL                                 AS column_103
                    --         ,NULL                                 AS column_104
                    --FROM      xxmx_ar_cash_rcpts_rt5_xfm
                    --WHERE     1 = 1
                    --AND       migration_set_id = pt_MigrationSetID
                    --UNION
                    --
                    /* Record Type 6 (Cash Receipt Transaction) Records */
                    SELECT    migration_set_id                              AS migration_set_id
                             ,migration_set_name                            AS migration_set_name
                             ,lockbox_number                                AS lockbox_number                                                                                              
                             ,record_seq                                              
                             ,record_type                                   AS column_1  
                             ,batch_name                                    AS column_2  
                             ,TO_CHAR(item_number)                          AS column_3  
                             ,TO_CHAR(remittance_amount)                    AS column_4  
                             ,transit_routing_number                        AS column_5  
                             ,customer_bank_account                         AS column_6  
                             ,receipt_number                                AS column_7  
                             ,TO_CHAR(receipt_date, 'RRMMDD' )              AS column_8  
                             ,currency_code                                 AS column_9  
                             ,exchange_rate_type                            AS column_10 
                             ,TO_CHAR(exchange_rate)                        AS column_11 
                             ,customer_number                               AS column_12 
                             ,bill_to_location                              AS column_13 
                             ,customer_bank_branch_name                     AS column_14 
                             ,customer_bank_name                            AS column_15 
                             ,receipt_method                                AS column_16 
                             ,remittance_bank_branch_name                   AS column_17 
                             ,remittance_bank_name                          AS column_18 
                             ,lockbox_number                                AS column_19 
                             ,TO_CHAR(deposit_date, 'RRMMDD')               AS column_20 
                             ,TO_CHAR(deposit_time, 'HH24:MI:SS')           AS column_21 
                             ,TO_CHAR(anticipated_clearing_date, 'RRMMDD')  AS column_22 
                             ,invoice1                                      AS column_23 
                             ,TO_CHAR(invoice1_installment)                 AS column_24 
                             ,TO_CHAR(matching1_date, 'RRMMDD')             AS column_25 
                             ,invoice_currency_code1                        AS column_26 
                             ,TO_CHAR(trans_to_receipt_rate1)               AS column_27 
                             ,TO_CHAR(amount_applied1)                      AS column_28 
                             ,TO_CHAR(amount_applied_from1)                 AS column_29 
                             ,customer_reference1                           AS column_30 
                             ,invoice2                                      AS column_31 
                             ,TO_CHAR(invoice2_installment)                 AS column_32 
                             ,TO_CHAR(matching2_date, 'RRMMDD')             AS column_33 
                             ,invoice_currency_code2                        AS column_34 
                             ,TO_CHAR(trans_to_receipt_rate2)               AS column_35 
                             ,TO_CHAR(amount_applied2)                      AS column_36 
                             ,TO_CHAR(amount_applied_from2)                 AS column_37 
                             ,customer_reference2                           AS column_38 
                             ,invoice3                                      AS column_39 
                             ,TO_CHAR(invoice3_installment)                 AS column_40 
                             ,TO_CHAR(matching3_date, 'RRMMDD')             AS column_41 
                             ,invoice_currency_code3                        AS column_42 
                             ,TO_CHAR(trans_to_receipt_rate3)               AS column_43 
                             ,TO_CHAR(amount_applied3)                      AS column_44 
                             ,TO_CHAR(amount_applied_from3)                 AS column_45 
                             ,customer_reference3                           AS column_46 
                             ,invoice4                                      AS column_47 
                             ,TO_CHAR(invoice4_installment)                 AS column_48 
                             ,TO_CHAR(matching4_date, 'RRMMDD')             AS column_49 
                             ,invoice_currency_code4                        AS column_50 
                             ,TO_CHAR(trans_to_receipt_rate4)               AS column_51 
                             ,TO_CHAR(amount_applied4)                      AS column_52 
                             ,TO_CHAR(amount_applied_from4)                 AS column_53 
                             ,customer_reference4                           AS column_54 
                             ,invoice5                                      AS column_55 
                             ,TO_CHAR(invoice5_installment)                 AS column_56 
                             ,TO_CHAR(matching5_date, 'RRMMDD')             AS column_57 
                             ,invoice_currency_code5                        AS column_58 
                             ,TO_CHAR(trans_to_receipt_rate5)               AS column_59 
                             ,TO_CHAR(amount_applied5)                      AS column_60 
                             ,TO_CHAR(amount_applied_from5)                 AS column_61 
                             ,customer_reference5                           AS column_62 
                             ,invoice6                                      AS column_63 
                             ,TO_CHAR(invoice6_installment)                 AS column_64 
                             ,TO_CHAR(matching6_date, 'RRMMDD')             AS column_65 
                             ,invoice_currency_code6                        AS column_66 
                             ,TO_CHAR(trans_to_receipt_rate6)               AS column_67 
                             ,TO_CHAR(amount_applied6)                      AS column_68 
                             ,TO_CHAR(amount_applied_from6)                 AS column_69 
                             ,customer_reference6                           AS column_70 
                             ,invoice7                                      AS column_71 
                             ,TO_CHAR(invoice7_installment)                 AS column_72 
                             ,TO_CHAR(matching7_date, 'RRMMDD')             AS column_73 
                             ,invoice_currency_code7                        AS column_74 
                             ,TO_CHAR(trans_to_receipt_rate7)               AS column_75 
                             ,TO_CHAR(amount_applied7)                      AS column_76 
                             ,TO_CHAR(amount_applied_from7)                 AS column_77 
                             ,customer_reference7                           AS column_78 
                             ,invoice8                                      AS column_79 
                             ,TO_CHAR(invoice8_installment)                 AS column_80 
                             ,TO_CHAR(matching8_date, 'RRMMDD')             AS column_81 
                             ,invoice_currency_code8                        AS column_82 
                             ,TO_CHAR(trans_to_receipt_rate8)               AS column_83 
                             ,TO_CHAR(amount_applied8)                      AS column_84 
                             ,TO_CHAR(amount_applied_from8)                 AS column_85 
                             ,customer_reference8                           AS column_86 
                             ,comments                                      AS column_87 
                             ,attribute1                                    AS column_88 
                             ,attribute2                                    AS column_89 
                             ,attribute3                                    AS column_90 
                             ,attribute4                                    AS column_91 
                             ,attribute5                                    AS column_92 
                             ,attribute6                                    AS column_93 
                             ,attribute7                                    AS column_94 
                             ,attribute8                                    AS column_95 
                             ,attribute9                                    AS column_96 
                             ,attribute10                                   AS column_97 
                             ,attribute11                                   AS column_98 
                             ,attribute12                                   AS column_99 
                             ,attribute13                                   AS column_100
                             ,attribute14                                   AS column_101
                             ,attribute15                                   AS column_102
                             ,attribute_category                            AS column_103
                             ,'END'                                         AS column_104
                    FROM      xxmx_ar_cash_rcpts_rt6_xfm
                    WHERE     1 = 1
                    AND       migration_set_id = pt_MigrationSetID
                    /*********************************************************/
                    /* COMMENTED OUT AS SOLUTION NOW USES RECORD TYPE 6 ONLY */
                    /*********************************************************/                    
                    /* UNION Record Type 8 (Lockbox Trailer) Records */
                    --
                    --UNION
                    --SELECT    migration_set_id                     AS migration_set_id
                    --         ,migration_set_name                   AS migration_set_name
                    --         ,lockbox_number                       AS lockbox_number                                                                                     
                    --         ,record_seq                                     
                    --         ,record_type                          AS column_1  
                    --         ,currency_code                        AS column_2  
                    --         ,receipt_method                       AS column_3  
                    --         ,lockbox_number                       AS column_4  
                    --         ,TO_CHAR(deposit_date, 'RRMMDD')      AS column_5  
                    --         ,TO_CHAR(deposit_time, 'HH24:MI:SS')  AS column_6  
                    --         ,TO_CHAR(lockbox_batch_count)         AS column_7  
                    --         ,TO_CHAR(lockbox_record_count)        AS column_8  
                    --         ,TO_CHAR(lockbox_amount)              AS column_9  
                    --         ,destination_bank_account             AS column_10 
                    --         ,bank_origination_number              AS column_11 
                    --         ,attribute1                           AS column_12 
                    --         ,attribute2                           AS column_13 
                    --         ,attribute3                           AS column_14 
                    --         ,attribute4                           AS column_15 
                    --         ,attribute5                           AS column_16 
                    --         ,attribute6                           AS column_17 
                    --         ,attribute7                           AS column_18 
                    --         ,attribute8                           AS column_19 
                    --         ,attribute9                           AS column_20 
                    --         ,attribute10                          AS column_21 
                    --         ,attribute11                          AS column_22 
                    --         ,attribute12                          AS column_23 
                    --         ,attribute13                          AS column_24 
                    --         ,attribute14                          AS column_25 
                    --         ,attribute15                          AS column_26 
                    --         ,'END'                                AS column_27 
                    --         ,NULL                                 AS column_28 
                    --         ,NULL                                 AS column_29 
                    --         ,NULL                                 AS column_30 
                    --         ,NULL                                 AS column_31 
                    --         ,NULL                                 AS column_32 
                    --         ,NULL                                 AS column_33 
                    --         ,NULL                                 AS column_34 
                    --         ,NULL                                 AS column_35 
                    --         ,NULL                                 AS column_36 
                    --         ,NULL                                 AS column_37 
                    --         ,NULL                                 AS column_38 
                    --         ,NULL                                 AS column_39 
                    --         ,NULL                                 AS column_40 
                    --         ,NULL                                 AS column_41 
                    --         ,NULL                                 AS column_42 
                    --         ,NULL                                 AS column_43 
                    --         ,NULL                                 AS column_44 
                    --         ,NULL                                 AS column_45 
                    --         ,NULL                                 AS column_46 
                    --         ,NULL                                 AS column_47 
                    --         ,NULL                                 AS column_48 
                    --         ,NULL                                 AS column_49 
                    --         ,NULL                                 AS column_50 
                    --         ,NULL                                 AS column_51 
                    --         ,NULL                                 AS column_52 
                    --         ,NULL                                 AS column_53 
                    --         ,NULL                                 AS column_54 
                    --         ,NULL                                 AS column_55 
                    --         ,NULL                                 AS column_56 
                    --         ,NULL                                 AS column_57 
                    --         ,NULL                                 AS column_58 
                    --         ,NULL                                 AS column_59 
                    --         ,NULL                                 AS column_60 
                    --         ,NULL                                 AS column_61 
                    --         ,NULL                                 AS column_62 
                    --         ,NULL                                 AS column_63 
                    --         ,NULL                                 AS column_64 
                    --         ,NULL                                 AS column_65 
                    --         ,NULL                                 AS column_66 
                    --         ,NULL                                 AS column_67 
                    --         ,NULL                                 AS column_68 
                    --         ,NULL                                 AS column_69 
                    --         ,NULL                                 AS column_70 
                    --         ,NULL                                 AS column_71 
                    --         ,NULL                                 AS column_72 
                    --         ,NULL                                 AS column_73 
                    --         ,NULL                                 AS column_74 
                    --         ,NULL                                 AS column_75 
                    --         ,NULL                                 AS column_76 
                    --         ,NULL                                 AS column_77 
                    --         ,NULL                                 AS column_78 
                    --         ,NULL                                 AS column_79 
                    --         ,NULL                                 AS column_80 
                    --         ,NULL                                 AS column_81 
                    --         ,NULL                                 AS column_82 
                    --         ,NULL                                 AS column_83 
                    --         ,NULL                                 AS column_84 
                    --         ,NULL                                 AS column_85 
                    --         ,NULL                                 AS column_86 
                    --         ,NULL                                 AS column_87 
                    --         ,NULL                                 AS column_88 
                    --         ,NULL                                 AS column_89 
                    --         ,NULL                                 AS column_90 
                    --         ,NULL                                 AS column_91 
                    --         ,NULL                                 AS column_92 
                    --         ,NULL                                 AS column_93 
                    --         ,NULL                                 AS column_94 
                    --         ,NULL                                 AS column_95 
                    --         ,NULL                                 AS column_96 
                    --         ,NULL                                 AS column_97 
                    --         ,NULL                                 AS column_98 
                    --         ,NULL                                 AS column_99 
                    --         ,NULL                                 AS column_100
                    --         ,NULL                                 AS column_101
                    --         ,NULL                                 AS column_102
                    --         ,NULL                                 AS column_103
                    --         ,NULL                                 AS column_104
                    --FROM      xxmx_ar_cash_rcpts_rt8_xfm
                    --WHERE     1 = 1
                    --AND       migration_set_id = pt_MigrationSetID
                    --
                    ORDER BY column_1
                            ,record_seq
                   )
               SELECT    migration_set_id 
                        ,migration_set_name
                        ,lockbox_number                                       
                        ,ROWNUM                          AS out_rec_seq          
                        ,column_1
                        ,column_2  
                        ,column_3  
                        ,column_4  
                        ,column_5  
                        ,column_6  
                        ,column_7  
                        ,column_8  
                        ,column_9  
                        ,column_10 
                        ,column_11 
                        ,column_12 
                        ,column_13 
                        ,column_14 
                        ,column_15 
                        ,column_16 
                        ,column_17 
                        ,column_18 
                        ,column_19 
                        ,column_20 
                        ,column_21 
                        ,column_22 
                        ,column_23 
                        ,column_24 
                        ,column_25 
                        ,column_26 
                        ,column_27 
                        ,column_28 
                        ,column_29 
                        ,column_30 
                        ,column_31 
                        ,column_32 
                        ,column_33 
                        ,column_34 
                        ,column_35 
                        ,column_36 
                        ,column_37 
                        ,column_38 
                        ,column_39 
                        ,column_40 
                        ,column_41 
                        ,column_42 
                        ,column_43 
                        ,column_44 
                        ,column_45 
                        ,column_46 
                        ,column_47 
                        ,column_48 
                        ,column_49 
                        ,column_50 
                        ,column_51 
                        ,column_52 
                        ,column_53 
                        ,column_54 
                        ,column_55 
                        ,column_56 
                        ,column_57 
                        ,column_58 
                        ,column_59 
                        ,column_60 
                        ,column_61 
                        ,column_62 
                        ,column_63 
                        ,column_64 
                        ,column_65 
                        ,column_66 
                        ,column_67 
                        ,column_68 
                        ,column_69 
                        ,column_70 
                        ,column_71 
                        ,column_72 
                        ,column_73 
                        ,column_74 
                        ,column_75 
                        ,column_76 
                        ,column_77 
                        ,column_78 
                        ,column_79 
                        ,column_80 
                        ,column_81 
                        ,column_82 
                        ,column_83 
                        ,column_84 
                        ,column_85 
                        ,column_86 
                        ,column_87 
                        ,column_88 
                        ,column_89 
                        ,column_90 
                        ,column_91 
                        ,column_92 
                        ,column_93 
                        ,column_94 
                        ,column_95 
                        ,column_96 
                        ,column_97 
                        ,column_98 
                        ,column_99 
                        ,column_100
                        ,column_101
                        ,column_102
                        ,column_103
                        ,column_104
               FROM      xfm_tables
               WHERE     1 = 1
               AND       migration_set_id = pt_MigrationSetID
               ORDER BY  column_1
                        ,out_rec_seq;
               --
          --** END CURSOR RecordConsolidation_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE stg_table_tt IS TABLE OF StgTable_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          TYPE out_table_tt IS TABLE OF RecordConsolidation_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_cash_receipts_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_salescredits_stg';
          ct_Rt5XfmTable                  CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_cash_rcpts_rt5_xfm';
          ct_Rt6XfmTable                  CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_cash_rcpts_rt6_xfm';
          ct_Rt8XfmTable                  CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_cash_rcpts_rt8_xfm';
          ct_OutXfmTable                  CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_cash_receipts_out';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          --** Create a variable based on the XFM table to hold the result or each simple
          --** or complex transformation.
          --
          vd_TransformStartDate           DATE;
          vt_MigrationStatus              xxmx_ar_cash_rcpts_rt6_xfm.transform_status%TYPE;
          vt_FusionBusinessUnitName       xxmx_source_operating_units.fusion_business_unit_name%TYPE;
          vt_FusionBusinessUnitID         xxmx_source_operating_units.fusion_business_unit_id%TYPE;
          vt_FusionLockboxNumber          xxmx_source_operating_units.lockbox_number%TYPE;
          vn_Rt5Rowcount                  NUMBER;
          vn_Rt6Rowcount                  NUMBER;
          vn_Rt8Rowcount                  NUMBER;
          vn_TotalExpectedRowcount        NUMBER;
          vn_OutRowcount                  NUMBER;
          vv_TransmissionTimestamp        VARCHAR2(20);
          --
          /*
          ****************************
          ** Record Table Declarations
          ****************************
          */
          --
          --
          /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          StgTable_tbl                    stg_table_tt;
          OutTable_tbl                    out_table_tt;
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          /*
          ** Initialise Procedure Global Variables
          */
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus := '';
          --
          /*
          ** Delete any MODULE messages from previous executions
          ** for the Business Entity and Business Entity Level
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Delete any DATA messages from previous executions
          ** for the Business Entity and Business Entity Level.
          **
          ** There should not be any DATA messages issued from
          ** within Extract procedures so this is here as an
          ** example that can be copied into Transform/enrichment
          ** procedures as those procedures SHOULD be issuing
          ** data messages as part of any validation they perform.
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Retrieve the Migration Set Name and Metadata
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          IF   pt_i_MigrationSetID       IS NOT NULL
          AND  pt_i_SubEntity            IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               vd_TransformStartDate := SYSDATE;
               --
               gvv_ProgressIndicator := '0060';
               --
               /*
               ** First delete any data from the XFM table for the current Migration Set ID.
               **
               ** This is to allow the PL/SQL based transformation process to be executed repeatedly
               ** if the client wishes to perform corrections to mapping data before the File Generation
               ** and load into Fusion Cloud takes place.
               */
               --
               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Simple transformation processing initiated.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '  - Deleting existing data from the '
               --                                ||ct_XfmTable
               --                                ||' table for Migration Set ID "'
               --                                ||pt_i_MigrationSetID
               --                                ||'".'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               --DELETE
               --FROM   xxmx_ar_cash_receipts_xfm
               --WHERE  1 = 1
               --AND    migration_set_id = pt_i_MigrationSetID;
               ----
               --gvn_RowCount := SQL%ROWCOUNT;
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '    - '
               --                                ||gvn_RowCount
               --                                ||' rows deleted.'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               --/*
               --** For Simple Transformations being performed by PL/SQL the data must be moved
               --** from the STG table to the XFM table as-is.
               --**
               --** The data is then transformed vertically with several updates across all rows.
               --**
               --** Any simple transforms are performed first followed by any complex transforms.
               --*/
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '  - Copying "'
               --                                ||pt_i_SubEntity
               --                                ||'" data from the "'
               --                                ||ct_StgTable
               --                                ||'" table to the "'
               --                                ||ct_XfmTable
               --                                ||'" table prior to simple transformation '
               --                                ||'(transformation processing is all by PL/SQL '
               --                                ||'for this Sub-entity).'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               --gvv_ProgressIndicator := '0080';
               ----
               --/*
               --** Copy the data from the STG table to the XFM Table.
               --*/
               ----
               --OPEN StgTable_cur
               --          (
               --           pt_i_MigrationSetID
               --          );
               ----
               --gvv_ProgressIndicator := '0090';
               ----
               --LOOP
               --     --
               --     FETCH        StgTable_cur
               --     BULK COLLECT
               --     INTO         StgTable_tbl
               --     LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
               --     --
               --     EXIT WHEN    StgTable_tbl.COUNT = 0;
               --     --
               --     gvv_ProgressIndicator := '0100';
               --     --
               --     FORALL ARCashReceipt_idx
               --     IN     1..StgTable_tbl.COUNT
               --          --
               --          INSERT
               --          INTO   xxmx_ar_cash_rcpts_rt6_xfm
               --                      (
               --                       migration_set_id
               --                      ,migration_set_name
               --                      ,transform_status
               --                      ,record_type
               --                      ,source_operating_unit_name
               --                      ,fusion_business_unit_name
               --                      ,batch_name
               --                      ,item_number
               --                      ,remittance_amount
               --                      ,transit_routing_number
               --                      ,customer_bank_account
               --                      ,receipt_number
               --                      ,receipt_date
               --                      ,currency_code
               --                      ,exchange_rate_type
               --                      ,exchange_rate
               --                      ,customer_number
               --                      ,bill_to_location
               --                      ,customer_bank_branch_name
               --                      ,customer_bank_name
               --                      ,receipt_method
               --                      ,remittance_bank_branch_name
               --                      ,remittance_bank_name
               --                      ,lockbox_number
               --                       deposit_date                 ,
               --                      ,deposit_time
               --                      ,anticipated_clearing_date
               --                      ,invoice1
               --                      ,invoice1_installment
               --                      ,matching1_date
               --                      ,invoice_currency_code1
               --                      ,trans_to_receipt_rate1
               --                      ,amount_applied1
               --                      ,amount_applied_from1
               --                      ,customer_reference1
               --                      ,invoice2
               --                      ,invoice2_installment
               --                      ,matching2_date
               --                      ,invoice_currency_code2
               --                      ,trans_to_receipt_rate2
               --                      ,amount_applied2
               --                      ,amount_applied_from2
               --                      ,customer_reference2
               --                      ,invoice3
               --                      ,invoice3_installment
               --                      ,matching3_date
               --                      ,invoice_currency_code3
               --                      ,trans_to_receipt_rate3
               --                      ,amount_applied3
               --                      ,amount_applied_from3
               --                      ,customer_reference3
               --                      ,invoice4
               --                      ,invoice4_installment
               --                      ,matching4_date
               --                      ,invoice_currency_code4
               --                      ,trans_to_receipt_rate4
               --                       amount_applied4
               --                     , amount_applied_from4
               --                      ,customer_reference4
               --                      ,invoice5
               --                      ,invoice5_installment
               --                      ,matching5_date
               --                      ,invoice_currency_code5
               --                      ,trans_to_receipt_rate5
               --                      ,amount_applied5
               --                      ,amount_applied_from5
               --                      ,customer_reference5
               --                      ,invoice6
               --                      ,invoice6_installment
               --                      ,matching6_date
               --                      ,invoice_currency_code6
               --                      ,trans_to_receipt_rate6
               --                      ,amount_applied6
               --                      ,amount_applied_from6
               --                       customer_reference6
               --                      ,invoice7
               --                      ,invoice7_installment
               --                      ,matching7_date
               --                      ,invoice_currency_code7
               --                      ,trans_to_receipt_rate7
               --                      ,amount_applied7
               --                      ,amount_applied_from7
               --                      ,customer_reference7
               --                      ,invoice8
               --                      ,invoice8_installment
               --                      ,matching8_date
               --                      ,invoice_currency_code8
               --                      ,trans_to_receipt_rate8
               --                      ,amount_applied8
               --                      ,amount_applied_from8
               --                      ,customer_reference8
               --                      ,comments
               --                      ,attribute1
               --                      ,attribute2
               --                      ,attribute3
               --                      ,attribute4
               --                      ,attribute5
               --                      ,attribute6
               --                      ,attribute7
               --                      ,attribute8
               --                      ,attribute9
               --                      ,attribute10
               --                      ,attribute11
               --                      ,attribute12
               --                      ,attribute13
               --                      ,attribute14
               --                      ,attribute15
               --                      ,attribute_category
               --                      )
               --          VALUES
               --                      (
               --                      ,StgTable_tbl(ARCashReceipt_idx).migration_set_id             -- migration_set_id
               --                      ,StgTable_tbl(ARCashReceipt_idx).migration_set_name           -- migration_set_name
               --                      ,'PRE-TRANSFORM'                                              -- transform_status
               --                      ,StgTable_tbl(ARCashReceipt_idx).record_type                  -- record_type
               --                      ,NULL                                                         -- source_operating_unit_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).fusion_business_unit_name    -- fusion_business_unit_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).batch_name                   -- batch_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).item_number                  -- item_number
               --                      ,StgTable_tbl(ARCashReceipt_idx).remittance_amount            -- remittance_amount
               --                      ,StgTable_tbl(ARCashReceipt_idx).transit_routing_number       -- transit_routing_number
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_bank_account        -- customer_bank_account
               --                      ,StgTable_tbl(ARCashReceipt_idx).receipt_number               -- receipt_number
               --                      ,StgTable_tbl(ARCashReceipt_idx).receipt_date                 -- receipt_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).currency_code                -- currency_code
               --                      ,StgTable_tbl(ARCashReceipt_idx).exchange_rate_type           -- exchange_rate_type
               --                      ,StgTable_tbl(ARCashReceipt_idx).exchange_rate                -- exchange_rate
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_number              -- customer_number
               --                      ,StgTable_tbl(ARCashReceipt_idx).bill_to_location             -- bill_to_location
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_bank_branch_name    -- customer_bank_branch_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_bank_name           -- customer_bank_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).receipt_method               -- receipt_method
               --                      ,StgTable_tbl(ARCashReceipt_idx).remittance_bank_branch_name  -- remittance_bank_branch_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).remittance_bank_name         -- remittance_bank_name
               --                      ,StgTable_tbl(ARCashReceipt_idx).lockbox_number               -- lockbox_number
               --                      ,StgTable_tbl(ARCashReceipt_idx).deposit_date                 -- deposit_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).deposit_time                 -- deposit_time
               --                      ,StgTable_tbl(ARCashReceipt_idx).anticipated_clearing_date    -- anticipated_clearing_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice1                     -- invoice1
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice1_installment         -- invoice1_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching1_date               -- matching1_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code1       -- invoice_currency_code1
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate1       -- trans_to_receipt_rate1
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied1              -- amount_applied1
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from1         -- amount_applied_from1
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference1          -- customer_reference1
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice2                     -- invoice2
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice2_installment         -- invoice2_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching2_date               -- matching2_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code2       -- invoice_currency_code2
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate2       -- trans_to_receipt_rate2
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied2              -- amount_applied2
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from2         -- amount_applied_from2
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference2          -- customer_reference2
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice3                     -- invoice3
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice3_installment         -- invoice3_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching3_date               -- matching3_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code3       -- invoice_currency_code3
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate3       -- trans_to_receipt_rate3
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied3              -- amount_applied3
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from3         -- amount_applied_from3
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference3          -- customer_reference3
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice4                     -- invoice4
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice4_installment         -- invoice4_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching4_date               -- matching4_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code4       -- invoice_currency_code4
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate4       -- trans_to_receipt_rate4
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied4              -- amount_applied4
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from4         -- amount_applied_from4
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference4          -- customer_reference4
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice5                     -- invoice5
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice5_installment         -- invoice5_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching5_date               -- matching5_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code5       -- invoice_currency_code5
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate5       -- trans_to_receipt_rate5
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied5              -- amount_applied5
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from5         -- amount_applied_from5
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference5          -- customer_reference5
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice6                     -- invoice6
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice6_installment         -- invoice6_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching6_date               -- matching6_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code6       -- invoice_currency_code6
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate6       -- trans_to_receipt_rate6
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied6              -- amount_applied6
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from6         -- amount_applied_from6
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference6          -- customer_reference6
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice7                     -- invoice7
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice7_installment         -- invoice7_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching7_date               -- matching7_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code7       -- invoice_currency_code7
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate7       -- trans_to_receipt_rate7
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied7              -- amount_applied7
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from7         -- amount_applied_from7
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference7          -- customer_reference7
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice8                     -- invoice8
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice8_installment         -- invoice8_installment
               --                      ,StgTable_tbl(ARCashReceipt_idx).matching8_date               -- matching8_date
               --                      ,StgTable_tbl(ARCashReceipt_idx).invoice_currency_code8       -- invoice_currency_code8
               --                      ,StgTable_tbl(ARCashReceipt_idx).trans_to_receipt_rate8       -- trans_to_receipt_rate8
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied8              -- amount_applied8
               --                      ,StgTable_tbl(ARCashReceipt_idx).amount_applied_from8         -- amount_applied_from8
               --                      ,StgTable_tbl(ARCashReceipt_idx).customer_reference8          -- customer_reference8
               --                      ,StgTable_tbl(ARCashReceipt_idx).comments                     -- comments
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute1                   -- attribute1
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute2                   -- attribute2
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute3                   -- attribute3
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute4                   -- attribute4
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute5                   -- attribute5
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute6                   -- attribute6
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute7                   -- attribute7
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute8                   -- attribute8
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute9                   -- attribute9
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute10                  -- attribute10
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute11                  -- attribute11
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute12                  -- attribute12
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute13                  -- attribute13
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute14                  -- attribute14
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute15                  -- attribute15
               --                      ,StgTable_tbl(ARCashReceipt_idx).attribute_category           -- attribute_category
               --                      );
               --          --
               --     --** END FORALL
               --     --
               --END LOOP; --** StgTable_cur BULK COLLECT LOOP
               ----
               --gvv_ProgressIndicator := '0110';
               ----
               --CLOSE StgTable_cur;
               ----
               --/*
               --** Obtain the count of rows inserted.
               --*/
               ----
               --gvv_ProgressIndicator := '0120';
               ----
               --gvn_RowCount := xxmx_utilities_pkg.get_row_count
               --                     (
               --                      gct_XfmSchema
               --                     ,ct_Rt6XfmTable
               --                     ,pt_i_MigrationSetID
               --                     );
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '    - '
               --                                ||gvn_RowCount
               --                                ||' rows copied from the "'
               --                                ||ct_StgTable
               --                                ||'" to the "'
               --                                ||ct_Rt6XfmTable
               --                                ||'" table.'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               /*
               ** Verify that required simple transformations and/or data enrichments have been defined.
               */
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Verifying simple transforms and/or data enrichment that need to be applied to "'
                                               ||pt_i_SubEntity
                                               ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_ProgressIndicator := '0130';
               --
               /*
               ** Verify Source Operating Unit to Fusion Business Unit transformations exist.
               **
               ** These transforms should apply to ALL Financials Transactions
               ** with Operating Unit in their data therefor the transformations
               ** are not defined for a specific Application.
               */
               --
               FOR   SourceOperatingUnit_rec
               IN    SourceOperatingUnits_cur
                          (
                           pt_i_MigrationSetID
                          )
               LOOP
                    --
                    gvb_MissingSetup := FALSE;
                    --
                    /*
                    ** First verify that the Source Operating Unit in the XFM table exists
                    ** in the XXMX_SOURCE_OPERATING_UNITS table.
                    **
                    ** If it doesn't exists, further processing cannot be performed.
                    **
                    ** If it exists, retrieve the Fusion details required for Simple Transformation
                    ** and Data Enrichment then check that thay are populated.  If any are missing
                    ** we will still update the XFM table with the details that are populated for
                    ** the Operating Unit and issue error messages for missing data elements.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - Verifying transformation and/or data enrichment '
                                                    ||'data elements for Source Operating Unit "'
                                                    ||SourceOperatingUnit_rec.source_operating_unit_name
                                                    ||'".'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    /*
                    ** Source Operating Unit to Fusion Business Unit transformation has
                    ** a Maximise Utilities Package procedure to retrieve Fusion Business
                    ** Unit values.  Fusion Business Unit ID is not required at this time
                    ** for Cash Receipts Data Migration but it it still returned by the 
                    ** procedure call so we must accommodate it.
                    */
                    --
                    xxmx_utilities_pkg.get_fusion_business_unit
                         (
                          pt_i_SourceOperatingUnitName => SourceOperatingUnit_rec.source_operating_unit_name
                         ,pt_o_FusionBusinessUnitName  => vt_FusionBusinessUnitName
                         ,pt_o_FusionBusinessUnitID    => vt_FusionBusinessUnitID
                         ,pv_o_ReturnStatus            => gvv_ReturnStatus
                         ,pt_o_ReturnMessage           => gvt_ReturnMessage
                         );
                    --
                    IF   gvv_ReturnStatus <> 'S'
                    THEN
                         --
                         gvb_MissingSetup := TRUE;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gct_BusinessEntity
                              ,pt_i_SubEntity           => pt_i_SubEntity
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'ERROR'
                              ,pt_i_PackageName         => gct_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '      - '
                                                         ||gvt_ReturnMessage
                              ,pt_i_OracleError         => NULL
                              );
                         --
                    ELSE
                         --
                         xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gct_BusinessEntity
                             ,pt_i_SubEntity           => pt_i_SubEntity
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'NOTIFICATION'
                             ,pt_i_PackageName         => gct_PackageName
                             ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => '      - FUSION_BUSINESS_UNIT_NAME is populated for '
                                                        ||'Source Operating Unit "'
                                                        ||SourceOperatingUnit_rec.source_operating_unit_name
                                                        ||'" in the XXMX_SOURCE_OPERATING_UNITS table.'
                             ,pt_i_OracleError         => NULL
                             );
                        --
                    END IF;
                    --
                    /*
                    ** There is no procedure to retrieve LOCKBOX_NUMBER for Source Operating Unit
                    ** at this time as it is only required for the Cash Receipts Data Migration
                    ** so we retrieve it directly from the table.
                    */
                    --
                    BEGIN
                         --
                         SELECT  lockbox_number
                         INTO    vt_FusionLockboxNumber
                         FROM    xxmx_source_operating_units
                         WHERE   1 = 1
                         AND     source_operating_unit_name = SourceOperatingUnit_rec.source_operating_unit_name
                         AND     migration_enabled_flag     = 'Y';
                         --
                         IF   vt_FusionLockboxNumber IS NULL
                         THEN
                              --
                              gvb_MissingSetup := TRUE;
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                                   ,pt_i_Application         => gct_Application
                                   ,pt_i_BusinessEntity      => gct_BusinessEntity
                                   ,pt_i_SubEntity           => pt_i_SubEntity
                                   ,pt_i_Phase               => ct_Phase
                                   ,pt_i_Severity            => 'ERROR'
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '      - LOCKBOX_NUMBER is not populated for '
                                                              ||'Source Operating Unit "'
                                                              ||SourceOperatingUnit_rec.source_operating_unit_name
                                                              ||'" in the XXMX_SOURCE_OPERATING_UNITS table.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                                   ,pt_i_Application         => gct_Application
                                   ,pt_i_BusinessEntity      => gct_BusinessEntity
                                   ,pt_i_SubEntity           => pt_i_SubEntity
                                   ,pt_i_Phase               => ct_Phase
                                   ,pt_i_Severity            => 'ERROR'
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '      - LOCKBOX_NUMBER is populated for '
                                                              ||'Source Operating Unit "'
                                                              ||SourceOperatingUnit_rec.source_operating_unit_name
                                                              ||'" in the XXMX_SOURCE_OPERATING_UNITS table.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF;
                         --
                    END; --** END Source Operating Unit Details block
                    --
                    IF   gvb_MissingSetup
                    THEN
                         --
                         UPDATE  xxmx_ar_cash_rcpts_rt6_xfm
                         SET     transform_status = 'TRANSFORMATION_OR_DATA_ENRICHMENT_FAILED'
                         WHERE   1 = 1
                         AND     migration_set_id           = pt_i_MigrationSetID
                         AND     source_operating_unit_name = SourceOperatingUnit_rec.source_operating_unit_name;
                         --
                    ELSE
                         --
                         UPDATE  xxmx_ar_cash_rcpts_rt6_xfm
                         SET     fusion_business_unit_name = vt_FusionBusinessUnitName
                                ,lockbox_number            = vt_FusionLockboxNumber
                                ,transform_status          = 'TRANSFORMED'
                         WHERE  1 = 1
                         AND    migration_set_id           = pt_i_MigrationSetID
                         AND    source_operating_unit_name = SourceOperatingUnit_rec.source_operating_unit_name;
                         --
                    END IF;
                    --
               END LOOP; --** END SourceOperatingUnits_cur LOOP
               --
               /*
               ** Generate Lockbox Header and Trailer record for all Source Operating Units
               ** where transformations and data enrichment have been successfully performed.
               */
               --
               /*
               ** Delete previous Lockbox Header records.
               */
               --
               gvv_ProgressIndicator := '0310';
               --
               DELETE
               FROM   xxmx_ar_cash_rcpts_rt5_xfm
               WHERE  1 = 1
               AND    migration_set_id = pt_i_MigrationSetID;
               --
               /*
               ** Delete previous Lockbox Trailer records.
               */
               --
               gvv_ProgressIndicator := '0310';
               --
               DELETE
               FROM   xxmx_ar_cash_rcpts_rt8_xfm
               WHERE  1 = 1
               AND    migration_set_id = pt_i_MigrationSetID;
               --
               /*
               ** Insert new Lockbox Header and Trailer records.
               */
               --
               gvv_ProgressIndicator := '0310';
               --
               --FOR  LockboxHeaderGen_rec
               --IN   LockboxHeadersGen_cur
               --          (
               --           pt_i_MigrationSetID
               --          )
               --LOOP
               --     --
               --     INSERT
               --     INTO   xxmx_ar_cash_rcpts_rt5_xfm
               --                 (
               --                  migration_set_id
               --                 ,migration_set_name
               --                 ,transform_status
               --                 ,record_type
               --                 ,record_seq
               --                 ,source_operating_unit_name
               --                 ,fusion_business_unit_name
               --                 ,currency_code
               --                 ,receipt_method
               --                 ,lockbox_number
               --                 ,deposit_date
               --                 ,deposit_time
               --                 ,lockbox_batch_count
               --                 ,lockbox_record_count
               --                 ,lockbox_amount
               --                 ,destination_bank_account
               --                 ,bank_origination_number
               --                 ,attribute1
               --                 ,attribute2
               --                 ,attribute3
               --                 ,attribute4
               --                 ,attribute5
               --                 ,attribute6
               --                 ,attribute7
               --                 ,attribute8
               --                 ,attribute9
               --                 ,attribute10
               --                 ,attribute11
               --                 ,attribute12
               --                 ,attribute13
               --                 ,attribute14
               --                 ,attribute15
               --                 )
               --     VALUES
               --                 (
               --                  LockboxHeaderGen_rec.migration_set_id            -- migration_set_id
               --                 ,LockboxHeaderGen_rec.migration_set_name          -- migration_set_name
               --                 ,LockboxHeaderGen_rec.transform_status            -- transform_status
               --                 ,5                                                -- record_type
               --                 ,LockboxHeaderGen_rec.header_trailer_seq          -- record_seq
               --                 ,LockboxHeaderGen_rec.source_operating_unit_name  -- source_operating_unit_name
               --                 ,LockboxHeaderGen_rec.fusion_business_unit_name   -- fusion_business_unit_name
               --                 ,NULL                                             -- currency_code
               --                 ,NULL                                             -- receipt_method
               --                 ,LockboxHeaderGen_rec.lockbox_number              -- lockbox_number
               --                 ,NULL                                             -- deposit_date
               --                 ,NULL                                             -- deposit_time
               --                 ,NULL                                             -- lockbox_batch_count
               --                 ,LockboxHeaderGen_rec.lockbox_record_count        -- lockbox_record_count
               --                 ,LockboxHeaderGen_rec.lockbox_amount              -- lockbox_amount
               --                 ,NULL                                             -- destination_bank_account
               --                 ,gct_DfltBankOriginationNum                       -- bank_origination_number  -- SMBC issue
               --                 ,NULL                                             -- attribute1
               --                 ,NULL                                             -- attribute2
               --                 ,NULL                                             -- attribute3
               --                 ,NULL                                             -- attribute4
               --                 ,NULL                                             -- attribute5
               --                 ,NULL                                             -- attribute6
               --                 ,NULL                                             -- attribute7
               --                 ,NULL                                             -- attribute8
               --                 ,NULL                                             -- attribute9
               --                 ,NULL                                             -- attribute10
               --                 ,NULL                                             -- attribute11
               --                 ,NULL                                             -- attribute12
               --                 ,NULL                                             -- attribute13
               --                 ,NULL                                             -- attribute14
               --                 ,NULL                                             -- attribute15
               --                 );
               --     --
               --     INSERT
               --     INTO   xxmx_ar_cash_rcpts_rt8_xfm
               --                 (
               --                  migration_set_id
               --                 ,migration_set_name
               --                 ,transform_status
               --                 ,record_type
               --                 ,record_seq
               --                 ,source_operating_unit_name
               --                 ,fusion_business_unit_name
               --                 ,currency_code
               --                 ,receipt_method
               --                 ,lockbox_number
               --                 ,deposit_date
               --                 ,deposit_time
               --                 ,lockbox_batch_count
               --                 ,lockbox_record_count
               --                 ,lockbox_amount
               --                 ,destination_bank_account
               --                 ,bank_origination_number
               --                 ,attribute1
               --                 ,attribute2
               --                 ,attribute3
               --                 ,attribute4
               --                 ,attribute5
               --                 ,attribute6
               --                 ,attribute7
               --                 ,attribute8
               --                 ,attribute9
               --                 ,attribute10
               --                 ,attribute11
               --                 ,attribute12
               --                 ,attribute13
               --                 ,attribute14
               --                 ,attribute15
               --                 )
               --     VALUES
               --                 (
               --                  LockboxHeaderGen_rec.migration_set_id            -- migration_set_id
               --                 ,LockboxHeaderGen_rec.migration_set_name          -- migration_set_name
               --                 ,LockboxHeaderGen_rec.transform_status            -- transform_status
               --                 ,8                                                -- record_type
               --                 ,LockboxHeaderGen_rec.header_trailer_seq          -- record_seq
               --                 ,LockboxHeaderGen_rec.source_operating_unit_name  -- source_operating_unit_name
               --                 ,LockboxHeaderGen_rec.fusion_business_unit_name   -- fusion_business_unit_name
               --                 ,NULL                                             -- currency_code
               --                 ,NULL                                               -- receipt_method
               --                 ,LockboxHeaderGen_rec.lockbox_number              -- lockbox_number
               --                 ,NULL                                             -- deposit_date
               --                 ,NULL                                             -- deposit_time
               --                 ,NULL                                             -- lockbox_batch_count
               --                 ,LockboxHeaderGen_rec.lockbox_record_count        -- lockbox_record_count
               --                 ,LockboxHeaderGen_rec.lockbox_amount              -- lockbox_amount
               --                 ,NULL                                             -- destination_bank_account
               --                 ,gct_DfltBankOriginationNum                       -- bank_origination_number  -- SMBC issue
               --                 ,NULL                                             -- attribute1
               --                 ,NULL                                             -- attribute2
               --                 ,NULL                                             -- attribute3
               --                 ,NULL                                             -- attribute4
               --                 ,NULL                                             -- attribute5
               --                 ,NULL                                             -- attribute6
               --                 ,NULL                                             -- attribute7
               --                 ,NULL                                             -- attribute8
               --                 ,NULL                                             -- attribute9
               --                 ,NULL                                             -- attribute10
               --                 ,NULL                                             -- attribute11
               --                 ,NULL                                             -- attribute12
               --                 ,NULL                                             -- attribute13
               --                 ,NULL                                             -- attribute14
               --                 ,NULL                                             -- attribute15
               --                 );
               --     --
               --END LOOP; --** END LockboxHeadersGen_cur LOOP
               --
               gvv_ProgressIndicator := '-0080';
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '-0090';
               --
               /*
               ** Obtain the counts of rows inserted for Lockbox Header/Trailer records.
               */
               --
               --vn_Rt5Rowcount := xxmx_utilities_pkg.get_row_count
               --                       (
               --                        gct_XfmSchema
               --                       ,ct_Rt5XfmTable
               --                       ,pt_i_MigrationSetID
               --                       );
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '    - '
               --                                ||vn_Rt5Rowcount
               --                                ||'Lockbox Header records generated and inserted into the "'
               --                                ||ct_Rt5XfmTable
               --                                ||'" table.'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               --vn_Rt8Rowcount := xxmx_utilities_pkg.get_row_count
               --                       (
               --                        gct_XfmSchema
               --                       ,ct_Rt8XfmTable
               --                       ,pt_i_MigrationSetID
               --                       );
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => pt_i_SubEntity
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '    - '
               --                                ||vn_Rt8Rowcount
               --                                ||'Lockbox Trailer records generated and inserted into the "'
               --                                ||ct_Rt8XfmTable
               --                                ||'" table.'
               --     ,pt_i_OracleError         => NULL
               --     );
               ----
               /*
               ** Count the number of records in the XXMX_AR_CASH_RCPTS_RT6_XFM table
               ** that are ready to be inserted into the XXMX_AR_CASH_RECEIPTS_OUT
               ** table.
               **
               ** These will only be the successfully transformed records, so we need
               ** to call the overloaded GET_ROW_COUNT function that allows us to
               ** specify opto 5 optional join conditions.
               */
               --
               vn_Rt6Rowcount := xxmx_utilities_pkg.get_row_count
                                      (
                                       gct_XfmSchema
                                      ,ct_Rt6XfmTable
                                      ,pt_i_MigrationSetID
                                      ,'AND transform_status = ''TRANSFORMED'''
                                      ,NULL
                                      ,NULL
                                      ,NULL
                                      ,NULL
                                      );
               --
               /*
               ** Write a log message for the total number of records we expect to be
               ** inserted into the XXMX_AR_CASH_RECEIPTS_OUT table.
               */
               --
               --vn_TotalExpectedRowcount := vn_Rt5Rowcount +
               --                            vn_Rt6Rowcount +
               --                            vn_Rt8Rowcount;
               vn_TotalExpectedRowcount := vn_Rt6Rowcount;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '    - Expected number of rows to be inserted into the "'
                                               ||ct_OutXfmTable
                                               ||'" table = '
                                               ||vn_TotalExpectedRowcount
                    ,pt_i_OracleError         => NULL
                    );
               --
               /*
               ** Now populate the XXMX_AR_CASH_RECEIPTS_OUT table with the records
               ** from the three XFM tables.
               **
               ** The XXMX_AR_CASH_RECEIPTS_OUT is the table used to generate the
               ** data file to be uploaded into Fusion Cloud.
               **
               ** The records are copied from the XFM tables in the following order:
               **
               **      1) xxmx_ar_cash_rcpts_rt5_xfm
               **      2) xxmx_ar_cash_rcpts_rt6_xfm
               **      3) xxmx_ar_cash_rcpts_rt8_xfm
               **
               ** As they are inserted into the XXMX_AR_CASH_RECEIPTS_OUT table, they
               ** are given a new record sequence number across all record types, so
               ** the ordering of rows as they are retrieved from the above tables is
               ** important and handled by the cursor.
               */
               --
               DELETE 
               FROM   xxmx_ar_cash_receipts_out
               WHERE  migration_set_id = pt_i_MigrationSetID;
               --
               --
               OPEN  RecordConsolidation_cur
                          (
                           pt_i_MigrationSetID
                          );
               --
               gvv_ProgressIndicator := '-0060';
               --
               LOOP
                    --
                    FETCH        RecordConsolidation_cur
                    BULK COLLECT
                    INTO         OutTable_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN OutTable_tbl.count = 0;
                    --
                    gvv_ProgressIndicator := '-0070';
                    --
                    FORALL OutTable_idx
                    IN     1..OutTable_tbl.count
                         --
                         INSERT
                         INTO    xxmx_ar_cash_receipts_out
                                  (
                                   migration_set_id  
                                  ,migration_set_name
                                  ,transmission_name
                                  ,lockbox_number               
                                  ,record_seq        
                                  ,column_1          
                                  ,column_2          
                                  ,column_3          
                                  ,column_4          
                                  ,column_5          
                                  ,column_6          
                                  ,column_7          
                                  ,column_8          
                                  ,column_9          
                                  ,column_10         
                                  ,column_11         
                                  ,column_12         
                                  ,column_13         
                                  ,column_14         
                                  ,column_15         
                                  ,column_16         
                                  ,column_17         
                                  ,column_18         
                                  ,column_19         
                                  ,column_20         
                                  ,column_21         
                                  ,column_22         
                                  ,column_23         
                                  ,column_24         
                                  ,column_25         
                                  ,column_26         
                                  ,column_27         
                                  ,column_28         
                                  ,column_29         
                                  ,column_30         
                                  ,column_31         
                                  ,column_32         
                                  ,column_33         
                                  ,column_34         
                                  ,column_35         
                                  ,column_36         
                                  ,column_37         
                                  ,column_38         
                                  ,column_39         
                                  ,column_40         
                                  ,column_41         
                                  ,column_42         
                                  ,column_43         
                                  ,column_44         
                                  ,column_45         
                                  ,column_46         
                                  ,column_47         
                                  ,column_48         
                                  ,column_49         
                                  ,column_50         
                                  ,column_51         
                                  ,column_52         
                                  ,column_53         
                                  ,column_54         
                                  ,column_55         
                                  ,column_56         
                                  ,column_57         
                                  ,column_58         
                                  ,column_59         
                                  ,column_60         
                                  ,column_61         
                                  ,column_62         
                                  ,column_63         
                                  ,column_64         
                                  ,column_65         
                                  ,column_66         
                                  ,column_67         
                                  ,column_68         
                                  ,column_69         
                                  ,column_70         
                                  ,column_71         
                                  ,column_72         
                                  ,column_73         
                                  ,column_74         
                                  ,column_75         
                                  ,column_76         
                                  ,column_77         
                                  ,column_78         
                                  ,column_79         
                                  ,column_80         
                                  ,column_81         
                                  ,column_82         
                                  ,column_83         
                                  ,column_84         
                                  ,column_85         
                                  ,column_86         
                                  ,column_87         
                                  ,column_88         
                                  ,column_89         
                                  ,column_90         
                                  ,column_91         
                                  ,column_92         
                                  ,column_93         
                                  ,column_94         
                                  ,column_95         
                                  ,column_96         
                                  ,column_97         
                                  ,column_98         
                                  ,column_99         
                                  ,column_100        
                                  ,column_101        
                                  ,column_102        
                                  ,column_103        
                                  ,column_104        
                                  )
                         VALUES
                                  (
                                   OutTable_tbl(OutTable_idx).migration_set_id    -- migration_set_id  
                                  ,OutTable_tbl(OutTable_idx).migration_set_name  -- migration_set_name
                                  ,NULL                                           -- transmission_name
                                  ,OutTable_tbl(OutTable_idx).lockbox_number      -- lockbox number                                                                 
                                  ,OutTable_tbl(OutTable_idx).out_rec_seq         -- record_seq        
                                  ,OutTable_tbl(OutTable_idx).column_1            -- column_1          
                                  ,OutTable_tbl(OutTable_idx).column_2            -- column_2          
                                  ,OutTable_tbl(OutTable_idx).column_3            -- column_3          
                                  ,OutTable_tbl(OutTable_idx).column_4            -- column_4          
                                  ,OutTable_tbl(OutTable_idx).column_5            -- column_5          
                                  ,OutTable_tbl(OutTable_idx).column_6            -- column_6          
                                  ,OutTable_tbl(OutTable_idx).column_7            -- column_7          
                                  ,OutTable_tbl(OutTable_idx).column_8            -- column_8          
                                  ,OutTable_tbl(OutTable_idx).column_9            -- column_9          
                                  ,OutTable_tbl(OutTable_idx).column_10           -- column_10         
                                  ,OutTable_tbl(OutTable_idx).column_11           -- column_11         
                                  ,OutTable_tbl(OutTable_idx).column_12           -- column_12         
                                  ,OutTable_tbl(OutTable_idx).column_13           -- column_13         
                                  ,OutTable_tbl(OutTable_idx).column_14           -- column_14         
                                  ,OutTable_tbl(OutTable_idx).column_15           -- column_15         
                                  ,OutTable_tbl(OutTable_idx).column_16           -- column_16         
                                  ,OutTable_tbl(OutTable_idx).column_17           -- column_17         
                                  ,OutTable_tbl(OutTable_idx).column_18           -- column_18         
                                  ,OutTable_tbl(OutTable_idx).column_19           -- column_19         
                                  ,OutTable_tbl(OutTable_idx).column_20           -- column_20         
                                  ,OutTable_tbl(OutTable_idx).column_21           -- column_21         
                                  ,OutTable_tbl(OutTable_idx).column_22           -- column_22         
                                  ,OutTable_tbl(OutTable_idx).column_23           -- column_23         
                                  ,OutTable_tbl(OutTable_idx).column_24           -- column_24         
                                  ,OutTable_tbl(OutTable_idx).column_25           -- column_25         
                                  ,OutTable_tbl(OutTable_idx).column_26           -- column_26         
                                  ,OutTable_tbl(OutTable_idx).column_27           -- column_27         
                                  ,OutTable_tbl(OutTable_idx).column_28           -- column_28         
                                  ,OutTable_tbl(OutTable_idx).column_29           -- column_29         
                                  ,OutTable_tbl(OutTable_idx).column_30           -- column_30         
                                  ,OutTable_tbl(OutTable_idx).column_31           -- column_31         
                                  ,OutTable_tbl(OutTable_idx).column_32           -- column_32         
                                  ,OutTable_tbl(OutTable_idx).column_33           -- column_33         
                                  ,OutTable_tbl(OutTable_idx).column_34           -- column_34         
                                  ,OutTable_tbl(OutTable_idx).column_35           -- column_35         
                                  ,OutTable_tbl(OutTable_idx).column_36           -- column_36         
                                  ,OutTable_tbl(OutTable_idx).column_37           -- column_37         
                                  ,OutTable_tbl(OutTable_idx).column_38           -- column_38         
                                  ,OutTable_tbl(OutTable_idx).column_39           -- column_39         
                                  ,OutTable_tbl(OutTable_idx).column_40           -- column_40         
                                  ,OutTable_tbl(OutTable_idx).column_41           -- column_41         
                                  ,OutTable_tbl(OutTable_idx).column_42           -- column_42         
                                  ,OutTable_tbl(OutTable_idx).column_43           -- column_43         
                                  ,OutTable_tbl(OutTable_idx).column_44           -- column_44         
                                  ,OutTable_tbl(OutTable_idx).column_45           -- column_45         
                                  ,OutTable_tbl(OutTable_idx).column_46           -- column_46         
                                  ,OutTable_tbl(OutTable_idx).column_47           -- column_47         
                                  ,OutTable_tbl(OutTable_idx).column_48           -- column_48         
                                  ,OutTable_tbl(OutTable_idx).column_49           -- column_49         
                                  ,OutTable_tbl(OutTable_idx).column_50           -- column_50         
                                  ,OutTable_tbl(OutTable_idx).column_51           -- column_51         
                                  ,OutTable_tbl(OutTable_idx).column_52           -- column_52         
                                  ,OutTable_tbl(OutTable_idx).column_53           -- column_53         
                                  ,OutTable_tbl(OutTable_idx).column_54           -- column_54         
                                  ,OutTable_tbl(OutTable_idx).column_55           -- column_55         
                                  ,OutTable_tbl(OutTable_idx).column_56           -- column_56         
                                  ,OutTable_tbl(OutTable_idx).column_57           -- column_57         
                                  ,OutTable_tbl(OutTable_idx).column_58           -- column_58         
                                  ,OutTable_tbl(OutTable_idx).column_59           -- column_59         
                                  ,OutTable_tbl(OutTable_idx).column_60           -- column_60         
                                  ,OutTable_tbl(OutTable_idx).column_61           -- column_61         
                                  ,OutTable_tbl(OutTable_idx).column_62           -- column_62         
                                  ,OutTable_tbl(OutTable_idx).column_63           -- column_63         
                                  ,OutTable_tbl(OutTable_idx).column_64           -- column_64         
                                  ,OutTable_tbl(OutTable_idx).column_65           -- column_65         
                                  ,OutTable_tbl(OutTable_idx).column_66           -- column_66         
                                  ,OutTable_tbl(OutTable_idx).column_67           -- column_67         
                                  ,OutTable_tbl(OutTable_idx).column_68           -- column_68         
                                  ,OutTable_tbl(OutTable_idx).column_69           -- column_69         
                                  ,OutTable_tbl(OutTable_idx).column_70           -- column_70         
                                  ,OutTable_tbl(OutTable_idx).column_71           -- column_71         
                                  ,OutTable_tbl(OutTable_idx).column_72           -- column_72         
                                  ,OutTable_tbl(OutTable_idx).column_73           -- column_73         
                                  ,OutTable_tbl(OutTable_idx).column_74           -- column_74         
                                  ,OutTable_tbl(OutTable_idx).column_75           -- column_75         
                                  ,OutTable_tbl(OutTable_idx).column_76           -- column_76         
                                  ,OutTable_tbl(OutTable_idx).column_77           -- column_77         
                                  ,OutTable_tbl(OutTable_idx).column_78           -- column_78         
                                  ,OutTable_tbl(OutTable_idx).column_79           -- column_79         
                                  ,OutTable_tbl(OutTable_idx).column_80           -- column_80         
                                  ,OutTable_tbl(OutTable_idx).column_81           -- column_81         
                                  ,OutTable_tbl(OutTable_idx).column_82           -- column_82         
                                  ,OutTable_tbl(OutTable_idx).column_83           -- column_83         
                                  ,OutTable_tbl(OutTable_idx).column_84           -- column_84         
                                  ,OutTable_tbl(OutTable_idx).column_85           -- column_85         
                                  ,OutTable_tbl(OutTable_idx).column_86           -- column_86         
                                  ,OutTable_tbl(OutTable_idx).column_87           -- column_87         
                                  ,OutTable_tbl(OutTable_idx).column_88           -- column_88         
                                  ,OutTable_tbl(OutTable_idx).column_89           -- column_89         
                                  ,OutTable_tbl(OutTable_idx).column_90           -- column_90         
                                  ,OutTable_tbl(OutTable_idx).column_91           -- column_91         
                                  ,OutTable_tbl(OutTable_idx).column_92           -- column_92         
                                  ,OutTable_tbl(OutTable_idx).column_93           -- column_93         
                                  ,OutTable_tbl(OutTable_idx).column_94           -- column_94         
                                  ,OutTable_tbl(OutTable_idx).column_95           -- column_95         
                                  ,OutTable_tbl(OutTable_idx).column_96           -- column_96         
                                  ,OutTable_tbl(OutTable_idx).column_97           -- column_97         
                                  ,OutTable_tbl(OutTable_idx).column_98           -- column_98         
                                  ,OutTable_tbl(OutTable_idx).column_99           -- column_99         
                                  ,OutTable_tbl(OutTable_idx).column_100          -- column_100        
                                  ,OutTable_tbl(OutTable_idx).column_101          -- column_101        
                                  ,OutTable_tbl(OutTable_idx).column_102          -- column_102        
                                  ,OutTable_tbl(OutTable_idx).column_103          -- column_103        
                                  ,OutTable_tbl(OutTable_idx).column_104          -- column_104        
                                  );        
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '-0080';
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '-0090';
               --
               CLOSE RecordConsolidation_cur;
               --
               /*
               ** Obtain the count of rows inserted.
               */
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_XfmSchema
                                    ,ct_OutXfmTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '    - '
                                               ||gvn_RowCount
                                               ||' rows inserted into the "'
                                               ||ct_OutXfmTable
                                               ||'" ('
                                               ||vn_TotalExpectedRowcount
                                               ||' expected).'
                    ,pt_i_OracleError         => NULL
                    );
               --
               /*
               ** Generate a Transmission Name based on Lockbox Number
               ** and update the xxmx_ar_cash_receipts_out with it.
               **
               ** The Transmission Name includes a timestamp which must
               ** be the same for every record in the out table so we
               ** do not simply generate it from SYSDATE during insert.
               */
               --
               vv_TransmissionTimestamp := xxmx_utilities_pkg.date_and_time_stamp
                                                (
                                                 pv_i_IncludeSeconds => 'N'
                                                );
               --
               UPDATE  xxmx_ar_cash_receipts_out
               SET     transmission_name = 'MXDM_'
                                         ||lockbox_number
                                         ||'_'
                                         ||LTRIM(RTRIM(vv_TransmissionTimestamp))
               WHERE   1 = 1
               AND     migration_set_id = pt_i_MigrationSetID;
               --
               /*
               ** Commit the updates and inserts for the XFM tables.
               */
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0210';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Simple Transformation and Data Enrichment processing completed.'
                    ,pt_i_OracleError         => NULL
                         );
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase end if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0290';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => ct_Rt6XfmTable
                    ,pt_i_TransformStartDate      => vd_TransformStartDate
                    ,pt_i_TransformCompletionDate => SYSDATE
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Transformation Table "'
                                             ||ct_Rt6XfmTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          ELSE
               --
               gvv_ProgressIndicator := '0330';
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_MigrationSetID", "pt_i_SubEntity" and "pt_i_SimpleXfmPerformedBy" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0340';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    IF   StgTable_cur%ISOPEN
                    THEN
                         --
                         CLOSE StgTable_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    IF   StgTable_cur%ISOPEN
                    THEN
                         --
                         CLOSE StgTable_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END ar_cash_receipts_xfm;
     --
     --
     --**********************
     --** PROCEDURE: stg_main
     --**********************
     --
     PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR StagingMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT  xmm.sub_entity_seq
                      ,xmm.sub_entity
                      ,xmm.entity_package_name
                      ,xmm.stg_procedure_name
                      ,xmm.stg_table
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
          --** END CURSOR StagingMetadata_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE  := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" parameter is mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Clear AR Receipts Module Messages
          */
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gct_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          /*
          ** Initialize the Migration Set for the Business Entity retrieving
          ** a new Migration Set ID.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_MigrationSetName  => pt_i_MigrationSetName
               ,pt_o_MigrationSetID    => vt_MigrationSetID
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Migration Set "'
                                            ||pt_i_MigrationSetName
                                            ||'" initialized (Generated Migration Set ID = '
                                            ||vt_MigrationSetID
                                            ||').  Processing extracts:'
               ,pt_i_OracleError         => NULL
               );
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Staging Package Name, Procedure Name and table name
          ** for each extract requied for the current Business Entity.
          */
          --
          gvv_ProgressIndicator := '0050';
          --
          FOR  StagingMetadata_rec
          IN   StagingMetadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Calling Procedure "'
                                                 ||StagingMetadata_rec.entity_package_name
                                                 ||'.'
                                                 ||StagingMetadata_rec.stg_procedure_name
                                                 ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||StagingMetadata_rec.entity_package_name
                                 ||'.'
                                 ||StagingMetadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||'pt_i_MigrationSetID => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity => '''
                                 ||StagingMetadata_rec.sub_entity||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SUBSTR(
                                                        '- Generated SQL Statement: '
                                                      ||gvv_SQLStatement
                                                       ,1
                                                       ,4000
                                                       )
                    ,pt_i_OracleError         => NULL
                    );
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
          END LOOP;
          --
          gvv_ProgressIndicator := '0060';
          --
          --xxmx_utilities_pkg.close_extract_phase
          --     (
          --      vt_MigrationSetID
          --     );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END stg_main;
     --
     --
     --*******************
     --** PROCEDURE: purge
     --*******************
     --
     PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   )
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR PurgingMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               --
               SELECT  xmm.stg_table
                      ,xmm.xfm_table
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
               --
          --** END CURSOR PurgingMetadata_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'CORE';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vv_PurgeTableName               VARCHAR2(30);
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
          --
     --** END Declarations **
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode     IS NULL
          OR   pt_i_MigrationSetID IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
           --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               gvt_Severity      := 'ERROR';
               --
               gvt_ModuleMessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Purging tables.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the staging table names to purge for the current Business
          ** Entity.
          */
          --
          gvv_SQLAction := 'DELETE';
          --
          gvv_SQLWhereClause := 'WHERE 1 = 1 '
                              ||'AND   migration_set_id = '
                              ||pt_i_MigrationSetID;
          --
          FOR  PurgingMetadata_rec
          IN   PurgingMetadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
          LOOP
               --
               gvv_SQLTableClause := 'FROM '
                                   ||gct_StgSchema
                                   ||'.'
                                   ||PurgingMetadata_rec.stg_table;
               --
               gvv_SQLStatement := gvv_SQLAction
                                 ||gcv_SQLSpace
                                 ||gvv_SQLTableClause
                                 ||gcv_SQLSpace
                                 ||gvv_SQLWhereClause;
               --
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Records purged from "'
                                               ||PurgingMetadata_rec.stg_table
                                               ||'" table: '
                                               ||gvn_RowCount
                    ,pt_i_OracleError         => NULL
                    );
               --
               --gvv_SQLTableClause := 'FROM '
               --                    ||vt_ClientSchemaName
               --                    ||'.'
               --                    ||PurgingMetadata_rec.xfm_table;
               ----
               --gvv_SQLStatement := gvv_SQLAction
               --                  ||gcv_SQLSpace
               --                  ||gvv_SQLTableClause
               --                  ||gcv_SQLSpace
               --                  ||gvv_SQLWhereClause;
               ----
               --EXECUTE IMMEDIATE gvv_SQLStatement;
               ----
               --gvn_RowCount := SQL%ROWCOUNT;
               ----
               --xxmx_utilities_pkg.log_module_message
               --     (
               --      pt_i_ApplicationSuite    => gct_ApplicationSuite
               --     ,pt_i_Application         => gct_Application
               --     ,pt_i_BusinessEntity      => gct_BusinessEntity
               --     ,pt_i_SubEntity           => ct_SubEntity
               --     ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               --     ,pt_i_Phase               => ct_Phase
               --     ,pt_i_Severity            => 'NOTIFICATION'
               --     ,pt_i_PackageName         => gct_PackageName
               --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage       => '  - Records purged from "'
               --                                ||PurgingMetadata_rec.xfm_table
               --                                ||'" table: '
               --                                ||gvn_RowCount
               --     ,pt_i_OracleError         => NULL
               --     );
               --
          END LOOP;
          --
          /*
          ** Purge the records for the Business Entity Levels
          ** Levels from the Migration Details table.
          */
          --
          vv_PurgeTableName := 'xxmx_migration_details';
          --
          --
          --** DSF 26/10/2020 - Replace with new constant for Core Schema.
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '  - Records purged from "'
                                          ||vv_PurgeTableName
                                          ||'" table: '
                                          ||gvn_RowCount
               ,pt_i_OracleError         => NULL
               );
          --
          /*
          ** Purge the records for the Business Entity
          ** from the Migration Headers table.
          */
          --
          --** DSF 261/10/2020 - Replace with new constant for Core Schema.
          --
          vv_PurgeTableName := 'xxmx_migration_headers';
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '  - Records purged from "'
                                          ||vv_PurgeTableName
                                          ||'" table: '
                                          ||gvn_RowCount
               ,pt_i_OracleError         => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Purging complete.'
               ,pt_i_OracleError         => NULL
               );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                            ||'** ERROR_BACKTRACE: '
                                            ||dbms_utility.format_error_backtrace
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END purge;
     --
END xxmx_ar_cash_receipts_pkg;
/

SHOW ERRORS PACKAGE BODY xxmx_ar_cash_receipts_pkg;
/
