--------------------------------------------------------
--  DDL for Table XXMX_AP_SUPPLIER_SITES_STG_BKP_171123
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_AP_SUPPLIER_SITES_STG_BKP_171123" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"IMPORT_ACTION" VARCHAR2(10 BYTE), 
	"SUPPLIER_ID" NUMBER, 
	"SUPPLIER_NAME" VARCHAR2(360 BYTE), 
	"PROCUREMENT_BU" VARCHAR2(240 BYTE), 
	"PARTY_SITE_ID" NUMBER, 
	"ADDRESS_NAME" VARCHAR2(240 BYTE), 
	"SUPPLIER_SITE_ID" NUMBER, 
	"SUPPLIER_SITE" VARCHAR2(15 BYTE), 
	"SUPPLIER_SITE_NEW" VARCHAR2(15 BYTE), 
	"INACTIVE_DATE" DATE, 
	"SOURCING_ONLY" VARCHAR2(1 BYTE), 
	"PURCHASING" VARCHAR2(1 BYTE), 
	"PROCUREMENT_CARD" VARCHAR2(1 BYTE), 
	"PAY" VARCHAR2(1 BYTE), 
	"PRIMARY_PAY" VARCHAR2(1 BYTE), 
	"INCOME_TAX_REPORTING_SITE" VARCHAR2(1 BYTE), 
	"ALTERNATE_SITE_NAME" VARCHAR2(320 BYTE), 
	"CUSTOMER_NUMBER" VARCHAR2(25 BYTE), 
	"B2B_COMMUNICATION_METHOD" VARCHAR2(10 BYTE), 
	"B2B_SUPPLIER_SITE_CODE" VARCHAR2(256 BYTE), 
	"COMMUNICATION_METHOD" VARCHAR2(25 BYTE), 
	"E_MAIL" VARCHAR2(2000 BYTE), 
	"FAX_COUNTRY_CODE" VARCHAR2(10 BYTE), 
	"FAX_AREA_CODE" VARCHAR2(10 BYTE), 
	"FAX" VARCHAR2(15 BYTE), 
	"HOLD_PURCHASING_DOCUMENTS" VARCHAR2(1 BYTE), 
	"HOLD_REASON" VARCHAR2(240 BYTE), 
	"CARRIER" VARCHAR2(360 BYTE), 
	"MODE_OF_TRANSPORT" VARCHAR2(30 BYTE), 
	"SERVICE_LEVEL" VARCHAR2(30 BYTE), 
	"FREIGHT_TERMS" VARCHAR2(25 BYTE), 
	"PAY_ON_RECEIPT" VARCHAR2(25 BYTE), 
	"FOB" VARCHAR2(25 BYTE), 
	"COUNTRY_OF_ORIGIN" VARCHAR2(2 BYTE), 
	"BUYER_MANAGED_TRANSPORTATION" VARCHAR2(1 BYTE), 
	"PAY_ON_USE" VARCHAR2(1 BYTE), 
	"AGING_ONSET_POINT" VARCHAR2(1 BYTE), 
	"AGING_PERIOD_DAYS" NUMBER(5,0), 
	"CONSUMPTION_ADVICE_FREQUENCY" VARCHAR2(30 BYTE), 
	"CONSUMPTION_ADVICE_SUMMARY" VARCHAR2(30 BYTE), 
	"DEFAULT_PAY_SITE" VARCHAR2(15 BYTE), 
	"INVOICE_SUMMARY_LEVEL" VARCHAR2(25 BYTE), 
	"GAPLESS_INVOICE_NUMBERING" VARCHAR2(1 BYTE), 
	"SELLING_COMPANY_IDENTIFIER" VARCHAR2(10 BYTE), 
	"CREATE_DEBIT_MEMO_FROM_RETURN" VARCHAR2(25 BYTE), 
	"SHIP_TO_EXCEPTION_ACTION" VARCHAR2(25 BYTE), 
	"RECEIPT_ROUTING" NUMBER(18,0), 
	"OVER_RECEIPT_TOLERANCE" NUMBER, 
	"OVER_RECEIPT_ACTION" VARCHAR2(25 BYTE), 
	"EARLY_RECEIPT_TOLERANCE" NUMBER, 
	"LATE_RECEIPT_TOLERANCE" NUMBER, 
	"ALLOW_SUBSTITUTE_RECEIPTS" VARCHAR2(1 BYTE), 
	"ALLOW_UNORDERED_RECEIPTS" VARCHAR2(1 BYTE), 
	"RECEIPT_DATE_EXCEPTION" VARCHAR2(25 BYTE), 
	"INVOICE_CURRENCY" VARCHAR2(15 BYTE), 
	"INVOICE_AMOUNT_LIMIT" NUMBER, 
	"INVOICE_MATCH_OPTION" VARCHAR2(25 BYTE), 
	"MATCH_APPROVAL_LEVEL" VARCHAR2(1 BYTE), 
	"PAYMENT_CURRENCY" VARCHAR2(15 BYTE), 
	"PAYMENT_PRIORITY" NUMBER, 
	"PAY_GROUP" VARCHAR2(25 BYTE), 
	"QUANTITY_TOLERANCES" VARCHAR2(255 BYTE), 
	"AMOUNT_TOLERANCE" VARCHAR2(255 BYTE), 
	"HOLD_ALL_INVOICES" VARCHAR2(1 BYTE), 
	"HOLD_UNMATCHED_INVOICES" VARCHAR2(1 BYTE), 
	"HOLD_UNVALIDATED_INVOICES" VARCHAR2(1 BYTE), 
	"PAYMENT_HOLD_BY" NUMBER(18,0), 
	"PAYMENT_HOLD_DATE" DATE, 
	"PAYMENT_HOLD_REASON" VARCHAR2(240 BYTE), 
	"PAYMENT_TERMS" VARCHAR2(50 BYTE), 
	"TERMS_DATE_BASIS" VARCHAR2(25 BYTE), 
	"PAY_DATE_BASIS" VARCHAR2(25 BYTE), 
	"BANK_CHARGE_DEDUCTION_TYPE" VARCHAR2(25 BYTE), 
	"ALWAYS_TAKE_DISCOUNT" VARCHAR2(1 BYTE), 
	"EXCLUDE_FREIGHT_FROM_DISCOUNT" VARCHAR2(1 BYTE), 
	"EXCLUDE_TAX_FROM_DISCOUNT" VARCHAR2(1 BYTE), 
	"CREATE_INTEREST_INVOICES" VARCHAR2(1 BYTE), 
	"VAT_CODE" VARCHAR2(30 BYTE), 
	"TAX_REGISTRATION_NUMBER" VARCHAR2(20 BYTE), 
	"PAYMENT_METHOD" VARCHAR2(30 BYTE), 
	"DELIVERY_CHANNEL" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION_1" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION_2" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION" VARCHAR2(255 BYTE), 
	"SETTLEMENT_PRIORITY" VARCHAR2(30 BYTE), 
	"PAYMENT_TEXT_MESSAGE_1" VARCHAR2(150 BYTE), 
	"PAYMENT_TEXT_MESSAGE_2" VARCHAR2(150 BYTE), 
	"PAYMENT_TEXT_MESSAGE_3" VARCHAR2(150 BYTE), 
	"BANK_CHARGE_BEARER" VARCHAR2(30 BYTE), 
	"PAYMENT_REASON" VARCHAR2(30 BYTE), 
	"PAYMENT_REASON_COMMENTS" VARCHAR2(240 BYTE), 
	"DELIVERY_METHOD" VARCHAR2(30 BYTE), 
	"REMITTANCE_E_MAIL" VARCHAR2(255 BYTE), 
	"REMITTANCE_FAX" VARCHAR2(15 BYTE), 
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
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_TIMESTAMP1" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP2" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP3" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP4" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP5" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP6" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP7" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP8" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP9" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP10" TIMESTAMP (6), 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"GLOBAL_ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"GLOBAL_ATTRIBUTE_DATE1" DATE, 
	"GLOBAL_ATTRIBUTE_DATE2" DATE, 
	"GLOBAL_ATTRIBUTE_DATE3" DATE, 
	"GLOBAL_ATTRIBUTE_DATE4" DATE, 
	"GLOBAL_ATTRIBUTE_DATE5" DATE, 
	"GLOBAL_ATTRIBUTE_DATE6" DATE, 
	"GLOBAL_ATTRIBUTE_DATE7" DATE, 
	"GLOBAL_ATTRIBUTE_DATE8" DATE, 
	"GLOBAL_ATTRIBUTE_DATE9" DATE, 
	"GLOBAL_ATTRIBUTE_DATE10" DATE, 
	"GLOBAL_ATTRIBUTE_TIMESTAMP1" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP2" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP3" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP4" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP5" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP6" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP7" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP8" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP9" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_TIMESTAMP10" TIMESTAMP (6), 
	"GLOBAL_ATTRIBUTE_NUMBER1" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER2" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER3" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER4" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER5" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER6" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER7" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER8" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER9" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER10" NUMBER, 
	"REQUIRED_ACKNOWLEDGEMENT" VARCHAR2(30 BYTE), 
	"ACKNOWLEDGE_WITHIN_DAYS" NUMBER(*,0), 
	"INVOICE_CHANNEL" VARCHAR2(30 BYTE), 
	"PAYEE_SERVICE_LEVEL_CODE" VARCHAR2(30 BYTE), 
	"EXCLUSIVE_PAYMENT_FLAG" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;