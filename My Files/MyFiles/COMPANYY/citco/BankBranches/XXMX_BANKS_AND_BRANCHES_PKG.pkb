create or replace PACKAGE BODY xxmx_banks_and_branches_pkg
AS
     --
     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_banks_and_branches_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'HR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'BANKS_AND_BRANCHES';
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
     ***********************
     ** PROCEDURE: banks_stg
     ***********************
     */
     --
     --** ISV 21/10/2020 - Reduced PROCEDURE parameters to the minimum.  Still pull the Sub-Entity in the STG_MAIN procedure
     --**                  for now and pass it as a parameter as there is no real need to remove it.
     --
     PROCEDURE banks_stg
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
          -- Cursor to get the Banks
          --
          CURSOR Banks_cur
          IS
                /* 03/03/2022 Michal Arrowsmith Commented out the select below as both IBY_EXT_BANKS_V  */
                /* and ce_bank_branches_v get the data from same table HZ_ORGANIZATION_PROFILES */
               /* SELECT  DISTINCT
                       'MERGE'                                  migration_action
                      ,'Bank'                                  institution_level
                      ,to_char(cba.bank_party_id )             bank_id
                      ,trim(cba.short_bank_name)               short_bank_name
                      ,trim(cba.bank_name)                     bank_name
                      ,cba.country                             country
                      ,cba.bank_number                         bank_number
                      ,cba.bank_name_alt                       alternate_bank_name
                      ,cba.end_date                            end_effective_date
                      ,'FIN'                                   bank_source_application
               FROM   apps.ce_bank_branches_v@xxmx_extract  cba
               UNION */
               Select DISTINCT
                       'MERGE'                      migration_action
                      ,'Bank'                       institution_level
                      ,to_char(IEB.bank_party_id)   bank_id
                      ,trim(IEB.short_bank_name)    short_bank_name
                      ,trim(IEB.bank_name)          bank_name
                      ,IEB.home_country             country
                      ,IEB.bank_number              bank_number
                      ,IEB.bank_name_alt            alternate_bank_name
                      ,IEB.end_date                 end_effective_date
                      ,'FIN'                                   bank_source_application
                from IBY_EXT_BANKS_V@xxmx_extract IEB
                UNION 
                Select
                        DISTINCT
                       'MERGE'                   migration_action
                      ,'Bank'                    institution_level
                      ,to_char(PBB.BANK_CODE)    bank_id
                      ,''                        short_bank_name
                      ,trim(FLV.MEANING)               bank_name
                      ,PBB.LEGISLATION_CODE      country
                      ,PBB.BANK_CODE             bank_number
                      ,''                        alternate_bank_name
                      ,PBB.END_DATE_ACTIVE       end_effective_date
                      ,'PAY'                                  bank_source_application
                from PAY_BANK_BRANCHES@xxmx_extract PBB
                   , fnd_lookup_values@xxmx_extract flv
                where flv.lookup_type = 'GB_BANKS'
                and flv.lookup_code = PBB.bank_code;
                /* End of Added lines by Pallavi for External Banks and HCM Bank Extract */

               --
               --
          --** END CURSOR Banks_cur
          --
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE Banks_tt IS TABLE OF Banks_cur%ROWTYPE INDEX BY BINARY_INTEGER;
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
          --** ISV 21/10/2020 - Add new constant for Staging Schema andf Table Name as will no longer be passed as parameters.
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'banks_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_banks_stg';
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
          Banks_tbl                       Banks_tt;
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
          gvv_ReturnStatus  := '';
          --
          /*
          ** Delete any MODULE messages from previous executions
          ** for the Business Entity and Business Entity Level
          */
          --
          --** ISV 21/10/2020 - Modified all Utilities Package Procedure/Function Calls to pass new "gcv_BusinessEntity" global constant
          --**                  to the "pt_i_BusinessEntity" parameter.
          --
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Retrieve the Migration Set Name
          */
          --
          gvv_ProgressIndicator := '0040';
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
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'
                                             ||ct_StgTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0060';
               --
               --** Extract the Banks and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
               --**                  by a Synonym in the xxmx_core schema to that table.
               --
               OPEN Banks_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH        Banks_cur
                    BULK COLLECT
                    INTO         Banks_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN Banks_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FORALL i IN 1..Banks_tbl.COUNT
                         --
                         INSERT
                         INTO   xxmx_banks_stg
                                     (
                                      migration_set_id
                                     ,migration_set_name
                                     ,migration_status
                                     ,migration_action
                                     ,institution_level
                                     ,bank_id
                                     ,short_bank_name
                                     ,bank_name
                                     ,country
                                     ,bank_number
                                     ,alternate_bank_name
                                     ,end_effective_date
                                     ,bank_source_application
                                     )
                         VALUES
                                    (
                                     pt_i_MigrationSetID  -- e.g. 24
                                    ,gvt_MigrationSetName  -- 'Test Migration'
                                    ,'EXTRACTED'
                                    ,Banks_tbl(i).migration_action
                                    ,Banks_tbl(i).institution_level
                                    ,Banks_tbl(i).bank_id
                                    ,Banks_tbl(i).short_bank_name
                                    ,Banks_tbl(i).bank_name
                                    ,Banks_tbl(i).country
                                    ,Banks_tbl(i).bank_number
                                    ,Banks_tbl(i).alternate_bank_name
                                    ,Banks_tbl(i).end_effective_date
                                    ,Banks_tbl(i).bank_source_application
                                    );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE Banks_cur;
               --
               gvv_ProgressIndicator := '0100';
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
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
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
                    IF   Banks_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE Banks_cur;
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
                    IF   Banks_cur%ISOPEN
                    THEN
                         --
                         --
                         CLOSE Banks_cur;
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
     END banks_stg;
     --
     --
     /*
     ***********************
     ** PROCEDURE: banks_stg
     ***********************
     */
     --
     PROCEDURE bank_branches_stg
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
          -- Cursor to get the Banks
          --
          CURSOR BankBranches_cur
          IS
               --
               /* 03/02/2022 Removed by Michal duplicates */
               /* SELECT  DISTINCT
                       'MERGE'                   migration_action
                      ,'BankBranch'              institution_level
                      ,to_char(cba.bank_party_id)         bank_id
                      ,cba.short_bank_name       short_bank_name
                      ,to_char(cba.branch_party_id )      branch_id
                      ,trim(cba.bank_name)               bank_name
                      ,cba.bank_number           bank_number
                      ,cba.country               country
                      ,cba.branch_number         bank_branch_number
                      ,cba.bank_branch_name      bank_branch_name
                      ,cba.bank_branch_name_alt  alternate_bank_branch_name
                      ,cba.bank_branch_type      bank_branch_type
                      ,cba.eft_swift_code        eft_swift_code
                      ,cba.eft_user_number       eft_user_number
                      ,''                        rfc
                      ,cba.end_date              end_effective_date
                      ,'FIN'                                   bank_source_application
               FROM   apps.ce_bank_branches_v@xxmx_extract cba
               UNION */
                SELECT  DISTINCT
                       'MERGE'                   migration_action
                      ,'BankBranch'              institution_level
                      ,to_char(IEBB.bank_party_id)         bank_id
                      ,IEB.short_bank_name       short_bank_name
                      ,to_char(IEBB.branch_party_id)       branch_id
                      ,trim(IEB.bank_name)             bank_name
                      ,IEB.bank_number           bank_number
--                      ,IEBB.home_country               country
                      ,NVL(IEBB.home_country,IEB.home_country)  country     -- default Bank County Code is Branch country code is null
                      ,IEBB.branch_number         bank_branch_number
                      ,IEBB.bank_branch_name      bank_branch_name
                      ,IEBB.bank_branch_name_alt  alternate_bank_branch_name
                      ,IEBB.bank_branch_type      bank_branch_type
                      ,IEBB.eft_swift_code        eft_swift_code
                      ,IEBB.eft_user_number       eft_user_number
                      ,''                        rfc
                      ,IEBB.end_date              end_effective_date
                      ,'FIN'                                   bank_source_application
               FROM   apps.IBY_EXT_BANK_BRANCHES_V@xxmx_extract IEBB,
                      apps.IBY_EXT_BANKS_V@xxmx_extract IEB
                WHERE  IEBB.BANK_PARTY_ID = IEB.BANK_PARTY_ID
                UNION
                Select DISTINCT
                       'MERGE'                   migration_action
                      ,'BankBranch'              institution_level
                      ,PBB.BANK_CODE             bank_id
                      ,''                        short_bank_name
                      ,PBB.BRANCH_CODE           branch_id
                      ,trim(FLV.MEANING)               bank_name
                      ,PBB.BANK_CODE             bank_number
                      ,PBB.LEGISLATION_CODE      country
                      ,PBB.BRANCH_CODE           bank_branch_number
                      ,PBB.BRANCH                bank_branch_name
                      ,PBB.LONG_BRANCH           alternate_bank_branch_name
                      ,''                        bank_branch_type
                      ,''                        eft_swift_code
                      ,''                        eft_user_number
                      ,''                        rfc
                      ,PBB.END_DATE_ACTIVE       end_effective_date
                      ,'PAY'                                   bank_source_application
                from PAY_BANK_BRANCHES@xxmx_extract PBB
                   , fnd_lookup_values@xxmx_extract flv
                where flv.lookup_type = 'GB_BANKS'
                and flv.lookup_code = PBB.bank_code;
                /* End of Added lines by Pallavi for External Banks and HCM Bank Extract */
               --
          --** END CURSOR BankBranches_cur
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE BankBranches_tt IS TABLE OF BankBranches_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
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
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'bank_branches_stg';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_bank_branches_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'EXTRACT';
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
          BankBranches_tbl                BankBranches_tt;
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          /*
          ** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          ** before raising this exception.
          */
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
          gvv_ProgressIndicator := NULL;
          --
          gvv_ReturnStatus  := '';
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
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
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
               ,pt_i_Phase            => ct_Phase
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
          /*
          ** Retrieve the Migration Set Name
          */
          --
          gvv_ProgressIndicator := '0040';
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
               **The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'
                                             ||ct_StgTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Banks Branches and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN BankBranches_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0060';
                    --
                    FETCH        BankBranches_cur
                    BULK COLLECT
                    INTO         BankBranches_tbl
                    LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN BankBranches_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL i IN 1..BankBranches_tbl.COUNT
                         --
                         INSERT
                         INTO   xxmx_bank_branches_stg
                                     (
                                      migration_set_id
                                     ,migration_set_name
                                     ,migration_status
                                     ,migration_action
                                     ,institution_level
                                     ,bank_name
                                     ,bank_number
                                     ,bank_id
                                     ,short_bank_name
                                     ,branch_id
                                     ,country
                                     ,bank_branch_number
                                     ,bank_branch_name
                                     ,alternate_bank_branch_name
                                     ,bank_branch_type
                                     ,eft_swift_code
                                     ,eft_user_number
                                     ,rfc
                                     ,end_effective_date
                                     ,bank_source_application
                                     )
                         VALUES
                                     (
                                      pt_i_MigrationSetID  -- e.g. 24
                                     ,gvt_MigrationSetName  -- 'Test Migration'
                                     ,'EXTRACTED'
                                     ,BankBranches_tbl(i).migration_action
                                     ,BankBranches_tbl(i).institution_level
                                     ,BankBranches_tbl(i).bank_name
                                     ,BankBranches_tbl(i).bank_number
                                     ,BankBranches_tbl(i).bank_id
                                     ,BankBranches_tbl(i).short_bank_name
                                     ,BankBranches_tbl(i).branch_id
                                     ,BankBranches_tbl(i).country
                                     ,BankBranches_tbl(i).bank_branch_number
                                     ,BankBranches_tbl(i).bank_branch_name
                                     ,BankBranches_tbl(i).alternate_bank_branch_name
                                     ,BankBranches_tbl(i).bank_branch_type
                                     ,BankBranches_tbl(i).eft_swift_code
                                     ,BankBranches_tbl(i).eft_user_number
                                     ,BankBranches_tbl(i).rfc
                                     ,BankBranches_tbl(i).end_effective_date
                                     ,BankBranches_tbl(i).bank_source_application
                                     );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE BankBranches_cur;
               --
               gvv_ProgressIndicator := '0090';
               --
               /*
               ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               ** is reached.
               */
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
               gvv_ProgressIndicator := '0100';
               --
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
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
               WHEN e_ModuleError
               THEN
                    --
                    IF   BankBranches_cur%ISOPEN
                    THEN
                         --
                         CLOSE BankBranches_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
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
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    IF   BankBranches_cur%ISOPEN
                    THEN
                         --
                         CLOSE BankBranches_cur;
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
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END bank_branches_stg;
     --
     --
     --**********************
     --** PROCEDURE: stg_main
     --**********************
     --
     --** ISV 21/10/2020 - Removed Business Entity Parameter as it is now a global constant for the package as this will never change.
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
          --          ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
          ** Clear Banks and Branches Module Messages
          */
          --
          gvv_ReturnStatus  := '';
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** ISV 21/10/2020 - Removed Client Schema Name config parameter as schema names will always be "xxmx_stg", "xxmx_xfm" and "xxmx_core".
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
          --     ,pt_i_BusinessEntity      => gcv_BusinessEntity
          --     ,pt_i_SubEntity => ct_SubEntity
          --     ,pt_i_Phase               => ct_Phase
          --     ,pt_i_Severity            => 'NOTIFICATION'
          --     ,pt_i_PackageName         => gcv_PackageName
          --     ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
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
                    ,gcv_BusinessEntity
                    )
          LOOP
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
     END stg_main;
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
          --     ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
                    ,gcv_BusinessEntity
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
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
               --     ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
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
END XXMX_BANKS_AND_BRANCHES_PKG;