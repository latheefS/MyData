LOAD DATA
INFILE XXMX_HCM_ASG_GRADESTEP.dat
REPLACE 
INTO  TABLE XXMX_ASG_GRADESTEP_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
ASSIGNMENT_NUMBER              ,
EFFECTIVE_START_DATE           ,
EFFECTIVE_END_DATE             ,
LANGUAGE                       ,
GRADENAME                      ,
GRADESTEPNAME                  ,
NEWGRADESTEP                   ,
PART_FULL_TIME                 ,
ACTION_CODE                    ,
REASON_CODE                    ,
PERSONNUMBER                   
)

