--------------------------------------------------------
--  DDL for Table XXMX_PO_AGENT_ACCESS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PO_AGENT_ACCESS" 
   (	"AGENT_NAME" VARCHAR2(120 BYTE), 
	"ENTERPRISE_ID" NUMBER, 
	"AGENT_EMAIL_ADDRESS" VARCHAR2(240 BYTE), 
	"BU_CODE" VARCHAR2(60 BYTE), 
	"ACCESS_ACTION_CODE" VARCHAR2(120 BYTE), 
	"ACCESS_ACTION_CODE_LEVEL" VARCHAR2(30 BYTE), 
	"ACTIVE_FLAG" VARCHAR2(1 BYTE), 
	"ALLOWED_FLAG" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;