--------------------------------------------------------
--  DDL for Table XXMX_PPM_PROJECTS_STG_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"XFACE_REC_ID" NUMBER(18,0), 
	"PROJECT_NAME" VARCHAR2(240 BYTE), 
	"PROJECT_NUMBER" VARCHAR2(25 BYTE), 
	"SOURCE_TEMPLATE_NUMBER" VARCHAR2(25 BYTE), 
	"SOURCE_TEMPLATE_NAME" VARCHAR2(240 BYTE), 
	"SOURCE_APPLICATION_CODE" VARCHAR2(30 BYTE), 
	"SOURCE_PROJECT_REFERENCE" VARCHAR2(25 BYTE), 
	"SCHEDULE_NAME" VARCHAR2(200 BYTE), 
	"EPS_NAME" VARCHAR2(200 BYTE), 
	"PROJECT_PLAN_VIEW_ACCESS" VARCHAR2(30 BYTE), 
	"SCHEDULE_TYPE" VARCHAR2(30 BYTE), 
	"ORGANIZATION_NAME" VARCHAR2(240 BYTE), 
	"LEGAL_ENTITY_NAME" VARCHAR2(240 BYTE), 
	"DESCRIPTION" VARCHAR2(2000 BYTE), 
	"PROJECT_MANAGER_NUMBER" VARCHAR2(30 BYTE), 
	"PROJECT_MANAGER_NAME" VARCHAR2(360 BYTE), 
	"PROJECT_MANAGER_EMAIL" VARCHAR2(360 BYTE), 
	"PROJECT_START_DATE" DATE, 
	"PROJECT_FINISH_DATE" DATE, 
	"CLOSED_DATE" DATE, 
	"PRJ_PLAN_BASELINE_NAME" VARCHAR2(100 BYTE), 
	"PRJ_PLAN_BASELINE_DESC" VARCHAR2(1000 BYTE), 
	"PRJ_PLAN_BASELINE_DATE" DATE, 
	"PROJECT_STATUS_NAME" VARCHAR2(80 BYTE), 
	"PROJECT_PRIORITY_CODE" VARCHAR2(30 BYTE), 
	"OUTLINE_DISPLAY_LEVEL" NUMBER(18,0), 
	"PLANNING_PROJECT_FLAG" VARCHAR2(1 BYTE), 
	"SERVICE_TYPE_CODE" VARCHAR2(30 BYTE), 
	"WORK_TYPE_NAME" VARCHAR2(240 BYTE), 
	"LIMIT_TO_TXN_CONTROLS_CODE" VARCHAR2(30 BYTE), 
	"BUDGETARY_CONTROL_FLAG" VARCHAR2(1 BYTE), 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"CURRENCY_CONV_RATE_TYPE" VARCHAR2(15 BYTE), 
	"CURRENCY_CONV_DATE_TYPE_CODE" VARCHAR2(30 BYTE), 
	"CURRENCY_CONV_DATE" DATE, 
	"CINT_ELIGIBLE_FLAG" VARCHAR2(1 BYTE), 
	"CINT_RATE_SCH_NAME" VARCHAR2(30 BYTE), 
	"CINT_STOP_DATE" DATE, 
	"ASSET_ALLOCATION_METHOD_CODE" VARCHAR2(30 BYTE), 
	"CAPITAL_EVENT_PROCESSING_CODE" VARCHAR2(30 BYTE), 
	"ALLOW_CROSS_CHARGE_FLAG" VARCHAR2(1 BYTE), 
	"CC_PROCESS_LABOR_FLAG" VARCHAR2(1 BYTE), 
	"LABOR_TP_SCHEDULE_NAME" VARCHAR2(50 BYTE), 
	"LABOR_TP_FIXED_DATE" DATE, 
	"CC_PROCESS_NL_FLAG" VARCHAR2(1 BYTE), 
	"NL_TP_SCHEDULE_NAME" VARCHAR2(50 BYTE), 
	"NL_TP_FIXED_DATE" DATE, 
	"BURDEN_SCHEDULE_NAME" VARCHAR2(30 BYTE), 
	"BURDEN_SCH_FIXED_DATED" DATE, 
	"KPI_NOTIFICATION_ENABLED" VARCHAR2(5 BYTE), 
	"KPI_NOTIFICATION_RECIPIENTS" VARCHAR2(30 BYTE), 
	"KPI_NOTIFICATION_INCLUDE_NOTES" VARCHAR2(5 BYTE), 
	"COPY_TEAM_MEMBERS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_CLASSIFICATIONS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_ATTACHMENTS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_DFF_FLAG" VARCHAR2(1 BYTE), 
	"COPY_TASKS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_TASK_ATTACHMENTS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_TASK_DFF_FLAG" VARCHAR2(1 BYTE), 
	"COPY_TASK_ASSIGNMENTS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_TRANSACTION_CONTROLS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_ASSETS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_ASSET_ASSIGNMENTS_FLAG" VARCHAR2(1 BYTE), 
	"COPY_COST_OVERRIDES_FLAG" VARCHAR2(1 BYTE), 
	"OPPORTUNITY_ID" NUMBER(18,0), 
	"OPPORTUNITY_NUMBER" VARCHAR2(240 BYTE), 
	"OPPORTUNITY_CUSTOMER_NUMBER" VARCHAR2(240 BYTE), 
	"OPPORTUNITY_CUSTOMER_ID" NUMBER(18,0), 
	"OPPORTUNITY_AMT" NUMBER, 
	"OPPORTUNITY_CURRCODE" VARCHAR2(15 BYTE), 
	"OPPORTUNITY_WIN_CONF_PERCENT" NUMBER, 
	"OPPORTUNITY_NAME" VARCHAR2(240 BYTE), 
	"OPPORTUNITY_DESC" VARCHAR2(1000 BYTE), 
	"OPPORTUNITY_CUSTOMER_NAME" VARCHAR2(900 BYTE), 
	"OPPORTUNITY_STATUS" VARCHAR2(240 BYTE), 
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
	"ATTRIBUTE30" VARCHAR2(150 BYTE), 
	"ATTRIBUTE31" VARCHAR2(150 BYTE), 
	"ATTRIBUTE32" VARCHAR2(150 BYTE), 
	"ATTRIBUTE33" VARCHAR2(150 BYTE), 
	"ATTRIBUTE34" VARCHAR2(150 BYTE), 
	"ATTRIBUTE35" VARCHAR2(150 BYTE), 
	"ATTRIBUTE36" VARCHAR2(150 BYTE), 
	"ATTRIBUTE37" VARCHAR2(150 BYTE), 
	"ATTRIBUTE38" VARCHAR2(150 BYTE), 
	"ATTRIBUTE39" VARCHAR2(150 BYTE), 
	"ATTRIBUTE40" VARCHAR2(150 BYTE), 
	"ATTRIBUTE41" VARCHAR2(150 BYTE), 
	"ATTRIBUTE42" VARCHAR2(150 BYTE), 
	"ATTRIBUTE43" VARCHAR2(150 BYTE), 
	"ATTRIBUTE44" VARCHAR2(150 BYTE), 
	"ATTRIBUTE45" VARCHAR2(150 BYTE), 
	"ATTRIBUTE46" VARCHAR2(150 BYTE), 
	"ATTRIBUTE47" VARCHAR2(150 BYTE), 
	"ATTRIBUTE48" VARCHAR2(150 BYTE), 
	"ATTRIBUTE49" VARCHAR2(150 BYTE), 
	"ATTRIBUTE50" VARCHAR2(150 BYTE), 
	"ATTRIBUTE1_NUMBER" NUMBER, 
	"ATTRIBUTE2_NUMBER" NUMBER, 
	"ATTRIBUTE3_NUMBER" NUMBER, 
	"ATTRIBUTE4_NUMBER" NUMBER, 
	"ATTRIBUTE5_NUMBER" NUMBER, 
	"ATTRIBUTE6_NUMBER" NUMBER, 
	"ATTRIBUTE7_NUMBER" NUMBER, 
	"ATTRIBUTE8_NUMBER" NUMBER, 
	"ATTRIBUTE9_NUMBER" NUMBER, 
	"ATTRIBUTE10_NUMBER" NUMBER, 
	"ATTRIBUTE11_NUMBER" NUMBER, 
	"ATTRIBUTE12_NUMBER" NUMBER, 
	"ATTRIBUTE13_NUMBER" NUMBER, 
	"ATTRIBUTE14_NUMBER" NUMBER, 
	"ATTRIBUTE15_NUMBER" NUMBER, 
	"ATTRIBUTE1_DATE" DATE, 
	"ATTRIBUTE2_DATE" DATE, 
	"ATTRIBUTE3_DATE" DATE, 
	"ATTRIBUTE4_DATE" DATE, 
	"ATTRIBUTE5_DATE" DATE, 
	"ATTRIBUTE6_DATE" DATE, 
	"ATTRIBUTE7_DATE" DATE, 
	"ATTRIBUTE8_DATE" DATE, 
	"ATTRIBUTE9_DATE" DATE, 
	"ATTRIBUTE10_DATE" DATE, 
	"ATTRIBUTE11_DATE" DATE, 
	"ATTRIBUTE12_DATE" DATE, 
	"ATTRIBUTE13_DATE" DATE, 
	"ATTRIBUTE14_DATE" DATE, 
	"ATTRIBUTE15_DATE" DATE, 
	"OBJECT_VERSION_NUMBER" NUMBER(9,0), 
	"LOAD_REQUEST_ID" NUMBER(18,0), 
	"REQUEST_ID" NUMBER(18,0), 
	"ORG_ID" NUMBER(18,0), 
	"LAST_UPDATE_DATE" TIMESTAMP (6), 
	"CREATION_DATE" TIMESTAMP (6), 
	"COPY_PROJECT_CLASSES_FLAG" VARCHAR2(1 BYTE), 
	"COPY_GROUP_SPACE_FLAG" VARCHAR2(1 BYTE), 
	"LOAD_STATUS" VARCHAR2(10 BYTE), 
	"IMPORT_STATUS" VARCHAR2(10 BYTE), 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE), 
	"PROJECT_ID" VARCHAR2(30 BYTE), 
	"PROJ_OWNING_ORG" VARCHAR2(240 BYTE), 
	"BATCH_ID" VARCHAR2(80 BYTE), 
	"BATCH_NAME" VARCHAR2(240 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PPM_PROJECTS_STG_ARCH" TO "XXMX_READONLY";