LOAD DATA
INFILE XXMX_HCM_PER_DISABILITY.dat
REPLACE 
INTO  TABLE XXMX_PER_DISABILITY_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONNUMBER                   ,
ORGANIZATIONNAME               ,
ORGANIZATIONCLASSCODE          ,
REGISTRATIONDATE               ,
REGISTRATIONEXPDATE            ,
ASSESSMENTDUEDATE              ,
CATEGORY                       ,
DESCRIPTION                    ,
DEGREE                         ,
QUOTAFTE                       ,
REASON                         ,
PREREGISTRATIONJOB             ,
WORKRESTRICTION                ,
STATUS                         ,
LEGISLATIONCODE                ,
EFFECTIVESTARTDATE             ,
EFFECTIVEENDDATE               
)

