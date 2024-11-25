--------------------------------------------------------
--  Constraints for Table XXMX_PAYMENT_METHOD
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_PAYMENT_METHOD" MODIFY ("PAYMENT_METHOD_CODE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PAYMENT_METHOD" MODIFY ("PAYMENT_METHOD_NAME" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PAYMENT_METHOD" ADD CONSTRAINT "XXMX_PAYMENT_METHOD_PK" PRIMARY KEY ("PAYMENT_METHOD_CODE", "PAYMENT_METHOD_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
