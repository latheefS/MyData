
  CREATE TABLE XXMX_CORE.XXMX_BUSINESS_UNITS 
   (	BU_NAME VARCHAR2(240 BYTE) NOT NULL ENABLE, 
	STATUS VARCHAR2(10 BYTE), 
	CONFIGURATION_STATUS VARCHAR2(240 BYTE), 
	FROM_DATE VARCHAR2(240 BYTE), 
	TO_DATE VARCHAR2(240 BYTE), 
	 CONSTRAINT XXMX_BUSINESS_UNITS_PK PRIMARY KEY (BU_NAME)
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE USERS  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE USERS ;
