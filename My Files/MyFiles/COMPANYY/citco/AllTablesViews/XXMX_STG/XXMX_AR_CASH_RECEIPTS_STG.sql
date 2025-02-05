--------------------------------------------------------
--  DDL for Table XXMX_AR_CASH_RECEIPTS_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" 
   (	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"RECORD_TYPE" NUMBER, 
	"OPERATING_UNIT_NAME" VARCHAR2(240 BYTE), 
	"BATCH_NAME" VARCHAR2(25 BYTE), 
	"ITEM_NUMBER" NUMBER, 
	"REMITTANCE_AMOUNT" NUMBER, 
	"REMITTANCE_AMOUNT_DISP" VARCHAR2(120 BYTE), 
	"TRANSIT_ROUTING_NUMBER" VARCHAR2(25 BYTE), 
	"CUSTOMER_BANK_ACCOUNT" VARCHAR2(30 BYTE), 
	"CASH_RECEIPT_ID" NUMBER, 
	"RECEIPT_NUMBER" VARCHAR2(30 BYTE), 
	"RECEIPT_DATE" DATE, 
	"RECEIPT_DATE_FORMAT" VARCHAR2(6 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"EXCHANGE_RATE_TYPE" VARCHAR2(30 BYTE), 
	"EXCHANGE_RATE" NUMBER, 
	"CUSTOMER_NUMBER" VARCHAR2(30 BYTE), 
	"BILL_TO_LOCATION" VARCHAR2(40 BYTE), 
	"CUSTOMER_BANK_BRANCH_NAME" VARCHAR2(320 BYTE), 
	"CUSTOMER_BANK_NAME" VARCHAR2(320 BYTE), 
	"RECEIPT_METHOD" VARCHAR2(30 BYTE), 
	"REMITTANCE_BANK_BRANCH_NAME" VARCHAR2(320 BYTE), 
	"REMITTANCE_BANK_NAME" VARCHAR2(320 BYTE), 
	"LOCKBOX_NUMBER" VARCHAR2(30 BYTE), 
	"DEPOSIT_DATE" DATE, 
	"DEPOSIT_DATE_FORMAT" VARCHAR2(6 BYTE), 
	"DEPOSIT_TIME" VARCHAR2(8 BYTE), 
	"ANTICIPATED_CLEAR_DATE" DATE, 
	"ANTICIPATED_CLEAR_DATE_FORMAT" VARCHAR2(6 BYTE), 
	"MIGRATED_RECEIPT_TYPE" VARCHAR2(30 BYTE), 
	"COMMENTS" VARCHAR2(240 BYTE), 
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
	"ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"OVERFLOW_SEQUENCE" NUMBER, 
	"OVERFLOW_INDICATOR" NUMBER, 
	"INVOICE_NUMBER" VARCHAR2(50 BYTE), 
	"INVOICE_INSTALLMENT" NUMBER, 
	"MATCHING_DATE" DATE, 
	"MATCHING_DATE_FORMAT" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE" NUMBER, 
	"AMOUNT_APPLIED" NUMBER, 
	"AMOUNT_APPLIED_DISP" VARCHAR2(30 BYTE), 
	"AMOUNT_APPLIED_FROM" NUMBER, 
	"CUSTOMER_REFERENCE" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS" NUMBER, 
	"BANK_ACCOUNT_NUM" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT ALTER ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_AR_CASH_RECEIPTS_STG" TO "XXMX_READONLY";
