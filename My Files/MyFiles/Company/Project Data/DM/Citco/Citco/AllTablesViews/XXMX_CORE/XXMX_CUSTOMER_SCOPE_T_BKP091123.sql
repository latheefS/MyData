--------------------------------------------------------
--  DDL for Table XXMX_CUSTOMER_SCOPE_T_BKP091123
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_CUSTOMER_SCOPE_T_BKP091123" 
   (	"ORG_ID" NUMBER(15,0), 
	"OPERATING_UNIT_NAME" VARCHAR2(240 BYTE), 
	"CUST_ACCOUNT_ID" NUMBER(15,0), 
	"ACCOUNT_NUMBER" VARCHAR2(30 BYTE), 
	"ACCOUNT_PARTY_ID" NUMBER(15,0), 
	"CUST_ACCT_SITE_ID" NUMBER(15,0), 
	"PARTY_NAME" VARCHAR2(360 BYTE), 
	"PARTY_SITE_ID" NUMBER(15,0), 
	"PARTY_SITE_NUMBER" VARCHAR2(30 BYTE), 
	"PARTY_SITE_NAME" VARCHAR2(240 BYTE), 
	"LOCATION_ID" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;