create or replace PACKAGE  XXMX_PO_RCPT_VALIDATIONS_PKG
AS
     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PO_RCPT_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :   Shruti Choudhury
     **
     ** PURPOSE   :  This script installs the package specification for the XXMX_PO_RCPT_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PO_RCPT_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                 Change Description
     ** -----  -----------  ------------------         -----------------------------------
     **   1.0  15-FEB-2024  Shruti Choudhury           Initial implementation
     ******************************************************************************
     */
    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_RCPT_HEADERS
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT_HEADERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );

    --
    /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_RCPT_TRANSACTIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT_TRANSACTIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    );						

    --
	/*
    ******************************
    ** PROCEDURE: VALIDATE_PO_RCPT
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT
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

END XXMX_PO_RCPT_VALIDATIONS_PKG;
/
     /*
    ******************************
    ** PACKAGE BODY
    ******************************
    */
create or replace PACKAGE BODY XXMX_PO_RCPT_VALIDATIONS_PKG
AS
     /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PO_RCPT_VALIDATIONS_PKG.pls
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Shruti Choudhury
     **
     ** PURPOSE   :  This script installs the package body for the XXMX_PO_RCPT_VALIDATIONS_PKG custom Procedures.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PO_RCPT_VALIDATIONS_PKG HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By             Change Description
     ** -----  -----------  ------------------     -----------------------------------
     **   1.0  15-FEB-2024  Shruti Choudhury       Initial implementation
	                                              
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
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_PO_RCPT_VALIDATIONS_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'SCM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'PO';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'PURCHASE_ORDER_RECEIPT';
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
    ** PROCEDURE: VALIDATE_PO_RCPT_HEADERS
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT_HEADERS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR po_receipt_header_validations(pt_i_MigrationSetID number)
        IS
		
	 /*
     ** Validate Supplier name Not present 
     */
            
            SELECT   'Supplier Name is Not Present' as VALIDATION_ERROR_MESSAGE, xsprh.*
            FROM     XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE    1 = 1
            AND      migration_set_id = pt_i_MigrationSetID
            AND NOT  EXISTS ( SELECT 1 FROM   xxmx_ap_suppliers_stg aps
                              WHERE  TRIM(UPPER(xsprh.vendor_name)) = TRIM(UPPER(aps.supplier_name))
							) 
	 /*
     ** Validate if Vendor is inactive
     */     
	        UNION ALL
            SELECT 'Vendor is inactive' as validation_error_message,xsprh.*
            FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1 FROM xxmx_ap_suppliers_stg aps
                            WHERE aps.supplier_name=xsprh.vendor_name
							AND TRUNC(SYSDATE) > TRUNC(NVL(aps.inactive_date,SYSDATE+1))
                           )
      /*
      ** Validate if Vendor Site is inactive
      */ 
			UNION ALL
			SELECT 'Vendor Site is inactive' as validation_error_message,xsprh.*
            FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND   NOT EXISTS (SELECT 1 FROM xxmx_ap_supplier_sites_stg apss
                            WHERE apss.supplier_name=xsprh.vendor_name               
							AND  TRUNC(SYSDATE) > TRUNC(NVL(apss.inactive_date,SYSDATE+1))
                             )
	 /*
     ** Validate if Customer number is not present- As discussed with Functional team this is not a reqiured field for loading 
     
	        UNION ALL	
			SELECT 'Customer number is not present' as validation_error_message,xsprh.*
			FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1
			                from xxmx_hz_parties_stg hps
							 where xsprh.customer_party_number = hps.party_number
							 )			
     */
		--					 
	 /*
     ** Validate if Employee Id is not present
     */
	        UNION ALL
			SELECT 'Employee ID does not exist' as validation_error_message,xsprh.*
			FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1
			                from XXMX_PER_NAMES_F_STG pnf
							 where xsprh.EMPLOYEE_ID  = pnf.person_id
							 )
     /*
     ** Validate if Requestor is an active employee- used to populate receivers name
     */   
	        UNION ALL
	        SELECT 'Requestor is not an active employee' as validation_error_message,xsprh.* 
            FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE 1=1
	        AND xsprh.migration_set_id=pt_i_MigrationSetID
           
            AND NOT EXISTS (SELECT 1 FROM XXMX_PER_NAMES_F_STG
                            WHERE first_name ||', '||last_name = xsprh.EMPLOYEE_NAME
					        )
     /*
     ** Validate if Requestor is an active employee -comparing employee name with requestor in PO
     */  
	        UNION ALL
	        SELECT 'Requestor is not a Deliver to Person in PO' as validation_error_message,xsprh.* 
            FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE 1=1
	        AND migration_set_id=pt_i_MigrationSetID
            
            AND NOT EXISTS (SELECT 1 FROM xxmx_scm_po_distributions_std_stg
                            WHERE DELIVER_TO_PERSON_FULL_NAME = xsprh.EMPLOYEE_NAME
					        )		
	 /*
     ** Validate if POR Header has at least one POR Line
     */	
            UNION ALL	 
			SELECT 'PO Receipt Header should have at least one PO Receipt Line' as validation_error_message,xsprh.*
			FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT HEADER_INTERFACE_NUM,INTERFACE_LINE_NUM
							 FROM XXMX_SCM_PO_RCPT_TXN_STG sprt
							 WHERE sprt.HEADER_INTERFACE_NUM=xsprh.HEADER_INTERFACE_NUMBER
							 GROUP BY HEADER_INTERFACE_NUM,INTERFACE_LINE_NUM
							 HAVING COUNT(1) >= 1
							)
	 /*
     ** Validate if Duplicate records are present
     */							 
			UNION ALL				 
            SELECT dup.VALIDATION_ERROR_MESSAGE,xsprh.*
            FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh,
            (SELECT   'Duplicate Records are present' as VALIDATION_ERROR_MESSAGE,xsprh.HEADER_INTERFACE_NUMBER, xsprh.shipment_number
            FROM     XXMX_SCM_PO_RCPT_HDR_STG xsprh
            WHERE    1 = 1
            AND      migration_set_id = pt_i_MigrationSetID
            GROUP BY xsprh.HEADER_INTERFACE_NUMBER ,xsprh.shipment_number
            HAVING   COUNT(1) > 1
            )dup
            WHERE xsprh.HEADER_INTERFACE_NUMBER=dup.HEADER_INTERFACE_NUMBER;
	 --	    				 
     --
       TYPE po_header_receipt_type IS TABLE OF po_receipt_header_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   po_header_receipt_tbl po_header_receipt_type;

	       --************************
          --** Constant Declarations
          --************************
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_RCPT_HEADERS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_RCPT_HDR_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_RCPT_HDR_STG';
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

		OPEN po_receipt_header_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH po_receipt_header_validations 
		 BULK COLLECT INTO po_header_receipt_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN po_header_receipt_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL I in 1..po_header_receipt_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_RCPT_HDR_VAL
        (
		 VALIDATION_ERROR_MESSAGE				
        ,FILE_SET_ID                       
		,MIGRATION_SET_ID                  
		,MIGRATION_SET_NAME                
		,MIGRATION_STATUS                  
		,HEADER_INTERFACE_NUMBER           
		,RECEIPT_SOURCE_CODE               
		,ASN_TYPE                          
		,TRANSACTION_TYPE                  
		,NOTICE_CREATION_DATE              
		,SHIPMENT_NUMBER                   
		,RECEIPT_NUMBER                    
		,VENDOR_NAME                       
		,VENDOR_NUM                        
		,VENDOR_SITE_CODE                  
		,FROM_ORGANIZATION_CODE            
		,SHIP_TO_ORGANIZATION_CODE         
		,LOCATION_CODE                     
		,BILL_OF_LADING                    
		,PACKING_SLIP                      
		,SHIPPED_DATE                      
		,CARRIER_NAME                      
		,EXPECTED_RECEIPT_DATE             
		,NUM_OF_CONTAINERS                 
		,WAY_BILL_AIRBILL_NUM              
		,COMMENTS                          
		,GROSS_WEIGHT                      
		,GROSS_WEIGHT_UNIT_OF_MEASURE      
		,NET_WEIGHT                        
		,NET_WEIGHT_UNIT_OF_MEASURE        
		,TAR_WEIGHT                        
		,TAR_WEIGHT_UNIT_OF_MEASURE        
		,PACKAGING_CODE                    
		,CARRIER_METHOD                    
		,CARRIER_EQUIPMENT                 
		,SPECIAL_HANDLING_CODE             
		,HAZARD_CODE                       
		,HAZARD_CLASS                      
		,HAZARD_DESCRIPTION                
		,FREIGHT_TERMS                     
		,FREIGHT_BILL_NUMBER               
		,INVOICE_NUM                       
		,INVOICE_DATE                      
		,TOTAL_INVOICE_AMOUNT              
		,TAX_NAME                          
		,TAX_AMOUNT                        
		,FREIGHT_AMOUNT                    
		,CURRENCY_CODE                     
		,CONVERSION_RATE_TYPE              
		,CONVERSION_RATE                   
		,CONVERSION_RATE_DATE              
		,PAYMENT_TERMS_NAME                
		,EMPLOYEE_NAME                     
		,TRANSACTION_DATE                  
		,CUSTOMER_ACCOUNT_NUMBER           
		,CUSTOMER_PARTY_NAME               
		,CUSTOMER_PARTY_NUMBER             
		,BUSINESS_UNIT                     
		,RA_OUTSOURCER_PARTY_NAME          
		,RECEIPT_ADVICE_NUMBER             
		,RA_DOCUMENT_CODE                  
		,RA_DOCUMENT_NUMBER                
		,RA_DOC_REVISION_NUMBER            
		,RA_DOC_REVISION_DATE              
		,RA_DOC_CREATION_DATE              
		,RA_DOC_LAST_UPDATE_DATE           
		,RA_OUTSOURCER_CONTACT_NAME        
		,RA_VENDOR_SITE_NAME               
		,RA_NOTE_TO_RECEIVER               
		,RA_DOO_SOURCE_SYSTEM_NAME         
		,GL_DATE                           
		,RECEIPT_HEADER_ID                 
		,EXTERNAL_SYS_TXN_REFERENCE        
		,EMPLOYEE_ID                       
		,LOAD_BATCH                                                         

        )
        VALUES 
        (
         po_header_receipt_tbl(I).VALIDATION_ERROR_MESSAGE				
        ,po_header_receipt_tbl(I).FILE_SET_ID                       
		,po_header_receipt_tbl(I).MIGRATION_SET_ID                  
		,po_header_receipt_tbl(I).MIGRATION_SET_NAME                
		,'VALIDATED'                 
		,po_header_receipt_tbl(I).HEADER_INTERFACE_NUMBER           
		,po_header_receipt_tbl(I).RECEIPT_SOURCE_CODE               
		,po_header_receipt_tbl(I).ASN_TYPE                          
		,po_header_receipt_tbl(I).TRANSACTION_TYPE                  
		,po_header_receipt_tbl(I).NOTICE_CREATION_DATE              
		,po_header_receipt_tbl(I).SHIPMENT_NUMBER                   
		,po_header_receipt_tbl(I).RECEIPT_NUMBER                    
		,po_header_receipt_tbl(I).VENDOR_NAME                       
		,po_header_receipt_tbl(I).VENDOR_NUM                        
		,po_header_receipt_tbl(I).VENDOR_SITE_CODE                  
		,po_header_receipt_tbl(I).FROM_ORGANIZATION_CODE            
		,po_header_receipt_tbl(I).SHIP_TO_ORGANIZATION_CODE         
		,po_header_receipt_tbl(I).LOCATION_CODE                     
		,po_header_receipt_tbl(I).BILL_OF_LADING                    
		,po_header_receipt_tbl(I).PACKING_SLIP                      
		,po_header_receipt_tbl(I).SHIPPED_DATE                      
		,po_header_receipt_tbl(I).CARRIER_NAME                      
		,po_header_receipt_tbl(I).EXPECTED_RECEIPT_DATE             
		,po_header_receipt_tbl(I).NUM_OF_CONTAINERS                 
		,po_header_receipt_tbl(I).WAY_BILL_AIRBILL_NUM              
		,po_header_receipt_tbl(I).COMMENTS                          
		,po_header_receipt_tbl(I).GROSS_WEIGHT                      
		,po_header_receipt_tbl(I).GROSS_WEIGHT_UNIT_OF_MEASURE      
		,po_header_receipt_tbl(I).NET_WEIGHT                        
		,po_header_receipt_tbl(I).NET_WEIGHT_UNIT_OF_MEASURE        
		,po_header_receipt_tbl(I).TAR_WEIGHT                        
		,po_header_receipt_tbl(I).TAR_WEIGHT_UNIT_OF_MEASURE        
		,po_header_receipt_tbl(I).PACKAGING_CODE                    
		,po_header_receipt_tbl(I).CARRIER_METHOD                    
		,po_header_receipt_tbl(I).CARRIER_EQUIPMENT                 
		,po_header_receipt_tbl(I).SPECIAL_HANDLING_CODE             
		,po_header_receipt_tbl(I).HAZARD_CODE                       
		,po_header_receipt_tbl(I).HAZARD_CLASS                      
		,po_header_receipt_tbl(I).HAZARD_DESCRIPTION                
		,po_header_receipt_tbl(I).FREIGHT_TERMS                     
		,po_header_receipt_tbl(I).FREIGHT_BILL_NUMBER               
		,po_header_receipt_tbl(I).INVOICE_NUM                       
		,po_header_receipt_tbl(I).INVOICE_DATE                      
		,po_header_receipt_tbl(I).TOTAL_INVOICE_AMOUNT              
		,po_header_receipt_tbl(I).TAX_NAME                          
		,po_header_receipt_tbl(I).TAX_AMOUNT                        
		,po_header_receipt_tbl(I).FREIGHT_AMOUNT                    
		,po_header_receipt_tbl(I).CURRENCY_CODE                     
		,po_header_receipt_tbl(I).CONVERSION_RATE_TYPE              
		,po_header_receipt_tbl(I).CONVERSION_RATE                   
		,po_header_receipt_tbl(I).CONVERSION_RATE_DATE              
		,po_header_receipt_tbl(I).PAYMENT_TERMS_NAME                
		,po_header_receipt_tbl(I).EMPLOYEE_NAME                     
		,po_header_receipt_tbl(I).TRANSACTION_DATE                  
		,po_header_receipt_tbl(I).CUSTOMER_ACCOUNT_NUMBER           
		,po_header_receipt_tbl(I).CUSTOMER_PARTY_NAME               
		,po_header_receipt_tbl(I).CUSTOMER_PARTY_NUMBER             
		,po_header_receipt_tbl(I).BUSINESS_UNIT                     
		,po_header_receipt_tbl(I).RA_OUTSOURCER_PARTY_NAME          
		,po_header_receipt_tbl(I).RECEIPT_ADVICE_NUMBER             
		,po_header_receipt_tbl(I).RA_DOCUMENT_CODE                  
		,po_header_receipt_tbl(I).RA_DOCUMENT_NUMBER                
		,po_header_receipt_tbl(I).RA_DOC_REVISION_NUMBER            
		,po_header_receipt_tbl(I).RA_DOC_REVISION_DATE              
		,po_header_receipt_tbl(I).RA_DOC_CREATION_DATE              
		,po_header_receipt_tbl(I).RA_DOC_LAST_UPDATE_DATE           
		,po_header_receipt_tbl(I).RA_OUTSOURCER_CONTACT_NAME        
		,po_header_receipt_tbl(I).RA_VENDOR_SITE_NAME               
		,po_header_receipt_tbl(I).RA_NOTE_TO_RECEIVER               
		,po_header_receipt_tbl(I).RA_DOO_SOURCE_SYSTEM_NAME         
		,po_header_receipt_tbl(I).GL_DATE                           
		,po_header_receipt_tbl(I).RECEIPT_HEADER_ID                 
		,po_header_receipt_tbl(I).EXTERNAL_SYS_TXN_REFERENCE        
		,po_header_receipt_tbl(I).EMPLOYEE_ID                       
		,po_header_receipt_tbl(I).LOAD_BATCH                              
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
               CLOSE po_receipt_header_validations;
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
                    IF   po_receipt_header_validations%ISOPEN
                    THEN
                         --
                         CLOSE po_receipt_header_validations;
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
END VALIDATE_PO_RCPT_HEADERS;


   /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_RCPT_TRANSACTIONS
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT_TRANSACTIONS
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    )
    IS

        CURSOR por_trx_validations(pt_i_MigrationSetID NUMBER)
        IS
	 /*
     ** Validate if shipment numbers in transaction is  present in header.- As discussed with Functional this is not a mandatory check 
  	
			SELECT 'Shipment number is not present in Receipt Header for the corresponding header' as validation_error_message, sprt.*
			FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT 1
							 FROM XXMX_SCM_PO_RCPT_HDR_STG xsprh
							 WHERE sprt.shipment_num = xsprh.shipment_number
                             and sprt.header_interface_num= xsprh.header_interface_number
					        )
	 */
	   --
	 /*
     ** Validate if document number is not present in PO
     */		
	        
			SELECT 'Document number is not present in PO' as validation_error_message, sprt.*
			FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT 1
							 FROM XXMX_SCM_PO_HEADERS_STD_STG xsph
							 WHERE sprt.DOCUMENT_NUM = xsph.DOCUMENT_NUM
							)	
     /*
     ** Validate if POR transaction line has at least one POR header
     */		
            UNION ALL	 
			SELECT 'POR transaction line should have a valid POR header' as validation_error_message,sprt.*
			FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
			WHERE 1=1
			AND  migration_set_id = pt_i_MigrationSetID
			AND NOT EXISTS (SELECT HEADER_INTERFACE_NUMBER
							 FROM XXMX_SCM_PO_RCPT_HDR_STG xsph
							 WHERE 1=1
							 AND sprt.HEADER_INTERFACE_NUM=xsph.HEADER_INTERFACE_NUMBER
							 GROUP BY HEADER_INTERFACE_NUMBER
							 HAVING COUNT(1)>=1
						    )
     /*
     ** Validate Supplier name Not present 
     */
            UNION ALL
            SELECT   'Supplier Name is Not Present' as VALIDATION_ERROR_MESSAGE,  sprt.*
            FROM     XXMX_SCM_PO_RCPT_TXN_STG  sprt
            WHERE    1 = 1
            AND      migration_set_id = pt_i_MigrationSetID
            AND NOT  EXISTS ( SELECT 1 FROM   xxmx_ap_suppliers_stg aps
                              WHERE  TRIM(UPPER( sprt.vendor_name)) = TRIM(UPPER(aps.supplier_name))
							 ) 
	 /*
     ** Validate if Vendor  is inactive
     */     
	        UNION ALL
            SELECT 'Vendor is inactive' as validation_error_message, sprt.*
            FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1 FROM xxmx_ap_suppliers_stg aps
                            WHERE aps.supplier_name= sprt.vendor_name
							AND TRUNC(SYSDATE) > TRUNC(NVL(aps.inactive_date,SYSDATE+1))
                           )
	 /*
     ** Validate if Vendor Site is inactive
     */     			   
			UNION ALL
			SELECT 'Vendor Site is inactive' as validation_error_message,sprt.*
            FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
            WHERE  1=1
			AND  migration_set_id = pt_i_MigrationSetID
            AND   NOT EXISTS (SELECT 1 FROM xxmx_ap_supplier_sites_stg apss
                            WHERE apss.supplier_name=sprt.vendor_name
                            AND  TRUNC(SYSDATE) > TRUNC(NVL(apss.inactive_date,SYSDATE+1))
                              )
	 /*
     ** Validate if deliver to person  is an active employee
     */	 
	        UNION ALL
	        SELECT 'Deliver to Person is an inactive employee' as validation_error_message,sprt.* 
            FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
            WHERE 1=1
	        AND migration_set_id=pt_i_MigrationSetID
            
            AND NOT EXISTS (SELECT 1 FROM XXMX_PER_NAMES_F_STG
                            WHERE sprt.DELIVER_TO_PERSON_NAME = first_name ||', '||last_name
					        );
	 /*
     ** Validate if Customer number is not present- As discussed with functional this is not a mandatory check.
     	
	        UNION ALL	
			SELECT 'Customer number is not present' as validation_error_message,sprt.*
			FROM XXMX_SCM_PO_RCPT_TXN_STG  sprt
            WHERE 1=1
            AND  migration_set_id = pt_i_MigrationSetID
            AND NOT EXISTS (SELECT 1
			                from xxmx_hz_parties_stg hps
							 where sprt.customer_party_number = hps.party_number
							 )	;
      */
	  --
       TYPE por_trx_type IS TABLE OF por_trx_validations%ROWTYPE INDEX BY BINARY_INTEGER;
	   por_trx_tbl por_trx_type;

	       --************************
          --** Constant Declarations
          --************************
          --
        ct_ProcOrFuncName CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'VALIDATE_PO_RCPT_TRANSACTIONS';
		ct_CoreSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_core';
        ct_CoreTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_RCPT_TXN_VAL';
		ct_StgTable                      CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'XXMX_SCM_PO_RCPT_TXN_STG';
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

		OPEN por_trx_validations(l_migration_set_id);

		LOOP
--		 
		 FETCH por_trx_validations 
		 BULK COLLECT INTO por_trx_tbl
		 LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;

		EXIT WHEN por_trx_tbl.COUNT=0  ;

		gvv_ProgressIndicator := '0060';

FORALL i in 1..por_trx_tbl.COUNT 

        INSERT INTO XXMX_SCM_PO_RCPT_TXN_VAL
        (
        VALIDATION_ERROR_MESSAGE         
        ,FILE_SET_ID                      
        ,MIGRATION_SET_ID                 
        ,MIGRATION_SET_NAME               
        ,MIGRATION_STATUS                 
        ,INTERFACE_LINE_NUM               
        ,TRANSACTION_TYPE                 
        ,AUTO_TRANSACT_CODE               
        ,TRANSACTION_DATE                 
        ,SOURCE_DOCUMENT_CODE             
        ,RECEIPT_SOURCE_CODE              
        ,HEADER_INTERFACE_NUM             
        ,PARENT_TRANSACTION_ID            
        ,PARENT_INTF_LINE_NUM             
        ,TO_ORGANIZATION_CODE             
        ,ITEM_NUM                         
        ,ITEM_DESCRIPTION                 
        ,ITEM_REVISION                    
        ,DOCUMENT_NUM                     
        ,DOCUMENT_LINE_NUM                
        ,DOCUMENT_SHIPMENT_LINE_NUM       
        ,DOCUMENT_DISTRIBUTION_NUM        
        ,BUSINESS_UNIT                    
        ,SHIPMENT_NUM                     
        ,EXPECTED_RECEIPT_DATE            
        ,SUBINVENTORY                     
        ,LOCATOR                          
        ,QUANTITY                         
        ,UNIT_OF_MEASURE                  
        ,PRIMARY_QUANTITY                 
        ,PRIMARY_UNIT_OF_MEASURE          
        ,SECONDARY_QUANTITY               
        ,SECONDARY_UNIT_OF_MEASURE        
        ,VENDOR_NAME                      
        ,VENDOR_NUM                       
        ,VENDOR_SITE_CODE                 
        ,CUSTOMER_PARTY_NAME              
        ,CUSTOMER_PARTY_NUMBER            
        ,CUSTOMER_ACCOUNT_NUMBER          
        ,SHIP_TO_LOCATION_CODE            
        ,LOCATION_CODE                    
        ,REASON_NAME                      
        ,DELIVER_TO_PERSON_NAME           
        ,DELIVER_TO_LOCATION_CODE         
        ,RECEIPT_EXCEPTION_FLAG           
        ,ROUTING_HEADER_ID                
        ,DESTINATION_TYPE_CODE            
        ,INTERFACE_SOURCE_CODE            
        ,INTERFACE_SOURCE_LINE_ID         
        ,AMOUNT                           
        ,CURRENCY_CODE                    
        ,CURRENCY_CONVERSION_TYPE         
        ,CURRENCY_CONVERSION_RATE         
        ,CURRENCY_CONVERSION_DATE         
        ,INSPECTION_STATUS_CODE           
        ,INSPECTION_QUALITY_CODE          
        ,FROM_ORGANIZATION_CODE           
        ,FROM_SUBINVENTORY                
        ,FROM_LOCATOR                     
        ,FREIGHT_CARRIER_NAME             
        ,BILL_OF_LADING                   
        ,PACKING_SLIP                     
        ,SHIPPED_DATE                     
        ,NUM_OF_CONTAINERS                
        ,WAYBILL_AIRBILL_NUM              
        ,RMA_REFERENCE                    
        ,COMMENTS                         
        ,TRUCK_NUM                        
        ,CONTAINER_NUM                    
        ,SUBSTITUTE_ITEM_NUM              
        ,NOTICE_UNIT_PRICE                
        ,ITEM_CATEGORY                    
        ,INTRANSIT_OWNING_ORG_CODE        
        ,ROUTING_CODE                     
        ,BARCODE_LABEL                    
        ,COUNTRY_OF_ORIGIN_CODE           
        ,CREATE_DEBIT_MEMO_FLAG           
        ,LICENSE_PLATE_NUMBER             
        ,TRANSFER_LICENSE_PLATE_NUMBER    
        ,LPN_GROUP_NUM                    
        ,ASN_LINE_NUM                     
        ,EMPLOYEE_NAME                    
        ,SOURCE_TRANSACTION_NUM           
        ,PARENT_SOURCE_TRANSACTION_NUM    
        ,PARENT_INTERFACE_TXN_ID          
        ,MATCHING_BASIS                   
        ,RA_OUTSOURCER_PARTY_NAME         
        ,RA_DOCUMENT_NUMBER               
        ,RA_DOCUMENT_LINE_NUMBER          
        ,RA_NOTE_TO_RECEIVER              
        ,RA_VENDOR_SITE_NAME              
        ,CONSIGNED_FLAG                   
        ,SOLDTO_LEGAL_ENTITY              
        ,CONSUMED_QUANTITY                
        ,DEFAULT_TAXATION_COUNTRY         
        ,TRX_BUSINESS_CATEGORY            
        ,DOCUMENT_FISCAL_CLASSIFICATION   
        ,USER_DEFINED_FISC_CLASS          
        ,PRODUCT_FISC_CLASS_NAME          
        ,INTENDED_USE                     
        ,PRODUCT_CATEGORY                 
        ,TAX_CLASSIFICATION_CODE          
        ,PRODUCT_TYPE                     
        ,FIRST_PTY_NUMBER                 
        ,THIRD_PTY_NUMBER                 
        ,TAX_INVOICE_NUMBER               
        ,TAX_INVOICE_DATE                 
        ,FINAL_DISCHARGE_LOC_CODE         
        ,ASSESSABLE_VALUE                 
        ,PHYSICAL_RETURN_REQD             
        ,EXTERNAL_SYSTEM_PACKING_UNIT     
        ,EWAY_BILL_NUMBER                 
        ,EWAY_BILL_DATE                   
        ,RECALL_NOTICE_NUMBER             
        ,RECALL_NOTICE_LINE_NUMBER        
        ,EXTERNAL_SYS_TXN_REFERENCE       
        ,DEFAULT_LOTSER_FROM_ASN          
        ,EMPLOYEE_ID                      
        ,LOAD_BATCH                       
        )
        VALUES 
        (
         por_trx_tbl(i).VALIDATION_ERROR_MESSAGE
		,por_trx_tbl(i).FILE_SET_ID
		,por_trx_tbl(i).MIGRATION_SET_ID
		,por_trx_tbl(i).MIGRATION_SET_NAME
		,'VALIDATED'
		,por_trx_tbl(i).INTERFACE_LINE_NUM               
        ,por_trx_tbl(i).TRANSACTION_TYPE                 
        ,por_trx_tbl(i).AUTO_TRANSACT_CODE               
        ,por_trx_tbl(i).TRANSACTION_DATE                 
        ,por_trx_tbl(i).SOURCE_DOCUMENT_CODE             
        ,por_trx_tbl(i).RECEIPT_SOURCE_CODE              
        ,por_trx_tbl(i).HEADER_INTERFACE_NUM             
        ,por_trx_tbl(i).PARENT_TRANSACTION_ID            
        ,por_trx_tbl(i).PARENT_INTF_LINE_NUM             
        ,por_trx_tbl(i).TO_ORGANIZATION_CODE             
        ,por_trx_tbl(i).ITEM_NUM                         
        ,por_trx_tbl(i).ITEM_DESCRIPTION                 
        ,por_trx_tbl(i).ITEM_REVISION                    
        ,por_trx_tbl(i).DOCUMENT_NUM                     
        ,por_trx_tbl(i).DOCUMENT_LINE_NUM                
        ,por_trx_tbl(i).DOCUMENT_SHIPMENT_LINE_NUM       
        ,por_trx_tbl(i).DOCUMENT_DISTRIBUTION_NUM        
        ,por_trx_tbl(i).BUSINESS_UNIT                    
        ,por_trx_tbl(i).SHIPMENT_NUM                     
        ,por_trx_tbl(i).EXPECTED_RECEIPT_DATE            
        ,por_trx_tbl(i).SUBINVENTORY                     
        ,por_trx_tbl(i).LOCATOR                          
        ,por_trx_tbl(i).QUANTITY                         
        ,por_trx_tbl(i).UNIT_OF_MEASURE                  
        ,por_trx_tbl(i).PRIMARY_QUANTITY                 
        ,por_trx_tbl(i).PRIMARY_UNIT_OF_MEASURE          
        ,por_trx_tbl(i).SECONDARY_QUANTITY               
        ,por_trx_tbl(i).SECONDARY_UNIT_OF_MEASURE        
        ,por_trx_tbl(i).VENDOR_NAME                      
        ,por_trx_tbl(i).VENDOR_NUM                       
        ,por_trx_tbl(i).VENDOR_SITE_CODE                 
        ,por_trx_tbl(i).CUSTOMER_PARTY_NAME              
        ,por_trx_tbl(i).CUSTOMER_PARTY_NUMBER            
        ,por_trx_tbl(i).CUSTOMER_ACCOUNT_NUMBER          
        ,por_trx_tbl(i).SHIP_TO_LOCATION_CODE            
        ,por_trx_tbl(i).LOCATION_CODE                    
        ,por_trx_tbl(i).REASON_NAME                      
        ,por_trx_tbl(i).DELIVER_TO_PERSON_NAME           
        ,por_trx_tbl(i).DELIVER_TO_LOCATION_CODE         
        ,por_trx_tbl(i).RECEIPT_EXCEPTION_FLAG           
        ,por_trx_tbl(i).ROUTING_HEADER_ID                
        ,por_trx_tbl(i).DESTINATION_TYPE_CODE            
        ,por_trx_tbl(i).INTERFACE_SOURCE_CODE            
        ,por_trx_tbl(i).INTERFACE_SOURCE_LINE_ID         
        ,por_trx_tbl(i).AMOUNT                           
        ,por_trx_tbl(i).CURRENCY_CODE                    
        ,por_trx_tbl(i).CURRENCY_CONVERSION_TYPE         
        ,por_trx_tbl(i).CURRENCY_CONVERSION_RATE         
        ,por_trx_tbl(i).CURRENCY_CONVERSION_DATE         
        ,por_trx_tbl(i).INSPECTION_STATUS_CODE           
        ,por_trx_tbl(i).INSPECTION_QUALITY_CODE          
        ,por_trx_tbl(i).FROM_ORGANIZATION_CODE           
        ,por_trx_tbl(i).FROM_SUBINVENTORY                
        ,por_trx_tbl(i).FROM_LOCATOR                     
        ,por_trx_tbl(i).FREIGHT_CARRIER_NAME             
        ,por_trx_tbl(i).BILL_OF_LADING                   
        ,por_trx_tbl(i).PACKING_SLIP                     
        ,por_trx_tbl(i).SHIPPED_DATE                     
        ,por_trx_tbl(i).NUM_OF_CONTAINERS                
        ,por_trx_tbl(i).WAYBILL_AIRBILL_NUM              
        ,por_trx_tbl(i).RMA_REFERENCE                    
        ,por_trx_tbl(i).COMMENTS                         
        ,por_trx_tbl(i).TRUCK_NUM                        
        ,por_trx_tbl(i).CONTAINER_NUM                    
        ,por_trx_tbl(i).SUBSTITUTE_ITEM_NUM              
        ,por_trx_tbl(i).NOTICE_UNIT_PRICE                
        ,por_trx_tbl(i).ITEM_CATEGORY                    
        ,por_trx_tbl(i).INTRANSIT_OWNING_ORG_CODE        
        ,por_trx_tbl(i).ROUTING_CODE                     
        ,por_trx_tbl(i).BARCODE_LABEL                    
        ,por_trx_tbl(i).COUNTRY_OF_ORIGIN_CODE           
        ,por_trx_tbl(i).CREATE_DEBIT_MEMO_FLAG           
        ,por_trx_tbl(i).LICENSE_PLATE_NUMBER             
        ,por_trx_tbl(i).TRANSFER_LICENSE_PLATE_NUMBER    
        ,por_trx_tbl(i).LPN_GROUP_NUM                    
        ,por_trx_tbl(i).ASN_LINE_NUM                     
        ,por_trx_tbl(i).EMPLOYEE_NAME                    
        ,por_trx_tbl(i).SOURCE_TRANSACTION_NUM           
        ,por_trx_tbl(i).PARENT_SOURCE_TRANSACTION_NUM    
        ,por_trx_tbl(i).PARENT_INTERFACE_TXN_ID          
        ,por_trx_tbl(i).MATCHING_BASIS                   
        ,por_trx_tbl(i).RA_OUTSOURCER_PARTY_NAME         
        ,por_trx_tbl(i).RA_DOCUMENT_NUMBER               
        ,por_trx_tbl(i).RA_DOCUMENT_LINE_NUMBER          
        ,por_trx_tbl(i).RA_NOTE_TO_RECEIVER              
        ,por_trx_tbl(i).RA_VENDOR_SITE_NAME              
        ,por_trx_tbl(i).CONSIGNED_FLAG                   
        ,por_trx_tbl(i).SOLDTO_LEGAL_ENTITY              
        ,por_trx_tbl(i).CONSUMED_QUANTITY                
        ,por_trx_tbl(i).DEFAULT_TAXATION_COUNTRY         
        ,por_trx_tbl(i).TRX_BUSINESS_CATEGORY            
        ,por_trx_tbl(i).DOCUMENT_FISCAL_CLASSIFICATION   
        ,por_trx_tbl(i).USER_DEFINED_FISC_CLASS          
        ,por_trx_tbl(i).PRODUCT_FISC_CLASS_NAME          
        ,por_trx_tbl(i).INTENDED_USE                     
        ,por_trx_tbl(i).PRODUCT_CATEGORY                 
        ,por_trx_tbl(i).TAX_CLASSIFICATION_CODE          
        ,por_trx_tbl(i).PRODUCT_TYPE                     
        ,por_trx_tbl(i).FIRST_PTY_NUMBER                 
        ,por_trx_tbl(i).THIRD_PTY_NUMBER                 
        ,por_trx_tbl(i).TAX_INVOICE_NUMBER               
        ,por_trx_tbl(i).TAX_INVOICE_DATE                 
        ,por_trx_tbl(i).FINAL_DISCHARGE_LOC_CODE         
        ,por_trx_tbl(i).ASSESSABLE_VALUE                 
        ,por_trx_tbl(i).PHYSICAL_RETURN_REQD             
        ,por_trx_tbl(i).EXTERNAL_SYSTEM_PACKING_UNIT     
        ,por_trx_tbl(i).EWAY_BILL_NUMBER                 
        ,por_trx_tbl(i).EWAY_BILL_DATE                   
        ,por_trx_tbl(i).RECALL_NOTICE_NUMBER             
        ,por_trx_tbl(i).RECALL_NOTICE_LINE_NUMBER        
        ,por_trx_tbl(i).EXTERNAL_SYS_TXN_REFERENCE       
        ,por_trx_tbl(i).DEFAULT_LOTSER_FROM_ASN          
        ,por_trx_tbl(i).EMPLOYEE_ID                      
        ,por_trx_tbl(i).LOAD_BATCH       
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
               CLOSE por_trx_validations;
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
                    IF   por_trx_validations%ISOPEN
                    THEN
                         --
                         CLOSE por_trx_validations;
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
END VALIDATE_PO_RCPT_TRANSACTIONS;

  

  /*
    ******************************
    ** PROCEDURE: VALIDATE_PO_RCPT
    ******************************
    */
    PROCEDURE VALIDATE_PO_RCPT
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
               SELECT  sub_entity_seq
                      ,LOWER(xmm.val_package_name)      AS val_package_name
                      ,LOWER(xmm.val_procedure_name)        AS val_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
               ORDER BY sub_entity_seq;


gvv_SQLStatement        VARCHAR2(32000);
gcv_SQLSpace  CONSTANT  VARCHAR2(1) := ' ';	
gvt_Phase     VARCHAR2(15) := 'VALIDATE';	

    BEGIN
        ct_ProcOrFuncName := 'VALIDATE_PO_RCPT';
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
    END VALIDATE_PO_RCPT;


END XXMX_PO_RCPT_VALIDATIONS_PKG;
/