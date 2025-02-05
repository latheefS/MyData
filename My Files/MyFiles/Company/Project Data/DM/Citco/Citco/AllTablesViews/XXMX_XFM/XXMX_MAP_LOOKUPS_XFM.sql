--------------------------------------------------------
--  DDL for Table XXMX_MAP_LOOKUPS_XFM
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" 
   (	"MAP_ID" VARCHAR2(64 BYTE), 
	"S_TYPE" VARCHAR2(1 BYTE), 
	"S_APPLICATION_ID" NUMBER(15,0), 
	"S_VIEW_APPLICATION_ID" NUMBER(18,0), 
	"S_LOOKUP_TYPE" VARCHAR2(30 BYTE), 
	"S_LOOKUP_CODE" VARCHAR2(30 BYTE), 
	"MODULE_ID" VARCHAR2(32 BYTE), 
	"T_VIEW_APPLICATION_ID" NUMBER(18,0), 
	"T_LOOKUP_TYPE" VARCHAR2(30 BYTE), 
	"T_LOOKUP_CODE" VARCHAR2(30 BYTE), 
	"MAPPED_FLAG" VARCHAR2(1 BYTE), 
	"MIGRATED_FLAG" VARCHAR2(1 BYTE), 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_MAP_LOOKUPS_XFM" TO "XXMX_CORE";
