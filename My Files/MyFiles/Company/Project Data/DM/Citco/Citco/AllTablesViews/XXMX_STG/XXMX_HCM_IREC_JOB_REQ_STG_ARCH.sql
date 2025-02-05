--------------------------------------------------------
--  DDL for Table XXMX_HCM_IREC_JOB_REQ_STG_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER(15,0), 
	"METADATA" VARCHAR2(150 BYTE), 
	"OBJECTNAME" VARCHAR2(150 BYTE), 
	"REQUISITION_ID" NUMBER(18,0), 
	"REQUISITION_NUMBER" VARCHAR2(240 BYTE), 
	"RECRUITING_TYPE" VARCHAR2(30 BYTE), 
	"JOB_ID" NUMBER(18,0), 
	"NUMBER_OF_OPENINGS" NUMBER(5,0), 
	"UNLIMITED_OPENINGS_FLAG" VARCHAR2(5 BYTE), 
	"REQUISITION_TITLE" VARCHAR2(250 BYTE), 
	"INTERNAL_REQUISITION_TITLE" VARCHAR2(240 BYTE), 
	"BUSINESS_JUSTIFICATION" VARCHAR2(30 BYTE), 
	"HIRING_MANAGER_ID" NUMBER(18,0), 
	"RECRUITER_ID" NUMBER(18,0), 
	"PRIMARY_WORK_LOCATION_ID" NUMBER(18,0), 
	"GRADE_ID" NUMBER(18,0), 
	"ORGANIZATION_ID" NUMBER(18,0), 
	"JOB_FAMILY_ID" NUMBER(18,0), 
	"JOB_FUNCTION" VARCHAR2(30 BYTE), 
	"LEGAL_EMPLOYER_ID" NUMBER(18,0), 
	"BUSINESS_UNIT_ID" NUMBER(18,0), 
	"DEPARTMENT_ID" NUMBER(18,0), 
	"SOURCING_BUDGET" NUMBER, 
	"TRAVEL_BUDGET" NUMBER, 
	"RELOCATION_BUDGET" NUMBER, 
	"EMPLOYEE_REFERRAL_BONUS" NUMBER, 
	"BUDGET_CURRENCY" VARCHAR2(30 BYTE), 
	"MAXIMUM_SALARY" NUMBER, 
	"MINIMUM_SALARY" NUMBER, 
	"PAY_FREQUENCY" VARCHAR2(30 BYTE), 
	"SALARY_CURRENCY" VARCHAR2(30 BYTE), 
	"WORKER_TYPE" VARCHAR2(30 BYTE), 
	"REGULAR_OR_TEMPORARY" VARCHAR2(30 BYTE), 
	"MANAGEMENT_LEVEL" VARCHAR2(30 BYTE), 
	"FULLTIME_OR_PARTTIME" VARCHAR2(30 BYTE), 
	"JOB_SHIFT" VARCHAR2(30 BYTE), 
	"JOB_TYPE" VARCHAR2(30 BYTE), 
	"EDUCATION_LEVEL" VARCHAR2(30 BYTE), 
	"CONTACT_NAME_EXTERNAL" VARCHAR2(240 BYTE), 
	"CONTACT_EMAIL_EXTERNAL" VARCHAR2(240 BYTE), 
	"EXTERNAL_SHORT_DESCRIPTION" CLOB, 
	"EXTERNAL_DESCRIPTION" CLOB, 
	"EXTERNAL_EMPLOYER_DESCRIPTION_ID" NUMBER(18,0), 
	"EXTERNAL_ORG_DESCRIPTION_ID" NUMBER(18,0), 
	"CONTACT_NAME_INTERNAL" VARCHAR2(240 BYTE), 
	"CONTACT_EMAIL_INTERNAL" VARCHAR2(240 BYTE), 
	"INTERNAL_SHORT_DESCRIPTION" CLOB, 
	"INTERNAL_DESCRIPTION" CLOB, 
	"INTERNAL_EMPLOYER_DESCRIPTION_ID" NUMBER(18,0), 
	"INTERNAL_ORG_DESCRIPTION_ID" NUMBER(18,0), 
	"DISPLAY_IN_ORG_CHART_FLAG" VARCHAR2(1 BYTE), 
	"CURRENT_PHASE_ID" NUMBER(18,0), 
	"CURRENT_STATE_ID" NUMBER(18,0), 
	"COMMENTS" CLOB, 
	"JOB_CODE" VARCHAR2(30 BYTE), 
	"HIRING_MANAGER_PERSON_NUMBER" NUMBER(30,0), 
	"HIRING_MANAGER_ASSIGNMENT_NUMBER" NUMBER(30,0), 
	"RECRUITER_PERSON_NUMBER" NUMBER(30,0), 
	"RECRUITER_ASSIGNMENT_NUMBER" VARCHAR2(30 BYTE), 
	"PRIMARY_LOCATION_NAME" VARCHAR2(360 BYTE), 
	"GRADE_CODE" VARCHAR2(30 BYTE), 
	"ORGANIZATION_CODE" VARCHAR2(60 BYTE), 
	"JOB_FAMILY_NAME" VARCHAR2(240 BYTE), 
	"LEGAL_EMPLOYER_NAME" VARCHAR2(240 BYTE), 
	"BUSINESS_UNIT_SHORT_CODE" VARCHAR2(150 BYTE), 
	"DEPARTMENT_NAME" VARCHAR2(240 BYTE), 
	"CURRENT_PHASE_CODE" VARCHAR2(30 BYTE), 
	"CURRENT_STATE_CODE" VARCHAR2(30 BYTE), 
	"PRIMARY_WORK_LOCATION_CODE" VARCHAR2(150 BYTE), 
	"BUDGET_CURRENCY_NAME" VARCHAR2(80 BYTE), 
	"SALARY_CURRENCY_NAME" VARCHAR2(80 BYTE), 
	"EXTERNAL_EMP_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"EXTERNAL_ORG_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"INTERNAL_EMP_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"INTERNAL_ORG_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"SUBMISSIONS_PROCESS_TEMPLATE_ID" NUMBER(18,0), 
	"ORGANIZATION_NAME" VARCHAR2(4000 BYTE), 
	"CLASSIFICATION_CODE" VARCHAR2(40 BYTE), 
	"PRIMARY_LOCATION_ID" NUMBER(18,0), 
	"BASE_LANGUAGE_CODE" VARCHAR2(30 BYTE), 
	"CANDIDATE_SELECTION_PROCESS_CODE" VARCHAR2(30 BYTE), 
	"JOB_FAMILY_CODE" VARCHAR2(240 BYTE), 
	"EXTERNAL_APPLY_FLOW_ID" NUMBER(18,0), 
	"EXTERNAL_APPLY_FLOW_CODE" VARCHAR2(30 BYTE), 
	"PIPELINE_REQUISITION_FLAG" VARCHAR2(30 BYTE), 
	"PIPELINE_REQUISITION_ID" NUMBER(18,0), 
	"APPLY_WHEN_NOT_POSTED_FLAG" VARCHAR2(30 BYTE), 
	"PIPELINE_REQUISITION_NUMBER" VARCHAR2(240 BYTE), 
	"POSITION_ID" NUMBER(18,0), 
	"POSITION_CODE" VARCHAR2(30 BYTE), 
	"REQUISITION_TEMPLATE_ID" NUMBER(18,0), 
	"CODE" VARCHAR2(240 BYTE), 
	"AUTOMATIC_FILL_FLAG" VARCHAR2(30 BYTE), 
	"SEND_NOTIFICATIONS_FLAG" VARCHAR2(30 BYTE), 
	"EXTERNAL_DESCRIPTION_ID" NUMBER(18,0), 
	"INTERNAL_DESCRIPTION_ID" NUMBER(18,0), 
	"EXTERNAL_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"INTERNAL_DESCRIPTION_CODE" VARCHAR2(30 BYTE), 
	"AUTO_OPEN_REQUISITION" VARCHAR2(30 BYTE), 
	"POSTING_EXPIRE_IN_DAYS" NUMBER, 
	"AUTO_UNPOST_REQUISITION" VARCHAR2(30 BYTE), 
	"UNPOST_FORMULA_ID" NUMBER(18,0), 
	"UNPOST_FORMULA_CODE" VARCHAR2(80 BYTE), 
	"GUID" VARCHAR2(32 BYTE), 
	"SOURCE_SYSTEM_ID" VARCHAR2(2000 BYTE), 
	"SOURCE_SYSTEM_OWNER" VARCHAR2(256 BYTE), 
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
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" 
 LOB ("EXTERNAL_SHORT_DESCRIPTION") STORE AS SECUREFILE (
  TABLESPACE "XXMX_STG" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("EXTERNAL_DESCRIPTION") STORE AS SECUREFILE (
  TABLESPACE "XXMX_STG" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("INTERNAL_SHORT_DESCRIPTION") STORE AS SECUREFILE (
  TABLESPACE "XXMX_STG" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("INTERNAL_DESCRIPTION") STORE AS SECUREFILE (
  TABLESPACE "XXMX_STG" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("COMMENTS") STORE AS SECUREFILE (
  TABLESPACE "XXMX_STG" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_HCM_IREC_JOB_REQ_STG_ARCH" TO "XXMX_READONLY";
