--------------------------------------------------------
--  DDL for Trigger TRG_CSV_FILE_TEMP_ID
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "XXMX_CORE"."TRG_CSV_FILE_TEMP_ID" 
BEFORE INSERT ON xxmx_csv_file_temp  FOR EACH ROW
BEGIN
SELECT xxmx_person_migr_temp_s.NEXTVAL INTO :NEW.ID FROM dual;
EXCEPTION WHEN OTHERS THEN RAISE;
END;



/
ALTER TRIGGER "XXMX_CORE"."TRG_CSV_FILE_TEMP_ID" ENABLE;
