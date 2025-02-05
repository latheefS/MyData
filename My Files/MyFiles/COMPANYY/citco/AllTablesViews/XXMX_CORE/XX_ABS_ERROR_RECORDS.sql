--------------------------------------------------------
--  DDL for Table XX_ABS_ERROR_RECORDS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XX_ABS_ERROR_RECORDS" 
   (	"PERSON_NUMBER" VARCHAR2(10 BYTE), 
	"ABS_NAME" VARCHAR2(100 BYTE), 
	"START_DATE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
