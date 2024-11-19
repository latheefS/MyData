LOAD DATA
INFILE XXMX_OLC_SPECIALIZATION.dat
REPLACE 
INTO  TABLE XXMX_OLC_SPEC_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
SPECIALIZATION_NUMBER          ,
TITLE                          ,
SHORT_DESCRIPTION              ,
DESCRIPTION                    ,
PUBLISH_START_DATE             ,
PUBLISH_END_DATE               ,
COVER_ART_FILE                 ,
COVER_ART_FILE_NAME            ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    ,
OWNED_BY_PERSON_NUMBER         ,
MINIMUM_EXPECTED_EFFORT        ,
MAXIMUM_EXPECTED_EFFORT        
)

