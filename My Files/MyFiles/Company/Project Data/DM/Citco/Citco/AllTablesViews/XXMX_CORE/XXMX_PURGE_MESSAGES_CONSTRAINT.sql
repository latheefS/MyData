--------------------------------------------------------
--  Constraints for Table XXMX_PURGE_MESSAGES
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("PURGE_MESSAGE_ID" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("APPLICATION_SUITE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("APPLICATION" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("BUSINESS_ENTITY" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("SUB_ENTITY" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("MESSAGE_TIMESTAMP" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PURGE_MESSAGES" MODIFY ("SEVERITY" NOT NULL ENABLE);