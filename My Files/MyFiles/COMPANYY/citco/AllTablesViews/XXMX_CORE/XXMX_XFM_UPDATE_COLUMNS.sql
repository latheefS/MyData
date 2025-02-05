--------------------------------------------------------
--  DDL for Table XXMX_XFM_UPDATE_COLUMNS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" 
   (	"MANDATORY" VARCHAR2(20 BYTE), 
	"INCLUDE_IN_OUTBOUND_FILE" VARCHAR2(20 BYTE), 
	"COLUMN_NAME" VARCHAR2(128 BYTE), 
	"TABLE_NAME" VARCHAR2(200 BYTE), 
	"FUSION_TEMPLATE_FIELD_NAME" VARCHAR2(150 BYTE), 
	"FUSION_TEMPLATE_SHEET_NAME" VARCHAR2(150 BYTE), 
	"USER_KEY" VARCHAR2(1 BYTE), 
	"APPL_NAME" VARCHAR2(30 BYTE), 
	"TRANSFORM_CODE" VARCHAR2(300 BYTE), 
	"DEFAULT_VALUE" VARCHAR2(200 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT DEBUG ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT QUERY REWRITE ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT ON COMMIT REFRESH ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT READ ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT REFERENCES ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT UPDATE ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT SELECT ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT INSERT ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT INDEX ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT DELETE ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
  GRANT ALTER ON "XXMX_CORE"."XXMX_XFM_UPDATE_COLUMNS" TO "XXMX_XFM";
