create or replace PACKAGE body xxmx_hr_location_pkg 
AS
---------------------------------------------------------------------------------------------------------
/****************************************************************	
	----------------EXPORT_HR_LOCATION----------------------------
	****************************************************************/

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
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_hr_location_pkg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'LOCATION';
    gvv_leg_code                                VARCHAR2(100);

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                               EXCEPTION;
	--E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;

    TYPE wrk_lkp_map_rec IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                    ,ebs_lookup_code     VARCHAR2(200)
                                    ,fusion_lookup_code  VARCHAR2(200));

    TYPE wrk_lkp_map_tab IS TABLE OF wrk_lkp_map_rec INDEX BY pls_integer;

    g_wrk_lkp_map wrk_lkp_map_tab;

    l_bu_id VARCHAR2(4000);
---------

PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 

        CURSOR METADATA_CUR
        IS
            SELECT	Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ,sub_entity
			FROM	xxmx_migration_metadata a 
			WHERE	application_suite = gct_ApplicationSuite
            AND		Application = gct_Application
			AND 	BUSINESS_ENTITY = gv_i_BusinessEntity
			AND 	a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_HR_LOCATION_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LOCATION';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
		
	BEGIN 

-- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
             pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                    ||pt_i_MigrationSetName
                                    ||'" initialized (Generated Migration Set ID = '
                                    ||vt_MigrationSetID
                                    ||').  Processing extracts:'       
                        ,pt_i_OracleError         => NULL
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
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'
            ,pt_i_OracleError         => NULL
        );

      --


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(  
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts'
            ,pt_i_OracleError         => NULL
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
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => lv_sql 
                        ,pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP; 

		COMMIT;

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
		
		
				
PROCEDURE export_hr_location_stg
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS
    
    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_hr_location'; 
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_HR_LOCATION_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LOCATION';
	
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
        --
        --
        --set_parameters(p_bg_id);
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
        FROM    XXMX_HCM_HR_LOCATION_STG;
        --WHERE   bg_id    = p_bg_id    ; 
        
        COMMIT;   
		
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
						
			INSERT  
				INTO    XXMX_HCM_HR_LOCATION_STG(
				        MIGRATION_SET_ID                           ,                            
                        MIGRATION_SET_NAME                          ,
                        MIGRATION_STATUS                            ,
                        BG_ID            			                ,
                        METADATA					                ,
                        OBJECTNAME					                ,
                        LOCATION_ID									,
                        SET_ID										,
                        SET_CODE									,
                        EFFECTIVE_START_DATE						,
                        LOCATION_IMAGE_URL							,
                        ACTIVE_STATUS								,
                        EMPLOYEE_LOCATION_FLAG						,
                        MAIN_PHONE_AREA_CODE					    ,
                        MAIN_PHONE_COUNTRY_CODE						,
                        MAIN_PHONE_EXTENSION						,
                        MAIN_PHONE_SUBSCRIBER_NUMBER  				,
                        FAX_AREA_CODE								,
                        FAX_COUNTRY_CODE							,
                        FAX_EXTENSION								,
                        FAX_SUBSCRIBER_NUMBER						,
                        OTHER_PHONE_AREA_CODE                       ,
                        OTHER_PHONE_COUNTRY_CODE					,
                        OTHER_PHONE_EXTENSION						,
                        OTHER_PHONE_SUBSCRIBER_NUMBER				,
                        OFFICIAL_LANGUAGE_CODE						,
                        EMAIL_ADDRESS								,
                        SHIP_TO_SITE_FLAG							,
                        SHIP_TO_LOCATION_SET_CODE					,
                        SHIP_TO_LOCATION_CODE						,
                        SHIP_TO_LOCATION_ID							,
                        RECEIVING_SITE_FLAG                         ,
                        BILL_TO_SITE_FLAG							,
                        OFFICE_SITE_FLAG               				,
                        DESIGNATED_RECEIVER_ID                      ,
                        DESIGNATED_PERSON_NUMBER                    ,
                        INVENTORY_ORGANIZATION_ID                   ,
                        INVENTORY_ORGANIZATION_NAME                 ,
                        GEO_HIERARCHY_NODE_ID                       ,
                        GEO_HIERARCHY_NODE_CODE                     ,
                        STANDARD_WORKING_HOURS						,
                        STANDARD_WORKING_FREQUENCY                  ,
                        STANDARD_ANNUAL_WORKING_DURATION			,
                        ANNUAL_WORKING_DURATION_UNITS               ,
                        LOCATION_CODE								,
                        LOCATION_NAME								,
                        DESCRIPTION									,
                        ADDRESS_LINE1								,
                        ADDRESS_LINE2                               ,
                        ADDRESS_LINE3                               ,
                        ADDRESS_LINE4                               ,
                        BUILDING									,
                        COUNTRY										,
                        FLOOR_NUMBER                                ,
                        LONG_POSTAL_CODE                            ,
                        POSTAL_CODE              					,
                        REGION1                                     ,
                        REGION2                                     ,
                        REGION3                                     ,
                        TIME_ZONE_NAME                              ,
                        TOWN_OR_CITY                                ,
                        ADDL_ADDRESS_ATTRIBUTE1                     ,
                        ADDL_ADDRESS_ATTRIBUTE2                     ,
                        ADDL_ADDRESS_ATTRIBUTE3                     ,
                        ADDL_ADDRESS_ATTRIBUTE4                     ,
                        ADDL_ADDRESS_ATTRIBUTE5                     ,
                        EFFECTIVE_END_DATE                          ,
                        ACTION_REASON_CODE							,
                        SOURCE_SYSTEM_OWNER                         ,
                        SOURCE_SYSTEM_ID                            ,
                        GUID										
					)
					
                SELECT  distinct      									                      
                pt_i_MigrationSetID                         				--MIGRATION_SET_ID                       
                ,pt_i_MigrationSetName                      				--MIGRATION_SET_NAME                     
                ,'EXTRACTED'                        				   --MIGRATION_STATUS                       
			    ,'' BG_ID            			            				--BG_ID            			            
                ,'' METADATA					                            --METADATA					            
                ,'' OBJECTNAME					            				--OBJECTNAME					            
                ,LOCATION_ID											--LOCATION_ID							
                ,'' SET_ID													--SET_ID									
                ,'' SET_CODE								                --SET_CODE								
                ,SYSDATE EFFECTIVE_START_DATE								    --EFFECTIVE_START_DATE					
                ,'' LOCATION_IMAGE_URL										--LOCATION_IMAGE_URL						
                ,'' ACTIVE_STATUS											--ACTIVE_STATUS							
                ,'' EMPLOYEE_LOCATION_FLAG					                --EMPLOYEE_LOCATION_FLAG					
                ,'' MAIN_PHONE_AREA_CODE					                --MAIN_PHONE_AREA_CODE					
                ,'' MAIN_PHONE_COUNTRY_CODE					            --MAIN_PHONE_COUNTRY_CODE				
                ,'' MAIN_PHONE_EXTENSION					                --MAIN_PHONE_EXTENSION					
                ,'' MAIN_PHONE_SUBSCRIBER_NUMBER  			                --MAIN_PHONE_SUBSCRIBER_NUMBER  			
                ,'' FAX_AREA_CODE											--FAX_AREA_CODE							
                ,'' FAX_COUNTRY_CODE						                --FAX_COUNTRY_CODE						
                ,'' FAX_EXTENSION							                --FAX_EXTENSION							
                ,'' FAX_SUBSCRIBER_NUMBER					                --FAX_SUBSCRIBER_NUMBER					
                ,'' OTHER_PHONE_AREA_CODE                                  --OTHER_PHONE_AREA_CODE                  
                ,'' OTHER_PHONE_COUNTRY_CODE				                --OTHER_PHONE_COUNTRY_CODE				
                ,'' OTHER_PHONE_EXTENSION					                --OTHER_PHONE_EXTENSION					
                ,'' OTHER_PHONE_SUBSCRIBER_NUMBER			                --OTHER_PHONE_SUBSCRIBER_NUMBER			
                ,'' OFFICIAL_LANGUAGE_CODE					                --OFFICIAL_LANGUAGE_CODE					
                ,'' EMAIL_ADDRESS							                --EMAIL_ADDRESS							
                ,SHIP_TO_SITE_FLAG						                --SHIP_TO_SITE_FLAG						
                ,'' SHIP_TO_LOCATION_SET_CODE				                --SHIP_TO_LOCATION_SET_CODE				
                ,'' SHIP_TO_LOCATION_CODE					                --SHIP_TO_LOCATION_CODE					
                ,SHIP_TO_LOCATION_ID						            --SHIP_TO_LOCATION_ID					
                ,RECEIVING_SITE_FLAG                                    --RECEIVING_SITE_FLAG                    
                ,BILL_TO_SITE_FLAG						                --BILL_TO_SITE_FLAG						
                ,OFFICE_SITE_FLAG               			            --OFFICE_SITE_FLAG               		
                ,DESIGNATED_RECEIVER_ID                                 --DESIGNATED_RECEIVER_ID                 
                ,'' DESIGNATED_PERSON_NUMBER                               --DESIGNATED_PERSON_NUMBER               
                ,INVENTORY_ORGANIZATION_ID                              --INVENTORY_ORGANIZATION_ID              
                ,'' INVENTORY_ORGANIZATION_NAME                            --INVENTORY_ORGANIZATION_NAME            
                ,'' GEO_HIERARCHY_NODE_ID                                  --GEO_HIERARCHY_NODE_ID                  
                ,'' GEO_HIERARCHY_NODE_CODE                                --GEO_HIERARCHY_NODE_CODE                
                ,'' STANDARD_WORKING_HOURS					                --STANDARD_WORKING_HOURS					
                ,'' STANDARD_WORKING_FREQUENCY                             --STANDARD_WORKING_FREQUENCY             
                ,'' STANDARD_ANNUAL_WORKING_DURATION					    --STANDARD_ANNUAL_WORKING_DURATION		
                ,'' ANNUAL_WORKING_DURATION_UNITS                          --ANNUAL_WORKING_DURATION_UNITS          
                ,LOCATION_CODE							                --LOCATION_CODE							
                ,'' LOCATION_NAME							                --LOCATION_NAME							
                ,DESCRIPTION								            --DESCRIPTION							
                ,ADDRESS_LINE_1							                --ADDRESS_LINE1							
                ,ADDRESS_LINE_2                                          --ADDRESS_LINE2                          
                ,ADDRESS_LINE_3                                          --ADDRESS_LINE3                          
                ,'' ADDRESS_LINE4                                          --ADDRESS_LINE4                          
                ,'' BUILDING								                --BUILDING								
                ,COUNTRY									            --COUNTRY								
                ,'' FLOOR_NUMBER                                           --FLOOR_NUMBER                           
                ,'' LONG_POSTAL_CODE                                       --LONG_POSTAL_CODE                       
                ,POSTAL_CODE              				                --POSTAL_CODE              				
                ,REGION_1                                                --REGION1                                
                ,REGION_2                                                --REGION2                                
                ,REGION_3                                                --REGION3                                
                ,''TIME_ZONE_NAME                                         --TIME_ZONE_NAME                         
                ,TOWN_OR_CITY                                           --TOWN_OR_CITY                           
                ,'' ADDL_ADDRESS_ATTRIBUTE1                                --ADDL_ADDRESS_ATTRIBUTE1                
                ,'' ADDL_ADDRESS_ATTRIBUTE2                                --ADDL_ADDRESS_ATTRIBUTE2                
                ,'' ADDL_ADDRESS_ATTRIBUTE3                                --ADDL_ADDRESS_ATTRIBUTE3                
                ,'' ADDL_ADDRESS_ATTRIBUTE4                                --ADDL_ADDRESS_ATTRIBUTE4                
                ,'' ADDL_ADDRESS_ATTRIBUTE5                                --ADDL_ADDRESS_ATTRIBUTE5                
                ,'' EFFECTIVE_END_DATE                                     --EFFECTIVE_END_DATE                     
                ,'' ACTION_REASON_CODE						                --ACTION_REASON_CODE						
                ,'' SOURCE_SYSTEM_OWNER                                    --SOURCE_SYSTEM_OWNER                    
                ,'' SOURCE_SYSTEM_ID                                       --SOURCE_SYSTEM_ID                       
                ,'' GUID									                --GUID									
               FROM 
			     HR_LOCATIONS_ALL@mxdm_nvis_extract
			            WHERE  1 = 1 ;
						
		
	COMMIT;

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
            
         --** END e_ModuleError Exception;
             
  EXCEPTION
     WHEN OTHERS 
     THEN
     --
            --ROLLBACK;
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
            RAISE ; 
         --Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_hr_location_stg;		
END xxmx_hr_location_pkg;

/



