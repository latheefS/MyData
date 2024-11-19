     --
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     ** FILENAME  :  xxmx_oic_table_dbi.sql
     **
     ** FILEPATH  :
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Dhanu
     **
     ** PURPOSE   : This script creates the package which performs all Dynamic SQL
     **             processing for Maximise.
     **
     ** NOTES     :
     **
     ******************************************************************************
          ** [previous_filename] HISTORY
     ** -----------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxmx_utilities_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-JAN-2022  Dhanu                 Created for Maximise.
     **
     ******************************************************************************
     */
     
--PROMPT
--PROMPT ***********************************
--PROMPT  DROPPING TABLES 
--PROMPT ***********************************
--PROMPT
     
EXEC DropTable('XXMX_DM_FUSION_DAS'); 

EXEC DropTable('XXMX_DM_STG_XFM_DATA'); 

EXEC DropTable('XXMX_DM_STG_XFM_HEADER');

EXEC DropTable('XXMX_DM_ASSET_BOOKS_IN_SCOPE');

EXEC DropTable('XXMX_DM_ESS_JOB_DEFINITIONS');

EXEC DropTable('XXMX_FUSION_BUSINESS_UNITS');

EXEC DropTable('XXMX_MAPPING_MASTER');

EXEC DropTable('XXMX_DM_SUBENTITY_FILE_MAP');

EXEC DropTable ('XXMX_DM_OIC_READ_LOG');


--PROMPT
--PROMPT ***********************************
--PROMPT  CREATING TABLES 
--PROMPT ***********************************
--PROMPT

CREATE TABLE XXMX_CORE.XXMX_DM_SUBENTITY_FILE_MAP
(   
APPLICATION_SUITE       	VARCHAR2(100),
APPLICATION             	VARCHAR2(100),
BUSINESS_ENTITY         	VARCHAR2(100),
SUB_ENTITY              	VARCHAR2(100),
FILE_TYPE               	VARCHAR2(100),
FILE_EXTENSION          	VARCHAR2(100),
FILE_NAME               	VARCHAR2(100),
EXCEL_FILE_HEADER       	CLOB
);


CREATE TABLE XXMX_CORE.XXMX_DM_FUSION_DAS
( "ACCESS_SET_ID" 			VARCHAR2(100 BYTE),
"DAS_NAME" 					VARCHAR2(100 BYTE),
"ACCESS_PRIVILEGE_CODE" 	VARCHAR2(100 BYTE),
"LEDGER_ID" 				VARCHAR2(100 BYTE),
"LEDGER_NAME" 				VARCHAR2(100 BYTE),
"BU_NAME" 					VARCHAR2(100 BYTE),
"BU_ID" 					VARCHAR2(100 BYTE),
"CURRENCY_CODE" 			VARCHAR2(100 BYTE),
"PERIOD_NAME" 				VARCHAR2(100 BYTE)
);



CREATE TABLE XXMX_DM_STG_XFM_DATA
(
	TABLE_NAME 				VARCHAR2(50),
	TABLE_DATA   			VARCHAR2(4000)
);


CREATE TABLE  XXMX_DM_STG_XFM_HEADER
(
table_name 					VARCHAR2(50),
header_text 				LONG 
);



CREATE TABLE XXMX_CORE.XXMX_DM_ASSET_BOOKS_IN_SCOPE
( "BOOK_TYPE_CODE" 			VARCHAR2(30 BYTE)
);




CREATE TABLE XXMX_CORE.XXMX_DM_ESS_JOB_DEFINITIONS
( "ITERATION" 				VARCHAR2(100 BYTE),
"IMPORTPROCESSNAME" 		VARCHAR2(100 BYTE),
"LOAD_NAME" 				VARCHAR2(100 BYTE),
"JOB_PACKAGE" 				VARCHAR2(100 BYTE),
"JOB_DEFINITION" 			VARCHAR2(100 BYTE),
"PARAM_COUNT" 				NUMBER,
"PARAMETER1" 				VARCHAR2(100 BYTE),
"PARAMETER2" 				VARCHAR2(100 BYTE),
"PARAMETER3" 				VARCHAR2(100 BYTE),
"PARAMETER4" 				VARCHAR2(100 BYTE),
"PARAMETER5" 				VARCHAR2(100 BYTE),
"PARAMETER6" 				VARCHAR2(100 BYTE),
"PARAMETER7" 				VARCHAR2(100 BYTE),
"PARAMETER8" 				VARCHAR2(100 BYTE),
"PARAMETER9" 				VARCHAR2(100 BYTE),
"PARAMETER10" 				VARCHAR2(100 BYTE),
"PARAMETER11" 				VARCHAR2(100 BYTE),
"PARAMETER12" 				VARCHAR2(100 BYTE),
"PARAMETER13" 				VARCHAR2(100 BYTE),
"PARAMETER14" 				VARCHAR2(100 BYTE),
"PARAMETER15" 				VARCHAR2(100 BYTE),
"PARAMETER16" 				VARCHAR2(100 BYTE),
"PARAMETER17" 				VARCHAR2(100 BYTE),
"PARAMETER18" 				VARCHAR2(100 BYTE),
"PARAMETER19" 				VARCHAR2(100 BYTE),
"PARAMETER20" 				VARCHAR2(100 BYTE),
"PARAMETER21" 				VARCHAR2(100 BYTE),
"PARAMETER22" 				VARCHAR2(100 BYTE),
"PARAMETER23" 				VARCHAR2(100 BYTE),
"PARAMETER24" 				VARCHAR2(100 BYTE)
);


CREATE TABLE XXMX_CORE.XXMX_FUSION_BUSINESS_UNITS
( "BU_ID" 					NUMBER,
"BU_NAME" 					VARCHAR2(250 BYTE)
);

CREATE TABLE XXMX_CORE.XXMX_MAPPING_MASTER 
 (
    SIMPLE_OR_COMPLEX	 	VARCHAR2(30 BYTE), 
    APPLICATION_SUITE	 	VARCHAR2(30 BYTE), 
    APPLICATION     		VARCHAR2(30 BYTE), 
    BUSINESS_ENTITY 		VARCHAR2(30 BYTE),     
    SUB_ENTITY 				VARCHAR2(30 BYTE),     
    CATEGORY_CODE 			VARCHAR2(30 BYTE), 	
	INPUT_CODE_1 			VARCHAR2(1000 BYTE), 
	INPUT_CODE_2 			VARCHAR2(1000 BYTE), 
	INPUT_CODE_3 			VARCHAR2(1000 BYTE), 
	INPUT_CODE_4 			VARCHAR2(1000 BYTE), 
	INPUT_CODE_5 			VARCHAR2(1000 BYTE), 
	INPUT_CODE_6 			VARCHAR2(1000 BYTE), 	 
	OUTPUT_CODE_1 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_1_DESC 		VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_2 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_2_DESC 		VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_3 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_3_DESC 		VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_4 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_4_DESC 		VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_5 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_5_DESC 		VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_6 			VARCHAR2(1000 BYTE), 
	OUTPUT_CODE_6_DESC 		VARCHAR2(1000 BYTE)
);

CREATE TABLE XXMX_DM_OIC_READ_LOG
(
   INSTANCE_ID           	NUMBER,       
   USER_NAME                VARCHAR2(250),
   INTEGRATION_NAME         VARCHAR2(250),
   INTEGRATION_IDENTIFIER   VARCHAR2(250),
   INTEGRATION_VERSION      VARCHAR2(250),
   START_TIME               VARCHAR2(250),
   END_TIME                 VARCHAR2(250),
   DURATION_MINS            NUMBER(10,2),
   PARAMETER1               VARCHAR2(250),
   PARAMETER2               VARCHAR2(250),
   PARAMETER3               VARCHAR2(250),
   PARAMETER4               VARCHAR2(250),
   PARAMETER5               VARCHAR2(250) 
);
 
--PROMPT
--PROMPT ***********************************
--PROMPT  Completed Table Creation for OIC 
--PROMPT ***********************************
--PROMPT 

