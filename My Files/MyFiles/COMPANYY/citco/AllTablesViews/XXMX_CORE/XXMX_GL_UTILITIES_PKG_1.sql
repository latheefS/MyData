--------------------------------------------------------
--  DDL for Package Body XXMX_GL_UTILITIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_GL_UTILITIES_PKG" 
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
     ** Global Constants for use in all xxmx_gl_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gct_PackageName                 CONSTANT  xxmx_module_messages.package_name%TYPE       := 'xxmx_gl_utilities_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'XXMX';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_Phase                       CONSTANT  xxmx_module_messages.phase%TYPE              := 'CORE';
     gct_BusinessEntity              CONSTANT  xxmx_module_messages.business_entity%TYPE    := 'UTILITIES';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvt_ParameterCode                         xxmx_migration_parameters.parameter_code%TYPE;
     --
     /*
     ** Global Progress Indicator Variable for use in all Procedures/Functions within this package
     */
     --
     gvv_ApplicationErrorMessage               VARCHAR2(2048);
     gvv_ProgressIndicator                     VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages)
     */
     --
     gvv_ReturnStatus                          VARCHAR2(1);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
     gvt_MigrationSetName                      xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                             VARCHAR2(100);
     gvv_SQLTableClause                        VARCHAR2(100);
     gvv_SQLColumnList                         VARCHAR2(4000);
     gvv_SQLValuesList                         VARCHAR2(4000);
     gvv_SQLWhereClause                        VARCHAR2(4000);
     gvv_SQLStatement                          VARCHAR2(32000);
     gvv_SQLResult                             VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
     gvn_RowCount                              NUMBER;
     --
     --
     /*
     *********************************************
     ** PROCEDURE: extract_src_gl_acct_structures
     *********************************************
     */
     --
     PROCEDURE extract_src_gl_acct_structures
     IS
          --
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          -- Cursor to get the Account Structure Names and Concatenated Segment Delimiters
          --
          CURSOR SourceAccountStructures_cur
          IS
               --
               SELECT    gl.name                               AS source_ledger_name
                        ,fifs.concatenated_segment_delimiter   AS source_segment_delimiter
                        ,gl.currency_code                      AS currency_code
               FROM      gl_ledgers@MXDM_NVIS_EXTRACT                 gl
                        ,fnd_id_flexs@MXDM_NVIS_EXTRACT               fif
                        ,fnd_id_flex_structures@MXDM_NVIS_EXTRACT     fifs
               WHERE     1 = 1
               AND       fif.id_flex_name            = 'Accounting Flexfield'
               AND       fifs.id_flex_code           = fif.id_flex_code
               AND       fifs.id_flex_num            = gl.chart_of_accounts_id
               ORDER BY  gl.name;
               --
          --** END CURSOR SourceAccountStructures_cur
          --
          CURSOR SourceAccountSegments_cur
                      (
                       pt_LedgerName                 VARCHAR2
                      )
          IS
               --
               SELECT    fifse.segment_num
                        ,fifse.segment_name
                        ,fifse.application_column_name
               FROM      gl_ledgers@MXDM_NVIS_EXTRACT                 gl
                        ,fnd_id_flexs@MXDM_NVIS_EXTRACT               fif
                        ,fnd_id_flex_structures@MXDM_NVIS_EXTRACT     fifs
                        ,fnd_id_flex_segments@MXDM_NVIS_EXTRACT       fifse
               WHERE     1 = 1
               AND       gl.name                     = pt_LedgerName
               AND       fif.id_flex_name            = 'Accounting Flexfield'
               AND       fifs.id_flex_code           = fif.id_flex_code
               AND       fifs.id_flex_num            = gl.chart_of_accounts_id
               AND       fifse.id_flex_code          = fifs.id_flex_code
               AND       fifse.id_flex_num           = fifs.id_flex_num
               ORDER BY  fifse.segment_num;
               --
               --
          --** END CURSOR SourceAccountSegments_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'SOURCE_STRUCTURES';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'extract_src_gl_acct_structures';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vn_SegmentCount                 NUMBER;
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
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => gct_Phase
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
                    ,pt_i_Phase             => gct_Phase
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
          ** Clear doown the tables.
          */
          --
          gvv_ProgressIndicator := '0020';
          --
          DELETE FROM xxmx_gl_source_structures;
          --
          DELETE FROM xxmx_gl_source_struct_segments;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Extracting GL Ledger Names, associated GL Account Structure Segment Delimiters and Segment Definitions.'
               ,pt_i_OracleError       => NULL
               );
          --
          FOR  SourceAccountStructure_rec
          IN   SourceAccountStructures_cur
          LOOP
               --
               INSERT
               INTO   xxmx_gl_source_structures
                           (
                            source_ledger_name
                           ,source_segment_delimiter
                           ,currency_code
                           ,gl_bal_fusion_jrnl_source
                           ,gl_bal_fusion_jrnl_category
                           )
               VALUES
                           (
                            SourceAccountStructure_rec.source_ledger_name
                           ,SourceAccountStructure_rec.source_segment_delimiter
                           ,SourceAccountStructure_rec.currency_code
                           ,'Data Migration'
                           ,'Default Journal Category'
                           );
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Segment Information for "'
                                             ||SourceAccountStructure_rec.source_ledger_name
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               vn_SegmentCount := 0;
               --
               FOR  SourceAccountSegment_rec
               IN   SourceAccountSegments_cur
                         (
                          SourceAccountStructure_rec.source_ledger_name
                         )
               LOOP
                    --
                    vn_SegmentCount := vn_SegmentCount + 1;
                    --
                    INSERT
                    INTO   xxmx_gl_source_struct_segments
                                (
                                 source_ledger_name
                                ,source_segment_num
                                ,source_segment_name
                                ,source_segment_column
                                )
                    VALUES
                                (
                                 SourceAccountStructure_rec.source_ledger_name      -- source_ledger_name
                                ,SourceAccountSegment_rec.segment_num               -- source_segment_num
                                ,SourceAccountSegment_rec.segment_name              -- source_segment_name
                                ,SourceAccountSegment_rec.application_column_name   -- source_segment_column
                                );
                    --
               END LOOP;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - '
                                             ||vn_SegmentCount
                                             ||' Segment definitions extracted.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END LOOP; --** SourceAccountStructures_cur LOOP
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
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
                         ,pt_i_Phase             => gct_Phase
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
     END extract_src_gl_acct_structures;
     --
     --
     /*
     *******************************************
     ** PROCEDURE: extract_src_gl_seg_value_sets
     *******************************************
     */
     --
     PROCEDURE extract_src_gl_seg_value_sets
                    (
                     pv_i_DeleteAllData              IN  VARCHAR2  DEFAULT 'N'
                    ,pv_i_DeleteFrozenData           IN  VARCHAR2  DEFAULT 'N'
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
          --** Cursor to retrieve Gl Ledger Name Maps
          --
          CURSOR LedgerNameMaps_cur
          IS
               --
               SELECT    DISTINCT
                         xgs1t1m.source_ledger_name
               FROM      xxmx_gl_segment_1_to_1_maps  xgs1t1m;
               --
          --** END CURSOR SegmentOneToOneMaps_cur
          --
          --** Cursor to get the Value Set details for a specific GL Ledger
          --
          CURSOR SegmentValueSets_cur
                      (
                       pt_LedgerName                   xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                      )
          IS
               --
               SELECT    fif.id_flex_name
                        ,fifst.id_flex_structure_name
                        ,fifs.concatenated_segment_delimiter
                        ,fifse.segment_name
                        ,fifse.application_column_name
                        ,fifse.segment_num
                        ,ffvs.flex_value_set_id
                        ,ffvs.flex_value_set_name
                        ,ffvs.format_type
                        ,ffvs.maximum_size
                        ,ffvs.alphanumeric_allowed_flag
                        ,ffvs.uppercase_only_flag
               FROM      gl_ledgers@MXDM_NVIS_EXTRACT                 gl
                        ,fnd_id_flexs@MXDM_NVIS_EXTRACT               fif
                        ,fnd_id_flex_structures@MXDM_NVIS_EXTRACT     fifs
                        ,fnd_id_flex_structures_tl@MXDM_NVIS_EXTRACT  fifst
                        ,fnd_id_flex_segments@MXDM_NVIS_EXTRACT       fifse
                        ,fnd_flex_value_sets@MXDM_NVIS_EXTRACT        ffvs
               WHERE     1 = 1
               AND       gl.name                     = pt_LedgerName
               AND       fif.id_flex_name            = 'Accounting Flexfield'
               AND       fifs.id_flex_code           = fif.id_flex_code
               AND       fifs.id_flex_num            = gl.chart_of_accounts_id
               AND       fifst.id_flex_code          = fifs.id_flex_code
               AND       fifst.id_flex_num           = fifs.id_flex_num
               AND       fifse.id_flex_code          = fifst.id_flex_code
               AND       fifse.id_flex_num           = fifst.id_flex_num
               AND       ffvs.flex_value_set_id      = fifse.flex_value_set_id
               ORDER BY  fifse.segment_num;
               --
          --** END CURSOR SegmentValueSets_cur
          --
          --** Cursor to get the Value Set Values for a specific Value Set
          --
          CURSOR ValueSetValues_cur
                      (
                       pn_FlexValueSetID               NUMBER
                      )
          IS
               --
               SELECT    ffv.flex_value
                        ,ffv.enabled_flag
                        ,ffv.summary_flag
               FROM      fnd_flex_values@MXDM_NVIS_EXTRACT  ffv
               WHERE     1 = 1
               AND       ffv.flex_value_set_id                 = pn_FlexValueSetID
               AND       NVL(ffv.enabled_flag, 'N')            = 'Y'
               AND       NVL(ffv.end_date_active, SYSDATE + 1) > TRUNC(SYSDATE)
               AND       NOT EXISTS (
                                     SELECT 'X'
                                     FROM   xxmx_gl_acct_seg_transforms  xgast
                                     WHERE  1 = 1
                                     AND    xgast.source_segment_value = ffv.flex_value
                                    )
               ORDER BY  ffv.flex_value;
               --
               --
          --** END CURSOR ValueSetValues_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE GLValueSetValues_tt IS TABLE OF ValueSetValues_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'SOURCE_SEGMENT_VALUES';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'extract_src_gl_seg_value_sets';
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
          GLValueSetValues_tbl            GLValueSetValues_tt;
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
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => gct_Phase
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
                    ,pt_i_Phase             => gct_Phase
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
          ** Clear doown the table.
          */
          --
          IF   pv_i_DeleteAllData = 'Y'
          THEN
               --
               DELETE
               FROM   xxmx_gl_acct_seg_transforms;
               --
          ELSE
               --
               IF   pv_i_DeleteFrozenData = 'Y'
               THEN
                    --
                    DELETE
                    FROM   xxmx_gl_acct_seg_transforms
                    WHERE  1 = 1
                    AND    data_source = 'GENERATED';
                    --
               ELSE
                    --
                    DELETE
                    FROM   xxmx_gl_acct_seg_transforms
                    WHERE  1 = 1
                    AND    data_source = 'GENERATED'
                    AND    frozen_flag = 'N';
                    --
               END IF;
               --
          END IF;
          --
          /*
          ** Loop through Ledger Names List
          */
          --
          FOR  LedgerNameMap_rec
          IN   LedgerNameMaps_cur
          LOOP
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
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting GL Account Structure Value Sets for GL Ledger "'
                                             ||LedgerNameMap_rec.source_ledger_name
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               FOR  SegmentValueSets_rec
               IN   SegmentValueSets_cur
                         (
                          LedgerNameMap_rec.source_ledger_name
                         )
               LOOP
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Extracting Values for Value Set "'
                                                  ||SegmentValueSets_rec.flex_value_set_name
                                                  ||'" assigned to '
                                                  ||SegmentValueSets_rec.id_flex_name
                                                  ||' Structure "'
                                                  ||SegmentValueSets_rec.id_flex_structure_name
                                                  ||'" and Segment "'
                                                  ||SegmentValueSets_rec.segment_name
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0050';
                    --
                    OPEN ValueSetValues_cur
                              (
                               SegmentValueSets_rec.flex_value_set_id
                              );
                    --
                    gvv_ProgressIndicator := '0060';
                    --
                    LOOP
                         --
                         FETCH        ValueSetValues_cur
                         BULK COLLECT
                         INTO         GLValueSetValues_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    GLValueSetValues_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0070';
                         --
                         FORALL GLValueSetValues_idx IN 1..GLValueSetValues_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_gl_acct_seg_transforms
                                          (
                                           data_source
                                          ,source_ledger_name
                                          ,source_segment_name
                                          ,source_segment_column
                                          ,source_segment_value
                                          ,source_segment_value_enabled
                                          ,fusion_segment_value
                                          ,frozen_flag
                                          )
                              VALUES
                                          (
                                           'GENERATED'                                              -- data_source
                                          ,LedgerNameMap_rec.source_ledger_name                     -- source_ledger_name
                                          ,SegmentValueSets_rec.segment_name                        -- source_segment_name
                                          ,SegmentValueSets_rec.application_column_name             -- source_segment_column
                                          ,GLValueSetValues_tbl(GLValueSetValues_idx).flex_value    -- source_segment_value
                                          ,GLValueSetValues_tbl(GLValueSetValues_idx).enabled_flag  -- source_segment_num
                                          ,NULL                                                     -- fusion_segment_value
                                          ,'N'                                                      -- frozen_flag
                                          );
                              --
                         --** END FORALL
                         --
                    END LOOP;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    CLOSE ValueSetValues_cur;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    SELECT COUNT(1)
                    INTO   gvn_RowCount
                    FROM   xxmx_gl_acct_seg_transforms  xgast
                    WHERE  1 = 1
                    AND    xgast.source_ledger_name            = LedgerNameMap_rec.source_ledger_name
                    AND    xgast.source_segment_column         = SegmentValueSets_rec.application_column_name;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' Values extracted.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END LOOP; --** SegmentValueSets_cur LOOP
               --
          END LOOP; --** LedgerName_tbl LOOP
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
                    IF   ValueSetValues_cur%ISOPEN
                    THEN
                         --
                         CLOSE ValueSetValues_cur;
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
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
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
                    IF   ValueSetValues_cur%ISOPEN
                    THEN
                         --
                         CLOSE ValueSetValues_cur;
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
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
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
     END extract_src_gl_seg_value_sets;
     --
     --
     /*
     *****************************************
     ** FUNCTION: transform_gl_account_segment
     *****************************************
     */
     --
     FUNCTION transform_gl_account_segment
                   (
                    pt_i_SourceLedgerName           IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                   ,pt_i_SourceSegmentName          IN      xxmx_gl_acct_seg_transforms.source_segment_name%TYPE
                   ,pt_i_SourceSegmentColumn        IN      xxmx_gl_acct_seg_transforms.source_segment_column%TYPE
                   ,pt_i_SourceSegmentValue         IN      xxmx_gl_acct_seg_transforms.source_segment_value%TYPE
                   )
     RETURN VARCHAR2
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
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'SEGMENT_TRANSFORM';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'transform_gl_account_segment';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vt_FusionSegmentValue           xxmx_gl_acct_seg_transforms.fusion_segment_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT xgast.fusion_segment_value
          INTO   vt_FusionSegmentValue
          FROM   xxmx_gl_acct_seg_transforms  xgast
          WHERE  1 = 1
          AND    (
                     pt_i_SourceLedgerName                    IS NULL
                  OR (
                          pt_i_SourceLedgerName               IS NOT NULL
                      AND xgast.source_ledger_name             = pt_i_SourceLedgerName
                     )
                 )
          AND    (
                      xgast.source_segment_column         = pt_i_SourceSegmentColumn
                  OR  xgast.source_segment_name           = pt_i_SourceSegmentName
                 )
          AND    xgast.source_segment_value               = pt_i_SourceSegmentValue;
          --
          RETURN(vt_FusionSegmentValue);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    vt_FusionSegmentValue := '[MULTI_MAP]';
                    --
                    RETURN(vt_FusionSegmentValue);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    vt_FusionSegmentValue := '[NO_MAP]';
                    --
                    RETURN(vt_FusionSegmentValue);
                    --
               --** END NO_DATA_FOUND Exception
               --
               WHEN OTHERS
               THEN
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
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
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
     END transform_gl_account_segment;
     --
     --
     /*
     ********************************************
     ** PROCEDURE: gen_default_gl_acct_transforms
     ********************************************
     */
     --
     PROCEDURE gen_default_gl_acct_transforms
     IS
          --
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          CURSOR LedgerNameMaps_cur
          IS
               --
               SELECT    DISTINCT
                         xgs1t1m.source_ledger_name
                        ,xgs1t1m.fusion_ledger_name
               FROM      xxmx_gl_segment_1_to_1_maps  xgs1t1m;
               --
          --** END CURSOR SegmentOneToOneMaps_cur
          --
          --** Cursor to get the pre-transform GL Account Code Combination data
          --** from the Source Gl Ledger
          --
          CURSOR CheckSegmentTransforms_cur
                      (
                       pt_SourceLedgerName             xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                      )
          IS
               --
               SELECT    COUNT(1)                     AS source_ledger_seg_maps
                        ,(
                          SELECT COUNT(1)
                          FROM   xxmx_gl_acct_seg_transforms  xgast2
                          WHERE  1 = 1
                          AND    xgast2.source_ledger_name    = xgast.source_ledger_name
                          AND    xgast2.source_segment_value IS NULL
                         )                            AS seg_maps_with_null_source_vals
                        ,(
                          SELECT COUNT(1)
                          FROM   xxmx_gl_acct_seg_transforms  xgast3
                          WHERE  1 = 1
                          AND    xgast3.source_ledger_name    = xgast.source_ledger_name
                          AND    xgast3.fusion_segment_value IS NULL
                         )                            AS seg_maps_with_null_fusion_vals
               FROM      xxmx_gl_acct_seg_transforms  xgast
               WHERE     1 = 1
               AND       xgast.source_ledger_name = pt_SourceLedgerName
               GROUP BY xgast.sourcE_ledger_name;
               --
          --** END CURSOR CheckSegmentTransforms_cur
          --
          --** Cursor to retrieve Gl Ledger Name Maps
          --
          CURSOR SourceAccountSegments_cur
                      (
                       pv_SourceLedgerName             VARCHAR2
                      )
          IS
               --
               WITH gl_account_types
               AS
                    (
                     SELECT DISTINCT
                            lookup_code       AS account_type
                           ,meaning           AS account_type_meaning
                     FROM   fnd_lookup_values@MXDM_NVIS_EXTRACT
                     WHERE  1 = 1
                     AND    lookup_type            = 'ACCOUNT_TYPE'
                     AND    view_application_id    = 0
                     AND    NVL(enabled_flag, 'N') = 'Y'
                    )
               SELECT  gl.name                               AS source_ledger_name
                      ,gcck.gl_account_type                  AS source_account_type
                      ,gat.account_type_meaning              AS source_account_type_meaning
                      ,gcck.enabled_flag                     AS source_account_enabled_flag
                      ,gcck.concatenated_segments            AS source_concatenated_segments
                      ,gcck.segment1                         AS source_segment1
                      ,gcck.segment2                         AS source_segment2
                      ,gcck.segment3                         AS source_segment3
                      ,gcck.segment4                         AS source_segment4
                      ,gcck.segment5                         AS source_segment5
                      ,gcck.segment6                         AS source_segment6
                      ,gcck.segment7                         AS source_segment7
                      ,gcck.segment8                         AS source_segment8
                      ,gcck.segment9                         AS source_segment9
                      ,gcck.segment10                        AS source_segment10
                      ,gcck.segment11                        AS source_segment11
                      ,gcck.segment12                        AS source_segment12
                      ,gcck.segment13                        AS source_segment13
                      ,gcck.segment14                        AS source_segment14
                      ,gcck.segment15                        AS source_segment15
                      ,gcck.segment16                        AS source_segment16
                      ,gcck.segment17                        AS source_segment17
                      ,gcck.segment18                        AS source_segment18
                      ,gcck.segment19                        AS source_segment19
                      ,gcck.segment20                        AS source_segment20
                      ,gcck.segment21                        AS source_segment21
                      ,gcck.segment22                        AS source_segment22
                      ,gcck.segment23                        AS source_segment23
                      ,gcck.segment24                        AS source_segment24
                      ,gcck.segment25                        AS source_segment25
                      ,gcck.segment26                        AS source_segment26
                      ,gcck.segment27                        AS source_segment27
                      ,gcck.segment28                        AS source_segment28
                      ,gcck.segment29                        AS source_segment29
                      ,gcck.segment30                        AS source_segment30
               FROM    gl_ledgers@MXDM_NVIS_EXTRACT                 gl
                      ,fnd_id_flexs@MXDM_NVIS_EXTRACT               fif
                      ,fnd_id_flex_structures@MXDM_NVIS_EXTRACT     fifs
                      ,gl_code_combinations_kfv@MXDM_NVIS_EXTRACT   gcck
                      ,gl_account_types                             gat
               WHERE   1 = 1
               AND     gl.name                     = pv_SourceLedgerName
               AND     fif.id_flex_name            = 'Accounting Flexfield'
               AND     fifs.id_flex_code           = fif.id_flex_code
               AND     fifs.id_flex_num            = gl.chart_of_accounts_id
               AND     gcck.chart_of_accounts_id   = fifs.id_flex_num
               --AND     NVL(gcck.enabled_flag, 'N') = 'Y'
               AND     gat.account_type(+)         = gcck.gl_account_type;
               --
          --** END CURSOR SourceAccountSegments_cur
          --
          --** Cursor to retrieve Segment One To One Maps
          --
           CURSOR SegmentOneToOneMaps_cur
                      (
                       pt_SourceLedgerName             xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                      )
          IS
               --
               SELECT    xgs1t1m.source_ledger_name
                        ,xgs1t1m.source_segment_name
                        ,xgs1t1m.source_segment_column
                        ,xgs1t1m.fusion_segment_name
                        ,xgs1t1m.fusion_segment_column
               FROM      xxmx_gl_segment_1_to_1_maps    xgs1t1m
               WHERE     1 = 1
               AND       xgs1t1m.source_ledger_name = pt_SourceLedgerName
               AND       EXISTS (
                                 SELECT 'X'
                                 FROM   xxmx_gl_account_transforms  xgat
                                 WHERE  1 = 1
                                 AND    xgat.source_ledger_name = xgs1t1m.source_ledger_name
                                );
               --
          --** END CURSOR SegmentOneToOneMaps_cur
          --
          --** Cursor to retrieve Segment One To One Maps
          --
          CURSOR SegmentDefaultingRules_cur
                      (
                       pt_FusionLedgerName             xxmx_gl_fusion_seg_defaults.fusion_ledger_name%TYPE
                      )
          IS
               --
               SELECT    xgfsd.fusion_ledger_name
                        ,xgfsd.fusion_segment_column
                        ,xgfsd.fusion_segment_default_value
               FROM      xxmx_gl_fusion_seg_defaults  xgfsd
               WHERE     1 = 1
               AND       xgfsd.fusion_ledger_name = pt_FusionLedgerName;
               --
          --** END CURSOR SegmentDefaultingRules_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE SourceAccountSegments_tt IS TABLE OF SourceAccountSegments_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          TYPE LoopVariable_rt          IS RECORD (
                                                   base_column_name                xxmx_gl_acct_seg_transforms.source_segment_column%TYPE
                                                  ,source_column_name              xxmx_gl_acct_seg_transforms.source_segment_column%TYPE
                                                  ,fusion_column_name              xxmx_gl_acct_seg_transforms.source_segment_column%TYPE
                                                  );
          TYPE LoopVariables_tt         IS TABLE OF LoopVariable_rt INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'DEFAULT_ACCOUNT_TRANSFORMS';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'gen_default_gl_acct_transforms';
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
          vt_SegmentDelimiter       xxmx_migration_parameters.parameter_value%TYPE;
          vb_OkayToTransform              BOOLEAN;
          vb_SegmentTransformsExist       BOOLEAN;
          vb_DefaultingRulesExist         BOOLEAN;
          vb_MergeRulesExist              BOOLEAN;
          vt_SegmentsNotTransformed       xxmx_gl_account_transforms.segments_not_transformed%TYPE;
          vv_SourceSegmentColumnName      VARCHAR2(30);
          vv_FusionSegmentColumnName      VARCHAR2(30);
          vt_UsePlaceboSegment            xxmx_migration_parameters.parameter_value%TYPE;
          vt_PlaceboSegmentValue          xxmx_migration_parameters.parameter_value%TYPE;
          vv_DateStamp                    VARCHAR2(20);
          vv_BackupTableName              VARCHAR2(30);
          --
          /*
          *****************************
          ** PL/SQL Record Declarations
          *****************************
          */
          --
          /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          EmptyLedgerName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          LedgerName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          ColumnNameMap_tbl               LoopVariables_tt;
          SourceAccountSegments_tbl       SourceAccountSegments_tt;
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
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => gct_Phase
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
                    ,pt_i_Phase             => gct_Phase
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
          --
          /*
          ** Loop through DISTINCT Source and Fusion Ledger Names in segment mapping table
          */
          --
          gvv_ProgressIndicator := '0030';
          --
          FOR  LedgerNameMap_rec
          IN   LedgerNameMaps_cur
          LOOP
               --
               vb_OkayToTransform := TRUE;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Processing Source Ledger Name "'
                                             ||LedgerNameMap_rec.source_ledger_name
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Verifying Fusion Segment Delimiter is defined in "xxmx_gl_fusion_structures" table for Fusion Ledger Name "'
                                             ||LedgerNameMap_rec.fusion_ledger_name
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               BEGIN
                    --
                    vt_SegmentDelimiter := NULL;
                    --
                    SELECT  fusion_segment_delimiter
                    INTO    vt_SegmentDelimiter
                    FROM    xxmx_gl_fusion_structures  xgfs
                    WHERE   1 = 1
                    AND     xgfs.fusion_ledger_name = LedgerNameMap_rec.fusion_ledger_name;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Fusion Segment Delimiter = '
                                                  ||vt_SegmentDelimiter
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    EXCEPTION
                         --
                         WHEN NO_DATA_FOUND
                         THEN
                              --
                              vb_OkayToTransform := FALSE;
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => ct_SubEntity
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '    - No row found in the "xxmx_gl_fusion_structures" table for Fusion Ledger Name "'
                                                            ||LedgerNameMap_rec.fusion_ledger_name
                                                            ||'".'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         --** END NO_DATA_FOUND Exception
                         --
                         WHEN OTHERS
                         THEN
                              --
                              RAISE;
                              --
                         --** END OTHERS Exception
                         --
                    --** END Exception Handler
                    --
               END;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Verifying "xxmx_gl_acct_seg_transforms"(individual Segment Value Mappings) table contents:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Check the individual segment mappings table for mapping gaps.
               */
               --
               gvv_ProgressIndicator := '0060';
               --
               vb_SegmentTransformsExist := FALSE;
               --
               FOR  CheckSegmentTransforms_rec
               IN   CheckSegmentTransforms_cur
                         (
                          LedgerNameMap_rec.source_ledger_name
                         )
               LOOP
                    --
                    vb_SegmentTransformsExist := TRUE;
                    --
                    IF   CheckSegmentTransforms_rec.seg_maps_with_null_fusion_vals > 0
                    OR   CheckSegmentTransforms_rec.seg_maps_with_null_source_vals > 0
                    THEN
                         --
                         gvt_Severity      := 'WARNING';
                         --
                         gvt_ModuleMessage := '      - Rows with NULL values for either the "source_segment_value" or '
                                            ||'"fusion_segment_value" column will result in the segment column name '
                                            ||'value being added to the "segments_not_transformed" column in the '
                                            ||'"xxmx_gl_account_transforms" table.';
                         --
                    ELSE
                         --
                         gvt_Severity      := 'NOTIFICATION';
                         --
                         gvt_ModuleMessage := '      - All "source_segment_value" columns are mapped to a value in the '
                                            ||'"fusion_segment_value" column.';
                         --
                    END IF;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Source Ledger Name "'
                                                  ||LedgerNameMap_rec.source_ledger_name
                                                  ||'" has '
                                                  ||CheckSegmentTransforms_rec.source_ledger_seg_maps
                                                  ||' individual Segment Value mapping rows with '
                                                  ||CheckSegmentTransforms_rec.seg_maps_with_null_source_vals
                                                  ||' rows having NULL Source Segment Values and '
                                                  ||CheckSegmentTransforms_rec.seg_maps_with_null_fusion_vals
                                                  ||' rows having NULL Fusion Segment Values.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
               END LOOP; --** END CheckSegmentTransforms_cur LOOP
               --
               IF   NOT vb_SegmentTransformsExist
               THEN
                    --
                    vb_OkayToTransform := FALSE;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Table is not populated for this Source Ledger Name.  No further actions can be performed.'
                         ,pt_i_OracleError       => gvt_ReturnMessage
                         );
                    --
               END IF;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - "xxmx_gl_acct_seg_transforms" table verification complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               IF   vb_OkayToTransform
               THEN
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Populating "xxmx_gl_account_transforms" table:'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - PHASE 1 (Extraction) - Extracting Source GL Account Code Combinations for Source GL Ledger "'
                                                  ||LedgerNameMap_rec.source_ledger_name
                                                  ||'":'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Phase 1 - First, populate the Account Transformation mapping
                    ** table with the source GL Account Code Combinations for the
                    ** current GL Ledger.
                    **
                    ** The initial transforms being created are for overall GL
                    ** transformations.  Business Entity/Sub-Entity specific
                    ** transformations can be added manually by the client.
                    **
                    ** The FROZEN_FLAG is set to "Y" at this stage on the assumption
                    ** that all segments will be transformed successfully in later
                    ** phases.
                    **
                    ** Any segments which can not be transformed will result in the
                    ** FROZEN_FLAG being updated to "N".
                    */
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    OPEN SourceAccountSegments_cur
                              (
                               LedgerNameMap_rec.source_ledger_name
                              );
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    LOOP
                         --
                         FETCH        SourceAccountSegments_cur
                         BULK COLLECT
                         INTO         SourceAccountSegments_tbl
                         LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                         --
                         EXIT WHEN    SourceAccountSegments_tbl.COUNT = 0;
                         --
                         gvv_ProgressIndicator := '0090';
                         --
                         FORALL SourceAccountSegments_idx IN 1..SourceAccountSegments_tbl.COUNT
                              --
                              INSERT
                              INTO   xxmx_gl_account_transforms
                                          (
                                           application_suite
                                          ,application
                                          ,business_entity
                                          ,sub_entity
                                          ,source_ledger_name
                                          ,source_account_type
                                          ,source_account_type_meaning
                                          ,source_account_enabled_flag
                                          ,source_concatenated_segments
                                          ,source_segment1
                                          ,source_segment2
                                          ,source_segment3
                                          ,source_segment4
                                          ,source_segment5
                                          ,source_segment6
                                          ,source_segment7
                                          ,source_segment8
                                          ,source_segment9
                                          ,source_segment10
                                          ,source_segment11
                                          ,source_segment12
                                          ,source_segment13
                                          ,source_segment14
                                          ,source_segment15
                                          ,source_segment16
                                          ,source_segment17
                                          ,source_segment18
                                          ,source_segment19
                                          ,source_segment20
                                          ,source_segment21
                                          ,source_segment22
                                          ,source_segment23
                                          ,source_segment24
                                          ,source_segment25
                                          ,source_segment26
                                          ,source_segment27
                                          ,source_segment28
                                          ,source_segment29
                                          ,source_segment30
                                          ,fusion_ledger_name
                                          ,frozen_flag
                                          )
                              VALUES
                                          (
                                           'FIN'                                                                              -- application_suite
                                          ,'GL'                                                                               -- application
                                          ,'ALL'                                                                              -- business_entity
                                          ,'ALL'                                                                              -- sub_entity
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_ledger_name            -- source_ledger_name
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_account_type           -- source_account_type
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_account_type_meaning   -- source_account_type_meaning
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_account_enabled_flag   -- source_account_enabled_flag
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_concatenated_segments  -- source_concatenated_segments
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment1               -- source_segment1
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment2               -- source_segment2
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment3               -- source_segment3
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment4               -- source_segment4
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment5               -- source_segment5
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment6               -- source_segment6
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment7               -- source_segment7
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment8               -- source_segment8
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment9               -- source_segment9
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment10              -- source_segment10
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment11              -- source_segment11
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment12              -- source_segment12
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment13              -- source_segment13
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment14              -- source_segment14
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment15              -- source_segment15
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment16              -- source_segment16
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment17              -- source_segment17
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment18              -- source_segment18
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment19              -- source_segment19
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment20              -- source_segment20
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment21              -- source_segment21
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment22              -- source_segment22
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment23              -- source_segment23
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment24              -- source_segment24
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment25              -- source_segment25
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment26              -- source_segment26
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment27              -- source_segment27
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment28              -- source_segment28
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment29              -- source_segment29
                                          ,SourceAccountSegments_tbl(SourceAccountSegments_idx).source_segment30              -- source_segment30
                                          ,LedgerNameMap_rec.fusion_ledger_name                                               -- fusion_ledger_name
                                          ,'Y'                                                                                -- frozen_flag
                                          );
                              --
                         --** END FORALL
                         --
                    END LOOP;
                    --
                    gvv_ProgressIndicator := '0100';
                    --
                    CLOSE SourceAccountSegments_cur;
                    --
                    SELECT COUNT(1)
                    INTO   gvn_Rowcount
                    FROM   xxmx_gl_account_transforms  xgat
                    WHERE  1 = 1
                    AND    xgat.source_ledger_name = LedgerNameMap_rec.source_ledger_name;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||gvn_Rowcount
                                                  ||' Account Code Combinations extracted from the Source Ledger and inserted into table.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Source GL Account Code Combination extraction complete.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Phase 2 - Perform individual Segment Transformations dependant on the
                    **           Segment 1 to 1 Mappings table.
                    **
                    ** Loop through the custom Segment One to One Mapping table for the current GL Ledger.
                    **
                    ** This table will identify which "source_segmentX" columns should contain values which
                    ** need to be transformed and populated into the mapped "fusion_segmentX" column in the
                    ** "xxmx_gl_account_transforms" table.
                    **
                    ** For ease of User understanding (i.e. the person who will populate the "xxmx_gl_segment_1_to_1_maps"
                    ** table) that table holds base column names (e.g. SEGMENT3 of the Source Ledger maps to
                    ** SEGMENT2 of the new Fusion Ledger).
                    **
                    ** The Base Column Names are converted into the appropriate column names in the
                    ** "xxmx_gl_account_transforms" by prefixing them with "source_" or "fusion_"
                    ** as appropriate.
                    */
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - PHASE 2 (Update) - Evaluating One to One Segment Mappings to populate "fusion_segmentX" columns.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_SQLAction      := 'UPDATE';
                    gvv_SQLTableClause := 'xxmx_gl_account_transforms  xgat';
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    FOR SegmentOneToOneMap_rec
                    IN  SegmentOneToOneMaps_cur
                              (
                               LedgerNameMap_rec.source_ledger_name
                              )
                    LOOP
                         --
                         gvv_ProgressIndicator := '0130';
                         --
                         vv_SourceSegmentColumnName := LOWER('source_'||SegmentOneToOneMap_rec.source_segment_column);
                         vv_FusionSegmentColumnName := LOWER('fusion_'||SegmentOneToOneMap_rec.fusion_segment_column);
                         --
                         IF   SegmentOneToOneMap_rec.source_segment_column <> SegmentOneToOneMap_rec.fusion_segment_column
                         THEN
                              --
                              gvt_ModuleMessage := '      - Updating the "'
                                                 ||vv_FusionSegmentColumnName
                                                 ||'" column with the post-transformed value of the "'
                                                 ||vv_SourceSegmentColumnName
                                                 ||'" column.  NOTE : Segment Value is being moved between '
                                                 ||'Segmment Numbers during transform due to Account Structure Mapping.';
                              --
                         ELSE
                              --
                              gvt_ModuleMessage := '      - Updating the "'
                                                 ||vv_FusionSegmentColumnName
                                                 ||'" column with the post-transformed value of the "'
                                                 ||vv_SourceSegmentColumnName
                                                 ||'" column.';
                              --
                         END IF;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => gvt_ModuleMessage
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_SQLColumnList  := 'SET xgat.'
                                             ||vv_FusionSegmentColumnName
                                             ||' = '
                                             ||'xxmx_gl_utilities_pkg.transform_gl_account_segment'
                                             ||'( '
                                             ||' pt_i_SourceLedgerName    => '''
                                             ||SegmentOneToOneMap_rec.source_ledger_name
                                             ||''',pt_i_SourceSegmentName   => '''
                                             ||SegmentOneToOneMap_rec.source_segment_name
                                             ||''',pt_i_SourceSegmentColumn => '''
                                             ||SegmentOneToOneMap_rec.source_segment_column
                                             ||''',pt_i_SourceSegmentValue  => xgat.'
                                             ||vv_SourceSegmentColumnName
                                             ||') ';
                         --
                         gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                             ||'AND    xgat.application_suite = ''FIN'' '
                                             ||'AND    xgat.application = ''GL'' '
                                             ||'AND    xgat.business_entity = ''ALL'' '
                                             ||'AND    xgat.sub_entity = ''ALL'' '
                                             ||'AND    xgat.source_ledger_name = '''
                                             ||SegmentOneToOneMap_rec.source_ledger_name
                                             ||'''';
                         --
                         gvv_SQLStatement := gvv_SQLAction
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         --xxmx_utilities_pkg.log_module_message
                         --     (
                         --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                         --     ,pt_i_Application       => gct_Application
                         --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                         --     ,pt_i_SubEntity         => ct_SubEntity
                         --     ,pt_i_Phase             => gct_Phase
                         --     ,pt_i_Severity          => 'NOTIFICATION'
                         --     ,pt_i_PackageName       => gct_PackageName
                         --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         --     ,pt_i_ModuleMessage     => '        - Generated UPDATE Statement : '
                         --                              ||gvv_SQLStatement
                         --     ,pt_i_OracleError       => NULL
                         --     );
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         EXECUTE IMMEDIATE  gvv_SQLStatement;
                         --
                         gvn_RowCount := SQL%ROWCOUNT;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - '
                                                       ||gvn_RowCount
                                                       ||' Rows updated for Source Ledger Name "'
                                                       ||SegmentOneToOneMap_rec.source_ledger_name
                                                       ||'", Source Segment Column "'
                                                       ||vv_SourceSegmentColumnName
                                                       ||'" and Fusion Segment Column "'
                                                       ||vv_FusionSegmentColumnName
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0150';
                         --
                         /*
                         ** Update the table where any segments failed transformation to copy the error
                         ** identifiers from the "fusion_segmentX" columns to the "segments_not_transformed"
                         ** column.
                         **
                         ** As there were individual segment transform errors, update the "FROZEN_FLAG" to 'N'
                         ** at the same time.
                         */
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - '
                                                       ||'Copying Error Codes to SEGMENTS_NOT_TRANSFORMED column.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_SQLColumnList  := 'SET xgat.segments_not_transformed = xgat.segments_not_transformed||'''
                                             ||UPPER(SegmentOneToOneMap_rec.source_segment_column)
                                             ||'''||xgat.'
                                             ||vv_FusionSegmentColumnName
                                             ||'||'':'''
                                             ||', xgat.frozen_flag = ''N''';
                         --
                         gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                             ||'AND    xgat.application_suite = ''FIN'' '
                                             ||'AND    xgat.application = ''GL'' '
                                             ||'AND    xgat.business_entity = ''ALL'' '
                                             ||'AND    xgat.sub_entity = ''ALL'' '
                                             ||'AND    xgat.source_ledger_name = '''
                                             ||SegmentOneToOneMap_rec.source_ledger_name
                                             ||''' '
                                             ||'AND    xgat.'
                                             ||vv_FusionSegmentColumnName
                                             ||' IN (''[NO_MAP]'', ''[MULTI_MAP]'')'
                                             ||'';
                         --
                         gvv_SQLStatement := gvv_SQLAction
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         gvv_ProgressIndicator := '0160';
                         --
                         EXECUTE IMMEDIATE  gvv_SQLStatement;
                         --
                         gvv_ProgressIndicator := '0170';
                         --
                         /*
                         ** Update the table where any segments failed transformation to replace the
                         ** error identifiers in the "fusion_segmentX" columns with the original
                         ** values in the "source_segmentX" columns.
                         */
                         --
                         /*
                         ** 17-JAN-2021 ISV :
                         **
                         ** Request from Jim Venn (V1 Functional Consultant on the SMBC Project) was
                         ** to not replace the error codes with the original source segment values but
                         ** rather with a placebo character.  # was suggested by Jim.
                         **
                         ** To provide flexibility, two new parameters have been added to the XXMX Migration
                         ** Parameters table so that the placebo segment string can be defined by the client
                         ** and its use enabled/disabled.
                         **
                         ** If use of the placebo segment value is disabled.  The original source segment
                         ** value will still be used.
                         */
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - '
                                                       ||'Replacing error codes with Placebo Segment Value or Original Segment Value.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvt_ParameterCode := 'USE_PLACEBO_SEGMENT_VALUE';
                         --
                         vt_UsePlaceboSegment := xxmx_utilities_pkg.get_single_parameter_value
                                                      (
                                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                                      ,pt_i_Application      => gct_Application
                                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                      ,pt_i_SubEntity        => ct_SubEntity
                                                      ,pt_i_ParameterCode    => gvt_ParameterCode
                                                      );
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '          - Value for Parameter "'
                                                       ||gvt_ParameterCode
                                                       ||'" : '
                                                       ||vt_UsePlaceboSegment
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         IF   UPPER(vt_UsePlaceboSegment) = 'Y'
                         THEN
                              --
                              gvt_ParameterCode := 'PLACEBO_SEGMENT_VALUE';
                              --
                              vt_PlaceboSegmentValue := xxmx_utilities_pkg.get_single_parameter_value
                                                             (
                                                              pt_i_ApplicationSuite => gct_ApplicationSuite
                                                             ,pt_i_Application      => gct_Application
                                                             ,pt_i_BusinessEntity   => gct_BusinessEntity
                                                             ,pt_i_SubEntity        => ct_SubEntity
                                                             ,pt_i_ParameterCode    => gvt_ParameterCode
                                                             );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => ct_SubEntity
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '            - Value for Parameter "'
                                                            ||gvt_ParameterCode
                                                            ||'" : '
                                                            ||vt_PlaceboSegmentValue
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              gvv_SQLColumnList  := 'SET xgat.'
                                                  ||vv_FusionSegmentColumnName
                                                  ||' = '''
                                                  ||vt_PlaceboSegmentValue
                                                  ||'''';
                              --
                        ELSE
                              --
                              gvv_SQLColumnList  := 'SET xgat.'
                                                  ||vv_FusionSegmentColumnName
                                                  ||' = xgat.'
                                                  ||vv_SourceSegmentColumnName
                                                  ||'';
                              --
                         END IF;
                         --
                         gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                             ||'AND    xgat.application_suite = ''FIN'' '
                                             ||'AND    xgat.application = ''GL'' '
                                             ||'AND    xgat.business_entity = ''ALL'' '
                                             ||'AND    xgat.sub_entity = ''ALL'' '
                                             ||'AND    xgat.source_ledger_name = '''
                                             ||SegmentOneToOneMap_rec.source_ledger_name
                                             ||''' '
                                             ||'AND    xgat.'
                                             ||vv_FusionSegmentColumnName
                                             ||' IN (''[NO_MAP]'', ''[MULTI_MAP]'')'
                                             ||'';
                         --
                         gvv_SQLStatement := gvv_SQLAction
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - Generated UPDATE Statement : '
                                                       ||gvv_SQLStatement
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         EXECUTE IMMEDIATE  gvv_SQLStatement;
                         --
                    END LOOP; --** SegmentOneToOneMaps_cur LOOP
                    --
                    gvv_ProgressIndicator := '0180';
                    --
                    /*
                    ** Trim the last ':' column separator from the "segments_not_transformed" column.
                    */
                    --
                    UPDATE xxmx_gl_account_transforms  xgat
                    SET    xgat.segments_not_transformed = RTRIM(xgat.segments_not_transformed, ':');
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Update complete. '
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Perform Segment Defaulting Updates
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - PHASE 3 (Update) - Evaluating Fusion Segment Defaulting Rules to populate "fusion_segmentX" columns.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0150';
                    --
                    vb_DefaultingRulesExist := FALSE;
                    --
                    FOR  SegmentDefaultingRule_rec
                    IN   SegmentDefaultingRules_cur
                              (
                               LedgerNameMap_rec.fusion_ledger_name
                              )
                    LOOP
                         --
                         vb_DefaultingRulesExist := TRUE;
                         --
                         vv_FusionSegmentColumnName := LOWER('fusion_'||SegmentDefaultingRule_rec.fusion_segment_column);
                         --
                         gvv_SQLColumnList  := 'SET xgat.'
                                             ||vv_FusionSegmentColumnName
                                             ||' = '''
                                             ||SegmentDefaultingRule_rec.fusion_segment_default_value
                                             ||'''';
                         --
                         gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                             ||'AND    xgat.application_suite = ''FIN'' '
                                             ||'AND    xgat.application = ''GL'' '
                                             ||'AND    xgat.business_entity = ''ALL'' '
                                             ||'AND    xgat.sub_entity = ''ALL'' '
                                             ||'AND    xgat.source_ledger_name = '''
                                             ||LedgerNameMap_rec.source_ledger_name
                                             ||''' AND    xgat.fusion_ledger_name = '''
                                             ||SegmentDefaultingRule_rec.fusion_ledger_name
                                             ||'''';
                         --
                         gvv_SQLStatement := gvv_SQLAction
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Generated UPDATE Statement : '
                                                       ||gvv_SQLStatement
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0160';
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
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - '
                                                       ||gvn_RowCount
                                                       ||' Rows updated for Fusion Ledger Name "'
                                                       ||SegmentDefaultingRule_rec.fusion_ledger_name
                                                       ||'" and Fusion Segment Column "'
                                                       ||vv_FusionSegmentColumnName
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END LOOP; --** SegmentDefaultingRules_cur LOOP
                    --
                    IF   vb_DefaultingRulesExist
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Update complete. '
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
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - No Fusion Segment Value Defaults defined. '
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF;
                    --
                    /*
                    ** Perform Segment Merging Updates
                    **
                    ** Need to think about if Segment Value need transforming before merge or not.
                    */
                    --
                    --xxmx_utilities_pkg.log_module_message
                    --     (
                    --      pt_i_ApplicationSuite  => gct_ApplicationSuite
                    --     ,pt_i_Application       => gct_Application
                    --     ,pt_i_BusinessEntity    => gct_BusinessEntity
                    --     ,pt_i_SubEntity         => ct_SubEntity
                    --     ,pt_i_Phase             => gct_Phase
                    --     ,pt_i_Severity          => 'NOTIFICATION'
                    --     ,pt_i_PackageName       => gct_PackageName
                    --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    --     ,pt_i_ModuleMessage     => '    - PHASE 4 (Update) - Evaluating Segment Merging Rules to populate "fusion_segmentX" columns.'
                    --     ,pt_i_OracleError       => NULL
                    --     );
                    --
                    /*
                    ** Finally generate Fusion Account Code Concatenated Segments from the
                    ** individual segments.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - PHASE 4 (Update) - Generating concatenated segments to populate the "fusion_concatenated_segments" column.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0170';
                    --
                    UPDATE  xxmx_gl_account_transforms  xgat
                    SET     xgat.fusion_concatenated_segments = RTRIM(
                                                                      xgat.fusion_segment1
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment2
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment3
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment4
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment5
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment6
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment7
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment8
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment9
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment10
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment11
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment12
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment13
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment14
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment15
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment16
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment17
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment18
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment19
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment20
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment21
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment22
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment23
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment24
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment25
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment26
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment27
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment28
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment29
                                                                    ||vt_SegmentDelimiter
                                                                    ||xgat.fusion_segment30
                                                                     ,vt_SegmentDelimiter
                                                                     )
                    WHERE   1 = 1
                    AND     xgat.application_suite  = 'FIN'
                    AND     xgat.application        = 'GL'
                    AND     xgat.business_entity    = 'ALL'
                    AND     xgat.sub_entity         = 'ALL'
                    AND     xgat.source_ledger_name = LedgerNameMap_rec.source_ledger_name;
                    --
                    gvn_RowCount := SQL%ROWCOUNT;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '
                                                  ||gvn_RowCount
                                                  ||' Rows updated.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Update complete. '
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF vb_SegmentTransformsExist
               --
          END LOOP; --** LedgerNameMaps_cur LOOP
          --
          gvv_ProgressIndicator := '0180';
          --
          COMMIT;
          --
          /*
          ** Now the default GL Account Transforms have been generated,
          ** create a backup of the table.
          */
          --
          gvv_ProgressIndicator := '0190';
          --
          vv_DateStamp := xxmx_utilities_pkg.date_and_time_stamp
                               (
                                pv_i_IncludeSeconds => 'N'
                               );
          --
          gvv_ProgressIndicator := '0200';
          --
          vv_BackupTableName := 'xxmx_xgat_bkp_'
                              ||LTRIM(RTRIM(vv_DateStamp));
          --
          gvv_SQLAction      := 'CREATE TABLE '
                              ||vv_BackupTableName;
          --
          gvv_SQLColumnList  := 'AS SELECT *';
          --
          gvv_SQLTableClause := 'FROM xxmx_gl_account_transforms';
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLColumnList
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Generated SQL Statement : '
                                        ||gvv_SQLStatement
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0210';
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Backup table "'
                                        ||vv_BackupTableName
                                        ||'" created.'
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
                    --ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
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
                    --ROLLBACK;
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
                         ,pt_i_Phase             => gct_Phase
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
     END gen_default_gl_acct_transforms;
     --
     --
     /*
     *******************************************
     ** PROCEDURE: verify_gl_account_transforms
     *******************************************
     */
     --
     PROCEDURE verify_gl_account_transforms
                    (
                     pt_i_ApplicationSuite           IN      xxmx_gl_account_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_gl_account_transforms.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_gl_account_transforms.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_gl_account_transforms.sub_entity%TYPE
                    ,pt_i_SourceLedgerName           IN      xxmx_gl_account_transforms.source_ledger_name%TYPE
                    ,pn_o_TransformRowCount              OUT NUMBER
                    ,pb_o_UnfrozenTransforms             OUT BOOLEAN
                    ,pt_o_TransformEvaluationMsg         OUT xxmx_data_messages.data_message%TYPE
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
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'VERIFY_ACCOUNT_TRANSFORMS';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'verify_gl_account_transforms';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vn_UnfrozenTransformCount       NUMBER;
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
          gvv_ProgressIndicator := '0010';
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
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => gct_Phase
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
                    ,pt_i_Phase             => gct_Phase
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => gct_Phase
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
          gvv_ProgressIndicator := '0020';
          --
          SELECT COUNT(1)
          INTO   pn_o_TransformRowCount
          FROM   xxmx_gl_account_transforms  xgat
          WHERE  1 = 1
          AND    xgat.application_suite  = pt_i_ApplicationSuite
          AND    xgat.application        = pt_i_Application
          AND    xgat.business_entity    = pt_i_BusinessEntity
          AND    xgat.sub_entity         = pt_i_SubEntity
          AND    xgat.source_ledger_name = pt_i_SourceLedgerName;
          --
          gvv_ProgressIndicator := '0030';
          --
          SELECT COUNT(1)
          INTO   vn_UnfrozenTransformCount
          FROM   xxmx_gl_account_transforms  xgat
          WHERE  1 = 1
          AND    xgat.application_suite  = pt_i_ApplicationSuite
          AND    xgat.application        = pt_i_Application
          AND    xgat.business_entity    = pt_i_BusinessEntity
          AND    xgat.sub_entity         = pt_i_SubEntity
          AND    source_ledger_name      = pt_i_SourceLedgerName
          AND    NVL(frozen_flag, 'N')  <> 'Y';
          --
          pb_o_UnfrozenTransforms := FALSE;
          --
          gvv_ProgressIndicator := '0040';
          --
          IF   pn_o_TransformRowCount > 0
          THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               IF   vn_UnfrozenTransformCount = pn_o_TransformRowCount
               THEN
                    --
                    pb_o_UnfrozenTransforms := TRUE;
                    --
                    pt_o_TransformEvaluationMsg := pn_o_TransformRowCount
                                                 ||' GL Account Transforms have been defined for Source Ledger "'
                                                 ||pt_i_SourceLedgerName
                                                 ||'" however none are in a frozen state.  XFM Table rows which have been transformed '
                                                 ||'using unfrozen data can be identified with a MIGRATION_STATUS of "GL_ACCOUNT_TRANSFORM_REVIEW".';
                    --
               ELSIF vn_UnfrozenTransformCount > 0
               THEN
                    --
                    pb_o_UnfrozenTransforms := TRUE;
                    --
                    pt_o_TransformEvaluationMsg := pn_o_TransformRowCount
                                                 ||' GL Account Transforms have been defined for Source Ledger "'
                                                 ||pt_i_SourceLedgerName
                                                 ||'" however '
                                                 ||vn_UnfrozenTransformCount
                                                 ||' are in an unfrozen state.  XFM Table rows which have been transformed '
                                                 ||'using unfrozen data can be identified with a MIGRATION_STATUS of "GL_ACCOUNT_TRANSFORM_REVIEW".';
                    --
               ELSE
                    --
                    pt_o_TransformEvaluationMsg := pn_o_TransformRowCount
                                                 ||' GL Account Transforms have been defined for Source Ledger "'
                                                 ||pt_i_SourceLedgerName
                                                 ||'" and all appear to be in a frozen state.';
                    --
               END IF;
               --
          ELSE
               --
               gvv_ProgressIndicator := '0060';
               --
               pt_o_TransformEvaluationMsg := 'No GL Account Transforms are defined for Source Ledger "'
                                            ||pt_i_SourceLedgerName
                                            ||'".';
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
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
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
                         ,pt_i_Phase             => gct_Phase
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
     END verify_gl_account_transforms;
     --
     --
     /*
     **********************************
     ** PROCEDURE: transform_gl_account
     **********************************
     */
     --
     PROCEDURE transform_gl_account
                    (
                     pt_i_ApplicationSuite           IN      xxmx_gl_account_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_gl_account_transforms.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_gl_account_transforms.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_gl_account_transforms.sub_entity%TYPE
                    ,pt_i_SourceLedgerName           IN      xxmx_gl_account_transforms.source_ledger_name%TYPE
                    ,pt_i_SourceSegment1             IN      xxmx_gl_account_transforms.source_segment1%TYPE
                    ,pt_i_SourceSegment2             IN      xxmx_gl_account_transforms.source_segment2%TYPE
                    ,pt_i_SourceSegment3             IN      xxmx_gl_account_transforms.source_segment3%TYPE
                    ,pt_i_SourceSegment4             IN      xxmx_gl_account_transforms.source_segment4%TYPE
                    ,pt_i_SourceSegment5             IN      xxmx_gl_account_transforms.source_segment5%TYPE
                    ,pt_i_SourceSegment6             IN      xxmx_gl_account_transforms.source_segment6%TYPE
                    ,pt_i_SourceSegment7             IN      xxmx_gl_account_transforms.source_segment7%TYPE
                    ,pt_i_SourceSegment8             IN      xxmx_gl_account_transforms.source_segment8%TYPE
                    ,pt_i_SourceSegment9             IN      xxmx_gl_account_transforms.source_segment9%TYPE
                    ,pt_i_SourceSegment10            IN      xxmx_gl_account_transforms.source_segment10%TYPE
                    ,pt_i_SourceSegment11            IN      xxmx_gl_account_transforms.source_segment11%TYPE
                    ,pt_i_SourceSegment12            IN      xxmx_gl_account_transforms.source_segment12%TYPE
                    ,pt_i_SourceSegment13            IN      xxmx_gl_account_transforms.source_segment13%TYPE
                    ,pt_i_SourceSegment14            IN      xxmx_gl_account_transforms.source_segment14%TYPE
                    ,pt_i_SourceSegment15            IN      xxmx_gl_account_transforms.source_segment15%TYPE
                    ,pt_i_SourceSegment16            IN      xxmx_gl_account_transforms.source_segment16%TYPE
                    ,pt_i_SourceSegment17            IN      xxmx_gl_account_transforms.source_segment17%TYPE
                    ,pt_i_SourceSegment18            IN      xxmx_gl_account_transforms.source_segment18%TYPE
                    ,pt_i_SourceSegment19            IN      xxmx_gl_account_transforms.source_segment19%TYPE
                    ,pt_i_SourceSegment20            IN      xxmx_gl_account_transforms.source_segment20%TYPE
                    ,pt_i_SourceSegment21            IN      xxmx_gl_account_transforms.source_segment21%TYPE
                    ,pt_i_SourceSegment22            IN      xxmx_gl_account_transforms.source_segment22%TYPE
                    ,pt_i_SourceSegment23            IN      xxmx_gl_account_transforms.source_segment23%TYPE
                    ,pt_i_SourceSegment24            IN      xxmx_gl_account_transforms.source_segment24%TYPE
                    ,pt_i_SourceSegment25            IN      xxmx_gl_account_transforms.source_segment25%TYPE
                    ,pt_i_SourceSegment26            IN      xxmx_gl_account_transforms.source_segment26%TYPE
                    ,pt_i_SourceSegment27            IN      xxmx_gl_account_transforms.source_segment27%TYPE
                    ,pt_i_SourceSegment28            IN      xxmx_gl_account_transforms.source_segment28%TYPE
                    ,pt_i_SourceSegment29            IN      xxmx_gl_account_transforms.source_segment29%TYPE
                    ,pt_i_SourceSegment30            IN      xxmx_gl_account_transforms.source_segment30%TYPE
                    ,pt_i_SourceConcatSegments       IN      xxmx_gl_account_transforms.source_concatenated_segments%TYPE
                    ,pt_o_FusionSegment1                OUT  xxmx_gl_account_transforms.fusion_segment1%TYPE
                    ,pt_o_FusionSegment2                OUT  xxmx_gl_account_transforms.fusion_segment2%TYPE
                    ,pt_o_FusionSegment3                OUT  xxmx_gl_account_transforms.fusion_segment3%TYPE
                    ,pt_o_FusionSegment4                OUT  xxmx_gl_account_transforms.fusion_segment4%TYPE
                    ,pt_o_FusionSegment5                OUT  xxmx_gl_account_transforms.fusion_segment5%TYPE
                    ,pt_o_FusionSegment6                OUT  xxmx_gl_account_transforms.fusion_segment6%TYPE
                    ,pt_o_FusionSegment7                OUT  xxmx_gl_account_transforms.fusion_segment7%TYPE
                    ,pt_o_FusionSegment8                OUT  xxmx_gl_account_transforms.fusion_segment8%TYPE
                    ,pt_o_FusionSegment9                OUT  xxmx_gl_account_transforms.fusion_segment9%TYPE
                    ,pt_o_FusionSegment10               OUT  xxmx_gl_account_transforms.fusion_segment10%TYPE
                    ,pt_o_FusionSegment11               OUT  xxmx_gl_account_transforms.fusion_segment11%TYPE
                    ,pt_o_FusionSegment12               OUT  xxmx_gl_account_transforms.fusion_segment12%TYPE
                    ,pt_o_FusionSegment13               OUT  xxmx_gl_account_transforms.fusion_segment13%TYPE
                    ,pt_o_FusionSegment14               OUT  xxmx_gl_account_transforms.fusion_segment14%TYPE
                    ,pt_o_FusionSegment15               OUT  xxmx_gl_account_transforms.fusion_segment15%TYPE
                    ,pt_o_FusionSegment16               OUT  xxmx_gl_account_transforms.fusion_segment16%TYPE
                    ,pt_o_FusionSegment17               OUT  xxmx_gl_account_transforms.fusion_segment17%TYPE
                    ,pt_o_FusionSegment18               OUT  xxmx_gl_account_transforms.fusion_segment18%TYPE
                    ,pt_o_FusionSegment19               OUT  xxmx_gl_account_transforms.fusion_segment19%TYPE
                    ,pt_o_FusionSegment20               OUT  xxmx_gl_account_transforms.fusion_segment20%TYPE
                    ,pt_o_FusionSegment21               OUT  xxmx_gl_account_transforms.fusion_segment21%TYPE
                    ,pt_o_FusionSegment22               OUT  xxmx_gl_account_transforms.fusion_segment22%TYPE
                    ,pt_o_FusionSegment23               OUT  xxmx_gl_account_transforms.fusion_segment23%TYPE
                    ,pt_o_FusionSegment24               OUT  xxmx_gl_account_transforms.fusion_segment24%TYPE
                    ,pt_o_FusionSegment25               OUT  xxmx_gl_account_transforms.fusion_segment25%TYPE
                    ,pt_o_FusionSegment26               OUT  xxmx_gl_account_transforms.fusion_segment26%TYPE
                    ,pt_o_FusionSegment27               OUT  xxmx_gl_account_transforms.fusion_segment27%TYPE
                    ,pt_o_FusionSegment28               OUT  xxmx_gl_account_transforms.fusion_segment28%TYPE
                    ,pt_o_FusionSegment29               OUT  xxmx_gl_account_transforms.fusion_segment29%TYPE
                    ,pt_o_FusionSegment30               OUT  xxmx_gl_account_transforms.fusion_segment30%TYPE
                    ,pt_o_FusionConcatSegments          OUT  xxmx_gl_account_transforms.fusion_concatenated_segments%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
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
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'TRANSFORM_ACCOUNT';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'transform_gl_account_segment';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vt_FrozenFlag                   xxmx_gl_account_transforms.frozen_flag%TYPE;
          vv_MatchedBy                    VARCHAR2(50);
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
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pv_o_ReturnMessage := NULL;
          --
          IF   pt_i_SourceConcatSegments IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               vv_MatchedBy := 'concatenated Source Segments';
               --
               SELECT   xgat.fusion_segment1
                       ,xgat.fusion_segment2
                       ,xgat.fusion_segment3
                       ,xgat.fusion_segment4
                       ,xgat.fusion_segment5
                       ,xgat.fusion_segment6
                       ,xgat.fusion_segment7
                       ,xgat.fusion_segment8
                       ,xgat.fusion_segment9
                       ,xgat.fusion_segment10
                       ,xgat.fusion_segment11
                       ,xgat.fusion_segment12
                       ,xgat.fusion_segment13
                       ,xgat.fusion_segment14
                       ,xgat.fusion_segment15
                       ,xgat.fusion_segment16
                       ,xgat.fusion_segment17
                       ,xgat.fusion_segment18
                       ,xgat.fusion_segment19
                       ,xgat.fusion_segment20
                       ,xgat.fusion_segment21
                       ,xgat.fusion_segment22
                       ,xgat.fusion_segment23
                       ,xgat.fusion_segment24
                       ,xgat.fusion_segment25
                       ,xgat.fusion_segment26
                       ,xgat.fusion_segment27
                       ,xgat.fusion_segment28
                       ,xgat.fusion_segment29
                       ,xgat.fusion_segment30
                       ,xgat.fusion_concatenated_segments
                       ,xgat.frozen_flag
               INTO     pt_o_FusionSegment1
                       ,pt_o_FusionSegment2
                       ,pt_o_FusionSegment3
                       ,pt_o_FusionSegment4
                       ,pt_o_FusionSegment5
                       ,pt_o_FusionSegment6
                       ,pt_o_FusionSegment7
                       ,pt_o_FusionSegment8
                       ,pt_o_FusionSegment9
                       ,pt_o_FusionSegment10
                       ,pt_o_FusionSegment11
                       ,pt_o_FusionSegment12
                       ,pt_o_FusionSegment13
                       ,pt_o_FusionSegment14
                       ,pt_o_FusionSegment15
                       ,pt_o_FusionSegment16
                       ,pt_o_FusionSegment17
                       ,pt_o_FusionSegment18
                       ,pt_o_FusionSegment19
                       ,pt_o_FusionSegment20
                       ,pt_o_FusionSegment21
                       ,pt_o_FusionSegment22
                       ,pt_o_FusionSegment23
                       ,pt_o_FusionSegment24
                       ,pt_o_FusionSegment25
                       ,pt_o_FusionSegment26
                       ,pt_o_FusionSegment27
                       ,pt_o_FusionSegment28
                       ,pt_o_FusionSegment29
                       ,pt_o_FusionSegment30
                       ,pt_o_FusionConcatSegments
                       ,vt_FrozenFlag
               FROM     xxmx_gl_account_transforms  xgat
               WHERE    1 = 1
               AND      xgat.application_suite            = pt_i_ApplicationSuite
               AND      xgat.application                  = pt_i_Application
               AND      xgat.business_entity              = pt_i_BusinessEntity
               AND      xgat.sub_entity                   = pt_i_SubEntity
               AND      xgat.source_ledger_name           = pt_i_SourceLedgerName
               AND      xgat.source_concatenated_segments = pt_i_SourceConcatSegments;
               --
          END IF;
          --
          /*
          ** If an Account Code Combination mapping could not be found by the Concatenated Source Segments,
          ** attempt to find a mapping using the individual source segment values.
          */
          --
          IF   pt_o_FusionConcatSegments IS NULL
          THEN
               --
               gvv_ProgressIndicator := '0030';
               --
               vv_MatchedBy := 'individual Source Segments';
               --
               SELECT   xgat.fusion_segment1
                       ,xgat.fusion_segment2
                       ,xgat.fusion_segment3
                       ,xgat.fusion_segment4
                       ,xgat.fusion_segment5
                       ,xgat.fusion_segment6
                       ,xgat.fusion_segment7
                       ,xgat.fusion_segment8
                       ,xgat.fusion_segment9
                       ,xgat.fusion_segment10
                       ,xgat.fusion_segment11
                       ,xgat.fusion_segment12
                       ,xgat.fusion_segment13
                       ,xgat.fusion_segment14
                       ,xgat.fusion_segment15
                       ,xgat.fusion_segment16
                       ,xgat.fusion_segment17
                       ,xgat.fusion_segment18
                       ,xgat.fusion_segment19
                       ,xgat.fusion_segment20
                       ,xgat.fusion_segment21
                       ,xgat.fusion_segment22
                       ,xgat.fusion_segment23
                       ,xgat.fusion_segment24
                       ,xgat.fusion_segment25
                       ,xgat.fusion_segment26
                       ,xgat.fusion_segment27
                       ,xgat.fusion_segment28
                       ,xgat.fusion_segment29
                       ,xgat.fusion_segment30
                       ,xgat.fusion_concatenated_segments
                       ,xgat.frozen_flag
               INTO     pt_o_FusionSegment1
                       ,pt_o_FusionSegment2
                       ,pt_o_FusionSegment3
                       ,pt_o_FusionSegment4
                       ,pt_o_FusionSegment5
                       ,pt_o_FusionSegment6
                       ,pt_o_FusionSegment7
                       ,pt_o_FusionSegment8
                       ,pt_o_FusionSegment9
                       ,pt_o_FusionSegment10
                       ,pt_o_FusionSegment11
                       ,pt_o_FusionSegment12
                       ,pt_o_FusionSegment13
                       ,pt_o_FusionSegment14
                       ,pt_o_FusionSegment15
                       ,pt_o_FusionSegment16
                       ,pt_o_FusionSegment17
                       ,pt_o_FusionSegment18
                       ,pt_o_FusionSegment19
                       ,pt_o_FusionSegment20
                       ,pt_o_FusionSegment21
                       ,pt_o_FusionSegment22
                       ,pt_o_FusionSegment23
                       ,pt_o_FusionSegment24
                       ,pt_o_FusionSegment25
                       ,pt_o_FusionSegment26
                       ,pt_o_FusionSegment27
                       ,pt_o_FusionSegment28
                       ,pt_o_FusionSegment29
                       ,pt_o_FusionSegment30
                       ,pt_o_FusionConcatSegments
                       ,vt_FrozenFlag
               FROM     xxmx_gl_account_transforms  xgat
               WHERE    1 = 1
               AND      xgat.application_suite     = pt_i_ApplicationSuite
               AND      xgat.application           = pt_i_Application
               AND      xgat.business_entity       = pt_i_BusinessEntity
               AND      xgat.sub_entity            = pt_i_SubEntity
               AND      xgat.source_ledger_name    = pt_i_SourceLedgerName
               AND      (
                            pt_i_SourceSegment1   IS NULL
                         OR (
                                 pt_i_SourceSegment1   IS NOT NULL
                             AND xgat.source_segment1   = pt_i_SourceSegment1
                            )
                        )
               AND      (
                            pt_i_SourceSegment2   IS NULL
                         OR (
                                 pt_i_SourceSegment2   IS NOT NULL
                             AND xgat.source_segment2   = pt_i_SourceSegment2
                            )
                        )
               AND      (
                            pt_i_SourceSegment3   IS NULL
                         OR (
                                 pt_i_SourceSegment3   IS NOT NULL
                             AND xgat.source_segment3   = pt_i_SourceSegment3
                            )
                        )
               AND      (
                            pt_i_SourceSegment4   IS NULL
                         OR (
                                 pt_i_SourceSegment4   IS NOT NULL
                             AND xgat.source_segment4   = pt_i_SourceSegment4
                            )
                        )
               AND      (
                            pt_i_SourceSegment5   IS NULL
                         OR (
                                 pt_i_SourceSegment5   IS NOT NULL
                             AND xgat.source_segment5   = pt_i_SourceSegment5
                            )
                        )
               AND      (
                            pt_i_SourceSegment6   IS NULL
                         OR (
                                 pt_i_SourceSegment6   IS NOT NULL
                             AND xgat.source_segment6   = pt_i_SourceSegment6
                            )
                        )
               AND      (
                            pt_i_SourceSegment7   IS NULL
                         OR (
                                 pt_i_SourceSegment7   IS NOT NULL
                             AND xgat.source_segment7   = pt_i_SourceSegment7
                            )
                        )
               AND      (
                            pt_i_SourceSegment8   IS NULL
                         OR (
                                 pt_i_SourceSegment8   IS NOT NULL
                             AND xgat.source_segment8   = pt_i_SourceSegment8
                            )
                        )
               AND      (
                            pt_i_SourceSegment9  IS NULL
                         OR (
                                 pt_i_SourceSegment9   IS NOT NULL
                             AND xgat.source_segment9   = pt_i_SourceSegment9
                            )
                        )
               AND      (
                            pt_i_SourceSegment10 IS NULL
                         OR (
                                 pt_i_SourceSegment10  IS NOT NULL
                             AND xgat.source_segment10  = pt_i_SourceSegment10
                            )
                        )
               AND      (
                            pt_i_SourceSegment11 IS NULL
                         OR (
                                 pt_i_SourceSegment11  IS NOT NULL
                             AND xgat.source_segment11  = pt_i_SourceSegment11
                            )
                        )
               AND      (
                            pt_i_SourceSegment12 IS NULL
                         OR (
                                 pt_i_SourceSegment12  IS NOT NULL
                             AND xgat.source_segment12  = pt_i_SourceSegment12
                            )
                        )
               AND      (
                            pt_i_SourceSegment13 IS NULL
                         OR (
                                 pt_i_SourceSegment13  IS NOT NULL
                             AND xgat.source_segment13  = pt_i_SourceSegment13
                            )
                        )
               AND      (
                            pt_i_SourceSegment14 IS NULL
                         OR (
                                 pt_i_SourceSegment14  IS NOT NULL
                             AND xgat.source_segment14  = pt_i_SourceSegment14
                            )
                        )
               AND      (
                            pt_i_SourceSegment15 IS NULL
                         OR (
                                 pt_i_SourceSegment15  IS NOT NULL
                             AND xgat.source_segment15  = pt_i_SourceSegment15
                            )
                        )
               AND      (
                            pt_i_SourceSegment16 IS NULL
                         OR (
                                 pt_i_SourceSegment16  IS NOT NULL
                             AND xgat.source_segment16  = pt_i_SourceSegment16
                            )
                        )
               AND      (
                            pt_i_SourceSegment17 IS NULL
                         OR (
                                 pt_i_SourceSegment17  IS NOT NULL
                             AND xgat.source_segment17  = pt_i_SourceSegment17
                            )
                        )
               AND      (
                            pt_i_SourceSegment18 IS NULL
                         OR (
                                  pt_i_SourceSegment18 IS NOT NULL
                             AND xgat.source_segment18  = pt_i_SourceSegment18
                            )
                        )
               AND      (
                            pt_i_SourceSegment19 IS NULL
                         OR (
                                 pt_i_SourceSegment19  IS NOT NULL
                             AND xgat.source_segment19  = pt_i_SourceSegment19
                            )
                        )
               AND      (
                            pt_i_SourceSegment20 IS NULL
                         OR (
                                 pt_i_SourceSegment20  IS NOT NULL
                             AND xgat.source_segment20  = pt_i_SourceSegment20
                            )
                        )
               AND      (
                            pt_i_SourceSegment21 IS NULL
                         OR (
                                 pt_i_SourceSegment21  IS NOT NULL
                             AND xgat.source_segment21  = pt_i_SourceSegment21
                            )
                        )
               AND      (
                            pt_i_SourceSegment22 IS NULL
                         OR (
                                 pt_i_SourceSegment22  IS NOT NULL
                             AND xgat.source_segment22  = pt_i_SourceSegment22
                            )
                        )
               AND      (
                            pt_i_SourceSegment23 IS NULL
                         OR (
                                 pt_i_SourceSegment23  IS NOT NULL
                             AND xgat.source_segment23  = pt_i_SourceSegment23
                            )
                        )
               AND      (
                            pt_i_SourceSegment24 IS NULL
                         OR (
                                 pt_i_SourceSegment24  IS NOT NULL
                             AND xgat.source_segment24  = pt_i_SourceSegment24
                            )
                        )
               AND      (
                            pt_i_SourceSegment25 IS NULL
                         OR (
                                 pt_i_SourceSegment25  IS NOT NULL
                             AND xgat.source_segment25  = pt_i_SourceSegment25
                            )
                        )
               AND      (
                            pt_i_SourceSegment26 IS NULL
                         OR (
                                 pt_i_SourceSegment26  IS NOT NULL
                             AND xgat.source_segment26  = pt_i_SourceSegment26
                            )
                        )
               AND      (
                            pt_i_SourceSegment27 IS NULL
                         OR (
                                 pt_i_SourceSegment27  IS NOT NULL
                             AND xgat.source_segment27  = pt_i_SourceSegment27
                            )
                        )
               AND      (
                            pt_i_SourceSegment28 IS NULL
                         OR (
                                 pt_i_SourceSegment28  IS NOT NULL
                             AND xgat.source_segment28  = pt_i_SourceSegment28
                            )
                        )
               AND      (
                            pt_i_SourceSegment29 IS NULL
                         OR (
                                 pt_i_SourceSegment29  IS NOT NULL
                             AND xgat.source_segment29  = pt_i_SourceSegment29
                            )
                        )
               AND      (
                            pt_i_SourceSegment30 IS NULL
                         OR (
                                 pt_i_SourceSegment30  IS NOT NULL
                             AND xgat.source_segment30  = pt_i_SourceSegment30
                            )
                        );
               --
          END IF;
          --
          /*
          ** If the Concatented Segments output parameter is still NULL then no match was found so
          ** set the return status and return message output parameters appropriately.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          IF   pt_o_FusionConcatSegments IS NULL
          THEN
               --
               pv_o_ReturnStatus := 'E';
               --
               pv_o_ReturnMessage := 'ERROR : Source GL Account Code not found in "xxmx_gl_account_transformations" table.';
               --
          ELSE
               --
               IF   vt_FrozenFlag = 'N'
               THEN
                    --
                    pv_o_ReturnStatus := 'W';
                    --
                    pv_o_ReturnMessage := 'WARNING : Transformed GL Account Code is not "frozen" in the "xxmx_gl_account_transformations" table.  '
                                        ||'This means that the Account has only been partially transformed (i.e. there were segment transform errors).  '
                                        ||'This Account Code Combination may cause errors if used during import into Fusion Cloud.';
                    --
               END IF;
               --
          END IF;
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    pv_o_ReturnStatus := 'E';
                    --
                    gvt_Severity := 'ERROR';
                    --
                    pv_o_ReturnMessage := 'The specified '
                                       ||vv_MatchedBy
                                       ||' did not identify a Source Account Code Combination in the "xxmx_gl_account_transforms" table.';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => pv_o_ReturnMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
               --** END NO_DATA_FOUND Exception
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    pv_o_ReturnStatus := 'E';
                    --
                    gvt_Severity := 'ERROR';
                    --
                    pv_o_ReturnMessage := 'The specified '
                                       ||vv_MatchedBy
                                       ||' matched multiple Source Account Code Combinations in the "xxmx_gl_account_transforms" table.';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => pv_o_ReturnMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN OTHERS
               THEN
                    --
                    pv_o_ReturnStatus := 'E';
                    --
                    pv_o_ReturnMessage := 'Oracle error encountered in "transform_gl_account" procedure.'
                                       ||'  Refer to the "xxmx_module_messages" table for further details.';
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
                         ,pt_i_Phase             => gct_Phase
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
     END transform_gl_account;
     --
     --
     FUNCTION account_code_format_is_valid
                   (
                    pv_i_SourceOrFusionAccount      IN      VARCHAR2
                   ,pt_i_LedgerName                 IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                   ,pv_i_ConcatenatedAccountCode    IN      VARCHAR2
                   ,pt_o_AccountEvaluationMsg          OUT  xxmx_data_messages.data_message%TYPE
                   )
     RETURN BOOLEAN
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
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ACCOUNT_VALIDATION';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'fusion_account_code_is_valid';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vt_ExpectedSegmentDelimiter     xxmx_gl_source_structures.source_segment_delimiter%TYPE;
          vb_AccountDelimitersAreValid    BOOLEAN;
          vb_AccountCodeFormatIsValid     BOOLEAN;
          vv_TempString                   VARCHAR2(1000);
          vv_CurrentCharacter             VARCHAR2(1);
          vv_InvalidDelimiters            VARCHAR2(100);
          vv_InvalidDelimiterNumbers      VARCHAR2(240);
          vn_ExpectedNumberOfSegments     NUMBER;
          vn_DelimiterCount               NUMBER;
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
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --
     --** END Declarations
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          pt_o_AccountEvaluationMsg   := NULL;
          --
          /*
          ** Verify that the mandatory parameters have been passed.
          */
          --
          IF   pv_i_SourceOrFusionAccount   IS NULL
          OR   pt_i_LedgerName              IS NULL
          OR   pv_i_ConcatenatedAccountCode IS NULL
          THEN
               --
               pt_o_AccountEvaluationMsg := 'All parameter values are mandatory in a call to the '
                                          ||gct_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'Function (the "pv_i_SourceOrFusionAccount" parameter must have a value of "SOURCE" or "FUSION").';
               --
               RETURN(FALSE);
               --
          END IF; --** If any parameter values are missing
          --
          /*
          ** First we retrieve appropriate Segment Delimiter the from the relevant GL Utilities
          ** table dependant on the value of the "pv_i_SourceOrFusionAccount" parameter.
          **
          ** If the Ledger is not defined in the relevant table or the Segment Delimiter column
          ** is blank we can not do any further validations on the concatenated Account Code.
          **
          ** This should be handled as a fatal error because essential setup has not been
          ** performed in the GL Utilities table and so whatever process called this function
          ** should receive a raised exception.
          */
          --
          gvv_ProgressIndicator := '0020';
          --
          vt_ExpectedSegmentDelimiter := NULL;
          --
          IF   pv_i_SourceOrFusionAccount = 'SOURCE'
          THEN
               --
               gvv_ProgressIndicator := '0030';
               --
               BEGIN
                    --
                    SELECT source_segment_delimiter
                    INTO   vt_ExpectedSegmentDelimiter
                    FROM   xxmx_gl_source_structures
                    WHERE  1 = 1
                    AND    source_ledger_name = pt_i_LedgerName;
                    --
                    EXCEPTION
                         --
                         WHEN NO_DATA_FOUND
                         THEN
                              --
                              pt_o_AccountEvaluationMsg := INITCAP(pv_i_SourceOrFusionAccount)
                                                         ||' Ledger "'
                                                         ||pt_i_LedgerName
                                                         ||'" could not be found in the "xxmx_gl_'
                                                         ||LOWER(pv_i_SourceOrFusionAccount)
                                                         ||'_structures" table. Segment delimiter could not be determined.';
                              --
                              RETURN(FALSE);
                              --
                         --** END NO_DATA_FOUND Exception
                         --
                         WHEN OTHERS
                         THEN
                              --
                              RAISE;
                              --
                         --** END OTHERS Exception
                         --
                    --** END Exception Handler
                    --
               END; --** Segment Delimiter retrieval block.
               --
          ELSIF pv_i_SourceOrFusionAccount = 'FUSION'
          THEN
               --
               gvv_ProgressIndicator := '0040';
               --
               BEGIN
                    --
                    SELECT fusion_segment_delimiter
                    INTO   vt_ExpectedSegmentDelimiter
                    FROM   xxmx_gl_fusion_structures
                    WHERE  1 = 1
                    AND    fusion_ledger_name = pt_i_LedgerName;
                    --
                    EXCEPTION
                         --
                         WHEN NO_DATA_FOUND
                         THEN
                              --
                              pt_o_AccountEvaluationMsg := INITCAP(pv_i_SourceOrFusionAccount)
                                                         ||' Ledger "'
                                                         ||pt_i_LedgerName
                                                         ||'" could not be found in the "xxmx_gl_'
                                                         ||LOWER(pv_i_SourceOrFusionAccount)
                                                         ||'_structures" table. Segment delimiter could not be determined.';
                              --
                              RETURN(FALSE);
                              --
                         --** END NO_DATA_FOUND Exception
                         --
                         WHEN OTHERS
                         THEN
                              --
                              RAISE;
                              --
                         --** END OTHERS Exception
                         --
                    --** END Exception Handler
                    --
               END; --** Segment Delimiter retrieval block.
               --
          ELSE
               --
               gvv_ProgressIndicator := '0050';
               --
               pt_o_AccountEvaluationMsg := '- the "pv_i_SourceOrFusionAccount" parameter must have a value of "SOURCE" or "FUSION".';
               --
               RETURN(FALSE);
               --
          END IF; --** IF  pv_i_SourceOrFusionAccount = 'SOURCE' or 'FUSION'
          --
          /*
          ** Check if the Segment Delimiter column retrieved from the GL Utilities Structures
          ** table IS NULL.
          */
          --
          gvv_ProgressIndicator := '0060';
          --
          IF   vt_ExpectedSegmentDelimiter IS NULL
          THEN
               --
               pt_o_AccountEvaluationMsg := 'The "'
                                          ||LOWER(pv_i_SourceOrFusionAccount)
                                          ||'_segment_delimiter" column in the "xxmx_gl_'
                                          ||LOWER(pv_i_SourceOrFusionAccount)
                                          ||'_structures" table does not have a value for '
                                          ||INITCAP(pv_i_SourceOrFusionAccount)
                                          ||' Ledger "'
                                          ||pt_i_LedgerName
                                          ||'".';
               --
               RETURN(FALSE);
               --
          END IF; --** IF  pv_i_SourceOrFusionAccount = 'SOURCE' or 'FUSION'
          --
          /*
          ** Now we have the Segment Delimiter, the basic validations we can perform on the concatenated
          ** Account Code string are:
          **
          ** 1) The Default Account String contains the appropiate Segment Delimiter.  If it doesn't it is
          **    not even an Account (however not sure if an Account can just be a single segment).
          **
          ** 2) If the Default Account String contains the Segment Delimiter, then we can perform the
          **    following validations:
          **
          **    a) The Segment Delimiter is the first character which indicates the first segment may be
          **       missing (e.g. -XXX-XXXX-XXXXXX-XXXXX)
          **    b) The Segment Delimiter is the last character which indicates the first segment may be
          **       missing (e.g. XXX-XXXX-XXXXXX-XXXXX-)
          **    c) There are two Segment Delimiters together anywhere in the string which indicates that
          **       an interim segment may be missing (e.g. XX-XXX-XXXX--XXXXX)
          **
          ** 3) Finally, the number of Segment Delimiters +1 equals the number of Segments Defined in the
          **    xxmx_gl_fusion_struct_segments table.  If there are no missing segments we still need to
          **    check that the Default Account has the correct number of segments.  e.g. the Fusion Ledger
          **    structure is defined with 5 segments but the Default Account string is XX-XXX-XXXX-XXXXX.
          **    There do not appear to be any missing segments but still the number of segments is incorrect.
          **
          ** Failures for any of the above validations are not fatal errors but whatever process called this
          ** function needs to be informed that the Account Code is not valid and what is wrong with it.
          */
          --
          gvv_ProgressIndicator := '0070';
          --
          vb_AccountDelimitersAreValid := TRUE;
          vb_AccountCodeFormatIsValid  := TRUE;
          --
          /*
          ** Replace any standard alphanumeric characters with a space.
          */
          --
          vv_TempString := TRANSLATE(
                                     pv_i_ConcatenatedAccountCode
                                    ,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
                                    ,'                                                              '
                                    );
          --
          /*
          ** Now remove all spaces which should leave only special characters.
          */
          --
          vv_TempString := REPLACE(
                                   vv_TempString
                                  ,' '
                                  ,''
                                  );
          --
          /*
          ** Now compare each individual character remaining in vv_TempString to the expected
          ** segment delimiter in vt_SegmentDelimiter.
          **
          ** If the current character does not match the expected segment delimiter, add the
          ** occurrence number of the delimiter (as opposed to it's position) to a
          ** to a string of invalid delimiter occurences and add the delimiter itself to a
          ** string of invalid delimiters.
          */
          --
          vv_InvalidDelimiters       := NULL;
          vv_InvalidDelimiterNumbers := NULL;
          --
          FOR  delimiter_occurence
          IN   1..LENGTH(vv_TempString)
          LOOP
               --
               vv_CurrentCharacter := SUBSTR(vv_TempString, delimiter_occurence, 1);
               --
               IF   vv_CurrentCharacter <> vt_ExpectedSegmentDelimiter
               THEN
                    --
                    vb_AccountDelimitersAreValid := FALSE;
                    --
                    vv_InvalidDelimiterNumbers := vv_InvalidDelimiterNumbers||TO_CHAR(delimiter_occurence)||',';
                    --
                    IF   vv_InvalidDelimiters IS NULL
                    OR   INSTR(vv_InvalidDelimiters, vv_CurrentCharacter) = 0
                    THEN
                         --
                         vv_InvalidDelimiters := vv_InvalidDelimiters||vv_CurrentCharacter||',';
                         --
                    END IF; --** INSTR(vv_InvalidDelimiters, vv_CurrentCharacter) = 0
                    --
               END IF; --** vv_CurrentCharacter <> vt_ExpectedSegmentDelimiter
               --
          END LOOP; --** character position LOOP
          --
          /*
          ** Remove end commas.
          */
          --
          vv_InvalidDelimiterNumbers := RTRIM(vv_InvalidDelimiterNumbers ,',');
          vv_InvalidDelimiters       := RTRIM(vv_InvalidDelimiters ,',');
          --
          IF   NOT vb_AccountDelimitersAreValid
          THEN
               --
               /*
               ** Default Account DOES NOT CONTAIN the Segment Delimiter.
               */
               --
               gvv_ProgressIndicator := '0080';
               --
               vb_AccountCodeFormatIsValid := FALSE;
               --
               pt_o_AccountEvaluationMsg := 'Segment Delimiter/s ['
                                          ||vv_InvalidDelimiters
                                          ||'] in position/s ['
                                          ||vv_InvalidDelimiterNumbers
                                          ||'] are invalid, the expected delimiter is ['
                                          ||vt_ExpectedSegmentDelimiter
                                          ||'].';
               --
          ELSE
               --
               /*
               ** Account code string CONTAINS the Segment Delimiter so check for possible missing segments.
               */
               --
               gvv_ProgressIndicator := '0090';
               --
               IF   SUBSTR(pv_i_ConcatenatedAccountCode,  1) = vt_ExpectedSegmentDelimiter                            -- Missing first Segment
               OR   SUBSTR(pv_i_ConcatenatedAccountCode, -1) = vt_ExpectedSegmentDelimiter                            -- Missing last Segment
               OR   INSTR(pv_i_ConcatenatedAccountCode, vt_ExpectedSegmentDelimiter||vt_ExpectedSegmentDelimiter) > 0 -- Missing segment in the middle
               THEN
                    --
                    vb_AccountCodeFormatIsValid := FALSE;
                    --
                    pt_o_AccountEvaluationMsg := 'Account Code appears to be missing Segments.';
                    --
               ELSE
                    --
                    /*
                    ** At this stage we know there are no missing segments, so now we need to verify
                    ** that the Default Account value has the correct number of segments.
                    **
                    ** To do this we first identify the number of segments that should be in the Account
                    ** Structure by counting them in the relevant GL Utilities Table.
                    */
                    --
                    gvv_ProgressIndicator := '0100';
                    --
                    IF   pv_i_SourceOrFusionAccount = 'SOURCE'
                    THEN
                         --
                         gvv_ProgressIndicator := '0110';
                         --
                         SELECT COUNT(1)
                         INTO   vn_ExpectedNumberOfSegments
                         FROM   xxmx_gl_source_struct_segments
                         WHERE  1 = 1
                         AND    source_ledger_name = pt_i_LedgerName;
                         --
                    ELSIF pv_i_SourceOrFusionAccount = 'FUSION'
                    THEN
                         --
                         gvv_ProgressIndicator := '0120';
                         --
                         SELECT COUNT(1)
                         INTO   vn_ExpectedNumberOfSegments
                         FROM   xxmx_gl_fusion_struct_segments
                         WHERE  1 = 1
                         AND    fusion_ledger_name = pt_i_LedgerName;
                         --
                    END IF;
                    --
                    /*
                    ** Now identify the number of occurrences of the Segment Delimiter in the
                    ** Account Code string.  The LENGTH of the string MINUS the length of the string
                    ** (with delimiters removed) will tell us how many delimiters there are in
                    ** the string.
                    */
                    --
                    gvv_ProgressIndicator := '0130';
                    --
                    SELECT LENGTH(pv_i_ConcatenatedAccountCode)
                           - LENGTH(REPLACE(pv_i_ConcatenatedAccountCode, vt_ExpectedSegmentDelimiter, ''))
                    INTO   vn_DelimiterCount
                    FROM   dual;
                    --
                    /*
                    ** Commpare the  number of Segment Delimiters (+1) to the
                    ** expected number of Segments in the Account Structure.
                    */
                    --
                    gvv_ProgressIndicator := '0140';
                    --
                    IF   (vn_DelimiterCount + 1) <> vn_ExpectedNumberOfSegments
                    THEN
                         --
                         /*
                         ** Account Code has an incorrect number of Segments.
                         */
                         --
                         vb_AccountCodeFormatIsValid := FALSE;
                         --
                         pt_o_AccountEvaluationMsg := 'Account Code should have '
                                                    ||vn_ExpectedNumberOfSegments
                                                    ||' segments for the "'
                                                    ||pt_i_LedgerName
                                                    ||'" '
                                                    ||INITCAP(pv_i_SourceOrFusionAccount)
                                                    ||' Ledger.';
                         --
                    END IF; --** IF   (vn_FusionDelimiterCount + 1) != vn_SegmentCount
                    --
               END IF; --** IF Account Code String is possibly missing Segments.
               --
          END IF; --** IF   INSTR(pv_i_ConcatenatedAccountCode, vt_ExpectedSegmentDelimiter) = 0
          --
          gvv_ProgressIndicator := '0150';
          --
          RETURN(vb_AccountCodeFormatIsValid);
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
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
                         ,pt_i_Phase             => gct_Phase
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
     END account_code_format_is_valid;
     --
     --
     PROCEDURE separate_account_segments
                    (
                     pv_i_SourceOrFusionAccount      IN      VARCHAR2
                    ,pt_i_LedgerName                 IN      xxmx_gl_acct_seg_transforms.source_ledger_name%TYPE
                    ,pv_i_ConcatenatedAccountCode    IN      VARCHAR2
                    ,pt_o_Segment1                      OUT  xxmx_gl_account_transforms.fusion_segment1%TYPE
                    ,pt_o_Segment2                      OUT  xxmx_gl_account_transforms.fusion_segment2%TYPE
                    ,pt_o_Segment3                      OUT  xxmx_gl_account_transforms.fusion_segment3%TYPE
                    ,pt_o_Segment4                      OUT  xxmx_gl_account_transforms.fusion_segment4%TYPE
                    ,pt_o_Segment5                      OUT  xxmx_gl_account_transforms.fusion_segment5%TYPE
                    ,pt_o_Segment6                      OUT  xxmx_gl_account_transforms.fusion_segment6%TYPE
                    ,pt_o_Segment7                      OUT  xxmx_gl_account_transforms.fusion_segment7%TYPE
                    ,pt_o_Segment8                      OUT  xxmx_gl_account_transforms.fusion_segment8%TYPE
                    ,pt_o_Segment9                      OUT  xxmx_gl_account_transforms.fusion_segment9%TYPE
                    ,pt_o_Segment10                     OUT  xxmx_gl_account_transforms.fusion_segment10%TYPE
                    ,pt_o_Segment11                     OUT  xxmx_gl_account_transforms.fusion_segment11%TYPE
                    ,pt_o_Segment12                     OUT  xxmx_gl_account_transforms.fusion_segment12%TYPE
                    ,pt_o_Segment13                     OUT  xxmx_gl_account_transforms.fusion_segment13%TYPE
                    ,pt_o_Segment14                     OUT  xxmx_gl_account_transforms.fusion_segment14%TYPE
                    ,pt_o_Segment15                     OUT  xxmx_gl_account_transforms.fusion_segment15%TYPE
                    ,pt_o_Segment16                     OUT  xxmx_gl_account_transforms.fusion_segment16%TYPE
                    ,pt_o_Segment17                     OUT  xxmx_gl_account_transforms.fusion_segment17%TYPE
                    ,pt_o_Segment18                     OUT  xxmx_gl_account_transforms.fusion_segment18%TYPE
                    ,pt_o_Segment19                     OUT  xxmx_gl_account_transforms.fusion_segment19%TYPE
                    ,pt_o_Segment20                     OUT  xxmx_gl_account_transforms.fusion_segment20%TYPE
                    ,pt_o_Segment21                     OUT  xxmx_gl_account_transforms.fusion_segment21%TYPE
                    ,pt_o_Segment22                     OUT  xxmx_gl_account_transforms.fusion_segment22%TYPE
                    ,pt_o_Segment23                     OUT  xxmx_gl_account_transforms.fusion_segment23%TYPE
                    ,pt_o_Segment24                     OUT  xxmx_gl_account_transforms.fusion_segment24%TYPE
                    ,pt_o_Segment25                     OUT  xxmx_gl_account_transforms.fusion_segment25%TYPE
                    ,pt_o_Segment26                     OUT  xxmx_gl_account_transforms.fusion_segment26%TYPE
                    ,pt_o_Segment27                     OUT  xxmx_gl_account_transforms.fusion_segment27%TYPE
                    ,pt_o_Segment28                     OUT  xxmx_gl_account_transforms.fusion_segment28%TYPE
                    ,pt_o_Segment29                     OUT  xxmx_gl_account_transforms.fusion_segment29%TYPE
                    ,pt_o_Segment30                     OUT  xxmx_gl_account_transforms.fusion_segment30%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     IS
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          CURSOR SourceAccountSegments_cur
                      (
                       pt_LedgerName                   IN      xxmx_gl_source_struct_segments.source_ledger_name%TYPE
                      )
          IS
               --
               SELECT   source_segment_num
                       ,TRIM(source_segment_column)  AS source_segment_column
               FROM     xxmx_gl_source_struct_segments
               WHERE    1 = 1
               AND      source_ledger_name = pt_LedgerName
               ORDER BY source_segment_num;
               --
          --** END CURSOR SourceAccountSegments_cur
          --
          CURSOR FusionAccountSegments_cur
                      (
                       pt_LedgerName                   IN      xxmx_gl_fusion_struct_segments.fusion_ledger_name%TYPE
                      )
          IS
               --
               SELECT   fusion_segment_num
                       ,TRIM(fusion_segment_column)  AS fusion_segment_column
               FROM     xxmx_gl_fusion_struct_segments
               WHERE    1 = 1
               AND      fusion_ledger_name = pt_LedgerName
               ORDER BY fusion_segment_num;
               --
          --** END CURSOR FusionAccountSegments_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */
          --
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'ACCOUNT_SEGMENT_SEPARATION';
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'seperate_account_segments';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          vt_SegmentDelimiter             xxmx_gl_source_structures.source_segment_delimiter%TYPE;
          vn_SegmentStartPosition         NUMBER;
          vn_EndDelimiterPosition         NUMBER;
          vn_SegmentLength                NUMBER;
          vt_SegmentValue                 xxmx_gl_fusion_seg_defaults.fusion_segment_default_value%TYPE;
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
          e_ReturnStatus                  EXCEPTION;
          --
     --** END Declarations
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus := 'S';
          --
          /*
          ** Verify that the mandatory parameters have been passed.
          */
          --
          IF   pv_i_SourceOrFusionAccount   IS NULL
          OR   pt_i_LedgerName              IS NULL
          OR   pv_i_ConcatenatedAccountCode IS NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               pv_o_ReturnStatus  := 'E';
               --
               pv_o_ReturnMessage := 'All parameter values are mandatory in a call to the '
                                   ||gct_PackageName
                                   ||'.'
                                   ||ct_ProcOrFuncName
                                   ||'Procedure (the "pv_i_SourceOrFusionAccount" parameter must have a value of "SOURCE" or "FUSION").';
               --
               RAISE e_ReturnStatus;
               --
          ELSE
               --
               /*
               ** First we retrieve appropriate Segment Delimiter the from the relevant GL Utilities
               ** table dependant on the value of the "pv_i_SourceOrFusionAccount" parameter.
               **
               ** If the Ledger is not defined in the relevant table or the Segment Delimiter column
               ** is blank we can not do any further validations on the concatenated Account Code.
               **
               ** This should be handled as a fatal error because essential setup has not been
               ** performed in the GL Utilities table and so whatever process called this function
               ** should receive a raised exception.
               */
               --
               gvv_ProgressIndicator := '0030';
               --
               vt_SegmentDelimiter := NULL;
               --
               IF   pv_i_SourceOrFusionAccount IN (
                                                   'SOURCE'
                                                  ,'FUSION'
                                                  )
               THEN
                    --
                    BEGIN
                         --
                         IF   pv_i_SourceOrFusionAccount = 'SOURCE'
                         THEN
                              --
                              gvv_ProgressIndicator := '0040';
                              --
                              SELECT source_segment_delimiter
                              INTO   vt_SegmentDelimiter
                              FROM   xxmx_gl_source_structures
                              WHERE  1 = 1
                              AND    source_ledger_name = pt_i_LedgerName;
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0050';
                              --
                              SELECT fusion_segment_delimiter
                              INTO   vt_SegmentDelimiter
                              FROM   xxmx_gl_fusion_structures
                              WHERE  1 = 1
                              AND    fusion_ledger_name = pt_i_LedgerName;
                              --
                         END IF;
                         --
                         EXCEPTION
                              --
                              WHEN NO_DATA_FOUND
                              THEN
                                   --
                                   pv_o_ReturnStatus  := 'E';
                                   --
                                   pv_o_ReturnMessage := INITCAP(pv_i_SourceOrFusionAccount)
                                                       ||' Ledger "'
                                                       ||pt_i_LedgerName
                                                       ||'" could not be found in the "xxmx_gl_'
                                                       ||LOWER(pv_i_SourceOrFusionAccount)
                                                       ||'_structures" table.';
                                   --
                                   RAISE e_ReturnStatus;
                                   --
                              --** END NO_DATA_FOUND Exception
                              --
                              WHEN OTHERS
                              THEN
                                   --
                                   RAISE;
                                   --
                              --** END OTHERS Exception
                              --
                         --** END Exception Handler
                         --
                    END; --** Segment Delimiter retrieval block.
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0060';
                    --
                    pv_o_ReturnStatus  := 'E';
                    --
                    pv_o_ReturnMessage := 'The "pv_i_SourceOrFusionAccount" parameter must have a value of "SOURCE" or "FUSION".';
                    --
                    RAISE e_ReturnStatus;
                    --
               END IF; --** IF  pv_i_SourceOrFusionAccount IN ('SOURCE', 'FUSION')
               --
               /*
               ** Check if the Segment Delimiter column retrieved from the GL Utilities Structures
               ** table IS NULL.
               */
               --
               gvv_ProgressIndicator := '0070';
               --
               IF   vt_SegmentDelimiter IS NULL
               THEN
                    --
                    pv_o_ReturnStatus  := 'E';
                    --
                    pv_o_ReturnMessage := 'The "'
                                        ||LOWER(pv_i_SourceOrFusionAccount)
                                        ||'_segment_delimiter" column in the "xxmx_gl_'
                                        ||LOWER(pv_i_SourceOrFusionAccount)
                                        ||'_structures" table does not have a value for '
                                        ||INITCAP(pv_i_SourceOrFusionAccount)
                                        ||' Ledger "'
                                        ||pt_i_LedgerName
                                        ||'".';
                    --
                    RAISE e_ReturnStatus;
                    --
               END IF; --** IF  vt_SegmentDelimiter IS NULL
               --
               gvv_ProgressIndicator := '0080';
               --
               IF   pv_i_SourceOrFusionAccount = 'SOURCE'
               THEN
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    vn_SegmentStartPosition := 1;
                    --
                    FOR  SourceAccountSegment_rec
                    IN   SourceAccountSegments_cur
                              (
                               pt_i_LedgerName
                              )
                    LOOP
                         --
                         /*
                         ** Extract the Segment Value from the Concatenated Account Code.  This is done based on
                         ** using the value of the source_segment_num column which denotes segment order and position
                         ** in the concatenated string.
                         */
                         --
                         gvv_ProgressIndicator := '0100';
                         --
                         vn_EndDelimiterPosition := (INSTR(pv_i_ConcatenatedAccountCode, vt_SegmentDelimiter, 1, SourceAccountSegment_rec.source_segment_num));
                         --
                         /*
                         ** If the above INSTR returns 0 we have hit the last segment, so as there is no delimiter after it we
                         ** make the End Delimiter Position as the last character of the string + 1 (simulating a delimiter as
                         ** the last character).  This is so the length of the last segment is calculated correctly.
                         */
                         --
                         gvv_ProgressIndicator := '0110';
                         --
                         IF   vn_EndDelimiterPosition = 0
                         THEN
                              --
                              vn_EndDelimiterPosition := LENGTH(pv_i_ConcatenatedAccountCode) + 1;
                              --
                         END IF;
                         --
                         /*
                         ** The Segment Length should be calculated as the current End Delimiter Position
                         ** minus the Segment Start Position.
                         */
                         --
                         gvv_ProgressIndicator := '0120';
                         --
                         vn_SegmentLength := vn_EndDelimiterPosition - vn_SegmentStartPosition;
                         --
                         /*
                         ** Use the Segment Start Position and the Segment Length to extract the Segment Value.
                         */
                         --
                         gvv_ProgressIndicator := '0130';
                         --
                         vt_SegmentValue := SUBSTR(pv_i_ConcatenatedAccountCode, vn_SegmentStartPosition, vn_SegmentLength);
                         --
                         /*
                         ** Assign the Segment Value to the correct output variable.
                         */
                         --
                         gvv_ProgressIndicator := '0140';
                         --
                         CASE SourceAccountSegment_rec.source_segment_column
                              --
                              WHEN 'SEGMENT1'  THEN pt_o_Segment1  := vt_SegmentValue;
                              WHEN 'SEGMENT2'  THEN pt_o_Segment2  := vt_SegmentValue;
                              WHEN 'SEGMENT3'  THEN pt_o_Segment3  := vt_SegmentValue;
                              WHEN 'SEGMENT4'  THEN pt_o_Segment4  := vt_SegmentValue;
                              WHEN 'SEGMENT5'  THEN pt_o_Segment5  := vt_SegmentValue;
                              WHEN 'SEGMENT6'  THEN pt_o_Segment6  := vt_SegmentValue;
                              WHEN 'SEGMENT7'  THEN pt_o_Segment7  := vt_SegmentValue;
                              WHEN 'SEGMENT8'  THEN pt_o_Segment8  := vt_SegmentValue;
                              WHEN 'SEGMENT9'  THEN pt_o_Segment9  := vt_SegmentValue;
                              WHEN 'SEGMENT10' THEN pt_o_Segment10 := vt_SegmentValue;
                              WHEN 'SEGMENT11' THEN pt_o_Segment11 := vt_SegmentValue;
                              WHEN 'SEGMENT12' THEN pt_o_Segment12 := vt_SegmentValue;
                              WHEN 'SEGMENT13' THEN pt_o_Segment13 := vt_SegmentValue;
                              WHEN 'SEGMENT14' THEN pt_o_Segment14 := vt_SegmentValue;
                              WHEN 'SEGMENT15' THEN pt_o_Segment15 := vt_SegmentValue;
                              WHEN 'SEGMENT16' THEN pt_o_Segment16 := vt_SegmentValue;
                              WHEN 'SEGMENT17' THEN pt_o_Segment17 := vt_SegmentValue;
                              WHEN 'SEGMENT18' THEN pt_o_Segment18 := vt_SegmentValue;
                              WHEN 'SEGMENT19' THEN pt_o_Segment19 := vt_SegmentValue;
                              WHEN 'SEGMENT20' THEN pt_o_Segment20 := vt_SegmentValue;
                              WHEN 'SEGMENT21' THEN pt_o_Segment21 := vt_SegmentValue;
                              WHEN 'SEGMENT22' THEN pt_o_Segment22 := vt_SegmentValue;
                              WHEN 'SEGMENT23' THEN pt_o_Segment23 := vt_SegmentValue;
                              WHEN 'SEGMENT24' THEN pt_o_Segment24 := vt_SegmentValue;
                              WHEN 'SEGMENT25' THEN pt_o_Segment25 := vt_SegmentValue;
                              WHEN 'SEGMENT26' THEN pt_o_Segment26 := vt_SegmentValue;
                              WHEN 'SEGMENT27' THEN pt_o_Segment27 := vt_SegmentValue;
                              WHEN 'SEGMENT28' THEN pt_o_Segment28 := vt_SegmentValue;
                              WHEN 'SEGMENT29' THEN pt_o_Segment29 := vt_SegmentValue;
                              WHEN 'SEGMENT30' THEN pt_o_Segment30 := vt_SegmentValue;
                              --
                         END CASE;
                         --
                         /*
                         ** Set the next Segment Start Position as the current Segment's End Delimiter Position + 1
                         ** before restarting the loop.
                         */
                         --
                         vn_SegmentStartPosition := vn_EndDelimiterPosition + 1;
                         --
                    END LOOP;
                    --
               ELSIF pv_i_SourceOrFusionAccount = 'FUSION'
               THEN
                    --
                    gvv_ProgressIndicator := '0150';
                    --
                    vn_SegmentStartPosition := 1;
                    --
                    FOR  FusionAccountSegment_rec
                    IN   FusionAccountSegments_cur
                              (
                               pt_i_LedgerName
                              )
                    LOOP
                         --
                         /*
                         ** Extract the Segment Value from the Concatenated Account Code.  This is done based on
                         ** using the value of the fusion_segment_num column which denotes segment order and position
                         ** in the concatenated string.
                         */
                         --
                         gvv_ProgressIndicator := '0160';
                         --
                         vn_EndDelimiterPosition := (INSTR(pv_i_ConcatenatedAccountCode, vt_SegmentDelimiter, 1, FusionAccountSegment_rec.fusion_segment_num));
                         --
                         /*
                         ** If the above INSTR returns 0 we have hit the last segment, so as there is no delimiter after it we
                         ** make the End Delimiter Position as the last character of the string + 1 (simulating a delimiter as
                         ** the last character).  This is so the length of the last segment is calculated correctly.
                         */
                         --
                         gvv_ProgressIndicator := '0170';
                         --
                         IF   vn_EndDelimiterPosition = 0
                         THEN
                              --
                              vn_EndDelimiterPosition := LENGTH(pv_i_ConcatenatedAccountCode) + 1;
                              --
                         END IF;
                         --
                         /*
                         ** The Segment Length should be calculated as the current End Delimiter Position
                         ** minus the Segment Start Position.
                         */
                         --
                         gvv_ProgressIndicator := '0180';
                         --
                         vn_SegmentLength := vn_EndDelimiterPosition - vn_SegmentStartPosition;
                         --
                         /*
                         ** Use the Segment Start Position and the Segment Length to extract the Segment Value.
                         */
                         --
                         gvv_ProgressIndicator := '0190';
                         --
                         vt_SegmentValue := SUBSTR(pv_i_ConcatenatedAccountCode, vn_SegmentStartPosition, vn_SegmentLength);
                         --
                         /*
                         ** Assign the Segment Value to the correct output variable.
                         */
                         --
                         gvv_ProgressIndicator := '0200';
                         --
                         CASE FusionAccountSegment_rec.fusion_segment_column
                              --
                              WHEN 'SEGMENT1'  THEN pt_o_Segment1  := vt_SegmentValue;
                              WHEN 'SEGMENT2'  THEN pt_o_Segment2  := vt_SegmentValue;
                              WHEN 'SEGMENT3'  THEN pt_o_Segment3  := vt_SegmentValue;
                              WHEN 'SEGMENT4'  THEN pt_o_Segment4  := vt_SegmentValue;
                              WHEN 'SEGMENT5'  THEN pt_o_Segment5  := vt_SegmentValue;
                              WHEN 'SEGMENT6'  THEN pt_o_Segment6  := vt_SegmentValue;
                              WHEN 'SEGMENT7'  THEN pt_o_Segment7  := vt_SegmentValue;
                              WHEN 'SEGMENT8'  THEN pt_o_Segment8  := vt_SegmentValue;
                              WHEN 'SEGMENT9'  THEN pt_o_Segment9  := vt_SegmentValue;
                              WHEN 'SEGMENT10' THEN pt_o_Segment10 := vt_SegmentValue;
                              WHEN 'SEGMENT11' THEN pt_o_Segment11 := vt_SegmentValue;
                              WHEN 'SEGMENT12' THEN pt_o_Segment12 := vt_SegmentValue;
                              WHEN 'SEGMENT13' THEN pt_o_Segment13 := vt_SegmentValue;
                              WHEN 'SEGMENT14' THEN pt_o_Segment14 := vt_SegmentValue;
                              WHEN 'SEGMENT15' THEN pt_o_Segment15 := vt_SegmentValue;
                              WHEN 'SEGMENT16' THEN pt_o_Segment16 := vt_SegmentValue;
                              WHEN 'SEGMENT17' THEN pt_o_Segment17 := vt_SegmentValue;
                              WHEN 'SEGMENT18' THEN pt_o_Segment18 := vt_SegmentValue;
                              WHEN 'SEGMENT19' THEN pt_o_Segment19 := vt_SegmentValue;
                              WHEN 'SEGMENT20' THEN pt_o_Segment20 := vt_SegmentValue;
                              WHEN 'SEGMENT21' THEN pt_o_Segment21 := vt_SegmentValue;
                              WHEN 'SEGMENT22' THEN pt_o_Segment22 := vt_SegmentValue;
                              WHEN 'SEGMENT23' THEN pt_o_Segment23 := vt_SegmentValue;
                              WHEN 'SEGMENT24' THEN pt_o_Segment24 := vt_SegmentValue;
                              WHEN 'SEGMENT25' THEN pt_o_Segment25 := vt_SegmentValue;
                              WHEN 'SEGMENT26' THEN pt_o_Segment26 := vt_SegmentValue;
                              WHEN 'SEGMENT27' THEN pt_o_Segment27 := vt_SegmentValue;
                              WHEN 'SEGMENT28' THEN pt_o_Segment28 := vt_SegmentValue;
                              WHEN 'SEGMENT29' THEN pt_o_Segment29 := vt_SegmentValue;
                              WHEN 'SEGMENT30' THEN pt_o_Segment30 := vt_SegmentValue;
                              --
                         END CASE;
                         --
                         /*
                         ** Set the next Segment Start Position as the current Segment's End Delimiter Position + 1
                         ** before restarting the loop.
                         */
                         --
                         vn_SegmentStartPosition := vn_EndDelimiterPosition + 1;
                         --
                    END LOOP;
                    --
               END IF; --** IF  pv_i_SourceOrFusionAccount = 'SOURCE' or 'FUSION'
               --
          END IF; --** If any parameter values are missing
          --
          EXCEPTION
               --
               WHEN e_ReturnStatus
               THEN
                    --
                    NULL;
                    --
               --** END e_ModuleError Exception
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
                         ,pt_i_Phase             => gct_Phase
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
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
     END separate_account_segments;
     --
     --
END xxmx_gl_utilities_pkg;

/
