CREATE OR REPLACE PACKAGE xxmx_ap_inv_pkg 
AS
     --
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
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
     ** FILENAME  :  xxmx_ap_inv_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.3
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Ian S. Vickerstaff
     **
     ** PURPOSE   :  This script installs the package for the Maximise AP Invoices
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
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_xfm_dbi.sql
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
     **   1.0  23-NOV-2020  Ian S. Vickerstaff  Created for Maximise.
     **
     **   1.1  08-JAN-2020  Ian S. Vickerstaff  Extract logic updates.
     **
     **   1.2  20-JAN-2020  Ian S. Vickerstaff  Added GL Account Defaulting logic.
     **                                         However development halted at this
     **                                         stage as SMBC put AP Invoices out
     **                                         of scope for Migration.
     **
     **   1.3  14-Jul-2021  Ian S. Vickerstaff  Header comments updated.
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
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_stg
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_xfm
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_stg
     **********************************
     */
     --
     PROCEDURE ap_invoice_lines_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_xfm
     **********************************
     */
     --
     PROCEDURE ap_invoice_lines_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
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
END xxmx_ap_inv_pkg;


/


CREATE OR REPLACE PACKAGE BODY xxmx_ap_inv_pkg 
AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ap_inv_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'INVOICES';
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
     ** Global Variables for Nigration Set Name
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
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_stg
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_stg 
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
          -- Cursor to get the detail AP Invoice Headers
          --
          CURSOR ap_invoice_hdr_cur
          IS
               --
               SELECT     aia.invoice_id                                             AS invoice_id
                         ,TRIM(haou.name)                                            AS operating_unit
                         ,(
                           SELECT gl.name
                           FROM   apps.gl_ledgers@mxdm_nvis_extract  gl
                           WHERE  1 = 1
                           AND    gl.ledger_id = aia.set_of_books_id
                          )                                                          AS ledger_name
                         ,TRIM(aia.invoice_num)                                      AS invoice_num
                         ,ROUND(aia.invoice_amount - nvl(aia.amount_paid, 0),2)      AS invoice_amount
                         ,aia.invoice_date                                           AS invoice_date
                         ,TRIM(aps.vendor_name)                                      AS vendor_name
                         ,TRIM(aps.segment1)                                         AS vendor_num
                         ,TRIM(assa.vendor_site_code)                                AS vendor_site_code
                         ,TRIM(aia.invoice_currency_code)                            AS invoice_currency_code
                         ,TRIM(aia.payment_currency_code)                            AS payment_currency_code
                         ,TRIM(aia.description)                                      AS description
                         ,TRIM(aia.invoice_type_lookup_code)                         AS invoice_type_lookup_code
                         ,TRIM((SELECT xep.name
                                FROM apps.xle_entity_profiles@MXDM_NVIS_EXTRACT xep
                                WHERE xep.legal_entity_id = aia.legal_entity_id))    AS legal_entity_name
                         ,TRIM(aia.cust_registration_number)                         AS cust_registration_number
                         ,TRIM(aia.Cust_Registration_Code)                           AS cust_registration_code
                         ,NULL                                                       AS first_party_registration_num
                         ,NULL                                                       AS third_party_registration_num
                         ,TRIM(apt.name)                                             AS terms_name
                         ,TRIM(aia.terms_date)                                       AS terms_date
                         ,TRIM(aia.goods_received_date)                              AS goods_received_date
                         ,TRIM(aia.invoice_received_date)                            AS invoice_received_date
                         ,TRIM(aia.gl_date)                                          AS gl_date
                         ,TRIM(aia.payment_method_code)                              AS payment_method_code
                         ,TRIM(aia.pay_group_lookup_code)                            AS pay_group_lookup_code -- EDQ Mapping take mapping from GRID Log Business Stream
                         ,TRIM(aia.exclusive_payment_flag)                           AS exclusive_payment_flag
                         ,TRIM(aia.amount_applicable_to_discount)                    AS amount_applicable_to_discount
                         ,NULL                                                       AS prepay_num
                         ,NULL                                                       AS prepay_line_num
                         ,NULL                                                       AS prepay_apply_amount
                         ,NULL                                                       AS prepay_gl_date
                         ,NULL                                                       AS invoice_includes_prepay_flag
                         ,NULL                                                       AS exchange_rate_type
                         ,TRIM(aia.exchange_date)                                    AS exchange_date
                         ,TRIM(aia.exchange_rate)                                    AS exchange_rate
                         ,TRIM(gcck.concatenated_segments)                           AS accts_pay_code_concatenated -- EDQ Mapping LIABILITY_ACCOUNT
                         ,TRIM(aia.doc_category_code)                                AS doc_category_code
                         ,TRIM(''    )                                               AS voucher_num
                         ,NULL                                                       AS requester_first_name
                         ,NULL                                                       AS requester_last_name
                         ,NULL                                                       AS requester_employee_num
                         ,TRIM(aia.delivery_channel_code)                            AS delivery_channel_code
                         ,TRIM(aia.bank_charge_bearer)                               AS bank_charge_bearer
                         ,TRIM(aia.remit_to_supplier_name)                           AS remit_to_supplier_name
                         ,NULL                                                       AS remit_to_supplier_num
                         ,NULL                                                       AS remit_to_address_name
                         ,NULL                                                       AS payment_priority
                         ,TRIM(aia.settlement_priority)                              AS settlement_priority
                         ,TRIM(aia.unique_remittance_identifier)                     AS unique_remittance_identifier
                         ,TRIM(aia.uri_check_digit)                                  AS uri_check_digit
                         ,TRIM(aia.payment_reason_code)                              AS payment_reason_code
                         ,TRIM(aia.payment_reason_comments)                          AS payment_reason_comments
                         ,TRIM(aia.remittance_message1)                              AS remittance_message1
                         ,TRIM(aia.remittance_message2)                              AS remittance_message2
                         ,TRIM(aia.remittance_message3)                              AS remittance_message3
                         ,NULL                                                       AS awt_group_name
                         ,NULL                                                       AS ship_to_location
                         ,TRIM(aia.taxation_country)                                 AS taxation_country
                         ,TRIM(aia.document_sub_type)                                AS document_sub_type
                         ,TRIM(aia.tax_invoice_internal_seq)                         AS tax_invoice_internal_seq
                         ,TRIM(aia.supplier_tax_invoice_number)                      AS supplier_tax_invoice_number
                         ,TRIM(aia.tax_invoice_recording_date)                       AS tax_invoice_recording_date
                         ,TRIM(aia.supplier_tax_invoice_date)                        AS supplier_tax_invoice_date
                         ,TRIM(aia.supplier_tax_exchange_rate)                       AS supplier_tax_exchange_rate
                         ,TRIM(aia.port_of_entry_code)                               AS port_of_entry_code
                         ,NULL                                                       AS correction_year
                         ,NULL                                                       AS correction_period
                         ,NULL                                                       AS import_document_number
                         ,NULL                                                       AS import_document_date
                         ,TRIM(aia.control_amount)                                   AS control_amount
                         ,NULL                                                       AS calc_tax_during_import_flag -- EDQ MApping 'N'
                         ,NULL                                                       AS add_tax_to_inv_amt_flag -- EDQ MApping 'N'
                         ,NULL                                                       AS attribute_category
                         ,NULL                                                       AS attribute1
                         ,NULL                                                       AS attribute2
                         ,NULL                                                       AS attribute3
                         ,NULL                                                       AS attribute4
                         ,NULL                                                       AS attribute5
                         ,NULL                                                       AS attribute6
                         ,NULL                                                       AS attribute7
                         ,NULL                                                       AS attribute8
                         ,NULL                                                       AS attribute9
                         ,NULL                                                       AS attribute10
                         ,NULL                                                       AS attribute11
                         ,NULL                                                       AS attribute12
                         ,NULL                                                       AS attribute13
                         ,NULL                                                       AS attribute14
                         ,NULL                                                       AS attribute15
                         ,NULL                                                       AS attribute_number1
                         ,NULL                                                       AS attribute_number2
                         ,NULL                                                       AS attribute_number3
                         ,NULL                                                       AS attribute_number4
                         ,NULL                                                       AS attribute_number5
                         ,NULL                                                       AS attribute_date1
                         ,NULL                                                       AS attribute_date2
                         ,NULL                                                       AS attribute_date3
                         ,NULL                                                       AS attribute_date4
                         ,NULL                                                       AS attribute_date5
                         ,NULL/*aia.global_attribute_category*/                      AS global_attribute_category
                         ,NULL/*aia.global_attribute1*/                              AS global_attribute1
                         ,NULL/*aia.global_attribute2*/                              AS global_attribute2
                         ,NULL/*aia.global_attribute3*/                              AS global_attribute3
                         ,NULL/*aia.global_attribute4*/                              AS global_attribute4
                         ,NULL/*aia.global_attribute5*/                              AS global_attribute5
                         ,NULL/*aia.global_attribute6*/                              AS global_attribute6
                         ,NULL/*aia.global_attribute7*/                              AS global_attribute7
                         ,NULL/*aia.global_attribute8*/                              AS global_attribute8
                         ,NULL/*aia.global_attribute9*/                              AS global_attribute9
                         ,NULL/*aia.global_attribute10*/                             AS global_attribute10
                         ,NULL/*aia.global_attribute11*/                             AS global_attribute11
                         ,NULL/*aia.global_attribute12*/                             AS global_attribute12
                         ,NULL/*aia.global_attribute13*/                             AS global_attribute13
                         ,NULL/*aia.global_attribute14*/                             AS global_attribute14
                         ,NULL/*aia.global_attribute15*/                             AS global_attribute15
                         ,NULL/*aia.global_attribute16*/                             AS global_attribute16
                         ,NULL/*aia.global_attribute17*/                             AS global_attribute17
                         ,NULL/*aia.global_attribute18*/                             AS global_attribute18
                         ,NULL/*aia.global_attribute19*/                             AS global_attribute19
                         ,NULL/*aia.global_attribute20*/                             AS global_attribute20
                         ,NULL                                                       AS global_attribute_number1
                         ,NULL                                                       AS global_attribute_number2
                         ,NULL                                                       AS global_attribute_number3
                         ,NULL                                                       AS global_attribute_number4
                         ,NULL                                                       AS global_attribute_number5
                         ,NULL                                                       AS global_attribute_date1
                         ,NULL                                                       AS global_attribute_date2
                         ,NULL                                                       AS global_attribute_date3
                         ,NULL                                                       AS global_attribute_date4
                         ,NULL                                                       AS global_attribute_date5
                         ,NULL                                                       AS image_document_uri
               FROM       xxmx_ap_inv_scope_v                                           selection
                         ,apps.ap_invoices_all@MXDM_NVIS_EXTRACT                        aia
                         ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT                  assa
                         ,apps.ap_suppliers@MXDM_NVIS_EXTRACT                           aps
                         ,apps.hz_parties@MXDM_NVIS_EXTRACT                             hp
                         ,apps.ap_terms_tl@MXDM_NVIS_EXTRACT                            apt
                         ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT              haou
                         ,apps.gl_code_combinations@MXDM_NVIS_EXTRACT                   gcc
                         ,apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT               gcck
               WHERE      aia.invoice_id                     = selection.invoice_id
               AND        haou.organization_id               = aia.org_id
               AND        aia.accts_pay_code_combination_id  = gcc.code_combination_id
               AND        gcc.rowid                          = gcck.row_id
               AND        assa.vendor_site_id                = aia.vendor_site_id
               AND        aps.vendor_id                      = assa.vendor_id
               AND        hp.party_id                        = aps.party_id
               AND        apt.term_id                        = aia.terms_id
               AND        apt.language                       = 'US';
               --
          --** END CURSOR ** 
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_invoice_hdr_tt IS TABLE OF ap_invoice_hdr_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_invoice_hdr_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_invoices_stg';
          --
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
          ap_invoice_hdr_tbl ap_invoice_hdr_tt;
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
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite        => gct_ApplicationSuite
               ,pt_i_Application             => gct_Application
               ,pt_i_BusinessEntity          => gct_BusinessEntity
               ,pt_i_SubEntity               => pt_i_SubEntity 
               ,pt_i_Phase                   => ct_Phase
               ,pt_i_MessageType             => 'MODULE'
               ,pv_o_ReturnStatus            => gvv_ReturnStatus
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
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
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
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'".'
                    ,pt_i_OracleError       => NULL
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity 
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the data and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_invoice_hdr_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               --
               LOOP
                    --
                    FETCH       ap_invoice_hdr_cur  
                    BULK COLLECT 
                    INTO        ap_invoice_hdr_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    EXIT WHEN   ap_invoice_hdr_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL i IN 1..ap_invoice_hdr_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_stg.xxmx_ap_invoices_stg
                                (
                                  migration_set_id
                                 ,migration_set_name
                                 ,migration_status
                                 ,invoice_id
                                 ,operating_unit
                                 ,ledger_name
                                 ,invoice_num
                                 ,invoice_amount
                                 ,invoice_date
                                 ,vendor_name
                                 ,vendor_num
                                 ,vendor_site_code
                                 ,invoice_currency_code
                                 ,payment_currency_code
                                 ,description
                                 ,invoice_type_lookup_code
                                 ,legal_entity_name
                                 ,cust_registration_number
                                 ,cust_registration_code
                                 ,first_party_registration_num
                                 ,third_party_registration_num
                                 ,terms_name
                                 ,terms_date
                                 ,goods_received_date
                                 ,invoice_received_date
                                 ,gl_date
                                 ,payment_method_code
                                 ,pay_group_lookup_code
                                 ,exclusive_payment_flag
                                 ,amount_applicable_to_discount
                                 ,prepay_num
                                 ,prepay_line_num
                                 ,prepay_apply_amount
                                 ,prepay_gl_date
                                 ,invoice_includes_prepay_flag
                                 ,exchange_rate_type
                                 ,exchange_date
                                 ,exchange_rate
                                 ,accts_pay_code_concatenated
                                 ,doc_category_code
                                 ,voucher_num
                                 ,requester_first_name
                                 ,requester_last_name
                                 ,requester_employee_num
                                 ,delivery_channel_code
                                 ,bank_charge_bearer
                                 ,remit_to_supplier_name
                                 ,remit_to_supplier_num
                                 ,remit_to_address_name
                                 ,payment_priority
                                 ,settlement_priority
                                 ,unique_remittance_identifier
                                 ,uri_check_digit
                                 ,payment_reason_code
                                 ,payment_reason_comments
                                 ,remittance_message1
                                 ,remittance_message2
                                 ,remittance_message3
                                 ,awt_group_name
                                 ,ship_to_location
                                 ,taxation_country
                                 ,document_sub_type
                                 ,tax_invoice_internal_seq
                                 ,supplier_tax_invoice_number
                                 ,tax_invoice_recording_date
                                 ,supplier_tax_invoice_date
                                 ,supplier_tax_exchange_rate
                                 ,port_of_entry_code
                                 ,correction_year
                                 ,correction_period
                                 ,import_document_number
                                 ,import_document_date
                                 ,control_amount
                                 ,calc_tax_during_import_flag
                                 ,add_tax_to_inv_amt_flag
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
                                 ,attribute_number1
                                 ,attribute_number2
                                 ,attribute_number3
                                 ,attribute_number4
                                 ,attribute_number5
                                 ,attribute_date1
                                 ,attribute_date2
                                 ,attribute_date3
                                 ,attribute_date4
                                 ,attribute_date5
                                 ,global_attribute_category
                                 ,global_attribute1
                                 ,global_attribute2
                                 ,global_attribute3
                                 ,global_attribute4
                                 ,global_attribute5
                                 ,global_attribute6
                                 ,global_attribute7
                                 ,global_attribute8
                                 ,global_attribute9
                                 ,global_attribute10
                                 ,global_attribute11
                                 ,global_attribute12
                                 ,global_attribute13
                                 ,global_attribute14
                                 ,global_attribute15
                                 ,global_attribute16
                                 ,global_attribute17
                                 ,global_attribute18
                                 ,global_attribute19
                                 ,global_attribute20
                                 ,global_attribute_number1
                                 ,global_attribute_number2
                                 ,global_attribute_number3
                                 ,global_attribute_number4
                                 ,global_attribute_number5
                                 ,global_attribute_date1
                                 ,global_attribute_date2
                                 ,global_attribute_date3
                                 ,global_attribute_date4
                                 ,global_attribute_date5
                                 ,image_document_uri
                                 )
                         VALUES (
                                 pt_i_MigrationSetID                               --MIGRATION_SET_ID
                                ,gvt_MigrationSetName 
                                ,'EXTRACTED'
                                ,ap_invoice_hdr_tbl(i).invoice_id
                                ,ap_invoice_hdr_tbl(i).operating_unit
                                ,ap_invoice_hdr_tbl(i).ledger_name
                                ,ap_invoice_hdr_tbl(i).invoice_num
                                ,ap_invoice_hdr_tbl(i).invoice_amount
                                ,ap_invoice_hdr_tbl(i).invoice_date
                                ,ap_invoice_hdr_tbl(i).vendor_name
                                ,ap_invoice_hdr_tbl(i).vendor_num
                                ,ap_invoice_hdr_tbl(i).vendor_site_code
                                ,ap_invoice_hdr_tbl(i).invoice_currency_code
                                ,ap_invoice_hdr_tbl(i).payment_currency_code
                                ,ap_invoice_hdr_tbl(i).description
                                ,ap_invoice_hdr_tbl(i).invoice_type_lookup_code
                                ,ap_invoice_hdr_tbl(i).legal_entity_name
                                ,ap_invoice_hdr_tbl(i).cust_registration_number
                                ,ap_invoice_hdr_tbl(i).cust_registration_code
                                ,ap_invoice_hdr_tbl(i).first_party_registration_num
                                ,ap_invoice_hdr_tbl(i).third_party_registration_num
                                ,ap_invoice_hdr_tbl(i).terms_name
                                ,ap_invoice_hdr_tbl(i).terms_date
                                ,ap_invoice_hdr_tbl(i).goods_received_date
                                ,ap_invoice_hdr_tbl(i).invoice_received_date
                                ,ap_invoice_hdr_tbl(i).gl_date
                                ,ap_invoice_hdr_tbl(i).payment_method_code
                                ,ap_invoice_hdr_tbl(i).pay_group_lookup_code
                                ,ap_invoice_hdr_tbl(i).exclusive_payment_flag
                                ,ap_invoice_hdr_tbl(i).amount_applicable_to_discount
                                ,ap_invoice_hdr_tbl(i).prepay_num
                                ,ap_invoice_hdr_tbl(i).prepay_line_num
                                ,ap_invoice_hdr_tbl(i).prepay_apply_amount
                                ,ap_invoice_hdr_tbl(i).prepay_gl_date
                                ,ap_invoice_hdr_tbl(i).invoice_includes_prepay_flag
                                ,ap_invoice_hdr_tbl(i).exchange_rate_type
                                ,ap_invoice_hdr_tbl(i).exchange_date
                                ,ap_invoice_hdr_tbl(i).exchange_rate
                                ,ap_invoice_hdr_tbl(i).accts_pay_code_concatenated
                                ,ap_invoice_hdr_tbl(i).doc_category_code
                                ,ap_invoice_hdr_tbl(i).voucher_num
                                ,ap_invoice_hdr_tbl(i).requester_first_name
                                ,ap_invoice_hdr_tbl(i).requester_last_name
                                ,ap_invoice_hdr_tbl(i).requester_employee_num
                                ,ap_invoice_hdr_tbl(i).delivery_channel_code
                                ,ap_invoice_hdr_tbl(i).bank_charge_bearer
                                ,ap_invoice_hdr_tbl(i).remit_to_supplier_name
                                ,ap_invoice_hdr_tbl(i).remit_to_supplier_num
                                ,ap_invoice_hdr_tbl(i).remit_to_address_name
                                ,ap_invoice_hdr_tbl(i).payment_priority
                                ,ap_invoice_hdr_tbl(i).settlement_priority
                                ,ap_invoice_hdr_tbl(i).unique_remittance_identifier
                                ,ap_invoice_hdr_tbl(i).uri_check_digit
                                ,ap_invoice_hdr_tbl(i).payment_reason_code
                                ,ap_invoice_hdr_tbl(i).payment_reason_comments
                                ,ap_invoice_hdr_tbl(i).remittance_message1
                                ,ap_invoice_hdr_tbl(i).remittance_message2
                                ,ap_invoice_hdr_tbl(i).remittance_message3
                                ,ap_invoice_hdr_tbl(i).awt_group_name
                                ,ap_invoice_hdr_tbl(i).ship_to_location
                                ,ap_invoice_hdr_tbl(i).taxation_country
                                ,ap_invoice_hdr_tbl(i).document_sub_type
                                ,ap_invoice_hdr_tbl(i).tax_invoice_internal_seq
                                ,ap_invoice_hdr_tbl(i).supplier_tax_invoice_number
                                ,ap_invoice_hdr_tbl(i).tax_invoice_recording_date
                                ,ap_invoice_hdr_tbl(i).supplier_tax_invoice_date
                                ,ap_invoice_hdr_tbl(i).supplier_tax_exchange_rate
                                ,ap_invoice_hdr_tbl(i).port_of_entry_code
                                ,ap_invoice_hdr_tbl(i).correction_year
                                ,ap_invoice_hdr_tbl(i).correction_period
                                ,ap_invoice_hdr_tbl(i).import_document_number
                                ,ap_invoice_hdr_tbl(i).import_document_date
                                ,ap_invoice_hdr_tbl(i).control_amount
                                ,ap_invoice_hdr_tbl(i).calc_tax_during_import_flag
                                ,ap_invoice_hdr_tbl(i).add_tax_to_inv_amt_flag
                                ,ap_invoice_hdr_tbl(i).attribute_category
                                ,ap_invoice_hdr_tbl(i).attribute1
                                ,ap_invoice_hdr_tbl(i).attribute2
                                ,ap_invoice_hdr_tbl(i).attribute3
                                ,ap_invoice_hdr_tbl(i).attribute4
                                ,ap_invoice_hdr_tbl(i).attribute5
                                ,ap_invoice_hdr_tbl(i).attribute6
                                ,ap_invoice_hdr_tbl(i).attribute7
                                ,ap_invoice_hdr_tbl(i).attribute8
                                ,ap_invoice_hdr_tbl(i).attribute9
                                ,ap_invoice_hdr_tbl(i).attribute10
                                ,ap_invoice_hdr_tbl(i).attribute11
                                ,ap_invoice_hdr_tbl(i).attribute12
                                ,ap_invoice_hdr_tbl(i).attribute13
                                ,ap_invoice_hdr_tbl(i).attribute14
                                ,ap_invoice_hdr_tbl(i).attribute15
                                ,ap_invoice_hdr_tbl(i).attribute_number1
                                ,ap_invoice_hdr_tbl(i).attribute_number2
                                ,ap_invoice_hdr_tbl(i).attribute_number3
                                ,ap_invoice_hdr_tbl(i).attribute_number4
                                ,ap_invoice_hdr_tbl(i).attribute_number5
                                ,ap_invoice_hdr_tbl(i).attribute_date1
                                ,ap_invoice_hdr_tbl(i).attribute_date2
                                ,ap_invoice_hdr_tbl(i).attribute_date3
                                ,ap_invoice_hdr_tbl(i).attribute_date4
                                ,ap_invoice_hdr_tbl(i).attribute_date5
                                ,ap_invoice_hdr_tbl(i).global_attribute_category
                                ,ap_invoice_hdr_tbl(i).global_attribute1
                                ,ap_invoice_hdr_tbl(i).global_attribute2
                                ,ap_invoice_hdr_tbl(i).global_attribute3
                                ,ap_invoice_hdr_tbl(i).global_attribute4
                                ,ap_invoice_hdr_tbl(i).global_attribute5
                                ,ap_invoice_hdr_tbl(i).global_attribute6
                                ,ap_invoice_hdr_tbl(i).global_attribute7
                                ,ap_invoice_hdr_tbl(i).global_attribute8
                                ,ap_invoice_hdr_tbl(i).global_attribute9
                                ,ap_invoice_hdr_tbl(i).global_attribute10
                                ,ap_invoice_hdr_tbl(i).global_attribute11
                                ,ap_invoice_hdr_tbl(i).global_attribute12
                                ,ap_invoice_hdr_tbl(i).global_attribute13
                                ,ap_invoice_hdr_tbl(i).global_attribute14
                                ,ap_invoice_hdr_tbl(i).global_attribute15
                                ,ap_invoice_hdr_tbl(i).global_attribute16
                                ,ap_invoice_hdr_tbl(i).global_attribute17
                                ,ap_invoice_hdr_tbl(i).global_attribute18
                                ,ap_invoice_hdr_tbl(i).global_attribute19
                                ,ap_invoice_hdr_tbl(i).global_attribute20
                                ,ap_invoice_hdr_tbl(i).global_attribute_number1
                                ,ap_invoice_hdr_tbl(i).global_attribute_number2
                                ,ap_invoice_hdr_tbl(i).global_attribute_number3
                                ,ap_invoice_hdr_tbl(i).global_attribute_number4
                                ,ap_invoice_hdr_tbl(i).global_attribute_number5
                                ,ap_invoice_hdr_tbl(i).global_attribute_date1
                                ,ap_invoice_hdr_tbl(i).global_attribute_date2
                                ,ap_invoice_hdr_tbl(i).global_attribute_date3
                                ,ap_invoice_hdr_tbl(i).global_attribute_date4
                                ,ap_invoice_hdr_tbl(i).global_attribute_date5
                                ,ap_invoice_hdr_tbl(i).image_document_uri
                                );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_invoice_hdr_cur;
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
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
                --
                --** Update the migration details (Migration status will be automatically determined
                --** in the called procedure dependant on the Phase and if an Error Message has been
                --** passed).
                --
                gvv_ProgressIndicator := '0100';
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity 
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
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
               --
               WHEN OTHERS
               THEN
                    --
                    IF   ap_invoice_hdr_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_invoice_hdr_cur;
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
     END ap_invoice_hdr_stg;
     --
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_xfm
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_xfm
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
                      ,invoice_id
                      ,operating_unit
                      ,ledger_name
                      ,invoice_num
                      ,invoice_amount
                      ,invoice_date
                      ,vendor_name
                      ,vendor_num
                      ,vendor_site_code
                      ,invoice_currency_code
                      ,payment_currency_code
                      ,description
                      ,invoice_type_lookup_code
                      ,legal_entity_name
                      ,cust_registration_number
                      ,cust_registration_code
                      ,first_party_registration_num
                      ,third_party_registration_num
                      ,terms_name
                      ,terms_date
                      ,goods_received_date
                      ,invoice_received_date
                      ,gl_date
                      ,payment_method_code
                      ,pay_group_lookup_code
                      ,exclusive_payment_flag
                      ,amount_applicable_to_discount
                      ,prepay_num
                      ,prepay_line_num
                      ,prepay_apply_amount
                      ,prepay_gl_date
                      ,invoice_includes_prepay_flag
                      ,exchange_rate_type
                      ,exchange_date
                      ,exchange_rate
                      ,accts_pay_code_concatenated
                      ,doc_category_code
                      ,voucher_num
                      ,requester_first_name
                      ,requester_last_name
                      ,requester_employee_num
                      ,delivery_channel_code
                      ,bank_charge_bearer
                      ,remit_to_supplier_name
                      ,remit_to_supplier_num
                      ,remit_to_address_name
                      ,payment_priority
                      ,settlement_priority
                      ,unique_remittance_identifier
                      ,uri_check_digit
                      ,payment_reason_code
                      ,payment_reason_comments
                      ,remittance_message1
                      ,remittance_message2
                      ,remittance_message3
                      ,awt_group_name
                      ,ship_to_location
                      ,taxation_country
                      ,document_sub_type
                      ,tax_invoice_internal_seq
                      ,supplier_tax_invoice_number
                      ,tax_invoice_recording_date
                      ,supplier_tax_invoice_date
                      ,supplier_tax_exchange_rate
                      ,port_of_entry_code
                      ,correction_year
                      ,correction_period
                      ,import_document_number
                      ,import_document_date
                      ,control_amount
                      ,calc_tax_during_import_flag
                      ,add_tax_to_inv_amt_flag
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
                      ,attribute_number1
                      ,attribute_number2
                      ,attribute_number3
                      ,attribute_number4
                      ,attribute_number5
                      ,attribute_date1
                      ,attribute_date2
                      ,attribute_date3
                      ,attribute_date4
                      ,attribute_date5
                      ,global_attribute_category
                      ,global_attribute1
                      ,global_attribute2
                      ,global_attribute3
                      ,global_attribute4
                      ,global_attribute5
                      ,global_attribute6
                      ,global_attribute7
                      ,global_attribute8
                      ,global_attribute9
                      ,global_attribute10
                      ,global_attribute11
                      ,global_attribute12
                      ,global_attribute13
                      ,global_attribute14
                      ,global_attribute15
                      ,global_attribute16
                      ,global_attribute17
                      ,global_attribute18
                      ,global_attribute19
                      ,global_attribute20
                      ,global_attribute_number1
                      ,global_attribute_number2
                      ,global_attribute_number3
                      ,global_attribute_number4
                      ,global_attribute_number5
                      ,global_attribute_date1
                      ,global_attribute_date2
                      ,global_attribute_date3
                      ,global_attribute_date4
                      ,global_attribute_date5
                      ,image_document_uri
               FROM    xxmx_ap_invoices_stg
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
                      ,invoice_id
                      ,source_operating_unit
                      ,fusion_business_unit
                      ,source_ledger_name
                      ,fusion_ledger_name
                      ,source
                      ,invoice_num
                      ,invoice_amount
                      ,invoice_date
                      ,vendor_name
                      ,vendor_num
                      ,vendor_site_code
                      ,invoice_currency_code
                      ,payment_currency_code
                      ,description
                      ,import_set
                      ,invoice_type_lookup_code
                      ,legal_entity_name
                      ,cust_registration_number
                      ,cust_registration_code
                      ,first_party_registration_num
                      ,third_party_registration_num
                      ,terms_name
                      ,terms_date
                      ,goods_received_date
                      ,invoice_received_date
                      ,gl_date
                      ,payment_method_code
                      ,pay_group_lookup_code
                      ,exclusive_payment_flag
                      ,amount_applicable_to_discount
                      ,prepay_num
                      ,prepay_line_num
                      ,prepay_apply_amount
                      ,prepay_gl_date
                      ,invoice_includes_prepay_flag
                      ,exchange_rate_type
                      ,exchange_date
                      ,exchange_rate
                      ,accts_pay_code_concatenated
                      ,doc_category_code
                      ,voucher_num
                      ,requester_first_name
                      ,requester_last_name
                      ,requester_employee_num
                      ,delivery_channel_code
                      ,bank_charge_bearer
                      ,remit_to_supplier_name
                      ,remit_to_supplier_num
                      ,remit_to_address_name
                      ,payment_priority
                      ,settlement_priority
                      ,unique_remittance_identifier
                      ,uri_check_digit
                      ,payment_reason_code
                      ,payment_reason_comments
                      ,remittance_message1
                      ,remittance_message2
                      ,remittance_message3
                      ,awt_group_name
                      ,ship_to_location
                      ,taxation_country
                      ,document_sub_type
                      ,tax_invoice_internal_seq
                      ,supplier_tax_invoice_number
                      ,tax_invoice_recording_date
                      ,supplier_tax_invoice_date
                      ,supplier_tax_exchange_rate
                      ,port_of_entry_code
                      ,correction_year
                      ,correction_period
                      ,import_document_number
                      ,import_document_date
                      ,control_amount
                      ,calc_tax_during_import_flag
                      ,add_tax_to_inv_amt_flag
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
                      ,attribute_number1
                      ,attribute_number2
                      ,attribute_number3
                      ,attribute_number4
                      ,attribute_number5
                      ,attribute_date1
                      ,attribute_date2
                      ,attribute_date3
                      ,attribute_date4
                      ,attribute_date5
                      ,global_attribute_category
                      ,global_attribute1
                      ,global_attribute2
                      ,global_attribute3
                      ,global_attribute4
                      ,global_attribute5
                      ,global_attribute6
                      ,global_attribute7
                      ,global_attribute8
                      ,global_attribute9
                      ,global_attribute10
                      ,global_attribute11
                      ,global_attribute12
                      ,global_attribute13
                      ,global_attribute14
                      ,global_attribute15
                      ,global_attribute16
                      ,global_attribute17
                      ,global_attribute18
                      ,global_attribute19
                      ,global_attribute20
                      ,global_attribute_number1
                      ,global_attribute_number2
                      ,global_attribute_number3
                      ,global_attribute_number4
                      ,global_attribute_number5
                      ,global_attribute_date1
                      ,global_attribute_date2
                      ,global_attribute_date3
                      ,global_attribute_date4
                      ,global_attribute_date5
                      ,image_document_uri
               FROM    xxmx_ap_invoices_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_invoice_hdr_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ap_invoices_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ap_invoices_xfm';
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
          vn_TransformRowCount            NUMBER;
          vt_MigrationStatus              xxmx_ap_invoice_lines_xfm.migration_status%TYPE;
          vt_FusionBusinessUnit           xxmx_ap_invoices_xfm.fusion_business_unit%TYPE;
          vt_FusionLedgerName             xxmx_ap_invoices_xfm.fusion_ledger_name%TYPE;
          vt_DefaultImportSource          xxmx_ap_invoices_xfm.source%TYPE;
          vt_DefaultPayCodeConcatenated   xxmx_ap_invoices_xfm.accts_pay_code_concatenated%TYPE;
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
                    FROM   xxmx_ap_invoices_xfm
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
                         FETCH        StgTable_cur
                         BULK COLLECT
                         INTO         StgTable_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    StgTable_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         FORALL APInvHdrs_idx IN 1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_ap_invoices_xfm
                                          (
                                           migration_set_id 
                                          ,migration_set_name
                                          ,migration_status
                                          ,invoice_id
                                          ,source_operating_unit
                                          ,fusion_business_unit
                                          ,source_ledger_name
                                          ,fusion_ledger_name
                                          ,source
                                          ,invoice_num
                                          ,invoice_amount
                                          ,invoice_date
                                          ,vendor_name
                                          ,vendor_num
                                          ,vendor_site_code
                                          ,invoice_currency_code
                                          ,payment_currency_code
                                          ,description
                                          ,import_set
                                          ,invoice_type_lookup_code
                                          ,legal_entity_name
                                          ,cust_registration_number
                                          ,cust_registration_code
                                          ,first_party_registration_num
                                          ,third_party_registration_num
                                          ,terms_name
                                          ,terms_date
                                          ,goods_received_date
                                          ,invoice_received_date
                                          ,gl_date
                                          ,payment_method_code
                                          ,pay_group_lookup_code
                                          ,exclusive_payment_flag
                                          ,amount_applicable_to_discount
                                          ,prepay_num
                                          ,prepay_line_num
                                          ,prepay_apply_amount
                                          ,prepay_gl_date
                                          ,invoice_includes_prepay_flag
                                          ,exchange_rate_type
                                          ,exchange_date
                                          ,exchange_rate
                                          ,accts_pay_code_concatenated
                                          ,doc_category_code
                                          ,voucher_num
                                          ,requester_first_name
                                          ,requester_last_name
                                          ,requester_employee_num
                                          ,delivery_channel_code
                                          ,bank_charge_bearer
                                          ,remit_to_supplier_name
                                          ,remit_to_supplier_num
                                          ,remit_to_address_name
                                          ,payment_priority
                                          ,settlement_priority
                                          ,unique_remittance_identifier
                                          ,uri_check_digit
                                          ,payment_reason_code
                                          ,payment_reason_comments
                                          ,remittance_message1
                                          ,remittance_message2
                                          ,remittance_message3
                                          ,awt_group_name
                                          ,ship_to_location
                                          ,taxation_country
                                          ,document_sub_type
                                          ,tax_invoice_internal_seq
                                          ,supplier_tax_invoice_number
                                          ,tax_invoice_recording_date
                                          ,supplier_tax_invoice_date
                                          ,supplier_tax_exchange_rate
                                          ,port_of_entry_code
                                          ,correction_year
                                          ,correction_period
                                          ,import_document_number
                                          ,import_document_date
                                          ,control_amount
                                          ,calc_tax_during_import_flag
                                          ,add_tax_to_inv_amt_flag
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
                                          ,attribute_number1
                                          ,attribute_number2
                                          ,attribute_number3
                                          ,attribute_number4
                                          ,attribute_number5
                                          ,attribute_date1
                                          ,attribute_date2
                                          ,attribute_date3
                                          ,attribute_date4
                                          ,attribute_date5
                                          ,global_attribute_category
                                          ,global_attribute1
                                          ,global_attribute2
                                          ,global_attribute3
                                          ,global_attribute4
                                          ,global_attribute5
                                          ,global_attribute6
                                          ,global_attribute7
                                          ,global_attribute8
                                          ,global_attribute9
                                          ,global_attribute10
                                          ,global_attribute11
                                          ,global_attribute12
                                          ,global_attribute13
                                          ,global_attribute14
                                          ,global_attribute15
                                          ,global_attribute16
                                          ,global_attribute17
                                          ,global_attribute18
                                          ,global_attribute19
                                          ,global_attribute20
                                          ,global_attribute_number1
                                          ,global_attribute_number2
                                          ,global_attribute_number3
                                          ,global_attribute_number4
                                          ,global_attribute_number5
                                          ,global_attribute_date1
                                          ,global_attribute_date2
                                          ,global_attribute_date3
                                          ,global_attribute_date4
                                          ,global_attribute_date5
                                          ,image_document_uri

                                          )
                              VALUES
                                          (
                                           StgTable_tbl(APInvHdrs_idx).migration_set_id               -- migration_set_id 
                                          ,StgTable_tbl(APInvHdrs_idx).migration_set_name             -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                      -- migration_status
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_id                     -- invoice_id
                                          ,StgTable_tbl(APInvHdrs_idx).operating_unit                 -- source_operating_unit
                                          ,NULL                                                       -- fusion_business_unit
                                          ,StgTable_tbl(APInvHdrs_idx).ledger_name                    -- source_ledger_name
                                          ,NULL                                                       -- fusion_ledger_name
                                          ,NULL                                                       -- source
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_num                    -- invoice_num
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_amount                 -- invoice_amount
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_date                   -- invoice_date
                                          ,StgTable_tbl(APInvHdrs_idx).vendor_name                    -- vendor_name
                                          ,StgTable_tbl(APInvHdrs_idx).vendor_num                     -- vendor_num
                                          ,StgTable_tbl(APInvHdrs_idx).vendor_site_code               -- vendor_site_code
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_currency_code          -- invoice_currency_code
                                          ,StgTable_tbl(APInvHdrs_idx).payment_currency_code          -- payment_currency_code
                                          ,StgTable_tbl(APInvHdrs_idx).description                    -- description
                                          ,StgTable_tbl(APInvHdrs_idx).migration_set_id               -- import_set
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_type_lookup_code       -- invoice_type_lookup_code
                                          ,StgTable_tbl(APInvHdrs_idx).legal_entity_name              -- legal_entity_name
                                          ,StgTable_tbl(APInvHdrs_idx).cust_registration_number       -- cust_registration_number
                                          ,StgTable_tbl(APInvHdrs_idx).cust_registration_code         -- cust_registration_code
                                          ,StgTable_tbl(APInvHdrs_idx).first_party_registration_num   -- first_party_registration_num
                                          ,StgTable_tbl(APInvHdrs_idx).third_party_registration_num   -- third_party_registration_num
                                          ,StgTable_tbl(APInvHdrs_idx).terms_name                     -- terms_name
                                          ,StgTable_tbl(APInvHdrs_idx).terms_date                     -- terms_date
                                          ,StgTable_tbl(APInvHdrs_idx).goods_received_date            -- goods_received_date
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_received_date          -- invoice_received_date
                                          ,StgTable_tbl(APInvHdrs_idx).gl_date                        -- gl_date
                                          ,StgTable_tbl(APInvHdrs_idx).payment_method_code            -- payment_method_code
                                          ,StgTable_tbl(APInvHdrs_idx).pay_group_lookup_code          -- pay_group_lookup_code
                                          ,StgTable_tbl(APInvHdrs_idx).exclusive_payment_flag         -- exclusive_payment_flag
                                          ,StgTable_tbl(APInvHdrs_idx).amount_applicable_to_discount  -- amount_applicable_to_discount
                                          ,StgTable_tbl(APInvHdrs_idx).prepay_num                     -- prepay_num
                                          ,StgTable_tbl(APInvHdrs_idx).prepay_line_num                -- prepay_line_num
                                          ,StgTable_tbl(APInvHdrs_idx).prepay_apply_amount            -- prepay_apply_amount
                                          ,StgTable_tbl(APInvHdrs_idx).prepay_gl_date                 -- prepay_gl_date
                                          ,StgTable_tbl(APInvHdrs_idx).invoice_includes_prepay_flag   -- invoice_includes_prepay_flag
                                          ,StgTable_tbl(APInvHdrs_idx).exchange_rate_type             -- exchange_rate_type
                                          ,StgTable_tbl(APInvHdrs_idx).exchange_date                  -- exchange_date
                                          ,StgTable_tbl(APInvHdrs_idx).exchange_rate                  -- exchange_rate
                                          ,StgTable_tbl(APInvHdrs_idx).accts_pay_code_concatenated    -- accts_pay_code_concatenated
                                          ,StgTable_tbl(APInvHdrs_idx).doc_category_code              -- doc_category_code
                                          ,StgTable_tbl(APInvHdrs_idx).voucher_num                    -- voucher_num
                                          ,StgTable_tbl(APInvHdrs_idx).requester_first_name           -- requester_first_name
                                          ,StgTable_tbl(APInvHdrs_idx).requester_last_name            -- requester_last_name
                                          ,StgTable_tbl(APInvHdrs_idx).requester_employee_num         -- requester_employee_num
                                          ,StgTable_tbl(APInvHdrs_idx).delivery_channel_code          -- delivery_channel_code
                                          ,StgTable_tbl(APInvHdrs_idx).bank_charge_bearer             -- bank_charge_bearer
                                          ,StgTable_tbl(APInvHdrs_idx).remit_to_supplier_name         -- remit_to_supplier_name
                                          ,StgTable_tbl(APInvHdrs_idx).remit_to_supplier_num          -- remit_to_supplier_num
                                          ,StgTable_tbl(APInvHdrs_idx).remit_to_address_name          -- remit_to_address_name
                                          ,StgTable_tbl(APInvHdrs_idx).payment_priority               -- payment_priority
                                          ,StgTable_tbl(APInvHdrs_idx).settlement_priority            -- settlement_priority
                                          ,StgTable_tbl(APInvHdrs_idx).unique_remittance_identifier   -- unique_remittance_identifier
                                          ,StgTable_tbl(APInvHdrs_idx).uri_check_digit                -- uri_check_digit
                                          ,StgTable_tbl(APInvHdrs_idx).payment_reason_code            -- payment_reason_code
                                          ,StgTable_tbl(APInvHdrs_idx).payment_reason_comments        -- payment_reason_comments
                                          ,StgTable_tbl(APInvHdrs_idx).remittance_message1            -- remittance_message1
                                          ,StgTable_tbl(APInvHdrs_idx).remittance_message2            -- remittance_message2
                                          ,StgTable_tbl(APInvHdrs_idx).remittance_message3            -- remittance_message3
                                          ,StgTable_tbl(APInvHdrs_idx).awt_group_name                 -- awt_group_name
                                          ,StgTable_tbl(APInvHdrs_idx).ship_to_location               -- ship_to_location
                                          ,StgTable_tbl(APInvHdrs_idx).taxation_country               -- taxation_country
                                          ,StgTable_tbl(APInvHdrs_idx).document_sub_type              -- document_sub_type
                                          ,StgTable_tbl(APInvHdrs_idx).tax_invoice_internal_seq       -- tax_invoice_internal_seq
                                          ,StgTable_tbl(APInvHdrs_idx).supplier_tax_invoice_number    -- supplier_tax_invoice_number
                                          ,StgTable_tbl(APInvHdrs_idx).tax_invoice_recording_date     -- tax_invoice_recording_date
                                          ,StgTable_tbl(APInvHdrs_idx).supplier_tax_invoice_date      -- supplier_tax_invoice_date
                                          ,StgTable_tbl(APInvHdrs_idx).supplier_tax_exchange_rate     -- supplier_tax_exchange_rate
                                          ,StgTable_tbl(APInvHdrs_idx).port_of_entry_code             -- port_of_entry_code
                                          ,StgTable_tbl(APInvHdrs_idx).correction_year                -- correction_year
                                          ,StgTable_tbl(APInvHdrs_idx).correction_period              -- correction_period
                                          ,StgTable_tbl(APInvHdrs_idx).import_document_number         -- import_document_number
                                          ,StgTable_tbl(APInvHdrs_idx).import_document_date           -- import_document_date
                                          ,StgTable_tbl(APInvHdrs_idx).control_amount                 -- control_amount
                                          ,StgTable_tbl(APInvHdrs_idx).calc_tax_during_import_flag    -- calc_tax_during_import_flag
                                          ,StgTable_tbl(APInvHdrs_idx).add_tax_to_inv_amt_flag        -- add_tax_to_inv_amt_flag
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_category             -- attribute_category
                                          ,StgTable_tbl(APInvHdrs_idx).attribute1                     -- attribute1
                                          ,StgTable_tbl(APInvHdrs_idx).attribute2                     -- attribute2
                                          ,StgTable_tbl(APInvHdrs_idx).attribute3                     -- attribute3
                                          ,StgTable_tbl(APInvHdrs_idx).attribute4                     -- attribute4
                                          ,StgTable_tbl(APInvHdrs_idx).attribute5                     -- attribute5
                                          ,StgTable_tbl(APInvHdrs_idx).attribute6                     -- attribute6
                                          ,StgTable_tbl(APInvHdrs_idx).attribute7                     -- attribute7
                                          ,StgTable_tbl(APInvHdrs_idx).attribute8                     -- attribute8
                                          ,StgTable_tbl(APInvHdrs_idx).attribute9                     -- attribute9
                                          ,StgTable_tbl(APInvHdrs_idx).attribute10                    -- attribute10
                                          ,StgTable_tbl(APInvHdrs_idx).attribute11                    -- attribute11
                                          ,StgTable_tbl(APInvHdrs_idx).attribute12                    -- attribute12
                                          ,StgTable_tbl(APInvHdrs_idx).attribute13                    -- attribute13
                                          ,StgTable_tbl(APInvHdrs_idx).attribute14                    -- attribute14
                                          ,StgTable_tbl(APInvHdrs_idx).attribute15                    -- attribute15
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_number1              -- attribute_number1
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_number2              -- attribute_number2
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_number3              -- attribute_number3
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_number4              -- attribute_number4
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_number5              -- attribute_number5
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_date1                -- attribute_date1
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_date2                -- attribute_date2
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_date3                -- attribute_date3
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_date4                -- attribute_date4
                                          ,StgTable_tbl(APInvHdrs_idx).attribute_date5                -- attribute_date5
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_category      -- global_attribute_category
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute1              -- global_attribute1
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute2              -- global_attribute2
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute3              -- global_attribute3
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute4              -- global_attribute4
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute5              -- global_attribute5
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute6              -- global_attribute6
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute7              -- global_attribute7
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute8              -- global_attribute8
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute9              -- global_attribute9
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute10             -- global_attribute10
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute11             -- global_attribute11
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute12             -- global_attribute12
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute13             -- global_attribute13
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute14             -- global_attribute14
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute15             -- global_attribute15
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute16             -- global_attribute16
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute17             -- global_attribute17
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute18             -- global_attribute18
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute19             -- global_attribute19
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute20             -- global_attribute20
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_number1       -- global_attribute_number1
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_number2       -- global_attribute_number2
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_number3       -- global_attribute_number3
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_number4       -- global_attribute_number4
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_number5       -- global_attribute_number5
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_date1         -- global_attribute_date1
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_date2         -- global_attribute_date2
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_date3         -- global_attribute_date3
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_date4         -- global_attribute_date4
                                          ,StgTable_tbl(APInvHdrs_idx).global_attribute_date5         -- global_attribute_date5
                                          ,StgTable_tbl(APInvHdrs_idx).image_document_uri             -- image_document_uri
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
                    ** all GL Ledgers in the Migration Set.
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
                    ** For AP Invoice Lines we do not have any Simple Transformations, but we do need
                    ** to perform Data Enrichment to default values for DIST_CODE_CONCATENATED.  As
                    ** per the above suggestion, this is implemented in the Migration Parameters table.
                    */
                    --
                    gvv_ProgressIndicator := '0130';
                    --
                    gvb_SimpleTransformsRequired := TRUE;
                    gvb_DataEnrichmentRequired   := TRUE;
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         --
                         /*
                         ** Check for and perform any Simple Transforms and/or Data Enrichment to be performed in PL/SQL.
                         */
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         IF   gvb_SimpleTransformsRequired
                         THEN
                              --
                              /*
                              ** Check that required simple transformations have been defined.
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
                                   ,pt_i_ModuleMessage       => '  - Verifying if simple transforms exist that apply to "'
                                                              ||pt_i_SubEntity
                                                              ||'".'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvb_MissingSimpleTransforms  := FALSE;
                              --
                              gvv_ProgressIndicator := '0150';
                              --
                              /*
                              ** Verify Operating Unit to Business Unit transformations exist.
                              **
                              ** These transforms should apply to ALL Financials Transactions
                              ** with Operatign Unit in their data therefor the transformations
                              ** are not defined for a specific Application.
                              */
                              --
                              gvt_TransformCategoryCode := 'OPERATING_UNIT_TO_BUSINESS_UNIT';
                              --
                              IF   xxmx_utilities_pkg.simple_transform_exists
                                        (
                                         pt_i_ApplicationSuite => gct_ApplicationSuite
                                        ,pt_i_Application      => 'ALL'
                                        ,pt_i_CategoryCode     => gvt_TransformCategoryCode
                                        )
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'".'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingSimpleTransforms := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have NOT been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'.  These are expected.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   xxmx_utilities_pkg.simple_transform_exists
                              --
                              gvv_ProgressIndicator := '0160';
                              --
                              /*
                              ** Verify LEDGER_NAME transformations exist.
                              */
                              --
                              gvt_TransformCategoryCode := 'LEDGER_NAME';
                              --
                              IF   xxmx_utilities_pkg.simple_transform_exists
                                        (
                                         pt_i_ApplicationSuite => gct_ApplicationSuite
                                        ,pt_i_Application      => 'GL'                       -- GL owns the transformations for LEDGER_NAME
                                        ,pt_i_CategoryCode     => gvt_TransformCategoryCode
                                        )
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'".'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingSimpleTransforms := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have NOT been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'.  These are expected.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   xxmx_utilities_pkg.simple_transform_exists
                              --
                              gvv_ProgressIndicator := '0170';
                              --
                              IF   gvb_MissingSimpleTransforms
                              THEN
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
                                        ,pt_i_ModuleMessage       => '- Simple transformations are required for Sub-Entity "'
                                                                   ||pt_i_SubEntity
                                                                   ||'", however they can not be performed due to absent transform data.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_MissingSimpleTransforms
                              --
                         END IF; --** IF   gvb_SimpleTransformsRequired
                         --
                         /*
                         ** Now verify if any required setup for Data enrichment has been performed.
                         **
                         ** Most Data Enrichment (i.e. value defaulting) can be performed using the Migration
                         ** Parameters table as long as there are now rules involved.  Further development will
                         ** likely be required along these lines.
                         */
                         --
                         gvv_ProgressIndicator := '0180';
                         --
                         IF   gvb_DataEnrichmentRequired
                         THEN
                              --
                              /*
                              ** Verify that required setup required for Data Enrichment has been performed.
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
                                   ,pt_i_ModuleMessage       => '  - Verifying that data enrichment setup that applies to "'
                                                              ||pt_i_SubEntity
                                                              ||'" has been performed .'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvb_MissingDataEnrichment := FALSE;
                              --
                              gvv_ProgressIndicator := '0190';
                              --
                              gvt_ParameterCode := 'DEFAULT_IMPORT_SOURCE';
                              --
                              gvv_ParameterCheckResult := xxmx_utilities_pkg.verify_parameter_exists
                                                               (
                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                               ,pt_i_Application      => gct_Application
                                                               ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                               ,pt_i_SubEntity        => pt_i_SubEntity
                                                               ,pt_i_ParameterCode    => gvt_ParameterCode
                                                               );
                              --
                              IF   gvv_ParameterCheckResult = 'SINGLE'
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Single Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSIF gvv_ParameterCheckResult = 'LIST'
                              THEN
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined but there are multiple occurrences '
                                                                   ||'and only one is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is not defined but is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_DataEnrichmentRequired
                              --
                              gvv_ProgressIndicator := '0200';
                              --
                              gvt_ParameterCode := 'DEFAULT_PAY_CODE_CONCATENATED';
                              --
                              gvv_ParameterCheckResult := xxmx_utilities_pkg.verify_parameter_exists
                                                               (
                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                               ,pt_i_Application      => gct_Application
                                                               ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                               ,pt_i_SubEntity        => pt_i_SubEntity
                                                               ,pt_i_ParameterCode    => gvt_ParameterCode
                                                               );
                              --
                              IF   gvv_ParameterCheckResult = 'SINGLE'
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Single Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSIF gvv_ParameterCheckResult = 'LIST'
                              THEN
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined but there are multiple occurrences '
                                                                   ||'and only one is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is not defined but is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_DataEnrichmentRequired
                              --
                              IF   gvb_MissingDataEnrichment
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Data Enrichment is required for Sub-Entity "'
                                                                   ||pt_i_SubEntity
                                                                   ||'", however it can not be performed due to absent enrichment data.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_MissingDataEnrichment
                              --
                         END IF; --** IF   gvb_DataEnrichmentRequired
                         --
                         gvv_ProgressIndicator := '0220';
                         --
                         IF   (
                                       gvb_SimpleTransformsRequired
                               AND NOT gvb_MissingSimpleTransforms
                              )
                         OR   (
                                       gvb_DataEnrichmentRequired
                               AND NOT gvb_MissingDataEnrichment
                              )
                         THEN
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
                                   ,pt_i_ModuleMessage       => '  - Performing simple transformations and/or data enrichment for the "'
                                                              ||pt_i_SubEntity
                                                              ||'" data in the "'
                                                              ||ct_XfmTable
                                                              ||'" table.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Update the XFM table performing all Simple Transforms and/or Data Enrichment for each row.
                              */
                              --
                              gvv_ProgressIndicator := '0230';
                              --
                              FOR  XfmTableUpd_rec
                              IN   XfmTableUpd_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
                                   --
                                   vt_MigrationStatus := 'TRANSFORMED';
                                   --
                                   /*
                                   ** First perform perform any Simple Transformation logic.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0240';
                                   --
                                   IF   gvb_SimpleTransformsRequired
                                   THEN
                                        --
                                        gvv_ProgressIndicator := '0250';
                                        --
                                        /*
                                        ** Transform the Source Operating Unit to Fusion Business Unit.
                                        */
                                        --
                                        gvt_TransformCategoryCode := 'OPERATING_UNIT_TO_BUSINESS_UNIT';
                                        --
                                        /*
                                        ** Source Operating Unit to Fusion Business Unit Transforms are defined for ALL Applications not just AR.
                                        */
                                        --
                                        vt_FusionBusinessUnit := xxmx_utilities_pkg.get_transform_fusion_value
                                                                      (
                                                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                      ,pt_i_Application      => 'ALL'
                                                                      ,pt_i_CategoryCode     => gvt_TransformCategoryCode
                                                                      ,pt_i_SourceValue      => XfmTableUpd_rec.source_operating_unit
                                                                      );
                                        --
                                        IF   vt_FusionBusinessUnit IS NULL
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
                                                  ,pt_i_RecordIdentifiers     => 'SOURCE_OPERATING_UNIT'
                                                                               ||'['||XfmTableUpd_rec.source_operating_unit||']'
                                                  ,pt_i_DataMessage           => 'No simple transform from Source Operating Unit to Fusion Business Unit exists.'
                                                  ,pt_i_DataElementsAndValues => 'No transform result.'
                                                  );
                                             --
                                        END IF; --** IF   vt_FusionBusinessUnit IS NULL
                                        --
                                        gvv_ProgressIndicator := '0260';
                                        --
                                        /*
                                        ** Transform Ledger Name
                                        */
                                        --
                                        vt_FusionLedgerName := NULL;
                                        --
                                        vt_FusionLedgerName := xxmx_utilities_pkg.get_transform_fusion_value
                                                                    (
                                                                     pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                    ,pt_i_Application      => 'GL'                       -- GL owns the transformations for LEDGER_NAME
                                                                    ,pt_i_CategoryCode     => 'LEDGER_NAME'
                                                                    ,pt_i_SourceValue      => XfmTableUpd_rec.source_ledger_name
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
                                                                               ||'['||XfmTableUpd_rec.source_ledger_name||']'
                                                  ,pt_i_DataMessage           => 'No simple transform from Source Ledger Name to Fusion Ledger Name exists.  '
                                                                               ||'Therefore Fusion Ledger Name cannot be transformed to Fusion Ledger ID.'
                                                  ,pt_i_DataElementsAndValues => 'No transform result.'
                                                  );
                                             --
                                        END IF; --** IF   vt_FusionLedgerName IS NULL
                                        --
                                        --<< Simple transform 3 here >>
                                        --
                                   END IF; --** IF   gvb_SimpleTransformsRequired
                                   --
                                   /*
                                   ** Now perform any Data Enrichment logic.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0270';
                                   --
                                   IF   gvb_DataEnrichmentRequired
                                   THEN
                                        --
                                        gvv_ProgressIndicator := '0280';
                                        --
                                        /*
                                        ** For AP Invoice Headers we need to default the SOURCE column with
                                        ** a value from the XXMX_MIGRATION_PARAMETERS table.
                                        */
                                        --
                                        gvt_ParameterCode := 'DEFAULT_IMPORT_SOURCE';
                                        --
                                        vt_DefaultImportSource := xxmx_utilities_pkg.get_single_parameter_value
                                                                       (
                                                                        pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                       ,pt_i_Application      => gct_Application
                                                                       ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                                       ,pt_i_SubEntity        => pt_i_SubEntity
                                                                       ,pt_i_ParameterCode    => gvt_ParameterCode
                                                                       );
                                        --
                                        IF   vt_DefaultImportSource IS NULL
                                        THEN
                                             --
                                             IF   vt_MigrationStatus = 'TRANSFORMED'
                                             THEN
                                                  --
                                                  vt_MigrationStatus := 'DATA_ENRICHMENT_FAILED';
                                                  --
                                             ELSE
                                                  --
                                                  vt_MigrationStatus := 'SIMPLE_TRANSFORM_AND_DATA_ENRICHMENT_FAILED';
                                                  --
                                             END IF;
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
                                                  ,pt_i_RecordIdentifiers     => 'Migration parameter '
                                                                               ||'['||gvt_ParameterCode||']'
                                                  ,pt_i_DataMessage           => 'Parameter does not exist or has no value assigned.'
                                                  ,pt_i_DataElementsAndValues => 'No transform result.'
                                                  );
                                             --
                                        END IF; --** IF   vt_DefaultDistCodeConcatenated IS NULL
                                        --
                                        /*
                                        ** For AP Invoice Headers we need to replace the extracted PAY_CODE_CONCATENATED
                                        ** with a default value which will be held in the XXMX_MIGRATION_PARAMETERS
                                        ** table.
                                        */
                                        --
                                        gvv_ProgressIndicator := '0290';
                                        --
                                        gvt_ParameterCode := 'DEFAULT_PAY_CODE_CONCATENATED';
                                        --
                                        vt_DefaultPayCodeConcatenated := xxmx_utilities_pkg.get_single_parameter_value
                                                                              (
                                                                               pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                              ,pt_i_Application      => gct_Application
                                                                              ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                                              ,pt_i_SubEntity        => pt_i_SubEntity
                                                                              ,pt_i_ParameterCode    => gvt_ParameterCode
                                                                              );
                                        --
                                        IF   vt_DefaultPayCodeConcatenated IS NULL
                                        THEN
                                             --
                                             IF   vt_MigrationStatus = 'TRANSFORMED'
                                             THEN
                                                  --
                                                  vt_MigrationStatus := 'DATA_ENRICHMENT_FAILED';
                                                  --
                                             ELSE
                                                  --
                                                  vt_MigrationStatus := 'SIMPLE_TRANSFORM_AND_DATA_ENRICHMENT_FAILED';
                                                  --
                                             END IF;
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
                                                  ,pt_i_RecordIdentifiers     => 'Migration parameter '
                                                                               ||'['||gvt_ParameterCode||']'
                                                  ,pt_i_DataMessage           => 'Parameter does not exist or has no value assigned.'
                                                  ,pt_i_DataElementsAndValues => 'No transform result.'
                                                  );
                                             --
                                        END IF; --** IF   vt_DefaultDistCodeConcatenated IS NULL
                                        --
                                   END IF; --** IF   gvb_DataEnrichmentRequired
                                   --
                                   gvv_ProgressIndicator := '0280';
                                   --
                                   /*
                                   ** Update the current row of the XFM table for all transforms.
                                   **
                                   ** If you add more column transforms above, don't forget to add them
                                   ** to the UPDATE statement.
                                   */
                                   --
                                   UPDATE  xxmx_ap_invoices_xfm
                                   SET     migration_status              = vt_MigrationStatus
                                          ,fusion_business_unit          = vt_FusionBusinessUnit
                                          ,fusion_ledger_name            = vt_FusionLedgerName
                                          ,source                        = vt_DefaultImportSource
                                          ,accts_pay_code_concatenated   = vt_DefaultPayCodeConcatenated
                                   WHERE CURRENT OF XfmTableUpd_cur;
                                   --
                              END LOOP; --** XfmTableUpd_cur
                              --
                              gvv_ProgressIndicator := '0290';
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
                                   ,pt_i_ModuleMessage       => '  - Simple Transformations and/or Data Enrichment completed.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Commit the updates for the XFM table.
                              */
                              --
                              COMMIT;
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0300';
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
                                   ,pt_i_ModuleMessage       => '- Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                              ||pt_i_SubEntity
                                                              ||'", however they could not be performed due to absent Simple Transform or Data Enrichment setup.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF; --** IF Simple Transforms required and present or Data Enrichment required and present.
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0310';
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
                              ,pt_i_ModuleMessage       => '- No Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                         ||pt_i_SubEntity
                                                         ||'".'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                    END IF; --** IF Simple Transforms required or Data Enrichment required.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0320';
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
                         ,pt_i_ModuleMessage       => '  - Any simple transformations for "'
                                                    ||pt_i_SubEntity
                                                    ||'" data should be performed within '
                                                    ||pt_i_SimpleXfmPerformedBy
                                                    ||'.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF; --** IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
               --
               gvv_ProgressIndicator := '0330';
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
               gvv_ProgressIndicator := '0340';
               --
               gvb_ComplexTransformsRequired := FALSE;
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
                    gvv_ProgressIndicator := '0350';
                    --
                    gvb_PerformComplexTransforms := FALSE;
                    --
                    IF   gvb_PerformComplexTransforms
                    THEN
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
                              ,pt_i_ModuleMessage       => '  - Performing complex transformations for the "'
                                                         ||pt_i_SubEntity
                                                         ||'" data in the "'
                                                         ||ct_XfmTable
                                                         ||'" table.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0360';
                         --
                         /*
                         ** Commit the complex transformation updates for the XFM table.
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
                         gvv_ProgressIndicator := '0370';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
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
                    gvv_ProgressIndicator := '0380';
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
               gvv_ProgressIndicator := '0390';
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
               gvv_ProgressIndicator := '0400';
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
     END ap_invoice_hdr_xfm;
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_stg
     **********************************
     */
     --
      PROCEDURE ap_invoice_lines_stg
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
         -- Cursor to get the detail AP Invoices Lines
           CURSOR ap_inv_lines_cur
           IS
                  --
                  --
                  SELECT DISTINCT
                            selection.invoice_id                                                                                                                          AS  invoice_id
                          , TRIM(aila.line_number)                                                                                                                          AS  line_number
                          , TRIM(aila.line_type_lookup_code)                                                                                                                AS  line_type_lookup_code
                          , round(aila.amount,2) +NVL((SELECT round(sum(unrounded_tax_amt),2)
                                                     FROM apps.zx_lines@MXDM_NVIS_EXTRACT
                                                     WHERE application_id = 200
                                                     AND   trx_id = selection.invoice_id
                                                     AND   entity_code = 'AP_INVOICES'
                                                     AND   trx_line_number =aila.line_number
                                                     AND   event_class_code in(
                                                                 'STANDARD INVOICES',
                                                                 'PREPAYMENT INVOICES',
                                                                 'EXPENSE REPORTS'
                                                            )),0)                                                 AS  amount
                          , round(aila.quantity_invoiced,2)                                                       AS  quantity_invoiced
                          , NULL                                                                                  AS  unit_price
                          , TRIM(aila.unit_meas_lookup_code)                                                      AS  unit_of_meas_lookup_code
                          , xxmx_utilities_pkg.convert_string
                                 (
                                  pv_i_StringToConvert     => SUBSTRB(TRIM(aila.description), 1, 240)
                                 ,pv_i_ConvertCommaToSpace => 'N'
                                 )                                                                                AS  description
                          , NULL                                                                                  AS  po_number
                          , NULL                                                                                  AS  po_line_number
                          , NULL                                                                                  AS  po_shipment_num
                          , NULL                                                                                  AS  po_distribution_num
                          , NULL                                                                                  AS  item_description
                          , NULL                                                                                  AS  release_num
                          , NULL                                                                                  AS  purchasing_category
                          , NULL                                                                                  AS  receipt_number
                          , NULL                                                                                  AS  receipt_line_number
                          , NULL                                                                                  AS  consumption_advice_number
                          , NULL                                                                                  AS  consumption_advice_line_number
                          , NULL                                                                                  AS  packing_slip
                          , TRIM(aila.final_match_flag)                                                             AS  final_match_flag
                          , (
                             SELECT concatenated_segments
                             FROM   (
                                     SELECT DISTINCT FIRST_VALUE(aid.dist_code_combination_id)
                                                     OVER (ORDER BY aid.amount desc) AS dist_code_combination_id  
                                     FROM  apps.ap_invoice_distributions_all@MXDM_NVIS_EXTRACT   aid
                                     WHERE aid.invoice_id                  = aila.invoice_id
                                     AND   aid.line_type_lookup_code       = 'ITEM'
                                    ) x
                                   ,apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT       gcck
                             WHERE  gcck.code_combination_id = x.dist_code_combination_id                          
                            )                                                                                     AS  dist_code_concatenated -- EDQ Mapping COA Mapping
                          , NULL                                                                                  AS  distribution_set_name
                          , aila.accounting_date                                                                    AS  accounting_date -- EDQ MApping  2019/12/31
                          , NULL                                                                                  AS  account_segment
                          , NULL                                                                                  AS  balancing_segment
                          , NULL                                                                                  AS  cost_center_segment
                          , NULL                                                                                  AS  tax_classification_code
                          , (SELECT TRIM(hl.location_code)       
                             FROM   apps.hr_locations_all@MXDM_NVIS_EXTRACT hl      
                             WHERE  hl.location_id = aila.ship_to_location_id)                                      AS  ship_to_location_code -- EDQ MAPPING HR LOCATION
                          , NULL                                                                                  AS  ship_from_location_code
                          , NULL                                                                                  AS  final_discharge_location_code
                          , TRIM(aila.trx_business_category)                                                        AS  trx_business_category
                          , TRIM(aila.product_fisc_classification)                                                  AS  product_fisc_classification
                          , TRIM(aila.primary_intended_use)                                                         AS  primary_intended_use
                          , TRIM(aila.user_defined_fisc_class)                                                      AS  user_defined_fisc_class
                          , NULL                                                                                  AS  product_type
                          , NULL                                                                                  AS  assessable_value
                          , NULL                                                                                  AS  product_category
                          , TRIM(aila.control_amount)                                                               AS  control_amount
                          , NULL                                                                                  AS  tax_regime_code
                          , NULL                                                                                  AS  tax
                          , NULL                                                                                  AS  tax_status_code
                          , NULL                                                                                  AS  tax_jurisdiction_code
                          , NULL                                                                                  AS  tax_rate_code
                          , NULL                                                                                  AS  tax_rate
                          , NULL                                                                                  AS  awt_group_name
                          , TRIM(aila.type_1099)                                                                    AS  type_1099
                          , NULL                                                                                  AS  income_tax_region
                          , NULL                                                                                  AS  prorate_across_flag
                          , NULL                                                                                  AS  line_group_number
                          , NULL                                                                                  AS  cost_factor_name
                          , TRIM(aila.stat_amount)                                                                  AS  stat_amount
                          , NULL                                                                                  AS  assets_tracking_flag
                          , NULL                                                                                  AS  asset_book_type_code
                          , NULL                                                                                  AS  asset_category_id
                          , TRIM(aila.serial_number)                                                                AS  serial_number
                          , TRIM(aila.manufacturer)                                                                 AS  manufacturer
                          , TRIM(aila.model_number)                                                                 AS  model_number
                          , TRIM(aila.warranty_number)                                                              AS  warranty_number
                          , NULL                                                                                  AS  price_correction_flag
                          , NULL                                                                                  AS  price_correct_inv_num
                          , NULL                                                                                  AS  price_correct_inv_line_num
                          , NULL                                                                                  AS  requester_first_name
                          , NULL                                                                                  AS  requester_last_name
                          , NULL                                                                                  AS  requester_employee_num
                          , NULL                                                                                  AS  attribute_category
                          , NULL                                                                                  AS  attribute1
                          , NULL                                                                                  AS  attribute2
                          , NULL                                                                                  AS  attribute3
                          , NULL                                                                                  AS  attribute4
                          , NULL                                                                                  AS  attribute5
                          , NULL                                                                                  AS  attribute6
                          , NULL                                                                                  AS  attribute7
                          , NULL                                                                                  AS  attribute8
                          , NULL                                                                                  AS  attribute9
                          , NULL                                                                                  AS  attribute10
                          , NULL                                                                                  AS  attribute11
                          , NULL                                                                                  AS  attribute12
                          , NULL                                                                                  AS  attribute13
                          , NULL                                                                                  AS  attribute14
                          , NULL                                                                                  AS  attribute15
                          , NULL                                                                                  AS attribute_number1
                          , NULL                                                                                  AS attribute_number2
                          , NULL                                                                                  AS attribute_number3
                          , NULL                                                                                  AS attribute_number4
                          , NULL                                                                                  AS attribute_number5
                          , NULL                                                                                  AS attribute_date1
                          , NULL                                                                                  AS attribute_date2
                          , NULL                                                                                  AS attribute_date3
                          , NULL                                                                                  AS attribute_date4
                          , NULL                                                                                  AS attribute_date5
                          , NULL                                                                                  AS global_attribute_category
                          , NULL                                                                                  AS global_attribute1
                          , NULL                                                                                  AS global_attribute2
                          , NULL                                                                                  AS global_attribute3
                          , NULL                                                                                  AS global_attribute4
                          , NULL                                                                                  AS global_attribute5
                          , NULL                                                                                  AS global_attribute6
                          , NULL                                                                                  AS global_attribute7
                          , NULL                                                                                  AS global_attribute8
                          , NULL                                                                                  AS global_attribute9
                          , NULL                                                                                  AS global_attribute10
                          , NULL                                                                                  AS global_attribute11
                          , NULL                                                                                  AS global_attribute12
                          , NULL                                                                                  AS global_attribute13
                          , NULL                                                                                  AS global_attribute14
                          , NULL                                                                                  AS global_attribute15
                          , NULL                                                                                  AS global_attribute16
                          , NULL                                                                                  AS global_attribute17
                          , NULL                                                                                  AS global_attribute18
                          , NULL                                                                                  AS global_attribute19
                          , NULL                                                                                  AS global_attribute20
                          , NULL                                                                                  AS global_attribute_number1
                          , NULL                                                                                  AS global_attribute_number2
                          , NULL                                                                                  AS global_attribute_number3
                          , NULL                                                                                  AS global_attribute_number4
                          , NULL                                                                                  AS global_attribute_number5
                          , NULL                                                                                  AS global_attribute_date1
                          , NULL                                                                                  AS global_attribute_date2
                          , NULL                                                                                  AS global_attribute_date3
                          , NULL                                                                                  AS global_attribute_date4
                          , NULL                                                                                  AS global_attribute_date5
                          , NULL                                                                                  AS pjc_project_id
                          , NULL                                                                                  AS pjc_task_id
                          , NULL                                                                                  AS pjc_expenditure_type_id
                          , NULL                                                                                  AS pjc_expenditure_item_date
                          , NULL                                                                                  AS pjc_organization_id
                          , NULL                                                                                  AS pjc_project_number
                          , NULL                                                                                  AS pjc_task_number
                          , NULL                                                                                  AS pjc_expenditure_type_name
                          , NULL                                                                                  AS pjc_organization_name
                          , NULL                                                                                  AS pjc_reserved_attribute1
                          , NULL                                                                                  AS pjc_reserved_attribute2
                          , NULL                                                                                  AS pjc_reserved_attribute3
                          , NULL                                                                                  AS pjc_reserved_attribute4
                          , NULL                                                                                  AS pjc_reserved_attribute5
                          , NULL                                                                                  AS pjc_reserved_attribute6
                          , NULL                                                                                  AS pjc_reserved_attribute7
                          , NULL                                                                                  AS pjc_reserved_attribute8
                          , NULL                                                                                  AS pjc_reserved_attribute9
                          , NULL                                                                                  AS pjc_reserved_attribute10
                          , NULL                                                                                  AS pjc_user_def_attribute1
                          , NULL                                                                                  AS pjc_user_def_attribute2
                          , NULL                                                                                  AS pjc_user_def_attribute3
                          , NULL                                                                                  AS pjc_user_def_attribute4
                          , NULL                                                                                  AS pjc_user_def_attribute5
                          , NULL                                                                                  AS pjc_user_def_attribute6
                          , NULL                                                                                  AS pjc_user_def_attribute7
                          , NULL                                                                                  AS pjc_user_def_attribute8
                          , NULL                                                                                  AS pjc_user_def_attribute9
                          , NULL                                                                                  AS pjc_user_def_attribute10
                          , NULL                                                                                  AS fiscal_charge_type
                          , NULL                                                                                  AS def_acctg_start_date
                          , NULL                                                                                  AS def_acctg_end_date
                          , NULL                                                                                  AS def_accrual_code_concatenated
                          , NULL                                                                                  AS pjc_project_name
                          , NULL                                                                                  AS pjc_task_name
                  FROM    xxmx_ap_inv_scope_v                                    selection
--                          ,apps.ap_invoices_all@MXDM_NVIS_EXTRACT              aia
                          , apps.ap_payment_schedules_all@MXDM_NVIS_EXTRACT     apsa
--                          , apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT        assa
--                          , apps.ap_suppliers@MXDM_NVIS_EXTRACT                 aps
--                          , apps.hz_parties@MXDM_NVIS_EXTRACT                   hp
--                          , apps.ap_terms_tl@MXDM_NVIS_EXTRACT                  apt
                          , apps.ap_invoice_lines_all@MXDM_NVIS_EXTRACT         aila
--                          , apps.po_headers_all@MXDM_NVIS_EXTRACT               ph
                          , apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
--                          , apps.pa_projects_all@MXDM_NVIS_EXTRACT                  ppa
--                          , apps.pa_tasks@MXDM_NVIS_EXTRACT                         pt
                   WHERE   1=1
                  AND aila.line_type_lookup_code                 IN ('ITEM')
                  AND apsa.invoice_id                             = selection.invoice_id
--                  AND aps.vendor_id                               = assa.vendor_id
--                  AND hp.party_id                               = aps.party_id
--                  AND apt.term_id                               = aia.terms_id
                  AND aila.invoice_id                             = selection.invoice_id
--                  AND ph.po_header_id(+)                        = aila.po_header_id
                  AND haou.organization_id                         = aila.org_id
--                  AND aila.project_id = ppa.project_id(+)
--                  AND aila.task_id    = pt.task_id(+)
                  ;
          --** END CURSOR ** 
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_invoice_lines_tt IS TABLE OF ap_inv_lines_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_invoice_lines_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_invoice_lines_stg';
          --
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
          ap_invoice_lines_tbl                  ap_invoice_lines_tt;
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
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity 
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application 
                    ,pt_i_BusinessEntity   => gct_BusinessEntity 
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
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
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the data and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_inv_lines_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_inv_lines_cur  
                    BULK COLLECT 
                    INTO ap_invoice_lines_tbl
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_invoice_lines_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL i in 1..ap_invoice_lines_tbl.COUNT
                         --
                         INSERT
                         INTO   xxmx_stg.xxmx_ap_invoice_lines_stg
                                    (
                                     migration_set_id
                                    ,migration_set_name
                                    ,migration_status
                                    ,invoice_id
                                    ,line_number
                                    ,line_type_lookup_code
                                    ,amount
                                    ,quantity_invoiced
                                    ,unit_price
                                    ,unit_of_meas_lookup_code
                                    ,description
                                    ,po_number
                                    ,po_line_number
                                    ,po_shipment_num
                                    ,po_distribution_num
                                    ,item_description
                                    ,release_num
                                    ,purchasing_category
                                    ,receipt_number
                                    ,receipt_line_number
                                    ,consumption_advice_number
                                    ,consumption_advice_line_number
                                    ,packing_slip
                                    ,final_match_flag
                                    ,dist_code_concatenated
                                    ,distribution_set_name
                                    ,accounting_date
                                    ,account_segment
                                    ,balancing_segment
                                    ,cost_center_segment
                                    ,tax_classification_code
                                    ,ship_to_location_code
                                    ,ship_from_location_code
                                    ,final_discharge_location_code
                                    ,trx_business_category
                                    ,product_fisc_classification
                                    ,primary_intended_use
                                    ,user_defined_fisc_class
                                    ,product_type
                                    ,assessable_value
                                    ,product_category
                                    ,control_amount
                                    ,tax_regime_code
                                    ,tax
                                    ,tax_status_code
                                    ,tax_jurisdiction_code
                                    ,tax_rate_code
                                    ,tax_rate
                                    ,awt_group_name
                                    ,type_1099
                                    ,income_tax_region
                                    ,prorate_across_flag
                                    ,line_group_number
                                    ,cost_factor_name
                                    ,stat_amount
                                    ,assets_tracking_flag
                                    ,asset_book_type_code
                                    ,asset_category_id
                                    ,serial_number
                                    ,manufacturer
                                    ,model_number
                                    ,warranty_number
                                    ,price_correction_flag
                                    ,price_correct_inv_num
                                    ,price_correct_inv_line_num
                                    ,requester_first_name
                                    ,requester_last_name
                                    ,requester_employee_num
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
                                    ,attribute_number1
                                    ,attribute_number2
                                    ,attribute_number3
                                    ,attribute_number4
                                    ,attribute_number5
                                    ,attribute_date1
                                    ,attribute_date2
                                    ,attribute_date3
                                    ,attribute_date4
                                    ,attribute_date5
                                    ,global_attribute_category
                                    ,global_attribute1
                                    ,global_attribute2
                                    ,global_attribute3
                                    ,global_attribute4
                                    ,global_attribute5
                                    ,global_attribute6
                                    ,global_attribute7
                                    ,global_attribute8
                                    ,global_attribute9
                                    ,global_attribute10
                                    ,global_attribute11
                                    ,global_attribute12
                                    ,global_attribute13
                                    ,global_attribute14
                                    ,global_attribute15
                                    ,global_attribute16
                                    ,global_attribute17
                                    ,global_attribute18
                                    ,global_attribute19
                                    ,global_attribute20
                                    ,global_attribute_number1
                                    ,global_attribute_number2
                                    ,global_attribute_number3
                                    ,global_attribute_number4
                                    ,global_attribute_number5
                                    ,global_attribute_date1
                                    ,global_attribute_date2
                                    ,global_attribute_date3
                                    ,global_attribute_date4
                                    ,global_attribute_date5
                                    ,pjc_project_id
                                    ,pjc_task_id
                                    ,pjc_expenditure_type_id
                                    ,pjc_expenditure_item_date
                                    ,pjc_organization_id
                                    ,pjc_project_number
                                    ,pjc_task_number
                                    ,pjc_expenditure_type_name
                                    ,pjc_organization_name
                                    ,pjc_reserved_attribute1
                                    ,pjc_reserved_attribute2
                                    ,pjc_reserved_attribute3
                                    ,pjc_reserved_attribute4
                                    ,pjc_reserved_attribute5
                                    ,pjc_reserved_attribute6
                                    ,pjc_reserved_attribute7
                                    ,pjc_reserved_attribute8
                                    ,pjc_reserved_attribute9
                                    ,pjc_reserved_attribute10
                                    ,pjc_user_def_attribute1
                                    ,pjc_user_def_attribute2
                                    ,pjc_user_def_attribute3
                                    ,pjc_user_def_attribute4
                                    ,pjc_user_def_attribute5
                                    ,pjc_user_def_attribute6
                                    ,pjc_user_def_attribute7
                                    ,pjc_user_def_attribute8
                                    ,pjc_user_def_attribute9
                                    ,pjc_user_def_attribute10
                                    ,fiscal_charge_type
                                    ,def_acctg_start_date
                                    ,def_acctg_end_date
                                    ,def_accrual_code_concatenated
                                    ,pjc_project_name
                                    ,pjc_task_name
                                    )
                         VALUES (
                                     pt_i_MigrationSetID                               --MIGRATION_SET_ID
                                    ,gvt_MigrationSetName 
                                    ,'EXTRACTED'
                                    ,ap_invoice_lines_tbl(i).invoice_id
                                    ,ap_invoice_lines_tbl(i).line_number
                                    ,ap_invoice_lines_tbl(i).line_type_lookup_code
                                    ,ap_invoice_lines_tbl(i).amount
                                    ,ap_invoice_lines_tbl(i).quantity_invoiced
                                    --,ap_invoice_lines_tbl(i).unit_price
                                    ,case when ap_invoice_lines_tbl(i).quantity_invoiced>0 then
                                    (ap_invoice_lines_tbl(i).amount/ap_invoice_lines_tbl(i).quantity_invoiced)
                                    else
                                    to_number(ap_invoice_lines_tbl(i).unit_price)
                                    END
                                    ,ap_invoice_lines_tbl(i).unit_of_meas_lookup_code
                                    ,ap_invoice_lines_tbl(i).description
                                    ,ap_invoice_lines_tbl(i).po_number
                                    ,ap_invoice_lines_tbl(i).po_line_number
                                    ,ap_invoice_lines_tbl(i).po_shipment_num
                                    ,ap_invoice_lines_tbl(i).po_distribution_num
                                    ,ap_invoice_lines_tbl(i).item_description
                                    ,ap_invoice_lines_tbl(i).release_num
                                    ,ap_invoice_lines_tbl(i).purchasing_category
                                    ,ap_invoice_lines_tbl(i).receipt_number
                                    ,ap_invoice_lines_tbl(i).receipt_line_number
                                    ,ap_invoice_lines_tbl(i).consumption_advice_number
                                    ,ap_invoice_lines_tbl(i).consumption_advice_line_number
                                    ,ap_invoice_lines_tbl(i).packing_slip
                                    ,ap_invoice_lines_tbl(i).final_match_flag
                                    ,ap_invoice_lines_tbl(i).dist_code_concatenated
                                    ,ap_invoice_lines_tbl(i).distribution_set_name
                                    ,ap_invoice_lines_tbl(i).accounting_date
                                    ,ap_invoice_lines_tbl(i).account_segment
                                    ,ap_invoice_lines_tbl(i).balancing_segment
                                    ,ap_invoice_lines_tbl(i).cost_center_segment
                                    ,ap_invoice_lines_tbl(i).tax_classification_code
                                    ,ap_invoice_lines_tbl(i).ship_to_location_code
                                    ,ap_invoice_lines_tbl(i).ship_from_location_code
                                    ,ap_invoice_lines_tbl(i).final_discharge_location_code
                                    ,ap_invoice_lines_tbl(i).trx_business_category
                                    ,ap_invoice_lines_tbl(i).product_fisc_classification
                                    ,ap_invoice_lines_tbl(i).primary_intended_use
                                    ,ap_invoice_lines_tbl(i).user_defined_fisc_class
                                    ,ap_invoice_lines_tbl(i).product_type
                                    ,ap_invoice_lines_tbl(i).assessable_value
                                    ,ap_invoice_lines_tbl(i).product_category
                                    ,ap_invoice_lines_tbl(i).control_amount
                                    ,ap_invoice_lines_tbl(i).tax_regime_code
                                    ,ap_invoice_lines_tbl(i).tax
                                    ,ap_invoice_lines_tbl(i).tax_status_code
                                    ,ap_invoice_lines_tbl(i).tax_jurisdiction_code
                                    ,ap_invoice_lines_tbl(i).tax_rate_code
                                    ,ap_invoice_lines_tbl(i).tax_rate
                                    ,ap_invoice_lines_tbl(i).awt_group_name
                                    ,ap_invoice_lines_tbl(i).type_1099
                                    ,ap_invoice_lines_tbl(i).income_tax_region
                                    ,ap_invoice_lines_tbl(i).prorate_across_flag
                                    ,ap_invoice_lines_tbl(i).line_group_number
                                    ,ap_invoice_lines_tbl(i).cost_factor_name
                                    ,ap_invoice_lines_tbl(i).stat_amount
                                    ,ap_invoice_lines_tbl(i).assets_tracking_flag
                                    ,ap_invoice_lines_tbl(i).asset_book_type_code
                                    ,ap_invoice_lines_tbl(i).asset_category_id
                                    ,ap_invoice_lines_tbl(i).serial_number
                                    ,ap_invoice_lines_tbl(i).manufacturer
                                    ,ap_invoice_lines_tbl(i).model_number
                                    ,ap_invoice_lines_tbl(i).warranty_number
                                    ,ap_invoice_lines_tbl(i).price_correction_flag
                                    ,ap_invoice_lines_tbl(i).price_correct_inv_num
                                    ,ap_invoice_lines_tbl(i).price_correct_inv_line_num
                                    ,ap_invoice_lines_tbl(i).requester_first_name
                                    ,ap_invoice_lines_tbl(i).requester_last_name
                                    ,ap_invoice_lines_tbl(i).requester_employee_num
                                    ,ap_invoice_lines_tbl(i).attribute_category
                                    ,ap_invoice_lines_tbl(i).attribute1
                                    ,ap_invoice_lines_tbl(i).attribute2
                                    ,ap_invoice_lines_tbl(i).attribute3
                                    ,ap_invoice_lines_tbl(i).attribute4
                                    ,ap_invoice_lines_tbl(i).attribute5
                                    ,ap_invoice_lines_tbl(i).attribute6
                                    ,ap_invoice_lines_tbl(i).attribute7
                                    ,ap_invoice_lines_tbl(i).attribute8
                                    ,ap_invoice_lines_tbl(i).attribute9
                                    ,ap_invoice_lines_tbl(i).attribute10
                                    ,ap_invoice_lines_tbl(i).attribute11
                                    ,ap_invoice_lines_tbl(i).attribute12
                                    ,ap_invoice_lines_tbl(i).attribute13
                                    ,ap_invoice_lines_tbl(i).attribute14
                                    ,ap_invoice_lines_tbl(i).attribute15
                                    ,ap_invoice_lines_tbl(i).attribute_number1
                                    ,ap_invoice_lines_tbl(i).attribute_number2
                                    ,ap_invoice_lines_tbl(i).attribute_number3
                                    ,ap_invoice_lines_tbl(i).attribute_number4
                                    ,ap_invoice_lines_tbl(i).attribute_number5
                                    ,ap_invoice_lines_tbl(i).attribute_date1
                                    ,ap_invoice_lines_tbl(i).attribute_date2
                                    ,ap_invoice_lines_tbl(i).attribute_date3
                                    ,ap_invoice_lines_tbl(i).attribute_date4
                                    ,ap_invoice_lines_tbl(i).attribute_date5
                                    ,ap_invoice_lines_tbl(i).global_attribute_category
                                    ,ap_invoice_lines_tbl(i).global_attribute1
                                    ,ap_invoice_lines_tbl(i).global_attribute2
                                    ,ap_invoice_lines_tbl(i).global_attribute3
                                    ,ap_invoice_lines_tbl(i).global_attribute4
                                    ,ap_invoice_lines_tbl(i).global_attribute5
                                    ,ap_invoice_lines_tbl(i).global_attribute6
                                    ,ap_invoice_lines_tbl(i).global_attribute7
                                    ,ap_invoice_lines_tbl(i).global_attribute8
                                    ,ap_invoice_lines_tbl(i).global_attribute9
                                    ,ap_invoice_lines_tbl(i).global_attribute10
                                    ,ap_invoice_lines_tbl(i).global_attribute11
                                    ,ap_invoice_lines_tbl(i).global_attribute12
                                    ,ap_invoice_lines_tbl(i).global_attribute13
                                    ,ap_invoice_lines_tbl(i).global_attribute14
                                    ,ap_invoice_lines_tbl(i).global_attribute15
                                    ,ap_invoice_lines_tbl(i).global_attribute16
                                    ,ap_invoice_lines_tbl(i).global_attribute17
                                    ,ap_invoice_lines_tbl(i).global_attribute18
                                    ,ap_invoice_lines_tbl(i).global_attribute19
                                    ,ap_invoice_lines_tbl(i).global_attribute20
                                    ,ap_invoice_lines_tbl(i).global_attribute_number1
                                    ,ap_invoice_lines_tbl(i).global_attribute_number2
                                    ,ap_invoice_lines_tbl(i).global_attribute_number3
                                    ,ap_invoice_lines_tbl(i).global_attribute_number4
                                    ,ap_invoice_lines_tbl(i).global_attribute_number5
                                    ,ap_invoice_lines_tbl(i).global_attribute_date1
                                    ,ap_invoice_lines_tbl(i).global_attribute_date2
                                    ,ap_invoice_lines_tbl(i).global_attribute_date3
                                    ,ap_invoice_lines_tbl(i).global_attribute_date4
                                    ,ap_invoice_lines_tbl(i).global_attribute_date5
                                    ,ap_invoice_lines_tbl(i).pjc_project_id
                                    ,ap_invoice_lines_tbl(i).pjc_task_id
                                    ,ap_invoice_lines_tbl(i).pjc_expenditure_type_id
                                    ,ap_invoice_lines_tbl(i).pjc_expenditure_item_date
                                    ,ap_invoice_lines_tbl(i).pjc_organization_id
                                    ,ap_invoice_lines_tbl(i).pjc_project_number
                                    ,ap_invoice_lines_tbl(i).pjc_task_number
                                    ,ap_invoice_lines_tbl(i).pjc_expenditure_type_name
                                    ,ap_invoice_lines_tbl(i).pjc_organization_name
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute1
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute2
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute3
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute4
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute5
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute6
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute7
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute8
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute9
                                    ,ap_invoice_lines_tbl(i).pjc_reserved_attribute10
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute1
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute2
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute3
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute4
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute5
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute6
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute7
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute8
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute9
                                    ,ap_invoice_lines_tbl(i).pjc_user_def_attribute10
                                    ,ap_invoice_lines_tbl(i).fiscal_charge_type
                                    ,ap_invoice_lines_tbl(i).def_acctg_start_date
                                    ,ap_invoice_lines_tbl(i).def_acctg_end_date
                                    ,ap_invoice_lines_tbl(i).def_accrual_code_concatenated
                                    ,ap_invoice_lines_tbl(i).pjc_project_name
                                    ,ap_invoice_lines_tbl(i).pjc_task_name
                                   );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_inv_lines_cur;
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
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0100';
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
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
                    IF ap_inv_lines_cur%ISOPEN
                    THEN
                          --
                          CLOSE ap_inv_lines_cur;
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
     END ap_invoice_lines_stg;
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_xfm
     **********************************
     */
     --
     PROCEDURE ap_invoice_lines_xfm
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
                      ,invoice_id
                      ,line_number
                      ,line_type_lookup_code
                      ,amount
                      ,quantity_invoiced
                      ,unit_price
                      ,unit_of_meas_lookup_code
                      ,description
                      ,po_number
                      ,po_line_number
                      ,po_shipment_num
                      ,po_distribution_num
                      ,item_description
                      ,release_num
                      ,purchasing_category
                      ,receipt_number
                      ,receipt_line_number
                      ,consumption_advice_number
                      ,consumption_advice_line_number
                      ,packing_slip
                      ,final_match_flag
                      ,dist_code_concatenated
                      ,distribution_set_name
                      ,accounting_date
                      ,account_segment
                      ,balancing_segment
                      ,cost_center_segment
                      ,tax_classification_code
                      ,ship_to_location_code
                      ,ship_from_location_code
                      ,final_discharge_location_code
                      ,trx_business_category
                      ,product_fisc_classification
                      ,primary_intended_use
                      ,user_defined_fisc_class
                      ,product_type
                      ,assessable_value
                      ,product_category
                      ,control_amount
                      ,tax_regime_code
                      ,tax
                      ,tax_status_code
                      ,tax_jurisdiction_code
                      ,tax_rate_code
                      ,tax_rate
                      ,awt_group_name
                      ,type_1099
                      ,income_tax_region
                      ,prorate_across_flag
                      ,line_group_number
                      ,cost_factor_name
                      ,stat_amount
                      ,assets_tracking_flag
                      ,asset_book_type_code
                      ,asset_category_id
                      ,serial_number
                      ,manufacturer
                      ,model_number
                      ,warranty_number
                      ,price_correction_flag
                      ,price_correct_inv_num
                      ,price_correct_inv_line_num
                      ,requester_first_name
                      ,requester_last_name
                      ,requester_employee_num
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
                      ,attribute_number1
                      ,attribute_number2
                      ,attribute_number3
                      ,attribute_number4
                      ,attribute_number5
                      ,attribute_date1
                      ,attribute_date2
                      ,attribute_date3
                      ,attribute_date4
                      ,attribute_date5
                      ,global_attribute_category
                      ,global_attribute1
                      ,global_attribute2
                      ,global_attribute3
                      ,global_attribute4
                      ,global_attribute5
                      ,global_attribute6
                      ,global_attribute7
                      ,global_attribute8
                      ,global_attribute9
                      ,global_attribute10
                      ,global_attribute11
                      ,global_attribute12
                      ,global_attribute13
                      ,global_attribute14
                      ,global_attribute15
                      ,global_attribute16
                      ,global_attribute17
                      ,global_attribute18
                      ,global_attribute19
                      ,global_attribute20
                      ,global_attribute_number1
                      ,global_attribute_number2
                      ,global_attribute_number3
                      ,global_attribute_number4
                      ,global_attribute_number5
                      ,global_attribute_date1
                      ,global_attribute_date2
                      ,global_attribute_date3
                      ,global_attribute_date4
                      ,global_attribute_date5
                      ,pjc_project_id
                      ,pjc_task_id
                      ,pjc_expenditure_type_id
                      ,pjc_expenditure_item_date
                      ,pjc_organization_id
                      ,pjc_project_number
                      ,pjc_task_number
                      ,pjc_expenditure_type_name
                      ,pjc_organization_name
                      ,pjc_reserved_attribute1
                      ,pjc_reserved_attribute2
                      ,pjc_reserved_attribute3
                      ,pjc_reserved_attribute4
                      ,pjc_reserved_attribute5
                      ,pjc_reserved_attribute6
                      ,pjc_reserved_attribute7
                      ,pjc_reserved_attribute8
                      ,pjc_reserved_attribute9
                      ,pjc_reserved_attribute10
                      ,pjc_user_def_attribute1
                      ,pjc_user_def_attribute2
                      ,pjc_user_def_attribute3
                      ,pjc_user_def_attribute4
                      ,pjc_user_def_attribute5
                      ,pjc_user_def_attribute6
                      ,pjc_user_def_attribute7
                      ,pjc_user_def_attribute8
                      ,pjc_user_def_attribute9
                      ,pjc_user_def_attribute10
                      ,fiscal_charge_type
                      ,def_acctg_start_date
                      ,def_acctg_end_date
                      ,def_accrual_code_concatenated
                      ,pjc_project_name
                      ,pjc_task_name
                      --,creation_date
                      --,created_by
                      --,last_update_date
                      --,last_updated_by
               FROM    xxmx_ap_invoice_lines_stg
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
                      ,invoice_id
                      ,line_number
                      ,line_type_lookup_code
                      ,amount
                      ,quantity_invoiced
                      ,unit_price
                      ,unit_of_meas_lookup_code
                      ,description
                      ,po_number
                      ,po_line_number
                      ,po_shipment_num
                      ,po_distribution_num
                      ,item_description
                      ,release_num
                      ,purchasing_category
                      ,receipt_number
                      ,receipt_line_number
                      ,consumption_advice_number
                      ,consumption_advice_line_number
                      ,packing_slip
                      ,final_match_flag
                      ,dist_code_concatenated
                      ,distribution_set_name
                      ,accounting_date
                      ,account_segment
                      ,balancing_segment
                      ,cost_center_segment
                      ,tax_classification_code
                      ,ship_to_location_code
                      ,ship_from_location_code
                      ,final_discharge_location_code
                      ,trx_business_category
                      ,product_fisc_classification
                      ,primary_intended_use
                      ,user_defined_fisc_class
                      ,product_type
                      ,assessable_value
                      ,product_category
                      ,control_amount
                      ,tax_regime_code
                      ,tax
                      ,tax_status_code
                      ,tax_jurisdiction_code
                      ,tax_rate_code
                      ,tax_rate
                      ,awt_group_name
                      ,type_1099
                      ,income_tax_region
                      ,prorate_across_flag
                      ,line_group_number
                      ,cost_factor_name
                      ,stat_amount
                      ,assets_tracking_flag
                      ,asset_book_type_code
                      ,asset_category_id
                      ,serial_number
                      ,manufacturer
                      ,model_number
                      ,warranty_number
                      ,price_correction_flag
                      ,price_correct_inv_num
                      ,price_correct_inv_line_num
                      ,requester_first_name
                      ,requester_last_name
                      ,requester_employee_num
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
                      ,attribute_number1
                      ,attribute_number2
                      ,attribute_number3
                      ,attribute_number4
                      ,attribute_number5
                      ,attribute_date1
                      ,attribute_date2
                      ,attribute_date3
                      ,attribute_date4
                      ,attribute_date5
                      ,global_attribute_category
                      ,global_attribute1
                      ,global_attribute2
                      ,global_attribute3
                      ,global_attribute4
                      ,global_attribute5
                      ,global_attribute6
                      ,global_attribute7
                      ,global_attribute8
                      ,global_attribute9
                      ,global_attribute10
                      ,global_attribute11
                      ,global_attribute12
                      ,global_attribute13
                      ,global_attribute14
                      ,global_attribute15
                      ,global_attribute16
                      ,global_attribute17
                      ,global_attribute18
                      ,global_attribute19
                      ,global_attribute20
                      ,global_attribute_number1
                      ,global_attribute_number2
                      ,global_attribute_number3
                      ,global_attribute_number4
                      ,global_attribute_number5
                      ,global_attribute_date1
                      ,global_attribute_date2
                      ,global_attribute_date3
                      ,global_attribute_date4
                      ,global_attribute_date5
                      ,pjc_project_id
                      ,pjc_task_id
                      ,pjc_expenditure_type_id
                      ,pjc_expenditure_item_date
                      ,pjc_organization_id
                      ,pjc_project_number
                      ,pjc_task_number
                      ,pjc_expenditure_type_name
                      ,pjc_organization_name
                      ,pjc_reserved_attribute1
                      ,pjc_reserved_attribute2
                      ,pjc_reserved_attribute3
                      ,pjc_reserved_attribute4
                      ,pjc_reserved_attribute5
                      ,pjc_reserved_attribute6
                      ,pjc_reserved_attribute7
                      ,pjc_reserved_attribute8
                      ,pjc_reserved_attribute9
                      ,pjc_reserved_attribute10
                      ,pjc_user_def_attribute1
                      ,pjc_user_def_attribute2
                      ,pjc_user_def_attribute3
                      ,pjc_user_def_attribute4
                      ,pjc_user_def_attribute5
                      ,pjc_user_def_attribute6
                      ,pjc_user_def_attribute7
                      ,pjc_user_def_attribute8
                      ,pjc_user_def_attribute9
                      ,pjc_user_def_attribute10
                      ,fiscal_charge_type
                      ,def_acctg_start_date
                      ,def_acctg_end_date
                      ,def_accrual_code_concatenated
                      ,pjc_project_name
                      ,pjc_task_name
               FROM    xxmx_ap_invoice_lines_xfm
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               FOR UPDATE;
               --
          --** END CURSOR XfmTableUpd_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_invoice_lines_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ap_invoice_lines_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE      := 'xxmx_ap_invoice_lines_xfm';
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
          vn_TransformRowCount            NUMBER;
          vt_MigrationStatus              xxmx_ap_invoice_lines_xfm.migration_status%TYPE;
          vt_DefaultDistCodeConcatenated  xxmx_migration_parameters.parameter_value%TYPE;
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
                    FROM   xxmx_ap_invoice_lines_xfm
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
                         FETCH        StgTable_cur
                         BULK COLLECT
                         INTO         StgTable_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    StgTable_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         FORALL APInvLines_idx IN 1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_ap_invoice_lines_xfm
                                          (
                                           migration_set_id
                                          ,migration_set_name
                                          ,migration_status
                                          ,invoice_id
                                          ,line_number
                                          ,line_type_lookup_code
                                          ,amount
                                          ,quantity_invoiced
                                          ,unit_price
                                          ,unit_of_meas_lookup_code
                                          ,description
                                          ,po_number
                                          ,po_line_number
                                          ,po_shipment_num
                                          ,po_distribution_num
                                          ,item_description
                                          ,release_num
                                          ,purchasing_category
                                          ,receipt_number
                                          ,receipt_line_number
                                          ,consumption_advice_number
                                          ,consumption_advice_line_number
                                          ,packing_slip
                                          ,final_match_flag
                                          ,dist_code_concatenated
                                          ,distribution_set_name
                                          ,accounting_date
                                          ,account_segment
                                          ,balancing_segment
                                          ,cost_center_segment
                                          ,tax_classification_code
                                          ,ship_to_location_code
                                          ,ship_from_location_code
                                          ,final_discharge_location_code
                                          ,trx_business_category
                                          ,product_fisc_classification
                                          ,primary_intended_use
                                          ,user_defined_fisc_class
                                          ,product_type
                                          ,assessable_value
                                          ,product_category
                                          ,control_amount
                                          ,tax_regime_code
                                          ,tax
                                          ,tax_status_code
                                          ,tax_jurisdiction_code
                                          ,tax_rate_code
                                          ,tax_rate
                                          ,awt_group_name
                                          ,type_1099
                                          ,income_tax_region
                                          ,prorate_across_flag
                                          ,line_group_number
                                          ,cost_factor_name
                                          ,stat_amount
                                          ,assets_tracking_flag
                                          ,asset_book_type_code
                                          ,asset_category_id
                                          ,serial_number
                                          ,manufacturer
                                          ,model_number
                                          ,warranty_number
                                          ,price_correction_flag
                                          ,price_correct_inv_num
                                          ,price_correct_inv_line_num
                                          ,requester_first_name
                                          ,requester_last_name
                                          ,requester_employee_num
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
                                          ,attribute_number1
                                          ,attribute_number2
                                          ,attribute_number3
                                          ,attribute_number4
                                          ,attribute_number5
                                          ,attribute_date1
                                          ,attribute_date2
                                          ,attribute_date3
                                          ,attribute_date4
                                          ,attribute_date5
                                          ,global_attribute_category
                                          ,global_attribute1
                                          ,global_attribute2
                                          ,global_attribute3
                                          ,global_attribute4
                                          ,global_attribute5
                                          ,global_attribute6
                                          ,global_attribute7
                                          ,global_attribute8
                                          ,global_attribute9
                                          ,global_attribute10
                                          ,global_attribute11
                                          ,global_attribute12
                                          ,global_attribute13
                                          ,global_attribute14
                                          ,global_attribute15
                                          ,global_attribute16
                                          ,global_attribute17
                                          ,global_attribute18
                                          ,global_attribute19
                                          ,global_attribute20
                                          ,global_attribute_number1
                                          ,global_attribute_number2
                                          ,global_attribute_number3
                                          ,global_attribute_number4
                                          ,global_attribute_number5
                                          ,global_attribute_date1
                                          ,global_attribute_date2
                                          ,global_attribute_date3
                                          ,global_attribute_date4
                                          ,global_attribute_date5
                                          ,pjc_project_id
                                          ,pjc_task_id
                                          ,pjc_expenditure_type_id
                                          ,pjc_expenditure_item_date
                                          ,pjc_organization_id
                                          ,pjc_project_number
                                          ,pjc_task_number
                                          ,pjc_expenditure_type_name
                                          ,pjc_organization_name
                                          ,pjc_reserved_attribute1
                                          ,pjc_reserved_attribute2
                                          ,pjc_reserved_attribute3
                                          ,pjc_reserved_attribute4
                                          ,pjc_reserved_attribute5
                                          ,pjc_reserved_attribute6
                                          ,pjc_reserved_attribute7
                                          ,pjc_reserved_attribute8
                                          ,pjc_reserved_attribute9
                                          ,pjc_reserved_attribute10
                                          ,pjc_user_def_attribute1
                                          ,pjc_user_def_attribute2
                                          ,pjc_user_def_attribute3
                                          ,pjc_user_def_attribute4
                                          ,pjc_user_def_attribute5
                                          ,pjc_user_def_attribute6
                                          ,pjc_user_def_attribute7
                                          ,pjc_user_def_attribute8
                                          ,pjc_user_def_attribute9
                                          ,pjc_user_def_attribute10
                                          ,fiscal_charge_type
                                          ,def_acctg_start_date
                                          ,def_acctg_end_date
                                          ,def_accrual_code_concatenated
                                          ,pjc_project_name
                                          ,pjc_task_name
                                          )
                              VALUES
                                          (
                                           StgTable_tbl(APInvLines_idx).migration_set_id                -- migration_set_id
                                          ,StgTable_tbl(APInvLines_idx).migration_set_name              -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                        -- migration_status
                                          ,StgTable_tbl(APInvLines_idx).invoice_id                      -- invoice_id
                                          ,StgTable_tbl(APInvLines_idx).line_number                     -- line_number
                                          ,StgTable_tbl(APInvLines_idx).line_type_lookup_code           -- line_type_lookup_code
                                          ,StgTable_tbl(APInvLines_idx).amount                          -- amount
                                          ,StgTable_tbl(APInvLines_idx).quantity_invoiced               -- quantity_invoiced
                                          ,StgTable_tbl(APInvLines_idx).unit_price                      -- unit_price
                                          ,StgTable_tbl(APInvLines_idx).unit_of_meas_lookup_code        -- unit_of_meas_lookup_code
                                          ,StgTable_tbl(APInvLines_idx).description                     -- description
                                          ,StgTable_tbl(APInvLines_idx).po_number                       -- po_number
                                          ,StgTable_tbl(APInvLines_idx).po_line_number                  -- po_line_number
                                          ,StgTable_tbl(APInvLines_idx).po_shipment_num                 -- po_shipment_num
                                          ,StgTable_tbl(APInvLines_idx).po_distribution_num             -- po_distribution_num
                                          ,StgTable_tbl(APInvLines_idx).item_description                -- item_description
                                          ,StgTable_tbl(APInvLines_idx).release_num                     -- release_num
                                          ,StgTable_tbl(APInvLines_idx).purchasing_category             -- purchasing_category
                                          ,StgTable_tbl(APInvLines_idx).receipt_number                  -- receipt_number
                                          ,StgTable_tbl(APInvLines_idx).receipt_line_number             -- receipt_line_number
                                          ,StgTable_tbl(APInvLines_idx).consumption_advice_number       -- consumption_advice_number
                                          ,StgTable_tbl(APInvLines_idx).consumption_advice_line_number  -- consumption_advice_line_number
                                          ,StgTable_tbl(APInvLines_idx).packing_slip                    -- packing_slip
                                          ,StgTable_tbl(APInvLines_idx).final_match_flag                -- final_match_flag
                                          ,StgTable_tbl(APInvLines_idx).dist_code_concatenated          -- dist_code_concatenated
                                          ,StgTable_tbl(APInvLines_idx).distribution_set_name           -- distribution_set_name
                                          ,StgTable_tbl(APInvLines_idx).accounting_date                 -- accounting_date
                                          ,StgTable_tbl(APInvLines_idx).account_segment                 -- account_segment
                                          ,StgTable_tbl(APInvLines_idx).balancing_segment               -- balancing_segment
                                          ,StgTable_tbl(APInvLines_idx).cost_center_segment             -- cost_center_segment
                                          ,StgTable_tbl(APInvLines_idx).tax_classification_code         -- tax_classification_code
                                          ,StgTable_tbl(APInvLines_idx).ship_to_location_code           -- ship_to_location_code
                                          ,StgTable_tbl(APInvLines_idx).ship_from_location_code         -- ship_from_location_code
                                          ,StgTable_tbl(APInvLines_idx).final_discharge_location_code   -- final_discharge_location_code
                                          ,StgTable_tbl(APInvLines_idx).trx_business_category           -- trx_business_category
                                          ,StgTable_tbl(APInvLines_idx).product_fisc_classification     -- product_fisc_classification
                                          ,StgTable_tbl(APInvLines_idx).primary_intended_use            -- primary_intended_use
                                          ,StgTable_tbl(APInvLines_idx).user_defined_fisc_class         -- user_defined_fisc_class
                                          ,StgTable_tbl(APInvLines_idx).product_type                    -- product_type
                                          ,StgTable_tbl(APInvLines_idx).assessable_value                -- assessable_value
                                          ,StgTable_tbl(APInvLines_idx).product_category                -- product_category
                                          ,StgTable_tbl(APInvLines_idx).control_amount                  -- control_amount
                                          ,StgTable_tbl(APInvLines_idx).tax_regime_code                 -- tax_regime_code
                                          ,StgTable_tbl(APInvLines_idx).tax                             -- tax
                                          ,StgTable_tbl(APInvLines_idx).tax_status_code                 -- tax_status_code
                                          ,StgTable_tbl(APInvLines_idx).tax_jurisdiction_code           -- tax_jurisdiction_code
                                          ,StgTable_tbl(APInvLines_idx).tax_rate_code                   -- tax_rate_code
                                          ,StgTable_tbl(APInvLines_idx).tax_rate                        -- tax_rate
                                          ,StgTable_tbl(APInvLines_idx).awt_group_name                  -- awt_group_name
                                          ,StgTable_tbl(APInvLines_idx).type_1099                       -- type_1099
                                          ,StgTable_tbl(APInvLines_idx).income_tax_region               -- income_tax_region
                                          ,StgTable_tbl(APInvLines_idx).prorate_across_flag             -- prorate_across_flag
                                          ,StgTable_tbl(APInvLines_idx).line_group_number               -- line_group_number
                                          ,StgTable_tbl(APInvLines_idx).cost_factor_name                -- cost_factor_name
                                          ,StgTable_tbl(APInvLines_idx).stat_amount                     -- stat_amount
                                          ,StgTable_tbl(APInvLines_idx).assets_tracking_flag            -- assets_tracking_flag
                                          ,StgTable_tbl(APInvLines_idx).asset_book_type_code            -- asset_book_type_code
                                          ,StgTable_tbl(APInvLines_idx).asset_category_id               -- asset_category_id
                                          ,StgTable_tbl(APInvLines_idx).serial_number                   -- serial_number
                                          ,StgTable_tbl(APInvLines_idx).manufacturer                    -- manufacturer
                                          ,StgTable_tbl(APInvLines_idx).model_number                    -- model_number
                                          ,StgTable_tbl(APInvLines_idx).warranty_number                 -- warranty_number
                                          ,StgTable_tbl(APInvLines_idx).price_correction_flag           -- price_correction_flag
                                          ,StgTable_tbl(APInvLines_idx).price_correct_inv_num           -- price_correct_inv_num
                                          ,StgTable_tbl(APInvLines_idx).price_correct_inv_line_num      -- price_correct_inv_line_num
                                          ,StgTable_tbl(APInvLines_idx).requester_first_name            -- requester_first_name
                                          ,StgTable_tbl(APInvLines_idx).requester_last_name             -- requester_last_name
                                          ,StgTable_tbl(APInvLines_idx).requester_employee_num          -- requester_employee_num
                                          ,StgTable_tbl(APInvLines_idx).attribute_category              -- attribute_category
                                          ,StgTable_tbl(APInvLines_idx).attribute1                      -- attribute1
                                          ,StgTable_tbl(APInvLines_idx).attribute2                      -- attribute2
                                          ,StgTable_tbl(APInvLines_idx).attribute3                      -- attribute3
                                          ,StgTable_tbl(APInvLines_idx).attribute4                      -- attribute4
                                          ,StgTable_tbl(APInvLines_idx).attribute5                      -- attribute5
                                          ,StgTable_tbl(APInvLines_idx).attribute6                      -- attribute6
                                          ,StgTable_tbl(APInvLines_idx).attribute7                      -- attribute7
                                          ,StgTable_tbl(APInvLines_idx).attribute8                      -- attribute8
                                          ,StgTable_tbl(APInvLines_idx).attribute9                      -- attribute9
                                          ,StgTable_tbl(APInvLines_idx).attribute10                     -- attribute10
                                          ,StgTable_tbl(APInvLines_idx).attribute11                     -- attribute11
                                          ,StgTable_tbl(APInvLines_idx).attribute12                     -- attribute12
                                          ,StgTable_tbl(APInvLines_idx).attribute13                     -- attribute13
                                          ,StgTable_tbl(APInvLines_idx).attribute14                     -- attribute14
                                          ,StgTable_tbl(APInvLines_idx).attribute15                     -- attribute15
                                          ,StgTable_tbl(APInvLines_idx).attribute_number1               -- attribute_number1
                                          ,StgTable_tbl(APInvLines_idx).attribute_number2               -- attribute_number2
                                          ,StgTable_tbl(APInvLines_idx).attribute_number3               -- attribute_number3
                                          ,StgTable_tbl(APInvLines_idx).attribute_number4               -- attribute_number4
                                          ,StgTable_tbl(APInvLines_idx).attribute_number5               -- attribute_number5
                                          ,StgTable_tbl(APInvLines_idx).attribute_date1                 -- attribute_date1
                                          ,StgTable_tbl(APInvLines_idx).attribute_date2                 -- attribute_date2
                                          ,StgTable_tbl(APInvLines_idx).attribute_date3                 -- attribute_date3
                                          ,StgTable_tbl(APInvLines_idx).attribute_date4                 -- attribute_date4
                                          ,StgTable_tbl(APInvLines_idx).attribute_date5                 -- attribute_date5
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_category       -- global_attribute_category
                                          ,StgTable_tbl(APInvLines_idx).global_attribute1               -- global_attribute1
                                          ,StgTable_tbl(APInvLines_idx).global_attribute2               -- global_attribute2
                                          ,StgTable_tbl(APInvLines_idx).global_attribute3               -- global_attribute3
                                          ,StgTable_tbl(APInvLines_idx).global_attribute4               -- global_attribute4
                                          ,StgTable_tbl(APInvLines_idx).global_attribute5               -- global_attribute5
                                          ,StgTable_tbl(APInvLines_idx).global_attribute6               -- global_attribute6
                                          ,StgTable_tbl(APInvLines_idx).global_attribute7               -- global_attribute7
                                          ,StgTable_tbl(APInvLines_idx).global_attribute8               -- global_attribute8
                                          ,StgTable_tbl(APInvLines_idx).global_attribute9               -- global_attribute9
                                          ,StgTable_tbl(APInvLines_idx).global_attribute10              -- global_attribute10
                                          ,StgTable_tbl(APInvLines_idx).global_attribute11              -- global_attribute11
                                          ,StgTable_tbl(APInvLines_idx).global_attribute12              -- global_attribute12
                                          ,StgTable_tbl(APInvLines_idx).global_attribute13              -- global_attribute13
                                          ,StgTable_tbl(APInvLines_idx).global_attribute14              -- global_attribute14
                                          ,StgTable_tbl(APInvLines_idx).global_attribute15              -- global_attribute15
                                          ,StgTable_tbl(APInvLines_idx).global_attribute16              -- global_attribute16
                                          ,StgTable_tbl(APInvLines_idx).global_attribute17              -- global_attribute17
                                          ,StgTable_tbl(APInvLines_idx).global_attribute18              -- global_attribute18
                                          ,StgTable_tbl(APInvLines_idx).global_attribute19              -- global_attribute19
                                          ,StgTable_tbl(APInvLines_idx).global_attribute20              -- global_attribute20
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_number1        -- global_attribute_number1
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_number2        -- global_attribute_number2
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_number3        -- global_attribute_number3
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_number4        -- global_attribute_number4
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_number5        -- global_attribute_number5
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_date1          -- global_attribute_date1
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_date2          -- global_attribute_date2
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_date3          -- global_attribute_date3
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_date4          -- global_attribute_date4
                                          ,StgTable_tbl(APInvLines_idx).global_attribute_date5          -- global_attribute_date5
                                          ,StgTable_tbl(APInvLines_idx).pjc_project_id                  -- pjc_project_id
                                          ,StgTable_tbl(APInvLines_idx).pjc_task_id                     -- pjc_task_id
                                          ,StgTable_tbl(APInvLines_idx).pjc_expenditure_type_id         -- pjc_expenditure_type_id
                                          ,StgTable_tbl(APInvLines_idx).pjc_expenditure_item_date       -- pjc_expenditure_item_date
                                          ,StgTable_tbl(APInvLines_idx).pjc_organization_id             -- pjc_organization_id
                                          ,StgTable_tbl(APInvLines_idx).pjc_project_number              -- pjc_project_number
                                          ,StgTable_tbl(APInvLines_idx).pjc_task_number                 -- pjc_task_number
                                          ,StgTable_tbl(APInvLines_idx).pjc_expenditure_type_name       -- pjc_expenditure_type_name
                                          ,StgTable_tbl(APInvLines_idx).pjc_organization_name           -- pjc_organization_name
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute1         -- pjc_reserved_attribute1
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute2         -- pjc_reserved_attribute2
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute3         -- pjc_reserved_attribute3
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute4         -- pjc_reserved_attribute4
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute5         -- pjc_reserved_attribute5
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute6         -- pjc_reserved_attribute6
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute7         -- pjc_reserved_attribute7
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute8         -- pjc_reserved_attribute8
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute9         -- pjc_reserved_attribute9
                                          ,StgTable_tbl(APInvLines_idx).pjc_reserved_attribute10        -- pjc_reserved_attribute10
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute1         -- pjc_user_def_attribute1
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute2         -- pjc_user_def_attribute2
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute3         -- pjc_user_def_attribute3
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute4         -- pjc_user_def_attribute4
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute5         -- pjc_user_def_attribute5
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute6         -- pjc_user_def_attribute6
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute7         -- pjc_user_def_attribute7
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute8         -- pjc_user_def_attribute8
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute9         -- pjc_user_def_attribute9
                                          ,StgTable_tbl(APInvLines_idx).pjc_user_def_attribute10        -- pjc_user_def_attribute10
                                          ,StgTable_tbl(APInvLines_idx).fiscal_charge_type              -- fiscal_charge_type
                                          ,StgTable_tbl(APInvLines_idx).def_acctg_start_date            -- def_acctg_start_date
                                          ,StgTable_tbl(APInvLines_idx).def_acctg_end_date              -- def_acctg_end_date
                                          ,StgTable_tbl(APInvLines_idx).def_accrual_code_concatenated   -- def_accrual_code_concatenated
                                          ,StgTable_tbl(APInvLines_idx).pjc_project_name                -- pjc_project_name
                                          ,StgTable_tbl(APInvLines_idx).pjc_task_name                   -- pjc_task_name
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
                    ** all GL Ledgers in the Migration Set.
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
                    ** For AP Invoice Lines we do not have any Simple Transformations, but we do need
                    ** to perform Data Enrichment to default values for DIST_CODE_CONCATENATED.  As
                    ** per the above suggestion, this is implemented in the Migration Parameters table.
                    */
                    --
                    gvb_SimpleTransformsRequired := FALSE;
                    gvb_DataEnrichmentRequired   := TRUE;
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         --
                         /*
                         ** Check for and perform any Simple Transforms and/or Data Enrichment to be performed in PL/SQL.
                         */
                         --
                         IF   gvb_SimpleTransformsRequired
                         THEN
                              --
                              /*
                              ** Verify that required simple transformations have been defined.
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
                                   ,pt_i_ModuleMessage       => '  - Verifying if simple transforms exist that apply to "'
                                                              ||pt_i_SubEntity
                                                              ||'".'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvb_MissingSimpleTransforms  := FALSE;
                              --
                              gvv_ProgressIndicator := '0130';
                              --
                              /*
                              ** Verify ???? transformations exist.
                              */
                              --
                              gvt_TransformCategoryCode := '????';
                              --
                              IF   xxmx_utilities_pkg.simple_transform_exists
                                        (
                                         pt_i_ApplicationSuite => gct_ApplicationSuite
                                        ,pt_i_Application      => gct_Application
                                        ,pt_i_CategoryCode     => gvt_TransformCategoryCode
                                        )
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'".'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingSimpleTransforms := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have NOT been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'.  These are expected.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   xxmx_utilities_pkg.simple_transform_exists
                              --
                              IF   gvb_MissingSimpleTransforms
                              THEN
                                   --
                                   gvv_ProgressIndicator := '0180';
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
                                        ,pt_i_ModuleMessage       => '    - Simple transformations are required for Sub-Entity "'
                                                                   ||pt_i_SubEntity
                                                                   ||'", however they can not be performed due to absent transform data.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_MissingSimpleTransforms
                              --
                         END IF; --** IF   gvb_SimpleTransformsRequired
                         --
                         /*
                         ** Now verify if any required setup for Data enrichment has been performed.
                         **
                         ** Most Data Enrichment (i.e. value defaulting) can be performed using the Migration
                         ** Parameters table as long as there are now rules involved.  Further development will
                         ** likely be required along these lines.
                         */
                         --
                         IF   gvb_DataEnrichmentRequired
                         THEN
                              --
                              /*
                              ** Verify that required setup required for Data Enrichment has been performed.
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
                                   ,pt_i_ModuleMessage       => '  - Verifying that data enrichment setup that applies to "'
                                                              ||pt_i_SubEntity
                                                              ||'" has been performed .'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvb_MissingDataEnrichment := FALSE;
                              --
                              gvt_ParameterCode := 'DEFAULT_DIST_CODE_CONCATENATED';
                              --
                              gvv_ParameterCheckResult := xxmx_utilities_pkg.verify_parameter_exists
                                                               (
                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                               ,pt_i_Application      => gct_Application
                                                               ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                               ,pt_i_SubEntity        => pt_i_SubEntity
                                                               ,pt_i_ParameterCode    => gvt_ParameterCode
                                                               );
                              --
                              IF   gvv_ParameterCheckResult = 'SINGLE'
                              THEN
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
                                        ,pt_i_ModuleMessage       => '    - Single Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSIF gvv_ParameterCheckResult = 'LIST'
                              THEN
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is defined but there are multiple occurrences '
                                                                   ||'and only one is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvb_MissingDataEnrichment := TRUE;
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
                                        ,pt_i_ModuleMessage       => '    - Parameter "'
                                                                   ||gvt_ParameterCode
                                                                   ||'" is not defined but is expected for Data Enrichment.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_DataEnrichmentRequired
                              --
                              IF   gvb_MissingDataEnrichment
                              THEN
                                   --
                                   gvv_ProgressIndicator := '0180';
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
                                        ,pt_i_ModuleMessage       => '    - Data Enrichment is required for Sub-Entity "'
                                                                   ||pt_i_SubEntity
                                                                   ||'", however it can not be performed due to absent enrichment data.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   gvb_MissingDataEnrichment
                              --
                         END IF; --** IF   gvb_DataEnrichmentRequired
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         IF   (
                                       gvb_SimpleTransformsRequired
                               AND NOT gvb_MissingSimpleTransforms
                              )
                         OR   (
                                       gvb_DataEnrichmentRequired
                               AND NOT gvb_MissingDataEnrichment
                              )
                         THEN
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
                                   ,pt_i_ModuleMessage       => '  - Performing Simple Transformations and/or Data Enrichment for the "'
                                                              ||pt_i_SubEntity
                                                              ||'" data in the "'
                                                              ||ct_XfmTable
                                                              ||'" table.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Update the XFM table performing all Simple Transforms and/or Data Enrichment for each row.
                              */
                              --
                              gvv_ProgressIndicator := '0150';
                              --
                              FOR  XfmTableUpd_rec
                              IN   XfmTableUpd_cur
                                        (
                                         pt_i_MigrationSetID
                                        )
                              LOOP
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
                                        ** for AP Invoice Lines we do not have any simple transformations
                                        ** defined in the XXMX_SIMPLE_TRANSFORMS table, however we do have
                                        ** to replace the Account Code Combinations that were extracted from
                                        ** the Source Database with default accounts to be used for the Fusion
                                        ** Import job.  This is handled in the Data Enrichment section next.
                                        */
                                        --
                                        /*
                                        ** Transform ????
                                        */
                                        --
                                        NULL;
                                        --
                                        --<< Simple transform 2 here >>
                                        --
                                        --<< Simple transform 3 here >>
                                        --
                                   END IF; --** IF   gvb_SimpleTransformsRequired
                                   --
                                   /*
                                   ** Now perform any Data Enrichment logic.
                                   */
                                   --
                                   IF   gvb_DataEnrichmentRequired
                                   THEN
                                        --
                                        /*
                                        ** For AP Invoices we need to replace the extracted DIST_CODE_CONCATENATED
                                        ** with a default value which will be held in the XXMX_MIGRATION_PARAMETERS
                                        ** table.
                                        */
                                        --
                                        gvv_ProgressIndicator := '0140';
                                        --
                                        gvt_ParameterCode := 'DEFAULT_DIST_CODE_CONCATENATED';
                                        --
                                        vt_DefaultDistCodeConcatenated := xxmx_utilities_pkg.get_single_parameter_value
                                                                               (
                                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                               ,pt_i_Application      => gct_Application
                                                                               ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                                               ,pt_i_SubEntity        => pt_i_SubEntity
                                                                               ,pt_i_ParameterCode    => gvt_ParameterCode
                                                                               );
                                        --
                                        IF   vt_DefaultDistCodeConcatenated IS NULL
                                        THEN
                                             --
                                             IF   vt_MigrationStatus = 'TRANSFORMED'
                                             THEN
                                                  --
                                                  vt_MigrationStatus := 'DATA_ENRICHMENT_FAILED';
                                                  --
                                             ELSE
                                                  --
                                                  vt_MigrationStatus := 'SIMPLE_TRANSFORM_AND_DATA_ENRICHMENT_FAILED';
                                                  --
                                             END IF;
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
                                                  ,pt_i_RecordIdentifiers     => 'Migration parameter '
                                                                               ||'['||gvt_ParameterCode||']'
                                                  ,pt_i_DataMessage           => 'Parameter does not exist or has no value assigned.'
                                                  ,pt_i_DataElementsAndValues => 'No transform result.'
                                                  );
                                             --
                                        END IF; --** IF   vt_DefaultDistCodeConcatenated IS NULL
                                        --
                                   END IF; --** IF   gvb_DataEnrichmentRequired
                                   --
                                   gvv_ProgressIndicator := '0170';
                                   --
                                   /*
                                   ** Update the current row of the XFM table for all transforms.
                                   **
                                   ** If you add more column transforms above, don't forget to add them
                                   ** to the UPDATE statement.
                                   */
                                   --
                                   UPDATE  xxmx_ap_invoice_lines_xfm
                                   SET     migration_status              = vt_MigrationStatus
                                          ,dist_code_concatenated        = vt_DefaultDistCodeConcatenated  --** Data Enrichment
                                   WHERE CURRENT OF XfmTableUpd_cur;
                                   --
                              END LOOP; --** XfmTableUpd_cur
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
                                   ,pt_i_ModuleMessage       => '  - Simple Transformations and/or Data Enrichment completed.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Commit the updates for the XFM table.
                              */
                              --
                              COMMIT;
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0190';
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
                                   ,pt_i_ModuleMessage       => '- Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                              ||pt_i_SubEntity
                                                              ||'", however they could not be performed due to absent Simple Transform or Data Enrichment setup.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF; --** IF Simple Transforms required and present or Data Enrichment required and present.
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0190';
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
                              ,pt_i_ModuleMessage       => '- No Simple Transformations or Data Enrichment are required for Sub-Entity "'
                                                         ||pt_i_SubEntity
                                                         ||'".'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                    END IF; --** IF Simple Transforms required or Data Enrichment required.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0200';
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
                         ,pt_i_ModuleMessage       => '  - Any simple transformations for "'
                                                    ||pt_i_SubEntity
                                                    ||'" data should be performed within '
                                                    ||pt_i_SimpleXfmPerformedBy
                                                    ||'.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF; --** IF   pt_i_SimpleXfmPerformedBy = 'PLSQL'
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
               gvv_ProgressIndicator := '0220';
               --
               gvb_ComplexTransformsRequired := FALSE;
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
                    gvb_PerformComplexTransforms := FALSE;
                    --
                    IF   gvb_PerformComplexTransforms
                    THEN
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
                              ,pt_i_ModuleMessage       => '  - Performing complex transformations for the "'
                                                         ||pt_i_SubEntity
                                                         ||'" data in the "'
                                                         ||ct_XfmTable
                                                         ||'" table.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0250';
                         --
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
     END ap_invoice_lines_xfm;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          IF   pt_i_ClientCode       IS NULL
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
          --** ISV 21/10/2020 - Commented out for now as not sure this would remove messages written by other extracts.
          --/*
          --** Clear Core Module Messages
          --*/
          ----
          --gvv_ReturnStatus  := '';
          ----
          --xxmx_utilities_pkg.clear_messages
          --     (
          --      pt_i_ApplicationSuite => 'XXMX'
          --     ,pt_i_Application      => 'XXMX'
          --     ,pt_i_BusinessEntity   => 'CORE_REPORTING'
          --     ,pt_i_SubEntity        => NULL
          --     ,pt_i_Phase            => 'CORE'
          --     ,pt_i_MessageType      => 'MODULE'
          --     ,pv_o_ReturnStatus     => gvv_ReturnStatus
          --     );
          ----
          --IF   gvv_ReturnStatus = 'F'
          --THEN
          --     --
          --     xxmx_utilities_pkg.log_module_message
          --          (
          --           pt_i_ApplicationSuite  => gct_ApplicationSuite
          --          ,pt_i_Application       => gct_Application
          --          ,pt_i_BusinessEntity    => gct_BusinessEntity
          --          ,pt_i_SubEntity         => ct_SubEntity
          --          ,pt_i_Phase             => ct_Phase
          --          ,pt_i_Severity          => 'ERROR'
          --          ,pt_i_PackageName       => gct_PackageName
          --          ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
          --          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          --          ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
          --          ,pt_i_OracleError       => gvt_ReturnMessage
          --          );
          --     --
          --     RAISE e_ModuleError;
          --     --
          --END IF;
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
          --** ISV 21/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and "xxmx_core".
          --/*
          --** Retrieve the Client Config Parameters needed to call subsequent procedures. 
          --*/
          ----
          --gvv_ProgressIndicator := '0030';
          --
          --vt_ConfigParameter := 'CLIENT_SCHEMA_NAME';
          ----
          --vt_ClientSchemaName := xxmx_utilities_pkg.get_client_config_value
          --                            (
          --                             pt_i_ClientCode      => pt_i_ClientCode
          --                            ,pt_i_ConfigParameter => vt_ConfigParameter
          --                            );
          ----
          --IF   vt_ClientSchemaName IS NULL
          --THEN
          --     --
          --     --
          --     gvt_Severity      := 'ERROR';
          --     --
          --     gvt_ModuleMessage := '- Client configuration parameter "'
          --                        ||vt_ConfigParameter
          --                        ||'" does not exist in "xxmx_client_config_parameters" table.';
          --     --
          --     RAISE e_ModuleError;
          --     --
          --     --
          --END IF;
          ----
          --xxmx_utilities_pkg.log_module_message
          --     (
          --      pt_i_ApplicationSuite  => gct_ApplicationSuite
          --     ,pt_i_Application       => gct_Application
          --     ,pt_i_BusinessEntity    => gct_BusinessEntity
          --     ,pt_i_SubEntity         => ct_SubEntity
          --     ,pt_i_Phase             => ct_Phase
          --     ,pt_i_Severity          => 'NOTIFICATION'
          --     ,pt_i_PackageName       => gct_PackageName
          --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
          --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          --     ,pt_i_ModuleMessage     => '- '
          --                              ||pt_i_ClientCode
          --                              ||' Client Config Parameter "'
          --                              ||vt_ConfigParameter
          --                              ||'" = '
          --                              ||vt_ClientSchemaName
          --     ,pt_i_OracleError       => NULL
          --     );
          --
          /*
          ** Initialize the Migration Set for the Business Entity retrieving
          ** a new Migration Set ID.
          */
          --
          --** ISV 21/10/2020 - Removed Sequence Number Parameters as "init_migration_set" procedure will determine these 
          --                    from the metadata table based on Application Suite, Application and Business Entity parameters.
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_MigrationSetName => pt_i_MigrationSetName
               ,pt_o_MigrationSetID   => vt_MigrationSetID
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Migration Set "'
                                        ||pt_i_MigrationSetName
                                        ||'" initialized (Generated Migration Set ID = '
                                        ||vt_MigrationSetID
                                        ||').  Processing extracts:'
               ,pt_i_OracleError       => NULL
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Calling Procedure "'
                                             ||StagingMetadata_rec.entity_package_name
                                             ||'.'
                                             ||StagingMetadata_rec.stg_procedure_name
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** ISV 21/10/2020 - Removed Client Schema Name, Business Entity and Staging Table parameters from dynamic SQL call
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||StagingMetadata_rec.entity_package_name
                                 ||'.'
                                 ||StagingMetadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||' pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity               => '''
                                 ||StagingMetadata_rec.sub_entity
                                 ||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
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
          --xxmx_utilities_pkg.close_extract_phase
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
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity => ct_SubEntity
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
                         ,pt_i_SubEntity => ct_SubEntity
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
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gct_PackageName
                    ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Calling Procedure "'
                                               ||Metadata_rec.entity_package_name
                                               ||'.'
                                               ||Metadata_rec.xfm_procedure_name
                                               ||'".'
                    ,pt_i_OracleError         => NULL
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
          --** ISV 21/10/2020 - Add new constant for Staging Schema andf Table Name as will no longer be passed as parameters.
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'CORE';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
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
               gvt_Severity      := 'ERROR';
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
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
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
          --** ISV 21/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and "xxmx_core".
          --gvv_ProgressIndicator := '0030';
          ----
          --vt_ConfigParameter := 'CLIENT_SCHEMA_NAME';
          ----
          --vt_ClientSchemaName := xxmx_utilities_pkg.get_client_config_value
          --                            (
          --                             pt_i_ClientCode      => pt_i_ClientCode
          --                            ,pt_i_ConfigParameter => vt_ConfigParameter
          --                            );
          ----
          --IF   vt_ClientSchemaName IS NULL
          --THEN
          --     --
          --     --
          --     gvt_ModuleMessage := '- Client configuration parameter "'
          --                        ||vt_ConfigParameter
          --                        ||'" does not exist in "xxmx_client_config_parameters" table.';
          --     --
          --     RAISE e_ModuleError;
          --     --
          --     --
          --END IF;
          ----
          --xxmx_utilities_pkg.log_module_message
          --     (
          --      pt_i_ApplicationSuite  => gct_ApplicationSuite
          --     ,pt_i_Application       => gct_Application
          --     ,pt_i_BusinessEntity    => gct_BusinessEntity
          --     ,pt_i_SubEntity         => ct_SubEntity
          --     ,pt_i_Phase             => ct_Phase
          --     ,pt_i_Severity          => 'NOTIFICATION'
          --     ,pt_i_PackageName       => gct_PackageName
          --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
          --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          --     ,pt_i_ModuleMessage     => '- '
          --                              ||pt_i_ClientCode
          --                              ||' Client Config Parameter "'
          --                              ||vt_ConfigParameter
          --                              ||'" = '
          --                              ||vt_ClientSchemaName
          --     ,pt_i_OracleError       => NULL
          --     );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
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
               --** ISV 21/10/2020 - Replace with new constant for Staging Schema.
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
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged from "'
                                             ||PurgingMetadata_rec.stg_table
                                             ||'" table: '
                                             ||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );
               --
               --gvv_SQLTableClause := 'FROM '
               --                    ||ct_XfmSchema
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
               --      pt_i_ApplicationSuite  => gct_ApplicationSuite
               --     ,pt_i_Application       => gct_Application
               --     ,pt_i_BusinessEntity    => gct_BusinessEntity
               --     ,pt_i_SubEntity         => ct_SubEntity
               --     ,pt_i_Phase             => ct_Phase
               --     ,pt_i_Severity          => 'NOTIFICATION'
               --     ,pt_i_PackageName       => gct_PackageName
               --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               --     ,pt_i_ModuleMessage     => '  - Records purged from "'
               --                              ||PurgingMetadata_rec.xfm_table
               --                              ||'" table: '
               --                              ||gvn_RowCount
               --     ,pt_i_OracleError       => NULL
               --     );
               --
          END LOOP;
          --
          /*
          ** Purge the records for the Business Entity Levels
          ** Levels from the Migration Details table.
          */
          --
          --** ISV 21/10/2020 - Replace with new constant for Core Schema.
          --
          vv_PurgeTableName := 'xxmx_migration_details';
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
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Records purged from "'
                                        ||vv_PurgeTableName
                                        ||'" table: '
                                        ||gvn_RowCount
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Purge the records for the Business Entity
          ** from the Migration Headers table.
          */
          --
          --** ISV 21/10/2020 - Replace with new constant for Core Schema.
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
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Records purged from "'
                                        ||vv_PurgeTableName
                                        ||'" table: '
                                        ||gvn_RowCount
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Purging complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
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
     END purge;
     --
END xxmx_ap_inv_pkg;
/
