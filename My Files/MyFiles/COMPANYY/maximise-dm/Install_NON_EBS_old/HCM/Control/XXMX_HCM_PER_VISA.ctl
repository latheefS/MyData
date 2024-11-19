LOAD DATA
INFILE XXMX_HCM_PER_VISA.dat
REPLACE 
INTO  TABLE XXMX_PER_VISA_F_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVESTARTDATE             ,
EFFECTIVEENDDATE               ,
PERSONNUMBER                   ,
LEGISLATIONCODE                ,
ENTRYDATE                      ,
EXPIRATIONDATE                 ,
CURRENTVISAPERMIT              ,
ISSUEDATE                      ,
ISSUINGAUTHORITY               ,
ISSUINGCOUNTRY                 ,
ISSUINGLOCATION                ,
PROFESSION                     ,
VISAPERMITCATEGORY             ,
VISAPERMITNUMBER               ,
VISAPERMITSTATUS               ,
VISAPERMITSTATUSDATE           ,
VISAPERMITTYPE                 
)

