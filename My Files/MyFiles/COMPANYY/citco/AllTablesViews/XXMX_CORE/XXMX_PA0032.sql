--------------------------------------------------------
--  DDL for Table XXMX_PA0032
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PA0032" 
   (	"PROJECT_ID" NUMBER(15,0), 
	"TASK_ID" NUMBER(15,0), 
	"PERIOD" CHAR(8 BYTE), 
	"PROJECT_NUMBER" VARCHAR2(30 BYTE), 
	"PROJECT_LONG_NAME" VARCHAR2(240 BYTE), 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"TASK_NUMBER" VARCHAR2(25 BYTE), 
	"ACCRUED_INCOME_LEDGER" NUMBER, 
	"DEFERRED_INCOME_LEDGER" NUMBER, 
	"BILLED_TO_DATE_TRANS" NUMBER, 
	"EARNED_TO_DATE_TRANS" NUMBER, 
	"ACCRUED_INCOME_TRANS" NUMBER, 
	"DEFERRED_INCOME_TRANS" NUMBER, 
	"REVAL_ACCRUED_INCOME_LEDGER" NUMBER, 
	"REVAL_DEFERRED_INCOME_LEDGER" NUMBER, 
	"LEDGER_CURRENCY_CODE" CHAR(20 BYTE), 
	"BILL_TRANS_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"TRANS_TO_LEDGER_RATE" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;