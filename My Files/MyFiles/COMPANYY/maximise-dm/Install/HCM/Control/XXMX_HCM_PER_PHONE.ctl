LOAD DATA
INFILE XXMX_HCM_PER_PHONE.dat
REPLACE 
INTO  TABLE XXMX_PER_PHONES_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(VALIDITY                       ,
COUNTRY_CODE_NUMBER            ,
EXTENSION                      ,
LEGISLATION_CODE               ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
DATE_FROM                      ,
DATE_TO                        ,
PHONE_TYPE                     ,
PHONE_NUMBER                   ,
SPEED_DIAL_NUMBER              ,
MEANING                        ,
AREA_CODE                      ,
SEARCH_PHONE_NUMBER            ,
PERSONNUMBER                   ,
PRIMARY_FLAG                   
)

