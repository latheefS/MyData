LOAD DATA
INFILE XXMX_HCM_PER_LEG.dat
REPLACE 
INTO  TABLE XXMX_PER_LEG_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEGISLATION_CODE               ,
SEX                            ,
MARITAL_STATUS                 ,
MARITAL_STATUS_DATE            ,
HIGHEST_EDUCATION_LEVEL        ,
PRIMARY_FLAG                   ,
PERSONNUMBER                   
)

