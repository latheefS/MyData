CREATE OR REPLACE PACKAGE xxmx_irec_job_referral_stg AS

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
	PROCEDURE export_irec_job_referral
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ; 



    PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


end xxmx_irec_job_referral_stg;

/


CREATE OR REPLACE PACKAGE BODY  xxmx_irec_job_referral_stg AS
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
--** FILENAME  :  xxmx_irec_job_refferal_stg.sql
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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irec_job_refferal_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'JOB_REFERRAL';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
	--pt_i_MigrationSetName                     VARCHAR2(100)                                         := 'IRecruitment '||to_char(SYSDATE, 'DD/MM/YYYY');  --no hard code
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
   -- gvv_leg_code                VARCHAR2(100);

    E_MODULEERROR                              EXCEPTION;
    gvv_migration_date_from                    VARCHAR2(30); 
	gvv_prev_tax_year_date                     VARCHAR2(30);         
	gvd_migration_date_from                    DATE;
	gvd_prev_tax_year_date                     DATE;   
	--gvv_migration_date_to                      VARCHAR2(30); 
	--gvd_migration_date_to                      DATE; 
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

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'xxmx_irec_job_referal_stg'; 
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_REFERRAL_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REFERRAL';    

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
       /* gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'JOB_REFERRAL'
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
                        ,pt_i_BusinessEntity            =>     'JOB_REFERRAL'
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
        );*/

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
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts',
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

PROCEDURE export_irec_job_referral
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE 
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS 

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_REFERRAL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'JOB_REFERRAL'; 

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
        FROM   XXMX_HCM_IREC_REFERRAL_STG     
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT  
        INTO  XXMX_HCM_IREC_REFERRAL_STG(
			FILE_SET_ID			,
		    MIGRATION_SET_ID 	,
		    MIGRATION_SET_NAME 	,
		    MIGRATION_STATUS	,
		    BG_NAME   			,
		    BG_ID            	,
		    METADATA			,
		    OBJECTNAME			,
		    ---         
		    REFERRAL_ID			,
		    REFERRER_PERSON_ID	,
		    REQUISITION_ID		,
		    AGENT_ID			,
		    CANDIDATE_PERSON_ID	,
		    NOTES_CANDIDATE		,
		    REQUISITION_NUMBER	,
		    CANDIDATE_NUMBER	,
		    PERSON_NUMBER		,
		    REFERRER_PERSON_NUMBER,
		    AGENCY_NAME			,
		    AGENT_NAME			,
		    PERSON_ID			,
		    GUID				,
		    SOURCE_SYSTEM_ID	,
		    SOURCE_SYSTEM_OWNER	,
		    ---         
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
		    ATTRIBUTE_DATE5 )	
		SELECT
				NULL	              , 
				pt_i_MigrationSetID   ,
				pt_i_MigrationSetName ,
				'EXTRACTED'           ,
				p_bg_name             ,
				p_bg_id               ,
				'MERGE'               ,
				'Referral'	      ,
				NULL AS referral_id,
				NULL AS referrer_person_id,
				NULL AS requisition_id,
				NULL AS agent_id,
				NULL AS candidate_person_id,
				NULL AS notes_candidate,
				NULL AS requisitionnumber,
				(CASE
						WHEN pty.user_person_type = 'EXTERNAL' and 
                        ican.candidate_number is not null THEN
							ppf.applicant_number
                            else 'CAN_' || ican.person_id
					END
				)as candidate_number,	

				(
					CASE
						WHEN pty.user_person_type = 'APPLICANT' and 
                        ppf.applicant_number is not null THEN
							ppf.applicant_number
                            else 'CAN_' || ican.person_id
					END
				) AS person_number,
				ppf.applicant_number   AS referrerpersonnumber,
				pv.vendor_name         AS agency_name,
				NULL AS agent_name,
				NULL AS person_id,
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
                xxmx_stg.xxmx_hcm_irec_can_stg                   ican,
                irc_referral_info@mxdm_nvis_extract              ref,
                irc_notification_preferences@mxdm_nvis_extract   nop,
                per_person_types@mxdm_nvis_extract               pty,   
                hz_parties@mxdm_nvis_extract                     hp,
                po_vendors@mxdm_nvis_extract                     pv,
                PER_ALL_PEOPLE_F@mxdm_nvis_extract               PPF,
                per_requisitions@MXDM_NVIS_EXTRACT               req
        WHERE
                ref.object_id = ican.person_id
                AND nop.person_id = ican.person_id (+)
                AND hp.party_id = ref.object_id
                AND pty.PERSON_TYPE_ID=ppf.PERSON_TYPE_ID
                AND vendor_type_lookup_code (+) = 'IRC_JOB_AGENCY'
                AND pv.vendor_id (+) = nop.agency_id
                AND PPF.PERSON_ID=ref.source_person_id
                AND ref.source_type IN (
                    'REF',
                    'ER'
                )

                AND ref.source_person_id IS NOT NULL
                AND PPF.BUSINESS_GROUP_ID=P_BG_ID
                AND PTY.BUSINESS_GROUP_ID=P_BG_ID
                AND req.person_id=ppf.person_id
                AND trunc(sysdate) BETWEEN PPF.effective_start_date AND PPF.effective_end_date;



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
	END export_irec_job_referral ;		

END xxmx_irec_job_referral_stg ;
/
