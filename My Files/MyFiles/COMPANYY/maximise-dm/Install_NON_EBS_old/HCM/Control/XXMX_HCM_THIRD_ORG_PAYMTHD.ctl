LOAD DATA
INFILE XXMX_HCM_THIRD_ORG_PAYMTHD.dat
REPLACE 
INTO  TABLE XXMX_THIRD_PAYMTHD_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(EFFECTIVE_DATE                 ,
ORGANIZATION_NAME              ,
ORGANIZATION_PAYMENT_METHOD    ,
BANK_ACCOUNT_NUMBER            ,
SORT_CODE                      ,
BANK_NAME                      ,
BANK_NUMBER                    ,
BRANCH_NAME                    ,
COUNTRY                        ,
BRANCH_NUMBER                  ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
LEGISLATION_CODE               
)

