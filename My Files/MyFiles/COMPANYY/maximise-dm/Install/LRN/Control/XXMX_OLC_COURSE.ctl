LOAD DATA
INFILE XXMX_OLC_COURSE.dat
REPLACE 
INTO  TABLE XXMX_OLC_COURSE_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
COURSE_NUMBER                  ,
TITLE                          ,
SHORT_DESCRIPTION              ,
SYLLABUS                       ,
PUBLISH_START_DATE             ,
PUBLISH_END_DATE               ,
MINIMUM_EXPECTED_EFFORT        ,
MAXIMUM_EXPECTED_EFFORT        ,
CURRENCY_CODE                  ,
MINIMUM_PRICE                  ,
MAXIMUM_PRICE                  ,
COVER_ART_FILE                 ,
COVER_ART_FILE_NAME            ,
OWNED_BY_PERSON_NUMBER         ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    
)

