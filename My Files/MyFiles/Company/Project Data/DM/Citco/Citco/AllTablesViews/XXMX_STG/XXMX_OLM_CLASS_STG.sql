--------------------------------------------------------
--  DDL for Table XXMX_OLM_CLASS_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_OLM_CLASS_STG" 
   (	"MIGRATION_SET_ID" NUMBER, 
	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER(15,0), 
	"SOURCESYSTEMID" VARCHAR2(2000 BYTE), 
	"SOURCESYSTEMOWNER" VARCHAR2(50 BYTE), 
	"METADATA" VARCHAR2(10 BYTE), 
	"COURSE_NUMBER" VARCHAR2(10 BYTE), 
	"ACTIVITY_VERSION_ID" VARCHAR2(10 BYTE), 
	"EVENT_TYPE" VARCHAR2(30 BYTE), 
	"TITLE" VARCHAR2(80 BYTE), 
	"COURSE_START_DATE" VARCHAR2(30 BYTE), 
	"COURSE_START_TIME" VARCHAR2(30 BYTE), 
	"COURSE_END_DATE" VARCHAR2(30 BYTE), 
	"COURSE_END_TIME" VARCHAR2(30 BYTE), 
	"DURATION" VARCHAR2(30 BYTE), 
	"DURATION_UNITS" VARCHAR2(30 BYTE), 
	"ENROLMENT_START_DATE" VARCHAR2(20 BYTE), 
	"ENROLMENT_END_DATE" VARCHAR2(20 BYTE), 
	"MAXIMUM_ATTENDEES" VARCHAR2(30 BYTE), 
	"MAXIMUM_INTERNAL_ATTENDEES" VARCHAR2(30 BYTE), 
	"MINIMUM_ATTENDEES" VARCHAR2(30 BYTE), 
	"TRAINING_CENTER_ID" VARCHAR2(30 BYTE), 
	"LOCATION_ID" VARCHAR2(30 BYTE), 
	"PARENT_OFFERING_ID" VARCHAR2(30 BYTE), 
	"INSTRUCTOR" VARCHAR2(240 BYTE), 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"CREATION_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"PERSON_ID" VARCHAR2(30 BYTE), 
	"PERSON_NUMBER" VARCHAR2(50 BYTE), 
	"OFFERING_NAME" VARCHAR2(500 BYTE), 
	"TIMEZONE" VARCHAR2(80 BYTE), 
	"INSTRUCTOR_NUMBER" VARCHAR2(80 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT SELECT ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_OLM_CLASS_STG" TO "XXMX_CORE";
