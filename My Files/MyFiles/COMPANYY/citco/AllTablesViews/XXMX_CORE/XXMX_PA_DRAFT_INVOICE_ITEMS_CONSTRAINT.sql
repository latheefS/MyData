--------------------------------------------------------
--  Constraints for Table XXMX_PA_DRAFT_INVOICE_ITEMS
--------------------------------------------------------

  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("PROJECT_ID" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("DRAFT_INVOICE_NUM" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("LINE_NUM" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("LAST_UPDATE_DATE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("LAST_UPDATED_BY" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("CREATION_DATE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("CREATED_BY" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("AMOUNT" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("TEXT" NOT NULL ENABLE);
  ALTER TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" MODIFY ("INVOICE_LINE_TYPE" NOT NULL ENABLE);