--------------------------------------------------------
--  DDL for Package Body XXMX_KIT_GRADE_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_KIT_GRADE_STG" AS
    --
    --
		--//================================================================================
		--// Version1
		--// $Id:$
		--//================================================================================
		--// Object Name        :: xxmx_kit_grade_stg
		--//
		--// Object Type        :: Package Body
		--//
		--// Object Description :: This package contains procedures for populating HCM 
		--//                            Grades from EBS
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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_grade_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'GRADE';

    gvv_set_code                                       VARCHAR2(1000) DEFAULT xxmx_KIT_UTIL_stg.get_set_code;
    gvv_ReturnStatus                                   VARCHAR2(1); 
    gvv_ProgressIndicator                              VARCHAR2(100); 
    gvn_RowCount                                       NUMBER;
    gvt_ReturnMessage                                  xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                       xxmx_module_messages .severity%TYPE;
    gvt_OracleError                                    xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                                  xxmx_module_messages .module_message%TYPE;
    e_ModuleError                 EXCEPTION;

    PROCEDURE export
        (p_bg_name                      IN      VARCHAR2
        ,p_bg_id                        IN      number
        ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName               CONSTANT      VARCHAR2(30) := 'export';   
        vt_ClientSchemaName                           xxmx_client_config_parameters.config_value%TYPE;
        ct_Phase                        CONSTANT      xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_stagingtable                 CONSTANT      VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel        CONSTANT      VARCHAR2(100) DEFAULT 'GRADE EXPORT';

        vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        --
        --main
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_grades_f_5".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_grades_f_5 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_grades_f_10".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_grades_f_10 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --
        --3 
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_grades_f_tl_15".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_grades_f_tl_15 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --
        -- 4
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_grades_f_tl_25".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_grades_f_tl_25 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --  Main finished
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

    PROCEDURE export_grades_f_5
        (p_bg_name                      IN      VARCHAR2
        ,p_bg_id                        IN      number
        ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName              CONSTANT VARCHAR2(30) := 'export_grades_f_5'; 
        ct_Phase                       CONSTANT xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                CONSTANT VARCHAR2(100) DEFAULT 'xxmx_grades_f_stg';
        cv_i_BusinessEntityLevel       CONSTANT VARCHAR2(100) DEFAULT 'GRADES_F_5';

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
                ,pt_i_ModuleMessage       => 'Deleting from xxmx_grades_f_stg.' 
                    ,pt_i_OracleError         => gvt_ReturnMessage  );
        --                        
        delete
        FROM    xxmx_grades_f_stg
        WHERE   xxmx_grades_f_stg.bg_id    = p_bg_id    ;
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
        INTO    xxmx_grades_f_stg
                    (migration_set_id
                    ,migration_set_name                   
                    ,migration_status
                    ,bg_name
                    ,bg_id
                    ,effective_start_date
                    ,effective_end_date
                    ,set_code
                    ,action_occurrence_id
                    ,starting_step
                    ,grade_code
                    ,grade_type
                    ,active_status
                    ,grade_id)
        SELECT       pt_i_MigrationSetID                               
                    ,pt_i_MigrationSetName                               
                    ,'EXTRACTED'  
                    ,p_bg_name
                    ,p_bg_id
                    ,per_grades.date_from effective_start_date
                    ,nvl (per_grades.date_to
                            ,to_date ('31-12-4712'
                                    ,'DD-MM-YYYY')) effective_end_date
                    ,gvv_set_code
                    ,- 1
                    ,NULL starting_step
                    ,substr(per_grades.name,1,30) grade_code
                    ,'GRADE' grade_type
                    ,'A' active_status
                    ,grade_id
                        || '_GRADE'
        FROM    per_grades@XXMX_EXTRACT per_grades
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        horg.organization_id = per_grades.business_group_id
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
    END export_grades_f_5;

    PROCEDURE export_grades_f_10
        (p_bg_name                      IN                  VARCHAR2
        ,p_bg_id                        IN                  number
        ,pt_i_MigrationSetID            IN                  xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN                  xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT        VARCHAR2(30) := 'export_grades_f_10'; 
        ct_Phase                            CONSTANT        xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT        VARCHAR2(100) DEFAULT 'xxmx_grades_f_stg';
        cv_i_BusinessEntityLevel            CONSTANT        VARCHAR2(100) DEFAULT 'GRADES_F_10';
    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
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
        INTO    xxmx_grades_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,grade_id
                ,effective_start_date
                ,effective_end_date
                ,set_code
                ,action_occurrence_id
                ,grade_code
                ,grade_type
                ,active_status)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_grades.grade_id
                    || '_GRADE' grade_id
                ,per_grades.date_to + 1 effective_start_date
                ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY') effective_end_date
                ,gvv_set_code
                ,- 1
                ,substr(per_grades.name,1,30) grade_code
                ,'GRADE' grade_type
                ,'I' active_status
        FROM    per_grades@XXMX_EXTRACT per_grades
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_grades.date_to IS NOT NULL
                AND     per_grades.date_to <> to_date ('31-12-4712'
                                                    ,'DD-MM-YYYY')
                )
        AND     (
                        horg.organization_id = per_grades.business_group_id
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
  END export_grades_f_10;

    PROCEDURE export_grades_f_tl_15
        (p_bg_name                      IN      VARCHAR2
        ,p_bg_id                        IN      number
        ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName           CONSTANT    VARCHAR2(30) := 'export_grades_f_tl_15';          
        ct_Phase                    CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable           CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_grades_f_tl_stg';
        cv_i_BusinessEntityLevel    CONSTANT    VARCHAR2(100) DEFAULT 'GRADES_F_TL_15';
    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
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
                    ,pt_i_ModuleMessage       => 'Deleting from xxmx_grades_f_stg AND xxmx_grades_f_tl_stg.' 
                    ,pt_i_OracleError         => gvt_ReturnMessage  );
        --    
        DELETE                     
        FROM    xxmx_grades_f_tl_stg
        WHERE   xxmx_grades_f_tl_stg.bg_id    = p_bg_id    ;
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "xxmx_grades_f_tl_stg".'   
                ,pt_i_OracleError         => gvt_ReturnMessage       );

        INSERT
        INTO    xxmx_grades_f_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,grade_id
                ,effective_start_date
                ,effective_end_date
                ,language
                ,source_lang
                ,name)
        SELECT       
                pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_grades.grade_id
                || '_GRADE' grade_id
                ,per_grades.date_from effective_start_date
                ,nvl (per_grades.date_to
                        ,to_date ('31-12-4712'
                                ,'DD-MM-YYYY')) effective_end_date
                ,'US' language
                ,'US' source_lang
                ,substr (per_grades_tl.name
                        ,1
                        ,240) name
        FROM    per_grades@XXMX_EXTRACT per_grades
                ,per_grades_tl@XXMX_EXTRACT per_grades_tl
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_grades_tl.grade_id = per_grades.grade_id
                AND     per_grades_tl.language = 'US'
                )
        AND     (
                        horg.organization_id = per_grades.business_group_id
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
        --
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

    END export_grades_f_tl_15;

    PROCEDURE export_grades_f_tl_25
        (p_bg_name                      IN      VARCHAR2
        ,p_bg_id                        IN      number
        ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName            CONSTANT      VARCHAR2(30) := 'export_grades_f_tl_25'; 
        ct_Phase                            CONSTANT  xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT VARCHAR2(100) DEFAULT 'xxmx_grades_f_tl_stg';
        cv_i_BusinessEntityLevel            CONSTANT VARCHAR2(100) DEFAULT 'GRADES_F_TL_25';

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
        --
        INSERT
        INTO    xxmx_grades_f_tl_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,grade_id
                ,effective_start_date
                ,effective_end_date
                ,language
                ,source_lang
                ,name)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,per_grades.grade_id
                || '_GRADE' grade_id
            ,per_grades.date_to + 1 effective_start_date
            ,to_date ('31-12-4712'
                        ,'DD-MM-YYYY') effective_end_date
            ,'US' language
            ,'US' source_lang
            ,substr (per_grades_tl.name
                    ,1
                    ,240) name
        FROM     per_grades@XXMX_EXTRACT per_grades
                ,per_grades_tl@XXMX_EXTRACT per_grades_tl
                ,hr_all_organization_units@XXMX_EXTRACT horg
        WHERE   (
                        per_grades.date_to IS NOT NULL
                AND     per_grades.date_to <> to_date ('31-12-4712'
                                                    ,'DD-MM-YYYY')
                )
        AND     (
                        per_grades_tl.grade_id = per_grades.grade_id
                AND     per_grades_tl.language = 'US'
                )
        AND     (
                        horg.organization_id = per_grades.business_group_id
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
    END export_grades_f_tl_25;

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
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'purge'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GRADES PURGE';
        --
        e_ModuleError                   EXCEPTION;
        --

     --
    BEGIN
        --
        gvv_ProgressIndicator := '0010';
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
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
        IF   gvv_ReturnStatus = 'F'
        THEN
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
                ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        IF   pt_i_MigrationSetID IS NULL
        THEN
            --
            gvt_Severity      := 'ERROR';
            gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
            --
            RAISE e_ModuleError;
            --
        END IF;
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
        gvv_ProgressIndicator := '0030';
        --
        DELETE
        FROM   xxmx_grades_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_grades_f_stg" table: '      ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        gvv_ProgressIndicator := '0040';
        --          
        DELETE
        FROM   xxmx_grades_f_tl_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_grades_f_stg" table: '    ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        DELETE
        FROM   xxmx_migration_details
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_DETAILS" table: '   ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
        --
        DELETE
        FROM   xxmx_migration_headers
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%ROWCOUNT;
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
            ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_HEADERS" table: '  ||gvn_RowCount
            ,pt_i_OracleError         => NULL
            );
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
        COMMIT;
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
        EXCEPTION
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
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                        ,pt_i_OracleError         => gvt_OracleError
                        );
                --
                RAISE;
                --** END OTHERS Exception
            --** END Exception Handler
        --
    END purge;
     --
END xxmx_kit_grade_stg;

/
