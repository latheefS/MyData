--------------------------------------------------------
--  DDL for Table XXMX_CSV_FILE_TEMP_AMIT1
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_CSV_FILE_TEMP_AMIT1" 
   (	"ID" NUMBER(10,0), 
	"FILE_NAME" VARCHAR2(40 BYTE), 
	"LINE_TYPE" VARCHAR2(40 BYTE), 
	"LINE_CONTENT" CLOB, 
	"STATUS" VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" 
 LOB ("LINE_CONTENT") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_CSV_FILE_TEMP_AMIT1" TO "XXMX_READONLY";