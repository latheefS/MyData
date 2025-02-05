--------------------------------------------------------
--  DDL for Table XXMX_JOB_REQ_MAP_TBL
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_JOB_REQ_MAP_TBL" 
   (	"CITY" VARCHAR2(2000 BYTE), 
	"COMPLETE_ADDRESS" VARCHAR2(2000 BYTE), 
	"CITY_CODE" VARCHAR2(2000 BYTE), 
	"POSTAL_CODE" VARCHAR2(2000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
