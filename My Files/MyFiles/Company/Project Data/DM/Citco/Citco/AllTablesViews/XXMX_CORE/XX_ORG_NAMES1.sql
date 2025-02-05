--------------------------------------------------------
--  DDL for Table XX_ORG_NAMES1
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XX_ORG_NAMES1" 
   (	"ORG_NAME" VARCHAR2(1000 BYTE), 
	"FUSION_ORG" VARCHAR2(1000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
