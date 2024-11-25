--------------------------------------------------------
--  DDL for Table XXMX_PPM_CONT_CUST_INT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_CONT_CUST_INT" 
   (	"PROJECT_ID" VARCHAR2(50 BYTE), 
	"PROJECT_NUMBER" VARCHAR2(50 BYTE), 
	"CUST_ID" VARCHAR2(50 BYTE), 
	"CUST_NAME" VARCHAR2(250 BYTE), 
	"CUST_ACCOUNT_NUMBER" VARCHAR2(50 BYTE), 
	"BILL_TO_ACCOUNT_ID" VARCHAR2(50 BYTE), 
	"BILL_TO_SITE_USE_ID" VARCHAR2(50 BYTE), 
	"SHIP_TO_ACCOUNT_ID" VARCHAR2(50 BYTE), 
	"SHIP_TO_SITE_USE_ID" VARCHAR2(50 BYTE), 
	"BILL_TO_ACCOUNT_NUMBER" VARCHAR2(50 BYTE), 
	"BILL_TO_SITE_USE_LOCATION" VARCHAR2(50 BYTE), 
	"SHIP_TO_ACCOUNT_NUMBER" VARCHAR2(50 BYTE), 
	"SHIP_TO_SITE_USE_LOCATION" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
