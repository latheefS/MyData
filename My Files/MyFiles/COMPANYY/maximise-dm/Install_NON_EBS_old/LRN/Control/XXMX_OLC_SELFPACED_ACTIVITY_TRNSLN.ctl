LOAD DATA
INFILE XXMX_OLC_SELFPACED_ACTIVITY_TRNSLN.dat
REPLACE 
INTO  TABLE XXMX_OLC_SALFPACE_TL_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(BG_ID                          ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LANGUAGE                       ,
ACTIVITY_NUMBER                ,
TITLE                          ,
DESCRIPTION                    ,
DESCRIPTION_TEXT               ,
MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        
)

