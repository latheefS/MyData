
--------------------------------------------------------
--  DDL for Table XXMX_CUSTOMER_VALIDATION
--------------------------------------------------------

CREATE TABLE XXMX_CORE.XXMX_CUSTOMER_VALIDATION 
   (	
    VALIDATION_TYPE    VARCHAR2(200), 
	VALIDATION_VALUE   VARCHAR2(360), 
	STATUS             VARCHAR2(1), 
	ERROR_MESSAGE      VARCHAR2(4000), 
	LAST_UPDATE_DATE   TIMESTAMP (6)
   ) ;