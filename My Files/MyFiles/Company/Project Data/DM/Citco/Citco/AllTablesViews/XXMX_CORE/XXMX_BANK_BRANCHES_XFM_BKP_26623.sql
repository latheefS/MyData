--------------------------------------------------------
--  DDL for Table XXMX_BANK_BRANCHES_XFM_BKP_26623
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_BANK_BRANCHES_XFM_BKP_26623" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"MIGRATION_ACTION" VARCHAR2(10 BYTE), 
	"INSTITUTION_LEVEL" VARCHAR2(20 BYTE), 
	"BANK_NAME" VARCHAR2(360 BYTE), 
	"BANK_NUMBER" VARCHAR2(30 BYTE), 
	"COUNTRY" VARCHAR2(60 BYTE), 
	"BANK_BRANCH_NUMBER" VARCHAR2(30 BYTE), 
	"BANK_BRANCH_NAME" VARCHAR2(360 BYTE), 
	"ALTERNATE_BANK_BRANCH_NAME" VARCHAR2(320 BYTE), 
	"BANK_BRANCH_TYPE" VARCHAR2(30 BYTE), 
	"EFT_SWIFT_CODE" VARCHAR2(30 BYTE), 
	"EFT_USER_NUMBER" VARCHAR2(30 BYTE), 
	"RFC" VARCHAR2(30 BYTE), 
	"END_EFFECTIVE_DATE" DATE, 
	"SHORT_BANK_NAME" VARCHAR2(40 BYTE), 
	"BANK_ID" VARCHAR2(10 BYTE), 
	"BRANCH_ID" VARCHAR2(10 BYTE), 
	"BANK_TYPE" VARCHAR2(30 BYTE), 
	"METADATA" VARCHAR2(10 BYTE), 
	"OBJECT_NAME" VARCHAR2(100 BYTE), 
	"SOURCESYSTEMID" VARCHAR2(2000 BYTE), 
	"SOURCESYSTEMOWNER" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;