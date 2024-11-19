--------------------------------------------------------
--  Constraints for Table XXMX_SOURCE_OPERATING_UNITS
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_SOURCE_OPERATING_UNITS" MODIFY ("SOURCE_OPERATING_UNIT_NAME" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_SOURCE_OPERATING_UNITS" MODIFY ("MIGRATION_ENABLED_FLAG" NOT NULL ENABLE);
