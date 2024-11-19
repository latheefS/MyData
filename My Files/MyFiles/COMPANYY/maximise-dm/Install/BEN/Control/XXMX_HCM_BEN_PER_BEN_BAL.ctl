LOAD DATA
INFILE XXMX_HCM_BEN_PER_BEN_BAL.dat
REPLACE 
INTO  TABLE XXMX_BEN_PBB_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(UOM                            ,
VAL                            ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSON_NUMBER                  ,
BENEFIT_BALANCE_NAME           ,
BENEFIT_RELATION_NAME          ,
ASSIGNMENT_NUMBER              ,
LEGAL_EMPLOYER                 ,
EFFECTIVE_END_DATE             ,
EFFECTIVE_START_DATE           ,
LEGAL_ENTITY_ID                ,
PER_BNFTS_BAL_ID               
)

