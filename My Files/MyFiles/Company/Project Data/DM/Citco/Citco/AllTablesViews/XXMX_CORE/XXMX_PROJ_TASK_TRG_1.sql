--------------------------------------------------------
--  DDL for Trigger XXMX_PROJ_TASK_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "XXMX_CORE"."XXMX_PROJ_TASK_TRG" 
before insert on XXMX_PROJ_TASK_BILL_CHARG_TBL
for each row
   WHEN (NEW.s_no is null) begin
:new.s_no :=xxmx_PROJ_TASK_seq.nextval;
END;


/
ALTER TRIGGER "XXMX_CORE"."XXMX_PROJ_TASK_TRG" ENABLE;
