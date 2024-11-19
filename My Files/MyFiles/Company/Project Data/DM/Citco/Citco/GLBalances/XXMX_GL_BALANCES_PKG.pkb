create or replace PACKAGE BODY xxmx_gl_balances_pkg AS
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
    gcv_packagename               CONSTANT VARCHAR2(30) := 'xxmx_gl_balances_pkg';
    gct_applicationsuite          CONSTANT xxmx_module_messages.application_suite%TYPE := 'FIN';
    gct_application               CONSTANT xxmx_module_messages.application%TYPE := 'GL';
    gct_stgschema                 CONSTANT VARCHAR2(10) := 'xxmx_stg';
    gct_xfmschema                 CONSTANT VARCHAR2(10) := 'xxmx_xfm';
    gct_coreschema                CONSTANT VARCHAR2(10) := 'xxmx_core';
    gct_businessentity            CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'BALANCES';
    gct_origsystem                CONSTANT VARCHAR2(10) := 'ORACLER12';
     --

     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
    gvv_progressindicator         VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
    gvv_returnstatus              VARCHAR2(1);
    gvt_returnmessage             xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for data existence checking */
     --
    gvn_existencecount            NUMBER;
     --
     -- Global Variables for Exception Handlers 
     --
    gvt_severity                  xxmx_module_messages.severity%TYPE;
    gvt_modulemessage             xxmx_module_messages.module_message%TYPE;
    gvt_oracleerror               xxmx_module_messages.oracle_error%TYPE;
     --
     --Exception Declarations
     --
    e_moduleerror EXCEPTION;
    e_dateerror EXCEPTION;
     --
     -- Global Variables for Exception Handlers 
     --
    gvt_migrationsetname          xxmx_migration_headers.migration_set_name%TYPE;
     --
     -- Global constants and variables for dynamic SQL usage 
     --
    gcv_sqlspace                  CONSTANT VARCHAR2(1) := ' ';
    gvv_sqlaction                 VARCHAR2(20);
    gvv_sqltableclause            VARCHAR2(100);
    gvv_sqlcolumnlist             VARCHAR2(4000);
    gvv_sqlvalueslist             VARCHAR2(4000);
    gvv_sqlwhereclause            VARCHAR2(4000);
    gvv_sqlstatement              VARCHAR2(32000);
    gvv_sqlresult                 VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
    gvn_rowcount                  NUMBER;
     --
     /* Global variables for transform procedures */
     --
    gvb_simpletransformsrequired  BOOLEAN;
    gvt_transformcategorycode     xxmx_simple_transforms.category_code%TYPE;
    gvb_missingsimpletransforms   BOOLEAN;
    gvb_dataenrichmentrequired    BOOLEAN;
    gvt_parametercode             xxmx_migration_parameters.parameter_code%TYPE;
    gvv_parametercheckresult      VARCHAR2(10);
    gvb_missingdataenrichment     BOOLEAN;
    gvb_complextransformsrequired BOOLEAN;
    gvb_performcomplextransforms  BOOLEAN;
     --
     --*****************************
     --** PROCEDURE: gl_opening_balances_stg
     --*****************************
     --
     --**
     --** Future Updates:
     --**   Pass Account Segment Delimiter as a Parameter determined from the Chart of Accounts Structure
     --**
    PROCEDURE gl_opening_balances_stg (
        pt_i_migrationsetid IN xxmx_migration_headers.migration_set_id%TYPE,
        pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the opening GL balance
          --
        CURSOR glbalances_cur (
            pv_ledgername   VARCHAR2,
            pv_country_code VARCHAR2
                      --,pv_ExtractYear                  VARCHAR2
            ,
            pv_periodname   VARCHAR2,
            pv_ou_name      VARCHAR2
        ) IS
               --
               --
        SELECT
            'NEW'                      fusion_status_code,
            gl.name                    ledger_name,
            gl.ledger_id               ledger_id,
            (
                SELECT
                    gp.end_date
                FROM
                    gl_periods_extract gp
                WHERE
                    gp.period_name = xbal.period_name
                    AND gp.period_set_name = gl.period_set_name
            )                          accounting_date,
            (
                SELECT
                    parameter_value
                FROM
                    xxmx_core.xxmx_migration_parameters
                WHERE
                    application_suite = gct_applicationsuite
                    AND application = gct_application
                    AND business_entity = gct_businessentity
                    AND parameter_code = 'BATCH_SOURCE'
            )                          user_je_source_name,
            (
                SELECT
                    parameter_value
                FROM
                    xxmx_core.xxmx_migration_parameters
                WHERE
                    application_suite = gct_applicationsuite
                    AND application = gct_application
                    AND business_entity = gct_businessentity
                    AND parameter_code = 'BATCH_CATEGORY_NAME'
            )                          user_je_category_name,
            xbal.currency_code         currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = xbal.period_name
--                        AND gp.period_set_name = gl.period_set_name)         date_created
            ,
            (
                SELECT
                    gp.end_date
                FROM
                    gl_periods_extract gp
                WHERE
                    gp.period_name = xbal.period_name
                    AND gp.period_set_name = gl.period_set_name
            )                          date_created,
            'A'                        actual_flag,
            gcc.segment1               segment1,
            gcc.segment2               segment2,
            gcc.segment3               segment3,
            gcc.segment4               segment4,
            gcc.segment5               segment5,
            gcc.segment6               segment6,
            gcc.segment7               segment7,
            gcc.segment8               segment8,
            gcc.segment9               segment9,
            gcc.segment10              segment10,
            gcc.segment11              segment11,
            gcc.segment12              segment12,
            gcc.segment13              segment13,
            gcc.segment14              segment14,
            gcc.segment15              segment15,
            gcc.segment16              segment16,
            gcc.segment17              segment17,
            gcc.segment18              segment18,
            gcc.segment19              segment19,
            gcc.segment20              segment20,
            gcc.segment21              segment21,
            gcc.segment22              segment22,
            gcc.segment23              segment23,
            gcc.segment24              segment24,
            gcc.segment25              segment25,
            gcc.segment26              segment26,
            gcc.segment27              segment27,
            gcc.segment28              segment28,
            gcc.segment29              segment29,
            gcc.segment30              segment30
--                      ,xbal.entered_dr                                   entered_dr
--                      ,xbal.entered_cr                                   entered_cr
            ,
            (
                CASE
                WHEN xbal.entered_dr IS NULL
                     AND xbal.entered_cr IS NULL
                     AND accounted_dr IS NOT NULL THEN
                0
                ELSE
                xbal.entered_dr
                END
            )                          entered_dr,
            (
                CASE
                WHEN xbal.entered_dr IS NULL
                     AND xbal.entered_cr IS NULL
                     AND accounted_cr IS NOT NULL THEN
                0
                ELSE
                xbal.entered_cr
                END
            )                          entered_cr,
                      --,xbal.accounted_dr                                 accounted_dr
            (
                CASE
                WHEN xbal.accounted_dr IS NULL
                     AND xbal.accounted_cr IS NULL
                     AND xbal.entered_dr IS NOT NULL THEN
                0
                WHEN ( entered_dr IS NOT NULL
                       AND accounted_cr IS NOT NULL ) THEN
                xbal.accounted_cr * - 1
                WHEN ( entered_cr IS NOT NULL
                       AND accounted_dr IS NOT NULL ) THEN
                NULL
                ELSE
                xbal.accounted_dr
                END
            )                          accounted_dr
                      --,xbal.accounted_cr                                 accounted_cr
            ,
            (
                CASE
                WHEN xbal.accounted_dr IS NULL
                     AND xbal.accounted_cr IS NULL
                     AND xbal.entered_cr IS NOT NULL THEN
                0
                WHEN ( entered_dr IS NOT NULL
                       AND accounted_cr IS NOT NULL ) THEN
                NULL
                WHEN ( entered_cr IS NOT NULL
                       AND accounted_dr IS NOT NULL ) THEN
                xbal.accounted_dr * - 1
                ELSE
                xbal.accounted_cr
                END
            )                          accounted_cr,
            'ACTUAL BALANCE MIGRATION'
            || ' '
            || xbal.period_name        reference1                        -- CV040 states this should be the Batch Name
            ,
            ''                         reference2                        -- CV040 states this should be the Batch Description
            ,
            ''                         reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
            ,
            'ACTUAL BALANCE MIGRATION'
            || ' '
            || xbal.period_name        reference4                      -- CV040 states this should be the Journal Entry Name
            ,
            ''                         reference5                        -- CV040 states this should be the Journal Entry Description
            ,
            ''                         reference6                        -- CV040 states this should be the Journal Entry Reference
            ,
            ''                         reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
            ,
            ''                         reference8                        -- CV040 states this should be the Journal entry Reversal Period
            ,
            ''                         reference9                        -- CV040 states this should be the Journal Reversal Method
            ,
            gcck.concatenated_segments reference10                       -- CV040 states this should be the Journal entry Line Description
            ,
            ''                         stat_amount,
            ''                         user_currency_conversion_type
                      --,gjh.currency_conversion_date                      currency_conversion_date
            ,
            ''                         currency_conversion_date,
            ''                         currency_conversion_rate,
            ''                         attribute_category,
            ''                         attribute1,
            ''                         attribute2,
            ''                         attribute3,
            ''                         attribute4,
            ''                         attribute5,
            ''                         attribute6,
            ''                         attribute7,
            ''                         attribute8,
            ''                         attribute9,
            ''                         attribute10,
            ''                         attribute11,
            ''                         attribute12,
            ''                         attribute13,
            ''                         attribute14,
            ''                         attribute15,
            ''                         attribute16,
            ''                         attribute17,
            ''                         attribute18,
            ''                         attribute19,
            ''                         attribute20,
            ''                         attribute_category3
-- MA 27/04/2022 no longer required
--                      ,''                                                average_journal_flag
            ,
            ''                         originating_bal_seg_value,
            ''                         encumbrance_type_id,
            ''                         jgzz_recon_ref
--                      ,(case when xbal.period_name like 'ADJ%' then
--                        replace(xbal.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(xbal.period_name)
--                        end)                                  period_name
            ,
            initcap(
                xbal.period_name
            )                          period_name
        FROM
            gl_ledgers_extract                  gl,
            xxmx_core.xxmx_gl_opening_balance_v xbal,
            gl_code_combinations_gcc_ext        gcc,
            gl_code_combinations_extract        gcck
        WHERE
            gl.name = pv_ledgername
--             and    gcc.segment1                                    = pv_country_code
--             AND    gl.period_set_name                              = 'CITCO MONTH'
            AND xbal.ledger_id = gl.ledger_id
            AND xbal.period_name = pv_periodname
-- Added by MA 23/03/2022 to eliminate the zero lines
            AND ( nvl(
                xbal.entered_dr, 0
            ) != 0
                  OR nvl(
                xbal.entered_cr, 0
            ) != 0
                  OR nvl(
                xbal.accounted_dr, 0
            ) != 0
                  OR nvl(
                xbal.accounted_cr, 0
            ) != 0 )
--             AND    nvl(xbal.entered_dr,0)+nvl(xbal.entered_cr,0)   > 0
            AND gcc.code_combination_id = xbal.code_combination_id
            AND gcck.code_combination_id = gcc.code_combination_id;
--             AND    gcc.segment1 = substr(pv_ou_name,3);

          --
          -- Cursor to get the ledger names
          -- 
        CURSOR getledger_cur IS
        SELECT
            *
        FROM
            xxmx_core.xxmx_ledger_scope_v;

          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
        TYPE ledgername_tt IS
            TABLE OF xxmx_core.xxmx_ledger_scope_v%rowtype INDEX BY BINARY_INTEGER;
        TYPE gl_balances_tt IS
            TABLE OF glbalances_cur%rowtype INDEX BY BINARY_INTEGER;
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
        cv_procorfuncname     CONSTANT VARCHAR2(30) := 'gl_opening_balances_stg';
        ct_stgtable           CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_opening_balances_stg';
        ct_phase              CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
        vt_listparametercode  xxmx_migration_parameters.parameter_code%TYPE;
        vn_listvaluecount     NUMBER;
        vb_okaytoextract      BOOLEAN;
        vb_periodandyearmatch BOOLEAN;
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
        emptyextractyear_tbl  xxmx_utilities_pkg.g_paramvaluelist_tt;
        extractyear_tbl       xxmx_utilities_pkg.g_paramvaluelist_tt;
        emptyperiodname_tbl   xxmx_utilities_pkg.g_paramvaluelist_tt;
        periodname_tbl        xxmx_utilities_pkg.g_paramvaluelist_tt;
        glbalances_tbl        gl_balances_tt;
        ledgerscope_tbl1      ledgername_tt;                 
          --
        vt_subentity          CONSTANT xxmx_module_messages.sub_entity%TYPE := 'OPEN_BAL';
        vt_migrationsetid     xxmx_migration_headers.migration_set_id%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
        e_moduleerror EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
    BEGIN
    --
        gvv_progressindicator := '0010';
    --
        vb_okaytoextract := true;
        gvv_returnstatus := '';
        gvt_returnmessage := '';
        vt_migrationsetid := pt_i_migrationsetid;
    --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => vt_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'MODULE',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
    --
        IF gvv_returnstatus = 'F' THEN
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0020';
    --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
    --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => vt_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'DATA',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
    --
        gvv_progressindicator := '0030';
    --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '  - Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );
          --
        gvv_progressindicator := '0040';
    --
    --** If the Migration Set ID is NULL then the Migration has not been initialized.
    --
        IF vt_migrationsetid IS NOT NULL THEN
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving ledger details from scope table.',
                                                 pt_i_oracleerror       => NULL
            );
               --
            gvv_progressindicator := '0045';
        --
            gvt_migrationsetname := xxmx_utilities_pkg.get_migration_set_name(pt_i_migrationsetid);
        --
            BEGIN
                OPEN getledger_cur;
                FETCH getledger_cur
                BULK COLLECT INTO ledgerscope_tbl1;
                CLOSE getledger_cur;
            EXCEPTION
                WHEN OTHERS THEN
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - err: ' || sqlerrm,
                                                         pt_i_oracleerror       => NULL
                    );
            END;
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Ledger scope count: ' || ledgerscope_tbl1.count(),
                                                 pt_i_oracleerror       => NULL
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
            gvv_progressindicator := '0060';
        --
            vt_listparametercode := 'PERIOD';
            vn_listvaluecount := 0;
            gvv_returnstatus := '';
            gvt_returnmessage := '';
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving "'
                                                                       || vt_listparametercode
                                                                       || '" List from Migration Parameters table:',
                                                 pt_i_oracleerror       => NULL
            );
        --
            periodname_tbl := xxmx_utilities_pkg.get_parameter_value_list(
                                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                                         pt_i_application      => gct_application,
                                                                         pt_i_businessentity   => gct_businessentity,
                                                                         pt_i_subentity        => 'OPENING BALANCES',
                                                                         pt_i_parametercode    => vt_listparametercode,
                                                                         pn_o_returncount      => vn_listvaluecount,
                                                                         pv_o_returnstatus     => gvv_returnstatus,
                                                                         pv_o_returnmessage    => gvt_returnmessage
                              );
        --
            IF gvv_returnstatus = 'F' THEN
            --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'ERROR',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                                           || vt_listparametercode
                                                                           || '" List could not be retrieved.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
                RAISE e_moduleerror;
            --
            ELSE
            --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - '
                                                                           || vn_listvaluecount
                                                                           || ' values for "'
                                                                           || vt_listparametercode
                                                                           || '" List retrieved.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF;
        --
            IF vn_listvaluecount = 0 THEN
            --
                vb_okaytoextract := false;
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'WARNING',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - No "'
                                                                           || vt_listparametercode
                                                                           || '" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
            END IF;
        --
        --
        -- If there are no Extract Parameters in the "xxmx_migration_parameters" table
        -- (those which are there have to be enabled), no balances can be extracted.
        --
        --
            gvv_progressindicator := '0070';
        --
            IF vb_okaytoextract THEN
            --
            --
            -- The Extract Parameters were successfully retrieved so now
            -- initialize the detail record for the GL Balances.
            --
                xxmx_utilities_pkg.init_migration_details(
                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                         pt_i_application      => gct_application,
                                                         pt_i_businessentity   => gct_businessentity,
                                                         pt_i_subentity        => vt_subentity,
                                                         pt_i_migrationsetid   => vt_migrationsetid,
                                                         pt_i_stagingtable     => ct_stgtable,
                                                         pt_i_extractstartdate => sysdate
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - Staging Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details initialised.',
                                                     pt_i_oracleerror       => NULL
                );
            --
            --  loop through the Ledger Name list and for each one:
            --
            -- a) Retrieve COA Structure Details pertaining to the Ledger.
            -- b) Extract the Balances for the Ledger.
            --
                gvv_progressindicator := '0090';
            --
                FOR ledgername_idx IN ledgerscope_tbl1.first..ledgerscope_tbl1.last LOOP
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - Loop: Ledger name.',
                                                         pt_i_oracleerror       => NULL
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
                    vb_periodandyearmatch := false;
                    --
                    --
                    -- Loop through GL Period Names List
                    --
                    --
                    FOR periodname_idx IN periodname_tbl.first..periodname_tbl.last LOOP
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '    - Loop: Period Name ' || periodname_tbl(periodname_idx),
                                                             pt_i_oracleerror       => NULL
                        );
                        --
                        gvn_existencecount := 0;
                        --
                        /*
                        ** Verify if the current Period Name Parameter exists
                        ** as a GL Period in the GL_PERIODS table for the current
                        ** Source Ledger Name and Extract Year Parameters.
                        */
                        --
                        gvv_progressindicator := '0130';
                        --
                        --
                        -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                        --
                        SELECT
                            COUNT(*)
                        INTO gvn_existencecount
                        FROM
                            gl_ledgers_extract gl2,
                            gl_periods_extract gp
                        WHERE
                            1 = 1
                            AND gl2.name = ledgerscope_tbl1(ledgername_idx).ledger_name
                            AND gp.period_set_name = gl2.period_set_name
                        --AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                            AND gp.period_name = periodname_tbl(periodname_idx);
                        --
                        IF gvn_existencecount = 0 THEN
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - No data found in EBS (source system) for Year/Period '
                                                                     --||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                                       || periodname_tbl(periodname_idx)
                                                                                       || ' Foe ledger '
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name,
                                                                 pt_i_oracleerror       => NULL
                            );
                        ELSE
                            --
                            --
                            -- Current Period Name Parameter exists in the GL_PERIODS table
                            -- for the current Source Ledger Name and Extract Year so the
                            -- Balances extract can proceed.
                            --
                            --
                            vb_periodandyearmatch := true;
                            --
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - Extracting "'
                                                                                       || gct_application
                                                                                       || ' '
                                                                                       || vt_subentity
                                                                                       || '" for GL Ledger Name "'
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                                       || '", Period Name "'
                                                                                       || periodname_tbl(periodname_idx)
                                                                                       || '".',
                                                                 pt_i_oracleerror       => NULL
                            );
                            --
                            gvv_progressindicator := '0140';
                            --
                            OPEN glbalances_cur(
                                               ledgerscope_tbl1(ledgername_idx).ledger_name,
                                               ledgerscope_tbl1(ledgername_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                               ,
                                               periodname_tbl(periodname_idx),
                                               ledgerscope_tbl1(ledgername_idx).operating_unit_name
                                 );
                            --
                            gvv_progressindicator := '0150';
                            --
                            LOOP
                            --
                                FETCH glbalances_cur
                                BULK COLLECT INTO glbalances_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                                --
                                EXIT WHEN glbalances_tbl.count = 0;
                                --
                                xxmx_utilities_pkg.log_module_message(
                                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                                     pt_i_application       => gct_application,
                                                                     pt_i_businessentity    => gct_businessentity,
                                                                     pt_i_subentity         => vt_subentity,
                                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                                     pt_i_phase             => ct_phase,
                                                                     pt_i_severity          => 'NOTIFICATION',
                                                                     pt_i_packagename       => gcv_packagename,
                                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                                     pt_i_progressindicator => gvv_progressindicator,
                                                                     pt_i_modulemessage     => '    - Record Count ' || glbalances_tbl.
                                                                     count,
                                                                     pt_i_oracleerror       => NULL
                                );
                                --
                                gvv_progressindicator := '0160';
                                --
                                FORALL glbalances_idx IN 1..glbalances_tbl.count
                                --
                                    INSERT INTO xxmx_stg.xxmx_gl_opening_balances_stg (
                                        migration_set_id,
                                        group_id,
                                        migration_set_name,
                                        migration_status,
                                        fusion_status_code,
                                        ledger_name,
                                        ledger_id,
                                        accounting_date,
                                        user_je_source_name,
                                        user_je_category_name,
                                        currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                        ,
                                        date_created,
                                        actual_flag,
                                        segment1,
                                        segment2,
                                        segment3,
                                        segment4,
                                        segment5,
                                        segment6,
                                        segment7,
                                        segment8,
                                        segment9,
                                        segment10,
                                        segment11,
                                        segment12,
                                        segment13,
                                        segment14,
                                        segment15,
                                        segment16,
                                        segment17,
                                        segment18,
                                        segment19,
                                        segment20,
                                        segment21,
                                        segment22,
                                        segment23,
                                        segment24,
                                        segment25,
                                        segment26,
                                        segment27,
                                        segment28,
                                        segment29,
                                        segment30,
                                        entered_dr,
                                        entered_cr,
                                        accounted_dr,
                                        accounted_cr,
                                        reference1,
                                        reference2,
                                        reference3,
                                        reference4,
                                        reference5,
                                        reference6,
                                        reference7,
                                        reference8,
                                        reference9,
                                        reference10,
                                        stat_amount,
                                        user_currency_conversion_type,
                                        currency_conversion_date,
                                        currency_conversion_rate,
                                        attribute_category,
                                        attribute1,
                                        attribute2,
                                        attribute3,
                                        attribute4,
                                        attribute5,
                                        attribute6,
                                        attribute7,
                                        attribute8,
                                        attribute9,
                                        attribute10,
                                        attribute11,
                                        attribute12,
                                        attribute13,
                                        attribute14,
                                        attribute15,
                                        attribute16,
                                        attribute17,
                                        attribute18,
                                        attribute19,
                                        attribute20,
                                        attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                        ,
                                        originating_bal_seg_value,
                                        encumbrance_type_id,
                                        jgzz_recon_ref,
                                        period_name
                                    ) VALUES (
                                        vt_migrationsetid                                             -- migration_set_id
                                        ,
                                        vt_migrationsetid                                             -- group_id
                                        ,
                                        gvt_migrationsetname                                          -- migration_set_name
                                        ,
                                        'EXTRACTED'                                                   -- migration_status
                                        ,
                                        glbalances_tbl(glbalances_idx).fusion_status_code             -- fusion_status_code
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_name                    -- ledger_name
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_id                        -- ledger_id
                                        ,
                                        glbalances_tbl(glbalances_idx).accounting_date                -- accounting_date
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_source_name            -- user_je_source_name
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_category_name          -- user_je_category_name
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                        ,
                                        glbalances_tbl(glbalances_idx).date_created    -- date_created
                                        ,
                                        glbalances_tbl(glbalances_idx).actual_flag                    -- actual_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).segment1                       -- segment1
                                        ,
                                        glbalances_tbl(glbalances_idx).segment2                       -- segment2
                                        ,
                                        glbalances_tbl(glbalances_idx).segment3                       -- segment3
                                        ,
                                        glbalances_tbl(glbalances_idx).segment4                       -- segment4
                                        ,
                                        glbalances_tbl(glbalances_idx).segment5                       -- segment5
                                        ,
                                        glbalances_tbl(glbalances_idx).segment6                       -- segment6
                                        ,
                                        glbalances_tbl(glbalances_idx).segment7                       -- segment7
                                        ,
                                        glbalances_tbl(glbalances_idx).segment8                       -- segment8
                                        ,
                                        glbalances_tbl(glbalances_idx).segment9                       -- segment9
                                        ,
                                        glbalances_tbl(glbalances_idx).segment10                      -- segment10
                                        ,
                                        glbalances_tbl(glbalances_idx).segment11                      -- segment11
                                        ,
                                        glbalances_tbl(glbalances_idx).segment12                      -- segment12
                                        ,
                                        glbalances_tbl(glbalances_idx).segment13                      -- segment13
                                        ,
                                        glbalances_tbl(glbalances_idx).segment14                      -- segment14
                                        ,
                                        glbalances_tbl(glbalances_idx).segment15                      -- segment15
                                        ,
                                        glbalances_tbl(glbalances_idx).segment16                      -- segment16
                                        ,
                                        glbalances_tbl(glbalances_idx).segment17                      -- segment17
                                        ,
                                        glbalances_tbl(glbalances_idx).segment18                      -- segment18
                                        ,
                                        glbalances_tbl(glbalances_idx).segment19                      -- segment19
                                        ,
                                        glbalances_tbl(glbalances_idx).segment20                      -- segment20
                                        ,
                                        glbalances_tbl(glbalances_idx).segment21                      -- segment21
                                        ,
                                        glbalances_tbl(glbalances_idx).segment22                      -- segment22
                                        ,
                                        glbalances_tbl(glbalances_idx).segment23                      -- segment23
                                        ,
                                        glbalances_tbl(glbalances_idx).segment24                      -- segment24
                                        ,
                                        glbalances_tbl(glbalances_idx).segment25                      -- segment25
                                        ,
                                        glbalances_tbl(glbalances_idx).segment26                      -- segment26
                                        ,
                                        glbalances_tbl(glbalances_idx).segment27                      -- segment27
                                        ,
                                        glbalances_tbl(glbalances_idx).segment28                      -- segment28
                                        ,
                                        glbalances_tbl(glbalances_idx).segment29                      -- segment29
                                        ,
                                        glbalances_tbl(glbalances_idx).segment30                      -- segment30
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_dr                     -- entered_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_cr                     -- entered_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_dr                   -- accounted_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_cr                   -- accounted_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).reference1                     -- reference1
                                        ,
                                        glbalances_tbl(glbalances_idx).reference2                     -- reference2
                                        ,
                                        glbalances_tbl(glbalances_idx).reference3                     -- reference3
                                        ,
                                        glbalances_tbl(glbalances_idx).reference4                     -- reference4
                                        ,
                                        glbalances_tbl(glbalances_idx).reference5                     -- reference5
                                        ,
                                        glbalances_tbl(glbalances_idx).reference6                     -- reference6
                                        ,
                                        glbalances_tbl(glbalances_idx).reference7                     -- reference7
                                        ,
                                        glbalances_tbl(glbalances_idx).reference8                     -- reference8
                                        ,
                                        glbalances_tbl(glbalances_idx).reference9                     -- reference9
                                        ,
                                        glbalances_tbl(glbalances_idx).reference10                    -- reference10
                                        ,
                                        glbalances_tbl(glbalances_idx).stat_amount                    -- stat_amount
                                        ,
                                        glbalances_tbl(glbalances_idx).user_currency_conversion_type  -- user_currency_conversion_type
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_date       -- currency_conversion_date
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_rate       -- currency_conversion_rate
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category             -- attribute_category
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute1                     -- attribute1
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute2                     -- attribute2
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute3                     -- attribute3
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute4                     -- attribute4
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute5                     -- attribute5
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute6                     -- attribute6
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute7                     -- attribute7
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute8                     -- attribute8
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute9                     -- attribute9
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute10                    -- attribute10
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute11                    -- attribute11
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute12                    -- attribute12
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute13                    -- attribute13
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute14                    -- attribute14
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute15                    -- attribute15
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute16                    -- attribute16
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute17                    -- attribute17
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute18                    -- attribute18
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute19                    -- attribute19
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute20                    -- attribute20
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category3            -- attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                        ,
                                        glbalances_tbl(glbalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                        ,
                                        glbalances_tbl(glbalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                        ,
                                        glbalances_tbl(glbalances_idx).period_name                    -- period_name
                                    );
                                                  --
                                             --** END FORALL
                                             --
                            END LOOP; --** GLBalances_cur BULK COLLECT LOOP
                            --
                            gvv_progressindicator := '0170';
                            --
                            CLOSE glbalances_cur;
                            --
                        END IF; --** IF gvn_ExistenceCount >0
                            --
                    END LOOP; --** PeriodName_tbl LOOP
                        --
                    gvv_progressindicator := '0180';
                        --
                    IF NOT vb_periodandyearmatch THEN
                            --
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                                   || '" and the Period Set associated with Source Ledger Name "'
                                                                                   || ledgerscope_tbl1(ledgername_idx).ledger_name
                                                                                   || '".  No Balances were extracted for this year.',
                                                             pt_i_oracleerror       => NULL
                        );
                            --
                    END IF; --** IF NOT vb_PeriodAndYearMatch
                        --
--                    END LOOP; --** ExtractYear_tbl LOOP
                    --
                END LOOP; --** Ledger scope tbl LOOP
                --
                gvv_progressindicator := '0190';
                --
                /*
                ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                ** all GL Ledgers in the Migration Set.
                */
                --
                gvn_rowcount := xxmx_utilities_pkg.get_row_count(
                                                                gct_stgschema,
                                                                ct_stgtable,
                                                                vt_migrationsetid
                                );
                --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Extraction complete.',
                                                     pt_i_oracleerror       => NULL
                );
                --
                --
                COMMIT;
                --
                -- Update the migration details (Migration status will be automatically determined
                -- in the called procedure dependant on the Phase and if an Error Message has been
                -- passed).
                --
                gvv_progressindicator := '0200';
                --
                --
                xxmx_utilities_pkg.upd_migration_details(
                                                        pt_i_migrationsetid          => vt_migrationsetid,
                                                        pt_i_businessentity          => gct_businessentity,
                                                        pt_i_subentity               => vt_subentity,
                                                        pt_i_phase                   => ct_phase,
                                                        pt_i_extractcompletiondate   => sysdate,
                                                        pt_i_extractrowcount         => gvn_rowcount,
                                                        pt_i_transformtable          => NULL,
                                                        pt_i_transformstartdate      => NULL,
                                                        pt_i_transformcompletiondate => NULL,
                                                        pt_i_exportfilename          => NULL,
                                                        pt_i_exportstartdate         => NULL,
                                                        pt_i_exportcompletiondate    => NULL,
                                                        pt_i_exportrowcount          => NULL,
                                                        pt_i_errorflag               => NULL
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Migration Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details updated.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF; --** vn_ListEntryCount > 0
            --
        ELSE
        --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- Migration Set not initialized.';
            --
            RAISE e_moduleerror;
               --
        END IF;
        --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
        WHEN e_moduleerror THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            RAISE;
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted at after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
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
    PROCEDURE gl_summary_balances_stg (
        pt_i_migrationsetid IN xxmx_migration_headers.migration_set_id%TYPE,
        pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the summary GL balance
          --
        CURSOR glbalances_cur (
            pv_ledgername   VARCHAR2,
            pv_country_code VARCHAR2
                     -- ,pv_ExtractYear                  VARCHAR2
            ,
            pv_periodname   VARCHAR2,
            pv_ou_name      VARCHAR2
        ) IS
        SELECT
            'NEW'                      fusion_status_code,
            gl.name                    ledger_name,
            gl.ledger_id               ledger_id,
            (
                SELECT
                    gp.end_date
                FROM
                    gl_periods_extract gp
                WHERE
                    gp.period_name = xbal.period_name
                    AND gp.period_set_name = gl.period_set_name
            )                          accounting_date,
            (
                SELECT
                    parameter_value
                FROM
                    xxmx_core.xxmx_migration_parameters
                WHERE  --application = gct_ApplicationSuite -- commented by Somya on 08-Apr-22
                    application_suite = gct_applicationsuite -- Added by Somya on 08-Apr-22
                    AND business_entity = gct_businessentity
                        --AND    parameter_code='batch_source' -- commented by Somya on 08-Apr-22
                    AND parameter_code = 'BATCH_SOURCE' -- added by Somya on 08-Apr-22
            )                          user_je_source_name,
            (
                SELECT
                    parameter_value
                FROM
                    xxmx_core.xxmx_migration_parameters
                WHERE  --application = gct_ApplicationSuite -- commented by Somya on 08-Apr-22
                    application_suite = gct_applicationsuite -- Added by Somya on 08-Apr-22
                    AND business_entity = gct_businessentity
                    AND parameter_code = 'BATCH_CATEGORY_NAME'
            )                          user_je_category_name,
            xbal.currency_code         currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = xbal.period_name
--                        AND gp.period_set_name = gl.period_set_name)         date_created
            ,
            (
                SELECT
                    gp.end_date
                FROM
                    gl_periods_extract gp
                WHERE
                    gp.period_name = xbal.period_name
                    AND gp.period_set_name = gl.period_set_name
            )                          date_created,
            'A'                        actual_flag,
            gcc.segment1               segment1,
            gcc.segment2               segment2,
            gcc.segment3               segment3,
            gcc.segment4               segment4,
            gcc.segment5               segment5,
            gcc.segment6               segment6,
            gcc.segment7               segment7,
            gcc.segment8               segment8,
            gcc.segment9               segment9,
            gcc.segment10              segment10,
            gcc.segment11              segment11,
            gcc.segment12              segment12,
            gcc.segment13              segment13,
            gcc.segment14              segment14,
            gcc.segment15              segment15,
            gcc.segment16              segment16,
            gcc.segment17              segment17,
            gcc.segment18              segment18,
            gcc.segment19              segment19,
            gcc.segment20              segment20,
            gcc.segment21              segment21,
            gcc.segment22              segment22,
            gcc.segment23              segment23,
            gcc.segment24              segment24,
            gcc.segment25              segment25,
            gcc.segment26              segment26,
            gcc.segment27              segment27,
            gcc.segment28              segment28,
            gcc.segment29              segment29,
            gcc.segment30              segment30
                      --                      ,xbal.entered_dr                                   entered_dr
--                      ,xbal.entered_cr                                   entered_cr
            ,
            (
                CASE
                WHEN xbal.entered_dr IS NULL
                     AND xbal.entered_cr IS NULL
                     AND accounted_dr IS NOT NULL THEN
                0
                ELSE
                xbal.entered_dr
                END
            )                          entered_dr,
            (
                CASE
                WHEN xbal.entered_dr IS NULL
                     AND xbal.entered_cr IS NULL
                     AND accounted_cr IS NOT NULL THEN
                0
                ELSE
                xbal.entered_cr
                END
            )                          entered_cr
                      --,xbal.accounted_dr                                 accounted_dr
            ,
            (
                CASE
                WHEN xbal.accounted_dr IS NULL
                     AND xbal.accounted_cr IS NULL
                     AND xbal.entered_dr IS NOT NULL THEN
                0
                WHEN ( entered_dr IS NOT NULL
                       AND accounted_cr IS NOT NULL ) THEN
                xbal.accounted_cr * - 1
                WHEN ( entered_cr IS NOT NULL
                       AND accounted_dr IS NOT NULL ) THEN
                NULL
                ELSE
                xbal.accounted_dr
                END
            )                          accounted_dr
                      --,xbal.accounted_cr                                 accounted_cr
            ,
            (
                CASE
                WHEN xbal.accounted_dr IS NULL
                     AND xbal.accounted_cr IS NULL
                     AND xbal.entered_cr IS NOT NULL THEN
                0
                WHEN ( entered_dr IS NOT NULL
                       AND accounted_cr IS NOT NULL ) THEN
                NULL
                WHEN ( entered_cr IS NOT NULL
                       AND accounted_dr IS NOT NULL ) THEN
                xbal.accounted_dr * - 1
                ELSE
                xbal.accounted_cr
                END
            )                          accounted_cr,
            'ACTUAL BALANCE MIGRATION'
            || ' '
            || xbal.period_name        reference1                        -- CV040 states this should be the Batch Name
            ,
            ''                         reference2                        -- CV040 states this should be the Batch Description
            ,
            ''                         reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
            ,
            'ACTUAL BALANCE MIGRATION'
            || ' '
            || xbal.period_name        reference4                      -- CV040 states this should be the Journal Entry Name
            ,
            ''                         reference5                        -- CV040 states this should be the Journal Entry Description
            ,
            ''                         reference6                        -- CV040 states this should be the Journal Entry Reference
            ,
            ''                         reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
            ,
            ''                         reference8                        -- CV040 states this should be the Journal entry Reversal Period
            ,
            ''                         reference9                        -- CV040 states this should be the Journal Reversal Method
            ,
            gcck.concatenated_segments reference10                       -- CV040 states this should be the Journal entry Line Description
            ,
            ''                         stat_amount,
            ''                         user_currency_conversion_type
                      --,gjh.currency_conversion_date                      currency_conversion_date
            ,
            ''                         currency_conversion_date,
            ''                         currency_conversion_rate,
            ''                         attribute_category
                      --,gcck.concatenated_segments                        attribute1 -- commented by Somya on 11-apr-22
            ,
            ''                         attribute1 -- added by Somya on 11-apr-22
            ,
            ''                         attribute2,
            ''                         attribute3,
            ''                         attribute4,
            ''                         attribute5,
            ''                         attribute6,
            ''                         attribute7,
            ''                         attribute8,
            ''                         attribute9,
            ''                         attribute10,
            ''                         attribute11,
            ''                         attribute12,
            ''                         attribute13,
            ''                         attribute14,
            ''                         attribute15,
            ''                         attribute16,
            ''                         attribute17,
            ''                         attribute18,
            ''                         attribute19,
            ''                         attribute20,
            ''                         attribute_category3
-- MA 27/04/2022 no longer required
--                      ,''                                                average_journal_flag
            ,
            ''                         originating_bal_seg_value,
            ''                         encumbrance_type_id,
            ''                         jgzz_recon_ref
--                      ,(case when xbal.period_name like 'ADJ%' then
--                        replace(xbal.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(xbal.period_name)
--                        end)                                  period_name
            ,
            initcap(
                xbal.period_name
            )                          period_name
        FROM
            gl_ledgers_extract           gl,
            xxmx_gl_balance_summary_v    xbal,
            gl_code_combinations_gcc_ext gcc,
            gl_code_combinations_extract gcck
        WHERE
            gl.name = pv_ledgername
--             and    gcc.segment1                                    = pv_country_code
--             AND    gl.period_set_name                              = 'CITCO MONTH'
            AND xbal.ledger_id = gl.ledger_id
            AND xbal.period_name = pv_periodname
-- Added by MA 14/03/2022 to eliminate the zero lines
            AND ( nvl(
                xbal.entered_dr, 0
            ) != 0
                  OR nvl(
                xbal.entered_cr, 0
            ) != 0
                  OR nvl(
                xbal.accounted_dr, 0
            ) != 0
                  OR nvl(
                xbal.accounted_cr, 0
            ) != 0 )
            AND gcc.code_combination_id = xbal.code_combination_id
            AND gcck.code_combination_id = gcc.code_combination_id
--             AND    gcc.segment1 = substr(pv_ou_name,3)
            ;
          --
          -- Cursor to get the ledger names
          -- 
        CURSOR getledger_cur IS
        SELECT
            *
        FROM
            xxmx_core.xxmx_ledger_scope_v;
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
        TYPE ledgername_tt IS
            TABLE OF xxmx_core.xxmx_ledger_scope_v%rowtype INDEX BY BINARY_INTEGER;
        TYPE gl_balances_tt IS
            TABLE OF glbalances_cur%rowtype INDEX BY BINARY_INTEGER;
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
        vt_subentity          CONSTANT xxmx_module_messages.sub_entity%TYPE := 'SUMM_BAL';
        vt_migrationsetid     xxmx_migration_headers.migration_set_id%TYPE;
        cv_procorfuncname     CONSTANT VARCHAR2(30) := 'gl_summary_balances_stg';
        ct_stgtable           CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_summary_balances_stg';
        ct_phase              CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
        vt_listparametercode  xxmx_migration_parameters.parameter_code%TYPE;
        vn_listvaluecount     NUMBER;
        vb_okaytoextract      BOOLEAN;
        vb_periodandyearmatch BOOLEAN;
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
        emptyextractyear_tbl  xxmx_utilities_pkg.g_paramvaluelist_tt;
        extractyear_tbl       xxmx_utilities_pkg.g_paramvaluelist_tt;
        emptyperiodname_tbl   xxmx_utilities_pkg.g_paramvaluelist_tt;
        periodname_tbl        xxmx_utilities_pkg.g_paramvaluelist_tt;
        glbalances_tbl        gl_balances_tt;
        ledgerscope_tbl1      ledgername_tt; 
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
        e_moduleerror EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
    BEGIN
    --
        gvv_progressindicator := '0010';
    --
        vb_okaytoextract := true;
        gvv_returnstatus := '';
        gvt_returnmessage := '';
        vt_migrationsetid := pt_i_migrationsetid;
    --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => vt_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'MODULE',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
    --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
    --
        gvv_progressindicator := '0020';
    --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
    --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => vt_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'DATA',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
    --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
    --
        gvv_progressindicator := '0030';
    --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '  - Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );
    --
        gvv_progressindicator := '0040';
    --
    -- If the Migration Set ID is NULL then the Migration has not been initialized.
    --
        IF vt_migrationsetid IS NOT NULL THEN
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving ledger details from scope table.',
                                                 pt_i_oracleerror       => NULL
            );
               --
            gvv_progressindicator := '0045';
        --
            gvt_migrationsetname := xxmx_utilities_pkg.get_migration_set_name(pt_i_migrationsetid);
        --
               --
            BEGIN
                OPEN getledger_cur;
                FETCH getledger_cur
                BULK COLLECT INTO ledgerscope_tbl1;
                CLOSE getledger_cur;
            EXCEPTION
                WHEN OTHERS THEN
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - err: ' || sqlerrm,
                                                         pt_i_oracleerror       => NULL
                    );
            END;
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Ledger scope count: ' || ledgerscope_tbl1.count(),
                                                 pt_i_oracleerror       => NULL
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
            gvv_progressindicator := '0060';
               --
            vt_listparametercode := 'PERIOD';
            vn_listvaluecount := 0;
            gvv_returnstatus := '';
            gvt_returnmessage := '';
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving "'
                                                                       || vt_listparametercode
                                                                       || '" List from Migration Parameters table:',
                                                 pt_i_oracleerror       => NULL
            );
               --
            periodname_tbl := xxmx_utilities_pkg.get_parameter_value_list(
                                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                                         pt_i_application      => gct_application,
                                                                         pt_i_businessentity   => gct_businessentity,
                                                                         pt_i_subentity        => 'SUMMARY BALANCES',
                                                                         pt_i_parametercode    => vt_listparametercode,
                                                                         pn_o_returncount      => vn_listvaluecount,
                                                                         pv_o_returnstatus     => gvv_returnstatus,
                                                                         pv_o_returnmessage    => gvt_returnmessage
                              );
               --
            IF gvv_returnstatus = 'F' THEN
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'ERROR',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                                           || vt_listparametercode
                                                                           || '" List could not be retrieved.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
                RAISE e_moduleerror;
            ELSE
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - '
                                                                           || vn_listvaluecount
                                                                           || ' values for "'
                                                                           || vt_listparametercode
                                                                           || '" List retrieved.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF;
               --
            IF vn_listvaluecount = 0 THEN
                    --
                vb_okaytoextract := false;
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'WARNING',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - No "'
                                                                           || vt_listparametercode
                                                                           || '" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
            END IF;
               --
               /*
               ** If there are no Extract Parameters in the "xxmx_migration_parameters" table
               ** (those which are there have to be enabled), no balances can be extracted.
               */
               --
            gvv_progressindicator := '0070';
               --
            IF vb_okaytoextract THEN
                    --
                    -- The Extract Parameters were successfully retrieved so now
                    -- initialize the detail record for the GL Balances.
                    --
                xxmx_utilities_pkg.init_migration_details(
                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                         pt_i_application      => gct_application,
                                                         pt_i_businessentity   => gct_businessentity,
                                                         pt_i_subentity        => vt_subentity,
                                                         pt_i_migrationsetid   => vt_migrationsetid,
                                                         pt_i_stagingtable     => ct_stgtable,
                                                         pt_i_extractstartdate => sysdate
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - Staging Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details initialised.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
                    --  loop through the Ledger Name list and for each one:
                    --
                    -- a) Retrieve COA Structure Details pertaining to the Ledger.
                    -- b) Extract the Balances for the Ledger.
                    --
                gvv_progressindicator := '0090';
                    --
                FOR ledgername_idx IN ledgerscope_tbl1.first..ledgerscope_tbl1.last LOOP
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - Loop: Ledger name.',
                                                         pt_i_oracleerror       => NULL
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
                    vb_periodandyearmatch := false;
                              --
                              /*
                              ** Loop through GL Period Names List
                              */
                              --
                    FOR periodname_idx IN periodname_tbl.first..periodname_tbl.last LOOP
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '    - Loop: Period Name ' || periodname_tbl(periodname_idx),
                                                             pt_i_oracleerror       => NULL
                        );
                                   --
                        gvn_existencecount := 0;
                                   --
                                   /*
                                   ** Verify if the current Period Name Parameter exists
                                   ** as a GL Period in the GL_PERIODS table for the current
                                   ** Source Ledger Name and Extract Year Parameters.
                                   */
                                   --
                        gvv_progressindicator := '0130';
                                   --
                                   --
                                   -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                                   --
                        SELECT
                            COUNT(*)
                        INTO gvn_existencecount
                        FROM
                            gl_ledgers_extract gl2,
                            gl_periods_extract gp
                        WHERE
                            1 = 1
                            AND gl2.name = ledgerscope_tbl1(ledgername_idx).ledger_name
                            AND gp.period_set_name = gl2.period_set_name
--                                   AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                            AND gp.period_name = periodname_tbl(periodname_idx);
                                   --
                        IF gvn_existencecount = 0 THEN
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - No data found in EBS (source system) for Year/Period '
--                                                                     ||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                                       || periodname_tbl(periodname_idx)
                                                                                       || ' Foe ledger '
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name,
                                                                 pt_i_oracleerror       => NULL
                            );
                        ELSE
                                        --
                                        /*
                                        ** Current Period Name Parameter exists in the GL_PERIODS table
                                        ** for the current Source Ledger Name and Extract Year so the
                                        ** Balances extract can proceed.
                                        */
                                        --
                            vb_periodandyearmatch := true;
                                        --
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - Extracting "'
                                                                                       || gct_application
                                                                                       || ' '
                                                                                       || vt_subentity
                                                                                       || '" for GL Ledger Name "'
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                                       || '", Period Name "'
                                                                      --||PeriodName_tbl(PeriodName_idx)
                                                                                       || periodname_tbl(periodname_idx)
                                                                                       || '".',
                                                                 pt_i_oracleerror       => NULL
                            );
                                        --
                                        --
                            gvv_progressindicator := '0140';
                                        --
                            OPEN glbalances_cur(
                                               ledgerscope_tbl1(ledgername_idx).ledger_name,
                                               ledgerscope_tbl1(ledgername_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                                  --,PeriodName_tbl(PeriodName_idx),
                                               ,
                                               periodname_tbl(periodname_idx),
                                               ledgerscope_tbl1(ledgername_idx).operating_unit_name
                                 );
                                        --
                            gvv_progressindicator := '0150';
                                        --
                            LOOP
                                             --
                                FETCH glbalances_cur
                                BULK COLLECT INTO glbalances_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                                             --
                                EXIT WHEN glbalances_tbl.count = 0;
                                             --
                                gvv_progressindicator := '0160';
                                             --
                                FORALL glbalances_idx IN 1..glbalances_tbl.count
                                                  --
                                    INSERT INTO xxmx_stg.xxmx_gl_summary_balances_stg (
                                        migration_set_id,
                                        group_id,
                                        migration_set_name,
                                        migration_status,
                                        fusion_status_code,
                                        ledger_name,
                                        ledger_id,
                                        accounting_date,
                                        user_je_source_name,
                                        user_je_category_name,
                                        currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                        ,
                                        date_created,
                                        actual_flag,
                                        segment1,
                                        segment2,
                                        segment3,
                                        segment4,
                                        segment5,
                                        segment6,
                                        segment7,
                                        segment8,
                                        segment9,
                                        segment10,
                                        segment11,
                                        segment12,
                                        segment13,
                                        segment14,
                                        segment15,
                                        segment16,
                                        segment17,
                                        segment18,
                                        segment19,
                                        segment20,
                                        segment21,
                                        segment22,
                                        segment23,
                                        segment24,
                                        segment25,
                                        segment26,
                                        segment27,
                                        segment28,
                                        segment29,
                                        segment30,
                                        entered_dr,
                                        entered_cr,
                                        accounted_dr,
                                        accounted_cr,
                                        reference1,
                                        reference2,
                                        reference3,
                                        reference4,
                                        reference5,
                                        reference6,
                                        reference7,
                                        reference8,
                                        reference9,
                                        reference10,
                                        stat_amount,
                                        user_currency_conversion_type,
                                        currency_conversion_date,
                                        currency_conversion_rate,
                                        attribute_category,
                                        attribute1,
                                        attribute2,
                                        attribute3,
                                        attribute4,
                                        attribute5,
                                        attribute6,
                                        attribute7,
                                        attribute8,
                                        attribute9,
                                        attribute10,
                                        attribute11,
                                        attribute12,
                                        attribute13,
                                        attribute14,
                                        attribute15,
                                        attribute16,
                                        attribute17,
                                        attribute18,
                                        attribute19,
                                        attribute20,
                                        attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                        ,
                                        originating_bal_seg_value,
                                        encumbrance_type_id,
                                        jgzz_recon_ref,
                                        period_name
                                    ) VALUES (
                                        vt_migrationsetid                                             -- migration_set_id
                                        ,
                                        vt_migrationsetid                                             -- group_id
                                        ,
                                        gvt_migrationsetname                                          -- migration_set_name
                                        ,
                                        'EXTRACTED'                                                   -- migration_status
                                        ,
                                        glbalances_tbl(glbalances_idx).fusion_status_code             -- fusion_status_code
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_name                    -- ledger_name
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_id                      --ledger_id
                                        ,
                                        glbalances_tbl(glbalances_idx).accounting_date                -- accounting_date
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_source_name            -- user_je_source_name
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_category_name          -- user_je_category_name
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                        ,
                                        glbalances_tbl(glbalances_idx).date_created    -- date_created
                                        ,
                                        glbalances_tbl(glbalances_idx).actual_flag                    -- actual_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).segment1                       -- segment1
                                        ,
                                        glbalances_tbl(glbalances_idx).segment2                       -- segment2
                                        ,
                                        glbalances_tbl(glbalances_idx).segment3                       -- segment3
                                        ,
                                        glbalances_tbl(glbalances_idx).segment4                       -- segment4
                                        ,
                                        glbalances_tbl(glbalances_idx).segment5                       -- segment5
                                        ,
                                        glbalances_tbl(glbalances_idx).segment6                       -- segment6
                                        ,
                                        glbalances_tbl(glbalances_idx).segment7                       -- segment7
                                        ,
                                        glbalances_tbl(glbalances_idx).segment8                       -- segment8
                                        ,
                                        glbalances_tbl(glbalances_idx).segment9                       -- segment9
                                        ,
                                        glbalances_tbl(glbalances_idx).segment10                      -- segment10
                                        ,
                                        glbalances_tbl(glbalances_idx).segment11                      -- segment11
                                        ,
                                        glbalances_tbl(glbalances_idx).segment12                      -- segment12
                                        ,
                                        glbalances_tbl(glbalances_idx).segment13                      -- segment13
                                        ,
                                        glbalances_tbl(glbalances_idx).segment14                      -- segment14
                                        ,
                                        glbalances_tbl(glbalances_idx).segment15                      -- segment15
                                        ,
                                        glbalances_tbl(glbalances_idx).segment16                      -- segment16
                                        ,
                                        glbalances_tbl(glbalances_idx).segment17                      -- segment17
                                        ,
                                        glbalances_tbl(glbalances_idx).segment18                      -- segment18
                                        ,
                                        glbalances_tbl(glbalances_idx).segment19                      -- segment19
                                        ,
                                        glbalances_tbl(glbalances_idx).segment20                      -- segment20
                                        ,
                                        glbalances_tbl(glbalances_idx).segment21                      -- segment21
                                        ,
                                        glbalances_tbl(glbalances_idx).segment22                      -- segment22
                                        ,
                                        glbalances_tbl(glbalances_idx).segment23                      -- segment23
                                        ,
                                        glbalances_tbl(glbalances_idx).segment24                      -- segment24
                                        ,
                                        glbalances_tbl(glbalances_idx).segment25                      -- segment25
                                        ,
                                        glbalances_tbl(glbalances_idx).segment26                      -- segment26
                                        ,
                                        glbalances_tbl(glbalances_idx).segment27                      -- segment27
                                        ,
                                        glbalances_tbl(glbalances_idx).segment28                      -- segment28
                                        ,
                                        glbalances_tbl(glbalances_idx).segment29                      -- segment29
                                        ,
                                        glbalances_tbl(glbalances_idx).segment30                      -- segment30
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_dr                     -- entered_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_cr                     -- entered_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_dr                   -- accounted_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_cr                   -- accounted_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).reference1                     -- reference1
                                        ,
                                        glbalances_tbl(glbalances_idx).reference2                     -- reference2
                                        ,
                                        glbalances_tbl(glbalances_idx).reference3                     -- reference3
                                        ,
                                        glbalances_tbl(glbalances_idx).reference4                     -- reference4
                                        ,
                                        glbalances_tbl(glbalances_idx).reference5                     -- reference5
                                        ,
                                        glbalances_tbl(glbalances_idx).reference6                     -- reference6
                                        ,
                                        glbalances_tbl(glbalances_idx).reference7                     -- reference7
                                        ,
                                        glbalances_tbl(glbalances_idx).reference8                     -- reference8
                                        ,
                                        glbalances_tbl(glbalances_idx).reference9                     -- reference9
                                        ,
                                        glbalances_tbl(glbalances_idx).reference10                    -- reference10
                                        ,
                                        glbalances_tbl(glbalances_idx).stat_amount                    -- stat_amount
                                        ,
                                        glbalances_tbl(glbalances_idx).user_currency_conversion_type  -- user_currency_conversion_type
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_date       -- currency_conversion_date
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_rate       -- currency_conversion_rate
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category             -- attribute_category
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute1                     -- attribute1
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute2                     -- attribute2
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute3                     -- attribute3
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute4                     -- attribute4
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute5                     -- attribute5
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute6                     -- attribute6
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute7                     -- attribute7
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute8                     -- attribute8
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute9                     -- attribute9
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute10                    -- attribute10
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute11                    -- attribute11
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute12                    -- attribute12
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute13                    -- attribute13
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute14                    -- attribute14
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute15                    -- attribute15
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute16                    -- attribute16
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute17                    -- attribute17
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute18                    -- attribute18
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute19                    -- attribute19
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute20                    -- attribute20
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category3            -- attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                        ,
                                        glbalances_tbl(glbalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                        ,
                                        glbalances_tbl(glbalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                        ,
                                        glbalances_tbl(glbalances_idx).period_name                    -- period_name
                                    );
                                                  --
                                             --** END FORALL
                                             --
                            END LOOP; --** GLBalances_cur BULK COLLECT LOOP
                                        --
                            gvv_progressindicator := '0170';
                                        --
                            CLOSE glbalances_cur;
                                        --
                        END IF; --** IF gvn_ExistenceCount >0
                                   --
                    END LOOP; --** PeriodName_tbl LOOP
                              --
                    gvv_progressindicator := '0180';
                              --
                    IF NOT vb_periodandyearmatch THEN
                                   --
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                                   || '" and the Period Set associated with Source Ledger Name "'
                                                                                   || ledgerscope_tbl1(ledgername_idx).ledger_name
                                                                                   || '".  No Balances were extracted for this year.',
                                                             pt_i_oracleerror       => NULL
                        );
                                   --
                    END IF; --** IF NOT vb_PeriodAndYearMatch
                              --
--                         END LOOP; --** ExtractYear_tbl LOOP
                         --
                END LOOP; --** Ledger details LOOP
                    --
                gvv_progressindicator := '0190';
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all GL Ledgers in the Migration Set.
                    */
                    --
                gvn_rowcount := xxmx_utilities_pkg.get_row_count(
                                                                gct_stgschema,
                                                                ct_stgtable,
                                                                vt_migrationsetid
                                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Extraction complete.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
                    --
                COMMIT;
                    --
                    --** Update the migration details (Migration status will be automatically determined
                    --** in the called procedure dependant on the Phase and if an Error Message has been
                    --** passed).
                    --
                gvv_progressindicator := '0200';
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
                    --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
                    --**
                    --**                  Removed "entity" from procedure_name.
                    --
                xxmx_utilities_pkg.upd_migration_details(
                                                        pt_i_migrationsetid          => vt_migrationsetid,
                                                        pt_i_businessentity          => gct_businessentity,
                                                        pt_i_subentity               => vt_subentity,
                                                        pt_i_phase                   => ct_phase,
                                                        pt_i_extractcompletiondate   => sysdate,
                                                        pt_i_extractrowcount         => gvn_rowcount,
                                                        pt_i_transformtable          => NULL,
                                                        pt_i_transformstartdate      => NULL,
                                                        pt_i_transformcompletiondate => NULL,
                                                        pt_i_exportfilename          => NULL,
                                                        pt_i_exportstartdate         => NULL,
                                                        pt_i_exportcompletiondate    => NULL,
                                                        pt_i_exportrowcount          => NULL,
                                                        pt_i_errorflag               => NULL
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Migration Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details updated.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF; --** vn_ListEntryCount > 0
               --
        ELSE
               --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- Migration Set not initialized.';
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
               --
        WHEN e_moduleerror THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            RAISE;
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted at after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
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
    PROCEDURE gl_detail_balances_stg (
        pt_i_migrationsetid IN xxmx_migration_headers.migration_set_id%TYPE,
        pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE
    ) IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the detail GL balance
          --
        CURSOR glbalances_cur (
            pv_ledgername   VARCHAR2,
            pv_country_code VARCHAR2
--                      ,pv_ExtractYear                  VARCHAR2
            ,
            pv_periodname   VARCHAR2,
            pv_ou_name      VARCHAR2
        ) IS
               --
               --
        SELECT
            'NEW'                         fusion_status_code,
            gl.name                       ledger_name,
            gl.ledger_id                  ledger_id
--                      ,(SELECT gp.end_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = gjh.period_name
--                          AND gp.period_set_name = gl.period_set_name)        accounting_date
            ,
            gjh.default_effective_date    accounting_date,
            gjst.user_je_source_name      user_je_source_name,
            gjct.user_je_category_name    user_je_category_name,
            gjh.currency_code             currency_code
--                      ,(SELECT gp.start_date
--                        FROM   gl_periods_extract gp
--                        WHERE  gp.period_name = gjh.period_name
--                        AND gp.period_set_name = gl.period_set_name)     date_created
            ,
            gjh.date_created              date_created,
            'A'                           actual_flag,
            gcc.segment1                  segment1,
            gcc.segment2                  segment2,
            gcc.segment3                  segment3,
            gcc.segment4                  segment4,
            gcc.segment5                  segment5,
            gcc.segment6                  segment6,
            gcc.segment7                  segment7,
            gcc.segment8                  segment8,
            gcc.segment9                  segment9,
            gcc.segment10                 segment10,
            gcc.segment11                 segment11,
            gcc.segment12                 segment12,
            gcc.segment13                 segment13,
            gcc.segment14                 segment14,
            gcc.segment15                 segment15,
            gcc.segment16                 segment16,
            gcc.segment17                 segment17,
            gcc.segment18                 segment18,
            gcc.segment19                 segment19,
            gcc.segment20                 segment20,
            gcc.segment21                 segment21,
            gcc.segment22                 segment22,
            gcc.segment23                 segment23,
            gcc.segment24                 segment24,
            gcc.segment25                 segment25,
            gcc.segment26                 segment26,
            gcc.segment27                 segment27,
            gcc.segment28                 segment28,
            gcc.segment29                 segment29,
            gcc.segment30                 segment30,
            gjl.entered_dr                entered_dr,
            gjl.entered_cr                entered_cr,
            gjl.accounted_dr              accounted_dr,
            gjl.accounted_cr              accounted_cr
--                      ,'ACTUAL BALANCE MIGRATION'
--                     ||' '
--                     ||gjh.period_name                                  reference1                        -- CV040 states this should be the Batch Name
            ,
            gjb.name                      reference1 -- added by Somya on 11-apr-2022 
                      --,''                                                reference2                        -- CV040 states this should be the Batch Description
            ,
            gjb.description               reference2 -- added by Somya on 11-apr-2022
            ,
            ''                            reference3                        -- CV040 does not reference this (FBDI Template has no column for it)
--                      ,'ACTUAL BALANCE MIGRATION'                                                          
--                     ||' '                                                                                 
--                     ||gjh.period_name                                   reference4                      -- CV040 states this should be the Journal Entry Name
            ,
            gjh.name                      reference4 -- added by Somya on 11-apr-2022
            ,
            gjh.description               reference5                        -- CV040 states this should be the Journal Entry Description
            ,
            gjh.external_reference        reference6                        -- CV040 states this should be the Journal Entry Reference
                      --,gjh.accrual_rev_flag                              reference7                        -- CV040 states this should be the Journal Entry Reversal Flag
                      --,gjh.accrual_rev_period_name                       reference8                        -- CV040 states this should be the Journal entry Reversal Period
                      --,gjh.accrual_rev_change_sign_flag                  reference9                        -- CV040 states this should be the Journal Reversal Method
            ,
            CASE
            WHEN gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
                 AND gjst.user_je_source_name <> 'Cost Management'
                        THEN
            gjh.accrual_rev_flag
            WHEN ( gjst.user_je_source_name = 'Cost Management'
                   AND gjh.je_category = 'Accrual' )
                 AND gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND EXISTS (
                SELECT
                    1
                FROM
                    gl_import_references@xxmx_extract gir,
                    xla_ae_lines@xxmx_extract         xal,
                    xla_ae_headers@xxmx_extract       xah
                WHERE
                    1 = 1
                    AND gjl.je_header_id = gir.je_header_id
                    AND gjl.je_line_num = gir.je_line_num
                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                    AND gir.gl_sl_link_id = xal.gl_sl_link_id
                    AND xah.ae_header_id = xal.ae_header_id
                    AND xah.application_id = xal.application_id
                    AND xah.accrual_reversal_flag = 'Y'
                    AND xah.parent_ae_header_id IS NULL
            ) THEN
            gjh.accrual_rev_flag
            WHEN gjh.parent_je_header_id IS NOT NULL
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.accrual_rev_period_name IS NULL --and gl.name='India Local' 
                 AND EXISTS (
                SELECT
                    1
                FROM
                    (
                        SELECT
                            period_name,
                            accrual_rev_period_name,
                            accrual_rev_status,
                            accrual_rev_flag,
                            je_category
                        FROM
                            gl_je_headers_extract gjh1
                        WHERE
                            gjh1.je_header_id = gjh.parent_je_header_id
                    ) a
                WHERE
                    a.period_name = (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_period_name IS NOT NULL
                    AND a.accrual_rev_status IS NULL
                    AND a.accrual_rev_period_name <> (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_flag = 'Y'
                    AND a.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
            ) THEN
            (
                SELECT
                    accrual_rev_flag
                FROM
                    gl_je_headers_extract gjh1
                WHERE
                    gjh1.je_header_id = gjh.parent_je_header_id
            )
            ELSE
            NULL
            END                           reference7,
            CASE
            WHEN gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
                 AND gjst.user_je_source_name <> 'Cost Management'
                        THEN
            initcap(
                gjh.accrual_rev_period_name
            )
            WHEN ( gjst.user_je_source_name = 'Cost Management'
                   AND gjh.je_category = 'Accrual' )
                 AND gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND EXISTS (
                SELECT
                    1
                FROM
                    gl_import_references@xxmx_extract gir,
                    xla_ae_lines@xxmx_extract         xal,
                    xla_ae_headers@xxmx_extract       xah
                WHERE
                    1 = 1
                    AND gjl.je_header_id = gir.je_header_id
                    AND gjl.je_line_num = gir.je_line_num
                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                    AND gir.gl_sl_link_id = xal.gl_sl_link_id
                    AND xah.ae_header_id = xal.ae_header_id
                    AND xah.application_id = xal.application_id
                    AND xah.accrual_reversal_flag = 'Y'
                    AND xah.parent_ae_header_id IS NULL
            ) THEN
            initcap(
                gjh.accrual_rev_period_name
            )
            WHEN gjh.parent_je_header_id IS NOT NULL
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.accrual_rev_period_name IS NULL--and gl.name='India Local' 
                 AND EXISTS (
                SELECT
                    1
                FROM
                    (
                        SELECT
                            period_name,
                            accrual_rev_period_name,
                            accrual_rev_status,
                            accrual_rev_flag,
                            je_category
                        FROM
                            gl_je_headers_extract gjh1
                        WHERE
                            gjh1.je_header_id = gjh.parent_je_header_id
                    ) a
                WHERE
                    a.period_name = (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_period_name IS NOT NULL
                    AND a.accrual_rev_status IS NULL
                    AND a.accrual_rev_period_name <> (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_flag = 'Y'
                    AND a.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
            ) THEN
            (
                SELECT
                    initcap(accrual_rev_period_name)
                FROM
                    gl_je_headers_extract gjh1
                WHERE
                    gjh1.je_header_id = gjh.parent_je_header_id
            )
            ELSE
            NULL
            END                           reference8,
            CASE
            WHEN gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
                 AND gjst.user_je_source_name <> 'Cost Management'
                        THEN
            'N'
            WHEN ( gjst.user_je_source_name = 'Cost Management'
                   AND gjh.je_category = 'Accrual' )
                 AND gjh.period_name = (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_period_name IS NOT NULL
                 AND gjh.accrual_rev_status IS NULL
                 AND gjh.accrual_rev_period_name <> (
                SELECT
                    parameter_value
                FROM
                    xxmx_migration_parameters
                WHERE
                    sub_entity = 'DETAILED BALANCES'
                    AND parameter_code = 'LAST_PERIOD_FLAG'
                    AND enabled_flag = 'Y'
            )
                 AND gjh.accrual_rev_flag = 'Y'
                 AND EXISTS (
                SELECT
                    1
                FROM
                    gl_import_references@xxmx_extract gir,
                    xla_ae_lines@xxmx_extract         xal,
                    xla_ae_headers@xxmx_extract       xah
                WHERE
                    1 = 1
                    AND gjl.je_header_id = gir.je_header_id
                    AND gjl.je_line_num = gir.je_line_num
                    AND gir.gl_sl_link_table = xal.gl_sl_link_table
                    AND gir.gl_sl_link_id = xal.gl_sl_link_id
                    AND xah.ae_header_id = xal.ae_header_id
                    AND xah.application_id = xal.application_id
                    AND xah.accrual_reversal_flag = 'Y'
                    AND xah.parent_ae_header_id IS NULL
            ) THEN
            'N'
            WHEN gjh.parent_je_header_id IS NOT NULL
                 AND gjh.accrual_rev_flag = 'Y'
                 AND gjh.accrual_rev_period_name IS NULL --and gl.name='India Local' 
                 AND EXISTS (
                SELECT
                    1
                FROM
                    (
                        SELECT
                            period_name,
                            accrual_rev_period_name,
                            accrual_rev_status,
                            accrual_rev_flag,
                            je_category
                        FROM
                            gl_je_headers_extract gjh1
                        WHERE
                            gjh1.je_header_id = gjh.parent_je_header_id
                    ) a
                WHERE
                    a.period_name = (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_period_name IS NOT NULL
                    AND a.accrual_rev_status IS NULL
                    AND a.accrual_rev_period_name <> (
                        SELECT
                            parameter_value
                        FROM
                            xxmx_migration_parameters
                        WHERE
                            sub_entity = 'DETAILED BALANCES'
                            AND parameter_code = 'LAST_PERIOD_FLAG'
                            AND enabled_flag = 'Y'
                    )
                    AND a.accrual_rev_flag = 'Y'
                    AND a.je_category IN ( 'Accrual', 'Rebook', 'Revaluation', 'T24 Reversing', 'Bank YTD Reversing' )
            ) THEN
            'N'
            ELSE
            NULL
            END                           reference9,
            gjl.description               reference10                       -- CV040 states this should be the Journal entry Line Description
            ,
            gjl.stat_amount               stat_amount
--                      ,gjh.currency_conversion_type                      user_currency_conversion_type
                  --    ,gldct.user_conversion_type                        user_currency_conversion_type    --commented by Laxmikanth 
            ,
            decode(
                gldct.user_conversion_type, NULL, NULL, 'User'
            )                             user_currency_conversion_type
                      --,gjh.currency_conversion_date                    currency_conversion_date
                    --  ,gjh.currency_conversion_date                      currency_conversion_date		--commented by Laxmikanth 
            ,
            decode(
                gjh.currency_conversion_rate, NULL, NULL, gjh.currency_conversion_date
            )                             currency_conversion_date,
            gjh.currency_conversion_rate  currency_conversion_rate
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
            ,
            NULL                          attribute_category,
            NULL                          attribute1 -- added by Somya on 11-Apr-22
            ,
            NULL                          attribute2,
            NULL                          attribute3,
            NULL                          attribute4,
            NULL                          attribute5,
            NULL                          attribute6,
            NULL                          attribute7,
            NULL                          attribute8,
            NULL                          attribute9,
            NULL                          attribute10,
            NULL                          attribute11,
            NULL                          attribute12,
            NULL                          attribute13 -- added by Somya on 13-May-22
            ,
            NULL                          attribute14,
            NULL                          attribute15,
            NULL                          attribute16 -- added by Somya on 13-May-22
            ,
            NULL                          attribute17,
            NULL                          attribute18,
            NULL                          attribute19,
            NULL                          attribute20,
            NULL                          attribute_category3
                      -----------

-- MA 27/04/2022 no longer required
--                      ,gjb.average_journal_flag                          average_journal_flag
            ,
            gjh.originating_bal_seg_value originating_bal_seg_value,
            ''                            encumbrance_type_id,
            ''                            jgzz_recon_ref
--                      ,(case when gjh.period_name like 'ADJ%' then
--                        replace(gjh.period_name,'ADJ','13_Dec')
--                        else
--                        initcap(gjh.period_name)
--                        end)                                   period_name,
            ,
            initcap(
                gjh.period_name
            )                             period_name,
            gjh.je_header_id
            || '_'
            || gjl.je_line_num            header_line, -- added by Somya on 20-Jul-22
            gcc.concatenated_segments     old_ccid -- added by Somya on 20-Jul-22
        FROM
            gl_je_sources_tl_ext          gjst,
            gl_je_categories_tl_ext       gjct,
            gl_ledgers_extract            gl,
            gl_je_headers_extract         gjh,
            gl_je_lines_extract           gjl,
            gl_je_batches_extract         gjb,
            gl_code_combinations_extract  gcc,
            gl_daily_conversion_types_ext gldct
        WHERE
            gl.name = pv_ledgername
--             and    gcc.segment1                                    = pv_country_code
--             AND     gl.period_set_name                              = 'CITCO MONTH'
            AND gjh.ledger_id = gl.ledger_id
            AND gjh.period_name = pv_periodname
            AND gjh.actual_flag = 'A'
            AND gjl.je_header_id = gjh.je_header_id
            AND gjb.je_batch_id = gjh.je_batch_id
            AND gjl.code_combination_id = gcc.code_combination_id
            AND gjh.je_source = gjst.je_source_name
            AND gjh.je_category = gjct.je_category_name
            AND gjl.status = 'P'
            AND gldct.conversion_type = gjh.currency_conversion_type;

          --
          -- Cursor to get the ledger names
          -- 
        CURSOR getledger_cur IS
        SELECT
            *
        FROM
            xxmx_core.xxmx_ledger_scope_v;

          --** END CURSOR **          
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
        TYPE ledgername_tt IS
            TABLE OF xxmx_core.xxmx_ledger_scope_v%rowtype INDEX BY BINARY_INTEGER;
        TYPE gl_balances_tt IS
            TABLE OF glbalances_cur%rowtype INDEX BY BINARY_INTEGER;
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
        cv_procorfuncname     CONSTANT VARCHAR2(30) := 'gl_detail_balances_stg';
        ct_stgtable           CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_detail_balances_stg';
        ct_phase              CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
        vt_subentity          CONSTANT xxmx_module_messages.sub_entity%TYPE := 'DETAIL_BAL';
        vt_migrationsetid     xxmx_migration_headers.migration_set_id%TYPE;
        vt_listparametercode  xxmx_migration_parameters.parameter_code%TYPE;
        vn_listvaluecount     NUMBER;
        vb_okaytoextract      BOOLEAN;
        vb_periodandyearmatch BOOLEAN;
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
        emptyextractyear_tbl  xxmx_utilities_pkg.g_paramvaluelist_tt;
        extractyear_tbl       xxmx_utilities_pkg.g_paramvaluelist_tt;
        emptyperiodname_tbl   xxmx_utilities_pkg.g_paramvaluelist_tt;
        periodname_tbl        xxmx_utilities_pkg.g_paramvaluelist_tt;
        glbalances_tbl        gl_balances_tt;
        ledgerscope_tbl1      ledgername_tt; 
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
        e_moduleerror EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
    BEGIN
    --
        gvv_progressindicator := '0010';
    --
        vb_okaytoextract := true;
        gvv_returnstatus := '';
        gvt_returnmessage := '';
        vt_migrationsetid := pt_i_migrationsetid;
    --
    --
        IF gvv_returnstatus = 'F' THEN
        --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
        --
            RAISE e_moduleerror;
        --
        END IF;
    --
        gvv_progressindicator := '0020';
          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
          --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => vt_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'DATA',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0030';
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '  - Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );
          --
        gvv_progressindicator := '0040';
          --
          -- If the Migration Set ID is NULL then the Migration has not been initialized.
          --
        IF vt_migrationsetid IS NOT NULL THEN
               --
               -- The Migration Set has been initialized so not retrieve the parameters for extracting GL Balances:
               --
               -- Retrieve GL Ledger Names List
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving ledger details from scope table.',
                                                 pt_i_oracleerror       => NULL
            );
               --
            gvv_progressindicator := '0045';
        --
            gvt_migrationsetname := xxmx_utilities_pkg.get_migration_set_name(pt_i_migrationsetid);
        --
            BEGIN
                OPEN getledger_cur;
                FETCH getledger_cur
                BULK COLLECT INTO ledgerscope_tbl1;
                CLOSE getledger_cur;
            EXCEPTION
                WHEN OTHERS THEN
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - err: ' || sqlerrm,
                                                         pt_i_oracleerror       => NULL
                    );
            END;
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => 'DETAILED BALANCES',
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Ledger scope count: ' || ledgerscope_tbl1.count(),
                                                 pt_i_oracleerror       => NULL
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
            gvv_progressindicator := '0060';
               --
            vt_listparametercode := 'PERIOD';
            vn_listvaluecount := 0;
            gvv_returnstatus := '';
            gvt_returnmessage := '';
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '    - Retrieving "'
                                                                       || vt_listparametercode
                                                                       || '" List from Migration Parameters table:',
                                                 pt_i_oracleerror       => NULL
            );
               --
            periodname_tbl := xxmx_utilities_pkg.get_parameter_value_list(
                                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                                         pt_i_application      => gct_application,
                                                                         pt_i_businessentity   => gct_businessentity,
                                                                         pt_i_subentity        => 'DETAILED BALANCES',
                                                                         pt_i_parametercode    => vt_listparametercode,
                                                                         pn_o_returncount      => vn_listvaluecount,
                                                                         pv_o_returnstatus     => gvv_returnstatus,
                                                                         pv_o_returnmessage    => gvt_returnmessage
                              );
               --
            IF gvv_returnstatus = 'F' THEN
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'ERROR',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - Oracle error in called procedure "xxmx_utilities_pkg.get_parameter_value_list".  "'
                                                                           || vt_listparametercode
                                                                           || '" List could not be retrieved.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
                RAISE e_moduleerror;
                    --
            ELSE
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '      - '
                                                                           || vn_listvaluecount
                                                                           || ' values for "'
                                                                           || vt_listparametercode
                                                                           || '" List retrieved.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF;
               --
            IF vn_listvaluecount = 0 THEN
                    --
                vb_okaytoextract := false;
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'WARNING',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - No "'
                                                                           || vt_listparametercode
                                                                           || '" parameters defined in "xxmx_migration_parameters" table.  GL Balances can not be extracted at this time.',
                                                     pt_i_oracleerror       => gvt_returnmessage
                );
                    --
            END IF;
               --
               /*
               ** If there are no Extract Parameters in the "xxmx_migration_parameters" table
               ** (those which are there have to be enabled), no balances can be extracted.
               */
               --
            gvv_progressindicator := '0070';
               --
            IF vb_okaytoextract THEN
                    --
                    --
                    -- The Extract Parameters were successfully retrieved so now
                    -- initialize the detail record for the GL Balances.
                    --
                xxmx_utilities_pkg.init_migration_details(
                                                         pt_i_applicationsuite => gct_applicationsuite,
                                                         pt_i_application      => gct_application,
                                                         pt_i_businessentity   => gct_businessentity,
                                                         pt_i_subentity        => vt_subentity,
                                                         pt_i_migrationsetid   => vt_migrationsetid,
                                                         pt_i_stagingtable     => ct_stgtable,
                                                         pt_i_extractstartdate => sysdate
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '    - Staging Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details initialised.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
                    --
                    --  loop through the Ledger Name list and for each one:
                    --
                    -- a) Retrieve COA Structure Details pertaining to the Ledger.
                    -- b) Extract the Balances for the Ledger.
                    --
                gvv_progressindicator := '0090';
                    --
                FOR ledgername_idx IN ledgerscope_tbl1.first..ledgerscope_tbl1.last LOOP
                    xxmx_utilities_pkg.log_module_message(
                                                         pt_i_applicationsuite  => gct_applicationsuite,
                                                         pt_i_application       => gct_application,
                                                         pt_i_businessentity    => gct_businessentity,
                                                         pt_i_subentity         => vt_subentity,
                                                         pt_i_migrationsetid    => vt_migrationsetid,
                                                         pt_i_phase             => ct_phase,
                                                         pt_i_severity          => 'NOTIFICATION',
                                                         pt_i_packagename       => gcv_packagename,
                                                         pt_i_procorfuncname    => cv_procorfuncname,
                                                         pt_i_progressindicator => gvv_progressindicator,
                                                         pt_i_modulemessage     => '    - Loop: Ledger name.',
                                                         pt_i_oracleerror       => NULL
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
                    vb_periodandyearmatch := false;
                              --
                              -- Loop through GL Period Names List
                              --
                    FOR periodname_idx IN periodname_tbl.first..periodname_tbl.last LOOP
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '    - Loop: Period Name ' || periodname_tbl(periodname_idx),
                                                             pt_i_oracleerror       => NULL
                        );
                                   --
                        gvn_existencecount := 0;
                                   --
                                   -- Verify if the current Period Name Parameter exists in gl_ledgers and gl_periods tables
                                   --
                        SELECT
                            COUNT(*)
                        INTO gvn_existencecount
                        FROM
                            gl_ledgers_extract gl2,
                            gl_periods_extract gp
                        WHERE
                            1 = 1
                            AND gl2.name = ledgerscope_tbl1(ledgername_idx).ledger_name
                            AND gp.period_set_name = gl2.period_set_name
--                                   AND     gp.period_year     = ExtractYear_tbl(ExtractYear_idx)
                            AND gp.period_name = periodname_tbl(periodname_idx);
                                   --
                        IF gvn_existencecount = 0 THEN
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - No data found in EBS (source system) for Year/Period '
--                                                                     ||ExtractYear_tbl(ExtractYear_idx)||'\'
                                                                                       || periodname_tbl(periodname_idx)
                                                                                       || ' Foe ledger '
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name,
                                                                 pt_i_oracleerror       => NULL
                            );
                        ELSE
                                        -- Current Period Name Parameter exists in the GL_PERIODS table
                                        -- for the current Source Ledger Name and Extract Year so the
                                        -- Balances extract can proceed.
                            vb_periodandyearmatch := true;
                                        --
                            xxmx_utilities_pkg.log_module_message(
                                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                                 pt_i_application       => gct_application,
                                                                 pt_i_businessentity    => gct_businessentity,
                                                                 pt_i_subentity         => vt_subentity,
                                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                                 pt_i_phase             => ct_phase,
                                                                 pt_i_severity          => 'NOTIFICATION',
                                                                 pt_i_packagename       => gcv_packagename,
                                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                                 pt_i_progressindicator => gvv_progressindicator,
                                                                 pt_i_modulemessage     => '      - Extracting "'
                                                                                       || gct_application
                                                                                       || ' '
                                                                                       || vt_subentity
                                                                                       || '" for GL Ledger Name "'
                                                                                       || ledgerscope_tbl1(ledgername_idx).ledger_name
--                                                                      ||'" and Year "'
--                                                                      ||ExtractYear_tbl(ExtractYear_idx)
                                                                                       || '", Period Name "'
                                                                                       || periodname_tbl(periodname_idx)
                                                                      --||pt_i_period_name
                                                                                       || '".',
                                                                 pt_i_oracleerror       => NULL
                            );
                                        --
                                        --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
                                        --**                  by a Synonym in the xxmx_core schema to that table.
                                        --
                            gvv_progressindicator := '0140';
                                        --
                            OPEN glbalances_cur(
                                               ledgerscope_tbl1(ledgername_idx).ledger_name,
                                               ledgerscope_tbl1(ledgername_idx).country_code
--                                                  ,ExtractYear_tbl(ExtractYear_idx)
                                               ,
                                               periodname_tbl(periodname_idx)
                                                  --,pt_i_period_name
                                               ,
                                               ledgerscope_tbl1(ledgername_idx).operating_unit_name
                                 );
                                        --
                            gvv_progressindicator := '0150';
                                        --
                            LOOP
                                             --
                                FETCH glbalances_cur
                                BULK COLLECT INTO glbalances_tbl LIMIT xxmx_utilities_pkg.gcn_bulkcollectlimit;
                                             --
                                EXIT WHEN glbalances_tbl.count = 0;
                                             --
                                gvv_progressindicator := '0160';
                                             --
                                FORALL glbalances_idx IN 1..glbalances_tbl.count
                                                  --
                                    INSERT INTO xxmx_stg.xxmx_gl_detail_balances_stg (
                                        migration_set_id,
                                        group_id,
                                        migration_set_name,
                                        migration_status,
                                        fusion_status_code,
                                        ledger_name,
                                        ledger_id,
                                        accounting_date,
                                        user_je_source_name,
                                        user_je_category_name,
                                        currency_code
-- MA 27/04/2022 become date_created
--                                                              ,journal_entry_creation_date
                                        ,
                                        date_created,
                                        actual_flag,
                                        segment1,
                                        segment2,
                                        segment3,
                                        segment4,
                                        segment5,
                                        segment6,
                                        segment7,
                                        segment8,
                                        segment9,
                                        segment10,
                                        segment11,
                                        segment12,
                                        segment13,
                                        segment14,
                                        segment15,
                                        segment16,
                                        segment17,
                                        segment18,
                                        segment19,
                                        segment20,
                                        segment21,
                                        segment22,
                                        segment23,
                                        segment24,
                                        segment25,
                                        segment26,
                                        segment27,
                                        segment28,
                                        segment29,
                                        segment30,
                                        entered_dr,
                                        entered_cr,
                                        accounted_dr,
                                        accounted_cr,
                                        reference1,
                                        reference2,
                                        reference3,
                                        reference4,
                                        reference5,
                                        reference6,
                                        reference7,
                                        reference8,
                                        reference9,
                                        reference10,
                                        stat_amount,
                                        user_currency_conversion_type,
                                        currency_conversion_date,
                                        currency_conversion_rate,
                                        attribute_category,
                                        attribute1,
                                        attribute2,
                                        attribute3,
                                        attribute4,
                                        attribute5,
                                        attribute6,
                                        attribute7,
                                        attribute8,
                                        attribute9,
                                        attribute10,
                                        attribute11,
                                        attribute12,
                                        attribute13,
                                        attribute14,
                                        attribute15,
                                        attribute16,
                                        attribute17,
                                        attribute18,
                                        attribute19,
                                        attribute20,
                                        attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,average_journal_flag
                                        ,
                                        originating_bal_seg_value,
                                        encumbrance_type_id,
                                        jgzz_recon_ref,
                                        period_name,
                                        global_attribute19,
                                        global_attribute20
                                    ) VALUES (
                                        vt_migrationsetid                                             -- migration_set_id
                                        ,
                                        vt_migrationsetid -- group_id
                                        ,
                                        gvt_migrationsetname                                          -- migration_set_name
                                        ,
                                        'EXTRACTED'                                                   -- migration_status
                                        ,
                                        glbalances_tbl(glbalances_idx).fusion_status_code             -- fusion_status_code
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_name                    -- ledger_name
                                        ,
                                        glbalances_tbl(glbalances_idx).ledger_id                      -- ledger_id
                                        ,
                                        glbalances_tbl(glbalances_idx).accounting_date                -- accounting_date
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_source_name            -- user_je_source_name
                                        ,
                                        glbalances_tbl(glbalances_idx).user_je_category_name          -- user_je_category_name
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_code                  -- currency_code
-- MA 27/04/2022 now date_created
--                                                              ,GLBalances_tbl(GLBalances_idx).journal_entry_creation_date    -- journal_entry_creation_date
                                        ,
                                        glbalances_tbl(glbalances_idx).date_created    -- date_created
                                        ,
                                        glbalances_tbl(glbalances_idx).actual_flag                    -- actual_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).segment1                       -- segment1
                                        ,
                                        glbalances_tbl(glbalances_idx).segment2                       -- segment2
                                        ,
                                        glbalances_tbl(glbalances_idx).segment3                       -- segment3
                                        ,
                                        glbalances_tbl(glbalances_idx).segment4                       -- segment4
                                        ,
                                        glbalances_tbl(glbalances_idx).segment5                       -- segment5
                                        ,
                                        glbalances_tbl(glbalances_idx).segment6                       -- segment6
                                        ,
                                        glbalances_tbl(glbalances_idx).segment7                       -- segment7
                                        ,
                                        glbalances_tbl(glbalances_idx).segment8                       -- segment8
                                        ,
                                        glbalances_tbl(glbalances_idx).segment9                       -- segment9
                                        ,
                                        glbalances_tbl(glbalances_idx).segment10                      -- segment10
                                        ,
                                        glbalances_tbl(glbalances_idx).segment11                      -- segment11
                                        ,
                                        glbalances_tbl(glbalances_idx).segment12                      -- segment12
                                        ,
                                        glbalances_tbl(glbalances_idx).segment13                      -- segment13
                                        ,
                                        glbalances_tbl(glbalances_idx).segment14                      -- segment14
                                        ,
                                        glbalances_tbl(glbalances_idx).segment15                      -- segment15
                                        ,
                                        glbalances_tbl(glbalances_idx).segment16                      -- segment16
                                        ,
                                        glbalances_tbl(glbalances_idx).segment17                      -- segment17
                                        ,
                                        glbalances_tbl(glbalances_idx).segment18                      -- segment18
                                        ,
                                        glbalances_tbl(glbalances_idx).segment19                      -- segment19
                                        ,
                                        glbalances_tbl(glbalances_idx).segment20                      -- segment20
                                        ,
                                        glbalances_tbl(glbalances_idx).segment21                      -- segment21
                                        ,
                                        glbalances_tbl(glbalances_idx).segment22                      -- segment22
                                        ,
                                        glbalances_tbl(glbalances_idx).segment23                      -- segment23
                                        ,
                                        glbalances_tbl(glbalances_idx).segment24                      -- segment24
                                        ,
                                        glbalances_tbl(glbalances_idx).segment25                      -- segment25
                                        ,
                                        glbalances_tbl(glbalances_idx).segment26                      -- segment26
                                        ,
                                        glbalances_tbl(glbalances_idx).segment27                      -- segment27
                                        ,
                                        glbalances_tbl(glbalances_idx).segment28                      -- segment28
                                        ,
                                        glbalances_tbl(glbalances_idx).segment29                      -- segment29
                                        ,
                                        glbalances_tbl(glbalances_idx).segment30                      -- segment30
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_dr                     -- entered_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).entered_cr                     -- entered_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_dr                   -- accounted_dr
                                        ,
                                        glbalances_tbl(glbalances_idx).accounted_cr                   -- accounted_cr
                                        ,
                                        glbalances_tbl(glbalances_idx).reference1                     -- reference1
                                        ,
                                        glbalances_tbl(glbalances_idx).reference2                     -- reference2
                                        ,
                                        glbalances_tbl(glbalances_idx).reference3                     -- reference3
                                        ,
                                        glbalances_tbl(glbalances_idx).reference4                     -- reference4
                                        ,
                                        glbalances_tbl(glbalances_idx).reference5                     -- reference5
                                        ,
                                        glbalances_tbl(glbalances_idx).reference6                     -- reference6
                                        ,
                                        glbalances_tbl(glbalances_idx).reference7                     -- reference7
                                        ,
                                        glbalances_tbl(glbalances_idx).reference8                     -- reference8
                                        ,
                                        glbalances_tbl(glbalances_idx).reference9                     -- reference9
                                        ,
                                        glbalances_tbl(glbalances_idx).reference10                    -- reference10
                                        ,
                                        glbalances_tbl(glbalances_idx).stat_amount                    -- stat_amount
                                        ,
                                        glbalances_tbl(glbalances_idx).user_currency_conversion_type  -- user_currency_conversion_type
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_date       -- currency_conversion_date
                                        ,
                                        glbalances_tbl(glbalances_idx).currency_conversion_rate       -- currency_conversion_rate
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category             -- attribute_category
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute1                     -- attribute1
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute2                     -- attribute2
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute3                     -- attribute3
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute4                     -- attribute4
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute5                     -- attribute5
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute6                     -- attribute6
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute7                     -- attribute7
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute8                     -- attribute8
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute9                     -- attribute9
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute10                    -- attribute10
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute11                    -- attribute11
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute12                    -- attribute12
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute13                    -- attribute13
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute14                    -- attribute14
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute15                    -- attribute15
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute16                    -- attribute16
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute17                    -- attribute17
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute18                    -- attribute18
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute19                    -- attribute19
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute20                    -- attribute20
                                        ,
                                        glbalances_tbl(glbalances_idx).attribute_category3            -- attribute_category3
-- MA 27/04/2022 no longer required
--                                                              ,GLBalances_tbl(GLBalances_idx).average_journal_flag           -- average_journal_flag
                                        ,
                                        glbalances_tbl(glbalances_idx).originating_bal_seg_value      -- originating_bal_seg_value
                                        ,
                                        glbalances_tbl(glbalances_idx).encumbrance_type_id            -- encumbrance_type_id
                                        ,
                                        glbalances_tbl(glbalances_idx).jgzz_recon_ref                 -- jgzz_recon_ref
                                        ,
                                        glbalances_tbl(glbalances_idx).period_name                    -- period_name
                                        ,
                                        glbalances_tbl(glbalances_idx).header_line,
                                        glbalances_tbl(glbalances_idx).old_ccid
                                    );
                                                  --
                                             --** END FORALL
                                             --
                            END LOOP; --** GLBalances_cur BULK COLLECT LOOP
                                        --
                            gvv_progressindicator := '0170';
                                        --
                            CLOSE glbalances_cur;
                                        --
                        END IF; --** IF gvn_ExistenceCount >0
                                   --
                    END LOOP; --** PeriodName_tbl LOOP
                              --
                    gvv_progressindicator := '0180';
                              --
                    IF NOT vb_periodandyearmatch THEN
                                   --
                        xxmx_utilities_pkg.log_module_message(
                                                             pt_i_applicationsuite  => gct_applicationsuite,
                                                             pt_i_application       => gct_application,
                                                             pt_i_businessentity    => gct_businessentity,
                                                             pt_i_subentity         => vt_subentity,
                                                             pt_i_migrationsetid    => vt_migrationsetid,
                                                             pt_i_phase             => ct_phase,
                                                             pt_i_severity          => 'NOTIFICATION',
                                                             pt_i_packagename       => gcv_packagename,
                                                             pt_i_procorfuncname    => cv_procorfuncname,
                                                             pt_i_progressindicator => gvv_progressindicator,
                                                             pt_i_modulemessage     => '      - No Period Name Parameters correspond to Extract Year "'
--                                                                 ||ExtractYear_tbl(ExtractYear_idx)
                                                                                   || '" and the Period Set associated with Source Ledger Name "'
                                                                                   || ledgerscope_tbl1(ledgername_idx).ledger_name
                                                                                   || '".  No Balances were extracted for this year.',
                                                             pt_i_oracleerror       => NULL
                        );
                                   --
                    END IF; --** IF NOT vb_PeriodAndYearMatch
                              --
--                         END LOOP; --** ExtractYear_tbl LOOP
                         --
                END LOOP; --** Ledger details LOOP
                    --
                gvv_progressindicator := '0190';
                    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all GL Ledgers in the Migration Set.
                    */
                    --
                gvn_rowcount := xxmx_utilities_pkg.get_row_count(
                                                                gct_stgschema,
                                                                ct_stgtable,
                                                                vt_migrationsetid
                                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Extraction complete.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
                    --
                COMMIT;
                    --
                    --** Update the migration details (Migration status will be automatically determined
                    --** in the called procedure dependant on the Phase and if an Error Message has been
                    --** passed).
                    --
                gvv_progressindicator := '0200';
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
                    --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
                    --**
                    --**                  Removed "entity" from procedure_name.
                    --
                xxmx_utilities_pkg.upd_migration_details(
                                                        pt_i_migrationsetid          => vt_migrationsetid,
                                                        pt_i_businessentity          => gct_businessentity,
                                                        pt_i_subentity               => vt_subentity,
                                                        pt_i_phase                   => ct_phase,
                                                        pt_i_extractcompletiondate   => sysdate,
                                                        pt_i_extractrowcount         => gvn_rowcount,
                                                        pt_i_transformtable          => NULL,
                                                        pt_i_transformstartdate      => NULL,
                                                        pt_i_transformcompletiondate => NULL,
                                                        pt_i_exportfilename          => NULL,
                                                        pt_i_exportstartdate         => NULL,
                                                        pt_i_exportcompletiondate    => NULL,
                                                        pt_i_exportrowcount          => NULL,
                                                        pt_i_errorflag               => NULL
                );
                    --
                xxmx_utilities_pkg.log_module_message(
                                                     pt_i_applicationsuite  => gct_applicationsuite,
                                                     pt_i_application       => gct_application,
                                                     pt_i_businessentity    => gct_businessentity,
                                                     pt_i_subentity         => vt_subentity,
                                                     pt_i_migrationsetid    => vt_migrationsetid,
                                                     pt_i_phase             => ct_phase,
                                                     pt_i_severity          => 'NOTIFICATION',
                                                     pt_i_packagename       => gcv_packagename,
                                                     pt_i_procorfuncname    => cv_procorfuncname,
                                                     pt_i_progressindicator => gvv_progressindicator,
                                                     pt_i_modulemessage     => '  - Migration Table "'
                                                                           || ct_stgtable
                                                                           || '" reporting details updated.',
                                                     pt_i_oracleerror       => NULL
                );
                    --
            END IF; --** vn_ListEntryCount > 0
               --
        ELSE
               --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- Migration Set not initialized.';
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => vt_subentity,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
               --
        WHEN e_moduleerror THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            RAISE;
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            IF glbalances_cur%isopen THEN
                         --
                CLOSE glbalances_cur;
                         --
            END IF;
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => vt_subentity,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted at after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
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
    PROCEDURE stg_main (
        pt_i_clientcode       IN xxmx_client_config_parameters.client_code%TYPE,
        pt_i_migrationsetname IN xxmx_migration_headers.migration_set_name%TYPE
    ) IS

        CURSOR metadata_cur IS
        SELECT
            entity_package_name,
            stg_procedure_name,
            business_entity,
            sub_entity_seq,
            sub_entity
        FROM
            xxmx_migration_metadata a
        WHERE
            application_suite = gct_applicationsuite
            AND application = gct_application
            AND business_entity = gct_businessentity
            AND a.enabled_flag = 'Y'
        ORDER BY
            business_entity_seq,
            sub_entity_seq;

        cv_procorfuncname        CONSTANT VARCHAR2(30) := 'stg_main';
        ct_phase                 CONSTANT xxmx_module_messages.phase%TYPE := 'EXTRACT';
        cv_stagingtable          CONSTANT VARCHAR2(100) DEFAULT 'XXMX_GL_BALANCES_PKG';
        cv_i_businessentitylevel CONSTANT VARCHAR2(100) DEFAULT 'GENERAL_LEDGER';
        vt_migrationsetid        xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                   VARCHAR2(32000);
    BEGIN
    --
        gvv_progressindicator := '0010';
    --
        IF pt_i_clientcode IS NULL OR pt_i_migrationsetname IS NULL THEN
        --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
        --
            RAISE e_moduleerror;
        --
        END IF;
    --
          --
        gvv_returnstatus := '';

          --
          /*
          ** Clear Customers Module Messages
          */
          --
        gvv_returnstatus := '';
          --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => cv_i_businessentitylevel,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'MODULE',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => cv_i_businessentitylevel,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".',
                                                 pt_i_oracleerror       => gvt_returnmessage
            );
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0020';
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => cv_i_businessentitylevel,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );
          --
        gvv_progressindicator := '0040';
          --
        xxmx_utilities_pkg.init_migration_set(
                                             pt_i_applicationsuite => gct_applicationsuite,
                                             pt_i_application      => gct_application,
                                             pt_i_businessentity   => gct_businessentity,
                                             pt_i_migrationsetname => pt_i_migrationsetname,
                                             pt_o_migrationsetid   => vt_migrationsetid
        );

          --vt_MigrationSetID := pt_i_ClientCode;
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => cv_i_businessentitylevel,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '- Migration Set "'
                                                                   || pt_i_migrationsetname
                                                                   || '" initialized (Generated Migration Set ID = '
                                                                   || vt_migrationsetid
                                                                   || ').  Processing extracts:',
                                             pt_i_oracleerror       => NULL
        );
          --
          -- First for performance reasons create a Temp table to hold details
          -- of all the sites we are to extract data for
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => cv_i_businessentitylevel,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => SQL%rowcount || ' entries added to Customer Scope Temp Staging',
                                             pt_i_oracleerror       => gvt_returnmessage
        );
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Staging Package Name, Procedure Name and table name
          ** for each extract requied for the current Business Entity.
          */
          --
        gvv_progressindicator := '0050';
          --
        FOR metadata_rec IN metadata_cur LOOP
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => cv_i_businessentitylevel,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '- Calling Procedure "'
                                                                       || metadata_rec.entity_package_name
                                                                       || '.'
                                                                       || metadata_rec.stg_procedure_name
                                                                       || '".',
                                                 pt_i_oracleerror       => NULL
            );
               --
            gvv_sqlstatement := 'BEGIN '
                                || metadata_rec.entity_package_name
                                || '.'
                                || metadata_rec.stg_procedure_name
                                || gcv_sqlspace
                                || '(pt_i_MigrationSetID          => '
                                || vt_migrationsetid
                                || ',pt_i_SubEntity     => '''
                                || metadata_rec.sub_entity
                                || ''''
                                || '); END;';
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => cv_i_businessentitylevel,
                                                 pt_i_migrationsetid    => vt_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => substr(
                                                     '- Generated SQL Statement: ' || gvv_sqlstatement, 1, 4000
                                                 ),
                                                 pt_i_oracleerror       => NULL
            );
               --
            EXECUTE IMMEDIATE gvv_sqlstatement;
               --
        END LOOP;
          --
        gvv_progressindicator := '0060';
          --
          --xxmx_utilities_pkg.close_extract_phase
          --     (
          --      vt_MigrationSetID
          --     );
          --
        COMMIT;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => cv_i_businessentitylevel,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
         --
        gvv_progressindicator := '0070';
    --
        COMMIT;
    --
    --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => cv_i_businessentitylevel,
                                             pt_i_migrationsetid    => vt_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
               --
        WHEN e_moduleerror THEN
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => cv_i_businessentitylevel,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            RAISE;
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => cv_i_businessentitylevel,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
            );
                    --
            RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
       --
    END stg_main;
     --
     --*******************
     --** PROCEDURE: purge
     --*******************
     --
    PROCEDURE purge (
        pt_i_clientcode     IN xxmx_client_config_parameters.client_code%TYPE,
        pt_i_migrationsetid IN xxmx_migration_headers.migration_set_id%TYPE
    ) IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
        CURSOR purgingmetadata_cur (
            pt_applicationsuite xxmx_migration_metadata.application_suite%TYPE,
            pt_application      xxmx_migration_metadata.application%TYPE,
            pt_businessentity   xxmx_migration_metadata.business_entity%TYPE
        ) IS
               --
               --
        SELECT
            xmm.stg_table,
            xmm.xfm_table
        FROM
            xxmx_migration_metadata xmm
        WHERE
            1 = 1
            AND xmm.application_suite = pt_applicationsuite
            AND xmm.application = pt_application
            AND xmm.business_entity = pt_businessentity
        ORDER BY
            xmm.sub_entity_seq;
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
        cv_procorfuncname   CONSTANT VARCHAR2(30) := 'purge';
        ct_subentity        CONSTANT xxmx_module_messages.sub_entity%TYPE := 'ALL';
        ct_phase            CONSTANT xxmx_module_messages.phase%TYPE := 'CORE';
          --
          --************************
          --** Variable Declarations
          --************************
          --
        vt_configparameter  xxmx_client_config_parameters.config_parameter%TYPE;
        vt_clientschemaname xxmx_client_config_parameters.config_value%TYPE;
        vv_purgetablename   VARCHAR2(30);
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
        e_moduleerror EXCEPTION;
          --
          --
     --** END Declarations **
     --
     --
    BEGIN
          --
        gvv_progressindicator := '0010';
          --
        IF
            pt_i_clientcode IS NULL
            AND pt_i_migrationsetid IS NULL
        THEN
               --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetID" parameters are mandatory.';
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_returnstatus := '';
        gvt_returnmessage := '';
          --
        xxmx_utilities_pkg.clear_messages(
                                         pt_i_applicationsuite => gct_applicationsuite,
                                         pt_i_application      => gct_application,
                                         pt_i_businessentity   => gct_businessentity,
                                         pt_i_subentity        => ct_subentity,
                                         pt_i_phase            => ct_phase,
                                         pt_i_messagetype      => 'MODULE',
                                         pv_o_returnstatus     => gvv_returnstatus
        );
          --
        IF gvv_returnstatus = 'F' THEN
               --
            gvt_severity := 'ERROR';
            gvt_modulemessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
               --
            RAISE e_moduleerror;
               --
        END IF;
          --
        gvv_progressindicator := '0020';
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" initiated.',
                                             pt_i_oracleerror       => NULL
        );

        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '- Purging tables.',
                                             pt_i_oracleerror       => NULL
        );
          --
        gvv_progressindicator := '0040';
          --
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the staging table names to purge for the current Business
          ** Entity.
          */
          --
        gvv_sqlaction := 'DELETE';
          --
        gvv_sqlwhereclause := 'WHERE 1 = 1 '
                              || 'AND   migration_set_id = '
                              || pt_i_migrationsetid;
          --
        FOR purgingmetadata_rec IN purgingmetadata_cur(
                                                      gct_applicationsuite,
                                                      gct_application,
                                                      gct_businessentity
                                   ) LOOP
               --
               --** ISV 21/10/2020 - Replace with new constant for Staging Schema.
               --
            gvv_sqltableclause := 'FROM '
                                  || gct_stgschema
                                  || '.'
                                  || purgingmetadata_rec.stg_table;
               --
            gvv_sqlstatement := gvv_sqlaction
                                || gcv_sqlspace
                                || gvv_sqltableclause
                                || gcv_sqlspace
                                || gvv_sqlwhereclause;
               --
            EXECUTE IMMEDIATE gvv_sqlstatement;
               --
            gvn_rowcount := SQL%rowcount;
               --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => ct_subentity,
                                                 pt_i_migrationsetid    => pt_i_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'NOTIFICATION',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => '  - Records purged from "'
                                                                       || purgingmetadata_rec.stg_table
                                                                       || '" table: '
                                                                       || gvn_rowcount,
                                                 pt_i_oracleerror       => NULL
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
        vv_purgetablename := 'xxmx_migration_details';
          --
        gvv_sqltableclause := 'FROM '
                              || gct_coreschema
                              || '.'
                              || vv_purgetablename;
          --
        gvv_sqlstatement := gvv_sqlaction
                            || gcv_sqlspace
                            || gvv_sqltableclause
                            || gcv_sqlspace
                            || gvv_sqlwhereclause;
          --
        EXECUTE IMMEDIATE gvv_sqlstatement;
          --
        gvn_rowcount := SQL%rowcount;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '  - Records purged from "'
                                                                   || vv_purgetablename
                                                                   || '" table: '
                                                                   || gvn_rowcount,
                                             pt_i_oracleerror       => NULL
        );
          --
          /*
          ** Purge the records for the Business Entity
          ** from the Migration Headers table.
          */
          --
          --** ISV 21/10/2020 - Replace with new constant for Core Schema.
          --
        vv_purgetablename := 'xxmx_migration_headers';
          --
        gvv_sqltableclause := 'FROM '
                              || gct_coreschema
                              || '.'
                              || vv_purgetablename;
          --
        gvv_sqlstatement := gvv_sqlaction
                            || gcv_sqlspace
                            || gvv_sqltableclause
                            || gcv_sqlspace
                            || gvv_sqlwhereclause;
          --
        EXECUTE IMMEDIATE gvv_sqlstatement;
          --
        gvn_rowcount := SQL%rowcount;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '  - Records purged from "'
                                                                   || vv_purgetablename
                                                                   || '" table: '
                                                                   || gvn_rowcount,
                                             pt_i_oracleerror       => NULL
        );
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => '- Purging complete.',
                                             pt_i_oracleerror       => NULL
        );
          --
        COMMIT;
          --
        xxmx_utilities_pkg.log_module_message(
                                             pt_i_applicationsuite  => gct_applicationsuite,
                                             pt_i_application       => gct_application,
                                             pt_i_businessentity    => gct_businessentity,
                                             pt_i_subentity         => ct_subentity,
                                             pt_i_migrationsetid    => pt_i_migrationsetid,
                                             pt_i_phase             => ct_phase,
                                             pt_i_severity          => 'NOTIFICATION',
                                             pt_i_packagename       => gcv_packagename,
                                             pt_i_procorfuncname    => cv_procorfuncname,
                                             pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage     => 'Procedure "'
                                                                   || gcv_packagename
                                                                   || '.'
                                                                   || cv_procorfuncname
                                                                   || '" completed.',
                                             pt_i_oracleerror       => NULL
        );
          --
    EXCEPTION
               --
        WHEN e_moduleerror THEN
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => ct_subentity,
                                                 pt_i_migrationsetid    => pt_i_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => gvt_severity,
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => gvt_modulemessage,
                                                 pt_i_oracleerror       => NULL
            );
                    --
            RAISE;
                    --
               --** END e_ModuleError Exception
               --
        WHEN OTHERS THEN
                    --
            ROLLBACK;
                    --
            gvt_oracleerror := substr(
                                     sqlerrm
                                     || '** ERROR_BACKTRACE: '
                                     || dbms_utility.format_error_backtrace,
                                     1,
                                     4000
                               );
                    --
            xxmx_utilities_pkg.log_module_message(
                                                 pt_i_applicationsuite  => gct_applicationsuite,
                                                 pt_i_application       => gct_application,
                                                 pt_i_businessentity    => gct_businessentity,
                                                 pt_i_subentity         => ct_subentity,
                                                 pt_i_migrationsetid    => pt_i_migrationsetid,
                                                 pt_i_phase             => ct_phase,
                                                 pt_i_severity          => 'ERROR',
                                                 pt_i_packagename       => gcv_packagename,
                                                 pt_i_procorfuncname    => cv_procorfuncname,
                                                 pt_i_progressindicator => gvv_progressindicator,
                                                 pt_i_modulemessage     => 'Oracle error encounted after Progress Indicator.',
                                                 pt_i_oracleerror       => gvt_oracleerror
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

END xxmx_gl_balances_pkg;