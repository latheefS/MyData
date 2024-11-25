--------------------------------------------------------
--  DDL for Table XXMX_CLOSED_AR_PRJ_DI_EVT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_CLOSED_AR_PRJ_DI_EVT" 
   (	"PROJECT_NUMBER" VARCHAR2(25 BYTE), 
	"TASK_NUMBER" VARCHAR2(25 BYTE), 
	"EVENT_ID" NUMBER, 
	"EVENT_TYPE" VARCHAR2(30 BYTE), 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"BILL_TRANS_BILL_AMOUNT" NUMBER, 
	"BILL_TRANS_REV_AMOUNT" NUMBER, 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJFUNC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJFUNC_REV_EXCHANGE_RATE" NUMBER, 
	"PROJFUNC_INV_RATE_DATE" DATE, 
	"PROJFUNC_BILL_AMOUNT" NUMBER, 
	"PROJFUNC_REVENUE_AMOUNT" NUMBER, 
	"EVENT_NUM" NUMBER(15,0), 
	"INV_AMOUNT" NUMBER, 
	"LINE_NUM" NUMBER(15,0), 
	"INVOICE_DATE" DATE, 
	"BILL_GROUP" VARCHAR2(40 BYTE), 
	"INVOICE_AR_NUMBER" VARCHAR2(20 BYTE), 
	"COMPLETION_DATE" DATE, 
	"BILLED_FLAG" VARCHAR2(1 BYTE), 
	"AR_INVOICE_STATUS" CHAR(9 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
