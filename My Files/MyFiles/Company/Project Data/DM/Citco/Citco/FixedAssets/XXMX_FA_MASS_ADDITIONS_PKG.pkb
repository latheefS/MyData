create or replace PACKAGE BODY xxmx_fa_mass_additions_pkg as



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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_fa_mass_additions_pkg';
    gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
    gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
    gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'FIN';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'FA';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'FIXED_ASSETS';
    g_batch_name                              CONSTANT  VARCHAR2(300)                               := 'FA_'||to_char(SYSDATE,'DDMMRRRRHHMISS') ;
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';

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
     gvv_migration_date                        VARCHAR2(30);
	 gvv_period_counter							number;
	 gvd_migration_date                        DATE;

     --
     --
     --
     --Exception Declarations
     e_moduleerror                             EXCEPTION;
     e_dateerror                               EXCEPTION;

     --
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
     */
     --

      PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                        ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
      IS

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
         AND   business_entity = gv_i_BusinessEntity
         AND   a.enabled_flag = 'Y'
         ORDER BY
         Business_entity_seq,
         Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_FA_MASS_ADDITIONS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'FIXED_ASSETS';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
   BEGIN

   -- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            --
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
            );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0010';
        /* Migration Set ID Generation*/
        xxmx_utilities_pkg.init_migration_set
         (
         pt_i_ApplicationSuite  => gct_ApplicationSuite
         ,pt_i_Application       => gct_Application
         ,pt_i_BusinessEntity    => gv_i_BusinessEntity
         ,pt_i_MigrationSetName  => pt_i_MigrationSetName
         ,pt_o_MigrationSetID    => vt_MigrationSetID
         );

         --
         gvv_ProgressIndicator :='0015';
        xxmx_utilities_pkg.log_module_message(
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                                   ||pt_i_MigrationSetName
                                                   ||'" initialized (Generated Migration Set ID = '
                                                   ||vt_MigrationSetID
                                                   ||').  Processing extracts:'       ,
                         pt_i_OracleError         => NULL
            );
        --
        --
        --main


        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message(
            pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for FA Extract'
            ,pt_i_OracleError         => NULL
        );

      --

       gvv_migration_date := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite            =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'CUT_OFF_DATE'
        );


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(
            pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Fixed Assets Extracts',
             pt_i_OracleError         => NULL
        );

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                     lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;

                    EXECUTE IMMEDIATE lv_sql ;

                    gvv_ProgressIndicator := '0030';
                    xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => lv_sql       ,
                        pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP;

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
        WHEN e_DateError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;

        WHEN OTHERS THEN
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
            xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@xxmx_extract;

   END stg_main;

	/****************************************************************
	----------------Export Mass Additions Distribution---------------
	*****************************************************************/

   PROCEDURE src_mass_addition_dist
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
   IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_mass_addition_dist';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_FA_MASS_ADDITION_DIST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'MASS_DISTRIBUTION';


        --
        -- Local Cursors
        -- Cursor to get all eligible Mass Additions to be migrated
        CURSOR imp_massadd_dist_cur_src
        IS

        SELECT /*+ DRIVING_SITE(fds) */ distinct fab_dist.asset_id                AS mass_addition_id --Hint added to improve performance
              ,fdh.units_assigned               AS units
              ,/*(select ppf.EMAIL_ADDRESS from per_all_people_f@xxmx_extract ppf where ppf.person_id=fdh.ASSIGNED_TO
and     ppf.effective_start_date =  ( select max(effective_start_date)
                                                                   from   per_all_people_f@XXMX_EXTRACT  ppf1
                                                                   where  ppf1.person_id = ppf.person_id))      */ NULL                         AS employee_email_address
              ,fal.segment1                     AS location_segment1
              ,fal.segment2                     AS location_segment2
              ,fal.segment3                     AS location_segment3
              ,fal.segment4                     AS location_segment4
              ,fal.segment5                     AS location_segment5
              ,fal.segment6                     AS location_segment6
              ,fal.segment7                     AS location_segment7
              ,gcc_exp.segment1                 AS deprn_expense_segment1
              ,gcc_exp.segment2                 AS deprn_expense_segment2
              ,gcc_exp.segment3                 AS deprn_expense_segment3
              ,gcc_exp.segment4                 AS deprn_expense_segment4
              ,gcc_exp.segment5                 AS deprn_expense_segment5
              ,gcc_exp.segment6                 AS deprn_expense_segment6
              ,gcc_exp.segment7                 AS deprn_expense_segment7
              ,gcc_exp.segment8                 AS deprn_expense_segment8
              ,gcc_exp.segment9                 AS deprn_expense_segment9
              ,gcc_exp.segment10                AS deprn_expense_segment10
              ,gcc_exp.segment11                AS deprn_expense_segment11
              ,gcc_exp.segment12                AS deprn_expense_segment12
              ,gcc_exp.segment13                AS deprn_expense_segment13
              ,gcc_exp.segment14                AS deprn_expense_segment14
              ,gcc_exp.segment15                AS deprn_expense_segment15
              ,gcc_exp.segment16                AS deprn_expense_segment16
              ,gcc_exp.segment17                AS deprn_expense_segment17
              ,gcc_exp.segment18                AS deprn_expense_segment18
              ,gcc_exp.segment19                AS deprn_expense_segment19
              ,gcc_exp.segment20                AS deprn_expense_segment20
              ,gcc_exp.segment21                AS deprn_expense_segment21
              ,gcc_exp.segment22                AS deprn_expense_segment22
              ,gcc_exp.segment23                AS deprn_expense_segment23
              ,gcc_exp.segment24                AS deprn_expense_segment24
              ,gcc_exp.segment25                AS deprn_expense_segment25
              ,gcc_exp.segment26                AS deprn_expense_segment26
              ,gcc_exp.segment27                AS deprn_expense_segment27
              ,gcc_exp.segment28                AS deprn_expense_segment28
              ,gcc_exp.segment29                AS deprn_expense_segment29
              ,gcc_exp.segment30                AS deprn_expense_segment30
              ,'FIXED_ASSET'||to_char(SYSDATE,'DDMMRRRRHHMISS')      AS  Batch_name
              --,xxmx_utilities_pkg.gvv_UserName                                          AS created_by  -- constant
              ,NULL  AS created_by  -- constant
              ,NULL                                             AS  creation_date -- constant
              --,xxmx_utilities_pkg.gvv_UserName                                          AS last_updated_by -- constant
              ,NULL as last_updated_by
              ,NULL                                              AS last_update_date -- constant
              , fds.deprn_source_code
        FROM   apps.fa_distribution_history@xxmx_extract    fdh
              ,apps.fa_additions_b@xxmx_extract             fab_dist
              ,apps.fa_locations@xxmx_extract               fal
              ,apps.gl_code_combinations@xxmx_extract       gcc_exp
              ,apps.fa_books@xxmx_extract                   fb
              ,apps.fa_deprn_summary@xxmx_extract           fds
              ,XXMX_CORE.XXMX_FA_SCOPE_V                    fsv
        WHERE  fdh.asset_id                         = fab_dist.asset_id
        AND    fal.location_id (+)                  = fdh.location_id
        AND    gcc_exp.code_combination_id(+)       = fdh.code_combination_id
        AND    fab_dist.asset_id                    = fb.asset_id
        AND    TRUNC(SYSDATE)                 BETWEEN fb.date_effective  AND NVL(fb.date_ineffective, SYSDATE)
        AND    TRUNC(SYSDATE)                       BETWEEN fdh.date_effective AND NVL(fdh.date_ineffective,SYSDATE)
        AND    fds.asset_id                         = fb.asset_id
        AND    fds.book_type_code                   = fb.book_type_code
        and    fab_dist.asset_id                    = fsv.asset_id
		 and TRUNC(fb.date_placed_in_service) <=  TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY')) 
        AND    fb.book_type_code                    IN(SELECT parameter_value
                                                       FROM XXMX_MIGRATION_PARAMETERS
                                                       WHERE APPLICATION = gct_Application
                                                       AND   application_suite = gct_ApplicationSuite
                                                       and parameter_code = 'BOOK_TYPE_CODE'
                                                       AND ENABLED_FLAG='Y')
        AND    fds.period_counter                   = ( SELECT MAX (fds1.period_counter)
                                                        FROM   apps.fa_deprn_summary@xxmx_extract fds1
                                                        WHERE  fds1.asset_id               = fds.asset_id
                                                        AND    fds1.book_type_code         = fds.book_type_code
                                                        and    fds1.deprn_source_code      in ( 'DEPRN','BOOKS')
                                                        AND    (trunc(fds1.deprn_run_date) <=  TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY'))  or  fds1.period_counter=gvv_period_counter)
                                                      )
         ;
       --
       -- Local Type Variables

      TYPE imp_massadd_dist_tb1_src IS TABLE OF imp_massadd_dist_cur_src%ROWTYPE INDEX BY BINARY_INTEGER;
      imp_massadd_dist_tb_src  imp_massadd_dist_tb1_src;
       --
       ld_begin_date             DATE;
       l_start_time              VARCHAR2(30);
       ex_dml_errors             EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;

       --
    BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;


        --
        --
        --

        gvv_ProgressIndicator := '0010';
        xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    XXMX_STG.XXMX_FA_MASS_ADDITION_DIST_STG ;

        COMMIT;
        --
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


           OPEN imp_massadd_dist_cur_src;
           --
           LOOP
           --

           gvv_ProgressIndicator := '0020';
           xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Inside the CURSOR loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           FETCH imp_massadd_dist_cur_src  BULK COLLECT INTO imp_massadd_dist_tb_src LIMIT 1000;
           --

            gvv_ProgressIndicator := '0020';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'CURSOR imp_massadd_dist_cur_src Fetch into imp_massadd_dist_tb_src'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           EXIT WHEN imp_massadd_dist_tb_src.COUNT=0;
           --
           FORALL i IN 1..imp_massadd_dist_tb_src.COUNT SAVE EXCEPTIONS
           --
             INSERT
             INTO XXMX_STG.XXMX_FA_MASS_ADDITION_DIST_STG
                    (
                mass_addition_id
               ,migration_status
               ,migration_set_name
               ,units
               ,employee_email_address
               ,location_segment1
               ,location_segment2
               ,location_segment3
               ,location_segment4
               ,location_segment5
               ,location_segment6
               ,location_segment7
               ,deprn_expense_segment1
               ,deprn_expense_segment2
               ,deprn_expense_segment3
               ,deprn_expense_segment4
               ,deprn_expense_segment5
               ,deprn_expense_segment6
               ,deprn_expense_segment7
               ,deprn_expense_segment8
               ,deprn_expense_segment9
               ,deprn_expense_segment10
               ,deprn_expense_segment11
               ,deprn_expense_segment12
               ,deprn_expense_segment13
               ,deprn_expense_segment14
               ,deprn_expense_segment15
               ,deprn_expense_segment16
               ,deprn_expense_segment17
               ,deprn_expense_segment18
               ,deprn_expense_segment19
               ,deprn_expense_segment20
               ,deprn_expense_segment21
               ,deprn_expense_segment22
               ,deprn_expense_segment23
               ,deprn_expense_segment24
               ,deprn_expense_segment25
               ,deprn_expense_segment26
               ,deprn_expense_segment27
               ,deprn_expense_segment28
               ,deprn_expense_segment29
               ,deprn_expense_segment30
               ,creation_date
               ,created_by
               ,last_update_date
               ,last_updated_by
               ,migration_set_id
               ,deprn_source_code
              )
          VALUES (

                imp_massadd_dist_tb_src(i).mass_addition_id
               ,'EXTRACTED'
               ,gvt_MigrationSetName
               ,imp_massadd_dist_tb_src(i).units
               ,imp_massadd_dist_tb_src(i).employee_email_address
               ,imp_massadd_dist_tb_src(i).location_segment1
               ,imp_massadd_dist_tb_src(i).location_segment2
               ,imp_massadd_dist_tb_src(i).location_segment3
               ,imp_massadd_dist_tb_src(i).location_segment4
               ,imp_massadd_dist_tb_src(i).location_segment5
               ,imp_massadd_dist_tb_src(i).location_segment6
               ,imp_massadd_dist_tb_src(i).location_segment7
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment1
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment2
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment3
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment4
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment5
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment6
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment7
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment8
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment9
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment10
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment11
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment12
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment13
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment14
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment15
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment16
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment17
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment18
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment19
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment20
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment21
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment22
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment23
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment24
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment25
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment26
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment27
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment28
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment29
               ,imp_massadd_dist_tb_src(i).deprn_expense_segment30
               ,imp_massadd_dist_tb_src(i).creation_date
               ,imp_massadd_dist_tb_src(i).created_by
               ,imp_massadd_dist_tb_src(i).last_update_date
               ,imp_massadd_dist_tb_src(i).last_updated_by
               ,pt_i_MigrationSetID
               ,imp_massadd_dist_tb_src(i).deprn_source_code
              );
         --
         END LOOP;

         --
        gvv_ProgressIndicator := '0030';
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );


        gvv_ProgressIndicator := '0031';
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Update Table into xxmx_fa_mass_addition_dist_stg'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );

         --
         -- Updating entity code in FA Mass Addition to split data based on Entity Code
         UPDATE xxmx_fa_mass_additions_stg fma
         SET fma.deprn_expense_segment6  = ( SELECT   distinct fmad.deprn_expense_segment6
                                           FROM      xxmx_fa_mass_addition_dist_stg fmad
                                           WHERE   fmad.mass_addition_id = fma.mass_addition_id  );
         --
         COMMIT;
         --
         gvv_ProgressIndicator := '0032';
           xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Close the Cursor imp_massadd_dist_cur_src'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );
          --


         IF imp_massadd_dist_cur_src%ISOPEN
         THEN
         --
               CLOSE imp_massadd_dist_cur_src;
         --
         END IF;

         --
         /*
         ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
         ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
         ** is reached.
         */
         --
         --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
         --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
         --
         gvn_RowCount := xxmx_utilities_pkg.get_row_count
                              (
                               gct_StgSchema
                              ,cv_StagingTable
                              ,pt_i_MigrationSetID
                              );
         --
         COMMIT;


         xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.upd_migration_details
                 (
                  pt_i_MigrationSetID          => pt_i_MigrationSetID
                 ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                 ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Migration Table "'
                                          ||cv_StagingTable
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
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
          --



    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );

           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF imp_massadd_dist_cur_src%ISOPEN
        THEN
            --
            CLOSE imp_massadd_dist_cur_src;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;
         --** END e_ModuleError Exception
         --
      WHEN e_DateError THEN
                --
        IF imp_massadd_dist_cur_src%ISOPEN
        THEN
            --
            CLOSE imp_massadd_dist_cur_src;
            --
        END IF;
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;

      WHEN OTHERS THEN

         IF imp_massadd_dist_cur_src%ISOPEN
         THEN
             --
             CLOSE imp_massadd_dist_cur_src;
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
         xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;

    END src_mass_addition_dist;


	/****************************************************************
	----------------Export Mass Additions-------------------------
	*****************************************************************/

   PROCEDURE src_mass_addition
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
   IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_mass_addition';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_FA_MASS_ADDITIONS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'MASS_ADDITIONS';


        --
    -- Local Cursors
    -- Cursor to get all eligible Mass Additions to be migrated
    CURSOR imp_massadd_src_cur
    IS
        SELECT  /*+ DRIVING_SITE(fds) */ fab.asset_id                                      AS mass_addition_id --Hint added to improve performance
                ,fb.book_type_code /* Reference data from EDQ*/                              AS book_type_code
                ,NULL                                                                      AS transaction_name
                ,fab.asset_number                                                          AS asset_number
                ,SUBSTR(replace(replace(TRIM(replace(Replace(replace((regexp_replace(fat.description, '(^[[:space:]]+)|([[:space:]]+$)',null)),chr(10)),chr(13)),chr(14849697))), '"', '"'), CHR(9)),1,80)
                                                                                           AS description
                ,fab.tag_number                                                            AS tag_number
                ,fab.manufacturer_name                                                     AS manufacturer_name
                ,fab.serial_number                                                         AS serial_number
                ,fab.model_number                                                          AS model_number
                ,fab.asset_type                                                            AS asset_type
                ,fb.cost                                                                   AS fixed_assets_cost
                ,fb.date_placed_in_service                                                 AS date_placed_in_service
                ,fb.prorate_convention_code                                                AS prorate_convention_code
                ,fab.current_units                                                         AS fixed_assets_units
                ,fac.segment1                                                              AS category_segment1
                ,fac.segment2                                                              AS category_segment2
                ,fac.segment3                                                              AS category_segment3
                ,fac.segment4                                                              AS category_segment4
                ,fac.segment5                                                              AS category_segment5
                ,fac.segment6                                                              AS category_segment6
                ,fac.segment7                                                              AS category_segment7
                ,NULL                                                                      AS posting_status
                ,NULL                                                                      AS queue_name
                ,NULL                                                                      AS feeder_system_name
                ,fab.parent_asset_id                                                       AS parent_asset_number
                ,NULL                                                                      AS add_to_asset_number
  /*              ,fak.segment1                                                              AS asset_key_segment1
                ,fak.segment2                                                              AS asset_key_segment2
                ,fak.segment3                                                              AS asset_key_segment3
                ,fak.segment4                                                              AS asset_key_segment4
                ,fak.segment5                                                              AS asset_key_segment5
                ,fak.segment6                                                              AS asset_key_segment6
                ,fak.segment7                                                              AS asset_key_segment7
                ,fak.segment8                                                              AS asset_key_segment8
                ,fak.segment9                                                              AS asset_key_segment9
                ,fak.segment10                                                             AS asset_key_segment10*/
                ,NULL                                                                      AS asset_key_segment1
                ,NULL                                                                      AS asset_key_segment2
                ,NULL                                                                      AS asset_key_segment3
                ,NULL                                                                      AS asset_key_segment4
                ,NULL                                                                      AS asset_key_segment5
                ,NULL                                                                      AS asset_key_segment6
                ,NULL                                                                      AS asset_key_segment7
                ,NULL                                                                      AS asset_key_segment8
                ,NULL                                                                      AS asset_key_segment9
                ,NULL                                                                      AS asset_key_segment10			
                ,fab.inventorial                                                           AS inventorial
                ,fab.property_type_code                                                    AS property_type_code
                ,fab.property_1245_1250_code                                               AS property_1245_1250_code
                ,fab.in_use_flag                                                           AS in_use_flag
                ,fab.owned_leased                                                          AS owned_leased
                ,fab.new_used                                                              AS new_used
                ,NULL                                                                      AS material_indicator_flag
                ,fab.commitment                                                            AS commitment
                ,fab.investment_law                                                        AS investment_law
				,DECODE((SELECT DISTINCT TRANSACTION_SUBTYPE FROM apps.fa_transaction_headers@xxmx_extract
				WHERE 1=1
				AND ASSET_ID=FAB.ASSET_ID 
				AND TRANSACTION_SUBTYPE='AMORTIZED'),'AMORTIZED','YES','NO')       AS amortize_flag --changed by veda poojitha to extract amortized flag yes/no	(20/Mar/2023)

              --,NULL                                                                      AS amortize_flag
		        ,DECODE((SELECT DISTINCT TRANSACTION_SUBTYPE FROM apps.fa_transaction_headers@xxmx_extract
				  WHERE ASSET_ID=FAB.ASSET_ID AND TRANSACTION_SUBTYPE='AMORTIZED'),'AMORTIZED',
				  (select LAST_DAY(TO_CHAR(ADD_MONTHS(PARAMETER_VALUE,1),'DD-MON-YYYY')) 
				      from xxmx_migration_parameters
                      where 1=1
					  AND application='FA'
                      AND APPLICATION_SUITE='FIN'
                      AND PARAMETER_CODE='CUT_OFF_DATE'
                      AND ENABLED_FLAG='Y'),'')                                            AS amortization_start_date  --changed by Sushma Chowdary to extract amortized  start date(20/Mar/2023)
              --,NULL                                                                      AS amortization_start_date
                ,fb.depreciate_flag                                                        AS depreciate_flag -- changed by Laxmikanth
                ,fb.salvage_type                                                           AS salvage_type
                ,fb.salvage_value                                                          AS salvage_value
                ,fb.percent_salvage_value                                                  AS percent_salvage_value
                ,DECODE (fdp.fiscal_year, fbc.current_fiscal_year, fds.ytd_deprn, 0)       AS ytd_deprn
                ,fds.deprn_reserve                                                         AS deprn_reserve
                ,DECODE (fdp.fiscal_year, fbc.current_fiscal_year, fds.bonus_ytd_deprn, 0) AS bonus_ytd_deprn
                ,fds.bonus_deprn_reserve                                                   AS bonus_deprn_reserve
				,(SELECT NVL(SUM(YTD_IMPAIRMENT),0) FROM APPS.FA_DEPRN_DETAIL@XXMX_EXTRACT A ,FA_DEPRN_PERIODS@XXMX_EXTRACT B
                		WHERE A.ASSET_ID =fab.asset_id
				        AND    A.book_type_code      = fb.book_type_code
				        and   B.fiscal_year= to_char(to_date(gvv_migration_date,'DD-MON-YYYY'),'YYYY')
                		AND A.PERIOD_COUNTER=B.PERIOD_COUNTER
                		AND A.BOOK_TYPE_CODE=B.BOOK_TYPE_CODE
                		AND A.PERIOD_COUNTER <= GVV_PERIOD_COUNTER)                        AS ytd_impairment --changed by veda poojitha/Sushma Chowdary to extract ytd_impairment(20/Mar/2023)
            --    ,(SELECT SUM(ytd_impairment)
            --      FROM   apps.fa_itf_impairments@xxmx_extract a
            --      WHERE  a.asset_id            = fab.asset_id
            --      AND    a.book_type_code      = fb.book_type_code
            --      AND    a.impairment_id       = (SELECT MAX(b.impairment_id)
            --                                      FROM   apps.fa_itf_impairments@xxmx_extract b
            --                                      WHERE  a.asset_id              = b.asset_id
            --                                      AND    a.book_type_code        = b.book_type_code
            --                                      AND    (TRUNC(b.deprn_run_date)<= TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY')) or  a.period_counter=gvv_period_counter)
            --                                      )
            --                                     )                                          AS ytd_impairment  
                ,(SELECT SUM(impairment_reserve)--SUM(impairment_amount)
                  FROM   apps.fa_itf_impairments@xxmx_extract a
                  WHERE  a.asset_id            = fab.asset_id
                  AND    a.book_type_code      = fb.book_type_code
                  AND    a.impairment_id       = (SELECT MAX(b.impairment_id)
                                                  FROM   apps.fa_itf_impairments@xxmx_extract b
                                                  WHERE  a.asset_id             = b.asset_id
                                                  AND    a.book_type_code       = b.book_type_code
                                                  AND    (TRUNC(b.deprn_run_date)<= TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY'))  or b.period_counter=gvv_period_counter)
                                                  )
                                                 )
                                                                                           AS impairment_reserve
                ,fb.deprn_method_code                                                      AS method_code
                ,fb.life_in_months                                                         AS life_in_months
                ,fb.basic_rate                                                             AS basic_rate
                ,fb.adjusted_rate                                                          AS adjusted_rate
                ,fb.unit_of_measure                                                        AS unit_of_measure
                ,fb.production_capacity                                                    AS production_capacity
                ,fb.ceiling_name                                                           AS ceiling_name
                ,fb.bonus_rule                                                             AS bonus_rule
                ,fb.cash_generating_unit_id                                                AS cash_generating_unit
                ,fb.deprn_limit_type                                                       AS deprn_limit_type
                ,fb.allowed_deprn_limit                                                    AS allowed_deprn_limit
                ,fb.allowed_deprn_limit_amount                                             AS allowed_deprn_limit_amount
                ,NULL                                                                      AS payables_cost
                ,(SELECT segment1 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment1
                ,(SELECT segment2 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment2
                ,(SELECT segment3 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment3
                ,(SELECT segment4 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment4
                ,(SELECT segment5 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment5
                ,(SELECT segment6 FROM gl_code_combinations@xxmx_extract cc1
                  WHERE cc1.code_combination_id = fcb.asset_clearing_account_ccid)         AS clearing_acct_segment6
/*
                ,NULL                                                                      AS clearing_acct_segment1
                ,NULL                                                                      AS clearing_acct_segment2
                ,NULL                                                                      AS clearing_acct_segment3
                ,NULL                                                                      AS clearing_acct_segment4
                ,NULL                                                                      AS clearing_acct_segment5
                ,NULL                                                                      AS clearing_acct_segment6
*/
                ,NULL                                                                      AS clearing_acct_segment7
                ,NULL                                                                      AS clearing_acct_segment8
                ,NULL                                                                      AS clearing_acct_segment9
                ,NULL                                                                      AS clearing_acct_segment10
                ,NULL                                                                      AS clearing_acct_segment11
                ,NULL                                                                      AS clearing_acct_segment12
                ,NULL                                                                      AS clearing_acct_segment13
                ,NULL                                                                      AS clearing_acct_segment14
                ,NULL                                                                      AS clearing_acct_segment15
                ,NULL                                                                      AS clearing_acct_segment16
                ,NULL                                                                      AS clearing_acct_segment17
                ,NULL                                                                      AS clearing_acct_segment18
                ,NULL                                                                      AS clearing_acct_segment19
                ,NULL                                                                      AS clearing_acct_segment20
                ,NULL                                                                      AS clearing_acct_segment21
                ,NULL                                                                      AS clearing_acct_segment22
                ,NULL                                                                      AS clearing_acct_segment23
                ,NULL                                                                      AS clearing_acct_segment24
                ,NULL                                                                      AS clearing_acct_segment25
                ,NULL                                                                      AS clearing_acct_segment26
                ,NULL                                                                      AS clearing_acct_segment27
                ,NULL                                                                      AS clearing_acct_segment28
                ,NULL                                                                      AS clearing_acct_segment29
                ,NULL                                                                      AS clearing_acct_segment30
                ,NULL                                                                      AS attribute1
                ,NULL                                                                      AS attribute2
                ,NULL                                                                      AS attribute3
                ,NULL                                                                      AS attribute4
                ,NULL                                                                      AS attribute5
                ,NULL                                                                      AS attribute6
                ,NULL                                                                      AS attribute7
                ,NULL                                                                      AS attribute8
                ,NULL                                                                      AS attribute9
                ,NULL                                                                      AS attribute10
                ,NULL                                                                      AS attribute11
                ,NULL                                                                      AS attribute12
                ,NULL                                                                      AS attribute13
                ,NULL                                                                      AS attribute14
                ,NULL                                                                      AS attribute15
                ,NULL                                                                      AS attribute16
                ,NULL                                                                      AS attribute17
                ,NULL                                                                      AS attribute18
                ,NULL                                                                      AS attribute19
                ,NULL                                                                      AS attribute20
                ,NULL                                                                      AS attribute21
                ,NULL                                                                      AS attribute22
                ,NULL                                                                      AS attribute23
                ,NULL                                                                      AS attribute24
                ,NULL                                                                      AS attribute25
                ,NULL                                                                      AS attribute26
                ,NULL                                                                      AS attribute27
                ,NULL                                                                      AS attribute28
                ,NULL                                                                      AS attribute29
                ,NULL                                                                      AS attribute30
                ,NULL                                                                      AS attribute_number1
                ,NULL                                                                      AS attribute_number2
                ,NULL                                                                      AS attribute_number3
                ,NULL                                                                      AS attribute_number4
                ,NULL                                                                      AS attribute_number5
                ,NULL                                                                      AS attribute_date1
                ,NULL                                                                      AS attribute_date2
                ,NULL                                                                      AS attribute_date3
                ,NULL                                                                      AS attribute_date4
                ,NULL                                                                      AS attribute_date5
                ,NULL                                                                      AS attribute_category_code
                ,NULL                                                                      AS context
                ,NULL                                                                      AS th_attribute1
                ,NULL                                                                      AS th_attribute2
                ,NULL                                                                      AS th_attribute3
                ,NULL                                                                      AS th_attribute4
                ,NULL                                                                      AS th_attribute5
                ,NULL                                                                      AS th_attribute6
                ,NULL                                                                      AS th_attribute7
                ,NULL                                                                      AS th_attribute8
                ,NULL                                                                      AS th_attribute9
                ,NULL                                                                      AS th_attribute10
                ,NULL                                                                      AS th_attribute11
                ,NULL                                                                      AS th_attribute12
                ,NULL                                                                      AS th_attribute13
                ,NULL                                                                      AS th_attribute14
                ,NULL                                                                      AS th_attribute15
                ,NULL                                                                      AS th_attribute_number1
                ,NULL                                                                      AS th_attribute_number2
                ,NULL                                                                      AS th_attribute_number3
                ,NULL                                                                      AS th_attribute_number4
                ,NULL                                                                      AS th_attribute_number5
                ,NULL                                                                      AS th_attribute_date1
                ,NULL                                                                      AS th_attribute_date2
                ,NULL                                                                      AS th_attribute_date3
                ,NULL                                                                      AS th_attribute_date4
                ,NULL                                                                      AS th_attribute_date5
                ,NULL                                                                      AS th_attribute_category_code
                ,NULL                                                                      AS th2_attribute1
                ,NULL                                                                      AS th2_attribute2
                ,NULL                                                                      AS th2_attribute3
                ,NULL                                                                      AS th2_attribute4
                ,NULL                                                                      AS th2_attribute5
                ,NULL                                                                      AS th2_attribute6
                ,NULL                                                                      AS th2_attribute7
                ,NULL                                                                      AS th2_attribute8
                ,NULL                                                                      AS th2_attribute9
                ,NULL                                                                      AS th2_attribute10
                ,NULL                                                                      AS th2_attribute11
                ,NULL                                                                      AS th2_attribute12
                ,NULL                                                                      AS th2_attribute13
                ,NULL                                                                      AS th2_attribute14
                ,NULL                                                                      AS th2_attribute15
                ,NULL                                                                      AS th2_attribute_number1
                ,NULL                                                                      AS th2_attribute_number2
                ,NULL                                                                      AS th2_attribute_number3
                ,NULL                                                                      AS th2_attribute_number4
                ,NULL                                                                      AS th2_attribute_number5
                ,NULL                                                                      AS th2_attribute_date1
                ,NULL                                                                      AS th2_attribute_date2
                ,NULL                                                                      AS th2_attribute_date3
                ,NULL                                                                      AS th2_attribute_date4
                ,NULL                                                                      AS th2_attribute_date5
                ,NULL                                                                      AS th2_attribute_category_code
                ,NULL                                                                      AS ai_attribute1
                ,NULL                                                                      AS ai_attribute2
                ,NULL                                                                      AS ai_attribute3
                ,NULL                                                                      AS ai_attribute4
                ,NULL                                                                      AS ai_attribute5
                ,NULL                                                                      AS ai_attribute6
                ,NULL                                                                      AS ai_attribute7
                ,NULL                                                                      AS ai_attribute8
                ,NULL                                                                      AS ai_attribute9
                ,NULL                                                                      AS ai_attribute10
                ,NULL                                                                      AS ai_attribute11
                ,NULL                                                                      AS ai_attribute12
                ,NULL                                                                      AS ai_attribute13
                ,NULL                                                                      AS ai_attribute14
                ,NULL                                                                      AS ai_attribute15
                ,NULL                                                                      AS ai_attribute_number1
                ,NULL                                                                      AS ai_attribute_number2
                ,NULL                                                                      AS ai_attribute_number3
                ,NULL                                                                      AS ai_attribute_number4
                ,NULL                                                                      AS ai_attribute_number5
                ,NULL                                                                      AS ai_attribute_date1
                ,NULL                                                                      AS ai_attribute_date2
                ,NULL                                                                      AS ai_attribute_date3
                ,NULL                                                                      AS ai_attribute_date4
                ,NULL                                                                      AS ai_attribute_date5
                ,NULL                                                                      AS ai_attribute_category_code
                ,NULL                                                                      AS mass_property_flag
                ,fb.group_asset_id                                                         AS group_asset_number
                ,fb.reduction_rate                                                         AS reduction_rate
                ,fb.reduce_addition_flag                                                   AS reduce_addition_flag
                ,NULL                                                                      AS reduce_adjustment_flag
                ,NULL                                                                      AS reduce_retirement_flag
                ,fb.recognize_gain_loss                                                    AS recognize_gain_loss
                ,fb.recapture_reserve_flag                                                 AS recapture_reserve_flag
                ,fb.limit_proceeds_flag                                                    AS limit_proceeds_flag
                ,fb.terminal_gain_loss                                                     AS terminal_gain_loss
                ,fb.tracking_method                                                        AS tracking_method
                ,fb.excess_allocation_option                                               AS excess_allocation_option
                ,fb.depreciation_option                                                    AS depreciation_option
                ,fb.member_rollup_flag                                                     AS member_rollup_flag
                ,fb.allocate_to_fully_rsv_flag                                             AS allocate_to_fully_rsv_flag
                ,fb.over_depreciate_option                                                 AS over_depreciate_option
                ,NULL                                                                      AS preparer_email_address
                ,NULL                                                                      AS merged_code
                ,NULL                                                                      AS parent_mass_addition_id
                ,NULL                                                                      AS sum_units
                ,NULL                                                                      AS new_master_flag
                ,NULL                                                                      AS units_to_adjust
                ,fb.short_fiscal_year_flag                                                 AS short_fiscal_year_flag
                ,fb.conversion_date                                                        AS conversion_date
                ,fb.original_deprn_start_date                                              AS original_deprn_start_date
                ,NULL                                                                      AS global_attribute1
                ,NULL                                                                      AS global_attribute2
                ,NULL                                                                      AS global_attribute3
                ,NULL                                                                      AS global_attribute4
                ,NULL                                                                      AS global_attribute5
                ,NULL                                                                      AS global_attribute6
                ,NULL                                                                      AS global_attribute7
                ,NULL                                                                      AS global_attribute8
                ,NULL                                                                      AS global_attribute9
                ,NULL                                                                      AS global_attribute10
                ,NULL                                                                      AS global_attribute11
                ,NULL                                                                      AS global_attribute12
                ,NULL                                                                      AS global_attribute13
                ,NULL                                                                      AS global_attribute14
                ,NULL                                                                      AS global_attribute15
                ,NULL                                                                      AS global_attribute16
                ,NULL                                                                      AS global_attribute17
                ,NULL                                                                      AS global_attribute18
                ,NULL                                                                      AS global_attribute19
                ,NULL                                                                      AS global_attribute20
                ,NULL                                                                      AS global_attribute_number1
                ,NULL                                                                      AS global_attribute_number2
                ,NULL                                                                      AS global_attribute_number3
                ,NULL                                                                      AS global_attribute_number4
                ,NULL                                                                      AS global_attribute_number5
                ,NULL                                                                      AS global_attribute_date1
                ,NULL                                                                      AS global_attribute_date2
                ,NULL                                                                      AS global_attribute_date3
                ,NULL                                                                      AS global_attribute_date4
                ,NULL                                                                      AS global_attribute_date5
                ,NULL                                                                      AS global_attribute_category
                ,fb.NBV_AT_SWITCH                                                          AS nbv_at_switch
                ,NULL                                                                      AS period_name_fully_reserved
                ,NULL                                                                      AS period_name_extended
                ,fb.prior_deprn_limit_type                                                 AS prior_deprn_limit_type
                ,fb.prior_deprn_limit                                                      AS prior_deprn_limit
                ,fb.prior_deprn_limit_amount                                               AS prior_deprn_limit_amount
                ,NULL                                                                      AS prior_method_code
                ,fb.prior_life_in_months                                                   AS prior_life_in_months
                ,fb.prior_basic_rate                                                       AS prior_basic_rate
                ,fb.prior_adjusted_rate                                                    AS prior_adjusted_rate
                ,NULL                                                                      AS asset_schedule_num
                ,fab.lease_number                                                          AS lease_number
                ,fds.reval_reserve                                                         AS reval_reserve
                ,fds.REVAL_LOSS_BALANCE                                                    AS reval_loss_balance
                ,fds.REVAL_AMORTIZATION_BASIS                                              AS reval_amortization_basis
                ,NULL                                                                      AS impair_loss_balance
                ,fb.reval_ceiling                                                          AS reval_ceiling
                ,NULL                                                                      AS fair_market_value
                ,NULL                                                                      AS last_price_index_value
                ,NULL                                                                      AS global_attribute_number6
                ,NULL                                                                      AS global_attribute_number7
                ,NULL                                                                      AS global_attribute_number8
                ,NULL                                                                      AS global_attribute_number9
                ,NULL                                                                      AS global_attribute_number10
                ,NULL                                                                      AS global_attribute_date6
                ,NULL                                                                      AS global_attribute_date7
                ,NULL                                                                      AS global_attribute_date8
                ,NULL                                                                      AS global_attribute_date9
                ,NULL                                                                      AS global_attribute_date10
                ,NULL                                                                      AS bk_global_attribute1
                ,NULL                                                                      AS bk_global_attribute2
                ,NULL                                                                      AS bk_global_attribute3
                ,NULL                                                                      AS bk_global_attribute4
                ,NULL                                                                      AS bk_global_attribute5
                ,NULL                                                                      AS bk_global_attribute6
                ,NULL                                                                      AS bk_global_attribute7
                ,NULL                                                                      AS bk_global_attribute8
                ,NULL                                                                      AS bk_global_attribute9
                ,NULL                                                                      AS bk_global_attribute10
                ,NULL                                                                      AS bk_global_attribute11
                ,NULL                                                                      AS bk_global_attribute12
                ,NULL                                                                      AS bk_global_attribute13
                ,NULL                                                                      AS bk_global_attribute14
                ,NULL                                                                      AS bk_global_attribute15
                ,NULL                                                                      AS bk_global_attribute16
                ,NULL                                                                      AS bk_global_attribute17
                ,NULL                                                                      AS bk_global_attribute18
                ,NULL                                                                      AS bk_global_attribute19
                ,NULL                                                                      AS bk_global_attribute20
                ,NULL                                                                      AS bk_global_attribute_number1
                ,NULL                                                                      AS bk_global_attribute_number2
                ,NULL                                                                      AS bk_global_attribute_number3
                ,NULL                                                                      AS bk_global_attribute_number4
                ,NULL                                                                      AS bk_global_attribute_number5
                ,NULL                                                                      AS bk_global_attribute_date1
                ,NULL                                                                      AS bk_global_attribute_date2
                ,NULL                                                                      AS bk_global_attribute_date3
                ,NULL                                                                      AS bk_global_attribute_date4
                ,NULL                                                                      AS bk_global_attribute_date5
                ,NULL                                                                      AS bk_global_attribute_category
                ,NULL                                                                      AS th_global_attribute1
                ,NULL                                                                      AS th_global_attribute2
                ,NULL                                                                      AS th_global_attribute3
                ,NULL                                                                      AS th_global_attribute4
                ,NULL                                                                      AS th_global_attribute5
                ,NULL                                                                      AS th_global_attribute6
                ,NULL                                                                      AS th_global_attribute7
                ,NULL                                                                      AS th_global_attribute8
                ,NULL                                                                      AS th_global_attribute9
                ,NULL                                                                      AS th_global_attribute10
                ,NULL                                                                      AS th_global_attribute11
                ,NULL                                                                      AS th_global_attribute12
                ,NULL                                                                      AS th_global_attribute13
                ,NULL                                                                      AS th_global_attribute14
                ,NULL                                                                      AS th_global_attribute15
                ,NULL                                                                      AS th_global_attribute16
                ,NULL                                                                      AS th_global_attribute17
                ,NULL                                                                      AS th_global_attribute18
                ,NULL                                                                      AS th_global_attribute19
                ,NULL                                                                      AS th_global_attribute20
                ,NULL                                                                      AS th_global_attribute_number1
                ,NULL                                                                      AS th_global_attribute_number2
                ,NULL                                                                      AS th_global_attribute_number3
                ,NULL                                                                      AS th_global_attribute_number4
                ,NULL                                                                      AS th_global_attribute_number5
                ,NULL                                                                      AS th_global_attribute_date1
                ,NULL                                                                      AS th_global_attribute_date2
                ,NULL                                                                      AS th_global_attribute_date3
                ,NULL                                                                      AS th_global_attribute_date4
                ,NULL                                                                      AS th_global_attribute_date5
                ,NULL                                                                      AS th_global_attribute_category
                ,NULL                                                                      AS ai_global_attribute1
                ,NULL                                                                      AS ai_global_attribute2
                ,NULL                                                                      AS ai_global_attribute3
                ,NULL                                                                      AS ai_global_attribute4
                ,NULL                                                                      AS ai_global_attribute5
                ,NULL                                                                      AS ai_global_attribute6
                ,NULL                                                                      AS ai_global_attribute7
                ,NULL                                                                      AS ai_global_attribute8
                ,NULL                                                                      AS ai_global_attribute9
                ,NULL                                                                      AS ai_global_attribute10
                ,NULL                                                                      AS ai_global_attribute11
                ,NULL                                                                      AS ai_global_attribute12
                ,NULL                                                                      AS ai_global_attribute13
                ,NULL                                                                      AS ai_global_attribute14
                ,NULL                                                                      AS ai_global_attribute15
                ,NULL                                                                      AS ai_global_attribute16
                ,NULL                                                                      AS ai_global_attribute17
                ,NULL                                                                      AS ai_global_attribute18
                ,NULL                                                                      AS ai_global_attribute19
                ,NULL                                                                      AS ai_global_attribute20
                ,NULL                                                                      AS ai_global_attribute_number1
                ,NULL                                                                      AS ai_global_attribute_number2
                ,NULL                                                                      AS ai_global_attribute_number3
                ,NULL                                                                      AS ai_global_attribute_number4
                ,NULL                                                                      AS ai_global_attribute_number5
                ,NULL                                                                      AS ai_global_attribute_date1
                ,NULL                                                                      AS ai_global_attribute_date2
                ,NULL                                                                      AS ai_global_attribute_date3
                ,NULL                                                                      AS ai_global_attribute_date4
                ,NULL                                                                      AS ai_global_attribute_date5
                ,NULL                                                                      AS ai_global_attribute_category
                ,NULL                                                                      AS vendor_name
                ,NULL                                                                      AS vendor_number
                ,NULL                                                                      AS po_number
                ,NULL                                                                      AS invoice_number
                ,NULL                                                                      AS invoice_voucher_number
                ,NULL                                                                      AS invoice_date
                ,NULL                                                                      AS payables_units
                ,NULL                                                                      AS invoice_line_number
                ,NULL                                                                      AS invoice_line_type
                ,NULL                                                                      AS invoice_line_description
                ,NULL                                                                      AS invoice_payment_number
                ,NULL                                                                      AS project_number
                ,NULL                                                                      AS project_task_number
                ,NULL                                                                      AS fully_reserve_on_add_flag
                ,NULL                                                                      AS deprn_adjustment_factor
                ,'FIXED_ASSET'||to_char(SYSDATE,'DDMMRRRRHHMISS')      AS  Batch_name
                ,NULL                                         AS created_by  -- constant
                ,NULL                                              AS  creation_date -- constant
                ,NULL                                         AS last_updated_by -- constant
                ,NULL                                             AS last_update_date -- constant
         FROM apps.fa_additions_v@xxmx_extract                 fab
           ,apps.fa_additions_tl@xxmx_extract                fat
           ,apps.fa_asset_keywords@xxmx_extract              fak
           ,apps.fa_books@xxmx_extract                       fb
           ,apps.fa_deprn_summary@xxmx_extract               fds
           ,apps.fa_categories_b@xxmx_extract                fac
           ,apps.fa_category_books@xxmx_extract              fcb
           ,apps.fa_deprn_periods@xxmx_extract               fdp
           ,apps.fa_book_controls@xxmx_extract               fbc
           ,XXMX_CORE.XXMX_FA_SCOPE_V                        fsv
        WHERE         fab.asset_id                         = fat.asset_id
         AND      fak.code_combination_id(+)           = fab.asset_key_ccid
         AND      fab.asset_id                         = fb.asset_id
         AND      fds.asset_id                         = fb.asset_id
         AND      fds.book_type_code                   = fb.book_type_code
         --and      fab.asset_id = 100080
         AND      fab.asset_category_id                = fac.category_id
         AND      fcb.category_id                      = fac.category_id
         AND      fds.book_type_code                   = fcb.book_type_code
         AND      TRUNC(sysdate)                 BETWEEN fb.date_effective AND NVL(fb.date_ineffective, sysdate)
         --AND      fdp.period_counter                   = DECODE (fbc.initial_period_counter,fds.period_counter, fds.period_counter + 1, fds.period_counter)
         AND      fdp.book_type_code                   = fds.book_type_code
         AND      fdp.period_counter                   =  fds.period_counter
         AND      fb.book_type_code                    = fbc.book_type_code
         and 	  fab.asset_id 						   = fsv.asset_id
		 and TRUNC(fb.date_placed_in_service) <=  TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY')) 
         AND      fds.book_type_code                   IN(SELECT parameter_value
                                                                  FROM XXMX_MIGRATION_PARAMETERS
                                                                   WHERE APPLICATION = 'FA'
                                                                   AND   application_suite = 'FIN'
                                                                   and parameter_code = 'BOOK_TYPE_CODE'
                                                                   AND ENABLED_FLAG='Y')
         AND      fds.period_counter                   = (SELECT MAX (fds1.period_counter)
                                                                  FROM   apps.fa_deprn_summary@xxmx_extract fds1
                                                                  WHERE  fds1.asset_id = fds.asset_id
                                                                  AND    fds1.book_type_code = fds.book_type_code
                                                                  AND    (TRUNC(fds1.DEPRN_RUN_DATE) <=  TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY')) or fds1.period_counter=gvv_period_counter)

                                                         )
         ;

        --AND  trunc(fb.date_placed_in_service)    <= trunc(to_date('31-AUG-2021', 'DD-MON-YYYY'))

       --
       -- Local Type Variables
       TYPE imp_massadd_src_tbl IS TABLE OF imp_massadd_src_cur%ROWTYPE INDEX BY BINARY_INTEGER;
       imp_massadd_src_tb  imp_massadd_src_tbl;
       --
       ld_begin_date             DATE;
       l_start_time              VARCHAR2(30);
       ex_dml_errors             EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;


       --
    BEGIN
	BEGIN
            EXECUTE IMMEDIATE ' alter session set NLS_language=''AMERICAN''';-- added by Laxmikanth
        END;

        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --

        gvv_migration_date := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite            =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'CUT_OFF_DATE'
        );
        --

        gvv_ProgressIndicator := '0010';
        xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    XXMX_FA_MASS_ADDITIONS_STG ;

        COMMIT;
        --
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --
BEGIN
select PERIOD_COUNTER 
into gvv_period_counter  
from apps.fa_deprn_periods@xxmx_extract  
where PERIOD_NAME=to_char(TO_DATE(gvv_migration_date, 'DD-MON-YYYY'),'MON-YY') and rownum=1;

END;

           OPEN imp_massadd_src_cur;
           --
           LOOP
           --

           gvv_ProgressIndicator := '0020';
           xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Inside the CURSOR loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           FETCH imp_massadd_src_cur  BULK COLLECT INTO imp_massadd_src_tb LIMIT 1000;
           --

            gvv_ProgressIndicator := '0020';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'CURSOR imp_massadd_src_cur Fetch into imp_massadd_src_tb - ' || TRUNC(TO_DATE(gvv_migration_date, 'DD-MON-YYYY'))
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           EXIT WHEN imp_massadd_src_tb.COUNT=0;
           --
           FORALL i IN 1..imp_massadd_src_tb.COUNT SAVE EXCEPTIONS
           --
             INSERT
             INTO xxmx_stg.XXMX_FA_MASS_ADDITIONS_STG
                    (
                   mass_addition_id
                  ,Migration_Status
                  ,migration_set_name
                  ,book_type_code
                  ,transaction_name
                  ,asset_number
                  ,description
                  ,tag_number
                  ,manufacturer_name
                  ,serial_number
                  ,model_number
                  ,asset_type
                  ,fixed_assets_cost
                  ,date_placed_in_service
                  ,prorate_convention_code
                  ,fixed_assets_units
                  ,category_segment1
                  ,category_segment2
                  ,category_segment3
                  ,category_segment4
                  ,category_segment5
                  ,category_segment6
                  ,category_segment7
                  ,posting_status
                  ,queue_name
                  ,feeder_system_name
                  ,parent_asset_number
                  ,add_to_asset_number
                  ,asset_key_segment1
                  ,asset_key_segment2
                  ,asset_key_segment3
                  ,asset_key_segment4
                  ,asset_key_segment5
                  ,asset_key_segment6
                  ,asset_key_segment7
                  ,asset_key_segment8
                  ,asset_key_segment9
                  ,asset_key_segment10
                  ,inventorial
                  ,property_type_code
                  ,property_1245_1250_code
                  ,in_use_flag
                  ,owned_leased
                  ,new_used
                  ,material_indicator_flag
                  ,commitment
                  ,investment_law
                  ,amortize_flag
                  ,amortization_start_date
                  ,depreciate_flag
                  ,salvage_type
                  ,salvage_value
                  ,percent_salvage_value
                  ,ytd_deprn
                  ,deprn_reserve
                  ,bonus_ytd_deprn
                  ,bonus_deprn_reserve
                  ,ytd_impairment
                  ,impairment_reserve
                  ,method_code
                  ,life_in_months
                  ,basic_rate
                  ,adjusted_rate
                  ,unit_of_measure
                  ,production_capacity
                  ,ceiling_name
                  ,bonus_rule
                  ,cash_generating_unit
                  ,deprn_limit_type
                  ,allowed_deprn_limit
                  ,allowed_deprn_limit_amount
                  ,payables_cost
                  ,clearing_acct_segment1
                  ,clearing_acct_segment2
                  ,clearing_acct_segment3
                  ,clearing_acct_segment4
                  ,clearing_acct_segment5
                  ,clearing_acct_segment6
                  ,clearing_acct_segment7
                  ,clearing_acct_segment8
                  ,clearing_acct_segment9
                  ,clearing_acct_segment10
                  ,clearing_acct_segment11
                  ,clearing_acct_segment12
                  ,clearing_acct_segment13
                  ,clearing_acct_segment14
                  ,clearing_acct_segment15
                  ,clearing_acct_segment16
                  ,clearing_acct_segment17
                  ,clearing_acct_segment18
                  ,clearing_acct_segment19
                  ,clearing_acct_segment20
                  ,clearing_acct_segment21
                  ,clearing_acct_segment22
                  ,clearing_acct_segment23
                  ,clearing_acct_segment24
                  ,clearing_acct_segment25
                  ,clearing_acct_segment26
                  ,clearing_acct_segment27
                  ,clearing_acct_segment28
                  ,clearing_acct_segment29
                  ,clearing_acct_segment30
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
                  ,attribute_date1
                  ,attribute_date2
                  ,attribute_date3
                  ,attribute_date4
                  ,attribute_date5
                  ,attribute_category_code
                  ,context
                  ,th_attribute1
                  ,th_attribute2
                  ,th_attribute3
                  ,th_attribute4
                  ,th_attribute5
                  ,th_attribute6
                  ,th_attribute7
                  ,th_attribute8
                  ,th_attribute9
                  ,th_attribute10
                  ,th_attribute11
                  ,th_attribute12
                  ,th_attribute13
                  ,th_attribute14
                  ,th_attribute15
                  ,th_attribute_number1
                  ,th_attribute_number2
                  ,th_attribute_number3
                  ,th_attribute_number4
                  ,th_attribute_number5
                  ,th_attribute_date1
                  ,th_attribute_date2
                  ,th_attribute_date3
                  ,th_attribute_date4
                  ,th_attribute_date5
                  ,th_attribute_category_code
                  ,th2_attribute1
                  ,th2_attribute2
                  ,th2_attribute3
                  ,th2_attribute4
                  ,th2_attribute5
                  ,th2_attribute6
                  ,th2_attribute7
                  ,th2_attribute8
                  ,th2_attribute9
                  ,th2_attribute10
                  ,th2_attribute11
                  ,th2_attribute12
                  ,th2_attribute13
                  ,th2_attribute14
                  ,th2_attribute15
                  ,th2_attribute_number1
                  ,th2_attribute_number2
                  ,th2_attribute_number3
                  ,th2_attribute_number4
                  ,th2_attribute_number5
                  ,th2_attribute_date1
                  ,th2_attribute_date2
                  ,th2_attribute_date3
                  ,th2_attribute_date4
                  ,th2_attribute_date5
                  ,th2_attribute_category_code
                  ,ai_attribute1
                  ,ai_attribute2
                  ,ai_attribute3
                  ,ai_attribute4
                  ,ai_attribute5
                  ,ai_attribute6
                  ,ai_attribute7
                  ,ai_attribute8
                  ,ai_attribute9
                  ,ai_attribute10
                  ,ai_attribute11
                  ,ai_attribute12
                  ,ai_attribute13
                  ,ai_attribute14
                  ,ai_attribute15
                  ,ai_attribute_number1
                  ,ai_attribute_number2
                  ,ai_attribute_number3
                  ,ai_attribute_number4
                  ,ai_attribute_number5
                  ,ai_attribute_date1
                  ,ai_attribute_date2
                  ,ai_attribute_date3
                  ,ai_attribute_date4
                  ,ai_attribute_date5
                  ,ai_attribute_category_code
                  ,mass_property_flag
                  ,group_asset_number
                  ,reduction_rate
                  ,reduce_addition_flag
                  ,reduce_adjustment_flag
                  ,reduce_retirement_flag
                  ,recognize_gain_loss
                  ,recapture_reserve_flag
                  ,limit_proceeds_flag
                  ,terminal_gain_loss
                  ,tracking_method
                  ,excess_allocation_option
                  ,depreciation_option
                  ,member_rollup_flag
                  ,allocate_to_fully_rsv_flag
                  ,over_depreciate_option
                  ,preparer_email_address
                  ,merged_code
                  ,parent_mass_addition_id
                  ,sum_units
                  ,new_master_flag
                  ,units_to_adjust
                  ,short_fiscal_year_flag
                  ,conversion_date
                  ,original_deprn_start_date
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
                  ,global_attribute_category
                  ,nbv_at_switch
                  ,period_name_fully_reserved
                  ,period_name_extended
                  ,prior_deprn_limit_type
                  ,prior_deprn_limit
                  ,prior_deprn_limit_amount
                  ,prior_method_code
                  ,prior_life_in_months
                  ,prior_basic_rate
                  ,prior_adjusted_rate
                  ,asset_schedule_num
                  ,lease_number
                  ,reval_reserve
                  ,reval_loss_balance
                  ,reval_amortization_basis
                  ,impair_loss_balance
                  ,reval_ceiling
                  ,fair_market_value
                  ,last_price_index_value
                  ,global_attribute_number6
                  ,global_attribute_number7
                  ,global_attribute_number8
                  ,global_attribute_number9
                  ,global_attribute_number10
                  ,global_attribute_date6
                  ,global_attribute_date7
                  ,global_attribute_date8
                  ,global_attribute_date9
                  ,global_attribute_date10
                  ,bk_global_attribute1
                  ,bk_global_attribute2
                  ,bk_global_attribute3
                  ,bk_global_attribute4
                  ,bk_global_attribute5
                  ,bk_global_attribute6
                  ,bk_global_attribute7
                  ,bk_global_attribute8
                  ,bk_global_attribute9
                  ,bk_global_attribute10
                  ,bk_global_attribute11
                  ,bk_global_attribute12
                  ,bk_global_attribute13
                  ,bk_global_attribute14
                  ,bk_global_attribute15
                  ,bk_global_attribute16
                  ,bk_global_attribute17
                  ,bk_global_attribute18
                  ,bk_global_attribute19
                  ,bk_global_attribute20
                  ,bk_global_attribute_number1
                  ,bk_global_attribute_number2
                  ,bk_global_attribute_number3
                  ,bk_global_attribute_number4
                  ,bk_global_attribute_number5
                  ,bk_global_attribute_date1
                  ,bk_global_attribute_date2
                  ,bk_global_attribute_date3
                  ,bk_global_attribute_date4
                  ,bk_global_attribute_date5
                  ,bk_global_attribute_category
                  ,th_global_attribute1
                  ,th_global_attribute2
                  ,th_global_attribute3
                  ,th_global_attribute4
                  ,th_global_attribute5
                  ,th_global_attribute6
                  ,th_global_attribute7
                  ,th_global_attribute8
                  ,th_global_attribute9
                  ,th_global_attribute10
                  ,th_global_attribute11
                  ,th_global_attribute12
                  ,th_global_attribute13
                  ,th_global_attribute14
                  ,th_global_attribute15
                  ,th_global_attribute16
                  ,th_global_attribute17
                  ,th_global_attribute18
                  ,th_global_attribute19
                  ,th_global_attribute20
                  ,th_global_attribute_number1
                  ,th_global_attribute_number2
                  ,th_global_attribute_number3
                  ,th_global_attribute_number4
                  ,th_global_attribute_number5
                  ,th_global_attribute_date1
                  ,th_global_attribute_date2
                  ,th_global_attribute_date3
                  ,th_global_attribute_date4
                  ,th_global_attribute_date5
                  ,th_global_attribute_category
                  ,ai_global_attribute1
                  ,ai_global_attribute2
                  ,ai_global_attribute3
                  ,ai_global_attribute4
                  ,ai_global_attribute5
                  ,ai_global_attribute6
                  ,ai_global_attribute7
                  ,ai_global_attribute8
                  ,ai_global_attribute9
                  ,ai_global_attribute10
                  ,ai_global_attribute11
                  ,ai_global_attribute12
                  ,ai_global_attribute13
                  ,ai_global_attribute14
                  ,ai_global_attribute15
                  ,ai_global_attribute16
                  ,ai_global_attribute17
                  ,ai_global_attribute18
                  ,ai_global_attribute19
                  ,ai_global_attribute20
                  ,ai_global_attribute_number1
                  ,ai_global_attribute_number2
                  ,ai_global_attribute_number3
                  ,ai_global_attribute_number4
                  ,ai_global_attribute_number5
                  ,ai_global_attribute_date1
                  ,ai_global_attribute_date2
                  ,ai_global_attribute_date3
                  ,ai_global_attribute_date4
                  ,ai_global_attribute_date5
                  ,ai_global_attribute_category
                  ,vendor_name
                  ,vendor_number
                  ,po_number
                  ,invoice_number
                  ,invoice_voucher_number
                  ,invoice_date
                  ,payables_units
                  ,invoice_line_number
                  ,invoice_line_type
                  ,invoice_line_description
                  ,invoice_payment_number
                  ,project_number
                  ,project_task_number
                  ,fully_reserve_on_add_flag
                  ,deprn_adjustment_factor
                  ,creation_date
                  ,created_by
                  ,last_update_date
                  ,last_updated_by
                  ,migration_set_id
                  )
          VALUES (
                   imp_massadd_src_tb(i).mass_addition_id
                  ,'EXTRACTED'
                  ,gvt_MigrationSetName
                  ,imp_massadd_src_tb(i).book_type_code
                  ,imp_massadd_src_tb(i).transaction_name
                  ,imp_massadd_src_tb(i).asset_number
                  ,imp_massadd_src_tb(i).description
                  ,imp_massadd_src_tb(i).tag_number
                  ,imp_massadd_src_tb(i).manufacturer_name
                  ,imp_massadd_src_tb(i).serial_number
                  ,imp_massadd_src_tb(i).model_number
                  ,imp_massadd_src_tb(i).asset_type
                  ,imp_massadd_src_tb(i).fixed_assets_cost
                  ,imp_massadd_src_tb(i).date_placed_in_service
                  ,imp_massadd_src_tb(i).prorate_convention_code
                  ,imp_massadd_src_tb(i).fixed_assets_units
                  ,imp_massadd_src_tb(i).category_segment1
                  ,imp_massadd_src_tb(i).category_segment2
                  ,imp_massadd_src_tb(i).category_segment3
                  ,imp_massadd_src_tb(i).category_segment4
                  ,imp_massadd_src_tb(i).category_segment5
                  ,imp_massadd_src_tb(i).category_segment6
                  ,imp_massadd_src_tb(i).category_segment7
                  ,imp_massadd_src_tb(i).posting_status
                  ,imp_massadd_src_tb(i).queue_name
                  ,imp_massadd_src_tb(i).feeder_system_name
                  ,imp_massadd_src_tb(i).parent_asset_number
                  ,imp_massadd_src_tb(i).add_to_asset_number
                  ,imp_massadd_src_tb(i).asset_key_segment1
                  ,imp_massadd_src_tb(i).asset_key_segment2
                  ,imp_massadd_src_tb(i).asset_key_segment3
                  ,imp_massadd_src_tb(i).asset_key_segment4
                  ,imp_massadd_src_tb(i).asset_key_segment5
                  ,imp_massadd_src_tb(i).asset_key_segment6
                  ,imp_massadd_src_tb(i).asset_key_segment7
                  ,imp_massadd_src_tb(i).asset_key_segment8
                  ,imp_massadd_src_tb(i).asset_key_segment9
                  ,imp_massadd_src_tb(i).asset_key_segment10
                  ,imp_massadd_src_tb(i).inventorial
                  ,imp_massadd_src_tb(i).property_type_code
                  ,imp_massadd_src_tb(i).property_1245_1250_code
                  ,imp_massadd_src_tb(i).in_use_flag
                  ,imp_massadd_src_tb(i).owned_leased
                  ,imp_massadd_src_tb(i).new_used
                  ,imp_massadd_src_tb(i).material_indicator_flag
                  ,imp_massadd_src_tb(i).commitment
                  ,imp_massadd_src_tb(i).investment_law
                  ,imp_massadd_src_tb(i).amortize_flag
                  ,imp_massadd_src_tb(i).amortization_start_date
                  ,imp_massadd_src_tb(i).depreciate_flag
                  ,imp_massadd_src_tb(i).salvage_type
                  ,imp_massadd_src_tb(i).salvage_value
                  ,imp_massadd_src_tb(i).percent_salvage_value
                  ,imp_massadd_src_tb(i).ytd_deprn
                  ,imp_massadd_src_tb(i).deprn_reserve
                  ,imp_massadd_src_tb(i).bonus_ytd_deprn
                  ,imp_massadd_src_tb(i).bonus_deprn_reserve
                  ,CASE WHEN NVL(imp_massadd_src_tb(i).ytd_impairment, 0) < 0
                   THEN 0
                   ELSE imp_massadd_src_tb(i).ytd_impairment END
                  ,CASE WHEN NVL(imp_massadd_src_tb(i).impairment_reserve, 0) < 0
                   THEN 0
                   ELSE imp_massadd_src_tb(i).impairment_reserve END
                  ,imp_massadd_src_tb(i).method_code
                  ,imp_massadd_src_tb(i).life_in_months
                  ,imp_massadd_src_tb(i).basic_rate
                  ,imp_massadd_src_tb(i).adjusted_rate
                  ,imp_massadd_src_tb(i).unit_of_measure
                  ,imp_massadd_src_tb(i).production_capacity
                  ,imp_massadd_src_tb(i).ceiling_name
                  ,imp_massadd_src_tb(i).bonus_rule
                  ,imp_massadd_src_tb(i).cash_generating_unit
                  ,imp_massadd_src_tb(i).deprn_limit_type
                  ,imp_massadd_src_tb(i).allowed_deprn_limit
                  ,imp_massadd_src_tb(i).allowed_deprn_limit_amount
                  ,imp_massadd_src_tb(i).payables_cost
                  ,imp_massadd_src_tb(i).clearing_acct_segment1
                  ,imp_massadd_src_tb(i).clearing_acct_segment2
                  ,imp_massadd_src_tb(i).clearing_acct_segment3
                  ,imp_massadd_src_tb(i).clearing_acct_segment4
                  ,imp_massadd_src_tb(i).clearing_acct_segment5
                  ,imp_massadd_src_tb(i).clearing_acct_segment6
                  ,imp_massadd_src_tb(i).clearing_acct_segment7
                  ,imp_massadd_src_tb(i).clearing_acct_segment8
                  ,imp_massadd_src_tb(i).clearing_acct_segment9
                  ,imp_massadd_src_tb(i).clearing_acct_segment10
                  ,imp_massadd_src_tb(i).clearing_acct_segment11
                  ,imp_massadd_src_tb(i).clearing_acct_segment12
                  ,imp_massadd_src_tb(i).clearing_acct_segment13
                  ,imp_massadd_src_tb(i).clearing_acct_segment14
                  ,imp_massadd_src_tb(i).clearing_acct_segment15
                  ,imp_massadd_src_tb(i).clearing_acct_segment16
                  ,imp_massadd_src_tb(i).clearing_acct_segment17
                  ,imp_massadd_src_tb(i).clearing_acct_segment18
                  ,imp_massadd_src_tb(i).clearing_acct_segment19
                  ,imp_massadd_src_tb(i).clearing_acct_segment20
                  ,imp_massadd_src_tb(i).clearing_acct_segment21
                  ,imp_massadd_src_tb(i).clearing_acct_segment22
                  ,imp_massadd_src_tb(i).clearing_acct_segment23
                  ,imp_massadd_src_tb(i).clearing_acct_segment24
                  ,imp_massadd_src_tb(i).clearing_acct_segment25
                  ,imp_massadd_src_tb(i).clearing_acct_segment26
                  ,imp_massadd_src_tb(i).clearing_acct_segment27
                  ,imp_massadd_src_tb(i).clearing_acct_segment28
                  ,imp_massadd_src_tb(i).clearing_acct_segment29
                  ,imp_massadd_src_tb(i).clearing_acct_segment30
                  ,imp_massadd_src_tb(i).attribute1
                  ,imp_massadd_src_tb(i).attribute2
                  ,imp_massadd_src_tb(i).attribute3
                  ,imp_massadd_src_tb(i).attribute4
                  ,imp_massadd_src_tb(i).attribute5
                  ,imp_massadd_src_tb(i).attribute6
                  ,imp_massadd_src_tb(i).attribute7
                  ,imp_massadd_src_tb(i).attribute8
                  ,imp_massadd_src_tb(i).attribute9
                  ,imp_massadd_src_tb(i).attribute10
                  ,imp_massadd_src_tb(i).attribute11
                  ,imp_massadd_src_tb(i).attribute12
                  ,imp_massadd_src_tb(i).attribute13
                  ,imp_massadd_src_tb(i).attribute14
                  ,imp_massadd_src_tb(i).attribute15
                  ,imp_massadd_src_tb(i).attribute16
                  ,imp_massadd_src_tb(i).attribute17
                  ,imp_massadd_src_tb(i).attribute18
                  ,imp_massadd_src_tb(i).attribute19
                  ,imp_massadd_src_tb(i).attribute20
                  ,imp_massadd_src_tb(i).attribute21
                  ,imp_massadd_src_tb(i).attribute22
                  ,imp_massadd_src_tb(i).attribute23
                  ,imp_massadd_src_tb(i).attribute24
                  ,imp_massadd_src_tb(i).attribute25
                  ,imp_massadd_src_tb(i).attribute26
                  ,imp_massadd_src_tb(i).attribute27
                  ,imp_massadd_src_tb(i).attribute28
                  ,imp_massadd_src_tb(i).attribute29
                  ,imp_massadd_src_tb(i).attribute30
                  ,imp_massadd_src_tb(i).attribute_number1
                  ,imp_massadd_src_tb(i).attribute_number2
                  ,imp_massadd_src_tb(i).attribute_number3
                  ,imp_massadd_src_tb(i).attribute_number4
                  ,imp_massadd_src_tb(i).attribute_number5
                  ,imp_massadd_src_tb(i).attribute_date1
                  ,imp_massadd_src_tb(i).attribute_date2
                  ,imp_massadd_src_tb(i).attribute_date3
                  ,imp_massadd_src_tb(i).attribute_date4
                  ,imp_massadd_src_tb(i).attribute_date5
                  ,imp_massadd_src_tb(i).attribute_category_code
                  ,imp_massadd_src_tb(i).context
                  ,imp_massadd_src_tb(i).th_attribute1
                  ,imp_massadd_src_tb(i).th_attribute2
                  ,imp_massadd_src_tb(i).th_attribute3
                  ,imp_massadd_src_tb(i).th_attribute4
                  ,imp_massadd_src_tb(i).th_attribute5
                  ,imp_massadd_src_tb(i).th_attribute6
                  ,imp_massadd_src_tb(i).th_attribute7
                  ,imp_massadd_src_tb(i).th_attribute8
                  ,imp_massadd_src_tb(i).th_attribute9
                  ,imp_massadd_src_tb(i).th_attribute10
                  ,imp_massadd_src_tb(i).th_attribute11
                  ,imp_massadd_src_tb(i).th_attribute12
                  ,imp_massadd_src_tb(i).th_attribute13
                  ,imp_massadd_src_tb(i).th_attribute14
                  ,imp_massadd_src_tb(i).th_attribute15
                  ,imp_massadd_src_tb(i).th_attribute_number1
                  ,imp_massadd_src_tb(i).th_attribute_number2
                  ,imp_massadd_src_tb(i).th_attribute_number3
                  ,imp_massadd_src_tb(i).th_attribute_number4
                  ,imp_massadd_src_tb(i).th_attribute_number5
                  ,imp_massadd_src_tb(i).th_attribute_date1
                  ,imp_massadd_src_tb(i).th_attribute_date2
                  ,imp_massadd_src_tb(i).th_attribute_date3
                  ,imp_massadd_src_tb(i).th_attribute_date4
                  ,imp_massadd_src_tb(i).th_attribute_date5
                  ,imp_massadd_src_tb(i).th_attribute_category_code
                  ,imp_massadd_src_tb(i).th2_attribute1
                  ,imp_massadd_src_tb(i).th2_attribute2
                  ,imp_massadd_src_tb(i).th2_attribute3
                  ,imp_massadd_src_tb(i).th2_attribute4
                  ,imp_massadd_src_tb(i).th2_attribute5
                  ,imp_massadd_src_tb(i).th2_attribute6
                  ,imp_massadd_src_tb(i).th2_attribute7
                  ,imp_massadd_src_tb(i).th2_attribute8
                  ,imp_massadd_src_tb(i).th2_attribute9
                  ,imp_massadd_src_tb(i).th2_attribute10
                  ,imp_massadd_src_tb(i).th2_attribute11
                  ,imp_massadd_src_tb(i).th2_attribute12
                  ,imp_massadd_src_tb(i).th2_attribute13
                  ,imp_massadd_src_tb(i).th2_attribute14
                  ,imp_massadd_src_tb(i).th2_attribute15
                  ,imp_massadd_src_tb(i).th2_attribute_number1
                  ,imp_massadd_src_tb(i).th2_attribute_number2
                  ,imp_massadd_src_tb(i).th2_attribute_number3
                  ,imp_massadd_src_tb(i).th2_attribute_number4
                  ,imp_massadd_src_tb(i).th2_attribute_number5
                  ,imp_massadd_src_tb(i).th2_attribute_date1
                  ,imp_massadd_src_tb(i).th2_attribute_date2
                  ,imp_massadd_src_tb(i).th2_attribute_date3
                  ,imp_massadd_src_tb(i).th2_attribute_date4
                  ,imp_massadd_src_tb(i).th2_attribute_date5
                  ,imp_massadd_src_tb(i).th2_attribute_category_code
                  ,imp_massadd_src_tb(i).ai_attribute1
                  ,imp_massadd_src_tb(i).ai_attribute2
                  ,imp_massadd_src_tb(i).ai_attribute3
                  ,imp_massadd_src_tb(i).ai_attribute4
                  ,imp_massadd_src_tb(i).ai_attribute5
                  ,imp_massadd_src_tb(i).ai_attribute6
                  ,imp_massadd_src_tb(i).ai_attribute7
                  ,imp_massadd_src_tb(i).ai_attribute8
                  ,imp_massadd_src_tb(i).ai_attribute9
                  ,imp_massadd_src_tb(i).ai_attribute10
                  ,imp_massadd_src_tb(i).ai_attribute11
                  ,imp_massadd_src_tb(i).ai_attribute12
                  ,imp_massadd_src_tb(i).ai_attribute13
                  ,imp_massadd_src_tb(i).ai_attribute14
                  ,imp_massadd_src_tb(i).ai_attribute15
                  ,imp_massadd_src_tb(i).ai_attribute_number1
                  ,imp_massadd_src_tb(i).ai_attribute_number2
                  ,imp_massadd_src_tb(i).ai_attribute_number3
                  ,imp_massadd_src_tb(i).ai_attribute_number4
                  ,imp_massadd_src_tb(i).ai_attribute_number5
                  ,imp_massadd_src_tb(i).ai_attribute_date1
                  ,imp_massadd_src_tb(i).ai_attribute_date2
                  ,imp_massadd_src_tb(i).ai_attribute_date3
                  ,imp_massadd_src_tb(i).ai_attribute_date4
                  ,imp_massadd_src_tb(i).ai_attribute_date5
                  ,imp_massadd_src_tb(i).ai_attribute_category_code
                  ,imp_massadd_src_tb(i).mass_property_flag
                  ,imp_massadd_src_tb(i).group_asset_number
                  ,imp_massadd_src_tb(i).reduction_rate
                  ,imp_massadd_src_tb(i).reduce_addition_flag
                  ,imp_massadd_src_tb(i).reduce_adjustment_flag
                  ,imp_massadd_src_tb(i).reduce_retirement_flag
                  ,imp_massadd_src_tb(i).recognize_gain_loss
                  ,imp_massadd_src_tb(i).recapture_reserve_flag
                  ,imp_massadd_src_tb(i).limit_proceeds_flag
                  ,imp_massadd_src_tb(i).terminal_gain_loss
                  ,imp_massadd_src_tb(i).tracking_method
                  ,imp_massadd_src_tb(i).excess_allocation_option
                  ,imp_massadd_src_tb(i).depreciation_option
                  ,imp_massadd_src_tb(i).member_rollup_flag
                  ,imp_massadd_src_tb(i).allocate_to_fully_rsv_flag
                  ,imp_massadd_src_tb(i).over_depreciate_option
                  ,imp_massadd_src_tb(i).preparer_email_address
                  ,imp_massadd_src_tb(i).merged_code
                  ,imp_massadd_src_tb(i).parent_mass_addition_id
                  ,imp_massadd_src_tb(i).sum_units
                  ,imp_massadd_src_tb(i).new_master_flag
                  ,imp_massadd_src_tb(i).units_to_adjust
                  ,imp_massadd_src_tb(i).short_fiscal_year_flag
                  ,imp_massadd_src_tb(i).conversion_date
                  ,imp_massadd_src_tb(i).original_deprn_start_date
                  ,imp_massadd_src_tb(i).global_attribute1
                  ,imp_massadd_src_tb(i).global_attribute2
                  ,imp_massadd_src_tb(i).global_attribute3
                  ,imp_massadd_src_tb(i).global_attribute4
                  ,imp_massadd_src_tb(i).global_attribute5
                  ,imp_massadd_src_tb(i).global_attribute6
                  ,imp_massadd_src_tb(i).global_attribute7
                  ,imp_massadd_src_tb(i).global_attribute8
                  ,imp_massadd_src_tb(i).global_attribute9
                  ,imp_massadd_src_tb(i).global_attribute10
                  ,imp_massadd_src_tb(i).global_attribute11
                  ,imp_massadd_src_tb(i).global_attribute12
                  ,imp_massadd_src_tb(i).global_attribute13
                  ,imp_massadd_src_tb(i).global_attribute14
                  ,imp_massadd_src_tb(i).global_attribute15
                  ,imp_massadd_src_tb(i).global_attribute16
                  ,imp_massadd_src_tb(i).global_attribute17
                  ,imp_massadd_src_tb(i).global_attribute18
                  ,imp_massadd_src_tb(i).global_attribute19
                  ,imp_massadd_src_tb(i).global_attribute20
                  ,imp_massadd_src_tb(i).global_attribute_number1
                  ,imp_massadd_src_tb(i).global_attribute_number2
                  ,imp_massadd_src_tb(i).global_attribute_number3
                  ,imp_massadd_src_tb(i).global_attribute_number4
                  ,imp_massadd_src_tb(i).global_attribute_number5
                  ,imp_massadd_src_tb(i).global_attribute_date1
                  ,imp_massadd_src_tb(i).global_attribute_date2
                  ,imp_massadd_src_tb(i).global_attribute_date3
                  ,imp_massadd_src_tb(i).global_attribute_date4
                  ,imp_massadd_src_tb(i).global_attribute_date5
                  ,imp_massadd_src_tb(i).global_attribute_category
                  ,imp_massadd_src_tb(i).nbv_at_switch
                  ,imp_massadd_src_tb(i).period_name_fully_reserved
                  ,imp_massadd_src_tb(i).period_name_extended
                  ,imp_massadd_src_tb(i).prior_deprn_limit_type
                  ,imp_massadd_src_tb(i).prior_deprn_limit
                  ,imp_massadd_src_tb(i).prior_deprn_limit_amount
                  ,imp_massadd_src_tb(i).prior_method_code
                  ,imp_massadd_src_tb(i).prior_life_in_months
                  ,imp_massadd_src_tb(i).prior_basic_rate
                  ,imp_massadd_src_tb(i).prior_adjusted_rate
                  ,imp_massadd_src_tb(i).asset_schedule_num
                  ,imp_massadd_src_tb(i).lease_number
                  ,imp_massadd_src_tb(i).reval_reserve
                  ,imp_massadd_src_tb(i).reval_loss_balance
                  ,imp_massadd_src_tb(i).reval_amortization_basis
                  ,imp_massadd_src_tb(i).impair_loss_balance
                  ,imp_massadd_src_tb(i).reval_ceiling
                  ,imp_massadd_src_tb(i).fair_market_value
                  ,imp_massadd_src_tb(i).last_price_index_value
                  ,imp_massadd_src_tb(i).global_attribute_number6
                  ,imp_massadd_src_tb(i).global_attribute_number7
                  ,imp_massadd_src_tb(i).global_attribute_number8
                  ,imp_massadd_src_tb(i).global_attribute_number9
                  ,imp_massadd_src_tb(i).global_attribute_number10
                  ,imp_massadd_src_tb(i).global_attribute_date6
                  ,imp_massadd_src_tb(i).global_attribute_date7
                  ,imp_massadd_src_tb(i).global_attribute_date8
                  ,imp_massadd_src_tb(i).global_attribute_date9
                  ,imp_massadd_src_tb(i).global_attribute_date10
                  ,imp_massadd_src_tb(i).bk_global_attribute1
                  ,imp_massadd_src_tb(i).bk_global_attribute2
                  ,imp_massadd_src_tb(i).bk_global_attribute3
                  ,imp_massadd_src_tb(i).bk_global_attribute4
                  ,imp_massadd_src_tb(i).bk_global_attribute5
                  ,imp_massadd_src_tb(i).bk_global_attribute6
                  ,imp_massadd_src_tb(i).bk_global_attribute7
                  ,imp_massadd_src_tb(i).bk_global_attribute8
                  ,imp_massadd_src_tb(i).bk_global_attribute9
                  ,imp_massadd_src_tb(i).bk_global_attribute10
                  ,imp_massadd_src_tb(i).bk_global_attribute11
                  ,imp_massadd_src_tb(i).bk_global_attribute12
                  ,imp_massadd_src_tb(i).bk_global_attribute13
                  ,imp_massadd_src_tb(i).bk_global_attribute14
                  ,imp_massadd_src_tb(i).bk_global_attribute15
                  ,imp_massadd_src_tb(i).bk_global_attribute16
                  ,imp_massadd_src_tb(i).bk_global_attribute17
                  ,imp_massadd_src_tb(i).bk_global_attribute18
                  ,imp_massadd_src_tb(i).bk_global_attribute19
                  ,imp_massadd_src_tb(i).bk_global_attribute20
                  ,imp_massadd_src_tb(i).bk_global_attribute_number1
                  ,imp_massadd_src_tb(i).bk_global_attribute_number2
                  ,imp_massadd_src_tb(i).bk_global_attribute_number3
                  ,imp_massadd_src_tb(i).bk_global_attribute_number4
                  ,imp_massadd_src_tb(i).bk_global_attribute_number5
                  ,imp_massadd_src_tb(i).bk_global_attribute_date1
                  ,imp_massadd_src_tb(i).bk_global_attribute_date2
                  ,imp_massadd_src_tb(i).bk_global_attribute_date3
                  ,imp_massadd_src_tb(i).bk_global_attribute_date4
                  ,imp_massadd_src_tb(i).bk_global_attribute_date5
                  ,imp_massadd_src_tb(i).bk_global_attribute_category
                  ,imp_massadd_src_tb(i).th_global_attribute1
                  ,imp_massadd_src_tb(i).th_global_attribute2
                  ,imp_massadd_src_tb(i).th_global_attribute3
                  ,imp_massadd_src_tb(i).th_global_attribute4
                  ,imp_massadd_src_tb(i).th_global_attribute5
                  ,imp_massadd_src_tb(i).th_global_attribute6
                  ,imp_massadd_src_tb(i).th_global_attribute7
                  ,imp_massadd_src_tb(i).th_global_attribute8
                  ,imp_massadd_src_tb(i).th_global_attribute9
                  ,imp_massadd_src_tb(i).th_global_attribute10
                  ,imp_massadd_src_tb(i).th_global_attribute11
                  ,imp_massadd_src_tb(i).th_global_attribute12
                  ,imp_massadd_src_tb(i).th_global_attribute13
                  ,imp_massadd_src_tb(i).th_global_attribute14
                  ,imp_massadd_src_tb(i).th_global_attribute15
                  ,imp_massadd_src_tb(i).th_global_attribute16
                  ,imp_massadd_src_tb(i).th_global_attribute17
                  ,imp_massadd_src_tb(i).th_global_attribute18
                  ,imp_massadd_src_tb(i).th_global_attribute19
                  ,imp_massadd_src_tb(i).th_global_attribute20
                  ,imp_massadd_src_tb(i).th_global_attribute_number1
                  ,imp_massadd_src_tb(i).th_global_attribute_number2
                  ,imp_massadd_src_tb(i).th_global_attribute_number3
                  ,imp_massadd_src_tb(i).th_global_attribute_number4
                  ,imp_massadd_src_tb(i).th_global_attribute_number5
                  ,imp_massadd_src_tb(i).th_global_attribute_date1
                  ,imp_massadd_src_tb(i).th_global_attribute_date2
                  ,imp_massadd_src_tb(i).th_global_attribute_date3
                  ,imp_massadd_src_tb(i).th_global_attribute_date4
                  ,imp_massadd_src_tb(i).th_global_attribute_date5
                  ,imp_massadd_src_tb(i).th_global_attribute_category
                  ,imp_massadd_src_tb(i).ai_global_attribute1
                  ,imp_massadd_src_tb(i).ai_global_attribute2
                  ,imp_massadd_src_tb(i).ai_global_attribute3
                  ,imp_massadd_src_tb(i).ai_global_attribute4
                  ,imp_massadd_src_tb(i).ai_global_attribute5
                  ,imp_massadd_src_tb(i).ai_global_attribute6
                  ,imp_massadd_src_tb(i).ai_global_attribute7
                  ,imp_massadd_src_tb(i).ai_global_attribute8
                  ,imp_massadd_src_tb(i).ai_global_attribute9
                  ,imp_massadd_src_tb(i).ai_global_attribute10
                  ,imp_massadd_src_tb(i).ai_global_attribute11
                  ,imp_massadd_src_tb(i).ai_global_attribute12
                  ,imp_massadd_src_tb(i).ai_global_attribute13
                  ,imp_massadd_src_tb(i).ai_global_attribute14
                  ,imp_massadd_src_tb(i).ai_global_attribute15
                  ,imp_massadd_src_tb(i).ai_global_attribute16
                  ,imp_massadd_src_tb(i).ai_global_attribute17
                  ,imp_massadd_src_tb(i).ai_global_attribute18
                  ,imp_massadd_src_tb(i).ai_global_attribute19
                  ,imp_massadd_src_tb(i).ai_global_attribute20
                  ,imp_massadd_src_tb(i).ai_global_attribute_number1
                  ,imp_massadd_src_tb(i).ai_global_attribute_number2
                  ,imp_massadd_src_tb(i).ai_global_attribute_number3
                  ,imp_massadd_src_tb(i).ai_global_attribute_number4
                  ,imp_massadd_src_tb(i).ai_global_attribute_number5
                  ,imp_massadd_src_tb(i).ai_global_attribute_date1
                  ,imp_massadd_src_tb(i).ai_global_attribute_date2
                  ,imp_massadd_src_tb(i).ai_global_attribute_date3
                  ,imp_massadd_src_tb(i).ai_global_attribute_date4
                  ,imp_massadd_src_tb(i).ai_global_attribute_date5
                  ,imp_massadd_src_tb(i).ai_global_attribute_category
                  ,imp_massadd_src_tb(i).vendor_name
                  ,imp_massadd_src_tb(i).vendor_number
                  ,imp_massadd_src_tb(i).po_number
                  ,imp_massadd_src_tb(i).invoice_number
                  ,imp_massadd_src_tb(i).invoice_voucher_number
                  ,imp_massadd_src_tb(i).invoice_date
                  ,imp_massadd_src_tb(i).payables_units
                  ,imp_massadd_src_tb(i).invoice_line_number
                  ,imp_massadd_src_tb(i).invoice_line_type
                  ,imp_massadd_src_tb(i).invoice_line_description
                  ,imp_massadd_src_tb(i).invoice_payment_number
                  ,imp_massadd_src_tb(i).project_number
                  ,imp_massadd_src_tb(i).project_task_number
                  ,imp_massadd_src_tb(i).fully_reserve_on_add_flag
                  ,imp_massadd_src_tb(i).deprn_adjustment_factor
                  ,imp_massadd_src_tb(i).creation_date
                  ,imp_massadd_src_tb(i).created_by
                  ,imp_massadd_src_tb(i).last_update_date
                  ,imp_massadd_src_tb(i).last_updated_by
                  ,pt_i_MigrationSetID
                  );
         --
         END LOOP;

         --
         gvv_ProgressIndicator := '0030';
         xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );


         gvv_ProgressIndicator := '0031';
         xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Update Table into xxmx_fa_mass_addition_stg'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );

          --
          -- Update posting status and queue name
         UPDATE XXMX_STG.XXMX_FA_MASS_ADDITIONS_STG fmas
         SET    (fmas.POSTING_STATUS, fmas.QUEUE_NAME) =
                              (SELECT fma.POSTING_STATUS, fma.QUEUE_NAME
                               FROM   apps.fa_mass_additions@xxmx_extract fma
                               WHERE  1=1
                               AND    fma.MASS_ADDITION_ID=fmas.MASS_ADDITION_ID
                              );
         --
         COMMIT;
         --
         gvv_ProgressIndicator := '0032';
         xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Close the Cursor imp_massadd_src_cur'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );
         --


         IF imp_massadd_src_cur%ISOPEN
         THEN
              --
              CLOSE imp_massadd_src_cur;
              --
         END IF;


                --
         /*
         ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
         ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
         ** is reached.
         */
         --
         --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
         --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
         --
         gvn_RowCount := xxmx_utilities_pkg.get_row_count
                              (
                               gct_StgSchema
                              ,cv_StagingTable
                              ,pt_i_MigrationSetID
                              );
         --
         COMMIT;


         xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.upd_migration_details
                 (
                  pt_i_MigrationSetID          => pt_i_MigrationSetID
                 ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                 ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Migration Table "'
                                          ||cv_StagingTable
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
            ,pt_i_BusinessEntity    => gv_i_BusinessEntity
            ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
       --



    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);


           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );
           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF imp_massadd_src_cur%ISOPEN
        THEN
            --
            CLOSE imp_massadd_src_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --
      WHEN e_DateError THEN
                --
        IF imp_massadd_src_cur%ISOPEN
        THEN
            --
            CLOSE imp_massadd_src_cur;
            --
        END IF;
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;

      WHEN OTHERS THEN

         IF imp_massadd_src_cur%ISOPEN
         THEN
             --
             CLOSE imp_massadd_src_cur;
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
         xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;

    END src_mass_addition;

    /****************************************************************
	----------------Export Mass Rates-------------------------
	*****************************************************************/

    PROCEDURE src_massrates
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
    AS




      --
      --**********************
      --** Cursor Declarations
      --**********************
      --

        CURSOR imp_massadd_rates_cur
        IS
            --
         /* commented by Laxmikanth
         SELECT   fmav.mass_addition_id
                    ,gsob.currency_code
                    ,fmr.fixed_assets_cost
                    ,exchange_rate
                    ,g_batch_name
                    ,NULL                                        AS creation_date
                    ,NULL                AS created_by
                    ,NULL                                        AS last_update_date
                    ,NULL            AS last_updated_by
                    ,to_char(SYSDATE,'DDMMRRRRHHMISS')
            FROM     apps.fa_mc_mass_rates@xxmx_extract           fmr
                    ,apps.fa_mass_additions_v@xxmx_extract        fmav
                    ,apps.gl_sets_of_books@xxmx_extract           gsob
                    ,XXMX_CORE.XXMX_FA_SCOPE_V            fsv
                    ,(select distinct mass_addition_id
                      from xxmx_fa_mass_additions_stg )    xfas

           WHERE    fmr.mass_addition_id              = fmav.mass_addition_id
           AND      gsob.set_of_books_id              = fmr.set_of_books_id
           AND      xfas.mass_addition_id = fmav.asset_id
           and      fmav.asset_id        =   fsv.asset_id*/
          SELECT
    fmav.mass_addition_id,
    gsob.to_currency AS currency_code,
    NULL fixed_assets_cost, --fmav.fixed_assets_cost --SHOULD NOT HAVE BOTH COST AND RATE, just need one of them. 
                            --As Citco does noe have cost in reporting currency in ledger, therefore cost is being set as NULL and rate is being used instead.
                            --Changes made by Veda Poojitha and on 27/01/2023.
    gsob.conversion_rate AS exchange_rate,
    g_batch_name,
    NULL AS creation_date,
    NULL AS created_by,
    NULL AS last_update_date,
    NULL AS last_updated_by,
    to_char(
        sysdate, 'DDMMRRRRHHMISS'
    )
FROM
    xxmx_fa_mass_additions_stg fmav,
    apps.gl_daily_rates@xxmx_extract      gsob,
    xxmx_mapping_master                   xmm
WHERE
    to_date(fmav.date_placed_in_service) = to_date(gsob.conversion_date)
    AND gsob.conversion_type = 'Spot'
    AND gsob.from_currency = xmm.input_code_2
    AND gsob.to_currency = xmm.output_code_1
    AND xmm.application_suite = 'FIN'
    AND xmm.application = 'FA'
    AND xmm.business_entity = 'FIXED_ASSETS'
    AND xmm.sub_entity = 'MASS_RATES'
    AND xmm.category_code = 'MASS_RATES_CURRENCY'
    AND fmav.book_type_code = xmm.input_code_1
        AND fmav.fixed_assets_cost <> 0
           ;

       --
       --**********************
       --** Record Declarations
       --**********************
       --

      TYPE imp_massadd_rates_tb1 IS TABLE OF imp_massadd_rates_cur%ROWTYPE INDEX BY BINARY_INTEGER;
      imp_massadd_rates_tb  imp_massadd_rates_tb1;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_massrates';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_FA_MASS_RATES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'MASS_RATES';

        --
       --************************
       --** Variable Declarations
       --************************
       --
        l_error_count                        NUMBER;
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);

       --
       --** END Declarations **
       --
    BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --

        gvv_ProgressIndicator := '0010';
        xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        DELETE
        FROM    XXMX_STG.XXMX_FA_MASS_RATES_STG ;

        COMMIT;
        --
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


           OPEN imp_massadd_rates_cur;
           --
           LOOP
           --

           gvv_ProgressIndicator := '0020';
           xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Inside the CURSOR loop imp_massadd_rates_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           FETCH imp_massadd_rates_cur  BULK COLLECT INTO imp_massadd_rates_tb LIMIT 1000;
           --

            gvv_ProgressIndicator := '0020';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'CURSOR imp_massadd_rates_cur Fetch into imp_massadd_rates_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
           --
           EXIT WHEN imp_massadd_rates_tb.COUNT=0;
           --
           FORALL i IN 1..imp_massadd_rates_tb.COUNT SAVE EXCEPTIONS
           --
             INSERT
             INTO XXMX_STG.XXMX_FA_MASS_RATES_STG
               (
                mass_addition_id
               ,migration_status
               ,migration_set_name
               ,currency_code
               ,fixed_assets_cost
               ,exchange_rate
             --  ,batch_name
               ,creation_date
               ,created_by
               ,last_update_date
               ,last_updated_by
               ,migration_set_id
              )
          VALUES (

                imp_massadd_rates_tb(i).mass_addition_id
               ,'EXTRACTED'
               ,gvt_MigrationSetName
               ,imp_massadd_rates_tb(i).currency_code
               ,imp_massadd_rates_tb(i).fixed_assets_cost
               ,imp_massadd_rates_tb(i).exchange_rate
               --,imp_massadd_rates_tb(i).g_batch_name
               ,imp_massadd_rates_tb(i).creation_date
               ,imp_massadd_rates_tb(i).created_by
               ,imp_massadd_rates_tb(i).last_update_date
               ,imp_massadd_rates_tb(i).last_updated_by
               ,pt_i_MigrationSetID
              );
         --
         END LOOP;

         --
           gvv_ProgressIndicator := '0030';
           xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );


           gvv_ProgressIndicator := '0031';
           xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Update Table into xxmx_fa_mass_rates_stg'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );


         COMMIT;
         --
         gvv_ProgressIndicator := '0032';
           xxmx_utilities_pkg.log_module_message(
                           pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Close the Cursor imp_massadd_rates_cur'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );
          --


          IF imp_massadd_rates_cur%ISOPEN
          THEN
                  --
                  CLOSE imp_massadd_rates_cur;
                  --
          END IF;



                   --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
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
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
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
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
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
          --



    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );

           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF imp_massadd_rates_cur%ISOPEN
        THEN
            --
            CLOSE imp_massadd_rates_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;
         --** END e_ModuleError Exception
         --
      WHEN e_DateError THEN
                --
        IF imp_massadd_rates_cur%ISOPEN
        THEN
            --
            CLOSE imp_massadd_rates_cur;
            --
        END IF;
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;

      WHEN OTHERS THEN

         IF imp_massadd_rates_cur%ISOPEN
         THEN
             --
             CLOSE imp_massadd_rates_cur;
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
         xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;


      END src_massrates;


END xxmx_fa_mass_additions_pkg;