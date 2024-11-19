create or replace PACKAGE  XXMX_AR_INVOICE_VALIDATION_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_AR_INVOICE_VALIDATION_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_AR_INVOICE_VALIDATION_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_AR_INVOICE_VALIDATION_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                         Change Description
     ** -----  -----------  ------------------                 -----------------------------------
     **   1.0  16-02-2024  	Harshith JG						   Initial implementation
     ******************************************************************************
     */
    --

    /*
    ******************************
    ** PROCEDURE: VALIDATE_RECEIVABLES
    ******************************
    */
    PROCEDURE VALIDATE_RECEIVABLES 
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_AR_LINES  
    ******************************
    */
    PROCEDURE VALIDATE_AR_LINES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_AR_DISTRIBUTIONS 
    ******************************
    */
    PROCEDURE VALIDATE_AR_DISTRIBUTIONS 
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
					
									
END XXMX_AR_INVOICE_VALIDATION_PKG;
/


create or replace PACKAGE BODY XXMX_AR_INVOICE_VALIDATION_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_AR_INVOICE_VALIDATION_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_AR_INVOICE_VALIDATION_PKG custom Procedures.
     **
     ** NOTES     :
	 
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_AR_INVOICE_VALIDATION_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                        Change Description
     ** -----  -----------  ------------------                -----------------------------------
     **   1.0  16-02-2024   Harshith JG				  	      Initial implementation, 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_AR_INVOICE_VALIDATION_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'TRANSACTIONS';
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
    ** PROCEDURE: VALIDATE_AR_LINES 
    ******************************
    */
    PROCEDURE VALIDATE_AR_LINES
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
	IS 
		CURSOR ra_lines_check(pt_i_MigrationSetID number)
		IS
	/*
     ** Validate Customer Account Number (ORIG_SYSTEM_BILL_CUSTOMER_REF) is Not present 
     */
        SELECT 'Customer Account Number (ORIG_SYSTEM_BILL_CUSTOMER_REF) is Not present' as validation_error_message, xatl.*
        FROM  XXMX_AR_TRX_LINES_STG xatl
        WHERE 1 = 1
        AND   migration_set_id = pt_i_MigrationSetID
        AND  NOT EXISTS ( SELECT 1
                          FROM   XXMX_HZ_CUST_ACCOUNTS_STG xhca
                          WHERE  xatl.ORIG_SYSTEM_BILL_CUSTOMER_REF = xhca.Account_number)				
	/*
     ** Validate Customer Account Site (ORIG_SYSTEM_BILL_ADDRESS_REF) is Not present 
     */
		UNION ALL
        SELECT 'Customer Account Site (ORIG_SYSTEM_BILL_ADDRESS_REF) is Not present' as validation_error_message, xatl.*
        FROM  XXMX_AR_TRX_LINES_STG xatl
        WHERE 1 = 1
        AND   migration_set_id = pt_i_MigrationSetID
        AND  NOT EXISTS ( SELECT 1
                          FROM   XXMX_HZ_CUST_ACCT_SITES_STG xhcas
                          WHERE  xatl.ORIG_SYSTEM_BILL_ADDRESS_REF = xhcas.CUST_SITE_ORIG_SYS_REF)                           
	/*
     ** Validate when transcation type is manual then trascation number is there are not, if it is not there enter manually  
     */
        UNION ALL	
		SELECT 'Validate transaction number for transcation type-Manual' as validation_error_message, xatl.*  
		FROM XXMX_AR_TRX_LINES_STG xatl
		WHERE 1=1
		AND migration_set_id= pt_i_MigrationSetID
		AND UPPER(cust_trx_type_name) = 'MANUAL' 
		AND trx_number is null
	/*
     ** Validate transcation line quantity should not be zero(0) 
     */  			
		UNION ALL	
		SELECT 'Validate transcation line quantity should not be zero(0)' as validation_error_message, xatl.*  
		FROM XXMX_AR_TRX_LINES_STG xatl
		WHERE 1=1
		AND migration_set_id= pt_i_MigrationSetID
		AND nvl(Quantity,0)=0;	
	TYPE ra_lines_type IS TABLE OF ra_lines_check%ROWTYPE INDEX BY BINARY_INTEGER;
		lines_rec_tbl ra_lines_type;
	
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_AR_LINES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_TRX_LINES_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_TRX_LINES_STG';
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

		OPEN ra_lines_check(l_migration_set_id);

		LOOP
--		 
		 FETCH ra_lines_check 
		 BULK COLLECT INTO lines_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN lines_rec_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';	
		
FORALL i in 1..lines_rec_tbl.COUNT

		INSERT INTO XXMX_AR_TRX_LINES_VAL
        (
		 VALIDATION_ERROR_MESSAGE			
		,FILE_SET_ID                     	
		,MIGRATION_SET_ID                  
		,MIGRATION_SET_NAME                
		,MIGRATION_STATUS                  
		,ROW_SEQ                           
		,XXMX_CUSTOMER_TRX_ID              
		,XXMX_CUSTOMER_TRX_LINE_ID         
		,XXMX_LINE_NUMBER                  
		,OPERATING_UNIT                    
		,ORG_ID                            
		,BATCH_SOURCE_NAME                 
		,CUST_TRX_TYPE_NAME                
		,TERM_NAME                         
		,TRX_DATE                          
		,GL_DATE                           
		,TRX_NUMBER                        
		,ORIG_SYSTEM_BILL_CUSTOMER_REF     
		,ORIG_SYSTEM_BILL_ADDRESS_REF      
		,ORIG_SYSTEM_BILL_CONTACT_REF      
		,ORIG_SYS_SHIP_PARTY_REF           
		,ORIG_SYS_SHIP_PARTY_SITE_REF      
		,ORIG_SYS_SHIP_PTY_CONTACT_REF     
		,ORIG_SYSTEM_SHIP_CUSTOMER_REF     
		,ORIG_SYSTEM_SHIP_ADDRESS_REF      
		,ORIG_SYSTEM_SHIP_CONTACT_REF      
		,ORIG_SYS_SOLD_PARTY_REF           
		,ORIG_SYS_SOLD_CUSTOMER_REF        
		,BILL_CUSTOMER_ACCOUNT_NUMBER      
		,BILL_CUSTOMER_SITE_NUMBER         
		,BILL_CONTACT_PARTY_NUMBER         
		,SHIP_CUSTOMER_ACCOUNT_NUMBER      
		,SHIP_CUSTOMER_SITE_NUMBER         
		,SHIP_CONTACT_PARTY_NUMBER         
		,SOLD_CUSTOMER_ACCOUNT_NUMBER      
		,LINE_TYPE                         
		,DESCRIPTION                       
		,CURRENCY_CODE                     
		,CONVERSION_TYPE                   
		,CONVERSION_DATE                   
		,CONVERSION_RATE                   
		,TRX_LINE_AMOUNT                   
		,QUANTITY                          
		,QUANTITY_ORDERED                  
		,UNIT_SELLING_PRICE                
		,UNIT_STANDARD_PRICE               
		,PRIMARY_SALESREP_NUMBER           
		,TAX_CLASSIFICATION_CODE           
		,LEGAL_ENTITY_IDENTIFIER           
		,ACCT_AMOUNT_IN_LEDGER_CURRENCY    
		,SALES_ORDER_NUMBER                
		,SALES_ORDER_DATE                  
		,ACTUAL_SHIP_DATE                  
		,WAREHOUSE_CODE                    
		,UNIT_OF_MEASURE_CODE              
		,UNIT_OF_MEASURE_NAME              
		,INVOICING_RULE_NAME               
		,REVENUE_SCHEDULING_RULE_NAME      
		,NUMBER_OF_REVENUE_PERIODS         
		,REV_SCHEDULING_RULE_START_DATE    
		,REV_SCHEDULING_RULE_END_DATE      
		,REASON_CODE_MEANING               
		,LAST_PERIOD_TO_CREDIT             
		,TRX_BUSINESS_CATEGORY_CODE        
		,PRODUCT_FISCAL_CLASS_CODE         
		,PRODUCT_CATEGORY_CODE             
		,PRODUCT_TYPE                      
		,LINE_INTENDED_USE_CODE            
		,ASSESSABLE_VALUE                  
		,DOCUMENT_SUB_TYPE                 
		,DEFAULT_TAXATION_COUNTRY          
		,USER_DEFINED_FISCAL_CLASS         
		,TAX_INVOICE_NUMBER                
		,TAX_INVOICE_DATE                  
		,TAX_REGIME_CODE                   
		,TAX                               
		,TAX_STATUS_CODE                   
		,TAX_RATE_CODE                     
		,TAX_JURISDICTION_CODE             
		,FIRST_PARTY_REG_NUMBER            
		,THIRD_PARTY_REG_NUMBER            
		,FINAL_DISCHARGE_LOCATION          
		,TAXABLE_AMOUNT                    
		,TAXABLE_FLAG                      
		,TAX_EXEMPT_FLAG                   
		,TAX_EXEMPT_REASON_CODE            
		,TAX_EXEMPT_REASON_CODE_MEANING    
		,TAX_EXEMPT_CERTIFICATE_NUMBER     
		,LINE_AMOUNT_INCLUDES_TAX_FLAG     
		,TAX_PRECEDENCE                    
		,CREDIT_METHOD_FOR_ACCT_RULE       
		,CREDIT_METHOD_FOR_INSTALLMENTS    
		,REASON_CODE                       
		,TAX_RATE                          
		,FOB_POINT                         
		,SHIP_VIA                          
		,WAYBILL_NUMBER                    
		,SALES_ORDER_LINE_NUMBER           
		,SALES_ORDER_SOURCE                
		,SALES_ORDER_REVISION_NUMBER       
		,PURCHASE_ORDER_NUMBER             
		,PURCHASE_ORDER_REVISION_NUMBER    
		,PURCHASE_ORDER_DATE               
		,AGREEMENT_NAME                    
		,MEMO_LINE_NAME                    
		,DOCUMENT_NUMBER                   
		,ORIG_SYSTEM_BATCH_NAME            
		,RECEIPT_METHOD_NAME               
		,PRINTING_OPTION                   
		,RELATED_BATCH_SOURCE_NAME         
		,RELATED_TRANSACTION_NUMBER        
		,BILL_TO_CUST_BANK_ACCT_NAME       
		,RESET_TRX_DATE_FLAG               
		,PAYMENT_SERVER_ORDER_NUMBER       
		,LAST_TRANS_ON_DEBIT_AUTH          
		,APPROVAL_CODE                     
		,ADDRESS_VERIFICATION_CODE         
		,TRANSLATED_DESCRIPTION            
		,CONSOLIDATED_BILLING_NUMBER       
		,PROMISED_COMMITMENT_AMOUNT        
		,PAYMENT_SET_IDENTIFIER            
		,ORIGINAL_GL_DATE                  
		,INVOICED_LINE_ACCTING_LEVEL       
		,OVERRIDE_AUTO_ACCOUNTING_FLAG     
		,HISTORICAL_FLAG                   
		,DEFERRAL_EXCLUSION_FLAG           
		,PAYMENT_ATTRIBUTES                
		,INVOICE_BILLING_DATE              
		,FREIGHT_CHARGE                    
		,INSURANCE_CHARGE                  
		,PACKING_CHARGE                    
		,MISCELLANEOUS_CHARGE              
		,COMMERCIAL_DISCOUNT               
		,LOAD_BATCH                        	
		)
        VALUES 
        (
		 lines_rec_tbl(i).VALIDATION_ERROR_MESSAGE			
		,lines_rec_tbl(i).FILE_SET_ID                     	
		,lines_rec_tbl(i).MIGRATION_SET_ID                  
		,lines_rec_tbl(i).MIGRATION_SET_NAME                
		,'VALIDATED'                 
		,lines_rec_tbl(i).ROW_SEQ                           
		,lines_rec_tbl(i).XXMX_CUSTOMER_TRX_ID              
		,lines_rec_tbl(i).XXMX_CUSTOMER_TRX_LINE_ID         
		,lines_rec_tbl(i).XXMX_LINE_NUMBER                  
		,lines_rec_tbl(i).OPERATING_UNIT                    
		,lines_rec_tbl(i).ORG_ID                            
		,lines_rec_tbl(i).BATCH_SOURCE_NAME                 
		,lines_rec_tbl(i).CUST_TRX_TYPE_NAME                
		,lines_rec_tbl(i).TERM_NAME                         
		,lines_rec_tbl(i).TRX_DATE                          
		,lines_rec_tbl(i).GL_DATE                           
		,lines_rec_tbl(i).TRX_NUMBER                        
		,lines_rec_tbl(i).ORIG_SYSTEM_BILL_CUSTOMER_REF     
		,lines_rec_tbl(i).ORIG_SYSTEM_BILL_ADDRESS_REF      
		,lines_rec_tbl(i).ORIG_SYSTEM_BILL_CONTACT_REF      
		,lines_rec_tbl(i).ORIG_SYS_SHIP_PARTY_REF           
		,lines_rec_tbl(i).ORIG_SYS_SHIP_PARTY_SITE_REF      
		,lines_rec_tbl(i).ORIG_SYS_SHIP_PTY_CONTACT_REF     
		,lines_rec_tbl(i).ORIG_SYSTEM_SHIP_CUSTOMER_REF     
		,lines_rec_tbl(i).ORIG_SYSTEM_SHIP_ADDRESS_REF      
		,lines_rec_tbl(i).ORIG_SYSTEM_SHIP_CONTACT_REF      
		,lines_rec_tbl(i).ORIG_SYS_SOLD_PARTY_REF           
		,lines_rec_tbl(i).ORIG_SYS_SOLD_CUSTOMER_REF        
		,lines_rec_tbl(i).BILL_CUSTOMER_ACCOUNT_NUMBER      
		,lines_rec_tbl(i).BILL_CUSTOMER_SITE_NUMBER         
		,lines_rec_tbl(i).BILL_CONTACT_PARTY_NUMBER         
		,lines_rec_tbl(i).SHIP_CUSTOMER_ACCOUNT_NUMBER      
		,lines_rec_tbl(i).SHIP_CUSTOMER_SITE_NUMBER         
		,lines_rec_tbl(i).SHIP_CONTACT_PARTY_NUMBER         
		,lines_rec_tbl(i).SOLD_CUSTOMER_ACCOUNT_NUMBER      
		,lines_rec_tbl(i).LINE_TYPE                         
		,lines_rec_tbl(i).DESCRIPTION                       
		,lines_rec_tbl(i).CURRENCY_CODE                     
		,lines_rec_tbl(i).CONVERSION_TYPE                   
		,lines_rec_tbl(i).CONVERSION_DATE                   
		,lines_rec_tbl(i).CONVERSION_RATE                   
		,lines_rec_tbl(i).TRX_LINE_AMOUNT                   
		,lines_rec_tbl(i).QUANTITY                          
		,lines_rec_tbl(i).QUANTITY_ORDERED                  
		,lines_rec_tbl(i).UNIT_SELLING_PRICE                
		,lines_rec_tbl(i).UNIT_STANDARD_PRICE               
		,lines_rec_tbl(i).PRIMARY_SALESREP_NUMBER           
		,lines_rec_tbl(i).TAX_CLASSIFICATION_CODE           
		,lines_rec_tbl(i).LEGAL_ENTITY_IDENTIFIER           
		,lines_rec_tbl(i).ACCT_AMOUNT_IN_LEDGER_CURRENCY    
		,lines_rec_tbl(i).SALES_ORDER_NUMBER                
		,lines_rec_tbl(i).SALES_ORDER_DATE                  
		,lines_rec_tbl(i).ACTUAL_SHIP_DATE                  
		,lines_rec_tbl(i).WAREHOUSE_CODE                    
		,lines_rec_tbl(i).UNIT_OF_MEASURE_CODE              
		,lines_rec_tbl(i).UNIT_OF_MEASURE_NAME              
		,lines_rec_tbl(i).INVOICING_RULE_NAME               
		,lines_rec_tbl(i).REVENUE_SCHEDULING_RULE_NAME      
		,lines_rec_tbl(i).NUMBER_OF_REVENUE_PERIODS         
		,lines_rec_tbl(i).REV_SCHEDULING_RULE_START_DATE    
		,lines_rec_tbl(i).REV_SCHEDULING_RULE_END_DATE      
		,lines_rec_tbl(i).REASON_CODE_MEANING               
		,lines_rec_tbl(i).LAST_PERIOD_TO_CREDIT             
		,lines_rec_tbl(i).TRX_BUSINESS_CATEGORY_CODE        
		,lines_rec_tbl(i).PRODUCT_FISCAL_CLASS_CODE         
		,lines_rec_tbl(i).PRODUCT_CATEGORY_CODE             
		,lines_rec_tbl(i).PRODUCT_TYPE                      
		,lines_rec_tbl(i).LINE_INTENDED_USE_CODE            
		,lines_rec_tbl(i).ASSESSABLE_VALUE                  
		,lines_rec_tbl(i).DOCUMENT_SUB_TYPE                 
		,lines_rec_tbl(i).DEFAULT_TAXATION_COUNTRY          
		,lines_rec_tbl(i).USER_DEFINED_FISCAL_CLASS         
		,lines_rec_tbl(i).TAX_INVOICE_NUMBER                
		,lines_rec_tbl(i).TAX_INVOICE_DATE                  
		,lines_rec_tbl(i).TAX_REGIME_CODE                   
		,lines_rec_tbl(i).TAX                               
		,lines_rec_tbl(i).TAX_STATUS_CODE                   
		,lines_rec_tbl(i).TAX_RATE_CODE                     
		,lines_rec_tbl(i).TAX_JURISDICTION_CODE             
		,lines_rec_tbl(i).FIRST_PARTY_REG_NUMBER            
		,lines_rec_tbl(i).THIRD_PARTY_REG_NUMBER            
		,lines_rec_tbl(i).FINAL_DISCHARGE_LOCATION          
		,lines_rec_tbl(i).TAXABLE_AMOUNT                    
		,lines_rec_tbl(i).TAXABLE_FLAG                      
		,lines_rec_tbl(i).TAX_EXEMPT_FLAG                   
		,lines_rec_tbl(i).TAX_EXEMPT_REASON_CODE            
		,lines_rec_tbl(i).TAX_EXEMPT_REASON_CODE_MEANING    
		,lines_rec_tbl(i).TAX_EXEMPT_CERTIFICATE_NUMBER     
		,lines_rec_tbl(i).LINE_AMOUNT_INCLUDES_TAX_FLAG     
		,lines_rec_tbl(i).TAX_PRECEDENCE                    
		,lines_rec_tbl(i).CREDIT_METHOD_FOR_ACCT_RULE       
		,lines_rec_tbl(i).CREDIT_METHOD_FOR_INSTALLMENTS    
		,lines_rec_tbl(i).REASON_CODE                       
		,lines_rec_tbl(i).TAX_RATE                          
		,lines_rec_tbl(i).FOB_POINT                         
		,lines_rec_tbl(i).SHIP_VIA                          
		,lines_rec_tbl(i).WAYBILL_NUMBER                    
		,lines_rec_tbl(i).SALES_ORDER_LINE_NUMBER           
		,lines_rec_tbl(i).SALES_ORDER_SOURCE                
		,lines_rec_tbl(i).SALES_ORDER_REVISION_NUMBER       
		,lines_rec_tbl(i).PURCHASE_ORDER_NUMBER             
		,lines_rec_tbl(i).PURCHASE_ORDER_REVISION_NUMBER    
		,lines_rec_tbl(i).PURCHASE_ORDER_DATE               
		,lines_rec_tbl(i).AGREEMENT_NAME                    
		,lines_rec_tbl(i).MEMO_LINE_NAME                    
		,lines_rec_tbl(i).DOCUMENT_NUMBER                   
		,lines_rec_tbl(i).ORIG_SYSTEM_BATCH_NAME            
		,lines_rec_tbl(i).RECEIPT_METHOD_NAME               
		,lines_rec_tbl(i).PRINTING_OPTION                   
		,lines_rec_tbl(i).RELATED_BATCH_SOURCE_NAME         
		,lines_rec_tbl(i).RELATED_TRANSACTION_NUMBER        
		,lines_rec_tbl(i).BILL_TO_CUST_BANK_ACCT_NAME       
		,lines_rec_tbl(i).RESET_TRX_DATE_FLAG               
		,lines_rec_tbl(i).PAYMENT_SERVER_ORDER_NUMBER       
		,lines_rec_tbl(i).LAST_TRANS_ON_DEBIT_AUTH          
		,lines_rec_tbl(i).APPROVAL_CODE                     
		,lines_rec_tbl(i).ADDRESS_VERIFICATION_CODE         
		,lines_rec_tbl(i).TRANSLATED_DESCRIPTION            
		,lines_rec_tbl(i).CONSOLIDATED_BILLING_NUMBER       
		,lines_rec_tbl(i).PROMISED_COMMITMENT_AMOUNT        
		,lines_rec_tbl(i).PAYMENT_SET_IDENTIFIER            
		,lines_rec_tbl(i).ORIGINAL_GL_DATE                  
		,lines_rec_tbl(i).INVOICED_LINE_ACCTING_LEVEL       
		,lines_rec_tbl(i).OVERRIDE_AUTO_ACCOUNTING_FLAG     
		,lines_rec_tbl(i).HISTORICAL_FLAG                   
		,lines_rec_tbl(i).DEFERRAL_EXCLUSION_FLAG           
		,lines_rec_tbl(i).PAYMENT_ATTRIBUTES                
		,lines_rec_tbl(i).INVOICE_BILLING_DATE              
		,lines_rec_tbl(i).FREIGHT_CHARGE                    
		,lines_rec_tbl(i).INSURANCE_CHARGE                  
		,lines_rec_tbl(i).PACKING_CHARGE                    
		,lines_rec_tbl(i).MISCELLANEOUS_CHARGE              
		,lines_rec_tbl(i).COMMERCIAL_DISCOUNT               
		,lines_rec_tbl(i).LOAD_BATCH                        	
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
               CLOSE ra_lines_check;
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
                    IF   ra_lines_check%ISOPEN
                    THEN
                         --
                         CLOSE ra_lines_check;
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
    END VALIDATE_AR_LINES;
	/*
    ******************************
    ** PROCEDURE: VALIDATE_AR_DISTRIBUTIONS 
    ******************************
    */
    PROCEDURE VALIDATE_AR_DISTRIBUTIONS 
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
	IS
		
	CURSOR ra_dist_check(pt_i_MigrationSetID number)
	IS 
			
	 /*
     ** Validate concatened segments from Gl code combination table 
     */			
		SELECT   'Distribution Combination Code is null' as validation_error_message, stg.*
          FROM     XXMX_AR_TRX_DISTS_STG stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND   	(SEGMENT1||'-'||SEGMENT2||'-'||SEGMENT3||'-'||SEGMENT4||'-'||SEGMENT5||'-'||SEGMENT6) IS NULL
	
	 --Please change the delimiter present between the segments accordingly & if needed change the number of segments present.
	
	/*
     ** Validate percent is null  
     */	
		UNION ALL
		SELECT   'Percent is null' as validation_error_message, stg.*
          FROM     XXMX_AR_TRX_DISTS_STG stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND   	stg.percent IS NULL;				
	TYPE ra_dist_type IS TABLE OF ra_dist_check%ROWTYPE INDEX BY BINARY_INTEGER;
			dist_rec_tbl ra_dist_type;	
	
		 --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_AR_DISTRIBUTIONS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_TRX_DISTS_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_TRX_DISTS_STG';
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
		
		OPEN ra_dist_check(l_migration_set_id);

		LOOP
--		 
		 FETCH ra_dist_check 
		 BULK COLLECT INTO dist_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN dist_rec_tbl.COUNT=0  ;		
		
				gvv_ProgressIndicator := '0060';
 
FORALL i in 1..dist_rec_tbl.COUNT 

        INSERT INTO XXMX_AR_TRX_DISTS_VAL
        (
		VALIDATION_ERROR_MESSAGE			  
		,FILE_SET_ID                       
		,MIGRATION_SET_ID                  
		,MIGRATION_SET_NAME                
		,MIGRATION_STATUS                  
		,ROW_SEQ                           
		,XXMX_CUSTOMER_TRX_ID              
		,XXMX_CUSTOMER_TRX_LINE_ID         
		,XXMX_CUST_TRX_LINE_GL_DIST_ID     
		,OPERATING_UNIT                    
		,ORG_ID                            
		,LEDGER_NAME                       
		,ACCOUNT_CLASS                     
		,AMOUNT                            
		,PERCENT                           
		,ACCOUNTED_AMT_IN_LEDGER_CURR      
		,SEGMENT1                          
		,SEGMENT2                          
		,SEGMENT3                          
		,SEGMENT4                          
		,SEGMENT5                          
		,SEGMENT6                          
		,SEGMENT7                          
		,SEGMENT8                          
		,SEGMENT9                          
		,SEGMENT10                         
		,COMMENTS                          
		,LOAD_BATCH                  
		)
		VALUES 
        (
		 dist_rec_tbl(i).VALIDATION_ERROR_MESSAGE			  
		,dist_rec_tbl(i).FILE_SET_ID                       
		,dist_rec_tbl(i).MIGRATION_SET_ID                  
		,dist_rec_tbl(i).MIGRATION_SET_NAME                
		,'VALIDATED'                  
		,dist_rec_tbl(i).ROW_SEQ                           
		,dist_rec_tbl(i).XXMX_CUSTOMER_TRX_ID              
		,dist_rec_tbl(i).XXMX_CUSTOMER_TRX_LINE_ID         
		,dist_rec_tbl(i).XXMX_CUST_TRX_LINE_GL_DIST_ID     
		,dist_rec_tbl(i).OPERATING_UNIT                    
		,dist_rec_tbl(i).ORG_ID                            
		,dist_rec_tbl(i).LEDGER_NAME                       
		,dist_rec_tbl(i).ACCOUNT_CLASS                     
		,dist_rec_tbl(i).AMOUNT                            
		,dist_rec_tbl(i).PERCENT                           
		,dist_rec_tbl(i).ACCOUNTED_AMT_IN_LEDGER_CURR      
		,dist_rec_tbl(i).SEGMENT1                          
		,dist_rec_tbl(i).SEGMENT2                          
		,dist_rec_tbl(i).SEGMENT3                          
		,dist_rec_tbl(i).SEGMENT4                          
		,dist_rec_tbl(i).SEGMENT5                          
		,dist_rec_tbl(i).SEGMENT6                          
		,dist_rec_tbl(i).SEGMENT7                          
		,dist_rec_tbl(i).SEGMENT8                          
		,dist_rec_tbl(i).SEGMENT9                          
		,dist_rec_tbl(i).SEGMENT10                         
		,dist_rec_tbl(i).COMMENTS                          
		,dist_rec_tbl(i).LOAD_BATCH  
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

		gvv_ProgressIndicator := '0080';
		
         CLOSE ra_dist_check; 
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
                    IF   ra_dist_check%ISOPEN
                    THEN
                         --
                         CLOSE ra_dist_check;
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
    END VALIDATE_AR_DISTRIBUTIONS;
	/*
    ******************************
    ** PROCEDURE: VALIDATE_RECEIVABLES 
    ******************************
    */

	PROCEDURE VALIDATE_RECEIVABLES
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
			   AND	   xmm.val_package_name IS NOT null
			   ORDER BY xmm.sub_entity_seq;
		
    gvv_SQLStatement        VARCHAR2(32000);
    gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
    gvt_Phase     VARCHAR2(15) := 'VALIDATE';	
	
    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_RECEIVABLES';
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
    END  VALIDATE_RECEIVABLES;
    --
    --
END XXMX_AR_INVOICE_VALIDATION_PKG;
/