LOAD DATA
INFILE XXMX_HCM_PER_ETHNICITY.dat
REPLACE 
INTO  TABLE XXMX_PER_ETHNICITIES_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
LEGISLATION_CODE               ,
ETHNICITY                      ,
DECLARER_ID                    ,
PRIMARY_FLAG                   ,
PERSONNUMBER                   ,
DECLARERPERSONNUMBER           
)

