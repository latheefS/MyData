
  CREATE TABLE "XXMX_STG"."XXMX_RESP_STG" 
   (	"MIGRATION_SET_ID" NUMBER NOT NULL ENABLE, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE) NOT NULL ENABLE, 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"METADATA" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"SOURCE_SYSTEM_ID" VARCHAR2(200 BYTE) NOT NULL ENABLE, 
	"SOURCE_SYSTEM_OWNER" VARCHAR2(30 BYTE), 
	"RECORD_TYPE" VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	"PERSON_NUMBER" VARCHAR2(30 BYTE) NOT NULL ENABLE, 
	"ORIG_USER_NAME" VARCHAR2(240 BYTE) NOT NULL ENABLE, 
	"NEW_USER_NAME" VARCHAR2(240 BYTE), 
	"EBS_RESPONSIBILITY" VARCHAR2(240 BYTE) NOT NULL ENABLE, 
	"EBS_RESPONSIBILITY_KEY" VARCHAR2(60 BYTE) NOT NULL ENABLE, 
	"EBS_APPLICATION" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"CLOUD_ROLE" VARCHAR2(240 BYTE), 
	"ADD_REMOVE_ROLE" VARCHAR2(10 BYTE) NOT NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;


  GRANT FLASHBACK ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_RESP_STG" TO "XXMX_CORE";
