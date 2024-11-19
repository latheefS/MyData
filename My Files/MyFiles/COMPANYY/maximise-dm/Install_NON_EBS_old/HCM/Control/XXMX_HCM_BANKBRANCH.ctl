LOAD DATA
INFILE XXMX_HCM_BANKBRANCH.dat
REPLACE 
INTO  TABLE XXMX_BANK_BRANCHES_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PERSONNUMBER                   ,
BANK_TYPE                      ,
SHORT_BANK_NAME                ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
INSTITUTION_LEVEL              ,
BANK_NAME                      ,
BANK_NUMBER                    ,
COUNTRY                        ,
BANK_BRANCH_NUMBER             ,
BANK_BRANCH_NAME               ,
ALTERNATE_BANK_BRANCH_NAME     ,
BANK_BRANCH_TYPE               ,
EFT_SWIFT_CODE                 ,
EFT_USER_NUMBER                ,
RFC                            ,
END_EFFECTIVE_DATE             
)

