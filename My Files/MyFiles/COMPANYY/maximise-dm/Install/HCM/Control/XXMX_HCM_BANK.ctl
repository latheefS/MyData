LOAD DATA
INFILE XXMX_HCM_BANK.dat
REPLACE 
INTO  TABLE XXMX_BANKS_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PERSONNUMBER                   ,
BANK_TYPE                      ,
SHORT_BANK_NAME                ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
INSTITUTION_LEVEL              ,
BANK_NAME                      ,
COUNTRY                        ,
BANK_NUMBER                    ,
ALTERNATE_BANK_NAME            ,
END_EFFECTIVE_DATE             
)

