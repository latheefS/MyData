LOAD DATA
INFILE XXMX_HCM_PERSONAL_PAYMTHD.dat
REPLACE 
INTO  TABLE XXMX_PER_PAY_METHOD_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONAL_PAYMENT_NAME          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEGISLATIVEDATAGROUPNAME       ,
ASSIGNMENT_NUMBER              ,
LEGISLATION_CODE               ,
PAYROLL_SHIP_NUMBER            ,
PAYMENT_AMOUNT_TYPE            ,
REMAINING_AMOUNT_FLAG          ,
PROCESSING_ORDER               ,
ORG_PAYMENT_METHOD_CODE        ,
BANK_ACCOUNT_NUMBER            ,
BANK_NUMBER                    ,
BANK_NAME                      ,
BRANCH_NAME                    ,
CURRENCY_CODE                  ,
SORT_CODE                      ,
SEC_ACCOUNT_REF                ,
AMOUNT                         ,
PERCENTAGE                     ,
PRIORITY                       ,
PERSONNUMBER                   
)

