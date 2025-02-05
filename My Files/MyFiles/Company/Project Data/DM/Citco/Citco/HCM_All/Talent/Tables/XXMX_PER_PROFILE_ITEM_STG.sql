
  CREATE TABLE "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" 
   (	"MIGRATION_SET_ID" NUMBER, 
	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER(15,0), 
	"SOURCESYSTEMID" VARCHAR2(2000 BYTE), 
	"SOURCESYSTEMOWNER" VARCHAR2(50 BYTE), 
	"METADATA" VARCHAR2(10 BYTE), 
	"OBJECT_NAME" VARCHAR2(200 BYTE), 
	"PERSON_NUMBER" VARCHAR2(80 BYTE), 
	"PROFILECODE" VARCHAR2(80 BYTE), 
	"CONTENTITEMID" VARCHAR2(80 BYTE), 
	"PROFILEID" VARCHAR2(80 BYTE), 
	"SECTIONID" VARCHAR2(80 BYTE), 
	"OVERALL_RATING" VARCHAR2(80 BYTE), 
	"CONTENTTYPEID" VARCHAR2(80 BYTE), 
	"RATINGMODELID1" VARCHAR2(80 BYTE), 
	"RATINGMODELCODE1" VARCHAR2(80 BYTE), 
	"RATINGLEVELID1" VARCHAR2(80 BYTE), 
	"RATINGLEVELCODE1" VARCHAR2(80 BYTE), 
	"QUALIFIERID1" VARCHAR2(80 BYTE), 
	"QUALIFIERCODE1" VARCHAR2(80 BYTE), 
	"QUALIFIERSETCODE1" VARCHAR2(80 BYTE), 
	"DATEFROM" DATE, 
	"DATETO" DATE, 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"PERSON_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;


  GRANT INSERT ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PER_PROFILE_ITEM_STG" TO "XXMX_READONLY";
