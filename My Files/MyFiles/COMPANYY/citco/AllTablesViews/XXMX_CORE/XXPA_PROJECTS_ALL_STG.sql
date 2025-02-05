--------------------------------------------------------
--  DDL for Table XXPA_PROJECTS_ALL_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXPA_PROJECTS_ALL_STG" 
   (	"PROJECT_ID" NUMBER(15,0), 
	"NAME" VARCHAR2(30 BYTE), 
	"SEGMENT1" VARCHAR2(25 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER(15,0), 
	"CREATION_DATE" DATE, 
	"CREATED_BY" NUMBER(15,0), 
	"LAST_UPDATE_LOGIN" NUMBER(15,0), 
	"PROJECT_TYPE" VARCHAR2(20 BYTE), 
	"CARRYING_OUT_ORGANIZATION_ID" NUMBER(15,0), 
	"PUBLIC_SECTOR_FLAG" VARCHAR2(1 BYTE), 
	"PROJECT_STATUS_CODE" VARCHAR2(30 BYTE), 
	"DESCRIPTION" VARCHAR2(250 BYTE), 
	"START_DATE" DATE, 
	"COMPLETION_DATE" DATE, 
	"CLOSED_DATE" DATE, 
	"DISTRIBUTION_RULE" VARCHAR2(30 BYTE), 
	"LABOR_INVOICE_FORMAT_ID" NUMBER(15,0), 
	"NON_LABOR_INVOICE_FORMAT_ID" NUMBER(15,0), 
	"RETENTION_INVOICE_FORMAT_ID" NUMBER(15,0), 
	"RETENTION_PERCENTAGE" NUMBER(17,2), 
	"BILLING_OFFSET" NUMBER(15,0), 
	"BILLING_CYCLE" NUMBER(15,0), 
	"LABOR_STD_BILL_RATE_SCHDL" VARCHAR2(20 BYTE), 
	"LABOR_BILL_RATE_ORG_ID" NUMBER(15,0), 
	"LABOR_SCHEDULE_FIXED_DATE" DATE, 
	"LABOR_SCHEDULE_DISCOUNT" NUMBER(7,4), 
	"NON_LABOR_STD_BILL_RATE_SCHDL" VARCHAR2(30 BYTE), 
	"NON_LABOR_BILL_RATE_ORG_ID" NUMBER(15,0), 
	"NON_LABOR_SCHEDULE_FIXED_DATE" DATE, 
	"NON_LABOR_SCHEDULE_DISCOUNT" NUMBER(7,4), 
	"LIMIT_TO_TXN_CONTROLS_FLAG" VARCHAR2(1 BYTE), 
	"PROJECT_LEVEL_FUNDING_FLAG" VARCHAR2(1 BYTE), 
	"INVOICE_COMMENT" VARCHAR2(240 BYTE), 
	"UNBILLED_RECEIVABLE_DR" NUMBER(22,5), 
	"UNEARNED_REVENUE_CR" NUMBER(22,5), 
	"REQUEST_ID" NUMBER(15,0), 
	"PROGRAM_ID" NUMBER(15,0), 
	"PROGRAM_APPLICATION_ID" NUMBER(15,0), 
	"PROGRAM_UPDATE_DATE" DATE, 
	"SUMMARY_FLAG" VARCHAR2(1 BYTE), 
	"ENABLED_FLAG" VARCHAR2(1 BYTE), 
	"SEGMENT2" VARCHAR2(25 BYTE), 
	"SEGMENT3" VARCHAR2(25 BYTE), 
	"SEGMENT4" VARCHAR2(25 BYTE), 
	"SEGMENT5" VARCHAR2(25 BYTE), 
	"SEGMENT6" VARCHAR2(25 BYTE), 
	"SEGMENT7" VARCHAR2(25 BYTE), 
	"SEGMENT8" VARCHAR2(25 BYTE), 
	"SEGMENT9" VARCHAR2(25 BYTE), 
	"SEGMENT10" VARCHAR2(25 BYTE), 
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
	"COST_IND_RATE_SCH_ID" NUMBER(15,0), 
	"REV_IND_RATE_SCH_ID" NUMBER(15,0), 
	"INV_IND_RATE_SCH_ID" NUMBER(15,0), 
	"COST_IND_SCH_FIXED_DATE" DATE, 
	"REV_IND_SCH_FIXED_DATE" DATE, 
	"INV_IND_SCH_FIXED_DATE" DATE, 
	"LABOR_SCH_TYPE" VARCHAR2(1 BYTE), 
	"NON_LABOR_SCH_TYPE" VARCHAR2(1 BYTE), 
	"OVR_COST_IND_RATE_SCH_ID" NUMBER(15,0), 
	"OVR_REV_IND_RATE_SCH_ID" NUMBER(15,0), 
	"OVR_INV_IND_RATE_SCH_ID" NUMBER(15,0), 
	"TEMPLATE_FLAG" VARCHAR2(1 BYTE), 
	"VERIFICATION_DATE" DATE, 
	"CREATED_FROM_PROJECT_ID" NUMBER(15,0), 
	"TEMPLATE_START_DATE_ACTIVE" DATE, 
	"TEMPLATE_END_DATE_ACTIVE" DATE, 
	"ORG_ID" NUMBER(15,0), 
	"PM_PRODUCT_CODE" VARCHAR2(30 BYTE), 
	"PM_PROJECT_REFERENCE" VARCHAR2(25 BYTE), 
	"ACTUAL_START_DATE" DATE, 
	"ACTUAL_FINISH_DATE" DATE, 
	"EARLY_START_DATE" DATE, 
	"EARLY_FINISH_DATE" DATE, 
	"LATE_START_DATE" DATE, 
	"LATE_FINISH_DATE" DATE, 
	"SCHEDULED_START_DATE" DATE, 
	"SCHEDULED_FINISH_DATE" DATE, 
	"BILLING_CYCLE_ID" NUMBER(15,0), 
	"ADW_NOTIFY_FLAG" VARCHAR2(1 BYTE), 
	"WF_STATUS_CODE" VARCHAR2(30 BYTE), 
	"OUTPUT_TAX_CODE" VARCHAR2(50 BYTE), 
	"RETENTION_TAX_CODE" VARCHAR2(50 BYTE), 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"ALLOW_CROSS_CHARGE_FLAG" VARCHAR2(1 BYTE), 
	"PROJECT_RATE_DATE" DATE, 
	"PROJECT_RATE_TYPE" VARCHAR2(30 BYTE), 
	"CC_PROCESS_LABOR_FLAG" VARCHAR2(1 BYTE), 
	"LABOR_TP_SCHEDULE_ID" NUMBER, 
	"LABOR_TP_FIXED_DATE" DATE, 
	"CC_PROCESS_NL_FLAG" VARCHAR2(1 BYTE), 
	"NL_TP_SCHEDULE_ID" NUMBER, 
	"NL_TP_FIXED_DATE" DATE, 
	"CC_TAX_TASK_ID" NUMBER, 
	"BILL_JOB_GROUP_ID" NUMBER(15,0), 
	"COST_JOB_GROUP_ID" NUMBER(15,0), 
	"ROLE_LIST_ID" NUMBER(15,0), 
	"WORK_TYPE_ID" NUMBER(15,0), 
	"CALENDAR_ID" NUMBER(15,0), 
	"LOCATION_ID" NUMBER(15,0), 
	"PROBABILITY_MEMBER_ID" NUMBER(15,0), 
	"PROJECT_VALUE" NUMBER, 
	"EXPECTED_APPROVAL_DATE" DATE, 
	"RECORD_VERSION_NUMBER" NUMBER(15,0), 
	"INITIAL_TEAM_TEMPLATE_ID" NUMBER(15,0), 
	"JOB_BILL_RATE_SCHEDULE_ID" NUMBER, 
	"EMP_BILL_RATE_SCHEDULE_ID" NUMBER, 
	"COMPETENCE_MATCH_WT" NUMBER, 
	"AVAILABILITY_MATCH_WT" NUMBER, 
	"JOB_LEVEL_MATCH_WT" NUMBER, 
	"ENABLE_AUTOMATED_SEARCH" VARCHAR2(1 BYTE), 
	"SEARCH_MIN_AVAILABILITY" NUMBER, 
	"SEARCH_ORG_HIER_ID" NUMBER(15,0), 
	"SEARCH_STARTING_ORG_ID" NUMBER(15,0), 
	"SEARCH_COUNTRY_CODE" VARCHAR2(2 BYTE), 
	"MIN_CAND_SCORE_REQD_FOR_NOM" NUMBER, 
	"NON_LAB_STD_BILL_RT_SCH_ID" NUMBER(15,0), 
	"INVPROC_CURRENCY_TYPE" VARCHAR2(30 BYTE), 
	"REVPROC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJECT_BIL_RATE_DATE_CODE" VARCHAR2(30 BYTE), 
	"PROJECT_BIL_RATE_TYPE" VARCHAR2(30 BYTE), 
	"PROJECT_BIL_RATE_DATE" DATE, 
	"PROJECT_BIL_EXCHANGE_RATE" NUMBER, 
	"PROJFUNC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJFUNC_BIL_RATE_DATE_CODE" VARCHAR2(30 BYTE), 
	"PROJFUNC_BIL_RATE_TYPE" VARCHAR2(30 BYTE), 
	"PROJFUNC_BIL_RATE_DATE" DATE, 
	"PROJFUNC_BIL_EXCHANGE_RATE" NUMBER, 
	"FUNDING_RATE_DATE_CODE" VARCHAR2(30 BYTE), 
	"FUNDING_RATE_TYPE" VARCHAR2(30 BYTE), 
	"FUNDING_RATE_DATE" DATE, 
	"FUNDING_EXCHANGE_RATE" NUMBER, 
	"BASELINE_FUNDING_FLAG" VARCHAR2(1 BYTE), 
	"PROJFUNC_COST_RATE_TYPE" VARCHAR2(30 BYTE), 
	"PROJFUNC_COST_RATE_DATE" DATE, 
	"INV_BY_BILL_TRANS_CURR_FLAG" VARCHAR2(1 BYTE), 
	"MULTI_CURRENCY_BILLING_FLAG" VARCHAR2(1 BYTE), 
	"SPLIT_COST_FROM_WORKPLAN_FLAG" VARCHAR2(1 BYTE), 
	"SPLIT_COST_FROM_BILL_FLAG" VARCHAR2(1 BYTE), 
	"ASSIGN_PRECEDES_TASK" VARCHAR2(1 BYTE), 
	"PRIORITY_CODE" VARCHAR2(30 BYTE), 
	"RETN_BILLING_INV_FORMAT_ID" NUMBER(15,0), 
	"RETN_ACCOUNTING_FLAG" VARCHAR2(1 BYTE), 
	"ADV_ACTION_SET_ID" NUMBER(15,0), 
	"START_ADV_ACTION_SET_FLAG" VARCHAR2(1 BYTE), 
	"REVALUATE_FUNDING_FLAG" VARCHAR2(1 BYTE), 
	"INCLUDE_GAINS_LOSSES_FLAG" VARCHAR2(1 BYTE), 
	"TARGET_START_DATE" DATE, 
	"TARGET_FINISH_DATE" DATE, 
	"BASELINE_START_DATE" DATE, 
	"BASELINE_FINISH_DATE" DATE, 
	"SCHEDULED_AS_OF_DATE" DATE, 
	"BASELINE_AS_OF_DATE" DATE, 
	"LABOR_DISC_REASON_CODE" VARCHAR2(30 BYTE), 
	"NON_LABOR_DISC_REASON_CODE" VARCHAR2(30 BYTE), 
	"SECURITY_LEVEL" NUMBER, 
	"ACTUAL_AS_OF_DATE" DATE, 
	"SCHEDULED_DURATION" NUMBER, 
	"BASELINE_DURATION" NUMBER, 
	"ACTUAL_DURATION" NUMBER, 
	"LONG_NAME" VARCHAR2(240 BYTE), 
	"BTC_COST_BASE_REV_CODE" VARCHAR2(90 BYTE), 
	"ASSET_ALLOCATION_METHOD" VARCHAR2(30 BYTE), 
	"CAPITAL_EVENT_PROCESSING" VARCHAR2(30 BYTE), 
	"CINT_RATE_SCH_ID" NUMBER(15,0), 
	"CINT_ELIGIBLE_FLAG" VARCHAR2(1 BYTE), 
	"CINT_STOP_DATE" DATE, 
	"SYS_PROGRAM_FLAG" VARCHAR2(1 BYTE), 
	"STRUCTURE_SHARING_CODE" VARCHAR2(30 BYTE), 
	"ENABLE_TOP_TASK_CUSTOMER_FLAG" VARCHAR2(1 BYTE), 
	"ENABLE_TOP_TASK_INV_MTH_FLAG" VARCHAR2(1 BYTE), 
	"REVENUE_ACCRUAL_METHOD" VARCHAR2(30 BYTE), 
	"INVOICE_METHOD" VARCHAR2(30 BYTE), 
	"PROJFUNC_ATTR_FOR_AR_FLAG" VARCHAR2(1 BYTE), 
	"PJI_SOURCE_FLAG" VARCHAR2(1 BYTE), 
	"ALLOW_MULTI_PROGRAM_ROLLUP" VARCHAR2(1 BYTE), 
	"PROJ_REQ_RES_FORMAT_ID" NUMBER, 
	"PROJ_ASGMT_RES_FORMAT_ID" NUMBER, 
	"FUNDING_APPROVAL_STATUS_CODE" VARCHAR2(30 BYTE), 
	"REVTRANS_CURRENCY_TYPE" VARCHAR2(30 BYTE), 
	"DATE_EFF_FUNDS_CONSUMPTION" VARCHAR2(1 BYTE), 
	"AR_REC_NOTIFY_FLAG" VARCHAR2(1 BYTE), 
	"AUTO_RELEASE_PWP_INV" VARCHAR2(1 BYTE), 
	"BILL_LABOR_ACCRUAL" VARCHAR2(1 BYTE), 
	"ADJ_ON_STD_INV" VARCHAR2(2 BYTE), 
	"CBS_VERSION_ID" NUMBER(15,0), 
	"IC_LABOR_TP_SCHEDULE_ID" NUMBER(22,0), 
	"IC_LABOR_TP_FIXED_DATE" DATE, 
	"IC_NL_TP_SCHEDULE_ID" NUMBER(22,0), 
	"IC_NL_TP_FIXED_DATE" DATE, 
	"OLAP_GROUP" NUMBER, 
	"OLAP_TASK_ID" NUMBER, 
	"DEFERRED_ROLLUP_ENABLED_FLAG" VARCHAR2(1 BYTE), 
	"PJT_ROLLUP_ENABLED_FLAG" VARCHAR2(1 BYTE), 
	"POBG_FLAG" VARCHAR2(1 BYTE), 
	"RMCS_INTEGRATION_FLAG" VARCHAR2(1 BYTE), 
	"SLA_ACC_END_DATE" DATE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
