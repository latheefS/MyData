--------------------------------------------------------
--  File created - Wednesday-September-15-2021   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package XXMX_GL_BALANCES_PKG
--------------------------------------------------------

  CREATE OR REPLACE  PACKAGE "XXMX_GL_BALANCES_PKG"
AS
     --
     --
     --*****************************
     --** PROCEDURE: gl_balances_stg
     --*****************************
     --
     PROCEDURE gl_balances_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
                    --
                    --
     --** END PROCEDURE gl_balances_stg
     --
     --
     /*
     *****************************
     ** PROCEDURE: gl_balances_xfm
     *****************************
     */
     --
     PROCEDURE gl_balances_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
                    --
                    --
     --** END PROCEDURE gl_balances_xfm
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
                    );
                    --
                    --
     --** END PROCEDURE stg_main
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
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_ID%TYPE
                    );
                    --
                    --
     --** END PROCEDURE xfm_main
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
                   );
                   --
                   --
     --** END PROCEDURE purge
     --
     --
     --*******************
     --** PROCEDURE: purge
     --*******************
     --
     PROCEDURE update_accounted_values
                   (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
                   --
                   --
     --** END PROCEDURE purge
     --
     --

end xxmx_gl_balances_pkg;
/

  CREATE OR REPLACE  PACKAGE BODY "XXMX_GL_BALANCES_PKG" 
AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_gl_balances_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_gl_balances_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'BALANCES';
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                     VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                          VARCHAR2(1);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for data existence checking */
     --
     gvn_ExistenceCount                        NUMBER;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                      xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                             VARCHAR2(20);
     gvv_SQLTableClause                        VARCHAR2(100);
     gvv_SQLColumnList                         VARCHAR2(4000);
     gvv_SQLValuesList                         VARCHAR2(4000);
     gvv_SQLWhereClause                        VARCHAR2(4000);
     gvv_SQLStatement                          VARCHAR2(32000);
     gvv_SQLResult                             VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                              NUMBER;
     --
     /* Global variables for transform procedures */
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
     --*****************************
     --** PROCEDURE: gl_balances_stg
     --*****************************
     --
     --**
     --** Future Updates:
     --**   Pass Account Segment Delimiter as a Parameter determined from the Chart of Accounts Structure
     --**
     PROCEDURE gl_balances_stg
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
          -- Cursor to get the detail GL balance
          --
          CURSOR GLBalances_cur
                      (
                       pv_LedgerName                   VARCHAR2
                      ,pv_ExtractYear                  VARCHAR2
                      ,pv_PeriodName                   VARCHAR2
                      )
          IS
               --
               --
               SELECT  DISTINCT
                       'NEW'                                             fusion_status_code
                      ,gl.name                                           ledger_name
                      ,gp.end_date                                       accounting_date
                      ,(
                        SELECT  xgss.gl_bal_fusion_jrnl_source
                        FROM    xxmx_gl_source_structures  xgss
                        WHERE   1 = 1
                        AND     xgss.source_ledger_name = gl.name
                       )                                                 user_je_source_name
                      ,(
                        SELECT  xgss.gl_bal_fusion_jrnl_category
                        FROM    xxmx_gl_source_structures  xgss
                        WHERE   1 = 1
                        AND     xgss.source_ledger_name = gl.name
                       )                                                 user_je_category_name
                      ,gb.currency_code                                  currency_code
                      ,TRUNC(SYSDATE)                                    journal_entry_creation_date
                      ,gb.actual_flag                                    actual_flag
                      ,gcc.segment1                                      segment1
                      ,gcc.segment2                                      segment2
                      ,gcc.segment3                                      segment3
                      ,gcc.segment4                                      segment4
                      ,gcc.segment5                                      segment5
                      ,gcc.segment6                                      segment6
                      ,gcc.segment7                                      segment7
                      ,gcc.segment8                                      segment8
                      ,gcc.segment9                                      segment9
                      ,gcc.segment10                                     segment10
                      ,gcc.segment11                                     segment11
                      ,gcc.segment12                                     segment12
                      ,gcc.segment13                                     segment13
                      ,gcc.segment14                                     segment14
                      ,gcc.segment15                                     segment15
                      ,gcc.segment16                                     segment16
                      ,gcc.segment17                                     segment17
                      ,gcc.segment18                                     segment18
                      ,gcc.segment19                                     segment19
                      ,gcc.segment20                                     segment20
                      ,gcc.segment21                                     segment21
                      ,gcc.segment22                                     segment22
                      ,gcc.segment23                                     segment23
                      ,gcc.segment24                                     segment24
                      ,gcc.segment25                                     segment25
                      ,gcc.segment26                                     segment26
                      ,gcc.segment27                                     segment27
                      ,gcc.segment28                                     segment28
                      ,gcc.segment29                                     segment29
                      ,gcc.segment30                                     segment30
                      ,(gb.begin_balance_dr + gb.period_net_dr)          entered_dr
                      ,(gb.begin_balance_cr + gb.period_net_cr)          entered_cr
                      ,(gb.begin_balance_dr_beq + gb.period_net_dr_beq)  accounted_dr
                      ,(gb.begin_balance_cr_beq + gb.period_net_cr_beq)  accounted_cr
                      ,'ACTUAL BALANCE MIGRATION'
                     ||' '
                     ||gp.period_name                                    reference1                        -- CV040 states this should be the Batch Name
                      ,''                                                reference2                        -- CV040 states this should be the Batch Description
                      ,''                                                reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
                      ,'ACTUAL BALANCE MIGRATION'                                                          
                     ||' '                                                                                 
                     ||gp.period_name                                    reference4                        -- CV040 states this should be the Journal Entry Name
                      ,''                                                reference5                        -- CV040 states this should be the Journal Entry Description
                      ,''                                                reference6                        -- CV040 states this should be the Journal Entry Reference
                      ,''                                                reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
                      ,''                                                reference8                        -- CV040 states this should be the Journal entry Reversal Period
                      ,''                                                reference9                        -- CV040 states this should be the Journal Reversal Method
                      ,''                                                reference10                       -- CV040 states this should be the Journal entry Line Description
                      ,gcck.concatenated_segments                        reference21                       -- Hidden Column in FDBI Template : Reference column 1
                      ,''                                                reference22                       -- Hidden Column in FDBI Template : Reference column 2
                      ,''                                                reference23                       -- Hidden Column in FDBI Template : Reference column 3
                      ,''                                                reference24                       -- Hidden Column in FDBI Template : Reference column 4
                      ,''                                                reference25                       -- Hidden Column in FDBI Template : Reference column 5
                      ,''                                                reference26                       -- Hidden Column in FDBI Template : Reference column 6
                      ,''                                                reference27                       -- Hidden Column in FDBI Template : Reference column 7
                      ,''                                                reference28                       -- Hidden Column in FDBI Template : Reference column 8
                      ,''                                                reference29                       -- Hidden Column in FDBI Template : Reference column 9
                      ,''                                                reference30                       -- Hidden Column in FDBI Template : Reference column 10
                      ,''                                                stat_amount
                      ,''                                                user_currency_conversion_type
                      --,gjh.currency_conversion_date                      currency_conversion_date
                      ,''                                                currency_conversion_date
                      ,''                                                currency_conversion_rate
                      ,''                                                attribute_category
                      ,''                                                attribute1
                      ,''                                                attribute2
                      ,''                                                attribute3
                      ,''                                                attribute4
                      ,''                                                attribute5
                      ,''                                                attribute6
                      ,''                                                attribute7
                      ,''                                                attribute8
                      ,''                                                attribute9
                      ,''                                                attribute10
                      ,''                                                attribute11
                      ,''                                                attribute12
                      ,''                                                attribute13
                      ,''                                                attribute14
                      ,''                                                attribute15
                      ,''                                                attribute16
                      ,''                                                attribute17
                      ,''                                                attribute18
                      ,''                                                attribute19
                      ,''                                                attribute20
                      ,''                                                attribute_category3
                      ,''                                                average_journal_flag
                      ,''                                                originating_bal_seg_value
                      ,''                                                encumbrance_type_id
                      ,''                                                jgzz_recon_ref
                      ,gb.period_name                                    period_name
               FROM    apps.gl_ledgers@MXDM_NVIS_EXTRACT                gl
                      ,apps.gl_periods@MXDM_NVIS_EXTRACT                gp
                      ,apps.gl_code_combinations@MXDM_NVIS_EXTRACT      gcc
                      ,apps.gl_code_combinations_kfv@MXDM_NVIS_EXTRACT  gcck
                      ,apps.gl_balances@MXDM_NVIS_EXTRACT               gb
               WHERE  1 = 1
               AND    gl.name                  = pv_LedgerName
               AND    gp.period_set_name       = gl.period_set_name
               AND    gp.period_year           = pv_ExtractYear
               AND    gp.period_name           = pv_PeriodName
               AND    gb.ledger_id             = gl.ledger_id
               AND    gb.period_name           = gp.period_name
               AND    gb.actual_flag           = 'A'
               AND    (
                          (gb.begin_balance_dr + gb.period_net_dr)         <> 0
                       OR (gb.begin_balance_cr + gb.period_net_cr)         <> 0
                       OR (gb.begin_balance_dr_beq + gb.period_net_dr_beq) <> 0
                       OR (gb.begin_balance_cr_beq + gb.period_net_cr_beq) <> 0
                      )
               AND    gcc.code_combination_id  = gb.code_combination_id
               AND    gcck.code_combination_id = gcc.code_combination_id;
               --AND    gb.currency_code          = gl.currency_code
               --
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE gl_balances_tt IS TABLE OF GLBalances_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_balances_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_balances_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ListParameterCode            xxmx_migration_parameters.parameter_code%TYPE;
          vn_ListValueCount               NUMBER;
          vb_OkayToExtract                BOOLEAN;
          vb_PeriodAndYearMatch           BOOLEAN;
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
          EmptyLedgerName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          LedgerName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyExtractYear_tbl            xxmx_utilities_pkg.g_ParamValueList_tt;
          ExtractYear_tbl                 xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyPeriodName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          PeriodName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          GLBalances_tbl                  gl_balances_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
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
          vb_OkayToExtract  := TRUE;
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
               /*
               ** The Migration Set has been initialized so not retrieve the
               ** Parameters for extracting GL Balances:
               **
               ** 1) GL Ledger Name List
               ** 2) Extract Years List
               ** 3) GL Period Name List
               */
               --
               /*
               ** Retrieve GL Ledger Names List
               */
               --
               gvv_ProgressIndicator := '0050';
               --
               vt_ListParameterCode := 'LEDGER_NAME';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'
                                             ||vt_ListParameterCode
                                             ||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               LedgerName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => pt_i_SubEntity
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
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
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                  ||vt_ListParameterCode
                                                  ||'" List could not be retrieved.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
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
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||vn_ListValueCount
                                                  ||' values for "'
                                                  ||vt_ListParameterCode
                                                  ||'" List retrieved.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF;
               --
               IF   vn_ListValueCount = 0
               THEN
                    --
                    vb_OkayToExtract := FALSE;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - No "'
                                                  ||vt_ListParameterCode
                                                  ||'" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
               END IF;
               --
               /*
               ** Retrieve Extract Years List
               */
               --
               gvv_ProgressIndicator := '0060';
               --
               vt_ListParameterCode := 'EXTRACT_YEAR';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'
                                             ||vt_ListParameterCode
                                             ||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               ExtractYear_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                       (
                                        pt_i_ApplicationSuite => gct_ApplicationSuite
                                       ,pt_i_Application      => gct_Application
                                       ,pt_i_BusinessEntity   => gct_BusinessEntity
                                       ,pt_i_SubEntity        => pt_i_SubEntity
                                       ,pt_i_ParameterCode    => vt_ListParameterCode
                                       ,pn_o_ReturnCount      => vn_ListValueCount
                                       ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                       ,pv_o_ReturnMessage    => gvt_ReturnMessage
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
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                  ||vt_ListParameterCode
                                                  ||'" List could not be retrieved.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
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
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||vn_ListValueCount
                                                  ||' values for "'
                                                  ||vt_ListParameterCode
                                                  ||'" List retrieved.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF;
               --
               IF   vn_ListValueCount = 0
               THEN
                    --
                    vb_OkayToExtract := FALSE;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'WARNING'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - No "'
                                                    ||vt_ListParameterCode
                                                    ||'" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.'
                         ,pt_i_OracleError         => gvt_ReturnMessage
                         );
                    --
               END IF;
               --
               /*
               ** Retrieve GL Period Name List
               */
               --
               gvv_ProgressIndicator := '0070';
               --
               vt_ListParameterCode := 'PERIOD_NAME';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'
                                             ||vt_ListParameterCode
                                             ||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               PeriodName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => pt_i_SubEntity
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
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
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                  ||vt_ListParameterCode
                                                  ||'" List could not be retrieved.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
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
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||vn_ListValueCount
                                                  ||' values for "'
                                                  ||vt_ListParameterCode
                                                  ||'" List retrieved.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF;
               --
               IF   vn_ListValueCount = 0
               THEN
                    --
                    vb_OkayToExtract := FALSE;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'WARNING'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '    - No "'
                                                    ||vt_ListParameterCode
                                                    ||'" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.'
                         ,pt_i_OracleError         => gvt_ReturnMessage
                         );
                    --
               END IF;
               --
               /*
               ** If there are no Extract Parameters in the "xxmx_migration_parameters" table
               ** (those which are there have to be enabled), no balances can be extracted.
               */
               --
               gvv_ProgressIndicator := '0080';
               --
               IF   vb_OkayToExtract
               THEN
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    /*
                    ** The Extract Parameters were successfully retrieved so now
                    ** initialize the detail record for the GL Balances.
                    */
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
                    --**                  table based on the Application Suite, Application and Business Entity parameters.
                    --**
                    --**                  Removed "entity" from procedure_name.
                    --
                    xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_StagingTable      => ct_StgTable
                         ,pt_i_ExtractStartDate  => SYSDATE
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
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'
                                                  ||ct_StgTable
                                                  ||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** There are Ledger Names in the "xxmx_migration_parameters" table
                    ** so loop through the Ledger Name list and for each one:
                    **
                    ** a) Retrieve COA Structure Details pertaining to the Ledger.
                    ** b) Extract the Balances for the Ledger.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Processing Parameter Lists and extracting GL Balances for specific '
                                                  ||'GL Ledger Name/Extract Year/GL Period Name combinations.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Loop through Ledger Names List
                    */
                    --
                    gvv_ProgressIndicator := '0100';
                    --
                    FOR  LedgerName_idx
                    IN   LedgerName_tbl.FIRST..LedgerName_tbl.LAST
                    LOOP
                         --
                         /*
                         ** Loop through Extract Years List
                         */
                         --
                         gvv_ProgressIndicator := '0110';
                         --
                         FOR  ExtractYear_idx
                         IN   ExtractYear_tbl.FIRST..ExtractYear_tbl.LAST
                         LOOP
                              --
                              /*
                              ** The following variable will be set to TRUE if any of the Period Names
                              ** in the Period Name Parameters list exist for the current Extract Year
                              ** Parameter.  If no Period Name Parameters match to the current Extract
                              ** Year Parameter this variable will remain FALSE.
                              **
                              ** This is so an INFORMATION log message can be issued if there are no
                              ** Period Name Parameters which match to the current Extract Year Parameter.
                              */
                              --
                              vb_PeriodAndYearMatch := FALSE;
                              --
                              /*
                              ** Loop through GL Period Names List
                              */
                              --
                              gvv_ProgressIndicator := '0120';
                              --
                              FOR  PeriodName_idx
                              IN   PeriodName_tbl.FIRST..PeriodName_tbl.LAST
                              LOOP
                                   --
                                   gvn_ExistenceCount := 0;
                                   --
                                   /*
                                   ** Verify if the current Period Name Parameter exists
                                   ** as a GL Period in the GL_PERIODS table for the current
                                   ** Source Ledger Name and Extract Year Parameters.
                                   */
                                   --
                                   gvv_ProgressIndicator := '0130';
                                   --
                                   SELECT  COUNT(1)
                                   INTO    gvn_ExistenceCount
                                   FROM    apps.gl_ledgers@MXDM_NVIS_EXTRACT  gl2
                                          ,apps.gl_periods@MXDM_NVIS_EXTRACT  gp
                                   WHERE   1 = 1
                                   AND     gl2.name           = LedgerName_tbl(LedgerName_idx)
                                   AND     gp.period_set_name = gl2.period_set_name
                                   AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                                   AND     gp.period_name     = PeriodName_tbl(PeriodName_idx);
                                   --
                                   IF   gvn_ExistenceCount > 0
                                   THEN
                                        --
                                        /*
                                        ** Current Period Name Parameter exists in the GL_PERIODS table
                                        ** for the current Source Ledger Name and Extract Year so the
                                        ** Balances extract can proceed.
                                        */
                                        --
                                        vb_PeriodAndYearMatch := TRUE;
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => pt_i_SubEntity
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'
                                                                      ||gct_Application
                                                                      ||' '
                                                                      ||pt_i_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerName_tbl(LedgerName_idx)
                                                                      ||'" and Year "'
                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                      ||'", Period Name "'
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
                                        --**                  by a Synonym in the xxmx_core schema to that table.
                                        --
                                        gvv_ProgressIndicator := '0140';
                                        --
                                        OPEN GLBalances_cur
                                                  (
                                                   LedgerName_tbl(LedgerName_idx)
                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                                  ,PeriodName_tbl(PeriodName_idx)
                                                  );
                                        --
                                        gvv_ProgressIndicator := '0150';
                                        --
                                        LOOP
                                             --
                                             FETCH        GLBalances_cur
                                             BULK COLLECT
                                             INTO         GLBalances_tbl
                                             LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                                             --
                                             EXIT WHEN    GLBalances_tbl.COUNT = 0;
                                             --
                                             gvv_ProgressIndicator := '0160';
                                             --
                                             FORALL GLBalances_idx IN 1..GLBalances_tbl.COUNT
                                                  --
                                                  INSERT
                                                  INTO   xxmx_gl_balances_stg
                                                              (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,fusion_status_code
                                                              ,ledger_name
                                                              ,accounting_date
                                                              ,user_je_source_name
                                                              ,user_je_category_name
                                                              ,currency_code
                                                              ,journal_entry_creation_date
                                                              ,actual_flag
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
                                                              ,entered_dr
                                                              ,entered_cr
                                                              ,accounted_dr
                                                              ,accounted_cr
                                                              ,reference1
                                                              ,reference2
                                                              ,reference3
                                                              ,reference4
                                                              ,reference5
                                                              ,reference6
                                                              ,reference7
                                                              ,reference8
                                                              ,reference9
                                                              ,reference10
                                                              ,reference21
                                                              ,reference22
                                                              ,reference23
                                                              ,reference24
                                                              ,reference25
                                                              ,reference26
                                                              ,reference27
                                                              ,reference28
                                                              ,reference29
                                                              ,reference30
                                                              ,stat_amount
                                                              ,user_currency_conversion_type
                                                              ,currency_conversion_date
                                                              ,currency_conversion_rate
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
                                                              ,attribute_category3
                                                              ,average_journal_flag
                                                              ,originating_bal_seg_value
                                                              ,encumbrance_type_id
                                                              ,jgzz_recon_ref
                                                              ,period_name
                                                              )
                                                  VALUES
                                                              (
                                                               pt_i_MigrationSetID                                           -- migration_set_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,GLBalances_tbl(GLBalances_idx).fusion_status_code             -- fusion_status_code
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_name                    -- ledger_name
                                                              ,GLBalances_tbl(GLBalances_idx).accounting_date                -- accounting_date
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_source_name            -- user_je_source_name
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_category_name          -- user_je_category_name
                                                              ,GLBalances_tbl(GLBalances_idx).currency_code                  -- currency_code
                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                                              ,GLBalances_tbl(GLBalances_idx).actual_flag                    -- actual_flag
                                                              ,GLBalances_tbl(GLBalances_idx).segment1                       -- segment1
                                                              ,GLBalances_tbl(GLBalances_idx).segment2                       -- segment2
                                                              ,GLBalances_tbl(GLBalances_idx).segment3                       -- segment3
                                                              ,GLBalances_tbl(GLBalances_idx).segment4                       -- segment4
                                                              ,GLBalances_tbl(GLBalances_idx).segment5                       -- segment5
                                                              ,GLBalances_tbl(GLBalances_idx).segment6                       -- segment6
                                                              ,GLBalances_tbl(GLBalances_idx).segment7                       -- segment7
                                                              ,GLBalances_tbl(GLBalances_idx).segment8                       -- segment8
                                                              ,GLBalances_tbl(GLBalances_idx).segment9                       -- segment9
                                                              ,GLBalances_tbl(GLBalances_idx).segment10                      -- segment10
                                                              ,GLBalances_tbl(GLBalances_idx).segment11                      -- segment11
                                                              ,GLBalances_tbl(GLBalances_idx).segment12                      -- segment12
                                                              ,GLBalances_tbl(GLBalances_idx).segment13                      -- segment13
                                                              ,GLBalances_tbl(GLBalances_idx).segment14                      -- segment14
                                                              ,GLBalances_tbl(GLBalances_idx).segment15                      -- segment15
                                                              ,GLBalances_tbl(GLBalances_idx).segment16                      -- segment16
                                                              ,GLBalances_tbl(GLBalances_idx).segment17                      -- segment17
                                                              ,GLBalances_tbl(GLBalances_idx).segment18                      -- segment18
                                                              ,GLBalances_tbl(GLBalances_idx).segment19                      -- segment19
                                                              ,GLBalances_tbl(GLBalances_idx).segment20                      -- segment20
                                                              ,GLBalances_tbl(GLBalances_idx).segment21                      -- segment21
                                                              ,GLBalances_tbl(GLBalances_idx).segment22                      -- segment22
                                                              ,GLBalances_tbl(GLBalances_idx).segment23                      -- segment23
                                                              ,GLBalances_tbl(GLBalances_idx).segment24                      -- segment24
                                                              ,GLBalances_tbl(GLBalances_idx).segment25                      -- segment25
                                                              ,GLBalances_tbl(GLBalances_idx).segment26                      -- segment26
                                                              ,GLBalances_tbl(GLBalances_idx).segment27                      -- segment27
                                                              ,GLBalances_tbl(GLBalances_idx).segment28                      -- segment28
                                                              ,GLBalances_tbl(GLBalances_idx).segment29                      -- segment29
                                                              ,GLBalances_tbl(GLBalances_idx).segment30                      -- segment30
                                                              ,GLBalances_tbl(GLBalances_idx).entered_dr                     -- entered_dr
                                                              ,GLBalances_tbl(GLBalances_idx).entered_cr                     -- entered_cr
                                                              ,GLBalances_tbl(GLBalances_idx).accounted_dr                   -- accounted_dr
                                                              ,GLBalances_tbl(GLBalances_idx).accounted_cr                   -- accounted_cr
                                                              ,GLBalances_tbl(GLBalances_idx).reference1                     -- reference1
                                                              ,GLBalances_tbl(GLBalances_idx).reference2                     -- reference2
                                                              ,GLBalances_tbl(GLBalances_idx).reference3                     -- reference3
                                                              ,GLBalances_tbl(GLBalances_idx).reference4                     -- reference4
                                                              ,GLBalances_tbl(GLBalances_idx).reference5                     -- reference5
                                                              ,GLBalances_tbl(GLBalances_idx).reference6                     -- reference6
                                                              ,GLBalances_tbl(GLBalances_idx).reference7                     -- reference7
                                                              ,GLBalances_tbl(GLBalances_idx).reference8                     -- reference8
                                                              ,GLBalances_tbl(GLBalances_idx).reference9                     -- reference9
                                                              ,GLBalances_tbl(GLBalances_idx).reference10                    -- reference10
                                                              ,GLBalances_tbl(GLBalances_idx).reference21                    -- reference21
                                                              ,GLBalances_tbl(GLBalances_idx).reference22                    -- reference22
                                                              ,GLBalances_tbl(GLBalances_idx).reference23                    -- reference23
                                                              ,GLBalances_tbl(GLBalances_idx).reference24                    -- reference24
                                                              ,GLBalances_tbl(GLBalances_idx).reference25                    -- reference25
                                                              ,GLBalances_tbl(GLBalances_idx).reference26                    -- reference26
                                                              ,GLBalances_tbl(GLBalances_idx).reference27                    -- reference27
                                                              ,GLBalances_tbl(GLBalances_idx).reference28                    -- reference28
                                                              ,GLBalances_tbl(GLBalances_idx).reference29                    -- reference29
                                                              ,GLBalances_tbl(GLBalances_idx).reference30                    -- reference30
                                                              ,GLBalances_tbl(GLBalances_idx).stat_amount                    -- stat_amount
                                                              ,GLBalances_tbl(GLBalances_idx).user_currency_conversion_type  -- user_currency_conversion_type
                                                              ,GLBalances_tbl(GLBalances_idx).currency_conversion_date       -- currency_conversion_date
                                                              ,GLBalances_tbl(GLBalances_idx).currency_conversion_rate       -- currency_conversion_rate
                                                              ,GLBalances_tbl(GLBalances_idx).attribute_category             -- attribute_category
                                                              ,GLBalances_tbl(GLBalances_idx).attribute1                     -- attribute1
                                                              ,GLBalances_tbl(GLBalances_idx).attribute2                     -- attribute2
                                                              ,GLBalances_tbl(GLBalances_idx).attribute3                     -- attribute3
                                                              ,GLBalances_tbl(GLBalances_idx).attribute4                     -- attribute4
                                                              ,GLBalances_tbl(GLBalances_idx).attribute5                     -- attribute5
                                                              ,GLBalances_tbl(GLBalances_idx).attribute6                     -- attribute6
                                                              ,GLBalances_tbl(GLBalances_idx).attribute7                     -- attribute7
                                                              ,GLBalances_tbl(GLBalances_idx).attribute8                     -- attribute8
                                                              ,GLBalances_tbl(GLBalances_idx).attribute9                     -- attribute9
                                                              ,GLBalances_tbl(GLBalances_idx).attribute10                    -- attribute10
                                                              ,GLBalances_tbl(GLBalances_idx).attribute11                    -- attribute11
                                                              ,GLBalances_tbl(GLBalances_idx).attribute12                    -- attribute12
                                                              ,GLBalances_tbl(GLBalances_idx).attribute13                    -- attribute13
                                                              ,GLBalances_tbl(GLBalances_idx).attribute14                    -- attribute14
                                                              ,GLBalances_tbl(GLBalances_idx).attribute15                    -- attribute15
                                                              ,GLBalances_tbl(GLBalances_idx).attribute16                    -- attribute16
                                                              ,GLBalances_tbl(GLBalances_idx).attribute17                    -- attribute17
                                                              ,GLBalances_tbl(GLBalances_idx).attribute18                    -- attribute18
                                                              ,GLBalances_tbl(GLBalances_idx).attribute19                    -- attribute19
                                                              ,GLBalances_tbl(GLBalances_idx).attribute20                    -- attribute20
                                                              ,GLBalances_tbl(GLBalances_idx).attribute_category3            -- attribute_category3
                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                                              ,GLBalances_tbl(GLBalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                                              ,GLBalances_tbl(GLBalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                                              ,GLBalances_tbl(GLBalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                                              ,GLBalances_tbl(GLBalances_idx).period_name                    -- period_name
                                                              );
                                                  --
                                             --** END FORALL
                                             --
                                        END LOOP; --** GLBalances_cur BULK COLLECT LOOP
                                        --
                                        gvv_ProgressIndicator := '0170';
                                        --
                                        CLOSE GLBalances_cur;
                                        --
                                   END IF; --** IF gvn_ExistenceCount >0
                                   --
                              END LOOP; --** PeriodName_tbl LOOP
                              --
                              gvv_ProgressIndicator := '0180';
                              --
                              IF   NOT vb_PeriodAndYearMatch
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
                                        ,pt_i_PackageName       => gcv_PackageName
                                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - No Period Name Parameters correspond to Extract Year "'
                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                 ||'" and the Period Set associated with Source Ledger Name "'
                                                                 ||LedgerName_tbl(LedgerName_idx)
                                                                 ||'".  No Balances were extracted for this year.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF NOT vb_PeriodAndYearMatch
                              --
                         END LOOP; --** ExtractYear_tbl LOOP
                         --
                    END LOOP; --** LedgerName_tbl LOOP
                    --
                    gvv_ProgressIndicator := '0190';
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all GL Ledgers in the Migration Set.
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
                    COMMIT;
                    --
                    --** Update the migration details (Migration status will be automatically determined
                    --** in the called procedure dependant on the Phase and if an Error Message has been
                    --** passed).
                    --
                    gvv_ProgressIndicator := '0200';
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
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
               END IF; --** vn_ListEntryCount > 0
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
                    IF   GLBalances_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLBalances_cur;
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
                    IF   GLBalances_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLBalances_cur;
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
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END gl_balances_stg;
     --
     --
     /*
     *****************************
     ** PROCEDURE: gl_balances_xfm
     *****************************
     */
     --
     PROCEDURE gl_balances_xfm
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
                      ,fusion_status_code
                      ,ledger_name
                      ,accounting_date
                      ,user_je_source_name
                      ,user_je_category_name
                      ,currency_code
                      ,journal_entry_creation_date
                      ,actual_flag
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
                      ,entered_dr
                      ,entered_cr
                      ,accounted_dr
                      ,accounted_cr
                      ,reference1
                      ,reference2
                      ,reference3
                      ,reference4
                      ,reference5
                      ,reference6
                      ,reference7
                      ,reference8
                      ,reference9
                      ,reference10
                      ,reference21
                      ,reference22
                      ,reference23
                      ,reference24
                      ,reference25
                      ,reference26
                      ,reference27
                      ,reference28
                      ,reference29
                      ,reference30
                      ,stat_amount
                      ,user_currency_conversion_type
                      ,currency_conversion_date
                      ,currency_conversion_rate
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
                      ,attribute_category3
                      ,average_journal_flag
                      ,originating_bal_seg_value
                      ,encumbrance_type_id
                      ,jgzz_recon_ref
                      ,period_name
               FROM    xxmx_gl_balances_stg
               WHERE   1 = 1
               AND     migration_set_id = pt_MigrationSetID
               AND     migration_status = 'EXTRACTED';
               --
          --** END CURSOR StgTable_cur
          --
          CURSOR XfmSourceLedgers_cur
          IS
               --
               SELECT  DISTINCT
                       source_ledger_name
               FROM    xxmx_gl_balances_xfm;
               --
          --** END CURSOR XfmSourceLedgers_cur
          --
          CURSOR XfmTableUpd_cur
                      (
                       pt_MigrationSetID               xxmx_gl_balances_xfm.migration_set_id%TYPE
                      )
          IS
               --
               SELECT  migration_set_id
                      ,migration_set_name
                      ,migration_status
                      ,fusion_status_code
                      ,source_ledger_name
                      ,fusion_ledger_id
                      ,fusion_ledger_name
                      ,accounting_date
                      ,user_je_source_name
                      ,user_je_category_name
                      ,currency_code
                      ,journal_entry_creation_date
                      ,actual_flag
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
                      ,entered_dr
                      ,entered_cr
                      ,accounted_dr
                      ,accounted_cr
                      ,reference1
                      ,reference2
                      ,reference3
                      ,reference4
                      ,reference5
                      ,reference6
                      ,reference7
                      ,reference8
                      ,reference9
                      ,reference10
                      ,reference21
                      ,reference22
                      ,reference23
                      ,reference24
                      ,reference25
                      ,reference26
                      ,reference27
                      ,reference28
                      ,reference29
                      ,reference30
                      ,stat_amount
                      ,user_currency_conversion_type
                      ,currency_conversion_date
                      ,currency_conversion_rate
                      ,group_id
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
                      ,attribute_category3
                      ,average_journal_flag
                      ,originating_bal_seg_value
                      ,encumbrance_type_id
                      ,jgzz_recon_ref
                      ,period_name
               FROM    xxmx_gl_balances_xfm
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_balances_xfm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'TRANSFORM';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE := 'xxmx_gl_balances_stg';
          ct_XfmTable                     CONSTANT  xxmx_migration_metadata.xfm_table%TYPE := 'xxmx_gl_balances_xfm';
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
          vt_FusionLedgerName             xxmx_gl_balances_xfm.fusion_ledger_name%TYPE;
          vt_FusionLedgerID               xxmx_gl_balances_xfm.fusion_ledger_id%TYPE;
          vn_TransformRowCount            NUMBER;
          vb_UnfrozenTransforms           BOOLEAN;
          vt_TransformEvaluationMsg       xxmx_data_messages.data_message%TYPE;
          vt_MigrationStatus              xxmx_gl_balances_xfm.migration_status%TYPE;
          vt_FusionSegment1               xxmx_gl_account_transforms.fusion_segment1%TYPE;
          vt_FusionSegment2               xxmx_gl_account_transforms.fusion_segment2%TYPE;
          vt_FusionSegment3               xxmx_gl_account_transforms.fusion_segment3%TYPE;
          vt_FusionSegment4               xxmx_gl_account_transforms.fusion_segment4%TYPE;
          vt_FusionSegment5               xxmx_gl_account_transforms.fusion_segment5%TYPE;
          vt_FusionSegment6               xxmx_gl_account_transforms.fusion_segment6%TYPE;
          vt_FusionSegment7               xxmx_gl_account_transforms.fusion_segment7%TYPE;
          vt_FusionSegment8               xxmx_gl_account_transforms.fusion_segment8%TYPE;
          vt_FusionSegment9               xxmx_gl_account_transforms.fusion_segment9%TYPE;
          vt_FusionSegment10              xxmx_gl_account_transforms.fusion_segment10%TYPE;
          vt_FusionSegment11              xxmx_gl_account_transforms.fusion_segment11%TYPE;
          vt_FusionSegment12              xxmx_gl_account_transforms.fusion_segment12%TYPE;
          vt_FusionSegment13              xxmx_gl_account_transforms.fusion_segment13%TYPE;
          vt_FusionSegment14              xxmx_gl_account_transforms.fusion_segment14%TYPE;
          vt_FusionSegment15              xxmx_gl_account_transforms.fusion_segment15%TYPE;
          vt_FusionSegment16              xxmx_gl_account_transforms.fusion_segment16%TYPE;
          vt_FusionSegment17              xxmx_gl_account_transforms.fusion_segment17%TYPE;
          vt_FusionSegment18              xxmx_gl_account_transforms.fusion_segment18%TYPE;
          vt_FusionSegment19              xxmx_gl_account_transforms.fusion_segment19%TYPE;
          vt_FusionSegment20              xxmx_gl_account_transforms.fusion_segment20%TYPE;
          vt_FusionSegment21              xxmx_gl_account_transforms.fusion_segment21%TYPE;
          vt_FusionSegment22              xxmx_gl_account_transforms.fusion_segment22%TYPE;
          vt_FusionSegment23              xxmx_gl_account_transforms.fusion_segment23%TYPE;
          vt_FusionSegment24              xxmx_gl_account_transforms.fusion_segment24%TYPE;
          vt_FusionSegment25              xxmx_gl_account_transforms.fusion_segment25%TYPE;
          vt_FusionSegment26              xxmx_gl_account_transforms.fusion_segment26%TYPE;
          vt_FusionSegment27              xxmx_gl_account_transforms.fusion_segment27%TYPE;
          vt_FusionSegment28              xxmx_gl_account_transforms.fusion_segment28%TYPE;
          vt_FusionSegment29              xxmx_gl_account_transforms.fusion_segment29%TYPE;
          vt_FusionSegment30              xxmx_gl_account_transforms.fusion_segment30%TYPE;
          vt_FusionConcatSegments         xxmx_gl_account_transforms.fusion_concatenated_segments%TYPE;
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
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                    FROM   xxmx_gl_balances_xfm
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         FORALL GLBalances_idx IN 1..StgTable_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_gl_balances_xfm
                                          (
                                           migration_set_id
                                          ,migration_set_name
                                          ,migration_status
                                          ,fusion_status_code
                                          ,source_ledger_name
                                          ,fusion_ledger_id
                                          ,fusion_ledger_name
                                          ,accounting_date
                                          ,user_je_source_name
                                          ,user_je_category_name
                                          ,currency_code
                                          ,journal_entry_creation_date
                                          ,actual_flag
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
                                          ,entered_dr
                                          ,entered_cr
                                          ,accounted_dr
                                          ,accounted_cr
                                          ,reference1
                                          ,reference2
                                          ,reference3
                                          ,reference4
                                          ,reference5
                                          ,reference6
                                          ,reference7
                                          ,reference8
                                          ,reference9
                                          ,reference10
                                          ,reference21
                                          ,reference22
                                          ,reference23
                                          ,reference24
                                          ,reference25
                                          ,reference26
                                          ,reference27
                                          ,reference28
                                          ,reference29
                                          ,reference30
                                          ,stat_amount
                                          ,user_currency_conversion_type
                                          ,currency_conversion_date
                                          ,currency_conversion_rate
                                          ,group_id
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
                                          ,attribute_category3
                                          ,average_journal_flag
                                          ,originating_bal_seg_value
                                          ,encumbrance_type_id
                                          ,jgzz_recon_ref
                                          ,period_name
                                          )
                              VALUES
                                          (
                                           StgTable_tbl(GLBalances_idx).migration_set_id               -- migration_set_id
                                          ,StgTable_tbl(GLBalances_idx).migration_set_name             -- migration_set_name
                                          ,'PLSQL PRE-TRANSFORM'                                       -- migration_status
                                          ,StgTable_tbl(GLBalances_idx).fusion_status_code             -- fusion_status_code
                                          ,StgTable_tbl(GLBalances_idx).ledger_name                    -- source_ledger_name
                                          ,NULL                                                        -- fusion_ledger_id
                                          ,NULL                                                        -- fusion_ledger_name
                                          ,StgTable_tbl(GLBalances_idx).accounting_date                -- accounting_date
                                          ,StgTable_tbl(GLBalances_idx).user_je_source_name            -- user_je_source_name
                                          ,StgTable_tbl(GLBalances_idx).user_je_category_name          -- user_je_category_name
                                          ,StgTable_tbl(GLBalances_idx).currency_code                  -- currency_code
                                          ,StgTable_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                          ,StgTable_tbl(GLBalances_idx).actual_flag                    -- actual_flag
                                          ,StgTable_tbl(GLBalances_idx).segment1                       -- segment1
                                          ,StgTable_tbl(GLBalances_idx).segment2                       -- segment2
                                          ,StgTable_tbl(GLBalances_idx).segment3                       -- segment3
                                          ,StgTable_tbl(GLBalances_idx).segment4                       -- segment4
                                          ,StgTable_tbl(GLBalances_idx).segment5                       -- segment5
                                          ,StgTable_tbl(GLBalances_idx).segment6                       -- segment6
                                          ,StgTable_tbl(GLBalances_idx).segment7                       -- segment7
                                          ,StgTable_tbl(GLBalances_idx).segment8                       -- segment8
                                          ,StgTable_tbl(GLBalances_idx).segment9                       -- segment9
                                          ,StgTable_tbl(GLBalances_idx).segment10                      -- segment10
                                          ,StgTable_tbl(GLBalances_idx).segment11                      -- segment11
                                          ,StgTable_tbl(GLBalances_idx).segment12                      -- segment12
                                          ,StgTable_tbl(GLBalances_idx).segment13                      -- segment13
                                          ,StgTable_tbl(GLBalances_idx).segment14                      -- segment14
                                          ,StgTable_tbl(GLBalances_idx).segment15                      -- segment15
                                          ,StgTable_tbl(GLBalances_idx).segment16                      -- segment16
                                          ,StgTable_tbl(GLBalances_idx).segment17                      -- segment17
                                          ,StgTable_tbl(GLBalances_idx).segment18                      -- segment18
                                          ,StgTable_tbl(GLBalances_idx).segment19                      -- segment19
                                          ,StgTable_tbl(GLBalances_idx).segment20                      -- segment20
                                          ,StgTable_tbl(GLBalances_idx).segment21                      -- segment21
                                          ,StgTable_tbl(GLBalances_idx).segment22                      -- segment22
                                          ,StgTable_tbl(GLBalances_idx).segment23                      -- segment23
                                          ,StgTable_tbl(GLBalances_idx).segment24                      -- segment24
                                          ,StgTable_tbl(GLBalances_idx).segment25                      -- segment25
                                          ,StgTable_tbl(GLBalances_idx).segment26                      -- segment26
                                          ,StgTable_tbl(GLBalances_idx).segment27                      -- segment27
                                          ,StgTable_tbl(GLBalances_idx).segment28                      -- segment28
                                          ,StgTable_tbl(GLBalances_idx).segment29                      -- segment29
                                          ,StgTable_tbl(GLBalances_idx).segment30                      -- segment30
                                          ,StgTable_tbl(GLBalances_idx).entered_dr                     -- entered_dr
                                          ,StgTable_tbl(GLBalances_idx).entered_cr                     -- entered_cr
                                          ,StgTable_tbl(GLBalances_idx).accounted_dr                   -- accounted_dr
                                          ,StgTable_tbl(GLBalances_idx).accounted_cr                   -- accounted_cr
                                          ,StgTable_tbl(GLBalances_idx).reference1                     -- reference1
                                          ,StgTable_tbl(GLBalances_idx).reference2                     -- reference2
                                          ,StgTable_tbl(GLBalances_idx).reference3                     -- reference3
                                          ,StgTable_tbl(GLBalances_idx).reference4                     -- reference4
                                          ,StgTable_tbl(GLBalances_idx).reference5                     -- reference5
                                          ,StgTable_tbl(GLBalances_idx).reference6                     -- reference6
                                          ,StgTable_tbl(GLBalances_idx).reference7                     -- reference7
                                          ,StgTable_tbl(GLBalances_idx).reference8                     -- reference8
                                          ,StgTable_tbl(GLBalances_idx).reference9                     -- reference9
                                          ,StgTable_tbl(GLBalances_idx).reference10                    -- reference10
                                          ,StgTable_tbl(GLBalances_idx).reference21                    -- reference21
                                          ,StgTable_tbl(GLBalances_idx).reference22                    -- reference22
                                          ,StgTable_tbl(GLBalances_idx).reference23                    -- reference23
                                          ,StgTable_tbl(GLBalances_idx).reference24                    -- reference24
                                          ,StgTable_tbl(GLBalances_idx).reference25                    -- reference25
                                          ,StgTable_tbl(GLBalances_idx).reference26                    -- reference26
                                          ,StgTable_tbl(GLBalances_idx).reference27                    -- reference27
                                          ,StgTable_tbl(GLBalances_idx).reference28                    -- reference28
                                          ,StgTable_tbl(GLBalances_idx).reference29                    -- reference29
                                          ,StgTable_tbl(GLBalances_idx).reference30                    -- reference30
                                          ,StgTable_tbl(GLBalances_idx).stat_amount                    -- stat_amount
                                          ,StgTable_tbl(GLBalances_idx).user_currency_conversion_type  -- user_currency_conversion_type
                                          ,StgTable_tbl(GLBalances_idx).currency_conversion_date       -- currency_conversion_date
                                          ,StgTable_tbl(GLBalances_idx).currency_conversion_rate       -- currency_conversion_rate
                                          ,StgTable_tbl(GLBalances_idx).migration_set_id               -- group_id
                                          ,StgTable_tbl(GLBalances_idx).attribute_category             -- attribute_category
                                          ,StgTable_tbl(GLBalances_idx).attribute1                     -- attribute1
                                          ,StgTable_tbl(GLBalances_idx).attribute2                     -- attribute2
                                          ,StgTable_tbl(GLBalances_idx).attribute3                     -- attribute3
                                          ,StgTable_tbl(GLBalances_idx).attribute4                     -- attribute4
                                          ,StgTable_tbl(GLBalances_idx).attribute5                     -- attribute5
                                          ,StgTable_tbl(GLBalances_idx).attribute6                     -- attribute6
                                          ,StgTable_tbl(GLBalances_idx).attribute7                     -- attribute7
                                          ,StgTable_tbl(GLBalances_idx).attribute8                     -- attribute8
                                          ,StgTable_tbl(GLBalances_idx).attribute9                     -- attribute9
                                          ,StgTable_tbl(GLBalances_idx).attribute10                    -- attribute10
                                          ,StgTable_tbl(GLBalances_idx).attribute11                    -- attribute11
                                          ,StgTable_tbl(GLBalances_idx).attribute12                    -- attribute12
                                          ,StgTable_tbl(GLBalances_idx).attribute13                    -- attribute13
                                          ,StgTable_tbl(GLBalances_idx).attribute14                    -- attribute14
                                          ,StgTable_tbl(GLBalances_idx).attribute15                    -- attribute15
                                          ,StgTable_tbl(GLBalances_idx).attribute16                    -- attribute16
                                          ,StgTable_tbl(GLBalances_idx).attribute17                    -- attribute17
                                          ,StgTable_tbl(GLBalances_idx).attribute18                    -- attribute18
                                          ,StgTable_tbl(GLBalances_idx).attribute19                    -- attribute19
                                          ,StgTable_tbl(GLBalances_idx).attribute20                    -- attribute20
                                          ,StgTable_tbl(GLBalances_idx).attribute_category3            -- attribute_category3
                                          ,StgTable_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                          ,StgTable_tbl(GLBalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                          ,StgTable_tbl(GLBalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                          ,StgTable_tbl(GLBalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                          ,StgTable_tbl(GLBalances_idx).period_name                    -- period_name
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                    gvb_SimpleTransformsRequired := TRUE;
                    gvb_DataEnrichmentRequired   := FALSE;
                    --
                    IF   gvb_SimpleTransformsRequired
                    OR   gvb_DataEnrichmentRequired
                    THEN
                         --
                         /*
                         ** Check for and perform any Simple Transforms and/or Data Enrichment to be performed in PL/SQL.
                         */
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
                                   ,pt_i_PackageName         => gcv_PackageName
                                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                              ** Verify LEDGER_NAME transformations exist.
                              */
                              --
                              gvt_TransformCategoryCode := 'LEDGER_NAME';
                              --
                              IF   xxmx_utilities_pkg.simple_transform_exists
                                        (
                                         gct_ApplicationSuite
                                        ,gct_Application
                                        ,gvt_TransformCategoryCode
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - Simple transforms have NOT been defined for transform category code "'
                                                                   ||gvt_TransformCategoryCode
                                                                   ||'.  These are expected.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF   xxmx_utilities_pkg.simple_transform_exists
                              --
                              gvv_ProgressIndicator := '0130';
                              --
                              /*
                              ** Verify FUSION_LEDGER_ID transformations exist.
                              */
                              --
                              gvt_TransformCategoryCode := 'FUSION_LEDGER_ID';
                              --
                              IF   xxmx_utilities_pkg.simple_transform_exists
                                        (
                                         gct_ApplicationSuite
                                        ,gct_Application
                                        ,gvt_TransformCategoryCode
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '- Simple Transformations are required for Sub-Entity "'
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
                                   ,pt_i_PackageName         => gcv_PackageName
                                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Verifying that data enrichment setup that applies to "'
                                                              ||pt_i_SubEntity
                                                              ||'" has been performed .'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvb_MissingDataEnrichment := FALSE;
                              --
                              gvt_ParameterCode := '?????';
                              --
                              gvv_ParameterCheckResult := xxmx_utilities_pkg.verify_parameter_exists
                                                               (
                                                                pt_i_ApplicationSuite => gct_ApplicationSuite
                                                               ,pt_i_Application      => gct_Application
                                                               ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                               ,pt_i_SubEntity        => 'ALL'
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ,pt_i_PackageName         => gcv_PackageName
                                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                   ,pt_i_PackageName         => gcv_PackageName
                                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                        ** Transform Ledger Name
                                        */
                                        --
                                        gvv_ProgressIndicator := '0160';
                                        --
                                        vt_FusionLedgerName := NULL;
                                        --
                                        vt_FusionLedgerName := xxmx_utilities_pkg.get_transform_fusion_value
                                                                    (
                                                                     pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                    ,pt_i_Application      => gct_Application
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
                                        ELSE
                                             --
                                             /*
                                             ** Transform Fusion Ledger Name to Fusion Ledger ID
                                             */
                                             --
                                             gvv_ProgressIndicator := '0170';
                                             --
                                             vt_FusionLedgerID := NULL;
                                             --
                                             vt_FusionLedgerID := xxmx_utilities_pkg.get_transform_fusion_value
                                                                        (
                                                                         pt_i_ApplicationSuite => gct_ApplicationSuite
                                                                        ,pt_i_Application      => gct_Application
                                                                        ,pt_i_CategoryCode     => 'FUSION_LEDGER_ID'
                                                                        ,pt_i_SourceValue      => vt_FusionLedgerName
                                                                        );
                                             --
                                             IF   vt_FusionLedgerID IS NULL
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
                                                       ,pt_i_RecordIdentifiers     => 'fusion_ledger_name'
                                                                                    ||'['||XfmTableUpd_rec.source_ledger_name||']'
                                                       ,pt_i_DataMessage           => 'No simple transform from Fusion Ledger Name to Fusion Ledger ID exists.'
                                                       ,pt_i_DataElementsAndValues => 'No transform result.'
                                                       );
                                                  --
                                             END IF; --** IF   vt_FusionLedgerID IS NULL
                                             --
                                        END IF; --** IF   vt_FusionLedgerName IS NULL
                                        --
                                        --<< Simple transform 3 here >>
                                        --
                                   END IF;  --** IF   gvb_SimpleTransformsRequired
                                   --
                                   /*
                                   ** Now perform any Data Enrichment logic.
                                   */
                                   --
                                   IF   gvb_DataEnrichmentRequired
                                   THEN
                                        --
                                        /*
                                        ** No Data Enrichment is required for GL Balances.
                                        */
                                        --
                                        NULL;
                                        --
                                   END IF;
                                   --
                                   gvv_ProgressIndicator := '0180';
                                   --
                                   /*
                                   ** Update the current row of the XFM table for all transforms.
                                   **
                                   ** If you add more column transforms above, don't forget to add them
                                   ** to the UPDATE statement.
                                   */
                                   --
                                   UPDATE  xxmx_gl_balances_xfm
                                   SET     migration_status   = vt_MigrationStatus
                                          ,fusion_ledger_id   = vt_FusionLedgerID    --** Simple Transformation
                                          ,fusion_ledger_name = vt_FusionLedgerName  --** Simple Transformation
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
                                   ,pt_i_PackageName         => gcv_PackageName
                                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                                   ,pt_i_PackageName         => gcv_PackageName
                                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               gvv_ProgressIndicator := '0220';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => pt_i_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               gvv_ProgressIndicator := '0230';
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
                    gvv_ProgressIndicator := '0240';
                    --
                    gvb_PerformComplexTransforms := FALSE;
                    --
                    FOR  XfmSourceLedger_rec
                    IN   XfmSourceLedgers_cur
                    LOOP
                         --
                         xxmx_gl_utilities_pkg.verify_gl_account_transforms
                              (
                               pt_i_ApplicationSuite       => gct_ApplicationSuite
                              ,pt_i_Application            => gct_Application
                              ,pt_i_BusinessEntity         => 'ALL'
                              ,pt_i_SubEntity              => 'ALL'
                              ,pt_i_SourceLedgerName       => XfmSourceLedger_rec.source_ledger_name
                              ,pn_o_TransformRowCount      => vn_TransformRowCount
                              ,pb_o_UnfrozenTransforms     => vb_UnfrozenTransforms
                              ,pt_o_TransformEvaluationMsg => vt_TransformEvaluationMsg
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
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - '
                                                         ||vt_TransformEvaluationMsg
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         IF   vn_TransformRowCount > 0
                         THEN
                              --
                              gvb_PerformComplexTransforms := TRUE;
                              --
                         END IF;
                         --
                    END LOOP; --** XfmSourceLedgers_cur LOOP
                    --
                    gvv_ProgressIndicator := '0250';
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
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - Performing complex transformations for the "'
                                                         ||pt_i_SubEntity
                                                         ||'" data in the "'
                                                         ||ct_XfmTable
                                                         ||'" table.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0260';
                         --
                         FOR  XfmTableUpd_rec
                         IN   XfmTableUpd_cur
                                   (
                                    pt_i_MigrationSetID
                                   )
                         LOOP
                              --
                              gvv_ProgressIndicator := '0270';
                              --
                              vt_MigrationStatus := XfmTableUpd_rec.migration_status;
                              --
                              xxmx_gl_utilities_pkg.transform_gl_account
                                   (
                                    pt_i_ApplicationSuite     => gct_ApplicationSuite
                                   ,pt_i_Application          => gct_Application
                                   ,pt_i_BusinessEntity       => 'ALL'
                                   ,pt_i_SubEntity            => 'ALL'
                                   ,pt_i_SourceLedgerName     => XfmTableUpd_rec.source_ledger_name
                                   ,pt_i_SourceSegment1       => XfmTableUpd_rec.segment1
                                   ,pt_i_SourceSegment2       => XfmTableUpd_rec.segment2
                                   ,pt_i_SourceSegment3       => XfmTableUpd_rec.segment3
                                   ,pt_i_SourceSegment4       => XfmTableUpd_rec.segment4
                                   ,pt_i_SourceSegment5       => XfmTableUpd_rec.segment5
                                   ,pt_i_SourceSegment6       => XfmTableUpd_rec.segment6
                                   ,pt_i_SourceSegment7       => XfmTableUpd_rec.segment7
                                   ,pt_i_SourceSegment8       => XfmTableUpd_rec.segment8
                                   ,pt_i_SourceSegment9       => XfmTableUpd_rec.segment9
                                   ,pt_i_SourceSegment10      => XfmTableUpd_rec.segment10
                                   ,pt_i_SourceSegment11      => XfmTableUpd_rec.segment11
                                   ,pt_i_SourceSegment12      => XfmTableUpd_rec.segment12
                                   ,pt_i_SourceSegment13      => XfmTableUpd_rec.segment13
                                   ,pt_i_SourceSegment14      => XfmTableUpd_rec.segment14
                                   ,pt_i_SourceSegment15      => XfmTableUpd_rec.segment15
                                   ,pt_i_SourceSegment16      => XfmTableUpd_rec.segment16
                                   ,pt_i_SourceSegment17      => XfmTableUpd_rec.segment17
                                   ,pt_i_SourceSegment18      => XfmTableUpd_rec.segment18
                                   ,pt_i_SourceSegment19      => XfmTableUpd_rec.segment19
                                   ,pt_i_SourceSegment20      => XfmTableUpd_rec.segment20
                                   ,pt_i_SourceSegment21      => XfmTableUpd_rec.segment21
                                   ,pt_i_SourceSegment22      => XfmTableUpd_rec.segment22
                                   ,pt_i_SourceSegment23      => XfmTableUpd_rec.segment23
                                   ,pt_i_SourceSegment24      => XfmTableUpd_rec.segment24
                                   ,pt_i_SourceSegment25      => XfmTableUpd_rec.segment25
                                   ,pt_i_SourceSegment26      => XfmTableUpd_rec.segment26
                                   ,pt_i_SourceSegment27      => XfmTableUpd_rec.segment27
                                   ,pt_i_SourceSegment28      => XfmTableUpd_rec.segment28
                                   ,pt_i_SourceSegment29      => XfmTableUpd_rec.segment29
                                   ,pt_i_SourceSegment30      => XfmTableUpd_rec.segment30
                                   ,pt_i_SourceConcatSegments => NULL
                                   ,pt_o_FusionSegment1       => vt_FusionSegment1
                                   ,pt_o_FusionSegment2       => vt_FusionSegment2
                                   ,pt_o_FusionSegment3       => vt_FusionSegment3
                                   ,pt_o_FusionSegment4       => vt_FusionSegment4
                                   ,pt_o_FusionSegment5       => vt_FusionSegment5
                                   ,pt_o_FusionSegment6       => vt_FusionSegment6
                                   ,pt_o_FusionSegment7       => vt_FusionSegment7
                                   ,pt_o_FusionSegment8       => vt_FusionSegment8
                                   ,pt_o_FusionSegment9       => vt_FusionSegment9
                                   ,pt_o_FusionSegment10      => vt_FusionSegment10
                                   ,pt_o_FusionSegment11      => vt_FusionSegment11
                                   ,pt_o_FusionSegment12      => vt_FusionSegment12
                                   ,pt_o_FusionSegment13      => vt_FusionSegment13
                                   ,pt_o_FusionSegment14      => vt_FusionSegment14
                                   ,pt_o_FusionSegment15      => vt_FusionSegment15
                                   ,pt_o_FusionSegment16      => vt_FusionSegment16
                                   ,pt_o_FusionSegment17      => vt_FusionSegment17
                                   ,pt_o_FusionSegment18      => vt_FusionSegment18
                                   ,pt_o_FusionSegment19      => vt_FusionSegment19
                                   ,pt_o_FusionSegment20      => vt_FusionSegment20
                                   ,pt_o_FusionSegment21      => vt_FusionSegment21
                                   ,pt_o_FusionSegment22      => vt_FusionSegment22
                                   ,pt_o_FusionSegment23      => vt_FusionSegment23
                                   ,pt_o_FusionSegment24      => vt_FusionSegment24
                                   ,pt_o_FusionSegment25      => vt_FusionSegment25
                                   ,pt_o_FusionSegment26      => vt_FusionSegment26
                                   ,pt_o_FusionSegment27      => vt_FusionSegment27
                                   ,pt_o_FusionSegment28      => vt_FusionSegment28
                                   ,pt_o_FusionSegment29      => vt_FusionSegment29
                                   ,pt_o_FusionSegment30      => vt_FusionSegment30
                                   ,pt_o_FusionConcatSegments => vt_FusionConcatSegments
                                   ,pv_o_ReturnStatus         => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage        => gvt_ReturnMessage
                                   );
                              --
                              gvv_ProgressIndicator := '0280';
                              --
                              IF   gvv_ReturnStatus = 'E'
                              THEN
                                   --
                                   IF   XfmTableUpd_rec.migration_status = 'SIMPLE_TRANSFORM_FAILED'
                                   THEN
                                        --
                                        vt_MigrationStatus := 'SIMPLE_AND_COMPLEX_TRANSFORM_FAILED';
                                        --
                                   ELSE
                                        --
                                        vt_MigrationStatus := 'COMPLEX_TRANSFORM_FAILED';
                                        --
                                   END IF;
                                   --
                                   gvv_ProgressIndicator := '0290';
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
                                        ,pt_i_RecordIdentifiers     => 'source_ledger_name['||XfmTableUpd_rec.source_ledger_name||']'
                                                                     ||'~'
                                                                     ||'segment1'
                                                                     ||'['||vt_FusionSegment1||']'
                                                                     ||'~'
                                                                     ||'segment2'
                                                                     ||'['||vt_FusionSegment2||']'
                                                                     ||'~'
                                                                     ||'segment3'
                                                                     ||'['||vt_FusionSegment3||']'
                                                                     ||'~'
                                                                     ||'segment4'
                                                                     ||'['||vt_FusionSegment4||']'
                                                                     ||'~'
                                                                     ||'segment5'
                                                                     ||'['||vt_FusionSegment5||']'
                                                                     ||'~'
                                                                     ||'segment6'
                                                                     ||'['||vt_FusionSegment6||']'
                                                                     ||'~'
                                                                     ||'segment7'
                                                                     ||'['||vt_FusionSegment7||']'
                                        ,pt_i_DataMessage           => 'No GL Account exists.'
                                        ,pt_i_DataElementsAndValues => 'No transformation result.'
                                        );
                                   --
                              ELSIF gvv_ReturnStatus = 'W'
                              THEN
                                   --
                                   vt_MigrationStatus := 'GL_ACCOUNT_TRANSFORM_REVIEW';
                                   --
                                   gvv_ProgressIndicator := '0300';
                                   --
                                   xxmx_utilities_pkg.log_data_message
                                        (
                                         pt_i_ApplicationSuite      => gct_ApplicationSuite
                                        ,pt_i_Application           => gct_Application
                                        ,pt_i_BusinessEntity        => gct_BusinessEntity
                                        ,pt_i_SubEntity             => pt_i_SubEntity
                                        ,pt_i_MigrationSetID        => pt_i_MigrationSetID
                                        ,pt_i_Phase                 => ct_Phase
                                        ,pt_i_Severity              => 'WARNING'
                                        ,pt_i_DataTable             => ct_XfmTable
                                        ,pt_i_RecordIdentifiers     => 'fusion_ledger_name['||XfmTableUpd_rec.fusion_ledger_name||']'
                                                                     ||'~'
                                                                     ||'segment1'
                                                                     ||'['||vt_FusionSegment1||']'
                                                                     ||'~'
                                                                     ||'segment2'
                                                                     ||'['||vt_FusionSegment2||']'
                                                                     ||'~'
                                                                     ||'segment3'
                                                                     ||'['||vt_FusionSegment3||']'
                                                                     ||'~'
                                                                     ||'segment4'
                                                                     ||'['||vt_FusionSegment4||']'
                                                                     ||'~'
                                                                     ||'segment5'
                                                                     ||'['||vt_FusionSegment5||']'
                                                                     ||'~'
                                                                     ||'segment6'
                                                                     ||'['||vt_FusionSegment6||']'
                                                                     ||'~'
                                                                     ||'segment7'
                                                                     ||'['||vt_FusionSegment7||']'
                                        ,pt_i_DataMessage           => 'Unfrozen transform. Please review the data in the "xxmx_gl_account_transforms" table.'
                                        ,pt_i_DataElementsAndValues => 'Record identifiers are the transformed values.'
                                        );
                                   --
                              END IF;
                              --
                              gvv_ProgressIndicator := '0310';
                              --
                              /*
                              ** Update the current row of the XFM table for all complex transforms.
                              */
                              --
                              UPDATE  xxmx_gl_balances_xfm
                              SET     migration_status = vt_MigrationStatus
                                     ,segment1         = vt_FusionSegment1
                                     ,segment2         = vt_FusionSegment2
                                     ,segment3         = vt_FusionSegment3
                                     ,segment4         = vt_FusionSegment4
                                     ,segment5         = vt_FusionSegment5
                                     ,segment6         = vt_FusionSegment6
                                     ,segment7         = vt_FusionSegment7
                                     ,segment8         = vt_FusionSegment8
                                     ,segment9         = vt_FusionSegment9
                                     ,segment10        = vt_FusionSegment10
                                     ,segment11        = vt_FusionSegment11
                                     ,segment12        = vt_FusionSegment12
                                     ,segment13        = vt_FusionSegment13
                                     ,segment14        = vt_FusionSegment14
                                     ,segment15        = vt_FusionSegment15
                                     ,segment16        = vt_FusionSegment16
                                     ,segment17        = vt_FusionSegment17
                                     ,segment18        = vt_FusionSegment18
                                     ,segment19        = vt_FusionSegment19
                                     ,segment20        = vt_FusionSegment20
                                     ,segment21        = vt_FusionSegment21
                                     ,segment22        = vt_FusionSegment22
                                     ,segment23        = vt_FusionSegment23
                                     ,segment24        = vt_FusionSegment24
                                     ,segment25        = vt_FusionSegment25
                                     ,segment26        = vt_FusionSegment26
                                     ,segment27        = vt_FusionSegment27
                                     ,segment28        = vt_FusionSegment28
                                     ,segment29        = vt_FusionSegment29
                                     ,segment30        = vt_FusionSegment30
                                     ,reference22      = vt_FusionConcatSegments
                              WHERE CURRENT OF XfmTableUpd_cur;
                              --
                         END LOOP; --** XfmTableUpd_cur LOOP
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
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gcv_PackageName
                              ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Complex transformation complete.'
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
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'WARNING'
                              ,pt_i_PackageName       => gcv_PackageName
                              ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          --
          EXCEPTION
               --
               --
               WHEN e_ModuleError
               THEN
                    --
                    --
                    IF   StgTable_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE StgTable_cur;
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
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
                    IF   StgTable_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE StgTable_cur;
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
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
     END gl_balances_xfm;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'EXTRACT';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
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
          --          ,pt_i_PackageName       => gcv_PackageName
          --          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
          ** Clear GL Balances Module Messages
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
          --      pt_i_ApplicationSuite  => gct_ApplicationSuite
          --     ,pt_i_Application       => gct_Application
          --     ,pt_i_BusinessEntity    => gct_BusinessEntity
          --     ,pt_i_SubEntity         => ct_SubEntity
          --     ,pt_i_Phase             => ct_Phase
          --     ,pt_i_Severity          => 'NOTIFICATION'
          --     ,pt_i_PackageName       => gcv_PackageName
          --     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_MigrationSetName  => pt_i_MigrationSetName
               ,pt_o_MigrationSetID    => vt_MigrationSetID
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
     --
     --
     --**********************
     --** PROCEDURE: xfm_main
     --**********************
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'xfm_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'TRANSFORM';
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
     END xfm_main;
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
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
          --     ,pt_i_PackageName       => gcv_PackageName
          --     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged from "'
                                             ||PurgingMetadata_rec.stg_table
                                             ||'" table: '
                                             ||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );
               --
               --gvv_SQLTableClause := 'FROM '
               --                    ||gct_XfmSchema
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
               --     ,pt_i_PackageName       => gcv_PackageName
               --     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
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
     --
     PROCEDURE update_accounted_values
                   (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   ) IS
     BEGIN
        UPDATE  XXMX_GL_BALANCES_XFM x
        SET    x.accounted_dr = x.entered_dr,
               x.accounted_cr = x.entered_cr
        WHERE  x.migration_set_id = pt_i_MigrationSetID
        AND    x.currency_code = (SELECT s.currency_code
                                  FROM    xxmx_gl_source_structures s
                                  WHERE  s.source_ledger_name = x.source_ledger_name);
     EXCEPTION
        WHEN OTHERS THEN
           null;
     END;
     --
     --
END xxmx_gl_balances_pkg;

/
SHOW ERRORS PACKAGE BODY xxmx_gl_balances_pkg;
/
