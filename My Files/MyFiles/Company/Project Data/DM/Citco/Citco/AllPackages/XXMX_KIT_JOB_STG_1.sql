--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_JOB_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_JOB_STG" AS


      --
      --
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_job_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for populating HCM 
		--//                            Jobs from EBS
		--//
		--//
		--// Version Control
		--//================================================================================
		--// Version      Author               Date               Description
		--//--------------------------------------------------------------------------------
		--// 1.1         Pallavi Kanajar       26/05/2020         Initial Build

		--//================================================================================
		--
		--
    gvv_set_code VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_set_code;

    gvv_cmp_cnt_typ VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_cmp_cnt_typ;

    gvv_job_prof_typ VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_job_prof_typ;

    gvv_job_prof_reln VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_job_prof_reln;

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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_job_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'JOB';

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                 EXCEPTION;

    PROCEDURE export
    (p_bg_name                      IN      VARCHAR2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB EXPORT';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
                        ,pt_i_Severity            => 'NOTIFICATION'
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
        -- main                             
        --1 
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_jobs_f_10".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_jobs_f_10 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --2
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_jobs_f_15".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_jobs_f_15 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);        --3 
        -- 
        -- 3
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_jobs_f_20".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_jobs_f_20 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --4 
        gvv_ProgressIndicator := '0040';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_jobs_f_tl_25".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_jobs_f_tl_25 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --5 
        gvv_ProgressIndicator := '0050';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_jobs_f_tl_35".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_jobs_f_tl_35 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --  
    EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
        -- Hr_Utility.raise_error@XXMX_EXTRACT;                             
   END export;

   PROCEDURE export_profiles_job
        (p_bg_name                      IN      VARCHAR2
        ,p_bg_id                        IN      number
        ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT        VARCHAR2(30) := 'export_profiles_job';   
        vt_ClientSchemaName                                 xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                                   xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT        xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT        VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT        VARCHAR2(100) DEFAULT 'JOB PROFILES EXPORT';

        vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
    --
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
                        ,pt_i_Severity            => 'NOTIFICATION'
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
        --main
        --1  
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profiles_b_2_job_65".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profiles_b_2_job_65 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --2 
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profiles_tl_2_1_job_70".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profiles_tl_2_1_job_70 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --3 
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_relns_1_job_80".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_relns_1_job_80 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 
        --4
        gvv_ProgressIndicator := '0040';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_profile_items_1_job_85".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_profile_items_1_job_85 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --  
    EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
        -- Hr_Utility.raise_error@XXMX_EXTRACT;                             
   END export_profiles_job;

    PROCEDURE export_jobs_f_10
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_jobs_f_10'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_jobs_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOBS_F_10';

    BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
        DELETE
        FROM    xxmx_jobs_f_stg
        WHERE   xxmx_jobs_f_stg.bg_id    = p_bg_id    ;    
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --
        INSERT  
        INTO    xxmx_jobs_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,job_code
                ,set_code
                ,action_occurrence_id
                ,active_status
                ,benchmark_job_flag
                ,approval_authority
                ,med_checkup_req
                ,job_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_jobs.date_from effective_start_date
                ,nvl (per_jobs.date_to
                        ,to_date ('31-12-4712'
                                ,'DD-MM-YYYY')) effective_end_date
                ,substr (per_jobs.name
                        ,1
                        ,30) job_code
                ,gvv_set_code
                ,- 1
                ,'A' active_status
                ,benchmark_job_flag benchmark_job_flag
                ,approval_authority approval_authority
                ,'N' med_checkup_req
                ,job_id
                || '_JOB'
            FROM    per_jobs@XXMX_EXTRACT per_jobs
                    ,hr_all_organization_units@XXMX_EXTRACT horg
            WHERE   per_jobs.business_group_id = horg.organization_id
            AND     horg.name = p_bg_name;

        COMMIT;
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

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
  END export_jobs_f_10;

    PROCEDURE export_jobs_f_15
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_jobs_f_15'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_jobs_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOBS_F_15';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Updating data in "' || cv_StagingTable || '".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );

        UPDATE  xxmx_jobs_f_stg t
        SET     t.benchmark_job_id = 
                                    (
                                    SELECT  s.benchmark_job_id
                                    FROM    (
                                            SELECT  c9_job_id
                                                    || '_JOB' job_id
                                                    ,c7_date_from effective_start_date
                                                    ,nvl (c6_date_to
                                                        ,to_date ('31-12-4712'
                                                                ,'DD-MM-YYYY')) effective_end_date
                                                    ,nvl2 (c5_benchmark_job_id
                                                        ,c5_benchmark_job_id
                                                            || '_JOB'
                                                        ,NULL) benchmark_job_id
                                            FROM    (
                                                    SELECT  'HCM_COEX' c1_last_updated_by
                                                            ,'HCM_COEX' c2_created_by
                                                            ,nvl (per_jobs.last_update_date
                                                                ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c3_last_update_date
                                                            ,nvl (per_jobs.creation_date
                                                                ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c4_creation_date
                                                            ,per_jobs.job_id c9_job_id
                                                            ,per_jobs.date_from c7_date_from
                                                            ,per_jobs.date_to c6_date_to
                                                            ,per_jobs.benchmark_job_id c5_benchmark_job_id
                                                    FROM    per_jobs@XXMX_EXTRACT per_jobs
                                                    )
                                            ) s
                                    WHERE   t.job_id = s.job_id
                                    AND     t.effective_start_date = s.effective_start_date
                                    AND     t.effective_end_date = s.effective_end_date
                                    )
        WHERE   (job_id,effective_start_date,effective_end_date) IN
                (
                SELECT  job_id
                        ,effective_start_date
                        ,effective_end_date
                FROM    (
                        SELECT  c9_job_id
                                || '_JOB' job_id
                                ,c7_date_from effective_start_date
                                ,nvl (c6_date_to
                                    ,to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')) effective_end_date
                                ,c5_benchmark_job_id
                                || '_JOB' benchmark_job_id
                        FROM    (
                                SELECT  'HCM_COEX' c1_last_updated_by
                                        ,'HCM_COEX' c2_created_by
                                        ,nvl (per_jobs.last_update_date
                                            ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c3_last_update_date
                                        ,nvl (per_jobs.creation_date
                                            ,CAST (current_timestamp AT TIME ZONE tz_offset (dbtimezone) AS timestamp) ) c4_creation_date
                                        ,per_jobs.job_id c9_job_id
                                        ,per_jobs.date_from c7_date_from
                                        ,per_jobs.date_to c6_date_to
                                        ,per_jobs.benchmark_job_id c5_benchmark_job_id
                                FROM    per_jobs@XXMX_EXTRACT per_jobs
                                )
                        ) s
                );

        COMMIT;
        --
        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'End of update at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
        -- Hr_Utility.raise_error@XXMX_EXTRACT;

   END export_jobs_f_15;

   PROCEDURE export_jobs_f_20
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_jobs_f_20'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_jobs_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOBS_F_20';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_grades_f_stg".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );


        INSERT  
        INTO    xxmx_jobs_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,job_id
                ,effective_start_date
                ,effective_end_date
                ,job_code
                ,set_code
                ,benchmark_job_id
                ,action_occurrence_id
                ,active_status
                ,benchmark_job_flag
                ,approval_authority
                ,med_checkup_req)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                ,per_jobs.job_id
                || '_JOB' job_id
                ,per_jobs.date_to + 1 effective_start_date
                ,to_date ('31-12-4712'
                        ,'DD-MM-YYYY') effective_end_date
                ,substr (per_jobs.name
                        ,1
                        ,30) job_code
                ,gvv_set_code
                ,nvl2 (
                    (
                    SELECT  job_id
                    FROM    xxmx_jobs_f_stg
                    WHERE   job_id = per_jobs.benchmark_job_id
                                        || '_JOB'
                    )
                    ,per_jobs.benchmark_job_id
                    || '_JOB'
                    ,NULL) benchmark_job_id
                ,- 1
                ,'I' active_status
                ,per_jobs.benchmark_job_flag benchmark_job_flag
                ,per_jobs.approval_authority approval_authority
                ,'N' med_checkup_req
        FROM    per_jobs@XXMX_EXTRACT per_jobs
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_jobs.date_to IS NOT NULL
                AND     per_jobs.date_to <> to_date ('31-12-4712'
                                                    ,'DD-MM-YYYY')
                )
        AND     per_jobs.business_group_id = horg.organization_id
        AND     horg.name = p_bg_name;

        COMMIT;
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
                ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                ,pt_i_OracleError         => gvt_ReturnMessage       );     

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
   END export_jobs_f_20;

   PROCEDURE export_jobs_f_tl_25
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_jobs_f_tl_25'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_jobs_f_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOBS_F_tl_25';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --                         
        DELETE 
        FROM    xxmx_jobs_f_tl_stg
        WHERE   xxmx_jobs_f_tl_stg.bg_id    = p_bg_id    ;   
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
                ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable || '".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );


        INSERT  
        INTO    xxmx_jobs_f_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,job_id
                ,language
                ,effective_start_date
                ,effective_end_date
                ,source_lang
                ,name)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                , per_jobs.job_id
                || '_JOB' job_id
                ,'US' language
                ,per_jobs.date_from effective_start_date
                ,nvl (per_jobs.date_to
                    ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY')) effective_end_date
                ,'US' source_lang
                ,substr (per_jobs.name
                        ,1
                        ,240) name
        FROM    per_jobs_tl@XXMX_EXTRACT per_jobs_tl
                ,per_jobs@XXMX_EXTRACT per_jobs
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_jobs_tl.job_id = per_jobs.job_id
                AND     per_jobs_tl.language = 'US'
                )
        AND     (
                        horg.organization_id = per_jobs.business_group_id
                AND     horg.name = p_bg_name
                )
        ;

        COMMIT;
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
                ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                ,pt_i_OracleError         => gvt_ReturnMessage       );   

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
   END export_jobs_f_tl_25;

   PROCEDURE export_jobs_f_tl_35
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_jobs_f_tl_35'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_jobs_f_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOBS_F_tl_35';

    BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_grades_f_stg".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );


        INSERT  
        INTO    xxmx_jobs_f_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,job_id
                ,language
                ,effective_start_date
                ,effective_end_date
                ,source_lang
                ,name)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                ,per_jobs.job_id
                || '_JOB' job_id
                ,'US' language
                ,per_jobs.date_to + 1 effective_start_date
                ,to_date ('31-12-4712'
                        ,'DD-MM-YYYY') effective_end_date
                ,'US' source_lang
                ,substr (per_jobs.name
                        ,1
                        ,240) name
        FROM    per_jobs_tl@XXMX_EXTRACT per_jobs_tl
                ,per_jobs@XXMX_EXTRACT per_jobs
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_jobs.date_to IS NOT NULL
                AND     per_jobs.date_to <> to_date ('31-12-4712'
                                                    ,'DD-MM-YYYY')
                )
        AND     (
                        per_jobs_tl.job_id = per_jobs.job_id
                AND     per_jobs_tl.language = 'US'
                )
        AND     (
                        horg.organization_id = per_jobs.business_group_id
                AND     horg.name = p_bg_name
                )
        ;

        COMMIT;
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
                ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                ,pt_i_OracleError         => gvt_ReturnMessage       );   

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;     
   END export_jobs_f_tl_35;

   PROCEDURE export_profiles_b_2_job_65
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profiles_b_2_job_65'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_profile_b_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'B_2_JOB_65';

    BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
        --
        DELETE 
        FROM    xxmx_hrt_profile_b_stg
        WHERE   xxmx_hrt_profile_b_stg.bg_id    = p_bg_id    ;    

        --
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
                ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable || '".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );

     INSERT  
     INTO    xxmx_hrt_profile_b_stg
            (migration_set_id
            ,migration_set_name                   
            ,migration_status
            ,bg_name
            ,bg_id
            ,profile_type_id
            ,profile_code
            ,profile_status_code
            ,profile_usage_code
            ,profile_id)
    SELECT   pt_i_MigrationSetID                               
            ,pt_i_MigrationSetName                               
            ,'EXTRACTED' 
            ,p_bg_name
            ,p_bg_id
            ,gvv_job_prof_typ profile_type_id
            ,substrb ('JOB_'
                      || job_id
                     ,1
                     ,30) profile_code
            ,'A' profile_status_code
            ,'M' profile_usage_code
            ,job_id
             || '_JOB_PROFILE'
     FROM    per_jobs@XXMX_EXTRACT per_jobs
            ,hr_all_organization_units@XXMX_EXTRACT horg
     WHERE   (
                     horg.organization_id = per_jobs.business_group_id
             AND     horg.name = p_bg_name
             )
     ;

     COMMIT;
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

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT; 
   END export_profiles_b_2_job_65;

   PROCEDURE export_profiles_tl_2_1_job_70
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profiles_tl_2_1_job_70'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_profile_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TL_2_1_JOB_70';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --                        
        DELETE 
        FROM    xxmx_hrt_profile_tl_stg
        WHERE   xxmx_hrt_profile_tl_stg.bg_id    = p_bg_id    ;           
        --
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
                ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable || '".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );

        --
        INSERT
        INTO    xxmx_hrt_profile_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,language
                ,source_lang
                ,description)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                ,per_jobs.job_id
                || '_JOB_PROFILE' profile_id
                ,'US' language
                ,'US' source_lang
                ,per_jobs_tl.name description
        FROM    per_jobs_tl@XXMX_EXTRACT per_jobs_tl
                ,per_jobs@XXMX_EXTRACT per_jobs
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_jobs_tl.job_id = per_jobs.job_id
                AND     per_jobs_tl.language = 'US'
                )
        AND     (
                        horg.organization_id = per_jobs.business_group_id
                AND     horg.name = p_bg_name
                )
        ;

        COMMIT;
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

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
   END export_profiles_tl_2_1_job_70;

   PROCEDURE export_profile_relns_1_job_80
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_relns_1_job_80'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_profile_rel_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RELNS_1_JOB_80';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --                     
        DELETE 
        FROM    xxmx_hrt_profile_rel_stg
        WHERE   xxmx_hrt_profile_rel_stg.bg_id    = p_bg_id    ;          
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_grades_f_stg".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );


        INSERT  
        INTO    xxmx_hrt_profile_rel_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,relation_id
                ,object_id
                ,object_eff_start_date
                ,object_eff_end_date
                ,profile_relation_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                ,job_id
                || '_JOB_PROFILE' profile_id
                ,gvv_job_prof_reln relation_id
                ,job_id
                || '_JOB' object_id
                ,per_jobs.date_from object_eff_start_date
                ,per_jobs.date_to object_eff_end_date
                ,job_id
                || '_JOB_PROFILE_RELATION'
        FROM    per_jobs@XXMX_EXTRACT per_jobs
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   horg.organization_id = per_jobs.business_group_id
        AND     horg.name = p_bg_name;

        COMMIT;
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

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
   END export_profile_relns_1_job_80;

   PROCEDURE export_profile_items_1_job_85
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_profile_items_1_job_85'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_pfl_items_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ITEMS_1_JOB_85';

   BEGIN
        --
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_Severity            => 'NOTIFICATION'
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
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable || '".' 
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --     
        DELETE 
        FROM    xxmx_hrt_pfl_items_stg
        WHERE   xxmx_hrt_pfl_items_stg.bg_id    = p_bg_id    ;   
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
                ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_grades_f_stg".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );

        INSERT  
        INTO    xxmx_hrt_pfl_items_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,profile_id
                ,content_type_id
                ,content_item_id
                ,date_from
                ,date_to
                ,rating_model_id1
                ,rating_model_id2
                ,rating_level_id1
                ,rating_level_id2
                ,mandatory
                ,importance
                ,profile_item_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED' 
                ,p_bg_name
                ,p_bg_id
                ,job_id
                || '_JOB_PROFILE' profile_id
                ,gvv_cmp_cnt_typ content_type_id
                ,competence_id
                || '_CMP_CNT_ITEM' content_item_id
                ,effective_date_from date_from
                ,effective_date_to date_to
                ,
                (
                SELECT  rating_model_id
                FROM    xxmx_hrt_cnt_items_b_stg
                WHERE   content_item_id = competence_id
                                        || '_CMP_CNT_ITEM'
                ) rating_model_id1
                ,
                (
                SELECT  rating_model_id
                FROM    xxmx_hrt_cnt_items_b_stg
                WHERE   content_item_id = competence_id
                                        || '_CMP_CNT_ITEM'
                ) rating_model_id2
                ,nvl2 (proficiency_level_id
                    ,proficiency_level_id
                    || '_RATING_LEVEL'
                    ,NULL) rating_level_id1
                ,nvl2 (high_proficiency_level_id
                    ,high_proficiency_level_id
                    || '_RATING_LEVEL'
                    ,NULL) rating_level_id2
                ,decode (per_competence_elements.mandatory
                        ,'Y'
                        ,'true'
                        ,'false') mandatory
                ,2 importance
                ,per_competence_elements.competence_element_id
                || '_JOB_PROFILE_ITEM'
        FROM    per_competence_elements@XXMX_EXTRACT per_competence_elements
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        (
                                per_competence_elements.job_id IS NOT NULL
                        )
                AND     per_competence_elements.type = 'REQUIREMENT'
                AND     per_competence_elements.business_group_id = horg.organization_id
                AND     horg.name = p_bg_name
                )
        ;

        COMMIT;
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

    EXCEPTION
        WHEN e_ModuleError THEN
            --
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
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
        --
        RAISE;
        --** END e_ModuleError Exception
        --
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
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'  
                    ,pt_i_OracleError         => gvt_OracleError       );     
        --
        RAISE;
        -- Hr_Utility.raise_error@XXMX_EXTRACT;
   END export_profile_items_1_job_85;

    --*******************
    --** PROCEDURE: purge
    --*******************
    --
    PROCEDURE purge
                    (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
    IS
        --
        cv_ProcOrFuncName                   CONSTANT      VARCHAR2(30) := 'purge'; 
        ct_Phase                            CONSTANT      xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT      VARCHAR2(100) DEFAULT 'JOB PURGE';
        --
        e_ModuleError                   EXCEPTION;
        --

        --
    BEGIN
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        --
        --
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
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
                --
                --
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
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0020';
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
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
        --
        IF   pt_i_MigrationSetID IS NULL
        THEN
                --
                --
                gvt_Severity      := 'ERROR';
                gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '- Purging tables.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0030';
        --
        --
        DELETE
        FROM   xxmx_jobs_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_jobs_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0040';
        --
        --          
        DELETE
        FROM   xxmx_jobs_f_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_jobs_f_tl_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0050';
        --
        --          
        DELETE
        FROM   xxmx_hrt_profile_b_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_b_stg" table: '
                                    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        --          
        DELETE
        FROM   xxmx_hrt_profile_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_tl_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        --          
        DELETE
        FROM   xxmx_hrt_profile_rel_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_profile_rel_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0080';
        --
        --          
        DELETE
        FROM   xxmx_hrt_pfl_items_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_hrt_pfl_items_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        DELETE
        FROM   xxmx_migration_details
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_DETAILS" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        DELETE
        FROM   xxmx_migration_headers
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_HEADERS" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '- Purging complete.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        COMMIT;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
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
                                        ||'" completed.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        EXCEPTION
                --
                --
                WHEN OTHERS
                THEN
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
                        (pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                        ,pt_i_OracleError         => gvt_OracleError
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
    END purge;
END xxmx_kit_job_stg;

/
