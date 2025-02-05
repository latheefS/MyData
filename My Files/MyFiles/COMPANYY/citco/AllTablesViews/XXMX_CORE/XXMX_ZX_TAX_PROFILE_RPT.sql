--------------------------------------------------------
--  DDL for Table XXMX_ZX_TAX_PROFILE_RPT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_ZX_TAX_PROFILE_RPT" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"PARTY_TYPE_CODE" VARCHAR2(80 BYTE), 
	"PARTY_NUMBER" VARCHAR2(30 BYTE), 
	"PARTY_NAME" VARCHAR2(150 BYTE), 
	"PROCESS_FOR_APPLICABILITY_FLAG" VARCHAR2(3 BYTE), 
	"ROUNDING_LEVEL_CODE" VARCHAR2(80 BYTE), 
	"ROUNDING_RULE_CODE" VARCHAR2(80 BYTE), 
	"TAX_CLASSIFICATION_CODE" VARCHAR2(30 BYTE), 
	"INCLUSIVE_TAX_FLAG" VARCHAR2(3 BYTE), 
	"ALLOW_OFFSET_TAX_FLAG" VARCHAR2(3 BYTE), 
	"COUNTRY_CODE" VARCHAR2(2 BYTE), 
	"REGISTRATION_TYPE_CODE" VARCHAR2(80 BYTE), 
	"REP_REGISTRATION_NUMBER" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
