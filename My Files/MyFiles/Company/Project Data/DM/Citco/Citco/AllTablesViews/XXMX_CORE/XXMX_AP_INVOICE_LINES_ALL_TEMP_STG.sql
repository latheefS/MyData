--------------------------------------------------------
--  DDL for Table XXMX_AP_INVOICE_LINES_ALL_TEMP_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_AP_INVOICE_LINES_ALL_TEMP_STG" 
   (	"INVOICE_ID" NUMBER(15,0), 
	"LINE_NUMBER" NUMBER, 
	"LINE_TYPE_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"REQUESTER_ID" NUMBER(15,0), 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"LINE_SOURCE" VARCHAR2(30 BYTE), 
	"ORG_ID" NUMBER(15,0), 
	"LINE_GROUP_NUMBER" NUMBER, 
	"INVENTORY_ITEM_ID" NUMBER, 
	"ITEM_DESCRIPTION" VARCHAR2(240 BYTE), 
	"SERIAL_NUMBER" VARCHAR2(35 BYTE), 
	"MANUFACTURER" VARCHAR2(30 BYTE), 
	"MODEL_NUMBER" VARCHAR2(40 BYTE), 
	"WARRANTY_NUMBER" VARCHAR2(15 BYTE), 
	"GENERATE_DISTS" VARCHAR2(1 BYTE), 
	"MATCH_TYPE" VARCHAR2(25 BYTE), 
	"DISTRIBUTION_SET_ID" NUMBER(15,0), 
	"ACCOUNT_SEGMENT" VARCHAR2(25 BYTE), 
	"BALANCING_SEGMENT" VARCHAR2(25 BYTE), 
	"COST_CENTER_SEGMENT" VARCHAR2(25 BYTE), 
	"OVERLAY_DIST_CODE_CONCAT" VARCHAR2(250 BYTE), 
	"DEFAULT_DIST_CCID" NUMBER(15,0), 
	"PRORATE_ACROSS_ALL_ITEMS" VARCHAR2(1 BYTE), 
	"ACCOUNTING_DATE" DATE, 
	"PERIOD_NAME" VARCHAR2(15 BYTE), 
	"DEFERRED_ACCTG_FLAG" VARCHAR2(1 BYTE), 
	"DEF_ACCTG_START_DATE" DATE, 
	"DEF_ACCTG_END_DATE" DATE, 
	"DEF_ACCTG_NUMBER_OF_PERIODS" NUMBER, 
	"DEF_ACCTG_PERIOD_TYPE" VARCHAR2(30 BYTE), 
	"SET_OF_BOOKS_ID" NUMBER(15,0), 
	"AMOUNT" NUMBER, 
	"BASE_AMOUNT" NUMBER, 
	"ROUNDING_AMT" NUMBER, 
	"QUANTITY_INVOICED" NUMBER, 
	"UNIT_MEAS_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"UNIT_PRICE" NUMBER, 
	"WFAPPROVAL_STATUS" VARCHAR2(30 BYTE), 
	"USSGL_TRANSACTION_CODE" VARCHAR2(30 BYTE), 
	"DISCARDED_FLAG" VARCHAR2(1 BYTE), 
	"ORIGINAL_AMOUNT" NUMBER, 
	"ORIGINAL_BASE_AMOUNT" NUMBER, 
	"ORIGINAL_ROUNDING_AMT" NUMBER, 
	"CANCELLED_FLAG" VARCHAR2(1 BYTE), 
	"INCOME_TAX_REGION" VARCHAR2(10 BYTE), 
	"TYPE_1099" VARCHAR2(10 BYTE), 
	"STAT_AMOUNT" NUMBER, 
	"PREPAY_INVOICE_ID" NUMBER(15,0), 
	"PREPAY_LINE_NUMBER" NUMBER, 
	"INVOICE_INCLUDES_PREPAY_FLAG" VARCHAR2(1 BYTE), 
	"CORRECTED_INV_ID" NUMBER(15,0), 
	"CORRECTED_LINE_NUMBER" NUMBER, 
	"PO_HEADER_ID" NUMBER, 
	"PO_LINE_ID" NUMBER, 
	"PO_RELEASE_ID" NUMBER, 
	"PO_LINE_LOCATION_ID" NUMBER, 
	"PO_DISTRIBUTION_ID" NUMBER, 
	"RCV_TRANSACTION_ID" NUMBER, 
	"FINAL_MATCH_FLAG" VARCHAR2(1 BYTE), 
	"ASSETS_TRACKING_FLAG" VARCHAR2(1 BYTE), 
	"ASSET_BOOK_TYPE_CODE" VARCHAR2(15 BYTE), 
	"ASSET_CATEGORY_ID" NUMBER(15,0), 
	"PROJECT_ID" NUMBER(15,0), 
	"TASK_ID" NUMBER(15,0), 
	"EXPENDITURE_TYPE" VARCHAR2(30 BYTE), 
	"EXPENDITURE_ITEM_DATE" DATE, 
	"EXPENDITURE_ORGANIZATION_ID" NUMBER(15,0), 
	"PA_QUANTITY" NUMBER, 
	"PA_CC_AR_INVOICE_ID" NUMBER(15,0), 
	"PA_CC_AR_INVOICE_LINE_NUM" NUMBER(15,0), 
	"PA_CC_PROCESSED_CODE" VARCHAR2(1 BYTE), 
	"AWARD_ID" NUMBER(15,0), 
	"AWT_GROUP_ID" NUMBER(15,0), 
	"REFERENCE_1" VARCHAR2(30 BYTE), 
	"REFERENCE_2" VARCHAR2(30 BYTE), 
	"RECEIPT_VERIFIED_FLAG" VARCHAR2(1 BYTE), 
	"RECEIPT_REQUIRED_FLAG" VARCHAR2(1 BYTE), 
	"RECEIPT_MISSING_FLAG" VARCHAR2(1 BYTE), 
	"JUSTIFICATION" VARCHAR2(240 BYTE), 
	"EXPENSE_GROUP" VARCHAR2(80 BYTE), 
	"START_EXPENSE_DATE" DATE, 
	"END_EXPENSE_DATE" DATE, 
	"RECEIPT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"RECEIPT_CONVERSION_RATE" NUMBER, 
	"RECEIPT_CURRENCY_AMOUNT" NUMBER, 
	"DAILY_AMOUNT" NUMBER, 
	"WEB_PARAMETER_ID" NUMBER, 
	"ADJUSTMENT_REASON" VARCHAR2(240 BYTE), 
	"MERCHANT_DOCUMENT_NUMBER" VARCHAR2(80 BYTE), 
	"MERCHANT_NAME" VARCHAR2(240 BYTE), 
	"MERCHANT_REFERENCE" VARCHAR2(240 BYTE), 
	"MERCHANT_TAX_REG_NUMBER" VARCHAR2(80 BYTE), 
	"MERCHANT_TAXPAYER_ID" VARCHAR2(80 BYTE), 
	"COUNTRY_OF_SUPPLY" VARCHAR2(5 BYTE), 
	"CREDIT_CARD_TRX_ID" NUMBER(15,0), 
	"COMPANY_PREPAID_INVOICE_ID" NUMBER(15,0), 
	"CC_REVERSAL_FLAG" VARCHAR2(1 BYTE), 
	"CREATION_DATE" DATE, 
	"CREATED_BY" NUMBER(15,0), 
	"LAST_UPDATED_BY" NUMBER(15,0), 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATE_LOGIN" NUMBER(15,0), 
	"PROGRAM_APPLICATION_ID" NUMBER(15,0), 
	"PROGRAM_ID" NUMBER(15,0), 
	"PROGRAM_UPDATE_DATE" DATE, 
	"REQUEST_ID" NUMBER(15,0), 
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
	"LINE_SELECTED_FOR_APPL_FLAG" VARCHAR2(1 BYTE), 
	"PREPAY_APPL_REQUEST_ID" NUMBER(15,0), 
	"APPLICATION_ID" NUMBER(15,0), 
	"PRODUCT_TABLE" VARCHAR2(30 BYTE), 
	"REFERENCE_KEY1" VARCHAR2(150 BYTE), 
	"REFERENCE_KEY2" VARCHAR2(150 BYTE), 
	"REFERENCE_KEY3" VARCHAR2(150 BYTE), 
	"REFERENCE_KEY4" VARCHAR2(150 BYTE), 
	"REFERENCE_KEY5" VARCHAR2(150 BYTE), 
	"PURCHASING_CATEGORY_ID" NUMBER(15,0), 
	"COST_FACTOR_ID" NUMBER(15,0), 
	"CONTROL_AMOUNT" NUMBER, 
	"ASSESSABLE_VALUE" NUMBER, 
	"TOTAL_REC_TAX_AMOUNT" NUMBER, 
	"TOTAL_NREC_TAX_AMOUNT" NUMBER, 
	"TOTAL_REC_TAX_AMT_FUNCL_CURR" NUMBER, 
	"TOTAL_NREC_TAX_AMT_FUNCL_CURR" NUMBER, 
	"INCLUDED_TAX_AMOUNT" NUMBER, 
	"PRIMARY_INTENDED_USE" VARCHAR2(30 BYTE), 
	"TAX_ALREADY_CALCULATED_FLAG" VARCHAR2(1 BYTE), 
	"SHIP_TO_LOCATION_ID" NUMBER(15,0), 
	"PRODUCT_TYPE" VARCHAR2(240 BYTE), 
	"PRODUCT_CATEGORY" VARCHAR2(240 BYTE), 
	"PRODUCT_FISC_CLASSIFICATION" VARCHAR2(240 BYTE), 
	"USER_DEFINED_FISC_CLASS" VARCHAR2(240 BYTE), 
	"TRX_BUSINESS_CATEGORY" VARCHAR2(240 BYTE), 
	"SUMMARY_TAX_LINE_ID" NUMBER, 
	"TAX_REGIME_CODE" VARCHAR2(30 BYTE), 
	"TAX" VARCHAR2(30 BYTE), 
	"TAX_JURISDICTION_CODE" VARCHAR2(30 BYTE), 
	"TAX_STATUS_CODE" VARCHAR2(30 BYTE), 
	"TAX_RATE_ID" NUMBER(15,0), 
	"TAX_RATE_CODE" VARCHAR2(150 BYTE), 
	"TAX_RATE" NUMBER, 
	"TAX_CODE_ID" NUMBER(15,0), 
	"HISTORICAL_FLAG" VARCHAR2(1 BYTE), 
	"TAX_CLASSIFICATION_CODE" VARCHAR2(30 BYTE), 
	"SOURCE_APPLICATION_ID" NUMBER, 
	"SOURCE_EVENT_CLASS_CODE" VARCHAR2(30 BYTE), 
	"SOURCE_ENTITY_CODE" VARCHAR2(30 BYTE), 
	"SOURCE_TRX_ID" NUMBER, 
	"SOURCE_LINE_ID" NUMBER, 
	"SOURCE_TRX_LEVEL_TYPE" VARCHAR2(30 BYTE), 
	"RETAINED_AMOUNT" NUMBER, 
	"RETAINED_AMOUNT_REMAINING" NUMBER, 
	"RETAINED_INVOICE_ID" NUMBER(15,0), 
	"RETAINED_LINE_NUMBER" NUMBER, 
	"LINE_SELECTED_FOR_RELEASE_FLAG" VARCHAR2(1 BYTE), 
	"LINE_OWNER_ROLE" VARCHAR2(320 BYTE), 
	"DISPUTABLE_FLAG" VARCHAR2(1 BYTE), 
	"RCV_SHIPMENT_LINE_ID" NUMBER(15,0), 
	"AIL_INVOICE_ID" NUMBER(15,0), 
	"AIL_DISTRIBUTION_LINE_NUMBER" NUMBER(15,0), 
	"AIL_INVOICE_ID2" NUMBER(15,0), 
	"AIL_DISTRIBUTION_LINE_NUMBER2" NUMBER(15,0), 
	"AIL_INVOICE_ID3" NUMBER(15,0), 
	"AIL_DISTRIBUTION_LINE_NUMBER3" NUMBER(15,0), 
	"AIL_INVOICE_ID4" NUMBER(15,0), 
	"PAY_AWT_GROUP_ID" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_AP_INVOICE_LINES_ALL_TEMP_STG" TO "XXMX_READONLY";