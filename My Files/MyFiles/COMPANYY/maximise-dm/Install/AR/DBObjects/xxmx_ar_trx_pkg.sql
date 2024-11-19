--------------------------------------------------------
--  File created - Wednesday-September-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package XXMX_AR_TRX_PKG
--------------------------------------------------------

  CREATE OR REPLACE  PACKAGE "XXMX_AR_TRX_PKG" 
AS
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2020 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_ar_trx_pkg.sql
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
     ** PURPOSE   :  This script installs the package for the Maximise AR Transactions
     **              Data Migration.
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
     ** 1.    Run the installation script to create all necessary database objects
     **       and Concurrent definitions:
     **
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_xfm_dbi.sql
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
     **   1.0  09-JUL-2020  Ian S. Vickerstaff  Created for Maximise.
     **
     **   1.1  17-NOV-2020  David Fuller        Change parameter lists and logging
     **                                         Add LEDGER_NAME to DIST extract
     **
     **   1.2  30-NOV-2020  David Fuller        SUBSTRB instead of SUBSTR on extract
     **                                         NULL most fles fields.
     **
     **   1.3  23-FEB-2021  Ian S. Vickerstaff  Corrections to STG and XFM tables
     **                                         for mapping to FDBI template.
     **                                         Added XFM procedures incorporating
     **                                         incorporated default Revenue
     **                                         Account determination.
     **
     **   1.4  04-APR-2021  Ian S. Vickerstaff  Removed HZ_PARTIES table and
     **                                         associated joins from all extract
     **                                         cursors as none of them SELECTed
     **                                         from this table.
     **
     **                                         Also removed a join in the Lines
     **                                         extract cursor:
     **
     **                                         AND rctla.interface_line_context
     **                                             = rcta.interface_header_context
     **
     **                                         As this was causing lines to be
     **                                         omitted for which distributions
     **                                         had already been extracted.
     **
     **   1.5  13-APR-2021  Dave Higham         Amended to remove '-' from address ref
     **                                         in lines_stg cursor
     **
     **   1.6  15-APR-2021  Dave Higham         Amended interface_line_attribute2 to be
     **                                         rcta.customer_trx_id instead of
     **                                         rcta.txn_number.
     **
     **   1.7  15-APR-2021  Dave Higham         Amended to add SHIP_TO, BILL_TO, SOLD_TO
     **                                         details in LINES record.
     **
     **   1.8  15-APR-2021  Dave Higham         Corrected column references in LINES cursor
     **
     **   1.9  29-APR-2021  Ian S. Vickerstaff  Changed the GL Account detmination for Distributions
     **                                         from a default Fusion Account to a transformation
     **                                         of the original EBS GL Account to a mapped Fusion GL
     **                                         Account.
     **
     **                                         Also, changed the XFM procedures to calculate the
     **                                         open balances for lines and distributions based
     **                                         on apportionment of the total Transaction Open
     **                                         Balance.
     **     
     **   1.10 30-APR-2021  Dave Higham         CUST_ACCT_SITE_ORIG_SYS and PARTY_SITE_ORIG_SYS
     **
     **   1.11 04-May-2021  Ian S. Vickerstaff  Added XXMX_ORIG_TRX_LINE_AMOUNT column to the
     **                                         XXMX_AR_TRX_LINES_XFM table and XXMX_ORIG_AMOUNT
     **                                         to the XXMX_AR_TRX_DISTS_XFM table.
     **
     **                                         XXMX_ORIG_TRX_LINE_AMOUNT is used in the calculation
     **                                         of a pro-rated open balance for a distribution.
     **
     **                                         XXMX_ORIG_AMOUNT is not currently used in any calculations
     **                                         but has been included for recording the original
     **                                         distribution amount for verififcation purposes.
     **
     **   1.12 12-May-2021  Ian S. Vickerstaff  Added XXMX_CUSTOMER_TRX_ID and XXMX_CUSTOMER_TRX_LINE_ID
     **                                         columns to the XXMX_AR_TRX_LINES_STG, XXMX_AR_TRX_LINES_XFM
     **                                         XXMX_AR_TRX_SALESCREDITS_STG and XXMX_AR_TRX_SALESCREDITS_XFM
     **                                         tables.
     **
     **                                         Also added the above columns plus the XXMX_CUST_TRX_LINE_GL_DIST_ID
     **                                         column to the XXMX_AR_TRX_DISTS_STG and XXMX_AR_TRX_DISTS_XFM
     **                                         tables.
     **
     **                                         These columns are required to join the STG and XFM tables
     **                                         back to the XXMX_AR_TRX_SCOPE_V view when calculating open
     **                                         balances for Lines and Distributions.
     **
     **   1.13 16-Jun-2021  Ian S. Vickerstaff  Added XXMX_ORIG_SC_AMOUNT_SPLIT to the XXMX_AR_TRX_SALESCREDITS_XFM
     **                                         table.  This new column will be set to the same value in the
     **                                         SALES_CREDIT_AMOUNT_SPLIT column when the data is transferred from
     **                                         the STG to the XFM table.
     **
     **                                         Sales Credits need to also be updated to reflect the new calculated
     **                                         open balances for the lines they relate to.
     **                                 
     **   1.13 16-Jun-2021  Ian S. Vickerstaff  Added XXMX_ORIG_SC_AMOUNT_SPLIT to the XXMX_AR_TRX_SALESCREDITS_XFM
     **                                         table.
     **
     **   1.13 08-Jul-2021  Ian S. Vickerstaff  Added XXMX_ORIG_UNIT_SELLING_PRICE to the XXMX_AR_TRX_LINES_XFM
     **                                         table and additional code to calculate a new Unit Selling Price based
     **                                         on the updated Line Value.  This is because Fusion seems to use
     **                                         QUANTITY * UNIT_SELLING_PRICE to calculate the Line amount and not
     **                                         the value in TRX_LINE_AMOUNT.
     **
     **   1.13 14-Jul-2021  Ian S. Vickerstaff  Header comments updated.
     **
     **   1.14 14-Jul-2021  Ian S. Vickerstaff  Updated the sub-query for retrieving the Salesrep Number for the
     **                                         PRIMARY_SALESREP_ID on the Trx Lines.  In only three Invoice
     **                                         examples, the Salesrep record had a NULL status which meant the
     **                                         Salesrep Number was not successfully retrieved for those Invoices
     **                                         as they were omitted by the "AND rsa.status = 'A'" WHERE clause
     **                                         predicate.  This has been changed to use the END_DATE_ACTIVE column
     **                                         instead.
     **
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
     ******************************
     ** PROCEDURE: ar_trx_lines_stg
     ******************************
     */
     --
     PROCEDURE ar_trx_lines_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ******************************
     ** PROCEDURE: ar_trx_lines_xfm
     ******************************
     */
     --
     PROCEDURE ar_trx_lines_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
     --
     --
     /*
     ******************************
     ** PROCEDURE: ar_trx_dists_stg
     ******************************
     */
     --
     PROCEDURE ar_trx_dists_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ******************************
     ** PROCEDURE: ar_trx_dists_xfm
     ******************************
     */
     --
     PROCEDURE ar_trx_dists_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
     --
     --
     /*
     *************************************
     ** PROCEDURE: ar_trx_salescredits_stg
     *************************************
     */
    PROCEDURE ar_trx_salescredits_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     *************************************
     ** PROCEDURE: ar_trx_salescredits_xfm
     *************************************
     */
     --
     PROCEDURE ar_trx_salescredits_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
     --
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
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
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --
     PROCEDURE purge
                   (
                 pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
     --
     --
END xxmx_ar_trx_pkg;
/


  CREATE OR REPLACE  PACKAGE BODY "XXMX_AR_TRX_PKG" 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ar_trx_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'TRANSACTIONS';
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
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
     gvb_SimpleTransformsRequired              BOOLEAN;
     gvt_TransformCategoryCode                 xxmx_simple_transforms.category_code%TYPE;
     gvb_MissingSimpleTransforms               BOOLEAN;
     gvb_DataEnrichmentRequired                BOOLEAN;
     gvt_ParameterCode                         xxmx_migration_parameters.parameter_code%TYPE;
     gvv_ParameterCheckResult                  VARCHAR2(10);
     gvb_MissingDataEnrichment                 BOOLEAN;
     gvb_ComplexTransformsRequired             BOOLEAN;
     gvb_PerformComplexTransforms              BOOLEAN;
     --
     --
     /*
     ******************************
     ** PROCEDURE: ar_trx_lines_stg
     ******************************
     */
     --
     PROCEDURE ar_trx_lines_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        )
     IS
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the detail ra_invoices_lines
          --
          CURSOR ARTrxLines_cur
          IS
               --
               SELECT    ROWNUM                                                               AS row_seq
                        ,rcta.customer_trx_id                                                 AS xxmx_customer_trx_id     
                        ,rctla.customer_trx_line_id                                           AS xxmx_customer_trx_line_id
                        ,rctla.line_number                                                    AS xxmx_line_number
                        ,haou.name                                                            AS operating_unit
                        ,'Data Migration'                                                     AS batch_source_name
                        ,xatsv.trx_type_name                                                  AS cust_trx_type_name
                        ,rtt.name                                                             AS term_name
                        ,rcta.trx_date                                                        AS trx_date
                        ,SYSDATE                                                              AS gl_date
                        ,rcta.trx_number                                                      AS trx_number
                        ,hca.account_number                                                   AS orig_system_bill_customer_ref
                        ,(
                          SELECT  --hps.party_id||'-'||hps.party_site_number
                                  --hcasa.cust_account_id||hcasa.party_site_id
                                  hcasa.cust_account_id||'-'||hcasa.cust_acct_site_id
                          FROM    --apps.hz_party_sites@MXDM_NVIS_EXTRACT          hps
                                  apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   hcsua
                                 ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT  hcasa
                          WHERE   1 = 1
                          AND     hcsua.site_use_code     = 'BILL_TO'
                          AND     hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
                          AND     hcsua.site_use_id       = rcta.bill_to_site_use_id
                          --AND     hps.party_site_id       = hcasa.party_site_id
                         )                                                                    AS orig_system_bill_address_ref
                        ,(
                          SELECT  hoc.org_contact_id 
                          FROM    apps.hz_org_contacts@MXDM_NVIS_EXTRACT hoc
                                 ,apps.hz_cust_account_roles@MXDM_NVIS_EXTRACT hcar
                                 ,apps.hz_relationships@MXDM_NVIS_EXTRACT hr 
                          WHERE   1 = 1
                          AND     hcar.cust_account_role_id = rcta.bill_to_contact_id
                          AND     hr.party_id = hcar.party_id
                          AND     hr.subject_Table_name = 'HZ_PARTIES' 
                          AND     hr.object_table_name = 'HZ_PARTIES' 
                          AND     hr.directional_flag = 'F'
                          AND     hoc.party_relationship_id   =  hr.relationship_id
                         )                                                                    AS orig_system_bill_contact_ref                         
                        ,(
                          SELECT party_id 
                          FROM   apps.hz_cust_accounts_all@MXDM_NVIS_EXTRACT 
                          WHERE  1 = 1
                          AND    cust_account_id = rcta.ship_to_customer_id
                         )                                                                    AS orig_sys_ship_party_ref      
                        ,(
                          SELECT  hps.party_id||'-'||hps.party_site_number --hcasa.cust_account_id||hcasa.party_site_id
                          FROM    apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                                       ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT    hcsua
                                 ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcasa
                          WHERE   1 = 1
                          AND     hcsua.site_use_code     = 'SHIP_TO'
                          AND     hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
                          AND     hcsua.site_use_id       = rcta.bill_to_site_use_id
                          AND     hps.party_site_id       = hcasa.party_site_id                            
                         )                                                                    AS orig_sys_ship_party_site_ref 
                        ,(
                          SELECT  hoc.org_contact_id 
                          FROM    apps.hz_org_contacts@MXDM_NVIS_EXTRACT        hoc
                                 ,apps.hz_cust_account_roles@MXDM_NVIS_EXTRACT  hcar
                                 ,apps.hz_relationships@MXDM_NVIS_EXTRACT       hr 
                          WHERE   1 = 1
                          AND     hcar.cust_account_role_id = rcta.sold_to_contact_id
                          AND     hr.party_id = hcar.party_id
                          AND     hr.subject_Table_name = 'HZ_PARTIES' 
                          AND     hr.object_table_name = 'HZ_PARTIES' 
                          AND     hr.directional_flag = 'F'
                          AND     hoc.party_relationship_id   =  hr.relationship_id
                         )                                                                    AS orig_sys_ship_pty_contact_ref                       
                        ,(
                          SELECT account_number 
                          FROM   apps.hz_cust_accounts_all@MXDM_NVIS_EXTRACT 
                          WHERE  1 = 1
                          AND    cust_account_id = rcta.ship_to_customer_id
                         )                                                                    AS orig_system_ship_customer_ref
                        ,(
                          SELECT  hps.party_id||'-'||hps.party_site_number --hcasa.cust_account_id||hcasa.party_site_id
                          FROM    apps.hz_party_sites@MXDM_NVIS_EXTRACT          hps
                                 ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT   hcsua
                                 ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT  hcasa
                          WHERE   1 = 1
                          AND     hcsua.site_use_code     = 'SHIP_TO'
                          AND     hcsua.cust_acct_site_id = hcasa.cust_acct_site_id
                          AND     hcsua.site_use_id       = rcta.bill_to_site_use_id
                          AND     hps.party_site_id       = hcasa.party_site_id                            
                         )                                                                    AS orig_system_ship_address_ref 
                        ,(
                          SELECT  hoc.org_contact_id 
                          FROM    apps.hz_org_contacts@MXDM_NVIS_EXTRACT        hoc
                                 ,apps.hz_cust_account_roles@MXDM_NVIS_EXTRACT  hcar
                                 ,apps.hz_relationships@MXDM_NVIS_EXTRACT hr 
                          WHERE   1 = 1
                          AND     hcar.cust_account_role_id = rcta.ship_to_contact_id
                          AND     hr.party_id = hcar.party_id
                          AND     hr.subject_Table_name = 'HZ_PARTIES' 
                          AND     hr.object_table_name = 'HZ_PARTIES' 
                          AND     hr.directional_flag = 'F'
                          AND     hoc.party_relationship_id   =  hr.relationship_id
                         )                                                                    AS orig_system_ship_contact_ref 
                        ,(
                                SELECT party_id 
                          FROM apps.hz_cust_accounts_all@MXDM_NVIS_EXTRACT 
                          WHERE cust_account_id = rcta.sold_to_customer_id
                         )                                                                    AS orig_sys_sold_party_ref      
                        ,(
                          SELECT account_number 
                          FROM apps.hz_cust_accounts_all@MXDM_NVIS_EXTRACT 
                          WHERE cust_account_id = rcta.sold_to_customer_id
                         )                                                                    AS orig_sys_sold_customer_ref
                        ,NULL                                                                 AS bill_customer_account_number
                        ,NULL                                                                 AS bill_customer_site_number
                        ,NULL                                                                 AS bill_contact_party_number
                        ,NULL                                                                 AS ship_customer_account_number
                        ,NULL                                                                 AS ship_customer_site_number
                        ,NULL                                                                 AS ship_contact_party_number
                        ,NULL                                                                 AS sold_customer_account_number
                        ,rctla.line_type                                                      AS line_type
                        ,xxmx_utilities_pkg.convert_string
                               (
                                pv_i_StringToConvert     => rctla.description
                               ,pv_i_ConvertCommaToSpace => 'N'
                               ,pi_i_SubstrStartPos      => 1
                               ,pi_i_SubstrLength        => 240
                               ,pv_i_UseBinarySubstr     => 'Y'
                               )                                                              AS description
                        ,rcta.invoice_currency_code                                           AS currency_code
                        ,'Corporate'                                                          AS conversion_type
                        ,rcta.exchange_date                                                   AS conversion_date
                        ,ROUND(NVL(rcta.exchange_rate, 1) ,2)                                 AS conversion_rate
                        --,ROUND(rctla.extended_amount, 2)+
                        --      (
                        --       SELECT SUM(extended_amount)
                        --       FROM   apps.ra_customer_trx_lines_all@MXDM_NVIS_EXTRACT
                        --       WHERE  1 = 1
                        --       AND    link_to_cust_trx_line_id = rctla.customer_trx_line_id
                        --      )                                                               AS trx_line_amount
                        ,rctla.extended_amount                                                AS trx_line_amount            -- will be updated post-extract
                        ,rctla.quantity_invoiced                                              AS quantity
                        ,rctla.quantity_ordered                                               AS quantity_ordered
                        ,ROUND(rctla.unit_selling_price, 2)                                   AS unit_selling_price
                        ,rctla.unit_standard_price                                            AS unit_standard_price
                        ,'AR_GENERIC'                                                         AS interface_line_context
                        ,hca.account_number                                                   AS interface_line_attribute1
                        ,rcta.trx_number                                                      AS interface_line_attribute2
                        ,rctla.line_number                                                    AS interface_line_attribute3
                        ,NULL                                                                 AS interface_line_attribute4
                        ,NULL                                                                 AS interface_line_attribute5
                        ,NULL                                                                 AS interface_line_attribute6
                        ,NULL                                                                 AS interface_line_attribute7
                        ,NULL                                                                 AS interface_line_attribute8
                        ,NULL                                                                 AS interface_line_attribute9
                        ,NULL                                                                 AS interface_line_attribute10
                        ,NULL                                                                 AS interface_line_attribute11
                        ,NULL                                                                 AS interface_line_attribute12
                        ,NULL                                                                 AS interface_line_attribute13
                        ,NULL                                                                 AS interface_line_attribute14
                        ,NULL                                                                 AS interface_line_attribute15
                        ,(
                          SELECT rsa.salesrep_number
                          FROM   apps.ra_salesreps_all@MXDM_NVIS_EXTRACT rsa
                          WHERE  1 = 1
                          AND    rsa.org_id                            = rcta.org_id
                          AND    rsa.salesrep_id                       = rcta.primary_salesrep_id
                          AND    NVL(rsa.end_date_active, SYSDATE + 1) > SYSDATE
                         )                                                                    AS primary_salesrep_number
                        ,rctla.tax_classification_code                                        AS tax_classification_code
                        ,NULL                                                                 AS legal_entity_identifier
                        ,NULL                                                                 AS acct_amount_in_ledger_currency
                        ,NULL                                                                 AS sales_order_number
                        ,NULL                                                                 AS sales_order_date
                        ,NULL                                                                 AS actual_ship_date
                        ,NULL                                                                 AS warehouse_code
                        ,NULL                                                                 AS unit_of_measure_code
                        ,NULL                                                                 AS unit_of_measure_name
                        ,NULL                                                                 AS invoicing_rule_name
                        ,NULL                                                                 AS revenue_scheduling_rule_name
                        ,NULL                                                                 AS number_of_revenue_periods
                        ,NULL                                                                 AS rev_sched_rule_start_date
                        ,NULL                                                                 AS rev_sched_rule_end_date
                        ,NULL                                                                 AS reason_code_meaning
                        ,NULL                                                                 AS last_period_to_credit
                        ,NULL                                                                 AS trx_business_category_code
                        ,NULL                                                                 AS product_fiscal_class_code
                        ,NULL                                                                 AS product_category_code
                        ,NULL                                                                 AS product_type
                        ,NULL                                                                 AS line_intended_use_code
                        ,NULL                                                                 AS assessable_value
                        ,NULL                                                                 AS document_sub_type
                        ,NULL                                                                 AS default_taxation_country
                        ,NULL                                                                 AS user_defined_fiscal_class
                        ,NULL                                                                 AS tax_invoice_number
                        ,NULL                                                                 AS tax_invoice_date
                        ,NULL                                                                 AS tax_regime_code
                        ,NULL                                                                 AS tax
                        ,NULL                                                                 AS tax_status_code
                        ,NULL                                                                 AS tax_rate_code
                        ,NULL                                                                 AS tax_jurisdiction_code
                        ,NULL                                                                 AS first_party_reg_number
                        ,NULL                                                                 AS third_party_reg_number
                        ,NULL                                                                 AS final_discharge_location
                        ,rctla.taxable_amount                                                 AS taxable_amount
                        ,rctla.taxable_flag                                                   AS taxable_flag
                        ,rctla.tax_exempt_flag                                                AS tax_exempt_flag
                        ,rctla.tax_exempt_reason_code                                         AS tax_exempt_reason_code
                        ,NULL                                                                 AS tax_exempt_reason_code_meaning
                        ,NULL                                                                 AS tax_exempt_certificate_number
                        ,rctla.amount_includes_tax_flag                                       AS line_amount_includes_tax_flag
                        ,rctla.tax_precedence                                                 AS tax_precedence
                        ,NULL                                                                 AS credit_method_for_acct_rule
                        ,NULL                                                                 AS credit_method_for_installments
                        ,rctla.reason_code                                                    AS reason_code
                        ,rctla.tax_rate                                                       AS tax_rate
                        ,NULL                                                                 AS fob_point
                        ,NULL                                                                 AS ship_via
                        ,NULL                                                                 AS waybill_number
                        ,NULL                                                                 AS sales_order_line_number
                        ,NULL                                                                 AS sales_order_source
                        ,NULL                                                                 AS sales_order_revision_number
                        ,rcta.purchase_order                                                  AS purchase_order_number
                        ,rcta.purchase_order_revision                                         AS purchase_order_revision_number
                        ,rcta.purchase_order_date                                             AS purchase_order_date
                        ,NULL                                                                 AS agreement_name
                        ,NULL                                                                 AS memo_line_name
                        ,NULL                                                                 AS document_number
                        ,NULL                                                                 AS orig_system_batch_name
                        ,NULL                                                                 AS link_to_line_context
                        ,NULL                                                                 AS link_to_line_attribute1
                        ,NULL                                                                 AS link_to_line_attribute2
                        ,NULL                                                                 AS link_to_line_attribute3
                        ,NULL                                                                 AS link_to_line_attribute4
                        ,NULL                                                                 AS link_to_line_attribute5
                        ,NULL                                                                 AS link_to_line_attribute6
                        ,NULL                                                                 AS link_to_line_attribute7
                        ,NULL                                                                 AS link_to_line_attribute8
                        ,NULL                                                                 AS link_to_line_attribute9
                        ,NULL                                                                 AS link_to_line_attribute10
                        ,NULL                                                                 AS link_to_line_attribute11
                        ,NULL                                                                 AS link_to_line_attribute12
                        ,NULL                                                                 AS link_to_line_attribute13
                        ,NULL                                                                 AS link_to_line_attribute14
                        ,NULL                                                                 AS link_to_line_attribute15
                        ,NULL                                                                 AS reference_line_context
                        ,NULL                                                                 AS reference_line_attribute1
                        ,NULL                                                                 AS reference_line_attribute2
                        ,NULL                                                                 AS reference_line_attribute3
                        ,NULL                                                                 AS reference_line_attribute4
                        ,NULL                                                                 AS reference_line_attribute5
                        ,NULL                                                                 AS reference_line_attribute6
                        ,NULL                                                                 AS reference_line_attribute7
                        ,NULL                                                                 AS reference_line_attribute8
                        ,NULL                                                                 AS reference_line_attribute9
                        ,NULL                                                                 AS reference_line_attribute10
                        ,NULL                                                                 AS reference_line_attribute11
                        ,NULL                                                                 AS reference_line_attribute12
                        ,NULL                                                                 AS reference_line_attribute13
                        ,NULL                                                                 AS reference_line_attribute14
                        ,NULL                                                                 AS reference_line_attribute15
                        ,NULL                                                                 AS link_to_parentline_context
                        ,NULL                                                                 AS link_to_parentline_attribute1
                        ,NULL                                                                 AS link_to_parentline_attribute2
                        ,NULL                                                                 AS link_to_parentline_attribute3
                        ,NULL                                                                 AS link_to_parentline_attribute4
                        ,NULL                                                                 AS link_to_parentline_attribute5
                        ,NULL                                                                 AS link_to_parentline_attribute6
                        ,NULL                                                                 AS link_to_parentline_attribute7
                        ,NULL                                                                 AS link_to_parentline_attribute8
                        ,NULL                                                                 AS link_to_parentline_attribute9
                        ,NULL                                                                 AS link_to_parentline_attribute10
                        ,NULL                                                                 AS link_to_parentline_attribute11
                        ,NULL                                                                 AS link_to_parentline_attribute12
                        ,NULL                                                                 AS link_to_parentline_attribute13
                        ,NULL                                                                 AS link_to_parentline_attribute14
                        ,NULL                                                                 AS link_to_parentline_attribute15
                        ,arm.name                                                             AS receipt_method_name
                        ,'N'                                                                  AS printing_option
                        ,NULL                                                                 AS related_batch_source_name
                        ,NULL                                                                 AS related_transaction_number
                        ,NULL                                                                 AS inventory_item_number
                        ,NULL                                                                 AS inventory_item_segment2
                        ,NULL                                                                 AS inventory_item_segment3
                        ,NULL                                                                 AS inventory_item_segment4
                        ,NULL                                                                 AS inventory_item_segment5
                        ,NULL                                                                 AS inventory_item_segment6
                        ,NULL                                                                 AS inventory_item_segment7
                        ,NULL                                                                 AS inventory_item_segment8
                        ,NULL                                                                 AS inventory_item_segment9
                        ,NULL                                                                 AS inventory_item_segment10
                        ,NULL                                                                 AS inventory_item_segment11
                        ,NULL                                                                 AS inventory_item_segment12
                        ,NULL                                                                 AS inventory_item_segment13
                        ,NULL                                                                 AS inventory_item_segment14
                        ,NULL                                                                 AS inventory_item_segment15
                        ,NULL                                                                 AS inventory_item_segment16
                        ,NULL                                                                 AS inventory_item_segment17
                        ,NULL                                                                 AS inventory_item_segment18
                        ,NULL                                                                 AS inventory_item_segment19
                        ,NULL                                                                 AS inventory_item_segment20
                        ,NULL                                                                 AS bill_to_cust_bank_acct_name
                        ,NULL                                                                 AS reset_trx_date_flag
                        ,NULL                                                                 AS payment_server_order_number
                        ,NULL                                                                 AS last_trans_on_debit_auth
                        ,NULL                                                                 AS approval_code
                        ,NULL                                                                 AS address_verification_code
                        ,NULL                                                                 AS translated_description
                        ,NULL                                                                 AS consolidated_billing_number
                        ,NULL                                                                 AS promised_commitment_amount
                        ,NULL                                                                 AS payment_set_identifier
                        ,NULL                                                                 AS original_gl_date
                        ,NULL                                                                 AS invoiced_line_accting_level
                        ,NULL                                                                 AS override_auto_accounting_flag
                        ,NULL                                                                 AS historical_flag
                        ,NULL                                                                 AS deferral_exclusion_flag
                        ,NULL                                                                 AS payment_attributes
                        ,NULL                                                                 AS invoice_billing_date
                        ,NULL                                                                 AS attribute_category
                        ,NULL                                                                 AS attribute1
                        ,NULL                                                                 AS attribute2
                        ,NULL                                                                 AS attribute3
                        ,NULL                                                                 AS attribute4
                        ,NULL                                                                 AS attribute5
                        ,NULL                                                                 AS attribute6
                        ,NULL                                                                 AS attribute7
                        ,NULL                                                                 AS attribute8
                        ,NULL                                                                 AS attribute9
                        ,NULL                                                                 AS attribute10
                        ,NULL                                                                 AS attribute11
                        ,NULL                                                                 AS attribute12
                        ,NULL                                                                 AS attribute13
                        ,NULL                                                                 AS attribute14
                        ,NULL                                                                 AS attribute15
                        ,NULL                                                                 AS header_attribute_category
                        ,NULL                                                                 AS header_attribute1
                        ,NULL                                                                 AS header_attribute2
                        ,NULL                                                                 AS header_attribute3
                        ,NULL                                                                 AS header_attribute4
                        ,NULL                                                                 AS header_attribute5
                        ,NULL                                                                 AS header_attribute6
                        ,NULL                                                                 AS header_attribute7
                        ,NULL                                                                 AS header_attribute8
                        ,NULL                                                                 AS header_attribute9
                        ,NULL                                                                 AS header_attribute10
                        ,NULL                                                                 AS header_attribute11
                        ,NULL                                                                 AS header_attribute12
                        ,NULL                                                                 AS header_attribute13
                        ,NULL                                                                 AS header_attribute14
                        ,NULL                                                                 AS header_attribute15
                        ,NULL                                                                 AS header_gdf_attr_category
                        ,NULL                                                                 AS header_gdf_attribute1
                        ,NULL                                                                 AS header_gdf_attribute2
                        ,NULL                                                                 AS header_gdf_attribute3
                        ,NULL                                                                 AS header_gdf_attribute4
                        ,NULL                                                                 AS header_gdf_attribute5
                        ,NULL                                                                 AS header_gdf_attribute6
                        ,NULL                                                                 AS header_gdf_attribute7
                        ,NULL                                                                 AS header_gdf_attribute8
                        ,NULL                                                                 AS header_gdf_attribute9
                        ,NULL                                                                 AS header_gdf_attribute10
                        ,NULL                                                                 AS header_gdf_attribute11
                        ,NULL                                                                 AS header_gdf_attribute12
                        ,NULL                                                                 AS header_gdf_attribute13
                        ,NULL                                                                 AS header_gdf_attribute14
                        ,NULL                                                                 AS header_gdf_attribute15
                        ,NULL                                                                 AS header_gdf_attribute16
                        ,NULL                                                                 AS header_gdf_attribute17
                        ,NULL                                                                 AS header_gdf_attribute18
                        ,NULL                                                                 AS header_gdf_attribute19
                        ,NULL                                                                 AS header_gdf_attribute20
                        ,NULL                                                                 AS header_gdf_attribute21
                        ,NULL                                                                 AS header_gdf_attribute22
                        ,NULL                                                                 AS header_gdf_attribute23
                        ,NULL                                                                 AS header_gdf_attribute24
                        ,NULL                                                                 AS header_gdf_attribute25
                        ,NULL                                                                 AS header_gdf_attribute26
                        ,NULL                                                                 AS header_gdf_attribute27
                        ,NULL                                                                 AS header_gdf_attribute28
                        ,NULL                                                                 AS header_gdf_attribute29
                        ,NULL                                                                 AS header_gdf_attribute30
                        ,NULL                                                                 AS line_gdf_attr_category
                        ,NULL                                                                 AS line_gdf_attribute1
                        ,NULL                                                                 AS line_gdf_attribute2
                        ,NULL                                                                 AS line_gdf_attribute3
                        ,NULL                                                                 AS line_gdf_attribute4
                        ,NULL                                                                 AS line_gdf_attribute5
                        ,NULL                                                                 AS line_gdf_attribute6
                        ,NULL                                                                 AS line_gdf_attribute7
                        ,NULL                                                                 AS line_gdf_attribute8
                        ,NULL                                                                 AS line_gdf_attribute9
                        ,NULL                                                                 AS line_gdf_attribute10
                        ,NULL                                                                 AS line_gdf_attribute11
                        ,NULL                                                                 AS line_gdf_attribute12
                        ,NULL                                                                 AS line_gdf_attribute13
                        ,NULL                                                                 AS line_gdf_attribute14
                        ,NULL                                                                 AS line_gdf_attribute15
                        ,NULL                                                                 AS line_gdf_attribute16
                        ,NULL                                                                 AS line_gdf_attribute17
                        ,NULL                                                                 AS line_gdf_attribute18
                        ,NULL                                                                 AS line_gdf_attribute19
                        ,NULL                                                                 AS line_gdf_attribute20
                        ,xxmx_utilities_pkg.convert_string
                              (
                               pv_i_StringToConvert     => rcta.comments
                              ,pv_i_ConvertCommaToSpace => 'N'
                              ,pi_i_SubstrStartPos      => 1
                              ,pi_i_SubstrLength        => 0   /* 0 turns off the SUBSTR functionality */
                              ,pv_i_UseBinarySubstr     => 'N'
                              )                                                               AS comments
                        ,xxmx_utilities_pkg.convert_string
                              (
                               pv_i_StringToConvert     => rcta.internal_notes
                              ,pv_i_ConvertCommaToSpace => 'N'
                              ,pi_i_SubstrStartPos      => 1
                              ,pi_i_SubstrLength        => 0   /* 0 turns off the SUBSTR functionality */
                              ,pv_i_UseBinarySubstr     => 'N'
                              )                                                               AS internal_notes
                        ,NULL                                                                 AS header_gdf_attribute_number1
                        ,NULL                                                                 AS header_gdf_attribute_number2
                        ,NULL                                                                 AS header_gdf_attribute_number3
                        ,NULL                                                                 AS header_gdf_attribute_number4
                        ,NULL                                                                 AS header_gdf_attribute_number5
                        ,NULL                                                                 AS header_gdf_attribute_number6
                        ,NULL                                                                 AS header_gdf_attribute_number7
                        ,NULL                                                                 AS header_gdf_attribute_number8
                        ,NULL                                                                 AS header_gdf_attribute_number9
                        ,NULL                                                                 AS header_gdf_attribute_number10
                        ,NULL                                                                 AS header_gdf_attribute_number11
                        ,NULL                                                                 AS header_gdf_attribute_number12
                        ,NULL                                                                 AS header_gdf_attribute_date1
                        ,NULL                                                                 AS header_gdf_attribute_date2
                        ,NULL                                                                 AS header_gdf_attribute_date3
                        ,NULL                                                                 AS header_gdf_attribute_date4
                        ,NULL                                                                 AS header_gdf_attribute_date5
                        ,NULL                                                                 AS line_gdf_attribute_number1
                        ,NULL                                                                 AS line_gdf_attribute_number2
                        ,NULL                                                                 AS line_gdf_attribute_number3
                        ,NULL                                                                 AS line_gdf_attribute_number4
                        ,NULL                                                                 AS line_gdf_attribute_number5
                        ,NULL                                                                 AS line_gdf_attribute_date1
                        ,NULL                                                                 AS line_gdf_attribute_date2
                        ,NULL                                                                 AS line_gdf_attribute_date3
                        ,NULL                                                                 AS line_gdf_attribute_date4
                        ,NULL                                                                 AS line_gdf_attribute_date5
                        ,NULL                                                                 AS freight_charge
                        ,NULL                                                                 AS insurance_charge
                        ,NULL                                                                 AS packing_charge
                        ,NULL                                                                 AS miscellaneous_charge
                        ,NULL                                                                 AS commercial_discount
               FROM      apps.ar_receipt_methods@MXDM_NVIS_EXTRACT         arm
                        ,xxmx_ar_trx_scope_v                               xatsv
                        ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT        rcta
                        ,apps.ra_terms_tl@MXDM_NVIS_EXTRACT                rtt
                        ,apps.ra_customer_trx_lines_all@MXDM_NVIS_EXTRACT  rctla
                        ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  haou
                        ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           hca
               WHERE     1 = 1
               AND       rcta.org_id                    = xatsv.org_id                   /* Invoice Headers to Invoice Scope View Joins */
               AND       rcta.customer_trx_id           = xatsv.customer_trx_id          /* Invoice Headers to Invoice Scope View Joins */
               AND       rtt.term_id(+)                 = rcta.term_id                   /* Payment Term to Invoice Headers Join        */
               AND       rctla.org_id                   = rcta.org_id                    /* Invoice Lines to Invoice Headers Joins      */
               AND       rctla.customer_trx_id          = rcta.customer_trx_id           /* Invoice Lines to Invoice Headers Joins      */
               AND       rctla.line_type               <> 'TAX'
               AND       haou.organization_id           = xatsv.org_id                   /* Operating Unit to Invoice Scope View Join   */
               AND       hca.cust_account_id            = rcta.bill_to_customer_id      /* Customer Account to Invoice Header Join     */
               AND       arm.receipt_method_id(+) = rcta.receipt_method_id;               
               --
          --** END CURSOR ARTrxLines_cur
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ARTrxLines_tt IS TABLE OF ARTrxLines_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_lines_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_trx_lines_stg';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
          ARTrxLines_tbl                  ARTrxLines_tt;
          --
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
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
           /*
          ** Delete any MODULE messages from previous executions
          ** for the Business Entity and Business Entity Level
          */
          --
          --** DSF 27/10/2020 - Modified all Utilities Package Procedure/Function Calls to pass new "gct_BusinessEntity" global constant
          --**                  to the "pt_i_BusinessEntity" parameter.
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
          IF   gvv_ReturnStatus = 'F'
          THEN
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
          IF   gvv_ReturnStatus = 'F'
          THEN
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
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
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
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
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
                    ,pt_i_ModuleMessage       => '- Extracting "'
                                                 ||pt_i_SubEntity
                                                 ||'":'
                    ,pt_i_OracleError         => NULL
                    );
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
               gvv_ProgressIndicator := '0050';
               --
               --** Extract into the staging table.
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
               OPEN ARTrxLines_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ARTrxLines_cur
                    BULK COLLECT
                    INTO ARTrxLines_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ARTrxLines_tbl.count=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL ARTrxLines_idx
                    IN     1..ARTrxLines_tbl.COUNT
                          --
                          INSERT
                          INTO   xxmx_ar_trx_lines_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,row_seq                  
                                   ,xxmx_customer_trx_id     
                                   ,xxmx_customer_trx_line_id
                                   ,xxmx_line_number
                                   ,operating_unit
                                   ,batch_source_name
                                   ,cust_trx_type_name
                                   ,term_name
                                   ,trx_date
                                   ,gl_date
                                   ,trx_number
                                   ,orig_system_bill_customer_ref
                                   ,orig_system_bill_address_ref
                                   ,orig_system_bill_contact_ref
                                   ,orig_sys_ship_party_ref
                                   ,orig_sys_ship_party_site_ref
                                   ,orig_sys_ship_pty_contact_ref
                                   ,orig_system_ship_customer_ref
                                   ,orig_system_ship_address_ref
                                   ,orig_system_ship_contact_ref
                                   ,orig_sys_sold_party_ref
                                   ,orig_sys_sold_customer_ref
                                   ,bill_customer_account_number
                                   ,bill_customer_site_number
                                   ,bill_contact_party_number
                                   ,ship_customer_account_number
                                   ,ship_customer_site_number
                                   ,ship_contact_party_number
                                   ,sold_customer_account_number
                                   ,line_type
                                   ,description
                                   ,currency_code
                                   ,conversion_type
                                   ,conversion_date
                                   ,conversion_rate
                                   ,trx_line_amount
                                   ,quantity
                                   ,quantity_ordered
                                   ,unit_selling_price
                                   ,unit_standard_price
                                   ,interface_line_context
                                   ,interface_line_attribute1
                                   ,interface_line_attribute2
                                   ,interface_line_attribute3
                                   ,interface_line_attribute4
                                   ,interface_line_attribute5
                                   ,interface_line_attribute6
                                   ,interface_line_attribute7
                                   ,interface_line_attribute8
                                   ,interface_line_attribute9
                                   ,interface_line_attribute10
                                   ,interface_line_attribute11
                                   ,interface_line_attribute12
                                   ,interface_line_attribute13
                                   ,interface_line_attribute14
                                   ,interface_line_attribute15
                                   ,primary_salesrep_number
                                   ,tax_classification_code
                                   ,legal_entity_identifier
                                   ,acct_amount_in_ledger_currency
                                   ,sales_order_number
                                   ,sales_order_date
                                   ,actual_ship_date
                                   ,warehouse_code
                                   ,unit_of_measure_code
                                   ,unit_of_measure_name
                                   ,invoicing_rule_name
                                   ,revenue_scheduling_rule_name
                                   ,number_of_revenue_periods
                                   ,rev_scheduling_rule_start_date
                                   ,rev_scheduling_rule_end_date
                                   ,reason_code_meaning
                                   ,last_period_to_credit
                                   ,trx_business_category_code
                                   ,product_fiscal_class_code
                                   ,product_category_code
                                   ,product_type
                                   ,line_intended_use_code
                                   ,assessable_value
                                   ,document_sub_type
                                   ,default_taxation_country
                                   ,user_defined_fiscal_class
                                   ,tax_invoice_number
                                   ,tax_invoice_date
                                   ,tax_regime_code
                                   ,tax
                                   ,tax_status_code
                                   ,tax_rate_code
                                   ,tax_jurisdiction_code
                                   ,first_party_reg_number
                                   ,third_party_reg_number
                                   ,final_discharge_location
                                   ,taxable_amount
                                   ,taxable_flag
                                   ,tax_exempt_flag
                                   ,tax_exempt_reason_code
                                   ,tax_exempt_reason_code_meaning
                                   ,tax_exempt_certificate_number
                                   ,line_amount_includes_tax_flag
                                   ,tax_precedence
                                   ,credit_method_for_acct_rule
                                   ,credit_method_for_installments
                                   ,reason_code
                                   ,tax_rate
                                   ,fob_point
                                   ,ship_via
                                   ,waybill_number
                                   ,sales_order_line_number
                                   ,sales_order_source
                                   ,sales_order_revision_number
                                   ,purchase_order_number
                                   ,purchase_order_revision_number
                                   ,purchase_order_date
                                   ,agreement_name
                                   ,memo_line_name
                                   ,document_number
                                   ,orig_system_batch_name
                                   ,link_to_line_context
                                   ,link_to_line_attribute1
                                   ,link_to_line_attribute2
                                   ,link_to_line_attribute3
                                   ,link_to_line_attribute4
                                   ,link_to_line_attribute5
                                   ,link_to_line_attribute6
                                   ,link_to_line_attribute7
                                   ,link_to_line_attribute8
                                   ,link_to_line_attribute9
                                   ,link_to_line_attribute10
                                   ,link_to_line_attribute11
                                   ,link_to_line_attribute12
                                   ,link_to_line_attribute13
                                   ,link_to_line_attribute14
                                   ,link_to_line_attribute15
                                   ,reference_line_context
                                   ,reference_line_attribute1
                                   ,reference_line_attribute2
                                   ,reference_line_attribute3
                                   ,reference_line_attribute4
                                   ,reference_line_attribute5
                                   ,reference_line_attribute6
                                   ,reference_line_attribute7
                                   ,reference_line_attribute8
                                   ,reference_line_attribute9
                                   ,reference_line_attribute10
                                   ,reference_line_attribute11
                                   ,reference_line_attribute12
                                   ,reference_line_attribute13
                                   ,reference_line_attribute14
                                   ,reference_line_attribute15
                                   ,link_to_parentline_context
                                   ,link_to_parentline_attribute1
                                   ,link_to_parentline_attribute2
                                   ,link_to_parentline_attribute3
                                   ,link_to_parentline_attribute4
                                   ,link_to_parentline_attribute5
                                   ,link_to_parentline_attribute6
                                   ,link_to_parentline_attribute7
                                   ,link_to_parentline_attribute8
                                   ,link_to_parentline_attribute9
                                   ,link_to_parentline_attribute10
                                   ,link_to_parentline_attribute11
                                   ,link_to_parentline_attribute12
                                   ,link_to_parentline_attribute13
                                   ,link_to_parentline_attribute14
                                   ,link_to_parentline_attribute15
                                   ,receipt_method_name
                                   ,printing_option
                                   ,related_batch_source_name
                                   ,related_transaction_number
                                   ,inventory_item_number
                                   ,inventory_item_segment2
                                   ,inventory_item_segment3
                                   ,inventory_item_segment4
                                   ,inventory_item_segment5
                                   ,inventory_item_segment6
                                   ,inventory_item_segment7
                                   ,inventory_item_segment8
                                   ,inventory_item_segment9
                                   ,inventory_item_segment10
                                   ,inventory_item_segment11
                                   ,inventory_item_segment12
                                   ,inventory_item_segment13
                                   ,inventory_item_segment14
                                   ,inventory_item_segment15
                                   ,inventory_item_segment16
                                   ,inventory_item_segment17
                                   ,inventory_item_segment18
                                   ,inventory_item_segment19
                                   ,inventory_item_segment20
                                   ,bill_to_cust_bank_acct_name
                                   ,reset_trx_date_flag
                                   ,payment_server_order_number
                                   ,last_trans_on_debit_auth
                                   ,approval_code
                                   ,address_verification_code
                                   ,translated_description
                                   ,consolidated_billing_number
                                   ,promised_commitment_amount
                                   ,payment_set_identifier
                                   ,original_gl_date
                                   ,invoiced_line_accting_level
                                   ,override_auto_accounting_flag
                                   ,historical_flag
                                   ,deferral_exclusion_flag
                                   ,payment_attributes
                                   ,invoice_billing_date
                                   ,attribute_category
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
                                   ,header_attribute_category
                                   ,header_attribute1
                                   ,header_attribute2
                                   ,header_attribute3
                                   ,header_attribute4
                                   ,header_attribute5
                                   ,header_attribute6
                                   ,header_attribute7
                                   ,header_attribute8
                                   ,header_attribute9
                                   ,header_attribute10
                                   ,header_attribute11
                                   ,header_attribute12
                                   ,header_attribute13
                                   ,header_attribute14
                                   ,header_attribute15
                                   ,header_gdf_attr_category
                                   ,header_gdf_attribute1
                                   ,header_gdf_attribute2
                                   ,header_gdf_attribute3
                                   ,header_gdf_attribute4
                                   ,header_gdf_attribute5
                                   ,header_gdf_attribute6
                                   ,header_gdf_attribute7
                                   ,header_gdf_attribute8
                                   ,header_gdf_attribute9
                                   ,header_gdf_attribute10
                                   ,header_gdf_attribute11
                                   ,header_gdf_attribute12
                                   ,header_gdf_attribute13
                                   ,header_gdf_attribute14
                                   ,header_gdf_attribute15
                                   ,header_gdf_attribute16
                                   ,header_gdf_attribute17
                                   ,header_gdf_attribute18
                                   ,header_gdf_attribute19
                                   ,header_gdf_attribute20
                                   ,header_gdf_attribute21
                                   ,header_gdf_attribute22
                                   ,header_gdf_attribute23
                                   ,header_gdf_attribute24
                                   ,header_gdf_attribute25
                                   ,header_gdf_attribute26
                                   ,header_gdf_attribute27
                                   ,header_gdf_attribute28
                                   ,header_gdf_attribute29
                                   ,header_gdf_attribute30
                                   ,line_gdf_attr_category
                                   ,line_gdf_attribute1
                                   ,line_gdf_attribute2
                                   ,line_gdf_attribute3
                                   ,line_gdf_attribute4
                                   ,line_gdf_attribute5
                                   ,line_gdf_attribute6
                                   ,line_gdf_attribute7
                                   ,line_gdf_attribute8
                                   ,line_gdf_attribute9
                                   ,line_gdf_attribute10
                                   ,line_gdf_attribute11
                                   ,line_gdf_attribute12
                                   ,line_gdf_attribute13
                                   ,line_gdf_attribute14
                                   ,line_gdf_attribute15
                                   ,line_gdf_attribute16
                                   ,line_gdf_attribute17
                                   ,line_gdf_attribute18
                                   ,line_gdf_attribute19
                                   ,line_gdf_attribute20
                                   ,comments
                                   ,internal_notes
                                   ,header_gdf_attribute_number1
                                   ,header_gdf_attribute_number2
                                   ,header_gdf_attribute_number3
                                   ,header_gdf_attribute_number4
                                   ,header_gdf_attribute_number5
                                   ,header_gdf_attribute_number6
                                   ,header_gdf_attribute_number7
                                   ,header_gdf_attribute_number8
                                   ,header_gdf_attribute_number9
                                   ,header_gdf_attribute_number10
                                   ,header_gdf_attribute_number11
                                   ,header_gdf_attribute_number12
                                   ,header_gdf_attribute_date1
                                   ,header_gdf_attribute_date2
                                   ,header_gdf_attribute_date3
                                   ,header_gdf_attribute_date4
                                   ,header_gdf_attribute_date5
                                   ,line_gdf_attribute_number1
                                   ,line_gdf_attribute_number2
                                   ,line_gdf_attribute_number3
                                   ,line_gdf_attribute_number4
                                   ,line_gdf_attribute_number5
                                   ,line_gdf_attribute_date1
                                   ,line_gdf_attribute_date2
                                   ,line_gdf_attribute_date3
                                   ,line_gdf_attribute_date4
                                   ,line_gdf_attribute_date5
                                   ,freight_charge
                                   ,insurance_charge
                                   ,packing_charge
                                   ,miscellaneous_charge
                                   ,commercial_discount
                                  )
                          VALUES
                                  (
                                    pt_i_MigrationSetID                                                                    -- migration_set_id
                                   ,gvt_MigrationSetName                                                                   -- migration_set_name
                                   ,'EXTRACTED'                                                                            -- migration_status
                                   ,ARTrxLines_tbl(ARTrxLines_idx).row_seq                                                 -- row_seq                  
                                   ,ARTrxLines_tbl(ARTrxLines_idx).xxmx_customer_trx_id                                    -- xxmx_customer_trx_id     
                                   ,ARTrxLines_tbl(ARTrxLines_idx).xxmx_customer_trx_line_id                               -- xxmx_customer_trx_line_id
                                   ,ARTrxLines_tbl(ARTrxLines_idx).xxmx_line_number                                        -- xxmx_line_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).operating_unit                                          -- operating_unit
                                   ,ARTrxLines_tbl(ARTrxLines_idx).batch_source_name                                       -- batch_source_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).cust_trx_type_name                                      -- cust_trx_type_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).term_name                                               -- term_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).trx_date                                                -- trx_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).gl_date                                                 -- gl_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).trx_number                                              -- trx_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_bill_customer_ref                           -- orig_system_bill_customer_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_bill_address_ref                            -- orig_system_bill_address_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_bill_contact_ref                            -- orig_system_bill_contact_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_sys_ship_party_ref                                 -- orig_sys_ship_party_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_sys_ship_party_site_ref                            -- orig_sys_ship_party_site_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_sys_ship_pty_contact_ref                           -- orig_sys_ship_pty_contact_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_ship_customer_ref                           -- orig_system_ship_customer_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_ship_address_ref                            -- orig_system_ship_address_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_ship_contact_ref                            -- orig_system_ship_contact_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_sys_sold_party_ref                                 -- orig_sys_sold_party_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_sys_sold_customer_ref                              -- orig_sys_sold_customer_ref
                                   ,ARTrxLines_tbl(ARTrxLines_idx).bill_customer_account_number                            -- bill_customer_account_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).bill_customer_site_number                               -- bill_customer_site_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).bill_contact_party_number                               -- bill_contact_party_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).ship_customer_account_number                            -- ship_customer_account_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).ship_customer_site_number                               -- ship_customer_site_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).ship_contact_party_number                               -- ship_contact_party_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sold_customer_account_number                            -- sold_customer_account_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_type                                               -- line_type
                                   ,ARTrxLines_tbl(ARTrxLines_idx).description                                             -- description
                                   ,ARTrxLines_tbl(ARTrxLines_idx).currency_code                                           -- currency_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).conversion_type                                         -- conversion_type
                                   ,ARTrxLines_tbl(ARTrxLines_idx).conversion_date                                         -- conversion_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).conversion_rate                                         -- conversion_rate
                                   ,ARTrxLines_tbl(ARTrxLines_idx).trx_line_amount                                         -- trx_line_amount
                                   ,ARTrxLines_tbl(ARTrxLines_idx).quantity                                                -- quantity
                                   ,ARTrxLines_tbl(ARTrxLines_idx).quantity_ordered                                        -- quantity_ordered
                                   ,CASE
                                         WHEN ARTrxLines_tbl(ARTrxLines_idx).quantity != 0
                                         THEN
                                              ARTrxLines_tbl(ARTrxLines_idx).trx_line_amount/ARTrxLines_tbl(ARTrxLines_idx).quantity
                                         ELSE
                                              ARTrxLines_tbl(ARTrxLines_idx).unit_selling_price
                                    END                                                                                    -- unit_selling_price
                                   ,ARTrxLines_tbl(ARTrxLines_idx).unit_standard_price                                     -- unit_standard_price
                                   ,ARTrxLines_tbl(ARTrxLines_idx).interface_line_context                                  -- interface_line_context
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute1 , 1, 30)              -- interface_line_attribute1
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute2 , 1, 30)              -- interface_line_attribute2
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute3 , 1, 30)              -- interface_line_attribute3
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute4 , 1, 30)              -- interface_line_attribute4
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute5 , 1, 30)              -- interface_line_attribute5
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute6 , 1, 30)              -- interface_line_attribute6
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute7 , 1, 30)              -- interface_line_attribute7
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute8 , 1, 30)              -- interface_line_attribute8
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute9 , 1, 30)              -- interface_line_attribute9
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute10, 1, 30)              -- interface_line_attribute10
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute11, 1, 30)              -- interface_line_attribute11
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute12, 1, 30)              -- interface_line_attribute12
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute13, 1, 30)              -- interface_line_attribute13
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute14, 1, 30)              -- interface_line_attribute14
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).interface_line_attribute15, 1, 30)              -- interface_line_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).primary_salesrep_number                                 -- primary_salesrep_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_classification_code                                 -- tax_classification_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).legal_entity_identifier                                 -- legal_entity_identifier
                                   ,ARTrxLines_tbl(ARTrxLines_idx).acct_amount_in_ledger_currency                          -- acct_amount_in_ledger_currency
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sales_order_number                                      -- sales_order_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sales_order_date                                        -- sales_order_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).actual_ship_date                                        -- actual_ship_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).warehouse_code                                          -- warehouse_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).unit_of_measure_code                                    -- unit_of_measure_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).unit_of_measure_name                                    -- unit_of_measure_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).invoicing_rule_name                                     -- invoicing_rule_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).revenue_scheduling_rule_name                            -- revenue_scheduling_rule_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).number_of_revenue_periods                               -- number_of_revenue_periods
                                   ,ARTrxLines_tbl(ARTrxLines_idx).rev_sched_rule_start_date                               -- rev_scheduling_rule_start_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).rev_sched_rule_end_date                                 -- rev_scheduling_rule_end_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).reason_code_meaning                                     -- reason_code_meaning
                                   ,ARTrxLines_tbl(ARTrxLines_idx).last_period_to_credit                                   -- last_period_to_credit
                                   ,ARTrxLines_tbl(ARTrxLines_idx).trx_business_category_code                              -- trx_business_category_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).product_fiscal_class_code                               -- product_fiscal_class_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).product_category_code                                   -- product_category_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).product_type                                            -- product_type
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_intended_use_code                                  -- line_intended_use_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).assessable_value                                        -- assessable_value
                                   ,ARTrxLines_tbl(ARTrxLines_idx).document_sub_type                                       -- document_sub_type
                                   ,ARTrxLines_tbl(ARTrxLines_idx).default_taxation_country                                -- default_taxation_country
                                   ,ARTrxLines_tbl(ARTrxLines_idx).user_defined_fiscal_class                               -- user_defined_fiscal_class
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_invoice_number                                      -- tax_invoice_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_invoice_date                                        -- tax_invoice_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_regime_code                                         -- tax_regime_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax                                                     -- tax
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_status_code                                         -- tax_status_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_rate_code                                           -- tax_rate_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_jurisdiction_code                                   -- tax_jurisdiction_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).first_party_reg_number                                  -- first_party_reg_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).third_party_reg_number                                  -- third_party_reg_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).final_discharge_location                                -- final_discharge_location
                                   ,ARTrxLines_tbl(ARTrxLines_idx).taxable_amount                                          -- taxable_amount
                                   ,ARTrxLines_tbl(ARTrxLines_idx).taxable_flag                                            -- taxable_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_exempt_flag                                         -- tax_exempt_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_exempt_reason_code                                  -- tax_exempt_reason_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_exempt_reason_code_meaning                          -- tax_exempt_reason_code_meaning
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_exempt_certificate_number                           -- tax_exempt_certificate_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_amount_includes_tax_flag                           -- line_amount_includes_tax_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_precedence                                          -- tax_precedence
                                   ,ARTrxLines_tbl(ARTrxLines_idx).credit_method_for_acct_rule                             -- credit_method_for_acct_rule
                                   ,ARTrxLines_tbl(ARTrxLines_idx).credit_method_for_installments                          -- credit_method_for_installments
                                   ,ARTrxLines_tbl(ARTrxLines_idx).reason_code                                             -- reason_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).tax_rate                                                -- tax_rate
                                   ,ARTrxLines_tbl(ARTrxLines_idx).fob_point                                               -- fob_point
                                   ,ARTrxLines_tbl(ARTrxLines_idx).ship_via                                                -- ship_via
                                   ,ARTrxLines_tbl(ARTrxLines_idx).waybill_number                                          -- waybill_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sales_order_line_number                                 -- sales_order_line_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sales_order_source                                      -- sales_order_source
                                   ,ARTrxLines_tbl(ARTrxLines_idx).sales_order_revision_number                             -- sales_order_revision_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).purchase_order_number                                   -- purchase_order_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).purchase_order_revision_number                          -- purchase_order_revision_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).purchase_order_date                                     -- purchase_order_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).agreement_name                                          -- agreement_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).memo_line_name                                          -- memo_line_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).document_number                                         -- document_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).orig_system_batch_name                                  -- orig_system_batch_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).link_to_line_context                                    -- link_to_line_context
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute1 , 1, 29)                -- link_to_line_attribute1
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute2 , 1, 29)                -- link_to_line_attribute2
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute3 , 1, 30)                -- link_to_line_attribute3
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute4 , 1, 29)                -- link_to_line_attribute4
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute5 , 1, 29)                -- link_to_line_attribute5
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute6 , 1, 29)                -- link_to_line_attribute6
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute7 , 1, 29)                -- link_to_line_attribute7
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute8 , 1, 29)                -- link_to_line_attribute8
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute9 , 1, 29)                -- link_to_line_attribute9
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute10, 1, 29)                -- link_to_line_attribute10
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute11, 1, 29)                -- link_to_line_attribute11
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute12, 1, 29)                -- link_to_line_attribute12
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute13, 1, 29)                -- link_to_line_attribute13
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute14, 1, 29)                -- link_to_line_attribute14
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_line_attribute15, 1, 29)                -- link_to_line_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).reference_line_context                                  -- reference_line_context
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute1 , 1, 30)              -- reference_line_attribute1
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute2 , 1, 30)              -- reference_line_attribute2
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute3 , 1, 30)              -- reference_line_attribute3
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute4 , 1, 30)              -- reference_line_attribute4
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute5 , 1, 30)              -- reference_line_attribute5
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute6 , 1, 30)              -- reference_line_attribute6
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute7 , 1, 30)              -- reference_line_attribute7
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute8 , 1, 30)              -- reference_line_attribute8
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute9 , 1, 30)              -- reference_line_attribute9
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute10, 1, 30)              -- reference_line_attribute10
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute11, 1, 30)              -- reference_line_attribute11
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute12, 1, 30)              -- reference_line_attribute12
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute13, 1, 30)              -- reference_line_attribute13
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute14, 1, 30)              -- reference_line_attribute14
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).reference_line_attribute15, 1, 30)              -- reference_line_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_context                              -- link_to_parentline_context
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute1 , 1, 30)          -- link_to_parentline_attribute1
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute2 , 1, 30)          -- link_to_parentline_attribute2
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute3 , 1, 30)          -- link_to_parentline_attribute3
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute4 , 1, 30)          -- link_to_parentline_attribute4
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute5 , 1, 30)          -- link_to_parentline_attribute5
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute6 , 1, 30)          -- link_to_parentline_attribute6
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute7 , 1, 30)          -- link_to_parentline_attribute7
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute8 , 1, 30)          -- link_to_parentline_attribute8
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute9 , 1, 30)          -- link_to_parentline_attribute9
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute10, 1, 30)          -- link_to_parentline_attribute10
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute11, 1, 30)          -- link_to_parentline_attribute11
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute12, 1, 30)          -- link_to_parentline_attribute12
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute13, 1, 30)          -- link_to_parentline_attribute13
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute14, 1, 30)          -- link_to_parentline_attribute14
                                   ,SUBSTRB(ARTrxLines_tbl(ARTrxLines_idx).link_to_parentline_attribute15, 1, 30)          -- link_to_parentline_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).receipt_method_name                                     -- receipt_method_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).printing_option                                         -- printing_option
                                   ,ARTrxLines_tbl(ARTrxLines_idx).related_batch_source_name                               -- related_batch_source_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).related_transaction_number                              -- related_transaction_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_number                                   -- inventory_item_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment2                                 -- inventory_item_segment2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment3                                 -- inventory_item_segment3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment4                                 -- inventory_item_segment4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment5                                 -- inventory_item_segment5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment6                                 -- inventory_item_segment6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment7                                 -- inventory_item_segment7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment8                                 -- inventory_item_segment8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment9                                 -- inventory_item_segment9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment10                                -- inventory_item_segment10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment11                                -- inventory_item_segment11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment12                                -- inventory_item_segment12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment13                                -- inventory_item_segment13
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment14                                -- inventory_item_segment14
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment15                                -- inventory_item_segment15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment16                                -- inventory_item_segment16
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment17                                -- inventory_item_segment17
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment18                                -- inventory_item_segment18
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment19                                -- inventory_item_segment19
                                   ,ARTrxLines_tbl(ARTrxLines_idx).inventory_item_segment20                                -- inventory_item_segment20
                                   ,ARTrxLines_tbl(ARTrxLines_idx).bill_to_cust_bank_acct_name                             -- bill_to_cust_bank_acct_name
                                   ,ARTrxLines_tbl(ARTrxLines_idx).reset_trx_date_flag                                     -- reset_trx_date_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).payment_server_order_number                             -- payment_server_order_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).last_trans_on_debit_auth                                -- last_trans_on_debit_auth
                                   ,ARTrxLines_tbl(ARTrxLines_idx).approval_code                                           -- approval_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).address_verification_code                               -- address_verification_code
                                   ,ARTrxLines_tbl(ARTrxLines_idx).translated_description                                  -- translated_description
                                   ,ARTrxLines_tbl(ARTrxLines_idx).consolidated_billing_number                             -- consolidated_billing_number
                                   ,ARTrxLines_tbl(ARTrxLines_idx).promised_commitment_amount                              -- promised_commitment_amount
                                   ,ARTrxLines_tbl(ARTrxLines_idx).payment_set_identifier                                  -- payment_set_identifier
                                   ,ARTrxLines_tbl(ARTrxLines_idx).original_gl_date                                        -- original_gl_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).invoiced_line_accting_level                             -- invoiced_line_accting_level
                                   ,ARTrxLines_tbl(ARTrxLines_idx).override_auto_accounting_flag                           -- override_auto_accounting_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).historical_flag                                         -- historical_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).deferral_exclusion_flag                                 -- deferral_exclusion_flag
                                   ,ARTrxLines_tbl(ARTrxLines_idx).payment_attributes                                      -- payment_attributes
                                   ,ARTrxLines_tbl(ARTrxLines_idx).invoice_billing_date                                    -- invoice_billing_date
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute_category                                      -- attribute_category
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute1                                              -- attribute1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute2                                              -- attribute2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute3                                              -- attribute3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute4                                              -- attribute4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute5                                              -- attribute5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute6                                              -- attribute6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute7                                              -- attribute7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute8                                              -- attribute8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute9                                              -- attribute9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute10                                             -- attribute10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute11                                             -- attribute11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute12                                             -- attribute12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute13                                             -- attribute13
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute14                                             -- attribute14
                                   ,ARTrxLines_tbl(ARTrxLines_idx).attribute15                                             -- attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute_category                               -- header_attribute_category
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute1                                       -- header_attribute1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute2                                       -- header_attribute2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute3                                       -- header_attribute3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute4                                       -- header_attribute4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute5                                       -- header_attribute5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute6                                       -- header_attribute6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute7                                       -- header_attribute7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute8                                       -- header_attribute8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute9                                       -- header_attribute9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute10                                      -- header_attribute10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute11                                      -- header_attribute11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute12                                      -- header_attribute12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute13                                      -- header_attribute13
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute14                                      -- header_attribute14
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_attribute15                                      -- header_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attr_category                                -- header_gdf_attr_category
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute1                                   -- header_gdf_attribute1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute2                                   -- header_gdf_attribute2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute3                                   -- header_gdf_attribute3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute4                                   -- header_gdf_attribute4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute5                                   -- header_gdf_attribute5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute6                                   -- header_gdf_attribute6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute7                                   -- header_gdf_attribute7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute8                                   -- header_gdf_attribute8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute9                                   -- header_gdf_attribute9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute10                                  -- header_gdf_attribute10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute11                                  -- header_gdf_attribute11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute12                                  -- header_gdf_attribute12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute13                                  -- header_gdf_attribute13
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute14                                  -- header_gdf_attribute14
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute15                                  -- header_gdf_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute16                                  -- header_gdf_attribute16
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute17                                  -- header_gdf_attribute17
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute18                                  -- header_gdf_attribute18
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute19                                  -- header_gdf_attribute19
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute20                                  -- header_gdf_attribute20
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute21                                  -- header_gdf_attribute21
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute22                                  -- header_gdf_attribute22
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute23                                  -- header_gdf_attribute23
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute24                                  -- header_gdf_attribute24
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute25                                  -- header_gdf_attribute25
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute26                                  -- header_gdf_attribute26
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute27                                  -- header_gdf_attribute27
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute28                                  -- header_gdf_attribute28
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute29                                  -- header_gdf_attribute29
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute30                                  -- header_gdf_attribute30
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attr_category                                  -- line_gdf_attr_category
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute1                                     -- line_gdf_attribute1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute2                                     -- line_gdf_attribute2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute3                                     -- line_gdf_attribute3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute4                                     -- line_gdf_attribute4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute5                                     -- line_gdf_attribute5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute6                                     -- line_gdf_attribute6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute7                                     -- line_gdf_attribute7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute8                                     -- line_gdf_attribute8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute9                                     -- line_gdf_attribute9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute10                                    -- line_gdf_attribute10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute11                                    -- line_gdf_attribute11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute12                                    -- line_gdf_attribute12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute13                                    -- line_gdf_attribute13
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute14                                    -- line_gdf_attribute14
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute15                                    -- line_gdf_attribute15
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute16                                    -- line_gdf_attribute16
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute17                                    -- line_gdf_attribute17
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute18                                    -- line_gdf_attribute18
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute19                                    -- line_gdf_attribute19
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute20                                    -- line_gdf_attribute20
                                   ,ARTrxLines_tbl(ARTrxLines_idx).comments                                                -- comments
                                   ,ARTrxLines_tbl(ARTrxLines_idx).internal_notes                                          -- internal_notes
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number1                            -- header_gdf_attribute_number1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number2                            -- header_gdf_attribute_number2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number3                            -- header_gdf_attribute_number3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number4                            -- header_gdf_attribute_number4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number5                            -- header_gdf_attribute_number5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number6                            -- header_gdf_attribute_number6
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number7                            -- header_gdf_attribute_number7
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number8                            -- header_gdf_attribute_number8
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number9                            -- header_gdf_attribute_number9
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number10                           -- header_gdf_attribute_number10
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number11                           -- header_gdf_attribute_number11
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_number12                           -- header_gdf_attribute_number12
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_date1                              -- header_gdf_attribute_date1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_date2                              -- header_gdf_attribute_date2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_date3                              -- header_gdf_attribute_date3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_date4                              -- header_gdf_attribute_date4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).header_gdf_attribute_date5                              -- header_gdf_attribute_date5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_number1                              -- line_gdf_attribute_number1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_number2                              -- line_gdf_attribute_number2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_number3                              -- line_gdf_attribute_number3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_number4                              -- line_gdf_attribute_number4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_number5                              -- line_gdf_attribute_number5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_date1                                -- line_gdf_attribute_date1
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_date2                                -- line_gdf_attribute_date2
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_date3                                -- line_gdf_attribute_date3
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_date4                                -- line_gdf_attribute_date4
                                   ,ARTrxLines_tbl(ARTrxLines_idx).line_gdf_attribute_date5                                -- line_gdf_attribute_date5
                                   ,ARTrxLines_tbl(ARTrxLines_idx).freight_charge                                          -- freight_charge
                                   ,ARTrxLines_tbl(ARTrxLines_idx).insurance_charge                                        -- insurance_charge
                                   ,ARTrxLines_tbl(ARTrxLines_idx).packing_charge                                          -- packing_charge
                                   ,ARTrxLines_tbl(ARTrxLines_idx).miscellaneous_charge                                    -- miscellaneous_charge
                                   ,ARTrxLines_tbl(ARTrxLines_idx).commercial_discount                                     -- commercial_discount
                                   );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ARTrxLines_cur;
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
               /*
               ** Update the migration details (Migration status will be automatically determined
               ** in the called procedure dependant on the Phase and if an Error Message has been
               ** passed).
               */
               --
               gvv_ProgressIndicator := '-0100';
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
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
               ,pt_i_Severity            => 'NOTIFICATION'
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
                    IF ARTrxLines_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARTrxLines_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_Severity            => gvt_Severity
                         ,pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
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
                    IF ARTrxLines_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARTrxLines_cur;
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
          --** END Exception Handler
          --
     END ar_trx_lines_stg;
     --
     --
     /*
     ******************************
     ** PROCEDURE: ar_trx_lines_xfm
     ******************************
     */
     --
     PROCEDURE ar_trx_lines_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
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
               SELECT  *
               FROM      xxmx_ar_trx_lines_stg
               WHERE   migration_set_id = pt_MigrationSetID
               AND         migration_status = 'EXTRACTED';
               --
          --** END CURSOR StgTable_cur
          --
          CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoice_lines_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  migration_set_id
                      ,migration_set_name
                      ,migration_status
                      ,row_seq                  
                      ,xxmx_customer_trx_id     
                      ,xxmx_customer_trx_line_id
                      ,xxmx_line_number
                      ,source_operating_unit
                      ,fusion_business_unit
                      ,batch_source_name
                      ,cust_trx_type_name
                      ,term_name
                      ,trx_date
                      ,gl_date
                      ,trx_number
                      ,orig_system_bill_customer_ref
                      ,orig_system_bill_address_ref
                      ,orig_system_bill_contact_ref
                      ,orig_sys_ship_party_ref
                      ,orig_sys_ship_party_site_ref
                      ,orig_sys_ship_pty_contact_ref
                      ,orig_system_ship_customer_ref
                      ,orig_system_ship_address_ref
                      ,orig_system_ship_contact_ref
                      ,orig_sys_sold_party_ref
                      ,orig_sys_sold_customer_ref
                      ,bill_customer_account_number
                      ,bill_customer_site_number
                      ,bill_contact_party_number
                      ,ship_customer_account_number
                      ,ship_customer_site_number
                      ,ship_contact_party_number
                      ,sold_customer_account_number
                      ,line_type
                      ,description
                      ,currency_code
                      ,conversion_type
                      ,conversion_date
                      ,conversion_rate
                      ,trx_line_amount
                      ,xxmx_orig_trx_line_amount
                      ,quantity
                      ,quantity_ordered
                      ,unit_selling_price
                      ,xxmx_orig_unit_selling_price
                      ,unit_standard_price
                      ,interface_line_context
                      ,interface_line_attribute1
                      ,interface_line_attribute2
                      ,interface_line_attribute3
                      ,interface_line_attribute4
                      ,interface_line_attribute5
                      ,interface_line_attribute6
                      ,interface_line_attribute7
                      ,interface_line_attribute8
                      ,interface_line_attribute9
                      ,interface_line_attribute10
                      ,interface_line_attribute11
                      ,interface_line_attribute12
                      ,interface_line_attribute13
                      ,interface_line_attribute14
                      ,interface_line_attribute15
                      ,primary_salesrep_number
                      ,tax_classification_code
                      ,legal_entity_identifier
                      ,acct_amount_in_ledger_currency
                      ,sales_order_number
                      ,sales_order_date
                      ,actual_ship_date
                      ,warehouse_code
                      ,unit_of_measure_code
                      ,unit_of_measure_name
                      ,invoicing_rule_name
                      ,revenue_scheduling_rule_name
                      ,number_of_revenue_periods
                      ,rev_scheduling_rule_start_date
                      ,rev_scheduling_rule_end_date
                      ,reason_code_meaning
                      ,last_period_to_credit
                      ,trx_business_category_code
                      ,product_fiscal_class_code
                      ,product_category_code
                      ,product_type
                      ,line_intended_use_code
                      ,assessable_value
                      ,document_sub_type
                      ,default_taxation_country
                      ,user_defined_fiscal_class
                      ,tax_invoice_number
                      ,tax_invoice_date
                      ,tax_regime_code
                      ,tax
                      ,tax_status_code
                      ,tax_rate_code
                      ,tax_jurisdiction_code
                      ,first_party_reg_number
                      ,third_party_reg_number
                      ,final_discharge_location
                      ,taxable_amount
                      ,taxable_flag
                      ,tax_exempt_flag
                      ,tax_exempt_reason_code
                      ,tax_exempt_reason_code_meaning
                      ,tax_exempt_certificate_number
                      ,line_amount_includes_tax_flag
                      ,tax_precedence
                      ,credit_method_for_acct_rule
                      ,credit_method_for_installments
                      ,reason_code
                      ,tax_rate
                      ,fob_point
                      ,ship_via
                      ,waybill_number
                      ,sales_order_line_number
                      ,sales_order_source
                      ,sales_order_revision_number
                      ,purchase_order_number
                      ,purchase_order_revision_number
                      ,purchase_order_date
                      ,agreement_name
                      ,memo_line_name
                      ,document_number
                      ,orig_system_batch_name
                      ,link_to_line_context
                      ,link_to_line_attribute1
                      ,link_to_line_attribute2
                      ,link_to_line_attribute3
                      ,link_to_line_attribute4
                      ,link_to_line_attribute5
                      ,link_to_line_attribute6
                      ,link_to_line_attribute7
                      ,link_to_line_attribute8
                      ,link_to_line_attribute9
                      ,link_to_line_attribute10
                      ,link_to_line_attribute11
                      ,link_to_line_attribute12
                      ,link_to_line_attribute13
                      ,link_to_line_attribute14
                      ,link_to_line_attribute15
                      ,reference_line_context
                      ,reference_line_attribute1
                      ,reference_line_attribute2
                      ,reference_line_attribute3
                      ,reference_line_attribute4
                      ,reference_line_attribute5
                      ,reference_line_attribute6
                      ,reference_line_attribute7
                      ,reference_line_attribute8
                      ,reference_line_attribute9
                      ,reference_line_attribute10
                      ,reference_line_attribute11
                      ,reference_line_attribute12
                      ,reference_line_attribute13
                      ,reference_line_attribute14
                      ,reference_line_attribute15
                      ,link_to_parentline_context
                      ,link_to_parentline_attribute1
                      ,link_to_parentline_attribute2
                      ,link_to_parentline_attribute3
                      ,link_to_parentline_attribute4
                      ,link_to_parentline_attribute5
                      ,link_to_parentline_attribute6
                      ,link_to_parentline_attribute7
                      ,link_to_parentline_attribute8
                      ,link_to_parentline_attribute9
                      ,link_to_parentline_attribute10
                      ,link_to_parentline_attribute11
                      ,link_to_parentline_attribute12
                      ,link_to_parentline_attribute13
                      ,link_to_parentline_attribute14
                      ,link_to_parentline_attribute15
                      ,receipt_method_name
                      ,printing_option
                      ,related_batch_source_name
                      ,related_transaction_number
                      ,inventory_item_number
                      ,inventory_item_segment2
                      ,inventory_item_segment3
                      ,inventory_item_segment4
                      ,inventory_item_segment5
                      ,inventory_item_segment6
                      ,inventory_item_segment7
                      ,inventory_item_segment8
                      ,inventory_item_segment9
                      ,inventory_item_segment10
                      ,inventory_item_segment11
                      ,inventory_item_segment12
                      ,inventory_item_segment13
                      ,inventory_item_segment14
                      ,inventory_item_segment15
                      ,inventory_item_segment16
                      ,inventory_item_segment17
                      ,inventory_item_segment18
                      ,inventory_item_segment19
                      ,inventory_item_segment20
                      ,bill_to_cust_bank_acct_name
                      ,reset_trx_date_flag
                      ,payment_server_order_number
                      ,last_trans_on_debit_auth
                      ,approval_code
                      ,address_verification_code
                      ,translated_description
                      ,consolidated_billing_number
                      ,promised_commitment_amount
                      ,payment_set_identifier
                      ,original_gl_date
                      ,invoiced_line_accting_level
                      ,override_auto_accounting_flag
                      ,historical_flag
                      ,deferral_exclusion_flag
                      ,payment_attributes
                      ,invoice_billing_date
                      ,attribute_category
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
                      ,header_attribute_category
                      ,header_attribute1
                      ,header_attribute2
                      ,header_attribute3
                      ,header_attribute4
                      ,header_attribute5
                      ,header_attribute6
                      ,header_attribute7
                      ,header_attribute8
                      ,header_attribute9
                      ,header_attribute10
                      ,header_attribute11
                      ,header_attribute12
                      ,header_attribute13
                      ,header_attribute14
                      ,header_attribute15
                      ,header_gdf_attr_category
                      ,header_gdf_attribute1
                      ,header_gdf_attribute2
                      ,header_gdf_attribute3
                      ,header_gdf_attribute4
                      ,header_gdf_attribute5
                      ,header_gdf_attribute6
                      ,header_gdf_attribute7
                      ,header_gdf_attribute8
                      ,header_gdf_attribute9
                      ,header_gdf_attribute10
                      ,header_gdf_attribute11
                      ,header_gdf_attribute12
                      ,header_gdf_attribute13
                      ,header_gdf_attribute14
                      ,header_gdf_attribute15
                      ,header_gdf_attribute16
                      ,header_gdf_attribute17
                      ,header_gdf_attribute18
                      ,header_gdf_attribute19
                      ,header_gdf_attribute20
                      ,header_gdf_attribute21
                      ,header_gdf_attribute22
                      ,header_gdf_attribute23
                      ,header_gdf_attribute24
                      ,header_gdf_attribute25
                      ,header_gdf_attribute26
                      ,header_gdf_attribute27
                      ,header_gdf_attribute28
                      ,header_gdf_attribute29
                      ,header_gdf_attribute30
                      ,line_gdf_attr_category
                      ,line_gdf_attribute1
                      ,line_gdf_attribute2
                      ,line_gdf_attribute3
                      ,line_gdf_attribute4
                      ,line_gdf_attribute5
                      ,line_gdf_attribute6
                      ,line_gdf_attribute7
                      ,line_gdf_attribute8
                      ,line_gdf_attribute9
                      ,line_gdf_attribute10
                      ,line_gdf_attribute11
                      ,line_gdf_attribute12
                      ,line_gdf_attribute13
                      ,line_gdf_attribute14
                      ,line_gdf_attribute15
                      ,line_gdf_attribute16
                      ,line_gdf_attribute17
                      ,line_gdf_attribute18
                      ,line_gdf_attribute19
                      ,line_gdf_attribute20
                      ,comments
                      ,internal_notes
                      ,header_gdf_attribute_number1
                      ,header_gdf_attribute_number2
                      ,header_gdf_attribute_number3
                      ,header_gdf_attribute_number4
                      ,header_gdf_attribute_number5
                      ,header_gdf_attribute_number6
                      ,header_gdf_attribute_number7
                      ,header_gdf_attribute_number8
                      ,header_gdf_attribute_number9
                      ,header_gdf_attribute_number10
                      ,header_gdf_attribute_number11
                      ,header_gdf_attribute_number12
                      ,header_gdf_attribute_date1
                      ,header_gdf_attribute_date2
                      ,header_gdf_attribute_date3
                      ,header_gdf_attribute_date4
                      ,header_gdf_attribute_date5
                      ,line_gdf_attribute_number1
                      ,line_gdf_attribute_number2
                      ,line_gdf_attribute_number3
                      ,line_gdf_attribute_number4
                      ,line_gdf_attribute_number5
                      ,line_gdf_attribute_date1
                      ,line_gdf_attribute_date2
                      ,line_gdf_attribute_date3
                      ,line_gdf_attribute_date4
                      ,line_gdf_attribute_date5
                      ,freight_charge
                      ,insurance_charge
                      ,packing_charge
                      ,miscellaneous_charge
                      ,commercial_discount
               FROM     xxmx_ar_trx_lines_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
          --
          CURSOR SourceOperatingUnits_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_lines_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT source_operating_unit
               FROM     xxmx_ar_trx_lines_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID;
               --
          --** END CURSOR SourceOperatingUnits_cur
          --
          /*
          ** This cursor retrieves unique CUSTOMER_TRX_IDs and their original
          ** and remaining amounts.  The Scope View is joined to the XFM
          ** table so that only invoices in the XFM table are retrieved
          ** when the PARTUALLY_PAID_FLAG in the Scope View = 'Y'.
          **
          ** HOwever as the CUSTOMER_TRX_ID can have multiple lines in the
          ** XFM table we need the distinct or the Lines Update Cursor
          ** would be executed more then one for Transactions with more
          ** then one line.
          */
          --
          CURSOR PartiallyPaidTrxs_cur
                      (
                       pt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE
                      )
          IS
               --
               SELECT    DISTINCT
                         xatsv.customer_trx_id
                        ,xatsv.amount_due_original                                     total_original_amt
                        ,xatsv.amount_due_remaining                                remaining_amt
                        ,xatsv.amount_line_items_original                          lines_original_amt
                        ,xatsv.amount_line_items_remaining
                        ,xatsv.freight_original
                        ,xatsv.freight_remaining
                        ,xatsv.amount_due_orig_excl_tax
                        ,xatsv.amount_due_rem_excl_tax
                        ,xatsv.tax_original                                                   tax_original_amt
                        ,xatsv.amount_paid                                                 total_paid_amt
               FROM       xxmx_ar_trx_lines_xfm   xatlx
                        , xxmx_ar_trx_scope_v    xatsv
               WHERE    xatlx.migration_set_id    = pt_MigrationSetID
               AND          xatsv.customer_trx_id     = xatlx.xxmx_customer_trx_id  /* CUSTOMER_TRX_ID Join from STG table to Scope View */
               AND          xatsv.partially_paid_flag = 'Y'
               ORDER BY  xatsv.customer_trx_id;
               --
          --** END CURSOR PartiallyPaidTrxs_cur
          --
          CURSOR UpdTrxLineAmounts_cur
                      (
                       pt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE
                      ,pn_CustomerTrxID                NUMBER
                      )
          IS
               --
               SELECT    xatlx.xxmx_customer_trx_id
                        ,xatlx.xxmx_customer_trx_line_id
                        ,xatlx.xxmx_line_number
                        ,xatlx.line_type
                        ,xatlx.trx_line_amount            AS original_line_amount
                        ,xatlx.quantity                   as original_line_quantity
               FROM       xxmx_ar_trx_lines_xfm   xatlx
               WHERE     1 = 1
               AND       xatlx.migration_set_id     = pt_MigrationSetID
               AND       xatlx.xxmx_customer_trx_id = pn_CustomerTrxID
               ORDER BY  
                        xatlx.xxmx_customer_trx_line_id,
                        xatlx.xxmx_line_number;
               --
          --** END CURSOR UpdTrxLineAmounts_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE stg_table_tt IS TABLE OF StgTable_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_lines_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_lines_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_lines_xfm';
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
          vt_MigrationStatus              xxmx_ar_trx_dists_xfm.migration_status%TYPE;
          vt_FusionBusinessUnit           xxmx_ar_trx_dists_xfm.fusion_business_unit%TYPE;
          vt_FusionBusinessUnitID         xxmx_source_operating_units.fusion_business_unit_id%TYPE;
          vn_TrxLineCount                 NUMBER;
          vn_TxnOpenBalanceRemaining      NUMBER;
          vn_OrigLineAmtRatio             NUMBER;
          vn_line_new_outstanding_amt       NUMBER;
          vn_NewUnitSellingPrice          NUMBER;
          vn_tax_outstanding_amt            NUMBER;         -- The tax outstanding amount after deducting its ration from the amount paid
          vn_lines_outstanding_amt            NUMBER;       -- total lines outstanding amount where we taken out the tax value
          --
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          AND  pt_i_SimpleXfmPerformedBy IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               IF   NOT xxmx_utilities_pkg.valid_lookup_code
                         (
                          'TRANSFORM_PERFORMERS'
                         ,UPPER(pt_i_SimpleXfmPerformedBy)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '- "pt_i_SimpleXfmPerformedBy" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "TRANSFORM_PERFORMERS".';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- Simple transformation processing is performed by '
                                                  ||UPPER(pt_i_SimpleXfmPerformedBy)
                                                              ||'.'
                         ,pt_i_OracleError       => NULL
                              );
                    --
                    --
               END IF; --** IF   NOT xxmx_utilities_pkg.valid_lookup_code
               --
               vd_TransformStartDate := SYSDATE;
               --
               gvv_ProgressIndicator := '0060';
               --
               IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               THEN
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Simple transformation processing initiated.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Deleting existing data from the '
                                                  ||ct_XfmTable
                                                  ||' table for Migration Set ID "'
                                                  ||pt_i_MigrationSetID
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    DELETE
                    FROM   xxmx_ar_trx_lines_xfm
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID;
                    --
                    gvn_RowCount := SQL%ROWCOUNT;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' rows deleted.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** For Simple Transformations being performed by PL/SQL the data must be moved
                    ** from the STG table to the XFM table as-is.
                    **
                    ** The data is then transformed vertically with several updates across all rows.
                    **
                    ** Any simple transforms are performed first followed by any complex transforms.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Copying "'
                                                  ||pt_i_SubEntity
                                                  ||'" data from the "'
                                                  ||ct_StgTable
                                                  ||'" table to the "'
                                                  ||ct_XfmTable
                                                  ||'" table prior to simple transformation '
                                                  ||'(transformation processing is all by PL/SQL '
                                                  ||'for this Sub-entity).'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    /*
                    ** Copy the data from the STG table to the XFM Table.
                    */
                    --
                    OPEN StgTable_cur
                              (
                               pt_i_MigrationSetID
                              );
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    LOOP
                         --
                         FETCH        StgTable_cur
                         BULK COLLECT
                         INTO         StgTable_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    StgTable_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         FORALL ARTrxLines_idx
                         IN     1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_ar_trx_lines_xfm
                                          (
                                           migration_set_id
                                          ,migration_set_name
                                          ,migration_status
                                          ,row_seq                  
                                          ,xxmx_customer_trx_id     
                                          ,xxmx_customer_trx_line_id
                                          ,xxmx_line_number
                                          ,source_operating_unit
                                          ,fusion_business_unit
                                          ,batch_source_name
                                          ,cust_trx_type_name
                                          ,term_name
                                          ,trx_date
                                          ,gl_date
                                          ,trx_number
                                          ,orig_system_bill_customer_ref
                                          ,orig_system_bill_address_ref
                                          ,orig_system_bill_contact_ref
                                          ,orig_sys_ship_party_ref
                                          ,orig_sys_ship_party_site_ref
                                          ,orig_sys_ship_pty_contact_ref
                                          ,orig_system_ship_customer_ref
                                          ,orig_system_ship_address_ref
                                          ,orig_system_ship_contact_ref
                                          ,orig_sys_sold_party_ref
                                          ,orig_sys_sold_customer_ref
                                          ,bill_customer_account_number
                                          ,bill_customer_site_number
                                          ,bill_contact_party_number
                                          ,ship_customer_account_number
                                          ,ship_customer_site_number
                                          ,ship_contact_party_number
                                          ,sold_customer_account_number
                                          ,line_type
                                          ,description
                                          ,currency_code
                                          ,conversion_type
                                          ,conversion_date
                                          ,conversion_rate
                                          ,trx_line_amount
                                          ,xxmx_orig_trx_line_amount
                                          ,quantity
                                          ,quantity_ordered
                                          ,unit_selling_price
                                          ,xxmx_orig_unit_selling_price
                                          ,unit_standard_price
                                          ,interface_line_context
                                          ,interface_line_attribute1
                                          ,interface_line_attribute2
                                          ,interface_line_attribute3
                                          ,interface_line_attribute4
                                          ,interface_line_attribute5
                                          ,interface_line_attribute6
                                          ,interface_line_attribute7
                                          ,interface_line_attribute8
                                          ,interface_line_attribute9
                                          ,interface_line_attribute10
                                          ,interface_line_attribute11
                                          ,interface_line_attribute12
                                          ,interface_line_attribute13
                                          ,interface_line_attribute14
                                          ,interface_line_attribute15
                                          ,primary_salesrep_number
                                          ,tax_classification_code
                                          ,legal_entity_identifier
                                          ,acct_amount_in_ledger_currency
                                          ,sales_order_number
                                          ,sales_order_date
                                          ,actual_ship_date
                                          ,warehouse_code
                                          ,unit_of_measure_code
                                          ,unit_of_measure_name
                                          ,invoicing_rule_name
                                          ,revenue_scheduling_rule_name
                                          ,number_of_revenue_periods
                                          ,rev_scheduling_rule_start_date
                                          ,rev_scheduling_rule_end_date
                                          ,reason_code_meaning
                                          ,last_period_to_credit
                                          ,trx_business_category_code
                                          ,product_fiscal_class_code
                                          ,product_category_code
                                          ,product_type
                                          ,line_intended_use_code
                                          ,assessable_value
                                          ,document_sub_type
                                          ,default_taxation_country
                                          ,user_defined_fiscal_class
                                          ,tax_invoice_number
                                          ,tax_invoice_date
                                          ,tax_regime_code
                                          ,tax
                                          ,tax_status_code
                                          ,tax_rate_code
                                          ,tax_jurisdiction_code
                                          ,first_party_reg_number
                                          ,third_party_reg_number
                                          ,final_discharge_location
                                          ,taxable_amount
                                          ,taxable_flag
                                          ,tax_exempt_flag
                                          ,tax_exempt_reason_code
                                          ,tax_exempt_reason_code_meaning
                                          ,tax_exempt_certificate_number
                                          ,line_amount_includes_tax_flag
                                          ,tax_precedence
                                          ,credit_method_for_acct_rule
                                          ,credit_method_for_installments
                                          ,reason_code
                                          ,tax_rate
                                          ,fob_point
                                          ,ship_via
                                          ,waybill_number
                                          ,sales_order_line_number
                                          ,sales_order_source
                                          ,sales_order_revision_number
                                          ,purchase_order_number
                                          ,purchase_order_revision_number
                                          ,purchase_order_date
                                          ,agreement_name
                                          ,memo_line_name
                                          ,document_number
                                          ,orig_system_batch_name
                                          ,link_to_line_context
                                          ,link_to_line_attribute1
                                          ,link_to_line_attribute2
                                          ,link_to_line_attribute3
                                          ,link_to_line_attribute4
                                          ,link_to_line_attribute5
                                          ,link_to_line_attribute6
                                          ,link_to_line_attribute7
                                          ,link_to_line_attribute8
                                          ,link_to_line_attribute9
                                          ,link_to_line_attribute10
                                          ,link_to_line_attribute11
                                          ,link_to_line_attribute12
                                          ,link_to_line_attribute13
                                          ,link_to_line_attribute14
                                          ,link_to_line_attribute15
                                          ,reference_line_context
                                          ,reference_line_attribute1
                                          ,reference_line_attribute2
                                          ,reference_line_attribute3
                                          ,reference_line_attribute4
                                          ,reference_line_attribute5
                                          ,reference_line_attribute6
                                          ,reference_line_attribute7
                                          ,reference_line_attribute8
                                          ,reference_line_attribute9
                                          ,reference_line_attribute10
                                          ,reference_line_attribute11
                                          ,reference_line_attribute12
                                          ,reference_line_attribute13
                                          ,reference_line_attribute14
                                          ,reference_line_attribute15
                                          ,link_to_parentline_context
                                          ,link_to_parentline_attribute1
                                          ,link_to_parentline_attribute2
                                          ,link_to_parentline_attribute3
                                          ,link_to_parentline_attribute4
                                          ,link_to_parentline_attribute5
                                          ,link_to_parentline_attribute6
                                          ,link_to_parentline_attribute7
                                          ,link_to_parentline_attribute8
                                          ,link_to_parentline_attribute9
                                          ,link_to_parentline_attribute10
                                          ,link_to_parentline_attribute11
                                          ,link_to_parentline_attribute12
                                          ,link_to_parentline_attribute13
                                          ,link_to_parentline_attribute14
                                          ,link_to_parentline_attribute15
                                          ,receipt_method_name
                                          ,printing_option
                                          ,related_batch_source_name
                                          ,related_transaction_number
                                          ,inventory_item_number
                                          ,inventory_item_segment2
                                          ,inventory_item_segment3
                                          ,inventory_item_segment4
                                          ,inventory_item_segment5
                                          ,inventory_item_segment6
                                          ,inventory_item_segment7
                                          ,inventory_item_segment8
                                          ,inventory_item_segment9
                                          ,inventory_item_segment10
                                          ,inventory_item_segment11
                                          ,inventory_item_segment12
                                          ,inventory_item_segment13
                                          ,inventory_item_segment14
                                          ,inventory_item_segment15
                                          ,inventory_item_segment16
                                          ,inventory_item_segment17
                                          ,inventory_item_segment18
                                          ,inventory_item_segment19
                                          ,inventory_item_segment20
                                          ,bill_to_cust_bank_acct_name
                                          ,reset_trx_date_flag
                                          ,payment_server_order_number
                                          ,last_trans_on_debit_auth
                                          ,approval_code
                                          ,address_verification_code
                                          ,translated_description
                                          ,consolidated_billing_number
                                          ,promised_commitment_amount
                                          ,payment_set_identifier
                                          ,original_gl_date
                                          ,invoiced_line_accting_level
                                          ,override_auto_accounting_flag
                                          ,historical_flag
                                          ,deferral_exclusion_flag
                                          ,payment_attributes
                                          ,invoice_billing_date
                                          ,attribute_category
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
                                          ,header_attribute_category
                                          ,header_attribute1
                                          ,header_attribute2
                                          ,header_attribute3
                                          ,header_attribute4
                                          ,header_attribute5
                                          ,header_attribute6
                                          ,header_attribute7
                                          ,header_attribute8
                                          ,header_attribute9
                                          ,header_attribute10
                                          ,header_attribute11
                                          ,header_attribute12
                                          ,header_attribute13
                                          ,header_attribute14
                                          ,header_attribute15
                                          ,header_gdf_attr_category
                                          ,header_gdf_attribute1
                                          ,header_gdf_attribute2
                                          ,header_gdf_attribute3
                                          ,header_gdf_attribute4
                                          ,header_gdf_attribute5
                                          ,header_gdf_attribute6
                                          ,header_gdf_attribute7
                                          ,header_gdf_attribute8
                                          ,header_gdf_attribute9
                                          ,header_gdf_attribute10
                                          ,header_gdf_attribute11
                                          ,header_gdf_attribute12
                                          ,header_gdf_attribute13
                                          ,header_gdf_attribute14
                                          ,header_gdf_attribute15
                                          ,header_gdf_attribute16
                                          ,header_gdf_attribute17
                                          ,header_gdf_attribute18
                                          ,header_gdf_attribute19
                                          ,header_gdf_attribute20
                                          ,header_gdf_attribute21
                                          ,header_gdf_attribute22
                                          ,header_gdf_attribute23
                                          ,header_gdf_attribute24
                                          ,header_gdf_attribute25
                                          ,header_gdf_attribute26
                                          ,header_gdf_attribute27
                                          ,header_gdf_attribute28
                                          ,header_gdf_attribute29
                                          ,header_gdf_attribute30
                                          ,line_gdf_attr_category
                                          ,line_gdf_attribute1
                                          ,line_gdf_attribute2
                                          ,line_gdf_attribute3
                                          ,line_gdf_attribute4
                                          ,line_gdf_attribute5
                                          ,line_gdf_attribute6
                                          ,line_gdf_attribute7
                                          ,line_gdf_attribute8
                                          ,line_gdf_attribute9
                                          ,line_gdf_attribute10
                                          ,line_gdf_attribute11
                                          ,line_gdf_attribute12
                                          ,line_gdf_attribute13
                                          ,line_gdf_attribute14
                                          ,line_gdf_attribute15
                                          ,line_gdf_attribute16
                                          ,line_gdf_attribute17
                                          ,line_gdf_attribute18
                                          ,line_gdf_attribute19
                                          ,line_gdf_attribute20
                                          ,comments
                                          ,internal_notes
                                          ,header_gdf_attribute_number1
                                          ,header_gdf_attribute_number2
                                          ,header_gdf_attribute_number3
                                          ,header_gdf_attribute_number4
                                          ,header_gdf_attribute_number5
                                          ,header_gdf_attribute_number6
                                          ,header_gdf_attribute_number7
                                          ,header_gdf_attribute_number8
                                          ,header_gdf_attribute_number9
                                          ,header_gdf_attribute_number10
                                          ,header_gdf_attribute_number11
                                          ,header_gdf_attribute_number12
                                          ,header_gdf_attribute_date1
                                          ,header_gdf_attribute_date2
                                          ,header_gdf_attribute_date3
                                          ,header_gdf_attribute_date4
                                          ,header_gdf_attribute_date5
                                          ,line_gdf_attribute_number1
                                          ,line_gdf_attribute_number2
                                          ,line_gdf_attribute_number3
                                          ,line_gdf_attribute_number4
                                          ,line_gdf_attribute_number5
                                          ,line_gdf_attribute_date1
                                          ,line_gdf_attribute_date2
                                          ,line_gdf_attribute_date3
                                          ,line_gdf_attribute_date4
                                          ,line_gdf_attribute_date5
                                          ,freight_charge
                                          ,insurance_charge
                                          ,packing_charge
                                          ,miscellaneous_charge
                                          ,commercial_discount
                                          )
                              VALUES
                                          (
                                           StgTable_tbl(ARTrxLines_idx).migration_set_id                    -- migration_set_id
                                          ,StgTable_tbl(ARTrxLines_idx).migration_set_name                  -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                            -- migration_status
                                          ,StgTable_tbl(ARTrxLines_idx).row_seq                             -- row_seq                  
                                          ,StgTable_tbl(ARTrxLines_idx).xxmx_customer_trx_id                -- xxmx_customer_trx_id     
                                          ,StgTable_tbl(ARTrxLines_idx).xxmx_customer_trx_line_id           -- xxmx_customer_trx_line_id
                                          ,StgTable_tbl(ARTrxLines_idx).xxmx_line_number                    -- xxmx_line_number
                                          ,StgTable_tbl(ARTrxLines_idx).operating_unit                      -- source_operating_unit
                                          ,NULL                                                             -- fusion_business_unit
                                          ,StgTable_tbl(ARTrxLines_idx).batch_source_name                   -- batch_source_name
                                          ,StgTable_tbl(ARTrxLines_idx).cust_trx_type_name                  -- cust_trx_type_name
                                          ,StgTable_tbl(ARTrxLines_idx).term_name                           -- term_name
                                          ,StgTable_tbl(ARTrxLines_idx).trx_date                            -- trx_date
                                          ,StgTable_tbl(ARTrxLines_idx).gl_date                             -- gl_date
                                          ,StgTable_tbl(ARTrxLines_idx).trx_number                          -- trx_number
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_bill_customer_ref       -- orig_system_bill_customer_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_bill_address_ref        -- orig_system_bill_address_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_bill_contact_ref        -- orig_system_bill_contact_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_sys_ship_party_ref             -- orig_sys_ship_party_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_sys_ship_party_site_ref        -- orig_sys_ship_party_site_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_sys_ship_pty_contact_ref       -- orig_sys_ship_pty_contact_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_ship_customer_ref       -- orig_system_ship_customer_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_ship_address_ref        -- orig_system_ship_address_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_ship_contact_ref        -- orig_system_ship_contact_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_sys_sold_party_ref             -- orig_sys_sold_party_ref
                                          ,StgTable_tbl(ARTrxLines_idx).orig_sys_sold_customer_ref          -- orig_sys_sold_customer_ref
                                          ,StgTable_tbl(ARTrxLines_idx).bill_customer_account_number        -- bill_customer_account_number
                                          ,StgTable_tbl(ARTrxLines_idx).bill_customer_site_number           -- bill_customer_site_number
                                          ,StgTable_tbl(ARTrxLines_idx).bill_contact_party_number           -- bill_contact_party_number
                                          ,StgTable_tbl(ARTrxLines_idx).ship_customer_account_number        -- ship_customer_account_number
                                          ,StgTable_tbl(ARTrxLines_idx).ship_customer_site_number           -- ship_customer_site_number
                                          ,StgTable_tbl(ARTrxLines_idx).ship_contact_party_number           -- ship_contact_party_number
                                          ,StgTable_tbl(ARTrxLines_idx).sold_customer_account_number        -- sold_customer_account_number
                                          ,StgTable_tbl(ARTrxLines_idx).line_type                           -- line_type
                                          ,StgTable_tbl(ARTrxLines_idx).description                         -- description
                                          ,StgTable_tbl(ARTrxLines_idx).currency_code                       -- currency_code
                                          ,StgTable_tbl(ARTrxLines_idx).conversion_type                     -- conversion_type
                                          ,StgTable_tbl(ARTrxLines_idx).conversion_date                     -- conversion_date
                                          ,StgTable_tbl(ARTrxLines_idx).conversion_rate                     -- conversion_rate
                                          ,StgTable_tbl(ARTrxLines_idx).trx_line_amount                     -- trx_line_amount
                                          ,StgTable_tbl(ARTrxLines_idx).trx_line_amount                     -- xxmx_orig_trx_line_amount
                                          ,StgTable_tbl(ARTrxLines_idx).quantity                            -- quantity
                                          ,StgTable_tbl(ARTrxLines_idx).quantity_ordered                    -- quantity_ordered
                                          ,StgTable_tbl(ARTrxLines_idx).unit_selling_price                  -- unit_selling_price
                                          ,StgTable_tbl(ARTrxLines_idx).unit_selling_price                  -- xxmx_orig_unit_selling_price
                                          ,StgTable_tbl(ARTrxLines_idx).unit_standard_price                 -- unit_standard_price
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_context              -- interface_line_context
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute1           -- interface_line_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute2           -- interface_line_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute3           -- interface_line_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute4           -- interface_line_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute5           -- interface_line_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute6           -- interface_line_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute7           -- interface_line_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute8           -- interface_line_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute9           -- interface_line_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute10          -- interface_line_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute11          -- interface_line_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute12          -- interface_line_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute13          -- interface_line_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute14          -- interface_line_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).interface_line_attribute15          -- interface_line_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).primary_salesrep_number             -- primary_salesrep_number
                                          ,StgTable_tbl(ARTrxLines_idx).tax_classification_code             -- tax_classification_code
                                          ,StgTable_tbl(ARTrxLines_idx).legal_entity_identifier             -- legal_entity_identifier
                                          ,StgTable_tbl(ARTrxLines_idx).acct_amount_in_ledger_currency      -- acct_amount_in_ledger_currency
                                          ,StgTable_tbl(ARTrxLines_idx).sales_order_number                  -- sales_order_number
                                          ,StgTable_tbl(ARTrxLines_idx).sales_order_date                    -- sales_order_date
                                          ,StgTable_tbl(ARTrxLines_idx).actual_ship_date                    -- actual_ship_date
                                          ,StgTable_tbl(ARTrxLines_idx).warehouse_code                      -- warehouse_code
                                          ,StgTable_tbl(ARTrxLines_idx).unit_of_measure_code                -- unit_of_measure_code
                                          ,StgTable_tbl(ARTrxLines_idx).unit_of_measure_name                -- unit_of_measure_name
                                          ,StgTable_tbl(ARTrxLines_idx).invoicing_rule_name                 -- invoicing_rule_name
                                          ,StgTable_tbl(ARTrxLines_idx).revenue_scheduling_rule_name        -- revenue_scheduling_rule_name
                                          ,StgTable_tbl(ARTrxLines_idx).number_of_revenue_periods           -- number_of_revenue_periods
                                          ,StgTable_tbl(ARTrxLines_idx).rev_scheduling_rule_start_date      -- rev_scheduling_rule_start_date
                                          ,StgTable_tbl(ARTrxLines_idx).rev_scheduling_rule_end_date        -- rev_scheduling_rule_end_date
                                          ,StgTable_tbl(ARTrxLines_idx).reason_code_meaning                 -- reason_code_meaning
                                          ,StgTable_tbl(ARTrxLines_idx).last_period_to_credit               -- last_period_to_credit
                                          ,StgTable_tbl(ARTrxLines_idx).trx_business_category_code          -- trx_business_category_code
                                          ,StgTable_tbl(ARTrxLines_idx).product_fiscal_class_code           -- product_fiscal_class_code
                                          ,StgTable_tbl(ARTrxLines_idx).product_category_code               -- product_category_code
                                          ,StgTable_tbl(ARTrxLines_idx).product_type                        -- product_type
                                          ,StgTable_tbl(ARTrxLines_idx).line_intended_use_code              -- line_intended_use_code
                                          ,StgTable_tbl(ARTrxLines_idx).assessable_value                    -- assessable_value
                                          ,StgTable_tbl(ARTrxLines_idx).document_sub_type                   -- document_sub_type
                                          ,StgTable_tbl(ARTrxLines_idx).default_taxation_country            -- default_taxation_country
                                          ,StgTable_tbl(ARTrxLines_idx).user_defined_fiscal_class           -- user_defined_fiscal_class
                                          ,StgTable_tbl(ARTrxLines_idx).tax_invoice_number                  -- tax_invoice_number
                                          ,StgTable_tbl(ARTrxLines_idx).tax_invoice_date                    -- tax_invoice_date
                                          ,StgTable_tbl(ARTrxLines_idx).tax_regime_code                     -- tax_regime_code
                                          ,StgTable_tbl(ARTrxLines_idx).tax                                 -- tax
                                          ,StgTable_tbl(ARTrxLines_idx).tax_status_code                     -- tax_status_code
                                          ,StgTable_tbl(ARTrxLines_idx).tax_rate_code                       -- tax_rate_code
                                          ,StgTable_tbl(ARTrxLines_idx).tax_jurisdiction_code               -- tax_jurisdiction_code
                                          ,StgTable_tbl(ARTrxLines_idx).first_party_reg_number              -- first_party_reg_number
                                          ,StgTable_tbl(ARTrxLines_idx).third_party_reg_number              -- third_party_reg_number
                                          ,StgTable_tbl(ARTrxLines_idx).final_discharge_location            -- final_discharge_location
                                          ,StgTable_tbl(ARTrxLines_idx).taxable_amount                      -- taxable_amount
                                          ,StgTable_tbl(ARTrxLines_idx).taxable_flag                        -- taxable_flag
                                          ,StgTable_tbl(ARTrxLines_idx).tax_exempt_flag                     -- tax_exempt_flag
                                          ,StgTable_tbl(ARTrxLines_idx).tax_exempt_reason_code              -- tax_exempt_reason_code
                                          ,StgTable_tbl(ARTrxLines_idx).tax_exempt_reason_code_meaning      -- tax_exempt_reason_code_meaning
                                          ,StgTable_tbl(ARTrxLines_idx).tax_exempt_certificate_number       -- tax_exempt_certificate_number
                                          ,StgTable_tbl(ARTrxLines_idx).line_amount_includes_tax_flag       -- line_amount_includes_tax_flag
                                          ,StgTable_tbl(ARTrxLines_idx).tax_precedence                      -- tax_precedence
                                          ,StgTable_tbl(ARTrxLines_idx).credit_method_for_acct_rule         -- credit_method_for_acct_rule
                                          ,StgTable_tbl(ARTrxLines_idx).credit_method_for_installments      -- credit_method_for_installments
                                          ,StgTable_tbl(ARTrxLines_idx).reason_code                         -- reason_code
                                          ,StgTable_tbl(ARTrxLines_idx).tax_rate                            -- tax_rate
                                          ,StgTable_tbl(ARTrxLines_idx).fob_point                           -- fob_point
                                          ,StgTable_tbl(ARTrxLines_idx).ship_via                            -- ship_via
                                          ,StgTable_tbl(ARTrxLines_idx).waybill_number                      -- waybill_number
                                          ,StgTable_tbl(ARTrxLines_idx).sales_order_line_number             -- sales_order_line_number
                                          ,StgTable_tbl(ARTrxLines_idx).sales_order_source                  -- sales_order_source
                                          ,StgTable_tbl(ARTrxLines_idx).sales_order_revision_number         -- sales_order_revision_number
                                          ,StgTable_tbl(ARTrxLines_idx).purchase_order_number               -- purchase_order_number
                                          ,StgTable_tbl(ARTrxLines_idx).purchase_order_revision_number      -- purchase_order_revision_number
                                          ,StgTable_tbl(ARTrxLines_idx).purchase_order_date                 -- purchase_order_date
                                          ,StgTable_tbl(ARTrxLines_idx).agreement_name                      -- agreement_name
                                          ,StgTable_tbl(ARTrxLines_idx).memo_line_name                      -- memo_line_name
                                          ,StgTable_tbl(ARTrxLines_idx).document_number                     -- document_number
                                          ,StgTable_tbl(ARTrxLines_idx).orig_system_batch_name              -- orig_system_batch_name
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_context                -- link_to_line_context
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute1             -- link_to_line_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute2             -- link_to_line_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute3             -- link_to_line_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute4             -- link_to_line_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute5             -- link_to_line_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute6             -- link_to_line_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute7             -- link_to_line_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute8             -- link_to_line_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute9             -- link_to_line_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute10            -- link_to_line_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute11            -- link_to_line_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute12            -- link_to_line_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute13            -- link_to_line_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute14            -- link_to_line_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_line_attribute15            -- link_to_line_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_context              -- reference_line_context
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute1           -- reference_line_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute2           -- reference_line_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute3           -- reference_line_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute4           -- reference_line_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute5           -- reference_line_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute6           -- reference_line_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute7           -- reference_line_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute8           -- reference_line_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute9           -- reference_line_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute10          -- reference_line_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute11          -- reference_line_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute12          -- reference_line_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute13          -- reference_line_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute14          -- reference_line_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).reference_line_attribute15          -- reference_line_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_context          -- link_to_parentline_context
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute1       -- link_to_parentline_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute2       -- link_to_parentline_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute3       -- link_to_parentline_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute4       -- link_to_parentline_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute5       -- link_to_parentline_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute6       -- link_to_parentline_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute7       -- link_to_parentline_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute8       -- link_to_parentline_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute9       -- link_to_parentline_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute10      -- link_to_parentline_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute11      -- link_to_parentline_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute12      -- link_to_parentline_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute13      -- link_to_parentline_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute14      -- link_to_parentline_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).link_to_parentline_attribute15      -- link_to_parentline_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).receipt_method_name                 -- receipt_method_name
                                          ,StgTable_tbl(ARTrxLines_idx).printing_option                     -- printing_option
                                          ,StgTable_tbl(ARTrxLines_idx).related_batch_source_name           -- related_batch_source_name
                                          ,StgTable_tbl(ARTrxLines_idx).related_transaction_number          -- related_transaction_number
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_number               -- inventory_item_number
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment2             -- inventory_item_segment2
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment3             -- inventory_item_segment3
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment4             -- inventory_item_segment4
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment5             -- inventory_item_segment5
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment6             -- inventory_item_segment6
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment7             -- inventory_item_segment7
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment8             -- inventory_item_segment8
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment9             -- inventory_item_segment9
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment10            -- inventory_item_segment10
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment11            -- inventory_item_segment11
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment12            -- inventory_item_segment12
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment13            -- inventory_item_segment13
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment14            -- inventory_item_segment14
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment15            -- inventory_item_segment15
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment16            -- inventory_item_segment16
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment17            -- inventory_item_segment17
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment18            -- inventory_item_segment18
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment19            -- inventory_item_segment19
                                          ,StgTable_tbl(ARTrxLines_idx).inventory_item_segment20            -- inventory_item_segment20
                                          ,StgTable_tbl(ARTrxLines_idx).bill_to_cust_bank_acct_name         -- bill_to_cust_bank_acct_name
                                          ,StgTable_tbl(ARTrxLines_idx).reset_trx_date_flag                 -- reset_trx_date_flag
                                          ,StgTable_tbl(ARTrxLines_idx).payment_server_order_number         -- payment_server_order_number
                                          ,StgTable_tbl(ARTrxLines_idx).last_trans_on_debit_auth            -- last_trans_on_debit_auth
                                          ,StgTable_tbl(ARTrxLines_idx).approval_code                       -- approval_code
                                          ,StgTable_tbl(ARTrxLines_idx).address_verification_code           -- address_verification_code
                                          ,StgTable_tbl(ARTrxLines_idx).translated_description              -- translated_description
                                          ,StgTable_tbl(ARTrxLines_idx).consolidated_billing_number         -- consolidated_billing_number
                                          ,StgTable_tbl(ARTrxLines_idx).promised_commitment_amount          -- promised_commitment_amount
                                          ,StgTable_tbl(ARTrxLines_idx).payment_set_identifier              -- payment_set_identifier
                                          ,StgTable_tbl(ARTrxLines_idx).original_gl_date                    -- original_gl_date
                                          ,StgTable_tbl(ARTrxLines_idx).invoiced_line_accting_level         -- invoiced_line_accting_level
                                          ,StgTable_tbl(ARTrxLines_idx).override_auto_accounting_flag       -- override_auto_accounting_flag
                                          ,StgTable_tbl(ARTrxLines_idx).historical_flag                     -- historical_flag
                                          ,StgTable_tbl(ARTrxLines_idx).deferral_exclusion_flag             -- deferral_exclusion_flag
                                          ,StgTable_tbl(ARTrxLines_idx).payment_attributes                  -- payment_attributes
                                          ,StgTable_tbl(ARTrxLines_idx).invoice_billing_date                -- invoice_billing_date
                                          ,StgTable_tbl(ARTrxLines_idx).attribute_category                  -- attribute_category
                                          ,StgTable_tbl(ARTrxLines_idx).attribute1                          -- attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).attribute2                          -- attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).attribute3                          -- attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).attribute4                          -- attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).attribute5                          -- attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).attribute6                          -- attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).attribute7                          -- attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).attribute8                          -- attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).attribute9                          -- attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).attribute10                         -- attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).attribute11                         -- attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).attribute12                         -- attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).attribute13                         -- attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).attribute14                         -- attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).attribute15                         -- attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute_category           -- header_attribute_category
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute1                   -- header_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute2                   -- header_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute3                   -- header_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute4                   -- header_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute5                   -- header_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute6                   -- header_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute7                   -- header_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute8                   -- header_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute9                   -- header_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute10                  -- header_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute11                  -- header_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute12                  -- header_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute13                  -- header_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute14                  -- header_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).header_attribute15                  -- header_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attr_category            -- header_gdf_attr_category
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute1               -- header_gdf_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute2               -- header_gdf_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute3               -- header_gdf_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute4               -- header_gdf_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute5               -- header_gdf_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute6               -- header_gdf_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute7               -- header_gdf_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute8               -- header_gdf_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute9               -- header_gdf_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute10              -- header_gdf_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute11              -- header_gdf_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute12              -- header_gdf_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute13              -- header_gdf_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute14              -- header_gdf_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute15              -- header_gdf_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute16              -- header_gdf_attribute16
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute17              -- header_gdf_attribute17
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute18              -- header_gdf_attribute18
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute19              -- header_gdf_attribute19
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute20              -- header_gdf_attribute20
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute21              -- header_gdf_attribute21
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute22              -- header_gdf_attribute22
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute23              -- header_gdf_attribute23
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute24              -- header_gdf_attribute24
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute25              -- header_gdf_attribute25
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute26              -- header_gdf_attribute26
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute27              -- header_gdf_attribute27
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute28              -- header_gdf_attribute28
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute29              -- header_gdf_attribute29
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute30              -- header_gdf_attribute30
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attr_category              -- line_gdf_attr_category
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute1                 -- line_gdf_attribute1
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute2                 -- line_gdf_attribute2
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute3                 -- line_gdf_attribute3
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute4                 -- line_gdf_attribute4
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute5                 -- line_gdf_attribute5
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute6                 -- line_gdf_attribute6
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute7                 -- line_gdf_attribute7
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute8                 -- line_gdf_attribute8
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute9                 -- line_gdf_attribute9
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute10                -- line_gdf_attribute10
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute11                -- line_gdf_attribute11
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute12                -- line_gdf_attribute12
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute13                -- line_gdf_attribute13
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute14                -- line_gdf_attribute14
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute15                -- line_gdf_attribute15
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute16                -- line_gdf_attribute16
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute17                -- line_gdf_attribute17
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute18                -- line_gdf_attribute18
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute19                -- line_gdf_attribute19
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute20                -- line_gdf_attribute20
                                          ,StgTable_tbl(ARTrxLines_idx).comments                            -- comments
                                          ,StgTable_tbl(ARTrxLines_idx).internal_notes                      -- internal_notes
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number1        -- header_gdf_attribute_number1
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number2        -- header_gdf_attribute_number2
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number3        -- header_gdf_attribute_number3
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number4        -- header_gdf_attribute_number4
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number5        -- header_gdf_attribute_number5
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number6        -- header_gdf_attribute_number6
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number7        -- header_gdf_attribute_number7
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number8        -- header_gdf_attribute_number8
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number9        -- header_gdf_attribute_number9
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number10       -- header_gdf_attribute_number10
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number11       -- header_gdf_attribute_number11
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_number12       -- header_gdf_attribute_number12
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_date1          -- header_gdf_attribute_date1
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_date2          -- header_gdf_attribute_date2
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_date3          -- header_gdf_attribute_date3
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_date4          -- header_gdf_attribute_date4
                                          ,StgTable_tbl(ARTrxLines_idx).header_gdf_attribute_date5          -- header_gdf_attribute_date5
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_number1          -- line_gdf_attribute_number1
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_number2          -- line_gdf_attribute_number2
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_number3          -- line_gdf_attribute_number3
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_number4          -- line_gdf_attribute_number4
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_number5          -- line_gdf_attribute_number5
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_date1            -- line_gdf_attribute_date1
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_date2            -- line_gdf_attribute_date2
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_date3            -- line_gdf_attribute_date3
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_date4            -- line_gdf_attribute_date4
                                          ,StgTable_tbl(ARTrxLines_idx).line_gdf_attribute_date5            -- line_gdf_attribute_date5
                                          ,StgTable_tbl(ARTrxLines_idx).freight_charge                      -- freight_charge
                                          ,StgTable_tbl(ARTrxLines_idx).insurance_charge                    -- insurance_charge
                                          ,StgTable_tbl(ARTrxLines_idx).packing_charge                      -- packing_charge
                                          ,StgTable_tbl(ARTrxLines_idx).miscellaneous_charge                -- miscellaneous_charge
                                          ,StgTable_tbl(ARTrxLines_idx).commercial_discount                 -- commercial_discount
                                          );
                              --
                         --** END FORALL
                         --
                    END LOOP; --** StgTable_cur BULK COLLECT LOOP
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    CLOSE StgTable_cur;
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all AR Invoice Lines in the Migration Set.
                    */
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                         (
                                          gct_XfmSchema
                                         ,ct_XfmTable
                                         ,pt_i_MigrationSetID
                                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' rows copied.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** If there are no simple transforms to be performed for this Sub-entity,
                    ** then set the following Boolean variable to FALSE so that an appropriate
                    ** message is issued to the message log table.
                    **
                    ** If set to TRUE, then:
                    **
                    ** a) Simple transform verification can be performed (we should always verify
                    **    that supporting data required to perform simple transforms has been
                    **    populated into the relevant transformation / lookup tables.
                    ** b) Simple transforms can then be performed if the verification stage is
                    **    completed successfully.
                    ** c) Any other conversions/data enrichment that needs to be done can be
                    **    handled here even if they are not implemented via the Simple Transform
                    **    table and associated functions and procedures.   For example you may
                    **    need to default a value from the XXMX_MIGRATION_PARAMETERS table using
                    **    the XXMX_UTILITIES_PKG.GET_SINGLE_PARAMETER_VALUE function (this falls
                    **    under the Data Enrichment area).
                    */
                    --
                    gvb_SimpleTransformsRequired := TRUE;
                    gvb_DataEnrichmentRequired   := FALSE;
                    --
                    gvv_ProgressIndicator := '0130';
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Performing Simple Transformations and/or Data Enrichment for the "'
                                                       ||pt_i_SubEntity
                                                       ||'" data in the "'
                                                       ||ct_XfmTable
                                                       ||'" table.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Update the XFM table performing all Simple Transforms and/or Data Enrichment for each row.
                         **
                         ** To make the transform process a bit faster for AR Invoices the FOR UPDATE CURSOR has been removed
                         ** and replaced with a number of separate bulk updates to the XFM table (rather than row-by-row) for
                         ** each specific Simple Transform.
                         */
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         vt_MigrationStatus := 'TRANSFORMED';
                         --
                         /*
                         ** First perform perform any Simple Transformation logic.
                         */
                         --
                         IF   gvb_SimpleTransformsRequired
                         THEN
                              --
                              /*
                              ** For AR Invoice Distributions we have to transform Source Operating
                              ** Units to Fusion Business Units and Source Ledger Names to Fusion
                              ** Ledger Names.
                              */
                              --
                              gvv_ProgressIndicator := '0150';
                              --
                              /*
                              ** Transform the Source Operating Units to Fusion Business Units.
                              ** by looping through all DISTINCT Source Operating Units in the
                              ** XFM table and calling the Utilities Package Transform Function
                              ** for each.  We only update the XFM table if a transform is found.
                              */
                              --
                              FOR  SourceOperatingUnit_rec
                              IN   SourceOperatingUnits_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
                                   --
                                   gvv_ProgressIndicator := '0160';
                                   --
                                   xxmx_utilities_pkg.get_fusion_business_unit
                                        (
                                         pt_i_SourceOperatingUnitName => SourceOperatingUnit_rec.source_operating_unit
                                        ,pt_o_FusionBusinessUnitName  => vt_FusionBusinessUnit
                                        ,pt_o_FusionBusinessUnitID    => vt_FusionBusinessUnitID
                                        ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                        ,pt_o_ReturnMessage           => gvt_ReturnMessage
                                        );
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        vt_MigrationStatus := 'SIMPLE_TRANSFORM_FAILED';
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'ERROR'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - '
                                                                      ||gvt_ReturnMessage
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                   ELSE
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '    - Updating XFM table with Fusion Business Unit "'
                                                                      ||vt_FusionBusinessUnit
                                                                      ||'" where Source Operating Unit = "'
                                                                      ||SourceOperatingUnit_rec.source_operating_unit
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        gvv_ProgressIndicator := '0170';
                                        --
                                        UPDATE  xxmx_ar_trx_lines_xfm
                                        SET     migration_status     = vt_MigrationStatus
                                               ,fusion_business_unit = vt_FusionBusinessUnit
                                        WHERE   1 = 1
                                        AND     migration_set_id      = pt_i_MigrationSetID
                                        AND     source_operating_unit = SourceOperatingUnit_rec.source_operating_unit;
                                        --
                                   END IF; --** IF   vt_FusionBusinessUnit IS NULL
                                   --
                              END LOOP; --** SourceOperatingUnits_cur LOOP
                              --
                              --<< Simple transform 2 here >>
                              --
                              --<< Simple transform 3 here >>
                              --
                         END IF; --** IF   gvb_SimpleTransformsRequired
                         --
                         IF   gvb_DataEnrichmentRequired
                         THEN
                              --
                              NULL;
                              --
                         END IF; --** IF   gvb_DataEnrichmentRequired
                         --
                         /*
                         ** Commit the updates for the XFM table.
                         */
                         --
                         COMMIT;
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0180';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '- No Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                       ||pt_i_SubEntity
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF Simple Transforms required or Data Enrichment required.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0190';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Any simple transformations for "'
                                                  ||pt_i_SubEntity
                                                  ||'" data should be performed within '
                                                  ||pt_i_SimpleXfmPerformedBy
                                                  ||'.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               --
               gvv_ProgressIndicator := '0200';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Simple transformation processing completed.'
                    ,pt_i_OracleError       => NULL
                         );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Complex transformation processing initiated.'
                    ,pt_i_OracleError       => NULL
                         );
               --
               /*
               ** If there are no complex transforms to be performed for this Sub-entity,
               ** then set the following Boolean variable to FALSE so that an appropriate
               ** message is issued to the message log table.
               **
               ** If set to TRUE, then:
               **
               ** a) Complex transform verification can be performed (we should always verify
               **    that supporting data required to perform complex transforms has been
               **    populated into the relevant standing data, transformation / lookup
               **    tables.
               ** b) Complex transforms can then be performed if the verification stage is
               **    completed successrfully.
               */
               --
               gvv_ProgressIndicator := '0210';
               --
               gvb_ComplexTransformsRequired := TRUE;
               --
               IF   gvb_ComplexTransformsRequired
               THEN
                    --
                    --<< Any code to check if Complex Transforms are required should be added in here.  Your logic should
                    --<< set gvb_PerformComplexTransforms to TRUE it it determines that a complex transformaion is required.
                    --<<
                    --<< As at this time it is unknown how Complex transforms will be handled for many Sub-Entites.
                    --<<
                    --<< However, if you know that complex rules are required in this procedure then you can simply set the
                    --<< variable to TRUE.
                    --
                    --** For GL Balances, we know that complex transformations can be performed if the "xxmx_gl_account_transforms"
                    --** table has been populated for the Source Ledger.
                    --**
                    --** However, if the client has not completed their reviews of the GL Account Transforms table there may still
                    --** be Account transforms in an unfrozen state (and therefore might not be a correct and final mapping).
                    --**
                    --** We can still perform the transformation process but utilise the MIGRATION_STATUS column to indicate if
                    --** as row was updated with a frozen transform (and therefore should not be rejected duing import into Fusion)
                    --** or if the row was updated with an unfrozen transform and needs to be reviewed in the XFM Table.
                    --**
                    --** The "xxmx_gl_utilities_pkg.verify_gl_account_transforms" procedure will determine the state of GL Account
                    --** transforms for each Source Ledger.
                    --
                    gvv_ProgressIndicator := '0220';
                    --
                    /*
                    ** We are going to recalculate the Transaction Line Item Amounts based
                    ** on the Total Amount Due Remaining for the Transaction.
                    **
                    ** We do this here in the Transformation phase so that the original
                    ** transaction line amounts can be referred back to in the STG table.
                    **
                    ** As there is no complex transformsetup to verify we simply set the
                    ** gvb_PerformComplexTransforms to TRUE to activate the logic section.
                    */
                    --
                    gvb_PerformComplexTransforms := TRUE;
                    --
                    IF   gvb_PerformComplexTransforms
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Performing complex transformations for the "'
                                                       ||pt_i_SubEntity
                                                       ||'" data in the "'
                                                       ||ct_XfmTable
                                                       ||'" table.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Now that all Transaction Lines have been extracted with their
                         ** original Line Amounts, we need to update them with a pro-rated
                         ** value based on the open balance for the Transaction apportioned
                         ** by a ratio equal to the ration that the original line amount
                         ** constituted of the original total transaction amount.
                         **
                         ** This only needs to be performed for partially-paid transactions.
                         **
                         ** This can be done here in the extract process or later in the transform
                         ** process.
                         */
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Re-calculating Transaction Line Amounts based '
                                                       ||'on Total Transaction Amount Due remaining.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0230';
                         --
                         --                                                                                                    PARTIAL PAID TRANSACTIONS
                         --
                         xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                             ,pt_i_Application       => gct_Application
                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                             ,pt_i_SubEntity         => pt_i_SubEntity
                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                             ,pt_i_Phase             => ct_Phase
                             ,pt_i_Severity          => 'NOTIFICATION'
                             ,pt_i_PackageName       => gct_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => 'PARTIAL PAID TRX: start processing the partially paid invoices '
                             ,pt_i_OracleError       => NULL
                             );
                        --
                        FOR  PartiallyPaidTrx_rec IN   PartiallyPaidTrxs_cur(pt_i_MigrationSetID)
                        LOOP
                              --
                              /*
                              ** Count Number of lines in STG table for the Transaction.
                              **
                              ** This is used to determine when we are dealing with the last
                              ** line for the Transaction.
                              */
                              --
                              gvv_ProgressIndicator := '0240';
                              --
                             xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => pt_i_SubEntity
                                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gct_PackageName
                                 ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => 'PARTIAL PAID TRX: processing  '||PartiallyPaidTrx_rec.customer_trx_id
                                 ,pt_i_OracleError       => NULL
                                 );
                            --
                            SELECT COUNT(1)
                              INTO   vn_TrxLineCount
                              FROM   xxmx_ar_trx_lines_xfm
                              WHERE  1 = 1
                              AND    migration_set_id     = pt_i_MigrationSetID
                              AND    xxmx_customer_trx_id = PartiallyPaidTrx_rec.customer_trx_id;
                              --
                              IF   vn_trxLineCount > 0
                              THEN
                                   --
                                   /*
                                   ** Store the Transaction Amount Due Remaining.  This will be reduced
                                   ** line-by-line as the new line amounts are calculated to determine if
                                   ** there is any remaining open balance to account for when the last
                                   ** line has been reached and calculated.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0250';
                                   --
                                   vn_tax_outstanding_amt   := round( PartiallyPaidTrx_rec.tax_original_amt    - ( (PartiallyPaidTrx_rec.tax_original_amt/PartiallyPaidTrx_rec.total_original_amt)*PartiallyPaidTrx_rec.total_paid_amt ) ,2);
                                   vn_lines_outstanding_amt := round( PartiallyPaidTrx_rec.remaining_amt - vn_tax_outstanding_amt ,2);
                                   vn_TxnOpenBalanceRemaining := vn_lines_outstanding_amt;
                                   --
                                    xxmx_utilities_pkg.log_module_message
                                         (
                                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                                         ,pt_i_Application       => gct_Application
                                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                                         ,pt_i_SubEntity         => pt_i_SubEntity
                                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                         ,pt_i_Phase             => ct_Phase
                                         ,pt_i_Severity          => 'NOTIFICATION'
                                         ,pt_i_PackageName       => gct_PackageName
                                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                         ,pt_i_ModuleMessage     => '        - vn_tax_outstanding_amt        = '||vn_tax_outstanding_amt
                                         ,pt_i_OracleError       => NULL
                                         );
                                    --
                                    xxmx_utilities_pkg.log_module_message
                                         (
                                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                                         ,pt_i_Application       => gct_Application
                                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                                         ,pt_i_SubEntity         => pt_i_SubEntity
                                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                         ,pt_i_Phase             => ct_Phase
                                         ,pt_i_Severity          => 'NOTIFICATION'
                                         ,pt_i_PackageName       => gct_PackageName
                                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                         ,pt_i_ModuleMessage     => '        - vn_lines_outstanding_amt        = '||vn_lines_outstanding_amt
                                         ,pt_i_OracleError       => NULL
                                         );
                                    --
                                   --
                                   gvv_ProgressIndicator := '0260';
                                   --
                                   FOR UpdTrxLineAmount_rec
                                   IN  UpdTrxLineAmounts_cur
                                            (
                                             pt_i_MigrationsetID
                                            ,PartiallyPaidTrx_rec.customer_trx_id
                                            )
                                   LOOP
                                        --
                                        /*
                                        ** Calculate what portion of the original transaction amount
                                        ** the original line amount accounts for (as a decimal number
                                        ** e.g. 0.15 this number when multipled by 100 would be a
                                        ** percentage e.g. 15%).
                                        **
                                        ** Rounding will be done on the new line amount.
                                        */
                                        --
                                        gvv_ProgressIndicator := '0270';
                                        --
                                        /*
                                        ** "TAX" Lines are excluded during extract so we need to calculate
                                        ** the new "open" line amount depending on the Line Type "FREIGHT"
                                        ** or "LINE".
                                        */
                                        --
                                        -- Calculate the outstnding TAX  and AMOUNT left to pay
                                        vn_OrigLineAmtRatio :=  UpdTrxLineAmount_rec.original_line_amount / PartiallyPaidTrx_rec.total_original_amt;
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '        - vn_OrigLineAmtRatio        = '||vn_OrigLineAmtRatio
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        /*
                                        ** Calculate the new line amount remaining as a portion of the transaction
                                        ** amount remaining.
                                        **
                                        ** This will be rounded to 2 decimal places.
                                        */
                                        --
                                        gvv_ProgressIndicator := '0280';
                                        --
                                        vn_line_new_outstanding_amt := ROUND((   PartiallyPaidTrx_rec.remaining_amt * vn_OrigLineAmtRatio)  ,2  );
                                        --
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - vn_line_new_outstanding_amt= '||vn_line_new_outstanding_amt
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        /*
                                        ** To calculate if there is any Transaction open balance remaining after
                                        ** new values have been calculated for each line, we subtract the new line
                                        ** amount from the transaction open balance.  Any remainder will be added
                                        ** to the last line.
                                        */
                                        --
                                        gvv_ProgressIndicator := '0290';
                                        --
                                        vn_TxnOpenBalanceRemaining :=   vn_TxnOpenBalanceRemaining - vn_line_new_outstanding_amt;
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - vn_TxnOpenBalanceRemaining   = '||vn_TxnOpenBalanceRemaining
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        /*
                                        ** If we have calculated the new line amount for the last line and
                                        ** if we still have any open balance remaining for the entire
                                        ** Transaction (should only be pennies) then add it to the last line.
                                        **
                                        ** Should the total of the new line amounts turn out to be slightly
                                        ** more then the original open balance remaining, then the transaction
                                        ** open balance remaining variable will be negative so in that case
                                        ** the open balance amount for the last line will be reduced accordingly.
                                        */
                                        --
                                        IF   UpdTrxLineAmount_rec.xxmx_line_number  = vn_TrxLineCount
                                        AND  vn_TxnOpenBalanceRemaining            <> 0
                                        THEN
                                             --
                                             gvv_ProgressIndicator := '0300';
                                             --
                                             vn_line_new_outstanding_amt := vn_line_new_outstanding_amt + vn_TxnOpenBalanceRemaining;
                                             --
                                             --xxmx_utilities_pkg.log_module_message
                                             --     (
                                             --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             --     ,pt_i_Application       => gct_Application
                                             --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             --     ,pt_i_SubEntity         => pt_i_SubEntity
                                             --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             --     ,pt_i_Phase             => ct_Phase
                                             --     ,pt_i_Severity          => 'NOTIFICATION'
                                             --     ,pt_i_PackageName       => gct_PackageName
                                             --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             --     ,pt_i_ModuleMessage     => '      - vn_line_new_outstanding_amt (Updated with rem balance for last line) = '
                                             --                             =||vn_line_new_outstanding_amt
                                             --     ,pt_i_OracleError       => NULL
                                             --     );
                                             --
                                        END IF;
                                        --
                                        gvv_ProgressIndicator := '0310';
                                        --
                                        /*
                                        ** Added 08/07/2021 ISV
                                        **
                                        ** Fusion Import seems to be using the Unit Selling Price * Quantity
                                        ** to determine the Trx Line Amount rather than the TRX_LINE_AMOUNT
                                        ** column itself.
                                        */
                                        --
                                        IF   UpdTrxLineAmount_rec.original_line_quantity > 1
                                        THEN
                                             --
                                             vn_NewUnitSellingPrice := vn_line_new_outstanding_amt / UpdTrxLineAmount_rec.original_line_quantity;
                                             --
                                        ELSE
                                             --
                                             vn_NewUnitSellingPrice := vn_line_new_outstanding_amt;
                                             --
                                        END IF; --** IF UpdTrxLineAmount_rec.original_line_quantity > 1
                                        --
                                        --
                                        UPDATE  xxmx_ar_trx_lines_xfm
                                        SET    trx_line_amount    = vn_line_new_outstanding_amt
                                              ,unit_selling_price = vn_NewUnitSellingPrice
                                        WHERE  1 = 1
                                        AND    migration_set_id          = pt_i_MigrationSetID
                                        AND    xxmx_customer_trx_id      = UpdTrxLineAmount_rec.xxmx_customer_trx_id
                                        AND    xxmx_customer_trx_line_id = UpdTrxLineAmount_rec.xxmx_customer_trx_line_id;
                                        --
                                   END LOOP; --** UpdTrxLineAmounts_cur LOOP
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                                        ,pt_i_Application       => gct_Application
                                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => ct_Phase
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_Severity          => 'ERROR'
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '    - No transaction lines found in "xxmx_ar_trx_lines_xfm" '
                                                                 ||'table for XXMX_CUSTOMER_TRX_ID "'
                                                                 ||PartiallyPaidTrx_rec.customer_trx_id
                                                                 ||'".'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF vn_trxLineCount > 0
                              --
                         END LOOP; --** PartiallyPaidTrxs_cur
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Transaction Line Amount Re-calculation complete.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Commit the complex transformation updates for the XFM table.
                         */
                         --
                         gvv_ProgressIndicator := '0320';
                         --
                         COMMIT;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '- Complex transformation complete.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0330';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'WARNING'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '- Complex transformations are required for Sub-Entity "'
                                                       ||pt_i_SubEntity
                                                       ||'", however they could not be performed due to absent transform data.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF   gvb_PerformComplexTransforms
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0340';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- No complex transformations are required for Sub-Entity "'
                                                  ||pt_i_SubEntity
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF   gvb_ComplexTransformsRequired
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase end if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0350';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => ct_XfmTable
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Transformation Table "'
                                             ||ct_XfmTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          ELSE
               --
               gvv_ProgressIndicator := '0360';
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_MigrationSetID", "pt_i_SubEntity" and "pt_i_SimpleXfmPerformedBy" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0370';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          --
          EXCEPTION
               --
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END ar_trx_lines_xfm;
     --
     --
     /*
     **********************************
     ** PROCEDURE: ar_trx_dists_stg
     **********************************
     */
     --
     PROCEDURE ar_trx_dists_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the detail DISTRIBUTIONS
          --
          CURSOR ARTrxDists_cur
          IS
               --
               --
               SELECT    ROWNUM                                                                            AS row_seq
                        ,rctlgda.customer_trx_id                                                           AS xxmx_customer_trx_id
                        ,rctlgda.customer_trx_line_id                                                      AS xxmx_customer_trx_line_id
                        ,rctlgda.cust_trx_line_gl_dist_id                                                  AS xxmx_cust_trx_line_gl_dist_id
                        ,haou.name                                                                         AS operating_unit
                        ,gl.name                                                                           AS ledger_name
                        ,rctlgda.account_class                                                             AS account_class
                        ,ROUND(rctlgda.amount,2)                                                           AS amount
                        ,NULL                                                                              AS percent
                        ,NULL                                                                              AS accounted_amt_in_ledger_curr
                        ,'AR_GENERIC'                                                                      AS interface_line_context
                        ,hca.account_number                                                                AS interface_line_attribute1
                        ,rcta.trx_number                                                                   AS interface_line_attribute2
                        ,rctla.line_number                                                                 AS interface_line_attribute3
                        ,NULL                                                                              AS interface_line_attribute4
                        ,NULL                                                                              AS interface_line_attribute5
                        ,NULL                                                                              AS interface_line_attribute6
                        ,NULL                                                                              AS interface_line_attribute7
                        ,NULL                                                                              AS interface_line_attribute8
                        ,NULL                                                                              AS interface_line_attribute9
                        ,NULL                                                                              AS interface_line_attribute10
                        ,NULL                                                                              AS interface_line_attribute11
                        ,NULL                                                                              AS interface_line_attribute12
                        ,NULL                                                                              AS interface_line_attribute13
                        ,NULL                                                                              AS interface_line_attribute14
                        ,NULL                                                                              AS interface_line_attribute15
                        ,gcc.segment1                                                                      AS segment1
                        ,gcc.segment2                                                                      AS segment2
                        ,gcc.segment3                                                                      AS segment3
                        ,gcc.segment4                                                                      AS segment4
                        ,gcc.segment5                                                                      AS segment5
                        ,gcc.segment6                                                                      AS segment6
                        ,gcc.segment7                                                                      AS segment7
                        ,gcc.segment8                                                                      AS segment8
                        ,gcc.segment9                                                                      AS segment9
                        ,gcc.segment10                                                                     AS segment10
                        ,gcc.segment11                                                                     AS segment11
                        ,gcc.segment12                                                                     AS segment12
                        ,gcc.segment13                                                                     AS segment13
                        ,gcc.segment14                                                                     AS segment14
                        ,gcc.segment15                                                                     AS segment15
                        ,gcc.segment16                                                                     AS segment16
                        ,gcc.segment17                                                                     AS segment17
                        ,gcc.segment18                                                                     AS segment18
                        ,gcc.segment19                                                                     AS segment19
                        ,gcc.segment20                                                                     AS segment20
                        ,gcc.segment21                                                                     AS segment21
                        ,gcc.segment22                                                                     AS segment22
                        ,gcc.segment23                                                                     AS segment23
                        ,gcc.segment24                                                                     AS segment24
                        ,gcc.segment25                                                                     AS segment25
                        ,gcc.segment26                                                                     AS segment26
                        ,gcc.segment27                                                                     AS segment27
                        ,gcc.segment28                                                                     AS segment28
                        ,gcc.segment29                                                                     AS segment29
                        ,gcc.segment30                                                                     AS segment30
                        ,NULL                                                                              AS comments
                        ,NULL                                                                              AS interim_tax_segment1
                        ,NULL                                                                              AS interim_tax_segment2
                        ,NULL                                                                              AS interim_tax_segment3
                        ,NULL                                                                              AS interim_tax_segment4
                        ,NULL                                                                              AS interim_tax_segment5
                        ,NULL                                                                              AS interim_tax_segment6
                        ,NULL                                                                              AS interim_tax_segment7
                        ,NULL                                                                              AS interim_tax_segment8
                        ,NULL                                                                              AS interim_tax_segment9
                        ,NULL                                                                              AS interim_tax_segment10
                        ,NULL                                                                              AS interim_tax_segment11
                        ,NULL                                                                              AS interim_tax_segment12
                        ,NULL                                                                              AS interim_tax_segment13
                        ,NULL                                                                              AS interim_tax_segment14
                        ,NULL                                                                              AS interim_tax_segment15
                        ,NULL                                                                              AS interim_tax_segment16
                        ,NULL                                                                              AS interim_tax_segment17
                        ,NULL                                                                              AS interim_tax_segment18
                        ,NULL                                                                              AS interim_tax_segment19
                        ,NULL                                                                              AS interim_tax_segment20
                        ,NULL                                                                              AS interim_tax_segment21
                        ,NULL                                                                              AS interim_tax_segment22
                        ,NULL                                                                              AS interim_tax_segment23
                        ,NULL                                                                              AS interim_tax_segment24
                        ,NULL                                                                              AS interim_tax_segment25
                        ,NULL                                                                              AS interim_tax_segment26
                        ,NULL                                                                              AS interim_tax_segment27
                        ,NULL                                                                              AS interim_tax_segment28
                        ,NULL                                                                              AS interim_tax_segment29
                        ,NULL                                                                              AS interim_tax_segment30
                        ,NULL                                                                              AS attribute_category
                        ,NULL                                                                              AS attribute1
                        ,NULL                                                                              AS attribute2
                        ,NULL                                                                              AS attribute3
                        ,NULL                                                                              AS attribute4
                        ,NULL                                                                              AS attribute5
                        ,NULL                                                                              AS attribute6
                        ,NULL                                                                              AS attribute7
                        ,NULL                                                                              AS attribute8
                        ,NULL                                                                              AS attribute9
                        ,NULL                                                                              AS attribute10
                        ,NULL                                                                              AS attribute11
                        ,NULL                                                                              AS attribute12
                        ,NULL                                                                              AS attribute13
                        ,NULL                                                                              AS attribute14
                        ,NULL                                                                              AS attribute15
               FROM      xxmx_ar_trx_scope_v                                           xatsv
                        ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT                    rcta
                        ,apps.ra_customer_trx_lines_all@MXDM_NVIS_EXTRACT              rctla
                        ,apps.ra_cust_trx_line_gl_dist_all@MXDM_NVIS_EXTRACT           rctlgda
                        ,apps.gl_code_combinations@MXDM_NVIS_EXTRACT                   gcc
                        ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT              haou
                        ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT                       hca
                        ,apps.gl_ledgers@MXDM_NVIS_EXTRACT                             gl
               WHERE     1 = 1
               AND       rcta.org_id                   = xatsv.org_id                  /* Invoice Headers to Invoice Scope View Joins      */
               AND       rcta.customer_trx_id          = xatsv.customer_trx_id         /* Invoice Headers to Invoice Scope View Joins      */
               AND       rctla.org_id                  = rcta.org_id                   /* Invoice Lines to Invoice Headers Joins           */
               AND       rctla.customer_trx_id         = rcta.customer_trx_id          /* Invoice Lines to Invoice Headers Joins           */
               AND       rctla.line_type              <> 'TAX'                         /* Invoice Lines to Invoice Headers Joins           */
               AND       rctlgda.org_id                = rctla.org_id                  /* Invoice Line GL Dists Joins to Invoice Lines     */
               AND       rctlgda.customer_trx_id       = rctla.customer_trx_id         /* Invoice Line GL Dists Joins to Invoice Lines     */
               AND       rctlgda.customer_trx_line_id  = rctla.customer_trx_line_id    /* Invoice Line GL Dists Joins to Invoice Lines     */
               AND       rctlgda.account_class         = 'REV'
               --AND       NVL(rctlgda.amount, 0)       <> 0                           /* Zero amount lines are being extracted so we should also extract zero amount distributions */
               AND       gcc.code_combination_id       = rctlgda.code_combination_id   /* GL Code Combination to Invoice Line GL Dist Join */
               AND       haou.organization_id          = rcta.org_id                   /* Operating Unit to Invoice Header Join            */
               AND       hca.cust_account_id           = rcta.bill_to_customer_id      /* Customer Account to Invoice Header Join          */
               AND       gl.ledger_id                  = rctlgda.set_of_books_id;      /* GL Ledger to Invoice Line GL Dist Join           */
          --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ARTrxDists_tt IS TABLE OF ARTrxDists_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_dists_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_trx_dists_stg';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
          ARTrxDists_tbl                  ARTrxDists_tt;
          --
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
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          /*
          ** Delete any MODULE messages from previous executions
          ** for the Business Entity and Business Entity Level
          */
          --
          --** DSF 27/10/2020 - Modified all Utilities Package Procedure/Function Calls to pass new "gct_BusinessEntity" global constant
          --**                  to the "pt_i_BusinessEntity" parameter.
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => pt_i_SubEntity
               ,pt_i_MigrationSetID      => NULL                 -- This is NULL so messages for all previous runs are deleted.
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
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_Severity            => 'ERROR'
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
               ,pt_i_MigrationSetID      => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'DATA'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
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
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
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
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
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
                    ,pt_i_ModuleMessage       => '- Extracting "'
                                                 ||pt_i_SubEntity
                                                 ||'":'
                    ,pt_i_OracleError         => NULL
                    );
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
               --** DSF 27/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application and Business Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               gvv_ProgressIndicator := '0050';
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
                --** Extract the AR Invoices and insert into the staging table.
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
               gvv_ProgressIndicator := '0060';
               --
               OPEN ARTrxDists_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH ARTrxDists_cur
                    BULK COLLECT
                    INTO ARTrxDists_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ARTrxDists_tbl.count=0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FORALL ARTrxDists_idx
                    IN     1..ARTrxDists_tbl.COUNT
                         --
                         INSERT
                         INTO   xxmx_ar_trx_dists_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,row_seq
                                   ,xxmx_customer_trx_id
                                   ,xxmx_customer_trx_line_id
                                   ,xxmx_cust_trx_line_gl_dist_id
                                   ,operating_unit
                                   ,ledger_name
                                   ,account_class
                                   ,amount
                                   ,percent
                                   ,accounted_amt_in_ledger_curr
                                   ,interface_line_context
                                   ,interface_line_attribute1
                                   ,interface_line_attribute2
                                   ,interface_line_attribute3
                                   ,interface_line_attribute4
                                   ,interface_line_attribute5
                                   ,interface_line_attribute6
                                   ,interface_line_attribute7
                                   ,interface_line_attribute8
                                   ,interface_line_attribute9
                                   ,interface_line_attribute10
                                   ,interface_line_attribute11
                                   ,interface_line_attribute12
                                   ,interface_line_attribute13
                                   ,interface_line_attribute14
                                   ,interface_line_attribute15
                                   ,segment1
                                   ,segment2
                                   ,segment3
                                   ,segment4
                                   ,segment5
                                   ,segment6
                                   ,segment7
                                   ,segment8
                                   ,segment9
                                   ,segment10
                                   ,segment11
                                   ,segment12
                                   ,segment13
                                   ,segment14
                                   ,segment15
                                   ,segment16
                                   ,segment17
                                   ,segment18
                                   ,segment19
                                   ,segment20
                                   ,segment21
                                   ,segment22
                                   ,segment23
                                   ,segment24
                                   ,segment25
                                   ,segment26
                                   ,segment27
                                   ,segment28
                                   ,segment29
                                   ,segment30
                                   ,comments
                                   ,interim_tax_segment1
                                   ,interim_tax_segment2
                                   ,interim_tax_segment3
                                   ,interim_tax_segment4
                                   ,interim_tax_segment5
                                   ,interim_tax_segment6
                                   ,interim_tax_segment7
                                   ,interim_tax_segment8
                                   ,interim_tax_segment9
                                   ,interim_tax_segment10
                                   ,interim_tax_segment11
                                   ,interim_tax_segment12
                                   ,interim_tax_segment13
                                   ,interim_tax_segment14
                                   ,interim_tax_segment15
                                   ,interim_tax_segment16
                                   ,interim_tax_segment17
                                   ,interim_tax_segment18
                                   ,interim_tax_segment19
                                   ,interim_tax_segment20
                                   ,interim_tax_segment21
                                   ,interim_tax_segment22
                                   ,interim_tax_segment23
                                   ,interim_tax_segment24
                                   ,interim_tax_segment25
                                   ,interim_tax_segment26
                                   ,interim_tax_segment27
                                   ,interim_tax_segment28
                                   ,interim_tax_segment29
                                   ,interim_tax_segment30
                                   ,attribute_category
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
                                   )
                         VALUES
                                   (
                                    pt_i_MigrationSetID                                                     -- migration_set_id
                                   ,gvt_MigrationSetName                                                    -- migration_set_name
                                   ,'EXTRACTED'                                                             -- migration_status
                                   ,ARTrxDists_tbl(ARTrxDists_idx).row_seq                                  -- row_seq
                                   ,ARTrxDists_tbl(ARTrxDists_idx).xxmx_customer_trx_id                     -- xxmx_customer_trx_id
                                   ,ARTrxDists_tbl(ARTrxDists_idx).xxmx_customer_trx_line_id                -- xxmx_customer_trx_line_id
                                   ,ARTrxDists_tbl(ARTrxDists_idx).xxmx_cust_trx_line_gl_dist_id            -- xxmx_cust_trx_line_gl_dist_id
                                   ,ARTrxDists_tbl(ARTrxDists_idx).operating_unit                           -- operating_unit
                                   ,ARTrxDists_tbl(ARTrxDists_idx).ledger_name                              -- ledger_name
                                   ,ARTrxDists_tbl(ARTrxDists_idx).account_class                            -- account_class
                                   ,ARTrxDists_tbl(ARTrxDists_idx).amount                                   -- amount
                                   ,ARTrxDists_tbl(ARTrxDists_idx).percent                                  -- percent
                                   ,ARTrxDists_tbl(ARTrxDists_idx).accounted_amt_in_ledger_curr             -- accounted_amt_in_ledger_curr
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_context                   -- interface_line_context
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute1                -- line_trans_flex_segment_1
                                   ,SUBSTRB(ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute2,1,30)  -- line_trans_flex_segment_2
                                   ,SUBSTRB(ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute3,1,30)  -- line_trans_flex_segment_3
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute4                -- line_trans_flex_segment_4
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute5                -- line_trans_flex_segment_5
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute6                -- line_trans_flex_segment_6
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute7                -- line_trans_flex_segment_7
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute8                -- line_trans_flex_segment_8
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute9                -- line_trans_flex_segment_9
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute10               -- line_trans_flex_segment_10
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute11               -- line_trans_flex_segment_11
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute12               -- line_trans_flex_segment_12
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute13               -- line_trans_flex_segment_13
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute14               -- line_trans_flex_segment_14
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interface_line_attribute15               -- line_trans_flex_segment_15
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment1                                  -- segment1
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment2                                  -- segment2
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment3                                  -- segment3
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment4                                  -- segment4
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment5                                  -- segment5
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment6                                  -- segment6
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment7                                  -- segment7
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment8                                  -- segment8
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment9                                  -- segment9
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment10                                 -- segment10
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment11                                 -- segment11
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment12                                 -- segment12
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment13                                 -- segment13
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment14                                 -- segment14
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment15                                 -- segment15
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment16                                 -- segment16
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment17                                 -- segment17
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment18                                 -- segment18
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment19                                 -- segment19
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment20                                 -- segment20
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment21                                 -- segment21
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment22                                 -- segment22
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment23                                 -- segment23
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment24                                 -- segment24
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment25                                 -- segment25
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment26                                 -- segment26
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment27                                 -- segment27
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment28                                 -- segment28
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment29                                 -- segment29
                                   ,ARTrxDists_tbl(ARTrxDists_idx).segment30                                 -- segment30
                                   ,ARTrxDists_tbl(ARTrxDists_idx).comments                                  -- comments
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment1                      -- interim_tax_segment_1
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment2                      -- interim_tax_segment_2
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment3                      -- interim_tax_segment_3
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment4                      -- interim_tax_segment_4
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment5                      -- interim_tax_segment_5
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment6                      -- interim_tax_segment_6
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment7                      -- interim_tax_segment_7
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment8                      -- interim_tax_segment_8
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment9                      -- interim_tax_segment_9
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment10                     -- interim_tax_segment_10
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment11                     -- interim_tax_segment_11
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment12                     -- interim_tax_segment_12
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment13                     -- interim_tax_segment_13
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment14                     -- interim_tax_segment_14
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment15                     -- interim_tax_segment_15
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment16                     -- interim_tax_segment_16
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment17                     -- interim_tax_segment_17
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment18                     -- interim_tax_segment_18
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment19                     -- interim_tax_segment_19
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment20                     -- interim_tax_segment_20
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment21                     -- interim_tax_segment_21
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment22                     -- interim_tax_segment_22
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment23                     -- interim_tax_segment_23
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment24                     -- interim_tax_segment_24
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment25                     -- interim_tax_segment_25
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment26                     -- interim_tax_segment_26
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment27                     -- interim_tax_segment_27
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment28                     -- interim_tax_segment_28
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment29                     -- interim_tax_segment_29
                                   ,ARTrxDists_tbl(ARTrxDists_idx).interim_tax_segment30                     -- interim_tax_segment_30
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute_category                        -- attribute_category
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute1                                -- interface_dist_flex_segment_1
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute2                                -- interface_dist_flex_segment_2
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute3                                -- interface_dist_flex_segment_3
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute4                                -- interface_dist_flex_segment_4
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute5                                -- interface_dist_flex_segment_5
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute6                                -- interface_dist_flex_segment_6
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute7                                -- interface_dist_flex_segment_7
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute8                                -- interface_dist_flex_segment_8
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute9                                -- interface_dist_flex_segment_9
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute10                               -- interface_dist_flex_segment_10
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute11                               -- interface_dist_flex_segment_11
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute12                               -- interface_dist_flex_segment_12
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute13                               -- interface_dist_flex_segment_13
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute14                               -- interface_dist_flex_segment_14
                                   ,ARTrxDists_tbl(ARTrxDists_idx).attribute15                               -- interface_dist_flex_segment_15
                                   );
                             --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0100';
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0110';
               --
               CLOSE ARTrxDists_cur;
               --
               /*
               ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               ** is reached.
               */
               --
               gvv_ProgressIndicator := '0120';
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
               gvv_ProgressIndicator := '0130';
               --
               --** ISV 27/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
               --
          ELSE
               --
               gvv_ProgressIndicator := '0140';
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
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
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
                   IF   ARTrxDists_cur%ISOPEN
                   THEN
                        --
                        CLOSE ARTrxDists_cur;
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
               WHEN OTHERS
               THEN
                    --
                    IF   ARTrxDists_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARTrxDists_cur;
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
          --** END Exception Handler
          --
     END ar_trx_dists_stg;
     --
     --
     /*
     **********************************
     ** PROCEDURE: ar_trx_dists_xfm
     **********************************
     */
     --
     PROCEDURE ar_trx_dists_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
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
               SELECT  migration_set_id
                      ,migration_set_name
                      ,migration_status
                      ,row_seq
                      ,xxmx_customer_trx_id
                      ,xxmx_customer_trx_line_id
                      ,xxmx_cust_trx_line_gl_dist_id
                      ,operating_unit
                      ,ledger_name
                      ,account_class
                      ,amount
                      ,percent
                      ,accounted_amt_in_ledger_curr
                      ,interface_line_context
                      ,interface_line_attribute1
                      ,interface_line_attribute2
                      ,interface_line_attribute3
                      ,interface_line_attribute4
                      ,interface_line_attribute5
                      ,interface_line_attribute6
                      ,interface_line_attribute7
                      ,interface_line_attribute8
                      ,interface_line_attribute9
                      ,interface_line_attribute10
                      ,interface_line_attribute11
                      ,interface_line_attribute12
                      ,interface_line_attribute13
                      ,interface_line_attribute14
                      ,interface_line_attribute15
                      ,segment1
                      ,segment2
                      ,segment3
                      ,segment4
                      ,segment5
                      ,segment6
                      ,segment7
                      ,segment8
                      ,segment9
                      ,segment10
                      ,segment11
                      ,segment12
                      ,segment13
                      ,segment14
                      ,segment15
                      ,segment16
                      ,segment17
                      ,segment18
                      ,segment19
                      ,segment20
                      ,segment21
                      ,segment22
                      ,segment23
                      ,segment24
                      ,segment25
                      ,segment26
                      ,segment27
                      ,segment28
                      ,segment29
                      ,segment30
                      ,comments
                      ,interim_tax_segment1
                      ,interim_tax_segment2
                      ,interim_tax_segment3
                      ,interim_tax_segment4
                      ,interim_tax_segment5
                      ,interim_tax_segment6
                      ,interim_tax_segment7
                      ,interim_tax_segment8
                      ,interim_tax_segment9
                      ,interim_tax_segment10
                      ,interim_tax_segment11
                      ,interim_tax_segment12
                      ,interim_tax_segment13
                      ,interim_tax_segment14
                      ,interim_tax_segment15
                      ,interim_tax_segment16
                      ,interim_tax_segment17
                      ,interim_tax_segment18
                      ,interim_tax_segment19
                      ,interim_tax_segment20
                      ,interim_tax_segment21
                      ,interim_tax_segment22
                      ,interim_tax_segment23
                      ,interim_tax_segment24
                      ,interim_tax_segment25
                      ,interim_tax_segment26
                      ,interim_tax_segment27
                      ,interim_tax_segment28
                      ,interim_tax_segment29
                      ,interim_tax_segment30
                      ,attribute_category
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
               FROM    xxmx_ar_trx_dists_stg
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               AND     migration_status = 'EXTRACTED';
               --
          --** END CURSOR StgTable_cur
          --
          CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoice_lines_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  migration_set_id
                      ,migration_set_name
                      ,migration_status
                      ,row_seq
                      ,xxmx_customer_trx_id
                      ,xxmx_customer_trx_line_id
                      ,xxmx_cust_trx_line_gl_dist_id
                      ,source_operating_unit
                      ,fusion_business_unit
                      ,source_ledger_name
                      ,fusion_ledger_name
                      ,account_class
                      ,amount
                      ,xxmx_orig_amount
                      ,percent
                      ,accounted_amt_in_ledger_curr
                      ,interface_line_context
                      ,interface_line_attribute1
                      ,interface_line_attribute2
                      ,interface_line_attribute3
                      ,interface_line_attribute4
                      ,interface_line_attribute5
                      ,interface_line_attribute6
                      ,interface_line_attribute7
                      ,interface_line_attribute8
                      ,interface_line_attribute9
                      ,interface_line_attribute10
                      ,interface_line_attribute11
                      ,interface_line_attribute12
                      ,interface_line_attribute13
                      ,interface_line_attribute14
                      ,interface_line_attribute15
                      ,segment1
                      ,segment2
                      ,segment3
                      ,segment4
                      ,segment5
                      ,segment6
                      ,segment7
                      ,segment8
                      ,segment9
                      ,segment10
                      ,segment11
                      ,segment12
                      ,segment13
                      ,segment14
                      ,segment15
                      ,segment16
                      ,segment17
                      ,segment18
                      ,segment19
                      ,segment20
                      ,segment21
                      ,segment22
                      ,segment23
                      ,segment24
                      ,segment25
                      ,segment26
                      ,segment27
                      ,segment28
                      ,segment29
                      ,segment30
                      ,comments
                      ,interim_tax_segment1
                      ,interim_tax_segment2
                      ,interim_tax_segment3
                      ,interim_tax_segment4
                      ,interim_tax_segment5
                      ,interim_tax_segment6
                      ,interim_tax_segment7
                      ,interim_tax_segment8
                      ,interim_tax_segment9
                      ,interim_tax_segment10
                      ,interim_tax_segment11
                      ,interim_tax_segment12
                      ,interim_tax_segment13
                      ,interim_tax_segment14
                      ,interim_tax_segment15
                      ,interim_tax_segment16
                      ,interim_tax_segment17
                      ,interim_tax_segment18
                      ,interim_tax_segment19
                      ,interim_tax_segment20
                      ,interim_tax_segment21
                      ,interim_tax_segment22
                      ,interim_tax_segment23
                      ,interim_tax_segment24
                      ,interim_tax_segment25
                      ,interim_tax_segment26
                      ,interim_tax_segment27
                      ,interim_tax_segment28
                      ,interim_tax_segment29
                      ,interim_tax_segment30
                      ,attribute_category
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
               FROM    xxmx_ar_trx_dists_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
          --
          CURSOR SourceOperatingUnits_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_dists_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT source_operating_unit
               FROM    xxmx_ar_trx_dists_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID;
               --
          --** END CURSOR SourceOperatingUnits_cur
          --
          CURSOR SourceLedgerNames_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_dists_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT source_ledger_name
               FROM    xxmx_ar_trx_dists_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID;
               --
          --** END CURSOR SourceLedgerNames_cur
          --
          --CURSOR SourceOpUnitDefaultAccts_cur
          --            (
          --             pt_MigrationSetID               xxmx_ar_trx_dists_xfm.migration_set_id%TYPE
          --            )
          --IS
          --     --
          --     SELECT  DISTINCT
          --             xsou.source_operating_unit_name
          --            ,xrcidx.fusion_ledger_name
          --            ,xsou.ar_trx_fusion_clearing_acct   AS default_account_code
          --     FROM    xxmx_ar_trx_dists_xfm        xrcidx
          --            ,xxmx_source_operating_units  xsou
          --     WHERE   1 = 1
          --     AND     xrcidx.migration_set_id          = pt_MigrationSetID
          --     AND     xrcidx.fusion_ledger_name       IS NOT NULL
          --     AND     xsou.source_operating_unit_name  = xrcidx.source_operating_unit;
          --     --
          ----** END CURSOR SourceOpUnitDefaultAccts_cur
          --
          CURSOR SourceDistAccts_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_dists_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT    xatdx.row_seq
                        ,xatdx.xxmx_customer_trx_id
                        ,xatdx.xxmx_customer_trx_line_id
                        ,xatdx.xxmx_cust_trx_line_gl_dist_id
                        ,xatdx.migration_status
                        ,xatdx.source_ledger_name
                        ,xatdx.segment1
                        ,xatdx.segment2
                        ,xatdx.segment3
                        ,xatdx.segment4
                        ,xatdx.segment5
                        ,xatdx.segment6
                        ,xatdx.segment7
                        ,xatdx.segment8
                        ,xatdx.segment9
                        ,xatdx.segment10
                        ,xatdx.segment11
                        ,xatdx.segment12
                        ,xatdx.segment13
                        ,xatdx.segment14
                        ,xatdx.segment15
                        ,xatdx.segment16
                        ,xatdx.segment17
                        ,xatdx.segment18
                        ,xatdx.segment19
                        ,xatdx.segment20
                        ,xatdx.segment21
                        ,xatdx.segment22
                        ,xatdx.segment23
                        ,xatdx.segment24
                        ,xatdx.segment25
                        ,xatdx.segment26
                        ,xatdx.segment27
                        ,xatdx.segment28
                        ,xatdx.segment29
                        ,xatdx.segment30
               FROM      xxmx_ar_trx_dists_xfm   xatdx
               WHERE     1 = 1
               AND       xatdx.migration_set_id  = pt_MigrationSetID
               AND       xatdx.migration_status  = 'EXTRACTED'
               FOR UPDATE;
               --
          --** END CURSOR SourceDistAccts_cur
          --
          CURSOR PartiallyPaidTrxLines_cur
                      (
                       pt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE
                      )

          IS
               --
               SELECT  DISTINCT
                       xatlx.xxmx_customer_trx_id
                      ,xatlx.xxmx_customer_trx_line_id
                      ,xatlx.trx_number
                      ,xatlx.xxmx_line_number
                      ,xatlx.trx_line_amount            AS updated_line_amount
                      ,xatlx.xxmx_orig_trx_line_amount
               FROM    xxmx_ar_trx_lines_xfm  xatlx
                      ,xxmx_ar_trx_scope_v    xatsv
               WHERE   1 = 1
               AND     xatlx.migration_set_id    = pt_MigrationSetID
               AND     xatlx.trx_line_amount    <> 0
               AND     xatsv.customer_trx_id     = xatlx.xxmx_customer_trx_id  /* CUSTOMER_TRX_ID Join from XFM table to Scope View */
               AND     xatsv.partially_paid_flag = 'Y'
               ORDER BY  xatlx.xxmx_customer_trx_id
                        ,xatlx.xxmx_line_number;
               --
          --** END CURSOR PartiallyPaidTrxs_cur
          --
          CURSOR UpdTrxDistAmounts_cur
                      (
                       pt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE
                      ,pn_CustomerTrxID                NUMBER
                      ,pn_CustomerTrxLineID            NUMBER
                      )
          IS
               --
               SELECT    xatdx.xxmx_customer_trx_id
                        ,xatdx.xxmx_customer_trx_line_id
                        ,xatdx.xxmx_cust_trx_line_gl_dist_id
                        ,xatdx.xxmx_orig_amount               AS original_dist_amount
               FROM      xxmx_ar_trx_dists_xfm  xatdx
               WHERE     1 = 1
               AND       xatdx.migration_set_id          = pt_MigrationSetID
               AND       xatdx.amount                   <> 0
               AND       xatdx.amount                    = xatdx.xxmx_orig_amount /* Distribution amount has not been updated previously */
               AND       xatdx.xxmx_customer_trx_id      = pn_CustomerTrxID
               AND       xatdx.xxmx_customer_trx_line_id = pn_CustomerTrxLineID
               ORDER BY  
                        xatdx.xxmx_cust_trx_line_gl_dist_id;
               --
          --** END CURSOR UpdTrxDistAmounts_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE stg_table_tt IS TABLE OF StgTable_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_dists_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_dists_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_dists_xfm';
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
          vt_MigrationStatus              xxmx_ar_trx_dists_xfm.migration_status%TYPE;
          vt_FusionBusinessUnit           xxmx_ar_trx_dists_xfm.fusion_business_unit%TYPE;
          vt_FusionBusinessUnitID         xxmx_source_operating_units.fusion_business_unit_id%TYPE;
          vt_FusionLedgerName             xxmx_ar_trx_dists_xfm.fusion_ledger_name%TYPE;
          vv_SourceOrFusionAccount        VARCHAR2(6);
          vt_FusionClearingAccount        xxmx_source_operating_units.ar_trx_fusion_clearing_acct%TYPE;
          vt_AccountEvaluationMsg         xxmx_data_messages.data_message%TYPE;
          vt_NewSegment1                  xxmx_ar_trx_dists_xfm.segment1%TYPE;
          vt_NewSegment2                  xxmx_ar_trx_dists_xfm.segment2%TYPE;
          vt_NewSegment3                  xxmx_ar_trx_dists_xfm.segment3%TYPE;
          vt_NewSegment4                  xxmx_ar_trx_dists_xfm.segment4%TYPE;
          vt_NewSegment5                  xxmx_ar_trx_dists_xfm.segment5%TYPE;
          vt_NewSegment6                  xxmx_ar_trx_dists_xfm.segment6%TYPE;
          vt_NewSegment7                  xxmx_ar_trx_dists_xfm.segment7%TYPE;
          vt_NewSegment8                  xxmx_ar_trx_dists_xfm.segment8%TYPE;
          vt_NewSegment9                  xxmx_ar_trx_dists_xfm.segment9%TYPE;
          vt_NewSegment10                 xxmx_ar_trx_dists_xfm.segment10%TYPE;
          vt_NewSegment11                 xxmx_ar_trx_dists_xfm.segment11%TYPE;
          vt_NewSegment12                 xxmx_ar_trx_dists_xfm.segment12%TYPE;
          vt_NewSegment13                 xxmx_ar_trx_dists_xfm.segment13%TYPE;
          vt_NewSegment14                 xxmx_ar_trx_dists_xfm.segment14%TYPE;
          vt_NewSegment15                 xxmx_ar_trx_dists_xfm.segment15%TYPE;
          vt_NewSegment16                 xxmx_ar_trx_dists_xfm.segment16%TYPE;
          vt_NewSegment17                 xxmx_ar_trx_dists_xfm.segment17%TYPE;
          vt_NewSegment18                 xxmx_ar_trx_dists_xfm.segment18%TYPE;
          vt_NewSegment19                 xxmx_ar_trx_dists_xfm.segment19%TYPE;
          vt_NewSegment20                 xxmx_ar_trx_dists_xfm.segment20%TYPE;
          vt_NewSegment21                 xxmx_ar_trx_dists_xfm.segment21%TYPE;
          vt_NewSegment22                 xxmx_ar_trx_dists_xfm.segment22%TYPE;
          vt_NewSegment23                 xxmx_ar_trx_dists_xfm.segment23%TYPE;
          vt_NewSegment24                 xxmx_ar_trx_dists_xfm.segment24%TYPE;
          vt_NewSegment25                 xxmx_ar_trx_dists_xfm.segment25%TYPE;
          vt_NewSegment26                 xxmx_ar_trx_dists_xfm.segment26%TYPE;
          vt_NewSegment27                 xxmx_ar_trx_dists_xfm.segment27%TYPE;
          vt_NewSegment28                 xxmx_ar_trx_dists_xfm.segment28%TYPE;
          vt_NewSegment29                 xxmx_ar_trx_dists_xfm.segment29%TYPE;
          vt_NewSegment30                 xxmx_ar_trx_dists_xfm.segment30%TYPE;
          vt_FusionConcatenatedSegments   xxmx_gl_account_transforms.fusion_concatenated_segments%TYPE;
          vt_RecordIdentifiers            xxmx_data_messages.record_identifiers%TYPE;
          vt_DataElementsAndValues        xxmx_data_messages.data_elements_and_values%TYPE;
          vn_TrxLineBalanceRemaining      NUMBER;
          vn_LastTrxLineDistID            NUMBER;
          vn_OrigDistAmtRatio             NUMBER;
          vn_NewDistRemainingAmount       NUMBER;
          vn_tax_outstanding_amt            NUMBER;         -- The tax outstanding amount after deducting its ration from the amount paid
          vn_lines_outstanding_amt            NUMBER;       -- total lines outstanding amount where we taken out the tax value
          vn_tax_outstanding_amt            NUMBER;         -- The tax outstanding amount after deducting its ration from the amount paid
          vn_lines_outstanding_amt            NUMBER;       -- total lines outstanding amount where we taken out the tax value
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
          gvv_ProgressIndicator := '0020';
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
          AND  pt_i_SimpleXfmPerformedBy IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               IF   NOT xxmx_utilities_pkg.valid_lookup_code
                         (
                          'TRANSFORM_PERFORMERS'
                         ,UPPER(pt_i_SimpleXfmPerformedBy)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '- "pt_i_SimpleXfmPerformedBy" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "TRANSFORM_PERFORMERS".';
                    --
                    RAISE e_ModuleError;
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
                         ,pt_i_ModuleMessage       => '- Simple transformation processing is performed by '
                                                    ||UPPER(pt_i_SimpleXfmPerformedBy)
                                                                 ||'.'
                         ,pt_i_OracleError         => NULL
                              );
                    --
                    --
               END IF; --** IF   NOT xxmx_utilities_pkg.valid_lookup_code
               --
               vd_TransformStartDate := SYSDATE;
               --
               gvv_ProgressIndicator := '0060';
               --
               IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               THEN
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
                         ,pt_i_ModuleMessage       => '  - Deleting existing data from the '
                                                    ||ct_XfmTable
                                                    ||' table for Migration Set ID "'
                                                    ||pt_i_MigrationSetID
                                                    ||'".'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    DELETE
                    FROM   xxmx_ar_trx_dists_xfm
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID;
                    --
                    gvn_RowCount := SQL%ROWCOUNT;
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
                         ,pt_i_ModuleMessage       => '    - '
                                                    ||gvn_RowCount
                                                    ||' rows deleted.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    /*
                    ** For Simple Transformations being performed by PL/SQL the data must be moved
                    ** from the STG table to the XFM table as-is.
                    **
                    ** The data is then transformed vertically with several updates across all rows.
                    **
                    ** Any simple transforms are performed first followed by any complex transforms.
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
                         ,pt_i_ModuleMessage       => '  - Copying "'
                                                    ||pt_i_SubEntity
                                                    ||'" data from the "'
                                                    ||ct_StgTable
                                                    ||'" table to the "'
                                                    ||ct_XfmTable
                                                    ||'" table prior to simple transformation '
                                                    ||'(transformation processing is all by PL/SQL '
                                                    ||'for this Sub-entity).'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    /*
                    ** Copy the data from the STG table to the XFM Table.
                    */
                    --
                    OPEN StgTable_cur
                              (
                               pt_i_MigrationSetID
                              );
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    LOOP
                         --
                         gvv_ProgressIndicator := '0090';
                         --
                         FETCH        StgTable_cur
                         BULK COLLECT
                         INTO         StgTable_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    StgTable_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         FORALL ARTrxDists_idx
                         IN     1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_ar_trx_dists_xfm
                                          (
                                           migration_set_id
                                          ,migration_set_name
                                          ,migration_status
                                          ,row_seq
                                          ,xxmx_customer_trx_id
                                          ,xxmx_customer_trx_line_id
                                          ,xxmx_cust_trx_line_gl_dist_id
                                          ,source_operating_unit
                                          ,fusion_business_unit
                                          ,source_ledger_name
                                          ,fusion_ledger_name
                                          ,account_class
                                          ,amount
                                          ,xxmx_orig_amount
                                          ,percent
                                          ,accounted_amt_in_ledger_curr
                                          ,interface_line_context
                                          ,interface_line_attribute1
                                          ,interface_line_attribute2
                                          ,interface_line_attribute3
                                          ,interface_line_attribute4
                                          ,interface_line_attribute5
                                          ,interface_line_attribute6
                                          ,interface_line_attribute7
                                          ,interface_line_attribute8
                                          ,interface_line_attribute9
                                          ,interface_line_attribute10
                                          ,interface_line_attribute11
                                          ,interface_line_attribute12
                                          ,interface_line_attribute13
                                          ,interface_line_attribute14
                                          ,interface_line_attribute15
                                          ,segment1
                                          ,segment2
                                          ,segment3
                                          ,segment4
                                          ,segment5
                                          ,segment6
                                          ,segment7
                                          ,segment8
                                          ,segment9
                                          ,segment10
                                          ,segment11
                                          ,segment12
                                          ,segment13
                                          ,segment14
                                          ,segment15
                                          ,segment16
                                          ,segment17
                                          ,segment18
                                          ,segment19
                                          ,segment20
                                          ,segment21
                                          ,segment22
                                          ,segment23
                                          ,segment24
                                          ,segment25
                                          ,segment26
                                          ,segment27
                                          ,segment28
                                          ,segment29
                                          ,segment30
                                          ,comments
                                          ,interim_tax_segment1
                                          ,interim_tax_segment2
                                          ,interim_tax_segment3
                                          ,interim_tax_segment4
                                          ,interim_tax_segment5
                                          ,interim_tax_segment6
                                          ,interim_tax_segment7
                                          ,interim_tax_segment8
                                          ,interim_tax_segment9
                                          ,interim_tax_segment10
                                          ,interim_tax_segment11
                                          ,interim_tax_segment12
                                          ,interim_tax_segment13
                                          ,interim_tax_segment14
                                          ,interim_tax_segment15
                                          ,interim_tax_segment16
                                          ,interim_tax_segment17
                                          ,interim_tax_segment18
                                          ,interim_tax_segment19
                                          ,interim_tax_segment20
                                          ,interim_tax_segment21
                                          ,interim_tax_segment22
                                          ,interim_tax_segment23
                                          ,interim_tax_segment24
                                          ,interim_tax_segment25
                                          ,interim_tax_segment26
                                          ,interim_tax_segment27
                                          ,interim_tax_segment28
                                          ,interim_tax_segment29
                                          ,interim_tax_segment30
                                          ,attribute_category
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
                                          )
                              VALUES
                                          (
                                           StgTable_tbl(ARTrxDists_idx).migration_set_id                -- migration_set_id
                                          ,StgTable_tbl(ARTrxDists_idx).migration_set_name              -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                        -- migration_status
                                          ,StgTable_tbl(ARTrxDists_idx).row_seq                         -- row_seq
                                          ,StgTable_tbl(ARTrxDists_idx).xxmx_customer_trx_id            -- xxmx_customer_trx_id
                                          ,StgTable_tbl(ARTrxDists_idx).xxmx_customer_trx_line_id       -- xxmx_customer_trx_line_id
                                          ,StgTable_tbl(ARTrxDists_idx).xxmx_cust_trx_line_gl_dist_id   -- xxmx_cust_trx_line_gl_dist_id
                                          ,StgTable_tbl(ARTrxDists_idx).operating_unit                  -- source_operating_unit
                                          ,NULL                                                         -- fusion_business_unit
                                          ,StgTable_tbl(ARTrxDists_idx).ledger_name                     -- source_ledger_name
                                          ,NULL                                                         -- fusion_ledger_name
                                          ,StgTable_tbl(ARTrxDists_idx).account_class                   -- account_class
                                          ,StgTable_tbl(ARTrxDists_idx).amount                          -- amount
                                          ,StgTable_tbl(ARTrxDists_idx).amount                          -- xxmx_orig_amount
                                          ,StgTable_tbl(ARTrxDists_idx).percent                         -- percent
                                          ,StgTable_tbl(ARTrxDists_idx).accounted_amt_in_ledger_curr    -- accounted_amt_in_ledger_curr
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_context          -- interface_line_context
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute1       -- interface_line_attribute1
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute2       -- interface_line_attribute2
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute3       -- interface_line_attribute3
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute4       -- interface_line_attribute4
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute5       -- interface_line_attribute5
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute6       -- interface_line_attribute6
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute7       -- interface_line_attribute7
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute8       -- interface_line_attribute8
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute9       -- interface_line_attribute9
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute10      -- interface_line_attribute10
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute11      -- interface_line_attribute11
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute12      -- interface_line_attribute12
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute13      -- interface_line_attribute13
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute14      -- interface_line_attribute14
                                          ,StgTable_tbl(ARTrxDists_idx).interface_line_attribute15      -- interface_line_attribute15
                                          ,StgTable_tbl(ARTrxDists_idx).segment1                        -- segment1
                                          ,StgTable_tbl(ARTrxDists_idx).segment2                        -- segment2
                                          ,StgTable_tbl(ARTrxDists_idx).segment3                        -- segment3
                                          ,StgTable_tbl(ARTrxDists_idx).segment4                        -- segment4
                                          ,StgTable_tbl(ARTrxDists_idx).segment5                        -- segment5
                                          ,StgTable_tbl(ARTrxDists_idx).segment6                        -- segment6
                                          ,StgTable_tbl(ARTrxDists_idx).segment7                        -- segment7
                                          ,StgTable_tbl(ARTrxDists_idx).segment8                        -- segment8
                                          ,StgTable_tbl(ARTrxDists_idx).segment9                        -- segment9
                                          ,StgTable_tbl(ARTrxDists_idx).segment10                       -- segment10
                                          ,StgTable_tbl(ARTrxDists_idx).segment11                       -- segment11
                                          ,StgTable_tbl(ARTrxDists_idx).segment12                       -- segment12
                                          ,StgTable_tbl(ARTrxDists_idx).segment13                       -- segment13
                                          ,StgTable_tbl(ARTrxDists_idx).segment14                       -- segment14
                                          ,StgTable_tbl(ARTrxDists_idx).segment15                       -- segment15
                                          ,StgTable_tbl(ARTrxDists_idx).segment16                       -- segment16
                                          ,StgTable_tbl(ARTrxDists_idx).segment17                       -- segment17
                                          ,StgTable_tbl(ARTrxDists_idx).segment18                       -- segment18
                                          ,StgTable_tbl(ARTrxDists_idx).segment19                       -- segment19
                                          ,StgTable_tbl(ARTrxDists_idx).segment20                       -- segment20
                                          ,StgTable_tbl(ARTrxDists_idx).segment21                       -- segment21
                                          ,StgTable_tbl(ARTrxDists_idx).segment22                       -- segment22
                                          ,StgTable_tbl(ARTrxDists_idx).segment23                       -- segment23
                                          ,StgTable_tbl(ARTrxDists_idx).segment24                       -- segment24
                                          ,StgTable_tbl(ARTrxDists_idx).segment25                       -- segment25
                                          ,StgTable_tbl(ARTrxDists_idx).segment26                       -- segment26
                                          ,StgTable_tbl(ARTrxDists_idx).segment27                       -- segment27
                                          ,StgTable_tbl(ARTrxDists_idx).segment28                       -- segment28
                                          ,StgTable_tbl(ARTrxDists_idx).segment29                       -- segment29
                                          ,StgTable_tbl(ARTrxDists_idx).segment30                       -- segment30
                                          ,StgTable_tbl(ARTrxDists_idx).comments                        -- comments
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment1            -- interim_tax_segment1
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment2            -- interim_tax_segment2
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment3            -- interim_tax_segment3
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment4            -- interim_tax_segment4
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment5            -- interim_tax_segment5
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment6            -- interim_tax_segment6
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment7            -- interim_tax_segment7
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment8            -- interim_tax_segment8
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment9            -- interim_tax_segment9
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment10           -- interim_tax_segment10
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment11           -- interim_tax_segment11
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment12           -- interim_tax_segment12
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment13           -- interim_tax_segment13
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment14           -- interim_tax_segment14
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment15           -- interim_tax_segment15
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment16           -- interim_tax_segment16
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment17           -- interim_tax_segment17
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment18           -- interim_tax_segment18
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment19           -- interim_tax_segment19
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment20           -- interim_tax_segment20
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment21           -- interim_tax_segment21
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment22           -- interim_tax_segment22
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment23           -- interim_tax_segment23
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment24           -- interim_tax_segment24
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment25           -- interim_tax_segment25
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment26           -- interim_tax_segment26
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment27           -- interim_tax_segment27
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment28           -- interim_tax_segment28
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment29           -- interim_tax_segment29
                                          ,StgTable_tbl(ARTrxDists_idx).interim_tax_segment30           -- interim_tax_segment30
                                          ,StgTable_tbl(ARTrxDists_idx).attribute_category              -- attribute_category
                                          ,StgTable_tbl(ARTrxDists_idx).attribute1                      -- attribute1
                                          ,StgTable_tbl(ARTrxDists_idx).attribute2                      -- attribute2
                                          ,StgTable_tbl(ARTrxDists_idx).attribute3                      -- attribute3
                                          ,StgTable_tbl(ARTrxDists_idx).attribute4                      -- attribute4
                                          ,StgTable_tbl(ARTrxDists_idx).attribute5                      -- attribute5
                                          ,StgTable_tbl(ARTrxDists_idx).attribute6                      -- attribute6
                                          ,StgTable_tbl(ARTrxDists_idx).attribute7                      -- attribute7
                                          ,StgTable_tbl(ARTrxDists_idx).attribute8                      -- attribute8
                                          ,StgTable_tbl(ARTrxDists_idx).attribute9                      -- attribute9
                                          ,StgTable_tbl(ARTrxDists_idx).attribute10                     -- attribute10
                                          ,StgTable_tbl(ARTrxDists_idx).attribute11                     -- attribute11
                                          ,StgTable_tbl(ARTrxDists_idx).attribute12                     -- attribute12
                                          ,StgTable_tbl(ARTrxDists_idx).attribute13                     -- attribute13
                                          ,StgTable_tbl(ARTrxDists_idx).attribute14                     -- attribute14
                                          ,StgTable_tbl(ARTrxDists_idx).attribute15                     -- attribute15
                                          );
                              --
                         --** END FORALL
                         --
                    END LOOP; --** StgTable_cur BULK COLLECT LOOP
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    CLOSE StgTable_cur;
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all AR Invoice Distributions in the Migration Set.
                    */
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                         (
                                          gct_XfmSchema
                                         ,ct_XfmTable
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
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - '
                                                    ||gvn_RowCount
                                                    ||' rows copied.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    /*
                    ** If there are no simple transforms to be performed for this Sub-entity,
                    ** then set the following Boolean variable to FALSE so that an appropriate
                    ** message is issued to the message log table.
                    **
                    ** If set to TRUE, then:
                    **
                    ** a) Simple transform verification can be performed (we should always verify
                    **    that supporting data required to perform simple transforms has been
                    **    populated into the relevant transformation / lookup tables.
                    ** b) Simple transforms can then be performed if the verification stage is
                    **    completed successfully.
                    ** c) Any other conversions/data enrichment that needs to be done can be
                    **    handled here even if they are not implemented via the Simple Transform
                    **    table and associated functions and procedures.   For example you may
                    **    need to default a value from the XXMX_MIGRATION_PARAMETERS table using
                    **    the XXMX_UTILITIES_PKG.GET_SINGLE_PARAMETER_VALUE function (this falls
                    **    under the Data Enrichment area).
                    */
                    --
                    /*
                    ** For AR Invoice Distributions we do not have any Simple Transformations, but we do need
                    ** to perform Data Enrichment to default values for the GL Account.  However that is
                    ** handled in the complex transforms section.
                    */
                    --
                    gvb_SimpleTransformsRequired := TRUE;
                    gvb_DataEnrichmentRequired   := FALSE;
                    --
                    gvv_ProgressIndicator := '0130';
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gct_BusinessEntity
                              ,pt_i_SubEntity           => pt_i_SubEntity
                              ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gct_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '    - Performing Simple Transformations and/or Data Enrichment for the "'
                                                         ||pt_i_SubEntity
                                                         ||'" data in the "'
                                                         ||ct_XfmTable
                                                         ||'" table.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         /*
                         ** Update the XFM table performing all Simple Transforms and/or Data Enrichment for each row.
                         **
                         ** To make the transform process a bit faster for AR Invoices the FOR UPDATE CURSOR has been removed
                         ** and replaced with a number of separate bulk updates to the XFM table (rather than row-by-row) for
                         ** each specific Simple Transform.
                         */
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         vt_MigrationStatus := 'TRANSFORMED';
                         --
                         /*
                         ** First perform perform any Simple Transformation logic.
                         */
                         --
                         IF   gvb_SimpleTransformsRequired
                         THEN
                              --
                              /*
                              ** For AR Invoice Distributions we have to transform Source Operating
                              ** Units to Fusion Business Units and Source Ledger Names to Fusion
                              ** Ledger Names.
                              */
                              gvv_ProgressIndicator := '0150';
                              --
                              /*
                              ** Transform the Source Operating Units to Fusion Business Units.
                              ** by looping through all DISTINCT Source Operating Units in the
                              ** XFM table and calling the Utilities Package Transform Function
                              ** for each.  We only update the XFM table if a transform is found.
                              */
                              --
                              FOR  SourceOperatingUnit_rec
                              IN   SourceOperatingUnits_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
                                   --
                                   gvv_ProgressIndicator := '0160';
                                   --
                                   xxmx_utilities_pkg.get_fusion_business_unit
                                        (
                                         pt_i_SourceOperatingUnitName => SourceOperatingUnit_rec.source_operating_unit
                                        ,pt_o_FusionBusinessUnitName  => vt_FusionBusinessUnit
                                        ,pt_o_FusionBusinessUnitID    => vt_FusionBusinessUnitID
                                        ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                        ,pt_o_ReturnMessage           => gvt_ReturnMessage
                                        );
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        vt_MigrationStatus := 'SIMPLE_TRANSFORM_FAILED';
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                                             ,pt_i_Application         => gct_Application
                                             ,pt_i_BusinessEntity      => gct_BusinessEntity
                                             ,pt_i_SubEntity           => pt_i_SubEntity
                                             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                                             ,pt_i_Phase               => ct_Phase
                                             ,pt_i_Severity            => 'ERROR'
                                             ,pt_i_PackageName         => gct_PackageName
                                             ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage       => '        - '
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
                                             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                                             ,pt_i_Phase               => ct_Phase
                                             ,pt_i_Severity            => 'NOTIFICATION'
                                             ,pt_i_PackageName         => gct_PackageName
                                             ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage       => '      - Updating XFM table with Fusion Business Unit "'
                                                                        ||vt_FusionBusinessUnit
                                                                        ||'" where Source Operating Unit = "'
                                                                        ||SourceOperatingUnit_rec.source_operating_unit
                                                                        ||'".'
                                             ,pt_i_OracleError         => NULL
                                             );
                                        --
                                        gvv_ProgressIndicator := '0170';
                                        --
                                        UPDATE  xxmx_ar_trx_dists_xfm
                                        SET     migration_status     = vt_MigrationStatus
                                               ,fusion_business_unit = vt_FusionBusinessUnit
                                        WHERE   1 = 1
                                        AND     migration_set_id      = pt_i_MigrationSetID
                                        AND     source_operating_unit = SourceOperatingUnit_rec.source_operating_unit;
                                        --
                                   END IF; --** IF   vt_FusionBusinessUnit IS NULL
                                   --
                              END LOOP; --** SourceOperatingUnits_cur LOOP
                              --
                              /*
                              ** Transform the Source Ledger Names to Fusion Ledger Names.
                              ** by looping through all DISTINCT Source Ledger Names in the
                              ** XFM table and calling the Utilities Package Transform Function
                              ** for each.  Again, we only update the XFM table if a transform is found.
                              */
                              --
                              gvv_ProgressIndicator := '0180';
                              --
                              FOR  SourceLedgerNames_rec
                              IN   SourceLedgerNames_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
                                   --
                                   gvv_ProgressIndicator := '0190';
                                   --
                                   gvt_TransformCategoryCode := 'LEDGER_NAME';
                                   --
                                   vt_FusionLedgerName := NULL;
                                   --
                                   vt_FusionLedgerName := xxmx_utilities_pkg.get_transform_fusion_value
                                                               (
                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                               ,pt_i_Application      => 'GL'                       -- GL owns the transformations for LEDGER_NAME
                                                               ,pt_i_CategoryCode     => 'LEDGER_NAME'
                                                               ,pt_i_SourceValue      => SourceLedgerNames_rec.source_ledger_name
                                                               );
                                   --
                                   IF   vt_FusionLedgerName IS NULL
                                   THEN
                                        --
                                        vt_MigrationStatus := 'SIMPLE_TRANSFORM_FAILED';
                                        --
                                        xxmx_utilities_pkg.log_data_message
                                             (
                                              pt_i_ApplicationSuite      => gct_ApplicationSuite
                                             ,pt_i_Application           => gct_Application
                                             ,pt_i_BusinessEntity        => gct_BusinessEntity
                                             ,pt_i_SubEntity             => pt_i_SubEntity
                                             ,pt_i_MigrationSetID        => pt_i_MigrationSetID
                                             ,pt_i_Phase                 => ct_Phase
                                             ,pt_i_Severity              => 'ERROR'
                                             ,pt_i_DataTable             => ct_XfmTable
                                             ,pt_i_RecordIdentifiers     => 'SOURCE_LEDGER_NAME'
                                                                          ||'['||SourceLedgerNames_rec.source_ledger_name||']'
                                             ,pt_i_DataMessage           => 'No simple transform from Source Ledger Name to Fusion Ledger Name exists.'
                                             ,pt_i_DataElementsAndValues => 'No transform result.'
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
                                             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                                             ,pt_i_Phase               => ct_Phase
                                             ,pt_i_Severity            => 'NOTIFICATION'
                                             ,pt_i_PackageName         => gct_PackageName
                                             ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage       => '      - Updating XFM table with Fusion Ledger Name "'
                                                                        ||vt_FusionLedgerName
                                                                        ||'" where Source Ledger Name = "'
                                                                        ||SourceLedgerNames_rec.source_ledger_name
                                                                        ||'".'
                                             ,pt_i_OracleError         => NULL
                                             );
                                        --
                                        gvv_ProgressIndicator := '0200';
                                        --
                                        UPDATE  xxmx_ar_trx_dists_xfm
                                        SET     migration_status   = vt_MigrationStatus
                                               ,fusion_ledger_name = vt_FusionLedgerName
                                        WHERE   1 = 1
                                        AND     migration_set_id   = pt_i_MigrationSetID
                                        AND     source_ledger_name = SourceLedgerNames_rec.source_ledger_name;
                                        --
                                   END IF; --** IF   vt_FusionLedgerName IS NULL
                                   --
                              END LOOP; --** SourceLedgerNames_cur LOOP
                              --
                              --<< Simple transform 3 here >>
                              --
                         END IF; --** IF   gvb_SimpleTransformsRequired
                         --
                         IF   gvb_DataEnrichmentRequired
                         THEN
                              --
                              NULL;
                              --
                         END IF; --** IF   gvb_DataEnrichmentRequired
                         --
                         /*
                         ** Commit the updates for the XFM table.
                         */
                         --
                         COMMIT;
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0210';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gct_BusinessEntity
                              ,pt_i_SubEntity           => pt_i_SubEntity
                              ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gct_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '    - No Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                         ||pt_i_SubEntity
                                                         ||'".'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                    END IF; --** IF Simple Transforms required or Data Enrichment required.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0220';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - Any simple transformations for "'
                                                    ||pt_i_SubEntity
                                                    ||'" data should be performed within '
                                                    ||pt_i_SimpleXfmPerformedBy
                                                    ||'.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF; --** IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               --
               gvv_ProgressIndicator := '0230';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Simple transformation processing completed.'
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Complex transformation processing initiated.'
                    ,pt_i_OracleError         => NULL
                    );
               --
               /*
               ** If there are no complex transforms to be performed for this Sub-entity,
               ** then set the following Boolean variable to FALSE so that an appropriate
               ** message is issued to the message log table.
               **
               ** If set to TRUE, then:
               **
               ** a) Complex transform verification can be performed (we should always verify
               **    that supporting data required to perform complex transforms has been
               **    populated into the relevant standing data, transformation / lookup
               **    tables.
               ** b) Complex transforms can then be performed if the verification stage is
               **    completed successrfully.
               */
               --
               gvv_ProgressIndicator := '0240';
               --
               gvb_ComplexTransformsRequired := TRUE;
               --
               IF   gvb_ComplexTransformsRequired
               THEN
                    --
                    /*
                    ************************************************************************************
                    ** The below comments only apply to the commented out code regarding the replacement
                    ** of original Distribution GL Accounts with a default Clearing Account.  This is no
                    ** longer the case for SMBC.
                    ************************************************************************************
                    */
                    --/*
                    --** For AR Invoice Distributions we need to overwrite any extracted Distribution GL Account with
                    --** a default Fusion Revenue Clearing Account.  As we are defaulting the AR Invoice Distribution Account
                    --** this technically falls under the area of Data Enrichment rather than Data Transformation.
                    --**
                    --** For AP Invoices, the Distribution Account is stored as a concatenated string and passed that way in the
                    --** data file to the Fusion Import Job.
                    --**
                    --** As there is the possibility that a client may want to use a different clearing account for each Source
                    --** Ledger (whether the AP Invoices are being migrated into a single Fusion Ledger or different Fusion
                    --** Ledgers) we hold the default AP Invoice Clearing Account as a concatenated string in our GL Utilities
                    --** Source Structures Table and simply do a swap in the Simple Transformation/Data Enrichment section of
                    --** the AP Invoice Line Transformation code.
                    --**
                    --** Where OIC is being used to perform Simple Transformations, OIC can also read the default Clearing Account
                    --** concatenated string from the Migration Parameters table and do the simple swap.
                    --**
                    --** This is a little more tricky for AR Invoices because AR Invoice Distributions store the Account as
                    --** individual segments.
                    --**
                    --** For AR Invoices, we still allow the client to specify the default Revenue Account as a concatenated string
                    --** in the GL Utilities Source Structures Table  table, but we have to break it down into its individual
                    --** segments and populate the correct segment columns of the XFM table.
                    --**
                    --** However before we break the concatenated account string into its individual segments we need to do some basic
                    --** validation on the string first to make sure it has been entered in the correct format.
                    --**
                    --** For this reason we are handling the defaulting of the AR Revenue Clearing Account as a complex transform so
                    --** we can handle all of the string manipulation here in PLSQL rather than trying to do it in OIC (if OIC is
                    --** being used by the client).
                    --**
                    --** For different Clients, the Fusion Account structure will of course be different, so we have to rely directly
                    --** on the setup performed for the Maximise GL Utilities which describes both the Source and Fusion GL Account
                    --** Structure in play for the Data Migration.
                    --**
                    --** In this section we:
                    --**
                    --**      Loop for all DISTINCT Source Ledger Names in the XFM table which have been successfully transformed
                    --**      to a Fusion Ledger Name, retrieving the default Account Code value from the "xxmx_gl_source_structures"
                    --**      table in the same cursor.  There is no point attempting to default the accounts where the ledger names
                    --**      have not been transformed as the Fusion Ledger structure is required to separate the segments.
                    --**
                    --**      For each Default Account Code retrieved by Source Ledger we process as follows:
                    --**
                    --**      A) If the Default Account for the Source Ledger is NULL we log an error and do not update the XFM table for
                    --**           that Source Ledger.
                    --**
                    --**      B) If the Default Account for the Source Ledger is NOT NULL:
                    --**
                    --**         1)   Call the GL Utilties Package Function to validate the format of the Default Account Code according
                    --**              to the structure required by the Fusion Ledger and if the Default Account Code is invalid we log an
                    --**              error and do not update the XFM table for that Source Ledger.
                    --**
                    --**         ELSE
                    --**
                    --**         2)  If the Default Account code is valid we:
                    --**
                    --**             i)   Split the Default Account code into it's individual segments according to the structure required
                    --**                  by the Fusion Ledger.
                    --**
                    --**             ii)  Update the XFM table with the segments.
                    --**
                    --*/
                    ----
                    --xxmx_utilities_pkg.log_module_message
                    --     (
                    --      pt_i_ApplicationSuite    => gct_ApplicationSuite
                    --     ,pt_i_Application         => gct_Application
                    --     ,pt_i_BusinessEntity      => gct_BusinessEntity
                    --     ,pt_i_SubEntity           => pt_i_SubEntity
                    --     ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    --     ,pt_i_Phase               => ct_Phase
                    --     ,pt_i_Severity            => 'NOTIFICATION'
                    --     ,pt_i_PackageName         => gct_PackageName
                    --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    --     ,pt_i_ModuleMessage       => '  - Retrieving and Validating Fusion Default Account Codes '
                    --                                ||'for Source Operating Units in the "'
                    --                                ||ct_XfmTable
                    --                                ||'" table prior to update.'
                    --     ,pt_i_OracleError         => NULL
                    --     );
                    ----
                    --gvv_ProgressIndicator := '0250';
                    ----
                    --FOR  SourceOpUnitDefaultAcct_rec
                    --IN   SourceOpUnitDefaultAccts_cur
                    --          (
                    --           pt_i_MigrationSetID
                    --          )
                    --LOOP
                    --     --
                    --     gvv_ProgressIndicator := '0260';
                    --     --
                    --     IF   SourceOpUnitDefaultAcct_rec.default_account_code IS NULL
                    --     THEN
                    --          --
                    --          xxmx_utilities_pkg.log_module_message
                    --               (
                    --                pt_i_ApplicationSuite    => gct_ApplicationSuite
                    --               ,pt_i_Application         => gct_Application
                    --               ,pt_i_BusinessEntity      => gct_BusinessEntity
                    --               ,pt_i_SubEntity           => pt_i_SubEntity
                    --               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    --               ,pt_i_Phase               => ct_Phase
                    --               ,pt_i_Severity            => 'ERROR'
                    --               ,pt_i_PackageName         => gct_PackageName
                    --               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    --               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    --               ,pt_i_ModuleMessage       => '    - Column "ar_trx_fusion_clearing_acct" in table "xxmx_source_operating_units" '
                    --                                          ||'does not have a value for Source Operating Unit "'
                    --                                          ||SourceOpUnitDefaultAcct_rec.source_operating_unit_name
                    --                                          ||'".'
                    --               ,pt_i_OracleError         => NULL
                    --               );
                    --          --
                    --     ELSE
                    --          --
                    --          xxmx_utilities_pkg.log_module_message
                    --               (
                    --                pt_i_ApplicationSuite    => gct_ApplicationSuite
                    --               ,pt_i_Application         => gct_Application
                    --               ,pt_i_BusinessEntity      => gct_BusinessEntity
                    --               ,pt_i_SubEntity           => pt_i_SubEntity
                    --               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    --               ,pt_i_Phase               => ct_Phase
                    --               ,pt_i_Severity            => 'NOTIFICATION'
                    --               ,pt_i_PackageName         => gct_PackageName
                    --               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    --               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    --               ,pt_i_ModuleMessage       => '    - Validating Fusion Default Account Code "'
                    --                                          ||SourceOpUnitDefaultAcct_rec.default_account_code
                    --                                          ||'" for Source Operating Unit "'
                    --                                          ||SourceOpUnitDefaultAcct_rec.source_operating_unit_name
                    --                                          ||'" against the account structure for Fusion Ledger "'
                    --                                          ||SourceOpUnitDefaultAcct_rec.fusion_ledger_name
                    --                                          ||'".'
                    --               ,pt_i_OracleError         => NULL
                    --               );
                    --          --
                    --          /*
                    --          ** Now we need to check the structure of the Fusion Clearing Account.
                    --          **
                    --          ** To do this, we need to retrieve the Fusion Ledger Name based on the Source Ledger Name.
                    --          **
                    --          ** First verify that Source Ledger Name to Fusion Ledger Name transforms have been defined,
                    --          ** then perform the specific transform.
                    --          */
                    --          --
                    --          gvv_ProgressIndicator := '0270';
                    --          --
                    --          vv_SourceOrFusionAccount := 'FUSION';
                    --          --
                    --          IF   NOT xxmx_gl_utilities_pkg.account_code_format_is_valid
                    --                        (
                    --                         pv_i_SourceOrFusionAccount   => vv_SourceOrFusionAccount
                    --                        ,pt_i_LedgerName              => SourceOpUnitDefaultAcct_rec.fusion_ledger_name
                    --                        ,pv_i_ConcatenatedAccountCode => SourceOpUnitDefaultAcct_rec.default_account_code
                    --                        ,pt_o_AccountEvaluationMsg    => vt_AccountEvaluationMsg
                    --                        )
                    --          THEN
                    --               --
                    --               xxmx_utilities_pkg.log_module_message
                    --                    (
                    --                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    --                    ,pt_i_Application         => gct_Application
                    --                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    --                    ,pt_i_SubEntity           => pt_i_SubEntity
                    --                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    --                    ,pt_i_Phase               => ct_Phase
                    --                    ,pt_i_Severity            => 'NOTIFICATION'
                    --                    ,pt_i_PackageName         => gct_PackageName
                    --                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    --                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    --                    ,pt_i_ModuleMessage       => '      - '
                    --                                               ||vt_AccountEvaluationMsg
                    --                    ,pt_i_OracleError         => NULL
                    --                    );
                    --               --
                    --          ELSE
                    --               --
                    --               xxmx_utilities_pkg.log_module_message
                    --                    (
                    --                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    --                    ,pt_i_Application       => gct_Application
                    --                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    --                    ,pt_i_SubEntity         => pt_i_SubEntity
                    --                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    --                    ,pt_i_Phase             => ct_Phase
                    --                    ,pt_i_Severity          => 'NOTIFICATION'
                    --                    ,pt_i_PackageName       => gct_PackageName
                    --                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    --                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    --                    ,pt_i_ModuleMessage     => '      - Separating '
                    --                                             ||INITCAP(vv_SourceOrFusionAccount)
                    --                                             ||' Default Account Code into it''s individual Segments.'
                    --                    ,pt_i_OracleError       => NULL
                    --                    );
                    --               --
                    --               gvv_ProgressIndicator := '0280';
                    --               --
                    --               xxmx_gl_utilities_pkg.separate_account_segments
                    --                    (
                    --                     pv_i_SourceOrFusionAccount   => vv_SourceOrFusionAccount
                    --                    ,pt_i_LedgerName              => SourceOpUnitDefaultAcct_rec.fusion_ledger_name
                    --                    ,pv_i_ConcatenatedAccountCode => SourceOpUnitDefaultAcct_rec.default_account_code
                    --                    ,pt_o_Segment1                => vt_NewSegment1
                    --                    ,pt_o_Segment2                => vt_NewSegment2
                    --                    ,pt_o_Segment3                => vt_NewSegment3
                    --                    ,pt_o_Segment4                => vt_NewSegment4
                    --                    ,pt_o_Segment5                => vt_NewSegment5
                    --                    ,pt_o_Segment6                => vt_NewSegment6
                    --                    ,pt_o_Segment7                => vt_NewSegment7
                    --                    ,pt_o_Segment8                => vt_NewSegment8
                    --                    ,pt_o_Segment9                => vt_NewSegment9
                    --                    ,pt_o_Segment10               => vt_NewSegment10
                    --                    ,pt_o_Segment11               => vt_NewSegment11
                    --                    ,pt_o_Segment12               => vt_NewSegment12
                    --                    ,pt_o_Segment13               => vt_NewSegment13
                    --                    ,pt_o_Segment14               => vt_NewSegment14
                    --                    ,pt_o_Segment15               => vt_NewSegment15
                    --                    ,pt_o_Segment16               => vt_NewSegment16
                    --                    ,pt_o_Segment17               => vt_NewSegment17
                    --                    ,pt_o_Segment18               => vt_NewSegment18
                    --                    ,pt_o_Segment19               => vt_NewSegment19
                    --                    ,pt_o_Segment20               => vt_NewSegment20
                    --                    ,pt_o_Segment21               => vt_NewSegment21
                    --                    ,pt_o_Segment22               => vt_NewSegment22
                    --                    ,pt_o_Segment23               => vt_NewSegment23
                    --                    ,pt_o_Segment24               => vt_NewSegment24
                    --                    ,pt_o_Segment25               => vt_NewSegment25
                    --                    ,pt_o_Segment26               => vt_NewSegment26
                    --                    ,pt_o_Segment27               => vt_NewSegment27
                    --                    ,pt_o_Segment28               => vt_NewSegment28
                    --                    ,pt_o_Segment29               => vt_NewSegment29
                    --                    ,pt_o_Segment30               => vt_NewSegment30
                    --                    ,pv_o_ReturnStatus            => gvv_ReturnStatus
                    --                    ,pv_o_ReturnMessage           => gvt_ReturnMessage
                    --                    );
                    --               --
                    --               IF   gvv_ReturnStatus = 'S'
                    --               THEN
                    --                    --
                    --                    xxmx_utilities_pkg.log_module_message
                    --                         (
                    --                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                    --                         ,pt_i_Application       => gct_Application
                    --                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                    --                         ,pt_i_SubEntity         => pt_i_SubEntity
                    --                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    --                         ,pt_i_Phase             => ct_Phase
                    --                         ,pt_i_Severity          => 'NOTIFICATION'
                    --                         ,pt_i_PackageName       => gct_PackageName
                    --                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    --                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    --                         ,pt_i_ModuleMessage     => '        - Updating the "'
                    --                                                  ||ct_XfmTable
                    --                                                  ||' table with the Default Account Segments for Fusion Ledger "'
                    --                                                  ||SourceOpUnitDefaultAcct_rec.fusion_ledger_name
                    --                                                  ||'".'
                    --                         ,pt_i_OracleError       => NULL
                    --                         );
                    --                    --
                    --                    gvv_ProgressIndicator := '0290';
                    --                    --
                    --                    vt_MigrationStatus := 'TRANSFORMED';
                    --                    --
                    --                    UPDATE  xxmx_ar_trx_dists_xfm
                    --                    SET     migration_status = vt_MigrationStatus
                    --                           ,segment1         = vt_NewSegment1
                    --                           ,segment2         = vt_NewSegment2
                    --                           ,segment3         = vt_NewSegment3
                    --                           ,segment4         = vt_NewSegment4
                    --                           ,segment5         = vt_NewSegment5
                    --                           ,segment6         = vt_NewSegment6
                    --                           ,segment7         = vt_NewSegment7
                    --                           ,segment8         = vt_NewSegment8
                    --                           ,segment9         = vt_NewSegment9
                    --                           ,segment10        = vt_NewSegment10
                    --                           ,segment11        = vt_NewSegment11
                    --                           ,segment12        = vt_NewSegment12
                    --                           ,segment13        = vt_NewSegment13
                    --                           ,segment14        = vt_NewSegment14
                    --                           ,segment15        = vt_NewSegment15
                    --                           ,segment16        = vt_NewSegment16
                    --                           ,segment17        = vt_NewSegment17
                    --                           ,segment18        = vt_NewSegment18
                    --                           ,segment19        = vt_NewSegment19
                    --                           ,segment20        = vt_NewSegment20
                    --                           ,segment21        = vt_NewSegment21
                    --                           ,segment22        = vt_NewSegment22
                    --                           ,segment23        = vt_NewSegment23
                    --                           ,segment24        = vt_NewSegment24
                    --                           ,segment25        = vt_NewSegment25
                    --                           ,segment26        = vt_NewSegment26
                    --                           ,segment27        = vt_NewSegment27
                    --                           ,segment28        = vt_NewSegment28
                    --                           ,segment29        = vt_NewSegment29
                    --                           ,segment30        = vt_NewSegment30
                    --                    WHERE   1 = 1
                    --                    AND     migration_set_id   = pt_i_MigrationSetID
                    --                    AND     fusion_ledger_name = SourceOpUnitDefaultAcct_rec.fusion_ledger_name;
                    --                    --
                    --                    gvv_ProgressIndicator := '0300';
                    --                    --
                    --                    gvn_RowCount := SQL%ROWCOUNT;
                    --                    --
                    --                    xxmx_utilities_pkg.log_module_message
                    --                         (
                    --                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                    --                         ,pt_i_Application       => gct_Application
                    --                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                    --                         ,pt_i_SubEntity         => pt_i_SubEntity
                    --                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    --                         ,pt_i_Phase             => ct_Phase
                    --                         ,pt_i_Severity          => 'NOTIFICATION'
                    --                         ,pt_i_PackageName       => gct_PackageName
                    --                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    --                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    --                         ,pt_i_ModuleMessage     => '        - '
                    --                                                  ||gvn_RowCount
                    --                                                  ||' Rows updated for Fusion Ledger Name "'
                    --                                                  ||SourceOpUnitDefaultAcct_rec.fusion_ledger_name
                    --                                                  ||'".'
                    --                         ,pt_i_OracleError       => NULL
                    --                         );
                    --                    --
                    --               ELSE
                    --                    --
                    --                    xxmx_utilities_pkg.log_module_message
                    --                         (
                    --                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                    --                         ,pt_i_Application       => gct_Application
                    --                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                    --                         ,pt_i_SubEntity         => pt_i_SubEntity
                    --                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    --                         ,pt_i_Phase             => ct_Phase
                    --                         ,pt_i_Severity          => 'ERROR'
                    --                         ,pt_i_PackageName       => gct_PackageName
                    --                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    --                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    --                         ,pt_i_ModuleMessage     => '        - Call to "xxmx_gl_utilities_pkg.separate_account_segments" returned message : '
                    --                                                  ||gvt_ReturnMessage
                    --                         ,pt_i_OracleError       => NULL
                    --                         );
                    --                    --
                    --               END IF;  --** gvv_ReturnStatus <> 'S'
                    --               --
                    --          END IF; --** IF   NOT xxmx_gl_utilities_pkg.account_code_format_is_valid
                    --          --
                    --     END IF; --** IF   SourceOpUnitDefaultAcct_rec.ar_trx_fusion_clearing_acct IS NULL
                    --     --
                    --END LOOP; --** SourceOpUnitDefaultAccts_cur LOOP
                    --
                    /*
                    ** The original AR Distribution GL Accounts need to be transformed to their Fusion
                    ** equivalents.  This is performed utilising a procedure in the GL Utilities Pkg
                    ** based on the XXMX_GL_ACCOUNT_TRANSFORMS table which holds GL Code Combination
                    ** Transformations.
                    **
                    ** The SourceDistAccts_cur will loop through all records for the current Migration
                    ** Set ID and the "transform_gl_account" procedure will be called for each row.
                    **
                    ** If the account has not been successfully transformed, a message will be written
                    ** to the data messages table.
                    **
                    ** The original row in the XXMX_AR_TRX_DISTS_XFM table will then be updated with
                    ** an appropriate muigration_status.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Performing Fusion GL Account Code Transformations.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0250';
                    --
                    FOR  SourceDistAcct_rec
                    IN   SourceDistAccts_cur
                              (
                               pt_i_MigrationSetID
                              )
                    LOOP
                         --
                         gvv_ProgressIndicator := '0260';
                         --
                         vt_NewSegment1  := NULL;
                         vt_NewSegment2  := NULL;
                         vt_NewSegment3  := NULL;
                         vt_NewSegment4  := NULL;
                         vt_NewSegment5  := NULL;
                         vt_NewSegment6  := NULL;
                         vt_NewSegment7  := NULL;
                         vt_NewSegment8  := NULL;
                         vt_NewSegment9  := NULL;
                         vt_NewSegment10 := NULL;
                         vt_NewSegment11 := NULL;
                         vt_NewSegment12 := NULL;
                         vt_NewSegment13 := NULL;
                         vt_NewSegment14 := NULL;
                         vt_NewSegment15 := NULL;
                         vt_NewSegment16 := NULL;
                         vt_NewSegment17 := NULL;
                         vt_NewSegment18 := NULL;
                         vt_NewSegment19 := NULL;
                         vt_NewSegment20 := NULL;
                         vt_NewSegment21 := NULL;
                         vt_NewSegment22 := NULL;
                         vt_NewSegment23 := NULL;
                         vt_NewSegment24 := NULL;
                         vt_NewSegment25 := NULL;
                         vt_NewSegment26 := NULL;
                         vt_NewSegment27 := NULL;
                         vt_NewSegment28 := NULL;
                         vt_NewSegment29 := NULL;
                         vt_NewSegment30 := NULL;
                         --
                         gvv_ReturnStatus := NULL;
                         --
                         xxmx_gl_utilities_pkg.transform_gl_account
                              (
                               pt_i_ApplicationSuite     => gct_ApplicationSuite
                              ,pt_i_Application          => 'GL'
                              ,pt_i_BusinessEntity       => 'ALL'
                              ,pt_i_SubEntity            => 'ALL'
                              ,pt_i_SourceLedgerName     => SourceDistAcct_rec.source_ledger_name
                              ,pt_i_SourceSegment1       => SourceDistAcct_rec.segment1
                              ,pt_i_SourceSegment2       => SourceDistAcct_rec.segment2
                              ,pt_i_SourceSegment3       => SourceDistAcct_rec.segment3
                              ,pt_i_SourceSegment4       => SourceDistAcct_rec.segment4
                              ,pt_i_SourceSegment5       => SourceDistAcct_rec.segment5
                              ,pt_i_SourceSegment6       => SourceDistAcct_rec.segment6
                              ,pt_i_SourceSegment7       => SourceDistAcct_rec.segment7
                              ,pt_i_SourceSegment8       => SourceDistAcct_rec.segment8
                              ,pt_i_SourceSegment9       => SourceDistAcct_rec.segment9
                              ,pt_i_SourceSegment10      => SourceDistAcct_rec.segment10
                              ,pt_i_SourceSegment11      => SourceDistAcct_rec.segment11
                              ,pt_i_SourceSegment12      => SourceDistAcct_rec.segment12
                              ,pt_i_SourceSegment13      => SourceDistAcct_rec.segment13
                              ,pt_i_SourceSegment14      => SourceDistAcct_rec.segment14
                              ,pt_i_SourceSegment15      => SourceDistAcct_rec.segment15
                              ,pt_i_SourceSegment16      => SourceDistAcct_rec.segment16
                              ,pt_i_SourceSegment17      => SourceDistAcct_rec.segment17
                              ,pt_i_SourceSegment18      => SourceDistAcct_rec.segment18
                              ,pt_i_SourceSegment19      => SourceDistAcct_rec.segment19
                              ,pt_i_SourceSegment20      => SourceDistAcct_rec.segment20
                              ,pt_i_SourceSegment21      => SourceDistAcct_rec.segment21
                              ,pt_i_SourceSegment22      => SourceDistAcct_rec.segment22
                              ,pt_i_SourceSegment23      => SourceDistAcct_rec.segment23
                              ,pt_i_SourceSegment24      => SourceDistAcct_rec.segment24
                              ,pt_i_SourceSegment25      => SourceDistAcct_rec.segment25
                              ,pt_i_SourceSegment26      => SourceDistAcct_rec.segment26
                              ,pt_i_SourceSegment27      => SourceDistAcct_rec.segment27
                              ,pt_i_SourceSegment28      => SourceDistAcct_rec.segment28
                              ,pt_i_SourceSegment29      => SourceDistAcct_rec.segment29
                              ,pt_i_SourceSegment30      => SourceDistAcct_rec.segment30
                              ,pt_i_SourceConcatSegments => NULL
                              ,pt_o_FusionSegment1       => vt_NewSegment1
                              ,pt_o_FusionSegment2       => vt_NewSegment2
                              ,pt_o_FusionSegment3       => vt_NewSegment3
                              ,pt_o_FusionSegment4       => vt_NewSegment4
                              ,pt_o_FusionSegment5       => vt_NewSegment5
                              ,pt_o_FusionSegment6       => vt_NewSegment6
                              ,pt_o_FusionSegment7       => vt_NewSegment7
                              ,pt_o_FusionSegment8       => vt_NewSegment8
                              ,pt_o_FusionSegment9       => vt_NewSegment9
                              ,pt_o_FusionSegment10      => vt_NewSegment10
                              ,pt_o_FusionSegment11      => vt_NewSegment11
                              ,pt_o_FusionSegment12      => vt_NewSegment12
                              ,pt_o_FusionSegment13      => vt_NewSegment13
                              ,pt_o_FusionSegment14      => vt_NewSegment14
                              ,pt_o_FusionSegment15      => vt_NewSegment15
                              ,pt_o_FusionSegment16      => vt_NewSegment16
                              ,pt_o_FusionSegment17      => vt_NewSegment17
                              ,pt_o_FusionSegment18      => vt_NewSegment18
                              ,pt_o_FusionSegment19      => vt_NewSegment19
                              ,pt_o_FusionSegment20      => vt_NewSegment20
                              ,pt_o_FusionSegment21      => vt_NewSegment21
                              ,pt_o_FusionSegment22      => vt_NewSegment22
                              ,pt_o_FusionSegment23      => vt_NewSegment23
                              ,pt_o_FusionSegment24      => vt_NewSegment24
                              ,pt_o_FusionSegment25      => vt_NewSegment25
                              ,pt_o_FusionSegment26      => vt_NewSegment26
                              ,pt_o_FusionSegment27      => vt_NewSegment27
                              ,pt_o_FusionSegment28      => vt_NewSegment28
                              ,pt_o_FusionSegment29      => vt_NewSegment29
                              ,pt_o_FusionSegment30      => vt_NewSegment30
                              ,pt_o_FusionConcatSegments => vt_FusionConcatenatedSegments
                              ,pv_o_ReturnStatus         => gvv_ReturnStatus
                              ,pv_o_ReturnMessage        => gvt_ReturnMessage
                              );
                         --
                         IF   gvv_ReturnStatus = 'S'
                         THEN
                              --
                              vt_MigrationStatus := 'TRANSFORMED';
                              --
                         ELSE
                              --
                              vt_RecordIdentifiers     := 'row_seq['
                                                        ||SourceDistAcct_rec.row_seq
                                                        ||']~source_ledger_name['
                                                        ||SourceDistAcct_rec.source_ledger_name
                                                        ||']';
                              --
                              vt_DataElementsAndValues := 'source_segment1['
                                                        ||SourceDistAcct_rec.segment1
                                                        ||']~source_segment2['
                                                        ||SourceDistAcct_rec.segment2
                                                        ||']~source_segment3['
                                                        ||SourceDistAcct_rec.segment3
                                                        ||']~source_segment4['
                                                        ||SourceDistAcct_rec.segment4
                                                        ||']~source_segment5['
                                                        ||SourceDistAcct_rec.segment5
                                                        ||']~source_segment6['
                                                        ||SourceDistAcct_rec.segment6
                                                        ||']~source_segment7['
                                                        ||SourceDistAcct_rec.segment7
                                                        ||']';
                              --
                              IF   gvv_ReturnStatus = 'W'
                              THEN
                                   --
                                   vt_MigrationStatus := 'ACCT_TRANSFORM_WARNING';
                                   --
                                   gvt_Severity := 'WARNING';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'ACCT_TRANSFORM_ERROR';
                                   --
                                   gvt_Severity := 'ERROR';
                                   --
                              END IF;
                              --
                              xxmx_utilities_pkg.log_data_message
                                   (
                                    pt_i_ApplicationSuite        => gct_ApplicationSuite
                                   ,pt_i_Application             => gct_Application
                                   ,pt_i_BusinessEntity          => gct_BusinessEntity
                                   ,pt_i_SubEntity               => pt_i_SubEntity
                                   ,pt_i_MigrationSetID          => pt_i_MigrationSetID
                                   ,pt_i_Phase                   => ct_Phase
                                   ,pt_i_Severity                => gvt_Severity
                                   ,pt_i_DataTable               => 'xxmx_ar_trx_dists_xfm'
                                   ,pt_i_RecordIdentifiers       => vt_RecordIdentifiers
                                   ,pt_i_DataMessage             => gvt_ReturnMessage
                                   ,pt_i_DataElementsAndValues   => vt_DataElementsAndValues
                                   );
                              --
                         END IF;  --** IF gvv_ReturnStatus = 'S'
                         --
                         gvv_ProgressIndicator := '0270';
                         --
                         UPDATE  xxmx_ar_trx_dists_xfm
                         SET     migration_status = vt_MigrationStatus
                                ,segment1         = vt_NewSegment1
                                ,segment2         = vt_NewSegment2
                                ,segment3         = vt_NewSegment3
                                ,segment4         = vt_NewSegment4
                                ,segment5         = vt_NewSegment5
                                ,segment6         = vt_NewSegment6
                                ,segment7         = vt_NewSegment7
                                ,segment8         = vt_NewSegment8
                                ,segment9         = vt_NewSegment9
                                ,segment10        = vt_NewSegment10
                                ,segment11        = vt_NewSegment11
                                ,segment12        = vt_NewSegment12
                                ,segment13        = vt_NewSegment13
                                ,segment14        = vt_NewSegment14
                                ,segment15        = vt_NewSegment15
                                ,segment16        = vt_NewSegment16
                                ,segment17        = vt_NewSegment17
                                ,segment18        = vt_NewSegment18
                                ,segment19        = vt_NewSegment19
                                ,segment20        = vt_NewSegment20
                                ,segment21        = vt_NewSegment21
                                ,segment22        = vt_NewSegment22
                                ,segment23        = vt_NewSegment23
                                ,segment24        = vt_NewSegment24
                                ,segment25        = vt_NewSegment25
                                ,segment26        = vt_NewSegment26
                                ,segment27        = vt_NewSegment27
                                ,segment28        = vt_NewSegment28
                                ,segment29        = vt_NewSegment29
                                ,segment30        = vt_NewSegment30
                         WHERE   1 = 1
                         AND     migration_set_id              = pt_i_MigrationSetID
                         AND     xxmx_customer_trx_id          = SourceDistAcct_rec.xxmx_customer_trx_id
                         AND     xxmx_customer_trx_line_id     = SourceDistAcct_rec.xxmx_customer_trx_line_id
                         AND     xxmx_cust_trx_line_gl_dist_id = SourceDistAcct_rec.xxmx_cust_trx_line_gl_dist_id;
                         --
                    END LOOP; --** SourceDistAccts_cur LOOP
                    --
                    /*
                    ** Commit the Account Transformations
                    */
                    --
                    COMMIT;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Fusion GL Account Code Transformations complete.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Now that all Transaction Distributions have been extracted with their
                    ** original Amounts, we need to update them with a pro-rated
                    ** value based on the apportioned open balance already updated on
                    ** the transaction line.
                    **
                    ** This will be calculated in a similar manner to the lines calculation
                    ** apart from the original Distribution Amount will be compared to the
                    ** original Line Amount to determine the ratio.
                    **
                    ** The new XXMX_ORIG_TRX_LINE_AMOUNT column was added to the lines
                    ** XFM table to preserve the original line amount before TRX_LINE_AMOUNT
                    ** was updated.
                    **
                    ** This only needs to be performed for partially-paid transactions.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Re-calculating Transaction Distribution Amounts based '
                                                  ||'on Transaction Line Amounts.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0280';
                    --
                    FOR  PartiallyPaidTrxLine_rec
                    IN   PartiallyPaidTrxLines_cur
                              (
                               pt_i_MigrationSetID
                              )
                    LOOP
                         --
                         /*
                         ** Count Number of Distributions in the XFM table for the Transaction Line.
                         **
                         ** This is used to determine when we are dealing with the last
                         ** distribution for the Line.
                         */
                         --
                         gvv_ProgressIndicator := '0290';
                         --
                         vn_LastTrxLineDistID := NULL;
                         --
                         SELECT MAX(xxmx_cust_trx_line_gl_dist_id)
                         INTO   vn_LastTrxLineDistID
                         FROM   xxmx_ar_trx_dists_xfm
                         WHERE  1 = 1
                         AND    migration_set_id          = pt_i_MigrationSetID
                         AND    xxmx_customer_trx_id      = PartiallyPaidTrxLine_rec.xxmx_customer_trx_id
                         AND    xxmx_customer_trx_line_id = PartiallyPaidTrxLine_rec.xxmx_customer_trx_line_id;
                         --
                         --xxmx_utilities_pkg.log_module_message
                         --     (
                         --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                         --     ,pt_i_Application       => gct_Application
                         --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                         --     ,pt_i_SubEntity         => pt_i_SubEntity
                         --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         --     ,pt_i_Phase             => ct_Phase
                         --     ,pt_i_Severity          => 'NOTIFICATION'
                         --     ,pt_i_PackageName       => gct_PackageName
                         --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         --     ,pt_i_ModuleMessage     => '    - Last Distribution ID for Customer Trx ID '
                         --                              ||PartiallyPaidTrxLine_rec.xxmx_customer_trx_id
                         --                              ||' and Line Number '
                         --                              ||PartiallyPaidTrxLine_rec.xxmx_line_number
                         --                              ||' = '
                         --                              ||vn_LastTrxLineDistID
                         --     ,pt_i_OracleError       => NULL
                         --     );
                         --
                         IF   vn_LastTrxLineDistID IS NOT NULL
                         THEN
                              --
                              /*
                              ** Store the Line Amount Due Remaining.  This will be reduced
                              ** distribution-by-distribution as the new distribution amounts
                              ** are calculated to determine if there is any remaining line
                              ** open balance to account for when the last distribution has
                              ** been reached and calculated.
                              **
                              ** As the new distribution amount is calculated based on the line
                              ** amount divided by the number of distributions (then rounded)
                              ** all the dists for a line should be updated with the same amount.
                              **
                              ** However due to the rounding and adjustment may need to be made to
                              ** the last distribution to ensure the didtribution total matches
                              ** the line amount.
                              */
                              --
                              gvv_ProgressIndicator := '0300';
                              --
                              vn_TrxLineBalanceRemaining := PartiallyPaidTrxLine_rec.updated_line_amount;
                              --
                              --xxmx_utilities_pkg.log_module_message
                              --     (
                              --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                              --     ,pt_i_Application       => gct_Application
                              --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                              --     ,pt_i_SubEntity         => pt_i_SubEntity
                              --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              --     ,pt_i_Phase             => ct_Phase
                              --     ,pt_i_Severity          => 'NOTIFICATION'
                              --     ,pt_i_PackageName       => gct_PackageName
                              --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              --     ,pt_i_ModuleMessage     => '    - vn_TrxLineBalanceRemaining (A)          = '
                              --                              ||vn_TrxLineBalanceRemaining
                              --     ,pt_i_OracleError       => NULL
                              --     );
                              --
                              gvv_ProgressIndicator := '0310';
                              --
                              FOR UpdTrxDistAmount_rec
                              IN  UpdTrxDistAmounts_cur
                                       (
                                        pt_i_MigrationsetID
                                       ,PartiallyPaidTrxLine_rec.xxmx_customer_trx_id
                                       ,PartiallyPaidTrxLine_rec.xxmx_customer_trx_line_id
                                       )
                              LOOP
                                   --
                                   /*
                                   ** Calculate what portion of the original line amount
                                   ** the original distribution amount accounts for (as a decimal number
                                   ** e.g. 0.15 this number when multipled by 100 would be a
                                   ** percentage e.g. 15%).
                                   **
                                   ** Rounding will be done on the new line amount.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0320';
                                   --
                                   vn_OrigDistAmtRatio :=  UpdTrxDistAmount_rec.original_dist_amount
                                                         / PartiallyPaidTrxLine_rec.xxmx_orig_trx_line_amount;
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite => gct_ApplicationSuite
                                   --     ,pt_i_Application      => gct_Application
                                   --     ,pt_i_BusinessEntity   => gct_BusinessEntity
                                   --     ,pt_i_SubEntity        => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                                   --     ,pt_i_Phase            => ct_Phase
                                   --     ,pt_i_Severity         => 'NOTIFICATION'
                                   --     ,pt_i_PackageName      => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName   => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator=> gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage    => '    - Original Line Amount (B)              = '
                                   --                             ||PartiallyPaidTrxLine_rec.xxmx_orig_trx_line_amount
                                   --     ,pt_i_OracleError      => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - Original Dist Amount (C)              = '
                                   --                              ||UpdTrxDistAmount_rec.original_dist_amount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_OrigDistAmtRatio (D) = (C/B)       = '
                                   --                              ||vn_OrigDistAmtRatio
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** Calculate the new distribution amount remaining as a portion
                                   ** of the distibution amount.
                                   **
                                   ** This will be rounded to 2 decimal places.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0330';
                                   --
                                   vn_NewDistRemainingAmount := ROUND(
                                                                       (
                                                                          PartiallyPaidTrxLine_rec.updated_line_amount
                                                                        * vn_OrigDistAmtRatio
                                                                       )
                                                                     ,2
                                                                     );
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - Updated Line Amount (E)               = '
                                   --                              ||PartiallyPaidTrxLine_rec.updated_line_amount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_NewDistRemainingAmount (F) = (E*D) = '
                                   --                              ||vn_NewDistRemainingAmount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** To calculate if there is any Transaction open balance remaining after
                                   ** new values have been calculated for each line, we subtract the new line
                                   ** amount from the transaction open balance.  Any remainder will be added
                                   ** to the last line.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0340';
                                   --
                                   vn_TrxLineBalanceRemaining :=   vn_TrxLineBalanceRemaining
                                                                 - vn_NewDistRemainingAmount;
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_TrxLineBalanceRemaining (A = A-F) = '
                                   --                              ||vn_TrxLineBalanceRemaining
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** If we have calculated the new line amount for the last line and
                                   ** if we still have any open balance remaining for the entire
                                   ** Transaction (should only be pennies) then add it to the last line.
                                   **
                                   ** Should the total of the new line amounts turn out to be slightly
                                   ** more then the original open balance remaining, then the transaction
                                   ** open balance remaining variable will be negative so in that case
                                   ** the open balance amount for the last line will be reduced accordingly.
                                   */
                                   --
                                   IF   UpdTrxDistAmount_rec.xxmx_cust_trx_line_gl_dist_id  = vn_LastTrxLineDistID
                                   AND  vn_TrxLineBalanceRemaining                         <> 0
                                   THEN
                                        --
                                        gvv_ProgressIndicator := '0350';
                                        --
                                        vn_NewDistRemainingAmount := vn_NewDistRemainingAmount + vn_TrxLineBalanceRemaining;
                                        --
                                        --xxmx_utilities_pkg.log_module_message
                                        --     (
                                        --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                        --     ,pt_i_Application       => gct_Application
                                        --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        --     ,pt_i_SubEntity         => pt_i_SubEntity
                                        --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        --     ,pt_i_Phase             => ct_Phase
                                        --     ,pt_i_Severity          => 'NOTIFICATION'
                                        --     ,pt_i_PackageName       => gct_PackageName
                                        --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        --     ,pt_i_ModuleMessage     => '    - vn_NewDistRemainingAmount (Updated for rem line balance) = '
                                        --                              ||vn_TrxLineBalanceRemaining
                                        --     ,pt_i_OracleError       => NULL
                                        --     );
                                        --
                                   END IF;
                                   --
                                   gvv_ProgressIndicator := '0360';
                                   --
                                   UPDATE xxmx_ar_trx_dists_xfm  xatdx
                                   SET    amount = vn_NewDistRemainingAmount
                                   WHERE  1 = 1
                                   AND    xatdx.xxmx_customer_trx_id          = UpdTrxDistAmount_rec.xxmx_customer_trx_id         
                                   AND    xatdx.xxmx_customer_trx_line_id     = UpdTrxDistAmount_rec.xxmx_customer_trx_line_id    
                                   AND    xatdx.xxmx_cust_trx_line_gl_dist_id = UpdTrxDistAmount_rec.xxmx_cust_trx_line_gl_dist_id;
                                   --
                              END LOOP; --** UpdTrxDistAmounts_cur LOOP
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0370';
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
                                   ,pt_i_ModuleMessage       => '    - No transaction distributions found in the "xxmx_ar_trx_dists_xfm" '
                                                              ||'table for XXMX_CUSTOMER_TRX_ID ['
                                                              ||PartiallyPaidTrxLine_rec.xxmx_customer_trx_id
                                                              ||'] (TRX_NUMBER ['
                                                              ||PartiallyPaidTrxLine_rec.trx_number
                                                              ||']) and XXMX_CUSTOMER_TRX_LINE_ID ['
                                                              ||PartiallyPaidTrxLine_rec.xxmx_customer_trx_line_id
                                                              ||'] (XXMX_LINE_NUMBER ['
                                                              ||PartiallyPaidTrxLine_rec.xxmx_line_number
                                                              ||']).'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF; --** vn_LastTrxLineDistID IS NOT NULL
                         --
                    END LOOP; --** PartiallyPaidTrxLines_cur
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '  - Transaction Distribution Amount Re-calculation complete.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0380';
                    --
                    COMMIT;
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0390';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - No complex transformations are required for Sub-Entity "'
                                                  ||pt_i_SubEntity
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF   gvb_ComplexTransformsRequired
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Complex transformation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase end if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0400';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => ct_XfmTable
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Transformation Table "'
                                             ||ct_XfmTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          ELSE
               --
               gvv_ProgressIndicator := '0410';
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_MigrationSetID", "pt_i_SubEntity" and "pt_i_SimpleXfmPerformedBy" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0420';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END ar_trx_dists_xfm;
     --
     --
     /*
     *************************************
     ** PROCEDURE: ar_trx_salescredits_stg
     *************************************
     */
     --
     PROCEDURE ar_trx_salescredits_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the detail ar_trx_salescredits_stg
          --
          CURSOR ARTrxSalescredits_cur
          IS
               --
               --
               SELECT    ROWNUM                                                                                                      AS row_seq
                        ,rctlsa.cust_trx_line_salesrep_id                                                                            AS xxmx_cust_trx_line_salesrep_id
                        ,rctlsa.customer_trx_id                                                                                      AS xxmx_customer_trx_id
                        ,rctlsa.customer_trx_line_id                                                                                 AS xxmx_customer_trx_line_id
                        ,haou.name                                                                                                   AS operating_unit
                        ,rsa.salesrep_number
                        ,osct.name                                                                                                   AS sales_credit_type_name
                        ,rctlsa.revenue_amount_split                                                                                 AS sales_credit_amount_split
                        ,NULL                                                                                                        AS sales_credit_percent_split
                        ,hca.account_number                                                                                          AS interface_line_attribute1
                        ,rcta.trx_number                                                                                             AS interface_line_attribute2
                        ,rctla.line_number                                                                                           AS interface_line_attribute3
                        ,NULL                                                                                                        AS interface_line_attribute4
                        ,NULL                                                                                                        AS interface_line_attribute5
                        ,NULL                                                                                                        AS interface_line_attribute6
                        ,NULL                                                                                                        AS interface_line_attribute7
                        ,NULL                                                                                                        AS interface_line_attribute8
                        ,NULL                                                                                                        AS interface_line_attribute9
                        ,NULL                                                                                                        AS interface_line_attribute10
                        ,NULL                                                                                                        AS interface_line_attribute11
                        ,NULL                                                                                                        AS interface_line_attribute12
                        ,NULL                                                                                                        AS interface_line_attribute13
                        ,NULL                                                                                                        AS interface_line_attribute14
                        ,NULL                                                                                                        AS interface_line_attribute15
                        ,'AR_GENERIC'                                                                                                AS interface_line_context
                        ,NULL                                                                                                        AS attribute_category
                        ,NULL                                                                                                        AS attribute1
                        ,NULL                                                                                                        AS attribute2
                        ,NULL                                                                                                        AS attribute3
                        ,NULL                                                                                                        AS attribute4
                        ,NULL                                                                                                        AS attribute5
                        ,NULL                                                                                                        AS attribute6
                        ,NULL                                                                                                        AS attribute7
                        ,NULL                                                                                                        AS attribute8
                        ,NULL                                                                                                        AS attribute9
                        ,NULL                                                                                                        AS attribute10
                        ,NULL                                                                                                        AS attribute11
                        ,NULL                                                                                                        AS attribute12
                        ,NULL                                                                                                        AS attribute13
                        ,NULL                                                                                                        AS attribute14
                        ,NULL                                                                                                        AS attribute15
               FROM      xxmx_ar_trx_scope_v                                    xatsv
                        ,apps.ra_customer_trx_all@MXDM_NVIS_EXTRACT             rcta
                        ,apps.ra_customer_trx_lines_all@MXDM_NVIS_EXTRACT       rctla
                        ,apps.ra_cust_trx_line_salesreps_all@MXDM_NVIS_EXTRACT  rctlsa
                        ,apps.ra_salesreps_all@MXDM_NVIS_EXTRACT                rsa
                        ,apps.oe_sales_credit_types@MXDM_NVIS_EXTRACT           osct
                        ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT       haou
                        ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT                hca
               WHERE     1 = 1
               AND       rcta.org_id                 = xatsv.org_id                /* Invoice Headers to Invoice Scope View Joins   */
               AND       rcta.customer_trx_id        = xatsv.customer_trx_id       /* Invoice Headers to Invoice Scope View Joins   */
               AND       rctla.org_id                = rcta.org_id                 /* Invoice Lines to Invoice Headers Joins        */
               AND       rctla.customer_trx_id       = rcta.customer_trx_id        /* Invoice Lines to Invoice Headers Joins        */
               AND       rctlsa.org_id               = rctla.org_id                /* Invoice Line Salesreps to Invoice Lines Joins */
               ANd       rctlsa.customer_trx_id      = rctla.customer_trx_id       /* Invoice Line Salesreps to Invoice Lines Joins */
               AND       rctlsa.customer_trx_line_id = rctla.customer_trx_line_id  /* Invoice Line Salesreps to Invoice Lines Joins */
               AND       rsa.org_id                  = rctlsa.org_id               /* Salesreps to Invoice Line Salesrep Joins      */
               AND       rsa.salesrep_id             = rctlsa.salesrep_id          /* Salesreps to Invoice Line Salesrep Join       */
               AND       osct.sales_credit_type_id   = rsa.sales_credit_type_id    /* Salescredit Types to Salesrep Join            */
               AND       haou.organization_id        = xatsv.org_id                /* Operating Unit to Invoice Scope View Join     */
               AND       hca.cust_account_id         = rcta.bill_to_customer_id;   /* Customer Account to Invoice Header Join       */
               --
          --** END CURSOR ARTrxSalescredits_cur
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ARTrxSalescredits_tt IS TABLE OF ARTrxSalescredits_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_salescredits_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ar_trx_salescredits_stg';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
          ARTrxSalescredits_tbl           ARTrxSalescredits_tt;
          --
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
          /*
          ** Delete any MODULE messages from previous executions
          ** for the Business Entity and Business Entity Level
          */
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
                    ,pt_i_Severity            => 'ERROR'
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
          gvv_ProgressIndicator := '0020';
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
                    ,pt_i_Severity            => 'ERROR'
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
          gvv_ProgressIndicator := '0030';
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
          gvv_ProgressIndicator := '0040';
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Extracting "'
                                                 ||pt_i_SubEntity
                                                 ||'":'
                    ,pt_i_OracleError         => NULL
                    );
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
               gvv_ProgressIndicator := '0050';
               --
               --
               --** Extract the ar_trx_salescredits_stg and insert into the staging table.
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
               --
               OPEN ARTrxSalescredits_cur;
               --
               --
               --xxmx_utilities_pkg.out_message(' After OPEN ARTrxSalescredits_cur');
               --
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ARTrxSalescredits_cur
                    BULK COLLECT
                    INTO ARTrxSalescredits_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ARTrxSalescredits_tbl.count=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL ARTrxSalescredits_idx
                    IN     1..ARTrxSalescredits_tbl.COUNT
                         --
                         INSERT
                         INTO   xxmx_ar_trx_salescredits_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,row_seq
                                   ,xxmx_cust_trx_line_salesrep_id
                                   ,xxmx_customer_trx_id
                                   ,xxmx_customer_trx_line_id
                                   ,operating_unit
                                   ,salesrep_number
                                   ,sales_credit_type_name
                                   ,sales_credit_amount_split
                                   ,sales_credit_percent_split
                                   ,interface_line_context
                                   ,interface_line_attribute1
                                   ,interface_line_attribute2
                                   ,interface_line_attribute3
                                   ,interface_line_attribute4
                                   ,interface_line_attribute5
                                   ,interface_line_attribute6
                                   ,interface_line_attribute7
                                   ,interface_line_attribute8
                                   ,interface_line_attribute9
                                   ,interface_line_attribute10
                                   ,interface_line_attribute11
                                   ,interface_line_attribute12
                                   ,interface_line_attribute13
                                   ,interface_line_attribute14
                                   ,interface_line_attribute15
                                   ,attribute_category
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
                                   )
                         VALUES
                                   (
                                    pt_i_MigrationSetID                                                                      -- migration_set_id
                                   ,gvt_MigrationSetName                                                                     -- migration_set_name
                                   ,'EXTRACTED'                                                                              -- migration_status
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).row_seq                                     -- row_seq
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).xxmx_cust_trx_line_salesrep_id              -- xxmx_cust_trx_line_salesrep_id
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).xxmx_customer_trx_id                        -- xxmx_customer_trx_id
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).xxmx_customer_trx_line_id                   -- xxmx_customer_trx_line_id
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).operating_unit                              -- operating_unit
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).salesrep_number                             -- salesrep_number
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).sales_credit_type_name                      -- sales_credit_type_name
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).sales_credit_amount_split                   -- sales_credit_amount_split
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).sales_credit_percent_split                  -- sales_credit_percent_split
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_context                      -- interface_line_context
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute1 , 1, 30)  -- interface_line_attribute1
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute2 , 1, 30)  -- interface_line_attribute2
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute3 , 1, 30)  -- interface_line_attribute3
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute4 , 1, 30)  -- interface_line_attribute4
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute5 , 1, 30)  -- interface_line_attribute5
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute6 , 1, 30)  -- interface_line_attribute6
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute7 , 1, 30)  -- interface_line_attribute7
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute8 , 1, 30)  -- interface_line_attribute8
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute9 , 1, 30)  -- interface_line_attribute9
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute10, 1, 30)  -- interface_line_attribute10
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute11, 1, 30)  -- interface_line_attribute11
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute12, 1, 30)  -- interface_line_attribute12
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute13, 1, 30)  -- interface_line_attribute13
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute14, 1, 30)  -- interface_line_attribute14
                                   ,SUBSTRB(ARTrxSalescredits_tbl(ARTrxSalescredits_idx).interface_line_attribute15, 1, 30)  -- interface_line_attribute15
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute_category                          -- attribute_category
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute1                                  -- attribute1
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute2                                  -- attribute2
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute3                                  -- attribute3
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute4                                  -- attribute4
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute5                                  -- attribute5
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute6                                  -- attribute6
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute7                                  -- attribute7
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute8                                  -- attribute8
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute9                                  -- attribute9
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute10                                 -- attribute10
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute11                                 -- attribute11
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute12                                 -- attribute12
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute13                                 -- attribute13
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute14                                 -- attribute14
                                   ,ARTrxSalescredits_tbl(ARTrxSalescredits_idx).attribute15                                 -- attribute15
                                   );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ARTrxSalescredits_cur;
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
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '-0100';
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
                    ,pt_i_ModuleMessage       => '  - Migration Table "'
                                                 ||ct_StgTable
                                                 ||'" reporting details updated.'
                    ,pt_i_OracleError         => NULL
                    );
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
                    ,pt_i_Severity            => 'NOTIFICATION'
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
                    IF ARTrxSalescredits_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARTrxSalescredits_cur;
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
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase             => ct_Phase
                        ,pt_i_PackageName       => gct_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_Severity          => gvt_Severity
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
                    IF   ARTrxSalescredits_cur%ISOPEN
                    THEN
                         --
                         CLOSE ARTrxSalescredits_cur;
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted at after Progress Indicator.'
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
     END ar_trx_salescredits_stg;
     --
     --
     /*
     *************************************
     ** PROCEDURE: ar_trx_salescredits_xfm
     *************************************
     */
     --
     PROCEDURE ar_trx_salescredits_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
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
               SELECT  migration_set_id                AS migration_set_id
                      ,migration_set_name              AS migration_set_name
                      ,migration_status                AS migration_status
                      ,row_seq                         AS row_seq          
                      ,xxmx_cust_trx_line_salesrep_id  AS xxmx_cust_trx_line_salesrep_id
                      ,xxmx_customer_trx_id            AS xxmx_customer_trx_id     
                      ,xxmx_customer_trx_line_id       AS xxmx_customer_trx_line_id
                      ,operating_unit                  AS operating_unit
                      ,salesrep_number                 AS salesrep_number
                      ,sales_credit_type_name          AS sales_credit_type_name
                      ,sales_credit_amount_split       AS sales_credit_amount_split
                      ,sales_credit_percent_split      AS sales_credit_percent_split
                      ,interface_line_context          AS interface_line_context
                      ,interface_line_attribute1       AS interface_line_attribute1
                      ,interface_line_attribute2       AS interface_line_attribute2
                      ,interface_line_attribute3       AS interface_line_attribute3
                      ,interface_line_attribute4       AS interface_line_attribute4
                      ,interface_line_attribute5       AS interface_line_attribute5
                      ,interface_line_attribute6       AS interface_line_attribute6
                      ,interface_line_attribute7       AS interface_line_attribute7
                      ,interface_line_attribute8       AS interface_line_attribute8
                      ,interface_line_attribute9       AS interface_line_attribute9
                      ,interface_line_attribute10      AS interface_line_attribute10
                      ,interface_line_attribute11      AS interface_line_attribute11
                      ,interface_line_attribute12      AS interface_line_attribute12
                      ,interface_line_attribute13      AS interface_line_attribute13
                      ,interface_line_attribute14      AS interface_line_attribute14
                      ,interface_line_attribute15      AS interface_line_attribute15
                      ,attribute_category              AS attribute_category
                      ,attribute1                      AS attribute1
                      ,attribute2                      AS attribute2
                      ,attribute3                      AS attribute3
                      ,attribute4                      AS attribute4
                      ,attribute5                      AS attribute5
                      ,attribute6                      AS attribute6
                      ,attribute7                      AS attribute7
                      ,attribute8                      AS attribute8
                      ,attribute9                      AS attribute9
                      ,attribute10                     AS attribute10
                      ,attribute11                     AS attribute11
                      ,attribute12                     AS attribute12
                      ,attribute13                     AS attribute13
                      ,attribute14                     AS attribute14
                      ,attribute15                     AS attribute15
               FROM    xxmx_ar_trx_salescredits_stg
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               AND     migration_status = 'EXTRACTED';
               --
          --** END CURSOR StgTable_cur
          --
          CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_ap_invoice_lines_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  migration_set_id
                      ,migration_set_name
                      ,migration_status
                      ,row_seq
                      ,xxmx_cust_trx_line_salesrep_id
                      ,xxmx_customer_trx_id     
                      ,xxmx_customer_trx_line_id
                      ,source_operating_unit
                      ,fusion_business_unit
                      ,salesrep_number
                      ,sales_credit_type_name
                      ,sales_credit_amount_split
                      ,xxmx_orig_sc_amount_split
                      ,sales_credit_percent_split
                      ,interface_line_context
                      ,interface_line_attribute1
                      ,interface_line_attribute2
                      ,interface_line_attribute3
                      ,interface_line_attribute4
                      ,interface_line_attribute5
                      ,interface_line_attribute6
                      ,interface_line_attribute7
                      ,interface_line_attribute8
                      ,interface_line_attribute9
                      ,interface_line_attribute10
                      ,interface_line_attribute11
                      ,interface_line_attribute12
                      ,interface_line_attribute13
                      ,interface_line_attribute14
                      ,interface_line_attribute15
                      ,attribute_category
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
               FROM    xxmx_ar_trx_salescredits_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
          --
          CURSOR SourceOperatingUnits_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_salescredits_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT xatsx.source_operating_unit
               FROM    xxmx_ar_trx_salescredits_xfm  xatsx
               WHERE   1 = 1
               AND     xatsx.migration_set_id = pt_MigrationSetID;
               --
          --** END CURSOR SourceOperatingUnits_cur
          --
          CURSOR UpdatedTrxLineAmounts_cur
                      (
                       pt_MigrationSetID               xxmx_ar_trx_lines_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  DISTINCT
                       xatlx.xxmx_customer_trx_id
                      ,xatlx.xxmx_customer_trx_line_id
                      ,xatlx.trx_number
                      ,xatlx.xxmx_line_number
                      ,xatlx.trx_line_amount            AS updated_line_amount
                      ,xatlx.xxmx_orig_trx_line_amount
               FROM    xxmx_ar_trx_lines_xfm  xatlx
               WHERE   1 = 1
               AND     xatlx.migration_set_id  = pt_MigrationSetID
               AND     xatlx.trx_line_amount  <> xatlx.xxmx_orig_trx_line_amount;
          --
          CURSOR UpdTrxSalescreditAmounts_cur
                      (
                       pt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE
                      ,pn_CustomerTrxID                NUMBER
                      ,pn_CustomerTrxLineID            NUMBER
                      )
          IS
               --
               SELECT    xatsx.xxmx_customer_trx_id
                        ,xatsx.xxmx_customer_trx_line_id
                        ,xatsx.xxmx_cust_trx_line_salesrep_id
                        ,xatsx.xxmx_orig_sc_amount_split       AS original_salescredit_amount
               FROM      xxmx_ar_trx_salescredits_xfm  xatsx
               WHERE     1 = 1
               AND       xatsx.migration_set_id           = pt_MigrationSetID
               AND       xatsx.sales_credit_amount_split <> 0
               AND       xatsx.sales_credit_amount_split  = xatsx.xxmx_orig_sc_amount_split /* Salescredit amount has not been updated previously */
               AND       xatsx.xxmx_customer_trx_id       = pn_CustomerTrxID
               AND       xatsx.xxmx_customer_trx_line_id  = pn_CustomerTrxLineID
               ORDER BY 
                        xatsx.xxmx_cust_trx_line_salesrep_id;
               --
          --** END CURSOR UpdTrxDistAmounts_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE stg_table_tt IS TABLE OF StgTable_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ar_trx_salescredits_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_salescredits_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ar_trx_salescredits_xfm';
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
          vt_MigrationStatus              xxmx_ar_trx_salescredits_xfm.migration_status%TYPE;
          vt_FusionBusinessUnit           xxmx_ar_trx_salescredits_xfm.fusion_business_unit%TYPE;
          vt_FusionBusinessUnitID         xxmx_source_operating_units.fusion_business_unit_id%TYPE;
          vn_TrxLineBalanceRemaining      NUMBER;
          vn_LastTrxLineSalesrepID        NUMBER;
          vn_OrigSalescreditAmtRatio      NUMBER;
          vn_NewSalescreditRemainAmount   NUMBER;
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          AND  pt_i_SimpleXfmPerformedBy IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               IF   NOT xxmx_utilities_pkg.valid_lookup_code
                         (
                          'TRANSFORM_PERFORMERS'
                         ,UPPER(pt_i_SimpleXfmPerformedBy)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '- "pt_i_SimpleXfmPerformedBy" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "TRANSFORM_PERFORMERS".';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- Simple transformation processing is performed by '
                                                  ||UPPER(pt_i_SimpleXfmPerformedBy)
                         ,pt_i_OracleError       => NULL
                              );
                    --
                    --
               END IF; --** IF   NOT xxmx_utilities_pkg.valid_lookup_code
               --
               vd_TransformStartDate := SYSDATE;
               --
               gvv_ProgressIndicator := '0060';
               --
               IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               THEN
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- Simple transformation processing initiated.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Deleting existing data from the '
                                                  ||ct_XfmTable
                                                  ||' table for Migration Set ID "'
                                                  ||pt_i_MigrationSetID
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    DELETE
                    FROM   xxmx_ar_trx_salescredits_xfm
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID;
                    --
                    gvn_RowCount := SQL%ROWCOUNT;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' rows deleted.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** For Simple Transformations being performed by PL/SQL the data must be moved
                    ** from the STG table to the XFM table as-is.
                    **
                    ** The data is then transformed vertically with several updates across all rows.
                    **
                    ** Any simple transforms are performed first followed by any complex transforms.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Copying "'
                                                  ||pt_i_SubEntity
                                                  ||'" data from the "'
                                                  ||ct_StgTable
                                                  ||'" table to the "'
                                                  ||ct_XfmTable
                                                  ||'" table prior to simple transformation '
                                                  ||'(transformation processing is all by PL/SQL '
                                                  ||'for this Sub-entity).'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    /*
                    ** Copy the data from the STG table to the XFM Table.
                    */
                    --
                    OPEN StgTable_cur
                              (
                               pt_i_MigrationSetID
                              );
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    LOOP
                         --
                         FETCH        StgTable_cur
                         BULK COLLECT
                         INTO         StgTable_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    StgTable_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         FORALL ARInvSalescredits_idx
                         IN     1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_ar_trx_salescredits_xfm
                                          (
                                           migration_set_id
                                          ,migration_set_name
                                          ,migration_status
                                          ,row_seq
                                          ,xxmx_cust_trx_line_salesrep_id                                          
                                          ,xxmx_customer_trx_id     
                                          ,xxmx_customer_trx_line_id
                                          ,source_operating_unit
                                          ,fusion_business_unit
                                          ,salesrep_number
                                          ,sales_credit_type_name
                                          ,sales_credit_amount_split
                                          ,sales_credit_percent_split
                                          ,interface_line_context
                                          ,interface_line_attribute1
                                          ,interface_line_attribute2
                                          ,interface_line_attribute3
                                          ,interface_line_attribute4
                                          ,interface_line_attribute5
                                          ,interface_line_attribute6
                                          ,interface_line_attribute7
                                          ,interface_line_attribute8
                                          ,interface_line_attribute9
                                          ,interface_line_attribute10
                                          ,interface_line_attribute11
                                          ,interface_line_attribute12
                                          ,interface_line_attribute13
                                          ,interface_line_attribute14
                                          ,interface_line_attribute15
                                          ,attribute_category
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
                                          )
                              VALUES
                                          (
                                           StgTable_tbl(ARInvSalescredits_idx).migration_set_id                -- migration_set_id
                                          ,StgTable_tbl(ARInvSalescredits_idx).migration_set_name              -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                               -- migration_status
                                          ,StgTable_tbl(ARInvSalescredits_idx).row_seq                         -- row_seq
                                          ,StgTable_tbl(ARInvSalescredits_idx).xxmx_cust_trx_line_salesrep_id  -- xxmx_cust_trx_line_salesrep_id
                                          ,StgTable_tbl(ARInvSalescredits_idx).xxmx_customer_trx_id            -- xxmx_customer_trx_id     
                                          ,StgTable_tbl(ARInvSalescredits_idx).xxmx_customer_trx_line_id       -- xxmx_customer_trx_line_id
                                          ,StgTable_tbl(ARInvSalescredits_idx).operating_unit                  -- source_operating_unit
                                          ,NULL                                                                -- fusion_business_unit
                                          ,StgTable_tbl(ARInvSalescredits_idx).salesrep_number                 -- salesrep_number
                                          ,StgTable_tbl(ARInvSalescredits_idx).sales_credit_type_name          -- sales_credit_type_name
                                          ,StgTable_tbl(ARInvSalescredits_idx).sales_credit_amount_split       -- sales_credit_amount_split
                                          ,StgTable_tbl(ARInvSalescredits_idx).sales_credit_percent_split      -- sales_credit_percent_split
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_context          -- interface_line_context
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute1       -- interface_line_attribute1
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute2       -- interface_line_attribute2
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute3       -- interface_line_attribute3
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute4       -- interface_line_attribute4
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute5       -- interface_line_attribute5
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute6       -- interface_line_attribute6
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute7       -- interface_line_attribute7
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute8       -- interface_line_attribute8
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute9       -- interface_line_attribute9
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute10      -- interface_line_attribute10
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute11      -- interface_line_attribute11
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute12      -- interface_line_attribute12
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute13      -- interface_line_attribute13
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute14      -- interface_line_attribute14
                                          ,StgTable_tbl(ARInvSalescredits_idx).interface_line_attribute15      -- interface_line_attribute15
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute_category              -- attribute_category
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute1                      -- attribute1
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute2                      -- attribute2
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute3                      -- attribute3
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute4                      -- attribute4
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute5                      -- attribute5
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute6                      -- attribute6
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute7                      -- attribute7
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute8                      -- attribute8
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute9                      -- attribute9
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute10                     -- attribute10
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute11                     -- attribute11
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute12                     -- attribute12
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute13                     -- attribute13
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute14                     -- attribute14
                                          ,StgTable_tbl(ARInvSalescredits_idx).attribute15                     -- attribute15
                                          );
                              --
                         --** END FORALL
                         --
                    END LOOP; --** StgTable_cur BULK COLLECT LOOP
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    CLOSE StgTable_cur;
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all AR Invoice Salescredits in the Migration Set.
                    */
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                         (
                                          gct_XfmSchema
                                         ,ct_XfmTable
                                         ,pt_i_MigrationSetID
                                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' rows copied.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** If there are no simple transforms to be performed for this Sub-entity,
                    ** then set the following Boolean variable to FALSE so that an appropriate
                    ** message is issued to the message log table.
                    **
                    ** If set to TRUE, then:
                    **
                    ** a) Simple transform verification can be performed (we should always verify
                    **    that supporting data required to perform simple transforms has been
                    **    populated into the relevant transformation / lookup tables.
                    ** b) Simple transforms can then be performed if the verification stage is
                    **    completed successfully.
                    ** c) Any other conversions/data enrichment that needs to be done can be
                    **    handled here even if they are not implemented via the Simple Transform
                    **    table and associated functions and procedures.   For example you may
                    **    need to default a value from the XXMX_MIGRATION_PARAMETERS table using
                    **    the XXMX_UTILITIES_PKG.GET_SINGLE_PARAMETER_VALUE function (this falls
                    **    under the Data Enrichment area).
                    */
                    --
                    /*
                    ** For AP Invoice Lines we do not have any Simple Transformations, but we do need
                    ** to perform Data Enrichment to default values for DIST_CODE_CONCATENATED.  As
                    ** per the above suggestion, this is implemented in the Migration Parameters table.
                    */
                    --
                    gvb_SimpleTransformsRequired := TRUE;
                    gvb_DataEnrichmentRequired   := FALSE;
                    --
                    gvv_ProgressIndicator := '0220';
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Performing Simple Transformations and/or Data Enrichment for the "'
                                                       ||pt_i_SubEntity
                                                       ||'" data in the "'
                                                       ||ct_XfmTable
                                                       ||'" table.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Update the XFM table performing all Simple Transforms and/or Data Enrichment for each row.
                         **
                         ** To make the transform process a bit faster for AR Invoices the FOR UPDATE CURSOR has been removed
                         ** and replaced with a number of separate bulk updates to the XFM table (rather than row-by-row) for
                         ** each specific Simple Transform.
                         */
                         --
                         gvv_ProgressIndicator := '0230';
                         --
                         vt_MigrationStatus := 'TRANSFORMED';
                         --
                         /*
                         ** First perform perform any Simple Transformation logic.
                         */
                         --
                         IF   gvb_SimpleTransformsRequired
                         THEN
                              --
                              /*
                              ** For AR Invoice Distributions we have to transform Source Operating
                              ** Units to Fusion Business Units and Source Ledger Names to Fusion
                              ** Ledger Names.
                              */
                              gvv_ProgressIndicator := '0240';
                              --
                              /*
                              ** Transform the Source Operating Units to Fusion Business Units.
                              ** by looping through all DISTINCT Source Operating Units in the
                              ** XFM table and calling the Utilities Package Transform Function
                              ** for each.  We only update the XFM table if a transform is found.
                              */
                              --
                              FOR  SourceOperatingUnit_rec
                              IN   SourceOperatingUnits_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
                                   --
                                   gvv_ProgressIndicator := '0250';
                                   --
                                   xxmx_utilities_pkg.get_fusion_business_unit
                                        (
                                         pt_i_SourceOperatingUnitName => SourceOperatingUnit_rec.source_operating_unit
                                        ,pt_o_FusionBusinessUnitName  => vt_FusionBusinessUnit
                                        ,pt_o_FusionBusinessUnitID    => vt_FusionBusinessUnitID
                                        ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                        ,pt_o_ReturnMessage           => gvt_ReturnMessage
                                        );
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        vt_MigrationStatus := 'SIMPLE_TRANSFORM_FAILED';
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'ERROR'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - '
                                                                      ||gvt_ReturnMessage
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                   ELSE
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '    - Updating XFM table with Fusion Business Unit "'
                                                                      ||vt_FusionBusinessUnit
                                                                      ||'" where Source Operating Unit = "'
                                                                      ||SourceOperatingUnit_rec.source_operating_unit
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        gvv_ProgressIndicator := '0260';
                                        --
                                        UPDATE  xxmx_ar_trx_salescredits_xfm
                                        SET     migration_status     = vt_MigrationStatus
                                               ,fusion_business_unit = vt_FusionBusinessUnit
                                        WHERE   1 = 1
                                        AND     migration_set_id      = pt_i_MigrationSetID
                                        AND     source_operating_unit = SourceOperatingUnit_rec.source_operating_unit;
                                        --
                                   END IF; --** IF   vt_FusionBusinessUnit IS NULL
                                   --
                              END LOOP; --** SourceOperatingUnits_cur LOOP
                              --
                              --<< Simple transform 2 here >>
                              --
                              --<< Simple transform 3 here >>
                              --
                         END IF; --** IF   gvb_SimpleTransformsRequired
                         --
                         IF   gvb_DataEnrichmentRequired
                         THEN
                              --
                              NULL;
                              --
                         END IF; --** IF   gvb_DataEnrichmentRequired
                         --
                         /*
                         ** Commit the updates for the XFM table.
                         */
                         --
                         COMMIT;
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0330';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '- No Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                       ||pt_i_SubEntity
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF Simple Transforms required or Data Enrichment required.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0340';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Any simple transformations for "'
                                                  ||pt_i_SubEntity
                                                  ||'" data should be performed within '
                                                  ||pt_i_SimpleXfmPerformedBy
                                                  ||'.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               --
               gvv_ProgressIndicator := '0210';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Simple transformation processing completed.'
                    ,pt_i_OracleError       => NULL
                         );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Complex transformation processing initiated.'
                    ,pt_i_OracleError       => NULL
                         );
               --
               /*
               ** If there are no complex transforms to be performed for this Sub-entity,
               ** then set the following Boolean variable to FALSE so that an appropriate
               ** message is issued to the message log table.
               **
               ** If set to TRUE, then:
               **
               ** a) Complex transform verification can be performed (we should always verify
               **    that supporting data required to perform complex transforms has been
               **    populated into the relevant standing data, transformation / lookup
               **    tables.
               ** b) Complex transforms can then be performed if the verification stage is
               **    completed successrfully.
               */
               --
               gvv_ProgressIndicator := '0220';
               --
               gvb_ComplexTransformsRequired := TRUE;
               --
               IF   gvb_ComplexTransformsRequired
               THEN
                    --
                    --<< Any code to check if Complex Transforms are required should be added in here.  Your logic should
                    --<< set gvb_PerformComplexTransforms to TRUE it it determines that a complex transformaion is required.
                    --<<
                    --<< As at this time it is unknown how Complex transforms will be handled for many Sub-Entites.
                    --<<
                    --<< However, if you know that complex rules are required in this procedure then you can simply set the
                    --<< variable to TRUE.
                    --
                    --** For GL Balances, we know that complex transformations can be performed if the "xxmx_gl_account_transforms"
                    --** table has been populated for the Source Ledger.
                    --**
                    --** However, if the client has not completed their reviews of the GL Account Transforms table there may still
                    --** be Account transforms in an unfrozen state (and therefore might not be a correct and final mapping).
                    --**
                    --** We can still perform the transformation process but utilise the MIGRATION_STATUS column to indicate if
                    --** as row was updated with a frozen transform (and therefore should not be rejected duing import into Fusion)
                    --** or if the row was updated with an unfrozen transform and needs to be reviewed in the XFM Table.
                    --**
                    --** The "xxmx_gl_utilities_pkg.verify_gl_account_transforms" procedure will determine the state of GL Account
                    --** transforms for each Source Ledger.
                    --
                    gvv_ProgressIndicator := '0230';
                    --
                    gvb_PerformComplexTransforms := TRUE;
                    --
                    IF   gvb_PerformComplexTransforms
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Performing complex transformations for the "'
                                                       ||pt_i_SubEntity
                                                       ||'" data in the "'
                                                       ||ct_XfmTable
                                                       ||'" table.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0250';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Updating Salescredit Amount Splits.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0250';
                         --

                    FOR  UpdatedTrxLineAmount_rec
                    IN   UpdatedTrxLineAmounts_cur
                              (
                               pt_i_MigrationSetID
                              )
                    LOOP
                         --
                         /*
                         ** Count Number of Distributions in the XFM table for the Transaction Line.
                         **
                         ** This is used to determine when we are dealing with the last
                         ** distribution for the Line.
                         */
                         --
                         gvv_ProgressIndicator := '0290';
                         --
                         vn_LastTrxLineSalesrepID := NULL;
                         --
                         SELECT MAX(xxmx_cust_trx_line_salesrep_id)
                         INTO   vn_LastTrxLineSalesrepID
                         FROM   xxmx_ar_trx_salescredits_xfm
                         WHERE  1 = 1
                         AND    migration_set_id          = pt_i_MigrationSetID
                         AND    xxmx_customer_trx_id      = UpdatedTrxLineAmount_rec.xxmx_customer_trx_id
                         AND    xxmx_customer_trx_line_id = UpdatedTrxLineAmount_rec.xxmx_customer_trx_line_id;
                         --
                         --xxmx_utilities_pkg.log_module_message
                         --     (
                         --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                         --     ,pt_i_Application       => gct_Application
                         --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                         --     ,pt_i_SubEntity         => pt_i_SubEntity
                         --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         --     ,pt_i_Phase             => ct_Phase
                         --     ,pt_i_Severity          => 'NOTIFICATION'
                         --     ,pt_i_PackageName       => gct_PackageName
                         --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         --     ,pt_i_ModuleMessage     => '    - Last Distribution ID for Customer Trx ID '
                         --                              ||UpdatedTrxLineAmount_rec.xxmx_customer_trx_id
                         --                              ||' and Line Number '
                         --                              ||UpdatedTrxLineAmount_rec.xxmx_line_number
                         --                              ||' = '
                         --                              ||vn_LastTrxLineDistID
                         --     ,pt_i_OracleError       => NULL
                         --     );
                         --
                         IF   vn_LastTrxLineSalesrepID IS NOT NULL
                         THEN
                              --
                              /*
                              ** Store the Line Amount Due Remaining.  This will be reduced
                              ** distribution-by-distribution as the new distribution amounts
                              ** are calculated to determine if there is any remaining line
                              ** open balance to account for when the last distribution has
                              ** been reached and calculated.
                              **
                              ** As the new distribution amount is calculated based on the line
                              ** amount divided by the number of distributions (then rounded)
                              ** all the dists for a line should be updated with the same amount.
                              **
                              ** However due to the rounding and adjustment may need to be made to
                              ** the last distribution to ensure the didtribution total matches
                              ** the line amount.
                              */
                              --
                              gvv_ProgressIndicator := '0300';
                              --
                              vn_TrxLineBalanceRemaining := UpdatedTrxLineAmount_rec.updated_line_amount;
                              --
                              --xxmx_utilities_pkg.log_module_message
                              --     (
                              --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                              --     ,pt_i_Application       => gct_Application
                              --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                              --     ,pt_i_SubEntity         => pt_i_SubEntity
                              --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              --     ,pt_i_Phase             => ct_Phase
                              --     ,pt_i_Severity          => 'NOTIFICATION'
                              --     ,pt_i_PackageName       => gct_PackageName
                              --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              --     ,pt_i_ModuleMessage     => '    - vn_TrxLineBalanceRemaining (A)          = '
                              --                              ||vn_TrxLineBalanceRemaining
                              --     ,pt_i_OracleError       => NULL
                              --     );
                              --
                              gvv_ProgressIndicator := '0310';
                              --
                              FOR UpdTrxSalescreditAmount_rec
                              IN  UpdTrxSalescreditAmounts_cur
                                       (
                                        pt_i_MigrationsetID
                                       ,UpdatedTrxLineAmount_rec.xxmx_customer_trx_id
                                       ,UpdatedTrxLineAmount_rec.xxmx_customer_trx_line_id
                                       )
                              LOOP
                                   --
                                   /*
                                   ** Calculate what portion of the original line amount
                                   ** the original distribution amount accounts for (as a decimal number
                                   ** e.g. 0.15 this number when multipled by 100 would be a
                                   ** percentage e.g. 15%).
                                   **
                                   ** Rounding will be done on the new line amount.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0320';
                                   --
                                   vn_OrigSalescreditAmtRatio :=  UpdTrxSalescreditAmount_rec.original_salescredit_amount
                                                                / UpdatedTrxLineAmount_rec.xxmx_orig_trx_line_amount;
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite => gct_ApplicationSuite
                                   --     ,pt_i_Application      => gct_Application
                                   --     ,pt_i_BusinessEntity   => gct_BusinessEntity
                                   --     ,pt_i_SubEntity        => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                                   --     ,pt_i_Phase            => ct_Phase
                                   --     ,pt_i_Severity         => 'NOTIFICATION'
                                   --     ,pt_i_PackageName      => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName   => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator=> gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage    => '    - Original Line Amount (B)              = '
                                   --                             ||UpdatedTrxLineAmount_rec.xxmx_orig_trx_line_amount
                                   --     ,pt_i_OracleError      => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - Original Dist Amount (C)              = '
                                   --                              ||UpdTrxSalescreditAmount_rec.original_salescredit_amount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_OrigSalescreditAmtRatio (D) = (C/B)       = '
                                   --                              ||vn_OrigSalescreditAmtRatio
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** Calculate the new distribution amount remaining as a portion
                                   ** of the distibution amount.
                                   **
                                   ** This will be rounded to 2 decimal places.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0330';
                                   --
                                   vn_NewSalescreditRemainAmount := ROUND(
                                                                          (
                                                                             UpdatedTrxLineAmount_rec.updated_line_amount
                                                                           * vn_OrigSalescreditAmtRatio
                                                                          )
                                                                        ,2
                                                                        );
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - Updated Line Amount (E)               = '
                                   --                              ||UpdatedTrxLineAmount_rec.updated_line_amount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   ----
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_NewSalescreditRemainAmount (F) = (E*D) = '
                                   --                              ||vn_NewSalescreditRemainAmount
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** To calculate if there is any Transaction open balance remaining after
                                   ** new values have been calculated for each line, we subtract the new line
                                   ** amount from the transaction open balance.  Any remainder will be added
                                   ** to the last line.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0340';
                                   --
                                   vn_TrxLineBalanceRemaining :=   vn_TrxLineBalanceRemaining
                                                                 - vn_NewSalescreditRemainAmount;
                                   --
                                   --xxmx_utilities_pkg.log_module_message
                                   --     (
                                   --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   --     ,pt_i_Application       => gct_Application
                                   --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   --     ,pt_i_SubEntity         => pt_i_SubEntity
                                   --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   --     ,pt_i_Phase             => ct_Phase
                                   --     ,pt_i_Severity          => 'NOTIFICATION'
                                   --     ,pt_i_PackageName       => gct_PackageName
                                   --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   --     ,pt_i_ModuleMessage     => '    - vn_TrxLineBalanceRemaining (A = A-F) = '
                                   --                              ||vn_TrxLineBalanceRemaining
                                   --     ,pt_i_OracleError       => NULL
                                   --     );
                                   --
                                   /*
                                   ** If we have calculated the new line amount for the last line and
                                   ** if we still have any open balance remaining for the entire
                                   ** Transaction (should only be pennies) then add it to the last line.
                                   **
                                   ** Should the total of the new line amounts turn out to be slightly
                                   ** more then the original open balance remaining, then the transaction
                                   ** open balance remaining variable will be negative so in that case
                                   ** the open balance amount for the last line will be reduced accordingly.
                                   */
                                   --
                                   IF   UpdTrxSalescreditAmount_rec.xxmx_cust_trx_line_salesrep_id  = vn_LastTrxLineSalesrepID
                                   AND  vn_TrxLineBalanceRemaining                                 <> 0
                                   THEN
                                        --
                                        gvv_ProgressIndicator := '0350';
                                        --
                                        vn_NewSalescreditRemainAmount := vn_NewSalescreditRemainAmount + vn_TrxLineBalanceRemaining;
                                        --
                                        --xxmx_utilities_pkg.log_module_message
                                        --     (
                                        --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                        --     ,pt_i_Application       => gct_Application
                                        --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        --     ,pt_i_SubEntity         => pt_i_SubEntity
                                        --     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        --     ,pt_i_Phase             => ct_Phase
                                        --     ,pt_i_Severity          => 'NOTIFICATION'
                                        --     ,pt_i_PackageName       => gct_PackageName
                                        --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        --     ,pt_i_ModuleMessage     => '    - vn_NewSalescreditRemainAmount (Updated for rem line balance) = '
                                        --                              ||vn_TrxLineBalanceRemaining
                                        --     ,pt_i_OracleError       => NULL
                                        --     );
                                        --
                                   END IF;
                                   --
                                   gvv_ProgressIndicator := '0360';
                                   --
                                   UPDATE xxmx_ar_trx_salescredits_xfm  xatsx
                                   SET    sales_credit_amount_split = vn_NewSalescreditRemainAmount
                                   WHERE  1 = 1
                                   AND    xatsx.xxmx_customer_trx_id           = UpdTrxSalescreditAmount_rec.xxmx_customer_trx_id         
                                   AND    xatsx.xxmx_customer_trx_line_id      = UpdTrxSalescreditAmount_rec.xxmx_customer_trx_line_id    
                                   AND    xatsx.xxmx_cust_trx_line_salesrep_id = UpdTrxSalescreditAmount_rec.xxmx_cust_trx_line_salesrep_id;
                                   --
                              END LOOP; --** UpdTrxSalescreditAmounts_cur LOOP
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0370';
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
                                   ,pt_i_ModuleMessage       => '    - No transaction salescredits found in the "xxmx_ar_trx_salescredits_xfm" '
                                                              ||'table for XXMX_CUSTOMER_TRX_ID ['
                                                              ||UpdatedTrxLineAmount_rec.xxmx_customer_trx_id
                                                              ||'] (TRX_NUMBER ['
                                                              ||UpdatedTrxLineAmount_rec.trx_number
                                                              ||']) and XXMX_CUSTOMER_TRX_LINE_ID ['
                                                              ||UpdatedTrxLineAmount_rec.xxmx_customer_trx_line_id
                                                              ||'] (XXMX_LINE_NUMBER ['
                                                              ||UpdatedTrxLineAmount_rec.xxmx_line_number
                                                              ||']).'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF; --** vn_LastTrxLineDistID IS NOT NULL
                         --
                    END LOOP; --** PartiallyPaidTrxLines_cur
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '  - Transaction Distribution Amount Re-calculation complete.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0380';
                    --
                    COMMIT;
                    --
                         /*
                         ** Commit the complex transformation updates for the XFM table.
                         */
                         --
                         gvv_ProgressIndicator := '0280';
                         --
                         COMMIT;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Complex transformation complete.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0300';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'WARNING'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '- Complex transformations are required for Sub-Entity "'
                                                       ||pt_i_SubEntity
                                                       ||'", however they could not be performed due to absent transform data.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF   gvb_PerformComplexTransforms
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0320';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- No complex transformations are required for Sub-Entity "'
                                                  ||pt_i_SubEntity
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF   gvb_ComplexTransformsRequired
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
                    ,pt_i_TransformTable          => ct_XfmTable
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Transformation Table "'
                                             ||ct_XfmTable
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END ar_trx_salescredits_xfm;
     --
     --
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
     */
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
          --** DSF 27/10/2020 - Removed Sequence Numbers and Stg Table as they no longer need to be passed as parameters.
               --
               SELECT  xmm.sub_entity
                      ,xmm.entity_package_name
                      ,xmm.stg_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
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
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'EXTRACT';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
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
          OR   pt_i_MigrationSetName IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          --
           gvv_ReturnStatus  := '';
          --
          /*
          ** Clear Core Module Messages
          */
          --** DSF (as per ISV) 27/10/2020 - Commented out for now as not sure this would remove messages written by other extracts.
          --
/*           xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => 'XXMX'
               ,pt_i_Application         => 'XXMX'
               ,pt_i_BusinessEntity      => 'CORE_REPORTING'
               ,pt_i_SubEntity           => NULL
               ,pt_i_Phase               => 'CORE'
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
 */          --
          /*
          ** Clear RA Invoice Stating
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
          --
          --** DSF 27/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and 
          /*
          ** Retrieve the Client Config Parameters needed to call subsequent procedures.
          */
          --
          -- vt_ConfigParameter := 'CLIENT_SCHEMA_NAME';

          -- vt_ClientSchemaName := xxmx_utilities_pkg.get_client_config_value
                                      -- (
                                       -- pt_i_ClientCode      => pt_i_ClientCode
                                      -- ,pt_i_ConfigParameter => vt_ConfigParameter
                                      -- );

          -- IF   vt_ClientSchemaName IS NULL
          -- THEN


               -- gvt_Severity      := 'ERROR';

               -- gvt_ModuleMessage := '- Client configuration parameter "'
                                  -- ||vt_ConfigParameter
                                  -- ||'" does not exist in "xxmx_client_config_parameters" table.';

               -- RAISE e_ModuleError;


          -- END IF;

          -- xxmx_utilities_pkg.log_module_message
               -- (
                -- pt_i_ApplicationSuite    => gct_ApplicationSuite
               -- ,pt_i_Application         => gct_Application
               -- ,pt_i_BusinessEntity      => gct_BusinessEntity
               -- ,pt_i_SubEntity           => ct_SubEntity
               -- ,pt_i_Phase               => ct_Phase
               -- ,pt_i_Severity            => 'NOTIFICATION'
               -- ,pt_i_PackageName         => gct_PackageName
               -- ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               -- ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               -- ,pt_i_ModuleMessage       => '- '
                                            -- ||pt_i_ClientCode
                                            -- ||' Client Config Parameter "'
                                            -- ||vt_ConfigParameter
                                            -- ||'" = '
                                            -- ||vt_ClientSchemaName
               -- ,pt_i_OracleError         => NULL
               -- );
          --
          /*
          ** Initialize the Migration Set for the Business Entity retrieving
          ** a new Migration Set ID.
          */
          --
          --
          --** DSF 27/10/2020 - Removed Sequence Number Parameters as "init_migration_set" procedure will determine these
          --                    from the metadata table based on Application Suite, Application and Business Entity parameters.
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
                                                        '- Generated SQL Statement: ' ||gvv_SQLStatement
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
          -- Call TRX Customisation Package
          --
         -- xxmx_ar_trx_cm_pkg.ar_trx_customisations_stg(vt_MigrationSetID);
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
     END stg_main;
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR Metadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               --
               SELECT  xmm.sub_entity
                      ,xmm.entity_package_name
                      ,xmm.xfm_procedure_name
                      ,xmm.simple_xfm_performed_by
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
               --
               --
          --** END CURSOR Metadata_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xfm_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
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
          IF   pt_i_MigrationSetID IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Clear Core Module Messages
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => 'XXMX'
               ,pt_i_Application      => 'XXMX'
               ,pt_i_BusinessEntity   => 'CORE_REPORTING'
               ,pt_i_SubEntity        => NULL
               ,pt_i_Phase            => 'CORE'
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
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          /*
          ** Clear Module Messages
          */
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => ct_SubEntity
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
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Transform Package Name and Procedure Name required
          ** to perform the transform process for each Business Entity
          ** and Sub-entity.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          FOR  Metadata_rec
          IN   Metadata_cur
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
          LOOP
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
                    ,pt_i_ModuleMessage     => '- Calling Procedure "'
                                             ||Metadata_rec.entity_package_name
                                             ||'.'
                                             ||Metadata_rec.xfm_procedure_name
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||Metadata_rec.entity_package_name
                                 ||'.'
                                 ||Metadata_rec.xfm_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||' pt_i_MigrationSetID          => '
                                 ||pt_i_MigrationSetID
                                 ||',pt_i_SubEntity     => '''
                                 ||Metadata_rec.sub_entity
                                 ||''''
                                 ||',pt_i_SimpleXfmPerformedBy => '''
                                 ||Metadata_rec.simple_xfm_performed_by
                                 ||''''
                                 ||'); END;';
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
                    ,pt_i_ModuleMessage     => SUBSTR(
                                                      '- Generated SQL Statement: '
                                                    ||gvv_SQLStatement
                                                     ,1
                                                     ,4000
                                                     )
                    ,pt_i_OracleError       => NULL
                    );
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
          END LOOP;
          --
          gvv_ProgressIndicator := '0060';
          --
          --xxmx_utilities_pkg.close_transform_phase
          --     (
          --      vt_MigrationSetID
          --     );
          --
          COMMIT;
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END xfm_main;
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
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
          --vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
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
          IF   pt_i_ClientCode     IS NOT NULL
          AND  pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetID" parameters are mandatory.';
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
          --
          --** DSF 27/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and 
          -- gvv_ProgressIndicator := '0030';

          -- vt_ConfigParameter := 'CLIENT_SCHEMA_NAME';

          -- vt_ClientSchemaName := xxmx_utilities_pkg.get_client_config_value
                                      -- (
                                       -- pt_i_ClientCode      => pt_i_ClientCode
                                      -- ,pt_i_ConfigParameter => vt_ConfigParameter
                                      -- );

          -- IF   vt_ClientSchemaName IS NULL
          -- THEN


               -- gvt_ModuleMessage := '- Client configuration parameter "'
                                  -- ||vt_ConfigParameter
                                  -- ||'" does not exist in "xxmx_client_config_parameters" table.';

               -- RAISE e_ModuleError;


          -- END IF;

          -- xxmx_utilities_pkg.log_module_message
               -- (
                -- pt_i_ApplicationSuite    => gct_ApplicationSuite
               -- ,pt_i_Application         => gct_Application
               -- ,pt_i_BusinessEntity      => gct_BusinessEntity
               -- ,pt_i_SubEntity           => ct_SubEntity
               -- ,pt_i_MigrationSetID      => vt_MigrationSetID
               -- ,pt_i_Phase               => ct_Phase
               -- ,pt_i_Severity            => 'NOTIFICATION'
               -- ,pt_i_PackageName         => gct_PackageName
               -- ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               -- ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               -- ,pt_i_ModuleMessage       => '- '
                                            -- ||pt_i_ClientCode
                                            -- ||' Client Config Parameter "'
                                            -- ||vt_ConfigParameter
                                            -- ||'" = '
                                            -- ||vt_ClientSchemaName
               -- ,pt_i_OracleError         => NULL
               -- );
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
               ,pt_i_ModuleMessage       => '- Purging tables.'
               ,pt_i_OracleError         => NULL
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
                    ,ct_SubEntity
                    )
          LOOP
               --
               gvv_SQLTableClause := 'FROM '
                                   ||gct_StgSchema
                                   ||'.'
                                   ||PurgingMetadata_rec.stg_table;
               --
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
               --                                  ||PurgingMetadata_rec.xfm_table
               --                                  ||'" table: '
               --                                  ||gvn_RowCount
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
          gvv_SQLTableClause := 'FROM '
                              ||gct_StgSchema
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
          vv_PurgeTableName := 'xxmx_migration_headers';
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_StgSchema
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
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
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
     END purge;
     --
END xxmx_ar_trx_pkg;
/
SHOW ERRORS PACKAGE BODY xxmx_ar_trx_pkg;
/