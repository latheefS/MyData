--------------------------------------------------------
--  DDL for Table XXMX_AP_SUPP_ADDRS_XFM_BKP_050923
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_AP_SUPP_ADDRS_XFM_BKP_050923" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" VARCHAR2(100 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"LOCATION_ID" NUMBER, 
	"SUPPLIER_SITE_ID" NUMBER, 
	"PARTY_SITE_ID" NUMBER, 
	"IMPORT_ACTION" VARCHAR2(10 BYTE), 
	"SUPPLIER_NAME" VARCHAR2(360 BYTE), 
	"ADDRESS_NAME" VARCHAR2(240 BYTE), 
	"ADDRESS_NAME_NEW" VARCHAR2(240 BYTE), 
	"COUNTRY" VARCHAR2(60 BYTE), 
	"ADDRESS1" VARCHAR2(240 BYTE), 
	"ADDRESS2" VARCHAR2(240 BYTE), 
	"ADDRESS3" VARCHAR2(240 BYTE), 
	"ADDRESS4" VARCHAR2(240 BYTE), 
	"PHONETIC_ADDRESS_LINE" VARCHAR2(560 BYTE), 
	"ADDRESS_ELEMENT_ATTRIBUTE_1" VARCHAR2(150 BYTE), 
	"ADDRESS_ELEMENT_ATTRIBUTE_2" VARCHAR2(150 BYTE), 
	"ADDRESS_ELEMENT_ATTRIBUTE_3" VARCHAR2(150 BYTE), 
	"ADDRESS_ELEMENT_ATTRIBUTE_4" VARCHAR2(150 BYTE), 
	"ADDRESS_ELEMENT_ATTRIBUTE_5" VARCHAR2(150 BYTE), 
	"BUILDING" VARCHAR2(240 BYTE), 
	"FLOOR_NUMBER" VARCHAR2(40 BYTE), 
	"CITY" VARCHAR2(60 BYTE), 
	"STATE" VARCHAR2(60 BYTE), 
	"PROVINCE" VARCHAR2(60 BYTE), 
	"COUNTY" VARCHAR2(60 BYTE), 
	"POSTAL_CODE" VARCHAR2(60 BYTE), 
	"POSTAL_PLUS_4_CODE" VARCHAR2(10 BYTE), 
	"ADDRESSEE" VARCHAR2(360 BYTE), 
	"GLOBAL_LOCATION_NUMBER" VARCHAR2(40 BYTE), 
	"LANGUAGE" VARCHAR2(4 BYTE), 
	"INACTIVE_DATE" DATE, 
	"PHONE_COUNTRY_CODE" VARCHAR2(10 BYTE), 
	"PHONE_AREA_CODE" VARCHAR2(10 BYTE), 
	"PHONE" VARCHAR2(40 BYTE), 
	"PHONE_EXTENSION" VARCHAR2(20 BYTE), 
	"FAX_COUNTRY_CODE" VARCHAR2(10 BYTE), 
	"FAX_AREA_CODE" VARCHAR2(10 BYTE), 
	"FAX" VARCHAR2(15 BYTE), 
	"RFQ_OR_BIDDING" VARCHAR2(1 BYTE), 
	"ORDERING" VARCHAR2(1 BYTE), 
	"PAY" VARCHAR2(1 BYTE), 
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
	"ATTRIBUTE21" VARCHAR2(150 BYTE), 
	"ATTRIBUTE22" VARCHAR2(150 BYTE), 
	"ATTRIBUTE23" VARCHAR2(150 BYTE), 
	"ATTRIBUTE24" VARCHAR2(150 BYTE), 
	"ATTRIBUTE25" VARCHAR2(150 BYTE), 
	"ATTRIBUTE26" VARCHAR2(150 BYTE), 
	"ATTRIBUTE27" VARCHAR2(150 BYTE), 
	"ATTRIBUTE28" VARCHAR2(150 BYTE), 
	"ATTRIBUTE29" VARCHAR2(150 BYTE), 
	"ATTRIBUTE30" VARCHAR2(150 BYTE), 
	"ATTRIBUTE_NUMBER1" NUMBER, 
	"ATTRIBUTE_NUMBER2" NUMBER, 
	"ATTRIBUTE_NUMBER3" NUMBER, 
	"ATTRIBUTE_NUMBER4" NUMBER, 
	"ATTRIBUTE_NUMBER5" NUMBER, 
	"ATTRIBUTE_NUMBER6" NUMBER, 
	"ATTRIBUTE_NUMBER7" NUMBER, 
	"ATTRIBUTE_NUMBER8" NUMBER, 
	"ATTRIBUTE_NUMBER9" NUMBER, 
	"ATTRIBUTE_NUMBER10" NUMBER, 
	"ATTRIBUTE_NUMBER11" NUMBER, 
	"ATTRIBUTE_NUMBER12" NUMBER, 
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
	"ATTRIBUTE_DATE11" DATE, 
	"ATTRIBUTE_DATE12" DATE, 
	"EMAIL_ADDRESS" VARCHAR2(320 BYTE), 
	"DELIVERY_CHANNEL" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION_1" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION_2" VARCHAR2(30 BYTE), 
	"BANK_INSTRUCTION" VARCHAR2(30 BYTE), 
	"SETTLEMENT_PRIORITY" VARCHAR2(30 BYTE), 
	"PAYMENT_TEXT_MESSAGE_1" VARCHAR2(150 BYTE), 
	"PAYMENT_TEXT_MESSAGE_2" VARCHAR2(150 BYTE), 
	"PAYMENT_TEXT_MESSAGE_3" VARCHAR2(150 BYTE), 
	"PAYEE_SERVICE_LEVEL" VARCHAR2(30 BYTE), 
	"PAY_EACH_DOCUMENT_ALONE" VARCHAR2(1 BYTE), 
	"BANK_CHARGE_BEARER" VARCHAR2(30 BYTE), 
	"PAYMENT_REASON" VARCHAR2(30 BYTE), 
	"PAYMENT_REASON_COMMENTS" VARCHAR2(240 BYTE), 
	"DELIVERY_METHOD" VARCHAR2(30 BYTE), 
	"REMITTANCE_E_MAIL" VARCHAR2(255 BYTE), 
	"REMITTANCE_FAX" VARCHAR2(15 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;