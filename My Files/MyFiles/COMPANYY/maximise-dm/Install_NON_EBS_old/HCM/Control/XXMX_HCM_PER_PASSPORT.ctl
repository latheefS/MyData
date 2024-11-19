LOAD DATA
INFILE XXMX_HCM_PER_PASSPORT.dat
REPLACE 
INTO  TABLE XXMX_PER_PASSPORT_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(BG_NAME                        ,
PERSONNUMBER                   ,
LEGISLATIONCODE                ,
PASSPORTTYPE                   ,
PASSPORTNUMBER                 ,
ISSUEDATE                      ,
EXPIRATIONDATE                 ,
ISSUINGAUTHORITY               ,
ISSUINGCOUNTRY                 ,
ISSUINGLOCATION                ,
PROFESSION                     ,
ECNR_REQUIRED                  ,
NAME                           ,
FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               
)

