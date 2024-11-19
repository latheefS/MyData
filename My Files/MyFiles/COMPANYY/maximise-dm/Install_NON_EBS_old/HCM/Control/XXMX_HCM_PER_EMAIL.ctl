LOAD DATA
INFILE XXMX_HCM_PER_EMAIL.dat
REPLACE 
INTO  TABLE XXMX_PER_EMAIL_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EMAIL_TYPE                     ,
DATE_FROM                      ,
DATE_TO                        ,
EMAIL_ADDRESS                  ,
PERSONNUMBER                   ,
PRIMARY_FLAG                   
)

