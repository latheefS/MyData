--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  XXMX_HCM_LRN_EXT_TAB.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/STG
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This script installs the XXMX_STG DB Objects for the Maximise
--**              HCM Learning Data Migration.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    None
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  ------------------------------------------
--** [ 1.0  29-JUL-2021  Shaik Latheef  	 Created Learning External tables for Maximise.]
--**
--*************************************************************************************
--
--
PROMPT
PROMPT
PROMPT ********************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise Learning Data Migration
PROMPT **
PROMPT ********************************************************************
PROMPT
PROMPT
--
--
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
PROMPT
PROMPT
--
--

EXEC DropTable ('XXMX_OLC_COURSE_EXT')					
EXEC DropTable ('XXMX_OLC_LEARN_RCD_EXT')				
EXEC DropTable ('XXMX_OLC_OFFER_EXT')				
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--

-- ****************************
-- ** Learning Record Table
-- ****************************

  CREATE TABLE "XXMX_CORE"."XXMX_OLC_LEARN_RCD_EXT" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER, 
	"METADATA" VARCHAR2(150 BYTE), 
	"OBJECTNAME" VARCHAR2(150 BYTE), 
	"LEARN_RECORD_EFFECTIVE_START_DATE" VARCHAR2(20), 
	"LEARN_RECORD_EFFECTIVE_END_DATE"  VARCHAR2(20),
	"LEARNING_RECORD_NUMBER" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_NUMBER" VARCHAR2(30 BYTE), 
	"LEARNING_ITEM_TYPE" VARCHAR2(30 BYTE), 
	"LEARNING_ITEM_NUMBER" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_TYPE" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_SUB_TYPE" VARCHAR2(30 BYTE), 
	"ASSIGNED_BY_PERSON_NUMBER" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_ATTRIBUTION_TYPE" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_ATTRIBUTION_NUMBER" VARCHAR2(30 BYTE), 
	"ASSIGNMENT_ATTRIBUTION_CODE" VARCHAR2(30 BYTE), 
	"LEARNER_NUMBER" VARCHAR2(30 BYTE), 
	"LEARNING_RECORD_STATUS" VARCHAR2(32 BYTE), 
	"LEARNING_RECORD_START_DATE"  VARCHAR2(20)
	"LEARNING_RECORD_DUE_DATE"  VARCHAR2(20)
	"LEARNING_RECORD_WITHDRAWN_DATE"  VARCHAR2(20)
	"LEARNING_RECORD_DELETED_DATE"  VARCHAR2(20)
	"LEARNING_RECORD_COMPLETION_DATE"  VARCHAR2(20)
	"LEARNING_RECORD_VALID_FROM_DATE"  VARCHAR2(20)
	"LEARNING_REC_EXPIRY_DATE"  VARCHAR2(20)
	"LEARNING_REC_TOT_ACT_EFFORT" NUMBER(9,0), 
	"LEARNING_REC_TOT_ACT_EFFORT_UOM" VARCHAR2(30 BYTE), 
	"LEARNING_RECORD_REASON_CODE" VARCHAR2(30 BYTE), 
	"LEARNING_RECORD_COMMENTS" VARCHAR2(4000 BYTE), 
	"ACTUAL_SCORE" NUMBER(9,0), 
	"SOURCE_SYSTEM_OWNER" VARCHAR2(30 BYTE), 
	"SOURCE_SYSTEM_ID" VARCHAR2(2000 BYTE)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_OLC_LEARN_RCD_STG.log' fields terminated by "|" optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_OLC_LEARN_RCD_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

-- ****************************
-- ** Course  Table
-- ****************************
  CREATE TABLE "XXMX_CORE"."XXMX_OLC_COURSE_EXT" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_NAME" VARCHAR2(150 BYTE), 
	"MIGRATION_STATUS" VARCHAR2(50 BYTE), 
	"BG_NAME" VARCHAR2(240 BYTE), 
	"BG_ID" NUMBER, 
	"METADATA" VARCHAR2(150 BYTE), 
	"OBJECTNAME" VARCHAR2(150 BYTE), 
	"EFFECTIVE_START_DATE"  VARCHAR2(20)
	"EFFECTIVE_END_DATE"  VARCHAR2(20)
	"COURSE_NUMBER" VARCHAR2(30 BYTE), 
	"TITLE" VARCHAR2(250 BYTE), 
	"SHORT_DESCRIPTION" VARCHAR2(4000 BYTE), 
	"PUBLISH_START_DATE"  VARCHAR2(20)
	"PUBLISH_END_DATE"  VARCHAR2(20)
	"MINIMUM_EXPECTED_EFFORT" NUMBER, 
	"MAXIMUM_EXPECTED_EFFORT" NUMBER, 
	"OWNED_BY_PERSON_NUMBER" VARCHAR2(30 BYTE), 
	"SOURCE_SYSTEM_OWNER" VARCHAR2(30 BYTE), 
	"SOURCE_SYSTEM_ID" VARCHAR2(2000 BYTE)
   ) 
   ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_OLC_COURSE_STG.log' fields terminated by "|" optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_OLC_COURSE_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;

-- ****************************
-- ** Offering Table
-- ****************************
CREATE TABLE XXMX_CORE.XXMX_OLC_OFFER_EXT
   (
   	FILE_SET_ID							VARCHAR2(30),   
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	METADATA							VARCHAR2(150) ,
	OBJECTNAME							VARCHAR2(150) ,
	--
	OFFERING_ID							NUMBER,
	EFFECTIVE_START_DATE				 VARCHAR2(20),
	EFFECTIVE_END_DATE					VARCHAR2(20),
	OFFERING_NUMBER						VARCHAR2(30) 
	TITLE								VARCHAR2(250) 
	DESCRIPTION							CLOB,
	DESCRIPTION_TEXT					VARCHAR2(4000),
	OFFERING_TYPE						VARCHAR2(30) NOT NULL ENABLE,
	PUBLISH_START_DATE					VARCHAR2(20),
	PUBLISH_END_DATE					VARCHAR2(20),
	OFFERING_START_DATE					VARCHAR2(20),
	OFFERING_END_DATE					VARCHAR2(20),
	PRIMARY_LOCATION_ID					NUMBER,
	PRIMARY_LOCATION_NUMBER				VARCHAR2(30),
	LANGUAGE_CODE						VARCHAR2(30) NOT NULL ENABLE,
	FACILITATOR_TYPE					VARCHAR2(30),
	PRIMARY_INSTRUCTOR_ID				NUMBER,
	PRIMARY_INSTRUCTOR_NUMBER			VARCHAR2(30),
	TRAINING_SUPPLIER_ID				NUMBER,
	TRAINING_SUPPLIER_NUMBER			VARCHAR2(30),
	COORDINATOR_ID						NUMBER,
	COORDINATOR_NUMBER					VARCHAR2(30) NOT NULL ENABLE,
	ENABLE_CAPACITY						VARCHAR2(1),
	MINIMUM_CAPACITY					NUMBER,
	MAXIMUM_CAPACITY					NUMBER,
	ENABLE_WAITLIST						VARCHAR2(1),
	QUESTIONNAIRE_CODE					VARCHAR2(240),
	QSTNR_REQUIRED_FOR_COMPLETION		VARCHAR2(1),
	COURSE_ID							NUMBER,
	COURSE_NUMBER						VARCHAR2(30) NOT NULL ENABLE,
	OWNED_BY_PERSON_ID					NUMBER,
	OWNED_BY_PERSON_NUMBER				VARCHAR2(30) NOT NULL ENABLE,
	SOURCE_TYPE							VARCHAR2(30),
	SOURCE_ID							NUMBER,
	SOURCE_INFO							VARCHAR2(240),
	SOURCE_SYSTEM_OWNER   				VARCHAR2(256),
	SOURCE_SYSTEM_ID	  				VARCHAR2(2000),
	--
	ATTRIBUTE_CATEGORY 					VARCHAR2(30), 
	ATTRIBUTE1 							VARCHAR2(150), 
	ATTRIBUTE2 							VARCHAR2(150), 
	ATTRIBUTE3 							VARCHAR2(150), 
	ATTRIBUTE4 							VARCHAR2(150), 
	ATTRIBUTE5 							VARCHAR2(150), 
	ATTRIBUTE6 							VARCHAR2(150), 
	ATTRIBUTE7 							VARCHAR2(150), 
	ATTRIBUTE8 							VARCHAR2(150), 
	ATTRIBUTE9 							VARCHAR2(150), 
	ATTRIBUTE10 						VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					VARCHAR2(20), 
	ATTRIBUTE_DATE2 					VARCHAR2(20), 
	ATTRIBUTE_DATE3 					VARCHAR2(20), 
	ATTRIBUTE_DATE4 					VARCHAR2(20), 
	ATTRIBUTE_DATE5 					VARCHAR2(20)
   )ORGANIZATION EXTERNAL 
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "SOURCE_DATAFILE"
      ACCESS PARAMETERS
      ( records delimited by newline skip 1 logfile 'XXMX_OLC_OFFER_STG.log' fields terminated by "|" optionally enclosed by '"' missing field values are null )
      LOCATION
       ( 'XXMX_OLC_OFFER_STG.csv'
       )
    )
   REJECT LIMIT UNLIMITED 
  PARALLEL 5 ;


--
--
--
--
PROMPT
PROMPT
PROMPT **********************************
PROMPT **                                
PROMPT ** End of Database Object Creation
PROMPT **                                
PROMPT **********************************
PROMPT
PROMPT
--
--

