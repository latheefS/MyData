--------------------------------------------------------
--  DDL for Table XXMX_AR_TRX_RECON_REP_DEV4
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_AR_TRX_RECON_REP_DEV4" 
   (	"BUSINESS_UNIT_NAME" VARCHAR2(250 BYTE), 
	"TRANSACTION_ENTERED_AMOUNT" VARCHAR2(250 BYTE), 
	"TRANSACTION_ACCOUNTED_AMOUNT" VARCHAR2(250 BYTE), 
	"DOCUMENT_CURRENCY" VARCHAR2(250 BYTE), 
	"LEDGER_CURRENCY" VARCHAR2(250 BYTE), 
	"CUSTOMER_TRANSACTION_REFERENCE" VARCHAR2(250 BYTE), 
	"INVOICE_STATUS" VARCHAR2(250 BYTE), 
	"ORIGINAL_TRANSACTION_NUMBER" VARCHAR2(250 BYTE), 
	"ORIGINAL_INVOICE_NUMBER" VARCHAR2(250 BYTE), 
	"TRANSACTION_NUMBER" VARCHAR2(250 BYTE), 
	"TRANSACTION_SOURCE" VARCHAR2(250 BYTE), 
	"TRANSACTION_STATUS" VARCHAR2(250 BYTE), 
	"TRANSACTION_DATE" DATE, 
	"TRANSACTION_TYPE_NAME" VARCHAR2(250 BYTE), 
	"ACCOUNTING_STATUS_CODE" VARCHAR2(250 BYTE), 
	"TRANSFER_STATUS" VARCHAR2(250 BYTE), 
	"ACCOUNTING_STATUS" VARCHAR2(250 BYTE), 
	"RECEIPT_METHOD" VARCHAR2(250 BYTE), 
	"CREATED_BY" VARCHAR2(250 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
