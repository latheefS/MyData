--------------------------------------------------------
--  DDL for Table XXMX_PA_CLOUD_TEMPLATES
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PA_CLOUD_TEMPLATES" 
   (	"NAME" VARCHAR2(1000 BYTE), 
	"SEGMENT1" VARCHAR2(1000 BYTE), 
	"BUSINESS_UNIT" VARCHAR2(1000 BYTE), 
	"PROJECT_UNIT" VARCHAR2(1000 BYTE), 
	"ORGANIZATION" VARCHAR2(1000 BYTE), 
	" LEGAL_ENTITY" VARCHAR2(1000 BYTE), 
	"PROJECT_TYPE" VARCHAR2(1000 BYTE), 
	"TASK_NUMBER" VARCHAR2(1000 BYTE), 
	"TASK_NAME" VARCHAR2(2000 BYTE), 
	"DESCRIPTION" VARCHAR2(2000 BYTE), 
	"BILLABLE_FLAG" VARCHAR2(1 BYTE), 
	"CHARGEABLE_FLAG" VARCHAR2(1 BYTE), 
	"EBS_BILLABLE_FLAG" VARCHAR2(1 BYTE), 
	"EBS_CHARGEABLE_FLAG" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
