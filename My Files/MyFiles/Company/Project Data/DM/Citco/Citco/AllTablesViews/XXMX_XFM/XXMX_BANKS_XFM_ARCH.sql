--------------------------------------------------------
--  DDL for Table XXMX_BANKS_XFM_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"MIGRATION_ACTION" VARCHAR2(10 BYTE), 
	"INSTITUTION_LEVEL" VARCHAR2(20 BYTE), 
	"BANK_NAME" VARCHAR2(360 BYTE), 
	"COUNTRY" VARCHAR2(60 BYTE), 
	"BANK_NUMBER" VARCHAR2(30 BYTE), 
	"ALTERNATE_BANK_NAME" VARCHAR2(320 BYTE), 
	"END_EFFECTIVE_DATE" DATE, 
	"SHORT_BANK_NAME" VARCHAR2(40 BYTE), 
	"BANK_ID" VARCHAR2(10 BYTE), 
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
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_BANKS_XFM_ARCH" TO "XXMX_CORE";