LOAD DATA
INFILE XXMX_OLC_NON_CATALOG_LRNG_ITEM.dat
REPLACE 
INTO  TABLE XXMX_OLC_NONCAT_LEARN_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEARNING_ITEM_NUMBER           ,
TITLE                          ,
DESCRIPTION                    ,
DURATION                       ,
PRICE                          ,
CURRENCY_CODE                  ,
OWNED_BY_PERSON_NUMBER         ,
NON_CATALOG_URL                ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    ,
MIGRATION_SET_ID               
)

