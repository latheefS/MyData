Select * from AP_INVOICE_LINES_INTERFACE;



INVOICE_ID                  NOT NULL NUMBER(15)     
INVOICE_LINE_ID                      NUMBER(15)     
LINE_NUMBER                          NUMBER(15)     
LINE_TYPE_LOOKUP_CODE                VARCHAR2(25)   
LINE_GROUP_NUMBER                    NUMBER         
AMOUNT                               NUMBER         
ACCOUNTING_DATE                      DATE           
DESCRIPTION                          VARCHAR2(240)  
AMOUNT_INCLUDES_TAX_FLAG             VARCHAR2(1)    
PRORATE_ACROSS_FLAG                  VARCHAR2(1)    
TAX_CODE                             VARCHAR2(30)   
FINAL_MATCH_FLAG                     VARCHAR2(1)    
PO_HEADER_ID                         NUMBER         
PO_NUMBER                            VARCHAR2(20)   
PO_LINE_ID                           NUMBER         
PO_LINE_NUMBER                       NUMBER         
PO_LINE_LOCATION_ID                  NUMBER         
PO_SHIPMENT_NUM                      NUMBER         
PO_DISTRIBUTION_ID                   NUMBER         
PO_DISTRIBUTION_NUM                  NUMBER         
PO_UNIT_OF_MEASURE                   VARCHAR2(25)   
INVENTORY_ITEM_ID                    NUMBER         
ITEM_DESCRIPTION                     VARCHAR2(240)  
QUANTITY_INVOICED                    NUMBER         
SHIP_TO_LOCATION_CODE                VARCHAR2(60)   
UNIT_PRICE                           NUMBER         
DISTRIBUTION_SET_ID                  NUMBER(15)     
DISTRIBUTION_SET_NAME                VARCHAR2(50)   
DIST_CODE_CONCATENATED               VARCHAR2(250)  
DIST_CODE_COMBINATION_ID             NUMBER(15)     
AWT_GROUP_ID                         NUMBER(15)     
AWT_GROUP_NAME                       VARCHAR2(25)   
LAST_UPDATED_BY                      NUMBER(15)     
LAST_UPDATE_DATE                     DATE           
LAST_UPDATE_LOGIN                    NUMBER(15)     
CREATED_BY                           NUMBER(15)     
CREATION_DATE                        DATE           
ATTRIBUTE_CATEGORY                   VARCHAR2(150)  
ATTRIBUTE1                           VARCHAR2(150)  
ATTRIBUTE2                           VARCHAR2(150)  
ATTRIBUTE3                           VARCHAR2(150)  
ATTRIBUTE4                           VARCHAR2(150)  
ATTRIBUTE5                           VARCHAR2(150)  
ATTRIBUTE6                           VARCHAR2(150)  
ATTRIBUTE7                           VARCHAR2(150)  
ATTRIBUTE8                           VARCHAR2(150)  
ATTRIBUTE9                           VARCHAR2(150)  
ATTRIBUTE10                          VARCHAR2(150)  
ATTRIBUTE11                          VARCHAR2(150)  
ATTRIBUTE12                          VARCHAR2(150)  
ATTRIBUTE13                          VARCHAR2(150)  
ATTRIBUTE14                          VARCHAR2(150)  
ATTRIBUTE15                          VARCHAR2(150)  
GLOBAL_ATTRIBUTE_CATEGORY            VARCHAR2(150)  
GLOBAL_ATTRIBUTE1                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE2                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE3                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE4                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE5                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE6                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE7                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE8                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE9                    VARCHAR2(150)  
GLOBAL_ATTRIBUTE10                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE11                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE12                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE13                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE14                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE15                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE16                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE17                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE18                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE19                   VARCHAR2(150)  
GLOBAL_ATTRIBUTE20                   VARCHAR2(150)  
PO_RELEASE_ID                        NUMBER         
RELEASE_NUM                          NUMBER         
ACCOUNT_SEGMENT                      VARCHAR2(25)   
BALANCING_SEGMENT                    VARCHAR2(25)   
COST_CENTER_SEGMENT                  VARCHAR2(25)   
PROJECT_ID                           NUMBER(15)     
TASK_ID                              NUMBER(15)     
EXPENDITURE_TYPE                     VARCHAR2(30)   
EXPENDITURE_ITEM_DATE                DATE           
EXPENDITURE_ORGANIZATION_ID          NUMBER(15)     
PROJECT_ACCOUNTING_CONTEXT           VARCHAR2(30)   
PA_ADDITION_FLAG                     VARCHAR2(1)    
PA_QUANTITY                          NUMBER(22,5)   
USSGL_TRANSACTION_CODE               VARCHAR2(30)   
STAT_AMOUNT                          NUMBER         
TYPE_1099                            VARCHAR2(10)   
INCOME_TAX_REGION                    VARCHAR2(10)   
ASSETS_TRACKING_FLAG                 VARCHAR2(1)    
PRICE_CORRECTION_FLAG                VARCHAR2(1)    
ORG_ID                               NUMBER(15)     
RECEIPT_NUMBER                       VARCHAR2(30)   
RECEIPT_LINE_NUMBER                  VARCHAR2(25)   
MATCH_OPTION                         VARCHAR2(25)   
PACKING_SLIP                         VARCHAR2(25)   
RCV_TRANSACTION_ID                   NUMBER         
PA_CC_AR_INVOICE_ID                  NUMBER(15)     
PA_CC_AR_INVOICE_LINE_NUM            NUMBER(15)     
REFERENCE_1                          VARCHAR2(30)   
REFERENCE_2                          VARCHAR2(30)   
PA_CC_PROCESSED_CODE                 VARCHAR2(1)    
TAX_RECOVERY_RATE                    NUMBER         
TAX_RECOVERY_OVERRIDE_FLAG           VARCHAR2(1)    
TAX_RECOVERABLE_FLAG                 VARCHAR2(1)    
TAX_CODE_OVERRIDE_FLAG               VARCHAR2(1)    
TAX_CODE_ID                          NUMBER(15)     
CREDIT_CARD_TRX_ID                   NUMBER(15)     
AWARD_ID                             NUMBER(15)     
VENDOR_ITEM_NUM                      VARCHAR2(25)   
TAXABLE_FLAG                         VARCHAR2(1)    
PRICE_CORRECT_INV_NUM                VARCHAR2(50)   
EXTERNAL_DOC_LINE_REF                VARCHAR2(240)  
SERIAL_NUMBER                        VARCHAR2(35)   
MANUFACTURER                         VARCHAR2(30)   
MODEL_NUMBER                         VARCHAR2(40)   
WARRANTY_NUMBER                      VARCHAR2(15)   
DEFERRED_ACCTG_FLAG                  VARCHAR2(1)    
DEF_ACCTG_START_DATE                 DATE           
DEF_ACCTG_END_DATE                   DATE           
DEF_ACCTG_NUMBER_OF_PERIODS          NUMBER         
DEF_ACCTG_PERIOD_TYPE                VARCHAR2(15)   
UNIT_OF_MEAS_LOOKUP_CODE             VARCHAR2(25)   
PRICE_CORRECT_INV_LINE_NUM           NUMBER         
ASSET_BOOK_TYPE_CODE                 VARCHAR2(15)   
ASSET_CATEGORY_ID                    NUMBER(15)     
REQUESTER_ID                         NUMBER(15)     
REQUESTER_FIRST_NAME                 VARCHAR2(150)  
REQUESTER_LAST_NAME                  VARCHAR2(150)  
REQUESTER_EMPLOYEE_NUM               VARCHAR2(30)   
APPLICATION_ID                       NUMBER(15)     
PRODUCT_TABLE                        VARCHAR2(30)   
REFERENCE_KEY1                       VARCHAR2(150)  
REFERENCE_KEY2                       VARCHAR2(150)  
REFERENCE_KEY3                       VARCHAR2(150)  
REFERENCE_KEY4                       VARCHAR2(150)  
REFERENCE_KEY5                       VARCHAR2(150)  
PURCHASING_CATEGORY                  VARCHAR2(2000) 
PURCHASING_CATEGORY_ID               NUMBER(15)     
COST_FACTOR_ID                       NUMBER(15)     
COST_FACTOR_NAME                     VARCHAR2(80)   
CONTROL_AMOUNT                       NUMBER         
ASSESSABLE_VALUE                     NUMBER         
DEFAULT_DIST_CCID                    NUMBER(15)     
PRIMARY_INTENDED_USE                 VARCHAR2(30)   
SHIP_TO_LOCATION_ID                  NUMBER(15)     
PRODUCT_TYPE                         VARCHAR2(240)  
PRODUCT_CATEGORY                     VARCHAR2(240)  
PRODUCT_FISC_CLASSIFICATION          VARCHAR2(240)  
USER_DEFINED_FISC_CLASS              VARCHAR2(240)  
TRX_BUSINESS_CATEGORY                VARCHAR2(240)  
TAX_REGIME_CODE                      VARCHAR2(30)   
TAX                                  VARCHAR2(30)   
TAX_JURISDICTION_CODE                VARCHAR2(30)   
TAX_STATUS_CODE                      VARCHAR2(30)   
TAX_RATE_ID                          NUMBER(15)     
TAX_RATE_CODE                        VARCHAR2(150)  
TAX_RATE                             NUMBER         
INCL_IN_TAXABLE_LINE_FLAG            VARCHAR2(1)    
SOURCE_APPLICATION_ID                NUMBER         
SOURCE_ENTITY_CODE                   VARCHAR2(30)   
SOURCE_EVENT_CLASS_CODE              VARCHAR2(30)   
SOURCE_TRX_ID                        NUMBER         
SOURCE_LINE_ID                       NUMBER         
SOURCE_TRX_LEVEL_TYPE                VARCHAR2(30)   
TAX_CLASSIFICATION_CODE              VARCHAR2(30)   
CC_REVERSAL_FLAG                     VARCHAR2(1)    
COMPANY_PREPAID_INVOICE_ID           NUMBER(15)     
EXPENSE_GROUP                        VARCHAR2(80)   
JUSTIFICATION                        VARCHAR2(240)  
MERCHANT_DOCUMENT_NUMBER             VARCHAR2(80)   
MERCHANT_NAME                        VARCHAR2(240)  
MERCHANT_REFERENCE                   VARCHAR2(240)  
MERCHANT_TAX_REG_NUMBER              VARCHAR2(80)   
MERCHANT_TAXPAYER_ID                 VARCHAR2(80)   
RECEIPT_CURRENCY_CODE                VARCHAR2(15)   
RECEIPT_CONVERSION_RATE              NUMBER         
RECEIPT_CURRENCY_AMOUNT              NUMBER         
COUNTRY_OF_SUPPLY                    VARCHAR2(5)    
PAY_AWT_GROUP_ID                     NUMBER(15)     
PAY_AWT_GROUP_NAME                   VARCHAR2(25)   
EXPENSE_START_DATE                   DATE           
EXPENSE_END_DATE                     DATE           