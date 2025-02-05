--------------------------------------------------------
--  DDL for Table XXMX_GL_FUSION_SEG_DEFAULTS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_GL_FUSION_SEG_DEFAULTS" 
   (	"FUSION_LEDGER_NAME" VARCHAR2(30 BYTE), 
	"FUSION_SEGMENT_COLUMN" VARCHAR2(30 BYTE), 
	"FUSION_SEGMENT_DEFAULT_VALUE" VARCHAR2(25 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_GL_FUSION_SEG_DEFAULTS" TO "XXMX_READONLY";
