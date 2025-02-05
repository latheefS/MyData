--------------------------------------------------------
--  DDL for Table XXMX_SCM_PO_HEADERS_STD_XFM_20231213
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_SCM_PO_HEADERS_STD_XFM_20231213" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"INTERFACE_HEADER_KEY" VARCHAR2(50 BYTE), 
	"ACTION" VARCHAR2(25 BYTE), 
	"BATCH_ID" NUMBER, 
	"INTERFACE_SOURCE_CODE" VARCHAR2(25 BYTE), 
	"APPROVAL_ACTION" VARCHAR2(25 BYTE), 
	"DOCUMENT_NUM" VARCHAR2(30 BYTE), 
	"DOCUMENT_TYPE_CODE" VARCHAR2(25 BYTE), 
	"STYLE_DISPLAY_NAME" VARCHAR2(240 BYTE), 
	"PRC_BU_NAME" VARCHAR2(240 BYTE), 
	"REQ_BU_NAME" VARCHAR2(240 BYTE), 
	"SOLDTO_LE_NAME" VARCHAR2(240 BYTE), 
	"BILLTO_BU_NAME" VARCHAR2(240 BYTE), 
	"AGENT_NAME" VARCHAR2(2000 BYTE), 
	"CURRENCY_CODE" VARCHAR2(15 BYTE), 
	"RATE" NUMBER, 
	"RATE_TYPE" VARCHAR2(30 BYTE), 
	"RATE_DATE" DATE, 
	"COMMENTS" VARCHAR2(240 BYTE), 
	"BILL_TO_LOCATION" VARCHAR2(60 BYTE), 
	"SHIP_TO_LOCATION" VARCHAR2(60 BYTE), 
	"VENDOR_NAME" VARCHAR2(360 BYTE), 
	"VENDOR_NUM" VARCHAR2(30 BYTE), 
	"VENDOR_SITE_CODE" VARCHAR2(15 BYTE), 
	"VENDOR_CONTACT" VARCHAR2(360 BYTE), 
	"VENDOR_DOC_NUM" VARCHAR2(25 BYTE), 
	"FOB" VARCHAR2(30 BYTE), 
	"FREIGHT_CARRIER" VARCHAR2(360 BYTE), 
	"FREIGHT_TERMS" VARCHAR2(30 BYTE), 
	"PAY_ON_CODE" VARCHAR2(25 BYTE), 
	"PAYMENT_TERMS" VARCHAR2(50 BYTE), 
	"ORIGINATOR_ROLE" VARCHAR2(25 BYTE), 
	"CHANGE_ORDER_DESC" VARCHAR2(2000 BYTE), 
	"ACCEPTANCE_REQUIRED_FLAG" VARCHAR2(1 BYTE), 
	"ACCEPTANCE_WITHIN_DAYS" NUMBER, 
	"SUPPLIER_NOTIF_METHOD" VARCHAR2(25 BYTE), 
	"FAX" VARCHAR2(60 BYTE), 
	"EMAIL_ADDRESS" VARCHAR2(2000 BYTE), 
	"CONFIRMING_ORDER_FLAG" VARCHAR2(1 BYTE), 
	"NOTE_TO_VENDOR" VARCHAR2(1000 BYTE), 
	"NOTE_TO_RECEIVER" VARCHAR2(1000 BYTE), 
	"DEFAULT_TAXATION_COUNTRY" VARCHAR2(2 BYTE), 
	"TAX_DOCUMENT_SUBTYPE" VARCHAR2(240 BYTE), 
	"ATTRIBUTE_CATEGORY" VARCHAR2(30 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE), 
	"ATTRIBUTE11" VARCHAR2(150 BYTE), 
	"ATTRIBUTE12" VARCHAR2(150 BYTE), 
	"ATTRIBUTE13" VARCHAR2(150 BYTE), 
	"ATTRIBUTE14" VARCHAR2(150 BYTE), 
	"ATTRIBUTE15" VARCHAR2(150 BYTE), 
	"ATTRIBUTE16" VARCHAR2(150 BYTE), 
	"ATTRIBUTE17" VARCHAR2(150 BYTE), 
	"ATTRIBUTE18" VARCHAR2(150 BYTE), 
	"ATTRIBUTE19" VARCHAR2(150 BYTE), 
	"ATTRIBUTE20" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_DATE1" DATE, 
	"ATTRIBUTE_DATE2" DATE, 
	"ATTRIBUTE_DATE3" DATE, 
	"ATTRIBUTE_DATE4" DATE, 
	"ATTRIBUTE_DATE5" DATE, 
	"ATTRIBUTE_DATE6" DATE, 
	"ATTRIBUTE_DATE7" DATE, 
	"ATTRIBUTE_DATE8" DATE, 
	"ATTRIBUTE_DATE9" DATE, 
	"ATTRIBUTE_DATE10" DATE, 
	"ATTRIBUTE_NUMBER1" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER2" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER3" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER4" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER5" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER6" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER7" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER8" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER9" NUMBER(18,0), 
	"ATTRIBUTE_NUMBER10" NUMBER(18,0), 
	"ATTRIBUTE_TIMESTAMP1" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP2" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP3" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP4" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP5" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP6" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP7" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP8" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP9" TIMESTAMP (6), 
	"ATTRIBUTE_TIMESTAMP10" TIMESTAMP (6), 
	"AGENT_EMAIL_ADDRESS" VARCHAR2(240 BYTE), 
	"MODE_OF_TRANSPORT" VARCHAR2(30 BYTE), 
	"SERVICE_LEVEL" VARCHAR2(80 BYTE), 
	"FIRST_PTY_REG_NUM" VARCHAR2(50 BYTE), 
	"THIRD_PTY_REG_NUM" VARCHAR2(50 BYTE), 
	"BUYER_MANAGED_TRANSPORT_FLAG" VARCHAR2(1 BYTE), 
	"MASTER_CONTRACT_NUMBER" VARCHAR2(120 BYTE), 
	"MASTER_CONTRACT_TYPE" VARCHAR2(150 BYTE), 
	"CC_EMAIL_ADDRESS" VARCHAR2(2000 BYTE), 
	"BCC_EMAIL_ADDRESS" VARCHAR2(2000 BYTE), 
	"PO_HEADER_ID" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
