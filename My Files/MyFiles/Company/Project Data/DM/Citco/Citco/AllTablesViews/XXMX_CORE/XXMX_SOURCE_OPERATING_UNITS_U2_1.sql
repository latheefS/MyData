--------------------------------------------------------
--  DDL for Index XXMX_SOURCE_OPERATING_UNITS_U2
--------------------------------------------------------

  CREATE INDEX "XXMX_CORE"."XXMX_SOURCE_OPERATING_UNITS_U2" ON "XXMX_CORE"."XXMX_SOURCE_OPERATING_UNITS" ("FUSION_BUSINESS_UNIT_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;