--------------------------------------------------------
--  DDL for Table XXMX_ROLE_GROUP_VAL_TO_MIGRATE
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_ROLE_GROUP_VAL_TO_MIGRATE" 
   (	"APPLICATION_CODE" VARCHAR2(10 BYTE), 
	"SECURITY_CONTEXT" VARCHAR2(120 BYTE), 
	"GROUP_NAME" VARCHAR2(60 BYTE), 
	"SECURITY_CONTEXT_VALUE" VARCHAR2(120 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
