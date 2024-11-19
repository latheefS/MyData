EXEC DropTable ('XXMX_AP_SUPPLIERS_EXT') ;

 CREATE TABLE "XXMX_CORE"."XXMX_AP_SUPPLIERS_EXT" 
(	"FILE_SET_ID" VARCHAR2(30 BYTE), 
   IMPORT_ACTION                      VARCHAR2(10),  
   SUPPLIER_NAME                      VARCHAR2(360), 
   SUPPLIER_NAME_NEW                  VARCHAR2(360), 
   SUPPLIER_NUMBER                    VARCHAR2(30) , 
   ALTERNATE_NAME                     VARCHAR2(360), 
   TAX_ORGANIZATION_TYPE              VARCHAR2(25) , 
   SUPPLIER_TYPE                      VARCHAR2(30) , 
   INACTIVE_DATE                      VARCHAR2(20)         , 
   BUSINESS_RELATIONSHIP              VARCHAR2(30) , 
   PARENT_SUPPLIER                    VARCHAR2(360), 
   ALIAS                              VARCHAR2(360), 
   DUNS_NUMBER                        VARCHAR2(30) , 
   ONE_TIME_SUPPLIER                  VARCHAR2(1)  , 
   CUSTOMER_NUMBER                    VARCHAR2(25) , 
   SIC                                VARCHAR2(25) , 
   NATIONAL_INSURANCE_NUMBER          VARCHAR2(30) , 
   CORPORATE_WEB_SITE                 VARCHAR2(150), 
   CHIEF_EXECUTIVE_TITLE              VARCHAR2(240), 
   CHIF_EXECUTIVE_NAME                VARCHAR2(240), 
   BUSINESS_CLASSIFICATION            VARCHAR2(1)  , 
   TAXPAYER_COUNTRY                   VARCHAR2(3)  , 
   TAXPAYER_ID                        VARCHAR2(30) , 
   FEDERAL_REPORTABLE                 VARCHAR2(1)  , 
   FEDERAL_INCOME_TAX_TYPE            VARCHAR2(10) , 
   STATE_REPORTABLE                   VARCHAR2(1)  , 
   TAX_REPORTING_NAME                 VARCHAR2(80) , 
   NAME_CONTROL                       VARCHAR2(4)  , 
   TAX_VERIFICATION_DATE              VARCHAR2(20)         , 
   USE_WITHHOLDING_TAX                VARCHAR2(1)  , 
   WITHHOLDING_TAX_GROUP              VARCHAR2(25) , 
   SUPPLIER_VAT_CODE                  VARCHAR2(30) , 
   TAX_REGISTRATION_NUMBER            VARCHAR2(20) , 
   AUTO_TAX_CALC_OVERRIDE             VARCHAR2(1)  , 
   SUPPLIER_PAYMENT_METHOD            VARCHAR2(30) , 
   DELIVERY_CHANNEL                   VARCHAR2(30) , 
   BANK_INSTRUCTION_1                 VARCHAR2(30) , 
   BANK_INSTRUCTION_2                 VARCHAR2(30) , 
   BANK_INSTRUCTION                   VARCHAR2(30) , 
   SETTLEMENT_PRIORITY                VARCHAR2(255), 
   PAYMENT_TEXT_MESSAGE_1             VARCHAR2(150), 
   PAYMENT_TEXT_MESSAGE_2             VARCHAR2(150), 
   PAYMENT_TEXT_MESSAGE_3             VARCHAR2(150), 
   BANK_CHARGE_BEARER                 VARCHAR2(30) , 
   PAYMENT_REASON                     VARCHAR2(30) , 
   PAYMENT_REASON_COMMENTS            VARCHAR2(30) , 
   PAYMENT_FORMAT                     VARCHAR2(30) , 
   ATTRIBUTE_CATEGORY                 VARCHAR2(30) , 
   ATTRIBUTE1                         VARCHAR2(150), 
   ATTRIBUTE2                         VARCHAR2(150), 
   ATTRIBUTE3                         VARCHAR2(150), 
   ATTRIBUTE4                         VARCHAR2(150), 
   ATTRIBUTE5                         VARCHAR2(150), 
   ATTRIBUTE6                         VARCHAR2(150), 
   ATTRIBUTE7                         VARCHAR2(150), 
   ATTRIBUTE8                         VARCHAR2(150), 
   ATTRIBUTE9                         VARCHAR2(150), 
   ATTRIBUTE10                        VARCHAR2(150), 
   ATTRIBUTE11                        VARCHAR2(150), 
   ATTRIBUTE12                        VARCHAR2(150), 
   ATTRIBUTE13                        VARCHAR2(150), 
   ATTRIBUTE14                        VARCHAR2(150), 
   ATTRIBUTE15                        VARCHAR2(150), 
   ATTRIBUTE16                        VARCHAR2(150), 
   ATTRIBUTE17                        VARCHAR2(150), 
   ATTRIBUTE18                        VARCHAR2(150), 
   ATTRIBUTE19                        VARCHAR2(150), 
   ATTRIBUTE20                        VARCHAR2(150), 
   ATTRIBUTE_DATE1                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE2                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE3                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE4                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE5                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE6                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE7                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE8                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE9                    VARCHAR2(20)         , 
   ATTRIBUTE_DATE10                   VARCHAR2(20)         , 
   ATTRIBUTE_TIMESTAMP1               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP2               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP3               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP4               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP5               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP6               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP7               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP8               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP9               TIMESTAMP(6) , 
   ATTRIBUTE_TIMESTAMP10              TIMESTAMP(6) , 
   ATTRIBUTE_NUMBER1                  NUMBER       , 
   ATTRIBUTE_NUMBER2                  NUMBER       , 
   ATTRIBUTE_NUMBER3                  NUMBER       , 
   ATTRIBUTE_NUMBER4                  NUMBER       , 
   ATTRIBUTE_NUMBER5                  NUMBER       , 
   ATTRIBUTE_NUMBER6                  NUMBER       , 
   ATTRIBUTE_NUMBER7                  NUMBER       , 
   ATTRIBUTE_NUMBER8                  NUMBER       , 
   ATTRIBUTE_NUMBER9                  NUMBER       , 
   ATTRIBUTE_NUMBER10                 NUMBER       , 
   GLOBAL_ATTRIBUTE_CATEGORY          VARCHAR2(30) , 
   GLOBAL_ATTRIBUTE1                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE2                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE3                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE4                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE5                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE6                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE7                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE8                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE9                  VARCHAR2(150), 
   GLOBAL_ATTRIBUTE10                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE11                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE12                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE13                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE14                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE15                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE16                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE17                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE18                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE19                 VARCHAR2(150), 
   GLOBAL_ATTRIBUTE20                 VARCHAR2(150),
   GLOBAL_ATTRIBUTE_DATE1             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE2             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE3             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE4             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE5             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE6             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE7             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE8             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE9             VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_DATE10            VARCHAR2(20)        ,  
   GLOBAL_ATTRIBUTE_TIMESTAMP1        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP2        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP3        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP4        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP5        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP6        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP7        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP8        TIMESTAMP(6), 
   GLOBAL_ATTRIBUTE_TIMESTAMP9        TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_TIMESTAMP10       TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_NUMBER1           TIMESTAMP(6),  
   GLOBAL_ATTRIBUTE_NUMBER2           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER3           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER4           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER5           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER6           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER7           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER8           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER9           NUMBER      ,  
   GLOBAL_ATTRIBUTE_NUMBER10          NUMBER      ,  
   REGISRTY_ID                        VARCHAR2(30),  
   SERVICE_LEVEL_CODE                 VARCHAR2(30),  
   EXCLUSIVE_PAYMENT_FLAG             VARCHAR2(1) ,  
   REMIT_ADVICE_DELIVERY_METHOD       VARCHAR2(30),  
   REMIT_ADVICE_EMAIL                 VARCHAR2(255), 
   REMIT_ADVICE_FAX                   VARCHAR2(100) 
) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPPLIERS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPPLIERS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

EXEC DropTable ('XXMX_AP_SUPP_ADDRS_EXT')

 CREATE TABLE "XXMX_CORE"."XXMX_AP_SUPP_ADDRS_EXT" 
(	
FILE_SET_ID                       VARCHAR2(30), 
IMPORT_ACTION                     VARCHAR2(10),  
SUPPLIER_NAME                     VARCHAR2(360), 
ADDRESS_NAME                      VARCHAR2(240), 
ADDRESS_NAME_NEW                  VARCHAR2(240), 
COUNTRY                           VARCHAR2(60) , 
ADDRESS1                          VARCHAR2(240), 
ADDRESS2                          VARCHAR2(240), 
ADDRESS3                          VARCHAR2(240), 
ADDRESS4                          VARCHAR2(240), 
PHONETIC_ADDRESS_LINE             VARCHAR2(560), 
ADDRESS_ELEMENT_ATTRIBUTE_1       VARCHAR2(150), 
ADDRESS_ELEMENT_ATTRIBUTE_2       VARCHAR2(150), 
ADDRESS_ELEMENT_ATTRIBUTE_3       VARCHAR2(150), 
ADDRESS_ELEMENT_ATTRIBUTE_4       VARCHAR2(150), 
ADDRESS_ELEMENT_ATTRIBUTE_5       VARCHAR2(150), 
BUILDING                          VARCHAR2(240), 
FLOOR_NUMBER                      VARCHAR2(40) , 
CITY                              VARCHAR2(60) , 
STATE                             VARCHAR2(60) , 
PROVINCE                          VARCHAR2(60) , 
COUNTY                            VARCHAR2(60) , 
POSTAL_CODE                       VARCHAR2(60) , 
POSTAL_PLUS_4_CODE                VARCHAR2(10) , 
ADDRESSEE                         VARCHAR2(360), 
GLOBAL_LOCATION_NUMBER            VARCHAR2(40) , 
LANGUAGE                          VARCHAR2(4)  , 
INACTIVE_DATE                     VARCHAR2(20)         , 
PHONE_COUNTRY_CODE                VARCHAR2(10) , 
PHONE_AREA_CODE                   VARCHAR2(10) , 
PHONE                             VARCHAR2(40) , 
PHONE_EXTENSION                   VARCHAR2(20) , 
FAX_COUNTRY_CODE                  VARCHAR2(10) , 
FAX_AREA_CODE                     VARCHAR2(10) , 
FAX                               VARCHAR2(15) , 
RFQ_OR_BIDDING                    VARCHAR2(1)  , 
ORDERING                          VARCHAR2(1)  , 
PAY                               VARCHAR2(1)  , 
ATTRIBUTE_CATEGORY                VARCHAR2(30) , 
ATTRIBUTE1                        VARCHAR2(150), 
ATTRIBUTE2                        VARCHAR2(150), 
ATTRIBUTE3                        VARCHAR2(150), 
ATTRIBUTE4                        VARCHAR2(150), 
ATTRIBUTE5                        VARCHAR2(150), 
ATTRIBUTE6                        VARCHAR2(150), 
ATTRIBUTE7                        VARCHAR2(150), 
ATTRIBUTE8                        VARCHAR2(150), 
ATTRIBUTE9                        VARCHAR2(150), 
ATTRIBUTE10                       VARCHAR2(150), 
ATTRIBUTE11                       VARCHAR2(150), 
ATTRIBUTE12                       VARCHAR2(150), 
ATTRIBUTE13                       VARCHAR2(150), 
ATTRIBUTE14                       VARCHAR2(150), 
ATTRIBUTE15                       VARCHAR2(150), 
ATTRIBUTE16                       VARCHAR2(150), 
ATTRIBUTE17                       VARCHAR2(150), 
ATTRIBUTE18                       VARCHAR2(150), 
ATTRIBUTE19                       VARCHAR2(150), 
ATTRIBUTE20                       VARCHAR2(150), 
ATTRIBUTE21                       VARCHAR2(150), 
ATTRIBUTE22                       VARCHAR2(150), 
ATTRIBUTE23                       VARCHAR2(150), 
ATTRIBUTE24                       VARCHAR2(150), 
ATTRIBUTE25                       VARCHAR2(150), 
ATTRIBUTE26                       VARCHAR2(150), 
ATTRIBUTE27                       VARCHAR2(150), 
ATTRIBUTE28                       VARCHAR2(150),
ATTRIBUTE29                       VARCHAR2(150), 
ATTRIBUTE30                       VARCHAR2(150), 
ATTRIBUTE_NUMBER1                 NUMBER       ,
ATTRIBUTE_NUMBER2                 NUMBER       , 
ATTRIBUTE_NUMBER3                 NUMBER       , 
ATTRIBUTE_NUMBER4                 NUMBER       , 
ATTRIBUTE_NUMBER5                 NUMBER       , 
ATTRIBUTE_NUMBER6                 NUMBER       , 
ATTRIBUTE_NUMBER7                 NUMBER       , 
ATTRIBUTE_NUMBER8                 NUMBER       , 
ATTRIBUTE_NUMBER9                 NUMBER       , 
ATTRIBUTE_NUMBER10                NUMBER       , 
ATTRIBUTE_NUMBER11                NUMBER       , 
ATTRIBUTE_NUMBER12                NUMBER       , 
ATTRIBUTE_DATE1                   VARCHAR2(20)         , 
ATTRIBUTE_DATE2                   VARCHAR2(20)         , 
ATTRIBUTE_DATE3                   VARCHAR2(20)         , 
ATTRIBUTE_DATE4                   VARCHAR2(20)         , 
ATTRIBUTE_DATE5                   VARCHAR2(20)         , 
ATTRIBUTE_DATE6                   VARCHAR2(20)         , 
ATTRIBUTE_DATE7                   VARCHAR2(20)         , 
ATTRIBUTE_DATE8                   VARCHAR2(20)         , 
ATTRIBUTE_DATE9                   VARCHAR2(20)         , 
ATTRIBUTE_DATE10                  VARCHAR2(20)         , 
ATTRIBUTE_DATE11                  VARCHAR2(20)         , 
ATTRIBUTE_DATE12                  VARCHAR2(20)         , 
EMAIL_ADDRESS                     VARCHAR2(320), 
DELIVERY_CHANNEL                  VARCHAR2(30) , 
BANK_INSTRUCTION_1                VARCHAR2(30) , 
BANK_INSTRUCTION_2                VARCHAR2(30) , 
BANK_INSTRUCTION                  VARCHAR2(30) , 
SETTLEMENT_PRIORITY               VARCHAR2(30) , 
PAYMENT_TEXT_MESSAGE_1            VARCHAR2(150), 
PAYMENT_TEXT_MESSAGE_2            VARCHAR2(150), 
PAYMENT_TEXT_MESSAGE_3            VARCHAR2(150), 
PAYEE_SERVICE_LEVEL               VARCHAR2(30) , 
PAY_EACH_DOCUMENT_ALONE           VARCHAR2(1)  , 
BANK_CHARGE_BEARER                VARCHAR2(30) , 
PAYMENT_REASON                    VARCHAR2(30) , 
PAYMENT_REASON_COMMENTS           VARCHAR2(240), 
DELIVERY_METHOD                   VARCHAR2(30) , 
REMITTANCE_E_MAIL                 VARCHAR2(255), 
REMITTANCE_FAX                    VARCHAR2(15)
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_ADDRS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_ADDRS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;


EXEC DropTable ('XXMX_AP_SUPPLIER_SITES_EXT')
  CREATE TABLE "XXMX_CORE"."XXMX_AP_SUPPLIER_SITES_EXT" 
(  
FILE_SET_ID                       VARCHAR2(30),
IMPORT_ACTION                       VARCHAR2(10),   
SUPPLIER_NAME                       VARCHAR2(360),  
PROCUREMENT_BU                      VARCHAR2(240),  
ADDRESS_NAME                        VARCHAR2(240),  
SUPPLIER_SITE                       VARCHAR2(15),   
SUPPLIER_SITE_NEW                   VARCHAR2(15),   
INACTIVE_DATE                       VARCHAR2(20) ,          
SOURCING_ONLY                       VARCHAR2(1),    
PURCHASING                          VARCHAR2(1),    
PROCUREMENT_CARD                    VARCHAR2(1),    
PAY                                 VARCHAR2(1),    
PRIMARY_PAY                         VARCHAR2(1),    
INCOME_TAX_REPORTING_SITE           VARCHAR2(1),    
ALTERNATE_SITE_NAME                 VARCHAR2(320),  
CUSTOMER_NUMBER                     VARCHAR2(25),   
B2B_COMMUNICATION_METHOD            VARCHAR2(10),   
B2B_SUPPLIER_SITE_CODE              VARCHAR2(256),  
COMMUNICATION_METHOD                VARCHAR2(25),   
E_MAIL                              VARCHAR2(2000), 
FAX_COUNTRY_CODE                    VARCHAR2(10),   
FAX_AREA_CODE                       VARCHAR2(10),   
FAX                                 VARCHAR2(15),   
HOLD_PURCHASING_DOCUMENTS           VARCHAR2(1),    
HOLD_REASON                         VARCHAR2(240),  
CARRIER                             VARCHAR2(360),  
MODE_OF_TRANSPORT                   VARCHAR2(30),   
SERVICE_LEVEL                       VARCHAR2(30),   
FREIGHT_TERMS                       VARCHAR2(25),   
PAY_ON_RECEIPT                      VARCHAR2(25),   
FOB                                 VARCHAR2(25),   
COUNTRY_OF_ORIGIN                   VARCHAR2(2),    
BUYER_MANAGED_TRANSPORTATION        VARCHAR2(1),    
PAY_ON_USE                          VARCHAR2(1),    
AGING_ONSET_POINT                   VARCHAR2(1),    
AGING_PERIOD_DAYS                   NUMBER(5),      
CONSUMPTION_ADVICE_FREQUENCY        VARCHAR2(30),   
CONSUMPTION_ADVICE_SUMMARY          VARCHAR2(30),   
DEFAULT_PAY_SITE                    VARCHAR2(15),   
INVOICE_SUMMARY_LEVEL               VARCHAR2(25),   
GAPLESS_INVOICE_NUMBERING           VARCHAR2(1),    
SELLING_COMPANY_IDENTIFIER          VARCHAR2(10),   
CREATE_DEBIT_MEMO_FROM_RETURN       VARCHAR2(25),   
SHIP_TO_EXCEPTION_ACTION            VARCHAR2(25),   
RECEIPT_ROUTING                     NUMBER(18),     
OVER_RECEIPT_TOLERANCE              NUMBER ,        
OVER_RECEIPT_ACTION                 VARCHAR2(25),   
EARLY_RECEIPT_TOLERANCE             NUMBER ,        
LATE_RECEIPT_TOLERANCE              NUMBER ,        
ALLOW_SUBSTITUTE_RECEIPTS           VARCHAR2(1),    
ALLOW_UNORDERED_RECEIPTS            VARCHAR2(1),    
RECEIPT_DATE_EXCEPTION              VARCHAR2(25),   
INVOICE_CURRENCY                    VARCHAR2(15),   
INVOICE_AMOUNT_LIMIT                NUMBER  ,       
INVOICE_MATCH_OPTION                VARCHAR2(25),   
MATCH_APPROVAL_LEVEL                VARCHAR2(1),    
PAYMENT_CURRENCY                    VARCHAR2(15),   
PAYMENT_PRIORITY                    NUMBER ,        
PAY_GROUP                           VARCHAR2(25),   
QUANTITY_TOLERANCES                 VARCHAR2(255),  
AMOUNT_TOLERANCE                    VARCHAR2(255),  
HOLD_ALL_INVOICES                   VARCHAR2(1),    
HOLD_UNMATCHED_INVOICES             VARCHAR2(1),    
HOLD_UNVALIDATED_INVOICES           VARCHAR2(1),    
PAYMENT_HOLD_BY                     NUMBER(18),     
PAYMENT_HOLD_DATE                   VARCHAR2(20)  ,         
PAYMENT_HOLD_REASON                 VARCHAR2(240),  
PAYMENT_TERMS                       VARCHAR2(50),   
TERMS_DATE_BASIS                    VARCHAR2(25),   
PAY_DATE_BASIS                      VARCHAR2(25),   
BANK_CHARGE_DEDUCTION_TYPE          VARCHAR2(25),   
ALWAYS_TAKE_DISCOUNT                VARCHAR2(1),    
EXCLUDE_FREIGHT_FROM_DISCOUNT       VARCHAR2(1),    
EXCLUDE_TAX_FROM_DISCOUNT           VARCHAR2(1),    
CREATE_INTEREST_INVOICES            VARCHAR2(1),    
VAT_CODE                            VARCHAR2(30),   
TAX_REGISTRATION_NUMBER             VARCHAR2(20),   
PAYMENT_METHOD                      VARCHAR2(30),   
DELIVERY_CHANNEL                    VARCHAR2(30),   
BANK_INSTRUCTION_1                  VARCHAR2(30),   
BANK_INSTRUCTION_2                  VARCHAR2(30),   
BANK_INSTRUCTION                    VARCHAR2(255),  
SETTLEMENT_PRIORITY                 VARCHAR2(30),   
PAYMENT_TEXT_MESSAGE_1              VARCHAR2(150),  
PAYMENT_TEXT_MESSAGE_2              VARCHAR2(150),  
PAYMENT_TEXT_MESSAGE_3              VARCHAR2(150),  
BANK_CHARGE_BEARER                  VARCHAR2(30),   
PAYMENT_REASON                      VARCHAR2(30),   
PAYMENT_REASON_COMMENTS             VARCHAR2(240),  
DELIVERY_METHOD                     VARCHAR2(30),   
REMITTANCE_E_MAIL                   VARCHAR2(255),  
REMITTANCE_FAX                      VARCHAR2(15),   
ATTRIBUTE_CATEGORY                  VARCHAR2(30),   
ATTRIBUTE1                          VARCHAR2(150),  
ATTRIBUTE2                          VARCHAR2(150),  
ATTRIBUTE3                          VARCHAR2(150),  
ATTRIBUTE4                          VARCHAR2(150),  
ATTRIBUTE5                          VARCHAR2(150),  
ATTRIBUTE6                          VARCHAR2(150),  
ATTRIBUTE7                          VARCHAR2(150),  
ATTRIBUTE8                          VARCHAR2(150),  
ATTRIBUTE9                          VARCHAR2(150),  
ATTRIBUTE10                         VARCHAR2(150),  
ATTRIBUTE11                         VARCHAR2(150),  
ATTRIBUTE12                         VARCHAR2(150),  
ATTRIBUTE13                         VARCHAR2(150),  
ATTRIBUTE14                         VARCHAR2(150),  
ATTRIBUTE15                         VARCHAR2(150),  
ATTRIBUTE16                         VARCHAR2(150),  
ATTRIBUTE17                         VARCHAR2(150),  
ATTRIBUTE18                         VARCHAR2(150),  
ATTRIBUTE19                         VARCHAR2(150),  
ATTRIBUTE20                         VARCHAR2(150),  
ATTRIBUTE_DATE1                     VARCHAR2(20)   ,        
ATTRIBUTE_DATE2                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE3                     VARCHAR2(20)   ,      
ATTRIBUTE_DATE4                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE5                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE6                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE7                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE8                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE9                     VARCHAR2(20)   ,       
ATTRIBUTE_DATE10                    VARCHAR2(20)   ,       
ATTRIBUTE_TIMESTAMP1                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP2                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP3                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP4                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP5                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP6                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP7                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP8                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP9                TIMESTAMP(6),   
ATTRIBUTE_TIMESTAMP10               TIMESTAMP(6),   
ATTRIBUTE_NUMBER1                   NUMBER ,        
ATTRIBUTE_NUMBER2                   NUMBER  ,       
ATTRIBUTE_NUMBER3                   NUMBER ,        
ATTRIBUTE_NUMBER4                   NUMBER ,        
ATTRIBUTE_NUMBER5                   NUMBER ,        
ATTRIBUTE_NUMBER6                   NUMBER ,        
ATTRIBUTE_NUMBER7                   NUMBER ,        
ATTRIBUTE_NUMBER8                   NUMBER ,        
ATTRIBUTE_NUMBER9                   NUMBER ,        
ATTRIBUTE_NUMBER10                  NUMBER ,        
GLOBAL_ATTRIBUTE_CATEGORY           VARCHAR2(30),   
GLOBAL_ATTRIBUTE1                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE2                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE3                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE4                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE5                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE6                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE7                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE8                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE9                   VARCHAR2(150),  
GLOBAL_ATTRIBUTE10                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE11                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE12                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE13                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE14                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE15                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE16                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE17                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE18                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE19                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE20                  VARCHAR2(150),  
GLOBAL_ATTRIBUTE_DATE1              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE2              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE3              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE4              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE5              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE6              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE7              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE8              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE9              VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_DATE10             VARCHAR2(20)  ,         
GLOBAL_ATTRIBUTE_TIMESTAMP1         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP2         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP3         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP4         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP5         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP6         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP7         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP8         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP9         TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_TIMESTAMP10        TIMESTAMP(6),   
GLOBAL_ATTRIBUTE_NUMBER1            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER2            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER3            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER4            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER5            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER6            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER7            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER8            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER9            NUMBER ,        
GLOBAL_ATTRIBUTE_NUMBER10           NUMBER,         
REQUIRED_ACKNOWLEDGEMENT            VARCHAR2(30),   
ACKNOWLEDGE_WITHIN_DAYS             NUMBER(38),     
INVOICE_CHANNEL                     VARCHAR2(30),   
PAYEE_SERVICE_LEVEL_CODE            VARCHAR2(30),   
EXCLUSIVE_PAYMENT_FLAG              VARCHAR2(1) 
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPPLIER_SITES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPPLIER_SITES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  
  
  
EXEC DropTable ('XXMX_AP_SUPP_3RD_PTY_RELS_EXT')
  
 CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_3RD_PTY_RELS_EXT
 (
   FILE_SET_ID                       VARCHAR2(30),
   IMPORT_ACTION                   VARCHAR2(10)  , 
   SUPPLIER_NAME                   VARCHAR2(360)  ,
   SUPPLIER_SITE                   VARCHAR2(15)   ,  
   PROCUREMENT_BU                  VARCHAR2(240)  ,
   DEFAULT_RELATIONSHIP_FLAG       VARCHAR2(1)    ,
   REMIT_TO_SUPPLIER               VARCHAR2(240)  ,
   REMIT_TO_ADDRESS                VARCHAR2(15)  , 
   FROM_DATE                       VARCHAR2(20)          , 
   TO_DATE                         VARCHAR2(20)          , 
   DESCRIPTION                     VARCHAR2(1000) 
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_3RD_PTY_RELS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_3RD_PTY_RELS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

EXEC DropTable ('XXMX_AP_SUPP_SITE_ASSIGNS_EXT')
 CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_SITE_ASSIGNS_EXT
 (
   FILE_SET_ID                       VARCHAR2(30),
   IMPORT_ACTION                    VARCHAR2(10) ,  
   SUPPLIER_NAME                    VARCHAR2(360), 
   SUPPLIER_SITE                    VARCHAR2(15) , 
   PROCUREMENT_BU                   VARCHAR2(240), 
   CLIENT_BU                        VARCHAR2(240), 
   BILL_TO_BU                       VARCHAR2(240), 
   SHIP_TO_LOCATION                 VARCHAR2(60) , 
   BILL_TO_LOCATION                 VARCHAR2(60) , 
   USE_WITHHOLDING_TAX              VARCHAR2(1)  , 
   WITHHOLDING_TAX_GROUP            VARCHAR2(25) , 
   LIABILITY_DISTRIBUTION           VARCHAR2(800), 
   PREPAYMENT_DISTRIBUTION          VARCHAR2(800), 
   BILLS_PAYABLE_DISTRIBUTION       VARCHAR2(800),
   DISTRIBUTION_SET                 VARCHAR2(50) , 
   INACTIVE_DATE                    VARCHAR2(20)
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_SITE_ASSIGNS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_SITE_ASSIGNS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;  


EXEC DropTable ('XXMX_AP_SUPP_CONTACTS_EXT')
CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_CONTACTS_EXT
(
   FILE_SET_ID                       VARCHAR2(30),
   IMPORT_ACTION               VARCHAR2(10),      
   SUPPLIER_NAME               VARCHAR2(360), 
   PREFIX                      VARCHAR2(30) , 
   FIRST_NAME                  VARCHAR2(150), 
   FIRST_NAME_NEW              VARCHAR2(150), 
   MIDDLE_NAME                 VARCHAR2(60) , 
   LAST_NAME                   VARCHAR2(150), 
   LAST_NAME_NEW               VARCHAR2(150), 
   JOB_TITLE                   VARCHAR2(100), 
   PRIMARY_ADMIN_CONTACT       VARCHAR2(1)  , 
   EMAIL_ADDRESS               VARCHAR2(360), 
   EMAIL_ADDRESS_NEW           VARCHAR2(360), 
   PHONE_COUNTRY_CODE          VARCHAR2(10) , 
   AREA_CODE                   VARCHAR2(10) , 
   PHONE                       VARCHAR2(40) , 
   PHONE_EXTENSION             VARCHAR2(40) , 
   FAX_COUNTRY_CODE            VARCHAR2(10) , 
   FAX_AREA_CODE               VARCHAR2(10) , 
   FAX                         VARCHAR2(40) , 
   MOBILE_COUNTRY_CODE         VARCHAR2(10) , 
   MOBILE_AREA_CODE            VARCHAR2(10) , 
   MOBILE                      VARCHAR2(40) , 
   INACTIVE_DATE               VARCHAR2(20)         , 
   ATTRIBUTE_CATEGORY          VARCHAR2(30) , 
   ATTRIBUTE1                  VARCHAR2(150), 
   ATTRIBUTE2                  VARCHAR2(150), 
   ATTRIBUTE3                  VARCHAR2(150), 
   ATTRIBUTE4                  VARCHAR2(150), 
   ATTRIBUTE5                  VARCHAR2(150), 
   ATTRIBUTE6                  VARCHAR2(150), 
   ATTRIBUTE7                  VARCHAR2(150), 
   ATTRIBUTE8                  VARCHAR2(150), 
   ATTRIBUTE9                  VARCHAR2(150), 
   ATTRIBUTE10                 VARCHAR2(150), 
   ATTRIBUTE11                 VARCHAR2(150), 
   ATTRIBUTE12                 VARCHAR2(150), 
   ATTRIBUTE13                 VARCHAR2(150), 
   ATTRIBUTE14                 VARCHAR2(150), 
   ATTRIBUTE15                 VARCHAR2(150), 
   ATTRIBUTE16                 VARCHAR2(150), 
   ATTRIBUTE17                 VARCHAR2(150), 
   ATTRIBUTE18                 VARCHAR2(150), 
   ATTRIBUTE19                 VARCHAR2(150), 
   ATTRIBUTE20                 VARCHAR2(150), 
   ATTRIBUTE21                 VARCHAR2(150), 
   ATTRIBUTE22                 VARCHAR2(150), 
   ATTRIBUTE23                 VARCHAR2(150), 
   ATTRIBUTE24                 VARCHAR2(150), 
   ATTRIBUTE25                 VARCHAR2(150), 
   ATTRIBUTE26                 VARCHAR2(150), 
   ATTRIBUTE27                 VARCHAR2(150), 
   ATTRIBUTE28                 VARCHAR2(150), 
   ATTRIBUTE29                 VARCHAR2(150), 
   ATTRIBUTE30                 VARCHAR2(255), 
   ATTRIBUTE_NUMBER1           NUMBER       , 
   ATTRIBUTE_NUMBER2           NUMBER       , 
   ATTRIBUTE_NUMBER3           NUMBER       , 
   ATTRIBUTE_NUMBER4           NUMBER       , 
   ATTRIBUTE_NUMBER5           NUMBER       , 
   ATTRIBUTE_NUMBER6           NUMBER       , 
   ATTRIBUTE_NUMBER7           NUMBER       , 
   ATTRIBUTE_NUMBER8           NUMBER       , 
   ATTRIBUTE_NUMBER9           NUMBER       , 
   ATTRIBUTE_NUMBER10          NUMBER       ,
   ATTRIBUTE_NUMBER11          NUMBER      ,  
   ATTRIBUTE_NUMBER12          NUMBER      ,  
   ATTRIBUTE_DATE1             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE2             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE3             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE4             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE5             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE6             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE7             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE8             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE9             VARCHAR2(20)        ,  
   ATTRIBUTE_DATE10            VARCHAR2(20)        ,  
   ATTRIBUTE_DATE11            VARCHAR2(20)        ,  
   ATTRIBUTE_DATE12            VARCHAR2(20)        ,  
   USER_ACCOUNT_ACTION         VARCHAR2(50),  
   ROLE1                       VARCHAR2(150), 
   ROLE2                       VARCHAR2(150), 
   ROLE3                       VARCHAR2(150), 
   ROLE4                       VARCHAR2(150), 
   ROLE5                       VARCHAR2(150), 
   ROLE6                       VARCHAR2(150), 
   ROLE7                       VARCHAR2(150), 
   ROLE8                       VARCHAR2(150), 
   ROLE9                       VARCHAR2(150), 
   ROLE10                      VARCHAR2(150)
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_CONTACTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_CONTACTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;    
  
EXEC DropTable ('XXMX_AP_SUPP_CONT_ADDRS_EXT')

CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_CONT_ADDRS_EXT
(
   FILE_SET_ID              VARCHAR2(30),
   IMPORT_ACTION            VARCHAR2(10),    
   SUPPLIER_NAME            VARCHAR2(360), 
   ADDRESS_NAME             VARCHAR2(240), 
   FIRST_NAME               VARCHAR2(150), 
   LAST_NAME                VARCHAR2(150), 
   EMAIL_ADDRESS            VARCHAR2(320)
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_CONT_ADDRS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_CONT_ADDRS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ; 
  
EXEC DropTable ('XXMX_AP_SUPP_PAYEES_EXT')
CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_PAYEES_EXT
(
   FILE_SET_ID                        VARCHAR2(30),
   TEMP_EXT_PAYEE_ID                  NUMBER       , 
   BUSINESS_UNIT                      VARCHAR2(240), 
   VENDOR_CODE                        VARCHAR2(30) , 
   VENDOR_SITE_CODE                   VARCHAR2(15) , 
   EXCLUSIVE_PAYMENT_FLAG             VARCHAR2(1)  , 
   DEFAULT_PAYMENT_METHOD_CODE        VARCHAR2(30) , 
   DELIVERY_CHANNEL_CODE              VARCHAR2(30) , 
   SETTLEMENT_PRIORITY                VARCHAR2(30) , 
   REMIT_ADVICE_DELIVERY_METHOD       VARCHAR2(30) , 
   REMIT_ADVICE_EMAIL                 VARCHAR2(255), 
   REMIT_ADVICE_FAX                   VARCHAR2(100), 
   BANK_INSTRUCTION1_CODE             VARCHAR2(30) , 
   BANK_INSTRUCTION2_CODE             VARCHAR2(30) , 
   BANK_INSTRUCTION_DETAILS           VARCHAR2(255), 
   PAYMENT_REASON_CODE                VARCHAR2(30) , 
   PAYMENT_REASON_COMMENTS            VARCHAR2(240), 
   PAYMENT_TEXT_MESSAGE1              VARCHAR2(150), 
   PAYMENT_TEXT_MESSAGE2              VARCHAR2(150), 
   PAYMENT_TEXT_MESSAGE3              VARCHAR2(150), 
   BANK_CHARGE_BEARER                 VARCHAR2(30)  
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_PAYEES_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_PAYEES_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;   
  
EXEC DropTable ('XXMX_AP_SUPP_BANK_ACCTS_EXT')
CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_BANK_ACCTS_EXT
(
   FILE_SET_ID                        VARCHAR2(30),
   TEMP_EXT_PARTY_ID                  NUMBER ,       
   TEMP_EXT_BANK_ACCT_ID              NUMBER  ,      
   BANK_NAME                          VARCHAR2(80)  ,
   BRANCH_NAME                        VARCHAR2(80)  ,
   COUNTRY_CODE                       VARCHAR2(2)   ,
   BANK_ACCOUNT_NAME                  VARCHAR2(80)  ,
   BANK_ACCOUNT_NUM                   VARCHAR2(100) ,
   CURRENCY_CODE                      VARCHAR2(15)  ,
   FOREIGN_PAYMENT_USE_FLAG           VARCHAR2(1)   ,
   START_DATE                         VARCHAR2(20)          ,
   END_DATE                           VARCHAR2(20)          ,
   IBAN                               VARCHAR2(50)  ,
   CHECK_DIGITS                       VARCHAR2(30)  ,
   BANK_ACCOUNT_NAME_ALT              VARCHAR2(320) ,
   BANK_ACCOUNT_TYPE                  VARCHAR2(25)  ,
   ACCOUNT_SUFFIX                     VARCHAR2(30)  ,
   DESCRIPTION                        VARCHAR2(240) ,
   AGENCY_LOCATION_CODE               VARCHAR2(30)  ,
   EXCHANGE_RATE_AGREEMENT_NUM        VARCHAR2(80)  ,
   EXCHANGE_RATE_AGREEMENT_TYPE       VARCHAR2(80)  ,
   EXCHANGE_RATE                      NUMBER        ,
   SECONDARY_ACCOUNT_REFERENCE        VARCHAR2(30)  ,
   ATTRIBUTE_CATEGORY                 VARCHAR2(150) ,
   ATTRIBUTE1                         VARCHAR2(150) ,
   ATTRIBUTE2                         VARCHAR2(150) ,
   ATTRIBUTE3                         VARCHAR2(150) ,
   ATTRIBUTE4                         VARCHAR2(150) ,
   ATTRIBUTE5                         VARCHAR2(150) ,
   ATTRIBUTE6                         VARCHAR2(150) ,
   ATTRIBUTE7                         VARCHAR2(150) ,
   ATTRIBUTE8                         VARCHAR2(150) ,
   ATTRIBUTE9                         VARCHAR2(150) ,
   ATTRIBUTE10                        VARCHAR2(150) ,
   ATTRIBUTE11                        VARCHAR2(150) ,
   ATTRIBUTE12                        VARCHAR2(150) ,
   ATTRIBUTE13                        VARCHAR2(150) ,
   ATTRIBUTE14                        VARCHAR2(150) ,
   ATTRIBUTE15                        VARCHAR2(150) 
)
 ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_BANK_ACCTS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_BANK_ACCTS_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;    
  
EXEC DropTable ('XXMX_AP_SUPP_PMT_INSTRS_EXT')
CREATE TABLE XXMX_CORE.XXMX_AP_SUPP_PMT_INSTRS_EXT
(
   FILE_SET_ID                 VARCHAR2(30),
   TEMP_EXT_PARTY_ID           NUMBER      ,  
   TEMP_EXT_BANK_ACCT_ID       NUMBER      ,  
   TEMP_PMT_INSTR_USE_ID       NUMBER      ,  
   PRIMARY_FLAG                VARCHAR2(1) ,  
   ACCT_ASSIG_START_DATE       VARCHAR2(20)        ,  
   ACCT_ASSIG_END_DATE         VARCHAR2(20)          
)
ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_AP_SUPP_PMT_INSTRS_STG.log' fields terminated by "," optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_AP_SUPP_PMT_INSTRS_STG.csv'
       )
    )
REJECT LIMIT UNLIMITED 
PARALLEL 5 ;   
  
  