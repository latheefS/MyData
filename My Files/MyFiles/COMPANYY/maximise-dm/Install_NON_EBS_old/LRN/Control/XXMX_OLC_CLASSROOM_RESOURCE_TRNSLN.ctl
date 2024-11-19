LOAD DATA
INFILE XXMX_OLC_CLASSROOM_RESOURCE_TRNSLN.dat
REPLACE 
INTO  TABLE XXMX_OLC_CLASS_RES_TL_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
LANGUAGE                       ,
CLASSROOM_RESOURCE_NUMBER      ,
TITLE                          ,
DESCRIPTION                    
)

