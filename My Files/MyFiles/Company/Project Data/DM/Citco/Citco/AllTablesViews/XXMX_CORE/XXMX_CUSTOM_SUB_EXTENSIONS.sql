--------------------------------------------------------
--  DDL for Table XXMX_CUSTOM_SUB_EXTENSIONS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_CUSTOM_SUB_EXTENSIONS" 
   (	"APPLICATION_SUITE" VARCHAR2(5 BYTE), 
	"APPLICATION" VARCHAR2(5 BYTE), 
	"BUSINESS_ENTITY" VARCHAR2(30 BYTE), 
	"SUB_ENTITY" VARCHAR2(60 BYTE), 
	"PHASE" VARCHAR2(20 BYTE), 
	"EXTENSION_SOURCE" VARCHAR2(20 BYTE), 
	"SCHEMA_NAME" VARCHAR2(128 BYTE), 
	"EXTENSION_PACKAGE" VARCHAR2(30 BYTE), 
	"EXTENSION_PROCEDURE" VARCHAR2(30 BYTE), 
	"EXECUTION_SEQUENCE" NUMBER(2,0), 
	"EXECUTE_NEXT_ON_ERROR" VARCHAR2(1 BYTE), 
	"ENABLED_FLAG" VARCHAR2(1 BYTE), 
	"COMMENTS" VARCHAR2(2000 BYTE), 
	"CREATION_DATE" DATE, 
	"CREATED_BY" VARCHAR2(240 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(240 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_CUSTOM_SUB_EXTENSIONS" TO "XXMX_READONLY";