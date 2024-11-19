     PROCEDURE log_module_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_module_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_module_messages.file_set_id%TYPE DEFAULT 0
                    ,pt_i_MigrationSetID             IN      xxmx_module_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_module_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_module_messages.severity%TYPE
                    ,pt_i_PackageName                IN      xxmx_module_messages.package_name%TYPE
                    ,pt_i_ProcOrFuncName             IN      xxmx_module_messages.proc_or_func_name%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_module_messages.progress_indicator%TYPE
                    ,pt_i_ModuleMessage              IN      xxmx_module_messages.module_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_module_messages.oracle_error%TYPE
                    )
     IS
          --
          PRAGMA AUTONOMOUS_TRANSACTION;
          --
          --**********************
          --** Cursor Declarations
          --**********************
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'log_module_message';
          v_debug_message                           VARCHAR2(5);
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
          --** Insert module message record.
          --
          IF   LENGTH(pt_i_ApplicationSuite) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationFSuite parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   LENGTH(pt_i_Application) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Application parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Phase) NOT IN ('CORE', 'EXTRACT', 'TRANSFORM', 'EXPORT','VALIDATE')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Phase parameter must be "CORE,", "EXTRACT", "TRANSFORM" ,"EXPORT" or "VALIDATE".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Severity) NOT IN ('NOTIFICATION', 'WARNING', 'ERROR')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Severity parameter must be "NOTIFICATION,", "WARNING" or "ERROR".';
               --
               RAISE e_ModuleError;
               --
          END IF;

          v_debug_message := xxmx_utilities_pkg.get_single_parameter_value
                                                              (
                                                               pt_i_ApplicationSuite          => 'XXMX'
                                                              ,pt_i_Application               => 'XXMX'
                                                              ,pt_i_BusinessEntity            => 'ALL'
                                                              ,pt_i_SubEntity                 => 'ALL'
                                                              ,pt_i_ParameterCode             => 'DEBUG'
                                                              );

          IF( v_debug_message = 'Y' AND  UPPER(pt_i_Severity) IN ('NOTIFICATION')) THEN
          --
                   INSERT
                   INTO   xxmx_module_messages
                          (
                           module_message_id
                          ,application_suite
                          ,application
                          ,business_entity
                          ,sub_entity
                          ,migration_set_id
                          ,phase
                          ,message_timestamp
                          ,severity
                          ,package_name
                          ,proc_or_func_name
                          ,progress_indicator
                          ,module_message
                          ,oracle_error
                          )
                   VALUES
                          (
                           xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                          ,UPPER(pt_i_ApplicationSuite)       -- application_suite
                          ,UPPER(pt_i_Application)            -- application
                          ,UPPER(pt_i_BusinessEntity)         -- business_entity
                          ,UPPER(pt_i_SubEntity)              -- sub_entity
                          ,pt_i_MigrationSetID                -- migration_set_id
                          ,UPPER(pt_i_Phase)                  -- phase
                          ,LOCALTIMESTAMP(3)                  -- message_timestamp
                          ,UPPER(pt_i_Severity)               -- severity
                          ,LOWER(pt_i_PackageName)            -- package_name
                          ,LOWER(pt_i_ProcOrFuncName)         -- proc_or_func_name
                          ,pt_i_ProgressIndicator             -- progress_indicator
                          ,pt_i_ModuleMessage                 -- module_message
                          ,pt_i_OracleError                   -- oracle_error
                          );
          ELSIF( UPPER(pt_i_Severity) IN ('WARNING', 'ERROR'))THEN
                   INSERT
                   INTO   xxmx_module_messages
                          (
                           module_message_id
                          ,application_suite
                          ,application
                          ,business_entity
                          ,sub_entity
                          ,migration_set_id
                          ,phase
                          ,message_timestamp
                          ,severity
                          ,package_name
                          ,proc_or_func_name
                          ,progress_indicator
                          ,module_message
                          ,oracle_error
                          )
                   VALUES
                          (
                           xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                          ,UPPER(pt_i_ApplicationSuite)       -- application_suite
                          ,UPPER(pt_i_Application)            -- application
                          ,UPPER(pt_i_BusinessEntity)         -- business_entity
                          ,UPPER(pt_i_SubEntity)              -- sub_entity
                          ,pt_i_MigrationSetID                -- migration_set_id
                          ,UPPER(pt_i_Phase)                  -- phase
                          ,LOCALTIMESTAMP(3)                  -- message_timestamp
                          ,UPPER(pt_i_Severity)               -- severity
                          ,LOWER(pt_i_PackageName)            -- package_name
                          ,LOWER(pt_i_ProcOrFuncName)         -- proc_or_func_name
                          ,pt_i_ProgressIndicator             -- progress_indicator
                          ,pt_i_ModuleMessage                 -- module_message
                          ,pt_i_OracleError                   -- oracle_error
                          );
          END IF;
          --

          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    gvt_OracleError := NULL;
                    --
                    INSERT
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,migration_set_id
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                           ,'XXMX'                             -- application_suite
                           ,'XXMX'                             -- application
                           ,gct_BusinessEntity                 -- business_entity
                           ,gct_SubEntity                      -- sub_entity
                           ,pt_i_MigrationSetID                -- migration_set_id
                           ,'CORE'                             -- phase
                           ,LOCALTIMESTAMP(3)                  -- message_timestamp
                           ,'ERROR'                            -- severity
                           ,LOWER(gct_PackageName)             -- package_name
                           ,LOWER(ct_ProcOrFuncName)           -- proc_or_func_name
                           ,gvv_ProgressIndicator              -- progress_indicator
                           ,gvt_ModuleMessage                  -- module_message
                           ,gvt_OracleError                    -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    INSERT
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,migration_set_id
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL                     -- module_message_id
                           ,'XXMX'                                                -- application_suite
                           ,'XXMX'                                                -- application
                           ,gct_BusinessEntity                                    -- business_entity
                           ,gct_SubEntity                                         -- sub_entity
                           ,pt_i_MigrationSetID                                   -- migration_set_id
                           ,'CORE'                                                -- phase
                           ,LOCALTIMESTAMP(3)                                     -- message_timestamp
                           ,'ERROR'                                               -- severity
                           ,LOWER(gct_PackageName)                                -- package_name
                           ,LOWER(ct_ProcOrFuncName)                              -- proc_or_func_name
                           ,gvv_ProgressIndicator                                 -- progress_indicator
                           ,'Oracle error encountered after Progress Indicator.'  -- module_message
                           ,gvt_OracleError                                       -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END log_module_message;