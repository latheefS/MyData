--------------------------------------------------------
--  DDL for Table XXMX_AR_CASH_RECEIPTS_XFM_ARCH
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_AR_CASH_RECEIPTS_XFM_ARCH" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"RECORD_TYPE" NUMBER, 
	"OPERATING_UNIT_NAME" VARCHAR2(240 BYTE), 
	"BATCH_NAME" VARCHAR2(25 BYTE), 
	"ITEM_NUMBER" NUMBER, 
	"REMITTANCE_AMOUNT" NUMBER, 
	"REMITTANCE_AMOUNT_DISP" NUMBER, 
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
	"INVOICE1" VARCHAR2(50 BYTE), 
	"INVOICE1_INSTALLMENT" NUMBER, 
	"MATCHING_DATE1" DATE, 
	"MATCHING_DATE_FORMAT1" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE1" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE1" NUMBER, 
	"AMOUNT_APPLIED1" NUMBER, 
	"AMOUNT_APPLIED_DISP1" NUMBER, 
	"AMOUNT_APPLIED_FROM1" NUMBER, 
	"CUSTOMER_REFERENCE1" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS1" NUMBER, 
	"INVOICE2" VARCHAR2(50 BYTE), 
	"INVOICE2_INSTALLMENT" NUMBER, 
	"MATCHING_DATE2" DATE, 
	"MATCHING_DATE_FORMAT2" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE2" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE2" NUMBER, 
	"AMOUNT_APPLIED2" NUMBER, 
	"AMOUNT_APPLIED_DISP2" NUMBER, 
	"AMOUNT_APPLIED_FROM2" NUMBER, 
	"CUSTOMER_REFERENCE2" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS2" NUMBER, 
	"INVOICE3" VARCHAR2(50 BYTE), 
	"INVOICE3_INSTALLMENT" NUMBER, 
	"MATCHING_DATE3" DATE, 
	"MATCHING_DATE_FORMAT3" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE3" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE3" NUMBER, 
	"AMOUNT_APPLIED3" NUMBER, 
	"AMOUNT_APPLIED_DISP3" NUMBER, 
	"AMOUNT_APPLIED_FROM3" NUMBER, 
	"CUSTOMER_REFERENCE3" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS3" NUMBER, 
	"INVOICE4" VARCHAR2(50 BYTE), 
	"INVOICE4_INSTALLMENT" NUMBER, 
	"MATCHING_DATE4" DATE, 
	"MATCHING_DATE_FORMAT4" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE4" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE4" NUMBER, 
	"AMOUNT_APPLIED4" NUMBER, 
	"AMOUNT_APPLIED_DISP4" NUMBER, 
	"AMOUNT_APPLIED_FROM4" NUMBER, 
	"CUSTOMER_REFERENCE4" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS4" NUMBER, 
	"INVOICE5" VARCHAR2(50 BYTE), 
	"INVOICE5_INSTALLMENT" NUMBER, 
	"MATCHING_DATE5" DATE, 
	"MATCHING_DATE_FORMAT5" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE5" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE5" NUMBER, 
	"AMOUNT_APPLIED5" NUMBER, 
	"AMOUNT_APPLIED_DISP5" NUMBER, 
	"AMOUNT_APPLIED_FROM5" NUMBER, 
	"CUSTOMER_REFERENCE5" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS5" NUMBER, 
	"INVOICE6" VARCHAR2(50 BYTE), 
	"INVOICE6_INSTALLMENT" NUMBER, 
	"MATCHING_DATE6" DATE, 
	"MATCHING_DATE_FORMAT6" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE6" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE6" NUMBER, 
	"AMOUNT_APPLIED6" NUMBER, 
	"AMOUNT_APPLIED_DISP6" NUMBER, 
	"AMOUNT_APPLIED_FROM6" NUMBER, 
	"CUSTOMER_REFERENCE6" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS6" NUMBER, 
	"INVOICE7" VARCHAR2(50 BYTE), 
	"INVOICE7_INSTALLMENT" NUMBER, 
	"MATCHING_DATE7" DATE, 
	"MATCHING_DATE_FORMAT7" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE7" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE7" NUMBER, 
	"AMOUNT_APPLIED7" NUMBER, 
	"AMOUNT_APPLIED_DISP7" NUMBER, 
	"AMOUNT_APPLIED_FROM7" NUMBER, 
	"CUSTOMER_REFERENCE7" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS7" NUMBER, 
	"INVOICE8" VARCHAR2(50 BYTE), 
	"INVOICE8_INSTALLMENT" NUMBER, 
	"MATCHING_DATE8" DATE, 
	"MATCHING_DATE_FORMAT8" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE8" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE8" NUMBER, 
	"AMOUNT_APPLIED8" NUMBER, 
	"AMOUNT_APPLIED_DISP8" NUMBER, 
	"AMOUNT_APPLIED_FROM8" NUMBER, 
	"CUSTOMER_REFERENCE8" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS8" NUMBER, 
	"INVOICE9" VARCHAR2(50 BYTE), 
	"INVOICE9_INSTALLMENT" NUMBER, 
	"MATCHING_DATE9" DATE, 
	"MATCHING_DATE_FORMAT9" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE9" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE9" NUMBER, 
	"AMOUNT_APPLIED9" NUMBER, 
	"AMOUNT_APPLIED_DISP9" NUMBER, 
	"AMOUNT_APPLIED_FROM9" NUMBER, 
	"CUSTOMER_REFERENCE9" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS9" NUMBER, 
	"INVOICE10" VARCHAR2(50 BYTE), 
	"INVOICE10_INSTALLMENT" NUMBER, 
	"MATCHING_DATE10" DATE, 
	"MATCHING_DATE_FORMAT10" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE10" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE10" NUMBER, 
	"AMOUNT_APPLIED10" NUMBER, 
	"AMOUNT_APPLIED_DISP10" NUMBER, 
	"AMOUNT_APPLIED_FROM10" NUMBER, 
	"CUSTOMER_REFERENCE10" VARCHAR2(100 BYTE), 
	"EXCHANGE_GAIN_LOSS10" NUMBER, 
	"INVOICE11" VARCHAR2(50 BYTE), 
	"INVOICE11_INSTALLMENT" NUMBER, 
	"MATCHING_DATE11" DATE, 
	"MATCHING_DATE_FORMAT11" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE11" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE11" NUMBER, 
	"AMOUNT_APPLIED11" NUMBER, 
	"AMOUNT_APPLIED_DISP11" NUMBER, 
	"AMOUNT_APPLIED_FROM11" NUMBER, 
	"CUSTOMER_REFERENCE11" VARCHAR2(110 BYTE), 
	"EXCHANGE_GAIN_LOSS11" NUMBER, 
	"INVOICE12" VARCHAR2(50 BYTE), 
	"INVOICE12_INSTALLMENT" NUMBER, 
	"MATCHING_DATE12" DATE, 
	"MATCHING_DATE_FORMAT12" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE12" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE12" NUMBER, 
	"AMOUNT_APPLIED12" NUMBER, 
	"AMOUNT_APPLIED_DISP12" NUMBER, 
	"AMOUNT_APPLIED_FROM12" NUMBER, 
	"CUSTOMER_REFERENCE12" VARCHAR2(120 BYTE), 
	"EXCHANGE_GAIN_LOSS12" NUMBER, 
	"INVOICE13" VARCHAR2(50 BYTE), 
	"INVOICE13_INSTALLMENT" NUMBER, 
	"MATCHING_DATE13" DATE, 
	"MATCHING_DATE_FORMAT13" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE13" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE13" NUMBER, 
	"AMOUNT_APPLIED13" NUMBER, 
	"AMOUNT_APPLIED_DISP13" NUMBER, 
	"AMOUNT_APPLIED_FROM13" NUMBER, 
	"CUSTOMER_REFERENCE13" VARCHAR2(130 BYTE), 
	"EXCHANGE_GAIN_LOSS13" NUMBER, 
	"INVOICE14" VARCHAR2(50 BYTE), 
	"INVOICE14_INSTALLMENT" NUMBER, 
	"MATCHING_DATE14" DATE, 
	"MATCHING_DATE_FORMAT14" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE14" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE14" NUMBER, 
	"AMOUNT_APPLIED14" NUMBER, 
	"AMOUNT_APPLIED_DISP14" NUMBER, 
	"AMOUNT_APPLIED_FROM14" NUMBER, 
	"CUSTOMER_REFERENCE14" VARCHAR2(140 BYTE), 
	"EXCHANGE_GAIN_LOSS14" NUMBER, 
	"INVOICE15" VARCHAR2(50 BYTE), 
	"INVOICE15_INSTALLMENT" NUMBER, 
	"MATCHING_DATE15" DATE, 
	"MATCHING_DATE_FORMAT15" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE15" VARCHAR2(15 BYTE), 
	"TRANS_TO_RECEIPT_RATE15" NUMBER, 
	"AMOUNT_APPLIED15" NUMBER, 
	"AMOUNT_APPLIED_DISP15" NUMBER, 
	"AMOUNT_APPLIED_FROM15" NUMBER, 
	"CUSTOMER_REFERENCE15" VARCHAR2(150 BYTE), 
	"EXCHANGE_GAIN_LOSS15" NUMBER, 
	"INVOICE16" VARCHAR2(50 BYTE), 
	"INVOICE16_INSTALLMENT" NUMBER, 
	"MATCHING_DATE16" DATE, 
	"MATCHING_DATE_FORMAT16" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE16" VARCHAR2(16 BYTE), 
	"TRANS_TO_RECEIPT_RATE16" NUMBER, 
	"AMOUNT_APPLIED16" NUMBER, 
	"AMOUNT_APPLIED_DISP16" NUMBER, 
	"AMOUNT_APPLIED_FROM16" NUMBER, 
	"CUSTOMER_REFERENCE16" VARCHAR2(160 BYTE), 
	"EXCHANGE_GAIN_LOSS16" NUMBER, 
	"INVOICE17" VARCHAR2(50 BYTE), 
	"INVOICE17_INSTALLMENT" NUMBER, 
	"MATCHING_DATE17" DATE, 
	"MATCHING_DATE_FORMAT17" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE17" VARCHAR2(17 BYTE), 
	"TRANS_TO_RECEIPT_RATE17" NUMBER, 
	"AMOUNT_APPLIED17" NUMBER, 
	"AMOUNT_APPLIED_DISP17" NUMBER, 
	"AMOUNT_APPLIED_FROM17" NUMBER, 
	"CUSTOMER_REFERENCE17" VARCHAR2(170 BYTE), 
	"EXCHANGE_GAIN_LOSS17" NUMBER, 
	"INVOICE18" VARCHAR2(50 BYTE), 
	"INVOICE18_INSTALLMENT" NUMBER, 
	"MATCHING_DATE18" DATE, 
	"MATCHING_DATE_FORMAT18" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE18" VARCHAR2(18 BYTE), 
	"TRANS_TO_RECEIPT_RATE18" NUMBER, 
	"AMOUNT_APPLIED18" NUMBER, 
	"AMOUNT_APPLIED_DISP18" NUMBER, 
	"AMOUNT_APPLIED_FROM18" NUMBER, 
	"CUSTOMER_REFERENCE18" VARCHAR2(180 BYTE), 
	"EXCHANGE_GAIN_LOSS18" NUMBER, 
	"INVOICE19" VARCHAR2(50 BYTE), 
	"INVOICE19_INSTALLMENT" NUMBER, 
	"MATCHING_DATE19" DATE, 
	"MATCHING_DATE_FORMAT19" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE19" VARCHAR2(19 BYTE), 
	"TRANS_TO_RECEIPT_RATE19" NUMBER, 
	"AMOUNT_APPLIED19" NUMBER, 
	"AMOUNT_APPLIED_DISP19" NUMBER, 
	"AMOUNT_APPLIED_FROM19" NUMBER, 
	"CUSTOMER_REFERENCE19" VARCHAR2(190 BYTE), 
	"EXCHANGE_GAIN_LOSS19" NUMBER, 
	"INVOICE20" VARCHAR2(50 BYTE), 
	"INVOICE20_INSTALLMENT" NUMBER, 
	"MATCHING_DATE20" DATE, 
	"MATCHING_DATE_FORMAT20" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE20" VARCHAR2(20 BYTE), 
	"TRANS_TO_RECEIPT_RATE20" NUMBER, 
	"AMOUNT_APPLIED20" NUMBER, 
	"AMOUNT_APPLIED_DISP20" NUMBER, 
	"AMOUNT_APPLIED_FROM20" NUMBER, 
	"CUSTOMER_REFERENCE20" VARCHAR2(200 BYTE), 
	"EXCHANGE_GAIN_LOSS20" NUMBER, 
	"INVOICE21" VARCHAR2(50 BYTE), 
	"INVOICE21_INSTALLMENT" NUMBER, 
	"MATCHING_DATE21" DATE, 
	"MATCHING_DATE_FORMAT21" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE21" VARCHAR2(21 BYTE), 
	"TRANS_TO_RECEIPT_RATE21" NUMBER, 
	"AMOUNT_APPLIED21" NUMBER, 
	"AMOUNT_APPLIED_DISP21" NUMBER, 
	"AMOUNT_APPLIED_FROM21" NUMBER, 
	"CUSTOMER_REFERENCE21" VARCHAR2(210 BYTE), 
	"EXCHANGE_GAIN_LOSS21" NUMBER, 
	"INVOICE22" VARCHAR2(50 BYTE), 
	"INVOICE22_INSTALLMENT" NUMBER, 
	"MATCHING_DATE22" DATE, 
	"MATCHING_DATE_FORMAT22" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE22" VARCHAR2(22 BYTE), 
	"TRANS_TO_RECEIPT_RATE22" NUMBER, 
	"AMOUNT_APPLIED22" NUMBER, 
	"AMOUNT_APPLIED_DISP22" NUMBER, 
	"AMOUNT_APPLIED_FROM22" NUMBER, 
	"CUSTOMER_REFERENCE22" VARCHAR2(220 BYTE), 
	"EXCHANGE_GAIN_LOSS22" NUMBER, 
	"INVOICE23" VARCHAR2(50 BYTE), 
	"INVOICE23_INSTALLMENT" NUMBER, 
	"MATCHING_DATE23" DATE, 
	"MATCHING_DATE_FORMAT23" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE23" VARCHAR2(23 BYTE), 
	"TRANS_TO_RECEIPT_RATE23" NUMBER, 
	"AMOUNT_APPLIED23" NUMBER, 
	"AMOUNT_APPLIED_DISP23" NUMBER, 
	"AMOUNT_APPLIED_FROM23" NUMBER, 
	"CUSTOMER_REFERENCE23" VARCHAR2(230 BYTE), 
	"EXCHANGE_GAIN_LOSS23" NUMBER, 
	"INVOICE24" VARCHAR2(50 BYTE), 
	"INVOICE24_INSTALLMENT" NUMBER, 
	"MATCHING_DATE24" DATE, 
	"MATCHING_DATE_FORMAT24" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE24" VARCHAR2(24 BYTE), 
	"TRANS_TO_RECEIPT_RATE24" NUMBER, 
	"AMOUNT_APPLIED24" NUMBER, 
	"AMOUNT_APPLIED_DISP24" NUMBER, 
	"AMOUNT_APPLIED_FROM24" NUMBER, 
	"CUSTOMER_REFERENCE24" VARCHAR2(240 BYTE), 
	"EXCHANGE_GAIN_LOSS24" NUMBER, 
	"INVOICE25" VARCHAR2(50 BYTE), 
	"INVOICE25_INSTALLMENT" NUMBER, 
	"MATCHING_DATE25" DATE, 
	"MATCHING_DATE_FORMAT25" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE25" VARCHAR2(25 BYTE), 
	"TRANS_TO_RECEIPT_RATE25" NUMBER, 
	"AMOUNT_APPLIED25" NUMBER, 
	"AMOUNT_APPLIED_DISP25" NUMBER, 
	"AMOUNT_APPLIED_FROM25" NUMBER, 
	"CUSTOMER_REFERENCE25" VARCHAR2(250 BYTE), 
	"EXCHANGE_GAIN_LOSS25" NUMBER, 
	"INVOICE26" VARCHAR2(50 BYTE), 
	"INVOICE26_INSTALLMENT" NUMBER, 
	"MATCHING_DATE26" DATE, 
	"MATCHING_DATE_FORMAT26" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE26" VARCHAR2(26 BYTE), 
	"TRANS_TO_RECEIPT_RATE26" NUMBER, 
	"AMOUNT_APPLIED26" NUMBER, 
	"AMOUNT_APPLIED_DISP26" NUMBER, 
	"AMOUNT_APPLIED_FROM26" NUMBER, 
	"CUSTOMER_REFERENCE26" VARCHAR2(260 BYTE), 
	"EXCHANGE_GAIN_LOSS26" NUMBER, 
	"INVOICE27" VARCHAR2(50 BYTE), 
	"MATCHING_DATE27" DATE, 
	"MATCHING_DATE_FORMAT27" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE27" VARCHAR2(27 BYTE), 
	"TRANS_TO_RECEIPT_RATE27" NUMBER, 
	"AMOUNT_APPLIED27" NUMBER, 
	"AMOUNT_APPLIED_DISP27" NUMBER, 
	"AMOUNT_APPLIED_FROM27" NUMBER, 
	"CUSTOMER_REFERENCE27" VARCHAR2(270 BYTE), 
	"EXCHANGE_GAIN_LOSS27" NUMBER, 
	"INVOICE28" VARCHAR2(50 BYTE), 
	"MATCHING_DATE28" DATE, 
	"MATCHING_DATE_FORMAT28" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE28" VARCHAR2(28 BYTE), 
	"TRANS_TO_RECEIPT_RATE28" NUMBER, 
	"AMOUNT_APPLIED28" NUMBER, 
	"AMOUNT_APPLIED_DISP28" NUMBER, 
	"AMOUNT_APPLIED_FROM28" NUMBER, 
	"CUSTOMER_REFERENCE28" VARCHAR2(280 BYTE), 
	"EXCHANGE_GAIN_LOSS28" NUMBER, 
	"INVOICE29" VARCHAR2(50 BYTE), 
	"MATCHING_DATE29" DATE, 
	"MATCHING_DATE_FORMAT29" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE29" VARCHAR2(29 BYTE), 
	"TRANS_TO_RECEIPT_RATE29" NUMBER, 
	"AMOUNT_APPLIED29" NUMBER, 
	"AMOUNT_APPLIED_DISP29" NUMBER, 
	"AMOUNT_APPLIED_FROM29" NUMBER, 
	"CUSTOMER_REFERENCE29" VARCHAR2(290 BYTE), 
	"EXCHANGE_GAIN_LOSS29" NUMBER, 
	"INVOICE30" VARCHAR2(50 BYTE), 
	"MATCHING_DATE30" DATE, 
	"MATCHING_DATE_FORMAT30" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE30" VARCHAR2(30 BYTE), 
	"TRANS_TO_RECEIPT_RATE30" NUMBER, 
	"AMOUNT_APPLIED30" NUMBER, 
	"AMOUNT_APPLIED_DISP30" NUMBER, 
	"AMOUNT_APPLIED_FROM30" NUMBER, 
	"CUSTOMER_REFERENCE30" VARCHAR2(300 BYTE), 
	"EXCHANGE_GAIN_LOSS30" NUMBER, 
	"INVOICE31" VARCHAR2(50 BYTE), 
	"MATCHING_DATE31" DATE, 
	"MATCHING_DATE_FORMAT31" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE31" VARCHAR2(31 BYTE), 
	"TRANS_TO_RECEIPT_RATE31" NUMBER, 
	"AMOUNT_APPLIED31" NUMBER, 
	"AMOUNT_APPLIED_DISP31" NUMBER, 
	"AMOUNT_APPLIED_FROM31" NUMBER, 
	"CUSTOMER_REFERENCE31" VARCHAR2(310 BYTE), 
	"EXCHANGE_GAIN_LOSS31" NUMBER, 
	"INVOICE32" VARCHAR2(50 BYTE), 
	"MATCHING_DATE32" DATE, 
	"MATCHING_DATE_FORMAT32" VARCHAR2(6 BYTE), 
	"INVOICE_CURRENCY_CODE32" VARCHAR2(32 BYTE), 
	"TRANS_TO_RECEIPT_RATE32" NUMBER, 
	"AMOUNT_APPLIED32" NUMBER, 
	"AMOUNT_APPLIED_DISP32" NUMBER, 
	"AMOUNT_APPLIED_FROM32" NUMBER, 
	"CUSTOMER_REFERENCE32" VARCHAR2(320 BYTE), 
	"EXCHANGE_GAIN_LOSS32" NUMBER, 
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
	"RECEIPT_AMOUNT_REMAINING" NUMBER, 
	"MIGRATED_RECEIPT_TYPE" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_XFM" ;