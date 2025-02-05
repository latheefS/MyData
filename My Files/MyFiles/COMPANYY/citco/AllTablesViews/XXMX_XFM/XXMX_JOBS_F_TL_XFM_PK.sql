--------------------------------------------------------
--  DDL for Index XXMX_JOBS_F_TL_XFM_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "XXMX_XFM"."XXMX_JOBS_F_TL_XFM_PK" ON "XXMX_XFM"."XXMX_JOBS_F_TL_XFM" ("JOB_ID", "LANGUAGE", "EFFECTIVE_START_DATE", "EFFECTIVE_END_DATE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;
