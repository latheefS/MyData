--------------------------------------------------------
--  DDL for Table XXMX_PPM_UNBIL_TEST_TAB
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_UNBIL_TEST_TAB" 
   (	"SOURCEREF" VARCHAR2(25 BYTE), 
	"ORGANIZATION_NAME" VARCHAR2(240 BYTE), 
	"EVENT_TYPE_NAME" VARCHAR2(30 BYTE), 
	"EVENT_DESC" VARCHAR2(240 BYTE), 
	"COMPLETION_DATE" DATE, 
	"BILL_TRNS_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"BILL_TRNS_AMOUNT" NUMBER, 
	"PROJECT_NUMBER" VARCHAR2(25 BYTE), 
	"TASK_NUMBER" VARCHAR2(25 BYTE), 
	"BILL_HOLD_FLAG" VARCHAR2(1 BYTE), 
	"REVENUE_HOLD_FLAG" VARCHAR2(1 BYTE), 
	"ATTRIBUTE1" VARCHAR2(80 BYTE), 
	"ATTRIBUTE2" VARCHAR2(80 BYTE), 
	"ATTRIBUTE3" VARCHAR2(40 BYTE), 
	"ATTRIBUTE4" VARCHAR2(40 BYTE), 
	"ATTRIBUTE7" CHAR(8 BYTE), 
	"ATTRIBUTE10" CHAR(7 BYTE), 
	"PROJECT_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJECT_BILL_AMOUNT" NUMBER, 
	"PROJFUNC_CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"PROJFUNC_BILL_AMOUNT" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
