--------------------------------------------------------
--  DDL for Table XXMX_PPM_CREATE_TEAM_MEM
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_CREATE_TEAM_MEM" 
   (	"PROJECT_NUMBER" VARCHAR2(100 BYTE), 
	"PROJECT_ID" VARCHAR2(100 BYTE), 
	"PERSON_ID" VARCHAR2(100 BYTE), 
	"TEAM_MEMBER_NUMBER" VARCHAR2(100 BYTE), 
	"PROJECT_ROLE" VARCHAR2(100 BYTE), 
	"START_DATE_ACTIVE" VARCHAR2(100 BYTE), 
	"ERROR" VARCHAR2(4000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;