--------------------------------------------------------
--  DDL for Table XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"INTERFACE_BU_ASSIGNMENT_KEY" VARCHAR2(50 BYTE), 
	"INTERFACE_HEADER_KEY" VARCHAR2(50 BYTE), 
	"REQ_BU_NAME" VARCHAR2(240 BYTE), 
	"ORDERED_LOCALLY_FLAG" VARCHAR2(1 BYTE), 
	"VENDOR_SITE_CODE" VARCHAR2(15 BYTE), 
	"SHIP_TO_LOCATION" VARCHAR2(60 BYTE), 
	"BILL_TO_BU_NAME" VARCHAR2(240 BYTE), 
	"BILL_TO_LOCATION" VARCHAR2(60 BYTE), 
	"ENABLED" VARCHAR2(1 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT SELECT ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_SCM_PO_GA_ORG_ASSIGN_CPA_STG" TO "XXMX_CORE";