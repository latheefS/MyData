--------------------------------------------------------
--  DDL for Table XXMX_MAPPING_SUP_BANK_18OCT
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_MAPPING_SUP_BANK_18OCT" 
   (	"SIMPLE_OR_COMPLEX" VARCHAR2(30 BYTE), 
	"APPLICATION_SUITE" VARCHAR2(30 BYTE), 
	"APPLICATION" VARCHAR2(30 BYTE), 
	"BUSINESS_ENTITY" VARCHAR2(30 BYTE), 
	"SUB_ENTITY" VARCHAR2(30 BYTE), 
	"CATEGORY_CODE" VARCHAR2(30 BYTE), 
	"INPUT_CODE_1" VARCHAR2(1000 BYTE), 
	"INPUT_CODE_2" VARCHAR2(1000 BYTE), 
	"INPUT_CODE_3" VARCHAR2(1000 BYTE), 
	"INPUT_CODE_4" VARCHAR2(1000 BYTE), 
	"INPUT_CODE_5" VARCHAR2(1000 BYTE), 
	"INPUT_CODE_6" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_1" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_1_DESC" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_2" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_2_DESC" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_3" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_3_DESC" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_4" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_4_DESC" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_5" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_5_DESC" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_6" VARCHAR2(1000 BYTE), 
	"OUTPUT_CODE_6_DESC" VARCHAR2(1000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
