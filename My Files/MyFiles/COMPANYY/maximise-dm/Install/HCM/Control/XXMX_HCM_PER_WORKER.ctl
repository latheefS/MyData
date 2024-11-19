LOAD DATA
INFILE XXMX_HCM_PER_WORKER.dat
REPLACE 
INTO  TABLE XXMX_PER_PEOPLE_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PERSON_NUMBER                  ,
WAIVE_DATA_PROTECT             ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
START_DATE                     ,
APPLICANT_NUMBER               ,
PERSON_TYPE                    
)

