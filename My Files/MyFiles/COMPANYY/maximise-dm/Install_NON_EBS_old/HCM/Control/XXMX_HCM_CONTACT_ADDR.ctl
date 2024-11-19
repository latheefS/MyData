LOAD DATA
INFILE XXMX_HCM_CONTACT_ADDR.dat
REPLACE 
INTO  TABLE XXMX_PER_CONTACT_ADDR_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PRIMARYFLAG                    ,
CONTACT_PERSONNUM              ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVESTARTDATE             ,
EFFECTIVEENDDATE               ,
ADDRESSTYPE                    ,
ADDRESSLINE1                   ,
ADDRESSLINE2                   ,
ADDRESSLINE3                   ,
TOWNORCITY                     ,
REGION1                        ,
COUNTRY                        ,
POSTALCODE                     
)

