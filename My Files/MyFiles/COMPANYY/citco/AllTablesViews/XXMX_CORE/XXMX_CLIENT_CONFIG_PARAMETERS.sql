--------------------------------------------------------
--  DDL for Table XXMX_CLIENT_CONFIG_PARAMETERS
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_CLIENT_CONFIG_PARAMETERS" 
   (	"CLIENT_CODE" VARCHAR2(10 BYTE), 
	"CONFIG_PARAMETER" VARCHAR2(100 BYTE), 
	"CONFIG_VALUE" VARCHAR2(100 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;
  GRANT SELECT ON "XXMX_CORE"."XXMX_CLIENT_CONFIG_PARAMETERS" TO "XXMX_READONLY";