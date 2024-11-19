--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_APLICENSE_FEE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_APLICENSE_FEE_PKG" 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_PPM_APLICENSE_FEE_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'AP_INVOICES';
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
     ** PROCEDURE: lic_unpaid_stg
     ********************************
     */
     --
     PROCEDURE lic_unpaid_stg
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
                           FROM   apps.gl_ledgers@XXMX_EXTRACT  gl
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
                                FROM apps.xle_entity_profiles@XXMX_EXTRACT xep
                                WHERE xep.legal_entity_id = aia.legal_entity_id))    AS legal_entity_name
                         ,TRIM(aia.cust_registration_number)                         AS cust_registration_number
                         ,TRIM(aia.Cust_Registration_Code)                           AS cust_registration_code
                         ,NULL                                                       AS first_party_registration_num
                         ,NULL                                                       AS third_party_registration_num
                         ,TRIM(apt.name)                                             AS terms_name
                         ,TRIM(aia.terms_date)                                       AS terms_date
                         ,TRIM(aia.goods_received_date)                              AS goods_received_date
                         ,TRIM(aia.invoice_received_date)                            AS invoice_received_date
--                         ,TRIM(aia.gl_date)                                          AS gl_date
                         ,xxmx_utilities_pkg.get_single_parameter_value('FIN','GL','BALANCES','ALL','GL_DATE') AS gl_date
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
                         ,TRIM(gcck.concatenated_segments)                           AS accts_pay_code_concatenated -- concatenated segment value AP invoice 05/04/2022
/*
                        ,(SELECT PARAMETER_VALUE  
                            FROM XXMX_MIGRATION_PARAMETERS
                            WHERE
                            application = 'AP'  
                            AND business_entity = 'INVOICES'
                            AND PARAMETER_CODE = 'DEFAULT_PAY_CODE_CONCATENATED'
                            AND SUB_ENTITY = 'INVOICE_HEADERS')                      AS  accts_pay_code_concatenated
*/
                         /* ,(SELECT PARAMETER_VALUE  
                            FROM XXMX_MIGRATION_PARAMETERS
                            WHERE
                            application = 'AP'  
                            AND business_entity = 'INVOICES'
                            AND PARAMETER_CODE = 'DEFAULT_ACCT_PAY_CCID_'||haou.name
                            AND SUB_ENTITY = 'INVOICE_HEADER')                      AS accts_pay_code_concatenated -- change requested by Elvis 24/03/2022*/
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
                         ,apps.ap_invoices_all@XXMX_EXTRACT                        aia
                         ,apps.ap_supplier_sites_all@XXMX_EXTRACT                  assa
                         ,apps.ap_suppliers@XXMX_EXTRACT                           aps
                         ,apps.hz_parties@XXMX_EXTRACT                             hp
                         ,apps.ap_terms_tl@XXMX_EXTRACT                            apt
                         ,apps.hr_all_organization_units@XXMX_EXTRACT              haou
                         ,apps.gl_code_combinations@XXMX_EXTRACT                   gcc
                         ,apps.gl_code_combinations_kfv@XXMX_EXTRACT               gcck
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'lic_unpaid_stg';
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => NULL
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
                    ,pt_i_FileSetID         => NULL
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
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => NULL
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
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0041';
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               gvv_ProgressIndicator := '0042';
               /*xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite       => gct_ApplicationSuite
                    ,pt_i_Application            => gct_Application
                    ,pt_i_BusinessEntity         => gct_BusinessEntity
                    ,pt_i_SubEntity              => pt_i_SubEntity
                    ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                    ,pt_i_StagingTable           => ct_StgTable
                    ,pt_i_ExtractStartDate       => SYSDATE
                    );*/
               --
               gvv_ProgressIndicator := '0043';
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_FileSetID         => NULL
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
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => NULL
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
                        ,pt_i_FileSetID         => NULL
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END lic_unpaid_stg;
     --
     --
     /*
     ********************************
     ** PROCEDURE: lic_unpaid_xfm
     ********************************
     */
     --
     PROCEDURE lic_unpaid_xfm
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
                       pt_MigrationSetID               xxmx_ap_invoices_stg.migration_set_id%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'lic_unpaid_xfm';
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
                    ,pt_i_FileSetID         => NULL
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
                    ,pt_i_FileSetID         => NULL
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
               ,pt_i_FileSetID         => NULL
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
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                   ,pt_i_FileSetID         => NULL
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                   ,pt_i_FileSetID         => NULL
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                        ,pt_i_FileSetID         => NULL
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                   ,pt_i_FileSetID         => NULL
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                   ,pt_i_FileSetID         => NULL
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                                   ,pt_i_FileSetID         => NULL
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                              ,pt_i_FileSetID         => NULL
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                         ,pt_i_FileSetID         => NULL
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                              ,pt_i_FileSetID         => NULL
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                              ,pt_i_FileSetID         => NULL
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
                         gvv_ProgressIndicator := '0370';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => NULL
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
                    gvv_ProgressIndicator := '0380';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => NULL
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
                    ,pt_i_FileSetID         => NULL
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
               ,pt_i_FileSetID         => NULL
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
                         ,pt_i_FileSetID         => NULL
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
                         ,pt_i_FileSetID         => NULL
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
     END lic_unpaid_xfm;
     --
     --
END XXMX_PPM_APLICENSE_FEE_PKG;

/
