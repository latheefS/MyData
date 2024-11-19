CREATE OR REPLACE PACKAGE xxmx_irec_job_requisition_stg AS

--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_hcm_irec_stg_pkg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Shireesha T.R
--**
--** PURPOSE   :  This package contains procedures for extracting IRecruitment into Staging tables

	/****************************************************************	
	----------------Export IRecruitment Information-------------------------
	*****************************************************************/
	PROCEDURE export_irec_job_requisition
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ; 

    PROCEDURE export_irec_jR_hiring_team
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

    PROCEDURE export_irec_jR_posting_detail
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


    PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


end xxmx_irec_job_requisition_stg;
/


CREATE OR REPLACE PACKAGE BODY  xxmx_irec_job_requisition_stg AS
--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_irecruit_job_requisition_stg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Shireesha T.R
--**
--** PURPOSE   :  This package contains procedures for extracting IRecruitment into Staging tables

	/****************************************************************	
	----------------Export IRecruitment Information-------------------------
	*****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irec_job_requisition_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'JOB_REQUISITION';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
	--pt_i_MigrationSetName                     VARCHAR2(100)                                         := 'IRecruitment '||to_char(SYSDATE, 'DD/MM/YYYY');  --no hard code
	--p_bg_name								  VARCHAR2(100)                                         := 'TEST_BG'; 
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvv_leg_code                VARCHAR2(100);

    E_MODULEERROR                              EXCEPTION;
    gvv_migration_date_from                    VARCHAR2(30); 
	gvv_prev_tax_year_date                     VARCHAR2(30);         
	gvd_migration_date_from                    DATE;
	gvd_prev_tax_year_date                     DATE;   
	gvv_migration_date_to                      VARCHAR2(30); 
	gvd_migration_date_to                      DATE; 
   -- gvt_user_person_type                       xxmx_migration_parameters.PARAMETER_VALUE%TYPE;

PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 

        CURSOR METADATA_CUR
        IS
            SELECT  Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ
			FROM     xxmx_migration_metadata a 
			WHERE application_suite = gct_ApplicationSuite
            AND Application = gct_Application
            AND business_entity = gv_i_BusinessEntity
			AND a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        CURSOR BG_CUR
        IS 
         SELECT DISTINCT
                    haou.organization_id,
                    haou.name
            FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'HR_BG'
           AND     haou.name            IN (
                                            SELECT xp.parameter_value
                                            FROM   xxmx_migration_parameters  xp
                                            WHERE  1 = 1
                                            AND    xp.application_suite      = 'HCM'            
                                            AND    xp.application            = 'HR'
                                            AND    xp.business_entity        = 'ALL'
                                            AND    xp.sub_entity             = 'ALL'
                                            AND    xp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                            AND    NVL(xp.enabled_flag, 'N') = 'Y'											    		
                        		);

    lv_sql VARCHAR2(32000);
    e_DateError                         EXCEPTION;

    l_leg_code VARCHAR2(1000);
    l_bg_name VARCHAR2(1000);
    l_bg_id NUMBER;

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'run_extract'; 
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REQUISITION';    

    vt_MigrationSetID                           xxmx_migration_headers.migration_set_id%TYPE;
    pt_i_MigrationSetID                         xxmx_migration_headers.migration_set_id%TYPE;
    vt_BusinessEntitySeq                        xxmx_migration_metadata.business_entity_seq%TYPE;


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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract',
             pt_i_OracleError         => NULL
        );

      --
        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM');  


        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_from,
             pt_i_OracleError         => NULL
        );
         --
        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application               =>     gct_Application
                        ,pt_i_BusinessEntity            =>     'ALL'
                        ,pt_i_SubEntity                 =>     'ALL'
                        ,pt_i_ParameterCode             =>     'MIGRATE_DATE_TO');        

        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_to,
             pt_i_OracleError         => NULL
        );

      	/*gvt_user_person_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite            =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'CANDIDATE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'PERSON_TYPE');  */


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
            ,pt_i_ModuleMessage       => 'Call to IREC Extracts- Job Requisition',
             pt_i_OracleError         => NULL
        );

    FOR BG_REC IN BG_CUR LOOP -- 10 

        l_bg_name := NULL;
        l_bg_id := NULL;
        l_bg_name := BG_REC.name;
        l_bg_id := BG_REC.organization_id;

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('||''''|| l_bg_name
                            ||''','						 
                            ||l_bg_id
                            ||','
                            ||vt_MigrationSetID
                            ||','''
                            ||pt_i_MigrationSetName
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;


END stg_main;  

PROCEDURE export_irec_job_requisition
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE 
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS 

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(80) := 'export_irec_job_requisition'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JOB_REQ_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REQUISITION'; 

        lvv_migration_date_to                           VARCHAR2(30); 
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_to                           DATE;  
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;  

        e_DateError                         EXCEPTION;
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
        FROM    XXMX_HCM_IREC_JOB_REQ_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT  
        INTO    XXMX_HCM_IREC_JOB_REQ_STG
               (
			   FILE_SET_ID			    ,
			   MIGRATION_SET_ID 	    ,
			   MIGRATION_SET_NAME 	    ,
			   MIGRATION_STATUS	        ,
			   BG_NAME   			    , 
			   BG_ID            	    ,
			   METADATA			        ,
			   OBJECTNAME			    ,
			   REQUISITION_ID			,			
			   REQUISITION_NUMBER		,			
			   RECRUITING_TYPE			,			
			   JOB_ID					,			
			   NUMBER_OF_OPENINGS		  ,			
			   UNLIMITED_OPENINGS_FLAG		,		
			   REQUISITION_TITLE			,		
			   INTERNAL_REQUISITION_TITLE ,			
			   BUSINESS_JUSTIFICATION	,			
			   HIRING_MANAGER_ID		,			
			   RECRUITER_ID				,		
			   PRIMARY_WORK_LOCATION_ID	,		
			   GRADE_ID					,		
			   ORGANIZATION_ID			,			
			   JOB_FAMILY_ID			,			
			   JOB_FUNCTION				,		
			   LEGAL_EMPLOYER_ID		,			
			   BUSINESS_UNIT_ID			,		
			   DEPARTMENT_ID			,			
			   SOURCING_BUDGET			,			
			   TRAVEL_BUDGET			,			
			   RELOCATION_BUDGET		,			
			   EMPLOYEE_REFERRAL_BONUS	,			
			   BUDGET_CURRENCY			,			
			   MAXIMUM_SALARY			,			
			   MINIMUM_SALARY			,			
			   PAY_FREQUENCY			,			
			   SALARY_CURRENCY			,			
			   WORKER_TYPE				,			
			   REGULAR_OR_TEMPORARY		,		
			   MANAGEMENT_LEVEL			,		
			   FULLTIME_OR_PARTTIME		,		
			   JOB_SHIFT				,			
			   JOB_TYPE					,		
			   EDUCATION_LEVEL			,			
			   CONTACT_NAME_EXTERNAL	,			
			   CONTACT_EMAIL_EXTERNAL			,	
/*			   EXTERNAL_SHORT_DESCRIPTION		*/
/*			   EXTERNAL_DESCRIPTION				*/
			   EXTERNAL_EMPLOYER_DESCRIPTION_ID	,
			   EXTERNAL_ORGANIZATION_DESCRIPTION_ID,
			   CONTACT_NAME_INTERNAL				,
			   CONTACT_EMAIL_INTERNAL				,
/*	   INTERNAL_SHORT_DESCRIPTION			*/
/*		   INTERNAL_DESCRIPTION			    */
			   INTERNAL_EMPLOYER_DESCRIPTION_ID	    ,
			   INTERNAL_ORGANIZATION_DESCRIPTION_ID ,
			   DISPLAY_IN_ORG_CHART_FLAG			,
			   CURRENT_PHASE_ID					,
			   CURRENT_STATE_ID					,  
/*COMMENTS						*/
			   JOB_CODE							,
			   HIRING_MANAGER_PERSON_NUMBER		,
			   HIRING_MANAGER_ASSIGNMENT_NUMBER	,
			   RECRUITER_PERSON_NUMBER			,	
			   RECRUITER_ASSIGNMENT_NUMBER		,	
			   PRIMARY_LOCATION_NAME			,	
			   GRADE_CODE						,	
			   ORGANIZATION_CODE				,	
			   JOB_FAMILY_NAME					,	
			   LEGAL_EMPLOYER_NAME				,	
			   BUSINESS_UNIT_SHORT_CODE			,
			   DEPARTMENT_NAME					,	
			   CURRENT_PHASE_CODE				,	
			   CURRENT_STATE_CODE				,	
			   PRIMARY_WORK_LOCATION_CODE		,	
			   BUDGET_CURRENCY_NAME				,
			   SALARY_CURRENCY_NAME	            ,
			   EXTERNAL_EMPLOYER_DESCRIPTION_CODE	   ,
			   EXTERNAL_ORGANIZATION_DESCRIPTION_CODE  ,
			   INTERNAL_EMPLOYER_DESCRIPTION_CODE	   ,
			   INTERNAL_ORGANIZATION_DESCRIPTION_CODE  ,
			   SUBMISSIONS_PROCESS_TEMPLATE_ID	,
			   ORGANIZATION_NAME				,
			   CLASSIFICATION_CODE				,
			   PRIMARY_LOCATION_ID				,
			   BASE_LANGUAGE_CODE				,
			   CANDIDATE_SELECTION_PROCESS_CODE ,
			   JOB_FAMILY_CODE					,
			   EXTERNAL_APPLY_FLOW_ID			,
			   EXTERNAL_APPLY_FLOW_CODE		,
			   PIPELINE_REQUISITION_FLAG	,	
			   PIPELINE_REQUISITION_ID		,	
			   APPLY_WHEN_NOT_POSTED_FLAG	,	
			   PIPELINE_REQUISITION_NUMBER	,	
			   POSITION_ID					,	
			   POSITION_CODE				,	
			   REQUISITION_TEMPLATE_ID		,	
			   CODE							,
			   AUTOMATIC_FILL_FLAG			,	
			   SEND_NOTIFICATIONS_FLAG		,	
			   EXTERNAL_DESCRIPTION_ID		,	
			   INTERNAL_DESCRIPTION_ID		,	
			   EXTERNAL_DESCRIPTION_CODE	,	
			   INTERNAL_DESCRIPTION_CODE	,	
			   AUTO_OPEN_REQUISITION		,	
			   POSTING_EXPIRE_IN_DAYS		,	
			   AUTO_UNPOST_REQUISITION		,	
			   UNPOST_FORMULA_ID			,	
			   UNPOST_FORMULA_CODE			,	
			   GUID							,
			   SOURCE_SYSTEM_ID				,
			   SOURCE_SYSTEM_OWNER			,	
			   ATTRIBUTE_CATEGORY 			,		                             
			   ATTRIBUTE1 					,		
			   ATTRIBUTE2 					,		
			   ATTRIBUTE3 					,		
			   ATTRIBUTE4 					,		
			   ATTRIBUTE5 					,		
			   ATTRIBUTE6 					,		
			   ATTRIBUTE7 					,	
			   ATTRIBUTE8 					,	
			   ATTRIBUTE9 					,		
			   ATTRIBUTE10 					,	
			   ATTRIBUTE_NUMBER1 			,		
			   ATTRIBUTE_NUMBER2 			,		
			   ATTRIBUTE_NUMBER3 			,		
			   ATTRIBUTE_NUMBER4 			,		
			   ATTRIBUTE_NUMBER5 			,		
			   ATTRIBUTE_DATE1 				,	
			   ATTRIBUTE_DATE2 				,
			   ATTRIBUTE_DATE3 				,
			   ATTRIBUTE_DATE4 				,	
			   ATTRIBUTE_DATE5 				)
          SELECT
               NULL,
				pt_i_MigrationSetID  ,
				pt_i_MigrationSetName,
				'EXTRACTED'          ,
		        p_bg_name            ,
				p_bg_id              ,
                'MERGE'              ,
                'Job_Requisition'    ,
				NULL,
				'REQ' || req.requisition_id,
				NULL AS recruitingtype,
				NULL AS jobid,
				pav.number_of_openings   AS number_of_openings,
				'No' AS unlimitedopenings_flag,
				req.name  AS requisition_title,
				NULL AS internal_requisition_title,
				SUBSTR(pav.description,1,30) AS business_justification,
				NULL AS hiring_manager_id,
				NULL AS recruiter_id,
				NULL AS prim_work_loc_id,
				NULL AS grade_id,
				NULL AS organization_id,
				NULL AS job_family_id,
				pjo.name AS job_function,
				NULL AS legal_employer_id,
				NULL AS business_unit_id,
				NULL AS department_id,
				NULL AS sourcing_budget,
				NULL AS travel_budget,
				NULL AS relocation_budget,
				NULL AS empl_referral_bonus,
				NULL AS budget_currency,
				NULL AS maximum_salary,
				NULL AS minimum_salary,
				NULL AS pay_frequency,
				NULL AS salary_currency,
				NULL AS wroker_type,
				'REGULAR' AS regular_or_temporary,
				NULL AS management_level,
				'FULL TIME' AS fulltime_or_parttime,
				NULL AS job_shift,
				NULL AS job_type,
				NULL AS education_level,
				NULL AS contact_name_external,
				NULL AS contact_email_external,
				--NULL AS external_short_description,
				--NULL AS external_description,
				NULL AS external_empl_desc_id,
				NULL AS external_orga_desc_id,
				NULL AS contact_name_internal,
				NULL AS contact_email_internal,
				--NULL AS internal_short_desc,
				--NULL AS internal_desc,
				NULL AS internal_employer_desc_id,
				NULL AS internal_organization_desc_id,
				'N' AS display_in_org_chart_flag,
				NULL AS current_phase_id,
				NULL AS current_state_id,
				--req.comments   AS comments,
				NULL AS job_code,
				ppf.employee_number      AS hiring_manager_person_number,
				reqppf.employee_number      AS hiring_manager_assign_number,
				pavppf.employee_number      AS recruiter_person_number,
				NULL AS recruiter_assignment_num,
				hla.description          AS primary_loc_name,
				NULL AS grade_code,
				NULL AS organization_code,
				pjg.displayed_name   AS jobfamilyname,
				NULL AS legalemployername,
				NULL AS business_unit_short_code,
				hor.name AS department_name,
				NULL AS current_phase_code,
				NULL AS current_state_code,
				hla.location_code   AS primary_work_location_code,
				NULL AS budget_currency_name,
				NULL AS salary_currency_name,
				NULL AS ext_empl_desc_code,
				NULL AS ext_orga_desc_code,
				NULL AS inter_employer_desc_code,
				NULL AS internal_org_desc_code,
				NULL AS submissions_procs_temp_id,
				hor.name  AS organization_name,
				NULL AS classification_code,
				NULL AS primary_location_id,
				'US' AS base_language_code,
				NULL AS cand_selection_procss_code,
				NULL AS job_family_code,
				NULL AS external_apply_flow_id,
				NULL AS external_apply_flow_code,
				NULL AS pipeline_requisition_flag,
				NULL AS pipeline_requisition_id,
				'YES' AS apply_when_not_posted_flag,
				NULL AS pipeline_requisition_number,
				NULL AS position_id,
				NULL AS position_code,
				NULL AS requisition_template_id,
				NULL AS code,
				'No' AS automatic_fill_flag,
				'YES' AS send_notifications_flag,
				NULL AS external_description_id,
				NULL AS internal_description_id,
				NULL AS external_description_code,
				NULL AS internal_description_code,
				'No' AS auto_open_requisition,
				NULL AS posting_expire_in_days,
				NULL AS auto_unpost_requisition,
				NULL AS unpost_formula_id,
				NULL AS unpost_formula_code,
				NULL AS guid,
				NULL AS source_system_id,
				NULL AS source_system_owner,
				NULL AS attribute_category,
				NULL AS attribute1,
				NULL AS attribute2,
				NULL AS attribute3,
				NULL AS attribute4,
				NULL AS attribute5,
				NULL AS attribute6,
				NULL AS attribute7,
				NULL AS attribute8,
				NULL AS attribute9,
				NULL AS attribute10,
				NULL AS attribute_number1,
				NULL AS attribute_number2,
				NULL AS attribute_number3,
				NULL AS attribute_number4,
				NULL AS attribute_number5,
				NULL AS attribute_date1,
				NULL AS attribute_date2,
				NULL AS attribute_date3,
				NULL AS attribute_date4,
				NULL AS attribute_date5
        FROM
				per_requisitions@MXDM_NVIS_EXTRACT            req,
				per_all_vacancies@MXDM_NVIS_EXTRACT           pav,
				hr_all_organization_units@MXDM_NVIS_EXTRACT   hor,
				per_all_people_f@MXDM_NVIS_EXTRACT            ppf,
                per_all_people_f@MXDM_NVIS_EXTRACT            pavppf,
                per_all_people_f@MXDM_NVIS_EXTRACT            reqppf,
				per_jobs@MXDM_NVIS_EXTRACT                    pjo,
				per_job_groups@MXDM_NVIS_EXTRACT              pjg,
				hr_locations_all@MXDM_NVIS_EXTRACT            hla
        WHERE
				req.requisition_id = pav.requisition_id
				AND pav.organization_id = hor.organization_id
				AND pav.manager_id = ppf.person_id
				AND req.person_id = reqppf.person_id
				AND pjo.job_id = pav.job_id
				AND pjo.job_group_id = pjg.job_group_id
				AND pav.location_id = hla.location_id
				AND pav.recruiter_id = pavppf.person_id
                AND ppf.business_Group_id = p_bg_id
                AND reqppf.business_Group_id = p_bg_id
                AND pavppf.business_Group_id = p_bg_id
                AND trunc(sysdate) between ppf.effective_start_Date and ppf.effective_end_date
                AND trunc(sysdate) between reqppf.effective_start_Date and reqppf.effective_end_date
                AND trunc(sysdate) between pavppf.effective_start_Date and pavppf.effective_end_date;        


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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
	END export_irec_job_requisition;		



PROCEDURE export_irec_jR_hiring_team
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE 
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS 

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_jR_hiring_team'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JR_HIRE_TEAM_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JR_HIRING_TEAM'; 

        lvv_migration_date_to                           VARCHAR2(30); 
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_to                           DATE;  
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;  

        e_DateError                         EXCEPTION;
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
        FROM    XXMX_HCM_IREC_JR_HIRE_TEAM_STG    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT  
        INTO    XXMX_HCM_IREC_JR_HIRE_TEAM_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   TEAM_MEMBER_ID	,
				   COLLABORATOR_TYPE,
				   REQUISITION_NUMBER,
				   MEMBER_TYPE,
				   PERSON_NUMBER,
				   REQUISITION_ID,
				   ASSIGNMENT_ID	,
				   ASSIGNMENT_NUMBER,
				   PERSON_ID,
				   GUID	 ,
				   SOURCE_SYSTEM_ID	    ,
				   SOURCE_SYSTEM_OWNER	,
			       ---                
			       ATTRIBUTE_CATEGORY,
			       ATTRIBUTE1 ,
			       ATTRIBUTE2 ,
			       ATTRIBUTE3 ,
			       ATTRIBUTE4 ,
			       ATTRIBUTE5 ,
			       ATTRIBUTE6 ,
			       ATTRIBUTE7 ,
			       ATTRIBUTE8 ,
			       ATTRIBUTE9 ,
			       ATTRIBUTE10   ,
			       ATTRIBUTE_NUMBER1 ,
			       ATTRIBUTE_NUMBER2 ,
			       ATTRIBUTE_NUMBER3 ,
			       ATTRIBUTE_NUMBER4 ,
			       ATTRIBUTE_NUMBER5 ,
			       ATTRIBUTE_DATE1  ,
			       ATTRIBUTE_DATE2  ,
			       ATTRIBUTE_DATE3  ,
			       ATTRIBUTE_DATE4  ,
			       ATTRIBUTE_DATE5  
			   )SELECT

                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
                    NULL AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Hiring Manager' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                    Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5 

             FROM
					per_requisitions@MXDM_NVIS_EXTRACT     per,
					per_all_vacancies@MXDM_NVIS_EXTRACT    pav,
					per_all_people_f@MXDM_NVIS_EXTRACT     papf
--per_all_people_f ppf_recruiter,
			WHERE
				   per.requisition_id = pav.requisition_id
			AND pav.manager_id = papf.person_id
			AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
			AND papf.business_Group_id = p_bg_id

			UNION
			SELECT
                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
					null AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Recruiter' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                    Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5 
			FROM
					per_requisitions@MXDM_NVIS_EXTRACT     per,
					per_all_vacancies@MXDM_NVIS_EXTRACT    pav,
					per_all_people_f@MXDM_NVIS_EXTRACT     papf

			WHERE
					per.requisition_id = pav.requisition_id
					AND pav.recruiter_id = papf.person_id
                    AND papf.business_Group_id = p_bg_id
					AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
					;

            INSERT  
        INTO    XXMX_HCM_IREC_JR_HIRE_TEAM_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   TEAM_MEMBER_ID	,
				   COLLABORATOR_TYPE,
				   REQUISITION_NUMBER,
				   MEMBER_TYPE,
				   PERSON_NUMBER,
				   REQUISITION_ID,
				   ASSIGNMENT_ID	,
				   ASSIGNMENT_NUMBER,
				   PERSON_ID,
				   GUID	 ,
				   SOURCE_SYSTEM_ID	    ,
				   SOURCE_SYSTEM_OWNER	,
			       ---                
			       ATTRIBUTE_CATEGORY,
			       ATTRIBUTE1 ,
			       ATTRIBUTE2 ,
			       ATTRIBUTE3 ,
			       ATTRIBUTE4 ,
			       ATTRIBUTE5 ,
			       ATTRIBUTE6 ,
			       ATTRIBUTE7 ,
			       ATTRIBUTE8 ,
			       ATTRIBUTE9 ,
			       ATTRIBUTE10   ,
			       ATTRIBUTE_NUMBER1 ,
			       ATTRIBUTE_NUMBER2 ,
			       ATTRIBUTE_NUMBER3 ,
			       ATTRIBUTE_NUMBER4 ,
			       ATTRIBUTE_NUMBER5 ,
			       ATTRIBUTE_DATE1  ,
			       ATTRIBUTE_DATE2  ,
			       ATTRIBUTE_DATE3  ,
			       ATTRIBUTE_DATE4  ,
			       ATTRIBUTE_DATE5  
			   )
			SELECT
                    NULL,
                    pt_i_MigrationSetID  ,
                    pt_i_MigrationSetName,
                    'EXTRACTED'          ,
                    p_bg_name            ,
                    p_bg_id              ,
                    'MERGE'              ,
                    'JR_HIRING_TEAM'    ,
					null AS teammemberid,
					'ORA_HIRING_TEAM_COLLABORATOR' AS collaboratortype,
					'REQ' || per.requisition_id AS requisitionnumber,
					'Collaborator' AS membertype,
					papf.employee_number AS personnumber,
					NULL requisitionid,
					NULL AS assignmentid,
					NULL AS assignmentnumber,
					NULL AS personid,
                     Null,
                    Null,
                    NUll,
                    NULL as ATTRIBUTE_CATEGORY,
                    NULL as ATTRIBUTE1 ,
                    NULL as ATTRIBUTE2 ,
                    NULL as ATTRIBUTE3 ,
                    NULL as ATTRIBUTE4 ,
                    NULL as ATTRIBUTE5 ,
                    NULL as ATTRIBUTE6 ,
                    NULL as ATTRIBUTE7 ,
                    NULL as ATTRIBUTE8 ,
                    NULL as ATTRIBUTE9 ,
                    NULL as ATTRIBUTE10   ,
                    NULL as ATTRIBUTE_NUMBER1 ,
                    NULL as ATTRIBUTE_NUMBER2 ,
                    NULL as ATTRIBUTE_NUMBER3 ,
                    NULL as ATTRIBUTE_NUMBER4 ,
                    NULL as ATTRIBUTE_NUMBER5 ,
                    NULL as ATTRIBUTE_DATE1  ,
                    NULL as ATTRIBUTE_DATE2  ,
                    NULL as ATTRIBUTE_DATE3  ,
                    NULL as ATTRIBUTE_DATE4  ,
                    NULL as ATTRIBUTE_DATE5 
			FROM
					per_requisitions@MXDM_NVIS_EXTRACT        per,
					per_all_vacancies@MXDM_NVIS_EXTRACT       pav,
					hz_parties@MXDM_NVIS_EXTRACT              par,
					per_all_people_f@MXDM_NVIS_EXTRACT        papf,
					irc_rec_team_members@MXDM_NVIS_EXTRACT    rec
			WHERE
					par.party_id = papf.party_id
			AND     party_type = 'PERSON'
			AND 	per.requisition_id = pav.requisition_id
			AND 	rec.party_id = par.party_id
			AND 	rec.vacancy_id = pav.vacancy_id
            AND NOT  exists (SELECT
					        papf.employee_number
					FROM
							xxmx_hcm_irec_jr_hire_team_stg xrec

					WHERE
							papf.EMPLOYEE_NUMBER = xrec.person_number
							  )
			AND papf.business_Group_id = p_bg_id
			AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date;   


--        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR 
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );        


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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
	END export_irec_jR_hiring_team;		

--JR Posting Details 
PROCEDURE export_irec_jR_posting_detail
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE 
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS 

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_jR_posting_detail'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_JR_POST_DET_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JR_POSTING_DETAIL'; 

        lvv_migration_date_to                           VARCHAR2(30); 
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_to                           DATE;  
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;  

        e_DateError                         EXCEPTION;
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
        FROM    XXMX_HCM_IREC_JR_POST_DET_STG    
        ;

        COMMIT;

		INSERT  
        INTO    XXMX_HCM_IREC_JR_POST_DET_STG
               (
				   FILE_SET_ID			,
				   MIGRATION_SET_ID 	,
				   MIGRATION_SET_NAME 	,
				   MIGRATION_STATUS	    ,
				   BG_NAME   			,
				   BG_ID            	,
				   METADATA			    ,
				   OBJECTNAME			,
				   --
				   PUBLISHED_JOB_ID     ,
				   EXTERNAL_OR_INTERNAL ,
				   REQUISITION_NUMBER	,
				   REQUISITION_ID       ,
				   END_DATE				,
				   START_DATE			,
				   POSTING_STATUS		,
                   ATTRIBUTE_CATEGORY 	,
                    ATTRIBUTE1 			,
                    ATTRIBUTE2 			,
                    ATTRIBUTE3 			,
                    ATTRIBUTE4 			,
                    ATTRIBUTE5 			,
                    ATTRIBUTE6 			,
                    ATTRIBUTE7 			,
                    ATTRIBUTE8 			,
                    ATTRIBUTE9 			,
                    ATTRIBUTE10 		,
                    ATTRIBUTE_NUMBER1 	,
                    ATTRIBUTE_NUMBER2 	,
                    ATTRIBUTE_NUMBER3 	,
                    ATTRIBUTE_NUMBER4 	,
                    ATTRIBUTE_NUMBER5 	,
                    ATTRIBUTE_DATE1 	,
                    ATTRIBUTE_DATE2 	,
                    ATTRIBUTE_DATE3 	,
                    ATTRIBUTE_DATE4 	,
                    ATTRIBUTE_DATE5 	

			   )
			   SELECT
               NULL,
				pt_i_MigrationSetID  ,
				pt_i_MigrationSetName,
				'EXTRACTED'          ,
		        p_bg_name            ,
				p_bg_id              ,
                'MERGE'              ,
                'JR_POSTING_DETAIL'    ,
				NULL AS PUBLISHED_JOB_ID,
				NULL AS external_or_internal,
				'REQ' || per.requisition_id AS requisition_number,
                NULL AS REQUISITION_ID,
				NULL AS end_date,
				SYSDATE start_date,
					(
					CASE
						WHEN sysdate BETWEEN per.date_from AND per.date_to THEN
							'POSTED'
						WHEN per.date_to IS NULL THEN
							'POSTED'
						ELSE
							'EXPIRED'
					END
				)as POSTING_STATUS,
                NULL AS	ATTRIBUTE_CATEGORY ,
                NULL AS	ATTRIBUTE1         ,
                NULL AS	ATTRIBUTE2         ,
                NULL AS	ATTRIBUTE3         ,
                NULL AS	ATTRIBUTE4         ,
                NULL AS	ATTRIBUTE5         ,
                NULL AS	ATTRIBUTE6         ,
                NULL AS	ATTRIBUTE7         ,
                NULL AS	ATTRIBUTE8         ,
                NULL AS	ATTRIBUTE9         ,
                NULL AS	ATTRIBUTE10        ,
                NULL AS	ATTRIBUTE_NUMBER1  ,
                NULL AS	ATTRIBUTE_NUMBER2  ,
                NULL AS	ATTRIBUTE_NUMBER3  ,
                NULL AS	ATTRIBUTE_NUMBER4  ,
                NULL AS	ATTRIBUTE_NUMBER5  ,
                NULL AS	ATTRIBUTE_DATE1    ,
                NULL AS	ATTRIBUTE_DATE2    ,
                NULL AS	ATTRIBUTE_DATE3    ,
                NULL AS	ATTRIBUTE_DATE4    ,
                NULL AS	ATTRIBUTE_DATE5    

				FROM
					per_requisitions@MXDM_NVIS_EXTRACT per
               ,per_all_vacancies@MXDM_NVIS_EXTRACT   pav
            where per.requisition_id = pav.requisition_id
            and pav.business_group_id = p_bg_id;

--        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR 
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );        


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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
	END export_irec_jR_posting_detail;		

END xxmx_irec_job_requisition_stg;
/
