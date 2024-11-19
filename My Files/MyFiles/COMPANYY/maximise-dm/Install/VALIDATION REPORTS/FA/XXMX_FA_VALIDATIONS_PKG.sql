create or replace PACKAGE  XXMX_CORE.XXMX_FA_VALIDATIONS_PKG
AS
/*
	 ******************************************************************************
     ** FILENAME  :  XXMX_FA_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary Kotapati
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_FA_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_FA_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                 Change Description
     ** -----  -----------  ------------------         -----------------------------------
     **   1.0  23-FEB-2024  Sushma Chowdary Kotapati        Initial implementation
     ******************************************************************************
	 */
	 --
	/*
    ******************************
    ** PROCEDURE: VALIDATE_FIXED_ASSETS
    ******************************
    */
    PROCEDURE VALIDATE_FIXED_ASSETS
                    (
                    pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_MASS_ADDITION
    ******************************
    */
	PROCEDURE VALIDATE_MASS_ADDITION
					(
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
	 --
	/*
    ******************************
    ** PROCEDURE: VALIDATE_FA_MASS_ADDITION_DIST
    ******************************
    */
    PROCEDURE VALIDATE_FA_MASS_ADDITION_DIST
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
	******************************
    ** PROCEDURE: VALIDATE_MASSRATES
    ******************************
    */
    PROCEDURE VALIDATE_MASSRATES
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

	END XXMX_FA_VALIDATIONS_PKG;
	/
	
	create or replace PACKAGE BODY XXMX_CORE.XXMX_FA_VALIDATIONS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_FA_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sushma Chowdary Kotapati
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_FA_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_FA_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By             Change Description
     ** -----  -----------  ------------------     -----------------------------------
     **   1.0  23-FEB-2024   Sushma Chowdary kotapati    Initial implementation, 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_FA_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'FA';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'FIXED_ASSETS';
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
    ** PROCEDURE: VALIDATE_MASS_ADDITION
    ******************************
    */
    PROCEDURE VALIDATE_MASS_ADDITION
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

	CURSOR fa_massaddition_validations(pt_i_MigrationSetID number)
        IS
	 /*
     ** Validate if Asset Cost is not a zero
     */
	 SELECT 'Fixed Asset cost should not be Zero' as validation_error_message,xfma.*
			FROM XXMX_FA_MASS_ADDITIONS_STG xfma
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND  xfma.FIXED_ASSETS_COST = 0
			UNION ALL
    /*
     ** Validate the Asset type
     */
	SELECT 'Invalid Asset type' as validation_error_message,xfma.*
			FROM XXMX_FA_MASS_ADDITIONS_STG xfma
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND ASSET_TYPE NOT IN('CAPITALIZED','CIP','GROUP','EXPENSED')
			UNION ALL
	/*
     ** Validate the ytd impairment
     */		
	SELECT 'Invalid ytd impairment(ytd impairment must be always equal or lesser than impairment reserve' as validation_error_message,xfma.*
			FROM XXMX_FA_MASS_ADDITIONS_STG xfma
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND xfma.YTD_IMPAIRMENT > xfma.IMPAIRMENT_RESERVE
			UNION ALL
   /*
    ** Validate if MASS_ADDITION_ID column is null.
    */
    SELECT   'MASS_ADDITION_ID should not be null' as VALIDATION_ERROR_MESSAGE, xfma.*
            FROM     XXMX_FA_MASS_ADDITIONS_STG xfma
            WHERE    1 = 1
            AND      xfma.migration_set_id = pt_i_MigrationSetID
            AND      xfma.MASS_ADDITION_ID IS NULL	
		UNION ALL
	/*
    ** Validate if the asset number are unique are not
    */
    SELECT   'Asset number must be unique' as VALIDATION_ERROR_MESSAGE, xfma.*
        from XXMX_FA_MASS_ADDITIONS_STG xfma
        where 1=1
        AND migration_set_id = pt_i_MigrationSetID
        AND exists (SELECT ASSET_NUMBER
        FROM XXMX_FA_MASS_ADDITIONS_STG xfma1
        WHERE xfma.migration_set_id = xfma1.migration_set_id
        AND xfma.ASSET_NUMBER=xfma1.ASSET_NUMBER
        GROUP BY ASSET_NUMBER
        HAVING COUNT(*) > 1)  
	UNION ALL
	/*
    ** Validate the posting status
    */
	SELECT 'Invalid posting_status' as validation_error_message,xfma.*
		FROM XXMX_FA_MASS_ADDITIONS_STG xfma
        WHERE  1=1
		AND  migration_set_id = pt_i_MigrationSetID
		AND xfma.POSTING_STATUS NOT IN('NEW','POST','ON HOLD','MERGED')
	UNION ALL
	/*
    ** Validate the Asset Description having the Junk/Invalid Characters
    */
        SELECT 'Asset Description having Junk/Invalid characters' as VALIDATION_ERROR_MESSAGE, xfma.*  
        FROM XXMX_FA_MASS_ADDITIONS_STG xfma
        WHERE 1=1
		AND xfma.migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( DESCRIPTION, '[^[:print:]]' )
	UNION ALL
/*
     ** Validate if Fa mass addition ID has at least one fa mass distribution is
     */			
			SELECT 'FA Mass Addition ID should have atleast one Mass distribution ID' as validation_error_message,xfma.*
			FROM XXMX_FA_MASS_ADDITIONS_STG xfma
            WHERE 1=1
            AND  xfma.migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT MASS_ADDITION_ID FROM XXMX_FA_MASS_ADDITION_DIST_STG xfmda
							 WHERE xfmda.MASS_ADDITION_ID=xfma.MASS_ADDITION_ID
							 AND  xfmda.migration_set_id = pt_i_MigrationSetID	
							 GROUP BY MASS_ADDITION_ID
							 HAVING COUNT(1) >= 1);
	
 TYPE fa_massaddition_type IS TABLE OF fa_massaddition_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	 fa_massaddition_tbl fa_massaddition_type;

	  --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_MASS_ADDITION';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_ADDITIONS_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_ADDITIONS_STG';
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

		OPEN fa_massaddition_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH fa_massaddition_validations 
		 BULK COLLECT INTO fa_massaddition_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN fa_massaddition_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

	FORALL i in 1..fa_massaddition_tbl.COUNT

	INSERT INTO XXMX_FA_MASS_ADDITIONS_VAL
        (
		VALIDATION_ERROR_MESSAGE
        ,FILE_SET_ID                      
        ,MIGRATION_SET_ID                 
        ,MIGRATION_SET_NAME               
        ,MIGRATION_STATUS                 
        ,OPERATING_UNIT                   
        ,LEDGER_NAME                      
        ,MASS_ADDITION_ID                 
        ,ASSET_CATEGORY_ID                
        ,PREPARER_ID                      
        ,CREATE_BATCH_ID                  
        ,CASH_GENERATING_UNIT_ID          
        ,PO_VENDOR_ID                     
        ,INVOICE_ID                       
        ,PARENT_MASS_ADDITION_ID          
        ,PARENT_ASSET_ID                  
        ,AP_DISTRIBUTION_LINE_NUMBER      
        ,POST_BATCH_ID                    
        ,ADD_TO_ASSET_ID                  
        ,ASSET_KEY_CCID                   
        ,LOAD_REQUEST_ID                  
        ,MERGE_PARENT_MASS_ADDITIONS_ID   
        ,SPLIT_PARENT_MASS_ADDITIONS_ID   
        ,PROJECT_ASSET_LINE_ID            
        ,PROJECT_ID                       
        ,TASK_ID                          
        ,ASSET_ID                         
        ,INVOICE_DISTRIBUTION_ID          
        ,PO_DISTRIBUTION_ID               
        ,REQUEST_ID                       
        ,WORKER_ID                        
        ,PROCESS_ORDER                    
        ,INVOICE_PAYMENT_ID               
        ,OBJECT_VERSION_NUMBER            
        ,METHOD_ID                        
        ,FLAT_RATE_ID                     
        ,CONVENTION_TYPE_ID               
        ,BONUS_RULE_ID                    
        ,CEILING_TYPE_ID                  
        ,PRIOR_METHOD_ID                  
        ,PRIOR_FLAT_RATE_ID               
        ,WARRANTY_ID                      
        ,ITC_AMOUNT_ID                    
        ,LEASE_ID                         
        ,LESSOR_ID                        
        ,PERIOD_COUNTER_FULLY_RESERVED    
        ,PERIOD_COUNTER_EXTENDED          
        ,PROJECT_ORGANIZATION_ID          
        ,TASK_ORGANIZATION_ID             
        ,EXPENDITURE_ORGANIZATION_ID      
        ,PROJECT_TXN_DOC_ENTRY_ID         
        ,EXPENDITURE_TYPE_ID              
        ,LEASE_SCHEDULE_ID                
        ,SHIP_TO_CUST_LOCATION_ID         
        ,SHIP_TO_LOCATION_ID              
        ,INTERFACE_LINE_NUM               
        ,BOOK_TYPE_CODE                   
        ,TRANSACTION_NAME                 
        ,ASSET_NUMBER                     
        ,DESCRIPTION                      
        ,TAG_NUMBER                       
        ,MANUFACTURER_NAME                
        ,SERIAL_NUMBER                    
        ,MODEL_NUMBER                     
        ,ASSET_TYPE                       
        ,FIXED_ASSETS_COST                
        ,DATE_PLACED_IN_SERVICE           
        ,PRORATE_CONVENTION_CODE          
        ,FIXED_ASSETS_UNITS               
        ,CATEGORY_SEGMENT1                
        ,CATEGORY_SEGMENT2                
        ,CATEGORY_SEGMENT3                
        ,CATEGORY_SEGMENT4                
        ,CATEGORY_SEGMENT5                
        ,CATEGORY_SEGMENT6                
        ,CATEGORY_SEGMENT7                
        ,POSTING_STATUS                   
        ,QUEUE_NAME                       
        ,FEEDER_SYSTEM_NAME               
        ,PARENT_ASSET_NUMBER              
        ,ADD_TO_ASSET_NUMBER              
        ,INVENTORIAL                      
        ,PROPERTY_TYPE_CODE               
        ,PROPERTY_1245_1250_CODE          
        ,IN_USE_FLAG                      
        ,OWNED_LEASED                     
        ,NEW_USED                         
        ,MATERIAL_INDICATOR_FLAG          
        ,COMMITMENT                       
        ,INVESTMENT_LAW                   
        ,AMORTIZE_FLAG                    
        ,AMORTIZATION_START_DATE          
        ,DEPRECIATE_FLAG                  
        ,SALVAGE_TYPE                     
        ,SALVAGE_VALUE                    
        ,PERCENT_SALVAGE_VALUE            
        ,YTD_DEPRN                        
        ,DEPRN_RESERVE                    
        ,BONUS_YTD_DEPRN                  
        ,BONUS_DEPRN_RESERVE              
        ,YTD_IMPAIRMENT                   
        ,IMPAIRMENT_RESERVE               
        ,METHOD_CODE                      
        ,LIFE_IN_MONTHS                   
        ,BASIC_RATE                       
        ,ADJUSTED_RATE                    
        ,UNIT_OF_MEASURE                  
        ,PRODUCTION_CAPACITY              
        ,CEILING_NAME                     
        ,BONUS_RULE                       
        ,CASH_GENERATING_UNIT             
        ,DEPRN_LIMIT_TYPE                 
        ,ALLOWED_DEPRN_LIMIT              
        ,ALLOWED_DEPRN_LIMIT_AMOUNT       
        ,PAYABLES_COST                    
        ,PAYABLES_CODE_COMBINATION_ID     
        ,CLEARING_ACCT_SEGMENT1           
        ,CLEARING_ACCT_SEGMENT2           
        ,CLEARING_ACCT_SEGMENT3           
        ,CLEARING_ACCT_SEGMENT4           
        ,CLEARING_ACCT_SEGMENT5           
        ,CLEARING_ACCT_SEGMENT6           
        ,MASS_PROPERTY_FLAG               
        ,GROUP_ASSET_NUMBER               
        ,REDUCTION_RATE                   
        ,REDUCE_ADDITION_FLAG             
        ,REDUCE_ADJUSTMENT_FLAG           
        ,REDUCE_RETIREMENT_FLAG           
        ,RECOGNIZE_GAIN_LOSS              
        ,RECAPTURE_RESERVE_FLAG           
        ,LIMIT_PROCEEDS_FLAG              
        ,TERMINAL_GAIN_LOSS               
        ,TRACKING_METHOD                  
        ,EXCESS_ALLOCATION_OPTION         
        ,DEPRECIATION_OPTION              
        ,MEMBER_ROLLUP_FLAG               
        ,ALLOCATE_TO_FULLY_RSV_FLAG       
        ,OVER_DEPRECIATE_OPTION           
        ,PREPARER_EMAIL_ADDRESS           
        ,MERGED_CODE                      
        ,PARENT_INT_LINE_NUM              
        ,SUM_UNITS                        
        ,NEW_MASTER_FLAG                  
        ,UNITS_TO_ADJUST                  
        ,SHORT_FISCAL_YEAR_FLAG           
        ,CONVERSION_DATE                  
        ,ORIGINAL_DEPRN_START_DATE        
        ,NBV_AT_SWITCH                    
        ,PERIOD_NAME_FULLY_RESERVED       
        ,PERIOD_NAME_EXTENDED             
        ,PRIOR_DEPRN_LIMIT_TYPE           
        ,PRIOR_DEPRN_LIMIT                
        ,PRIOR_DEPRN_LIMIT_AMOUNT         
        ,PRIOR_METHOD_CODE                
        ,PRIOR_LIFE_IN_MONTHS             
        ,PRIOR_BASIC_RATE                 
        ,PRIOR_ADJUSTED_RATE              
        ,ASSET_SCHEDULE_NUM               
        ,LEASE_NUMBER                     
        ,REVAL_RESERVE                    
        ,REVAL_LOSS_BALANCE               
        ,REVAL_AMORTIZATION_BASIS         
        ,IMPAIR_LOSS_BALANCE              
        ,REVAL_CEILING                    
        ,FAIR_MARKET_VALUE                
        ,LAST_PRICE_INDEX_VALUE           
        ,VENDOR_NAME                      
        ,VENDOR_NUMBER                    
        ,PO_NUMBER                        
        ,INVOICE_NUMBER                   
        ,INVOICE_VOUCHER_NUMBER           
        ,INVOICE_DATE                     
        ,PAYABLES_UNITS                   
        ,INVOICE_LINE_NUMBER              
        ,INVOICE_LINE_TYPE                
        ,INVOICE_LINE_DESCRIPTION         
        ,INVOICE_PAYMENT_NUMBER           
        ,PROJECT_NUMBER                   
        ,PROJECT_TASK_NUMBER              
        ,FULLY_RESERVE_ON_ADD_FLAG        
        ,DEPRN_ADJUSTMENT_FACTOR          
        ,REVALUED_COST                    
        ,BACKLOG_DEPRN_RESERVE            
        ,YTD_BACKLOG_DEPRN                
        ,REVAL_AMORT_BALANCE              
        ,YTD_REVAL_AMORTIZATION           
        ,ADJUSTED_COST                    
        ,LAST_UPDATED_BY                  
        ,REVIEWER_COMMENTS                
        ,INVOICE_CREATED_BY               
        ,INVOICE_UPDATED_BY               
        ,PAYABLES_BATCH_NAME              
        ,SPLIT_MERGED_CODE                
        ,SPLIT_CODE                       
        ,DIST_NAME                        
        ,CREATED_BY                       
        ,LAST_UPDATE_LOGIN                
        ,MERGE_INVOICE_NUMBER             
        ,MERGE_VENDOR_NUMBER              
        ,PREPARER_NAME                    
        ,PREPARER_NUMBER                  
        ,PERIOD_FULL_RESERVE              
        ,PERIOD_EXTD_DEPRN                
        ,WARRANTY_NUMBER                  
        ,ATTACHMENT_FLAG                  
        ,ERROR_MSG                        
        ,LOW_VALUE_ASSET_FLAG             
        ,CREATE_EXPENSED_ASSET_FLAG       
        ,CAP_THRESHOLD_CHECK_FLAG         
        ,LINE_TYPE_LOOKUP_CODE            
        ,INTANGIBLE_ASSET_FLAG            
        ,CREATE_BATCH_DATE                
        ,LAST_UPDATE_DATE                 
        ,CREATION_DATE                    
        ,ACCOUNTING_DATE                  
        ,GROUP_ASSET_ID                   
        ,YTD_REVAL_DEPRN_EXPENSE          
        ,UNREVALUED_COST                  
        ,FULLY_RSVD_REVALS_COUNTER        
        ,DEPRN_EXPENSE_SEGMENT6 
		)
		VALUES 
        (
		fa_massaddition_tbl(i).VALIDATION_ERROR_MESSAGE
        ,fa_massaddition_tbl(i).FILE_SET_ID                      
        ,fa_massaddition_tbl(i).MIGRATION_SET_ID                 
        ,fa_massaddition_tbl(i).MIGRATION_SET_NAME               
        ,'VALIDATED'                 
        ,fa_massaddition_tbl(i).OPERATING_UNIT                   
        ,fa_massaddition_tbl(i).LEDGER_NAME                      
        ,fa_massaddition_tbl(i).MASS_ADDITION_ID                 
        ,fa_massaddition_tbl(i).ASSET_CATEGORY_ID                
        ,fa_massaddition_tbl(i).PREPARER_ID                      
        ,fa_massaddition_tbl(i).CREATE_BATCH_ID                  
        ,fa_massaddition_tbl(i).CASH_GENERATING_UNIT_ID          
        ,fa_massaddition_tbl(i).PO_VENDOR_ID                     
        ,fa_massaddition_tbl(i).INVOICE_ID                       
        ,fa_massaddition_tbl(i).PARENT_MASS_ADDITION_ID          
        ,fa_massaddition_tbl(i).PARENT_ASSET_ID                  
        ,fa_massaddition_tbl(i).AP_DISTRIBUTION_LINE_NUMBER      
        ,fa_massaddition_tbl(i).POST_BATCH_ID                    
        ,fa_massaddition_tbl(i).ADD_TO_ASSET_ID                  
        ,fa_massaddition_tbl(i).ASSET_KEY_CCID                   
        ,fa_massaddition_tbl(i).LOAD_REQUEST_ID                  
        ,fa_massaddition_tbl(i).MERGE_PARENT_MASS_ADDITIONS_ID   
        ,fa_massaddition_tbl(i).SPLIT_PARENT_MASS_ADDITIONS_ID   
        ,fa_massaddition_tbl(i).PROJECT_ASSET_LINE_ID            
        ,fa_massaddition_tbl(i).PROJECT_ID                       
        ,fa_massaddition_tbl(i).TASK_ID                          
        ,fa_massaddition_tbl(i).ASSET_ID                         
        ,fa_massaddition_tbl(i).INVOICE_DISTRIBUTION_ID          
        ,fa_massaddition_tbl(i).PO_DISTRIBUTION_ID               
        ,fa_massaddition_tbl(i).REQUEST_ID                       
        ,fa_massaddition_tbl(i).WORKER_ID                        
        ,fa_massaddition_tbl(i).PROCESS_ORDER                    
        ,fa_massaddition_tbl(i).INVOICE_PAYMENT_ID               
        ,fa_massaddition_tbl(i).OBJECT_VERSION_NUMBER            
        ,fa_massaddition_tbl(i).METHOD_ID                        
        ,fa_massaddition_tbl(i).FLAT_RATE_ID                     
        ,fa_massaddition_tbl(i).CONVENTION_TYPE_ID               
        ,fa_massaddition_tbl(i).BONUS_RULE_ID                    
        ,fa_massaddition_tbl(i).CEILING_TYPE_ID                  
        ,fa_massaddition_tbl(i).PRIOR_METHOD_ID                  
        ,fa_massaddition_tbl(i).PRIOR_FLAT_RATE_ID               
        ,fa_massaddition_tbl(i).WARRANTY_ID                      
        ,fa_massaddition_tbl(i).ITC_AMOUNT_ID                    
        ,fa_massaddition_tbl(i).LEASE_ID                         
        ,fa_massaddition_tbl(i).LESSOR_ID                        
        ,fa_massaddition_tbl(i).PERIOD_COUNTER_FULLY_RESERVED    
        ,fa_massaddition_tbl(i).PERIOD_COUNTER_EXTENDED          
        ,fa_massaddition_tbl(i).PROJECT_ORGANIZATION_ID          
        ,fa_massaddition_tbl(i).TASK_ORGANIZATION_ID             
        ,fa_massaddition_tbl(i).EXPENDITURE_ORGANIZATION_ID      
        ,fa_massaddition_tbl(i).PROJECT_TXN_DOC_ENTRY_ID         
        ,fa_massaddition_tbl(i).EXPENDITURE_TYPE_ID              
        ,fa_massaddition_tbl(i).LEASE_SCHEDULE_ID                
        ,fa_massaddition_tbl(i).SHIP_TO_CUST_LOCATION_ID         
        ,fa_massaddition_tbl(i).SHIP_TO_LOCATION_ID              
        ,fa_massaddition_tbl(i).INTERFACE_LINE_NUM               
        ,fa_massaddition_tbl(i).BOOK_TYPE_CODE                   
        ,fa_massaddition_tbl(i).TRANSACTION_NAME                 
        ,fa_massaddition_tbl(i).ASSET_NUMBER                     
        ,fa_massaddition_tbl(i).DESCRIPTION                      
        ,fa_massaddition_tbl(i).TAG_NUMBER                       
        ,fa_massaddition_tbl(i).MANUFACTURER_NAME                
        ,fa_massaddition_tbl(i).SERIAL_NUMBER                    
        ,fa_massaddition_tbl(i).MODEL_NUMBER                     
        ,fa_massaddition_tbl(i).ASSET_TYPE                       
        ,fa_massaddition_tbl(i).FIXED_ASSETS_COST                
        ,fa_massaddition_tbl(i).DATE_PLACED_IN_SERVICE           
        ,fa_massaddition_tbl(i).PRORATE_CONVENTION_CODE          
        ,fa_massaddition_tbl(i).FIXED_ASSETS_UNITS               
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT1                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT2                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT3                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT4                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT5                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT6                
        ,fa_massaddition_tbl(i).CATEGORY_SEGMENT7                
        ,fa_massaddition_tbl(i).POSTING_STATUS                   
        ,fa_massaddition_tbl(i).QUEUE_NAME                       
        ,fa_massaddition_tbl(i).FEEDER_SYSTEM_NAME               
        ,fa_massaddition_tbl(i).PARENT_ASSET_NUMBER              
        ,fa_massaddition_tbl(i).ADD_TO_ASSET_NUMBER              
        ,fa_massaddition_tbl(i).INVENTORIAL                      
        ,fa_massaddition_tbl(i).PROPERTY_TYPE_CODE               
        ,fa_massaddition_tbl(i).PROPERTY_1245_1250_CODE          
        ,fa_massaddition_tbl(i).IN_USE_FLAG                      
        ,fa_massaddition_tbl(i).OWNED_LEASED                     
        ,fa_massaddition_tbl(i).NEW_USED                         
        ,fa_massaddition_tbl(i).MATERIAL_INDICATOR_FLAG          
        ,fa_massaddition_tbl(i).COMMITMENT                       
        ,fa_massaddition_tbl(i).INVESTMENT_LAW                   
        ,fa_massaddition_tbl(i).AMORTIZE_FLAG                    
        ,fa_massaddition_tbl(i).AMORTIZATION_START_DATE          
        ,fa_massaddition_tbl(i).DEPRECIATE_FLAG                  
        ,fa_massaddition_tbl(i).SALVAGE_TYPE                     
        ,fa_massaddition_tbl(i).SALVAGE_VALUE                    
        ,fa_massaddition_tbl(i).PERCENT_SALVAGE_VALUE            
        ,fa_massaddition_tbl(i).YTD_DEPRN                        
        ,fa_massaddition_tbl(i).DEPRN_RESERVE                    
        ,fa_massaddition_tbl(i).BONUS_YTD_DEPRN                  
        ,fa_massaddition_tbl(i).BONUS_DEPRN_RESERVE              
        ,fa_massaddition_tbl(i).YTD_IMPAIRMENT                   
        ,fa_massaddition_tbl(i).IMPAIRMENT_RESERVE               
        ,fa_massaddition_tbl(i).METHOD_CODE                      
        ,fa_massaddition_tbl(i).LIFE_IN_MONTHS                   
        ,fa_massaddition_tbl(i).BASIC_RATE                       
        ,fa_massaddition_tbl(i).ADJUSTED_RATE                    
        ,fa_massaddition_tbl(i).UNIT_OF_MEASURE                  
        ,fa_massaddition_tbl(i).PRODUCTION_CAPACITY              
        ,fa_massaddition_tbl(i).CEILING_NAME                     
        ,fa_massaddition_tbl(i).BONUS_RULE                       
        ,fa_massaddition_tbl(i).CASH_GENERATING_UNIT             
        ,fa_massaddition_tbl(i).DEPRN_LIMIT_TYPE                 
        ,fa_massaddition_tbl(i).ALLOWED_DEPRN_LIMIT              
        ,fa_massaddition_tbl(i).ALLOWED_DEPRN_LIMIT_AMOUNT       
        ,fa_massaddition_tbl(i).PAYABLES_COST                    
        ,fa_massaddition_tbl(i).PAYABLES_CODE_COMBINATION_ID     
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT1           
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT2           
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT3           
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT4           
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT5           
        ,fa_massaddition_tbl(i).CLEARING_ACCT_SEGMENT6           
        ,fa_massaddition_tbl(i).MASS_PROPERTY_FLAG               
        ,fa_massaddition_tbl(i).GROUP_ASSET_NUMBER               
        ,fa_massaddition_tbl(i).REDUCTION_RATE                   
        ,fa_massaddition_tbl(i).REDUCE_ADDITION_FLAG             
        ,fa_massaddition_tbl(i).REDUCE_ADJUSTMENT_FLAG           
        ,fa_massaddition_tbl(i).REDUCE_RETIREMENT_FLAG           
        ,fa_massaddition_tbl(i).RECOGNIZE_GAIN_LOSS              
        ,fa_massaddition_tbl(i).RECAPTURE_RESERVE_FLAG           
        ,fa_massaddition_tbl(i).LIMIT_PROCEEDS_FLAG              
        ,fa_massaddition_tbl(i).TERMINAL_GAIN_LOSS               
        ,fa_massaddition_tbl(i).TRACKING_METHOD                  
        ,fa_massaddition_tbl(i).EXCESS_ALLOCATION_OPTION         
        ,fa_massaddition_tbl(i).DEPRECIATION_OPTION              
        ,fa_massaddition_tbl(i).MEMBER_ROLLUP_FLAG               
        ,fa_massaddition_tbl(i).ALLOCATE_TO_FULLY_RSV_FLAG       
        ,fa_massaddition_tbl(i).OVER_DEPRECIATE_OPTION           
        ,fa_massaddition_tbl(i).PREPARER_EMAIL_ADDRESS           
        ,fa_massaddition_tbl(i).MERGED_CODE                      
        ,fa_massaddition_tbl(i).PARENT_INT_LINE_NUM              
        ,fa_massaddition_tbl(i).SUM_UNITS                        
        ,fa_massaddition_tbl(i).NEW_MASTER_FLAG                  
        ,fa_massaddition_tbl(i).UNITS_TO_ADJUST                  
        ,fa_massaddition_tbl(i).SHORT_FISCAL_YEAR_FLAG           
        ,fa_massaddition_tbl(i).CONVERSION_DATE                  
        ,fa_massaddition_tbl(i).ORIGINAL_DEPRN_START_DATE        
        ,fa_massaddition_tbl(i).NBV_AT_SWITCH                    
        ,fa_massaddition_tbl(i).PERIOD_NAME_FULLY_RESERVED       
        ,fa_massaddition_tbl(i).PERIOD_NAME_EXTENDED             
        ,fa_massaddition_tbl(i).PRIOR_DEPRN_LIMIT_TYPE           
        ,fa_massaddition_tbl(i).PRIOR_DEPRN_LIMIT                
        ,fa_massaddition_tbl(i).PRIOR_DEPRN_LIMIT_AMOUNT         
        ,fa_massaddition_tbl(i).PRIOR_METHOD_CODE                
        ,fa_massaddition_tbl(i).PRIOR_LIFE_IN_MONTHS             
        ,fa_massaddition_tbl(i).PRIOR_BASIC_RATE                 
        ,fa_massaddition_tbl(i).PRIOR_ADJUSTED_RATE              
        ,fa_massaddition_tbl(i).ASSET_SCHEDULE_NUM               
        ,fa_massaddition_tbl(i).LEASE_NUMBER                     
        ,fa_massaddition_tbl(i).REVAL_RESERVE                    
        ,fa_massaddition_tbl(i).REVAL_LOSS_BALANCE               
        ,fa_massaddition_tbl(i).REVAL_AMORTIZATION_BASIS         
        ,fa_massaddition_tbl(i).IMPAIR_LOSS_BALANCE              
        ,fa_massaddition_tbl(i).REVAL_CEILING                    
        ,fa_massaddition_tbl(i).FAIR_MARKET_VALUE                
        ,fa_massaddition_tbl(i).LAST_PRICE_INDEX_VALUE           
        ,fa_massaddition_tbl(i).VENDOR_NAME                      
        ,fa_massaddition_tbl(i).VENDOR_NUMBER                    
        ,fa_massaddition_tbl(i).PO_NUMBER                        
        ,fa_massaddition_tbl(i).INVOICE_NUMBER                   
        ,fa_massaddition_tbl(i).INVOICE_VOUCHER_NUMBER           
        ,fa_massaddition_tbl(i).INVOICE_DATE                     
        ,fa_massaddition_tbl(i).PAYABLES_UNITS                   
        ,fa_massaddition_tbl(i).INVOICE_LINE_NUMBER              
        ,fa_massaddition_tbl(i).INVOICE_LINE_TYPE                
        ,fa_massaddition_tbl(i).INVOICE_LINE_DESCRIPTION         
        ,fa_massaddition_tbl(i).INVOICE_PAYMENT_NUMBER           
        ,fa_massaddition_tbl(i).PROJECT_NUMBER                   
        ,fa_massaddition_tbl(i).PROJECT_TASK_NUMBER              
        ,fa_massaddition_tbl(i).FULLY_RESERVE_ON_ADD_FLAG        
        ,fa_massaddition_tbl(i).DEPRN_ADJUSTMENT_FACTOR          
        ,fa_massaddition_tbl(i).REVALUED_COST                    
        ,fa_massaddition_tbl(i).BACKLOG_DEPRN_RESERVE            
        ,fa_massaddition_tbl(i).YTD_BACKLOG_DEPRN                
        ,fa_massaddition_tbl(i).REVAL_AMORT_BALANCE              
        ,fa_massaddition_tbl(i).YTD_REVAL_AMORTIZATION           
        ,fa_massaddition_tbl(i).ADJUSTED_COST                    
        ,fa_massaddition_tbl(i).LAST_UPDATED_BY                  
        ,fa_massaddition_tbl(i).REVIEWER_COMMENTS                
        ,fa_massaddition_tbl(i).INVOICE_CREATED_BY               
        ,fa_massaddition_tbl(i).INVOICE_UPDATED_BY               
        ,fa_massaddition_tbl(i).PAYABLES_BATCH_NAME              
        ,fa_massaddition_tbl(i).SPLIT_MERGED_CODE                
        ,fa_massaddition_tbl(i).SPLIT_CODE                       
        ,fa_massaddition_tbl(i).DIST_NAME                        
        ,fa_massaddition_tbl(i).CREATED_BY                       
        ,fa_massaddition_tbl(i).LAST_UPDATE_LOGIN                
        ,fa_massaddition_tbl(i).MERGE_INVOICE_NUMBER             
        ,fa_massaddition_tbl(i).MERGE_VENDOR_NUMBER              
        ,fa_massaddition_tbl(i).PREPARER_NAME                    
        ,fa_massaddition_tbl(i).PREPARER_NUMBER                  
        ,fa_massaddition_tbl(i).PERIOD_FULL_RESERVE              
        ,fa_massaddition_tbl(i).PERIOD_EXTD_DEPRN                
        ,fa_massaddition_tbl(i).WARRANTY_NUMBER                  
        ,fa_massaddition_tbl(i).ATTACHMENT_FLAG                  
        ,fa_massaddition_tbl(i).ERROR_MSG                        
        ,fa_massaddition_tbl(i).LOW_VALUE_ASSET_FLAG             
        ,fa_massaddition_tbl(i).CREATE_EXPENSED_ASSET_FLAG       
        ,fa_massaddition_tbl(i).CAP_THRESHOLD_CHECK_FLAG         
        ,fa_massaddition_tbl(i).LINE_TYPE_LOOKUP_CODE            
        ,fa_massaddition_tbl(i).INTANGIBLE_ASSET_FLAG            
        ,fa_massaddition_tbl(i).CREATE_BATCH_DATE                
        ,fa_massaddition_tbl(i).LAST_UPDATE_DATE                 
        ,fa_massaddition_tbl(i).CREATION_DATE                    
        ,fa_massaddition_tbl(i).ACCOUNTING_DATE                  
        ,fa_massaddition_tbl(i).GROUP_ASSET_ID                   
        ,fa_massaddition_tbl(i).YTD_REVAL_DEPRN_EXPENSE          
        ,fa_massaddition_tbl(i).UNREVALUED_COST                  
        ,fa_massaddition_tbl(i).FULLY_RSVD_REVALS_COUNTER        
        ,fa_massaddition_tbl(i).DEPRN_EXPENSE_SEGMENT6 
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
               CLOSE fa_massaddition_validations;
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
                    IF   fa_massaddition_validations%ISOPEN
                    THEN
                         --
                         CLOSE fa_massaddition_validations;
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
END VALIDATE_MASS_ADDITION;

	/*
    ******************************
    ** PROCEDURE: VALIDATE_FA_MASS_ADDITION_DIST
    ******************************
    */
    PROCEDURE VALIDATE_FA_MASS_ADDITION_DIST
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

	CURSOR fa_massadd_dist_validations(pt_i_MigrationSetID NUMBER)
        IS
	   /*
        ** Validate if UNITS column is NULL.
        */
          SELECT   'UNITS should not be NULL' as VALIDATION_ERROR_MESSAGE, xfmda.*
          FROM     XXMX_FA_MASS_ADDITION_DIST_STG xfmda
          WHERE    1 = 1
          AND      xfmda.migration_set_id = pt_i_MigrationSetID
          AND      xfmda.UNITS IS NULL
		  
		  UNION ALL 
		 /*
        ** Validate if EMAIL is valid.
        */
		  SELECT 'Email address is not valid' as validation_error_message,xfmda.*
			FROM XXMX_FA_MASS_ADDITION_DIST_STG xfmda
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
			and EMPLOYEE_EMAIL_ADDRESS not like '%@%' 
			
		UNION ALL
    /*
     ** Validate if fa mass distribution ID has at least one Fa mass addition ID
     */			
			SELECT 'FA_Mass_Distribution should have a valid Mass_addition_ID' as validation_error_message,xfmda.*
			FROM XXMX_FA_MASS_ADDITION_DIST_STG xfmda
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT MASS_ADDITION_ID,MASSADD_DIST_ID
							 FROM XXMX_FA_MASS_ADDITIONS_STG xfma
							 WHERE 1=1
							 AND xfma.MASS_ADDITION_ID=xfmda.MASS_ADDITION_ID
							 AND  xfma.migration_set_id = pt_i_MigrationSetID
							 GROUP BY MASS_ADDITION_ID,MASSADD_DIST_ID
							 HAVING COUNT(1)>=1
						    );

	 TYPE fa_mass_addition_dist_type IS TABLE OF fa_massadd_dist_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	 fa_mass_addition_dist_tbl  fa_mass_addition_dist_type;

		  --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_FA_MASS_ADDITION_DIST';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_ADDITION_DIST_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_ADDITION_DIST_STG';
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
                    ,pt_i_ModuleMessage     => '  - Inserting Validated data into "'
                                             ||ct_CoreTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
         		 --

		BEGIN		

		EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || ct_CoreTable;

		END;

		OPEN fa_massadd_dist_validations(l_migration_set_id);

		LOOP
         --	 
		 FETCH fa_massadd_dist_validations 
		 BULK COLLECT INTO fa_mass_addition_dist_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN fa_mass_addition_dist_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..fa_mass_addition_dist_tbl.COUNT 

        INSERT INTO XXMX_FA_MASS_ADDITION_DIST_VAL
        (
        VALIDATION_ERROR_MESSAGE
        ,FILE_SET_ID             
        ,MIGRATION_SET_ID        
        ,MIGRATION_SET_NAME      
        ,MIGRATION_STATUS        
        ,OPERATING_UNIT          
        ,LEDGER_NAME             
        ,MASSADD_DIST_ID         
        ,MASS_ADDITION_ID        
        ,INTERFACE_LINE_NUM      
        ,UNITS                   
        ,EMPLOYEE_EMAIL_ADDRESS  
        ,LOCATION_SEGMENT1       
        ,LOCATION_SEGMENT2       
        ,LOCATION_SEGMENT3       
        ,LOCATION_SEGMENT4       
        ,LOCATION_SEGMENT5       
        ,LOCATION_SEGMENT6       
        ,LOCATION_SEGMENT7       
        ,DEPRN_EXPENSE_CCID      
        ,LOCATION_ID             
        ,EMPLOYEE_ID             
        ,LOAD_REQUEST_ID         
        ,CREATION_DATE           
        ,CREATED_BY              
        ,LAST_UPDATE_DATE        
        ,LAST_UPDATED_BY         
        ,LAST_UPDATE_LOGIN       
        ,OBJECT_VERSION_NUMBER   
        ,DEPRN_EXPENSE_SEGMENT1  
        ,DEPRN_EXPENSE_SEGMENT2  
        ,DEPRN_EXPENSE_SEGMENT3  
        ,DEPRN_EXPENSE_SEGMENT4  
        ,DEPRN_EXPENSE_SEGMENT5  
        ,DEPRN_EXPENSE_SEGMENT6  
        ,DEPRN_SOURCE_CODE       
		)
		VALUES 
        (
		 fa_mass_addition_dist_tbl(i).VALIDATION_ERROR_MESSAGE
        ,fa_mass_addition_dist_tbl(i).FILE_SET_ID             
        ,fa_mass_addition_dist_tbl(i).MIGRATION_SET_ID        
        ,fa_mass_addition_dist_tbl(i).MIGRATION_SET_NAME      
        ,'VALIDATED'        
        ,fa_mass_addition_dist_tbl(i).OPERATING_UNIT          
        ,fa_mass_addition_dist_tbl(i).LEDGER_NAME             
        ,fa_mass_addition_dist_tbl(i).MASSADD_DIST_ID         
        ,fa_mass_addition_dist_tbl(i).MASS_ADDITION_ID        
        ,fa_mass_addition_dist_tbl(i).INTERFACE_LINE_NUM      
        ,fa_mass_addition_dist_tbl(i).UNITS                   
        ,fa_mass_addition_dist_tbl(i).EMPLOYEE_EMAIL_ADDRESS  
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT1       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT2       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT3       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT4       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT5       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT6       
        ,fa_mass_addition_dist_tbl(i).LOCATION_SEGMENT7       
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_CCID      
        ,fa_mass_addition_dist_tbl(i).LOCATION_ID             
        ,fa_mass_addition_dist_tbl(i).EMPLOYEE_ID             
        ,fa_mass_addition_dist_tbl(i).LOAD_REQUEST_ID         
        ,fa_mass_addition_dist_tbl(i).CREATION_DATE           
        ,fa_mass_addition_dist_tbl(i).CREATED_BY              
        ,fa_mass_addition_dist_tbl(i).LAST_UPDATE_DATE        
        ,fa_mass_addition_dist_tbl(i).LAST_UPDATED_BY         
        ,fa_mass_addition_dist_tbl(i).LAST_UPDATE_LOGIN       
        ,fa_mass_addition_dist_tbl(i).OBJECT_VERSION_NUMBER   
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT1  
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT2  
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT3  
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT4  
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT5  
        ,fa_mass_addition_dist_tbl(i).DEPRN_EXPENSE_SEGMENT6  
        ,fa_mass_addition_dist_tbl(i).DEPRN_SOURCE_CODE  
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
               CLOSE fa_massadd_dist_validations;
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
                    IF   fa_massadd_dist_validations%ISOPEN
                    THEN
                         --
                         CLOSE fa_massadd_dist_validations;
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
END VALIDATE_FA_MASS_ADDITION_DIST;

    /*
    ******************************
    ** PROCEDURE: VALIDATE_MASSRATES
    ******************************
    */
    PROCEDURE VALIDATE_MASSRATES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR fa_massrates_validations(pt_i_MigrationSetID NUMBER)
        IS

	    /*
        ** Validate if MASS_ADDITION_ID column is null.
        */
          SELECT   'MASS_ADDITION_ID should not be null' as VALIDATION_ERROR_MESSAGE, xfmr.*
          FROM     XXMX_FA_MASS_RATES_STG xfmr
          WHERE    1 = 1
          AND      xfmr.migration_set_id = pt_i_MigrationSetID
          AND      xfmr.MASS_ADDITION_ID IS NULL
		 UNION ALL 
		/*
     ** Validate if fa mass Rates has at least one Fa mass addition ID
     */			
			SELECT 'FA_Mass_Rates should have a valid Mass_addition_ID' as validation_error_message,xfmr.*
			FROM XXMX_FA_MASS_RATES_STG xfmr
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT MASS_ADDITION_ID,ASSET_NUMBER
							 FROM XXMX_FA_MASS_ADDITIONS_STG xfma
							 WHERE 1=1
							 AND xfma.MASS_ADDITION_ID=xfmr.MASS_ADDITION_ID
							 AND  xfma.migration_set_id = pt_i_MigrationSetID
							 GROUP BY MASS_ADDITION_ID,ASSET_NUMBER
							 HAVING COUNT(1)>=1
						    ) ;

       TYPE fa_massrates_type IS TABLE OF fa_massrates_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   fa_massrates_tbl fa_massrates_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_MASSRATES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_RATES_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_FA_MASS_RATES_STG';
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

		OPEN fa_massrates_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH fa_massrates_validations 
		 BULK COLLECT INTO fa_massrates_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN fa_massrates_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..fa_massrates_tbl.COUNT 

        INSERT INTO XXMX_FA_MASS_RATES_VAL
        (
		VALIDATION_ERROR_MESSAGE   
		,FILE_SET_ID               
		,MIGRATION_SET_ID          
		,MIGRATION_SET_NAME        
		,MIGRATION_STATUS          
		,OPERATING_UNIT            
		,LEDGER_NAME               
		,SET_OF_BOOKS_ID           
		,INTERFACE_LINE_NUM        
		,MASS_ADDITION_ID          
		,PARENT_MASS_ADDITION_ID   
		,CURRENCY_CODE             
		,FIXED_ASSETS_COST         
		,EXCHANGE_RATE             
		,LOAD_REQUEST_ID           
		,CREATED_BY                
		,CREATION_DATE             
		,LAST_UPDATED_BY           
		,LAST_UPDATE_DATE          
		,LAST_UPDATE_LOGIN         
		,OBJECT_VERSION_NUMBER  		
        )
        VALUES 
        (
         fa_massrates_tbl(i).VALIDATION_ERROR_MESSAGE   
	    ,fa_massrates_tbl(i).FILE_SET_ID               
	    ,fa_massrates_tbl(i).MIGRATION_SET_ID          
	    ,fa_massrates_tbl(i).MIGRATION_SET_NAME        
	    ,'VALIDATED'          
	    ,fa_massrates_tbl(i).OPERATING_UNIT            
	    ,fa_massrates_tbl(i).LEDGER_NAME               
	    ,fa_massrates_tbl(i).SET_OF_BOOKS_ID           
	    ,fa_massrates_tbl(i).INTERFACE_LINE_NUM        
	    ,fa_massrates_tbl(i).MASS_ADDITION_ID          
	    ,fa_massrates_tbl(i).PARENT_MASS_ADDITION_ID   
	    ,fa_massrates_tbl(i).CURRENCY_CODE             
	    ,fa_massrates_tbl(i).FIXED_ASSETS_COST         
	    ,fa_massrates_tbl(i).EXCHANGE_RATE             
	    ,fa_massrates_tbl(i).LOAD_REQUEST_ID           
	    ,fa_massrates_tbl(i).CREATED_BY                
	    ,fa_massrates_tbl(i).CREATION_DATE             
	    ,fa_massrates_tbl(i).LAST_UPDATED_BY           
	    ,fa_massrates_tbl(i).LAST_UPDATE_DATE          
	    ,fa_massrates_tbl(i).LAST_UPDATE_LOGIN         
	    ,fa_massrates_tbl(i).OBJECT_VERSION_NUMBER         	   
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
               CLOSE fa_massrates_validations;
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
                    IF   fa_massrates_validations%ISOPEN
                    THEN
                         --
                         CLOSE fa_massrates_validations;
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
END VALIDATE_MASSRATES;


 /*
    ******************************
    ** PROCEDURE: VALIDATE_FIXED_ASSETS
    ******************************
    */
    PROCEDURE VALIDATE_FIXED_ASSETS
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
        ct_ProcOrFuncName := 'VALIDATE_FIXED_ASSETS';
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
    END VALIDATE_FIXED_ASSETS;


END XXMX_FA_VALIDATIONS_PKG;