--------------------------------------------------------
--  DDL for Table XXMX_FA_LOCATIONS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_FA_LOCATIONS" 
   (	"COUNTRY" VARCHAR2(360 BYTE), 
	"STATE" VARCHAR2(360 BYTE), 
	"REGION" VARCHAR2(360 BYTE), 
	"CITY" VARCHAR2(360 BYTE), 
	"ENABLED_FLAG" VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;