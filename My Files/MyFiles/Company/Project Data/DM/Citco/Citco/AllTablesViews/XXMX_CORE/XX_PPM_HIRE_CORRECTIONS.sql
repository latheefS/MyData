--------------------------------------------------------
--  DDL for Table XX_PPM_HIRE_CORRECTIONS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XX_PPM_HIRE_CORRECTIONS" 
   (	"PERSON_NUMBER" VARCHAR2(20 BYTE), 
	"EFFECTIVE_START_DATE" VARCHAR2(20 BYTE), 
	"EFFECTIVE_END_DATE" VARCHAR2(20 BYTE), 
	"ACTION_CODE" VARCHAR2(30 BYTE), 
	"POSITION_CODE" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;