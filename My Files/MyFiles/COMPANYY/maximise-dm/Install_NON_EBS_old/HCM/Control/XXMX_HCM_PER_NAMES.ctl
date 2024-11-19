LOAD DATA
INFILE XXMX_HCM_PER_NAMES.dat
REPLACE 
INTO  TABLE XXMX_PER_NAMES_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FULL_NAME                      ,
LIST_NAME                      ,
ORDER_NAME                     ,
PERSONNUMBER                   ,
NAME_TYPE                      ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LEGISLATION_CODE               ,
LAST_NAME                      ,
FIRST_NAME                     ,
MIDDLE_NAMES                   ,
TITLE                          ,
PRE_NAME_ADJUNCT               ,
SUFFIX                         ,
KNOWN_AS                       ,
PREVIOUS_LAST_NAME             ,
HONORS                         ,
MILITARY_RANK                  ,
DISPLAY_NAME                   
)

