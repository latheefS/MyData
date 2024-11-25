--------------------------------------------------------
--  DDL for Table XXMX_DM_SUBENTITY_FILE_MAP
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_DM_SUBENTITY_FILE_MAP" 
   (	"APPLICATION_SUITE" VARCHAR2(100 BYTE), 
	"APPLICATION" VARCHAR2(100 BYTE), 
	"BUSINESS_ENTITY" VARCHAR2(100 BYTE), 
	"SUB_ENTITY" VARCHAR2(100 BYTE), 
	"FILE_TYPE" VARCHAR2(100 BYTE), 
	"FILE_EXTENSION" VARCHAR2(100 BYTE), 
	"FILE_NAME" VARCHAR2(100 BYTE), 
	"EXCEL_FILE_HEADER" CLOB
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" 
 LOB ("EXCEL_FILE_HEADER") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_DM_SUBENTITY_FILE_MAP" TO "XXMX_READONLY";
