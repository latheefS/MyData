LOAD DATA
INFILE XXMX_HCM_ASG_SALARY.dat
REPLACE 
INTO  TABLE XXMX_PER_ASG_SALARY_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
ASSIGNMENT_NUMBER              ,
LEGISLATION_CODE               ,
NAME                           ,
PAY_BASIS_TYPE                 ,
MULTIPLE_COMPONENTS            ,
APPROVED                       ,
PROPOSED_SALARY                ,
NEXT_SAL_REVIEW_DATE           ,
FTE_VALUE                      ,
GRADE_VALUE                    ,
PERSONNUMBER                   
)

