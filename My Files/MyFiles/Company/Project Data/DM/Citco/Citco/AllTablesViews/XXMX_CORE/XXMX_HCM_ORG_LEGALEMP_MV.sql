--------------------------------------------------------
--  DDL for Table XXMX_HCM_ORG_LEGALEMP_MV
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_HCM_ORG_LEGALEMP_MV" 
   (	"LEGAL_ENTITY_ID" NUMBER(15,0), 
	"LE_NAME" VARCHAR2(240 BYTE), 
	"ORG_NAME" VARCHAR2(240 BYTE), 
	"ORGANIZATION_ID" NUMBER(15,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" ;

   COMMENT ON TABLE "XXMX_CORE"."XXMX_HCM_ORG_LEGALEMP_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_HCM_ORG_LEGALEMP_MV';
  GRANT SELECT ON "XXMX_CORE"."XXMX_HCM_ORG_LEGALEMP_MV" TO "XXMX_READONLY";
