--------------------------------------------------------
--  DDL for Table XXMX_ORC_DM_ONLINE_PHONES
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_ORC_DM_ONLINE_PHONES" 
   (	"COUNTRY" VARCHAR2(5 BYTE), 
	"COUNTRY_CODE" VARCHAR2(10 BYTE), 
	"AREA_CODE" VARCHAR2(10 BYTE), 
	"PHONE_NUMBER" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;