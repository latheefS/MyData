LOAD DATA
INFILE XXMX_HCM_PER_MAT_ABSENCE.dat
REPLACE 
INTO  TABLE XXMX_PER_MAT_ABSENCE_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(MIGRATION_SET_NAME             ,
FILE_SET_ID                    ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONNUMBER                   ,
ABSENCESTATUS                  ,
APPROVALSTATUS                 ,
STARTDATE                      ,
STARTTIME                      ,
ENDDATE                        ,
ENDTIME                        ,
ABSENCETYPE                    ,
ABSENCENAME                    ,
ABSENCECATEGORY                ,
DATE_NOTIFICATION              ,
ABSENCEREASON                  ,
ABSREASON_MEANING              ,
ABSCAT_MEANING                 ,
CONFIRMEDDATE                  ,
COMMENTS                       ,
ABSENCE_DAYS                   ,
ABSENCE_HOURS                  ,
LEGISLATIONCODE                ,
LEGAL_EMPLOYER_NAME            ,
INTENDTORETFLAG                ,
ACTUAL_BIRTH_DATE              ,
DUE_DATE                       ,
SSP1_ISSUED                    ,
EFFECTIVESTARTDATE             ,
EFFECTIVEENDDATE               ,
ASSIGNMENT_NUMBER              ,
STARTDATEDURATION              ,
ENDDATEDURATION                ,
PLANNEDENDDATE                 ,
PAYROLL_NAME                   
)

