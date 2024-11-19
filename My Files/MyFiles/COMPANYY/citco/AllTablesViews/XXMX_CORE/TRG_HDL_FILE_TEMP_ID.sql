--------------------------------------------------------
--  DDL for Trigger TRG_HDL_FILE_TEMP_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "XXMX_CORE"."TRG_HDL_FILE_TEMP_ID" 
BEFORE INSERT ON xxmx_hdl_file_temp  FOR EACH ROW
BEGIN
SELECT xxmx_person_migr_temp_s.NEXTVAL INTO :NEW.ID FROM dual;
EXCEPTION WHEN OTHERS THEN RAISE;
END;



/
ALTER TRIGGER "XXMX_CORE"."TRG_HDL_FILE_TEMP_ID" ENABLE;
