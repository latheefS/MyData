LOAD DATA
INFILE XXMX_OLC_ADHOC_RESOURCE.dat
REPLACE 
INTO  TABLE XXMX_OLC_ADHOC_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
ADHOC_RESOURCE_NUMBER          ,
NAME                           ,
DESCRIPTION                    ,
QUANTITY                       ,
ACTIVITY_NUMBER                
)

