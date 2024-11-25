--------------------------------------------------------
--  Constraints for Table XXMX_TAX_TYPE
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_TAX_TYPE" MODIFY ("INCOME_TAX_TYPE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_TAX_TYPE" ADD CONSTRAINT "XXMX_TAX_TYPE_PK" PRIMARY KEY ("INCOME_TAX_TYPE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
