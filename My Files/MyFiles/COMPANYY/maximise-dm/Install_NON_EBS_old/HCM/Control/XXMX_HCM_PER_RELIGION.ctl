LOAD DATA
INFILE XXMX_HCM_PER_RELIGION.dat
REPLACE 
INTO  TABLE XXMX_PER_RELIGION_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONNUMBER                   ,
LEGISLATIONCODE                ,
EFFECTIVESTARTDATE             ,
EFFECTIVEENDDATE               ,
RELIGION                       ,
PRIMARY_FLAG                   
)
