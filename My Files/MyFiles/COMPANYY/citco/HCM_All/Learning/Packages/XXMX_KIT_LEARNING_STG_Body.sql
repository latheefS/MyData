create or replace PACKAGE BODY xxmx_kit_learning_stg AS

		--
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_learning_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for extracting Learning , Course 
		--//                       Data from EBS.
		--//
		--//
		--// Version Control
		--//================================================================================
		--// Version      Author               Date               Description
		--//--------------------------------------------------------------------------------
		--// 1.1         Vamsi Krishna        14/03/2022         Initial Build
		--//================================================================================
		--
		--
     --

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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_learning_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'LEARNING';

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages.module_message%TYPE;
    gvt_Severity                                xxmx_module_messages.severity%TYPE;
    gvt_OracleError                             xxmx_module_messages.oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages.module_message%TYPE;
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
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LEARNING EXPORT';

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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_learning_certification".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_learning_certification (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        -- 2
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_learning_classes".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_learning_classes (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

        -- 3
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_learning_courses".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_learning_courses (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

		-- 4

        gvv_ProgressIndicator := '0060';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_learner_records".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_learner_records (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
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
---------------------------------------------------------------------------------------
-- Export Certifications Procedure
---------------------------------------------------------------------------------------
    PROCEDURE export_learning_certification 
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_learning_certification'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_OLM_CERTIFICATION_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CERTIFICATION';        

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
        FROM    XXMX_OLM_CERTIFICATION_STG
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
          INTO  XXMX_OLM_CERTIFICATION_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name                ,bg_id
				,METADATA
                ,EMPLOYEE_NUMBER
                ,FULL_NAME
                ,CERT_ENROLLMENT_ID
                ,CERTIFICATION_ID
                ,PERSON_ID
                ,CERTIFICATION_STATUS_CODE
                ,ENROLLMENT_DATE
                ,COMPLETION_DATE
                ,IS_AUTOMATIC_SUBSCRIPTION
                ,CERTIFICATION_NAME
				,SourceSystemOwner
                ,SourceSystemId )
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,'MERGE'
                ,MV.EMPLOYEE_NUMBER
                ,MV.FULL_NAME
                ,OCE.CERT_ENROLLMENT_ID
                ,OCE.CERTIFICATION_ID
                ,OCE.PERSON_ID
                ,OCE.CERTIFICATION_STATUS_CODE
                ,OCE.ENROLLMENT_DATE
                ,OCE.COMPLETION_DATE
                ,OCE.IS_AUTOMATIC_SUBSCRIPTION
                ,OCTL.NAME
				,'CITCO' SourceSystemOwner
                ,'CERTIFICATE_'|| OCE.CERTIFICATION_ID||'_'||row_number() over (partition by OCE.CERTIFICATION_ID order by OCE.CERTIFICATION_ID) SourceSystemId
             FROM OTA_CERT_ENROLLMENTS@XXMX_EXTRACT OCE,
                  OTA_CERTIFICATIONS_TL@XXMX_EXTRACT OCTL,
                  XXMX_HCM_CURRENT_PERSON_MV MV
            WHERE OCTL.NAME IN ( 'CGS Onboarding eLearning Certification', 
                                 'Citco Lines of Business Overviews certification',
                                 'Citco Onboarding Compliance Certification', 
                                 'Mercator TMS - Learning Certification',
                                 'Citco Toronto Compliance and Regulatory Onboarding'  )
              AND OCE.CERTIFICATION_ID = OCTL.CERTIFICATION_ID
              AND MV.PERSON_ID = OCE.PERSON_ID
              AND CERTIFICATION_STATUS_CODE = 'ENROLLED' --OR CERTIFICATION_STATUS_CODE = 'CERTIFIED' )   Commented on 15SEP2022
			  AND ENROLLMENT_DATE >= gvd_migration_date_from-60;

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
    END export_learning_certification;
------------------------------------------------------------------------------------
-- Export Learning Classes Procedure
------------------------------------------------------------------------------------
    PROCEDURE export_learning_classes 
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_learning_classes'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_OLM_CLASS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CLASSES';

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
        FROM    XXMX_OLM_CLASS_STG
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
        INTO    XXMX_OLM_CLASS_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,METADATA
                ,COURSE_NUMBER
                ,ACTIVITY_VERSION_ID
                ,EVENT_TYPE
                ,TITLE
                ,COURSE_START_DATE
                ,COURSE_START_TIME
                ,COURSE_END_DATE
                ,COURSE_END_TIME
                ,TIMEZONE
                ,DURATION
                ,DURATION_UNITS
                ,ENROLMENT_START_DATE
                ,ENROLMENT_END_DATE
                ,MAXIMUM_ATTENDEES
                ,MAXIMUM_INTERNAL_ATTENDEES
                ,MINIMUM_ATTENDEES
                ,TRAINING_CENTER_ID
                ,LOCATION_ID
                ,PARENT_OFFERING_ID
                ,INSTRUCTOR
                ,INSTRUCTOR_NUMBER
				,SourceSystemOwner
                ,SourceSystemId 
				,PERSON_ID
				,PERSON_NUMBER
				,OFFERING_NAME)
        SELECT   UNIQUE pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,'MERGE' 
                ,OE.ACTIVITY_VERSION_ID COURSE_NUMBER
				--,NULL ACTIVITY_VERSION_ID
                ,OE.EVENT_ID       --Added on 24Oct2022
                ,OE.EVENT_TYPE
                ,OE.TITLE
                ,TO_CHAR(TO_DATE(OE.COURSE_START_DATE,'DD-MON-RRRR'),'RRRR/MM/DD')
                ,OE.COURSE_START_TIME
                ,TO_CHAR(TO_DATE(OE.COURSE_END_DATE,'DD-MON-RRRR'),'RRRR/MM/DD')
                ,OE.COURSE_END_TIME
                ,OE.TIMEZONE
                ,OE.DURATION
                ,OE.DURATION_UNITS
                ,OE.ENROLMENT_START_DATE
                ,OE.ENROLMENT_END_DATE
                ,OE.MAXIMUM_ATTENDEES
                ,OE.MAXIMUM_INTERNAL_ATTENDEES
                ,OE.MINIMUM_ATTENDEES
                ,OE.TRAINING_CENTER_ID
                ,OE.LOCATION_ID
                ,OE.PARENT_OFFERING_ID
                ,--MV.INSTRUCTOR                
                NVL(INSTRUCTOR,'Beresford, Iain') INSTRUCTOR
				--,MV.PERSON_ID
				,NVL(MV.PERSON_NUMBER,50) PERSON_NUMBER
				--,'CITCO' SourceSystemOwner
				, NULL SourceSystemOwner
                --, 'CLASS_' || OE.EVENT_ID||'_'||row_number() over (partition by OE.EVENT_ID order by OE.EVENT_ID) SourceSystemId
				,NULL SourceSystemId
            		,(SELECT EMPLOYEE_ID FROM FND_USER@XXMX_EXTRACT WHERE USER_ID=OFF.CREATED_BY) PERSON_ID
                ,(SELECT UNIQUE PERSONNUMBER FROM XXMX_PER_PERSONS_STG WHERE PERSON_ID=(SELECT EMPLOYEE_ID FROM FND_USER@XXMX_EXTRACT
                WHERE USER_ID=OFF.CREATED_BY)) PERSONNUMBER
				,OFF.NAME
          FROM OTA_EVENTS@XXMX_EXTRACT OE
             , (SELECT orb.event_id,osr.trainer_id PERSON_ID,mv.full_name INSTRUCTOR,MV.EMPLOYEE_NUMBER PERSON_NUMBER
                  FROM OTA_RESOURCE_BOOKINGS@XXMX_EXTRACT ORB
                     , OTA_SUPPLIABLE_RESOURCES@XXMX_EXTRACT OSR
                     , XXMX_HCM_CURRENT_PERSON_MV MV
                 WHERE ORB.SUPPLIED_RESOURCE_ID = OSR.SUPPLIED_RESOURCE_ID
                   AND OSR.TRAINER_ID = MV.PERSON_ID(+)
                   AND TRUNC(SYSDATE) BETWEEN mv.EFFECTIVE_START_DATE AND mv.EFFECTIVE_END_DATE) mv
				,ota_offerings_vl@xxmx_extract off
         WHERE OE.EVENT_ID = MV.EVENT_ID(+)
           AND OE.COURSE_START_TIME IS NOT NULL 
           AND OE.COURSE_END_TIME IS NOT NULL 
		   and oe.parent_offering_id = off.offering_id
           AND OE.COURSE_START_DATE >= gvd_migration_date_from;
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
    END export_learning_classes;
------------------------------------------------------------------------------------
-- Export Learning Courses Procedure
------------------------------------------------------------------------------------
    PROCEDURE export_learning_courses 
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_learning_courses'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_OLM_COURSE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'COURSES';

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
        FROM    XXMX_OLM_COURSE_STG
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
        INTO    XXMX_OLM_COURSE_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,METADATA
                ,EFFECTIVE_START_DATE
                ,EFFECTIVE_END_DATE
                ,COURSE_NUMBER
                ,PUBLISH_START_DATE
                ,PUBLISH_END_DATE
                ,TITLE
                ,DESCRIPTION
	            ,INTENDED_AUDIENCE
	            ,OBJECTIVES
	            ,PRIMARY_CATEGORY
	            ,PICTURE
				,SourceSystemOwner
                ,SourceSystemId 
				--,person_id
				--,PERSON_NUMBER
                )
        SELECT   UNIQUE pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,'MERGE' 
                ,TO_CHAR(TO_DATE(avt.START_DATE,'DD-MON-RRRR'),'RRRR/MM/DD')
                ,TO_CHAR(TO_DATE(avt.END_DATE,'DD-MON-RRRR'),'RRRR/MM/DD')
                ,avt.ACTIVITY_VERSION_ID
                ,NULL PUBLISH_START_DATE
                ,NULL PUBLISH_END_DATE
                ,avt.VERSION_NAME
                ,avt.DESCRIPTION
	            ,avt.INTENDED_AUDIENCE
	            ,avt.OBJECTIVES
	            /*,(SELECT CASE WHEN CATEGORY IN()
                    FROM OTA_CATEGORY_USAGES@xxmx_extract WHERE CATEGORY_USAGE_ID = AVD.CATEGORY_USAGE_ID) Primary_Category */
                ,(SELECT CASE WHEN CATEGORY IN('Emerging Leaders','Leadership Development','Leading Self','Leading Others','Core Skills')
                              THEN 'Leadership'
                              WHEN CATEGORY ='Onboarding'
                              THEN 'Onboarding'
                              WHEN CATEGORY IN('Global Mandatory Training','Mandated Learning')
                              THEN 'Mandatory Compliance'
                              ELSE 'Business Skills'
                        END CATEGORY
                    FROM OTA_CATEGORY_USAGES@xxmx_extract WHERE CATEGORY_USAGE_ID = AVD.CATEGORY_USAGE_ID) Primary_Category
	            ,NULL PICTURE
				--,'CITCO' SourceSystemOwner
				, NULL SourceSystemOwner
                --, 'COURSE_' || avt.ACTIVITY_VERSION_ID||'_'||row_number() over (partition by avt.ACTIVITY_VERSION_ID order by avt.ACTIVITY_VERSION_ID) SourceSystemId
				, NULL SourceSystemId
				--,(SELECT EMPLOYEE_ID FROM FND_USER@XXMX_EXTRACT WHERE USER_ID=OFF.CREATED_BY) PERSON_ID
                --,(SELECT UNIQUE PERSONNUMBER FROM XXMX_PER_PERSONS_STG WHERE PERSON_ID=(SELECT EMPLOYEE_ID FROM FND_USER@XXMX_EXTRACT WHERE USER_ID=OFF.CREATED_BY)) PERSONNUMBER
          FROM OTA_ACTIVITY_VERSIONS@XXMX_EXTRACT avt
             , APPS.OTA_ACTIVITY_DEFINITIONS@xxmx_extract AVD
             , APPS.OTA_EVENTS@xxmx_extract E
             , OTA_OFFERINGS_VL@XXMX_EXTRACT off
         WHERE avt.END_DATE IS NULL
           AND AVT.ACTIVITY_ID = AVD.ACTIVITY_ID(+)
           AND AVT.ACTIVITY_VERSION_ID = E.ACTIVITY_VERSION_ID(+)
           AND E.PARENT_OFFERING_ID = OFF.OFFERING_ID(+);
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
    END export_learning_courses;
---------------------------------------------------------------------
-- Export Learner Records
---------------------------------------------------------------------

    PROCEDURE export_learner_records 
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_learner_records'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_learner_records_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LEARNER RECORDS';

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
        FROM    xxmx_learner_records_stg
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
        INTO    xxmx_learner_records_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,METADATA
                ,COURSE_NAME
	            ,COURSE_CODE
	            ,CLASS_START_DATE
	            ,CLASS_END_DATE
	            ,CLASS_START_TIME
	            ,CLASS_END_TIME
	            ,TIMEZONE
                ,DURATION
                ,DURATION_UNITS
                ,CLASS_NAME
	            ,OFFERING_NAME
	            ,DELIVERY_MODE
	            ,PERSON_ID
				,PERSON_NUMBER
	            ,LEARNER
	            ,USER_PERSON_TYPE
                ,DEPARTMENT
				,ENROLLMENT_NUMBER
	            ,ENROLLMENT_STATUS
	            ,NUMBER_OF_PLACES
	            ,PLAYER_STATUS
	            ,MANDATOEY_ENROLLMENT
				,SourceSystemOwner
                ,SourceSystemId
                ,EVENT_ID )          --ADDED ON 26OCT2022
        SELECT pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,'MERGE' 
				,COURSE_NAME
				,COURSE_CODE
				,COURSE_START_DATE
				,COURSE_END_DATE
				,COURSE_START_TIME
				,COURSE_END_TIME
				,TIMEZONE
                ,DURATION
                ,CASE WHEN DURATION_UNITS = 'H' THEN 'ORA_DUR_HOUR'
                      WHEN DURATION_UNITS = 'D' THEN 'ORA_DUR_DAY'
                      WHEN DURATION_UNITS = 'MIN' THEN 'ORA_DUR_MINUTE'
                      ELSE NULL
                 END DURATION_UNITS
                ,CLASS_NAME
				,OFFERING_NAME
				,OFFERING_NAME    --DELIVERY_MODE
				,PERSON_ID
				,(SELECT UNIQUE PERSONNUMBER FROM XXMX_PER_PERSONS_STG WHERE PERSON_ID = LREC.PERSON_ID)
				,LEARNER
				,USER_PERSON_TYPE
                , (SELECT NAME FROM hr_all_organization_units@XXMX_EXTRACT WHERE TYPE='DEPARTMENT' AND ORGANIZATION_ID = LREC.ORGANIZATION_ID)  DEPARTMENT
				,ENROLLMENT_NUMBER
				,ENROLLMENT_STATUS
				,NUMBER_OF_PLACES
				--,XXMX_OLM_PLAYER_STATUS_FUN(LREC.EVENT_ID,LREC.LEARNING_OBJECT_ID,LREC.PERSON_ID) PLAYER_STATUS
				/*,XXMX_OLM_PLAYER_STATUS_PKG.get_enroll_lo_status( LREC.PERSON_ID
				                                                 ,'E'                  --p_user_type
                                                                 , LREC.EVENT_ID       --p_event_id
                                                                 , LREC.BOOKING_STATUS_TYPE_ID   --p_booking_status_type_id
                                                                 , LREC.BOOKING_ID      --p_booking_id
														        )*/ 
                , NULL PLAYER_STATUS
				,MANDATORY_ENROLLMENT
				,'CITCO' SourceSystemOwner
                ,'COURSE_' || EVENT_ID||'_'||row_number() over (partition by EVENT_ID order by EVENT_ID) SourceSystemId
                ,EVENT_ID
		FROM (SELECT  UNIQUE AVT.VERSION_NAME COURSE_NAME
				            ,AVT.ACTIVITY_VERSION_ID COURSE_CODE
				            ,E.COURSE_START_DATE
				            ,NVL(E.COURSE_END_DATE,ADD_MONTHS(E.COURSE_START_DATE,2)) COURSE_END_DATE
				            ,E.COURSE_START_TIME
				            ,E.COURSE_END_TIME
				            ,E.TIMEZONE
                            ,E.DURATION
                            ,E.DURATION_UNITS
                            ,E.TITLE CLASS_NAME
				            ,OFF.NAME OFFERING_NAME
				            ,PAPF.PERSON_ID
				            ,PAPF.FULL_NAME LEARNER
				            ,PAPF.USER_PERSON_TYPE
				            ,ODB.BOOKING_ID ENROLLMENT_NUMBER
				            ,OB.NAME ENROLLMENT_STATUS
				            ,ODB.NUMBER_OF_PLACES
				            ,DECODE(odb.IS_MANDATORY_ENROLLMENT,'Y','Yes','No') MANDATORY_ENROLLMENT
							,E.EVENT_ID,OFF.LEARNING_OBJECT_ID,ODB.ORGANIZATION_ID,ODB.BOOKING_STATUS_TYPE_ID,ODB.BOOKING_ID
                         FROM OTA_ACTIVITY_VERSIONS@xxmx_extract AVT
                            , APPS.OTA_EVENTS@xxmx_extract E
                           -- , OTA_LEARNING_PATH_MEMBERS@XXMX_EXTRACT OPM
                            --, OTA_LEARNING_PATHS@xxmx_extract OLP
                            , XXMX_HCM_CURRENT_PERSON_MV PAPF
                            , OTA_DELEGATE_BOOKINGS@XXMX_EXTRACT ODB
                            , APPS.OTA_BOOKING_STATUS_TYPES@xxmx_extract OB
		                    , OTA_OFFERINGS_VL@XXMX_EXTRACT off
                        WHERE 1=1--AVT.VERSION_NAME='Mandatory Disclosure Rules - EU DAC6 (New Hires CGS)'
                          AND AVT.ACTIVITY_VERSION_ID = E.ACTIVITY_VERSION_ID
                          --AND AVT.ACTIVITY_VERSION_ID = OPM.ACTIVITY_VERSION_ID
                          AND ODB.DELEGATE_PERSON_ID = PAPF.PERSON_ID
                          AND E.EVENT_ID = ODB.EVENT_ID
                          AND E.COURSE_START_TIME IS NOT NULL 
                          and E.COURSE_END_TIME IS NOT NULL 
                          AND E.COURSE_START_DATE >= gvd_migration_date_from
                          AND OB.BOOKING_STATUS_TYPE_ID = ODB.BOOKING_STATUS_TYPE_ID
                          AND OB.NAME IN('Enrolled','Attended')
		                  AND E.PARENT_OFFERING_ID = off.OFFERING_ID
                          AND papf.user_person_type = 'Employee'
                         -- AND AVT.ACTIVITY_VERSION_ID IN(SELECT COURSE_NUMBER FROM XXMX_OLM_CLASS_STG)
          /*    UNION
                       SELECT OAV.VERSION_NAME COURSE_NAME
                            , OAV.ACTIVITY_VERSION_ID COURSE_CODE
				            ,ODB.DATE_BOOKING_PLACED COURSE_START_DATE
				            ,NVL(OE.COURSE_END_DATE,ADD_MONTHS(ODB.DATE_BOOKING_PLACED,2)) COURSE_END_DATE
				            ,OE.COURSE_START_TIME
				            ,OE.COURSE_END_TIME
				            ,OE.TIMEZONE
                            ,OE.DURATION
                            ,OE.DURATION_UNITS
                            ,OE.TITLE CLASS_NAME
				            ,OFF.NAME OFFERING_NAME
				            ,PAPF.PERSON_ID
				            ,PAPF.FULL_NAME LEARNER
				            ,PAPF.USER_PERSON_TYPE
    			            ,ODB.BOOKING_ID ENROLLMENT_NUMBER
				            ,OB.NAME ENROLLMENT_STATUS
				            ,ODB.NUMBER_OF_PLACES
				            ,DECODE(odb.IS_MANDATORY_ENROLLMENT,'Y','Yes','No') MANDATORY_ENROLLMENT
							,OE.EVENT_ID,OFF.LEARNING_OBJECT_ID,ODB.ORGANIZATION_ID,ODB.BOOKING_STATUS_TYPE_ID,ODB.BOOKING_ID
                         FROM OTA_CERTIFICATIONS_VL@xxmx_Extract ocv
                            , OTA_CERTIFICATION_MEMBERS@xxmx_extract ocm
                            , ota_activity_versions@xxmx_extract oaV
                            , ota_events@xxmx_extract oe
                            , OTA_DELEGATE_BOOKINGS@XXMX_EXTRACT ODB
                            , APPS.OTA_BOOKING_STATUS_TYPES@xxmx_extract OB
                            , XXMX_HCM_CURRENT_PERSON_MV PAPF
                            , OTA_OFFERINGS_VL@XXMX_EXTRACT off
                        WHERE 1=1
                          AND ocv.certification_id = ocm.certification_id
                          AND oav.activity_version_id = ocm.object_id
                          --AND NVL(ocm.end_date_active, SYSDATE + 1) > SYSDATE 
						  --AND NVL(ocm.end_date_active, SYSDATE + 1) >= to_date('01-NOV-2021','DD-MON-YYYY')-60
                          AND NVL(ODB.DATE_BOOKING_PLACED, SYSDATE + 1) >= to_date('07-JUN-2023','DD-MON-YYYY')-60
                          AND oav.activity_version_id = oe.activity_version_id
                          AND oe.event_id = odb.event_id
                          AND OB.BOOKING_STATUS_TYPE_ID = ODB.BOOKING_STATUS_TYPE_ID
                          AND OB.NAME IN('Enrolled','Attended')
                          AND ODB.DELEGATE_PERSON_ID = PAPF.PERSON_ID 
                          AND oE.PARENT_OFFERING_ID = off.OFFERING_ID
                          AND ocv.NAME IN ( 'CGS Onboarding eLearning Certification', 
                                            'Citco Lines of Business Overviews certification',
                                            'Citco Onboarding Compliance Certification', 
                                            'Mercator TMS - Learning Certification',
                                            'Citco Toronto Compliance and Regulatory Onboarding'  )
                        AND papf.user_person_type = 'Employee' 
                        AND EXISTS (SELECT 1 
                                      FROM OTA_CERT_ENROLLMENTS@XXMX_EXTRACT OCE
                                     WHERE OCE.PERSON_ID = PAPF.PERSON_ID
                                       AND OCE.CERTIFICATION_ID = ocv.certification_id
                                       AND OCE.CERTIFICATION_STATUS_CODE = 'ENROLLED'
			                           AND OCE.ENROLLMENT_DATE >= TO_DATE('07-JUN-2023','DD-MON-YYYY')-60
                                       )
            */            --AND OAV.ACTIVITY_VERSION_ID IN(SELECT COURSE_NUMBER FROM XXMX_OLM_CLASS_STG)
    ) LREC;

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
    END export_learner_records;

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
        gvv_ProgressIndicator := '0030';
        --
        --
        DELETE
        FROM   XXMX_OLM_CERTIFICATION_STG
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
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_OLM_CERTIFICATION_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0040';
        --
        --          
        DELETE
        FROM   XXMX_OLM_CLASS_STG
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
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_OLM_CLASS_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
		gvv_ProgressIndicator := '0050';
        --
        --          
        DELETE
        FROM   XXMX_OLM_COURSE_STG
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
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_OLM_COURSE_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
		 gvv_ProgressIndicator := '0060';
        --
        --
        DELETE
        FROM   XXMX_LEARNER_RECORDS_STG
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
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_LEARNER_RECORDS_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '070';
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
        --        gvv_ProgressIndicator := '070';
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
END xxmx_kit_learning_stg;