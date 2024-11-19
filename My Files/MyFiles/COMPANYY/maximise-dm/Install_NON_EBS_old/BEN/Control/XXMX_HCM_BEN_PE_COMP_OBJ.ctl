LOAD DATA
INFILE XXMX_HCM_BEN_PE_COMP_OBJ.dat
REPLACE 
INTO  TABLE XXMX_BEN_PE_CO_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BEN_PLAN                       ,
BEN_PROGRAM                    ,
BEN_OPTION                     ,
ORIGINAL_ENROLLMENT_DATE       ,
RATE                           ,
COVERAGE                       ,
PERSON_NUMBER                  ,
DENROLL_BEN_PROGRAM            ,
DENROLL_BEN_PLAN               ,
DENROLL_BEN_OPTION             ,
LINE_NUMBER                    ,
ENROLLMENT_LINE_ID             
)

