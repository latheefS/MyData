--------------------------------------------------------
--  DDL for Table XXMX_PA_DRAFT_INVOICE_ITEMS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PA_DRAFT_INVOICE_ITEMS" 
   (	"PROJECT_ID" NUMBER(15,0), 
	"DRAFT_INVOICE_NUM" NUMBER(15,0), 
	"LINE_NUM" NUMBER(15,0), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER(15,0), 
	"CREATION_DATE" DATE, 
	"CREATED_BY" NUMBER(15,0), 
	"AMOUNT" NUMBER(22,5), 
	"TEXT" VARCHAR2(240 BYTE), 
	"INVOICE_LINE_TYPE" VARCHAR2(30 BYTE), 
	"REQUEST_ID" NUMBER(15,0), 
	"PROGRAM_APPLICATION_ID" NUMBER(15,0), 
	"PROGRAM_ID" NUMBER(15,0), 
	"PROGRAM_UPDATE_DATE" DATE, 
	"UNEARNED_REVENUE_CR" NUMBER(22,5), 
	"UNBILLED_RECEIVABLE_DR" NUMBER(22,5), 
	"TASK_ID" NUMBER(15,0), 
	"EVENT_TASK_ID" NUMBER(15,0), 
	"EVENT_NUM" NUMBER(15,0), 
	"SHIP_TO_ADDRESS_ID" NUMBER(15,0), 
	"TAXABLE_FLAG" VARCHAR2(1 BYTE), 
	"DRAFT_INV_LINE_NUM_CREDITED" NUMBER(15,0), 
	"LAST_UPDATE_LOGIN" NUMBER(15,0), 
	"INV_AMOUNT" NUMBER, 
	"OUTPUT_VAT_TAX_ID" NUMBER, 
	"OUTPUT_TAX_EXEMPT_FLAG" VARCHAR2(1 BYTE), 
	"OUTPUT_TAX_EXEMPT_REASON_CODE" VARCHAR2(30 BYTE), 
	"OUTPUT_TAX_EXEMPT_NUMBER" VARCHAR2(80 BYTE), 
	"ACCT_AMOUNT" NUMBER, 
	"ROUNDING_AMOUNT" NUMBER, 
	"UNBILLED_ROUNDING_AMOUNT_DR" NUMBER, 
	"UNEARNED_ROUNDING_AMOUNT_CR" NUMBER, 
	"TRANSLATED_TEXT" VARCHAR2(1000 BYTE), 
	"CC_REV_CODE_COMBINATION_ID" NUMBER, 
	"CC_PROJECT_ID" NUMBER, 
	"CC_TAX_TASK_ID" NUMBER, 
	"PROJFUNC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJFUNC_BILL_AMOUNT" NUMBER, 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJECT_BILL_AMOUNT" NUMBER, 
	"FUNDING_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"FUNDING_BILL_AMOUNT" NUMBER, 
	"FUNDING_RATE_DATE" DATE, 
	"FUNDING_EXCHANGE_RATE" NUMBER, 
	"FUNDING_RATE_TYPE" VARCHAR2(30 BYTE), 
	"INVPROC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"BILL_TRANS_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"BILL_TRANS_BILL_AMOUNT" NUMBER, 
	"RETN_BILLING_METHOD" VARCHAR2(30 BYTE), 
	"RETN_PERCENT_COMPLETE" NUMBER, 
	"RETN_TOTAL_RETENTION" NUMBER, 
	"RETN_BILLING_CYCLE_ID" NUMBER(15,0), 
	"RETN_CLIENT_EXTENSION_FLAG" VARCHAR2(1 BYTE), 
	"RETN_BILLING_PERCENTAGE" NUMBER, 
	"RETN_BILLING_AMOUNT" NUMBER, 
	"RETENTION_RULE_ID" NUMBER(15,0), 
	"RETAINED_AMOUNT" NUMBER, 
	"RETN_DRAFT_INVOICE_NUM" NUMBER, 
	"RETN_DRAFT_INVOICE_LINE_NUM" NUMBER, 
	"CREDIT_AMOUNT" NUMBER, 
	"CREDIT_PROCESS_FLAG" VARCHAR2(1 BYTE), 
	"OUTPUT_TAX_CLASSIFICATION_CODE" VARCHAR2(50 BYTE), 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"GLOBAL_ATTRIBUTE1" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE2" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE3" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE4" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE5" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE6" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE7" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE8" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE9" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE10" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE11" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE12" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE13" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE14" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE15" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE16" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE17" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE18" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE19" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE20" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE21" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE22" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE23" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE24" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE25" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE26" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE27" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE28" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE29" VARCHAR2(240 BYTE), 
	"GLOBAL_ATTRIBUTE30" VARCHAR2(240 BYTE), 
	"PROVIDER_ORGANIZATION_ID" NUMBER(15,0), 
	"RECEIVER_ORGANIZATION_ID" NUMBER(15,0), 
	"INV_RATE_TYPE" VARCHAR2(30 BYTE), 
	"INV_RATE_DATE" DATE, 
	"INV_EXCHANGE_RATE" NUMBER, 
	"ADD_INV_GROUP" VARCHAR2(40 BYTE), 
	"POBG_ID" NUMBER(15,0), 
	"TRX_NUM" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;