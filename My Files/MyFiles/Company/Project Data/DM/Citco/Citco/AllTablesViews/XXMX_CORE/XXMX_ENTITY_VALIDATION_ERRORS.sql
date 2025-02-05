--------------------------------------------------------
--  DDL for Table XXMX_ENTITY_VALIDATION_ERRORS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_ENTITY_VALIDATION_ERRORS" 
   (	"ENTITY_CODE" VARCHAR2(30 BYTE), 
	"SUB_ENTITY_CODE" VARCHAR2(30 BYTE), 
	"TABLE_NAME" VARCHAR2(30 BYTE), 
	"KEY_VALUE" VARCHAR2(30 BYTE), 
	"COLUMN_NAME" VARCHAR2(30 BYTE), 
	"COLUMN_VALUE" VARCHAR2(100 BYTE), 
	"ERROR_MESSAGE" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
