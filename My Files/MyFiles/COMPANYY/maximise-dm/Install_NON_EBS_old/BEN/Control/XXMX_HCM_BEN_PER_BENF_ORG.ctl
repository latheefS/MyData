LOAD DATA
INFILE XXMX_HCM_BEN_PER_BENF_ORG.dat
REPLACE 
INTO  TABLE XXMX_BEN_PBO_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(PERSON_NUMBER                  ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PER_BNF_ORG_ID                 ,
START_DATE                     ,
END_DATE                       ,
BNF_TYP_CD                     ,
BNF_ORGANIZATION_ID            ,
TRUSTEE_ORG_NAME               ,
TRUSTEE_ORG_REG_CD             ,
TRUSTEE_ORG_DESCRIPTION        ,
TRUSTEE_ADDL_DETAILS           ,
TRUSTEE_EXECUTOR_NAME          ,
ORGANIZATION_NAME              
)

