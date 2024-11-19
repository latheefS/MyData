/*
--------------------------------------------------------------------------
CREATION OF THE VALIDATION TABLE FOR XXMX_AR_TRX_LINES_VAL 
(VALIDATION_ERROR_MESSAGE: New Column added as per the package) 
--------------------------------------------------------------------------
*/

DROP TABLE XXMX_CORE.XXMX_AR_TRX_LINES_VAL ; 
  --
Create Table XXMX_CORE.XXMX_AR_TRX_LINES_VAL
(    
	 VALIDATION_ERROR_MESSAGE			 VARCHAR2(3000 BYTE)
	,FILE_SET_ID                     	 VARCHAR2(30)   
	,MIGRATION_SET_ID                     NUMBER         
	,MIGRATION_SET_NAME                   VARCHAR2(150)  
	,MIGRATION_STATUS                     VARCHAR2(50)   
	,ROW_SEQ                              NUMBER         
	,XXMX_CUSTOMER_TRX_ID                 NUMBER         
	,XXMX_CUSTOMER_TRX_LINE_ID            NUMBER         
	,XXMX_LINE_NUMBER                     NUMBER         
	,OPERATING_UNIT                       VARCHAR2(240)  
	,ORG_ID                               NUMBER         
	,BATCH_SOURCE_NAME                    VARCHAR2(50)   
	,CUST_TRX_TYPE_NAME                   VARCHAR2(20)   
	,TERM_NAME                            VARCHAR2(15)   
	,TRX_DATE                             DATE           
	,GL_DATE                              DATE           
	,TRX_NUMBER                           VARCHAR2(20)   
	,ORIG_SYSTEM_BILL_CUSTOMER_REF        VARCHAR2(240)  
	,ORIG_SYSTEM_BILL_ADDRESS_REF         VARCHAR2(240)  
	,ORIG_SYSTEM_BILL_CONTACT_REF         VARCHAR2(240)  
	,ORIG_SYS_SHIP_PARTY_REF              VARCHAR2(240)  
	,ORIG_SYS_SHIP_PARTY_SITE_REF         VARCHAR2(240)  
	,ORIG_SYS_SHIP_PTY_CONTACT_REF        VARCHAR2(240)  
	,ORIG_SYSTEM_SHIP_CUSTOMER_REF        VARCHAR2(240)  
	,ORIG_SYSTEM_SHIP_ADDRESS_REF         VARCHAR2(240)  
	,ORIG_SYSTEM_SHIP_CONTACT_REF         VARCHAR2(240)  
	,ORIG_SYS_SOLD_PARTY_REF              VARCHAR2(240)  
	,ORIG_SYS_SOLD_CUSTOMER_REF           VARCHAR2(240)  
	,BILL_CUSTOMER_ACCOUNT_NUMBER         VARCHAR2(240)  
	,BILL_CUSTOMER_SITE_NUMBER            VARCHAR2(240)  
	,BILL_CONTACT_PARTY_NUMBER            VARCHAR2(240)  
	,SHIP_CUSTOMER_ACCOUNT_NUMBER         VARCHAR2(240)  
	,SHIP_CUSTOMER_SITE_NUMBER            VARCHAR2(240)  
	,SHIP_CONTACT_PARTY_NUMBER            VARCHAR2(240)  
	,SOLD_CUSTOMER_ACCOUNT_NUMBER         VARCHAR2(240)  
	,LINE_TYPE                            VARCHAR2(20)   
	,DESCRIPTION                          VARCHAR2(240)  
	,CURRENCY_CODE                        VARCHAR2(15)   
	,CONVERSION_TYPE                      VARCHAR2(30)   
	,CONVERSION_DATE                      DATE           
	,CONVERSION_RATE                      NUMBER         
	,TRX_LINE_AMOUNT                      NUMBER         
	,QUANTITY                             NUMBER         
	,QUANTITY_ORDERED                     NUMBER         
	,UNIT_SELLING_PRICE                   NUMBER         
	,UNIT_STANDARD_PRICE                  NUMBER         
	,PRIMARY_SALESREP_NUMBER              VARCHAR2(30)   
	,TAX_CLASSIFICATION_CODE              VARCHAR2(50)   
	,LEGAL_ENTITY_IDENTIFIER              VARCHAR2(30)   
	,ACCT_AMOUNT_IN_LEDGER_CURRENCY       NUMBER         
	,SALES_ORDER_NUMBER                   VARCHAR2(50)   
	,SALES_ORDER_DATE                     DATE           
	,ACTUAL_SHIP_DATE                     DATE           
	,WAREHOUSE_CODE                       VARCHAR2(18)   
	,UNIT_OF_MEASURE_CODE                 VARCHAR2(3)    
	,UNIT_OF_MEASURE_NAME                 VARCHAR2(25)   
	,INVOICING_RULE_NAME                  VARCHAR2(30)   
	,REVENUE_SCHEDULING_RULE_NAME         VARCHAR2(30)   
	,NUMBER_OF_REVENUE_PERIODS            VARCHAR2(18)   
	,REV_SCHEDULING_RULE_START_DATE       DATE           
	,REV_SCHEDULING_RULE_END_DATE         DATE           
	,REASON_CODE_MEANING                  VARCHAR2(80)   
	,LAST_PERIOD_TO_CREDIT                NUMBER         
	,TRX_BUSINESS_CATEGORY_CODE           VARCHAR2(240)  
	,PRODUCT_FISCAL_CLASS_CODE            VARCHAR2(240)  
	,PRODUCT_CATEGORY_CODE                VARCHAR2(240)  
	,PRODUCT_TYPE                         VARCHAR2(240)  
	,LINE_INTENDED_USE_CODE               VARCHAR2(240)  
	,ASSESSABLE_VALUE                     NUMBER         
	,DOCUMENT_SUB_TYPE                    VARCHAR2(240)  
	,DEFAULT_TAXATION_COUNTRY             VARCHAR2(2)    
	,USER_DEFINED_FISCAL_CLASS            VARCHAR2(30)   
	,TAX_INVOICE_NUMBER                   VARCHAR2(150)  
	,TAX_INVOICE_DATE                     DATE           
	,TAX_REGIME_CODE                      VARCHAR2(30)   
	,TAX                                  VARCHAR2(30)   
	,TAX_STATUS_CODE                      VARCHAR2(30)   
	,TAX_RATE_CODE                        VARCHAR2(30)   
	,TAX_JURISDICTION_CODE                VARCHAR2(30)   
	,FIRST_PARTY_REG_NUMBER               VARCHAR2(60)   
	,THIRD_PARTY_REG_NUMBER               VARCHAR2(30)   
	,FINAL_DISCHARGE_LOCATION             VARCHAR2(60)   
	,TAXABLE_AMOUNT                       NUMBER         
	,TAXABLE_FLAG                         VARCHAR2(1)    
	,TAX_EXEMPT_FLAG                      VARCHAR2(1)    
	,TAX_EXEMPT_REASON_CODE               VARCHAR2(30)   
	,TAX_EXEMPT_REASON_CODE_MEANING       VARCHAR2(80)   
	,TAX_EXEMPT_CERTIFICATE_NUMBER        VARCHAR2(80)   
	,LINE_AMOUNT_INCLUDES_TAX_FLAG        VARCHAR2(1)    
	,TAX_PRECEDENCE                       NUMBER         
	,CREDIT_METHOD_FOR_ACCT_RULE          VARCHAR2(30)   
	,CREDIT_METHOD_FOR_INSTALLMENTS       VARCHAR2(30)   
	,REASON_CODE                          VARCHAR2(30)   
	,TAX_RATE                             NUMBER         
	,FOB_POINT                            VARCHAR2(30)   
	,SHIP_VIA                             VARCHAR2(25)   
	,WAYBILL_NUMBER                       VARCHAR2(50)   
	,SALES_ORDER_LINE_NUMBER              VARCHAR2(30)   
	,SALES_ORDER_SOURCE                   VARCHAR2(50)   
	,SALES_ORDER_REVISION_NUMBER          NUMBER         
	,PURCHASE_ORDER_NUMBER                VARCHAR2(50)   
	,PURCHASE_ORDER_REVISION_NUMBER       VARCHAR2(50)   
	,PURCHASE_ORDER_DATE                  DATE           
	,AGREEMENT_NAME                       VARCHAR2(30)   
	,MEMO_LINE_NAME                       VARCHAR2(50)   
	,DOCUMENT_NUMBER                      NUMBER         
	,ORIG_SYSTEM_BATCH_NAME               VARCHAR2(40)     
	,RECEIPT_METHOD_NAME                  VARCHAR2(30)   
	,PRINTING_OPTION                      VARCHAR2(20)   
	,RELATED_BATCH_SOURCE_NAME            VARCHAR2(50)   
	,RELATED_TRANSACTION_NUMBER           VARCHAR2(20)   
	,BILL_TO_CUST_BANK_ACCT_NAME          VARCHAR2(80)   
	,RESET_TRX_DATE_FLAG                  VARCHAR2(1)    
	,PAYMENT_SERVER_ORDER_NUMBER          VARCHAR2(80)   
	,LAST_TRANS_ON_DEBIT_AUTH             VARCHAR2(1)    
	,APPROVAL_CODE                        VARCHAR2(80)   
	,ADDRESS_VERIFICATION_CODE            VARCHAR2(80)   
	,TRANSLATED_DESCRIPTION               VARCHAR2(1000) 
	,CONSOLIDATED_BILLING_NUMBER          VARCHAR2(30)   
	,PROMISED_COMMITMENT_AMOUNT           NUMBER         
	,PAYMENT_SET_IDENTIFIER               NUMBER         
	,ORIGINAL_GL_DATE                     DATE           
	,INVOICED_LINE_ACCTING_LEVEL          VARCHAR2(15)   
	,OVERRIDE_AUTO_ACCOUNTING_FLAG        VARCHAR2(1)    
	,HISTORICAL_FLAG                      VARCHAR2(1)    
	,DEFERRAL_EXCLUSION_FLAG              VARCHAR2(1)    
	,PAYMENT_ATTRIBUTES                   VARCHAR2(1000) 
	,INVOICE_BILLING_DATE                 DATE           
	,FREIGHT_CHARGE                       NUMBER         
	,INSURANCE_CHARGE                     NUMBER         
	,PACKING_CHARGE                       NUMBER         
	,MISCELLANEOUS_CHARGE                 NUMBER         
	,COMMERCIAL_DISCOUNT                  NUMBER         
	,LOAD_BATCH                           VARCHAR2(300)
);
/*
--------------------------------------------------------------------------
CREATION OF THE VALIDATION TABLE FOR XXMX_AR_TRX_DISTS_VAL
(VALIDATION_ERROR_MESSAGE: New Column added as per the package)
--------------------------------------------------------------------------
*/

DROP TABLE XXMX_CORE.XXMX_AR_TRX_DISTS_VAL ;
--
Create Table XXMX_CORE.XXMX_AR_TRX_DISTS_VAL
(
	VALIDATION_ERROR_MESSAGE			VARCHAR2(3000 BYTE)
	,FILE_SET_ID                         VARCHAR2(30)  
	,MIGRATION_SET_ID                    NUMBER        
	,MIGRATION_SET_NAME                  VARCHAR2(150) 
	,MIGRATION_STATUS                    VARCHAR2(50)  
	,ROW_SEQ                             NUMBER        
	,XXMX_CUSTOMER_TRX_ID                NUMBER        
	,XXMX_CUSTOMER_TRX_LINE_ID           NUMBER        
	,XXMX_CUST_TRX_LINE_GL_DIST_ID       NUMBER        
	,OPERATING_UNIT                      VARCHAR2(240) 
	,ORG_ID                              NUMBER        
	,LEDGER_NAME                         VARCHAR2(30)  
	,ACCOUNT_CLASS                       VARCHAR2(20)  
	,AMOUNT                              NUMBER        
	,PERCENT                             NUMBER        
	,ACCOUNTED_AMT_IN_LEDGER_CURR        NUMBER        
	,SEGMENT1                            VARCHAR2(25)  
	,SEGMENT2                            VARCHAR2(25)  
	,SEGMENT3                            VARCHAR2(25)  
	,SEGMENT4                            VARCHAR2(25)  
	,SEGMENT5                            VARCHAR2(25)  
	,SEGMENT6                            VARCHAR2(25)  
	,SEGMENT7                            VARCHAR2(25)  
	,SEGMENT8                            VARCHAR2(25)  
	,SEGMENT9                            VARCHAR2(25)  
	,SEGMENT10                           VARCHAR2(25)   
	,COMMENTS                            VARCHAR2(240) 
	,LOAD_BATCH                          VARCHAR2(300) 
);



