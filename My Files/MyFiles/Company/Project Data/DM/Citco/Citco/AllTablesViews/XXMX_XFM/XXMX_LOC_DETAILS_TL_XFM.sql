--------------------------------------------------------
--  DDL for Table XXMX_LOC_DETAILS_TL_XFM
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" 
   (	"MIGRATION_SET_ID" NUMBER, 
	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER(15,0), 
	"LOCATION_DETAILS_ID" VARCHAR2(264 BYTE), 
	"EFFECTIVE_START_DATE" DATE, 
	"EFFECTIVE_END_DATE" DATE, 
	"LANGUAGE" VARCHAR2(4 BYTE), 
	"OBJECT_VERSION_NUMBER" NUMBER(9,0), 
	"LOCATION_CODE" VARCHAR2(60 BYTE), 
	"LOCATION_NAME" VARCHAR2(240 BYTE), 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"SOURCE_LANG" VARCHAR2(4 BYTE), 
	"AC_LOCATION_CODE" VARCHAR2(60 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_LOC_DETAILS_TL_XFM" TO "XXMX_CORE";