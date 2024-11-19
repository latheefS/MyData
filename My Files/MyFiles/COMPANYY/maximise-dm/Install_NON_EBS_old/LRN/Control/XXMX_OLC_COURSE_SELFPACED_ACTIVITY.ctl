LOAD DATA
INFILE XXMX_OLC_COURSE_SELFPACED_ACTIVITY.dat
REPLACE 
INTO  TABLE XXMX_OLC_SALFPACE_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(DESCRIPTION_TEXT               ,
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
EXPECTED_EFFORT                ,
SELF_COMPLETE_FLAG             ,
CONTENT_NUMBER                 ,
OFFERING_NUMBER                ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    
)

