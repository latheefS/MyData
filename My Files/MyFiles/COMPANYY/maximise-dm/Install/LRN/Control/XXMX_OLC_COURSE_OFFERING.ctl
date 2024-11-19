LOAD DATA
INFILE XXMX_OLC_COURSE_OFFERING.dat
REPLACE 
INTO  TABLE XXMX_OLC_OFFER_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
OFFERING_NUMBER                ,
TITLE                          ,
DESCRIPTION                    ,
DESCRIPTION_TEXT               ,
OFFERING_TYPE                  ,
PUBLISH_START_DATE             ,
PUBLISH_END_DATE               ,
OFFERING_START_DATE            ,
OFFERING_END_DATE              ,
PRIMARY_LOCATION_NUMBER        ,
LANGUAGE_CODE                  ,
FACILITATOR_TYPE               ,
PRIMARY_INSTRUCTOR_NUMBER      ,
TRAINING_SUPPLIER_NUMBER       ,
COORDINATOR_NUMBER             ,
ENABLE_CAPACITY                ,
MINIMUM_CAPACITY               ,
MAXIMUM_CAPACITY               ,
ENABLE_WAITLIST                ,
QUESTIONNAIRE_CODE             ,
QSTNR_REQUIRED_FOR_COMPLETION  ,
COURSE_NUMBER                  ,
OWNED_BY_PERSON_NUMBER         ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    ,
MIGRATION_SET_ID               
)

