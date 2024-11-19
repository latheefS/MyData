create or replace PACKAGE    XXMX_CORE.XXMX_PPM_PRJ_VALIDATIONS_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PPM_PRJ_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary Kotapati/Veda Poojitha
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_PPM_PRJ_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PPM_PRJ_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                                Change Description
     ** -----  -----------  ------------------                        -----------------------------------
     **   1.0  15-MAR-2024  Sushma Chowdary Kotapati/Veda Poojitha     Initial implementation
     ******************************************************************************
     */
    --
	
	/*
    ******************************
    ** PROCEDURE: VALIDATE_XXMX_PPM_PROJECTS
    ******************************
    */
					
	PROCEDURE VALIDATE_XXMX_PPM_PROJECTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
	/*
	******************************
    ** PROCEDURE: VALIDATE_SRC_PA_PROJECTS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_PROJECTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*

    /*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TASKS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TASKS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TRX_CONTROL
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TRX_CONTROL
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
					
					
	/*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TEAM_MEMBERS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TEAM_MEMBERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
					
	/*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_CLASS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_CLASS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
	
	FUNCTION get_migration_set_id
	                (
					pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
					)
					RETURN NUMBER;

    FUNCTION get_subentity_name
	                (
					pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                   ,pt_i_table                      IN      xxmx_migration_metadata.stg_table%TYPE
					)
					RETURN VARCHAR2;
    --
END XXMX_PPM_PRJ_VALIDATIONS_PKG;
/



/* package body */

create or replace PACKAGE BODY XXMX_CORE.XXMX_PPM_PRJ_VALIDATIONS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PPM_PRJ_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary Kotapati/Veda Poojitha
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_PPM_PRJ_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PPM_PRJ_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                              Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  15-MAR-2024  Sushma Chowdary Kotapati/Veda Poojitha   Initial implementation 

     ******************************************************************************
     */
    --

     /*
     ** Maximise Integration
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gvv_ApplicationErrorMessage                        VARCHAR2(2048);
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     gvv_ProgressIndicator                              VARCHAR2(100);
     ct_ProcOrFuncName                                  xxmx_module_messages.proc_or_func_name%TYPE;
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_PPM_PRJ_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'PPM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'PRJ';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'PRJ_FOUNDATION';
     ct_Phase                                  CONSTANT xxmx_module_messages.phase%TYPE              := 'VALIDATE';
     ct_SubEntity                              CONSTANT xxmx_module_messages.sub_entity%TYPE         := 'ALL';
	 gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
    --
    --
	     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --


	 --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --

	  /*
     ** Global variables for holding table row counts
     */
     --
     gvn_RowCount                                       NUMBER;
     --
     --			

FUNCTION get_migration_set_id 
                    (
                    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
   RETURN NUMBER IS 
   l_migration_set_id NUMBER:= 0;
   l_stg_table VARCHAR2(50);
   l_SQL VARCHAR2(500);

   BEGIN 

            SELECT stg_table
            INTO l_stg_table
            FROM xxmx_migration_metadata
            WHERE business_entity = pt_i_BusinessEntity
            AND sub_entity_seq IN( 
                                SELECT MIN(sub_entity_seq)
                                FROM xxmx_migration_metadata
                                WHERE business_entity = pt_i_BusinessEntity
                                AND enabled_flag = 'Y');

            l_sql := 'select MAX(migration_Set_id) from XXMX_STG.'||l_stg_table;

            EXECUTE IMMEDIATE l_sql INTO l_migration_Set_id; 

             IF(l_migration_Set_id IS NULL)
                THEN
                    BEGIN
                    Select distinct max(MIGRATION_SET_ID)
                    INTO l_migration_Set_id
                    from xxmx_migration_headers
                    where business_entity = pt_i_BusinessEntity;
            EXCEPTION
                WHEN OTHERS THEN
                    l_migration_Set_id := NULL;
                END;
               END IF;
				RETURN l_migration_Set_id;

   END;



FUNCTION get_subentity_name 
                    (
                    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
				   ,pt_i_table                      IN      xxmx_migration_metadata.stg_table%TYPE
                    )
   RETURN VARCHAR2 IS 
   l_subentity_name VARCHAR2(120);
   l_SQL VARCHAR2(500);

   BEGIN 

            SELECT sub_entity
            INTO l_subentity_name
            FROM xxmx_migration_metadata
            WHERE business_entity = pt_i_BusinessEntity
            AND stg_table = pt_i_table;

				RETURN l_subentity_name;

            EXCEPTION
			    WHEN NO_DATA_FOUND THEN 
				    l_subentity_name := 'ALL';
                WHEN OTHERS THEN
                    l_subentity_name := 'ALL';

   END;

  /*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_PROJECTS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_PROJECTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR pa_project_validation(pt_i_MigrationSetID number)
        IS
		/*
     ** Validate if Project is valid or not
     */	
        SELECT 'Project is not Open' as validation_error_message,PPS.*
      from XXMX_PPM_PROJECTS_STG PPS
		WHERE 1=1
		AND  migration_set_id = pt_i_MigrationSetID
		and (trunc(sysdate) not between trunc(project_start_date) and trunc(project_finish_date)
        or project_start_date is null 
        or project_finish_date is null);


        TYPE pa_project_type IS TABLE OF pa_project_validation%ROWTYPE INDEX BY BINARY_INTEGER;
		src_pa_project_tbl pa_project_type;



	      --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SRC_PA_PROJECTS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PROJECTS_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PROJECTS_STG';
		l_migration_set_id NUMBER;
		l_subentity VARCHAR2(360);


          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations

    BEGIN

        l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';

		 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity 
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
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
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set ID
          --
          gvv_ProgressIndicator := '0040';
          -- 
            l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);

          IF   l_migration_set_id IS NOT NULL
          THEN

		       xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );

                                   --
              --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
         		 --
        BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN pa_project_validation(l_migration_set_id);

		LOOP
--		 
		 FETCH pa_project_validation
		 BULK COLLECT INTO src_pa_project_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN src_pa_project_tbl.COUNT=0  ;


		gvv_ProgressIndicator := '0060';

FORALL i in 1..src_pa_project_tbl.COUNT 

        INSERT INTO XXMX_PPM_PROJECTS_VAL
        (
          VALIDATION_ERROR_MESSAGE      
         ,FILE_SET_ID                   
         ,MIGRATION_SET_ID              
         ,MIGRATION_SET_NAME            
         ,MIGRATION_STATUS              
         ,LOAD_BATCH                    
         ,PROJECT_NAME                  
         ,PROJECT_NUMBER                
         ,SOURCE_TEMPLATE_NUMBER        
         ,SOURCE_TEMPLATE_NAME          
         ,SOURCE_APPLICATION_CODE       
         ,SOURCE_PROJECT_REFERENCE      
         ,SCHEDULE_NAME                 
         ,EPS_NAME                      
         ,PROJECT_PLAN_VIEW_ACCESS      
         ,SCHEDULE_TYPE                 
         ,ORGANIZATION_NAME             
         ,LEGAL_ENTITY_NAME             
         ,DESCRIPTION                   
         ,PROJECT_MANAGER_NUMBER        
         ,PROJECT_MANAGER_NAME          
         ,PROJECT_MANAGER_EMAIL         
         ,PROJECT_START_DATE            
         ,PROJECT_FINISH_DATE           
         ,CLOSED_DATE                   
         ,PRJ_PLAN_BASELINE_NAME        
         ,PRJ_PLAN_BASELINE_DESC        
         ,PRJ_PLAN_BASELINE_DATE        
         ,PROJECT_STATUS_NAME           
         ,PROJECT_PRIORITY_CODE         
         ,OUTLINE_DISPLAY_LEVEL         
         ,PLANNING_PROJECT_FLAG         
         ,SERVICE_TYPE_CODE             
         ,WORK_TYPE_NAME                
         ,LIMIT_TO_TXN_CONTROLS_CODE    
         ,BUDGETARY_CONTROL_FLAG        
         ,PROJECT_CURRENCY_CODE         
         ,CURRENCY_CONV_RATE_TYPE       
         ,CURRENCY_CONV_DATE_TYPE_CODE  
         ,CURRENCY_CONV_DATE            
         ,CINT_ELIGIBLE_FLAG            
         ,CINT_RATE_SCH_NAME            
         ,CINT_STOP_DATE                
         ,ASSET_ALLOCATION_METHOD_CODE  
         ,CAPITAL_EVENT_PROCESSING_CODE 
         ,ALLOW_CROSS_CHARGE_FLAG       
         ,CC_PROCESS_LABOR_FLAG         
         ,LABOR_TP_SCHEDULE_NAME        
         ,LABOR_TP_FIXED_DATE           
         ,CC_PROCESS_NL_FLAG            
         ,NL_TP_SCHEDULE_NAME           
         ,NL_TP_FIXED_DATE              
         ,BURDEN_SCHEDULE_NAME          
         ,BURDEN_SCH_FIXED_DATED        
         ,KPI_NOTIFICATION_ENABLED      
         ,KPI_NOTIFICATION_RECIPIENTS   
         ,KPI_NOTIFICATION_INCLUDE_NOTES
         ,COPY_TEAM_MEMBERS_FLAG        
         ,COPY_CLASSIFICATIONS_FLAG     
         ,COPY_ATTACHMENTS_FLAG         
         ,COPY_DFF_FLAG                 
         ,COPY_TASKS_FLAG               
         ,COPY_TASK_ATTACHMENTS_FLAG    
         ,COPY_TASK_DFF_FLAG            
         ,COPY_TASK_ASSIGNMENTS_FLAG    
         ,COPY_TRANSACTION_CONTROLS_FLAG
         ,COPY_ASSETS_FLAG              
         ,COPY_ASSET_ASSIGNMENTS_FLAG   
         ,COPY_COST_OVERRIDES_FLAG      
         ,OPPORTUNITY_ID                
         ,OPPORTUNITY_NUMBER            
         ,OPPORTUNITY_CUSTOMER_NUMBER   
         ,OPPORTUNITY_CUSTOMER_ID       
         ,OPPORTUNITY_AMT               
         ,OPPORTUNITY_CURRCODE          
         ,OPPORTUNITY_WIN_CONF_PERCENT  
         ,OPPORTUNITY_NAME              
         ,OPPORTUNITY_DESC              
         ,OPPORTUNITY_CUSTOMER_NAME     
         ,OPPORTUNITY_STATUS            
         ,XFACE_REC_ID                  
         ,ORG_ID                        
         ,COPY_GROUP_SPACE_FLAG         
         ,PROJECT_ID                    
         ,PROJ_OWNING_ORG               
         ,BATCH_ID                      
         ,BATCH_NAME                    
         ,CREATED_BY                    
         ,CREATION_DATE                 
         ,LAST_UPDATE_LOGIN             
         ,LAST_UPDATED_BY               
         ,LAST_UPDATE_DATE              
         ,LOAD_STATUS                   
         ,IMPORT_STATUS                 
         ,LOAD_REQUEST_ID               
         ,REQUEST_ID                    
         ,OBJECT_VERSION_NUMBER            
        )
        VALUES 
        (
        src_pa_project_tbl(i).VALIDATION_ERROR_MESSAGE
		,src_pa_project_tbl(i).FILE_SET_ID          
		,src_pa_project_tbl(i).MIGRATION_SET_ID     
		,src_pa_project_tbl(i).MIGRATION_SET_NAME   
		,'VALIDATED'     
		,src_pa_project_tbl(i).LOAD_BATCH           
		,src_pa_project_tbl(i).PROJECT_NAME         
		,src_pa_project_tbl(i).PROJECT_NUMBER       
		,src_pa_project_tbl(i).SOURCE_TEMPLATE_NUMBER
		,src_pa_project_tbl(i).SOURCE_TEMPLATE_NAME 
		,src_pa_project_tbl(i).SOURCE_APPLICATION_CODE
		,src_pa_project_tbl(i).SOURCE_PROJECT_REFERENCE
		,src_pa_project_tbl(i).SCHEDULE_NAME        
		,src_pa_project_tbl(i).EPS_NAME             
		,src_pa_project_tbl(i).PROJECT_PLAN_VIEW_ACCESS
		,src_pa_project_tbl(i).SCHEDULE_TYPE        
		,src_pa_project_tbl(i).ORGANIZATION_NAME    
		,src_pa_project_tbl(i).LEGAL_ENTITY_NAME    
		,src_pa_project_tbl(i).DESCRIPTION          
		,src_pa_project_tbl(i).PROJECT_MANAGER_NUMBER
		,src_pa_project_tbl(i).PROJECT_MANAGER_NAME 
		,src_pa_project_tbl(i).PROJECT_MANAGER_EMAIL
		,src_pa_project_tbl(i).PROJECT_START_DATE   
		,src_pa_project_tbl(i).PROJECT_FINISH_DATE  
		,src_pa_project_tbl(i).CLOSED_DATE          
		,src_pa_project_tbl(i).PRJ_PLAN_BASELINE_NAME
		,src_pa_project_tbl(i).PRJ_PLAN_BASELINE_DESC
		,src_pa_project_tbl(i).PRJ_PLAN_BASELINE_DATE
		,src_pa_project_tbl(i).PROJECT_STATUS_NAME  
		,src_pa_project_tbl(i).PROJECT_PRIORITY_CODE
		,src_pa_project_tbl(i).OUTLINE_DISPLAY_LEVEL
		,src_pa_project_tbl(i).PLANNING_PROJECT_FLAG
		,src_pa_project_tbl(i).SERVICE_TYPE_CODE    
		,src_pa_project_tbl(i).WORK_TYPE_NAME       
		,src_pa_project_tbl(i).LIMIT_TO_TXN_CONTROLS_CODE
		,src_pa_project_tbl(i).BUDGETARY_CONTROL_FLAG
		,src_pa_project_tbl(i).PROJECT_CURRENCY_CODE
		,src_pa_project_tbl(i).CURRENCY_CONV_RATE_TYPE
		,src_pa_project_tbl(i).CURRENCY_CONV_DATE_TYPE_CODE
		,src_pa_project_tbl(i).CURRENCY_CONV_DATE   
		,src_pa_project_tbl(i).CINT_ELIGIBLE_FLAG   
		,src_pa_project_tbl(i).CINT_RATE_SCH_NAME   
		,src_pa_project_tbl(i).CINT_STOP_DATE       
		,src_pa_project_tbl(i).ASSET_ALLOCATION_METHOD_CODE
		,src_pa_project_tbl(i).CAPITAL_EVENT_PROCESSING_CODE
		,src_pa_project_tbl(i).ALLOW_CROSS_CHARGE_FLAG
		,src_pa_project_tbl(i).CC_PROCESS_LABOR_FLAG
		,src_pa_project_tbl(i).LABOR_TP_SCHEDULE_NAME
		,src_pa_project_tbl(i).LABOR_TP_FIXED_DATE  
		,src_pa_project_tbl(i).CC_PROCESS_NL_FLAG   
		,src_pa_project_tbl(i).NL_TP_SCHEDULE_NAME  
		,src_pa_project_tbl(i).NL_TP_FIXED_DATE     
		,src_pa_project_tbl(i).BURDEN_SCHEDULE_NAME 
		,src_pa_project_tbl(i).BURDEN_SCH_FIXED_DATED
		,src_pa_project_tbl(i).KPI_NOTIFICATION_ENABLED
		,src_pa_project_tbl(i).KPI_NOTIFICATION_RECIPIENTS
		,src_pa_project_tbl(i).KPI_NOTIFICATION_INCLUDE_NOTES
		,src_pa_project_tbl(i).COPY_TEAM_MEMBERS_FLAG
		,src_pa_project_tbl(i).COPY_CLASSIFICATIONS_FLAG
		,src_pa_project_tbl(i).COPY_ATTACHMENTS_FLAG
		,src_pa_project_tbl(i).COPY_DFF_FLAG        
		,src_pa_project_tbl(i).COPY_TASKS_FLAG      
		,src_pa_project_tbl(i).COPY_TASK_ATTACHMENTS_FLAG
		,src_pa_project_tbl(i).COPY_TASK_DFF_FLAG   
		,src_pa_project_tbl(i).COPY_TASK_ASSIGNMENTS_FLAG
		,src_pa_project_tbl(i).COPY_TRANSACTION_CONTROLS_FLAG
		,src_pa_project_tbl(i).COPY_ASSETS_FLAG     
		,src_pa_project_tbl(i).COPY_ASSET_ASSIGNMENTS_FLAG
		,src_pa_project_tbl(i).COPY_COST_OVERRIDES_FLAG
		,src_pa_project_tbl(i).OPPORTUNITY_ID       
		,src_pa_project_tbl(i).OPPORTUNITY_NUMBER   
		,src_pa_project_tbl(i).OPPORTUNITY_CUSTOMER_NUMBER
		,src_pa_project_tbl(i).OPPORTUNITY_CUSTOMER_ID
		,src_pa_project_tbl(i).OPPORTUNITY_AMT      
		,src_pa_project_tbl(i).OPPORTUNITY_CURRCODE 
		,src_pa_project_tbl(i).OPPORTUNITY_WIN_CONF_PERCENT
		,src_pa_project_tbl(i).OPPORTUNITY_NAME     
		,src_pa_project_tbl(i).OPPORTUNITY_DESC     
		,src_pa_project_tbl(i).OPPORTUNITY_CUSTOMER_NAME
		,src_pa_project_tbl(i).OPPORTUNITY_STATUS   
		,src_pa_project_tbl(i).XFACE_REC_ID         
		,src_pa_project_tbl(i).ORG_ID               
		,src_pa_project_tbl(i).COPY_GROUP_SPACE_FLAG
		,src_pa_project_tbl(i).PROJECT_ID           
		,src_pa_project_tbl(i).PROJ_OWNING_ORG      
		,src_pa_project_tbl(i).BATCH_ID             
		,src_pa_project_tbl(i).BATCH_NAME           
		,src_pa_project_tbl(i).CREATED_BY           
		,src_pa_project_tbl(i).CREATION_DATE        
		,src_pa_project_tbl(i).LAST_UPDATE_LOGIN    
		,src_pa_project_tbl(i).LAST_UPDATED_BY      
		,src_pa_project_tbl(i).LAST_UPDATE_DATE     
		,src_pa_project_tbl(i).LOAD_STATUS          
		,src_pa_project_tbl(i).IMPORT_STATUS        
		,src_pa_project_tbl(i).LOAD_REQUEST_ID      
		,src_pa_project_tbl(i).REQUEST_ID           
		,src_pa_project_tbl(i).OBJECT_VERSION_NUMBER
        );	

END LOOP;
               --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --

		COMMIT;

               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE pa_project_validation;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set ID is not found.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
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
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   pa_project_validation%ISOPEN
                    THEN
                         --
                         CLOSE pa_project_validation;
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
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
    END VALIDATE_SRC_PA_PROJECTS;
	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TASKS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TASKS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS



        CURSOR pa_task_validation(pt_i_MigrationSetID NUMBER)
        IS
	/*
     ** Validate if Project name is valid or not
     */	
        select 'project name is not valid' as validation_error_message,PPTS.* 
from XXMX_PPM_PRJ_TASKS_stg PPTS
WHERE 1=1
AND  migration_set_id = pt_i_MigrationSetID
and project_name in(select project_name from XXMX_PPM_PROJECTS_STG 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID
AND (trunc(sysdate) not between trunc(project_start_date) and trunc(project_finish_date)
        or project_start_date is null 
        or project_finish_date is null));
        

    TYPE pa_task_type IS TABLE OF pa_task_validation%ROWTYPE INDEX BY BINARY_INTEGER;
		pa_task_tbl pa_task_type;

	      --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SRC_PA_TASKS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TASKS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TASKS_STG';
		l_migration_set_id NUMBER;
        l_subentity VARCHAR2(360);

         --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations

    BEGIN

	l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';
				 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
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
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set ID
          --
          gvv_ProgressIndicator := '0040';
		  --
            l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);

          IF   l_migration_set_id IS NOT NULL
          THEN

		       xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );

               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN pa_task_validation(l_migration_set_id);

		LOOP
--		 
		 FETCH pa_task_validation 
		 BULK COLLECT INTO pa_task_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN pa_task_tbl.COUNT=0  ;

				gvv_ProgressIndicator := '0060';

FORALL i in 1..pa_task_tbl.COUNT 

        INSERT INTO XXMX_PPM_PRJ_TASKS_VAL
        (
         VALIDATION_ERROR_MESSAGE       
         ,FILE_SET_ID                    
         ,MIGRATION_SET_ID               
         ,MIGRATION_SET_NAME             
         ,MIGRATION_STATUS               
         ,LOAD_BATCH                     
         ,PROJECT_NAME                   
         ,PROJECT_NUMBER                 
         ,TASK_NAME                      
         ,TASK_NUMBER                    
         ,SOURCE_TASK_REFERENCE          
         ,FINANCIAL_TASK                 
         ,TASK_DESCRIPTION               
         ,PARENT_TASK_NUMBER             
         ,PLANNING_START_DATE            
         ,PLANNING_END_DATE              
         ,PLANNED_EFFORT                 
         ,PLANNED_DURATION               
         ,MILESTONE_FLAG                 
         ,CRITICAL_FLAG                  
         ,CHARGEABLE_FLAG                
         ,BILLABLE_FLAG                  
         ,CAPITALIZABLE_FLAG             
         ,LIMIT_TO_TXN_CONTROLS_FLAG     
         ,SERVICE_TYPE_CODE              
         ,WORK_TYPE_ID                   
         ,MANAGER_PERSON_ID              
         ,ALLOW_CROSS_CHARGE_FLAG        
         ,CC_PROCESS_LABOR_FLAG          
         ,CC_PROCESS_NL_FLAG             
         ,RECEIVE_PROJECT_INVOICE_FLAG   
         ,ORGANIZATION_NAME              
         ,REQMNT_CODE                    
         ,SPRINT                         
         ,PRIORITY                       
         ,SCHEDULE_MODE                  
         ,BASELINE_START_DATE            
         ,BASELINE_FINISH_DATE           
         ,BASELINE_EFFORT                
         ,BASELINE_DURATION              
         ,BASELINE_ALLOCATION            
         ,BASELINE_LABOR_COST_AMOUNT     
         ,BASELINE_LABOR_BILLED_AMOUNT   
         ,BASELINE_EXPENSE_COST_AMOUNT   
         ,CONSTRAINT_TYPE_CODE           
         ,CONSTRAINT_DATE                
         ,SOURCE_APPLICATION_CODE        
         ,OPERATING_UNIT                 
         ,LEDGER_NAME                    
         ,BATCH_ID                       
         ,BATCH_NAME                     
         ,CREATED_BY                     
         ,CREATION_DATE                  
         ,LAST_UPDATE_LOGIN              
         ,LAST_UPDATED_BY                
         ,LAST_UPDATE_DATE               
         ,LOAD_STATUS                    
         ,IMPORT_STATUS                  
	
        )
        VALUES 
        (
		pa_task_tbl(i).VALIDATION_ERROR_MESSAGE       
		,pa_task_tbl(i).FILE_SET_ID                    
		,pa_task_tbl(i).MIGRATION_SET_ID               
		,pa_task_tbl(i).MIGRATION_SET_NAME             
		,'VALIDATED'               
		,pa_task_tbl(i).LOAD_BATCH                     
		,pa_task_tbl(i).PROJECT_NAME                   
		,pa_task_tbl(i).PROJECT_NUMBER                 
		,pa_task_tbl(i).TASK_NAME                      
		,pa_task_tbl(i).TASK_NUMBER                    
		,pa_task_tbl(i).SOURCE_TASK_REFERENCE          
		,pa_task_tbl(i).FINANCIAL_TASK                 
		,pa_task_tbl(i).TASK_DESCRIPTION               
		,pa_task_tbl(i).PARENT_TASK_NUMBER             
		,pa_task_tbl(i).PLANNING_START_DATE            
		,pa_task_tbl(i).PLANNING_END_DATE              
		,pa_task_tbl(i).PLANNED_EFFORT                 
		,pa_task_tbl(i).PLANNED_DURATION               
		,pa_task_tbl(i).MILESTONE_FLAG                 
		,pa_task_tbl(i).CRITICAL_FLAG                  
		,pa_task_tbl(i).CHARGEABLE_FLAG                
		,pa_task_tbl(i).BILLABLE_FLAG                  
		,pa_task_tbl(i).CAPITALIZABLE_FLAG             
		,pa_task_tbl(i).LIMIT_TO_TXN_CONTROLS_FLAG     
		,pa_task_tbl(i).SERVICE_TYPE_CODE              
		,pa_task_tbl(i).WORK_TYPE_ID                   
		,pa_task_tbl(i).MANAGER_PERSON_ID              
		,pa_task_tbl(i).ALLOW_CROSS_CHARGE_FLAG        
		,pa_task_tbl(i).CC_PROCESS_LABOR_FLAG          
		,pa_task_tbl(i).CC_PROCESS_NL_FLAG             
		,pa_task_tbl(i).RECEIVE_PROJECT_INVOICE_FLAG   
		,pa_task_tbl(i).ORGANIZATION_NAME              
		,pa_task_tbl(i).REQMNT_CODE                    
		,pa_task_tbl(i).SPRINT                         
		,pa_task_tbl(i).PRIORITY                       
		,pa_task_tbl(i).SCHEDULE_MODE                  
		,pa_task_tbl(i).BASELINE_START_DATE            
		,pa_task_tbl(i).BASELINE_FINISH_DATE           
		,pa_task_tbl(i).BASELINE_EFFORT                
		,pa_task_tbl(i).BASELINE_DURATION              
		,pa_task_tbl(i).BASELINE_ALLOCATION            
		,pa_task_tbl(i).BASELINE_LABOR_COST_AMOUNT     
		,pa_task_tbl(i).BASELINE_LABOR_BILLED_AMOUNT   
		,pa_task_tbl(i).BASELINE_EXPENSE_COST_AMOUNT   
		,pa_task_tbl(i).CONSTRAINT_TYPE_CODE           
		,pa_task_tbl(i).CONSTRAINT_DATE                
		,pa_task_tbl(i).SOURCE_APPLICATION_CODE        
		,pa_task_tbl(i).OPERATING_UNIT                 
		,pa_task_tbl(i).LEDGER_NAME                    
		,pa_task_tbl(i).BATCH_ID                       
		,pa_task_tbl(i).BATCH_NAME                     
		,pa_task_tbl(i).CREATED_BY                     
		,pa_task_tbl(i).CREATION_DATE                  
		,pa_task_tbl(i).LAST_UPDATE_LOGIN              
		,pa_task_tbl(i).LAST_UPDATED_BY                
		,pa_task_tbl(i).LAST_UPDATE_DATE               
		,pa_task_tbl(i).LOAD_STATUS                    
		,pa_task_tbl(i).IMPORT_STATUS                  
		);	

END LOOP;

 --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --

		COMMIT;

         CLOSE pa_task_validation; 
  --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set ID is not found.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
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
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   pa_task_validation%ISOPEN
                    THEN
                         --
                         CLOSE pa_task_validation;
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
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
      --
    END VALIDATE_SRC_PA_TASKS;
	
	
	/*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TRX_CONTROL
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TRX_CONTROL
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR pa_trx_validation(pt_i_MigrationSetID NUMBER)
        IS
     /*
     ** Validate if Project is valid or not
     */
	  select 'project name is not valid' as validation_error_message,PPTC.* 
from XXMX_PPM_PRJ_TRX_CONTROL_STG PPTC
WHERE 1=1
AND  migration_set_id = pt_i_MigrationSetID
and project_name in(select project_name from XXMX_PPM_PROJECTS_STG 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID
AND (trunc(sysdate) not between trunc(project_start_date) and trunc(project_finish_date)
        or project_start_date is null 
        or project_finish_date is null));



       TYPE pa_trx_validation_type IS TABLE OF pa_trx_validation%ROWTYPE INDEX BY BINARY_INTEGER;
	   pa_trx_tbl pa_trx_validation_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SRC_PA_TRX_CONTROL';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TRX_CONTROL_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TRX_CONTROL_STG';
		l_migration_set_id NUMBER;		
        l_subentity VARCHAR2(360);

         --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations

    BEGIN

l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';

		 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
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
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';

          l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(l_migration_set_id);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                   
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN pa_trx_validation(l_migration_set_id);

		LOOP
--		 
		 FETCH pa_trx_validation 
		 BULK COLLECT INTO pa_trx_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN pa_trx_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..pa_trx_tbl.COUNT 

        INSERT INTO XXMX_PPM_PRJ_TRX_CONTROL_VAL
        (
		  VALIDATION_ERROR_MESSAGE    
		 ,FILE_SET_ID                 
		 ,MIGRATION_SET_ID            
		 ,MIGRATION_SET_NAME          
		 ,MIGRATION_STATUS            
		 ,LOAD_BATCH                  
		 ,TXN_CTRL_REFERENCE          
		 ,PROJECT_NAME                
		 ,PROJECT_NUMBER              
		 ,TASK_NUMBER                 
		 ,TASK_NAME                   
		 ,EXPENDITURE_CATEGORY_NAME   
		 ,EXPENDITURE_TYPE            
		 ,NON_LABOR_RESOURCE          
		 ,PERSON_NUMBER               
		 ,PERSON_NAME                 
		 ,PERSON_EMAIL                
		 ,PERSON_TYPE                 
		 ,JOB_NAME                    
		 ,ORGANIZATION_NAME           
		 ,CHARGEABLE_FLAG             
		 ,BILLABLE_FLAG               
		 ,CAPITALIZABLE_FLAG          
		 ,START_DATE_ACTIVE           
		 ,END_DATE_ACTIVE             
		 ,BATCH_ID                    
		 ,BATCH_NAME                  
		 ,CREATED_BY                  
		 ,CREATION_DATE               
		 ,LAST_UPDATE_LOGIN           
		 ,LAST_UPDATED_BY             
		 ,LAST_UPDATE_DATE         
		
        )
        VALUES 
        (
        pa_trx_tbl(i).VALIDATION_ERROR_MESSAGE    
		,pa_trx_tbl(i).FILE_SET_ID                 
		,pa_trx_tbl(i).MIGRATION_SET_ID            
		,pa_trx_tbl(i).MIGRATION_SET_NAME          
		,'VALIDATED'            
		,pa_trx_tbl(i).LOAD_BATCH                  
		,pa_trx_tbl(i).TXN_CTRL_REFERENCE          
		,pa_trx_tbl(i).PROJECT_NAME                
		,pa_trx_tbl(i).PROJECT_NUMBER              
		,pa_trx_tbl(i).TASK_NUMBER                 
		,pa_trx_tbl(i).TASK_NAME                   
		,pa_trx_tbl(i).EXPENDITURE_CATEGORY_NAME   
		,pa_trx_tbl(i).EXPENDITURE_TYPE            
		,pa_trx_tbl(i).NON_LABOR_RESOURCE          
		,pa_trx_tbl(i).PERSON_NUMBER               
		,pa_trx_tbl(i).PERSON_NAME                 
		,pa_trx_tbl(i).PERSON_EMAIL                
		,pa_trx_tbl(i).PERSON_TYPE                 
		,pa_trx_tbl(i).JOB_NAME                    
		,pa_trx_tbl(i).ORGANIZATION_NAME           
		,pa_trx_tbl(i).CHARGEABLE_FLAG             
		,pa_trx_tbl(i).BILLABLE_FLAG               
		,pa_trx_tbl(i).CAPITALIZABLE_FLAG          
		,pa_trx_tbl(i).START_DATE_ACTIVE           
		,pa_trx_tbl(i).END_DATE_ACTIVE             
		,pa_trx_tbl(i).BATCH_ID                    
		,pa_trx_tbl(i).BATCH_NAME                  
		,pa_trx_tbl(i).CREATED_BY                  
		,pa_trx_tbl(i).CREATION_DATE               
		,pa_trx_tbl(i).LAST_UPDATE_LOGIN           
		,pa_trx_tbl(i).LAST_UPDATED_BY             
		,pa_trx_tbl(i).LAST_UPDATE_DATE            						
        );	

END LOOP;
               --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --

		COMMIT;

               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE pa_trx_validation;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
                xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
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
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   pa_trx_validation%ISOPEN
                    THEN
                         --
                         CLOSE pa_trx_validation;
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
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
END VALIDATE_SRC_PA_TRX_CONTROL;


/*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_TEAM_MEMBERS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_TEAM_MEMBERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR pa_team_mem_validation(pt_i_MigrationSetID NUMBER)
        IS
     /*
     ** Validate if Project is open but key member is ex-employee
     */
	  SELECT 'Project is open but active key member is an ex-employee' as validation_error_message,PPT.*
from XXMX_PPM_PRJ_TEAM_MEM_stg PPT
where 1=1
and  migration_set_id = pt_i_MigrationSetID
and team_member_number in(select personnumber from xxmx_per_pos_wr_stg 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID 
AND trunc(actual_termination_date)<trunc(sysdate))
and project_name in(select project_name from XXMX_PPM_PROJECTS_STG 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID 
AND trunc(sysdate) between trunc(project_start_date) and trunc(project_finish_date))
	
	union all 
	 /*
     ** Validate if Project name is valid or not
     */	
	select 'project name is not valid' as validation_error_message,PPT.* 
from XXMX_PPM_PRJ_TEAM_MEM_stg PPT
WHERE 1=1
AND  migration_set_id = pt_i_MigrationSetID
and project_name in(select project_name from XXMX_PPM_PROJECTS_STG 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID
AND (trunc(sysdate) not between trunc(project_start_date) and trunc(project_finish_date)
        or project_start_date is null 
        or project_finish_date is null));



       TYPE pa_team_mem_type IS TABLE OF pa_team_mem_validation%ROWTYPE INDEX BY BINARY_INTEGER;
	   pa_team_mem_tbl pa_team_mem_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SRC_PA_TEAM_MEMBERS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TEAM_MEM_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_TEAM_MEM_STG';
		l_migration_set_id NUMBER;		
        l_subentity VARCHAR2(360);

         --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations

    BEGIN

l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';

		 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
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
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';

          l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(l_migration_set_id);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                   
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN pa_team_mem_validation(l_migration_set_id);

		LOOP
--		 
		 FETCH pa_team_mem_validation 
		 BULK COLLECT INTO pa_team_mem_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN pa_team_mem_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..pa_team_mem_tbl.COUNT 

        INSERT INTO XXMX_PPM_PRJ_TEAM_MEM_VAL
        (
		VALIDATION_ERROR_MESSAGE     
		,FILE_SET_ID                  
		,MIGRATION_SET_ID             
		,MIGRATION_SET_NAME           
		,MIGRATION_STATUS             
		,LOAD_BATCH                   
		,PROJECT_NAME                 
		,TEAM_MEMBER_NUMBER           
		,TEAM_MEMBER_NAME             
		,TEAM_MEMBER_EMAIL            
		,PROJECT_ROLE                 
		,START_DATE_ACTIVE            
		,END_DATE_ACTIVE              
		,ALLOCATION                   
		,LABOR_EFFORT                 
		,COST_RATE                    
		,BILL_RATE                    
		,TRACK_TIME                   
		,ASSIGNMENT_TYPE_CODE         
		,BILLABLE_PERCENT             
		,BILLABLE_PERCENT_REASON_CODE 
		,BATCH_ID                     
		,BATCH_NAME                   
		,PROJECT_NUMBER               
		,ORGANIZATION_NAME            
		,CREATED_BY                   
		,CREATION_DATE                
		,LAST_UPDATE_LOGIN            
		,LAST_UPDATED_BY              
		,LAST_UPDATE_DATE             
		)
        VALUES 
        (
         pa_team_mem_tbl(i).VALIDATION_ERROR_MESSAGE     
		,pa_team_mem_tbl(i).FILE_SET_ID                  
		,pa_team_mem_tbl(i).MIGRATION_SET_ID             
		,pa_team_mem_tbl(i).MIGRATION_SET_NAME           
		,'VALIDATED'             
		,pa_team_mem_tbl(i).LOAD_BATCH                   
		,pa_team_mem_tbl(i).PROJECT_NAME                 
		,pa_team_mem_tbl(i).TEAM_MEMBER_NUMBER           
		,pa_team_mem_tbl(i).TEAM_MEMBER_NAME             
		,pa_team_mem_tbl(i).TEAM_MEMBER_EMAIL            
		,pa_team_mem_tbl(i).PROJECT_ROLE                 
		,pa_team_mem_tbl(i).START_DATE_ACTIVE            
		,pa_team_mem_tbl(i).END_DATE_ACTIVE              
		,pa_team_mem_tbl(i).ALLOCATION                   
		,pa_team_mem_tbl(i).LABOR_EFFORT                 
		,pa_team_mem_tbl(i).COST_RATE                    
		,pa_team_mem_tbl(i).BILL_RATE                    
		,pa_team_mem_tbl(i).TRACK_TIME                   
		,pa_team_mem_tbl(i).ASSIGNMENT_TYPE_CODE         
		,pa_team_mem_tbl(i).BILLABLE_PERCENT             
		,pa_team_mem_tbl(i).BILLABLE_PERCENT_REASON_CODE 
		,pa_team_mem_tbl(i).BATCH_ID                     
		,pa_team_mem_tbl(i).BATCH_NAME                   
		,pa_team_mem_tbl(i).PROJECT_NUMBER               
		,pa_team_mem_tbl(i).ORGANIZATION_NAME            
		,pa_team_mem_tbl(i).CREATED_BY                   
		,pa_team_mem_tbl(i).CREATION_DATE                
		,pa_team_mem_tbl(i).LAST_UPDATE_LOGIN            
		,pa_team_mem_tbl(i).LAST_UPDATED_BY              
		,pa_team_mem_tbl(i).LAST_UPDATE_DATE             		
        );	

END LOOP;
               --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --

		COMMIT;

               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE pa_team_mem_validation;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
                xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
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
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   pa_team_mem_validation%ISOPEN
                    THEN
                         --
                         CLOSE pa_team_mem_validation;
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
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
END VALIDATE_SRC_PA_TEAM_MEMBERS;


/*
    ******************************
    ** PROCEDURE: VALIDATE_SRC_PA_CLASS
    ******************************
    */
    PROCEDURE VALIDATE_SRC_PA_CLASS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR pa_classification_validation(pt_i_MigrationSetID NUMBER)
        IS
/*
     ** Validate if Project name is valid or not
     */	
	 select 'project name is not valid' as validation_error_message,PPC.* 
from XXMX_PPM_PRJ_CLASS_stg PPC
WHERE 1=1
AND  migration_set_id = pt_i_MigrationSetID
and project_name in(select project_name from XXMX_PPM_PROJECTS_STG 
where 1=1
AND  migration_set_id = pt_i_MigrationSetID 
AND (trunc(sysdate) not between trunc(project_start_date) and trunc(project_finish_date)
        or project_start_date is null 
        or project_finish_date is null));



       TYPE pa_classification_type IS TABLE OF pa_classification_validation%ROWTYPE INDEX BY BINARY_INTEGER;
	   pa_classification_tbl pa_classification_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_SRC_PA_CLASS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_CLASS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_PPM_PRJ_CLASS_STG';
		l_migration_set_id NUMBER;		
        l_subentity VARCHAR2(360);

         --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations

    BEGIN

l_subentity:= get_subentity_name(pt_i_BusinessEntity,ct_StgTable);

        gvv_ProgressIndicator := '0010';

		 --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
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
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => pt_i_BusinessEntity
               ,pt_i_SubEntity        => l_subentity
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
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
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
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';

          l_migration_set_id := get_migration_set_id(pt_i_BusinessEntity);
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(l_migration_set_id);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
          --
          IF   gvt_MigrationSetName IS NOT NULL
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                   
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Validating "'
                                             ||pt_i_BusinessEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN pa_classification_validation(l_migration_set_id);

		LOOP
--		 
		 FETCH pa_classification_validation 
		 BULK COLLECT INTO pa_classification_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN pa_classification_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..pa_classification_tbl.COUNT 

        INSERT INTO XXMX_PPM_PRJ_CLASS_VAL
        (
		VALIDATION_ERROR_MESSAGE 
		,FILE_SET_ID              
		,MIGRATION_SET_ID         
		,MIGRATION_SET_NAME       
		,MIGRATION_STATUS         
		,LOAD_BATCH               
		,PROJECT_NAME             
		,CLASS_CATEGORY           
		,CLASS_CODE               
		,CODE_PERCENTAGE          
		,PROJECT_NUMBER           
		,ORGANIZATION_NAME        
		,BATCH_ID                 
		,BATCH_NAME               
		,CREATED_BY               
		,CREATION_DATE            
		,LAST_UPDATE_LOGIN        
		,LAST_UPDATED_BY          
		,LAST_UPDATE_DATE         	
        )
        VALUES 
        (
        pa_classification_tbl(i).VALIDATION_ERROR_MESSAGE
		,pa_classification_tbl(i).FILE_SET_ID              
		,pa_classification_tbl(i).MIGRATION_SET_ID         
		,pa_classification_tbl(i).MIGRATION_SET_NAME       
		,'VALIDATED'         
		,pa_classification_tbl(i).LOAD_BATCH               
		,pa_classification_tbl(i).PROJECT_NAME             
		,pa_classification_tbl(i).CLASS_CATEGORY           
		,pa_classification_tbl(i).CLASS_CODE               
		,pa_classification_tbl(i).CODE_PERCENTAGE          
		,pa_classification_tbl(i).PROJECT_NUMBER           
		,pa_classification_tbl(i).ORGANIZATION_NAME        
		,pa_classification_tbl(i).BATCH_ID                 
		,pa_classification_tbl(i).BATCH_NAME               
		,pa_classification_tbl(i).CREATED_BY               
		,pa_classification_tbl(i).CREATION_DATE            
		,pa_classification_tbl(i).LAST_UPDATE_LOGIN        
		,pa_classification_tbl(i).LAST_UPDATED_BY          
		,pa_classification_tbl(i).LAST_UPDATE_DATE         
        );	

END LOOP;
               --
               gvv_ProgressIndicator := '0070';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_CoreSchema
                                    ,ct_CoreTable
                                    ,l_migration_set_id
                                    );
               --

		COMMIT;

               --
               gvv_ProgressIndicator := '0080';
               --
               CLOSE pa_classification_validation;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_FileSetID         => NULL
                    ,pt_i_MigrationSetID    => l_migration_set_id                    
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Validation complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0090';
               --
                xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => l_migration_set_id
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => l_subentity
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
					,pt_i_ValidateRowCount        => gvn_RowCount
					,pt_i_ValidateStartDate   	  => SYSDATE
                    ,pt_i_ValidateCompletionDate  => SYSDATE
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => l_subentity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_CoreTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => l_subentity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
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
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
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
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
           WHEN OTHERS
               THEN
                    --
                    IF   pa_classification_validation%ISOPEN
                    THEN
                         --
                         CLOSE pa_classification_validation;
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
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --
END VALIDATE_SRC_PA_CLASS;


    /*

    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_XXMX_PPM_PROJECTS
    ******************************
    */
    PROCEDURE VALIDATE_XXMX_PPM_PROJECTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS
	CURSOR metadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT  DISTINCT
                      xmm.sub_entity_seq as sub_entity_seq
                      ,LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
               AND xmm.val_package_name IS NOT NULL
               ORDER BY xmm.sub_entity_seq;


gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	

    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_XXMX_PPM_PROJECTS';
        gvv_ProgressIndicator := '0010';


		FOR metadata_cur_rec 
		IN metadata_cur
		   (
		    pt_i_ApplicationSuite
		   ,pt_i_Application
		   ,pt_i_BusinessEntity
		   )
		 LOOP

               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => 'ALL'
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => metadata_cur_rec.val_package_name
                    ,pt_i_ProcOrFuncName    => metadata_cur_rec.val_procedure_name
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Procedure "'
                                               ||metadata_cur_rec.val_package_name
                                               ||'.'
                                               ||metadata_cur_rec.val_procedure_name
                                               ||'" initiated.'
                    ,pt_i_OracleError       => NULL
                    );		

        gvv_ProgressIndicator := '0020';

                gvv_SQLStatement := 'BEGIN '
                                    ||metadata_cur_rec.val_package_name
                                    ||'.'
                                    ||metadata_cur_rec.val_procedure_name
                                    ||gcv_SQLSpace
                                    ||'('
                                    ||' pt_i_ApplicationSuite => '''
									||pt_i_ApplicationSuite
                                    ||''''
                                    ||',pt_i_Application => '''
									||pt_i_Application
                                    ||''''
                                    ||',pt_i_BusinessEntity =>  '''
									||pt_i_BusinessEntity
                                    ||''''
                                    ||'); END;';	

                xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => pt_i_ApplicationSuite
                                   ,pt_i_Application         => pt_i_Application
                                   ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => metadata_cur_rec.val_package_name
                                   ,pt_i_ProcOrFuncName      => metadata_cur_rec.val_procedure_name
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => SUBSTR(
                                                                       '      - Generated SQL Statement: ' ||gvv_SQLStatement
                                                                      ,1
                                                                      ,4000
                                                                      )
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE IMMEDIATE gvv_SQLStatement;	


		 END LOOP;

		--
    EXCEPTION
           WHEN OTHERS
               THEN
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
                     ,pt_i_BusinessEntity    => gct_BusinessEntity
                     ,pt_i_SubEntity         => ct_SubEntity
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                     ,pt_i_OracleError       => gvt_OracleError
                     );
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
                RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                --
           --** END OTHERS Exception
           --
      --** END Exception Handler
      --    
    END VALIDATE_XXMX_PPM_PROJECTS;
    --
    --
END XXMX_PPM_PRJ_VALIDATIONS_PKG;