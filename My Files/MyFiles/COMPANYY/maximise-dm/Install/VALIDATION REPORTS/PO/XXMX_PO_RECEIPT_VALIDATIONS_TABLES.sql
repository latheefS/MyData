 /*
	 ******************************************************************************
     ** FILENAME  :  XXMX_PO_RECEIPT_VALIDATIONS_TABLES.sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Shruti Choudhury
     **
     ** PURPOSE   :  This script installs the validation tables for Purchase Order Receipt.
     **
     ** NOTES     :

     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** XXMX_PO_RECEIPT_VALIDATIONS_TABLES HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By                              Change Description
     ** -----  -----------  ------------------                      -----------------------------------
     **   1.0  13-02-2024   Shruti Choudhury                        Initial implementation
     ******************************************************************************
     */
    -- 
PROMPT
PROMPT
PROMPT **************************************************************
PROMPT **
PROMPT ** Installing validation tables for Purchase Order Receipt.
PROMPT **
PROMPT **************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Dropping Tables
PROMPT *********************
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_RCPT_HDR_VAL
PROMPT
--
EXEC DropTable ('XXMX_SCM_PO_RCPT_HDR_VAL')
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_PO_RCPT_TXN_VAL
PROMPT
--
EXEC DropTable ('XXMX_SCM_PO_RCPT_TXN_VAL')
--	
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--	
--
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_RCPT_HDR_VAL
(
    VALIDATION_ERROR_MESSAGE            VARCHAR2(150) 
    ,FILE_SET_ID                        VARCHAR2(30)  
    ,MIGRATION_SET_ID                   NUMBER        
    ,MIGRATION_SET_NAME                 VARCHAR2(100) 
    ,MIGRATION_STATUS                   VARCHAR2(50)  
    ,HEADER_INTERFACE_NUMBER            VARCHAR2(30)  
    ,RECEIPT_SOURCE_CODE                VARCHAR2(25)  
    ,ASN_TYPE                           VARCHAR2(25)  
    ,TRANSACTION_TYPE                   VARCHAR2(25)  
    ,NOTICE_CREATION_DATE               DATE          
    ,SHIPMENT_NUMBER                    VARCHAR2(30)  
    ,RECEIPT_NUMBER                     VARCHAR2(30)  
    ,VENDOR_NAME                        VARCHAR2(240) 
    ,VENDOR_NUM                         VARCHAR2(30)  
    ,VENDOR_SITE_CODE                   VARCHAR2(35)  
    ,FROM_ORGANIZATION_CODE             VARCHAR2(18)  
    ,SHIP_TO_ORGANIZATION_CODE          NUMBER        
    ,LOCATION_CODE                      VARCHAR2(60)  
    ,BILL_OF_LADING                     VARCHAR2(25)  
    ,PACKING_SLIP                       VARCHAR2(25)  
    ,SHIPPED_DATE                       DATE          
    ,CARRIER_NAME                       VARCHAR2(25)  
    ,EXPECTED_RECEIPT_DATE              DATE          
    ,NUM_OF_CONTAINERS                  NUMBER        
    ,WAY_BILL_AIRBILL_NUM               VARCHAR2(20)  
    ,COMMENTS                           VARCHAR2(240) 
    ,GROSS_WEIGHT                       NUMBER        
    ,GROSS_WEIGHT_UNIT_OF_MEASURE       VARCHAR2(3)   
    ,NET_WEIGHT                         NUMBER        
    ,NET_WEIGHT_UNIT_OF_MEASURE         VARCHAR2(3)   
    ,TAR_WEIGHT                         NUMBER        
    ,TAR_WEIGHT_UNIT_OF_MEASURE         VARCHAR2(3)   
    ,PACKAGING_CODE                     VARCHAR2(5)   
    ,CARRIER_METHOD                     VARCHAR2(2)   
    ,CARRIER_EQUIPMENT                  VARCHAR2(10)  
    ,SPECIAL_HANDLING_CODE              VARCHAR2(3)   
    ,HAZARD_CODE                        VARCHAR2(1)   
    ,HAZARD_CLASS                       VARCHAR2(4)   
    ,HAZARD_DESCRIPTION                 VARCHAR2(80)  
    ,FREIGHT_TERMS                      VARCHAR2(25)  
    ,FREIGHT_BILL_NUMBER                VARCHAR2(35)  
    ,INVOICE_NUM                        VARCHAR2(30)  
    ,INVOICE_DATE                       DATE          
    ,TOTAL_INVOICE_AMOUNT               NUMBER        
    ,TAX_NAME                           VARCHAR2(15)  
    ,TAX_AMOUNT                         NUMBER        
    ,FREIGHT_AMOUNT                     NUMBER        
    ,CURRENCY_CODE                      VARCHAR2(15)  
    ,CONVERSION_RATE_TYPE               VARCHAR2(30)  
    ,CONVERSION_RATE                    NUMBER        
    ,CONVERSION_RATE_DATE               DATE          
    ,PAYMENT_TERMS_NAME                 VARCHAR2(50)  
    ,EMPLOYEE_NAME                      VARCHAR2(240) 
    ,TRANSACTION_DATE                   DATE          
    ,CUSTOMER_ACCOUNT_NUMBER            NUMBER        
    ,CUSTOMER_PARTY_NAME                VARCHAR2(30)  
    ,CUSTOMER_PARTY_NUMBER              NUMBER        
    ,BUSINESS_UNIT                      VARCHAR2(240) 
    ,RA_OUTSOURCER_PARTY_NAME           VARCHAR2(240) 
    ,RECEIPT_ADVICE_NUMBER              VARCHAR2(80)  
    ,RA_DOCUMENT_CODE                   VARCHAR2(25)  
    ,RA_DOCUMENT_NUMBER                 VARCHAR2(80)  
    ,RA_DOC_REVISION_NUMBER             VARCHAR2(80)  
    ,RA_DOC_REVISION_DATE               DATE          
    ,RA_DOC_CREATION_DATE               DATE          
    ,RA_DOC_LAST_UPDATE_DATE            DATE          
    ,RA_OUTSOURCER_CONTACT_NAME         VARCHAR2(240) 
    ,RA_VENDOR_SITE_NAME                VARCHAR2(240) 
    ,RA_NOTE_TO_RECEIVER                VARCHAR2(480) 
    ,RA_DOO_SOURCE_SYSTEM_NAME          VARCHAR2(80)  
    ,GL_DATE                            DATE          
    ,RECEIPT_HEADER_ID                  NUMBER        
    ,EXTERNAL_SYS_TXN_REFERENCE         VARCHAR2(300) 
    ,EMPLOYEE_ID                        NUMBER        
    ,LOAD_BATCH                         VARCHAR2(300) 
);
--
--
CREATE TABLE XXMX_CORE.XXMX_SCM_PO_RCPT_TXN_VAL 
(
     VALIDATION_ERROR_MESSAGE              VARCHAR2(150) 
     ,FILE_SET_ID                          VARCHAR2(30)       
     ,MIGRATION_SET_ID                     NUMBER             
     ,MIGRATION_SET_NAME                   VARCHAR2(100)      
     ,MIGRATION_STATUS                     VARCHAR2(50)       
     ,INTERFACE_LINE_NUM                   VARCHAR2(30)       
     ,TRANSACTION_TYPE                     VARCHAR2(25)       
     ,AUTO_TRANSACT_CODE                   VARCHAR2(25)       
     ,TRANSACTION_DATE                     DATE               
     ,SOURCE_DOCUMENT_CODE                 VARCHAR2(25)       
     ,RECEIPT_SOURCE_CODE                  VARCHAR2(25)       
     ,HEADER_INTERFACE_NUM                 VARCHAR2(30)       
     ,PARENT_TRANSACTION_ID                NUMBER             
     ,PARENT_INTF_LINE_NUM                 NUMBER             
     ,TO_ORGANIZATION_CODE                 VARCHAR2(18)       
     ,ITEM_NUM                             VARCHAR2(300)      
     ,ITEM_DESCRIPTION                     VARCHAR2(240)      
     ,ITEM_REVISION                        VARCHAR2(18)       
     ,DOCUMENT_NUM                         VARCHAR2(20)       
     ,DOCUMENT_LINE_NUM                    NUMBER             
     ,DOCUMENT_SHIPMENT_LINE_NUM           NUMBER             
     ,DOCUMENT_DISTRIBUTION_NUM            NUMBER             
     ,BUSINESS_UNIT                        VARCHAR2(30)       
     ,SHIPMENT_NUM                         NUMBER             
     ,EXPECTED_RECEIPT_DATE                DATE               
     ,SUBINVENTORY                         VARCHAR2(10)       
     ,LOCATOR                              VARCHAR2(18)       
     ,QUANTITY                             NUMBER             
     ,UNIT_OF_MEASURE                      VARCHAR2(30)       
     ,PRIMARY_QUANTITY                     NUMBER             
     ,PRIMARY_UNIT_OF_MEASURE              VARCHAR2(30)       
     ,SECONDARY_QUANTITY                   NUMBER             
     ,SECONDARY_UNIT_OF_MEASURE            VARCHAR2(3)        
     ,VENDOR_NAME                          VARCHAR2(240)      
     ,VENDOR_NUM                           VARCHAR2(30)       
     ,VENDOR_SITE_CODE                     VARCHAR2(15)       
     ,CUSTOMER_PARTY_NAME                  VARCHAR2(360)      
     ,CUSTOMER_PARTY_NUMBER                VARCHAR2(30)       
     ,CUSTOMER_ACCOUNT_NUMBER              NUMBER             
     ,SHIP_TO_LOCATION_CODE                VARCHAR2(30)       
     ,LOCATION_CODE                        VARCHAR2(60)       
     ,REASON_NAME                          VARCHAR2(30)       
     ,DELIVER_TO_PERSON_NAME               VARCHAR2(240)      
     ,DELIVER_TO_LOCATION_CODE             VARCHAR2(60)       
     ,RECEIPT_EXCEPTION_FLAG               VARCHAR2(1)        
     ,ROUTING_HEADER_ID                    NUMBER             
     ,DESTINATION_TYPE_CODE                VARCHAR2(25)       
     ,INTERFACE_SOURCE_CODE                VARCHAR2(30)       
     ,INTERFACE_SOURCE_LINE_ID             NUMBER             
     ,AMOUNT                               NUMBER             
     ,CURRENCY_CODE                        VARCHAR2(15)       
     ,CURRENCY_CONVERSION_TYPE             VARCHAR2(30)       
     ,CURRENCY_CONVERSION_RATE             NUMBER             
     ,CURRENCY_CONVERSION_DATE             DATE               
     ,INSPECTION_STATUS_CODE               VARCHAR2(25)       
     ,INSPECTION_QUALITY_CODE              VARCHAR2(25)       
     ,FROM_ORGANIZATION_CODE               VARCHAR2(18)       
     ,FROM_SUBINVENTORY                    VARCHAR2(10)       
     ,FROM_LOCATOR                         VARCHAR2(81)       
     ,FREIGHT_CARRIER_NAME                 VARCHAR2(360)      
     ,BILL_OF_LADING                       VARCHAR2(25)       
     ,PACKING_SLIP                         VARCHAR2(25)       
     ,SHIPPED_DATE                         DATE               
     ,NUM_OF_CONTAINERS                    NUMBER             
     ,WAYBILL_AIRBILL_NUM                  VARCHAR2(20)       
     ,RMA_REFERENCE                        VARCHAR2(30)       
     ,COMMENTS                             VARCHAR2(240)      
     ,TRUCK_NUM                            VARCHAR2(35)       
     ,CONTAINER_NUM                        VARCHAR2(35)       
     ,SUBSTITUTE_ITEM_NUM                  VARCHAR2(300)      
     ,NOTICE_UNIT_PRICE                    NUMBER             
     ,ITEM_CATEGORY                        VARCHAR2(81)       
     ,INTRANSIT_OWNING_ORG_CODE            VARCHAR2(18)       
     ,ROUTING_CODE                         VARCHAR2(30)       
     ,BARCODE_LABEL                        VARCHAR2(35)       
     ,COUNTRY_OF_ORIGIN_CODE               VARCHAR2(2)        
     ,CREATE_DEBIT_MEMO_FLAG               VARCHAR2(1)        
     ,LICENSE_PLATE_NUMBER                 NUMBER             
     ,TRANSFER_LICENSE_PLATE_NUMBER        NUMBER             
     ,LPN_GROUP_NUM                        VARCHAR2(30)       
     ,ASN_LINE_NUM                         NUMBER             
     ,EMPLOYEE_NAME                        VARCHAR2(240)      
     ,SOURCE_TRANSACTION_NUM               VARCHAR2(25)       
     ,PARENT_SOURCE_TRANSACTION_NUM        VARCHAR2(25)       
     ,PARENT_INTERFACE_TXN_ID              NUMBER             
     ,MATCHING_BASIS                       VARCHAR2(30)       
     ,RA_OUTSOURCER_PARTY_NAME             VARCHAR2(240)      
     ,RA_DOCUMENT_NUMBER                   VARCHAR2(80)       
     ,RA_DOCUMENT_LINE_NUMBER              VARCHAR2(80)       
     ,RA_NOTE_TO_RECEIVER                  VARCHAR2(480)      
     ,RA_VENDOR_SITE_NAME                  VARCHAR2(240)      
     ,CONSIGNED_FLAG                       VARCHAR2(1)        
     ,SOLDTO_LEGAL_ENTITY                  VARCHAR2(240)      
     ,CONSUMED_QUANTITY                    NUMBER             
     ,DEFAULT_TAXATION_COUNTRY             VARCHAR2(2 CHAR)   
     ,TRX_BUSINESS_CATEGORY                VARCHAR2(240)      
     ,DOCUMENT_FISCAL_CLASSIFICATION       VARCHAR2(240)      
     ,USER_DEFINED_FISC_CLASS              VARCHAR2(30)       
     ,PRODUCT_FISC_CLASS_NAME              VARCHAR2(30)       
     ,INTENDED_USE                         VARCHAR2(240 CHAR) 
     ,PRODUCT_CATEGORY                     VARCHAR2(240 CHAR) 
     ,TAX_CLASSIFICATION_CODE              VARCHAR2(50 CHAR)  
     ,PRODUCT_TYPE                         VARCHAR2(240 CHAR) 
     ,FIRST_PTY_NUMBER                     VARCHAR2(30 CHAR)  
     ,THIRD_PTY_NUMBER                     VARCHAR2(30 CHAR)  
     ,TAX_INVOICE_NUMBER                   VARCHAR2(150 CHAR) 
     ,TAX_INVOICE_DATE                     DATE               
     ,FINAL_DISCHARGE_LOC_CODE             VARCHAR2(60 CHAR)  
     ,ASSESSABLE_VALUE                     NUMBER             
     ,PHYSICAL_RETURN_REQD                 VARCHAR2(1)        
     ,EXTERNAL_SYSTEM_PACKING_UNIT         VARCHAR2(150 CHAR) 
     ,EWAY_BILL_NUMBER                     NUMBER             
     ,EWAY_BILL_DATE                       DATE               
     ,RECALL_NOTICE_NUMBER                 NUMBER             
     ,RECALL_NOTICE_LINE_NUMBER            NUMBER             
     ,EXTERNAL_SYS_TXN_REFERENCE           VARCHAR2(300 CHAR) 
     ,DEFAULT_LOTSER_FROM_ASN              VARCHAR2(1 CHAR)   
     ,EMPLOYEE_ID                          NUMBER             
     ,LOAD_BATCH                           VARCHAR2(300)      
);
--
--