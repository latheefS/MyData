create or replace PACKAGE BODY xxmx_gl_daily_rates_pkg
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Daily Rates Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 09/02/2022     Prabhat Kumar Sahu        Initial version
-- 05/05/2022     Michal Arrowsmith         add a date parameter
-- ===========================================================================*/
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_gl_dailyrates_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_gl_dailyrates_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'DAILY_RATES';
     gct_SubEntity                   CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'DAILY_RATES';
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
     e_moduleerror                             EXCEPTION;
     e_dateerror                               EXCEPTION;
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
     --
     --*****************************
     --** PROCEDURE: gl_dailyrates_stg
     --*****************************
     --

     PROCEDURE gl_daily_rates_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the daily rates
          --
          CURSOR GLDailyrates_cur (p_conv_date_param varchar2)
          IS
             --
             --
              SELECT typ.user_conversion_type
                   ,rat.from_currency 
                   ,rat.to_currency        
                   ,rat.conversion_date                 as from_conversion_date
                   ,rat.conversion_date                 as to_conversion_date
                   ,rat.conversion_rate                 as conversion_rate
                   ,rev.conversion_rate                 as inverse_rate
             FROM   gl.gl_daily_conversion_types@xxmx_extract typ
             ,      gl.gl_daily_rates@xxmx_extract            rat
             ,      gl.gl_daily_rates@xxmx_extract            rev
             WHERE  rat.conversion_type = typ.conversion_type
             and  rev.conversion_type = typ.conversion_type
             AND    rat.from_currency   < rat.to_currency 
             AND    rev.from_currency   > rev.to_currency 
             AND    rat.CONVERSION_DATE >= to_date(p_conv_date_param,'dd/mm/yyyy')
             AND    rat.CONVERSION_DATE = rev.CONVERSION_DATE
             and    rat.from_currency=rev.to_currency
             and    rat.to_currency=rev.from_currency
             and    rat.status_code = 'C'
             and    rev.status_code = 'C'
             ;
/*             SELECT typ.user_conversion_type
                   ,rat.from_currency 
                   ,rat.to_currency        
                   ,conversion_date                 as from_conversion_date
                   ,conversion_date                 as to_conversion_date
                   ,conversion_rate
             FROM   gl_daily_conversion_types@xxmx_extract typ
             ,      gl_daily_rates@xxmx_extract            rat
             WHERE  rat.conversion_type = typ.conversion_type
             AND    rat.from_currency   < rat.to_currency -- ensure pairs only shown once.
-- need to be a parameter in parameter table
             AND    CONVERSION_DATE >= to_date('01-12-2019','dd/mm/yyyy')
--             GROUP BY typ.user_conversion_type
--             ,        rat.from_currency  
--             ,        rat.to_currency
 --            ,        conversion_rate
--             ORDER BY 1,2,3
;
*/


          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE gl_dailyrates_tt IS TABLE OF GLDailyrates_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_dailyrates_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_dailyrates_stg';
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
--          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
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
          vt_cutoffdate                             varchar2(20);
          EmptyLedgerName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          gl_dailyrates_tbl               gl_dailyrates_tt;
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
               ,pt_i_SubEntity        => gct_SubEntity
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
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_SubEntity        => gct_SubEntity
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
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
    --
    gvv_ProgressIndicator := '0040';
    --
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    -- If the Migration Set Name is NULL then the Migration has not been initialized.
    --
    IF   gvt_MigrationSetName IS NULL
    THEN
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- Migration Set not initialized.';
        --
        RAISE e_ModuleError;
    ELSE
        --
        gvv_ProgressIndicator := '0050';
        --
        --
        xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    --
        xxmx_utilities_pkg.log_module_message
        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Extracting GL dailyrates for specific '
                         ,pt_i_OracleError       => NULL
                         );
                    --
        vt_cutoffdate := xxmx_utilities_pkg.get_single_parameter_value
        (
                     pt_i_ApplicationSuite           => gct_ApplicationSuite
                    ,pt_i_Application                => gct_Application
                    ,pt_i_BusinessEntity             => 'DAILY_RATES'
                    ,pt_i_SubEntity                  => 'RATES'
                    ,pt_i_ParameterCode              => 'CUT_OFF_DATE'
        );
        xxmx_utilities_pkg.log_module_message
        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - vt_cutoffdate='||vt_cutoffdate
                         ,pt_i_OracleError       => NULL
        );
        --
        gvv_ProgressIndicator := '060';
        --
        gvv_ProgressIndicator := '0140';
        --
        OPEN GLDailyrates_cur(vt_cutoffdate);
        --
        gvv_ProgressIndicator := '0150';
        --
            LOOP
            --
            FETCH        GLDailyrates_cur
                BULK COLLECT
                INTO         gl_dailyrates_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    gl_dailyrates_tbl.COUNT = 0;
            --
            gvv_ProgressIndicator := '0160';
            --
            FORALL GLdailyrates_idx 
                IN 1..gl_dailyrates_tbl.COUNT
            --
                INSERT
                INTO   xxmx_stg.xxmx_gl_dailyrates_stg
                (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,from_currency
                                                              ,to_currency
                                                              ,from_conversion_date
                                                              ,to_conversion_date
                                                              ,conversion_rate_type
                                                              ,conversion_rate
                                                              ,inverse_rate
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
                                                              ,attribute_number1
                                                              ,attribute_number2
															  ,attribute_number3
															  ,attribute_number4
															  ,attribute_number5
                )
                VALUES
                (
                                                               pt_i_MigrationSetID                                           -- migration_set_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).from_currency      -- user_conversion_type
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).to_currency             -- from_currency
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).from_conversion_date               -- to_currency
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).to_conversion_date      -- user_je_source_name
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).user_conversion_type        -- user_je_category_name
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).CONVERSION_RATE           -- currency_code
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).inverse_rate              -- inverse_rate
                                                              ,NULL                                                          -- attribute_category
                                                              ,NULL                                                          -- attribute1
                                                              ,NULL                                                          -- attribute2
                                                              ,NULL                                                          -- attribute3
                                                              ,NULL                                                          -- attribute4
                                                              ,NULL                                                          -- attribute5
                                                              ,NULL                                                          -- attribute6
                                                              ,NULL                                                          -- attribute7
                                                              ,NULL                                                          -- attribute8
                                                              ,NULL                                                          -- attribute9
                                                              ,NULL                                                          -- attribute10
                                                              ,NULL                                                          -- attribute11
                                                              ,NULL                                                          -- attribute12
                                                              ,NULL                                                          -- attribute13
                                                              ,NULL                                                          -- attribute14
                                                              ,NULL                                                          -- attribute15
                                                              ,NULL                                                          -- attribute16
                                                              ,NULL                                                          -- attribute17
                                                              ,NULL                                                          -- attribute18
                                                              ,NULL                                                          -- attribute19
                                                              ,NULL                                                          -- attribute20
                                                              ,NULL                                                          -- attribute_date1
                                                              ,NULL                                                          -- attribute_date2
                                                              ,NULL                                                          -- attribute_date3
                                                              ,NULL                                                          -- attribute_date4
                                                              ,NULL                                                          -- attribute_date5
                                                              ,NULL                                                          -- attribute_number1
                                                              ,NULL                                                          -- attribute_number2
                                                              ,NULL                                                          -- attribute_number3
                                                              ,NULL                                                          -- attribute_number4
                                                              ,NULL                                                          -- attribute_number5
                );
                --
                --** END FORALL 
                --
            END LOOP; --** GLBalances_cur BULK COLLECT LOOP
            --
            gvv_ProgressIndicator := '0170';
            --
        CLOSE GLDailyrates_cur;
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
                         ,pt_i_SubEntity         => gct_SubEntity
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
                         ,pt_i_SubEntity               => gct_SubEntity
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
                         ,pt_i_SubEntity         => gct_SubEntity
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
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    IF   GLDailyrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLDailyrates_cur;
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
                         ,pt_i_SubEntity         => gct_SubEntity
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
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    IF   GLDailyrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLDailyrates_cur;
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
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
     END gl_daily_rates_stg;
     --
     PROCEDURE gl_daily_rates_xfm
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
--                    ,pv_cutoffdate IN VARCHAR2
                    )
     IS
     BEGIN
        null;
     END gl_daily_rates_xfm;

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
    delete from xxmx_stg.xxmx_gl_dailyrates_stg where migration_set_id=pt_i_MigrationSetID;
    commit;
/*
          IF   pt_i_ClientCode     IS  NULL
          AND  pt_i_MigrationSetID IS  NULL
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          --
          -- Loop through the Migration Metadata table to retrieve
          -- the staging table names to purge for the current Business
          -- Entity.
          --
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
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          --
          -- Purge the records for the Business Entity Levels
          -- Levels from the Migration Details table.
          --
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
          --
          -- Purge the records for the Business Entity
          -- from the Migration Headers table.
          --
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
*/
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
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END purge;
     --
     --
     procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     is
        CURSOR metadata_cur
        IS
         SELECT  Entity_package_name
                ,Stg_procedure_name
                , BUSINESS_ENTITY
                ,SUB_ENTITY_SEQ
                ,sub_entity
         FROM     xxmx_migration_metadata a
         WHERE application_suite = gct_ApplicationSuite
         AND   Application = gct_Application
         AND   business_entity = gct_BusinessEntity
         AND   a.enabled_flag = 'Y'
         ORDER BY
         Business_entity_seq,
         Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
--        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_GL_BALANCES_PKG';
--        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GENERAL_LEDGER';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
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
          gvv_ReturnStatus  := '';

          --
          /*
          ** Clear Customers Module Messages
          */
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
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
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gcv_PackageName
                                            ||'.'
                                            ||cv_ProcOrFuncName
                                            ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
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

          --vt_MigrationSetID := pt_i_ClientCode;
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Migration Set "'
                                          ||pt_i_MigrationSetName
                                          ||'" initialized (Generated Migration Set ID = '
                                          ||vt_MigrationSetID
                                          ||').  Processing extracts:'
               ,pt_i_OracleError         => NULL
               );
          --
          -- First for performance reasons create a Temp table to hold details
          -- of all the sites we are to extract data for
          --
          xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SQL%ROWCOUNT || ' entries added to Customer Scope Temp Staging'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Staging Package Name, Procedure Name and table name
          ** for each extract requied for the current Business Entity.
          */
          --
          gvv_ProgressIndicator := '0050';
          --
          FOR  Metadata_rec
          IN   Metadata_cur
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Calling Procedure "'
                                               ||Metadata_rec.entity_package_name
                                               ||'.'
                                               ||Metadata_rec.stg_procedure_name
                                               ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||Metadata_rec.entity_package_name
                                 ||'.'
                                 ||Metadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'(pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity     => '''
                                 ||Metadata_rec.sub_entity||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gcv_PackageName
                                            ||'.'
                                            ||cv_ProcOrFuncName
                                            ||'" completed.'
               ,pt_i_OracleError         => NULL
               );
         --
         gvv_ProgressIndicator :='0070';
    --
    COMMIT;
    --
    --
    xxmx_utilities_pkg.log_module_message
    (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
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
                         ,pt_i_SubEntity           => gct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                         ,pt_i_SubEntity           => gct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
       --
    end stg_main;

END xxmx_gl_daily_rates_pkg;