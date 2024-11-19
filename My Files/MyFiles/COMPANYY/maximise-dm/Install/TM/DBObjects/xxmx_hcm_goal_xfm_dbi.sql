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
--** FILENAME  :  xxmx_hcm_goal_XFM_dbi.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/XFM
--**
--** VERSION   :  1.1
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_XFM
--**
--** AUTHORS   :  Soundarya Kamatagi
--**
--** PURPOSE   :  This script installs the staging tables for the HCM 
--**              common Procedures and Functions packages.
--**
--** NOTES     :
--**
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
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
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
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
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
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  05-SEP-2023  Soundarya Kamatagi   Adding XFM script for Hcm Talent Management Goal]
--******************************************************************************
--**
--******************************************************************************
--
--
--
--
PROMPT
PROMPT
PROMPT *************************************************************
PROMPT **
PROMPT ** Installing Database Objects for Maximise HCM Data Migration
PROMPT **
PROMPT *************************************************************
PROMPT
PROMPT
--
--

--
--
PROMPT
PROMPT
PROMPT *********************
PROMPT ** Dropping Tables
PROMPT *********************
PROMPT
PROMPT
--
--
EXEC DropTable ('XXMX_HCM_GOAL_XFM')
EXEC DropTable ('XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM')
EXEC DropTable ('XXMX_HCM_GOAL_ACCESS_XFM')
EXEC DropTable ('XXMX_HCM_GOAL_ACTION_XFM')
EXEC DropTable ('XXMX_HCM_GOAL_ALIGNMENT_XFM')
EXEC DropTable ('XXMX_HCM_GOAL_PLAN_GOAL_XFM')
EXEC DropTable ('XXMX_HCM_GTARGET_OUTCOME_XFM')
EXEC DropTable ('XXMX_HCM_GOAL_MEASUREMENT_XFM')
--

--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_XFM
PROMPT
--
--
--
--
CREATE TABLE xxmx_XFM.XXMX_HCM_GOAL_XFM(
    FILE_SET_ID							          VARCHAR2(30),  
	MIGRATION_SET_ID					          NUMBER,
	MIGRATION_SET_NAME 					          VARCHAR2(150),
	MIGRATION_STATUS					              VARCHAR2(50),
	BG_NAME   							              VARCHAR2(240),
	BG_ID            					              NUMBER(15),
	BATCH_NAME							              VARCHAR2(300),
	METADATA							              VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							              VARCHAR2(150) DEFAULT 'Goal',
    GOAL_ID	                                          NUMBER(18) NOT NULL ENABLE,
    WORKER_ASSIGNMENT_NUMBER	                      VARCHAR2(50),
    ORGANIZATION_NAME	                              VARCHAR2(240),
    GOAL_NAME	                                      VARCHAR2(400) NOT NULL ENABLE,
    GOAL_TYPE_CODE						              VARCHAR2(30) NOT NULL ENABLE,
    GOAL_VERSION_TYPE_CODE				              VARCHAR2(30) NOT NULL ENABLE,
    WORKER_PERSON_NUMBER				              VARCHAR2(30),
    START_DATE							              DATE  NOT NULL ENABLE,
    TARGET_COMPLETION_DATE				              DATE,
    ACTIVE_FLAG							             VARCHAR2(30),
    ACTUAL_COMPLETION_DATE	   			              DATE,
    ALLOW_DELGOALFLAG	   				              VARCHAR2(30),
    ALLOW_KEY_ATTR_UPDATE_FLAG			              VARCHAR2(30),
    APPROVAL_STATUS_CODE					          VARCHAR2(30),
    ASSIGNED_BY_PERSON_ID					          NUMBER(18),
    ASSIGNMENT_ID					    			  NUMBER(18),
    CATEGORY_CODE					    			  VARCHAR2(30),
    COMMENTS_FILE                                    VARCHAR2(3000),
	PERCENT_COMPLETE_CODE	    			          VARCHAR2(30),
	DESCRIPTION							          VARCHAR2(4000),
	GOAL_EXT_ID							          VARCHAR2(250),
	GOAL_APPROVAL_STATE					          VARCHAR2(30),
	LEVEL_CODE							              VARCHAR2(30),
	REFERENCE_CONTENT_ITEM_ID	   			          NUMBER(18),
	REFERENCE_CONTENT_ITEM_NAME			          VARCHAR2(700),
	LONG_DESCRIPTION_FILE					          VARCHAR2(3000),
	MEASURE_CALC_RULE_CODE					          VARCHAR2(30),
	ORGANIZATION_ID	  							  NUMBER(18),
	ASSIGNED_BY_PERSON_NUMBER	  					  VARCHAR2(30),
	PERSON_ID										  NUMBER(18),
	PREVIOUS_STATE_GOAL_ID							  NUMBER(18),
	PREVIOUS_STATE_GOAL_NAME						  VARCHAR2(150),
	PREVIOUS_STATE_GOAL_ORGANIZATION_NAME			  VARCHAR2(240),
	PREVIOUS_STATE_GOAL_START_DATE					  DATE,
	PREVIOUS_STATE_GOAL_TARGET_COMPLETION_DATE		  DATE,
	PREVIOUS_STATE_GOAL_TYPE_CODE			          VARCHAR2(150),
	PREVIOUS_STATE_GOAL_VERSION_TYPE_CODE	          VARCHAR2(150),
	PREVIOUS_STATE_GOAL_WORKER_ASSIGNMENT_NUMBER	  VARCHAR2(30),
	PREVIOUS_STATE_GOAL_WORKER_PERSON_NUMBER		  VARCHAR2(30),
	PRIORITY_CODE							          VARCHAR2(30),
	PRIVATE_FLAG								      VARCHAR2(30) NOT NULL ENABLE,
	PUBLISH_DATE								      DATE,
	PUBLISHED_FLAG	  						          VARCHAR2(30),
	REFERENCE_GOAL_WORKER_ASSIGNMENT_NUMBER		  VARCHAR2(30),
	REFERENCE_GOAL_ID							       NUMBER(18),
	REFERENCE_GOAL_NAME						       VARCHAR2(150),
	REFERENCE_GOAL_ORGANIZATION_NAME			       VARCHAR2(240),
	REFERENCE_GOAL_WORKER_PERSON_NUMBER			   VARCHAR2(30),
	REFERENCE_GOAL_START_DATE					       DATE,
	REFERENCE_GOAL_TARGET_COMPLETION_DATE		       DATE,
    REFERENCE_GOAL_TYPE_CODE					       VARCHAR2(30),
    REFERENCE_GOAL_VERSION_TYPE_CODE			       VARCHAR2(30),
	GOAL_URL									       VARCHAR2(4000),
	REQUESTER_PERSON_ID							   NUMBER(18),
	REQUESTER_PERSON_NUMBER						   VARCHAR2(30),
	GOAL_SOURCE_CODE								   VARCHAR2(30) NOT NULL ENABLE,
	STATUS_CODE									   VARCHAR2(30),
	GOAL_SUB_TYPE_CODE								   VARCHAR2(30),
	SUCCESS_CRITERIA_FILE							   VARCHAR2(3000),
	SOURCE_SYSTEM_ID								   VARCHAR2(2000),
	SOURCE_SYSTEM_OWNER							   VARCHAR2(30),
	ATTRIBUTE_CATEGORY							       VARCHAR2(150),
	ATTRIBUTE1									       VARCHAR2(150),
	ATTRIBUTE2									       VARCHAR2(150),
	ATTRIBUTE3									       VARCHAR2(150),
	ATTRIBUTE4									       VARCHAR2(150),
	ATTRIBUTE5									       VARCHAR2(150),
	ATTRIBUTE6									       VARCHAR2(150),
	ATTRIBUTE7									       VARCHAR2(150),
	ATTRIBUTE8									       VARCHAR2(150),
	ATTRIBUTE9									       VARCHAR2(150),
	ATTRIBUTE10									   VARCHAR2(150),
	ATTRIBUTE11									   VARCHAR2(150),
	ATTRIBUTE12									   VARCHAR2(150),
	ATTRIBUTE13									   VARCHAR2(150),
	ATTRIBUTE14									   VARCHAR2(150),
	ATTRIBUTE15									   VARCHAR2(150),
	ATTRIBUTE_NUMBER1							       NUMBER,
	ATTRIBUTE_NUMBER2							       NUMBER,
	ATTRIBUTE_NUMBER3						           NUMBER,
	ATTRIBUTE_NUMBER4						           NUMBER,
	ATTRIBUTE_NUMBER5						           NUMBER,
	ATTRIBUTE_DATE1							       DATE,
	ATTRIBUTE_DATE2							       DATE,
	ATTRIBUTE_DATE3							       DATE,
	ATTRIBUTE_DATE4							       DATE,
	ATTRIBUTE_DATE5							       DATE
);
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM
PROMPT
--
--
CREATE TABLE XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM(
    FILE_SET_ID							          VARCHAR2(30)   
	,MIGRATION_SET_ID					              NUMBER
	,MIGRATION_SET_NAME 					          VARCHAR2(150)
	,MIGRATION_STATUS					              VARCHAR2(50)
	,BG_NAME   							              VARCHAR2(240)
	,BG_ID            					              NUMBER(15)
	,BATCH_NAME							              VARCHAR2(300)
	,METADATA							              VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							              VARCHAR2(150) DEFAULT 'GoalTargetOutcomeProfileItem'
	 --
	 ,PROFILE_ITEM_ID								   NUMBER(18)NOT NULL ENABLE
     ,GOAL_ID	 									   NUMBER(18)NOT NULL ENABLE
	 ,GOAL_NAME										   VARCHAR2(400)
     ,GOAL_ORGANIZATION_NAME						   VARCHAR2(240)
     ,GOAL_START_DATE	                               DATE
     ,GOAL_TARGET_COMPLETION_DATE	 				   DATE
     ,GOAL_TYPE_CODE	                               VARCHAR2(80)
     ,GOAL_VERSION_TYPE_CODE	                       VARCHAR2(80)
     ,GOAL_WORKER_ASSIGNMENT_NUMBER	                   VARCHAR2(80)
     ,GOAL_WORKER_PERSON_NUMBER						   VARCHAR2(30)
     ,CONTENT_ITEM										VARCHAR2(700)
     ,CONTENT_ITEM_ID									NUMBER(18)
     ,CONTENT_TYPE										VARCHAR2(240)
     ,CONTENT_TYPE_ID									NUMBER(18)NOT NULL ENABLE
     ,COUNTRY_COUNTRY_CODE	                            VARCHAR2(2)
     ,COUNTRY_GEOGRAPHY_CODE	                        VARCHAR2(30)
     ,COUNTRY_ID										NUMBER(18)
     ,DATE_FROM											DATE NOT NULL ENABLE
     ,DATE_TO											DATE
     ,IMPORTANCE										VARCHAR2(18)
     ,INTEREST_LEVEL									VARCHAR2(30)
     ,ITEM_DATE1										DATE
     ,ITEM_DATE10										DATE
     ,ITEM_DATE2									    DATE
     ,ITEM_DATE3									    DATE
     ,ITEM_DATE4									    DATE
     ,ITEM_DATE5									    DATE
     ,ITEM_DATE6									    DATE
     ,ITEM_DATE7									    DATE
     ,ITEM_DATE8									    DATE
     ,ITEM_DATE9									    DATE
     ,ITEM_DECIMAL1										NUMBER(15)
     ,ITEM_DECIMAL2										NUMBER(15)
     ,ITEM_DECIMAL3										NUMBER(15)
     ,ITEM_DECIMAL4										NUMBER(15)
     ,ITEM_DECIMAL5										NUMBER(15)
     ,ITEM_NUMBER1										NUMBER(18)
     ,ITEM_NUMBER10										NUMBER(18)
     ,ITEM_NUMBER2										NUMBER(18)
     ,ITEM_NUMBER3										NUMBER(18)
     ,ITEM_NUMBER4										NUMBER(18)
     ,ITEM_NUMBER5										NUMBER(18)
     ,ITEM_NUMBER6										NUMBER(18)
     ,ITEM_NUMBER7										NUMBER(18)
     ,ITEM_NUMBER8										NUMBER(18)
     ,ITEM_NUMBER9										NUMBER(18)
     ,ITEM_TEXT20001									VARCHAR2(2000)
     ,ITEM_TEXT20002									VARCHAR2(2000)
     ,ITEM_TEXT20003									VARCHAR2(2000)
     ,ITEM_TEXT20004									VARCHAR2(2000)
     ,ITEM_TEXT20005									VARCHAR2(2000)
     ,ITEM_TEXT2401										VARCHAR2(2000)
     ,ITEM_TEXT24010									VARCHAR2(240)
     ,ITEM_TEXT24011									VARCHAR2(240)
     ,ITEM_TEXT24012									VARCHAR2(240)
     ,ITEM_TEXT24013									VARCHAR2(240)
     ,ITEM_TEXT24014									VARCHAR2(240)
     ,ITEM_TEXT24015									VARCHAR2(240)
     ,ITEM_TEXT2402										VARCHAR2(240)
     ,ITEM_TEXT2403										VARCHAR2(240)
     ,ITEM_TEXT2404										VARCHAR2(240)
     ,ITEM_TEXT2405										VARCHAR2(240)
     ,ITEM_TEXT2406										VARCHAR2(240)
     ,ITEM_TEXT2407										VARCHAR2(240)
     ,ITEM_TEXT2408										VARCHAR2(240)
     ,ITEM_TEXT2409										VARCHAR2(240)
     ,ITEM_TEXT301										VARCHAR2(30)
     ,ITEM_TEXT3010										VARCHAR2(30)
     ,ITEM_TEXT3011										VARCHAR2(30)
     ,ITEM_TEXT3012										VARCHAR2(30)
     ,ITEM_TEXT3013										VARCHAR2(30)
     ,ITEM_TEXT3014										VARCHAR2(30)
     ,ITEM_TEXT3015										VARCHAR2(30)
     ,ITEM_TEXT302										VARCHAR2(30)
     ,ITEM_TEXT303										VARCHAR2(30)
     ,ITEM_TEXT304										VARCHAR2(30)
     ,ITEM_TEXT305										VARCHAR2(30)
     ,ITEM_TEXT306										VARCHAR2(30)
     ,ITEM_TEXT307										VARCHAR2(30)
     ,ITEM_TEXT308										VARCHAR2(30)
     ,ITEM_TEXT309										VARCHAR2(30)
     ,MANDATORY											VARCHAR2(30)
     ,PROFILE_CODE										VARCHAR2(30)
     ,PROFILE_ID										NUMBER(18)NOT NULL ENABLE
     ,QUALIFIER_CODE1									VARCHAR2(150)
     ,QUALIFIER_ID1										NUMBER(18)
     ,QUALIFIER_CODE2									VARCHAR2(30)
     ,QUALIFIER_ID2										NUMBER(18)
     ,QUALIFIER_SET_CODE1								VARCHAR2(150)
     ,QUALIFIER_SET_CODE2								VARCHAR2(150)
     ,RATING_LEVEL_CODE1								VARCHAR2(30)
     ,RATING_LEVEL_ID1									NUMBER(18)
     ,RATING_LEVEL_CODE2								VARCHAR2(30)
     ,RATING_LEVEL_ID2									NUMBER(18)
     ,RATING_LEVEL_CODE3								VARCHAR2(30)
     ,RATING_LEVEL_ID3									NUMBER(18)
     ,RATING_MODEL_CODE1								VARCHAR2(30)
     ,RATING_MODEL_ID1									NUMBER(18)
     ,RATING_MODEL_CODE2								VARCHAR2(30)
     ,RATING_MODEL_ID2									NUMBER(18)
     ,RATING_MODEL_CODE3								VARCHAR2(30)
     ,RATING_MODEL_ID3									NUMBER(18)
     ,SECTION_ID										NUMBER(18)
     ,SECTION_NAME										VARCHAR2(150)
     ,SOURCE_ID											NUMBER(18)
     ,SOURCE_KEY1										NUMBER(18)
     ,SOURCE_KEY2										NUMBER(18)
     ,SOURCE_KEY3										NUMBER(18)
     ,SOURCE_TYPE										VARCHAR2(30)
     ,STATE_COUNTRY_CODE								VARCHAR2(150)
     ,STATE_GEOGRAPHY_CODE								VARCHAR2(360)
     ,STATE_PROVINCE_ID									NUMBER(18)
     ,SOURCE_SYSTEM_ID									VARCHAR2(2000)
     ,SOURCE_SYSTEM_OWNER								VARCHAR2(30)
     ,ATTRIBUTE_CATEGORY								VARCHAR2(150)
     ,ATTRIBUTE1										VARCHAR2(150)
     ,ATTRIBUTE2										VARCHAR2(150)
     ,ATTRIBUTE3										VARCHAR2(150)
     ,ATTRIBUTE4										VARCHAR2(150)
     ,ATTRIBUTE5										VARCHAR2(150)
     ,ATTRIBUTE6										VARCHAR2(150)
     ,ATTRIBUTE7										VARCHAR2(150)
     ,ATTRIBUTE8										VARCHAR2(150)
     ,ATTRIBUTE9										VARCHAR2(150)
     ,ATTRIBUTE10										VARCHAR2(150)
     ,ATTRIBUTE11										VARCHAR2(150)
     ,ATTRIBUTE12										VARCHAR2(150)
     ,ATTRIBUTE13										VARCHAR2(150)
     ,ATTRIBUTE14										VARCHAR2(150)
     ,ATTRIBUTE15										VARCHAR2(150)
     ,ATTRIBUTE_NUMBER1									NUMBER
     ,ATTRIBUTE_NUMBER2									NUMBER
     ,ATTRIBUTE_NUMBER3									NUMBER
     ,ATTRIBUTE_NUMBER4									NUMBER
     ,ATTRIBUTE_NUMBER5									NUMBER
     ,ATTRIBUTE_DATE1									DATE
     ,ATTRIBUTE_DATE2									DATE
     ,ATTRIBUTE_DATE3									DATE
     ,ATTRIBUTE_DATE4									DATE
     ,ATTRIBUTE_DATE5									DATE
);

--
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_ACCESS_XFM
PROMPT
--

CREATE TABLE XXMX_HCM_GOAL_ACCESS_XFM(
    FILE_SET_ID							                VARCHAR2(30)   
	,MIGRATION_SET_ID					                NUMBER
	,MIGRATION_SET_NAME 					            VARCHAR2(150)
	,MIGRATION_STATUS					                VARCHAR2(50)
	,BG_NAME   							                VARCHAR2(240)
	,BG_ID            					                NUMBER(15)
	,BATCH_NAME							                VARCHAR2(300)
	,METADATA							                VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                VARCHAR2(150) DEFAULT 'GoalAccess' 
	--
	,GOAL_ACCESS_ID									    NUMBER(18)NOT NULL ENABLE
	,GOAL_ACCESS_PERSON_NUMBER						    VARCHAR2(30)
    ,GOAL_WORKER_ASSIGNMENT_NUMBER						VARCHAR2(50)
    ,GOAL_NAME	   								        VARCHAR2(400)
    ,GOAL_ORGANIZATION_NAME								VARCHAR2(240)
    ,GOAL_WORKER_PERSON_NUMBER							VARCHAR2(30)
    ,GOAL_START_DATE								    DATE
    ,GOAL_TARGET_COMPLETION_DATE						DATE
    ,GOAL_TYPE_CODE										VARCHAR2(30)
    ,GOAL_VERSION_TYPE_CODE								VARCHAR2(30)
    ,GOAL_ID											NUMBER(18)NOT NULL ENABLE
    ,PERSON_ID											NUMBER(18)NOT NULL ENABLE 
    ,GOAL_ACTION_ACCESS_FLAG							VARCHAR2(30)NOT NULL ENABLE
    ,SOURCE_SYSTEM_ID									VARCHAR2(2000)
    ,SOURCE_SYSTEM_OWNER								VARCHAR2(30)
    ,ATTRIBUTE_CATEGORY									VARCHAR2(150)
    ,ATTRIBUTE1	                                        VARCHAR2(150)
    ,ATTRIBUTE2	                                        VARCHAR2(150)
    ,ATTRIBUTE3	                                        VARCHAR2(150)
    ,ATTRIBUTE4	                                        VARCHAR2(150)
    ,ATTRIBUTE5	                                        VARCHAR2(150)
    ,ATTRIBUTE6	                                        VARCHAR2(150)
    ,ATTRIBUTE7	                                        VARCHAR2(150)
    ,ATTRIBUTE8	                                        VARCHAR2(150)
    ,ATTRIBUTE9	                                        VARCHAR2(150)
    ,ATTRIBUTE10	                                    VARCHAR2(150)
    ,ATTRIBUTE11	                                    VARCHAR2(150)
    ,ATTRIBUTE12	                                    VARCHAR2(150)
    ,ATTRIBUTE13	                                    VARCHAR2(150)
    ,ATTRIBUTE14	                                    VARCHAR2(150)
    ,ATTRIBUTE15	                                    VARCHAR2(150)
    ,ATTRIBUTE_NUMBER1	                                NUMBER
    ,ATTRIBUTE_NUMBER2	                                NUMBER
    ,ATTRIBUTE_NUMBER3	                                NUMBER
    ,ATTRIBUTE_NUMBER4	                                NUMBER
    ,ATTRIBUTE_NUMBER5	                                NUMBER
    ,ATTRIBUTE_DATE1	                                DATE
    ,ATTRIBUTE_DATE2	                                DATE
    ,ATTRIBUTE_DATE3	                                DATE
    ,ATTRIBUTE_DATE4	                                DATE
    ,ATTRIBUTE_DATE5	                                DATE
);
--
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_ACTION_XFM
PROMPT
--
--
CREATE TABLE XXMX_HCM_GOAL_ACTION_XFM
(
     FILE_SET_ID							            VARCHAR2(30)   
	,MIGRATION_SET_ID					                NUMBER
	,MIGRATION_SET_NAME 					            VARCHAR2(150)
	,MIGRATION_STATUS					                VARCHAR2(50)
	,BG_NAME   							                VARCHAR2(240)
	,BG_ID            					                NUMBER(15)
	,BATCH_NAME							                VARCHAR2(300)
	,METADATA							                VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                VARCHAR2(150) DEFAULT 'GoalAction' 
	--
   ,GOAL_ACTION_ID										NUMBER(18)NOT NULL ENABLE
   ,GOAL_WORKER_ASSIGNMENT_NUMBER	   						VARCHAR2(50)
   ,GOAL_NAME											VARCHAR2(400)
   ,GOAL_ORGANIZATION_NAME								VARCHAR2(240)
   ,GOAL_WORKER_PERSON_NUMBER								VARCHAR2(30)
   ,GOAL_START_DATE										DATE
   ,GOAL_TARGET_COMPLETION_DATE							DATE
   ,GOAL_TYPE_CODE										VARCHAR2(30)
   ,GOAL_VERSION_TYPE_CODE									VARCHAR2(30)
   ,ACTION_NAME											VARCHAR2(240)NOT NULL ENABLE
   ,START_DATE											DATE
   ,ACTION_TYPE_CODE										VARCHAR2(30)NOT NULL ENABLE
   ,GOAL_ID												NUMBER(18)NOT NULL ENABLE
   ,COMMENTS											VARCHAR2(4000)
   ,PERCENT_COMPLETE_CODE									VARCHAR2(30)
   ,PRIORITY_CODE										VARCHAR2(30)
   ,ACTION_URL											VARCHAR2(4000)
   ,STATUS_CODE											VARCHAR2(30)
   ,TARGET_COMPLETION_DATE								DATE
   ,SOURCE_SYSTEM_ID										VARCHAR2(2000)
   , SOURCE_SYSTEM_OWNER									VARCHAR2(30)
   ,ATTRIBUTE_CATEGORY									VARCHAR2(150)
   ,ATTRIBUTE1											VARCHAR2(150)
   ,ATTRIBUTE2											VARCHAR2(150)
   ,ATTRIBUTE3											VARCHAR2(150)
   ,ATTRIBUTE4											VARCHAR2(150)
   ,ATTRIBUTE5											VARCHAR2(150)
   ,ATTRIBUTE6											VARCHAR2(150)
   ,ATTRIBUTE7											VARCHAR2(150)
   ,ATTRIBUTE8											VARCHAR2(150)
   ,ATTRIBUTE9											VARCHAR2(150)
   ,ATTRIBUTE10											VARCHAR2(150)
   ,ATTRIBUTE11											VARCHAR2(150)
   ,ATTRIBUTE12											VARCHAR2(150)
   ,ATTRIBUTE13											VARCHAR2(150)
   ,ATTRIBUTE14											VARCHAR2(150)
   ,ATTRIBUTE15											VARCHAR2(150)
   ,ATTRIBUTE_NUMBER1	                                NUMBER
   ,ATTRIBUTE_NUMBER2	                                NUMBER
   ,ATTRIBUTE_NUMBER3	                                NUMBER
   ,ATTRIBUTE_NUMBER4	                                NUMBER
   ,ATTRIBUTE_NUMBER5	                                NUMBER
   ,ATTRIBUTE_DATE1	                                    DATE
   ,ATTRIBUTE_DATE2	                                    DATE
   ,ATTRIBUTE_DATE3	                                    DATE
   ,ATTRIBUTE_DATE4	                                    DATE
   ,ATTRIBUTE_DATE5	                                    DATE
);
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_ALIGNMENT_XFM
PROMPT
--
--
CREATE TABLE XXMX_HCM_GOAL_ALIGNMENT_XFM(
     FILE_SET_ID							            VARCHAR2(30)   
	,MIGRATION_SET_ID					                NUMBER
	,MIGRATION_SET_NAME 					            VARCHAR2(150)
	,MIGRATION_STATUS					                VARCHAR2(50)
	,BG_NAME   							                VARCHAR2(240)
	,BG_ID            					                NUMBER(15)
	,BATCH_NAME							                VARCHAR2(300)
	,METADATA							                VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                VARCHAR2(150) DEFAULT 'GoalAlignment' 
	--
	,GOAL_ALIGNMENT_ID									NUMBER (18)NOT NULL ENABLE
   ,GOAL_WORKER_ASSIGNMENT_NUMBER							VARCHAR2(50)
   ,GOAL_NAME											VARCHAR2(400)
   ,GOAL_ORGANIZATION_NAME	                            VARCHAR2(240)
   ,GOAL_WORKER_PERSON_NUMBER	                            VARCHAR2(30)
   ,GOAL_START_DATE										DATE
   ,GOAL_TARGET_COMPLETION_DATE							DATE
   ,GOAL_TYPE_CODE										VARCHAR2(30)
   ,GOAL_VERSION_TYPE_CODE									VARCHAR2(30)
   ,GOAL_ID												NUMBER (18)
   ,ALIGNED_GOAL_ID										NUMBER (18)NOT NULL ENABLE
   ,ALIGNED_GOAL_WORKER_PERSON_NUMBER						VARCHAR2(30)
   ,ALIGNED_GOAL_WORKER_ASSIGNMENT_NUMBER					VARCHAR2(30)
   ,ALIGNED_GOAL_NAME										VARCHAR2(150)
   ,ALIGNED_GOAL_ORGANIZATION_NAME							VARCHAR2(240)
   ,ALIGNED_GOAL_START_DATE								DATE
   ,ALIGNED_GOAL_TARGET_COMPLETION_DATE						DATE
   ,ALIGNED_GOAL_TYPE_CODE									VARCHAR2(30)
   ,ALIGNED_GOAL_VERSION_TYPE_CODE							VARCHAR2(30)
   ,SOURCE_SYSTEM_ID										VARCHAR2(2000)
   ,SOURCE_SYSTEM_OWNER									VARCHAR2(30)
   ,ATTRIBUTE_CATEGORY									VARCHAR2(150)
   ,ATTRIBUTE1											VARCHAR2(150)
   ,ATTRIBUTE2											VARCHAR2(150)
   ,ATTRIBUTE3											VARCHAR2(150)
   ,ATTRIBUTE4											VARCHAR2(150)
   ,ATTRIBUTE5											VARCHAR2(150)
   ,ATTRIBUTE6											VARCHAR2(150)
   ,ATTRIBUTE7											VARCHAR2(150)
   ,ATTRIBUTE8											VARCHAR2(150)
   ,ATTRIBUTE9											VARCHAR2(150)
   ,ATTRIBUTE10											VARCHAR2(150)
   ,ATTRIBUTE11											VARCHAR2(150)
   ,ATTRIBUTE12											VARCHAR2(150)
   ,ATTRIBUTE13											VARCHAR2(150)
   ,ATTRIBUTE14											VARCHAR2(150)
   ,ATTRIBUTE15											VARCHAR2(150)
   ,ATTRIBUTE_NUMBER1	                                NUMBER
   ,ATTRIBUTE_NUMBER2	                                NUMBER
   ,ATTRIBUTE_NUMBER3	                                NUMBER
   ,ATTRIBUTE_NUMBER4	                                NUMBER
   ,ATTRIBUTE_NUMBER5	                                NUMBER
   ,ATTRIBUTE_DATE1	                                    DATE
   ,ATTRIBUTE_DATE2	                                    DATE
   ,ATTRIBUTE_DATE3	                                    DATE
   ,ATTRIBUTE_DATE4	                                    DATE
   ,ATTRIBUTE_DATE5	                                    DATE
);
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_PLAN_GOAL_XFM
PROMPT
--
--
CREATE TABLE XXMX_HCM_GOAL_PLAN_GOAL_XFM
(
     FILE_SET_ID							            	VARCHAR2(30)   
	,MIGRATION_SET_ID					                	NUMBER
	,MIGRATION_SET_NAME 					            	VARCHAR2(150)
	,MIGRATION_STATUS					                	VARCHAR2(50)
	,BG_NAME   							                	VARCHAR2(240)
	,BG_ID            					                	NUMBER(15)
	,BATCH_NAME							                	VARCHAR2(300)
	,METADATA							                	VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	VARCHAR2(150) DEFAULT 'GoalPlanGoal' 
	--
   ,GOAL_PLAN_GOAL_ID										    NUMBER (18)NOT NULL ENABLE
   ,GOAL_PLAN_END_DATE											DATE
   ,GOAL_WORKER_ASSIGNMENT_NUMBER								VARCHAR2(50)
   ,GOAL_NAME												VARCHAR2(400)
   ,GOAL_ORGANIZATION_NAME									VARCHAR2(240)
   ,GOAL_WORKER_PERSON_NUMBER									VARCHAR2(30)
   ,GOAL_PLAN_EXTERNAL_ID										VARCHAR2(250)
   ,GOAL_PLAN_NAME											VARCHAR2(400)
   ,GOAL_START_DATE											DATE
   ,GOAL_TARGET_COMPLETION_DATE								DATE
   ,GOAL_TYPE_CODE											VARCHAR2(30)
   ,GOAL_VERSION_TYPE_CODE										VARCHAR2(30)
   ,GOAL_PLAN_START_DATE										DATE
   ,GOAL_ID												    NUMBER (18)NOT NULL ENABLE
   ,ASSIGNMENT_ID											NUMBER (18)
   ,GOAL_PLAN_ID												NUMBER (18)NOT NULL ENABLE
   ,GOAL_PLAN_SET_EXTERNAL_ID									VARCHAR2(250)
   ,GOAL_PLAN_SET_ID											NUMBER (18)
   ,PRIORITY_CODE											VARCHAR2(30)
   ,REVIEW_PERIOD_ID											NUMBER (18)
   ,REVIEW_PERIOD_NAME	  									VARCHAR2(400)
   ,WEIGHTING												NUMBER (5)
   ,SOURCE_SYSTEM_ID											VARCHAR2(2000)
   ,SOURCE_SYSTEM_OWNER										VARCHAR2(30)
   ,ATTRIBUTE_CATEGORY										VARCHAR2(150)
   ,ATTRIBUTE1												VARCHAR2(150)
   ,ATTRIBUTE2												VARCHAR2(150)
   ,ATTRIBUTE3												VARCHAR2(150)
   ,ATTRIBUTE4												VARCHAR2(150)
   ,ATTRIBUTE5												VARCHAR2(150)
   ,ATTRIBUTE6												VARCHAR2(150)
   ,ATTRIBUTE7												VARCHAR2(150)
   ,ATTRIBUTE8												VARCHAR2(150)
   ,ATTRIBUTE9												VARCHAR2(150)
   ,ATTRIBUTE10												VARCHAR2(150)
   ,ATTRIBUTE11												VARCHAR2(150)
   ,ATTRIBUTE12												VARCHAR2(150)
   ,ATTRIBUTE13												VARCHAR2(150)
   ,ATTRIBUTE14												VARCHAR2(150)
   ,ATTRIBUTE15												VARCHAR2(150)
   ,ATTRIBUTE_NUMBER1										NUMBER
   ,ATTRIBUTE_NUMBER2										NUMBER
   ,ATTRIBUTE_NUMBER3										NUMBER
   ,ATTRIBUTE_NUMBER4										NUMBER
   ,ATTRIBUTE_NUMBER5										NUMBER
   ,ATTRIBUTE_DATE1											DATE
   ,ATTRIBUTE_DATE2											DATE
   ,ATTRIBUTE_DATE3											DATE
   ,ATTRIBUTE_DATE4											DATE
   ,ATTRIBUTE_DATE5											DATE
);
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GTARGET_OUTCOME_XFM
PROMPT
--
--
CREATE TABLE XXMX_HCM_GTARGET_OUTCOME_XFM
(
     FILE_SET_ID							            	    VARCHAR2(30)   
	,MIGRATION_SET_ID					                	    NUMBER
	,MIGRATION_SET_NAME 					            	    VARCHAR2(150)
	,MIGRATION_STATUS					                	    VARCHAR2(50)
	,BG_NAME   							                	    VARCHAR2(240)
	,BG_ID            					                	    NUMBER(15)
	,BATCH_NAME							                	    VARCHAR2(300)
	,METADATA							                	    VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	    VARCHAR2(150) DEFAULT 'GoalTargetOutcome' 
	--
   ,GOAL_TARGET_OUTCOME_ID										    NUMBER (18)NOT NULL ENABLE   
   ,CONTENT_ITEM_NAME												VARCHAR2(700)
   ,CONTENT_TYPE_CONTEXT_NAME										VARCHAR2(240)
   ,GOAL_WORKER_ASSIGNMENT_NUMBER									VARCHAR2(50)
   ,GOAL_NAME													VARCHAR2(400)
   ,GOAL_ORGANIZATION_NAME										VARCHAR2(240)
   ,GOAL_WORKER_PERSON_NUMBER	 									VARCHAR2(30)
   ,GOAL_START_DATE											    DATE
   ,GOAL_TARGET_COMPLETION_DATE									DATE
   ,GOAL_TYPE_CODE												VARCHAR2(30)
   ,GOAL_VERSION_TYPE_CODE										    VARCHAR2(30)
   ,GOAL_ID													    NUMBER (18)NOT NULL ENABLE         
   ,COMMENTS													VARCHAR2(4000)
   ,CONTENT_ITEM_ID												NUMBER (18)NOT NULL ENABLE  
   ,CONTENT_ITEM_TYPE_ID											NUMBER (18)
   ,APPROVED_RATING_CODE											VARCHAR2(30)
   ,APPROVED_RATING_ID											NUMBER (18)
   ,CONTENT_SOURCE_CODE											VARCHAR2(30)
   ,TARGET_RATING_LEVEL_CODE3										VARCHAR2(30)
   ,TARGET_RATING_LEVEL_ID3										NUMBER (18)         
   ,TARGET_RATING_LEVEL_CODE										VARCHAR2(30)
   ,TARGET_RATING_LEVEL_ID											NUMBER (18)         
   ,TARGET_RATING_LEVEL_CODE2										VARCHAR2(30)
   ,TARGET_RATING_LEVEL_ID2										NUMBER (18)         
   ,SOURCE_SYSTEM_ID												VARCHAR2(2000)       
   ,SOURCE_SYSTEM_OWNER											VARCHAR2(30)
   ,ATTRIBUTE_CATEGORY       	                                VARCHAR2(30)  
   ,ATTRIBUTE1               	                                VARCHAR2(150) 
   ,ATTRIBUTE2               	                                VARCHAR2(150) 
   ,ATTRIBUTE3               	                                VARCHAR2(150) 
   ,ATTRIBUTE4               	                                VARCHAR2(150) 
   ,ATTRIBUTE5               	                                VARCHAR2(150) 
   ,ATTRIBUTE6               	                                VARCHAR2(150) 
   ,ATTRIBUTE7               	                                VARCHAR2(150) 
   ,ATTRIBUTE8               	                                VARCHAR2(150) 
   ,ATTRIBUTE9               	                                VARCHAR2(150) 
   ,ATTRIBUTE10               	                                VARCHAR2(150) 
   ,ATTRIBUTE11             	                                VARCHAR2(150) 
   ,ATTRIBUTE12             	                                VARCHAR2(150) 
   ,ATTRIBUTE13             	                                VARCHAR2(150) 
   ,ATTRIBUTE14             	                                VARCHAR2(150) 
   ,ATTRIBUTE15             	                                VARCHAR2(150) 
   ,ATTRIBUTE_NUMBER1	                                        NUMBER
   ,ATTRIBUTE_NUMBER2	                                        NUMBER
   ,ATTRIBUTE_NUMBER3	                                        NUMBER
   ,ATTRIBUTE_NUMBER4	                                        NUMBER
   ,ATTRIBUTE_NUMBER5	                                        NUMBER
   ,ATTRIBUTE_DATE1	                                            DATE
   ,ATTRIBUTE_DATE2	                                            DATE
   ,ATTRIBUTE_DATE3	                                            DATE
   ,ATTRIBUTE_DATE4	                                            DATE
   ,ATTRIBUTE_DATE5	                                            DATE
);
--
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GOAL_MEASUREMENT_XFM
PROMPT
--
--

CREATE TABLE XXMX_HCM_GOAL_MEASUREMENT_XFM
(
     FILE_SET_ID							            	    VARCHAR2(30)   
	,MIGRATION_SET_ID					                	    NUMBER
	,MIGRATION_SET_NAME 					            	    VARCHAR2(150)
	,MIGRATION_STATUS					                	    VARCHAR2(50)
	,BG_NAME   							                	    VARCHAR2(240)
	,BG_ID            					                	    NUMBER(15)
	,BATCH_NAME							                	    VARCHAR2(300)
	,METADATA							                	    VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	    VARCHAR2(150) DEFAULT 'GoalMeasurement' 
	--
	,MEASUREMENT_ID	 											NUMBER (18)NOT NULL ENABLE
    ,GOAL_WORKER_ASSIGNMENT_NUMBER									VARCHAR2(50)
    ,GOAL_NAME													VARCHAR2(400)
    ,GOAL_ORGANIZATIONNAME										VARCHAR2(240)
    ,GOAL_WORKER_PERSON_NUMBER										VARCHAR2(30)
    ,GOAL_START_DATE												DATE
    ,GOAL_TARGET_COMPLETION_DATE									DATE
    ,GOAL_TYPE_CODE												VARCHAR2(30)
    ,GOAL_VERSION_TYPE_CODE											VARCHAR2(30)
    ,MEASUREMENT_NAME												VARCHAR2(400)NOT NULL ENABLE
    ,GOAL_ID	 													NUMBER (18)NOT NULL ENABLE
    ,ACHIEVED_WEIGHT											    NUMBER (18)
    ,ACTUAL_VALUE	 												NUMBER (18)
    ,END_DATE														DATE
    ,MAX_TARGET													NUMBER (18)
    ,COMMENTS													VARCHAR2(4000)
    ,MIN_TARGET													NUMBER (18)
    ,MEASURE_TYPE_CODE												VARCHAR2(30)
    ,DISPLAY_SEQUENCE												NUMBER (9)
    ,START_DATE													DATE
    ,TARGET_PERCENTAGE											NUMBER (18)
    ,TARGET_TYPE													VARCHAR2(30)
    ,TARGET_VALUE													NUMBER (18)
    ,UOM_CODE														VARCHAR2(30)
    ,SOURCE_SYSTEM_ID												VARCHAR2(2000)
    ,SOURCE_SYSTEM_OWNER 											VARCHAR2(30)
    ,ATTRIBUTE_CATEGORY											VARCHAR2(150)
    ,ATTRIBUTE1													VARCHAR2(150)
    ,ATTRIBUTE2													VARCHAR2(150)
    ,ATTRIBUTE3													VARCHAR2(150)
    ,ATTRIBUTE4													VARCHAR2(150)
    ,ATTRIBUTE5													VARCHAR2(150)
    ,ATTRIBUTE6													VARCHAR2(150)
    ,ATTRIBUTE7													VARCHAR2(150)
    ,ATTRIBUTE8													VARCHAR2(150)
    ,ATTRIBUTE9													VARCHAR2(150)
    ,ATTRIBUTE10													VARCHAR2(150)
    ,ATTRIBUTE11													VARCHAR2(150)
    ,ATTRIBUTE12													VARCHAR2(150)
    ,ATTRIBUTE13													VARCHAR2(150)
    ,ATTRIBUTE14													VARCHAR2(150)
    ,ATTRIBUTE15													VARCHAR2(150)
    ,ATTRIBUTE_NUMBER1											NUMBER
    ,ATTRIBUTE_NUMBER2											NUMBER
    ,ATTRIBUTE_NUMBER3											NUMBER
    ,ATTRIBUTE_NUMBER4											NUMBER
    ,ATTRIBUTE_NUMBER5											NUMBER
    ,ATTRIBUTE_DATE1												DATE
    ,ATTRIBUTE_DATE2												DATE
    ,ATTRIBUTE_DATE3												DATE
    ,ATTRIBUTE_DATE4												DATE
    ,ATTRIBUTE_DATE5												DATE
);


--------------------------
---SYNONYMS AND GRANTS
--------------------------

--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** CREATE OR REPLACE SYNONYM
PROMPT ***********************
--
--



CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_XFM for XXMX_HCM_GOAL_XFM;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM for XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_ACCESS_XFM for XXMX_HCM_GOAL_ACCESS_XFM;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_ACTION_XFM for XXMX_HCM_GOAL_ACTION_XFM;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_ALIGNMENT_XFM for XXMX_HCM_GOAL_ALIGNMENT_XFM;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_PLAN_GOAL_XFM for XXMX_HCM_GOAL_PLAN_GOAL_XFM ;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GTARGET_OUTCOME_XFM for XXMX_HCM_GTARGET_OUTCOME_XFM ;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GOAL_MEASUREMENT_XFM for XXMX_HCM_GOAL_MEASUREMENT_XFM ;


--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--
GRANT ALL ON XXMX_HCM_GOAL_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GTARGT_OUTCME_PFILE_ITM_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GOAL_ACCESS_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GOAL_ACTION_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_HCM_GOAL_ALIGNMENT_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GOAL_PLAN_GOAL_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GTARGET_OUTCOME_XFM TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GOAL_MEASUREMENT_XFM TO XXMX_CORE; 

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

