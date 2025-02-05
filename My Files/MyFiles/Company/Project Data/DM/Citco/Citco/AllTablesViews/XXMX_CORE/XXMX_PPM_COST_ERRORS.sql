--------------------------------------------------------
--  DDL for Table XXMX_PPM_COST_ERRORS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_COST_ERRORS" 
   (	"ORIG_TRANSACTION_REFERENCE" VARCHAR2(100 BYTE), 
	"PERSON_ID" VARCHAR2(100 BYTE), 
	"DOCUMENT_NAME" VARCHAR2(100 BYTE), 
	"DOC_ENTRY_NAME" VARCHAR2(100 BYTE), 
	"BATCH_NAME" VARCHAR2(100 BYTE), 
	"EXPENDITURE_ITEM_DATE" VARCHAR2(100 BYTE), 
	"MESSAGE_TEXT_2" VARCHAR2(4000 BYTE), 
	"PERSON_NUMBER" VARCHAR2(100 BYTE), 
	"PERSON_JOB_ID" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
