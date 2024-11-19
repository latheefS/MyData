--------------------------------------------------------
--  File created - Friday-January-12-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View XXMX_GL_LEDGER_MAPS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_GL_LEDGER_MAPS_V" ("SOURCE_LEDGER_NAME", "FUSION_LEDGER_NAME") AS 
  SELECT  DISTINCT
             source_ledger_name
            ,fusion_ledger_name
     FROM    xxmx_gl_segment_1_to_1_maps
     WHERE   1 = 1
;
REM INSERTING into XXMX_CORE.XXMX_GL_LEDGER_MAPS_V
SET DEFINE OFF;
Insert into XXMX_CORE.XXMX_GL_LEDGER_MAPS_V (SOURCE_LEDGER_NAME,FUSION_LEDGER_NAME) values ('SCH','SMBC Primary');
Insert into XXMX_CORE.XXMX_GL_LEDGER_MAPS_V (SOURCE_LEDGER_NAME,FUSION_LEDGER_NAME) values ('Vision Utilities','SMBC Primary');
Insert into XXMX_CORE.XXMX_GL_LEDGER_MAPS_V (SOURCE_LEDGER_NAME,FUSION_LEDGER_NAME) values ('Vision ADB Holdings (UK)','SMBC Primary');
Insert into XXMX_CORE.XXMX_GL_LEDGER_MAPS_V (SOURCE_LEDGER_NAME,FUSION_LEDGER_NAME) values ('SOLIHULL MBC SET OF BOOKS','SMBC Primary');
