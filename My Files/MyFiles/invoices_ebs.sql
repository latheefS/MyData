Select * from AP_INVOICES_ALL;



INVOICE_ID                    NOT NULL NUMBER(15)     
LAST_UPDATE_DATE              NOT NULL DATE           
LAST_UPDATED_BY               NOT NULL NUMBER(15)     
VENDOR_ID                              NUMBER(15)     
INVOICE_NUM                   NOT NULL VARCHAR2(50)   
SET_OF_BOOKS_ID               NOT NULL NUMBER(15)     
INVOICE_CURRENCY_CODE         NOT NULL VARCHAR2(15)   
PAYMENT_CURRENCY_CODE         NOT NULL VARCHAR2(15)   
PAYMENT_CROSS_RATE            NOT NULL NUMBER         
INVOICE_AMOUNT                         NUMBER         
VENDOR_SITE_ID                         NUMBER(15)     
AMOUNT_PAID                            NUMBER         
DISCOUNT_AMOUNT_TAKEN                  NUMBER         
INVOICE_DATE                           DATE           
SOURCE                                 VARCHAR2(25)   
INVOICE_TYPE_LOOKUP_CODE               VARCHAR2(25)   
DESCRIPTION                            VARCHAR2(240)  
BATCH_ID                               NUMBER(15)     
AMOUNT_APPLICABLE_TO_DISCOUNT          NUMBER         
TAX_AMOUNT                             NUMBER         
TERMS_ID                               NUMBER(15)     
TERMS_DATE                             DATE           
PAYMENT_METHOD_LOOKUP_CODE             VARCHAR2(25)   
PAY_GROUP_LOOKUP_CODE                  VARCHAR2(30)   
ACCTS_PAY_CODE_COMBINATION_ID          NUMBER(15)     
PAYMENT_STATUS_FLAG                    VARCHAR2(1)    
CREATION_DATE                          DATE           
CREATED_BY                             NUMBER(15)     
BASE_AMOUNT                            NUMBER         
VAT_CODE                               VARCHAR2(15)   
LAST_UPDATE_LOGIN                      NUMBER(15)     
EXCLUSIVE_PAYMENT_FLAG                 VARCHAR2(1)    
PO_HEADER_ID                           NUMBER(15)     
FREIGHT_AMOUNT                         NUMBER         
GOODS_RECEIVED_DATE                    DATE           
INVOICE_RECEIVED_DATE                  DATE           
VOUCHER_NUM                            VARCHAR2(50)   
APPROVED_AMOUNT                        NUMBER         
RECURRING_PAYMENT_ID                   NUMBER(15)     
EXCHANGE_RATE                          NUMBER         
EXCHANGE_RATE_TYPE                     VARCHAR2(30)   
EXCHANGE_DATE                          DATE           
EARLIEST_SETTLEMENT_DATE               DATE           
ORIGINAL_PREPAYMENT_AMOUNT             NUMBER         
DOC_SEQUENCE_ID                        NUMBER         
DOC_SEQUENCE_VALUE                     NUMBER         
DOC_CATEGORY_CODE                      VARCHAR2(30)   
ATTRIBUTE1                             VARCHAR2(150)  
ATTRIBUTE2                             VARCHAR2(150)  
ATTRIBUTE3                             VARCHAR2(150)  
ATTRIBUTE4                             VARCHAR2(150)  
ATTRIBUTE5                             VARCHAR2(150)  
ATTRIBUTE6                             VARCHAR2(150)  
ATTRIBUTE7                             VARCHAR2(150)  
ATTRIBUTE8                             VARCHAR2(150)  
ATTRIBUTE9                             VARCHAR2(150)  
ATTRIBUTE10                            VARCHAR2(150)  
ATTRIBUTE11                            VARCHAR2(150)  
ATTRIBUTE12                            VARCHAR2(150)  
ATTRIBUTE13                            VARCHAR2(150)  
ATTRIBUTE14                            VARCHAR2(150)  
ATTRIBUTE15                            VARCHAR2(150)  
ATTRIBUTE_CATEGORY                     VARCHAR2(150)  
APPROVAL_STATUS                        VARCHAR2(25)   
APPROVAL_DESCRIPTION                   VARCHAR2(240)  
INVOICE_DISTRIBUTION_TOTAL             NUMBER         
POSTING_STATUS                         VARCHAR2(15)   
PREPAY_FLAG                            VARCHAR2(1)    
AUTHORIZED_BY                          VARCHAR2(25)   
CANCELLED_DATE                         DATE           
CANCELLED_BY                           NUMBER(15)     
CANCELLED_AMOUNT                       NUMBER         
TEMP_CANCELLED_AMOUNT                  NUMBER         
PROJECT_ACCOUNTING_CONTEXT             VARCHAR2(30)   
USSGL_TRANSACTION_CODE                 VARCHAR2(30)   
USSGL_TRX_CODE_CONTEXT                 VARCHAR2(30)   
PROJECT_ID                             NUMBER(15)     
TASK_ID                                NUMBER(15)     
EXPENDITURE_TYPE                       VARCHAR2(30)   
EXPENDITURE_ITEM_DATE                  DATE           
PA_QUANTITY                            NUMBER(22,5)   
EXPENDITURE_ORGANIZATION_ID            NUMBER(15)     
PA_DEFAULT_DIST_CCID                   NUMBER(15)     
VENDOR_PREPAY_AMOUNT                   NUMBER         
PAYMENT_AMOUNT_TOTAL                   NUMBER         
AWT_FLAG                               VARCHAR2(1)    
AWT_GROUP_ID                           NUMBER(15)     
REFERENCE_1                            VARCHAR2(30)   
REFERENCE_2                            VARCHAR2(30)   
ORG_ID                                 NUMBER(15)     
PRE_WITHHOLDING_AMOUNT                 NUMBER         
GLOBAL_ATTRIBUTE_CATEGORY              VARCHAR2(150)  
GLOBAL_ATTRIBUTE1                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE2                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE3                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE4                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE5                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE6                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE7                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE8                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE9                      VARCHAR2(150)  
GLOBAL_ATTRIBUTE10                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE11                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE12                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE13                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE14                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE15                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE16                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE17                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE18                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE19                     VARCHAR2(150)  
GLOBAL_ATTRIBUTE20                     VARCHAR2(150)  
AUTO_TAX_CALC_FLAG                     VARCHAR2(1)    
PAYMENT_CROSS_RATE_TYPE                VARCHAR2(30)   
PAYMENT_CROSS_RATE_DATE                DATE           
PAY_CURR_INVOICE_AMOUNT                NUMBER         
MRC_BASE_AMOUNT                        VARCHAR2(2000) 
MRC_EXCHANGE_RATE                      VARCHAR2(2000) 
MRC_EXCHANGE_RATE_TYPE                 VARCHAR2(2000) 
MRC_EXCHANGE_DATE                      VARCHAR2(2000) 
MRC_POSTING_STATUS                     VARCHAR2(2000) 
GL_DATE                       NOT NULL DATE           
AWARD_ID                               NUMBER(15)     
PAID_ON_BEHALF_EMPLOYEE_ID             NUMBER(15)     
AMT_DUE_CCARD_COMPANY                  NUMBER         
AMT_DUE_EMPLOYEE                       NUMBER         
APPROVAL_READY_FLAG           NOT NULL VARCHAR2(1)    
APPROVAL_ITERATION                     NUMBER(9)      
WFAPPROVAL_STATUS             NOT NULL VARCHAR2(50)   
REQUESTER_ID                           NUMBER(15)     
VALIDATION_REQUEST_ID                  NUMBER(15)     
VALIDATED_TAX_AMOUNT                   NUMBER         
QUICK_CREDIT                           VARCHAR2(1)    
CREDITED_INVOICE_ID                    NUMBER(15)     
DISTRIBUTION_SET_ID                    NUMBER(15)     
APPLICATION_ID                         NUMBER(15)     
PRODUCT_TABLE                          VARCHAR2(30)   
REFERENCE_KEY1                         VARCHAR2(150)  
REFERENCE_KEY2                         VARCHAR2(150)  
REFERENCE_KEY3                         VARCHAR2(150)  
REFERENCE_KEY4                         VARCHAR2(150)  
REFERENCE_KEY5                         VARCHAR2(150)  
TOTAL_TAX_AMOUNT                       NUMBER         
SELF_ASSESSED_TAX_AMOUNT               NUMBER         
TAX_RELATED_INVOICE_ID                 NUMBER(15)     
TRX_BUSINESS_CATEGORY                  VARCHAR2(240)  
USER_DEFINED_FISC_CLASS                VARCHAR2(240)  
TAXATION_COUNTRY                       VARCHAR2(30)   
DOCUMENT_SUB_TYPE                      VARCHAR2(150)  
SUPPLIER_TAX_INVOICE_NUMBER            VARCHAR2(150)  
SUPPLIER_TAX_INVOICE_DATE              DATE           
SUPPLIER_TAX_EXCHANGE_RATE             NUMBER         
TAX_INVOICE_RECORDING_DATE             DATE           
TAX_INVOICE_INTERNAL_SEQ               VARCHAR2(150)  
LEGAL_ENTITY_ID                        NUMBER(15)     
HISTORICAL_FLAG                        VARCHAR2(1)    
FORCE_REVALIDATION_FLAG                VARCHAR2(1)    
BANK_CHARGE_BEARER                     VARCHAR2(30)   
REMITTANCE_MESSAGE1                    VARCHAR2(150)  
REMITTANCE_MESSAGE2                    VARCHAR2(150)  
REMITTANCE_MESSAGE3                    VARCHAR2(150)  
UNIQUE_REMITTANCE_IDENTIFIER           VARCHAR2(30)   
URI_CHECK_DIGIT                        VARCHAR2(2)    
SETTLEMENT_PRIORITY                    VARCHAR2(30)   
PAYMENT_REASON_CODE                    VARCHAR2(30)   
PAYMENT_REASON_COMMENTS                VARCHAR2(240)  
PAYMENT_METHOD_CODE                    VARCHAR2(30)   
DELIVERY_CHANNEL_CODE                  VARCHAR2(30)   
QUICK_PO_HEADER_ID                     NUMBER(15)     
NET_OF_RETAINAGE_FLAG                  VARCHAR2(1)    
RELEASE_AMOUNT_NET_OF_TAX              NUMBER         
CONTROL_AMOUNT                         NUMBER         
PARTY_ID                               NUMBER(15)     
PARTY_SITE_ID                          NUMBER(15)     
PAY_PROC_TRXN_TYPE_CODE                VARCHAR2(30)   
PAYMENT_FUNCTION                       VARCHAR2(30)   
CUST_REGISTRATION_CODE                 VARCHAR2(50)   
CUST_REGISTRATION_NUMBER               VARCHAR2(30)   
PORT_OF_ENTRY_CODE                     VARCHAR2(30)   
EXTERNAL_BANK_ACCOUNT_ID               NUMBER(15)     
VENDOR_CONTACT_ID                      NUMBER(15)     
INTERNAL_CONTACT_EMAIL                 VARCHAR2(2000) 
DISC_IS_INV_LESS_TAX_FLAG              VARCHAR2(1)    
EXCLUDE_FREIGHT_FROM_DISCOUNT          VARCHAR2(1)    
PAY_AWT_GROUP_ID                       NUMBER(15)     
ORIGINAL_INVOICE_AMOUNT                NUMBER         
DISPUTE_REASON                         VARCHAR2(100)  
REMIT_TO_SUPPLIER_NAME                 VARCHAR2(240)  
REMIT_TO_SUPPLIER_ID                   NUMBER(15)     
REMIT_TO_SUPPLIER_SITE                 VARCHAR2(240)  
REMIT_TO_SUPPLIER_SITE_ID              NUMBER(15)     
RELATIONSHIP_ID                        NUMBER(15)     
PO_MATCHED_FLAG                        VARCHAR2(1)    
VALIDATION_WORKER_ID                   NUMBER(15)



Select * from ap_invoices_all where invoice_num = 'W41112' order by creation_date desc;