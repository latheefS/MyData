LOAD DATA
INFILE XXMX_OLC_CLASSROOM_RESOURCE.dat
REPLACE 
INTO  TABLE XXMX_OLC_CLASS_RES_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(BG_ID                          ,
CLASSROOM_RESOURCE_NUMBER      ,
TITLE                          ,
DESCRIPTION                    ,
CAPACITY                       ,
CONTACT_ID                     ,
CONTACT_NUMBER                 ,
LOCATION_ID                    ,
LOCATION_CODE                  ,
SET_CODE                       ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
OWNED_BY_PERSON_NUMBER         ,
MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        
)

