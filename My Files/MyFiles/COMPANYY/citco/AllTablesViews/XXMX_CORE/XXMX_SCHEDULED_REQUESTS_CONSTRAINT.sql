--------------------------------------------------------
--  Constraints for Table XXMX_SCHEDULED_REQUESTS
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_SCHEDULED_REQUESTS" MODIFY ("REQUEST_ID" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_SCHEDULED_REQUESTS" MODIFY ("MIGRATION_SET_ID" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_SCHEDULED_REQUESTS" MODIFY ("PROCEDURE_NAME" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_SCHEDULED_REQUESTS" MODIFY ("START_TIME" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_SCHEDULED_REQUESTS" MODIFY ("REQUEST_STATUS" NOT NULL ENABLE);