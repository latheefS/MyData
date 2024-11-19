LOAD DATA
INFILE XXMX_HCM_PER_ADDRESS.dat
REPLACE 
INTO  TABLE XXMX_PER_ADDRESS_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONNUMBER                   ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
ADDRESS_LINE_1                 ,
ADDRESS_LINE_2                 ,
ADDRESS_LINE_3                 ,
ADDRESS_LINE_4                 ,
BUILDING                       ,
FLOOR_NUMBER                   ,
TOWN_OR_CITY                   ,
REGION_1                       ,
REGION_2                       ,
REGION_3                       ,
COUNTRY                        ,
COUNTRY_CODE                   ,
POSTAL_CODE                    ,
LONG_POSTAL_CODE               ,
TIMEZONE_CODE                  ,
DERIVED_LOCALE                 ,
GEOMETRY                       ,
PRIMARY_FLAG                   ,
TELEPHONE_NUMBER_1             ,
TELEPHONE_NUMBER_2             ,
TELEPHONE_NUMBER_3             ,
ADDRESS_STYLE                  ,
ADDRESS_TYPE                   ,
DQ_VALIDATION_LEVEL            
)

