--------------------------------------------------------
--  DDL for Index XXMX_MIGRATION_METADATA_N3
--------------------------------------------------------

  CREATE INDEX "XXMX_CORE"."XXMX_MIGRATION_METADATA_N3" ON "XXMX_CORE"."XXMX_MIGRATION_METADATA" ("XFM_TABLE", "ENABLED_FLAG", "APPLICATION_SUITE", "BUSINESS_ENTITY", "SUB_ENTITY") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
