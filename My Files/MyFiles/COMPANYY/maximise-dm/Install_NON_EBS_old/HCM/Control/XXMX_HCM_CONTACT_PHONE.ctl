LOAD DATA
INFILE XXMX_HCM_CONTACT_PHONE.dat
REPLACE 
INTO  TABLE XXMX_PER_CONTACT_PHONE_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PHONENUMBER                    ,
PRIMARYFLAG                    ,
RELATEDPERSONNUM               ,
CONTACT_PERSONNUM              ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
DATEFROM                       ,
DATETO                         ,
LEGISLATIONCODE                ,
COUNTRYCODENUMBER              ,
PHONETYPE                      
)

