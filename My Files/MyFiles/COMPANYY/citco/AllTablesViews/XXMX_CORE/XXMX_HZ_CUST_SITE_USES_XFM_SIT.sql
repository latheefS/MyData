--------------------------------------------------------
--  DDL for Table XXMX_HZ_CUST_SITE_USES_XFM_SIT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_SITE_USES_XFM_SIT" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"ACCOUNT_NUMBER" VARCHAR2(30 BYTE), 
	"PARTY_SITE_NUMBER" VARCHAR2(30 BYTE), 
	"CUST_SITE_ORIG_SYSTEM" VARCHAR2(30 BYTE), 
	"CUST_SITE_ORIG_SYS_REF" VARCHAR2(240 BYTE), 
	"CUST_SITEUSE_ORIG_SYSTEM" VARCHAR2(30 BYTE), 
	"CUST_SITEUSE_ORIG_SYS_REF" VARCHAR2(240 BYTE), 
	"SITE_USE_CODE" VARCHAR2(30 BYTE), 
	"PRIMARY_FLAG" VARCHAR2(1 BYTE), 
	"INSERT_UPDATE_FLAG" VARCHAR2(1 BYTE), 
	"LOCATION" VARCHAR2(150 BYTE), 
	"SET_CODE" VARCHAR2(30 BYTE), 
	"START_DATE" DATE, 
	"END_DATE" DATE, 
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
	"LOAD_REQUEST_ID" NUMBER, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" VARCHAR2(100 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(100 BYTE), 
	"OU_NAME" VARCHAR2(500 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;