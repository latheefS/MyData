/*
--------------------------------------------------------------------------
CREATION OF THE VALIDATION TABLE FOR XXMX_AR_CASH_RECEIPTS_VAL 
(VALIDATION_ERROR_MESSAGE: New Column added as per the package) 
--------------------------------------------------------------------------
*/

DROP TABLE XXMX_CORE.XXMX_AR_CASH_RECEIPTS_VAL ; 
  --
Create Table XXMX_CORE.XXMX_AR_CASH_RECEIPTS_VAL
(   
	VALIDATION_ERROR_MESSAGE			  VARCHAR2(3000 BYTE)
	,MIGRATION_SET_ID            		  NUMBER        
	,MIGRATION_SET_NAME          		  VARCHAR2(240) 
	,RECORD_TYPE                 		  VARCHAR2(2)   
	,RECORD_SEQ                  		  NUMBER        
	,OPERATING_UNIT_NAME         		  VARCHAR2(240) 
	,BATCH_NAME                           VARCHAR2(25)  
	,ITEM_NUMBER                          NUMBER        
	,REMITTANCE_AMOUNT                    NUMBER        
	,TRANSIT_ROUTING_NUMBER               VARCHAR2(25)  
	,CUSTOMER_BANK_ACCOUNT                VARCHAR2(30)  
	,RECEIPT_NUMBER                       VARCHAR2(30)  
	,RECEIPT_DATE                         DATE          
	,CURRENCY_CODE                        VARCHAR2(15)  
	,EXCHANGE_RATE_TYPE                   VARCHAR2(30)  
	,EXCHANGE_RATE                        NUMBER        
	,CUSTOMER_NUMBER                      VARCHAR2(30)  
	,BILL_TO_LOCATION                     VARCHAR2(40)  
	,CUSTOMER_BANK_BRANCH_NAME            VARCHAR2(320) 
	,CUSTOMER_BANK_NAME                   VARCHAR2(320) 
	,RECEIPT_METHOD                       VARCHAR2(30)  
	,REMITTANCE_BANK_BRANCH_NAME          VARCHAR2(320) 
	,REMITTANCE_BANK_NAME                 VARCHAR2(320) 
	,DEPOSIT_DATE                         DATE          
	,DEPOSIT_TIME                         VARCHAR2(8)   
	,ANTICIPATED_CLEARING_DATE            DATE          
	,INVOICE1                             VARCHAR2(50)  
	,INVOICE1_INSTALLMENT                 NUMBER        
	,MATCHING1_DATE                       DATE          
	,INVOICE_CURRENCY_CODE1               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE1               NUMBER        
	,AMOUNT_APPLIED1                      NUMBER        
	,AMOUNT_APPLIED_FROM1                 NUMBER        
	,CUSTOMER_REFERENCE1                  VARCHAR2(100) 
	,INVOICE2                             VARCHAR2(50)  
	,INVOICE2_INSTALLMENT                 NUMBER        
	,MATCHING2_DATE                       DATE          
	,INVOICE_CURRENCY_CODE2               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE2               NUMBER        
	,AMOUNT_APPLIED2                      NUMBER        
	,AMOUNT_APPLIED_FROM2                 NUMBER        
	,CUSTOMER_REFERENCE2                  VARCHAR2(100) 
	,INVOICE3                             VARCHAR2(50)  
	,INVOICE3_INSTALLMENT                 NUMBER        
	,MATCHING3_DATE                       DATE          
	,INVOICE_CURRENCY_CODE3               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE3               NUMBER        
	,AMOUNT_APPLIED3                      NUMBER        
	,AMOUNT_APPLIED_FROM3                 NUMBER        
	,CUSTOMER_REFERENCE3                  VARCHAR2(100) 
	,INVOICE4                             VARCHAR2(50)  
	,INVOICE4_INSTALLMENT                 NUMBER        
	,MATCHING4_DATE                       DATE          
	,INVOICE_CURRENCY_CODE4               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE4               NUMBER        
	,AMOUNT_APPLIED4                      NUMBER        
	,AMOUNT_APPLIED_FROM4                 NUMBER        
	,CUSTOMER_REFERENCE4                  VARCHAR2(100) 
	,INVOICE5                             VARCHAR2(50)  
	,INVOICE5_INSTALLMENT                 NUMBER        
	,MATCHING5_DATE                       DATE          
	,INVOICE_CURRENCY_CODE5               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE5               NUMBER        
	,AMOUNT_APPLIED5                      NUMBER        
	,AMOUNT_APPLIED_FROM5                 NUMBER        
	,CUSTOMER_REFERENCE5                  VARCHAR2(100) 
	,INVOICE6                             VARCHAR2(50)  
	,INVOICE6_INSTALLMENT                 NUMBER        
	,MATCHING6_DATE                       DATE          
	,INVOICE_CURRENCY_CODE6               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE6               NUMBER        
	,AMOUNT_APPLIED6                      NUMBER        
	,AMOUNT_APPLIED_FROM6                 NUMBER        
	,CUSTOMER_REFERENCE6                  VARCHAR2(100) 
	,INVOICE7                             VARCHAR2(50)  
	,INVOICE7_INSTALLMENT                 NUMBER        
	,MATCHING7_DATE                       DATE          
	,INVOICE_CURRENCY_CODE7               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE7               NUMBER        
	,AMOUNT_APPLIED7                      NUMBER        
	,AMOUNT_APPLIED_FROM7                 NUMBER        
	,CUSTOMER_REFERENCE7                  VARCHAR2(100) 
	,INVOICE8                             VARCHAR2(50)  
	,INVOICE8_INSTALLMENT                 NUMBER        
	,MATCHING8_DATE                       DATE          
	,INVOICE_CURRENCY_CODE8               VARCHAR2(15)  
	,TRANS_TO_RECEIPT_RATE8               NUMBER        
	,AMOUNT_APPLIED8                      NUMBER        
	,AMOUNT_APPLIED_FROM8                 NUMBER        
	,CUSTOMER_REFERENCE8                  VARCHAR2(100) 
	,COMMENTS                             VARCHAR2(240) 
	,ATTRIBUTE1                           VARCHAR2(150) 
	,ATTRIBUTE2                           VARCHAR2(150) 
	,ATTRIBUTE3                           VARCHAR2(150) 
	,ATTRIBUTE4                           VARCHAR2(150) 
	,ATTRIBUTE5                           VARCHAR2(150) 
	,ATTRIBUTE6                           VARCHAR2(150) 
	,ATTRIBUTE7                           VARCHAR2(150) 
	,ATTRIBUTE8                           VARCHAR2(150) 
	,ATTRIBUTE9                           VARCHAR2(150) 
	,ATTRIBUTE10                          VARCHAR2(150) 
	,ATTRIBUTE11                          VARCHAR2(150) 
	,ATTRIBUTE12                          VARCHAR2(150) 
	,ATTRIBUTE13                          VARCHAR2(150) 
	,ATTRIBUTE14                          VARCHAR2(150) 
	,ATTRIBUTE15                          VARCHAR2(150) 
	,ATTRIBUTE_CATEGORY                   VARCHAR2(30)  
	,LOAD_BATCH                           VARCHAR2(300) 
	,MIGRATION_STATUS                     VARCHAR2(150) 
);