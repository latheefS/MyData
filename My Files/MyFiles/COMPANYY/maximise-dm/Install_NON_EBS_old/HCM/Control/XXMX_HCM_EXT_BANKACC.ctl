LOAD DATA
INFILE XXMX_HCM_EXT_BANKACC.dat
REPLACE 
INTO  TABLE XXMX_EXT_BANK_ACC_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(BG_NAME                        ,
BANK_ACCOUNT_NUMBER            ,
BANK_NUMBER                    ,
BANK_NAME                      ,
BRANCH_NAME                    ,
CURRENCY_CODE                  ,
COUNTRY_CODE                   ,
SEC_ACCOUNT_REF                ,
SORT_CODE                      ,
PERSON_NUMBER                  ,
EXT_BANK_ACC_OWNER             ,
PRIMARY_FLAG                   ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               
)

