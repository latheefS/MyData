LOAD DATA
INFILE XXMX_OLC_INSTRUCTOR_RESOURCE.dat
REPLACE 
INTO  TABLE XXMX_OLC_INSTR_RES_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(PERSON_NUMBER                  ,
OWNED_BY_PERSON_NUMBER         ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
INSTRUCTOR_RESOURCE_NUMBER     
)

