create or replace PACKAGE BODY XXMX_CUSTOMER_TAX_PROFILE_PKG AS
-- =============================================================================
-- | VERSION1 |
-- =============================================================================
--
-- PACKAGE
-- XXMX_CUSTOMER_TAX_PROFILE_PKG
--
-- DESCRIPTION
-- Extract CUSTOMER Tax informationt
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ---------------------------
-- 10/11/2022 Michal Arrowsmith Replace ROUNDING_LEVEL_CODE with null as it is 
--                              no longer used in the tax registration FBDI 
--                              spreadsheet as per SR 3-31107730141
--                              Remove decode from the following fields as they
--                              will be transformed in Gate2 to  allow the 
--                              comparison to EBS to be possitive
--                              PROCESS_FOR_APPLICABILITY_FLAG
--                              INCLUSIVE_TAX_FLAG
-- 21/11/2022 Michal Arrowsmith Remove the decode from the column
--                              DEFAULT_REGISTRATION_FLAG
-- 24/04/2023 Michal Arrowsmith Procedure party_tax_classific_stg:
--                              Add the condition below to restrict the active tax classification
--                              AND     nvl(hzca.END_DATE_ACTIVE,sysdate+10)     > sysdate                
--                               
-- 01/09/2023 Michal Arrowsmith Procedure xxmx_zx_tax_registration_stg added to the where clause
--                                      and     zxptp.PARTY_TYPE_CODE       = 'THIRD_PARTY_SITE';
--                              See Jira 19491
--                              
--                              
--                              
-- =============================================================================
--
--
--     **********************
--     ** Global Declarations
--     **********************
--
--
--     **********************
--     ** Maximise Integration Globals
--     **********************
--
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_customer_tax_profile_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'ZX';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CUSTOMERS TAX';
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variable for Migration Set Name */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
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
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                                       NUMBER;
     --
     /*
     **************************************************************************************************************************
     ** PROCEDURE: party_tax_profile_stg
     **************************************************************************************************************************
     */
    -- ---------------------------------------------------------------------- --
    -- PROCEDURE: party_tax_profile_stg
    -- ---------------------------------------------------------------------- --
PROCEDURE party_tax_profile_stg
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
          --
    CURSOR party_tax_profile_cur is
        SELECT  DISTINCT
             'Customer site'                                  as PARTY_TYPE_CODE
            ,scope.party_site_number                             as PARTY_NUMBER
            ,scope.party_name                                      as PARTY_NAME
            --,decode(zxptp.PROCESS_FOR_APPLICABILITY_FLAG,
            --    'Y','Yes','N','No',
            --    zxptp.PROCESS_FOR_APPLICABILITY_FLAG) as PROCESS_FOR_APPLICABILITY_FLAG
            ,zxptp.PROCESS_FOR_APPLICABILITY_FLAG  as PROCESS_FOR_APPLICABILITY_FLAG
            --,decode(zxptp.ROUNDING_LEVEL_CODE,
            --   'HEADER','Header','DOWN','Down',
            --   zxptp.ROUNDING_LEVEL_CODE)               as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_LEVEL_CODE                    as ROUNDING_LEVEL_CODE
            -- MA 06-12-2022 remove decode
            --,decode(zxptp.ROUNDING_RULE_CODE,
            --    'UP','Up','DOWN','Down',
            --    zxptp.ROUNDING_RULE_CODE)                as ROUNDING_RULE_CODE
            ,zxptp.ROUNDING_RULE_CODE                      as ROUNDING_RULE_CODE
            ,zxptp.TAX_CLASSIFICATION_CODE            as TAX_CLASSIFICATION_CODE
            --,decode(zxptp.INCLUSIVE_TAX_FLAG,
            --    'Y','Yes','N','No',
            --    zxptp.INCLUSIVE_TAX_FLAG)                as INCLUSIVE_TAX_FLAG
            ,zxptp.INCLUSIVE_TAX_FLAG                      as INCLUSIVE_TAX_FLAG
            ,zxptp.allow_offset_tax_flag                   as ALLOW_OFFSET_TAX_FLAG
            ,zxptp.COUNTRY_CODE                                  as COUNTRY_CODE
            ,zxptp.REGISTRATION_TYPE_CODE              as REGISTRATION_TYPE_CODE
            ,zxptp.REP_REGISTRATION_NUMBER            as REP_REGISTRATION_NUMBER
                FROM 
                     ZX_REGISTRATIONS@xxmx_extract       zxr,
                     ZX_PARTY_TAX_PROFILE@xxmx_extract   zxptp,
                     XXMX_CUSTOMER_SCOPE_T               scope
                WHERE zxr.EFFECTIVE_TO              IS NULL
                AND zxr.PARTY_TAX_PROFILE_ID    = zxptp.PARTY_TAX_PROFILE_ID
                AND zxptp.PARTY_ID              = scope.party_site_id
        UNION
         SELECT  DISTINCT
             'Customer site'                                  as PARTY_TYPE_CODE
            ,scope.party_site_number                             as PARTY_NUMBER
            ,scope.party_name                                      as PARTY_NAME
            ,zxptp.PROCESS_FOR_APPLICABILITY_FLAG  as PROCESS_FOR_APPLICABILITY_FLAG
            ,zxptp.ROUNDING_LEVEL_CODE                    as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_RULE_CODE                      as ROUNDING_RULE_CODE
            ,zxptp.TAX_CLASSIFICATION_CODE            as TAX_CLASSIFICATION_CODE
            ,zxptp.INCLUSIVE_TAX_FLAG                      as INCLUSIVE_TAX_FLAG
            ,zxptp.allow_offset_tax_flag                   as ALLOW_OFFSET_TAX_FLAG
            ,zxptp.COUNTRY_CODE                                  as COUNTRY_CODE
            ,zxptp.REGISTRATION_TYPE_CODE              as REGISTRATION_TYPE_CODE
            ,zxptp.REP_REGISTRATION_NUMBER            as REP_REGISTRATION_NUMBER
                FROM 
                     ZX_PARTY_TAX_PROFILE@xxmx_extract   zxptp,
                     XXMX_CUSTOMER_SCOPE_T               scope
                WHERE 1=1
                AND zxptp.PARTY_ID              = scope.party_site_id
                AND PARTY_TYPE_CODE = 'THIRD_PARTY_SITE'
                AND zxptp.REP_REGISTRATION_NUMBER IS NOT NULL
                ;
          --
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE party_tax_profile_tt    IS TABLE OF party_tax_profile_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'party_tax_profile_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_tax_profile_stg';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
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
          party_tax_profile_tbl                       party_tax_profile_tt;
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
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
          --
          gvv_ProgressIndicator := '0010';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
          gvv_ProgressIndicator := '0020';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          -- Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          -- If the Migration Set Name is NULL then the Migration has not been initialized.
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
    select  /*+ driving_site(zxptp) */ count(*)
        into gvn_RowCount
        FROM 
            ZX_REGISTRATIONS@xxmx_extract       zxr,
            ZX_PARTY_TAX_PROFILE@xxmx_extract   zxptp,
            XXMX_CUSTOMER_SCOPE_T               scope,
            apps.hz_party_sites@xxmx_extract    hps
        WHERE zxr.EFFECTIVE_TO              IS NULL
        AND zxr.PARTY_TAX_PROFILE_ID    = zxptp.PARTY_TAX_PROFILE_ID
        AND zxptp.PARTY_ID              = scope.party_site_id
        and scope.party_site_id         = hps.party_site_id;
    --
    xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data total="'||to_char(gvn_RowCount)||'".'
                    ,pt_i_OracleError       => NULL
                    );
    --
    OPEN party_tax_profile_cur;
    --
    LOOP
        --
        gvv_ProgressIndicator := '0070';
        --
        FETCH party_tax_profile_cur
            BULK    COLLECT
            INTO    party_tax_profile_tbl
            LIMIT   xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - XXX='||party_tax_profile_tbl.COUNT
                    ,pt_i_OracleError       => NULL
                    );
        --
        EXIT WHEN party_tax_profile_tbl.COUNT = 0;
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - YYY='||party_tax_profile_tbl.COUNT
                    ,pt_i_OracleError       => NULL
                    );
            gvv_ProgressIndicator := '0080';
            --
            FORALL i IN 1..party_tax_profile_tbl.COUNT
            --FOR i IN 1..party_tax_profile_tbl.COUNT LOOP
                INSERT INTO xxmx_stg.xxmx_zx_tax_profile_stg
                (
                                         migration_set_id
                                        ,file_set_id
                                        ,migration_set_name
                                        ,migration_status
                                        ,PARTY_NUMBER
                                        ,PARTY_NAME
                                        ,PARTY_TYPE_CODE
                                        ,PROCESS_FOR_APPLICABILITY_FLAG
                                        ,ROUNDING_LEVEL_CODE
                                        ,ROUNDING_RULE_CODE
                                        ,TAX_CLASSIFICATION_CODE
                                        ,INCLUSIVE_TAX_FLAG
                                        ,ALLOW_OFFSET_TAX_FLAG
                                        ,COUNTRY_CODE
                                        ,REGISTRATION_TYPE_CODE
                                        ,REP_REGISTRATION_NUMBER
                )
                VALUES
                (
                                        pt_i_MigrationSetID
                                       ,59
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
                                       ,party_tax_profile_tbl(i).party_number
                                       ,party_tax_profile_tbl(i).party_name
                                       ,party_tax_profile_tbl(i).party_type_code
                                       ,party_tax_profile_tbl(i).PROCESS_FOR_APPLICABILITY_FLAG
                                       ,party_tax_profile_tbl(i).rounding_level_code
                                       ,party_tax_profile_tbl(i).rounding_rule_code
                                       ,party_tax_profile_tbl(i).TAX_CLASSIFICATION_CODE
                                       ,party_tax_profile_tbl(i).INCLUSIVE_TAX_FLAG
                                       ,party_tax_profile_tbl(i).ALLOW_OFFSET_TAX_FLAG
                                       ,party_tax_profile_tbl(i).COUNTRY_CODE
                                       ,party_tax_profile_tbl(i).REGISTRATION_TYPE_CODE
                                       ,party_tax_profile_tbl(i).REP_REGISTRATION_NUMBER
                );
            --END LOOP;
    END LOOP;
    --
    gvv_ProgressIndicator := '0090';
    --
    CLOSE party_tax_profile_cur;
    --
    gvv_ProgressIndicator := '0100';
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data total after="'||to_char(gvn_RowCount)||'".'
                    ,pt_i_OracleError       => NULL
                    );
    COMMIT;
    --
    xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               gvv_ProgressIndicator := '0110';
               --
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
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
                    --
                    IF   party_tax_profile_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_tax_profile_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END e_ModuleError Exception
               --
               --
               WHEN OTHERS
               THEN
                    --
                    --
                    IF   party_tax_profile_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_tax_profile_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END OTHERS Exception
               --
               --
          --** END Exception Handler
          --
          --
END party_tax_profile_stg;
--
--
PROCEDURE xxmx_zx_tax_registration_stg
(
     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
)
is
    --  **********************
    --  ** CURSOR Declarations
    --  **********************
    CURSOR party_tax_reg_cur is
        SELECT  DISTINCT
             scope.party_site_number                             as PARTY_NUMBER
            ,scope.party_name                                      as PARTY_NAME
            ,'Customer site'                                  as PARTY_TYPE_CODE
            ,zxptp.REP_REGISTRATION_NUMBER            as REP_REGISTRATION_NUMBER
            -- MA 27/07/2022 change to zxr instead of zxptp
            -- ,decode(zxr.ROUNDING_LEVEL_CODE,
            -- 'HEADER','Header',
            -- 'DOWN','Down',zxptp.ROUNDING_LEVEL_CODE)   as ROUNDING_LEVEL_CODE
            -- 10/11/2022 replace ROUNDING_LEVEL_CODE with null
            ,null                                         as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_RULE_CODE                      as ROUNDING_RULE_CODE
            ,zxptp.COUNTRY_CODE                                  as COUNTRY_CODE
            ,zxptp.TAX_CLASSIFICATION_CODE            as TAX_CLASSIFICATION_CODE
            ,zxptp.SELF_ASSESS_FLAG                          as SELF_ASSESS_FLAG
            ,''                                                  as SUPLIER_FLAG
            ,'Y'                                                as CUSTOMER_FLAG
            --,decode(zxptp.PROCESS_FOR_APPLICABILITY_FLAG,
            --    'Y','Yes',
            --    'N','No',
            --    zxptp.PROCESS_FOR_APPLICABILITY_FLAG) as PROCESS_FOR_APPLICABILITY_FLAG
            ,zxptp.PROCESS_FOR_APPLICABILITY_FLAG as PROCESS_FOR_APPLICABILITY_FLAG
            ,''                                         as ALLOW_OFFSET_TAX_FLAG
            ,''                                          as TRANSPORT_PRVDR_FLAG
            ,zxr.TAX_REGIME_CODE                              as TAX_REGIME_CODE
            ,zxr.TAX                                                 as TAX_CODE
            ,zxr.TAX_JURISDICTION_CODE                  as TAX_JURISDICTION_CODE
            ,zxr.REGISTRATION_TYPE_CODE                as REGISTRATION_TYPE_CODE
            --,decode(zxr.DEFAULT_REGISTRATION_FLAG,
            --    'Y','Yes',
            --    'N','No',
            --    zxr.DEFAULT_REGISTRATION_FLAG)    as DEFAULT_REGISTRATION_FLAG
            ,zxr.DEFAULT_REGISTRATION_FLAG          as DEFAULT_REGISTRATION_FLAG
            ,ZXR.REGISTRATION_NUMBER                      as REGISTRATION_NUMBER
            -- MA 21/03/2022 a validation when loading rejects the record as 
            -- the start date is before the party site/customer site creation_date
            -- ,zxr.EFFECTIVE_FROM                             as EFFECTIVE_FROM
            ,nvl(hps.start_date_active,hps.creation_date)      as EFFECTIVE_FROM
            ,zxr.EFFECTIVE_TO                                    as EFFECTIVE_TO
            -- MA 26/05/2022 add decode
            ,zxr.REGISTRATION_REASON_CODE            as REGISTRATION_REASON_CODE
            ,zxr.REGISTRATION_STATUS_CODE            as REGISTRATION_STATUS_CODE
            ,zxr.REGISTRATION_SOURCE_CODE            as REGISTRATION_SOURCE_CODE
            --,decode(zxr.INCLUSIVE_TAX_FLAG,
            --    'Y','Yes',
            --    'N','No',
            --    zxr.INCLUSIVE_TAX_FLAG)                    as INCLUSIVE_TAX_FLAG
            ,zxr.INCLUSIVE_TAX_FLAG                        as INCLUSIVE_TAX_FLAG
            ,zxr.REP_PARTY_TAX_NAME                        as REP_PARTY_TAX_NAME
            ,''                                           as LEGAL_LOCATION_CODE
            ,''                                                as ADDRESS_LINE_1
            ,''                                                  as TOWN_OR_CITY                                       
            ,''                                                      as REGION_1                                           
            ,''                                            as TAX_AUTHORITY_NAME
        FROM 
            ZX_REGISTRATIONS@xxmx_extract       zxr,
            ZX_PARTY_TAX_PROFILE@xxmx_extract   zxptp,
            XXMX_CUSTOMER_SCOPE_T               scope,
            apps.hz_party_sites@xxmx_extract    hps
        WHERE   sysdate between zxr.EFFECTIVE_FROM and nvl(zxr.EFFECTIVE_TO,sysdate+1)
        AND     zxr.PARTY_TAX_PROFILE_ID    = zxptp.PARTY_TAX_PROFILE_ID
        AND     zxptp.PARTY_ID              = scope.party_site_id
        and     scope.party_site_id         = hps.party_site_id
        and     zxptp.PARTY_TYPE_CODE       = 'THIRD_PARTY_SITE';
    --
    --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE party_tax_profile_tt    IS TABLE OF party_tax_reg_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'party_tax_profile_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_tax_profile_stg';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
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
          party_tax_reg_tbl                       party_tax_profile_tt;
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
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
          --
          gvv_ProgressIndicator := '0010';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
          gvv_ProgressIndicator := '0020';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          -- Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          -- If the Migration Set Name is NULL then the Migration has not been initialized.
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               OPEN party_tax_reg_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH        party_tax_reg_cur
                       BULK COLLECT
                       INTO         party_tax_reg_tbl
                       LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN party_tax_reg_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    --FORALL i IN 1..party_tax_reg_tbl.COUNT
                    FOR i IN 1..party_tax_reg_tbl.COUNT
                    LOOP
                         --
                         INSERT INTO xxmx_stg.xxmx_zx_tax_registration_stg
                                     (
                                         migration_set_id                                   
                                        ,file_set_id
                                        ,migration_set_name                                 
                                        ,migration_status                                   
                                        ,PARTY_NUMBER
                                        ,PARTY_NAME                                         
                                        ,PARTY_TYPE_CODE                                    
                                        ,TAX_REGIME_CODE                                    
                                        ,TAX
                                        ,TAX_JURISDICTION_CODE 
                                        ,REGISTRATION_TYPE_CODE                             
                                        ,REGISTRATION_NUMBER                                
                                        ,EFFECTIVE_FROM
                                        ,EFFECTIVE_TO
                                        ,DEFAULT_REGISTRATION_FLAG
                                        ,REGISTRATION_REASON_CODE
                                        ,REGISTRATION_STATUS_CODE
                                        ,REGISTRATION_SOURCE_CODE
                                        ,REP_PARTY_TAX_NAME
                                        ,ROUNDING_LEVEL_CODE
                                        ,SELF_ASSESS_FLAG
                                        ,INCLUSIVE_TAX_FLAG
                                     )
                         VALUES
                                    (
                                        pt_i_MigrationSetID  
                                       ,60
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
                                       ,party_tax_reg_tbl(i).party_number
                                       ,party_tax_reg_tbl(i).party_name
                                       ,party_tax_reg_tbl(i).party_type_code
                                       ,party_tax_reg_tbl(i).TAX_REGIME_CODE
                                       ,party_tax_reg_tbl(i).TAX_CODE
                                       ,party_tax_reg_tbl(i).TAX_JURISDICTION_CODE 
                                       ,party_tax_reg_tbl(i).REGISTRATION_TYPE_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_NUMBER
                                       ,party_tax_reg_tbl(i).EFFECTIVE_FROM
                                       ,party_tax_reg_tbl(i).EFFECTIVE_TO
                                       ,party_tax_reg_tbl(i).DEFAULT_REGISTRATION_FLAG
                                       ,party_tax_reg_tbl(i).REGISTRATION_REASON_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_STATUS_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_SOURCE_CODE
                                       ,party_tax_reg_tbl(i).REP_PARTY_TAX_NAME
                                       ,party_tax_reg_tbl(i).ROUNDING_LEVEL_CODE
                                       ,party_tax_reg_tbl(i).SELF_ASSESS_FLAG
                                       ,party_tax_reg_tbl(i).INCLUSIVE_TAX_FLAG
                                    );
                   END LOOP;
               END LOOP;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE party_tax_reg_cur;
               --
               gvv_ProgressIndicator := '0100';
               --
               --
               -- Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               -- clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               -- is reached.
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
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               gvv_ProgressIndicator := '0110';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
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
                    --
                    IF   party_tax_reg_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_tax_reg_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END e_ModuleError Exception
               --
               --
               WHEN OTHERS
               THEN
                    --
                    --
                    IF   party_tax_reg_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_tax_reg_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END OTHERS Exception
               --
               --
          --** END Exception Handler
          --
          --
     END xxmx_zx_tax_registration_stg;
     --
     --
     PROCEDURE party_tax_classific_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          -- CURSOR Declarations
          --
          CURSOR party_classification_cur is
                SELECT  DISTINCT --Added hint MR
                     scope.party_site_number              as PARTY_NUMBER
                    ,scope.party_name                     as PARTY_NAME
                    ,'Customer site'                      as PARTY_TYPE_CODE
                    -- MA 06-12-2022 will be set in Gate2 by citco
                    --,'REGISTERED'                       as CLASS_CATEGORY
                    ,''                                   as CLASS_CATEGORY
                    ,zxft.CLASSIFICATION_TYPE_CODE        as CLASSIFICATION_TYPE_CODE
                    ,zxft.CLASSIFICATION_TYPE_CODE        as CLASSIFICATION_TYPE_NAME
                    ,null                                 as TAX_REGIME_CODE
                    ,hzca.CLASS_CODE                      as CLASS_CODE
                    -- MA 26/05/2022 column removed by Latheef from table
                    --,hzca.CLASS_CODE                    as CLASS_NAME
                    -- MA 31/05/2023 reinstate the column and set to null. the clumn is no longer in use but still is mandatory in the FBDI
                    ,null                                 as CLASS_NAME
                    ,hzca.START_DATE_ACTIVE               as EFFECTIVE_FROM
                    ,hzca.END_DATE_ACTIVE                 as EFFECTIVE_TO
                FROM 
                     HZ_CODE_ASSIGNMENTS@xxmx_extract    hzca,
                     ZX_FC_TYPES_B@xxmx_extract          zxft,
                     zx_party_tax_profile@xxmx_extract   zxptp,
                     hz_party_sites@xxmx_extract         hzps,
                     XXMX_CUSTOMER_SCOPE_T               scope
                WHERE   hzca.CLASS_CATEGORY                      = 'Fiscal Classification'
                -- MA 24/04/2023 add the condition below to restrict the active tax classification
                AND     nvl(hzca.END_DATE_ACTIVE,sysdate+10)     > sysdate
                AND     zxft.classification_type_code            = 'FISCAL CLASSFICATION'
                AND     hzca.owner_table_id                      = zxptp.party_tax_profile_id
                and     hzps.party_site_id                       = scope.party_site_id
                and     zxptp.party_type_code                    = 'THIRD_PARTY_SITE'
                and     zxptp.party_id                           = hzps.party_site_id
                and     zxft.OWNER_ID_CHAR                       = hzca.CLASS_CATEGORY  
                ;
          --
          -- Type Declarations
          --
          TYPE party_classification_tt IS TABLE OF party_classification_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          -- Constant Declarations
          --
          -- This is declared in each Procedure within the package to allow for
          -- a different value to be assigned in the Staging/Transform/Export
          -- procedures.
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'party_tax_profile_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_tax_profile_stg';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
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
          party_classification_tbl                    party_classification_tt;
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
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
          --
          gvv_ProgressIndicator := '0010';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
          gvv_ProgressIndicator := '0020';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          -- Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          -- If the Migration Set Name is NULL then the Migration has not been initialized.
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '0100';
               --
               OPEN party_classification_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH        party_classification_cur
                       BULK COLLECT
                       INTO         party_classification_tbl
                       LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN party_classification_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FOR i IN 1..party_classification_tbl.COUNT
                    LOOP
                         --
                         INSERT INTO xxmx_stg.xxmx_zx_party_classific_stg
                                     (
                                         migration_set_id
                                        ,file_set_id
                                        ,migration_set_name
                                        ,migration_status
                                        ,PARTY_NUMBER
                                        ,PARTY_NAME
                                        ,PARTY_TYPE_CODE
                                        ,CLASS_CATEGORY
                                        ,CLASSIFICATION_TYPE_CODE
                                        ,CLASSIFICATION_TYPE_NAME
                                        ,TAX_REGIME_CODE
                                        ,CLASS_CODE
                                        -- MA 26/05/2022 column removed by Latheef from table
                                        --,CLASS_NAME
                                        ,EFFECTIVE_FROM
                                        ,EFFECTIVE_TO
                                     )
                         VALUES
                                    (
                                        pt_i_MigrationSetID
                                       ,64
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
                                       ,party_classification_tbl(i).party_number
                                       ,party_classification_tbl(i).party_name
                                       ,party_classification_tbl(i).party_type_code
                                       ,party_classification_tbl(i).CLASS_CATEGORY
                                       ,party_classification_tbl(i).CLASSIFICATION_TYPE_CODE
                                       ,party_classification_tbl(i).CLASSIFICATION_TYPE_NAME
                                       ,party_classification_tbl(i).TAX_REGIME_CODE
                                       ,party_classification_tbl(i).CLASS_CODE
                                        -- MA 26/05/2022 column removed by Latheef from table
                                       --,party_classification_tbl(i).CLASS_NAME
                                       ,party_classification_tbl(i).EFFECTIVE_FROM
                                       ,party_classification_tbl(i).EFFECTIVE_TO
                                    );

                   END LOOP;
               END LOOP;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE party_classification_cur;
            --
               /*
               ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               ** is reached.
               */
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     gct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               gvv_ProgressIndicator := '0110';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
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
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||ct_StgTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
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
                    --
                    IF   party_classification_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_classification_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END e_ModuleError Exception
               --
               --
               WHEN OTHERS
               THEN
                    --
                    --
                    IF   party_classification_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE party_classification_cur;
                         --
                         --
                    END IF;
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                             SQLERRM
                                           ||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    --
                    RAISE;
                    --
                    --
               --** END OTHERS Exception
               --
               --
          --** END Exception Handler
          --
          --
     END party_tax_classific_stg;
    -- ---------------------------------------------------------------------- --
    -- PROCEDURE: stg_main
    -- ---------------------------------------------------------------------- --
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
               AND     xmm.stg_procedure_name IS NOT NULL
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'EXTRACT';
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
          IF   pt_i_ClientCode       IS NULL
          OR   pt_i_MigrationSetName IS NULL
          THEN
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               RAISE e_ModuleError;
          END IF;
          --
          --
          -- Clear Customer TAX Module Messages
          gvv_ProgressIndicator := '0020';
          gvv_ReturnStatus  := '';
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          -- Initialize the Migration Set for the Business Entity retrieving
          -- a new Migration Set ID.
          --
          gvv_ProgressIndicator := '0040';
          xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_MigrationSetName => pt_i_MigrationSetName
               ,pt_o_MigrationSetID   => vt_MigrationSetID
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Migration Set "'||pt_i_MigrationSetName||'" initialized (Generated Migration Set ID = '||vt_MigrationSetID||').  Processing extracts:'
               ,pt_i_OracleError       => NULL
               );
          --
          --
          gvv_ProgressIndicator := '0050';
          party_tax_profile_stg(vt_MigrationSetID,'CUSTOMERS_TAX');
          --
          --
          gvv_ProgressIndicator := '0060';
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
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
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END stg_main;
    -- ---------------------------------------------------------------------- --
    -- PROCEDURE: purge
    -- ---------------------------------------------------------------------- --
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'CORE';
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
          IF  pt_i_MigrationSetID IS NULL
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameters is mandatory.';
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
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
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
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          --
          delete from xxmx_stg.XXMX_ZX_TAX_PROFILE_STG where migration_set_id = pt_i_MigrationSetID;
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged from xxmx_zx_tax_profile_stg table: '||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );
               --
          --
          delete from xxmx_stg.XXMX_ZX_TAX_REGISTRATION_STG where migration_set_id = pt_i_MigrationSetID;
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged from xxmx_zx_tax_registration table: '||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );
               --
          --
          delete from xxmx_stg.XXMX_ZX_PARTY_CLASSIFIC_STG where migration_set_id = pt_i_MigrationSetID;
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged from xxmx_zx_tax_registration table: '||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );
               --
          --
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
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
    PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
    IS
        CURSOR tax_profile_cur is
            select
                file_set_id||','||
                PARTY_NUMBER||','||
                PARTY_NAME||','||
                PARTY_TYPE_CODE||','||
                PROCESS_FOR_APPLICABILITY_FLAG||','||
                ROUNDING_LEVEL_CODE||','||
                ROUNDING_RULE_CODE||','||
                TAX_CLASSIFICATION_CODE||','||
                INCLUSIVE_TAX_FLAG||','||
                ALLOW_OFFSET_TAX_FLAG||','||
                COUNTRY_CODE||','||
                REGISTRATION_TYPE_CODE||','||
                REP_REGISTRATION_NUMBER
            from xxmx_xfm.xxmx_zx_tax_profile_xfm
            where migration_set_name=pt_i_MigrationSetName;
        CURSOR tax_registration_cur is
            select
                file_set_id||','||
                PARTY_NUMBER||','||
                PARTY_NAME||','||
                PARTY_TYPE_CODE||','||
                TAX_REGIME_CODE||','||
                TAX||','||
                TAX_JURISDICTION_CODE||','||
                REGISTRATION_TYPE_CODE||','||
                REGISTRATION_NUMBER||','||
                EFFECTIVE_FROM||','||
                EFFECTIVE_TO||','||
                DEFAULT_REGISTRATION_FLAG||','||
                REGISTRATION_REASON_CODE||','||
                REGISTRATION_STATUS_CODE||','||
                REGISTRATION_SOURCE_CODE||','||
                REP_PARTY_TAX_NAME||','||
                ROUNDING_LEVEL_CODE||','||
                SELF_ASSESS_FLAG||','||
                INCLUSIVE_TAX_FLAG
            from xxmx_xfm.xxmx_zx_tax_registration_xfm
            where migration_set_name=pt_i_MigrationSetName;
        CURSOR party_classification_cur is
            select
                file_set_id||','||
                PARTY_NUMBER||','||
                PARTY_NAME||','||
                PARTY_TYPE_CODE||','||
                CLASS_CATEGORY||','||
                CLASSIFICATION_TYPE_CODE||','||
                CLASSIFICATION_TYPE_NAME||','||
                TAX_REGIME_CODE||','||
                CLASS_CODE||','||
                CLASS_CODE||','||
                EFFECTIVE_FROM||','||
                EFFECTIVE_TO
            from xxmx_xfm.xxmx_zx_party_classific_xfm
            where migration_set_name=pt_i_MigrationSetName;
    BEGIN
        null;
    END xfm_main;
    --
END xxmx_customer_tax_profile_pkg;