--------------------------------------------------------
--  DDL for Table XXPA_PROJECT_PARTIES_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXPA_PROJECT_PARTIES_STG" 
   (	"PROJECT_PARTY_ID" NUMBER(15,0), 
	"OBJECT_ID" NUMBER, 
	"OBJECT_TYPE" VARCHAR2(30 BYTE), 
	"PROJECT_ID" NUMBER(15,0), 
	"RESOURCE_ID" NUMBER(15,0), 
	"RESOURCE_TYPE_ID" NUMBER(15,0), 
	"RESOURCE_SOURCE_ID" NUMBER(15,0), 
	"PROJECT_ROLE_ID" NUMBER, 
	"START_DATE_ACTIVE" DATE, 
	"END_DATE_ACTIVE" DATE, 
	"SCHEDULED_FLAG" VARCHAR2(1 BYTE), 
	"RECORD_VERSION_NUMBER" NUMBER, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" NUMBER, 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER, 
	"LAST_UPDATE_LOGIN" NUMBER, 
	"GRANT_ID" RAW(16)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;