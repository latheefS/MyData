--------------------------------------------------------
--  DDL for Table XXMX_AP_INVOICES_XFM_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"INVOICE_ID" NUMBER(15,0), 
	"SOURCE_OPERATING_UNIT" VARCHAR2(240 BYTE), 
	"FUSION_BUSINESS_UNIT" VARCHAR2(240 BYTE), 
	"SOURCE_LEDGER_NAME" VARCHAR2(30 BYTE), 
	"FUSION_LEDGER_NAME" VARCHAR2(30 BYTE), 
	"SOURCE" VARCHAR2(80 BYTE), 
	"INVOICE_NUM" VARCHAR2(50 BYTE), 
	"INVOICE_AMOUNT" NUMBER, 
	"INVOICE_DATE" DATE, 
	"VENDOR_NAME" VARCHAR2(240 BYTE), 
	"VENDOR_NUM" VARCHAR2(30 BYTE), 
	"VENDOR_SITE_CODE" VARCHAR2(15 BYTE), 
	"INVOICE_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PAYMENT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"IMPORT_SET" VARCHAR2(80 BYTE), 
	"INVOICE_TYPE_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"LEGAL_ENTITY_NAME" VARCHAR2(50 BYTE), 
	"CUST_REGISTRATION_NUMBER" VARCHAR2(30 BYTE), 
	"CUST_REGISTRATION_CODE" VARCHAR2(30 BYTE), 
	"FIRST_PARTY_REGISTRATION_NUM" VARCHAR2(60 BYTE), 
	"THIRD_PARTY_REGISTRATION_NUM" VARCHAR2(60 BYTE), 
	"TERMS_NAME" VARCHAR2(50 BYTE), 
	"TERMS_DATE" DATE, 
	"GOODS_RECEIVED_DATE" DATE, 
	"INVOICE_RECEIVED_DATE" DATE, 
	"GL_DATE" DATE, 
	"PAYMENT_METHOD_CODE" VARCHAR2(30 BYTE), 
	"PAY_GROUP_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"EXCLUSIVE_PAYMENT_FLAG" VARCHAR2(1 BYTE), 
	"AMOUNT_APPLICABLE_TO_DISCOUNT" NUMBER, 
	"PREPAY_NUM" VARCHAR2(50 BYTE), 
	"PREPAY_LINE_NUM" NUMBER, 
	"PREPAY_APPLY_AMOUNT" NUMBER, 
	"PREPAY_GL_DATE" DATE, 
	"INVOICE_INCLUDES_PREPAY_FLAG" VARCHAR2(1 BYTE), 
	"EXCHANGE_RATE_TYPE" VARCHAR2(30 BYTE), 
	"EXCHANGE_DATE" DATE, 
	"EXCHANGE_RATE" NUMBER, 
	"ACCTS_PAY_CODE_CONCATENATED" VARCHAR2(250 BYTE), 
	"DOC_CATEGORY_CODE" VARCHAR2(30 BYTE), 
	"VOUCHER_NUM" VARCHAR2(50 BYTE), 
	"REQUESTER_FIRST_NAME" VARCHAR2(150 BYTE), 
	"REQUESTER_LAST_NAME" VARCHAR2(150 BYTE), 
	"REQUESTER_EMPLOYEE_NUM" VARCHAR2(30 BYTE), 
	"DELIVERY_CHANNEL_CODE" VARCHAR2(30 BYTE), 
	"BANK_CHARGE_BEARER" VARCHAR2(30 BYTE), 
	"REMIT_TO_SUPPLIER_NAME" VARCHAR2(240 BYTE), 
	"REMIT_TO_SUPPLIER_NUM" VARCHAR2(30 BYTE), 
	"REMIT_TO_ADDRESS_NAME" VARCHAR2(240 BYTE), 
	"PAYMENT_PRIORITY" NUMBER(2,0), 
	"SETTLEMENT_PRIORITY" VARCHAR2(30 BYTE), 
	"UNIQUE_REMITTANCE_IDENTIFIER" VARCHAR2(30 BYTE), 
	"URI_CHECK_DIGIT" VARCHAR2(2 BYTE), 
	"PAYMENT_REASON_CODE" VARCHAR2(30 BYTE), 
	"PAYMENT_REASON_COMMENTS" VARCHAR2(240 BYTE), 
	"REMITTANCE_MESSAGE1" VARCHAR2(150 BYTE), 
	"REMITTANCE_MESSAGE2" VARCHAR2(150 BYTE), 
	"REMITTANCE_MESSAGE3" VARCHAR2(150 BYTE), 
	"AWT_GROUP_NAME" VARCHAR2(25 BYTE), 
	"SHIP_TO_LOCATION" VARCHAR2(40 BYTE), 
	"TAXATION_COUNTRY" VARCHAR2(30 BYTE), 
	"DOCUMENT_SUB_TYPE" VARCHAR2(150 BYTE), 
	"TAX_INVOICE_INTERNAL_SEQ" VARCHAR2(150 BYTE), 
	"SUPPLIER_TAX_INVOICE_NUMBER" VARCHAR2(150 BYTE), 
	"TAX_INVOICE_RECORDING_DATE" DATE, 
	"SUPPLIER_TAX_INVOICE_DATE" DATE, 
	"SUPPLIER_TAX_EXCHANGE_RATE" NUMBER, 
	"PORT_OF_ENTRY_CODE" VARCHAR2(30 BYTE), 
	"CORRECTION_YEAR" NUMBER, 
	"CORRECTION_PERIOD" VARCHAR2(15 BYTE), 
	"IMPORT_DOCUMENT_NUMBER" VARCHAR2(50 BYTE), 
	"IMPORT_DOCUMENT_DATE" DATE, 
	"CONTROL_AMOUNT" NUMBER, 
	"CALC_TAX_DURING_IMPORT_FLAG" VARCHAR2(1 BYTE), 
	"ADD_TAX_TO_INV_AMT_FLAG" VARCHAR2(1 BYTE), 
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
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"GLOBAL_ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
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
	"GLOBAL_ATTRIBUTE_NUMBER1" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER2" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER3" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER4" NUMBER, 
	"GLOBAL_ATTRIBUTE_NUMBER5" NUMBER, 
	"GLOBAL_ATTRIBUTE_DATE1" DATE, 
	"GLOBAL_ATTRIBUTE_DATE2" DATE, 
	"GLOBAL_ATTRIBUTE_DATE3" DATE, 
	"GLOBAL_ATTRIBUTE_DATE4" DATE, 
	"GLOBAL_ATTRIBUTE_DATE5" DATE, 
	"IMAGE_DOCUMENT_URI" VARCHAR2(4000 BYTE), 
	"EXTERNAL_BANK_ACCOUNT_NUMBER" VARCHAR2(100 BYTE), 
	"EXT_BANK_ACCOUNT_IBAN_NUMBER" VARCHAR2(50 BYTE), 
	"REQUESTER_EMAIL_ADDRESS" VARCHAR2(240 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_AP_INVOICES_XFM_ARCH" TO "XXMX_CORE";