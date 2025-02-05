--------------------------------------------------------
--  DDL for Package Body XXMX_GL_HISTORICAL_RATES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_GL_HISTORICAL_RATES_PKG" 
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Historical Rates Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 08-11-2022     Meenakshi Rajendran        Initial version
-- ===========================================================================*/
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_gl_historicalrates_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_gl_historical_rates_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'HISTORICAL_RATES';
     gct_SubEntity                   CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'HISTORICAL_RATES';
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
     --** PROCEDURE: gl_historicalrates_stg
     --*****************************
     --

     PROCEDURE gl_historical_rates_stg
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
          -- Cursor to get the historical rates
          --
          CURSOR GLHistoricalrates_cur 
		              (
						pv_LedgerName VARCHAR2
                       ,pv_PeriodName VARCHAR2						
					  )
          IS
             --
             --
			        SELECT *
					FROM 
						(SELECT
								gl.name       ledger_name,
								'INSERT'      import_action,
								gcc.segment1  segment1,
								gcc.segment2  segment2,
								gcc.segment3  segment3,
								gcc.segment4  segment4,
								gcc.segment5  segment5,
								gcc.segment6  segment6,
                                gcc.segment7  segment7,
                                gcc.segment8  segment8,
                                gcc.segment9  segment9,
                                gcc.segment10  segment10,
                                gcc.segment11  segment11,
                                gcc.segment12  segment12,
                                gcc.segment13  segment13,
                                gcc.segment14  segment14,
                                gcc.segment15  segment15,
                                gcc.segment16  segment16,
                                gcc.segment17  segment17,
                                gcc.segment18  segment18,
                                gcc.segment19  segment19,
                                gcc.segment20  segment20,
                                gcc.segment21  segment21,
                                gcc.segment22  segment22,
                                gcc.segment23  segment23,
                                gcc.segment24  segment24,
                                gcc.segment25  segment25,
                                gcc.segment26  segment26,
                                gcc.segment27  segment27,
                                gcc.segment28  segment28,
                                gcc.segment29  segment29,
                                gcc.segment30  segment30,
								INITCAP(gp.period_name) period_name,
								glb.currency_code target_currency_code,
								'AMOUNT' value_type_code,
								 SUM(CASE WHEN glb.currency_code = gl.currency_code THEN
										(nvl(glb.begin_balance_dr_beq, 0) - nvl(glb.begin_balance_cr_beq, 0))
									   +(nvl(glb.period_net_dr_beq, 0) - nvl(glb.period_net_cr_beq, 0))
									 ELSE
										(nvl(glb.begin_balance_dr, 0) - nvl(glb.begin_balance_cr, 0)) 
									   +(nvl(glb.period_net_dr, 0) - nvl(glb.period_net_cr, 0))
									 END       
								)credit_amount_rate,
								(
								CASE /*WHEN gl.ret_earn_code_combination_id=gcc.code_combination_id THEN 
									  'YES'*/
									  WHEN (select gcc1.segment2 from apps.gl_code_combinations@xxmx_extract gcc1 where gcc1.CODE_COMBINATION_ID= gl.ret_earn_code_combination_id)=gcc.segment2 THEN --added by Laxmikanth 
									  'YES'
									  ELSE 
									  'NO'
									  END
								)auto_roll_forward_flag       
							FROM
								apps.gl_ledgers@xxmx_extract           gl,
								apps.gl_balances@xxmx_extract          glb,
								apps.gl_code_combinations@xxmx_extract gcc,
								apps.gl_periods@xxmx_extract           gp
							WHERE
								1 = 1
								AND gl.name = pv_LedgerName
								AND gl.ledger_id = glb.ledger_id
								AND gcc.code_combination_id = glb.code_combination_id
								AND glb.period_name = gp.period_name
								AND gl.period_set_name=gp.period_set_name --added by Laxmikanth for duplicate fix
								AND gp.period_name = pv_PeriodName
								AND glb.actual_flag = 'A'
								AND nvl(glb.translated_flag, 'X') IN ( 'Y')
								AND glb.template_id IS NULL
								AND glb.currency_code != 'STAT'
							GROUP BY     
								gl.name,gcc.segment1,gcc.segment2,gcc.segment3,gcc.segment4,gcc.segment5,
								gcc.segment6,gcc.segment7,gcc.segment8,gcc.segment9,gcc.segment10,
                                gcc.segment11,gcc.segment12,gcc.segment13,gcc.segment14,gcc.segment15,
                                gcc.segment16,gcc.segment17,gcc.segment18,gcc.segment19,gcc.segment20,
                                gcc.segment21,gcc.segment22,gcc.segment23,gcc.segment24,gcc.segment25,
                                gcc.segment26,gcc.segment27,gcc.segment28,gcc.segment29,gcc.segment30,
								gp.period_name,glb.currency_code,gl.ret_earn_code_combination_id,
								gcc.code_combination_id
							)ghr
					WHERE 1=1
					AND credit_amount_rate != 0
					ORDER BY
						1,10,3,4,5,6,7,8;


          --
          -- Cursor to get the ledger names
          -- 
          CURSOR getLedger_cur
          IS          
          SELECT * 
          FROM   XXMX_CORE.XXMX_HISTRATE_LEDGER_SCOPE_V;

          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
		  TYPE LedgerName_tt IS TABLE of XXMX_CORE.XXMX_HISTRATE_LEDGER_SCOPE_V%ROWTYPE INDEX BY BINARY_INTEGER;
          TYPE gl_historicalrates_tt IS TABLE OF GLHistoricalrates_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_historical_rates_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_historicalrates_stg';
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
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
		  vt_periodname                   VARCHAR2(30);
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
		  LedgerScope_tbl1                LedgerName_tt;
          gl_historicalrates_tbl          gl_historicalrates_tt;
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
	vt_MigrationSetID := pt_i_MigrationSetID;
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
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               ,pt_i_MigrationSetID    => vt_MigrationSetID
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
    --** If the Migration Set ID is NULL then the Migration has not been initialized.
    --
    IF   vt_MigrationSetID IS NOT NULL THEN
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving ledger details from scope table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
        gvv_ProgressIndicator := '0045';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
		        --
        begin
            OPEN  getLedger_cur;
            FETCH getLedger_cur
                       BULK COLLECT
                       INTO  LedgerScope_tbl1;
            CLOSE getLedger_cur;
        exception
            when others then
                   xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                        ,pt_i_Application       => gct_Application
                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                        ,pt_i_SubEntity         => gct_SubEntity
                        ,pt_i_MigrationSetID    => vt_MigrationSetID
                        ,pt_i_Phase             => ct_Phase
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => gcv_PackageName
                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '    - err: '||sqlerrm
                        ,pt_i_OracleError       => NULL
                        );
        end;
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Ledger scope count: '||LedgerScope_tbl1.count()
                    ,pt_i_OracleError       => NULL
                    );
        --

		vt_periodname := xxmx_utilities_pkg.get_single_parameter_value
        (
                     pt_i_ApplicationSuite           => gct_ApplicationSuite
                    ,pt_i_Application                => gct_Application
                    ,pt_i_BusinessEntity             => gct_BusinessEntity
                    ,pt_i_SubEntity                  => gct_SubEntity
                    ,pt_i_ParameterCode              => 'PERIOD_NAME'
        );
        xxmx_utilities_pkg.log_module_message
        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - vt_periodname='||vt_periodname
                         ,pt_i_OracleError       => NULL
        );

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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Extracting GL Historicalrates for specific '
                         ,pt_i_OracleError       => NULL
                         );
                    --
		--  loop through the Ledger Name list
        gvv_ProgressIndicator := '060';
        --
		FOR LedgerName_idx
            IN LedgerScope_tbl1.FIRST..LedgerScope_tbl1.LAST
            LOOP
                xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => gct_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Ledger name.'
                                 ,pt_i_OracleError       => NULL
                                 );

			    xxmx_utilities_pkg.log_module_message
                                   (
                                   pt_i_ApplicationSuite  => gct_ApplicationSuite
                                  ,pt_i_Application       => gct_Application
                                  ,pt_i_BusinessEntity    => gct_BusinessEntity
                                  ,pt_i_SubEntity         => gct_SubEntity
                                  ,pt_i_MigrationSetID    => vt_MigrationSetID
                                  ,pt_i_Phase             => ct_Phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gcv_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => '      - Extracting "'
                                                            ||gct_Application
                                                            ||' '
                                                            ||gct_SubEntity
                                                            ||'" for GL Ledger Name "'
                                                            ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                            ||'", Period Name "'
                                                            ||vt_periodname
                                                            ||'".'
                                  ,pt_i_OracleError       => NULL
                                   );

        gvv_ProgressIndicator := '0140';
        --
        OPEN GLHistoricalrates_cur(LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME,vt_periodname);
        --
        gvv_ProgressIndicator := '0150';
        --
            LOOP
            --
            FETCH        GLHistoricalrates_cur
                BULK COLLECT
                INTO         gl_historicalrates_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    gl_historicalrates_tbl.COUNT = 0;
            --
                xxmx_utilities_pkg.log_module_message
                        (
                        pt_i_ApplicationSuite  => gct_ApplicationSuite
                       ,pt_i_Application       => gct_Application
                       ,pt_i_BusinessEntity    => gct_BusinessEntity
                       ,pt_i_SubEntity         => gct_SubEntity
                       ,pt_i_MigrationSetID    => vt_MigrationSetID
                       ,pt_i_Phase             => ct_Phase
                       ,pt_i_Severity          => 'NOTIFICATION'
                       ,pt_i_PackageName       => gcv_PackageName
                       ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                       ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                       ,pt_i_ModuleMessage     => '    - Record Count '||gl_historicalrates_tbl.COUNT
                       ,pt_i_OracleError       => NULL
                        );
                                --			
            gvv_ProgressIndicator := '0160';
            --
            FORALL GLHistoricalrates_idx 
                IN 1..gl_historicalrates_tbl.COUNT
            --
                INSERT
                INTO   xxmx_stg.xxmx_gl_historicalrates_stg
                (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,ledger_name
                                                              ,import_action
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
															  ,period_name
															  ,target_currency_code
															  ,value_type_code
															  ,credit_amount_rate
															  ,auto_roll_forward_flag
															  ,attribute_category
															  ,attribute1
															  ,attribute2
															  ,attribute3
															  ,attribute4
															  ,attribute5

                )
                VALUES
                (
                                                               vt_MigrationSetID                                             -- migration_set_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).ledger_name     -- ledger_name
															  ,gl_historicalrates_tbl(GLHistoricalrates_idx).import_action   --import_action
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment1        -- segment1
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment2        -- segment2
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment3        -- segment3
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment4        -- segment4
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment5        -- segment5
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment6        -- segment6
															  ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment7        -- segment7
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment8        -- segment8
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment9        -- segment9
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment10       -- segment10
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment11       -- segment11
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment12       -- segment12
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment13       -- segment13
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment14       -- segment14
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment15       -- segment15
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment16       -- segment16
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment17       -- segment17
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment18       -- segment18
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment19       -- segment19
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment20       -- segment20
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment21       -- segment21
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment22       -- segment22
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment23       -- segment23
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment24       -- segment24
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment25       -- segment25
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment26       -- segment26
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment27       -- segment27
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment28       -- segment28
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment29       -- segment29
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).segment30       -- segment30
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).period_name     --period_name
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).target_currency_code --target_currency_code                                                          -- attribute_date4
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).value_type_code    --value_type_code                                                          -- attribute_date5
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).credit_amount_rate --credit_amount_rate                                                          -- attribute_number1
                                                              ,gl_historicalrates_tbl(GLHistoricalrates_idx).auto_roll_forward_flag --auto_roll_forward_flag                                                          -- attribute_number2
                                                              ,NULL                                                          -- attribute_category
                                                              ,NULL                                                          -- attribute1
                                                              ,NULL                                                          -- attribute2
															  ,NULL                                                          -- attribute3
															  ,NULL                                                          -- attribute4
															  ,NULL                                                          -- attribute5
                );
                --
                --** END FORALL 
                --
            END LOOP; --** GLHistoricalrates_cur BULK COLLECT LOOP
            --
            gvv_ProgressIndicator := '0170';
            --
        CLOSE GLHistoricalrates_cur;

		 END LOOP; --** Ledger scope tbl LOOP
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
                                         ,vt_MigrationSetID
                                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                          pt_i_MigrationSetID          => vt_MigrationSetID
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    IF   GLHistoricalrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLHistoricalrates_cur;
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                    IF   GLHistoricalrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLHistoricalrates_cur;
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
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
     END gl_historical_rates_stg;
     --
     PROCEDURE gl_historical_rates_xfm
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
--                    ,pv_cutoffdate IN VARCHAR2
                    )
     IS
     BEGIN
        null;
     END gl_historical_rates_xfm;

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
    delete from xxmx_stg.xxmx_gl_historicalrates_stg where migration_set_id=pt_i_MigrationSetID;
    commit;

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

END xxmx_gl_historical_rates_pkg;

/
