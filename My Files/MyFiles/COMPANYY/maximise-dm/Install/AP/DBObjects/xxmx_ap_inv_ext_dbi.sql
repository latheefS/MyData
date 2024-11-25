
EXEC DropTable ('XXMX_AP_INVOICES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_AP_INVOICES_EXT" 
(	
   FILE_SET_ID                         VARCHAR2(30 BYTE), 
   INVOICE_ID                          NUMBER(15)  ,   
   OPERATING_UNIT                      VARCHAR2(240),
   SOURCE                              VARCHAR2(80)  ,
   INVOICE_NUM                         VARCHAR2(50)  , 
   INVOICE_AMOUNT                      NUMBER        , 
   INVOICE_DATE                        VARCHAR2(20)          , 
   VENDOR_NAME                         VARCHAR2(240) , 
   VENDOR_NUM                          VARCHAR2(30)  , 
   VENDOR_SITE_CODE                    VARCHAR2(15)  , 
   INVOICE_CURRENCY_CODE               VARCHAR2(15)  , 
   PAYMENT_CURRENCY_CODE               VARCHAR2(15)  , 
   DESCRIPTION                         VARCHAR2(240) , 
   IMPORT_SET                          VARCHAR2(80)  ,
   INVOICE_TYPE_LOOKUP_CODE            VARCHAR2(25)  , 
   LEGAL_ENTITY_NAME                   VARCHAR2(50)  , 
   CUST_REGISTRATION_NUMBER            VARCHAR2(30)  , 
   CUST_REGISTRATION_CODE              VARCHAR2(30)  , 
   FIRST_PARTY_REGISTRATION_NUM        VARCHAR2(60)  , 
   THIRD_PARTY_REGISTRATION_NUM        VARCHAR2(60)  , 
   TERMS_NAME                          VARCHAR2(50)  , 
   TERMS_DATE                          VARCHAR2(20)          , 
   GOODS_RECEIVED_DATE                 VARCHAR2(20)          , 
   INVOICE_RECEIVED_DATE               VARCHAR2(20)         , 
   GL_DATE                             VARCHAR2(20)          , 
   PAYMENT_METHOD_CODE                 VARCHAR2(30)  , 
   PAY_GROUP_LOOKUP_CODE               VARCHAR2(25)  , 
   EXCLUSIVE_PAYMENT_FLAG              VARCHAR2(1)   , 
   AMOUNT_APPLICABLE_TO_DISCOUNT       NUMBER        , 
   PREPAY_NUM                          VARCHAR2(50)  , 
   PREPAY_LINE_NUM                     NUMBER        , 
   PREPAY_APPLY_AMOUNT                 NUMBER        , 
   PREPAY_GL_DATE                     VARCHAR2(20)         , 
   INVOICE_INCLUDES_PREPAY_FLAG        VARCHAR2(1)   , 
   EXCHANGE_RATE_TYPE                  VARCHAR2(30)  , 
   EXCHANGE_DATE                      VARCHAR2(20)        , 
   EXCHANGE_RATE                       NUMBER        , 
   ACCTS_PAY_CODE_CONCATENATED         VARCHAR2(250) , 
   DOC_CATEGORY_CODE                   VARCHAR2(30)  , 
   VOUCHER_NUM                         VARCHAR2(50)  , 
   REQUESTER_FIRST_NAME                VARCHAR2(150) , 
   REQUESTER_LAST_NAME                 VARCHAR2(150) , 
   REQUESTER_EMPLOYEE_NUM              VARCHAR2(30)  , 
   DELIVERY_CHANNEL_CODE               VARCHAR2(30)  , 
   BANK_CHARGE_BEARER                  VARCHAR2(30)  , 
   REMIT_TO_SUPPLIER_NAME              VARCHAR2(240) , 
   REMIT_TO_SUPPLIER_NUM               VARCHAR2(30)  , 
   REMIT_TO_ADDRESS_NAME               VARCHAR2(240) , 
   PAYMENT_PRIORITY                    NUMBER(2)     , 
   SETTLEMENT_PRIORITY                 VARCHAR2(30)  , 
   UNIQUE_REMITTANCE_IDENTIFIER        VARCHAR2(30)  , 
   URI_CHECK_DIGIT                     VARCHAR2(2)   , 
   PAYMENT_REASON_CODE                 VARCHAR2(30)  , 
   PAYMENT_REASON_COMMENTS             VARCHAR2(240) , 
   REMITTANCE_MESSAGE1                 VARCHAR2(150) , 
   REMITTANCE_MESSAGE2                 VARCHAR2(150) , 
   REMITTANCE_MESSAGE3                 VARCHAR2(150) , 
   AWT_GROUP_NAME                      VARCHAR2(25)  , 
   SHIP_TO_LOCATION                    VARCHAR2(40)  , 
   TAXATION_COUNTRY                    VARCHAR2(30)  , 
   DOCUMENT_SUB_TYPE                   VARCHAR2(150) , 
   TAX_INVOICE_INTERNAL_SEQ            VARCHAR2(150) , 
   SUPPLIER_TAX_INVOICE_NUMBER         VARCHAR2(150) , 
   TAX_INVOICE_RECORDING_DATE         VARCHAR2(20)         , 
   SUPPLIER_TAX_INVOICE_DATE          VARCHAR2(20)         , 
   SUPPLIER_TAX_EXCHANGE_RATE          NUMBER        , 
   PORT_OF_ENTRY_CODE                  VARCHAR2(30)  , 
   CORRECTION_YEAR                     NUMBER        , 
   CORRECTION_PERIOD                   VARCHAR2(15)  , 
   IMPORT_DOCUMENT_NUMBER              VARCHAR2(50)  , 
   IMPORT_DOCUMENT_DATE               VARCHAR2(20)         , 
   CONTROL_AMOUNT                      NUMBER        , 
   CALC_TAX_DURING_IMPORT_FLAG         VARCHAR2(1)   , 
   ADD_TAX_TO_INV_AMT_FLAG             VARCHAR2(1)   , 
   ATTRIBUTE_CATEGORY                  VARCHAR2(150) , 
   ATTRIBUTE1                          VARCHAR2(150) , 
   ATTRIBUTE2                          VARCHAR2(150) , 
   ATTRIBUTE3                          VARCHAR2(150) , 
   ATTRIBUTE4                          VARCHAR2(150) , 
   ATTRIBUTE5                          VARCHAR2(150) , 
   ATTRIBUTE6                          VARCHAR2(150) , 
   ATTRIBUTE7                          VARCHAR2(150) , 
   ATTRIBUTE8                          VARCHAR2(150) , 
   ATTRIBUTE9                          VARCHAR2(150) , 
   ATTRIBUTE10                         VARCHAR2(150) , 
   ATTRIBUTE11                         VARCHAR2(150) , 
   ATTRIBUTE12                         VARCHAR2(150) , 
   ATTRIBUTE13                         VARCHAR2(150) , 
   ATTRIBUTE14                         VARCHAR2(150) , 
   ATTRIBUTE15                         VARCHAR2(150) , 
   ATTRIBUTE_NUMBER1                   NUMBER        , 
   ATTRIBUTE_NUMBER2                   NUMBER        , 
   ATTRIBUTE_NUMBER3                   NUMBER        ,
   ATTRIBUTE_NUMBER4                   NUMBER        , 
   ATTRIBUTE_NUMBER5                   NUMBER        , 
   ATTRIBUTE_DATE1                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                    VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_CATEGORY           VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE1                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE2                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE3                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE4                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE5                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE6                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE7                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE8                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE9                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE10                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE11                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE12                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE13                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE14                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE15                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE16                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE17                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE18                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE19                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE20                  VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE_NUMBER1            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER2            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER3            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER4            NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER5            NUMBER        , 
   GLOBAL_ATTRIBUTE_DATE1             VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE2             VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE3             VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE4             VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE5             VARCHAR2(20)         , 
   IMAGE_DOCUMENT_URI                  VARCHAR2(4000),
   EXTERNAL_BANK_ACCOUNT_NUMBER        VARCHAR2(100),
   EXT_BANK_ACCOUNT_IBAN_NUMBER        VARCHAR2(50),
   REQUESTER_EMAIL_ADDRESS             VARCHAR2(240)
) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_INVOICES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_INVOICES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
  
EXEC DropTable ('XXMX_AP_INVOICE_LINES_EXT')
CREATE TABLE "XXMX_CORE"."XXMX_AP_INVOICE_LINES_EXT" 
(	
   FILE_SET_ID                          VARCHAR2(30 BYTE), 
   INVOICE_ID                           NUMBER(15)   ,  
   LINE_NUMBER                          NUMBER(18)    , 
   LINE_TYPE_LOOKUP_CODE                VARCHAR2(25)   ,
   AMOUNT                               NUMBER        , 
   QUANTITY_INVOICED                    NUMBER        , 
   UNIT_PRICE                           NUMBER        , 
   UNIT_OF_MEAS_LOOKUP_CODE             VARCHAR2(25)  , 
   DESCRIPTION                          VARCHAR2(240) , 
   PO_NUMBER                            VARCHAR2(20)  , 
   PO_LINE_NUMBER                       NUMBER        , 
   PO_SHIPMENT_NUM                      NUMBER        , 
   PO_DISTRIBUTION_NUM                  NUMBER        , 
   ITEM_DESCRIPTION                     VARCHAR2(240) , 
   RELEASE_NUM                          NUMBER        , 
   PURCHASING_CATEGORY                  VARCHAR2(2000), 
   RECEIPT_NUMBER                       VARCHAR2(30)  , 
   RECEIPT_LINE_NUMBER                  VARCHAR2(25)  , 
   CONSUMPTION_ADVICE_NUMBER            VARCHAR2(20)  , 
   CONSUMPTION_ADVICE_LINE_NUMBER       NUMBER        , 
   PACKING_SLIP                         VARCHAR2(25)  , 
   FINAL_MATCH_FLAG                     VARCHAR2(1)   , 
   DIST_CODE_CONCATENATED               VARCHAR2(250) , 
   DISTRIBUTION_SET_NAME                VARCHAR2(50)  , 
   ACCOUNTING_DATE                     VARCHAR2(20)         , 
   ACCOUNT_SEGMENT                      VARCHAR2(25)  , 
   BALANCING_SEGMENT                    VARCHAR2(25)  , 
   COST_CENTER_SEGMENT                  VARCHAR2(25)  , 
   TAX_CLASSIFICATION_CODE              VARCHAR2(30)  , 
   SHIP_TO_LOCATION_CODE                VARCHAR2(60)  , 
   SHIP_FROM_LOCATION_CODE              VARCHAR2(60)  , 
   FINAL_DISCHARGE_LOCATION_CODE        VARCHAR2(60)  , 
   TRX_BUSINESS_CATEGORY                VARCHAR2(240) , 
   PRODUCT_FISC_CLASSIFICATION          VARCHAR2(240) , 
   PRIMARY_INTENDED_USE                 VARCHAR2(30)  , 
   USER_DEFINED_FISC_CLASS              VARCHAR2(240) , 
   PRODUCT_TYPE                         VARCHAR2(240) , 
   ASSESSABLE_VALUE                     NUMBER        , 
   PRODUCT_CATEGORY                     VARCHAR2(240) , 
   CONTROL_AMOUNT                       NUMBER        , 
   TAX_REGIME_CODE                      VARCHAR2(30)  , 
   TAX                                  VARCHAR2(30)  , 
   TAX_STATUS_CODE                      VARCHAR2(30)  , 
   TAX_JURISDICTION_CODE                VARCHAR2(30)  , 
   TAX_RATE_CODE                        VARCHAR2(150) , 
   TAX_RATE                             NUMBER        , 
   AWT_GROUP_NAME                       VARCHAR2(25)  , 
   TYPE_1099                            VARCHAR2(10)  , 
   INCOME_TAX_REGION                    VARCHAR2(10)  , 
   PRORATE_ACROSS_FLAG                  VARCHAR2(1)   , 
   LINE_GROUP_NUMBER                    NUMBER        , 
   COST_FACTOR_NAME                     VARCHAR2(80)  , 
   STAT_AMOUNT                          NUMBER        , 
   ASSETS_TRACKING_FLAG                 VARCHAR2(1)   , 
   ASSET_BOOK_TYPE_CODE                 VARCHAR2(30)  , 
   ASSET_CATEGORY_ID                    NUMBER(18)    , 
   SERIAL_NUMBER                        VARCHAR2(35)  , 
   MANUFACTURER                         VARCHAR2(30)  , 
   MODEL_NUMBER                         VARCHAR2(40)  , 
   WARRANTY_NUMBER                      VARCHAR2(15)  , 
   PRICE_CORRECTION_FLAG                VARCHAR2(1)   , 
   PRICE_CORRECT_INV_NUM                VARCHAR2(50)  , 
   PRICE_CORRECT_INV_LINE_NUM           NUMBER        , 
   REQUESTER_FIRST_NAME                 VARCHAR2(150) , 
   REQUESTER_LAST_NAME                  VARCHAR2(150) , 
   REQUESTER_EMPLOYEE_NUM               VARCHAR2(30)  , 
   ATTRIBUTE_CATEGORY                   VARCHAR2(150) , 
   ATTRIBUTE1                           VARCHAR2(150) , 
   ATTRIBUTE2                           VARCHAR2(150) , 
   ATTRIBUTE3                           VARCHAR2(150) , 
   ATTRIBUTE4                           VARCHAR2(150) , 
   ATTRIBUTE5                           VARCHAR2(150) , 
   ATTRIBUTE6                           VARCHAR2(150) , 
   ATTRIBUTE7                           VARCHAR2(150) , 
   ATTRIBUTE8                           VARCHAR2(150) , 
   ATTRIBUTE9                           VARCHAR2(150) , 
   ATTRIBUTE10                          VARCHAR2(150) , 
   ATTRIBUTE11                          VARCHAR2(150) , 
   ATTRIBUTE12                          VARCHAR2(150) , 
   ATTRIBUTE13                          VARCHAR2(150) , 
   ATTRIBUTE14                          VARCHAR2(150) , 
   ATTRIBUTE15                          VARCHAR2(150) , 
   ATTRIBUTE_NUMBER1                    NUMBER        , 
   ATTRIBUTE_NUMBER2                    NUMBER        , 
   ATTRIBUTE_NUMBER3                    NUMBER        , 
   ATTRIBUTE_NUMBER4                    NUMBER        , 
   ATTRIBUTE_NUMBER5                    NUMBER        , 
   ATTRIBUTE_DATE1                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                     VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                     VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_CATEGORY            VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE1                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE2                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE3                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE4                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE5                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE6                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE7                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE8                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE9                    VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE10                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE11                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE12                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE13                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE14                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE15                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE16                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE17                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE18                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE19                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE20                   VARCHAR2(150) , 
   GLOBAL_ATTRIBUTE_NUMBER1             NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER2             NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER3             NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER4             NUMBER        , 
   GLOBAL_ATTRIBUTE_NUMBER5             NUMBER        , 
   GLOBAL_ATTRIBUTE_DATE1              VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE2              VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE3              VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE4              VARCHAR2(20)         , 
   GLOBAL_ATTRIBUTE_DATE5              VARCHAR2(20)         , 
   PJC_PROJECT_ID                       NUMBER(18)    , 
   PJC_TASK_ID                          NUMBER(18)    , 
   PJC_EXPENDITURE_TYPE_ID              NUMBER(18)    , 
   PJC_EXPENDITURE_ITEM_DATE           VARCHAR2(20)         , 
   PJC_ORGANIZATION_ID                  NUMBER(18)    , 
   PJC_PROJECT_NUMBER                   VARCHAR2(25)  , 
   PJC_TASK_NUMBER                      VARCHAR2(100) , 
   PJC_EXPENDITURE_TYPE_NAME            VARCHAR2(240) , 
   PJC_ORGANIZATION_NAME                VARCHAR2(240) , 
   PJC_RESERVED_ATTRIBUTE1              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE2              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE3              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE4              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE5              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE6              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE7              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE8              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE9              VARCHAR2(150) , 
   PJC_RESERVED_ATTRIBUTE10             VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE1              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE2              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE3              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE4              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE5              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE6              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE7              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE8              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE9              VARCHAR2(150) , 
   PJC_USER_DEF_ATTRIBUTE10             VARCHAR2(150) , 
   FISCAL_CHARGE_TYPE                   VARCHAR2(30)  , 
   DEF_ACCTG_START_DATE                VARCHAR2(20)         , 
   DEF_ACCTG_END_DATE                  VARCHAR2(20)         , 
   DEF_ACCRUAL_CODE_CONCATENATED       VARCHAR2(20)         , 
   PJC_PROJECT_NAME                     VARCHAR2(240) , 
   PJC_TASK_NAME                        VARCHAR2(255) ,  
   PJC_WORK_TYPE                        VARCHAR2(240),
   PJC_CONTRACT_NAME                    VARCHAR2(300),
   PJC_CONTRACT_NUMBER                  VARCHAR2(120),
   PJC_FUNDING_SOURCE_NAME              VARCHAR2(360),
   PJC_FUNDING_SOURCE_NUMBER            VARCHAR2(50),
   REQUESTER_EMAIL_ADDRESS              VARCHAR2(240)
) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_INVOICE_LINES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_INVOICE_LINES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;
     