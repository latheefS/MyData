--------------------------------------------------------
--  DDL for Table XXMX_POSITION_PROFILES_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_POSITION_PROFILES_STG" 
   (	"POSITION_CODE" VARCHAR2(50 BYTE), 
	"RESPONSIBILITY" VARCHAR2(500 BYTE), 
	"QUALIFICATION" VARCHAR2(500 BYTE), 
	"DESCRIPTION" VARCHAR2(500 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
