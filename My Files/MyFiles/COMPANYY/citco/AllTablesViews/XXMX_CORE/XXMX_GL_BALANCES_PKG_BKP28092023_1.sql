--------------------------------------------------------
--  DDL for Package Body XXMX_GL_BALANCES_PKG_BKP28092023
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_GL_BALANCES_PKG_BKP28092023" 
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Balance Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 27/02/2022     Prabhat Kumar Sahu        Initial version
-- 25/04/2022     Michal Arrowsmith         Changes to work with new version of MAXIMISE
-- 27/04/2022     Michal Arrowsmith         Changes to work with new version of MAXIMISE
-- ===========================================================================*/
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
     gct_OrigSystem                  CONSTANT VARCHAR2(10)                                  := 'ORACLER12';
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
     -- Global Variables for Exception Handlers 
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     --
     --Exception Declarations
     --
     e_moduleerror                             EXCEPTION;
     e_dateerror                               EXCEPTION;
     --
     -- Global Variables for Exception Handlers 
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     -- Global constants and variables for dynamic SQL usage 
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
     --** PROCEDURE: gl_opening_balances_stg
     --*****************************
     --
     --**
     --** Future Updates:
     --**   Pass Account Segment Delimiter as a Parameter determined from the Chart of Accounts Structure
     --**
     PROCEDURE gl_opening_balances_stg
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
          -- Cursor to get the opening GL balance
          --
          CURSOR GLBalances_cur
                      (
                       pv_LedgerName                   VARCHAR2
                      ,pv_country_code                 VARCHAR2
                      --,pv_ExtractYear                  VARCHAR2
                      ,pv_PeriodName                   VARCHAR2
                      ,pv_ou_name                      VARCHAR2
                      )
          IS
               --
               --
             SELECT  
                       'NEW'                                             fusion_status_code
                      ,gl.name                                           ledger_name
                      ,gl.ledger_id                                           ledger_id
                      ,(SELECT gp.end_date
                        FROM   gl_periods_extract gp
                        WHERE  gp.period_name = xbal.period_name
                        AND gp.period_set_name = gl.period_set_name)        accounting_date
                      ,(
                        SELECT parameter_value 
                        FROM   xxmx_core.xxmx_migration_parameters 
                        WHERE  application_suite = gct_ApplicationSuite
                        AND    application = gct_Application 
                        AND    business_entity = gct_BusinessEntity
                        AND    parameter_code='BATCH_SOURCE'
                       )                                                 user_je_source_name
                      ,(
                        SELECT parameter_value 
                        FROM   xxmx_core.xxmx_migration_parameters 
                        WHERE  application_suite = gct_ApplicationSuite
                        AND    application = gct_Application 
                        AND    business_entity = gct_BusinessEntity
                        AND    parameter_code='BATCH_CATEGORY_NAME'
                       )                                                 user_je_category_name
                      ,xbal.currency_code                                currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = xbal.period_name
--                        AND gp.period_set_name = gl.period_set_name)         date_created
                      ,(SELECT gp.end_date
                        FROM   gl_periods_extract gp
                        WHERE  gp.period_name = xbal.period_name
                        AND gp.period_set_name = gl.period_set_name)        date_created
                      ,'A'                                               actual_flag
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
--                      ,xbal.entered_dr                                   entered_dr
--                      ,xbal.entered_cr                                   entered_cr
                    , (case when xbal.entered_dr is null and xbal.entered_cr is null and accounted_dr is not null then
                      0
                      else 
                      xbal.entered_dr
                      end) entered_dr
                      ,(case when xbal.entered_dr is null and xbal.entered_cr is null and accounted_cr is not null then
                      0
                      else 
                      xbal.entered_cr
                      end)                                   entered_cr,
                      --,xbal.accounted_dr                                 accounted_dr
                     (case when xbal.accounted_dr is null and xbal.accounted_cr is null and xbal.entered_dr is not null then
                      0
                      when (entered_dr is not null and accounted_cr is not null) then
                      xbal.accounted_cr * -1
                      when (entered_cr is not null and accounted_dr is not null) then
                      null
                      else 
                      xbal.accounted_dr                                     
                      end)                                  accounted_dr
                      --,xbal.accounted_cr                                 accounted_cr
                      ,(case when xbal.accounted_dr is null and xbal.accounted_cr is null and xbal.entered_cr is not null then
                      0
                      when (entered_dr is not null and accounted_cr is not null) then
                      null
                      when (entered_cr is not null and accounted_dr is not null) then
                      xbal.accounted_dr * -1
                      else 
                      xbal.accounted_cr                                     
                      end)                                  accounted_cr
                      ,'ACTUAL BALANCE MIGRATION'
                     ||' '
                     ||xbal.period_name                                  reference1                        -- CV040 states this should be the Batch Name
                      ,''                                                reference2                        -- CV040 states this should be the Batch Description
                      ,''                                                reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
                      ,'ACTUAL BALANCE MIGRATION'                                                          
                     ||' '                                                                                 
                     ||xbal.period_name                                  reference4                      -- CV040 states this should be the Journal Entry Name
                      ,''                                                reference5                        -- CV040 states this should be the Journal Entry Description
                      ,''                                                reference6                        -- CV040 states this should be the Journal Entry Reference
                      ,''                                                reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
                      ,''                                                reference8                        -- CV040 states this should be the Journal entry Reversal Period
                      ,''                                                reference9                        -- CV040 states this should be the Journal Reversal Method
                      ,gcck.concatenated_segments                        reference10                       -- CV040 states this should be the Journal entry Line Description
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
-- MA 27/04/2022 no longer required
--                      ,''                                                average_journal_flag
                      ,''                                                originating_bal_seg_value
                      ,''                                                encumbrance_type_id
                      ,''                                                jgzz_recon_ref
--                      ,(case when xbal.period_name like 'ADJ%' then
--                        replace(xbal.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(xbal.period_name)
--                        end)                                  period_name
                    , initcap(xbal.period_name)   period_name
             FROM   gl_ledgers_extract                         gl,
                    xxmx_core.XXMX_GL_OPENING_BALANCE_V                  xbal,
                    gl_code_combinations_gcc_ext               gcc,
                    gl_code_combinations_extract           gcck
             WHERE  gl.name                                         = pv_LedgerName
--             and    gcc.segment1                                    = pv_country_code
--             AND    gl.period_set_name                              = 'CITCO MONTH'
             AND    xbal.ledger_id                                  = gl.ledger_id
             AND    xbal.period_name                                = pv_PeriodName
-- Added by MA 23/03/2022 to eliminate the zero lines
             and    ( nvl(xbal.entered_dr,0)!=0 or nvl(xbal.entered_cr,0)!=0 or nvl(xbal.accounted_dr,0)!=0 or nvl(xbal.accounted_cr,0)!=0)
--             AND    nvl(xbal.entered_dr,0)+nvl(xbal.entered_cr,0)   > 0
             AND    gcc.code_combination_id                         = xbal.code_combination_id
             AND    gcck.code_combination_id                        = gcc.code_combination_id;
--             AND    gcc.segment1 = substr(pv_ou_name,3);

          --
          -- Cursor to get the ledger names
          -- 
          CURSOR getLedger_cur
          IS          
          SELECT * 
          FROM   XXMX_CORE.XXMX_LEDGER_SCOPE_V;

          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE LedgerName_tt IS TABLE of XXMX_CORE.XXMX_LEDGER_SCOPE_V%ROWTYPE INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_opening_balances_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_opening_balances_stg';
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
          EmptyExtractYear_tbl            xxmx_utilities_pkg.g_ParamValueList_tt;
          ExtractYear_tbl                 xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyPeriodName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          PeriodName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          GLBalances_tbl                  gl_balances_tt;
          LedgerScope_tbl1                 LedgerName_tt;                 
          --
          vt_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'OPEN_BAL';
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
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
               ,pt_i_SubEntity        => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity        => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
               ,pt_i_MigrationSetID    => vt_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
                        ,pt_i_SubEntity         => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
        -- Retrieve Extract Years List
        --
       /*gvv_ProgressIndicator := '0050';
        --
        vt_ListParameterCode := 'YEAR';
        vn_ListValueCount    := 0;
        gvv_ReturnStatus     := '';
        gvt_ReturnMessage    := '';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'||vt_ListParameterCode||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
        ExtractYear_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                       (
                                        pt_i_ApplicationSuite => gct_ApplicationSuite
                                       ,pt_i_Application      => gct_Application
                                       ,pt_i_BusinessEntity   => gct_BusinessEntity
                                       ,pt_i_SubEntity        => 'OPENING BALANCES'
                                       ,pt_i_ParameterCode    => vt_ListParameterCode
                                       ,pn_o_ReturnCount      => vn_ListValueCount
                                       ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                       ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                       );
               --
        IF   gvv_ReturnStatus = 'F' THEN
            --
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
        IF   vn_ListValueCount = 0 THEN
                    --
                    vb_OkayToExtract := FALSE;
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
        END IF;*/
        --
        --
        -- Retrieve GL Period Name List
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        vt_ListParameterCode := 'PERIOD';
        vn_ListValueCount    := 0;
        gvv_ReturnStatus     := '';
        gvt_ReturnMessage    := '';
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                                      ,pt_i_SubEntity        => 'OPENING BALANCES'
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                      );
        --
        IF   gvv_ReturnStatus = 'F' THEN
            --
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
        IF   vn_ListValueCount = 0 THEN
            --
            vb_OkayToExtract := FALSE;
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
        --
        -- If there are no Extract Parameters in the "xxmx_migration_parameters" table
        -- (those which are there have to be enabled), no balances can be extracted.
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        IF   vb_OkayToExtract THEN
            --
            --
            -- The Extract Parameters were successfully retrieved so now
            -- initialize the detail record for the GL Balances.
            --
            xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
            --
            --  loop through the Ledger Name list and for each one:
            --
            -- a) Retrieve COA Structure Details pertaining to the Ledger.
            -- b) Extract the Balances for the Ledger.
            --
            gvv_ProgressIndicator := '0090';
            --
            FOR LedgerName_idx
            IN LedgerScope_tbl1.FIRST..LedgerScope_tbl1.LAST
            LOOP
                xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Ledger name.'
                                 ,pt_i_OracleError       => NULL
                                 );
                --
                -- Loop through Extract Years List
                --
              /*  FOR ExtractYear_idx
                IN ExtractYear_tbl.FIRST..ExtractYear_tbl.LAST
                LOOP
                    xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Year.'
                                 ,pt_i_OracleError       => NULL
                                 );*/
                    --
                    --
                    -- The following variable will be set to TRUE if any of the Period Names
                    -- in the Period Name Parameters list exist for the current Extract Year
                    -- Parameter.  If no Period Name Parameters match to the current Extract
                    -- Year Parameter this variable will remain FALSE.
                    --
                    -- This is so an INFORMATION log message can be issued if there are no
                    -- Period Name Parameters which match to the current Extract Year Parameter.
                    --
                    vb_PeriodAndYearMatch := FALSE;
                    --
                    --
                    -- Loop through GL Period Names List
                    --
                    --
                    FOR PeriodName_idx
                    IN PeriodName_tbl.FIRST..PeriodName_tbl.LAST
                    LOOP
                        xxmx_utilities_pkg.log_module_message
                                     (
                                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                     ,pt_i_Application       => gct_Application
                                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                     ,pt_i_SubEntity         => vt_SubEntity
                                     ,pt_i_MigrationSetID    => vt_MigrationSetID
                                     ,pt_i_Phase             => ct_Phase
                                     ,pt_i_Severity          => 'NOTIFICATION'
                                     ,pt_i_PackageName       => gcv_PackageName
                                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                     ,pt_i_ModuleMessage     => '    - Loop: Period Name '||PeriodName_tbl(PeriodName_idx)
                                     ,pt_i_OracleError       => NULL
                                     );
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
                        --
                        -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                        --
                        SELECT  COUNT(*)
                        INTO    gvn_ExistenceCount
                        FROM    gl_ledgers_extract  gl2
                                ,gl_periods_extract  gp
                        WHERE   1 = 1
                        AND     gl2.name           = LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                        AND     gp.period_set_name = gl2.period_set_name
                        --AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                        AND     gp.period_name     = PeriodName_tbl(PeriodName_idx);
                        --
                        IF   gvn_ExistenceCount = 0 THEN
                            xxmx_utilities_pkg.log_module_message
                                            (
                                             pt_i_ApplicationSuite  => gct_ApplicationSuite
                                            ,pt_i_Application       => gct_Application
                                            ,pt_i_BusinessEntity    => gct_BusinessEntity
                                            ,pt_i_SubEntity         => vt_SubEntity
                                            ,pt_i_MigrationSetID    => vt_MigrationSetID
                                            ,pt_i_Phase             => ct_Phase
                                            ,pt_i_Severity          => 'NOTIFICATION'
                                            ,pt_i_PackageName       => gcv_PackageName
                                            ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                            ,pt_i_ModuleMessage     => '      - No data found in EBS (source system) for Year/Period '
                                                                     --||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                     ||PeriodName_tbl(PeriodName_idx)||' Foe ledger '
                                                                     ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                            ,pt_i_OracleError       => NULL
                                            );
                        ELSE
                            --
                            --
                            -- Current Period Name Parameter exists in the GL_PERIODS table
                            -- for the current Source Ledger Name and Extract Year so the
                            -- Balances extract can proceed.
                            --
                            --
                            vb_PeriodAndYearMatch := TRUE;
                            --
                            xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => vt_SubEntity
                                             ,pt_i_MigrationSetID    => vt_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'
                                                                      ||gct_Application
                                                                      ||' '
                                                                      ||vt_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                      ||'", Period Name "'
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );
                            --
                            gvv_ProgressIndicator := '0140';
                            --
                            OPEN GLBalances_cur
                                (
                                                   LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                  ,LedgerScope_tbl1(LedgerName_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                                  ,PeriodName_tbl(PeriodName_idx)
                                                  ,LedgerScope_tbl1(LedgerName_idx).OPERATING_UNIT_NAME
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
                                xxmx_utilities_pkg.log_module_message
                                                (
                                                 pt_i_ApplicationSuite  => gct_ApplicationSuite
                                                ,pt_i_Application       => gct_Application
                                                ,pt_i_BusinessEntity    => gct_BusinessEntity
                                                ,pt_i_SubEntity         => vt_SubEntity
                                                ,pt_i_MigrationSetID    => vt_MigrationSetID
                                                ,pt_i_Phase             => ct_Phase
                                                ,pt_i_Severity          => 'NOTIFICATION'
                                                ,pt_i_PackageName       => gcv_PackageName
                                                ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                                ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                                ,pt_i_ModuleMessage     => '    - Record Count '||GLBalances_tbl.COUNT
                                                ,pt_i_OracleError       => NULL
                                                );
                                --
                                gvv_ProgressIndicator := '0160';
                                --
                                FORALL GLBalances_idx IN 1..GLBalances_tbl.COUNT
                                --
                                INSERT
                                INTO   xxmx_stg.xxmx_gl_opening_balances_stg
                                                              (
                                                               migration_set_id
                                                              ,group_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,fusion_status_code
                                                              ,ledger_name
                                                              ,ledger_id
                                                              ,accounting_date
                                                              ,user_je_source_name
                                                              ,user_je_category_name
                                                              ,currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                                              ,date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                                              ,originating_bal_seg_value
                                                              ,encumbrance_type_id
                                                              ,jgzz_recon_ref
                                                              ,period_name
                                                              )
                                                  VALUES
                                                              (
                                                               vt_MigrationSetID                                             -- migration_set_id
                                                              ,vt_MigrationSetID                                             -- group_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,GLBalances_tbl(GLBalances_idx).fusion_status_code             -- fusion_status_code
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_name                    -- ledger_name
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_id                        -- ledger_id
                                                              ,GLBalances_tbl(GLBalances_idx).accounting_date                -- accounting_date
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_source_name            -- user_je_source_name
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_category_name          -- user_je_category_name
                                                              ,GLBalances_tbl(GLBalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                                              ,GLBalances_tbl(GLBalances_idx).date_created    -- date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
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
                                        ,pt_i_SubEntity         => vt_SubEntity
                                        ,pt_i_MigrationSetID    => vt_MigrationSetID
                                        ,pt_i_Phase             => ct_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gcv_PackageName
                                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                 ||'" and the Period Set associated with Source Ledger Name "'
                                                                 ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                                 ||'".  No Balances were extracted for this year.'
                                        ,pt_i_OracleError       => NULL
                                        );
                            --
                        END IF; --** IF NOT vb_PeriodAndYearMatch
                        --
--                    END LOOP; --** ExtractYear_tbl LOOP
                    --
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                -- Update the migration details (Migration status will be automatically determined
                -- in the called procedure dependant on the Phase and if an Error Message has been
                -- passed).
                --
                gvv_ProgressIndicator := '0200';
                --
                --
                xxmx_utilities_pkg.upd_migration_details
                         (
                          pt_i_MigrationSetID          => vt_MigrationSetID
                         ,pt_i_BusinessEntity          => gct_BusinessEntity
                         ,pt_i_SubEntity               => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
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
          WHEN e_ModuleError THEN
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
     END gl_opening_balances_stg;
     --
     --************************************
     --** PROCEDURE: gl_summary_balances_stg
     --************************************
     --
     PROCEDURE gl_summary_balances_stg
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
          -- Cursor to get the summary GL balance
          --
          CURSOR GLBalances_cur
                      (
                       pv_LedgerName                   VARCHAR2
                      ,pv_country_code                 VARCHAR2
                     -- ,pv_ExtractYear                  VARCHAR2
                      ,pv_PeriodName                   VARCHAR2
                      ,pv_ou_name                      VARCHAR2
                      )
          IS
             SELECT  
                       'NEW'                                             fusion_status_code
                      ,gl.name                                           ledger_name
                      ,gl.ledger_id                                      ledger_id
                      ,(SELECT gp.end_date
                        FROM   gl_periods_extract gp
                        WHERE  gp.period_name = xbal.period_name
                        AND gp.period_set_name = gl.period_set_name)         accounting_date
                      ,(
                        SELECT parameter_value 
                        FROM   xxmx_core.xxmx_migration_parameters 
                        WHERE  --application = gct_ApplicationSuite -- commented by Somya on 08-Apr-22
                        application_suite = gct_ApplicationSuite -- Added by Somya on 08-Apr-22
                        AND    business_entity = gct_BusinessEntity
                        --AND    parameter_code='batch_source' -- commented by Somya on 08-Apr-22
                        AND    parameter_code='BATCH_SOURCE' -- added by Somya on 08-Apr-22
                       )                                                 user_je_source_name
                      ,(
                        SELECT parameter_value 
                        FROM   xxmx_core.xxmx_migration_parameters 
                        WHERE  --application = gct_ApplicationSuite -- commented by Somya on 08-Apr-22
                        application_suite = gct_ApplicationSuite -- Added by Somya on 08-Apr-22
                        AND    business_entity = gct_BusinessEntity
                        AND    parameter_code='BATCH_CATEGORY_NAME'
                       )                                                 user_je_category_name
                      ,xbal.currency_code                                currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = xbal.period_name
--                        AND gp.period_set_name = gl.period_set_name)         date_created
                      ,(SELECT gp.end_date
                        FROM   gl_periods_extract gp
                        WHERE  gp.period_name = xbal.period_name
                        AND gp.period_set_name = gl.period_set_name)        date_created
                      ,'A'                                               actual_flag
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
                      --                      ,xbal.entered_dr                                   entered_dr
--                      ,xbal.entered_cr                                   entered_cr
                    , (case when xbal.entered_dr is null and xbal.entered_cr is null and accounted_dr is not null then
                      0
                      else 
                      xbal.entered_dr
                      end) entered_dr
                      ,(case when xbal.entered_dr is null and xbal.entered_cr is null and accounted_cr is not null then
                      0
                      else 
                      xbal.entered_cr
                      end)                                   entered_cr
                      --,xbal.accounted_dr                                 accounted_dr
                     , (case when xbal.accounted_dr is null and xbal.accounted_cr is null and xbal.entered_dr is not null then
                      0
                      when (entered_dr is not null and accounted_cr is not null) then
                      xbal.accounted_cr * -1
                      when (entered_cr is not null and accounted_dr is not null) then
                      null
                      else 
                      xbal.accounted_dr                                     
                      end)                                  accounted_dr
                      --,xbal.accounted_cr                                 accounted_cr
                      ,(case when xbal.accounted_dr is null and xbal.accounted_cr is null and xbal.entered_cr is not null then
                      0
                      when (entered_dr is not null and accounted_cr is not null) then
                      null
                      when (entered_cr is not null and accounted_dr is not null) then
                      xbal.accounted_dr * -1
                      else 
                      xbal.accounted_cr                                     
                      end)                                  accounted_cr
                      ,'ACTUAL BALANCE MIGRATION'
                     ||' '
                     ||xbal.period_name                                  reference1                        -- CV040 states this should be the Batch Name
                      ,''                                                reference2                        -- CV040 states this should be the Batch Description
                      ,''                                                reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
                      ,'ACTUAL BALANCE MIGRATION'                                                          
                     ||' '                                                                                 
                     ||xbal.period_name                                  reference4                      -- CV040 states this should be the Journal Entry Name
                      ,''                                                reference5                        -- CV040 states this should be the Journal Entry Description
                      ,''                                                reference6                        -- CV040 states this should be the Journal Entry Reference
                      ,''                                                reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
                      ,''                                                reference8                        -- CV040 states this should be the Journal entry Reversal Period
                      ,''                                                reference9                        -- CV040 states this should be the Journal Reversal Method
                      ,gcck.concatenated_segments                        reference10                       -- CV040 states this should be the Journal entry Line Description
                      ,''                                                stat_amount
                      ,''                                                user_currency_conversion_type
                      --,gjh.currency_conversion_date                      currency_conversion_date
                      ,''                                                currency_conversion_date
                      ,''                                                currency_conversion_rate
                      ,''                                                attribute_category
                      --,gcck.concatenated_segments                        attribute1 -- commented by Somya on 11-apr-22
                      ,''                                               attribute1 -- added by Somya on 11-apr-22
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
-- MA 27/04/2022 no longer required
--                      ,''                                                average_journal_flag
                      ,''                                                originating_bal_seg_value
                      ,''                                                encumbrance_type_id
                      ,''                                                jgzz_recon_ref
--                      ,(case when xbal.period_name like 'ADJ%' then
--                        replace(xbal.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(xbal.period_name)
--                        end)                                  period_name
                    , initcap(xbal.period_name) period_name
             FROM   gl_ledgers_extract                         gl,
                    XXMX_GL_BALANCE_SUMMARY_V                              xbal,
                    GL_CODE_COMBINATIONS_GCC_EXT               gcc,
                    gl_code_combinations_extract           gcck
             WHERE  gl.name                                         = pv_LedgerName
--             and    gcc.segment1                                    = pv_country_code
--             AND    gl.period_set_name                              = 'CITCO MONTH'
             AND    xbal.ledger_id                                  = gl.ledger_id
             AND    xbal.period_name                                = pv_PeriodName
-- Added by MA 14/03/2022 to eliminate the zero lines
             and    ( nvl(xbal.entered_dr,0)!=0 or nvl(xbal.entered_cr,0)!=0 or nvl(xbal.accounted_dr,0)!=0 or nvl(xbal.accounted_cr,0)!=0)
             AND    gcc.code_combination_id                         = xbal.code_combination_id
             AND    gcck.code_combination_id                        = gcc.code_combination_id
--             AND    gcc.segment1 = substr(pv_ou_name,3)
             ;
          --
          -- Cursor to get the ledger names
          -- 
          CURSOR getLedger_cur
          IS          
          SELECT * 
          FROM   XXMX_CORE.XXMX_LEDGER_SCOPE_V;
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE LedgerName_tt IS TABLE of XXMX_CORE.XXMX_LEDGER_SCOPE_V%ROWTYPE INDEX BY BINARY_INTEGER;
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
          vt_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE   := 'SUMM_BAL';
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_summary_balances_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_summary_balances_stg';
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
          EmptyExtractYear_tbl            xxmx_utilities_pkg.g_ParamValueList_tt;
          ExtractYear_tbl                 xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyPeriodName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          PeriodName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          GLBalances_tbl                  gl_balances_tt;
          LedgerScope_tbl1                 LedgerName_tt; 
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
               ,pt_i_SubEntity        => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity        => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
               ,pt_i_MigrationSetID    => vt_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
    );
    --
    gvv_ProgressIndicator := '0040';
    --
    -- If the Migration Set ID is NULL then the Migration has not been initialized.
    --
    IF   vt_MigrationSetID IS NOT NULL THEN
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
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
                        ,pt_i_SubEntity         => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               -- Retrieve Extract Years List
               --
              /* gvv_ProgressIndicator := '0050';
               --
               vt_ListParameterCode := 'YEAR';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'||vt_ListParameterCode||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               ExtractYear_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                       (
                                        pt_i_ApplicationSuite => gct_ApplicationSuite
                                       ,pt_i_Application      => gct_Application
                                       ,pt_i_BusinessEntity   => gct_BusinessEntity
                                       ,pt_i_SubEntity        => 'SUMMARY BALANCES'
                                       ,pt_i_ParameterCode    => vt_ListParameterCode
                                       ,pn_o_ReturnCount      => vn_ListValueCount
                                       ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                       ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                       );
               --
               IF   gvv_ReturnStatus = 'F' THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - '||vn_ListValueCount||' values for "'||vt_ListParameterCode||'" List retrieved.'
                         ,pt_i_OracleError         => NULL
                         );
                    --
               END IF;
               --
               IF   vn_ListValueCount = 0 THEN
                    --
                    vb_OkayToExtract := FALSE;
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
               END IF;*/
               --
               /*
               ** Retrieve GL Period Name List
               */
               --
               gvv_ProgressIndicator := '0060';
               --
               vt_ListParameterCode := 'PERIOD';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'||vt_ListParameterCode||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               PeriodName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => 'SUMMARY BALANCES'
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                      );
               --
               IF   gvv_ReturnStatus = 'F' THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               ELSE
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               IF   vn_ListValueCount = 0 THEN
                    --
                    vb_OkayToExtract := FALSE;
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
               gvv_ProgressIndicator := '0070';
               --
               IF   vb_OkayToExtract THEN
                    --
                    -- The Extract Parameters were successfully retrieved so now
                    -- initialize the detail record for the GL Balances.
                    --
                    xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --  loop through the Ledger Name list and for each one:
                    --
                    -- a) Retrieve COA Structure Details pertaining to the Ledger.
                    -- b) Extract the Balances for the Ledger.
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    FOR LedgerName_idx
                      IN LedgerScope_tbl1.FIRST..LedgerScope_tbl1.LAST
                      LOOP
                          xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Ledger name.'
                                 ,pt_i_OracleError       => NULL
                                 );
                         --
                         -- Loop through Extract Years List
                         --
                       /*  FOR ExtractYear_idx
                           IN ExtractYear_tbl.FIRST..ExtractYear_tbl.LAST
                           LOOP
                               xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Year.'
                                 ,pt_i_OracleError       => NULL
                                 );*/
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
                              FOR PeriodName_idx
                                IN PeriodName_tbl.FIRST..PeriodName_tbl.LAST
                                LOOP
                                   xxmx_utilities_pkg.log_module_message
                                     (
                                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                     ,pt_i_Application       => gct_Application
                                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                     ,pt_i_SubEntity         => vt_SubEntity
                                     ,pt_i_MigrationSetID    => vt_MigrationSetID
                                     ,pt_i_Phase             => ct_Phase
                                     ,pt_i_Severity          => 'NOTIFICATION'
                                     ,pt_i_PackageName       => gcv_PackageName
                                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                     ,pt_i_ModuleMessage     => '    - Loop: Period Name '||PeriodName_tbl(PeriodName_idx)
                                     ,pt_i_OracleError       => NULL
                                     );
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
                                   --
                                   -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                                   --
                                   SELECT  COUNT(*)
                                   INTO    gvn_ExistenceCount
                                   FROM    gl_ledgers_extract  gl2
                                          ,gl_periods_extract  gp
                                   WHERE   1 = 1
                                   AND     gl2.name           = LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                   AND     gp.period_set_name = gl2.period_set_name
--                                   AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                                   AND     gp.period_name     = PeriodName_tbl(PeriodName_idx);
                                   --
                                   IF   gvn_ExistenceCount = 0 THEN
                                       xxmx_utilities_pkg.log_module_message
                                            (
                                             pt_i_ApplicationSuite  => gct_ApplicationSuite
                                            ,pt_i_Application       => gct_Application
                                            ,pt_i_BusinessEntity    => gct_BusinessEntity
                                            ,pt_i_SubEntity         => vt_SubEntity
                                            ,pt_i_MigrationSetID    => vt_MigrationSetID
                                            ,pt_i_Phase             => ct_Phase
                                            ,pt_i_Severity          => 'NOTIFICATION'
                                            ,pt_i_PackageName       => gcv_PackageName
                                            ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                            ,pt_i_ModuleMessage     => '      - No data found in EBS (source system) for Year/Period '
--                                                                     ||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                     ||PeriodName_tbl(PeriodName_idx)||' Foe ledger '
                                                                     ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                            ,pt_i_OracleError       => NULL
                                            );
                                   ELSE
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
                                             ,pt_i_SubEntity         => vt_SubEntity
                                             ,pt_i_MigrationSetID    => vt_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'
                                                                      ||gct_Application
                                                                      ||' '
                                                                      ||vt_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                      ||'", Period Name "'
                                                                      --||PeriodName_tbl(PeriodName_idx)
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      ||'".'
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                        --
                                        gvv_ProgressIndicator := '0140';
                                        --
                                        OPEN GLBalances_cur
                                                  (
                                                   LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                  ,LedgerScope_tbl1(LedgerName_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                                  --,PeriodName_tbl(PeriodName_idx),
                                                  ,PeriodName_tbl(PeriodName_idx)
                                                  ,LedgerScope_tbl1(LedgerName_idx).OPERATING_UNIT_NAME
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
                                                  INTO   xxmx_stg.xxmx_gl_summary_balances_stg
                                                              (
                                                               migration_set_id
                                                              ,group_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,fusion_status_code
                                                              ,ledger_name
                                                              ,ledger_id
                                                              ,accounting_date
                                                              ,user_je_source_name
                                                              ,user_je_category_name
                                                              ,currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                                              ,date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                                              ,originating_bal_seg_value
                                                              ,encumbrance_type_id
                                                              ,jgzz_recon_ref
                                                              ,period_name
                                                              )
                                                  VALUES
                                                              (
                                                               vt_MigrationSetID                                             -- migration_set_id
                                                              ,vt_MigrationSetID                                             -- group_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,GLBalances_tbl(GLBalances_idx).fusion_status_code             -- fusion_status_code
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_name                    -- ledger_name
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_id                      --ledger_id
                                                              ,GLBalances_tbl(GLBalances_idx).accounting_date                -- accounting_date
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_source_name            -- user_je_source_name
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_category_name          -- user_je_category_name
                                                              ,GLBalances_tbl(GLBalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                                              ,GLBalances_tbl(GLBalances_idx).date_created    -- date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
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
                                        ,pt_i_SubEntity         => vt_SubEntity
                                        ,pt_i_MigrationSetID    => vt_MigrationSetID
                                        ,pt_i_Phase             => ct_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gcv_PackageName
                                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                 ||'" and the Period Set associated with Source Ledger Name "'
                                                                 ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                                 ||'".  No Balances were extracted for this year.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF NOT vb_PeriodAndYearMatch
                              --
--                         END LOOP; --** ExtractYear_tbl LOOP
                         --
                    END LOOP; --** Ledger details LOOP
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity               => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
     END gl_summary_balances_stg;
     --
     --************************************
     --** PROCEDURE: gl_detail_balances_stg
     --************************************
     --
     PROCEDURE gl_detail_balances_stg
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
          -- Cursor to get the detail GL balance
          --
          CURSOR GLBalances_cur
                      (
                       pv_LedgerName                   VARCHAR2
                      ,pv_country_code                 VARCHAR2
--                      ,pv_ExtractYear                  VARCHAR2
                      ,pv_PeriodName                   VARCHAR2
                      ,pv_ou_name                      VARCHAR2
                      )
          IS
               --
               --
             SELECT  
                       'NEW'                                             fusion_status_code
                      ,gl.name                                           ledger_name
                      ,gl.ledger_id                                      ledger_id
--                      ,(SELECT gp.end_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = gjh.period_name
--                          AND gp.period_set_name = gl.period_set_name)        accounting_date
                    , gjh.default_effective_date accounting_date
                      ,gjst.user_je_source_name                        user_je_source_name
                      ,gjct.user_je_category_name                       user_je_category_name
                      ,gjh.currency_code                                currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = gjh.period_name
--                        AND gp.period_set_name = gl.period_set_name)     date_created
                    , gjh.date_created date_created
                      ,'A'                                               actual_flag
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
                      ,gjl.entered_dr                                    entered_dr
                      ,gjl.entered_cr                                    entered_cr
                      ,gjl.accounted_dr                                  accounted_dr
                      ,gjl.accounted_cr                                  accounted_cr
--                      ,'ACTUAL BALANCE MIGRATION'
--                     ||' '
--                     ||gjh.period_name                                  reference1                        -- CV040 states this should be the Batch Name
                     , gjb.name                                        reference1 -- added by Somya on 11-apr-2022 
                      --,''                                                reference2                        -- CV040 states this should be the Batch Description
                      , gjb.description                                 reference2 -- added by Somya on 11-apr-2022
                      ,''                                                reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
--                      ,'ACTUAL BALANCE MIGRATION'                                                          
--                     ||' '                                                                                 
--                     ||gjh.period_name                                   reference4                      -- CV040 states this should be the Journal Entry Name
                      , gjh.name                                          reference4 -- added by Somya on 11-apr-2022
                      ,gjh.description                                   reference5                        -- CV040 states this should be the Journal Entry Description
                      ,gjh.external_reference                            reference6                        -- CV040 states this should be the Journal Entry Reference
                      --,gjh.accrual_rev_flag                              reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
                      --,gjh.accrual_rev_period_name                       reference8                        -- CV040 states this should be the Journal entry Reversal Period
                      --,gjh.accrual_rev_change_sign_flag                  reference9                        -- CV040 states this should be the Journal Reversal Method
                      ,case 
                      when gjh.period_name=(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND gjh.ACCRUAL_REV_PERIOD_NAME is not null and gjh.ACCRUAL_REV_STATUS is  null
                      AND gjh.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND gjh.accrual_rev_flag='Y' and gjh.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing')

                      THEN 
                      gjh.ACCRUAL_REV_FLAG
                      when gjh.parent_je_header_id is not null and gjh.ACCRUAL_REV_FLAG='Y' and gjh.ACCRUAL_REV_PERIOD_NAME is null --and gl.name='India Local' 
                      and exists (select 1 from 
                                            (select period_name,ACCRUAL_REV_PERIOD_NAME,ACCRUAL_REV_STATUS, accrual_rev_flag ,je_category 
                                            from gl_je_headers_extract gjh1 where gjh1.je_header_id=gjh.parent_je_header_id) a
                      where a.period_name =(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND a.ACCRUAL_REV_PERIOD_NAME is not null and a.ACCRUAL_REV_STATUS is  null
                      AND a.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND a.accrual_rev_flag='Y' and a.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing'))
                      THEN
                      (select accrual_rev_flag  
                                            from gl_je_headers_extract gjh1 where gjh1.je_header_id=gjh.parent_je_header_id)
                      else 
                      NULL
                      end reference7
                      ,case 
                      when gjh.period_name=(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND gjh.ACCRUAL_REV_PERIOD_NAME is not null and gjh.ACCRUAL_REV_STATUS is  null
                      AND gjh.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND gjh.accrual_rev_flag='Y' and gjh.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing')

                      THEN 
                      initcap(gjh.ACCRUAL_REV_PERIOD_NAME)

                      when gjh.parent_je_header_id is not null and gjh.ACCRUAL_REV_FLAG='Y' and gjh.ACCRUAL_REV_PERIOD_NAME is null--and gl.name='India Local' 
                      and exists (select 1 from 
                                            (select period_name,ACCRUAL_REV_PERIOD_NAME,ACCRUAL_REV_STATUS, accrual_rev_flag ,je_category 
                                            from gl_je_headers_extract gjh1 where gjh1.je_header_id=gjh.parent_je_header_id) a
                      where a.period_name =(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND a.ACCRUAL_REV_PERIOD_NAME is not null and a.ACCRUAL_REV_STATUS is  null
                      AND a.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND a.accrual_rev_flag='Y' and a.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing'))
                      THEN
                      (select initcap(ACCRUAL_REV_PERIOD_NAME)  
                                            from gl_je_headers_extract gjh1 where gjh1.je_header_id=gjh.parent_je_header_id)
                      else 
                      NULL
                      end reference8
                      ,case 
                      when gjh.period_name=(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND gjh.ACCRUAL_REV_PERIOD_NAME is not null and gjh.ACCRUAL_REV_STATUS is  null
                      AND gjh.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND gjh.accrual_rev_flag='Y' and gjh.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing')

                      THEN 
                      'N'
                      when gjh.parent_je_header_id is not null and gjh.ACCRUAL_REV_FLAG='Y' and gjh.ACCRUAL_REV_PERIOD_NAME is null --and gl.name='India Local' 
                      and exists (select 1 from 
                                            (select period_name,ACCRUAL_REV_PERIOD_NAME,ACCRUAL_REV_STATUS, accrual_rev_flag ,je_category 
                                            from gl_je_headers_extract gjh1 where gjh1.je_header_id=gjh.parent_je_header_id) a
                      where a.period_name =(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y')
                       AND a.ACCRUAL_REV_PERIOD_NAME is not null and a.ACCRUAL_REV_STATUS is  null
                      AND a.ACCRUAL_REV_PERIOD_NAME<>(SELECT PARAMETER_VALUE 
                      FROM XXMX_MIGRATION_PARAMETERS 
                      where SUB_ENTITY='DETAILED BALANCES' and PARAMETER_CODE='LAST_PERIOD_FLAG' and enabled_flag='Y') 
                      AND a.accrual_rev_flag='Y' and a.je_category in ('Accrual', 'Rebook','Revaluation','T24 Reversing','Bank YTD Reversing'))
                      THEN
                      'N'
                      else 
                      NULL
                      end reference9
                      ,gjl.description                                   reference10                       -- CV040 states this should be the Journal entry Line Description
                      ,gjl.stat_amount                                                stat_amount
--                      ,gjh.currency_conversion_type                      user_currency_conversion_type
                  --    ,gldct.user_conversion_type                        user_currency_conversion_type    --commented by Laxmikanth 
				  ,decode(gldct.user_conversion_type,null,null,'User')   user_currency_conversion_type
                      --,gjh.currency_conversion_date                    currency_conversion_date
                    --  ,gjh.currency_conversion_date                      currency_conversion_date		--commented by Laxmikanth 
					,decode(gjh.currency_conversion_rate ,null,null,gjh.currency_conversion_date) currency_conversion_date
                      ,gjh.currency_conversion_rate                      currency_conversion_rate
                     /* ,gjl.context                                       attribute_category
                      --,gcc.concatenated_segments                         attribute1 --commented by Somya on 11-apr-22
                      ,''                                                attribute1 -- added by Somya on 11-Apr-22
                      ,gjl.attribute2                                    attribute2
                      ,gjl.attribute3                                    attribute3
                      ,gjl.attribute4                                    attribute4
                      ,gjl.attribute5                                    attribute5
                      ,gjl.attribute6                                    attribute6
                      ,gjl.attribute7                                    attribute7
                      ,gjl.attribute8                                    attribute8
                      ,gjl.attribute9                                    attribute9
                      ,gjl.attribute10                                   attribute10
                      ,gjl.attribute11                                   attribute11
                      ,gjl.attribute12                                   attribute12
                      --,gjl.attribute13                                   attribute13 -- commented by Somya on 13-May-22
                      ,NULL                                               attribute13 -- added by Somya on 13-May-22
                      ,gjl.attribute14                                   attribute14
                      ,gjl.attribute15                                   attribute15
                      --,gjl.attribute16                                   attribute16 -- commented by Somya on 13-May-22
                      ,NULL                                              attribute16 -- added by Somya on 13-May-22
                      ,gjl.attribute17                                   attribute17
                      ,gjl.attribute18                                   attribute18
                      ,gjl.attribute19                                   attribute19
                      ,gjl.attribute20                                   attribute20
                      ,gjl.context3                                      attribute_category3*/

                      ----------
                      ,NULL                                  attribute_category
                      ,NULL                                   attribute1 -- added by Somya on 11-Apr-22
                      ,NULL                                   attribute2
                      ,NULL                                   attribute3
                      ,NULL                                   attribute4
                      ,NULL                                   attribute5
                      ,NULL                                   attribute6
                      ,NULL                                   attribute7
                      ,NULL                                   attribute8
                      ,NULL                                   attribute9
                      ,NULL                                   attribute10
                      ,NULL                                   attribute11
                      ,NULL                                   attribute12
                      ,NULL                                   attribute13 -- added by Somya on 13-May-22
                      ,NULL                                   attribute14
                      ,NULL                                   attribute15
                      ,NULL                                   attribute16 -- added by Somya on 13-May-22
                      ,NULL                                   attribute17
                      ,NULL                                   attribute18
                      ,NULL                                   attribute19
                      ,NULL                                   attribute20
                      ,NULL                                   attribute_category3
                      -----------

-- MA 27/04/2022 no longer required
--                      ,gjb.average_journal_flag                          average_journal_flag
                      ,gjh.originating_bal_seg_value                     originating_bal_seg_value
                      ,''                                                encumbrance_type_id
                      ,''                                                jgzz_recon_ref
--                      ,(case when gjh.period_name like 'ADJ%' then
--                        replace(gjh.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(gjh.period_name)
--                        end)                                   period_name,
                        , initcap(gjh.period_name) period_name ,
                        gjh.je_header_id||'_'||gjl.je_line_num header_line, -- added by Somya on 20-Jul-22
                        gcc.concatenated_segments old_ccid -- added by Somya on 20-Jul-22
             FROM
                    gl_je_sources_tl_ext                 gjst,
                    gl_je_categories_tl_ext              gjct,
                    gl_ledgers_extract                       gl,
                    gl_je_headers_extract                    gjh,
                    gl_je_lines_extract                      gjl,
                    gl_je_batches_extract                    gjb,
                    gl_code_combinations_extract                      gcc,
                    gl_daily_conversion_types_ext        gldct
             where   gl.name                                         = pv_LedgerName
--             and    gcc.segment1                                    = pv_country_code
--             AND     gl.period_set_name                              = 'CITCO MONTH'
             AND     gjh.ledger_id                                   = gl.ledger_id
             AND     gjh.period_name                                 = pv_PeriodName
             AND     gjh.actual_flag                                 = 'A'
             AND     gjl.je_header_id                                = gjh.je_header_id
             AND     gjb.je_batch_id                                 = gjh.je_batch_id
             AND     gjl.code_combination_id                         = gcc.code_combination_id
             AND     gjh.je_source                                   = gjst.je_source_name
             AND     gjh.je_category                                 = gjct.je_category_name
             AND     gjl.status                                      = 'P'
             AND     gldct.conversion_type                           = gjh.currency_conversion_type
          ;

          --
          -- Cursor to get the ledger names
          -- 
          CURSOR getLedger_cur
          IS          
          SELECT * 
          FROM   XXMX_CORE.XXMX_LEDGER_SCOPE_V;

          --** END CURSOR **          
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE LedgerName_tt IS TABLE of XXMX_CORE.XXMX_LEDGER_SCOPE_V%ROWTYPE
          INDEX BY BINARY_INTEGER;
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'gl_detail_balances_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_detail_balances_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'DETAIL_BAL';
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
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
          EmptyExtractYear_tbl            xxmx_utilities_pkg.g_ParamValueList_tt;
          ExtractYear_tbl                 xxmx_utilities_pkg.g_ParamValueList_tt;
          EmptyPeriodName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          PeriodName_tbl                  xxmx_utilities_pkg.g_ParamValueList_tt;
          GLBalances_tbl                  gl_balances_tt;
          LedgerScope_tbl1                 LedgerName_tt; 
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
    --
    IF   gvv_ReturnStatus = 'F'
    THEN
        --
        xxmx_utilities_pkg.log_module_message
        (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity        => vt_SubEntity
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
                    ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
               ,pt_i_MigrationSetID    => vt_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          -- If the Migration Set ID is NULL then the Migration has not been initialized.
          --
          IF   vt_MigrationSetID IS NOT NULL THEN
               --
               -- The Migration Set has been initialized so not retrieve the parameters for extracting GL Balances:
               --
               -- Retrieve GL Ledger Names List
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
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
                        ,pt_i_SubEntity         => vt_SubEntity
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
                    ,pt_i_SubEntity         => 'DETAILED BALANCES'
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
               --
               -- Retrieve Extract Years List
               --
              /* gvv_ProgressIndicator := '0050';
               --
               vt_ListParameterCode := 'YEAR';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                                       ,pt_i_SubEntity        => 'DETAILED BALANCES'
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               IF   vn_ListValueCount = 0 THEN
                    --
                    vb_OkayToExtract := FALSE;
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
               END IF;*/
               --
               /*
               ** Retrieve GL Period Name List
               */
               --
               gvv_ProgressIndicator := '0060';
               --
               vt_ListParameterCode := 'PERIOD';
               vn_ListValueCount    := 0;
               gvv_ReturnStatus     := '';
               gvt_ReturnMessage    := '';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => vt_SubEntity
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Retrieving "'||vt_ListParameterCode||'" List from Migration Parameters table:'
                    ,pt_i_OracleError       => NULL
                    );
               --
               PeriodName_tbl := xxmx_utilities_pkg.get_parameter_value_list
                                      (
                                       pt_i_ApplicationSuite => gct_ApplicationSuite
                                      ,pt_i_Application      => gct_Application
                                      ,pt_i_BusinessEntity   => gct_BusinessEntity
                                      ,pt_i_SubEntity        => 'DETAILED BALANCES'
                                      ,pt_i_ParameterCode    => vt_ListParameterCode
                                      ,pn_o_ReturnCount      => vn_ListValueCount
                                      ,pv_o_ReturnStatus     => gvv_ReturnStatus
                                      ,pv_o_ReturnMessage    => gvt_ReturnMessage
                                      );
               --
               IF   gvv_ReturnStatus = 'F' THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
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
               IF   vn_ListValueCount = 0 THEN
                    --
                    vb_OkayToExtract := FALSE;
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => vt_SubEntity
                         ,pt_i_MigrationSetID      => vt_MigrationSetID
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
               gvv_ProgressIndicator := '0070';
               --
               IF   vb_OkayToExtract THEN
                    --
                    --
                    -- The Extract Parameters were successfully retrieved so now
                    -- initialize the detail record for the GL Balances.
                    --
                    xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --
                    --  loop through the Ledger Name list and for each one:
                    --
                    -- a) Retrieve COA Structure Details pertaining to the Ledger.
                    -- b) Extract the Balances for the Ledger.
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    FOR LedgerName_idx
                      IN LedgerScope_tbl1.FIRST..LedgerScope_tbl1.LAST
                      LOOP
                          xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Ledger name.'
                                 ,pt_i_OracleError       => NULL
                                 );
                         --
                         -- Loop through Extract Years List
                         --
                        /* FOR ExtractYear_idx
                           IN ExtractYear_tbl.FIRST..ExtractYear_tbl.LAST
                           LOOP
                               xxmx_utilities_pkg.log_module_message
                                 (
                                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                                 ,pt_i_Application       => gct_Application
                                 ,pt_i_BusinessEntity    => gct_BusinessEntity
                                 ,pt_i_SubEntity         => vt_SubEntity
                                 ,pt_i_MigrationSetID    => vt_MigrationSetID
                                 ,pt_i_Phase             => ct_Phase
                                 ,pt_i_Severity          => 'NOTIFICATION'
                                 ,pt_i_PackageName       => gcv_PackageName
                                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage     => '    - Loop: Year.'
                                 ,pt_i_OracleError       => NULL
                                 );*/
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
                              -- Loop through GL Period Names List
                              --
                              FOR PeriodName_idx
                                IN PeriodName_tbl.FIRST..PeriodName_tbl.LAST
                                LOOP
                                   xxmx_utilities_pkg.log_module_message
                                     (
                                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                                     ,pt_i_Application       => gct_Application
                                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                                     ,pt_i_SubEntity         => vt_SubEntity
                                     ,pt_i_MigrationSetID    => vt_MigrationSetID
                                     ,pt_i_Phase             => ct_Phase
                                     ,pt_i_Severity          => 'NOTIFICATION'
                                     ,pt_i_PackageName       => gcv_PackageName
                                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                     ,pt_i_ModuleMessage     => '    - Loop: Period Name '||PeriodName_tbl(PeriodName_idx)
                                     ,pt_i_OracleError       => NULL
                                     );
                                   --
                                   gvn_ExistenceCount := 0;
                                   --
                                   -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                                   --
                                   SELECT  COUNT(*)
                                   INTO    gvn_ExistenceCount
                                   FROM    gl_ledgers_extract  gl2
                                          ,gl_periods_extract  gp
                                   WHERE   1 = 1
                                   AND     gl2.name           = LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                   AND     gp.period_set_name = gl2.period_set_name
--                                   AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                                   AND     gp.period_name     = PeriodName_tbl(PeriodName_idx);
                                   --
                                   IF   gvn_ExistenceCount = 0 THEN
                                       xxmx_utilities_pkg.log_module_message
                                            (
                                             pt_i_ApplicationSuite  => gct_ApplicationSuite
                                            ,pt_i_Application       => gct_Application
                                            ,pt_i_BusinessEntity    => gct_BusinessEntity
                                            ,pt_i_SubEntity         => vt_SubEntity
                                            ,pt_i_MigrationSetID    => vt_MigrationSetID
                                            ,pt_i_Phase             => ct_Phase
                                            ,pt_i_Severity          => 'NOTIFICATION'
                                            ,pt_i_PackageName       => gcv_PackageName
                                            ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                            ,pt_i_ModuleMessage     => '      - No data found in EBS (source system) for Year/Period '
--                                                                     ||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                     ||PeriodName_tbl(PeriodName_idx)||' Foe ledger '
                                                                     ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                            ,pt_i_OracleError       => NULL
                                            );
                                   ELSE
                                        -- Current Period Name Parameter exists in the GL_PERIODS table
                                        -- for the current Source Ledger Name and Extract Year so the
                                        -- Balances extract can proceed.
                                        vb_PeriodAndYearMatch := TRUE;
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => vt_SubEntity
                                             ,pt_i_MigrationSetID    => vt_MigrationSetID
                                             ,pt_i_Phase             => ct_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gcv_PackageName
                                             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '      - Extracting "'||gct_Application||' '||vt_SubEntity
                                                                      ||'" for GL Ledger Name "'
                                                                      ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                      ||'", Period Name "'
                                                                      ||PeriodName_tbl(PeriodName_idx)
                                                                      --||pt_i_period_name
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
                                                   LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                  ,LedgerScope_tbl1(LedgerName_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                                  ,PeriodName_tbl(PeriodName_idx)
                                                  --,pt_i_period_name
                                                  ,LedgerScope_tbl1(LedgerName_idx).OPERATING_UNIT_NAME
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
                                                  INTO   xxmx_stg.xxmx_gl_detail_balances_stg
                                                              (
                                                               migration_set_id
                                                              , group_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,fusion_status_code
                                                              ,ledger_name
                                                              ,ledger_id
                                                              ,accounting_date
                                                              ,user_je_source_name
                                                              ,user_je_category_name
                                                              ,currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                                              ,date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                                              ,originating_bal_seg_value
                                                              ,encumbrance_type_id
                                                              ,jgzz_recon_ref
                                                              ,period_name
                                                              ,global_attribute19
                                                              ,global_attribute20
                                                              )
                                                  VALUES
                                                              (
                                                               vt_MigrationSetID                                             -- migration_set_id
                                                              ,vt_MigrationSetID -- group_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,GLBalances_tbl(GLBalances_idx).fusion_status_code             -- fusion_status_code
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_name                    -- ledger_name
                                                              ,GLBalances_tbl(GLBalances_idx).ledger_id                      -- ledger_id
                                                              ,GLBalances_tbl(GLBalances_idx).accounting_date                -- accounting_date
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_source_name            -- user_je_source_name
                                                              ,GLBalances_tbl(GLBalances_idx).user_je_category_name          -- user_je_category_name
                                                              ,GLBalances_tbl(GLBalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                                              ,GLBalances_tbl(GLBalances_idx).date_created    -- date_created
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
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                                              ,GLBalances_tbl(GLBalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                                              ,GLBalances_tbl(GLBalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                                              ,GLBalances_tbl(GLBalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                                              ,GLBalances_tbl(GLBalances_idx).period_name                    -- period_name
                                                              ,GLBalances_tbl(GLBalances_idx).header_line                    
                                                              ,GLBalances_tbl(GLBalances_idx).old_ccid                    
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
                                        ,pt_i_SubEntity         => vt_SubEntity
                                        ,pt_i_MigrationSetID    => vt_MigrationSetID
                                        ,pt_i_Phase             => ct_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gcv_PackageName
                                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                 ||'" and the Period Set associated with Source Ledger Name "'
                                                                 ||LedgerScope_tbl1(LedgerName_idx).LEDGER_NAME
                                                                 ||'".  No Balances were extracted for this year.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF NOT vb_PeriodAndYearMatch
                              --
--                         END LOOP; --** ExtractYear_tbl LOOP
                         --
                    END LOOP; --** Ledger details LOOP
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity               => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
               ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
                         ,pt_i_SubEntity         => vt_SubEntity
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
     END gl_detail_balances_stg;
     --
     --*******************
     --** PROCEDURE: main
     --*******************
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
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_GL_BALANCES_PKG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GENERAL_LEDGER';
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
               ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
               ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
               ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
               ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
               ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                         ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
                         ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
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
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
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

END XXMX_GL_BALANCES_PKG_bkp28092023;

/
