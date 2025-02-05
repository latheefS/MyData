--------------------------------------------------------
--  DDL for Table XXMX_STG_UPDATE_COLUMNS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" 
   (	"MANDATORY" VARCHAR2(20 BYTE), 
	"INCLUDE_IN_CONTROL_FILE" VARCHAR2(20 BYTE), 
	"COLUMN_NAME" VARCHAR2(128 BYTE), 
	"TABLE_NAME" VARCHAR2(200 BYTE), 
	"APPL_NAME" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT DEBUG ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT QUERY REWRITE ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT ON COMMIT REFRESH ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT READ ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT REFERENCES ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT UPDATE ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT SELECT ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT INSERT ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT ALTER ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT INDEX ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
  GRANT DELETE ON "XXMX_CORE"."XXMX_STG_UPDATE_COLUMNS" TO "XXMX_STG";
