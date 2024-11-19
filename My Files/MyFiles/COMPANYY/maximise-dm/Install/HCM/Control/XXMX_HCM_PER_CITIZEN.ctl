LOAD DATA
INFILE XXMX_HCM_PER_CITIZEN.dat
REPLACE 
INTO  TABLE XXMX_CITIZENSHIPS_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
DATE_FROM                      ,
DATE_TO                        ,
LEGISLATION_CODE               ,
CITIZENSHIP_STATUS             ,
PERSONNUMBER                   
)

