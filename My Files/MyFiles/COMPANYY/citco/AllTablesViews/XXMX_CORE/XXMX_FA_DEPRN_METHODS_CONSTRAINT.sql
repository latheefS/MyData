--------------------------------------------------------
--  Constraints for Table XXMX_FA_DEPRN_METHODS
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" MODIFY ("METHOD_CODE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" MODIFY ("LIFE_IN_MONTHS" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" MODIFY ("RATE_SOURCE_RULE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" MODIFY ("DEPRN_BASIS_RULE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" MODIFY ("NAME" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_FA_DEPRN_METHODS" ADD CONSTRAINT "XXMX_FA_DEPRN_METHODS_PK" PRIMARY KEY ("METHOD_CODE", "LIFE_IN_MONTHS", "RATE_SOURCE_RULE", "DEPRN_BASIS_RULE", "NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;