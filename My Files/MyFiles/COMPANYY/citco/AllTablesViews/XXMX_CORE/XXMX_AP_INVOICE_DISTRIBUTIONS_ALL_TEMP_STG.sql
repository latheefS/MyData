--------------------------------------------------------
--  DDL for Table XXMX_AP_INVOICE_DISTRIBUTIONS_ALL_TEMP_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_AP_INVOICE_DISTRIBUTIONS_ALL_TEMP_STG" 
   (	"ACCOUNTING_DATE" DATE, 
	"ACCRUAL_POSTED_FLAG" VARCHAR2(1 BYTE), 
	"ASSETS_ADDITION_FLAG" VARCHAR2(1 BYTE), 
	"ASSETS_TRACKING_FLAG" VARCHAR2(1 BYTE), 
	"CASH_POSTED_FLAG" VARCHAR2(1 BYTE), 
	"DISTRIBUTION_LINE_NUMBER" NUMBER(15,0), 
	"DIST_CODE_COMBINATION_ID" NUMBER(15,0), 
	"INVOICE_ID" NUMBER(15,0), 
	"LAST_UPDATED_BY" NUMBER(15,0), 
	"LAST_UPDATE_DATE" DATE, 
	"LINE_TYPE_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"PERIOD_NAME" VARCHAR2(15 BYTE), 
	"SET_OF_BOOKS_ID" NUMBER(15,0), 
	"ACCTS_PAY_CODE_COMBINATION_ID" NUMBER(15,0), 
	"AMOUNT" NUMBER, 
	"BASE_AMOUNT" NUMBER, 
	"BASE_INVOICE_PRICE_VARIANCE" NUMBER, 
	"BATCH_ID" NUMBER(15,0), 
	"CREATED_BY" NUMBER(15,0), 
	"CREATION_DATE" DATE, 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"EXCHANGE_RATE_VARIANCE" NUMBER, 
	"FINAL_MATCH_FLAG" VARCHAR2(1 BYTE), 
	"INCOME_TAX_REGION" VARCHAR2(10 BYTE), 
	"INVOICE_PRICE_VARIANCE" NUMBER, 
	"LAST_UPDATE_LOGIN" NUMBER(15,0), 
	"MATCH_STATUS_FLAG" VARCHAR2(1 BYTE), 
	"POSTED_FLAG" VARCHAR2(1 BYTE), 
	"PO_DISTRIBUTION_ID" NUMBER(15,0), 
	"PROGRAM_APPLICATION_ID" NUMBER(15,0), 
	"PROGRAM_ID" NUMBER(15,0), 
	"PROGRAM_UPDATE_DATE" DATE, 
	"QUANTITY_INVOICED" NUMBER, 
	"RATE_VAR_CODE_COMBINATION_ID" NUMBER(15,0), 
	"REQUEST_ID" NUMBER(15,0), 
	"REVERSAL_FLAG" VARCHAR2(1 BYTE), 
	"TYPE_1099" VARCHAR2(10 BYTE), 
	"UNIT_PRICE" NUMBER, 
	"AMOUNT_ENCUMBERED" NUMBER, 
	"BASE_AMOUNT_ENCUMBERED" NUMBER, 
	"ENCUMBERED_FLAG" VARCHAR2(1 BYTE), 
	"EXCHANGE_DATE" DATE, 
	"EXCHANGE_RATE" NUMBER, 
	"EXCHANGE_RATE_TYPE" VARCHAR2(30 BYTE), 
	"PRICE_ADJUSTMENT_FLAG" VARCHAR2(1 BYTE), 
	"PRICE_VAR_CODE_COMBINATION_ID" NUMBER(15,0), 
	"QUANTITY_UNENCUMBERED" NUMBER, 
	"STAT_AMOUNT" NUMBER, 
	"AMOUNT_TO_POST" NUMBER, 
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
	"ATTRIBUTE_CATEGORY" VARCHAR2(150 BYTE), 
	"BASE_AMOUNT_TO_POST" NUMBER, 
	"CASH_JE_BATCH_ID" NUMBER(15,0), 
	"EXPENDITURE_ITEM_DATE" DATE, 
	"EXPENDITURE_ORGANIZATION_ID" NUMBER(15,0), 
	"EXPENDITURE_TYPE" VARCHAR2(30 BYTE), 
	"JE_BATCH_ID" NUMBER(15,0), 
	"PARENT_INVOICE_ID" NUMBER(15,0), 
	"PA_ADDITION_FLAG" VARCHAR2(1 BYTE), 
	"PA_QUANTITY" NUMBER(22,5), 
	"POSTED_AMOUNT" NUMBER, 
	"POSTED_BASE_AMOUNT" NUMBER, 
	"PREPAY_AMOUNT_REMAINING" NUMBER, 
	"PROJECT_ACCOUNTING_CONTEXT" VARCHAR2(30 BYTE), 
	"PROJECT_ID" NUMBER(15,0), 
	"TASK_ID" NUMBER(15,0), 
	"USSGL_TRANSACTION_CODE" VARCHAR2(30 BYTE), 
	"USSGL_TRX_CODE_CONTEXT" VARCHAR2(30 BYTE), 
	"EARLIEST_SETTLEMENT_DATE" DATE, 
	"REQ_DISTRIBUTION_ID" NUMBER(15,0), 
	"QUANTITY_VARIANCE" NUMBER, 
	"BASE_QUANTITY_VARIANCE" NUMBER, 
	"PACKET_ID" NUMBER(15,0), 
	"AWT_FLAG" VARCHAR2(1 BYTE), 
	"AWT_GROUP_ID" NUMBER(15,0), 
	"AWT_TAX_RATE_ID" NUMBER(15,0), 
	"AWT_GROSS_AMOUNT" NUMBER, 
	"AWT_INVOICE_ID" NUMBER(15,0), 
	"AWT_ORIGIN_GROUP_ID" NUMBER(15,0), 
	"REFERENCE_1" VARCHAR2(30 BYTE), 
	"REFERENCE_2" VARCHAR2(30 BYTE), 
	"ORG_ID" NUMBER(15,0), 
	"OTHER_INVOICE_ID" NUMBER(15,0), 
	"AWT_INVOICE_PAYMENT_ID" NUMBER(15,0), 
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
	"LINE_GROUP_NUMBER" NUMBER(15,0), 
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
	"AWARD_ID" NUMBER(15,0), 
	"MRC_ACCRUAL_POSTED_FLAG" VARCHAR2(2000 BYTE), 
	"MRC_CASH_POSTED_FLAG" VARCHAR2(2000 BYTE), 
	"MRC_DIST_CODE_COMBINATION_ID" VARCHAR2(2000 BYTE), 
	"MRC_AMOUNT" VARCHAR2(2000 BYTE), 
	"MRC_BASE_AMOUNT" VARCHAR2(2000 BYTE), 
	"MRC_BASE_INV_PRICE_VARIANCE" VARCHAR2(2000 BYTE), 
	"MRC_EXCHANGE_RATE_VARIANCE" VARCHAR2(2000 BYTE), 
	"MRC_POSTED_FLAG" VARCHAR2(2000 BYTE), 
	"MRC_PROGRAM_APPLICATION_ID" VARCHAR2(2000 BYTE), 
	"MRC_PROGRAM_ID" VARCHAR2(2000 BYTE), 
	"MRC_PROGRAM_UPDATE_DATE" VARCHAR2(2000 BYTE), 
	"MRC_RATE_VAR_CCID" VARCHAR2(2000 BYTE), 
	"MRC_REQUEST_ID" VARCHAR2(2000 BYTE), 
	"MRC_EXCHANGE_DATE" VARCHAR2(2000 BYTE), 
	"MRC_EXCHANGE_RATE" VARCHAR2(2000 BYTE), 
	"MRC_EXCHANGE_RATE_TYPE" VARCHAR2(2000 BYTE), 
	"MRC_AMOUNT_TO_POST" VARCHAR2(2000 BYTE), 
	"MRC_BASE_AMOUNT_TO_POST" VARCHAR2(2000 BYTE), 
	"MRC_CASH_JE_BATCH_ID" VARCHAR2(2000 BYTE), 
	"MRC_JE_BATCH_ID" VARCHAR2(2000 BYTE), 
	"MRC_POSTED_AMOUNT" VARCHAR2(2000 BYTE), 
	"MRC_POSTED_BASE_AMOUNT" VARCHAR2(2000 BYTE), 
	"MRC_RECEIPT_CONVERSION_RATE" VARCHAR2(2000 BYTE), 
	"CREDIT_CARD_TRX_ID" NUMBER(15,0), 
	"DIST_MATCH_TYPE" VARCHAR2(25 BYTE), 
	"RCV_TRANSACTION_ID" NUMBER(15,0), 
	"INVOICE_DISTRIBUTION_ID" NUMBER(15,0), 
	"PARENT_REVERSAL_ID" NUMBER(15,0), 
	"TAX_RECOVERABLE_FLAG" VARCHAR2(1 BYTE), 
	"PA_CC_AR_INVOICE_ID" NUMBER(15,0), 
	"PA_CC_AR_INVOICE_LINE_NUM" NUMBER(15,0), 
	"PA_CC_PROCESSED_CODE" VARCHAR2(1 BYTE), 
	"MERCHANT_DOCUMENT_NUMBER" VARCHAR2(80 BYTE), 
	"MERCHANT_NAME" VARCHAR2(80 BYTE), 
	"MERCHANT_REFERENCE" VARCHAR2(240 BYTE), 
	"MERCHANT_TAX_REG_NUMBER" VARCHAR2(80 BYTE), 
	"MERCHANT_TAXPAYER_ID" VARCHAR2(80 BYTE), 
	"COUNTRY_OF_SUPPLY" VARCHAR2(5 BYTE), 
	"MATCHED_UOM_LOOKUP_CODE" VARCHAR2(25 BYTE), 
	"GMS_BURDENABLE_RAW_COST" NUMBER(22,5), 
	"ACCOUNTING_EVENT_ID" NUMBER(15,0), 
	"PREPAY_DISTRIBUTION_ID" NUMBER(15,0), 
	"UPGRADE_POSTED_AMT" NUMBER, 
	"UPGRADE_BASE_POSTED_AMT" NUMBER, 
	"INVENTORY_TRANSFER_STATUS" VARCHAR2(1 BYTE), 
	"COMPANY_PREPAID_INVOICE_ID" NUMBER(15,0), 
	"CC_REVERSAL_FLAG" VARCHAR2(1 BYTE), 
	"AWT_WITHHELD_AMT" NUMBER, 
	"INVOICE_INCLUDES_PREPAY_FLAG" VARCHAR2(1 BYTE), 
	"PRICE_CORRECT_INV_ID" NUMBER(15,0), 
	"PRICE_CORRECT_QTY" NUMBER, 
	"PA_CMT_XFACE_FLAG" VARCHAR2(1 BYTE), 
	"CANCELLATION_FLAG" VARCHAR2(1 BYTE), 
	"INVOICE_LINE_NUMBER" NUMBER, 
	"CORRECTED_INVOICE_DIST_ID" NUMBER(15,0), 
	"ROUNDING_AMT" NUMBER, 
	"CHARGE_APPLICABLE_TO_DIST_ID" NUMBER(15,0), 
	"CORRECTED_QUANTITY" NUMBER, 
	"RELATED_ID" NUMBER(15,0), 
	"ASSET_BOOK_TYPE_CODE" VARCHAR2(15 BYTE), 
	"ASSET_CATEGORY_ID" NUMBER(15,0), 
	"DISTRIBUTION_CLASS" VARCHAR2(30 BYTE), 
	"FINAL_PAYMENT_ROUNDING" NUMBER, 
	"FINAL_APPLICATION_ROUNDING" NUMBER, 
	"AMOUNT_AT_PREPAY_XRATE" NUMBER, 
	"CASH_BASIS_FINAL_APP_ROUNDING" NUMBER, 
	"AMOUNT_AT_PREPAY_PAY_XRATE" NUMBER, 
	"INTENDED_USE" VARCHAR2(30 BYTE), 
	"DETAIL_TAX_DIST_ID" NUMBER, 
	"REC_NREC_RATE" NUMBER, 
	"RECOVERY_RATE_ID" NUMBER, 
	"RECOVERY_RATE_NAME" VARCHAR2(150 BYTE), 
	"RECOVERY_TYPE_CODE" VARCHAR2(30 BYTE), 
	"RECOVERY_RATE_CODE" VARCHAR2(30 BYTE), 
	"WITHHOLDING_TAX_CODE_ID" NUMBER(15,0), 
	"TAX_ALREADY_DISTRIBUTED_FLAG" VARCHAR2(1 BYTE), 
	"SUMMARY_TAX_LINE_ID" NUMBER, 
	"TAXABLE_AMOUNT" NUMBER, 
	"TAXABLE_BASE_AMOUNT" NUMBER, 
	"EXTRA_PO_ERV" NUMBER, 
	"PREPAY_TAX_DIFF_AMOUNT" NUMBER, 
	"TAX_CODE_ID" NUMBER(15,0), 
	"VAT_CODE" VARCHAR2(15 BYTE), 
	"AMOUNT_INCLUDES_TAX_FLAG" VARCHAR2(1 BYTE), 
	"TAX_CALCULATED_FLAG" VARCHAR2(1 BYTE), 
	"TAX_RECOVERY_RATE" NUMBER, 
	"TAX_RECOVERY_OVERRIDE_FLAG" VARCHAR2(1 BYTE), 
	"TAX_CODE_OVERRIDE_FLAG" VARCHAR2(1 BYTE), 
	"TOTAL_DIST_AMOUNT" NUMBER, 
	"TOTAL_DIST_BASE_AMOUNT" NUMBER, 
	"PREPAY_TAX_PARENT_ID" NUMBER(15,0), 
	"CANCELLED_FLAG" VARCHAR2(1 BYTE), 
	"OLD_DISTRIBUTION_ID" NUMBER(15,0), 
	"OLD_DIST_LINE_NUMBER" NUMBER(15,0), 
	"AMOUNT_VARIANCE" NUMBER, 
	"BASE_AMOUNT_VARIANCE" NUMBER, 
	"HISTORICAL_FLAG" VARCHAR2(1 BYTE), 
	"RCV_CHARGE_ADDITION_FLAG" VARCHAR2(1 BYTE), 
	"AWT_RELATED_ID" NUMBER(15,0), 
	"RELATED_RETAINAGE_DIST_ID" NUMBER(15,0), 
	"RETAINED_AMOUNT_REMAINING" NUMBER, 
	"BC_EVENT_ID" NUMBER, 
	"RETAINED_INVOICE_DIST_ID" NUMBER(15,0), 
	"FINAL_RELEASE_ROUNDING" NUMBER, 
	"FULLY_PAID_ACCTD_FLAG" VARCHAR2(1 BYTE), 
	"ROOT_DISTRIBUTION_ID" NUMBER(15,0), 
	"XINV_PARENT_REVERSAL_ID" NUMBER(15,0), 
	"RECURRING_PAYMENT_ID" NUMBER(15,0), 
	"RELEASE_INV_DIST_DERIVED_FROM" NUMBER(15,0), 
	"PAY_AWT_GROUP_ID" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_AP_INVOICE_DISTRIBUTIONS_ALL_TEMP_STG" TO "XXMX_READONLY";
