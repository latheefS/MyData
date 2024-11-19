LOAD DATA
INFILE XXMX_HCM_PER_IMAGES.dat
REPLACE 
INTO  TABLE XXMX_PER_IMAGES_STG
FIELDS TERMINATED BY "|" OPTIONALLY ENCLOSED BY '"'  TRAILING NULLCOLS 
(FILE_SET_ID                    ,
MIGRATION_SET_NAME             ,
MIGRATION_STATUS               ,
BG_NAME                        ,
PERSONNUMBER                   ,
IMAGENAME                      ,
IMAGE_REF                      ,
IMAGETYPE                      ,
PRIMARY_FLAG                   
)

