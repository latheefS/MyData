--------------------------------------------------------
--  DDL for Table XXMX_PPM_PRJ_MISCCOST_STG_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BATCH_ID" VARCHAR2(80 BYTE), 
	"CREATION_DATE" TIMESTAMP (6), 
	"LAST_UPDATE_DATE" TIMESTAMP (6), 
	"CREATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATED_BY" VARCHAR2(64 BYTE), 
	"LAST_UPDATE_LOGIN" VARCHAR2(32 BYTE), 
	"TRANSACTION_TYPE" VARCHAR2(20 BYTE), 
	"BUSINESS_UNIT" VARCHAR2(240 BYTE), 
	"ORG_ID" NUMBER, 
	"USER_TRANSACTION_SOURCE" VARCHAR2(240 BYTE), 
	"TRANSACTION_SOURCE_ID" VARCHAR2(200 BYTE), 
	"DOCUMENT_NAME" VARCHAR2(240 BYTE), 
	"DOCUMENT_ID" NUMBER, 
	"DOC_ENTRY_NAME" VARCHAR2(240 BYTE), 
	"DOC_ENTRY_ID" NUMBER, 
	"BATCH_NAME" VARCHAR2(240 BYTE), 
	"EXP_BATCH_NAME" VARCHAR2(240 BYTE), 
	"BATCH_ENDING_DATE" DATE, 
	"BATCH_DESCRIPTION" VARCHAR2(250 BYTE), 
	"EXPENDITURE_ITEM_DATE" DATE, 
	"PERSON_NUMBER" VARCHAR2(30 BYTE), 
	"PERSON_NAME" VARCHAR2(2000 BYTE), 
	"PERSON_ID" NUMBER, 
	"HCM_ASSIGNMENT_NAME" VARCHAR2(80 BYTE), 
	"HCM_ASSIGNMENT_ID" NUMBER, 
	"PROJECT_NUMBER" VARCHAR2(25 BYTE), 
	"PROJECT_NAME" VARCHAR2(240 BYTE), 
	"PROJECT_ID" NUMBER, 
	"TASK_NUMBER" VARCHAR2(100 BYTE), 
	"TASK_NAME" VARCHAR2(255 BYTE), 
	"TASK_ID" NUMBER, 
	"EXPENDITURE_TYPE" VARCHAR2(240 BYTE), 
	"EXPENDITURE_TYPE_ID" NUMBER, 
	"ORGANIZATION_NAME" VARCHAR2(240 BYTE), 
	"ORGANIZATION_ID" NUMBER, 
	"QUANTITY" NUMBER, 
	"UNIT_OF_MEASURE_NAME" VARCHAR2(80 BYTE), 
	"UNIT_OF_MEASURE" VARCHAR2(30 BYTE), 
	"WORK_TYPE" VARCHAR2(240 BYTE), 
	"WORK_TYPE_ID" NUMBER, 
	"BILLABLE_FLAG" VARCHAR2(1 BYTE), 
	"CAPITALIZABLE_FLAG" VARCHAR2(1 BYTE), 
	"ACCRUAL_FLAG" VARCHAR2(1 BYTE), 
	"ORIG_TRANSACTION_REFERENCE" VARCHAR2(120 BYTE), 
	"UNMATCHED_NEGATIVE_TXN_FLAG" VARCHAR2(1 BYTE), 
	"REVERSED_ORIG_TXN_REFERENCE" VARCHAR2(120 BYTE), 
	"EXPENDITURE_COMMENT" VARCHAR2(240 BYTE), 
	"GL_DATE" DATE, 
	"DENOM_CURRENCY_CODE" VARCHAR2(50 BYTE), 
	"DENOM_CURRENCY" VARCHAR2(80 BYTE), 
	"DENOM_RAW_COST" NUMBER, 
	"DENOM_BURDENED_COST" NUMBER, 
	"RAW_COST_CR_CCID" NUMBER, 
	"RAW_COST_CR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"RAW_COST_DR_CCID" NUMBER, 
	"RAW_COST_DR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"BURDENED_COST_CR_CCID" NUMBER, 
	"BURDENED_COST_CR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"BURDENED_COST_DR_CCID" NUMBER, 
	"BURDENED_COST_DR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"BURDEN_COST_CR_CCID" NUMBER, 
	"BURDEN_COST_CR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"BURDEN_COST_DR_CCID" NUMBER, 
	"BURDEN_COST_DR_ACCOUNT" VARCHAR2(2000 BYTE), 
	"ACCT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"ACCT_CURRENCY" VARCHAR2(80 BYTE), 
	"ACCT_RAW_COST" NUMBER, 
	"ACCT_BURDENED_COST" NUMBER, 
	"ACCT_RATE_TYPE" VARCHAR2(30 BYTE), 
	"ACCT_RATE_DATE" DATE, 
	"ACCT_RATE_DATE_TYPE" VARCHAR2(4 BYTE), 
	"ACCT_EXCHANGE_RATE" NUMBER, 
	"ACCT_EXCHANGE_ROUNDING_LIMIT" NUMBER, 
	"CONVERTED_FLAG" VARCHAR2(1 BYTE), 
	"CONTEXT_CATEGORY" VARCHAR2(40 BYTE), 
	"USER_DEF_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"USER_DEF_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"FUNDING_SOURCE_ID" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"RESERVED_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
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
	"CONTRACT_NUMBER" VARCHAR2(120 BYTE), 
	"CONTRACT_NAME" VARCHAR2(240 BYTE), 
	"CONTRACT_ID" NUMBER, 
	"FUNDING_SOURCE_NUMBER" VARCHAR2(240 BYTE), 
	"FUNDING_SOURCE_NAME" VARCHAR2(240 BYTE), 
	"COST_TYPE" VARCHAR2(250 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PPM_PRJ_MISCCOST_STG_ARCH" TO "XXMX_READONLY";
