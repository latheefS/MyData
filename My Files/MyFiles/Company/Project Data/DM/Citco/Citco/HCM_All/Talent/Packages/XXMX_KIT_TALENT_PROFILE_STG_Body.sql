create or replace PACKAGE BODY xxmx_kit_talent_profile_stg AS

		--
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_talent_profile_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for extracting Performance Ratings and Competence 
		--//                       Data from EBS.
		--//
		--//
		--// Version Control
		--//================================================================================
		--// Version      Author               Date               Description
		--//--------------------------------------------------------------------------------
		--// 1.0         Vamsi                15/04/2022         Initial Build
		--// 1.1          Vamsi              20/05/2022           Added Talent Profile
		--//================================================================================
		--
		--
     --

    gvv_goal_cnt_typ VARCHAR2(1000)     := xxmx_KIT_UTIL_stg.get_goal_type;
    gvv_memb_cnt_typ VARCHAR2(1000)     := xxmx_KIT_UTIL_stg.get_memb_cnt_typ;
    gvv_ed_lvl_cnt_typ VARCHAR2(1000)   := xxmx_KIT_UTIL_stg.get_edulvl_cnt_typ;
    gvv_deg_cnt_typ VARCHAR2(1000)      := xxmx_KIT_UTIL_stg.get_deg_cnt_typ;
    gvv_hon_cnt_typ VARCHAR2(1000)      := xxmx_KIT_UTIL_stg.get_hon_cnt_typ;
    gvv_cert_cnt_typ VARCHAR2(1000)     := xxmx_KIT_UTIL_stg.get_cert_cnt_typ;
    gvv_cmp_cnt_typ VARCHAR2(1000)      := xxmx_KIT_UTIL_stg.get_cmp_cnt_typ;

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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_talent_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'TALENT';

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                 EXCEPTION;
    
    gvv_migration_date_from                   VARCHAR2(30); 
    gvv_migration_date_to                     VARCHAR2(30); 
    gvd_migration_date_from                   DATE;        
    gvd_migration_date_to                     DATE;  
-------------------------------------------------------
    /* Procedure to Set Cutoff Date Parameters */  -- Added on 22Nov23
-------------------------------------------------------
PROCEDURE set_parameters (p_bg_id IN NUMBER)
	IS
	BEGIN 
        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
       gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');
         --
        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_TO'
        );        
        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
         --         

	END;
-------------------------------------------------------
    PROCEDURE export
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TALENT EXPORT';

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
        --main
		--1
        gvv_ProgressIndicator := '0245';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_person_talent_profile".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_person_talent_profile (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --2
        gvv_ProgressIndicator := '0250';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_performance_ratings".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_performance_ratings (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		-- 3
     /*   gvv_ProgressIndicator := '0260';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_competences".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_competences (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);  */

        COMMIT;
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
--********************************************************
--** Procedure for Person TALENT_PROFILE 
--********************************************************
PROCEDURE export_person_talent_profile
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_person_talent_profile'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_talent_profile_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TALENT_PROFILE';

    BEGIN
        --
        --        
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
        THEN            xxmx_utilities_pkg.log_module_message
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
        gvv_ProgressIndicator := '0015';
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
        FROM    xxmx_per_talent_profile_stg
        WHERE   bg_id    = p_bg_id    ;

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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_talent_profile_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,METADATA
				,OBJECT_NAME
				,profile_type_code
                ,profile_status_code
                ,profile_usage_code
				,person_id
                ,PERSON_NUMBER
				,description
				,profile_id)
        SELECT /*+ driving_site(table alias name) */  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,'MERGE'
				,'TalentProfile'
                ,'PERSON'
                , 'A'   profile_status_code
                , 'P' profile_usage_code
				, papf.person_id
                , papf.employee_number person_number
				--, papf.full_name     --Description
				, NULL    --Description
                , 'Config'   profile_id
           FROM XXMX_HCM_CURRENT_PERSON_MV PAPF
          WHERE 1=1--person_id=30024;
		    AND user_person_type='Employee'
            AND gvd_migration_date_from BETWEEN TRUNC(PAPF.EFFECTIVE_START_DATE) AND TRUNC(PAPF.EFFECTIVE_END_DATE)
		    AND PAPF.BUSINESS_GROUP_ID = p_bg_id;

        COMMIT;
        --
        -- 
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
            --
    END export_person_talent_profile;

--********************************************************
--** Procedure for PERFORMANCE_RATINGS
--********************************************************
PROCEDURE export_performance_ratings
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_performance_ratings'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_profile_item_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERFORMANCE_RATINGS';

    BEGIN
        --
        --        
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
        THEN            xxmx_utilities_pkg.log_module_message
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
        gvv_ProgressIndicator := '0015';
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
        FROM    xxmx_per_profile_item_stg
        WHERE   bg_id    = p_bg_id    ;

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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_profile_item_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,METADATA
                ,SOURCESYSTEMID
                ,SOURCESYSTEMOWNER
				,object_name
				,PERSON_ID
				,person_number
				,DATEFROM
				,OVERALL_RATING
                ,PROFILEID
				,SECTIONID
				,ProfileCode
				,ContentTypeId
                ,RatingModelId1
				,RatingModelCode1
				,RatingLevelId1
				,QualifierId1
			,DATETO )
        SELECT  /*+ driving_site(table alias name) */ pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'          --MIGRATION_STATUS
                ,p_bg_name
                ,p_bg_id
				,'MERGE'
				, NULL --SOURCESYSTEMID
				, NULL   --SOURCESYSTEMOWNER
				,'ProfileItem'
				,papf.person_id
				,PAPF.EMPLOYEE_NUMBER   --PERSON_NUMBER
				,NVL(PA.APPRAISAL_PERIOD_START_DATE,TRUNC(PREV.REVIEW_DATE,'YEAR')) APPRAISAL_PERIOD_START_DATE    --DATEFROM
				--,PA.ATTRIBUTE5  --OVERALL_RATING
                ,decode( PREV.performance_rating,
                      1,  'Basic Performance',
                        2 ,'Developing Performance',
                        3 ,'High Performance',
                        4 , 'Superior Performance',
                        5 , 'Top Performance'
                ) --OVERALL_RATING
				,'Config'           --PROFILEID
				, 'Config'    --12501       --SECTIONID
				, NULL          --ProfileCode 
				, 'Config'    --125         --ContentTypeId
                , NULL          --RatingModelId1
				, NULL          --RatingModelCode1
				, NULL          --RatingLevelId1
				, NULL          --QualifierId1
				, NVL(PA.APPRAISAL_PERIOD_END_DATE,TO_DATE('31-DEC-4712','DD-MON-YYYY'))     --DATETO
          FROM  XXMX_HCM_CURRENT_PERSON_MV PAPF
             ,  per_performance_reviews@xxmx_extract PREV
             ,  per_appraisals@xxmx_extract PA
         WHERE  PAPF.PERSON_ID = PREV.PERSON_ID
           AND TRUNC(PREV.REVIEW_DATE) >= ADD_MONTHS(gvd_migration_date_from,-24)
		   AND nvl(trunc(papf.EFFECTIVE_END_DATE),gvd_migration_date_to) >= gvd_migration_date_from
           AND PREV.EVENT_ID = PA.EVENT_ID(+)
		   AND PAPF.user_person_type='Employee'
           AND gvd_migration_date_from BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE  --Added on 14Jun23(SIT2)
		   AND PAPF.BUSINESS_GROUP_ID = p_bg_id;

        COMMIT;
        --
        -- 
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
            --
    END export_performance_ratings;
--*************************************************************************

--********************************************************
--** Procedure for PERSON_COMPETENCES
--********************************************************
/*PROCEDURE export_competences
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_competences'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_profile_item_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_COMPETENCES';

    BEGIN
        --
        --        
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
        THEN            xxmx_utilities_pkg.log_module_message
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_profile_item_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,METADATA
                ,SOURCESYSTEMID
                ,SOURCESYSTEMOWNER
				,object_name
				,DATEFROM
                ,PROFILEID
				,SECTIONID
				,ProfileCode
				,ContentTypeId
                ,RatingModelId1
				,RatingLevelId1
				,QualifierId1
				,DATETO )
	SELECT    pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'          --MIGRATION_STATUS
                ,p_bg_name
                ,p_bg_id
				,'MERGE'
				, 'Profile_Item_'||employee_number||'_'||row_number() over (partition by person_id order by person_id) --SOURCESYSTEMID
				,'CITCO'                              --SOURCESYSTEMOWNER
				,'COMPETENCE'
				, date_from     --DATEFROM
				,NULL           --PROFILEID
				, '12501'       --SECTIONID
				, name       --ProfileCode (Competency_Name)
				, '125'         --ContentTypeId
                , NULL          --RatingModelId1
				, NULL          --RatingLevelId1
				, NULL          --QualifierId1
				, date_TO     --DATETO
		FROM (
        SELECT  DISTINCT  papf.employee_number
		        , papf.person_id
				, pc.date_from     --DATEFROM
				, Pc.name       --ProfileCode (Competency_Name)
				, pc.date_TO     --DATETO
          FROM per_competences@XXMX_EXTRACT pc
             , per_competence_elements@XXMX_EXTRACT pce
             , XXMX_HCM_CURRENT_PERSON_MV papf
         WHERE pce.competence_id = pc.competence_id
           AND pce.object_id = papf.person_id
           AND TRUNC(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
           AND pc.date_to is null
		   AND PAPF.BUSINESS_GROUP_ID = p_bg_id
		   );

        COMMIT;
        --
        -- 
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
            --
    END export_competences;   */
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
        --
        cv_ProcOrFuncName                  CONSTANT      VARCHAR2(30) := 'purge'; 
        ct_Phase                            CONSTANT      xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT      VARCHAR2(100) DEFAULT 'PERSON PURGE';
        --
        e_ModuleError                   EXCEPTION;
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
		gvv_ProgressIndicator := '0105';
        --
        --          
        DELETE
        FROM   xxmx_per_talent_profile_stg
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
                ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_talent_profile_stg" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
		gvv_ProgressIndicator := '0105';
        --
        --          
        DELETE
        FROM   xxmx_per_profile_item_stg
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
                ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_profile_item_stg" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0110';
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
        gvv_ProgressIndicator := '0120';
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
END xxmx_kit_talent_profile_stg;