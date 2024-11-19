LOAD DATA
INFILE XXMX_OLC_LEG_LRNG_ITEM.dat
REPLACE 
INTO  TABLE XXMX_OLC_LEG_LEARN_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEARNING_ITEM_NUMBER           ,
TITLE                          ,
SHORT_DESCRIPTION              ,
OWNED_BY_PERSON_NUMBER         ,
SOURCE_TYPE                    ,
SOURCE_ID                      ,
SOURCE_INFO                    
)

