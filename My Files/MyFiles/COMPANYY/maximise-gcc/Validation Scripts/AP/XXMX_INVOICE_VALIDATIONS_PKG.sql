create or replace PACKAGE  XXMX_INVOICES_VALIDATIONS_PKG
AS

     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_INVOICES_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_INVOICES_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_INVOICES_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  	  Changed By                 Change Description
     ** -----  ----------- 		 ------------------      	-----------------------------------
     **   1.0  13-02-2024	 	  Harshith JG				 Initial implementation
     ******************************************************************************
     */
    --

    /*
    ******************************
    ** PROCEDURE: VALIDATE_INVOICES 
    ******************************
    */
    PROCEDURE VALIDATE_INVOICES 
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );	
    /*
    ******************************
    ** PROCEDURE: VALIDATE_INVOICE_HEADERS 
    ******************************
    */
    PROCEDURE VALIDATE_INVOICE_HEADERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );
    /*
    ******************************
    ** PROCEDURE: VALIDATE_INVOICE_LINES 
    ******************************
    */
    PROCEDURE VALIDATE_INVOICE_LINES 
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
					
									
END XXMX_INVOICES_VALIDATIONS_PKG;
/


create or replace PACKAGE BODY XXMX_INVOICES_VALIDATIONS_PKG
AS


     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_INVOICES_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Harshith JG
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_INVOICES_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :
	 
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_INVOICES_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date   Changed By          Change Description
     ** -----  -----------   -----------------   -----------------------------------
     **   1.0  13-02-2024	 Harshith JG	     Initial implementation
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_INVOICES_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AP';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'INVOICES';
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
    ** PROCEDURE: VALIDATE_INVOICE_HEADERS 
    ******************************
    */
	PROCEDURE VALIDATE_INVOICE_HEADERS
	(
    pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE,
    pt_i_Application                IN      xxmx_module_messages.application%TYPE,
    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
	)
	IS 
    CURSOR invoice_header_check(pt_i_MigrationSetID NUMBER) IS



	/*
     ** Validate Invoice Records getting duplicated
     */
					
		  select stg1.validation_error_message,stg.*
          FROM xxmx_ap_invoices_stg stg,
          (SELECT   'Duplicate Invoice Records' as validation_error_message, stg.invoice_id,stg.invoice_num,stg.operating_unit,stg.vendor_name,stg.vendor_site_code
          FROM     xxmx_ap_invoices_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          GROUP BY stg.invoice_id,stg.invoice_num,stg.operating_unit,stg.vendor_name,stg.vendor_site_code
          HAVING   COUNT(1) > 1
          )stg1
          WHERE stg.invoice_id=stg1.invoice_id
		  AND   stg.invoice_num=stg1.invoice_num
		  AND	stg.operating_unit=stg1.operating_unit
		  AND	stg.vendor_name=stg1.vendor_name
		  AND	stg.vendor_site_code=stg1.vendor_site_code
      			
	
	/*
     ** Validate Supplier name Not present 
     */
          UNION ALL
          SELECT   'Supplier Name is Not Present' as validation_error_message, stg.*
          FROM     xxmx_ap_invoices_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND   NOT  EXISTS ( SELECT 1
                            FROM   xxmx_ap_suppliers_stg aps
                            WHERE  TRIM(UPPER(stg.vendor_name)) = TRIM(UPPER(aps.supplier_name))) 
                               
	/*
     ** Validate Supplier number Not present 
     */
          UNION ALL
          SELECT   'Supplier Number is Not Present' as validation_error_message, stg.*
          FROM     xxmx_ap_invoices_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND   NOT  EXISTS ( SELECT 1
                            FROM   xxmx_ap_suppliers_stg aps
                            WHERE  stg.vendor_num = aps.supplier_id )			
	

	/*
     ** Validate Supplier Site Not present 
     */
          UNION ALL
          SELECT   'Supplier site is Not Present' as validation_error_message, stg.*
          FROM     xxmx_ap_invoices_stg stg
          WHERE    1 = 1
          AND      migration_set_id = pt_i_MigrationSetID
          AND   NOT  EXISTS ( SELECT 1
                            FROM   xxmx_ap_supplier_sites_stg aps
                            WHERE  stg.vendor_site_code = aps.supplier_site	)					
	
	
	/*
     ** Validate Supplier Name having Junk / Invalid characters
     */	
	 
		UNION ALL	
		SELECT 'Supplier name having Junk/Invalid characters' as validation_error_message, stg.*  
        FROM xxmx_ap_invoices_stg stg
        WHERE 1=1
		AND migration_set_id= pt_i_MigrationSetID
        AND REGEXP_LIKE( vendor_name, '[^[:print:]]' )							
			

	/*
     ** Validate pay site flag is not set to Y
     */
		
		UNION ALL 
		select 'Supplier does not have PAY_SITE_FLAG set to ''Y''' as validation_error_message, stg.*
			FROM xxmx_ap_invoices_stg stg,
			xxmx_ap_supplier_sites_stg apss
			WHERE 1=1
			AND stg.migration_set_id = pt_i_MigrationSetID
            AND apss.supplier_name=stg.vendor_name
			AND  nvl(APSS.PAY,'N') <> 'Y'
			
	/*
     ** Validate vendor site is inactive
     */
	
			UNION ALL
			SELECT 'Supplier Site is inactive' as validation_error_message,xais.*
            FROM xxmx_ap_invoices_stg xais
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND  EXISTS (SELECT 1 FROM xxmx_ap_supplier_sites_stg apss
                            WHERE 1=1
							and  apss.supplier_name=xais.Vendor_name
                            AND  TRUNC(SYSDATE) > TRUNC(NVL(apss.inactive_date,SYSDATE+1))
                            )
	/*
     ** Validate vendor is inactive
     */
	
			UNION ALL
			SELECT 'Supplier is inactive' as validation_error_message,xais.*
            FROM xxmx_ap_invoices_stg xais
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND  EXISTS (SELECT 1 FROM xxmx_ap_suppliers_stg apss
                            WHERE 1=1
							and  apss.supplier_name=xais.Vendor_name
                            AND  TRUNC(SYSDATE) > TRUNC(NVL(apss.inactive_date,SYSDATE+1))
                            )
							
	/*
     ** Validate Invoice Amount according to Invoice Type
     */
        UNION ALL
        SELECT
		CASE 
			WHEN stg.invoice_type_lookup_code = 'STANDARD' AND stg.invoice_amount < 0 THEN 'Amount is mismatching for the Invoice Type-STANDARD'
			WHEN stg.invoice_type_lookup_code = 'CREDIT MEMO' AND stg.invoice_amount > 0 THEN 'Amount is mismatching for the Invoice Type-CREDIT MEMO'
		END AS validation_error_message, 
			stg.*
		FROM     
			xxmx_ap_invoices_stg stg
		WHERE  1=1  
			AND  migration_set_id = pt_i_MigrationSetID
			AND (stg.invoice_type_lookup_code = 'STANDARD' AND stg.invoice_amount < 0 OR stg.invoice_type_lookup_code = 'CREDIT MEMO' AND stg.invoice_amount > 0)
	
	/*
     ** Validate Invoice Amount does not Match with Line Amount
     */

		  UNION ALL
		  SELECT 'AP Invoice Amount does not match with Line Amount' as validation_error_message,stg.*
            FROM  xxmx_ap_invoices_stg stg
				,(SELECT SUM(xais.invoice_amount) amount,xais.invoice_id
				  FROM xxmx_ap_invoices_stg xais,xxmx_ap_invoice_lines_stg xails
                  WHERE xais.invoice_id=xails.invoice_id
				  GROUP  BY xais.invoice_id) xais
				,(SELECT SUM(xails.amount) amount,xails.invoice_id
				  FROM xxmx_ap_invoice_lines_stg xails,xxmx_ap_invoices_stg xais
				  WHERE xais.invoice_id=xails.invoice_id
				  GROUP  BY xails.invoice_id) xails
			WHERE	1=1
				AND 	migration_set_id = pt_i_MigrationSetID
				AND		stg.invoice_id=xais.invoice_id
				AND		stg.invoice_id=xails.invoice_id
				AND		xais.amount <> xails.amount
										
							
	 /*
     ** Validate if AP Header has at least one AP Line
     */								
							
		UNION ALL					
		SELECT 'AP Header should have at least one AP Line' as validation_error_message,ais.*
			FROM xxmx_ap_invoices_stg ais
            WHERE 1=1
           -- AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT apls.invoice_id,apls.line_number
							 FROM xxmx_ap_invoice_lines_stg apls
							 WHERE apls.invoice_id=ais.invoice_id
							 GROUP BY apls.invoice_id,apls.line_number
							 HAVING COUNT(1) >= 1)

	/*
     ** Validate Description is having junk 
     */
		
		UNION ALL	
		SELECT 'Description having Junk/Invalid characters' as validation_error_message, stg.*  
		FROM xxmx_ap_invoices_stg stg
		WHERE 1=1
		AND stg.migration_set_id= pt_i_MigrationSetID
		AND REGEXP_LIKE(description, '[^[:print:]]');
	
		
 TYPE invoice_header_type IS TABLE OF invoice_header_check%ROWTYPE INDEX BY BINARY_INTEGER;
    header_rec_tbl invoice_header_type;
	
	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_INVOICE_HEADERS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_INVOICES_VAL';
        ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_INVOICES_STG';
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

		OPEN invoice_header_check(l_migration_set_id);

		LOOP
--		 
		 FETCH invoice_header_check 
		 BULK COLLECT INTO header_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN header_rec_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';	
		
FORALL i in 1..header_rec_tbl.COUNT

		INSERT INTO XXMX_AP_INVOICES_VAL
        (
			 VALIDATION_ERROR_MESSAGE			
			,MIGRATION_SET_ID				
			,MIGRATION_SET_NAME				
			,MIGRATION_STATUS				
			,INVOICE_ID						
			,OPERATING_UNIT					
			,LEDGER_NAME					
			,INVOICE_NUM					
			,INVOICE_AMOUNT					
			,INVOICE_DATE					
			,VENDOR_NAME					
			,VENDOR_NUM						
			,VENDOR_SITE_CODE				
			,INVOICE_CURRENCY_CODE			
			,PAYMENT_CURRENCY_CODE			
			,DESCRIPTION					
			,INVOICE_TYPE_LOOKUP_CODE		
			,LEGAL_ENTITY_NAME				
			,CUST_REGISTRATION_NUMBER		
			,CUST_REGISTRATION_CODE			
			,FIRST_PARTY_REGISTRATION_NUM	
			,THIRD_PARTY_REGISTRATION_NUM	
			,TERMS_NAME						
			,TERMS_DATE						
			,GOODS_RECEIVED_DATE			
			,INVOICE_RECEIVED_DATE			
			,GL_DATE						
			,PAYMENT_METHOD_CODE			
			,PAY_GROUP_LOOKUP_CODE			
			,EXCLUSIVE_PAYMENT_FLAG			
			,AMOUNT_APPLICABLE_TO_DISCOUNT	
			,PREPAY_NUM						
			,PREPAY_LINE_NUM				
			,PREPAY_APPLY_AMOUNT			
			,PREPAY_GL_DATE					
			,INVOICE_INCLUDES_PREPAY_FLAG	
			,EXCHANGE_RATE_TYPE				
			,EXCHANGE_DATE					
			,EXCHANGE_RATE					
			,ACCTS_PAY_CODE_CONCATENATED	
			,DOC_CATEGORY_CODE				
			,VOUCHER_NUM					
			,REQUESTER_FIRST_NAME			
			,REQUESTER_LAST_NAME			
			,REQUESTER_EMPLOYEE_NUM			
			,DELIVERY_CHANNEL_CODE			
			,BANK_CHARGE_BEARER				
			,REMIT_TO_SUPPLIER_NAME			
			,REMIT_TO_SUPPLIER_NUM			
			,REMIT_TO_ADDRESS_NAME			
			,PAYMENT_PRIORITY				
			,SETTLEMENT_PRIORITY			
			,UNIQUE_REMITTANCE_IDENTIFIER	
			,URI_CHECK_DIGIT				
			,PAYMENT_REASON_CODE			
			,PAYMENT_REASON_COMMENTS		
			,REMITTANCE_MESSAGE1			
			,REMITTANCE_MESSAGE2			
			,REMITTANCE_MESSAGE3			
			,AWT_GROUP_NAME					
			,SHIP_TO_LOCATION				
			,TAXATION_COUNTRY				
			,DOCUMENT_SUB_TYPE				
			,TAX_INVOICE_INTERNAL_SEQ		
			,SUPPLIER_TAX_INVOICE_NUMBER	
			,TAX_INVOICE_RECORDING_DATE		
			,SUPPLIER_TAX_INVOICE_DATE		
			,SUPPLIER_TAX_EXCHANGE_RATE		
			,PORT_OF_ENTRY_CODE				
			,CORRECTION_YEAR				
			,CORRECTION_PERIOD				
			,IMPORT_DOCUMENT_NUMBER			
			,IMPORT_DOCUMENT_DATE			
			,CONTROL_AMOUNT					
			,CALC_TAX_DURING_IMPORT_FLAG	
			,ADD_TAX_TO_INV_AMT_FLAG		
			,IMAGE_DOCUMENT_URI				
			,LOAD_BATCH						
			,EXTERNAL_BANK_ACCOUNT_NUMBER	
			,EXT_BANK_ACCOUNT_IBAN_NUMBER	
			,REQUESTER_EMAIL_ADDRESS		
			,FUSION_BUSINESS_UNIT			

		)
        VALUES 
        (
			 header_rec_tbl(i).VALIDATION_ERROR_MESSAGE			
			,header_rec_tbl(i).MIGRATION_SET_ID				
			,header_rec_tbl(i).MIGRATION_SET_NAME				
			,'VALIDATED'				
			,header_rec_tbl(i).INVOICE_ID						
			,header_rec_tbl(i).OPERATING_UNIT					
			,header_rec_tbl(i).LEDGER_NAME					
			,header_rec_tbl(i).INVOICE_NUM					
			,header_rec_tbl(i).INVOICE_AMOUNT					
			,header_rec_tbl(i).INVOICE_DATE					
			,header_rec_tbl(i).VENDOR_NAME					
			,header_rec_tbl(i).VENDOR_NUM						
			,header_rec_tbl(i).VENDOR_SITE_CODE				
			,header_rec_tbl(i).INVOICE_CURRENCY_CODE			
			,header_rec_tbl(i).PAYMENT_CURRENCY_CODE			
			,header_rec_tbl(i).DESCRIPTION					
			,header_rec_tbl(i).INVOICE_TYPE_LOOKUP_CODE		
			,header_rec_tbl(i).LEGAL_ENTITY_NAME				
			,header_rec_tbl(i).CUST_REGISTRATION_NUMBER		
			,header_rec_tbl(i).CUST_REGISTRATION_CODE			
			,header_rec_tbl(i).FIRST_PARTY_REGISTRATION_NUM	
			,header_rec_tbl(i).THIRD_PARTY_REGISTRATION_NUM	
			,header_rec_tbl(i).TERMS_NAME						
			,header_rec_tbl(i).TERMS_DATE						
			,header_rec_tbl(i).GOODS_RECEIVED_DATE			
			,header_rec_tbl(i).INVOICE_RECEIVED_DATE			
			,header_rec_tbl(i).GL_DATE						
			,header_rec_tbl(i).PAYMENT_METHOD_CODE			
			,header_rec_tbl(i).PAY_GROUP_LOOKUP_CODE			
			,header_rec_tbl(i).EXCLUSIVE_PAYMENT_FLAG			
			,header_rec_tbl(i).AMOUNT_APPLICABLE_TO_DISCOUNT	
			,header_rec_tbl(i).PREPAY_NUM						
			,header_rec_tbl(i).PREPAY_LINE_NUM				
			,header_rec_tbl(i).PREPAY_APPLY_AMOUNT			
			,header_rec_tbl(i).PREPAY_GL_DATE					
			,header_rec_tbl(i).INVOICE_INCLUDES_PREPAY_FLAG	
			,header_rec_tbl(i).EXCHANGE_RATE_TYPE				
			,header_rec_tbl(i).EXCHANGE_DATE					
			,header_rec_tbl(i).EXCHANGE_RATE					
			,header_rec_tbl(i).ACCTS_PAY_CODE_CONCATENATED	
			,header_rec_tbl(i).DOC_CATEGORY_CODE				
			,header_rec_tbl(i).VOUCHER_NUM					
			,header_rec_tbl(i).REQUESTER_FIRST_NAME			
			,header_rec_tbl(i).REQUESTER_LAST_NAME			
			,header_rec_tbl(i).REQUESTER_EMPLOYEE_NUM			
			,header_rec_tbl(i).DELIVERY_CHANNEL_CODE			
			,header_rec_tbl(i).BANK_CHARGE_BEARER				
			,header_rec_tbl(i).REMIT_TO_SUPPLIER_NAME			
			,header_rec_tbl(i).REMIT_TO_SUPPLIER_NUM			
			,header_rec_tbl(i).REMIT_TO_ADDRESS_NAME			
			,header_rec_tbl(i).PAYMENT_PRIORITY				
			,header_rec_tbl(i).SETTLEMENT_PRIORITY			
			,header_rec_tbl(i).UNIQUE_REMITTANCE_IDENTIFIER	
			,header_rec_tbl(i).URI_CHECK_DIGIT				
			,header_rec_tbl(i).PAYMENT_REASON_CODE			
			,header_rec_tbl(i).PAYMENT_REASON_COMMENTS		
			,header_rec_tbl(i).REMITTANCE_MESSAGE1			
			,header_rec_tbl(i).REMITTANCE_MESSAGE2			
			,header_rec_tbl(i).REMITTANCE_MESSAGE3			
			,header_rec_tbl(i).AWT_GROUP_NAME					
			,header_rec_tbl(i).SHIP_TO_LOCATION				
			,header_rec_tbl(i).TAXATION_COUNTRY				
			,header_rec_tbl(i).DOCUMENT_SUB_TYPE				
			,header_rec_tbl(i).TAX_INVOICE_INTERNAL_SEQ		
			,header_rec_tbl(i).SUPPLIER_TAX_INVOICE_NUMBER	
			,header_rec_tbl(i).TAX_INVOICE_RECORDING_DATE		
			,header_rec_tbl(i).SUPPLIER_TAX_INVOICE_DATE		
			,header_rec_tbl(i).SUPPLIER_TAX_EXCHANGE_RATE		
			,header_rec_tbl(i).PORT_OF_ENTRY_CODE				
			,header_rec_tbl(i).CORRECTION_YEAR				
			,header_rec_tbl(i).CORRECTION_PERIOD				
			,header_rec_tbl(i).IMPORT_DOCUMENT_NUMBER			
			,header_rec_tbl(i).IMPORT_DOCUMENT_DATE			
			,header_rec_tbl(i).CONTROL_AMOUNT					
			,header_rec_tbl(i).CALC_TAX_DURING_IMPORT_FLAG	
			,header_rec_tbl(i).ADD_TAX_TO_INV_AMT_FLAG		
			,header_rec_tbl(i).IMAGE_DOCUMENT_URI				
			,header_rec_tbl(i).LOAD_BATCH						
			,header_rec_tbl(i).EXTERNAL_BANK_ACCOUNT_NUMBER	
			,header_rec_tbl(i).EXT_BANK_ACCOUNT_IBAN_NUMBER	
			,header_rec_tbl(i).REQUESTER_EMAIL_ADDRESS		
			,header_rec_tbl(i).FUSION_BUSINESS_UNIT			


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
               CLOSE invoice_header_check;
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
                    IF   invoice_header_check%ISOPEN
                    THEN
                         --
                         CLOSE invoice_header_check;
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
    END VALIDATE_INVOICE_HEADERS;
    

	/*
    ******************************
    ** PROCEDURE: VALIDATE_INVOICE_LINES 
    ******************************
    */
   PROCEDURE VALIDATE_INVOICE_LINES 
    (
    pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE,
    pt_i_Application                IN      xxmx_module_messages.application%TYPE,
    pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
    )
    IS
    CURSOR invoice_lines_check(pt_i_MigrationSetID NUMBER) IS
			
	 /*
     ** Validate if AP Lines has at least one AP Header
     */			
			SELECT 'AP Line should have at least one AP Header' as validation_error_message,apls.*
			FROM xxmx_ap_invoice_lines_stg apls
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT ais.invoice_id,ais.operating_unit
							 FROM xxmx_ap_invoices_stg ais
							 WHERE apls.invoice_id=ais.invoice_id
							 GROUP BY ais.invoice_id,ais.operating_unit
							 HAVING COUNT(1) >= 1) 
	
	 /*
     ** Validate Distribution Combination code is blank
     */		
		UNION ALL		
		SELECT 'Distribution Combination code is null' as validation_error_message, apls.*  
        FROM xxmx_ap_invoice_lines_stg apls
        WHERE 1=1
		AND  migration_set_id= pt_i_MigrationSetID
        AND apls.DIST_CODE_CONCATENATED IS NULL 
		
		
	/*
     ** Validate Description is having junk 
     */
		
		UNION ALL	
		SELECT 'Description having Junk/Invalid characters' as validation_error_message, xails.*  
		FROM xxmx_ap_invoice_lines_stg xails
		WHERE 1=1
		AND xails.migration_set_id= pt_i_MigrationSetID
		AND REGEXP_LIKE(xails.description, '[^[:print:]]');
	
		

          TYPE invoice_lines_type IS TABLE OF invoice_lines_check%ROWTYPE INDEX BY BINARY_INTEGER;
    lines_rec_tbl invoice_lines_type;
	
		 --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_INVOICE_LINES';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_INVOICE_LINES_VAL';
        ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_AP_INVOICE_LINES_STG';
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
		
		OPEN invoice_lines_check(l_migration_set_id);

		LOOP
--		 
		 FETCH invoice_lines_check 
		 BULK COLLECT INTO lines_rec_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN lines_rec_tbl.COUNT=0  ;		
		
				gvv_ProgressIndicator := '0060';
 
FORALL i in 1..lines_rec_tbl.COUNT 

        INSERT INTO XXMX_AP_INVOICE_LINES_VAL
        (
			  VALIDATION_ERROR_MESSAGE			  	
			,MIGRATION_SET_ID                   
			,MIGRATION_SET_NAME                 
			,MIGRATION_STATUS                   
			,INVOICE_ID                         
			,LINE_NUMBER                        
			,LINE_TYPE_LOOKUP_CODE              
			,AMOUNT                             
			,QUANTITY_INVOICED                  
			,UNIT_PRICE                         
			,UNIT_OF_MEAS_LOOKUP_CODE           
			,DESCRIPTION                        
			,PO_NUMBER                          
			,PO_LINE_NUMBER                     
			,PO_SHIPMENT_NUM                    
			,PO_DISTRIBUTION_NUM                
			,ITEM_DESCRIPTION                   
			,RELEASE_NUM                        
			,PURCHASING_CATEGORY                
			,RECEIPT_NUMBER                     
			,RECEIPT_LINE_NUMBER                
			,CONSUMPTION_ADVICE_NUMBER          
			,CONSUMPTION_ADVICE_LINE_NUMBER     
			,PACKING_SLIP                       
			,FINAL_MATCH_FLAG                   
			,DIST_CODE_CONCATENATED             
			,DISTRIBUTION_SET_NAME              
			,ACCOUNTING_DATE                    
			,ACCOUNT_SEGMENT                    
			,BALANCING_SEGMENT                  
			,COST_CENTER_SEGMENT                
			,TAX_CLASSIFICATION_CODE            
			,SHIP_TO_LOCATION_CODE              
			,SHIP_FROM_LOCATION_CODE            
			,FINAL_DISCHARGE_LOCATION_CODE      
			,TRX_BUSINESS_CATEGORY              
			,PRODUCT_FISC_CLASSIFICATION        
			,PRIMARY_INTENDED_USE               
			,USER_DEFINED_FISC_CLASS            
			,PRODUCT_TYPE                       
			,ASSESSABLE_VALUE                   
			,PRODUCT_CATEGORY                   
			,CONTROL_AMOUNT                     
			,TAX_REGIME_CODE                    
			,TAX                                
			,TAX_STATUS_CODE                    
			,TAX_JURISDICTION_CODE              
			,TAX_RATE_CODE                      
			,TAX_RATE                           
			,AWT_GROUP_NAME                     
			,TYPE_1099                          
			,INCOME_TAX_REGION                  
			,PRORATE_ACROSS_FLAG                
			,LINE_GROUP_NUMBER                  
			,COST_FACTOR_NAME                   
			,STAT_AMOUNT                        
			,ASSETS_TRACKING_FLAG               
			,ASSET_BOOK_TYPE_CODE               
			,ASSET_CATEGORY_ID                  
			,SERIAL_NUMBER                      
			,MANUFACTURER                       
			,MODEL_NUMBER                       
			,WARRANTY_NUMBER                    
			,PRICE_CORRECTION_FLAG              
			,PRICE_CORRECT_INV_NUM              
			,PRICE_CORRECT_INV_LINE_NUM         
			,REQUESTER_FIRST_NAME               
			,REQUESTER_LAST_NAME                
			,REQUESTER_EMPLOYEE_NUM             
			,DEF_ACCTG_START_DATE               
			,DEF_ACCTG_END_DATE                 
			,DEF_ACCRUAL_CODE_CONCATENATED      
			,PJC_PROJECT_NAME                   
			,PJC_TASK_NAME                      
			,LOAD_BATCH                         
			,PJC_WORK_TYPE                      
			,PJC_CONTRACT_NAME                  
			,PJC_CONTRACT_NUMBER                
			,PJC_FUNDING_SOURCE_NAME            
			,PJC_FUNDING_SOURCE_NUMBER          
			,REQUESTER_EMAIL_ADDRESS            
			,RCV_TRANSACTION_ID                 

		)
		VALUES 
        (
			 lines_rec_tbl(i).VALIDATION_ERROR_MESSAGE			  	
			,lines_rec_tbl(i).MIGRATION_SET_ID                   
			,lines_rec_tbl(i).MIGRATION_SET_NAME                 
			,'VALIDATED'                  
			,lines_rec_tbl(i).INVOICE_ID                         
			,lines_rec_tbl(i).LINE_NUMBER                        
			,lines_rec_tbl(i).LINE_TYPE_LOOKUP_CODE              
			,lines_rec_tbl(i).AMOUNT                             
			,lines_rec_tbl(i).QUANTITY_INVOICED                  
			,lines_rec_tbl(i).UNIT_PRICE                         
			,lines_rec_tbl(i).UNIT_OF_MEAS_LOOKUP_CODE           
			,lines_rec_tbl(i).DESCRIPTION                        
			,lines_rec_tbl(i).PO_NUMBER                          
			,lines_rec_tbl(i).PO_LINE_NUMBER                     
			,lines_rec_tbl(i).PO_SHIPMENT_NUM                    
			,lines_rec_tbl(i).PO_DISTRIBUTION_NUM                
			,lines_rec_tbl(i).ITEM_DESCRIPTION                   
			,lines_rec_tbl(i).RELEASE_NUM                        
			,lines_rec_tbl(i).PURCHASING_CATEGORY                
			,lines_rec_tbl(i).RECEIPT_NUMBER                     
			,lines_rec_tbl(i).RECEIPT_LINE_NUMBER                
			,lines_rec_tbl(i).CONSUMPTION_ADVICE_NUMBER          
			,lines_rec_tbl(i).CONSUMPTION_ADVICE_LINE_NUMBER     
			,lines_rec_tbl(i).PACKING_SLIP                       
			,lines_rec_tbl(i).FINAL_MATCH_FLAG                   
			,lines_rec_tbl(i).DIST_CODE_CONCATENATED             
			,lines_rec_tbl(i).DISTRIBUTION_SET_NAME              
			,lines_rec_tbl(i).ACCOUNTING_DATE                    
			,lines_rec_tbl(i).ACCOUNT_SEGMENT                    
			,lines_rec_tbl(i).BALANCING_SEGMENT                  
			,lines_rec_tbl(i).COST_CENTER_SEGMENT                
			,lines_rec_tbl(i).TAX_CLASSIFICATION_CODE            
			,lines_rec_tbl(i).SHIP_TO_LOCATION_CODE              
			,lines_rec_tbl(i).SHIP_FROM_LOCATION_CODE            
			,lines_rec_tbl(i).FINAL_DISCHARGE_LOCATION_CODE      
			,lines_rec_tbl(i).TRX_BUSINESS_CATEGORY              
			,lines_rec_tbl(i).PRODUCT_FISC_CLASSIFICATION        
			,lines_rec_tbl(i).PRIMARY_INTENDED_USE               
			,lines_rec_tbl(i).USER_DEFINED_FISC_CLASS            
			,lines_rec_tbl(i).PRODUCT_TYPE                       
			,lines_rec_tbl(i).ASSESSABLE_VALUE                   
			,lines_rec_tbl(i).PRODUCT_CATEGORY                   
			,lines_rec_tbl(i).CONTROL_AMOUNT                     
			,lines_rec_tbl(i).TAX_REGIME_CODE                    
			,lines_rec_tbl(i).TAX                                
			,lines_rec_tbl(i).TAX_STATUS_CODE                    
			,lines_rec_tbl(i).TAX_JURISDICTION_CODE              
			,lines_rec_tbl(i).TAX_RATE_CODE                      
			,lines_rec_tbl(i).TAX_RATE                           
			,lines_rec_tbl(i).AWT_GROUP_NAME                     
			,lines_rec_tbl(i).TYPE_1099                          
			,lines_rec_tbl(i).INCOME_TAX_REGION                  
			,lines_rec_tbl(i).PRORATE_ACROSS_FLAG                
			,lines_rec_tbl(i).LINE_GROUP_NUMBER                  
			,lines_rec_tbl(i).COST_FACTOR_NAME                   
			,lines_rec_tbl(i).STAT_AMOUNT                        
			,lines_rec_tbl(i).ASSETS_TRACKING_FLAG               
			,lines_rec_tbl(i).ASSET_BOOK_TYPE_CODE               
			,lines_rec_tbl(i).ASSET_CATEGORY_ID                  
			,lines_rec_tbl(i).SERIAL_NUMBER                      
			,lines_rec_tbl(i).MANUFACTURER                       
			,lines_rec_tbl(i).MODEL_NUMBER                       
			,lines_rec_tbl(i).WARRANTY_NUMBER                    
			,lines_rec_tbl(i).PRICE_CORRECTION_FLAG              
			,lines_rec_tbl(i).PRICE_CORRECT_INV_NUM              
			,lines_rec_tbl(i).PRICE_CORRECT_INV_LINE_NUM         
			,lines_rec_tbl(i).REQUESTER_FIRST_NAME               
			,lines_rec_tbl(i).REQUESTER_LAST_NAME                
			,lines_rec_tbl(i).REQUESTER_EMPLOYEE_NUM             
			,lines_rec_tbl(i).DEF_ACCTG_START_DATE               
			,lines_rec_tbl(i).DEF_ACCTG_END_DATE                 
			,lines_rec_tbl(i).DEF_ACCRUAL_CODE_CONCATENATED      
			,lines_rec_tbl(i).PJC_PROJECT_NAME                   
			,lines_rec_tbl(i).PJC_TASK_NAME                      
			,lines_rec_tbl(i).LOAD_BATCH                         
			,lines_rec_tbl(i).PJC_WORK_TYPE                      
			,lines_rec_tbl(i).PJC_CONTRACT_NAME                  
			,lines_rec_tbl(i).PJC_CONTRACT_NUMBER                
			,lines_rec_tbl(i).PJC_FUNDING_SOURCE_NAME            
			,lines_rec_tbl(i).PJC_FUNDING_SOURCE_NUMBER          
			,lines_rec_tbl(i).REQUESTER_EMAIL_ADDRESS            
			,lines_rec_tbl(i).RCV_TRANSACTION_ID                 
          
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
		
         CLOSE invoice_lines_check; 
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
                    IF   invoice_lines_check%ISOPEN
                    THEN
                         --
                         CLOSE invoice_lines_check;
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
    END VALIDATE_INVOICE_LINES;
    /*



	/*
    ******************************
    ** PROCEDURE: VALIDATE_INVOICES 
    ******************************
    */

	PROCEDURE VALIDATE_INVOICES
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
                       LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y';
			   
		
gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	
	
    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_INVOICES';
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
    END  VALIDATE_INVOICES;
    --
    --
END XXMX_INVOICES_VALIDATIONS_PKG;
/
