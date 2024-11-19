--------------------------------------------------------
--  DDL for Procedure DROPSEQUENCE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."DROPSEQUENCE" (pSequence IN VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pSequence ;
EXCEPTION
   WHEN OTHERS THEN
	  IF SQLCODE != -02289 THEN
		 RAISE;
	  END IF;
END DropSequence ;

/
