LOAD DATA
INFILE XXMX_HCM_ASG_WORKMSURE.dat
REPLACE 
INTO  TABLE XXMX_ASG_WORKMSURE_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
ASSIGNMENT_NUMBER              ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEGISLATION_CODE               ,
UNIT                           ,
VALUE                          ,
PERSONNUMBER                   
)

