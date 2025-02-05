--------------------------------------------------------
--  DDL for Table XXMX_HZ_ROLE_RESPS_XFM
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"INSERT_UPDATE_CODE" VARCHAR2(30 BYTE), 
	"INSERT_UPDATE_FLAG" VARCHAR2(1 BYTE), 
	"CUST_CONTACT_ORIG_SYSTEM" VARCHAR2(30 BYTE), 
	"CUST_CONTACT_ORIG_SYS_REF" VARCHAR2(240 BYTE), 
	"ROLE_RESP_ORIG_SYSTEM" VARCHAR2(30 BYTE), 
	"ROLE_RESP_ORIG_SYS_REF" VARCHAR2(240 BYTE), 
	"RESPONSIBILITY_TYPE" VARCHAR2(30 BYTE), 
	"PRIMARY_FLAG" VARCHAR2(1 BYTE), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"ATTRIBUTE21" VARCHAR2(150 BYTE), 
	"ATTRIBUTE22" VARCHAR2(150 BYTE), 
	"ATTRIBUTE23" VARCHAR2(150 BYTE), 
	"ATTRIBUTE24" VARCHAR2(150 BYTE), 
	"ATTRIBUTE25" VARCHAR2(150 BYTE), 
	"ATTRIBUTE26" VARCHAR2(150 BYTE), 
	"ATTRIBUTE27" VARCHAR2(150 BYTE), 
	"ATTRIBUTE28" VARCHAR2(150 BYTE), 
	"ATTRIBUTE29" VARCHAR2(150 BYTE), 
	"ATTRIBUTE30" VARCHAR2(255 BYTE), 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"ATTRIBUTE_NUMBER11" NUMBER, 
	"ATTRIBUTE_NUMBER12" NUMBER, 
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_DATE11" DATE, 
	"ATTRIBUTE_DATE12" DATE, 
	"LOAD_REQUEST_ID" NUMBER, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" VARCHAR2(100 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_HZ_ROLE_RESPS_XFM" TO "XXMX_CORE";
