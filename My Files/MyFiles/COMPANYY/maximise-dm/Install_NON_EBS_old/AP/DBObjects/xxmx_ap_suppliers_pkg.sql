--------------------------------------------------------
--  File created - Wednesday-September-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package XXMX_SUPPLIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE  PACKAGE "XXMX_SUPPLIER_PKG" 
AS
     --
     --
     /*
     ******************************
     ** PROCEDURE: ap_suppliers_stg
     ******************************
     */
     --
     PROCEDURE ap_suppliers_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ***************************************
     ** PROCEDURE: ap_supplier_addresses_stg
     ***************************************
     */
     --
     PROCEDURE ap_supplier_addresses_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ***********************************
     ** PROCEDURE: ap_supplier_sites_stg
     ***********************************
     */
     --
     PROCEDURE ap_supplier_sites_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supp_3rd_party_rels_stg
     ****************************************
     */
     --
     PROCEDURE ap_supp_3rd_party_rels_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supp_site_assigns_stg
     **************************************
     */
     --
     PROCEDURE ap_supp_site_assigns_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supplier_contacts_stg
     **************************************
     */
     --
     PROCEDURE ap_supplier_contacts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     *******************************************
     ** PROCEDURE: ap_supplier_contact_addrs_stg
     *******************************************
     */
     --
     PROCEDURE ap_supplier_contact_addrs_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ************************************
     ** PROCEDURE: ap_supplier_payees_stg
     ************************************
     */
     --
     PROCEDURE ap_supplier_payees_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_bank_accts_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_bank_accts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_pmt_instrs_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_pmt_instrs_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
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
END xxmx_supplier_pkg;
/

  CREATE OR REPLACE  PACKAGE BODY "XXMX_SUPPLIER_PKG" 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_supplier_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'SUPPLIERS';
     gct_MigrateCISData                        CONSTANT VARCHAR2(1)                                  := 'N';                 -- Added for SMBC flexibility, could move to migration parameter table
     --
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
     ** Global Variables for Exception Handlers
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
     --
     /*
     ******************************
     ** PROCEDURE: ap_suppliers_stg
     ******************************
     */
     --
     PROCEDURE ap_suppliers_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_suppliers_cur
          IS
               --
               --
               SELECT DISTINCT
                       'CREATE'                                                       AS import_action
                      ,aps.vendor_id                                                  AS supplier_id
                      ,aps.vendor_name                                                AS supplier_name
                      ,''                                                             AS supplier_name_new
                      ,aps.segment1                                                   AS supplier_number
                      ,aps.vendor_name_alt                                            AS alternate_name
                      ,NULL                                                           AS tax_organization_type
                      ,aps.vendor_type_lookup_code                                    AS supplier_type
                      ,aps.end_date_active                                            AS inactive_date
                      ,NULL                                                           AS business_relationship
                      ,(
                        SELECT aps2.vendor_name
                        FROM   apps.ap_suppliers@MXDM_NVIS_EXTRACT aps2
                        WHERE  aps2.vendor_id = aps.parent_vendor_id
                       )                                                              AS parent_supplier
                      ,''                                                             AS alias
                      ,(
                        SELECT RPAD(MAX(assa.ece_tp_location_code),9,'0')
                        FROM   apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT assa
                        WHERE  aps.vendor_id            = assa.vendor_id
                        AND    assa.ece_tp_location_code IS NOT NULL
                        AND    ROWNUM = 1
                       )                                                              AS duns_number
                      ,aps.one_time_flag                                              AS one_time_supplier
                      ,''                                                             AS customer_number
                      ,''                                                             AS sic
                      ,aps.national_insurance_number                                  AS national_insurance_number
                      ,''                                                             AS corporate_web_site
                      ,''                                                             AS chief_executive_title
                      ,''                                                             AS chif_executive_name
                      ,CASE
                           WHEN aps.women_owned_flag = 'Y'
                           OR   aps.small_business_flag = 'Y'
                                THEN 'Y'
                           ELSE NULL
                       END                                                            AS business_classification
                      ,(
                        SELECT country_code
                        FROM   apps.zx_party_tax_profile@MXDM_NVIS_EXTRACT zptp
                        WHERE  zptp.party_id   = aps.party_id
                        AND    party_type_code = 'THIRD_PARTY'
                       )                                                              AS taxpayer_country
                      ,aps.num_1099                                                   AS taxpayer_id
                      ,aps.federal_reportable_flag                                    AS federal_reportable
                      ,aps.type_1099                                                  AS federal_income_tax_type
                      ,aps.state_reportable_flag                                      AS state_reportable
                      ,aps.tax_reporting_name                                         AS tax_reporting_name
                      ,aps.name_control                                               AS name_control
                      ,aps.tax_verification_date                                      AS tax_verification_date
                      ,decode(gct_MigrateCISData,'N','N',aps.allow_awt_flag)          AS use_withholding_tax
                      ,decode(gct_MigrateCISData,'N',null,(
                        SELECT name
                        FROM  apps.ap_awt_groups@MXDM_NVIS_EXTRACT aag
                        WHERE  aag.group_id = aps.awt_group_id
                       ))                                                             AS withholding_tax_group
                      ,aps.vat_code                                                   AS supplier_vat_code
                      ,aps.vat_registration_num                                       AS tax_registration_number
                      ,aps.auto_tax_calc_override                                     AS auto_tax_calc_override
                      ,aps.payment_method_lookup_code                                 AS supplier_payment_method
                      ,''                                                             AS delivery_channel
                      ,''                                                             AS bank_instruction_1
                      ,''                                                             AS bank_instruction_2
                      ,''                                                             AS bank_instruction
                      ,''                                                             AS settlement_priority
                      ,''                                                             AS payment_text_message_1
                      ,''                                                             AS payment_text_message_2
                      ,''                                                             AS payment_text_message_3
                      ,''                                                             AS bank_charge_bearer
                      ,''                                                             AS payment_reason
                      ,''                                                             AS payment_reason_comments
                      ,''                                                             AS payment_format
                      ,NULL                                                           AS attribute_category
                      ,NULL                                                           AS attribute1
                      ,NULL                                                           AS attribute2
                      ,NULL                                                           AS attribute3
                      ,NULL                                                           AS attribute4
                      ,NULL                                                           AS attribute5
                      ,NULL                                                           AS attribute6
                      ,NULL                                                           AS attribute7
                      ,NULL                                                           AS attribute8
                      ,NULL                                                           AS attribute9
                      ,NULL                                                           AS attribute10
                      ,NULL                                                           AS attribute11
                      ,NULL                                                           AS attribute12
                      ,NULL                                                           AS attribute13
                      ,NULL                                                           AS attribute14
                      ,NULL                                                           AS attribute15
                      ,NULL                                                           AS attribute16
                      ,NULL                                                           AS attribute17
                      ,NULL                                                           AS attribute18
                      ,NULL                                                           AS attribute19
                      ,NULL                                                           AS attribute20
                      ,NULL                                                           AS attribute_date1
                      ,NULL                                                           AS attribute_date2
                      ,NULL                                                           AS attribute_date3
                      ,NULL                                                           AS attribute_date4
                      ,NULL                                                           AS attribute_date5
                      ,NULL                                                           AS attribute_date6
                      ,NULL                                                           AS attribute_date7
                      ,NULL                                                           AS attribute_date8
                      ,NULL                                                           AS attribute_date9
                      ,NULL                                                           AS attribute_date10
                      ,NULL                                                           AS attribute_timestamp1
                      ,NULL                                                           AS attribute_timestamp2
                      ,NULL                                                           AS attribute_timestamp3
                      ,NULL                                                           AS attribute_timestamp4
                      ,NULL                                                           AS attribute_timestamp5
                      ,NULL                                                           AS attribute_timestamp6
                      ,NULL                                                           AS attribute_timestamp7
                      ,NULL                                                           AS attribute_timestamp8
                      ,NULL                                                           AS attribute_timestamp9
                      ,NULL                                                           AS attribute_timestamp10
                      ,NULL                                                           AS attribute_number1
                      ,NULL                                                           AS attribute_number2
                      ,NULL                                                           AS attribute_number3
                      ,NULL                                                           AS attribute_number4
                      ,NULL                                                           AS attribute_number5
                      ,NULL                                                           AS attribute_number6
                      ,NULL                                                           AS attribute_number7
                      ,NULL                                                           AS attribute_number8
                      ,NULL                                                           AS attribute_number9
                      ,NULL                                                           AS attribute_number10
                      ,NULL                                                           AS global_attribute_category
                      ,NULL                                                           AS global_attribute1
                      ,NULL                                                           AS global_attribute2
                      ,NULL                                                           AS global_attribute3
                      ,NULL                                                           AS global_attribute4
                      ,NULL                                                           AS global_attribute5
                      ,NULL                                                           AS global_attribute6
                      ,NULL                                                           AS global_attribute7
                      ,NULL                                                           AS global_attribute8
                      ,NULL                                                           AS global_attribute9
                      ,NULL                                                           AS global_attribute10
                      ,NULL                                                           AS global_attribute11
                      ,NULL                                                           AS global_attribute12
                      ,NULL                                                           AS global_attribute13
                      ,NULL                                                           AS global_attribute14
                      ,NULL                                                           AS global_attribute15
                      ,NULL                                                           AS global_attribute16
                      ,NULL                                                           AS global_attribute17
                      ,NULL                                                           AS global_attribute18
                      ,NULL                                                           AS global_attribute19
                      ,NULL                                                           AS global_attribute20
                      ,NULL                                                           AS global_attribute_date1
                      ,NULL                                                           AS global_attribute_date2
                      ,NULL                                                           AS global_attribute_date3
                      ,NULL                                                           AS global_attribute_date4
                      ,NULL                                                           AS global_attribute_date5
                      ,NULL                                                           AS global_attribute_date6
                      ,NULL                                                           AS global_attribute_date7
                      ,NULL                                                           AS global_attribute_date8
                      ,NULL                                                           AS global_attribute_date9
                      ,NULL                                                           AS global_attribute_date10
                      ,NULL                                                           AS global_attribute_timestamp1
                      ,NULL                                                           AS global_attribute_timestamp2
                      ,NULL                                                           AS global_attribute_timestamp3
                      ,NULL                                                           AS global_attribute_timestamp4
                      ,NULL                                                           AS global_attribute_timestamp5
                      ,NULL                                                           AS global_attribute_timestamp6
                      ,NULL                                                           AS global_attribute_timestamp7
                      ,NULL                                                           AS global_attribute_timestamp8
                      ,NULL                                                           AS global_attribute_timestamp9
                      ,NULL                                                           AS global_attribute_timestamp10
                      ,NULL                                                           AS global_attribute_number1
                      ,NULL                                                           AS global_attribute_number2
                      ,NULL                                                           AS global_attribute_number3
                      ,NULL                                                           AS global_attribute_number4
                      ,NULL                                                           AS global_attribute_number5
                      ,NULL                                                           AS global_attribute_number6
                      ,NULL                                                           AS global_attribute_number7
                      ,NULL                                                           AS global_attribute_number8
                      ,NULL                                                           AS global_attribute_number9
                      ,NULL                                                           AS global_attribute_number10
                      ,''                                                             AS regisrty_id
                      ,''                                                             AS service_level_code
                      ,aps.exclusive_payment_flag                                     AS exclusive_payment_flag
                      ,''                                                             AS remit_advice_delivery_method
                      ,''                                                             AS remit_advice_email
                      ,''                                                             AS remit_advice_fax
               FROM    xxmx_supplier_scope_v                xssv
                      ,apps.ap_suppliers@MXDM_NVIS_EXTRACT  aps
                      ,apps.hz_parties@MXDM_NVIS_EXTRACT    hp
               WHERE   1 = 1
               AND     aps.vendor_id = xssv.vendor_id
               AND     aps.party_id  = hp.party_id;
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_suppliers_tt IS TABLE OF ap_suppliers_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'ap_suppliers_stg';
          ct_StgSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_suppliers_stg';
          ct_Phase                        CONSTANT xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          ap_suppliers_tbl  ap_suppliers_tt;
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
     --** END Declarations
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_suppliers_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_suppliers_cur
                    BULK COLLECT
                    INTO ap_suppliers_tbl
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_suppliers_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..ap_suppliers_tbl.COUNT
                         --
                         INSERT
                         INTO    xxmx_ap_suppliers_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_id
                                   ,supplier_name
                                   ,supplier_name_new
                                   ,supplier_number
                                   ,alternate_name
                                   ,tax_organization_type
                                   ,supplier_type
                                   ,inactive_date
                                   ,business_relationship
                                   ,parent_supplier
                                   ,alias
                                   ,duns_number
                                   ,one_time_supplier
                                   ,customer_number
                                   ,sic
                                   ,national_insurance_number
                                   ,corporate_web_site
                                   ,chief_executive_title
                                   ,chif_executive_name
                                   ,business_classification
                                   ,taxpayer_country
                                   ,taxpayer_id
                                   ,federal_reportable
                                   ,federal_income_tax_type
                                   ,state_reportable
                                   ,tax_reporting_name
                                   ,name_control
                                   ,tax_verification_date
                                   ,use_withholding_tax
                                   ,withholding_tax_group
                                   ,supplier_vat_code
                                   ,tax_registration_number
                                   ,auto_tax_calc_override
                                   ,supplier_payment_method
                                   ,delivery_channel
                                   ,bank_instruction_1
                                   ,bank_instruction_2
                                   ,bank_instruction
                                   ,settlement_priority
                                   ,payment_text_message_1
                                   ,payment_text_message_2
                                   ,payment_text_message_3
                                   ,bank_charge_bearer
                                   ,payment_reason
                                   ,payment_reason_comments
                                   ,payment_format
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
                                   ,attribute16
                                   ,attribute17
                                   ,attribute18
                                   ,attribute19
                                   ,attribute20
                                   ,attribute_date1
                                   ,attribute_date2
                                   ,attribute_date3
                                   ,attribute_date4
                                   ,attribute_date5
                                   ,attribute_date6
                                   ,attribute_date7
                                   ,attribute_date8
                                   ,attribute_date9
                                   ,attribute_date10
                                   ,attribute_timestamp1
                                   ,attribute_timestamp2
                                   ,attribute_timestamp3
                                   ,attribute_timestamp4
                                   ,attribute_timestamp5
                                   ,attribute_timestamp6
                                   ,attribute_timestamp7
                                   ,attribute_timestamp8
                                   ,attribute_timestamp9
                                   ,attribute_timestamp10
                                   ,attribute_number1
                                   ,attribute_number2
                                   ,attribute_number3
                                   ,attribute_number4
                                   ,attribute_number5
                                   ,attribute_number6
                                   ,attribute_number7
                                   ,attribute_number8
                                   ,attribute_number9
                                   ,attribute_number10
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
                                   ,global_attribute_date1
                                   ,global_attribute_date2
                                   ,global_attribute_date3
                                   ,global_attribute_date4
                                   ,global_attribute_date5
                                   ,global_attribute_date6
                                   ,global_attribute_date7
                                   ,global_attribute_date8
                                   ,global_attribute_date9
                                   ,global_attribute_date10
                                   ,global_attribute_timestamp1
                                   ,global_attribute_timestamp2
                                   ,global_attribute_timestamp3
                                   ,global_attribute_timestamp4
                                   ,global_attribute_timestamp5
                                   ,global_attribute_timestamp6
                                   ,global_attribute_timestamp7
                                   ,global_attribute_timestamp8
                                   ,global_attribute_timestamp9
                                   ,global_attribute_timestamp10
                                   ,global_attribute_number1
                                   ,global_attribute_number2
                                   ,global_attribute_number3
                                   ,global_attribute_number4
                                   ,global_attribute_number5
                                   ,global_attribute_number6
                                   ,global_attribute_number7
                                   ,global_attribute_number8
                                   ,global_attribute_number9
                                   ,global_attribute_number10
                                   ,regisrty_id
                                   ,service_level_code
                                   ,exclusive_payment_flag
                                   ,remit_advice_delivery_method
                                   ,remit_advice_email
                                   ,remit_advice_fax
                                   )
                         VALUES
                                   (
                                    pt_i_MigrationSetID                               --MIGRATION_SET_ID
                                   ,gvt_MigrationSetName                               --MIGRATION_SET_NAME
                                   ,'EXTRACTED'
                                   ,ap_suppliers_tbl(i).import_action
                                   ,ap_suppliers_tbl(i).supplier_id
                                   ,ap_suppliers_tbl(i).supplier_name
                                   ,ap_suppliers_tbl(i).supplier_name_new
                                   ,ap_suppliers_tbl(i).supplier_number
                                   ,ap_suppliers_tbl(i).alternate_name
                                   ,ap_suppliers_tbl(i).tax_organization_type
                                   ,ap_suppliers_tbl(i).supplier_type
                                   ,ap_suppliers_tbl(i).inactive_date
                                   ,ap_suppliers_tbl(i).business_relationship
                                   ,ap_suppliers_tbl(i).parent_supplier
                                   ,ap_suppliers_tbl(i).alias
                                   ,ap_suppliers_tbl(i).duns_number
                                   ,ap_suppliers_tbl(i).one_time_supplier
                                   ,ap_suppliers_tbl(i).customer_number
                                   ,ap_suppliers_tbl(i).sic
                                   ,ap_suppliers_tbl(i).national_insurance_number
                                   ,ap_suppliers_tbl(i).corporate_web_site
                                   ,ap_suppliers_tbl(i).chief_executive_title
                                   ,ap_suppliers_tbl(i).chif_executive_name
                                   ,ap_suppliers_tbl(i).business_classification
                                   ,ap_suppliers_tbl(i).taxpayer_country
                                   ,ap_suppliers_tbl(i).taxpayer_id
                                   ,ap_suppliers_tbl(i).federal_reportable
                                   ,ap_suppliers_tbl(i).federal_income_tax_type
                                   ,ap_suppliers_tbl(i).state_reportable
                                   ,ap_suppliers_tbl(i).tax_reporting_name
                                   ,ap_suppliers_tbl(i).name_control
                                   ,ap_suppliers_tbl(i).tax_verification_date
                                   ,ap_suppliers_tbl(i).use_withholding_tax
                                   ,ap_suppliers_tbl(i).withholding_tax_group
                                   ,ap_suppliers_tbl(i).supplier_vat_code
                                   ,ap_suppliers_tbl(i).tax_registration_number
                                   ,ap_suppliers_tbl(i).auto_tax_calc_override
                                   ,ap_suppliers_tbl(i).supplier_payment_method
                                   ,ap_suppliers_tbl(i).delivery_channel
                                   ,ap_suppliers_tbl(i).bank_instruction_1
                                   ,ap_suppliers_tbl(i).bank_instruction_2
                                   ,ap_suppliers_tbl(i).bank_instruction
                                   ,ap_suppliers_tbl(i).settlement_priority
                                   ,ap_suppliers_tbl(i).payment_text_message_1
                                   ,ap_suppliers_tbl(i).payment_text_message_2
                                   ,ap_suppliers_tbl(i).payment_text_message_3
                                   ,ap_suppliers_tbl(i).bank_charge_bearer
                                   ,ap_suppliers_tbl(i).payment_reason
                                   ,ap_suppliers_tbl(i).payment_reason_comments
                                   ,ap_suppliers_tbl(i).payment_format
                                   ,ap_suppliers_tbl(i).attribute_category
                                   ,ap_suppliers_tbl(i).attribute1
                                   ,ap_suppliers_tbl(i).attribute2
                                   ,ap_suppliers_tbl(i).attribute3
                                   ,ap_suppliers_tbl(i).attribute4
                                   ,ap_suppliers_tbl(i).attribute5
                                   ,ap_suppliers_tbl(i).attribute6
                                   ,ap_suppliers_tbl(i).attribute7
                                   ,ap_suppliers_tbl(i).attribute8
                                   ,ap_suppliers_tbl(i).attribute9
                                   ,ap_suppliers_tbl(i).attribute10
                                   ,ap_suppliers_tbl(i).attribute11
                                   ,ap_suppliers_tbl(i).attribute12
                                   ,ap_suppliers_tbl(i).attribute13
                                   ,ap_suppliers_tbl(i).attribute14
                                   ,ap_suppliers_tbl(i).attribute15
                                   ,ap_suppliers_tbl(i).attribute16
                                   ,ap_suppliers_tbl(i).attribute17
                                   ,ap_suppliers_tbl(i).attribute18
                                   ,ap_suppliers_tbl(i).attribute19
                                   ,ap_suppliers_tbl(i).attribute20
                                   ,ap_suppliers_tbl(i).attribute_date1
                                   ,ap_suppliers_tbl(i).attribute_date2
                                   ,ap_suppliers_tbl(i).attribute_date3
                                   ,ap_suppliers_tbl(i).attribute_date4
                                   ,ap_suppliers_tbl(i).attribute_date5
                                   ,ap_suppliers_tbl(i).attribute_date6
                                   ,ap_suppliers_tbl(i).attribute_date7
                                   ,ap_suppliers_tbl(i).attribute_date8
                                   ,ap_suppliers_tbl(i).attribute_date9
                                   ,ap_suppliers_tbl(i).attribute_date10
                                   ,ap_suppliers_tbl(i).attribute_timestamp1
                                   ,ap_suppliers_tbl(i).attribute_timestamp2
                                   ,ap_suppliers_tbl(i).attribute_timestamp3
                                   ,ap_suppliers_tbl(i).attribute_timestamp4
                                   ,ap_suppliers_tbl(i).attribute_timestamp5
                                   ,ap_suppliers_tbl(i).attribute_timestamp6
                                   ,ap_suppliers_tbl(i).attribute_timestamp7
                                   ,ap_suppliers_tbl(i).attribute_timestamp8
                                   ,ap_suppliers_tbl(i).attribute_timestamp9
                                   ,ap_suppliers_tbl(i).attribute_timestamp10
                                   ,ap_suppliers_tbl(i).attribute_number1
                                   ,ap_suppliers_tbl(i).attribute_number2
                                   ,ap_suppliers_tbl(i).attribute_number3
                                   ,ap_suppliers_tbl(i).attribute_number4
                                   ,ap_suppliers_tbl(i).attribute_number5
                                   ,ap_suppliers_tbl(i).attribute_number6
                                   ,ap_suppliers_tbl(i).attribute_number7
                                   ,ap_suppliers_tbl(i).attribute_number8
                                   ,ap_suppliers_tbl(i).attribute_number9
                                   ,ap_suppliers_tbl(i).attribute_number10
                                   ,ap_suppliers_tbl(i).global_attribute_category
                                   ,ap_suppliers_tbl(i).global_attribute1
                                   ,ap_suppliers_tbl(i).global_attribute2
                                   ,ap_suppliers_tbl(i).global_attribute3
                                   ,ap_suppliers_tbl(i).global_attribute4
                                   ,ap_suppliers_tbl(i).global_attribute5
                                   ,ap_suppliers_tbl(i).global_attribute6
                                   ,ap_suppliers_tbl(i).global_attribute7
                                   ,ap_suppliers_tbl(i).global_attribute8
                                   ,ap_suppliers_tbl(i).global_attribute9
                                   ,ap_suppliers_tbl(i).global_attribute10
                                   ,ap_suppliers_tbl(i).global_attribute11
                                   ,ap_suppliers_tbl(i).global_attribute12
                                   ,ap_suppliers_tbl(i).global_attribute13
                                   ,ap_suppliers_tbl(i).global_attribute14
                                   ,ap_suppliers_tbl(i).global_attribute15
                                   ,ap_suppliers_tbl(i).global_attribute16
                                   ,ap_suppliers_tbl(i).global_attribute17
                                   ,ap_suppliers_tbl(i).global_attribute18
                                   ,ap_suppliers_tbl(i).global_attribute19
                                   ,ap_suppliers_tbl(i).global_attribute20
                                   ,ap_suppliers_tbl(i).global_attribute_date1
                                   ,ap_suppliers_tbl(i).global_attribute_date2
                                   ,ap_suppliers_tbl(i).global_attribute_date3
                                   ,ap_suppliers_tbl(i).global_attribute_date4
                                   ,ap_suppliers_tbl(i).global_attribute_date5
                                   ,ap_suppliers_tbl(i).global_attribute_date6
                                   ,ap_suppliers_tbl(i).global_attribute_date7
                                   ,ap_suppliers_tbl(i).global_attribute_date8
                                   ,ap_suppliers_tbl(i).global_attribute_date9
                                   ,ap_suppliers_tbl(i).global_attribute_date10
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp1
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp2
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp3
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp4
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp5
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp6
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp7
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp8
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp9
                                   ,ap_suppliers_tbl(i).global_attribute_timestamp10
                                   ,ap_suppliers_tbl(i).global_attribute_number1
                                   ,ap_suppliers_tbl(i).global_attribute_number2
                                   ,ap_suppliers_tbl(i).global_attribute_number3
                                   ,ap_suppliers_tbl(i).global_attribute_number4
                                   ,ap_suppliers_tbl(i).global_attribute_number5
                                   ,ap_suppliers_tbl(i).global_attribute_number6
                                   ,ap_suppliers_tbl(i).global_attribute_number7
                                   ,ap_suppliers_tbl(i).global_attribute_number8
                                   ,ap_suppliers_tbl(i).global_attribute_number9
                                   ,ap_suppliers_tbl(i).global_attribute_number10
                                   ,ap_suppliers_tbl(i).regisrty_id
                                   ,ap_suppliers_tbl(i).service_level_code
                                   ,ap_suppliers_tbl(i).exclusive_payment_flag
                                   ,ap_suppliers_tbl(i).remit_advice_delivery_method
                                   ,ap_suppliers_tbl(i).remit_advice_email
                                   ,ap_suppliers_tbl(i).remit_advice_fax
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_suppliers_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator :='0120';
               --
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
               WHEN OTHERS
               THEN
                    --
                    IF   ap_suppliers_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_suppliers_cur;
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
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
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
     END ap_suppliers_stg;
     --
     --
     /*
     ***************************************
     ** PROCEDURE: ap_supplier_addresses_stg
     ***************************************
     */
     --
     PROCEDURE ap_supplier_addresses_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_addresses_cur
          IS
               --
               WITH
               distinct_party_sites
               AS
                    (
                     SELECT  DISTINCT
                             xssv.vendor_name
                            ,xssv.party_id
                            ,xssv.party_site_id
                     FROM    xxmx_supplier_scope_v  xssv
                    )
              ,contact_points
               AS
                    (
                     SELECT  DISTINCT
                             dps.party_site_id
                           ,(
                             SELECT  cp_phone.phone_country_code
                             FROM    apps.hz_contact_points@MXDM_NVIS_EXTRACT      cp_phone
                             WHERE   1 = 1
                             AND     cp_phone.owner_table_name      = 'HZ_PARTY_SITES'
                             AND     cp_phone.owner_table_id        = dps.party_site_id
                             AND     cp_phone.contact_point_type    = 'PHONE'
                             AND     cp_phone.status                = 'A'
                             AND     cp_phone.primary_flag          = 'Y'
                             AND     ROWNUM                         = 1
                            )                                                      AS phone_country_code
                           ,(
                             SELECT  cp_phone.phone_area_code
                             FROM    apps.hz_contact_points@MXDM_NVIS_EXTRACT      cp_phone
                             WHERE   1 = 1
                             AND     cp_phone.owner_table_name      = 'HZ_PARTY_SITES'
                             AND     cp_phone.owner_table_id        = dps.party_site_id
                             AND     cp_phone.contact_point_type    = 'PHONE'
                             AND     cp_phone.status                = 'A'
                             AND     cp_phone.primary_flag          = 'Y'
                             AND     ROWNUM                         = 1
                            )                                                      AS phone_area_code
                           ,(
                             SELECT  cp_phone.phone_number
                             FROM    apps.hz_contact_points@MXDM_NVIS_EXTRACT      cp_phone
                             WHERE   1 = 1
                             AND     cp_phone.owner_table_name      = 'HZ_PARTY_SITES'
                             AND     cp_phone.owner_table_id        = dps.party_site_id
                             AND     cp_phone.contact_point_type    = 'PHONE'
                             AND     cp_phone.status                = 'A'
                             AND     cp_phone.primary_flag          = 'Y'
                             AND     ROWNUM                         = 1
                            )                                                      AS phone_number
                           ,(
                             SELECT  cp_email.email_address
                             FROM    apps.hz_contact_points@MXDM_NVIS_EXTRACT      cp_email
                             WHERE   1 = 1
                             AND     cp_email.owner_table_name(+)   = 'HZ_PARTY_SITES'
                             AND     cp_email.owner_table_id(+)     = dps.party_site_id
                             AND     cp_email.contact_point_type(+) = 'EMAIL'
                             AND     cp_email.status(+)             = 'A'
                             AND     cp_email.primary_flag(+)       = 'Y'
                             AND     ROWNUM                         = 1
                            )                                                      AS email_address
                           ,(
                             SELECT  cp_fax.telex_number
                             FROM    apps.hz_contact_points@MXDM_NVIS_EXTRACT      cp_fax
                             WHERE   1 = 1
                             AND     cp_fax.owner_table_name(+)     = 'HZ_PARTIES'
                             AND     cp_fax.owner_table_id(+)       = dps.party_site_id
                             AND     cp_fax.contact_point_type(+)   = 'TLX'
                             AND     cp_fax.status(+)               = 'A'
                             AND     cp_fax.primary_flag(+)         = 'Y'
                             AND     ROWNUM                         = 1
                            )                                                      AS telex_number
                     FROM    distinct_party_sites  dps
                    )
               SELECT   'CREATE'                                                                AS import_action
                       ,hl.location_id                                                          AS location_id
                       ,NULL                                                                    AS supplier_site_id
                       ,NULL                                                                    AS party_site_id
                       ,TRIM(dps.vendor_name)                                                   AS supplier_name
                       ,hps.party_site_name                                                     AS address_name
                       ,''                                                                      AS address_name_new
                       ,hl.country                                                              AS country
                       ,hl.address1                                                             AS address1
                       ,hl.address2                                                             AS address2
                       ,hl.address3                                                             AS address3
                       ,hl.address4                                                             AS address4
                       ,hl.address_lines_phonetic                                               AS phonetic_address_line
                       ,''                                                                      AS address_element_attribute_1
                       ,''                                                                      AS address_element_attribute_2
                       ,''                                                                      AS address_element_attribute_3
                       ,''                                                                      AS address_element_attribute_4
                       ,''                                                                      AS address_element_attribute_5
                       ,hl.building                                                             AS building
                       ,hl.floor                                                                AS floor_number
                       ,hl.city                                                                 AS city
                       ,hl.state                                                                AS state
                       ,hl.province                                                             AS province
                       ,hl.county                                                               AS county
                       ,hl.postal_code                                                          AS postal_code
                       ,hl.postal_plus4_code                                                    AS postal_plus_4_code
                       ,(
                         SELECT hps.addressee
                         FROM   apps.hz_party_sites@MXDM_NVIS_EXTRACT hps
                         WHERE  hps.party_site_id = dps.party_site_id
                         AND    hps.addressee    IS NOT NULL
                         AND    ROWNUM            = 1
                        )                                                                       AS addressee
                       ,(
                         SELECT hps.global_location_number
                         FROM   apps.hz_party_sites@MXDM_NVIS_EXTRACT hps
                         WHERE  hps.party_site_id           = dps.party_site_id
                         AND    hps.global_location_number IS NOT NULL
                         AND    ROWNUM                      = 1
                        )                                                                       AS global_location_number
                       ,hl.language                                                             AS language
                       ,hps.end_date_active                                                     AS inactive_date
                       ,cp.phone_country_code                                                   AS phone_country_code -- DH 2021-02-18
                       ,cp.phone_area_code                                                      AS phone_area_code    -- DH 2021-02-18
                       ,cp.phone_number                                                         AS phone              -- DH 2021-02-18
                       ,''                                                                      AS phone_extension
                       ,''                                                                      AS fax_country_code
                       ,''                                                                      AS fax_area_code
                       ,cp.telex_number                                                         AS fax
                       ,NVL(
                            (
                             SELECT DISTINCT 'Y'
                             FROM   apps.ap_supplier_sites_all@mxdm_nvis_extract  assa
                             WHERE  1 = 1
                             AND    assa.party_site_id      = hps.party_site_id
                             AND    assa.rfq_only_site_flag = 'Y'
                            )
                           ,'N'
                           )                                                                    AS rfq_or_bidding
                       ,NVL(
                            (
                             SELECT DISTINCT 'Y'
                             FROM   apps.ap_supplier_sites_all@mxdm_nvis_extract  assa
                             WHERE  1 = 1
                             AND    assa.party_site_id        = hps.party_site_id
                             AND    assa.purchasing_site_flag = 'Y'
                            )
                           ,'N'
                           )                                                                    AS ordering
                       ,NVL(
                            (
                             SELECT DISTINCT 'Y'
                             FROM   apps.ap_supplier_sites_all@mxdm_nvis_extract  assa
                             WHERE  1 = 1
                             AND    assa.party_site_id = hps.party_site_id
                             AND    assa.pay_site_flag = 'Y'
                            )
                           ,'N'
                           )                                                                    AS pay
                       ,NULL                                                                    AS attribute_category
                       ,NULL                                                                    AS attribute1
                       ,NULL                                                                    AS attribute2
                       ,NULL                                                                    AS attribute3
                       ,NULL                                                                    AS attribute4
                       ,NULL                                                                    AS attribute5
                       ,NULL                                                                    AS attribute6
                       ,NULL                                                                    AS attribute7
                       ,NULL                                                                    AS attribute8
                       ,NULL                                                                    AS attribute9
                       ,NULL                                                                    AS attribute10
                       ,NULL                                                                    AS attribute11
                       ,NULL                                                                    AS attribute12
                       ,NULL                                                                    AS attribute13
                       ,NULL                                                                    AS attribute14
                       ,NULL                                                                    AS attribute15
                       ,NULL                                                                    AS attribute16
                       ,NULL                                                                    AS attribute17
                       ,NULL                                                                    AS attribute18
                       ,NULL                                                                    AS attribute19
                       ,NULL                                                                    AS attribute20
                       ,NULL                                                                    AS attribute21
                       ,NULL                                                                    AS attribute22
                       ,NULL                                                                    AS attribute23
                       ,NULL                                                                    AS attribute24
                       ,NULL                                                                    AS attribute25
                       ,NULL                                                                    AS attribute26
                       ,NULL                                                                    AS attribute27
                       ,NULL                                                                    AS attribute28
                       ,NULL                                                                    AS attribute29
                       ,NULL                                                                    AS attribute30
                       ,NULL                                                                    AS attribute_number1
                       ,NULL                                                                    AS attribute_number2
                       ,NULL                                                                    AS attribute_number3
                       ,NULL                                                                    AS attribute_number4
                       ,NULL                                                                    AS attribute_number5
                       ,NULL                                                                    AS attribute_number6
                       ,NULL                                                                    AS attribute_number7
                       ,NULL                                                                    AS attribute_number8
                       ,NULL                                                                    AS attribute_number9
                       ,NULL                                                                    AS attribute_number10
                       ,NULL                                                                    AS attribute_number11
                       ,NULL                                                                    AS attribute_number12
                       ,NULL                                                                    AS attribute_date1
                       ,NULL                                                                    AS attribute_date2
                       ,NULL                                                                    AS attribute_date3
                       ,NULL                                                                    AS attribute_date4
                       ,NULL                                                                    AS attribute_date5
                       ,NULL                                                                    AS attribute_date6
                       ,NULL                                                                    AS attribute_date7
                       ,NULL                                                                    AS attribute_date8
                       ,NULL                                                                    AS attribute_date9
                       ,NULL                                                                    AS attribute_date10
                       ,NULL                                                                    AS attribute_date11
                       ,NULL                                                                    AS attribute_date12
                       ,cp.email_address                                                        AS email_address
                       ,''                                                                      AS delivery_channel
                       ,''                                                                      AS bank_instruction_1
                       ,''                                                                      AS bank_instruction_2
                       ,''                                                                      AS bank_instruction
                       ,''                                                                      AS settlement_priority
                       ,''                                                                      AS payment_text_message_1
                       ,''                                                                      AS payment_text_message_2
                       ,''                                                                      AS payment_text_message_3
                       ,''                                                                      AS payee_service_level
                       ,''                                                                      AS pay_each_document_alone
                       ,''                                                                      AS bank_charge_bearer
                       ,''                                                                      AS payment_reason
                       ,''                                                                      AS payment_reason_comments
                       ,''                                                                      AS delivery_method
                       ,''                                                                      AS remittance_email
                       ,''                                                                      AS remittance_fax
               FROM    distinct_party_sites                   dps
                      ,apps.hz_party_sites@MXDM_NVIS_EXTRACT  hps   -- Join to HZ_PARTIES to get DISTINCT Addresses
                      ,apps.hz_locations@MXDM_NVIS_EXTRACT    hl
                      ,contact_points                         cp
               WHERE   1 = 1
               AND     hps.party_id                   = dps.party_id
               AND     hps.party_site_id              = dps.party_site_id
               AND     hl.location_id                 = hps.location_id
               AND     cp.party_site_id               = hps.party_site_id;
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_addresses_tt IS TABLE OF ap_supplier_addresses_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName                CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_addresses_stg';
          ct_StgSchema                     CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                      CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_addrs_stg';
          ct_Phase                         CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          ap_supplier_addresses_tbl    ap_supplier_addresses_tt;
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supplier_addresses_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_supplier_addresses_cur
                    BULK COLLECT
                    INTO ap_supplier_addresses_tbl
                    LIMIT XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supplier_addresses_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..ap_supplier_addresses_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_addrs_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,location_id
                                   ,supplier_site_id
                                   ,party_site_id
                                   ,import_action
                                   ,supplier_name
                                   ,address_name
                                   ,address_name_new
                                   ,country
                                   ,address1
                                   ,address2
                                   ,address3
                                   ,address4
                                   ,phonetic_address_line
                                   ,address_element_attribute_1
                                   ,address_element_attribute_2
                                   ,address_element_attribute_3
                                   ,address_element_attribute_4
                                   ,address_element_attribute_5
                                   ,building
                                   ,floor_number
                                   ,city
                                   ,state
                                   ,province
                                   ,county
                                   ,postal_code
                                   ,postal_plus_4_code
                                   ,addressee
                                   ,global_location_number
                                   ,language
                                   ,inactive_date
                                   ,phone_country_code
                                   ,phone_area_code
                                   ,phone
                                   ,phone_extension
                                   ,fax_country_code
                                   ,fax_area_code
                                   ,fax
                                   ,rfq_or_bidding
                                   ,ordering
                                   ,pay
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
                                   ,attribute16
                                   ,attribute17
                                   ,attribute18
                                   ,attribute19
                                   ,attribute20
                                   ,attribute21
                                   ,attribute22
                                   ,attribute23
                                   ,attribute24
                                   ,attribute25
                                   ,attribute26
                                   ,attribute27
                                   ,attribute28
                                   ,attribute29
                                   ,attribute30
                                   ,attribute_number1
                                   ,attribute_number2
                                   ,attribute_number3
                                   ,attribute_number4
                                   ,attribute_number5
                                   ,attribute_number6
                                   ,attribute_number7
                                   ,attribute_number8
                                   ,attribute_number9
                                   ,attribute_number10
                                   ,attribute_number11
                                   ,attribute_number12
                                   ,attribute_date1
                                   ,attribute_date2
                                   ,attribute_date3
                                   ,attribute_date4
                                   ,attribute_date5
                                   ,attribute_date6
                                   ,attribute_date7
                                   ,attribute_date8
                                   ,attribute_date9
                                   ,attribute_date10
                                   ,attribute_date11
                                   ,attribute_date12
                                   ,email_address
                                   ,delivery_channel
                                   ,bank_instruction_1
                                   ,bank_instruction_2
                                   ,bank_instruction
                                   ,settlement_priority
                                   ,payment_text_message_1
                                   ,payment_text_message_2
                                   ,payment_text_message_3
                                   ,payee_service_level
                                   ,pay_each_document_alone
                                   ,bank_charge_bearer
                                   ,payment_reason
                                   ,payment_reason_comments
                                   ,delivery_method
                                   ,remittance_e_mail
                                   ,remittance_fax
                                   )
                         VALUES    (
                                    pt_i_MigrationSetID                                        -- migration_set_id
                                   ,gvt_MigrationSetName                                       -- migration_set_name
                                   ,'EXTRACTED'                                                -- migration_status
                                   ,ap_supplier_addresses_tbl(i).location_id                   -- location_id
                                   ,ap_supplier_addresses_tbl(i).supplier_site_id              -- supplier_site_id
                                   ,ap_supplier_addresses_tbl(i).party_site_id                 -- party_site_id
                                   ,ap_supplier_addresses_tbl(i).import_action                 -- import_action
                                   ,ap_supplier_addresses_tbl(i).supplier_name                 -- supplier_name
                                   ,ap_supplier_addresses_tbl(i).address_name                  -- address_name
                                   ,ap_supplier_addresses_tbl(i).address_name_new              -- address_name_new
                                   ,ap_supplier_addresses_tbl(i).country                       -- country
                                   ,ap_supplier_addresses_tbl(i).address1                      -- address1
                                   ,ap_supplier_addresses_tbl(i).address2                      -- address2
                                   ,ap_supplier_addresses_tbl(i).address3                      -- address3
                                   ,ap_supplier_addresses_tbl(i).address4                      -- address4
                                   ,ap_supplier_addresses_tbl(i).phonetic_address_line         -- phonetic_address_line
                                   ,ap_supplier_addresses_tbl(i).address_element_attribute_1   -- address_element_attribute_1
                                   ,ap_supplier_addresses_tbl(i).address_element_attribute_2   -- address_element_attribute_2
                                   ,ap_supplier_addresses_tbl(i).address_element_attribute_3   -- address_element_attribute_3
                                   ,ap_supplier_addresses_tbl(i).address_element_attribute_4   -- address_element_attribute_4
                                   ,ap_supplier_addresses_tbl(i).address_element_attribute_5   -- address_element_attribute_5
                                   ,ap_supplier_addresses_tbl(i).building                      -- building
                                   ,ap_supplier_addresses_tbl(i).floor_number                  -- floor_number
                                   ,ap_supplier_addresses_tbl(i).city                          -- city
                                   ,ap_supplier_addresses_tbl(i).state                         -- state
                                   ,ap_supplier_addresses_tbl(i).province                      -- province
                                   ,ap_supplier_addresses_tbl(i).county                        -- county
                                   ,ap_supplier_addresses_tbl(i).postal_code                   -- postal_code
                                   ,ap_supplier_addresses_tbl(i).postal_plus_4_code            -- postal_plus_4_code
                                   ,ap_supplier_addresses_tbl(i).addressee                     -- addressee
                                   ,ap_supplier_addresses_tbl(i).global_location_number        -- global_location_number
                                   ,ap_supplier_addresses_tbl(i).language                      -- language
                                   ,ap_supplier_addresses_tbl(i).inactive_date                 -- inactive_date
                                   ,ap_supplier_addresses_tbl(i).phone_country_code            -- phone_country_code
                                   ,ap_supplier_addresses_tbl(i).phone_area_code               -- phone_area_code
                                   ,ap_supplier_addresses_tbl(i).phone                         -- phone
                                   ,ap_supplier_addresses_tbl(i).phone_extension               -- phone_extension
                                   ,ap_supplier_addresses_tbl(i).fax_country_code              -- fax_country_code
                                   ,ap_supplier_addresses_tbl(i).fax_area_code                 -- fax_area_code
                                   ,ap_supplier_addresses_tbl(i).fax                           -- fax
                                   ,ap_supplier_addresses_tbl(i).rfq_or_bidding                -- rfq_or_bidding
                                   ,ap_supplier_addresses_tbl(i).ordering                      -- ordering
                                   ,ap_supplier_addresses_tbl(i).pay                           -- pay
                                   ,ap_supplier_addresses_tbl(i).attribute_category            -- attribute_category
                                   ,ap_supplier_addresses_tbl(i).attribute1                    -- attribute1
                                   ,ap_supplier_addresses_tbl(i).attribute2                    -- attribute2
                                   ,ap_supplier_addresses_tbl(i).attribute3                    -- attribute3
                                   ,ap_supplier_addresses_tbl(i).attribute4                    -- attribute4
                                   ,ap_supplier_addresses_tbl(i).attribute5                    -- attribute5
                                   ,ap_supplier_addresses_tbl(i).attribute6                    -- attribute6
                                   ,ap_supplier_addresses_tbl(i).attribute7                    -- attribute7
                                   ,ap_supplier_addresses_tbl(i).attribute8                    -- attribute8
                                   ,ap_supplier_addresses_tbl(i).attribute9                    -- attribute9
                                   ,ap_supplier_addresses_tbl(i).attribute10                   -- attribute10
                                   ,ap_supplier_addresses_tbl(i).attribute11                   -- attribute11
                                   ,ap_supplier_addresses_tbl(i).attribute12                   -- attribute12
                                   ,ap_supplier_addresses_tbl(i).attribute13                   -- attribute13
                                   ,ap_supplier_addresses_tbl(i).attribute14                   -- attribute14
                                   ,ap_supplier_addresses_tbl(i).attribute15                   -- attribute15
                                   ,ap_supplier_addresses_tbl(i).attribute16                   -- attribute16
                                   ,ap_supplier_addresses_tbl(i).attribute17                   -- attribute17
                                   ,ap_supplier_addresses_tbl(i).attribute18                   -- attribute18
                                   ,ap_supplier_addresses_tbl(i).attribute19                   -- attribute19
                                   ,ap_supplier_addresses_tbl(i).attribute20                   -- attribute20
                                   ,ap_supplier_addresses_tbl(i).attribute21                   -- attribute21
                                   ,ap_supplier_addresses_tbl(i).attribute22                   -- attribute22
                                   ,ap_supplier_addresses_tbl(i).attribute23                   -- attribute23
                                   ,ap_supplier_addresses_tbl(i).attribute24                   -- attribute24
                                   ,ap_supplier_addresses_tbl(i).attribute25                   -- attribute25
                                   ,ap_supplier_addresses_tbl(i).attribute26                   -- attribute26
                                   ,ap_supplier_addresses_tbl(i).attribute27                   -- attribute27
                                   ,ap_supplier_addresses_tbl(i).attribute28                   -- attribute28
                                   ,ap_supplier_addresses_tbl(i).attribute29                   -- attribute29
                                   ,ap_supplier_addresses_tbl(i).attribute30                   -- attribute30
                                   ,ap_supplier_addresses_tbl(i).attribute_number1             -- attribute_number1
                                   ,ap_supplier_addresses_tbl(i).attribute_number2             -- attribute_number2
                                   ,ap_supplier_addresses_tbl(i).attribute_number3             -- attribute_number3
                                   ,ap_supplier_addresses_tbl(i).attribute_number4             -- attribute_number4
                                   ,ap_supplier_addresses_tbl(i).attribute_number5             -- attribute_number5
                                   ,ap_supplier_addresses_tbl(i).attribute_number6             -- attribute_number6
                                   ,ap_supplier_addresses_tbl(i).attribute_number7             -- attribute_number7
                                   ,ap_supplier_addresses_tbl(i).attribute_number8             -- attribute_number8
                                   ,ap_supplier_addresses_tbl(i).attribute_number9             -- attribute_number9
                                   ,ap_supplier_addresses_tbl(i).attribute_number10            -- attribute_number10
                                   ,ap_supplier_addresses_tbl(i).attribute_number11            -- attribute_number11
                                   ,ap_supplier_addresses_tbl(i).attribute_number12            -- attribute_number12
                                   ,ap_supplier_addresses_tbl(i).attribute_date1               -- attribute_date1
                                   ,ap_supplier_addresses_tbl(i).attribute_date2               -- attribute_date2
                                   ,ap_supplier_addresses_tbl(i).attribute_date3               -- attribute_date3
                                   ,ap_supplier_addresses_tbl(i).attribute_date4               -- attribute_date4
                                   ,ap_supplier_addresses_tbl(i).attribute_date5               -- attribute_date5
                                   ,ap_supplier_addresses_tbl(i).attribute_date6               -- attribute_date6
                                   ,ap_supplier_addresses_tbl(i).attribute_date7               -- attribute_date7
                                   ,ap_supplier_addresses_tbl(i).attribute_date8               -- attribute_date8
                                   ,ap_supplier_addresses_tbl(i).attribute_date9               -- attribute_date9
                                   ,ap_supplier_addresses_tbl(i).attribute_date10              -- attribute_date10
                                   ,ap_supplier_addresses_tbl(i).attribute_date11              -- attribute_date11
                                   ,ap_supplier_addresses_tbl(i).attribute_date12              -- attribute_date12
                                   ,ap_supplier_addresses_tbl(i).email_address                 -- email_address
                                   ,ap_supplier_addresses_tbl(i).delivery_channel              -- delivery_channel
                                   ,ap_supplier_addresses_tbl(i).bank_instruction_1            -- bank_instruction_1
                                   ,ap_supplier_addresses_tbl(i).bank_instruction_2            -- bank_instruction_2
                                   ,ap_supplier_addresses_tbl(i).bank_instruction              -- bank_instruction
                                   ,ap_supplier_addresses_tbl(i).settlement_priority           -- settlement_priority
                                   ,ap_supplier_addresses_tbl(i).payment_text_message_1        -- payment_text_message_1
                                   ,ap_supplier_addresses_tbl(i).payment_text_message_2        -- payment_text_message_2
                                   ,ap_supplier_addresses_tbl(i).payment_text_message_3        -- payment_text_message_3
                                   ,ap_supplier_addresses_tbl(i).payee_service_level           -- payee_service_level
                                   ,ap_supplier_addresses_tbl(i).pay_each_document_alone       -- pay_each_document_alone
                                   ,ap_supplier_addresses_tbl(i).bank_charge_bearer            -- bank_charge_bearer
                                   ,ap_supplier_addresses_tbl(i).payment_reason                -- payment_reason
                                   ,ap_supplier_addresses_tbl(i).payment_reason_comments       -- payment_reason_comments
                                   ,ap_supplier_addresses_tbl(i).delivery_method               -- delivery_method
                                   ,ap_supplier_addresses_tbl(i).remittance_email              -- remittance_e_mail
                                   ,ap_supplier_addresses_tbl(i).remittance_fax                -- remittance_fax
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_addresses_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
               WHEN OTHERS
               THEN
                    --
                    IF   ap_supplier_addresses_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_addresses_cur;
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
     END ap_supplier_addresses_stg;
     --
     --
     /*
     ***********************************
     ** PROCEDURE: ap_supplier_sites_stg
     ***********************************
     */
     --
     PROCEDURE ap_supplier_sites_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_sites_cur
          IS
               --
               --
               WITH
               defaults_from_supplier
               AS
                      (
                       SELECT aps.vendor_id                                           AS vendor_id
                             ,aps.hold_flag                                           AS hold_flag
                             ,aps.purchasing_hold_reason                              AS purchasing_hold_reason
                             ,aps.enforce_ship_to_location_code                       AS enforce_ship_to_location_code
                             ,aps.receiving_routing_id                                AS receiving_routing_id
                             ,aps.qty_rcv_tolerance                                   AS qty_rcv_tolerance
                             ,aps.qty_rcv_exception_code                              AS qty_rcv_exception_code
                             ,aps.days_early_receipt_allowed                          AS days_early_receipt_allowed
                             ,aps.days_late_receipt_allowed                           AS days_late_receipt_allowed
                             ,aps.allow_substitute_receipts_flag                      AS allow_substitute_receipts_flag
                             ,aps.allow_unordered_receipts_flag                       AS allow_unordered_receipts_flag
                             ,aps.receipt_days_exception_code                         AS receipt_days_exception_code
                             ,aps.hold_future_payments_flag                           AS hold_future_payments_flag
                             ,aps.hold_by                                             AS hold_by
                             ,aps.hold_date                                           AS hold_date
                             ,CASE
                                   WHEN NVL(aps.receipt_required_flag, 'N')    = 'Y'
                                   AND  NVL(aps.inspection_required_flag, 'N') = 'Y'
                                        THEN '4'
                                   WHEN NVL(aps.receipt_required_flag, 'N')    = 'Y'
                                   AND  NVL(aps.inspection_required_flag, 'N') = 'N'
                                        THEN '3'
                                   ELSE '2'
                              END                                                     AS match_approval_level
                             ,aps.auto_calculate_interest_flag                        AS auto_calculate_interest_flag
                             ,aps.exclusive_payment_flag                              AS exclusive_payment_flag
                       FROM   ap_suppliers@MXDM_NVIS_EXTRACT  aps
                      )
               SELECT  DISTINCT
                       'CREATE'                                                                 AS import_action
                      ,xssv.vendor_id                                                           AS supplier_id
                      ,xssv.vendor_name                                                         AS supplier_name
                      ,xssv.operating_unit_name                                                 AS operating_unit_name
                      ,hps.party_site_id                                                        AS party_site_id
                      ,hps.party_site_name                                                      AS address_name
                      ,assa.vendor_site_id                                                      AS supplier_site_id
--                      ,assa.vendor_site_code                                                    AS supplier_site
                      ,decode(assa.org_id,142,substr(assa.vendor_site_id||'-'||assa.vendor_site_code,1,15),
                                                    assa.vendor_site_code)                           AS supplier_site                      
                      ,''                                                                       AS supplier_site_new
                      ,assa.inactive_date                                                       AS inactive_date
                      ,assa.rfq_only_site_flag                                                  AS sourcing_only
                      ,assa.purchasing_site_flag                                                AS purchasing
                      ,assa.pcard_site_flag                                                     AS procurement_card
                      ,assa.pay_site_flag                                                       AS pay_site_flag
                      ,assa.primary_pay_site_flag                                               AS primary_pay
/*
                      ,DECODE(
                              ROW_NUMBER() OVER (
                                                 PARTITION BY TRIM(xssv.vendor_name)
                                                 ORDER BY     TRIM(assa.vendor_site_code) DESC
                                                )
                             ,1 ,'Y'
                             ,NULL
                             )                                                                  AS primary_pay
*/
                      ,assa.tax_reporting_site_flag                                             AS income_tax_reporting_site
                      ,assa.vendor_site_code_alt                                                AS alternate_site_name
                      ,''                                                                       AS customer_number
                      ,''                                                                       AS b2b_communication_method
                      ,''                                                                       AS b2b_supplier_site_code
                      ,CASE
                            WHEN assa.email_address IS NOT NULL
                            AND  assa.fax           IS NOT NULL
                                 THEN assa.supplier_notif_method
                            ELSE NULL
                       END                                                                      AS communication_method
                      ,CASE
                            WHEN assa.supplier_notif_method = 'EMAIL'
                                 THEN assa.email_address
                            ELSE NULL
                       END                                                                      AS email
                      ,''                                                                       AS fax_country_code
                      ,CASE
                            WHEN assa.supplier_notif_method = 'FAX'
                                 THEN assa.fax_area_code
                            ELSE NULL
                       END                                                                      AS fax_area_code
                      ,CASE
                            WHEN assa.supplier_notif_method = 'FAX'
                                 THEN assa.fax
                            ELSE NULL
                       END                                                                      AS fax
                      ,dfs.hold_flag                                                            AS hold_purchasing_documents
                      ,dfs.purchasing_hold_reason                                               AS hold_reason
                      ,(
                        SELECT wcv.carrier_name
                        FROM   apps.wsh_carriers_v@MXDM_NVIS_EXTRACT wcv
                        WHERE  1 = 1
                        AND    wcv.supplier_id      = assa.vendor_id
                        AND    wcv.supplier_site_id = assa.vendor_site_id
                        AND    ROWNUM               = 1
                       )                                                                        AS carrier
                      ,(
                        SELECT  wcs.mode_of_transport
                        FROM    apps.wsh_carriers_v@MXDM_NVIS_EXTRACT       wcv
                               ,apps.wsh_carrier_services@MXDM_NVIS_EXTRACT wcs
                        WHERE   1 = 1
                        AND     wcv.carrier_id       = wcs.carrier_id
                        AND     wcv.supplier_id      = assa.vendor_id
                        AND     wcv.supplier_site_id = assa.vendor_site_id
                        AND     ROWNUM               = 1
                       )                                                                        AS mode_of_transport
                      ,(
                        SELECT segment1
                        FROM   apps.pos_sup_products_services@MXDM_NVIS_EXTRACT psps
                        WHERE  1 = 1
                        AND    psps.vendor_id = xssv.vendor_id
                        AND    ROWNUM         = 1
                       )                                                                        AS service_level
                      ,assa.freight_terms_lookup_code                                           AS freight_terms
                      ,CASE
                            WHEN assa.pay_on_code IS NOT NULL
                                 THEN 'Y'
                            ELSE NULL
                       END                                                                      AS pay_on_receipt
                      ,assa.fob_lookup_code                                                     AS fob
                      ,assa.country_of_origin_code                                              AS country_of_origin
                      ,''                                                                       AS buyer_managed_transportation
                      ,''                                                                       AS pay_on_use
                      ,''                                                                       AS aging_onset_point
                      ,''                                                                       AS aging_period_days
                      ,''                                                                       AS consumption_advice_frequency
                      ,''                                                                       AS consumption_advice_summary
                      ,''                                                                       AS default_pay_site
                      ,CASE
                            WHEN assa.pay_on_code IS NOT NULL
                                 THEN assa.pay_on_receipt_summary_code
                            ELSE NULL
                       END                                                                      AS invoice_summary_level
                      ,assa.gapless_inv_num_flag                                                AS gapless_invoice_numbering
                      ,assa.selling_company_identifier                                          AS selling_company_identifier
                      ,assa.create_debit_memo_flag                                              AS create_debit_memo_from_return
                      ,dfs.enforce_ship_to_location_code                                        AS ship_to_exception_action
                      ,dfs.receiving_routing_id                                                 AS receipt_routing
                      ,dfs.qty_rcv_tolerance                                                    AS over_receipt_tolerance
                      ,dfs.qty_rcv_exception_code                                               AS over_receipt_action
                      ,dfs.days_early_receipt_allowed                                           AS early_receipt_tolerance
                      ,dfs.days_late_receipt_allowed                                            AS late_receipt_tolerance
                      ,dfs.allow_substitute_receipts_flag                                       AS allow_substitute_receipts
                      ,dfs.allow_unordered_receipts_flag                                        AS allow_unordered_receipts
                      ,dfs.receipt_days_exception_code                                          AS receipt_date_exception
                      ,assa.invoice_currency_code                                               AS invoice_currency
                      ,assa.invoice_amount_limit                                                AS invoice_amount_limit
                      ,assa.match_option                                                        AS invoice_match_option
                      ,dfs.match_approval_level                                                 AS match_approval_level
                      ,assa.payment_currency_code                                               AS payment_currency
                      ,assa.payment_priority                                                    AS payment_priority
                      ,assa.pay_group_lookup_code                                               AS pay_group
                      ,(
                        SELECT att2.tolerance_name
                        FROM   apps.ap_tolerance_templates@MXDM_NVIS_EXTRACT att2
                        WHERE  1 = 1
                        AND    att2.tolerance_id = assa.tolerance_id
                       )                                                                        AS quantity_tolerances
                      ,''                                                                       AS amount_tolerance
                      ,assa.hold_all_payments_flag                                              AS hold_all_invoices
                      ,assa.hold_unmatched_invoices_flag                                        AS hold_unmatched_invoices
                      ,dfs.hold_future_payments_flag                                            AS hold_unvalidated_invoices
                      ,dfs.hold_by                                                              AS payment_hold_by
                      ,dfs.hold_date                                                            AS payment_hold_date
                      ,assa.hold_reason                                                         AS payment_hold_reason
                      ,att.name                                                                 AS payment_terms
                      ,assa.terms_date_basis                                                    AS terms_date_basis
                      ,assa.pay_date_basis_lookup_code                                          AS pay_date_basis
                      ,''                                                                       AS bank_charge_deduction_type
                      ,assa.always_take_disc_flag                                               AS always_take_discount
                      ,assa.exclude_freight_from_discount                                       AS exclude_freight_from_discount
                      ,''                                                                       AS exclude_tax_from_discount
                      ,dfs.auto_calculate_interest_flag                                         AS create_interest_invoices
                      ,assa.vat_code                                                            AS vat_code
                      ,assa.vat_registration_num                                                AS tax_registration_number
                      ,assa.payment_method_lookup_code                                          AS payment_method
                      ,NULL                                                                     AS delivery_channel  
                      ,NULL                                                                     AS bank_instruction_1
                      ,NULL                                                                     AS bank_instruction_2
                      ,NULL                                                                     AS bank_instruction
                      ,NULL                                                                     AS settlement_priority
                      ,NULL                                                                     AS payment_text_message_1
                      ,NULL                                                                     AS payment_text_message_2
                      ,NULL                                                                     AS payment_text_message_3
                      ,NULL                                                                     AS bank_charge_bearer
                      ,NULL                                                                     AS payment_reason
                      ,NULL                                                                     AS payment_reason_comments
                      ,NULL                                                                     AS delivery_method
                      ,NULL                                                                     AS remittance_e_mail
                      ,NULL                                                                     AS remittance_fax
                      ,NULL                                                                     AS attribute_category
                      ,NULL                                                                     AS attribute1
                      ,NULL                                                                     AS attribute2
                      ,NULL                                                                     AS attribute3
                      ,NULL                                                                     AS attribute4
                      ,NULL                                                                     AS attribute5
                      ,NULL                                                                     AS attribute6
                      ,NULL                                                                     AS attribute7
                      ,NULL                                                                     AS attribute8
                      ,NULL                                                                     AS attribute9
                      ,NULL                                                                     AS attribute10
                      ,NULL                                                                     AS attribute11
                      ,NULL                                                                     AS attribute12
                      ,NULL                                                                     AS attribute13
                      ,NULL                                                                     AS attribute14
                      ,NULL                                                                     AS attribute15
                      ,NULL                                                                     AS attribute16
                      ,NULL                                                                     AS attribute17
                      ,NULL                                                                     AS attribute18
                      ,NULL                                                                     AS attribute19
                      ,NULL                                                                     AS attribute20
                      ,NULL                                                                     AS attribute_date1
                      ,NULL                                                                     AS attribute_date2
                      ,NULL                                                                     AS attribute_date3
                      ,NULL                                                                     AS attribute_date4
                      ,NULL                                                                     AS attribute_date5
                      ,NULL                                                                     AS attribute_date6
                      ,NULL                                                                     AS attribute_date7
                      ,NULL                                                                     AS attribute_date8
                      ,NULL                                                                     AS attribute_date9
                      ,NULL                                                                     AS attribute_date10
                      ,NULL                                                                     AS attribute_timestamp1
                      ,NULL                                                                     AS attribute_timestamp2
                      ,NULL                                                                     AS attribute_timestamp3
                      ,NULL                                                                     AS attribute_timestamp4
                      ,NULL                                                                     AS attribute_timestamp5
                      ,NULL                                                                     AS attribute_timestamp6
                      ,NULL                                                                     AS attribute_timestamp7
                      ,NULL                                                                     AS attribute_timestamp8
                      ,NULL                                                                     AS attribute_timestamp9
                      ,NULL                                                                     AS attribute_timestamp10
                      ,NULL                                                                     AS attribute_number1
                      ,NULL                                                                     AS attribute_number2
                      ,NULL                                                                     AS attribute_number3
                      ,NULL                                                                     AS attribute_number4
                      ,NULL                                                                     AS attribute_number5
                      ,NULL                                                                     AS attribute_number6
                      ,NULL                                                                     AS attribute_number7
                      ,NULL                                                                     AS attribute_number8
                      ,NULL                                                                     AS attribute_number9
                      ,NULL                                                                     AS attribute_number10
                      ,NULL                                                                     AS global_attribute_category
                      ,NULL                                                                     AS global_attribute1
                      ,NULL                                                                     AS global_attribute2
                      ,NULL                                                                     AS global_attribute3
                      ,NULL                                                                     AS global_attribute4
                      ,NULL                                                                     AS global_attribute5
                      ,NULL                                                                     AS global_attribute6
                      ,NULL                                                                     AS global_attribute7
                      ,NULL                                                                     AS global_attribute8
                      ,NULL                                                                     AS global_attribute9
                      ,NULL                                                                     AS global_attribute10
                      ,NULL                                                                     AS global_attribute11
                      ,NULL                                                                     AS global_attribute12
                      ,NULL                                                                     AS global_attribute13
                      ,NULL                                                                     AS global_attribute14
                      ,NULL                                                                     AS global_attribute15
                      ,NULL                                                                     AS global_attribute16
                      ,NULL                                                                     AS global_attribute17
                      ,NULL                                                                     AS global_attribute18
                      ,NULL                                                                     AS global_attribute19
                      ,NULL                                                                     AS global_attribute20
                      ,NULL                                                                     AS global_attribute_date1
                      ,NULL                                                                     AS global_attribute_date2
                      ,NULL                                                                     AS global_attribute_date3
                      ,NULL                                                                     AS global_attribute_date4
                      ,NULL                                                                     AS global_attribute_date5
                      ,NULL                                                                     AS global_attribute_date6
                      ,NULL                                                                     AS global_attribute_date7
                      ,NULL                                                                     AS global_attribute_date8
                      ,NULL                                                                     AS global_attribute_date9
                      ,NULL                                                                     AS global_attribute_date10
                      ,NULL                                                                     AS global_attribute_timestamp1
                      ,NULL                                                                     AS global_attribute_timestamp2
                      ,NULL                                                                     AS global_attribute_timestamp3
                      ,NULL                                                                     AS global_attribute_timestamp4
                      ,NULL                                                                     AS global_attribute_timestamp5
                      ,NULL                                                                     AS global_attribute_timestamp6
                      ,NULL                                                                     AS global_attribute_timestamp7
                      ,NULL                                                                     AS global_attribute_timestamp8
                      ,NULL                                                                     AS global_attribute_timestamp9
                      ,NULL                                                                     AS global_attribute_timestamp10
                      ,NULL                                                                     AS global_attribute_number1
                      ,NULL                                                                     AS global_attribute_number2
                      ,NULL                                                                     AS global_attribute_number3
                      ,NULL                                                                     AS global_attribute_number4
                      ,NULL                                                                     AS global_attribute_number5
                      ,NULL                                                                     AS global_attribute_number6
                      ,NULL                                                                     AS global_attribute_number7
                      ,NULL                                                                     AS global_attribute_number8
                      ,NULL                                                                     AS global_attribute_number9
                      ,NULL                                                                     AS global_attribute_number10
                      ,''                                                                       AS required_acknowledgement
                      ,''                                                                       AS acknowledge_within_days
                      ,''                                                                       AS invoice_channel
                      ,NULL                                                                     AS payee_service_level_code
                      ,dfs.exclusive_payment_flag                                               AS exclusive_payment_flag
               FROM    xxmx_supplier_scope_v                              xssv
                      ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT       assa
                      ,apps.hz_party_sites@MXDM_NVIS_EXTRACT              hps
                      ,apps.ap_terms_tl@MXDM_NVIS_EXTRACT                 att
                      ,apps.hz_locations@MXDM_NVIS_EXTRACT                hl
                      ,defaults_from_supplier                             dfs
               WHERE   1=1
               ANd     assa.vendor_id            = xssv.vendor_id
               AND     assa.org_id               = xssv.org_id
               AND     assa.vendor_site_id       = xssv.vendor_site_id
               AND     hps.party_site_id         = assa.party_site_id
               AND     att.term_id(+)            = assa.terms_id
               AND     att.LANGUAGE(+)           = 'US'
               AND     hl.location_id            = hps.location_id
               AND     dfs.vendor_id(+)          = assa.vendor_id;
               --
          --** END CURSOR **
          --
          CURSOR UpdR12PayeeDetails_cur
                      (
                       pt_MigrationSetID               xxmx_ap_supplier_sites_stg.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  xasss.procurement_bu
                      ,xasss.supplier_site_id
                      ,iepa.delivery_channel_code                           AS delivery_channel
                      ,iepa.bank_instruction1_code                          AS bank_instruction_1
                      ,iepa.bank_instruction2_code                          AS bank_instruction_2
                      ,iepa.bank_instruction_details                        AS bank_instruction
                      ,iepa.settlement_priority                             AS settlement_priority
                      ,iepa.payment_text_message1                           AS payment_text_message_1
                      ,iepa.payment_text_message2                           AS payment_text_message_2
                      ,iepa.payment_text_message3                           AS payment_text_message_3
                      ,iepa.bank_charge_bearer                              AS bank_charge_bearer
                      ,iepa.payment_reason_code                             AS payment_reason
                      ,iepa.payment_reason_comments                         AS payment_reason_comments
                      ,iepa.remit_advice_delivery_method                    AS delivery_method
                      ,iepa.remit_advice_email                              AS remittance_e_mail
                      ,iepa.remit_advice_fax                                AS remittance_fax
                      ,iepa.service_level_code                              AS payee_service_level_code
               FROM     xxmx_ap_supplier_sites_stg               xasss
                      ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  haou
                      ,apps.iby_external_payees_all@MXDM_NVIS_EXTRACT    iepa
               WHERE   1 = 1
               AND     xasss.migration_set_id  = pt_MigrationSetID
               AND     haou.name               = xasss.procurement_bu
               AND     iepa.org_id             = haou.organization_id
               AND     iepa.supplier_site_id   = xasss.supplier_site_id
               AND     iepa.inactive_date IS NULL;
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_sites_tt IS TABLE OF ap_supplier_sites_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName                CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_sites_stg';
          ct_StgSchema                     CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                      CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supplier_sites_stg';
          ct_Phase                         CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          ap_supplier_sites_tbl  ap_supplier_sites_tt;
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
     --** END Declarations
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supplier_sites_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_supplier_sites_cur
                    BULK COLLECT
                    INTO ap_supplier_sites_tbl
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supplier_sites_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN 1..ap_supplier_sites_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supplier_sites_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_id
                                   ,supplier_name
                                   ,procurement_bu
                                   ,party_site_id
                                   ,address_name
                                   ,supplier_site_id
                                   ,supplier_site
                                   ,supplier_site_new
                                   ,inactive_date
                                   ,sourcing_only
                                   ,purchasing
                                   ,procurement_card
                                   ,pay
                                   ,primary_pay
                                   ,income_tax_reporting_site
                                   ,alternate_site_name
                                   ,customer_number
                                   ,b2b_communication_method
                                   ,b2b_supplier_site_code
                                   ,communication_method
                                   ,e_mail
                                   ,fax_country_code
                                   ,fax_area_code
                                   ,fax
                                   ,hold_purchasing_documents
                                   ,hold_reason
                                   ,carrier
                                   ,mode_of_transport
                                   ,service_level
                                   ,freight_terms
                                   ,pay_on_receipt
                                   ,fob
                                   ,country_of_origin
                                   ,buyer_managed_transportation
                                   ,pay_on_use
                                   ,aging_onset_point
                                   ,aging_period_days
                                   ,consumption_advice_frequency
                                   ,consumption_advice_summary
                                   ,default_pay_site
                                   ,invoice_summary_level
                                   ,gapless_invoice_numbering
                                   ,selling_company_identifier
                                   ,create_debit_memo_from_return
                                   ,ship_to_exception_action
                                   ,receipt_routing
                                   ,over_receipt_tolerance
                                   ,over_receipt_action
                                   ,early_receipt_tolerance
                                   ,late_receipt_tolerance
                                   ,allow_substitute_receipts
                                   ,allow_unordered_receipts
                                   ,receipt_date_exception
                                   ,invoice_currency
                                   ,invoice_amount_limit
                                   ,invoice_match_option
                                   ,match_approval_level
                                   ,payment_currency
                                   ,payment_priority
                                   ,pay_group
                                   ,quantity_tolerances
                                   ,amount_tolerance
                                   ,hold_all_invoices
                                   ,hold_unmatched_invoices
                                   ,hold_unvalidated_invoices
                                   ,payment_hold_by
                                   ,payment_hold_date
                                   ,payment_hold_reason
                                   ,payment_terms
                                   ,terms_date_basis
                                   ,pay_date_basis
                                   ,bank_charge_deduction_type
                                   ,always_take_discount
                                   ,exclude_freight_from_discount
                                   ,exclude_tax_from_discount
                                   ,create_interest_invoices
                                   ,vat_code
                                   ,tax_registration_number
                                   ,payment_method
                                   ,delivery_channel
                                   ,bank_instruction_1
                                   ,bank_instruction_2
                                   ,bank_instruction
                                   ,settlement_priority
                                   ,payment_text_message_1
                                   ,payment_text_message_2
                                   ,payment_text_message_3
                                   ,bank_charge_bearer
                                   ,payment_reason
                                   ,payment_reason_comments
                                   ,delivery_method
                                   ,remittance_e_mail
                                   ,remittance_fax
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
                                   ,attribute16
                                   ,attribute17
                                   ,attribute18
                                   ,attribute19
                                   ,attribute20
                                   ,attribute_date1
                                   ,attribute_date2
                                   ,attribute_date3
                                   ,attribute_date4
                                   ,attribute_date5
                                   ,attribute_date6
                                   ,attribute_date7
                                   ,attribute_date8
                                   ,attribute_date9
                                   ,attribute_date10
                                   ,attribute_timestamp1
                                   ,attribute_timestamp2
                                   ,attribute_timestamp3
                                   ,attribute_timestamp4
                                   ,attribute_timestamp5
                                   ,attribute_timestamp6
                                   ,attribute_timestamp7
                                   ,attribute_timestamp8
                                   ,attribute_timestamp9
                                   ,attribute_timestamp10
                                   ,attribute_number1
                                   ,attribute_number2
                                   ,attribute_number3
                                   ,attribute_number4
                                   ,attribute_number5
                                   ,attribute_number6
                                   ,attribute_number7
                                   ,attribute_number8
                                   ,attribute_number9
                                   ,attribute_number10
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
                                   ,global_attribute_date1
                                   ,global_attribute_date2
                                   ,global_attribute_date3
                                   ,global_attribute_date4
                                   ,global_attribute_date5
                                   ,global_attribute_date6
                                   ,global_attribute_date7
                                   ,global_attribute_date8
                                   ,global_attribute_date9
                                   ,global_attribute_date10
                                   ,global_attribute_timestamp1
                                   ,global_attribute_timestamp2
                                   ,global_attribute_timestamp3
                                   ,global_attribute_timestamp4
                                   ,global_attribute_timestamp5
                                   ,global_attribute_timestamp6
                                   ,global_attribute_timestamp7
                                   ,global_attribute_timestamp8
                                   ,global_attribute_timestamp9
                                   ,global_attribute_timestamp10
                                   ,global_attribute_number1
                                   ,global_attribute_number2
                                   ,global_attribute_number3
                                   ,global_attribute_number4
                                   ,global_attribute_number5
                                   ,global_attribute_number6
                                   ,global_attribute_number7
                                   ,global_attribute_number8
                                   ,global_attribute_number9
                                   ,global_attribute_number10
                                   ,required_acknowledgement
                                   ,acknowledge_within_days
                                   ,invoice_channel
                                   ,payee_service_level_code
                                   ,exclusive_payment_flag
                                   )
                         VALUES  (
                                    pt_i_MigrationSetID
                                   ,gvt_MigrationSetName
                                   ,'EXTRACTED'
                                   ,ap_supplier_sites_tbl(i).import_action
                                   ,ap_supplier_sites_tbl(i).supplier_id
                                   ,ap_supplier_sites_tbl(i).supplier_name
                                   ,ap_supplier_sites_tbl(i).operating_unit_name
                                   ,ap_supplier_sites_tbl(i).party_site_id
                                   ,ap_supplier_sites_tbl(i).address_name
                                   ,ap_supplier_sites_tbl(i).supplier_site_id
                                   ,ap_supplier_sites_tbl(i).supplier_site
                                   ,ap_supplier_sites_tbl(i).supplier_site_new
                                   ,ap_supplier_sites_tbl(i).inactive_date
                                   ,ap_supplier_sites_tbl(i).sourcing_only
                                   ,ap_supplier_sites_tbl(i).purchasing
                                   ,ap_supplier_sites_tbl(i).procurement_card
                                   ,ap_supplier_sites_tbl(i).pay_site_flag
                                   ,ap_supplier_sites_tbl(i).primary_pay
                                   ,ap_supplier_sites_tbl(i).income_tax_reporting_site
                                   ,ap_supplier_sites_tbl(i).alternate_site_name
                                   ,ap_supplier_sites_tbl(i).customer_number
                                   ,ap_supplier_sites_tbl(i).b2b_communication_method
                                   ,ap_supplier_sites_tbl(i).b2b_supplier_site_code
                                   ,ap_supplier_sites_tbl(i).communication_method
                                   ,ap_supplier_sites_tbl(i).email
                                   ,ap_supplier_sites_tbl(i).fax_country_code
                                   ,ap_supplier_sites_tbl(i).fax_area_code
                                   ,ap_supplier_sites_tbl(i).fax
                                   ,ap_supplier_sites_tbl(i).hold_purchasing_documents
                                   ,ap_supplier_sites_tbl(i).hold_reason
                                   ,ap_supplier_sites_tbl(i).carrier
                                   ,ap_supplier_sites_tbl(i).mode_of_transport
                                   ,ap_supplier_sites_tbl(i).service_level
                                   ,ap_supplier_sites_tbl(i).freight_terms
                                   ,ap_supplier_sites_tbl(i).pay_on_receipt
                                   ,ap_supplier_sites_tbl(i).fob
                                   ,ap_supplier_sites_tbl(i).country_of_origin
                                   ,ap_supplier_sites_tbl(i).buyer_managed_transportation
                                   ,ap_supplier_sites_tbl(i).pay_on_use
                                   ,ap_supplier_sites_tbl(i).aging_onset_point
                                   ,ap_supplier_sites_tbl(i).aging_period_days
                                   ,ap_supplier_sites_tbl(i).consumption_advice_frequency
                                   ,ap_supplier_sites_tbl(i).consumption_advice_summary
                                   ,ap_supplier_sites_tbl(i).default_pay_site
                                   ,ap_supplier_sites_tbl(i).invoice_summary_level
                                   ,ap_supplier_sites_tbl(i).gapless_invoice_numbering
                                   ,ap_supplier_sites_tbl(i).selling_company_identifier
                                   ,ap_supplier_sites_tbl(i).create_debit_memo_from_return
                                   ,ap_supplier_sites_tbl(i).ship_to_exception_action
                                   ,ap_supplier_sites_tbl(i).receipt_routing
                                   ,ap_supplier_sites_tbl(i).over_receipt_tolerance
                                   ,ap_supplier_sites_tbl(i).over_receipt_action
                                   ,ap_supplier_sites_tbl(i).early_receipt_tolerance
                                   ,ap_supplier_sites_tbl(i).late_receipt_tolerance
                                   ,ap_supplier_sites_tbl(i).allow_substitute_receipts
                                   ,ap_supplier_sites_tbl(i).allow_unordered_receipts
                                   ,ap_supplier_sites_tbl(i).receipt_date_exception
                                   ,ap_supplier_sites_tbl(i).invoice_currency
                                   ,ap_supplier_sites_tbl(i).invoice_amount_limit
                                   ,ap_supplier_sites_tbl(i).invoice_match_option
                                   ,ap_supplier_sites_tbl(i).match_approval_level
                                   ,ap_supplier_sites_tbl(i).payment_currency
                                   ,ap_supplier_sites_tbl(i).payment_priority
                                   ,ap_supplier_sites_tbl(i).pay_group
                                   ,ap_supplier_sites_tbl(i).quantity_tolerances
                                   ,ap_supplier_sites_tbl(i).amount_tolerance
                                   ,ap_supplier_sites_tbl(i).hold_all_invoices
                                   ,ap_supplier_sites_tbl(i).hold_unmatched_invoices
                                   ,ap_supplier_sites_tbl(i).hold_unvalidated_invoices
                                   ,ap_supplier_sites_tbl(i).payment_hold_by
                                   ,ap_supplier_sites_tbl(i).payment_hold_date
                                   ,ap_supplier_sites_tbl(i).payment_hold_reason
                                   ,ap_supplier_sites_tbl(i).payment_terms
                                   ,ap_supplier_sites_tbl(i).terms_date_basis
                                   ,ap_supplier_sites_tbl(i).pay_date_basis
                                   ,ap_supplier_sites_tbl(i).bank_charge_deduction_type
                                   ,ap_supplier_sites_tbl(i).always_take_discount
                                   ,ap_supplier_sites_tbl(i).exclude_freight_from_discount
                                   ,ap_supplier_sites_tbl(i).exclude_tax_from_discount
                                   ,ap_supplier_sites_tbl(i).create_interest_invoices
                                   ,ap_supplier_sites_tbl(i).vat_code
                                   ,ap_supplier_sites_tbl(i).tax_registration_number
                                   ,ap_supplier_sites_tbl(i).payment_method
                                   ,ap_supplier_sites_tbl(i).delivery_channel  
                                   ,ap_supplier_sites_tbl(i).bank_instruction_1
                                   ,ap_supplier_sites_tbl(i).bank_instruction_2
                                   ,ap_supplier_sites_tbl(i).bank_instruction
                                   ,ap_supplier_sites_tbl(i).settlement_priority
                                   ,ap_supplier_sites_tbl(i).payment_text_message_1
                                   ,ap_supplier_sites_tbl(i).payment_text_message_2
                                   ,ap_supplier_sites_tbl(i).payment_text_message_3
                                   ,ap_supplier_sites_tbl(i).bank_charge_bearer
                                   ,ap_supplier_sites_tbl(i).payment_reason
                                   ,ap_supplier_sites_tbl(i).payment_reason_comments
                                   ,ap_supplier_sites_tbl(i).delivery_method
                                   ,ap_supplier_sites_tbl(i).remittance_e_mail
                                   ,ap_supplier_sites_tbl(i).remittance_fax
                                   ,ap_supplier_sites_tbl(i).attribute_category
                                   ,ap_supplier_sites_tbl(i).attribute1
                                   ,ap_supplier_sites_tbl(i).attribute2
                                   ,ap_supplier_sites_tbl(i).attribute3
                                   ,ap_supplier_sites_tbl(i).attribute4
                                   ,ap_supplier_sites_tbl(i).attribute5
                                   ,ap_supplier_sites_tbl(i).attribute6
                                   ,ap_supplier_sites_tbl(i).attribute7
                                   ,ap_supplier_sites_tbl(i).attribute8
                                   ,ap_supplier_sites_tbl(i).attribute9
                                   ,ap_supplier_sites_tbl(i).attribute10
                                   ,ap_supplier_sites_tbl(i).attribute11
                                   ,ap_supplier_sites_tbl(i).attribute12
                                   ,ap_supplier_sites_tbl(i).attribute13
                                   ,ap_supplier_sites_tbl(i).attribute14
                                   ,ap_supplier_sites_tbl(i).attribute15
                                   ,ap_supplier_sites_tbl(i).attribute16
                                   ,ap_supplier_sites_tbl(i).attribute17
                                   ,ap_supplier_sites_tbl(i).attribute18
                                   ,ap_supplier_sites_tbl(i).attribute19
                                   ,ap_supplier_sites_tbl(i).attribute20
                                   ,ap_supplier_sites_tbl(i).attribute_date1
                                   ,ap_supplier_sites_tbl(i).attribute_date2
                                   ,ap_supplier_sites_tbl(i).attribute_date3
                                   ,ap_supplier_sites_tbl(i).attribute_date4
                                   ,ap_supplier_sites_tbl(i).attribute_date5
                                   ,ap_supplier_sites_tbl(i).attribute_date6
                                   ,ap_supplier_sites_tbl(i).attribute_date7
                                   ,ap_supplier_sites_tbl(i).attribute_date8
                                   ,ap_supplier_sites_tbl(i).attribute_date9
                                   ,ap_supplier_sites_tbl(i).attribute_date10
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp1
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp2
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp3
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp4
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp5
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp6
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp7
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp8
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp9
                                   ,ap_supplier_sites_tbl(i).attribute_timestamp10
                                   ,ap_supplier_sites_tbl(i).attribute_number1
                                   ,ap_supplier_sites_tbl(i).attribute_number2
                                   ,ap_supplier_sites_tbl(i).attribute_number3
                                   ,ap_supplier_sites_tbl(i).attribute_number4
                                   ,ap_supplier_sites_tbl(i).attribute_number5
                                   ,ap_supplier_sites_tbl(i).attribute_number6
                                   ,ap_supplier_sites_tbl(i).attribute_number7
                                   ,ap_supplier_sites_tbl(i).attribute_number8
                                   ,ap_supplier_sites_tbl(i).attribute_number9
                                   ,ap_supplier_sites_tbl(i).attribute_number10
                                   ,ap_supplier_sites_tbl(i).global_attribute_category
                                   ,ap_supplier_sites_tbl(i).global_attribute1
                                   ,ap_supplier_sites_tbl(i).global_attribute2
                                   ,ap_supplier_sites_tbl(i).global_attribute3
                                   ,ap_supplier_sites_tbl(i).global_attribute4
                                   ,ap_supplier_sites_tbl(i).global_attribute5
                                   ,ap_supplier_sites_tbl(i).global_attribute6
                                   ,ap_supplier_sites_tbl(i).global_attribute7
                                   ,ap_supplier_sites_tbl(i).global_attribute8
                                   ,ap_supplier_sites_tbl(i).global_attribute9
                                   ,ap_supplier_sites_tbl(i).global_attribute10
                                   ,ap_supplier_sites_tbl(i).global_attribute11
                                   ,ap_supplier_sites_tbl(i).global_attribute12
                                   ,ap_supplier_sites_tbl(i).global_attribute13
                                   ,ap_supplier_sites_tbl(i).global_attribute14
                                   ,ap_supplier_sites_tbl(i).global_attribute15
                                   ,ap_supplier_sites_tbl(i).global_attribute16
                                   ,ap_supplier_sites_tbl(i).global_attribute17
                                   ,ap_supplier_sites_tbl(i).global_attribute18
                                   ,ap_supplier_sites_tbl(i).global_attribute19
                                   ,ap_supplier_sites_tbl(i).global_attribute20
                                   ,ap_supplier_sites_tbl(i).global_attribute_date1
                                   ,ap_supplier_sites_tbl(i).global_attribute_date2
                                   ,ap_supplier_sites_tbl(i).global_attribute_date3
                                   ,ap_supplier_sites_tbl(i).global_attribute_date4
                                   ,ap_supplier_sites_tbl(i).global_attribute_date5
                                   ,ap_supplier_sites_tbl(i).global_attribute_date6
                                   ,ap_supplier_sites_tbl(i).global_attribute_date7
                                   ,ap_supplier_sites_tbl(i).global_attribute_date8
                                   ,ap_supplier_sites_tbl(i).global_attribute_date9
                                   ,ap_supplier_sites_tbl(i).global_attribute_date10
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp1
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp2
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp3
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp4
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp5
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp6
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp7
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp8
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp9
                                   ,ap_supplier_sites_tbl(i).global_attribute_timestamp10
                                   ,ap_supplier_sites_tbl(i).global_attribute_number1
                                   ,ap_supplier_sites_tbl(i).global_attribute_number2
                                   ,ap_supplier_sites_tbl(i).global_attribute_number3
                                   ,ap_supplier_sites_tbl(i).global_attribute_number4
                                   ,ap_supplier_sites_tbl(i).global_attribute_number5
                                   ,ap_supplier_sites_tbl(i).global_attribute_number6
                                   ,ap_supplier_sites_tbl(i).global_attribute_number7
                                   ,ap_supplier_sites_tbl(i).global_attribute_number8
                                   ,ap_supplier_sites_tbl(i).global_attribute_number9
                                   ,ap_supplier_sites_tbl(i).global_attribute_number10
                                   ,ap_supplier_sites_tbl(i).required_acknowledgement
                                   ,ap_supplier_sites_tbl(i).acknowledge_within_days
                                   ,ap_supplier_sites_tbl(i).invoice_channel
                                   ,ap_supplier_sites_tbl(i).payee_service_level_code
                                   ,ap_supplier_sites_tbl(i).exclusive_payment_flag
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_sites_cur;
               --
               /*
               ** Once the base Supplier Sites have been extracted, update the table
               ** with the R12 Payee Details for the sites.
               */
               --
               gvv_ProgressIndicator := '0100';
               --
               FOR   UpdR12PayeeDetail_rec
               IN    UpdR12PayeeDetails_cur
                          (
                           pt_i_MigrationSetID
                          )
               LOOP
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    UPDATE   xxmx_ap_supplier_sites_stg  xasss
                    SET     xasss.delivery_channel         = UpdR12PayeeDetail_rec.delivery_channel
                           ,xasss.bank_instruction_1       = UpdR12PayeeDetail_rec.bank_instruction_1
                           ,xasss.bank_instruction_2       = UpdR12PayeeDetail_rec.bank_instruction_2
                           ,xasss.bank_instruction         = UpdR12PayeeDetail_rec.bank_instruction
                           ,xasss.settlement_priority      = UpdR12PayeeDetail_rec.settlement_priority
                           ,xasss.payment_text_message_1   = UpdR12PayeeDetail_rec.payment_text_message_1
                           ,xasss.payment_text_message_2   = UpdR12PayeeDetail_rec.payment_text_message_2
                           ,xasss.payment_text_message_3   = UpdR12PayeeDetail_rec.payment_text_message_3
                           ,xasss.bank_charge_bearer       = UpdR12PayeeDetail_rec.bank_charge_bearer
                           ,xasss.payment_reason           = UpdR12PayeeDetail_rec.payment_reason
                           ,xasss.payment_reason_comments  = UpdR12PayeeDetail_rec.payment_reason_comments
                           ,xasss.delivery_method          = UpdR12PayeeDetail_rec.delivery_method
                           ,xasss.remittance_e_mail        = UpdR12PayeeDetail_rec.remittance_e_mail
                           ,xasss.remittance_fax           = UpdR12PayeeDetail_rec.remittance_fax
                           ,xasss.payee_service_level_code = UpdR12PayeeDetail_rec.payee_service_level_code
                    WHERE   1 = 1
                    AND     xasss.procurement_bu   = UpdR12PayeeDetail_rec.procurement_bu
                    AND     xasss.supplier_site_id = UpdR12PayeeDetail_rec.supplier_site_id;
                    --
               END LOOP;
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
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0120';
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
                    IF   ap_supplier_sites_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_sites_cur;
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
     END ap_supplier_sites_stg;
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supp_3rd_party_rels_stg
     ****************************************
     */
     --
     PROCEDURE ap_supp_3rd_party_rels_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supp_3rd_party_rels_cur
          IS
               --
               SELECT  'CREATE'                                            AS import_action
                      ,supplier_party.party_name                           AS supplier_name
--                      ,xssv.vendor_site_code                               AS supplier_site
                      ,decode(xssv.org_id,142,substr(assa.vendor_site_id||'-'||assa.vendor_site_code,1,15),assa.vendor_site_code)  AS supplier_site
                      ,iepr.relationship_id                                AS relationship_id
                      ,xssv.operating_unit_name                            AS operating_unit_name
                      ,iepr.primary_flag                                   AS default_relationship_flag
                      ,remit_to_party.party_name                           AS remit_to_supplier
--                      ,remit_to_site.vendor_site_code                      AS remit_to_address
                      ,decode(xssv.org_id,142,substr(remit_to_site.vendor_site_id||'-'||remit_to_site.vendor_site_code,1,15),remit_to_site.vendor_site_code) AS remit_to_address
                      ,iepr.from_date                                      AS from_date
                      ,iepr.to_date                                        AS to_date
                      ,iepr.additional_information                         AS description
               FROM    xxmx_supplier_scope_v                               xssv
                      ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT        assa
                      ,apps.iby_ext_payee_relationships@MXDM_NVIS_EXTRACT  iepr
                      ,apps.hz_parties@MXDM_NVIS_EXTRACT                   supplier_party
                      ,apps.hz_parties@MXDM_NVIS_EXTRACT                   remit_to_party
                      ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT        remit_to_site
               WHERE   1 = 1
               AND     assa.org_id                  = xssv.org_id
               AND     assa.vendor_id               = xssv.vendor_id
               AND     assa.vendor_site_id          = xssv.vendor_site_id
               AND     iepr.supplier_site_id        = assa.vendor_site_id
               AND     supplier_party.party_id      = iepr.party_id
               AND     remit_to_party.party_id      = iepr.remit_party_id
               AND     remit_to_site.vendor_site_id = iepr.remit_supplier_site_id;
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supp_3rd_party_rels_tt IS TABLE OF ap_supp_3rd_party_rels_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName                CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_3rd_party_rels_stg';
          ct_StgSchema                     CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                      CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_3rd_pty_rels_stg';
          ct_Phase                         CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          ap_supp_3rd_party_rels_tbl  ap_supp_3rd_party_rels_tt;
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
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
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
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supp_3rd_party_rels_cur;
               --
               --
               gvv_ProgressIndicator := '0060';
               --
               --
               LOOP
                    --
                    --
                    FETCH               ap_supp_3rd_party_rels_cur
                    BULK COLLECT
                    INTO                ap_supp_3rd_party_rels_tbl
                    LIMIT               XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    --
                    EXIT WHEN           ap_supp_3rd_party_rels_tbl.COUNT=0;
                    --
                    --
                    FORALL I
                    IN 1..ap_supp_3rd_party_rels_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_3rd_pty_rels_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_name
                                   ,supplier_site
                                   ,relationship_id
                                   ,procurement_bu
                                   ,default_relationship_flag
                                   ,remit_to_supplier
                                   ,remit_to_address
                                   ,from_date
                                   ,to_date
                                   ,description
                                   )
                         VALUES
                                  (
                                    pt_i_MigrationSetID                               --MIGRATION_SET_ID
                                   ,gvt_MigrationSetName                               --MIGRATION_SET_NAME
                                   ,'EXTRACTED'
                                   ,ap_supp_3rd_party_rels_tbl(i).import_action
                                   ,ap_supp_3rd_party_rels_tbl(i).supplier_name
                                   ,ap_supp_3rd_party_rels_tbl(i).supplier_site
                                   ,ap_supp_3rd_party_rels_tbl(i).relationship_id
                                   ,ap_supp_3rd_party_rels_tbl(i).operating_unit_name
                                   ,ap_supp_3rd_party_rels_tbl(i).default_relationship_flag
                                   ,ap_supp_3rd_party_rels_tbl(i).remit_to_supplier
                                   ,ap_supp_3rd_party_rels_tbl(i).remit_to_address
                                   ,ap_supp_3rd_party_rels_tbl(i).from_date
                                   ,ap_supp_3rd_party_rels_tbl(i).to_date
                                   ,ap_supp_3rd_party_rels_tbl(i).description
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supp_3rd_party_rels_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
               WHEN OTHERS
               THEN
                    --
                    IF   ap_supp_3rd_party_rels_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supp_3rd_party_rels_cur;
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
     END ap_supp_3rd_party_rels_stg;
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supp_site_assigns_stg
     **************************************
     */
     --
     PROCEDURE ap_supp_site_assigns_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supp_site_assigns_cur
          IS
               --
               SELECT  DISTINCT
                       'CREATE'                                                                 AS import_action
                      ,aps.vendor_id                                                            AS supplier_id
                      ,TRIM(aps.vendor_name)                                                    AS supplier_name
                      ,assa.vendor_site_id                                                      AS supplier_site_id
--                      ,assa.vendor_site_code                                                    AS supplier_site
                      ,decode(assa.org_id,142,substr(assa.vendor_site_id||'-'||assa.vendor_site_code,1,15),assa.vendor_site_code) AS supplier_site
                      ,xssv.operating_unit_name                                                 AS procurement_bu
                      ,xssv.operating_unit_name                                                 AS client_bu
                      ,xssv.operating_unit_name                                                 AS bill_to_bu
                      ,ship_loc.location_code                                                   AS ship_to_location
                      ,bill_loc.location_code                                                   AS bill_to_location
                      ,DECODE(
                              gct_MigrateCISData
                                   ,'N' ,'N'
                                        ,aps.allow_awt_flag
                             )                                                                  AS use_withholding_tax
                      ,DECODE(
                              gct_MigrateCISData
                                   ,'N' ,NULL
                                        ,(
                                          SELECT name
                                          FROM  apps.ap_awt_groups@MXDM_NVIS_EXTRACT aag
                                          WHERE  aag.group_id = aps.awt_group_id
                                         )
                             )                                                                  AS withholding_tax_group                     
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.accts_pay_code_combination_id
                       )                                                                        AS liability_distribution
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.prepay_code_combination_id
                       )                                                                        AS prepayment_distribution
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.future_dated_payment_ccid
                       )                                                                        AS bills_payable_distribution
                      ,(
                        SELECT distribution_set_name
                        FROM   apps.ap_distribution_sets_all@MXDM_NVIS_EXTRACT ads
                        WHERE  1 = 1
                        AND    ads.distribution_set_id = aps.distribution_set_id
                       )                                                                        AS distribution_set
                      ,assa.inactive_date                                                       AS inactive_date
               FROM    xxmx_supplier_scope_v                             xssv
                      ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT      assa
                      ,apps.ap_suppliers@MXDM_NVIS_EXTRACT               aps
                      ,apps.hr_locations_all@MXDM_NVIS_EXTRACT           bill_loc
                      ,apps.hr_locations_all@MXDM_NVIS_EXTRACT           ship_loc                      
               WHERE   1 = 1
               AND     assa.org_id          = xssv.org_id
               AND     assa.vendor_id       = xssv.vendor_id
               AND     assa.vendor_site_id  = xssv.vendor_site_id
               AND     aps.vendor_id        = assa.vendor_id
               AND     bill_loc.location_id(+) = assa.bill_to_location_id
               AND     ship_loc.location_id(+) = assa.ship_to_location_id;
/*
               SELECT  DISTINCT
                       NULL                                                                     AS import_action      -- REMOVE THIS
                      ,aps.vendor_id                                                            AS supplier_id
                      ,TRIM(aps.vendor_name)                                                    AS supplier_name
                      ,assa.vendor_site_id                                                      AS supplier_site_id
                      ,assa.vendor_site_code                                                    AS supplier_site
                      ,xssv.operating_unit_name                                                 AS operating_unit_name
                      ,xssv.operating_unit_name                                                 AS client_bu
                      ,xssv.operating_unit_name                                                 AS bill_to_bu
                      ,''                                                                       AS ship_to_location
                      ,''                                                                       AS bill_to_location
                      ,NULL                                                                     AS use_withholding_tax
                      ,(
                        SELECT name
                        FROM   apps.ap_awt_groups@MXDM_NVIS_EXTRACT aag
                        WHERE  aag.group_id = aps.awt_group_id
                       )                                                                        AS withholding_tax_group
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.accts_pay_code_combination_id
                       )                                                                        AS liability_distribution
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.prepay_code_combination_id
                       )                                                                        AS prepayment_distribution
                      ,(
                        SELECT concatenated_segments
                        FROM   apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT gcc
                        WHERE  1 = 1
                        AND    gcc.code_combination_id = aps.future_dated_payment_ccid
                       )                                                                        AS bills_payable_distribution
                      ,(
                        SELECT distribution_set_name
                        FROM   apps.ap_distribution_sets_all@MXDM_NVIS_EXTRACT ads
                        WHERE  1 = 1
                        AND    ads.distribution_set_id = aps.distribution_set_id
                       )                                                                        AS distribution_set
                      ,assa.inactive_date                                                       AS inactive_date
               FROM    xxmx_supplier_scope_v                             xssv
                      ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT      assa
                      ,apps.ap_suppliers@MXDM_NVIS_EXTRACT               aps
                      ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             hps
                      ,apps.ap_terms_tl@MXDM_NVIS_EXTRACT                att
                      ,apps.hr_all_organization_units@MXDM_NVIS_EXTRACT  org
                      ,apps.hz_locations@MXDM_NVIS_EXTRACT               hl
               WHERE   1 = 1
               AND     assa.org_id         = xssv.org_id
               AND     assa.vendor_id      = xssv.vendor_id
               AND     assa.vendor_site_id = xssv.vendor_site_id
               AND     aps.vendor_id       = assa.vendor_id
               AND     hps.party_site_id   = assa.party_site_id
               AND     att.term_id         = assa.terms_id
               AND     att.LANGUAGE        = 'US'
               AND     hl.location_id      = hps.location_id;
*/               
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supp_site_assigns_tt IS TABLE OF ap_supp_site_assigns_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName                CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_site_assigns_stg';
          ct_StgSchema                     CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                      CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_site_assigns_stg';
          ct_Phase                         CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
            ap_supp_site_assigns_tbl  ap_supp_site_assigns_tt;
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supp_site_assigns_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_supp_site_assigns_cur
                    BULK COLLECT
                    INTO ap_supp_site_assigns_tbl
                    LIMIT XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supp_site_assigns_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN 1..ap_supp_site_assigns_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_site_assigns_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_id
                                   ,supplier_name
                                   ,supplier_site_id
                                   ,supplier_site
                                   ,procurement_bu
                                   ,client_bu
                                   ,bill_to_bu
                                   ,ship_to_location
                                   ,bill_to_location
                                   ,use_withholding_tax
                                   ,withholding_tax_group
                                   ,liability_distribution
                                   ,prepayment_distribution
                                   ,bills_payable_distribution
                                   ,distribution_set
                                   ,inactive_date
                                   )
                         VALUES
                                   (
                                    pt_i_MigrationSetID                                     -- migration_set_id
                                   ,gvt_MigrationSetName                                    -- migration_set_name
                                   ,'EXTRACTED'                                             -- migration_status
                                   ,ap_supp_site_assigns_tbl(i).import_action               -- import_action
                                   ,ap_supp_site_assigns_tbl(i).supplier_id                 -- supplier_id
                                   ,ap_supp_site_assigns_tbl(i).supplier_name               -- supplier_name
                                   ,ap_supp_site_assigns_tbl(i).supplier_site_id            -- supplier_site_id
                                   ,ap_supp_site_assigns_tbl(i).supplier_site               -- supplier_site
                                   ,ap_supp_site_assigns_tbl(i).procurement_bu              -- procurement_bu
                                   ,ap_supp_site_assigns_tbl(i).client_bu                   -- client_bu
                                   ,ap_supp_site_assigns_tbl(i).bill_to_bu                  -- bill_to_bu
                                   ,ap_supp_site_assigns_tbl(i).ship_to_location            -- ship_to_location
                                   ,ap_supp_site_assigns_tbl(i).bill_to_location            -- bill_to_location
                                   ,ap_supp_site_assigns_tbl(i).use_withholding_tax         -- use_withholding_tax
                                   ,ap_supp_site_assigns_tbl(i).withholding_tax_group       -- withholding_tax_group
                                   ,ap_supp_site_assigns_tbl(i).liability_distribution      -- liability_distribution
                                   ,ap_supp_site_assigns_tbl(i).prepayment_distribution     -- prepayment_distribution
                                   ,ap_supp_site_assigns_tbl(i).bills_payable_distribution  -- bills_payable_distribution
                                   ,ap_supp_site_assigns_tbl(i).distribution_set            -- distribution_set
                                   ,ap_supp_site_assigns_tbl(i).inactive_date               -- inactive_date
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supp_site_assigns_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
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
                    IF   ap_supp_site_assigns_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supp_site_assigns_cur;
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
     END ap_supp_site_assigns_stg;
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supplier_contacts_stg
     **************************************
     */
     --
     PROCEDURE ap_supplier_contacts_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_contacts_cur
          IS
               --
               SELECT   DISTINCT
                         'CREATE'                                                                   AS import_action
                        ,xssv.vendor_name                                                           AS supplier_name
                        ,apsc.vendor_contact_id                                                     AS supplier_contact_id
                        ,apsc.prefix                                                                AS prefix
                        ,person_party.person_first_name                                             AS first_name
                        ,''                                                                         AS first_name_new
                        ,apsc.middle_name                                                           AS middle_name
                        ,person_party.person_last_name                                              AS last_name
                        ,''                                                                         AS last_name_new
                        ,apsc.title                                                                 AS job_title
                        ,''                                                                         AS primary_admin_contact
                        ,apsc.email_address                                                         AS email_address
                        ,''                                                                         AS email_address_new
                        ,CASE
                              WHEN apsc.phone IS NOT NULL
                                   THEN (
                                         SELECT phone_country_code
                                         FROM   apps.hz_phone_country_codes@MXDM_NVIS_EXTRACT hpc
                                         WHERE  1 = 1
                                         AND    hpc.territory_code = assa.country
                                        )
                              ELSE NULL
                         END                                                                        AS phone_country_code
                        ,apsc.area_code                                                             AS area_code
                        ,apsc.phone                                                                 AS phone
                        ,''                                                                         AS phone_extension
                        ,''                                                                         AS fax_country_code
                        ,apsc.fax_area_code                                                         AS fax_area_code
                        ,apsc.fax                                                                   AS fax
                        ,''                                                                         AS mobile_country_code
                        ,''                                                                         AS mobile_area_code
                        ,''                                                                         AS mobile
                        ,apsc.inactive_date                                                         AS inactive_date
                        ,NULL                                                                       AS attribute_category
                        ,NULL                                                                       AS attribute1
                        ,NULL                                                                       AS attribute2
                        ,NULL                                                                       AS attribute3
                        ,NULL                                                                       AS attribute4
                        ,NULL                                                                       AS attribute5
                        ,NULL                                                                       AS attribute6
                        ,NULL                                                                       AS attribute7
                        ,NULL                                                                       AS attribute8
                        ,NULL                                                                       AS attribute9
                        ,NULL                                                                       AS attribute10
                        ,NULL                                                                       AS attribute11
                        ,NULL                                                                       AS attribute12
                        ,NULL                                                                       AS attribute13
                        ,NULL                                                                       AS attribute14
                        ,NULL                                                                       AS attribute15
                        ,NULL                                                                       AS attribute16
                        ,NULL                                                                       AS attribute17
                        ,NULL                                                                       AS attribute18
                        ,NULL                                                                       AS attribute19
                        ,NULL                                                                       AS attribute20
                        ,NULL                                                                       AS attribute21
                        ,NULL                                                                       AS attribute22
                        ,NULL                                                                       AS attribute23
                        ,NULL                                                                       AS attribute24
                        ,NULL                                                                       AS attribute25
                        ,NULL                                                                       AS attribute26
                        ,NULL                                                                       AS attribute27
                        ,NULL                                                                       AS attribute28
                        ,NULL                                                                       AS attribute29
                        ,NULL                                                                       AS attribute30
                        ,NULL                                                                       AS attribute_number1
                        ,NULL                                                                       AS attribute_number2
                        ,NULL                                                                       AS attribute_number3
                        ,NULL                                                                       AS attribute_number4
                        ,NULL                                                                       AS attribute_number5
                        ,NULL                                                                       AS attribute_number6
                        ,NULL                                                                       AS attribute_number7
                        ,NULL                                                                       AS attribute_number8
                        ,NULL                                                                       AS attribute_number9
                        ,NULL                                                                       AS attribute_number10
                        ,NULL                                                                       AS attribute_number11
                        ,NULL                                                                       AS attribute_number12
                        ,NULL                                                                       AS attribute_date1
                        ,NULL                                                                       AS attribute_date2
                        ,NULL                                                                       AS attribute_date3
                        ,NULL                                                                       AS attribute_date4
                        ,NULL                                                                       AS attribute_date5
                        ,NULL                                                                       AS attribute_date6
                        ,NULL                                                                       AS attribute_date7
                        ,NULL                                                                       AS attribute_date8
                        ,NULL                                                                       AS attribute_date9
                        ,NULL                                                                       AS attribute_date10
                        ,NULL                                                                       AS attribute_date11
                        ,NULL                                                                       AS attribute_date12
                        ,''                                                                         AS user_account_action
                        ,''                                                                         AS role1
                        ,''                                                                         AS role2
                        ,''                                                                         AS role3
                        ,''                                                                         AS role4
                        ,''                                                                         AS role5
                        ,''                                                                         AS role6
                        ,''                                                                         AS role7
                        ,''                                                                         AS role8
                        ,''                                                                         AS role9
                        ,''                                                                         AS role10
               FROM      xxmx_supplier_scope_v                         xssv
                        ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa
                        ,apps.hz_parties@MXDM_NVIS_EXTRACT             person_party
                        ,apps.hz_parties@MXDM_NVIS_EXTRACT             relationship_party
                        ,apps.ap_supplier_contacts@MXDM_NVIS_EXTRACT   apsc
               WHERE     1 = 1
               AND       assa.org_id                                        = xssv.org_id
               AND       assa.vendor_id                                     = xssv.vendor_id
               AND       assa.vendor_site_id                                = xssv.vendor_site_id
               AND       apsc.vendor_site_id(+)                             = assa.vendor_site_id
               AND       apsc.org_party_site_id(+)                          = assa.party_site_id
               AND       NVL(TRUNC(apsc.inactive_date), TRUNC(SYSDATE) + 1) > TRUNC(SYSDATE)
               AND       person_party.party_id                              = apsc.per_party_id
               AND       relationship_party.party_id                        = apsc.rel_party_id;
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_contacts_tt IS TABLE OF ap_supplier_contacts_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName           CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_contacts_stg';
          ct_StgSchema                CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                 CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_contacts_stg';
          ct_Phase                    CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
           ap_supplier_contacts_tbl  ap_supplier_contacts_tt;
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
     --** END Declarations
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supplier_contacts_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH        ap_supplier_contacts_cur
                    BULK COLLECT
                    INTO         ap_supplier_contacts_tbl
                    LIMIT        XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supplier_contacts_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..ap_supplier_contacts_tbl.COUNT
                         --
                         INSERT
                         INTO    xxmx_ap_supp_contacts_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_contact_id
                                   ,supplier_name
                                   ,prefix
                                   ,first_name
                                   ,first_name_new
                                   ,middle_name
                                   ,last_name
                                   ,last_name_new
                                   ,job_title
                                   ,primary_admin_contact
                                   ,email_address
                                   ,email_address_new
                                   ,phone_country_code
                                   ,area_code
                                   ,phone
                                   ,phone_extension
                                   ,fax_country_code
                                   ,fax_area_code
                                   ,fax
                                   ,mobile_country_code
                                   ,mobile_area_code
                                   ,mobile
                                   ,inactive_date
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
                                   ,attribute16
                                   ,attribute17
                                   ,attribute18
                                   ,attribute19
                                   ,attribute20
                                   ,attribute21
                                   ,attribute22
                                   ,attribute23
                                   ,attribute24
                                   ,attribute25
                                   ,attribute26
                                   ,attribute27
                                   ,attribute28
                                   ,attribute29
                                   ,attribute30
                                   ,attribute_number1
                                   ,attribute_number2
                                   ,attribute_number3
                                   ,attribute_number4
                                   ,attribute_number5
                                   ,attribute_number6
                                   ,attribute_number7
                                   ,attribute_number8
                                   ,attribute_number9
                                   ,attribute_number10
                                   ,attribute_number11
                                   ,attribute_number12
                                   ,attribute_date1
                                   ,attribute_date2
                                   ,attribute_date3
                                   ,attribute_date4
                                   ,attribute_date5
                                   ,attribute_date6
                                   ,attribute_date7
                                   ,attribute_date8
                                   ,attribute_date9
                                   ,attribute_date10
                                   ,attribute_date11
                                   ,attribute_date12
                                   ,user_account_action
                                   ,role1
                                   ,role2
                                   ,role3
                                   ,role4
                                   ,role5
                                   ,role6
                                   ,role7
                                   ,role8
                                   ,role9
                                   ,role10
                                   )
                         VALUES  (
                                    pt_i_MigrationSetID                                -- migration_set_id
                                   ,gvt_MigrationSetName                               -- migration_set_name
                                   ,'EXTRACTED'                                        -- migration_status
                                   ,ap_supplier_contacts_tbl(i).import_action          -- import_action
                                   ,ap_supplier_contacts_tbl(i).supplier_contact_id    -- supplier_contact_id
                                   ,ap_supplier_contacts_tbl(i).supplier_name          -- supplier_name
                                   ,ap_supplier_contacts_tbl(i).prefix                 -- prefix
                                   ,ap_supplier_contacts_tbl(i).first_name             -- first_name
                                   ,ap_supplier_contacts_tbl(i).first_name_new         -- first_name_new
                                   ,ap_supplier_contacts_tbl(i).middle_name            -- middle_name
                                   ,ap_supplier_contacts_tbl(i).last_name              -- last_name
                                   ,ap_supplier_contacts_tbl(i).last_name_new          -- last_name_new
                                   ,ap_supplier_contacts_tbl(i).job_title              -- job_title
                                   ,ap_supplier_contacts_tbl(i).primary_admin_contact  -- primary_admin_contact
                                   ,ap_supplier_contacts_tbl(i).email_address          -- email_address
                                   ,ap_supplier_contacts_tbl(i).email_address_new      -- email_address_new
                                   ,ap_supplier_contacts_tbl(i).phone_country_code     -- phone_country_code
                                   ,ap_supplier_contacts_tbl(i).area_code              -- area_code
                                   ,ap_supplier_contacts_tbl(i).phone                  -- phone
                                   ,ap_supplier_contacts_tbl(i).phone_extension        -- phone_extension
                                   ,ap_supplier_contacts_tbl(i).fax_country_code       -- fax_country_code
                                   ,ap_supplier_contacts_tbl(i).fax_area_code          -- fax_area_code
                                   ,ap_supplier_contacts_tbl(i).fax                    -- fax
                                   ,ap_supplier_contacts_tbl(i).mobile_country_code    -- mobile_country_code
                                   ,ap_supplier_contacts_tbl(i).mobile_area_code       -- mobile_area_code
                                   ,ap_supplier_contacts_tbl(i).mobile                 -- mobile
                                   ,ap_supplier_contacts_tbl(i).inactive_date          -- inactive_date
                                   ,ap_supplier_contacts_tbl(i).attribute_category     -- attribute_category
                                   ,ap_supplier_contacts_tbl(i).attribute1             -- attribute1
                                   ,ap_supplier_contacts_tbl(i).attribute2             -- attribute2
                                   ,ap_supplier_contacts_tbl(i).attribute3             -- attribute3
                                   ,ap_supplier_contacts_tbl(i).attribute4             -- attribute4
                                   ,ap_supplier_contacts_tbl(i).attribute5             -- attribute5
                                   ,ap_supplier_contacts_tbl(i).attribute6             -- attribute6
                                   ,ap_supplier_contacts_tbl(i).attribute7             -- attribute7
                                   ,ap_supplier_contacts_tbl(i).attribute8             -- attribute8
                                   ,ap_supplier_contacts_tbl(i).attribute9             -- attribute9
                                   ,ap_supplier_contacts_tbl(i).attribute10            -- attribute10
                                   ,ap_supplier_contacts_tbl(i).attribute11            -- attribute11
                                   ,ap_supplier_contacts_tbl(i).attribute12            -- attribute12
                                   ,ap_supplier_contacts_tbl(i).attribute13            -- attribute13
                                   ,ap_supplier_contacts_tbl(i).attribute14            -- attribute14
                                   ,ap_supplier_contacts_tbl(i).attribute15            -- attribute15
                                   ,ap_supplier_contacts_tbl(i).attribute16            -- attribute16
                                   ,ap_supplier_contacts_tbl(i).attribute17            -- attribute17
                                   ,ap_supplier_contacts_tbl(i).attribute18            -- attribute18
                                   ,ap_supplier_contacts_tbl(i).attribute19            -- attribute19
                                   ,ap_supplier_contacts_tbl(i).attribute20            -- attribute20
                                   ,ap_supplier_contacts_tbl(i).attribute21            -- attribute21
                                   ,ap_supplier_contacts_tbl(i).attribute22            -- attribute22
                                   ,ap_supplier_contacts_tbl(i).attribute23            -- attribute23
                                   ,ap_supplier_contacts_tbl(i).attribute24            -- attribute24
                                   ,ap_supplier_contacts_tbl(i).attribute25            -- attribute25
                                   ,ap_supplier_contacts_tbl(i).attribute26            -- attribute26
                                   ,ap_supplier_contacts_tbl(i).attribute27            -- attribute27
                                   ,ap_supplier_contacts_tbl(i).attribute28            -- attribute28
                                   ,ap_supplier_contacts_tbl(i).attribute29            -- attribute29
                                   ,ap_supplier_contacts_tbl(i).attribute30            -- attribute30
                                   ,ap_supplier_contacts_tbl(i).attribute_number1      -- attribute_number1
                                   ,ap_supplier_contacts_tbl(i).attribute_number2      -- attribute_number2
                                   ,ap_supplier_contacts_tbl(i).attribute_number3      -- attribute_number3
                                   ,ap_supplier_contacts_tbl(i).attribute_number4      -- attribute_number4
                                   ,ap_supplier_contacts_tbl(i).attribute_number5      -- attribute_number5
                                   ,ap_supplier_contacts_tbl(i).attribute_number6      -- attribute_number6
                                   ,ap_supplier_contacts_tbl(i).attribute_number7      -- attribute_number7
                                   ,ap_supplier_contacts_tbl(i).attribute_number8      -- attribute_number8
                                   ,ap_supplier_contacts_tbl(i).attribute_number9      -- attribute_number9
                                   ,ap_supplier_contacts_tbl(i).attribute_number10     -- attribute_number10
                                   ,ap_supplier_contacts_tbl(i).attribute_number11     -- attribute_number11
                                   ,ap_supplier_contacts_tbl(i).attribute_number12     -- attribute_number12
                                   ,ap_supplier_contacts_tbl(i).attribute_date1        -- attribute_date1
                                   ,ap_supplier_contacts_tbl(i).attribute_date2        -- attribute_date2
                                   ,ap_supplier_contacts_tbl(i).attribute_date3        -- attribute_date3
                                   ,ap_supplier_contacts_tbl(i).attribute_date4        -- attribute_date4
                                   ,ap_supplier_contacts_tbl(i).attribute_date5        -- attribute_date5
                                   ,ap_supplier_contacts_tbl(i).attribute_date6        -- attribute_date6
                                   ,ap_supplier_contacts_tbl(i).attribute_date7        -- attribute_date7
                                   ,ap_supplier_contacts_tbl(i).attribute_date8        -- attribute_date8
                                   ,ap_supplier_contacts_tbl(i).attribute_date9        -- attribute_date9
                                   ,ap_supplier_contacts_tbl(i).attribute_date10       -- attribute_date10
                                   ,ap_supplier_contacts_tbl(i).attribute_date11       -- attribute_date11
                                   ,ap_supplier_contacts_tbl(i).attribute_date12       -- attribute_date12
                                   ,ap_supplier_contacts_tbl(i).user_account_action    -- user_account_action
                                   ,ap_supplier_contacts_tbl(i).role1                  -- role1
                                   ,ap_supplier_contacts_tbl(i).role2                  -- role2
                                   ,ap_supplier_contacts_tbl(i).role3                  -- role3
                                   ,ap_supplier_contacts_tbl(i).role4                  -- role4
                                   ,ap_supplier_contacts_tbl(i).role5                  -- role5
                                   ,ap_supplier_contacts_tbl(i).role6                  -- role6
                                   ,ap_supplier_contacts_tbl(i).role7                  -- role7
                                   ,ap_supplier_contacts_tbl(i).role8                  -- role8
                                   ,ap_supplier_contacts_tbl(i).role9                  -- role9
                                   ,ap_supplier_contacts_tbl(i).role10                 -- role10
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_contacts_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
               WHEN OTHERS
               THEN
                    --
                    IF ap_supplier_contacts_cur%ISOPEN
                    THEN
                          --
                          CLOSE ap_supplier_contacts_cur;
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
     END ap_supplier_contacts_stg;
     --
     --
     /*
     *******************************************
     ** PROCEDURE: ap_supplier_contact_addrs_stg
     *******************************************
     */
     --
     PROCEDURE ap_supplier_contact_addrs_stg
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
          -- Cursor to get the detail AP balance
          --
            CURSOR ap_supplier_contact_addrs_cur
            IS
                  --
                  --
                  SELECT  'CREATE'                                                          AS import_action 
                         ,xssv.vendor_id                                                    AS supplier_id
                         ,xssv.vendor_name                                                  AS supplier_name
                         ,assa.vendor_site_id                                               AS supplier_site_id
--                         ,assa.vendor_site_code                                             AS address_name
                         ,decode(assa.org_id,142,substr(assa.vendor_site_id||'-'||assa.vendor_site_code,1,15),assa.vendor_site_code) AS address_name                         
                         ,person_party.person_first_name                                    AS first_name
                         ,person_party.person_last_name                                     AS last_name
                         ,apsc.email_address                                                AS email_address
                  FROM    xxmx_supplier_scope_v                         xssv
                         ,apps.ap_supplier_sites_all@MXDM_NVIS_EXTRACT  assa
                         ,apps.hz_parties@MXDM_NVIS_EXTRACT             person_party
                         ,apps.hz_parties@MXDM_NVIS_EXTRACT             relationship_party
                         ,apps.ap_supplier_contacts@MXDM_NVIS_EXTRACT   apsc
                  WHERE   1 = 1
                  AND     assa.org_id                                        = xssv.org_id
                  AND     assa.vendor_id                                     = xssv.vendor_id
                  AND     assa.vendor_site_id                                = xssv.vendor_site_id
                  AND     apsc.vendor_site_id(+)                             = assa.vendor_site_id
                  AND     apsc.org_party_site_id(+)                          = assa.party_site_id
                  AND     NVL(TRUNC(apsc.inactive_date), TRUNC(SYSDATE) + 1) > TRUNC(SYSDATE)
                  AND     person_party.party_id                              = apsc.per_party_id
                  AND     relationship_party.party_id                        = apsc.rel_party_id;
              --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_contact_addrs_tt IS TABLE OF ap_supplier_contact_addrs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName           CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_contact_addrs_stg';
          ct_StgSchema                CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                 CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_cont_addrs_stg';
          ct_Phase                    CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
           ap_supplier_contact_addrs_tbl  ap_supplier_contact_addrs_tt;
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN ap_supplier_contact_addrs_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    --
                    FETCH         ap_supplier_contact_addrs_cur
                    BULK COLLECT
                    INTO          ap_supplier_contact_addrs_tbl
                    LIMIT         XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supplier_contact_addrs_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..ap_supplier_contact_addrs_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_cont_addrs_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,import_action
                                   ,supplier_id
                                   ,supplier_name
                                   ,supplier_site_id
                                   ,address_name
                                   ,first_name
                                   ,last_name
                                   ,email_address
                                   )
                         VALUES
                                   (
                                    pt_i_MigrationSetID                               --MIGRATION_SET_ID
                                   ,gvt_MigrationSetName                               --MIGRATION_SET_NAME
                                   ,'EXTRACTED'
                                   ,ap_supplier_contact_addrs_tbl(i).import_action
                                   ,ap_supplier_contact_addrs_tbl(i).supplier_id
                                   ,ap_supplier_contact_addrs_tbl(i).supplier_name
                                   ,ap_supplier_contact_addrs_tbl(i).supplier_site_id
                                   ,ap_supplier_contact_addrs_tbl(i).address_name
                                   ,ap_supplier_contact_addrs_tbl(i).first_name
                                   ,ap_supplier_contact_addrs_tbl(i).last_name
                                   ,ap_supplier_contact_addrs_tbl(i).email_address
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_contact_addrs_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
               WHEN OTHERS
               THEN
                    --
                    IF   ap_supplier_contact_addrs_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_contact_addrs_cur;
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
     END ap_supplier_contact_addrs_stg;
     --
     --
     /*
     ************************************
     ** PROCEDURE: ap_supplier_payees_stg
     ************************************
     */
     --
     PROCEDURE ap_supplier_payees_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_payees_cur
                      (
                       pn_i_OrderOfPreferenceLimit     NUMBER
                      )
          IS
               --
               SELECT  DISTINCT
                       supplier_payees.temp_ext_payee_id             AS temp_ext_payee_id
                      ,supplier_payees.operating_unit_name           AS operating_unit_name
                      ,supplier_payees.vendor_code                   AS vendor_code
                      ,supplier_payees.vendor_site_code              AS vendor_site_code
                      ,supplier_payees.exclusive_payment_flag        AS exclusive_payment_flag
                      ,supplier_payees.default_payment_method_code   AS default_payment_method_code
                      ,supplier_payees.delivery_channel_code         AS delivery_channel_code
                      ,supplier_payees.settlement_priority           AS settlement_priority
                      ,supplier_payees.remit_advice_delivery_method  AS remit_advice_delivery_method
                      ,supplier_payees.remit_advice_email            AS remit_advice_email
                      ,supplier_payees.remit_advice_fax              AS remit_advice_fax
                      ,supplier_payees.bank_instruction1_code        AS bank_instruction1_code
                      ,supplier_payees.bank_instruction2_code        AS bank_instruction2_code
                      ,supplier_payees.bank_instruction_details      AS bank_instruction_details
                      ,supplier_payees.payment_reason_code           AS payment_reason_code
                      ,supplier_payees.payment_reason_comments       AS payment_reason_comments
                      ,supplier_payees.payment_text_message1         AS payment_text_message1
                      ,supplier_payees.payment_text_message2         AS payment_text_message2
                      ,supplier_payees.payment_text_message3         AS payment_text_message3
                      ,supplier_payees.bank_charge_bearer            AS bank_charge_bearer
                      ,supplier_payees.vendor_name                   AS supplier_name
               FROM   (
                       SELECT  iepa.ext_payee_id                  AS temp_ext_payee_id
                              ,NULL                               AS operating_unit_name
                              ,xssv.vendor_number                 AS vendor_code
                              ,NULL                               AS vendor_site_code
                              ,iepa.exclusive_payment_flag        AS exclusive_payment_flag
                              ,iepa.default_payment_method_code   AS default_payment_method_code
                              ,iepa.delivery_channel_code         AS delivery_channel_code
                              ,iepa.settlement_priority           AS settlement_priority
                              ,iepa.remit_advice_delivery_method  AS remit_advice_delivery_method
                              ,iepa.remit_advice_email            AS remit_advice_email
                              ,iepa.remit_advice_fax              AS remit_advice_fax
                              ,iepa.bank_instruction1_code        AS bank_instruction1_code
                              ,iepa.bank_instruction2_code        AS bank_instruction2_code
                              ,iepa.bank_instruction_details      AS bank_instruction_details
                              ,iepa.payment_reason_code           AS payment_reason_code
                              ,iepa.payment_reason_comments       AS payment_reason_comments
                              ,iepa.payment_text_message1         AS payment_text_message1
                              ,iepa.payment_text_message2         AS payment_text_message2
                              ,iepa.payment_text_message3         AS payment_text_message3
                              ,iepa.bank_charge_bearer            AS bank_charge_bearer
                              ,xssv.vendor_name                   AS vendor_name
                       FROM    xxmx_supplier_scope_v                           xssv
                              ,xxmx_iby_payee_bank_accts_v                     xipbav
                              ,apps.iby_external_payees_all@MXDM_NVIS_EXTRACT  iepa
                       WHERE   1 = 1
                       AND     xipbav.payee_party_id       = xssv.party_id
                       AND     xipbav.org_id              IS NULL                         /* Supplier Level Payee */         
                       AND     xipbav.supplier_site_id    IS NULL                         /* Supplier Level Payee */
                       AND     xipbav.order_of_preference <= pn_i_OrderOfPreferenceLimit
                       AND     iepa.ext_payee_id           = xipbav.ext_payee_id
                       UNION /* Does the outer query need a DISTINCT if this is a UNION and not UNION ALL? */
                       SELECT  iepa.ext_payee_id                  AS temp_ext_payee_id
                              ,xssv.operating_unit_name           AS operating_unit_name
                              ,xssv.vendor_number                 AS vendor_code
                              --,xssv.vendor_site_code              AS vendor_site_code
                              ,DECODE(
                                      xssv.org_id
                                           ,142 ,SUBSTR(xssv.vendor_site_id||'-'||xssv.vendor_site_code,1,15)
                                                ,xssv.vendor_site_code
                                     )                            AS vendor_site_code                              
                              ,iepa.exclusive_payment_flag        AS exclusive_payment_flag
                              ,iepa.default_payment_method_code   AS default_payment_method_code
                              ,iepa.delivery_channel_code         AS delivery_channel_code
                              ,iepa.settlement_priority           AS settlement_priority
                              ,iepa.remit_advice_delivery_method  AS remit_advice_delivery_method
                              ,iepa.remit_advice_email            AS remit_advice_email
                              ,iepa.remit_advice_fax              AS remit_advice_fax
                              ,iepa.bank_instruction1_code        AS bank_instruction1_code
                              ,iepa.bank_instruction2_code        AS bank_instruction2_code
                              ,iepa.bank_instruction_details      AS bank_instruction_details
                              ,iepa.payment_reason_code           AS payment_reason_code
                              ,iepa.payment_reason_comments       AS payment_reason_comments
                              ,iepa.payment_text_message1         AS payment_text_message1
                              ,iepa.payment_text_message2         AS payment_text_message2
                              ,iepa.payment_text_message3         AS payment_text_message3
                              ,iepa.bank_charge_bearer            AS bank_charge_bearer
                              ,xssv.vendor_name                   AS vendor_name
                       FROM    xxmx_supplier_scope_v                           xssv
                              ,xxmx_iby_payee_bank_accts_v                     xipbav
                              ,apps.iby_external_payees_all@MXDM_NVIS_EXTRACT  iepa
                       WHERE   1 = 1
                       AND     xipbav.payee_party_id       = xssv.party_id
                       AND     xipbav.org_id               = xssv.org_id                  /* Supplier Site Level Payee */         
                       AND     xipbav.supplier_site_id     = xssv.vendor_site_id          /* Supplier Site Level Payee */
                       AND     xipbav.order_of_preference <= pn_i_OrderOfPreferenceLimit
                       AND     iepa.ext_payee_id           = xipbav.ext_payee_id
                      ) supplier_payees
                ORDER BY supplier_payees.temp_ext_payee_id;
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_payees_tt IS TABLE OF ap_supplier_payees_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_payees_stg';
          ct_StgSchema                    CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_payees_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_OrderOfPreferenceLimit       NUMBER;
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
          ap_supplier_payees_tbl  ap_supplier_payees_tt;
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
          --
          gvv_ProgressIndicator := '0010';
          --
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
               --
          END IF;
          --
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
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Retrieve the ORDER_OF_PREFERNCE_LIMIT parameter
               ** to restricte the Payment Instrument Uses retrieved
               ** in the extract Cursor.
               */
               --
               vn_OrderOfPreferenceLimit := xxmx_utilities_pkg.get_single_parameter_value
                                                  (
                                                   pt_i_ApplicationSuite => 'FIN'
                                                  ,pt_i_Application      => 'AP'
                                                  ,pt_i_BusinessEntity   => 'SUPPLIERS'
                                                  ,pt_i_SubEntity        => 'SUPPLIER_PMT_INSTRS'
                                                  ,pt_i_ParameterCode    => 'ORDER_OF_PREFERENCE_LIMIT'
                                                  );
               --
               IF   vn_OrderOfPreferenceLimit IS NULL
               THEN
                    --
                    vn_OrderOfPreferenceLimit := 0;
                    --
               END IF;
               --
               OPEN ap_supplier_payees_cur
                         (
                          vn_OrderOfPreferenceLimit
                         );
               --
               --
               gvv_ProgressIndicator := '0060';
               --
               --
               LOOP
                    --
                    --
                    FETCH ap_supplier_payees_cur
                    BULK COLLECT
                    INTO ap_supplier_payees_tbl
                    LIMIT XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    --
                    EXIT WHEN ap_supplier_payees_tbl.COUNT=0;
                    --
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    --
                    FORALL I
                    IN     1..ap_supplier_payees_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_payees_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,temp_ext_payee_id
                                   ,business_unit
                                   ,vendor_code
                                   ,vendor_site_code
                                   ,exclusive_payment_flag
                                   ,default_payment_method_code
                                   ,delivery_channel_code
                                   ,settlement_priority
                                   ,remit_advice_delivery_method
                                   ,remit_advice_email
                                   ,remit_advice_fax
                                   ,bank_instruction1_code
                                   ,bank_instruction2_code
                                   ,bank_instruction_details
                                   ,payment_reason_code
                                   ,payment_reason_comments
                                   ,payment_text_message1
                                   ,payment_text_message2
                                   ,payment_text_message3
                                   ,bank_charge_bearer
                                   ,supplier_name
                                   )
                         VALUES    (
                                    pt_i_MigrationSetID                                     -- migration_set_id
                                   ,gvt_MigrationSetName                                    -- migration_set_name
                                   ,'EXTRACTED'                                             -- migration_status
                                   ,ap_supplier_payees_tbl(i).temp_ext_payee_id             -- temp_ext_payee_id
                                   ,ap_supplier_payees_tbl(i).operating_unit_name           -- business_unit
                                   ,ap_supplier_payees_tbl(i).vendor_code                   -- vendor_code
                                   ,ap_supplier_payees_tbl(i).vendor_site_code              -- vendor_site_code
                                   ,ap_supplier_payees_tbl(i).exclusive_payment_flag        -- exclusive_payment_flag
                                   ,ap_supplier_payees_tbl(i).default_payment_method_code   -- default_payment_method_code
                                   ,ap_supplier_payees_tbl(i).delivery_channel_code         -- delivery_channel_code
                                   ,ap_supplier_payees_tbl(i).settlement_priority           -- settlement_priority
                                   ,ap_supplier_payees_tbl(i).remit_advice_delivery_method  -- remit_advice_delivery_method
                                   ,ap_supplier_payees_tbl(i).remit_advice_email            -- remit_advice_email
                                   ,ap_supplier_payees_tbl(i).remit_advice_fax              -- remit_advice_fax
                                   ,ap_supplier_payees_tbl(i).bank_instruction1_code        -- bank_instruction1_code
                                   ,ap_supplier_payees_tbl(i).bank_instruction2_code        -- bank_instruction2_code
                                   ,ap_supplier_payees_tbl(i).bank_instruction_details      -- bank_instruction_details
                                   ,ap_supplier_payees_tbl(i).payment_reason_code           -- payment_reason_code
                                   ,ap_supplier_payees_tbl(i).payment_reason_comments       -- payment_reason_comments
                                   ,ap_supplier_payees_tbl(i).payment_text_message1         -- payment_text_message1
                                   ,ap_supplier_payees_tbl(i).payment_text_message2         -- payment_text_message2
                                   ,ap_supplier_payees_tbl(i).payment_text_message3         -- payment_text_message3
                                   ,ap_supplier_payees_tbl(i).bank_charge_bearer            -- bank_charge_bearer
                                   ,ap_supplier_payees_tbl(i).supplier_name                 -- supplier_name
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_payees_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
                    IF   ap_supplier_payees_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_payees_cur;
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
     END ap_supplier_payees_stg;
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_bank_accts_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_bank_accts_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_bank_accts_cur
                      (
                       pt_MigrationSetID             xxmx_ap_supp_payees_stg.migration_set_id%TYPE
                      ,pn_OrderOfPreferenceLimit     NUMBER
                      )
          IS
               --
               WITH payee_bank_accounts
               AS
                    (
                     SELECT    DISTINCT
                               xipbav.ext_payee_id
                              ,xipbav.ext_bank_account_id
                              ,xipbav.org_id
                     FROM      xxmx_ap_supp_payees_stg      xasps
                              ,xxmx_iby_payee_bank_accts_v  xipbav
                     WHERE     1 = 1
                     AND       xasps.migration_set_id      = pt_MigrationSetID
                     AND       xipbav.ext_payee_id         = xasps.temp_ext_payee_id
                     AND       xipbav.order_of_preference <= pn_OrderOfPreferenceLimit
                    )
               SELECT  DISTINCT
                       pba.ext_payee_id                                            AS temp_ext_party_id
                      --,TO_NUMBER(ieba.ext_bank_account_id||iepa.supplier_site_id)
                      ,TO_NUMBER(
                                 pba.ext_payee_id
                               ||pba.ext_bank_account_id
                               ||pba.org_id
                                )                                                  AS temp_ext_bank_acct_id 
                      ,cbbv.bank_name                                              AS bank_name
                      ,cbbv.bank_branch_name                                       AS branch_name
                      ,CASE
                            WHEN INSTR(cbbv.branch_number, '-') > 0
                                 THEN REPLACE(cbbv.branch_number, '-', '')
                            ELSE cbbv.branch_number
                       END                                                         AS xxmx_branch_number
                      ,ieba.country_code                                           AS country_code
                      ,ieba.bank_account_name                                      AS bank_account_name
                      ,ieba.bank_account_num                                       AS bank_account_num
                      ,ieba.currency_code                                          AS currency_code
                      ,ieba.foreign_payment_use_flag                               AS foreign_payment_use_flag
                      ,ieba.start_date                                             AS start_date
                      ,ieba.end_date                                               AS end_date
                      ,ieba.iban                                                   AS iban
                      ,ieba.check_digits                                           AS check_digits
                      ,ieba.bank_account_name_alt                                  AS bank_account_name_alt
                      ,ieba.bank_account_type                                      AS bank_account_type
                      ,ieba.account_suffix                                         AS account_suffix
                      ,ieba.description                                            AS description
                      ,ieba.agency_location_code                                   AS agency_location_code
                      ,ieba.exchange_rate_agreement_num                            AS exchange_rate_agreement_num
                      ,ieba.exchange_rate_agreement_type                           AS exchange_rate_agreement_type
                      ,ieba.exchange_rate                                          AS exchange_rate
                      ,ieba.secondary_account_reference                            AS secondary_account_reference
                      ,ieba.attribute_category                                     AS attribute_category
                      ,ieba.attribute1                                             AS attribute1
                      ,ieba.attribute2                                             AS attribute2
                      ,ieba.attribute3                                             AS attribute3
                      ,ieba.attribute4                                             AS attribute4
                      ,ieba.attribute5                                             AS attribute5
                      ,ieba.attribute6                                             AS attribute6
                      ,ieba.attribute7                                             AS attribute7
                      ,ieba.attribute8                                             AS attribute8
                      ,ieba.attribute9                                             AS attribute9
                      ,ieba.attribute10                                            AS attribute10
                      ,ieba.attribute11                                            AS attribute11
                      ,ieba.attribute12                                            AS attribute12
                      ,ieba.attribute13                                            AS attribute13
                      ,ieba.attribute14                                            AS attribute14
                      ,ieba.attribute15                                            AS attribute15
                      ,NULL                                                        AS operating_unit_name
               FROM    payee_bank_accounts                           pba
                      ,apps.iby_ext_bank_accounts@MXDM_NVIS_EXTRACT  ieba
                      ,apps.ce_bank_branches_v@MXDM_NVIS_EXTRACT     cbbv
               WHERE   1 = 1
               AND     ieba.ext_bank_account_id = pba.ext_bank_account_id
               AND     cbbv.pk_id               = ieba.branch_id
               ORDER BY pba.ext_payee_id
                       ,TO_NUMBER(
                                  pba.ext_payee_id
                                ||pba.ext_bank_account_id
                                ||pba.org_id
                                 );
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_bank_accts_tt IS TABLE OF ap_supplier_bank_accts_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_bank_accts_stg';
          ct_StgSchema                    CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_bank_accts_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_OrderOfPreferenceLimit       NUMBER;
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
          ap_supplier_bank_accts_tbl  ap_supplier_bank_accts_tt;
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Retrieve the ORDER_OF_PREFERNCE_LIMIT parameter
               ** to restricte the Payment Instrument Uses retrieved
               ** in the extract Cursor.
               */
               --
               vn_OrderOfPreferenceLimit := xxmx_utilities_pkg.get_single_parameter_value
                                                  (
                                                   pt_i_ApplicationSuite => 'FIN'
                                                  ,pt_i_Application      => 'AP'
                                                  ,pt_i_BusinessEntity   => 'SUPPLIERS'
                                                  ,pt_i_SubEntity        => 'SUPPLIER_PMT_INSTRS'
                                                  ,pt_i_ParameterCode    => 'ORDER_OF_PREFERENCE_LIMIT'
                                                  );
               --
               IF   vn_OrderOfPreferenceLimit IS NULL
               THEN
                    --
                    vn_OrderOfPreferenceLimit := 0;
                    --
               END IF;
               --
               OPEN ap_supplier_bank_accts_cur
                         (
                          pt_i_MigrationSetID
                         ,vn_OrderOfPreferenceLimit
                         );
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH ap_supplier_bank_accts_cur
                    BULK COLLECT
                    INTO ap_supplier_bank_accts_tbl
                    LIMIT XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN ap_supplier_bank_accts_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..ap_supplier_bank_accts_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_bank_accts_stg
                              (
                               migration_set_id
                              ,migration_set_name
                              ,migration_status
                              ,temp_ext_party_id
                              ,temp_ext_bank_acct_id
                              ,bank_name
                              ,branch_name
                              ,xxmx_branch_number
                              ,country_code
                              ,bank_account_name
                              ,bank_account_num
                              ,currency_code
                              ,foreign_payment_use_flag
                              ,start_date
                              ,end_date
                              ,iban
                              ,check_digits
                              ,bank_account_name_alt
                              ,bank_account_type
                              ,account_suffix
                              ,description
                              ,agency_location_code
                              ,exchange_rate_agreement_num
                              ,exchange_rate_agreement_type
                              ,exchange_rate
                              ,secondary_account_reference
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
                              ,ou_name
                              )
                         VALUES
                              (
                               pt_i_MigrationSetID                                         -- migration_set_id
                              ,gvt_MigrationSetName                                        -- migration_set_name
                              ,'EXTRACTED'                                                 -- migration_status
                              ,ap_supplier_bank_accts_tbl(i).temp_ext_party_id             -- temp_ext_party_id
                              ,ap_supplier_bank_accts_tbl(i).temp_ext_bank_acct_id         -- temp_ext_bank_acct_id
                              ,ap_supplier_bank_accts_tbl(i).bank_name                     -- bank_name
                              ,ap_supplier_bank_accts_tbl(i).branch_name                   -- branch_name
                              ,ap_supplier_bank_accts_tbl(i).xxmx_branch_number            -- xxmx_branch_number
                              ,ap_supplier_bank_accts_tbl(i).country_code                  -- country_code
                              ,ap_supplier_bank_accts_tbl(i).bank_account_name             -- bank_account_name
                              ,ap_supplier_bank_accts_tbl(i).bank_account_num              -- bank_account_num
                              ,ap_supplier_bank_accts_tbl(i).currency_code                 -- currency_code
                              ,ap_supplier_bank_accts_tbl(i).foreign_payment_use_flag      -- foreign_payment_use_flag
                              ,ap_supplier_bank_accts_tbl(i).start_date                    -- start_date
                              ,ap_supplier_bank_accts_tbl(i).end_date                      -- end_date
                              ,ap_supplier_bank_accts_tbl(i).iban                          -- iban
                              ,ap_supplier_bank_accts_tbl(i).check_digits                  -- check_digits
                              ,ap_supplier_bank_accts_tbl(i).bank_account_name_alt         -- bank_account_name_alt
                              ,ap_supplier_bank_accts_tbl(i).bank_account_type             -- bank_account_type
                              ,ap_supplier_bank_accts_tbl(i).account_suffix                -- account_suffix
                              ,ap_supplier_bank_accts_tbl(i).description                   -- description
                              ,ap_supplier_bank_accts_tbl(i).agency_location_code          -- agency_location_code
                              ,ap_supplier_bank_accts_tbl(i).exchange_rate_agreement_num   -- exchange_rate_agreement_num
                              ,ap_supplier_bank_accts_tbl(i).exchange_rate_agreement_type  -- exchange_rate_agreement_type
                              ,ap_supplier_bank_accts_tbl(i).exchange_rate                 -- exchange_rate
                              ,ap_supplier_bank_accts_tbl(i).secondary_account_reference   -- secondary_account_reference
                              ,ap_supplier_bank_accts_tbl(i).attribute_category            -- attribute_category
                              ,ap_supplier_bank_accts_tbl(i).attribute1                    -- attribute1
                              ,ap_supplier_bank_accts_tbl(i).attribute2                    -- attribute2
                              ,ap_supplier_bank_accts_tbl(i).attribute3                    -- attribute3
                              ,ap_supplier_bank_accts_tbl(i).attribute4                    -- attribute4
                              ,ap_supplier_bank_accts_tbl(i).attribute5                    -- attribute5
                              ,ap_supplier_bank_accts_tbl(i).attribute6                    -- attribute6
                              ,ap_supplier_bank_accts_tbl(i).attribute7                    -- attribute7
                              ,ap_supplier_bank_accts_tbl(i).attribute8                    -- attribute8
                              ,ap_supplier_bank_accts_tbl(i).attribute9                    -- attribute9
                              ,ap_supplier_bank_accts_tbl(i).attribute10                   -- attribute10
                              ,ap_supplier_bank_accts_tbl(i).attribute11                   -- attribute11
                              ,ap_supplier_bank_accts_tbl(i).attribute12                   -- attribute12
                              ,ap_supplier_bank_accts_tbl(i).attribute13                   -- attribute13
                              ,ap_supplier_bank_accts_tbl(i).attribute14                   -- attribute14
                              ,ap_supplier_bank_accts_tbl(i).attribute15                   -- attribute15
                              ,ap_supplier_bank_accts_tbl(i).operating_unit_name           -- operating_unit_name
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_bank_accts_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
               WHEN OTHERS
               THEN
                    --
                    IF   ap_supplier_bank_accts_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_bank_accts_cur;
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
     END ap_supplier_bank_accts_stg;
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_pmt_instrs_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_pmt_instrs_stg
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
          -- Cursor to get the detail AP balance
          --
          CURSOR ap_supplier_pmt_instrs_cur
                      (
                       pt_MigrationSetID             xxmx_ap_supp_payees_stg.migration_set_id%TYPE 
                      ,pn_OrderOfPreferenceLimit     NUMBER
                      )
          IS
               --
               SELECT  DISTINCT
                       supplier_pmt_instr_uses.temp_ext_party_id                                           AS temp_ext_party_id
                      ,supplier_pmt_instr_uses.temp_ext_bank_acct_id                                       AS temp_ext_bank_acct_id
                      ,supplier_pmt_instr_uses.temp_pmt_instr_use_id                                       AS temp_pmt_instr_use_id
                      ,DECODE(
                              ROW_NUMBER() OVER (
                                                 PARTITION BY supplier_pmt_instr_uses.temp_ext_party_id
                                                             ,supplier_pmt_instr_uses.temp_ext_bank_acct_id
                                                 ORDER BY     supplier_pmt_instr_uses.temp_ext_party_id     DESC
                                                             ,supplier_pmt_instr_uses.temp_ext_bank_acct_id DESC
                                                             ,supplier_pmt_instr_uses.temp_pmt_instr_use_id DESC
                                                )
                              ,1 ,'Y'
                                 ,'N'                                                                      /* ISV 06/05/2021 : Replaced NULL with 'N' as primary flag is mandatory in Fusion */
                             )                                                                             AS primary_flag
                      ,supplier_pmt_instr_uses.acct_assig_start_date                                       AS acct_assig_start_date
                      ,supplier_pmt_instr_uses.acct_assig_end_date                                         AS acct_assig_end_date
                      ,supplier_pmt_instr_uses.operating_unit_name
               FROM   (
                       WITH payee_pmnt_instr_uses
                       AS
                            (
                             SELECT    DISTINCT
                                       xipbav.ext_payee_id
                                      ,xipbav.ext_bank_account_id
                                      ,xipbav.org_id
                                      ,xipbav.instrument_payment_use_id
                             FROM      xxmx_ap_supp_payees_stg      xasps
                                      ,xxmx_iby_payee_bank_accts_v  xipbav
                             WHERE     1 = 1
                             AND       xasps.migration_set_id      = pt_MigrationSetID
                             AND       xipbav.ext_payee_id         = xasps.temp_ext_payee_id
                             AND       xipbav.order_of_preference <= pn_OrderOfPreferenceLimit
                            )
                       SELECT  ipiua.ext_pmt_party_id                         AS temp_ext_party_id
                              --,TO_NUMBER(ieba.ext_bank_account_id||iepa.supplier_site_id)
                              ,TO_NUMBER(
                                         ppiu.ext_payee_id
                                       ||ppiu.ext_bank_account_id
                                       ||ppiu.org_id
                                        )                                     AS temp_ext_bank_acct_id
                              ,ipiua.instrument_payment_use_id                AS temp_pmt_instr_use_id
                              ,NULL                                           AS primary_flag
                              ,ipiua.start_date                               AS acct_assig_start_date
                              ,ipiua.end_date                                 AS acct_assig_end_date
                              ,NULL                                           AS operating_unit_name
                       FROM    payee_pmnt_instr_uses                          ppiu
                              ,apps.iby_pmt_instr_uses_all@MXDM_NVIS_EXTRACT  ipiua
                       WHERE   1 = 1
                       AND     ipiua.ext_pmt_party_id           = ppiu.ext_payee_id
                       AND     ipiua.instrument_id              = ppiu.ext_bank_account_id
                       AND     ipiua.instrument_payment_use_id  = ppiu.instrument_payment_use_id
                      ) supplier_pmt_instr_uses
               ORDER BY  supplier_pmt_instr_uses.temp_ext_party_id
                        ,supplier_pmt_instr_uses.temp_ext_bank_acct_id
                        ,supplier_pmt_instr_uses.temp_pmt_instr_use_id;
               --
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE ap_supplier_pmt_instrs_tt IS TABLE OF ap_supplier_pmt_instrs_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supplier_pmt_instrs_stg';
          ct_StgSchema                    CONSTANT  VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_pmt_instrs_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_OrderOfPreferenceLimit       NUMBER;
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
          ap_supplier_pmt_instrs_tbl  ap_supplier_pmt_instrs_tt;
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
          --
          gvv_ProgressIndicator := '0010';
          --
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
               --
          END IF;
          --
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
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
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
                                             ||'":'
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Retrieve the ORDER_OF_PREFERNCE_LIMIT parameter
               ** to restricte the Payment Instrument Uses retrieved
               ** in the extract Cursor.
               */
               --
               vn_OrderOfPreferenceLimit := xxmx_utilities_pkg.get_single_parameter_value
                                                  (
                                                   pt_i_ApplicationSuite => 'FIN'
                                                  ,pt_i_Application      => 'AP'
                                                  ,pt_i_BusinessEntity   => 'SUPPLIERS'
                                                  ,pt_i_SubEntity        => 'SUPPLIER_PMT_INSTRS'
                                                  ,pt_i_ParameterCode    => 'ORDER_OF_PREFERENCE_LIMIT'
                                                  );
               --
               IF   vn_OrderOfPreferenceLimit IS NULL
               THEN
                    --
                    vn_OrderOfPreferenceLimit := 0;
                    --
               END IF;
               --
               OPEN ap_supplier_pmt_instrs_cur
                         (
                          pt_i_MigrationSetID
                         ,vn_OrderOfPreferenceLimit
                         );
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    --
                    FETCH         ap_supplier_pmt_instrs_cur
                    BULK COLLECT
                    INTO          ap_supplier_pmt_instrs_tbl
                    LIMIT         XXMX_UTILITIES_PKG.gcn_BulkCollectLimit;
                    --
                    --
                    EXIT WHEN ap_supplier_pmt_instrs_tbl.COUNT=0;
                    --
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    --
                    FORALL I
                    IN     1..ap_supplier_pmt_instrs_tbl.COUNT
                         --
                         INSERT
                         INTO  xxmx_ap_supp_pmt_instrs_stg
                                   (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,temp_ext_party_id
                                   ,temp_ext_bank_acct_id
                                   ,temp_pmt_instr_use_id
                                   ,primary_flag
                                   ,acct_assig_start_date
                                   ,acct_assig_end_date
                                   ,ou_name
                                   )
                         VALUES  (
                                   pt_i_MigrationSetID                                   -- migration_set_id
                                   ,gvt_MigrationSetName                                 -- migration_set_name
                                   ,'EXTRACTED'                                          -- migration_status
                                   ,ap_supplier_pmt_instrs_tbl(i).temp_ext_party_id      -- temp_ext_party_id
                                   ,ap_supplier_pmt_instrs_tbl(i).temp_ext_bank_acct_id  -- temp_ext_bank_acct_id
                                   ,ap_supplier_pmt_instrs_tbl(i).temp_pmt_instr_use_id  -- temp_pmt_instr_use_id
                                   ,ap_supplier_pmt_instrs_tbl(i).primary_flag           -- primary_flag
                                   ,ap_supplier_pmt_instrs_tbl(i).acct_assig_start_date  -- acct_assig_start_date
                                   ,ap_supplier_pmt_instrs_tbl(i).acct_assig_end_date    -- acct_assig_end_date
                                   ,ap_supplier_pmt_instrs_tbl(i).operating_unit_name    -- operating_unit_name
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
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE ap_supplier_pmt_instrs_cur;
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
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
                    IF   ap_supplier_pmt_instrs_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_pmt_instrs_cur;
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
                    IF   ap_supplier_pmt_instrs_cur%ISOPEN
                    THEN
                         --
                         CLOSE ap_supplier_pmt_instrs_cur;
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
     END ap_supplier_pmt_instrs_stg;
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
          --** ISV 21/10/2020 - Removed Sequence Numbers and Stg Table as they no longer need to be passed as parameters.
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
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
          --** ISV 21/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and 
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
          --      pt_i_ApplicationSuite    => gct_ApplicationSuite
          --     ,pt_i_Application         => gct_Application
          --     ,pt_i_BusinessEntity      => gct_BusinessEntity
          --     ,pt_i_SubEntity => ct_SubEntity
          --     ,pt_i_Phase               => ct_Phase
          --     ,pt_i_Severity            => 'NOTIFICATION'
          --     ,pt_i_PackageName         => gct_PackageName
          --     ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
          --     ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
          --     ,pt_i_ModuleMessage       => '- '
          --                                ||pt_i_ClientCode
          --                                ||' Client Config Parameter "'
          --                                ||vt_ConfigParameter
          --                                ||'" = '
          --                                ||vt_ClientSchemaName
          --     ,pt_i_OracleError         => NULL
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
          --
          --** DH  20/04/2021 - call custom package for any customisations to be processed.
          --
          xxmx_utilities_pkg.log_module_message
          (
              pt_i_ApplicationSuite    => gct_ApplicationSuite
             ,pt_i_Application         => gct_Application
             ,pt_i_BusinessEntity      => gct_BusinessEntity
             ,pt_i_SubEntity           => ct_SubEntity
             ,pt_i_MigrationSetID      => vt_MigrationSetID
             ,pt_i_Phase               => ct_Phase
             ,pt_i_PackageName         => gct_PackageName
             ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => 'Calling procedure "'
                                          ||'xxmx_suppliers_cm_pkg'
                                          ||'.'
                                          ||'upd_supplier_dffs_stg'
                                          ||'".'
             ,pt_i_OracleError       => NULL
          );
          --
          --               
          --xxmx_suppliers_cm_pkg.upd_supplier_dffs_stg(vt_MigrationSetID);
          --
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
     END stg_main;
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
          --** ISV 21/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and 
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
END xxmx_supplier_pkg;
/

SHOW ERRORS PACKAGE BODY xxmx_supplier_pkg;
/
