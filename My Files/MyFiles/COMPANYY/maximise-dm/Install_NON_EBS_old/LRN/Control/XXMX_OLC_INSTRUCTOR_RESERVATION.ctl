LOAD DATA
INFILE XXMX_OLC_INSTRUCTOR_RESERVATION.dat
REPLACE 
INTO  TABLE XXMX_OLC_INSTR_RESV_STG
FIELDS TERMINATED BY "|" TRAILING NULLCOLS 
(MIGRATION_SET_ID               ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
BG_ID                          ,
INSTRUCTOR_RESERVATION_NUMBER  ,
INSTRUCTOR_RESOURCE_NUMBER     ,
ACTIVITY_NUMBER                
)
