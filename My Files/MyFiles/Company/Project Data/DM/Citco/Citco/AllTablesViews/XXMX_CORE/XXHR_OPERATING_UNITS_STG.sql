--------------------------------------------------------
--  DDL for Table XXHR_OPERATING_UNITS_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXHR_OPERATING_UNITS_STG" 
   (	"BUSINESS_GROUP_ID" NUMBER(15,0), 
	"ORGANIZATION_ID" NUMBER(15,0), 
	"NAME" VARCHAR2(240 BYTE), 
	"DATE_FROM" DATE, 
	"DATE_TO" DATE, 
	"SHORT_CODE" VARCHAR2(150 BYTE), 
	"SET_OF_BOOKS_ID" VARCHAR2(150 BYTE), 
	"DEFAULT_LEGAL_CONTEXT_ID" VARCHAR2(150 BYTE), 
	"USABLE_FLAG" VARCHAR2(150 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
