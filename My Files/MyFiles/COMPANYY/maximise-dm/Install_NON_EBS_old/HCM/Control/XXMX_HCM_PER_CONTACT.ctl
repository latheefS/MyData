LOAD DATA
INFILE XXMX_HCM_PER_CONTACT.dat
REPLACE 
INTO  TABLE XXMX_PER_CONTACTS_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
START_DATE                     ,
CORRESPONDENCE_LANGUAGE        ,
BLOOD_TYPE                     ,
DATE_OF_BIRTH                  ,
DATE_OF_DEATH                  ,
COUNTRY_OF_BIRTH               ,
REGION_OF_BIRTH                ,
TOWN_OF_BIRTH                  ,
NAMETYPE                       ,
LAST_NAME                      ,
FIRST_NAME                     ,
MIDDLE_NAMES                   ,
LEGISLATION_CODE               ,
TITLE                          ,
PRE_NAME_ADJUNCT               ,
SUFFIX                         ,
KNOWN_AS                       ,
PREVIOUS_LAST_NAME             ,
PERSONNUMBER                   ,
CNTPERSONNUMBER                
)

