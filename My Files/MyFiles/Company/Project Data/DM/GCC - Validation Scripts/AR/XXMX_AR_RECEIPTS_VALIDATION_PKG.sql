CREATE OR REPLACE PACKAGE  XXMX_RECEIPTS_VALIDATION_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_RECEIPTS_VALIDATION_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_RECEIPTS_VALIDATION_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_RECEIPTS_VALIDATION_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                             Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  16-02-2024  	Harshith JG							   Initial implementation
     ******************************************************************************
     */
    --

    /*
    ******************************
    ** PROCEDURE: VALIDATE_RECEIPTS
    ******************************
    */
    PROCEDURE VALIDATE_RECEIPTS 
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_CASH_RECEIPTS  
    ******************************
    */
    PROCEDURE VALIDATE_CASH_RECEIPTS
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
					
									
END XXMX_RECEIPTS_VALIDATION_PKG;
/
--
CREATE OR REPLACE PACKAGE BODY XXMX_RECEIPTS_VALIDATION_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_RECEIPTS_VALIDATION_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_RECEIPTS_VALIDATION_PKG custom Procedures.
     **
     ** NOTES     :
	 
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_RECEIPTS_VALIDATION_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                             Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  16-02-2024   Harshith JG				  			   Initial implementation, 
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_RECEIPTS_VALIDATION_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CASH_RECEIPTS';
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
--   
--  
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
    ** PROCEDURE: VALIDATE_CASH_RECEIPTS 
    ******************************
    */
    PROCEDURE VALIDATE_CASH_RECEIPTS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
	IS 
		CURSOR ra_cash_check(pt_i_MigrationSetID number)
		IS
	/*
     ** Validate receipt Records getting duplicated
     */
          select stg1.validation_error_message,xacr.*
          FROM XXMX_AR_CASH_RECEIPTS_STG xacr,
          (SELECT   'Duplicate receipt Records' as validation_error_message, xacr.RECEIPT_NUMBER,xacr.RECEIPT_DATE,xacr.CUSTOMER_NUMBER,xacr.REMITTANCE_AMOUNT
          FROM     XXMX_AR_CASH_RECEIPTS_STG xacr
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          GROUP BY xacr.RECEIPT_NUMBER,xacr.RECEIPT_DATE,xacr.CUSTOMER_NUMBER,xacr.REMITTANCE_AMOUNT
          HAVING   COUNT(1) > 1
          )stg1
          WHERE xacr.RECEIPT_NUMBER=stg1.RECEIPT_NUMBER
          AND xacr.RECEIPT_DATE=stg1.RECEIPT_DATE
		  AND xacr.CUSTOMER_NUMBER=stg1.CUSTOMER_NUMBER
		  AND xacr.REMITTANCE_AMOUNT=stg1.REMITTANCE_AMOUNT
	/*
     ** Validate CUSTOMER_NUMBER not present
     */
		UNION ALL 
		SELECT 'Customer Account Number (CUSTOMER_NUMBER) is Not present' as validation_error_message, xacr.*
        FROM  XXMX_AR_CASH_RECEIPTS_STG xacr
        WHERE 1 = 1
        AND   migration_set_id = pt_i_MigrationSetID
        AND  NOT EXISTS ( SELECT 1
                          FROM   XXMX_HZ_CUST_ACCOUNTS_STG xhca
                          WHERE  xacr.CUSTOMER_NUMBER = xhca.Account_number)	
	/*
     ** Validate bill to location not present
     */
		UNION ALL
		SELECT 'Bill to Location is Not present' as validation_error_message, xacr.*
        FROM  XXMX_AR_CASH_RECEIPTS_STG xacr
        WHERE 1 = 1
        AND   migration_set_id = pt_i_MigrationSetID
        AND NOT EXISTS ( SELECT 1
                          FROM   xxmx_hz_cust_Site_uses_stg xhcsu
                          WHERE  xacr.BILL_TO_LOCATION = xhcsu.LOCATION
						  AND 	 xhcsu.SITE_USE_CODE ='BILL_TO');	
	--						  
	TYPE ra_cash_type IS TABLE OF ra_cash_check%ROWTYPE INDEX BY BINARY_INTEGER;
		cash_rec_tbl ra_cash_type;
	
	       --************************
          --** Constant Declarations
          --************************
        --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_CASH_RECEIPTS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_CASH_RECEIPTS_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AR_CASH_RECEIPTS_STG';
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

		OPEN ra_cash_check(l_migration_set_id);

		LOOP
--		 
		 FETCH ra_cash_check 
		 BULK COLLECT INTO cash_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN cash_rec_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';	
		
	FORALL i in 1..cash_rec_tbl.COUNT
	--
		INSERT INTO XXMX_AR_CASH_RECEIPTS_VAL
        (
		 VALIDATION_ERROR_MESSAGE		   	      
		,MIGRATION_SET_ID                 	  
		,MIGRATION_SET_NAME          		  
		,RECORD_TYPE                 		  
		,RECORD_SEQ                  		  
		,OPERATING_UNIT_NAME         		  
		,BATCH_NAME                            
		,ITEM_NUMBER                           
		,REMITTANCE_AMOUNT                     
		,TRANSIT_ROUTING_NUMBER                
		,CUSTOMER_BANK_ACCOUNT                 
		,RECEIPT_NUMBER                        
		,RECEIPT_DATE                          
		,CURRENCY_CODE                         
		,EXCHANGE_RATE_TYPE                    
		,EXCHANGE_RATE                         
		,CUSTOMER_NUMBER                       
		,BILL_TO_LOCATION                      
		,CUSTOMER_BANK_BRANCH_NAME             
		,CUSTOMER_BANK_NAME                    
		,RECEIPT_METHOD                        
		,REMITTANCE_BANK_BRANCH_NAME           
		,REMITTANCE_BANK_NAME                  
		,DEPOSIT_DATE                          
		,DEPOSIT_TIME                          
		,ANTICIPATED_CLEARING_DATE             
		,INVOICE1                              
		,INVOICE1_INSTALLMENT                  
		,MATCHING1_DATE                        
		,INVOICE_CURRENCY_CODE1                
		,TRANS_TO_RECEIPT_RATE1                
		,AMOUNT_APPLIED1                       
		,AMOUNT_APPLIED_FROM1                  
		,CUSTOMER_REFERENCE1                   
		,INVOICE2                              
		,INVOICE2_INSTALLMENT                  
		,MATCHING2_DATE                        
		,INVOICE_CURRENCY_CODE2                
		,TRANS_TO_RECEIPT_RATE2                
		,AMOUNT_APPLIED2                       
		,AMOUNT_APPLIED_FROM2                  
		,CUSTOMER_REFERENCE2                   
		,INVOICE3                              
		,INVOICE3_INSTALLMENT                  
		,MATCHING3_DATE                        
		,INVOICE_CURRENCY_CODE3                
		,TRANS_TO_RECEIPT_RATE3                
		,AMOUNT_APPLIED3                       
		,AMOUNT_APPLIED_FROM3                  
		,CUSTOMER_REFERENCE3                   
		,INVOICE4                              
		,INVOICE4_INSTALLMENT                  
		,MATCHING4_DATE                        
		,INVOICE_CURRENCY_CODE4                
		,TRANS_TO_RECEIPT_RATE4                
		,AMOUNT_APPLIED4                       
		,AMOUNT_APPLIED_FROM4                  
		,CUSTOMER_REFERENCE4                   
		,INVOICE5                              
		,INVOICE5_INSTALLMENT                  
		,MATCHING5_DATE                        
		,INVOICE_CURRENCY_CODE5                
		,TRANS_TO_RECEIPT_RATE5                
		,AMOUNT_APPLIED5                       
		,AMOUNT_APPLIED_FROM5                  
		,CUSTOMER_REFERENCE5                   
		,INVOICE6                              
		,INVOICE6_INSTALLMENT                  
		,MATCHING6_DATE                        
		,INVOICE_CURRENCY_CODE6                
		,TRANS_TO_RECEIPT_RATE6                
		,AMOUNT_APPLIED6                       
		,AMOUNT_APPLIED_FROM6                  
		,CUSTOMER_REFERENCE6                   
		,INVOICE7                              
		,INVOICE7_INSTALLMENT                  
		,MATCHING7_DATE                        
		,INVOICE_CURRENCY_CODE7                
		,TRANS_TO_RECEIPT_RATE7                
		,AMOUNT_APPLIED7                       
		,AMOUNT_APPLIED_FROM7                  
		,CUSTOMER_REFERENCE7                   
		,INVOICE8                              
		,INVOICE8_INSTALLMENT                  
		,MATCHING8_DATE                        
		,INVOICE_CURRENCY_CODE8                
		,TRANS_TO_RECEIPT_RATE8                
		,AMOUNT_APPLIED8                       
		,AMOUNT_APPLIED_FROM8                  
		,CUSTOMER_REFERENCE8                   
		,COMMENTS                              
		,ATTRIBUTE1                            
		,ATTRIBUTE2                            
		,ATTRIBUTE3                            
		,ATTRIBUTE4                            
		,ATTRIBUTE5                            
		,ATTRIBUTE6                            
		,ATTRIBUTE7                            
		,ATTRIBUTE8                            
		,ATTRIBUTE9                            
		,ATTRIBUTE10                           
		,ATTRIBUTE11                           
		,ATTRIBUTE12                           
		,ATTRIBUTE13                           
		,ATTRIBUTE14                           
		,ATTRIBUTE15                           
		,ATTRIBUTE_CATEGORY                    
		,LOAD_BATCH  
		,MIGRATION_STATUS		
		)
        VALUES 
        (
		  cash_rec_tbl(i).VALIDATION_ERROR_MESSAGE		   	      
		 ,cash_rec_tbl(i).MIGRATION_SET_ID                 	  
		 ,cash_rec_tbl(i).MIGRATION_SET_NAME          		  
		 ,cash_rec_tbl(i).RECORD_TYPE                 		  
		 ,cash_rec_tbl(i).RECORD_SEQ                  		  
		 ,cash_rec_tbl(i).OPERATING_UNIT_NAME         		  
		 ,cash_rec_tbl(i).BATCH_NAME                            
		 ,cash_rec_tbl(i).ITEM_NUMBER                           
		 ,cash_rec_tbl(i).REMITTANCE_AMOUNT                     
		 ,cash_rec_tbl(i).TRANSIT_ROUTING_NUMBER                
		 ,cash_rec_tbl(i).CUSTOMER_BANK_ACCOUNT                 
		 ,cash_rec_tbl(i).RECEIPT_NUMBER                        
		 ,cash_rec_tbl(i).RECEIPT_DATE                          
		 ,cash_rec_tbl(i).CURRENCY_CODE                         
		 ,cash_rec_tbl(i).EXCHANGE_RATE_TYPE                    
		 ,cash_rec_tbl(i).EXCHANGE_RATE                         
		 ,cash_rec_tbl(i).CUSTOMER_NUMBER                       
		 ,cash_rec_tbl(i).BILL_TO_LOCATION                      
		 ,cash_rec_tbl(i).CUSTOMER_BANK_BRANCH_NAME             
		 ,cash_rec_tbl(i).CUSTOMER_BANK_NAME                    
		 ,cash_rec_tbl(i).RECEIPT_METHOD                        
		 ,cash_rec_tbl(i).REMITTANCE_BANK_BRANCH_NAME           
		 ,cash_rec_tbl(i).REMITTANCE_BANK_NAME                  
		 ,cash_rec_tbl(i).DEPOSIT_DATE                          
		 ,cash_rec_tbl(i).DEPOSIT_TIME                          
		 ,cash_rec_tbl(i).ANTICIPATED_CLEARING_DATE             
		 ,cash_rec_tbl(i).INVOICE1                              
		 ,cash_rec_tbl(i).INVOICE1_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING1_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE1                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE1                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED1                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM1                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE1                   
		 ,cash_rec_tbl(i).INVOICE2                              
		 ,cash_rec_tbl(i).INVOICE2_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING2_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE2                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE2                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED2                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM2                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE2                   
		 ,cash_rec_tbl(i).INVOICE3                              
		 ,cash_rec_tbl(i).INVOICE3_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING3_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE3                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE3                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED3                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM3                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE3                   
		 ,cash_rec_tbl(i).INVOICE4                              
		 ,cash_rec_tbl(i).INVOICE4_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING4_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE4                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE4                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED4                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM4                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE4                   
		 ,cash_rec_tbl(i).INVOICE5                              
		 ,cash_rec_tbl(i).INVOICE5_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING5_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE5                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE5                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED5                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM5                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE5                   
		 ,cash_rec_tbl(i).INVOICE6                              
		 ,cash_rec_tbl(i).INVOICE6_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING6_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE6                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE6                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED6                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM6                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE6                   
		 ,cash_rec_tbl(i).INVOICE7                              
		 ,cash_rec_tbl(i).INVOICE7_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING7_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE7                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE7                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED7                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM7                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE7                   
		 ,cash_rec_tbl(i).INVOICE8                              
		 ,cash_rec_tbl(i).INVOICE8_INSTALLMENT                  
		 ,cash_rec_tbl(i).MATCHING8_DATE                        
		 ,cash_rec_tbl(i).INVOICE_CURRENCY_CODE8                
		 ,cash_rec_tbl(i).TRANS_TO_RECEIPT_RATE8                
		 ,cash_rec_tbl(i).AMOUNT_APPLIED8                       
		 ,cash_rec_tbl(i).AMOUNT_APPLIED_FROM8                  
		 ,cash_rec_tbl(i).CUSTOMER_REFERENCE8                   
		 ,cash_rec_tbl(i).COMMENTS                              
		 ,cash_rec_tbl(i).ATTRIBUTE1                            
		 ,cash_rec_tbl(i).ATTRIBUTE2                            
		 ,cash_rec_tbl(i).ATTRIBUTE3                            
		 ,cash_rec_tbl(i).ATTRIBUTE4                            
		 ,cash_rec_tbl(i).ATTRIBUTE5                            
		 ,cash_rec_tbl(i).ATTRIBUTE6                            
		 ,cash_rec_tbl(i).ATTRIBUTE7                            
		 ,cash_rec_tbl(i).ATTRIBUTE8                            
		 ,cash_rec_tbl(i).ATTRIBUTE9                            
		 ,cash_rec_tbl(i).ATTRIBUTE10                           
		 ,cash_rec_tbl(i).ATTRIBUTE11                           
		 ,cash_rec_tbl(i).ATTRIBUTE12                           
		 ,cash_rec_tbl(i).ATTRIBUTE13                           
		 ,cash_rec_tbl(i).ATTRIBUTE14                           
		 ,cash_rec_tbl(i).ATTRIBUTE15                           
		 ,cash_rec_tbl(i).ATTRIBUTE_CATEGORY                    
		 ,cash_rec_tbl(i).LOAD_BATCH 
		 ,'VALIDATED'
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
               CLOSE ra_cash_check;
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
                    IF   ra_cash_check%ISOPEN
                    THEN
                         --
                         CLOSE ra_cash_check;
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
    END VALIDATE_CASH_RECEIPTS;
	/*
    ******************************
    ** PROCEDURE: VALIDATE_RECEIPTS 
    ******************************
    */

	PROCEDURE VALIDATE_RECEIPTS
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
        ct_ProcOrFuncName := 'VALIDATE_RECEIPTS';
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
    END  VALIDATE_RECEIPTS;
    --
    --
END XXMX_RECEIPTS_VALIDATION_PKG;
/