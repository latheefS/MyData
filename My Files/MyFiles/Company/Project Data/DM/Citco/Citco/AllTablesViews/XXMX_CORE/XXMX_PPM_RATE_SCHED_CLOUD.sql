--------------------------------------------------------
--  DDL for Table XXMX_PPM_RATE_SCHED_CLOUD
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_PPM_RATE_SCHED_CLOUD" 
   (	"RATE_SCHEDULE_NAME" VARCHAR2(50 BYTE), 
	"EXP_TYPE_NAME" VARCHAR2(50 BYTE), 
	"START_DATE_ACTIVE" VARCHAR2(50 BYTE), 
	"RATE_UNIT" VARCHAR2(50 BYTE), 
	"MARKUP_PERCENTAGE" NUMBER, 
	"JOB_NAME" VARCHAR2(50 BYTE), 
	"RATE" NUMBER, 
	"END_DATE_ACTIVE" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;