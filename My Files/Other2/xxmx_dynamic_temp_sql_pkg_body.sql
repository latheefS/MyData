create or replace PACKAGE BODY                     xxmx_dynamic_temp_sql_pkg
AS
     /*
     **********************
     ** GLOBAL DECLARATIONS
     **********************
     */
     --
     /*
     ** Global Type Declarations for use in all Procedure/Function Calls within this package.
     */
     --
     TYPE RefCursor_t IS REF CURSOR;
     --
     /*
     ** Global Constants for use in all Procedure/Function Calls within this package.
     */
     --
     gct_PackageName                 CONSTANT  xxmx_module_messages.package_name%TYPE      := 'xxmx_dynamic_temp_sql_pkg';
     gct_XXMXApplicationSuite        CONSTANT  xxmx_module_messages.application_suite%TYPE := 'XXMX';
     gct_XXMXApplication             CONSTANT  xxmx_module_messages.application%TYPE       := 'XXMX';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                       := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                       := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                       := 'xxmx_core';
     gct_CoreBusinessEntity          CONSTANT  xxmx_module_messages.business_entity%TYPE   := 'XXMX_CORE';
     gct_CoreSubEntity               CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'XXMX_DYNASQL';
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvt_FileSetID                             xxmx_migration_headers.file_set_id%TYPE;
     gvt_MigrationSetID                        xxmx_migration_headers.migration_set_id%TYPE;
     gvv_ApplicationErrorMessage               VARCHAR2(2048);
     gvv_ProgressIndicator                     VARCHAR2(100);
     gvv_ReturnStatus                          VARCHAR2(1);
     gvv_ReturnCode                            VARCHAR2(50);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     gvn_RowCount                              NUMBER;
     gvn_ExistenceCheckCount                   NUMBER;
     gvt_Phase                                 xxmx_module_messages.phase%TYPE;
     gvt_ObjectStatus                          all_objects.status%TYPE;
     --
     /*
     ** Global Variables for Core Parameters used within this package.
     */
     --
     gvt_StgPopulationMethod                   xxmx_core_parameters.parameter_value%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers.
     */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage.
     */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1)     := ' ';
     gvv_SQLAction1                            VARCHAR2(2000);
     gvv_SQLAction2                            VARCHAR2(2000);
     gvv_SQLTableClause                        VARCHAR2(2000);
     gvv_SQLSelectColumnList                   VARCHAR2(32000);
     gvv_SQLInsertColumnList                   VARCHAR2(32000);
     gvv_SQLUpdateColumnList                   VARCHAR2(32000);
     gvv_SQLWhereClause                        VARCHAR2(32000);
     gvc_SQLStatement                          CLOB;
     gvc_SQLResult                             CLOB;
     --
     --

     /******************
     This Procedure populate XFM Tables 
     Data Dictionary .
     *********************/
        Procedure xfm_populate    (  pt_i_ApplicationSuite     IN      xxmx_migration_metadata.application_suite%TYPE
                              ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                              ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                              ,pt_fusion_template_name         IN      xxmx_xfm_tables.fusion_template_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_name   IN      xxmx_xfm_tables.fusion_template_sheet_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_order  IN      xxmx_xfm_tables.fusion_template_sheet_order%TYPE DEFAULT NULL
							  ,pt_common_load_column           IN      VARCHAR2 DEFAULT NULL
                              ,pv_o_ReturnStatus               OUT     VARCHAR2) 
   IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xfm_populate';
          lv_table_name                             VARCHAR2(200);
          lv_count                                  NUMBER;
          --
          --************************
          --** Variable Declarations
          --************************
          --
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
          gvt_Phase := 'EXTRACT';
          --
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ( '
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||' / '
                                        ||pt_i_ApplicationSuite
                                        ||' / '
                                        ||pt_i_Application
                                        ||' ) '||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Below Insert will populate the XFM Tables 
          ** for passed Parameters
          */
          --
          DELETE FROM xxmx_xfm_tables
          where table_name IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));
          --
          --
          SELECT COUNT(1)
          INTO lv_count
          FROM      ALL_TABLES allt
          WHERE     1 = 1
          AND       allt.owner         = 'XXMX_XFM'
          --AND       allt.table_name LIKE 'XXMX%XFM'
          and       allt.table_name IN('XXMX_FA_MASS_ADDITIONS_XFM')
          ORDER BY  UPPER(allt.owner)
                   ,UPPER(allt.table_name);
          --
          gvv_ProgressIndicator := '0015';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'DELETE Command Executed '||SQL%ROWCOUNT ||' '||lv_table_name ||' '||lv_count
               ,pt_i_OracleError       => NULL
               );
          --
          INSERT
            INTO   xxmx_xfm_tables
                        (
                         xfm_table_id
                        ,metadata_id
                        ,schema_name
                        ,table_name
                        ,comments
                        ,sequence_name
                        ,generate_sequence
                        ,sequence_start_value
                        ,fusion_template_name
                        ,fusion_template_sheet_name
                        ,fusion_template_sheet_order
                        ,field_delimiter
                        ,include_column_heading
                        ,include_column_heading_by_row
						,common_load_column
                        ,purge_flag
                        ,creation_date
                        ,created_by
                        ,last_update_date
                        ,last_updated_by
                        )
            SELECT  xxmx_xfm_table_ids_s.NEXTVAL
                   ,NVL(
                        (
                         SELECT  DISTINCT
                                 xmd.metadata_id
                         FROM    xxmx_migration_metadata  xmd
                         WHERE  1 = 1
                         AND    UPPER(xmd.xfm_table) = UPPER(distinct_tables.table_name)
                         AND    ROWNUM               = 1
                        )
                       ,0
                       )                                AS metadata_id
                   ,distinct_tables.owner
                   ,distinct_tables.table_name
                   ,distinct_tables.comments
                   ,distinct_tables.sequence_name
                   ,distinct_tables.generate_sequence
                   ,distinct_tables.sequence_start_value
                   ,distinct_tables.fusion_template_name
                   ,distinct_tables.fusion_template_sheet_name
                   ,distinct_tables.fusion_template_sheet_order
                   ,distinct_tables.field_delimiter
                   ,distinct_tables.include_column_heading
                   ,distinct_tables.include_column_heading_by_row
				   ,common_load_column
                   ,distinct_tables.purge_flag
                   ,distinct_tables.creation_date
                   ,distinct_tables.created_by
                   ,distinct_tables.last_updated_date
                   ,distinct_tables.last_updated_by
            FROM    (
                     SELECT     DISTINCT
                                UPPER(allt.owner)                      AS owner
                               ,UPPER(allt.table_name)                 AS table_name
                               ,NULL                                   AS comments
                               ,NULL                                   AS sequence_name
                               ,NULL                                   AS generate_sequence
                               ,NULL                                   AS sequence_start_value
                               ,NVL(pt_fusion_template_name,NULL)      AS fusion_template_name
                               ,NVL(pt_fusion_template_sheet_name,NULL) AS fusion_template_sheet_name
                               ,NVL(pt_fusion_template_sheet_order,NULL)   AS fusion_template_sheet_order
                               ,'|'                                    AS field_delimiter
                               ,NULL                                   AS include_column_heading
                               ,NULL                                   AS include_column_heading_by_row
							   ,pt_common_load_column		           AS common_load_column
                               ,'Y'                                    AS purge_flag
                               ,TO_DATE(SYSDATE, 'DD-MON-RRRR')        AS creation_date
                               ,'XXMX'                                 AS created_by
                               ,TO_DATE(SYSDATE, 'DD-MON-RRRR')        AS last_updated_date
                               ,'XXMX'                                 AS last_updated_by
                     FROM      all_tables allt
                     WHERE     1 = 1
                     AND       allt.owner         = 'XXMX_XFM'
                     AND       allt.table_name LIKE 'XXMX%XFM'
                     and       allt.table_name IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                     ORDER BY  UPPER(allt.owner)
                              ,UPPER(allt.table_name)
                    ) distinct_tables;
          --
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'After XXMX_XFM_TABLE INSERT '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
            Commit;
            /* Update all the Tables of Cash Receipts.*/
            UPDATE xxmx_xfm_tables
            SET    metadata_id     = (
                                      SELECT metadata_id
                                      FROM   xxmx_xfm_tables
                                      WHERE  1 = 1
                                      AND    table_name = 'XXMX_AR_CASH_RCPTS_RT6_XFM'
                                     )
            WHERE 1 = 1
            AND   table_name LIKE 'XXMX_AR_CASH%'
            AND   table_name   != 'XXMX_AR_CASH_RCPTS_RT6_XFM';
           --
          -- Commit;
           --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Populated XFM_TABLES Data_dictionary_tables '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
          --

           DELETE FROM xxmx_xfm_table_columns
           where xfm_table_id IN( SELECT distinct xfm_table_id
                              from xxmx_migration_metadata a, 
                                   xxmx_xfm_tables xt
                               where application = pt_i_Application
                               and application_suite = pt_i_ApplicationSuite
                               and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                               and XFM_TABLE is NOT NULL
                               and xt.metadata_id = a.metadata_id
                               and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));
                      --
          gvv_ProgressIndicator := '0025';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'DELETE XXMX_XFM_TABLE_COLUMNS '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
          --  Commit;

            --
            INSERT
            INTO   xxmx_xfm_table_columns
                        (
                         xfm_table_id
                        ,xfm_table_column_id
                        ,xfm_column_seq
                        ,column_name
                        ,data_type
                        ,data_length
                        ,mandatory
                        ,comments
                        ,creation_date
                        ,created_by
                        ,last_update_date
                        ,last_updated_by
                        )
            SELECT  ordered_columns.xfm_table_id
                   ,xxmx_xfm_table_column_ids_s.NEXTVAL
                   ,ordered_columns.xfm_column_seq
                   ,ordered_columns.column_name
                   ,ordered_columns.data_type
                   ,ordered_columns.data_length
                   ,ordered_columns.mandatory
                   ,NULL                                   AS comments
                   ,TO_DATE('01-JAN-2021', 'DD-MON-RRRR')  AS creation_date
                   ,'XXMX'                                 AS created_by
                   ,TO_DATE('01-JAN-2021', 'DD-MON-RRRR')  AS last_updated_date
                   ,'XXMX'                                 AS last_updated_by
            FROM   (
                    SELECT    xxt.xfm_table_id             AS xfm_table_id
                             ,alltc.column_id              AS xfm_column_seq
                             ,UPPER(alltc.column_name)     AS column_name
                             ,alltc.data_type              AS data_type
                             ,DECODE(
                                     alltc.data_type
                                          ,'VARCHAR2' ,alltc.data_length
                                          ,'NUMBER'   ,alltc.data_length
                                                      ,NULL
                                    )                      AS data_length
                             ,DECODE(
                                     alltc.nullable
                                          ,'N' ,'Y'
                                          ,'Y' ,NULL
                                               ,NULL
                                    )                      AS mandatory
                    FROM      all_tab_columns  alltc
                             ,xxmx_xfm_tables  xxt
                    WHERE     1 = 1
                    AND       alltc.table_name = UPPER(xxt.table_name)
                    AND       xxt.schema_name  = 'XXMX_XFM'
                    AND       xxt.table_name LIKE 'XXMX%XFM'
                    and       UPPER(xxt.table_name) IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                    ORDER BY  alltc.table_name
                             ,alltc.column_id
                   )  ordered_columns;
            --
           --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'AFTER XXMX_XFM_TABLE_COLUMNS INSERT '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
            COMMIT;
      EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END xfm_populate;    

END xxmx_dynamic_temp_sql_pkg;