LOAD DATA
INFILE XXMX_OLC_INSTRUCTOR_LED_ACTIVITY.dat
REPLACE 
INTO  TABLE XXMX_OLC_INSTR_LED_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(OFFERING_NUMBER                ,
VIRTUAL_CLASSROOM_URL          ,
CLASSROOM_RESOURCE_NUMBER      ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    ,
DESCRIPTION_TEXT               ,
VIRTUAL_PROVIDER_NUMBER        ,
VIRTUAL_PROVIDER_PRODUCT       ,
MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
ACTIVITY_NUMBER                ,
ACTIVITY_POSITION              ,
TITLE                          ,
DESCRIPTION                    ,
ACTIVITY_DATE                  ,
ACTIVITY_START_TIME            ,
ACTIVITY_END_TIME              ,
TIME_ZONE                      ,
EXPECTED_EFFORT                ,
SELF_COMPLETE_FLAG             
)

