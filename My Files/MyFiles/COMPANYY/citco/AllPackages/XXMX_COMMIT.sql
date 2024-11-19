--------------------------------------------------------
--  DDL for Procedure XXMX_COMMIT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_COMMIT" as
-- This procedure is called by OIC process that generates the csv file to be
-- loaded into cloud.
-- Changes
-- Date
-- --------- ----------------- -------------------------------------------------
-- 04/10/2022 Michal Arrowsmith Replaced sys.dbms_lock.sleep with 
--                              sys.dbms_session.sleep as this has changed since
--                               18c.   Change back if your db is pre 18c
begin 
commit;
--sys.dbms_lock.sleep(40);
sys.dbms_session.sleep(40);
end;

/
