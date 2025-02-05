--------------------------------------------------------
--  DDL for Table XXMX_HR_ALL_ORGANIZATION_UNITS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_HR_ALL_ORGANIZATION_UNITS" 
   (	"ORGANIZATION_ID" NUMBER(15,0), 
	"BUSINESS_GROUP_ID" NUMBER(15,0), 
	"COST_ALLOCATION_KEYFLEX_ID" NUMBER(9,0), 
	"LOCATION_ID" NUMBER(15,0), 
	"SOFT_CODING_KEYFLEX_ID" NUMBER(15,0), 
	"DATE_FROM" DATE, 
	"NAME" VARCHAR2(240 BYTE), 
	"DATE_TO" DATE, 
	"INTERNAL_EXTERNAL_FLAG" VARCHAR2(30 BYTE), 
	"INTERNAL_ADDRESS_LINE" VARCHAR2(80 BYTE), 
	"TYPE" VARCHAR2(30 BYTE), 
	"REQUEST_ID" NUMBER(15,0), 
	"PROGRAM_APPLICATION_ID" NUMBER(15,0), 
	"PROGRAM_ID" NUMBER(15,0), 
	"PROGRAM_UPDATE_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
