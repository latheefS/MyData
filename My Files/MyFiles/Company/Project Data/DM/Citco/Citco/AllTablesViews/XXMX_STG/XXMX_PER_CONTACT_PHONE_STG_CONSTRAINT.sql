--------------------------------------------------------
--  Constraints for Table XXMX_PER_CONTACT_PHONE_STG
--------------------------------------------------------

  ALTER TABLE "XXMX_STG"."XXMX_PER_CONTACT_PHONE_STG" MODIFY ("DATEFROM" NOT NULL ENABLE);
  ALTER TABLE "XXMX_STG"."XXMX_PER_CONTACT_PHONE_STG" MODIFY ("PHONETYPE" NOT NULL ENABLE);
  ALTER TABLE "XXMX_STG"."XXMX_PER_CONTACT_PHONE_STG" MODIFY ("PHONENUMBER" NOT NULL ENABLE);
  ALTER TABLE "XXMX_STG"."XXMX_PER_CONTACT_PHONE_STG" MODIFY ("RELATEDPERSONNUM" NOT NULL ENABLE);
  ALTER TABLE "XXMX_STG"."XXMX_PER_CONTACT_PHONE_STG" MODIFY ("CONTACT_PERSONNUM" NOT NULL ENABLE);