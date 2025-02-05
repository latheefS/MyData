--------------------------------------------------------
--  DDL for Table XXMX_HRT_CNT_ITEMS_TL_XFM
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" 
   (	"MIGRATION_SET_ID" NUMBER, 
	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER(15,0), 
	"CONTENT_ITEM_ID" VARCHAR2(264 BYTE), 
	"LANGUAGE" VARCHAR2(4 BYTE), 
	"SOURCE_LANG" VARCHAR2(4 BYTE), 
	"NAME" VARCHAR2(700 BYTE), 
	"ITEM_DESCRIPTION" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_1" VARCHAR2(240 BYTE), 
	"ITEM_TEXT_TL_2" VARCHAR2(240 BYTE), 
	"ITEM_TEXT_TL_3" VARCHAR2(240 BYTE), 
	"ITEM_TEXT_TL_4" VARCHAR2(240 BYTE), 
	"ITEM_TEXT_TL_5" VARCHAR2(240 BYTE), 
	"ITEM_TEXT_TL_6" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_7" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_8" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_9" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_10" VARCHAR2(2000 BYTE), 
	"ITEM_TEXT_TL_11" VARCHAR2(4000 BYTE), 
	"ITEM_TEXT_TL_12" VARCHAR2(4000 BYTE), 
	"ITEM_TEXT_TL_13" VARCHAR2(4000 BYTE), 
	"ITEM_TEXT_TL_14" VARCHAR2(4000 BYTE), 
	"ITEM_TEXT_TL_15" VARCHAR2(4000 BYTE), 
	"ITEM_DESCRLONG" VARCHAR2(4000 BYTE), 
	"OBJECT_VERSION_NUMBER" NUMBER(9,0), 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"CREATION_DATE" DATE, 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE), 
	"METADATA" VARCHAR2(10 BYTE) DEFAULT 'MERGE', 
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
  GRANT ALTER ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_HRT_CNT_ITEMS_TL_XFM" TO "XXMX_CORE";
