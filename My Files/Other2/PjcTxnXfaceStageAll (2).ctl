--  This control file loads third party project based transactions. It populates into staging table PJC_TXN_XFACE_STAGE_ALL. 
--  This table can be populated with named columns (Project Number, Task Number, etc) and / or with corresponding ID columns.
--  Core processing tbale PJC_TXN_XFACE_ALL will be populated with all required ID columns after performing mapping of name to ID
--  This control file can accept six different types of trasactions (Labor, Non Labor, Misc, Inventory, Supplier Invoices, Expenses)
--  For each of above type, sequence of columns in CSV is defined as per following order. 
--  First column TRANSACTION is dummy column to identify nature of the transaction.

LOAD DATA
INFILE *
APPEND
-- Labor Transactions
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION = 'LABOR' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'LABOR',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
PERSON_NUMBER                ,
PERSON_NAME CHAR(2000)                  ,
PERSON_ID                    ,
HCM_ASSIGNMENT_NAME          ,
HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
--NON_LABOR_RESOURCE           ,
--NON_LABOR_RESOURCE_ID        ,
--NON_LABOR_RESOURCE_ORG       ,
--NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
--ACCRUAL_FLAG                 ,
--SUPPLIER_NUMBER              ,
--SUPPLIER_NAME                ,
--VENDOR_ID                    ,
--INVENTORY_ITEM_NAME          ,
--INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
--RECEIPT_CURRENCY_CODE        ,
--RECEIPT_CURRENCY             ,
--RECEIPT_CURRENCY_AMOUNT      ,
--RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             EXPRESSION "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp"         ,
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)

--- Non Labor Transactions
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION = 'NONLABOR' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'NONLABOR',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
PERSON_NUMBER                ,
PERSON_NAME CHAR(2000)                  ,
PERSON_ID                    ,
HCM_ASSIGNMENT_NAME          ,
HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
NON_LABOR_RESOURCE           ,
NON_LABOR_RESOURCE_ID        ,
NON_LABOR_RESOURCE_ORG       ,
NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
--ACCRUAL_FLAG                 ,
--SUPPLIER_NUMBER              ,
--SUPPLIER_NAME                ,
--VENDOR_ID                    ,
--INVENTORY_ITEM_NAME          ,
--INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
--RECEIPT_CURRENCY_CODE        ,
--RECEIPT_CURRENCY             ,
--RECEIPT_CURRENCY_AMOUNT      ,
--RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             expression "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp",
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)

--- Misc Transactions
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION =  'MISCELLANEOUS' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'MISCELLANEOUS',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
PERSON_NUMBER                ,
PERSON_NAME CHAR(2000)                  ,
PERSON_ID                    ,
HCM_ASSIGNMENT_NAME          ,
HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
--NON_LABOR_RESOURCE           ,
--NON_LABOR_RESOURCE_ID        ,
--NON_LABOR_RESOURCE_ORG       ,
--NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
ACCRUAL_FLAG                 ,
--SUPPLIER_NUMBER              ,
--SUPPLIER_NAME                ,
--VENDOR_ID                    ,
--INVENTORY_ITEM_NAME          ,
--INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
--RECEIPT_CURRENCY_CODE        ,
--RECEIPT_CURRENCY             ,
--RECEIPT_CURRENCY_AMOUNT      ,
--RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             expression "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp",
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)

--- Supplier Invoices
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION =  'SUPPLIER' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'SUPPLIER',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
--PERSON_NUMBER                ,
--PERSON_NAME                  ,
--PERSON_ID                    ,
--HCM_ASSIGNMENT_NAME          ,
--HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
--NON_LABOR_RESOURCE           ,
--NON_LABOR_RESOURCE_ID        ,
--NON_LABOR_RESOURCE_ORG       ,
--NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
--ACCRUAL_FLAG                 ,
SUPPLIER_NUMBER              ,
SUPPLIER_NAME CHAR(360)                ,
VENDOR_ID                    ,
--INVENTORY_ITEM_NAME          ,
--INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
--RECEIPT_CURRENCY_CODE        ,
--RECEIPT_CURRENCY             ,
--RECEIPT_CURRENCY_AMOUNT      ,
--RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             expression "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp",
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)

--- Expense Report
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION =  'EXPENSES' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'EXPENSES',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
PERSON_NUMBER                ,
PERSON_NAME CHAR(2000)                  ,
PERSON_ID                    ,
HCM_ASSIGNMENT_NAME          ,
HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
--NON_LABOR_RESOURCE           ,
--NON_LABOR_RESOURCE_ID        ,
--NON_LABOR_RESOURCE_ORG       ,
--NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
--ACCRUAL_FLAG                 ,
--SUPPLIER_NUMBER              ,
--SUPPLIER_NAME                ,
--VENDOR_ID                    ,
--INVENTORY_ITEM_NAME          ,
--INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
RECEIPT_CURRENCY_CODE        ,
RECEIPT_CURRENCY             ,
RECEIPT_CURRENCY_AMOUNT      ,
RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             expression "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp",
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)

--- Inventory Transaction
INTO TABLE pjc_txn_xface_stage_all
WHEN TRANSACTION =  'INVENTORY' 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS 
(
TRANSACTION             FILLER POSITION(1),
TRANSACTION_TYPE        CONSTANT 'INVENTORY',
BUSINESS_UNIT                ,
ORG_ID                       ,
USER_TRANSACTION_SOURCE      ,
TRANSACTION_SOURCE_ID        ,
DOCUMENT_NAME                ,
DOCUMENT_ID                  ,
DOC_ENTRY_NAME               ,
DOC_ENTRY_ID                 ,
BATCH_NAME                   ,
BATCH_ENDING_DATE            "to_date(:BATCH_ENDING_DATE, 'YYYY/MM/DD')" ,
BATCH_DESCRIPTION            ,
EXPENDITURE_ITEM_DATE        "to_date(:EXPENDITURE_ITEM_DATE, 'YYYY/MM/DD') ",
PERSON_NUMBER                ,
PERSON_NAME CHAR(2000)                  ,
PERSON_ID                    ,
HCM_ASSIGNMENT_NAME          ,
HCM_ASSIGNMENT_ID            ,
PROJECT_NUMBER               ,
PROJECT_NAME                 ,
PROJECT_ID                   ,
TASK_NUMBER                  ,
TASK_NAME                    ,
TASK_ID                      ,
EXPENDITURE_TYPE             ,
EXPENDITURE_TYPE_ID          ,
ORGANIZATION_NAME            ,
ORGANIZATION_ID              ,
--NON_LABOR_RESOURCE           ,
--NON_LABOR_RESOURCE_ID        ,
--NON_LABOR_RESOURCE_ORG       ,
--NON_LABOR_RESOURCE_ORG_ID    ,
QUANTITY                     ,
UNIT_OF_MEASURE_NAME         ,
UNIT_OF_MEASURE              ,
WORK_TYPE                    ,
WORK_TYPE_ID                 ,
BILLABLE_FLAG                ,
CAPITALIZABLE_FLAG           ,
--ACCRUAL_FLAG                 ,
--SUPPLIER_NUMBER              ,
--SUPPLIER_NAME                ,
--VENDOR_ID                    ,
INVENTORY_ITEM_NAME CHAR(300)          ,
INVENTORY_ITEM_ID            ,
ORIG_TRANSACTION_REFERENCE   ,
UNMATCHED_NEGATIVE_TXN_FLAG  ,
REVERSED_ORIG_TXN_REFERENCE  ,
EXPENDITURE_COMMENT          ,
GL_DATE                      "to_date(:GL_DATE, 'YYYY/MM/DD')",
DENOM_CURRENCY_CODE          ,
DENOM_CURRENCY               ,
DENOM_RAW_COST               ,
DENOM_BURDENED_COST          ,
RAW_COST_CR_CCID             ,
RAW_COST_CR_ACCOUNT CHAR(2000)          ,
RAW_COST_DR_CCID             ,
RAW_COST_DR_ACCOUNT CHAR(2000)          ,
BURDENED_COST_CR_CCID        ,
BURDENED_COST_CR_ACCOUNT CHAR(2000)     ,
BURDENED_COST_DR_CCID        ,
BURDENED_COST_DR_ACCOUNT CHAR(2000)     ,
BURDEN_COST_CR_CCID          ,
BURDEN_COST_CR_ACCOUNT CHAR(2000)       ,
BURDEN_COST_DR_CCID          ,
BURDEN_COST_DR_ACCOUNT CHAR(2000)       ,
ACCT_CURRENCY_CODE           ,
ACCT_CURRENCY                ,
ACCT_RAW_COST                ,
ACCT_BURDENED_COST           ,
ACCT_RATE_TYPE               ,
ACCT_RATE_DATE                "to_date(:ACCT_RATE_DATE, 'YYYY/MM/DD')",
ACCT_RATE_DATE_TYPE          ,
ACCT_EXCHANGE_RATE           ,
ACCT_EXCHANGE_ROUNDING_LIMIT ,
RECEIPT_CURRENCY_CODE        ,
RECEIPT_CURRENCY             ,
RECEIPT_CURRENCY_AMOUNT      ,
RECEIPT_EXCHANGE_RATE        ,
CONVERTED_FLAG               ,
CONTEXT_CATEGORY             ,
USER_DEF_ATTRIBUTE1          ,
USER_DEF_ATTRIBUTE2          ,
USER_DEF_ATTRIBUTE3          ,
USER_DEF_ATTRIBUTE4          ,
USER_DEF_ATTRIBUTE5          ,
USER_DEF_ATTRIBUTE6          ,
USER_DEF_ATTRIBUTE7          ,
USER_DEF_ATTRIBUTE8          ,
USER_DEF_ATTRIBUTE9          ,
USER_DEF_ATTRIBUTE10         ,
RESERVED_ATTRIBUTE1          ,
RESERVED_ATTRIBUTE2          ,
RESERVED_ATTRIBUTE3          ,
RESERVED_ATTRIBUTE4          ,
RESERVED_ATTRIBUTE5          ,
RESERVED_ATTRIBUTE6          ,
RESERVED_ATTRIBUTE7          ,
RESERVED_ATTRIBUTE8          ,
RESERVED_ATTRIBUTE9          ,
RESERVED_ATTRIBUTE10         ,
ATTRIBUTE_CATEGORY           ,
ATTRIBUTE1                   ,
ATTRIBUTE2                   ,
ATTRIBUTE3                   ,
ATTRIBUTE4                   ,
ATTRIBUTE5                   ,
ATTRIBUTE6                   ,
ATTRIBUTE7                   ,
ATTRIBUTE8                   ,
ATTRIBUTE9                   ,
ATTRIBUTE10                  ,
TXN_INTERFACE_ID             expression "S_ROW_ID_SEQ.nextval"   ,
TRANSACTION_STATUS_CODE      CONSTANT 'P'                        ,
OBJECT_VERSION_NUMBER        CONSTANT  1                         ,
LOAD_REQUEST_ID              CONSTANT  '#LOADREQUESTID#'       ,
LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'     ,
CREATED_BY                   CONSTANT  '#CREATEDBY#'           ,
CREATION_DATE                EXPRESSION "systimestamp"         ,
LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'       ,
LAST_UPDATE_DATE             EXPRESSION "systimestamp",
-- LOAD_REQUEST_ID              CONSTANT  '9999'                    ,
-- LAST_UPDATE_LOGIN            CONSTANT  '#LASTUPDATELOGIN#'       ,
-- CREATED_BY                   CONSTANT  '#CREATEDBY#'             ,
-- CREATION_DATE                EXPRESSION "SYSDATE"                ,
-- LAST_UPDATED_BY              CONSTANT  '#LASTUPDATEDBY#'         ,
-- LAST_UPDATE_DATE             EXPRESSION "SYSDATE"
CONTRACT_NUMBER,
CONTRACT_NAME CHAR(300),
CONTRACT_ID,
FUNDING_SOURCE_NUMBER,
FUNDING_SOURCE_NAME
)