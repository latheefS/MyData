--------------------------------------------------------
--  DDL for Table XXMX_HZ_CUST_PROFILES_RPT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_HZ_CUST_PROFILES_RPT" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"INSERT_UPDATE_FLAG" VARCHAR2(1 BYTE), 
	"PARTY_ORIG_SYSTEM" VARCHAR2(240 BYTE), 
	"PARTY_ORIG_SYSTEM_REFERENCE" VARCHAR2(240 BYTE), 
	"CUST_ORIG_SYSTEM" VARCHAR2(240 BYTE), 
	"CUST_ORIG_SYSTEM_REFERENCE" VARCHAR2(240 BYTE), 
	"CUST_SITE_ORIG_SYSTEM" VARCHAR2(240 BYTE), 
	"CUST_SITE_ORIG_SYS_REF" VARCHAR2(240 BYTE), 
	"CUSTOMER_PROFILE_CLASS_NAME" VARCHAR2(30 BYTE), 
	"COLLECTOR_NAME" VARCHAR2(30 BYTE), 
	"CREDIT_ANALYST_NAME" VARCHAR2(240 BYTE), 
	"CREDIT_REVIEW_CYCLE" VARCHAR2(20 BYTE), 
	"LAST_CREDIT_REVIEW_DATE" DATE, 
	"NEXT_CREDIT_REVIEW_DATE" DATE, 
	"CREDIT_BALANCE_STATEMENTS" VARCHAR2(1 BYTE), 
	"CREDIT_CHECKING" VARCHAR2(1 BYTE), 
	"CREDIT_HOLD" VARCHAR2(1 BYTE), 
	"DISCOUNT_TERMS" VARCHAR2(1 BYTE), 
	"DUNNING_LETTERS" VARCHAR2(1 BYTE), 
	"INTEREST_CHARGES" VARCHAR2(1 BYTE), 
	"STATEMENTS" VARCHAR2(1 BYTE), 
	"TOLERANCE" NUMBER, 
	"TAX_PRINTING_OPTION" VARCHAR2(30 BYTE), 
	"ACCOUNT_STATUS" VARCHAR2(30 BYTE), 
	"AUTOCASH_HIERARCHY_NAME" VARCHAR2(30 BYTE), 
	"CREDIT_RATING" VARCHAR2(30 BYTE), 
	"DISCOUNT_GRACE_DAYS" NUMBER, 
	"INTEREST_PERIOD_DAYS" NUMBER, 
	"OVERRIDE_TERMS" VARCHAR2(1 BYTE), 
	"PAYMENT_GRACE_DAYS" NUMBER, 
	"PERCENT_COLLECTABLE" NUMBER, 
	"RISK_CODE" VARCHAR2(30 BYTE), 
	"STANDARD_TERM_NAME" VARCHAR2(15 BYTE), 
	"STATEMENT_CYCLE_NAME" VARCHAR2(15 BYTE), 
	"CHARGE_ON_FINANCE_CHARGE_FLAG" VARCHAR2(1 BYTE), 
	"GROUPING_RULE_NAME" VARCHAR2(40 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"AUTO_REC_MIN_RECEIPT_AMOUNT" NUMBER, 
	"INTEREST_RATE" NUMBER, 
	"MAX_INTEREST_CHARGE" NUMBER, 
	"MIN_DUNNING_AMOUNT" NUMBER, 
	"MIN_DUNNING_INVOICE_AMOUNT" NUMBER, 
	"MIN_FC_BALANCE_AMOUNT" NUMBER, 
	"MIN_FC_INVOICE_AMOUNT" NUMBER, 
	"MIN_STATEMENT_AMOUNT" NUMBER, 
	"OVERALL_CREDIT_LIMIT" NUMBER, 
	"TRX_CREDIT_LIMIT" NUMBER, 
	"ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"AMOUNT_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"AMOUNT_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"AUTO_REC_INCL_DISPUTED_FLAG" VARCHAR2(1 BYTE), 
	"CLEARING_DAYS" NUMBER, 
	"ORG_ID" VARCHAR2(30 BYTE), 
	"CONS_INV_FLAG" VARCHAR2(1 BYTE), 
	"CONS_INV_TYPE" VARCHAR2(30 BYTE), 
	"LOCKBOX_MATCHING_OPTION" VARCHAR2(30 BYTE), 
	"AUTOCASH_HIERARCHY_NAME_ADR" VARCHAR2(30 BYTE), 
	"CREDIT_CLASSIFICATION" VARCHAR2(30 BYTE), 
	"CONS_BILL_LEVEL" VARCHAR2(30 BYTE), 
	"LATE_CHARGE_CALCULATION_TRX" VARCHAR2(30 BYTE), 
	"CREDIT_ITEMS_FLAG" VARCHAR2(1 BYTE), 
	"DISPUTED_TRANSACTIONS_FLAG" VARCHAR2(1 BYTE), 
	"LATE_CHARGE_TYPE" VARCHAR2(30 BYTE), 
	"INTEREST_CALCULATION_PERIOD" VARCHAR2(30 BYTE), 
	"HOLD_CHARGED_INVOICES_FLAG" VARCHAR2(1 BYTE), 
	"MULTIPLE_INTEREST_RATES_FLAG" VARCHAR2(1 BYTE), 
	"CHARGE_BEGIN_DATE" DATE, 
	"EXCHANGE_RATE_TYPE" VARCHAR2(30 BYTE), 
	"MIN_FC_INVOICE_OVERDUE_TYPE" VARCHAR2(30 BYTE), 
	"MIN_FC_INVOICE_PERCENT" NUMBER, 
	"MIN_FC_BALANCE_OVERDUE_TYPE" VARCHAR2(30 BYTE), 
	"MIN_FC_BALANCE_PERCENT" NUMBER, 
	"INTEREST_TYPE" VARCHAR2(30 BYTE), 
	"INTEREST_FIXED_AMOUNT" NUMBER, 
	"PENALTY_TYPE" VARCHAR2(30 BYTE), 
	"PENALTY_RATE" NUMBER, 
	"MIN_INTEREST_CHARGE" NUMBER, 
	"PENALTY_FIXED_AMOUNT" NUMBER, 
	"AUTOMATCH_RULE_NAME" VARCHAR2(30 BYTE), 
	"MATCH_BY_AUTOUPDATE_FLAG" VARCHAR2(1 BYTE), 
	"PRINTING_OPTION_CODE" VARCHAR2(30 BYTE), 
	"TXN_DELIVERY_METHOD" VARCHAR2(30 BYTE), 
	"STMT_DELIVERY_METHOD" VARCHAR2(30 BYTE), 
	"XML_INV_FLAG" VARCHAR2(1 BYTE), 
	"XML_DM_FLAG" VARCHAR2(1 BYTE), 
	"XML_CB_FLAG" VARCHAR2(1 BYTE), 
	"XML_CM_FLAG" VARCHAR2(1 BYTE), 
	"CMK_CONFIG_FLAG" VARCHAR2(1 BYTE), 
	"SERVICE_PROVIDER_NAME" VARCHAR2(256 BYTE), 
	"PARTNER_ID" VARCHAR2(100 BYTE), 
	"PARTNER_ID_TYPE_CODE" VARCHAR2(100 BYTE), 
	"AR_OUTBOUND_TRANSACTION_FLAG" VARCHAR2(1 BYTE), 
	"AR_INBOUND_CONFIRM_BOD_FLAG" VARCHAR2(1 BYTE), 
	"ACCOUNT_NUMBER" VARCHAR2(30 BYTE), 
	"PARTY_NUMBER" VARCHAR2(30 BYTE), 
	"PREF_CONTACT_METHOD" VARCHAR2(30 BYTE), 
	"INTEREST_SCHEDULE_ID" NUMBER, 
	"PENALTY_SCHEDULE_ID" NUMBER, 
	"LOAD_REQUEST_ID" NUMBER, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" VARCHAR2(100 BYTE), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" VARCHAR2(100 BYTE), 
	"OU_NAME" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
