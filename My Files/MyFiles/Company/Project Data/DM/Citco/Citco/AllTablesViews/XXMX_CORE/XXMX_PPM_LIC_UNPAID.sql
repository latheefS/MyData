--------------------------------------------------------
--  DDL for Table XXMX_PPM_LIC_UNPAID
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_LIC_UNPAID" 
   (	"BUSINESS_UNIT" VARCHAR2(240 BYTE), 
	"INVOICEID" NUMBER(15,0), 
	"PROJECTID" NUMBER(15,0), 
	"TASKID" NUMBER(15,0), 
	"ORGID" NUMBER(15,0), 
	"INVOICE_NUMBER" VARCHAR2(50 BYTE), 
	"INVOICE_CURRENCY" VARCHAR2(15 BYTE), 
	"INVOICE_AMOUNT" NUMBER, 
	"INVOICE_DATE" DATE, 
	"INVOICE_TYPE" VARCHAR2(25 BYTE), 
	"DESCRIPTION" VARCHAR2(240 BYTE), 
	"PAYMENTMETHOD" VARCHAR2(25 BYTE), 
	"ACCOUNTINGDATE" DATE, 
	"CONVERSIONRATE" NUMBER, 
	"CONVERSIONRATETYPE" VARCHAR2(30 BYTE), 
	"CONVERSIONDATE" DATE, 
	"PAYGROUP" VARCHAR2(25 BYTE), 
	"SUPPLIER" VARCHAR2(240 BYTE), 
	"SUPPLIERSITE" VARCHAR2(15 BYTE), 
	"LINENUMBER" NUMBER, 
	"LINEDESCRIPTION" VARCHAR2(240 BYTE), 
	"TYPE" VARCHAR2(25 BYTE), 
	"TAXCLASSIFICATION" VARCHAR2(30 BYTE), 
	"TAXCONTROL" NUMBER, 
	"COST_TYPE" VARCHAR2(9 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
