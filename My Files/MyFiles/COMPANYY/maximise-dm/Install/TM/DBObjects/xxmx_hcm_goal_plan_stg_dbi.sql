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
--** FILENAME  :  xxmx_hcm_goal_plan_stg_dbi.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/STG
--**
--** VERSION   :  1.1
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
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
--** [ 1.0  05-SEP-2023  Soundarya Kamatagi   Adding stg script for Hcm Talent Management Goal plan]
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
EXEC DropTable ('XXMX_HCM_GPLAN_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_ASGN_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_DTYPE_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_GP_GOALS_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_MASS_REQ_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_EO_PROF_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_MR_ASGN_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_MR_HIER_STG')
EXEC DropTable ('XXMX_HCM_GPLAN_MR_EXEM_STG')
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPLAN_STG
PROMPT
--
--
--
--
CREATE TABLE XXMX_HCM_GPLAN_STG
   (
   	 FILE_SET_ID							          VARCHAR2(30)   
	,MIGRATION_SET_ID					              NUMBER
	,MIGRATION_SET_NAME 					          VARCHAR2(150)
	,MIGRATION_STATUS					              VARCHAR2(50)
	,BG_NAME   							              VARCHAR2(240)
	,BG_ID            					              NUMBER(15)
	,BATCH_NAME							              VARCHAR2(300)
	,METADATA							              VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							              VARCHAR2(150) DEFAULT 'GoalPlan'
    --
   ,GOAL_PLAN_ACTIVE_FLAG							  VARCHAR2(30)
   ,ENABLE_WEIGHTING_FLAG								  VARCHAR2(30)
   ,END_DATE											  DATE
   ,ENFORCE_GOAL_WEIGHT_FLAG							  VARCHAR2(30)
   ,GOAL_ACCESS_LEVEL_CODE								  VARCHAR2(30)
   ,GOAL_SUB_TYPE_CODE	                                  VARCHAR2(30)
   ,GOAL_PLAN_NAME	                                  VARCHAR2(400) 
   ,GOAL_PLAN_ID										  NUMBER (18)
   ,GOAL_PLAN_EXTERNAL_ID	                              VARCHAR2(250)
   ,GOAL_PLAN_TYPE_CODE	                              VARCHAR2(30)
   ,INCLUDE_IN_PERFDOC_FLAG							  VARCHAR2(30)
   ,START_DATE	 									  DATE
   ,SOURCE_SYSTEM_OWNER								  VARCHAR2(30)
   ,SOURCE_SYSTEM_ID									  VARCHAR2(2000)
   ,REQ_SUBMITTED_BY_PERSON_NUMBER	                      VARCHAR2(30)
   ,REQUEST_SUBMISSION_DATE	                          DATE
   ,REQ_SUBMITTED_BY_PERSON_ID	                          NUMBER (18)
   ,REVIEW_PERIOD_ID									  NUMBER (18)
   ,REVIEW_PERIOD_NAME								  VARCHAR2(400)
   ,DESCRIPTION	                                      VARCHAR2(4000)
   ,ALL_DEPARTMENTS_FLAG								  VARCHAR2(30)
   ,EVALUATION_TYPE								      VARCHAR2(30)
   ,MAX_GOALS_NUMIN_GOAL_PLAN	                         NUMBER (18)
   ,ALLOW_PVT_GOAL_MAX_GOAL_FLAG	                          VARCHAR2(30)
   ,ENFORCE_MAX_GOAL_SINGP_FLAG	                          VARCHAR2(30)
   ,ATTRIBUTE_CATEGORY								  VARCHAR2(150)
   ,ATTRIBUTE1	   									  VARCHAR2(150)
   ,ATTRIBUTE2	                                      VARCHAR2(150)
   ,ATTRIBUTE3	                                      VARCHAR2(150)
   ,ATTRIBUTE4	                                      VARCHAR2(150)
   ,ATTRIBUTE5	                                      VARCHAR2(150)
   ,ATTRIBUTE6	                                      VARCHAR2(150)
   ,ATTRIBUTE7	                                      VARCHAR2(150)
   ,ATTRIBUTE8	                                      VARCHAR2(150)
   ,ATTRITBUTE9	                                      VARCHAR2(150)
   ,ATTRIBUTE10	                                      VARCHAR2(150)
   ,ATTRIBUTE11	                                      VARCHAR2(150)
   ,ATTRIBUTE12	                                      VARCHAR2(150)
   ,ATTRIBUTE13	                                      VARCHAR2(150)
   ,ATTRIBUTE14	                                      VARCHAR2(150)
   ,ATTRIBUTE15	                                      VARCHAR2(150)
   ,ATTRIBUTE_NUMBER1	                              NUMBER(15)
   ,ATTRIBUTE_NUMBER2	                              NUMBER(15)
   ,ATTRIBUTE_NUMBER3	                              NUMBER(15)
   ,ATTRIBUTE_NUMBER4	                              NUMBER(15)
   ,ATTRIBUTE_NUMBER5	                              NUMBER(15)
   ,ATTRIBUTE_DATE1	                                  DATE
   ,ATTRIBUTE_DATE2	                                  DATE
   ,ATTRIBUTE_DATE3	                                  DATE
   ,ATTRIBUTE_DATE4	                                  DATE
   ,ATTRIBUTE_DATE5									  DATE
);
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPLAN_ASGN_STG
PROMPT
--
--
CREATE TABLE XXMX_HCM_GPLAN_ASGN_STG
(
    FILE_SET_ID							          VARCHAR2(30)   
	,MIGRATION_SET_ID					              NUMBER
	,MIGRATION_SET_NAME 					          VARCHAR2(150)
	,MIGRATION_STATUS					              VARCHAR2(50)
	,BG_NAME   							              VARCHAR2(240)
	,BG_ID            					              NUMBER(15)
	,BATCH_NAME							              VARCHAR2(300)
	,METADATA							              VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							              VARCHAR2(150) DEFAULT 'GoalPlanAssignment'
	 --
	,GOAL_PLAN_SET_ID								  NUMBER(18)
    ,GOAL_PLAN_SET_START_DATE						  DATE
    ,GOAL_PLAN_END_DATE								  DATE
    ,GOAL_PLAN_ASSIGNMENT_ID						  NUMBER(18)
    ,ASSIGNMENT_ID									  NUMBER(18)
    ,GOALPLAN_START_DATE							  DATE
    ,GOAL_PLAN_SET_END_DATE							  DATE
    ,GOAL_PLAN_ID	                                  NUMBER(18)
    ,ORGANIZATION_ID	                              NUMBER(18)
    ,PERSON_ID										  NUMBER(18)
    ,STATUS	                                          VARCHAR2(30)
    ,WEIGHTING										  NUMBER(5)
    ,ORGANIZATION_NAME								  VARCHAR2(150)
    ,WORKER_ASSIGNMENT_NUMBER	                      VARCHAR2(150)
    ,GOAL_PLAN_EXTERNAL_ID							  VARCHAR2(150)
    ,GOAL_PLANS_ETEXTERNAL_ID	                      VARCHAR2(250)
    ,SOURCE_SYSTEM_ID	                              VARCHAR2(2000)
    ,SOURCE_SYSTEM_OWNER							      VARCHAR2(150)
    ,ATTRIBUTE_CATEGORY							      VARCHAR2(150)
    ,ATTRIBUTE1									      VARCHAR2(150)
    ,ATTRIBUTE2									      VARCHAR2(150)
    ,ATTRIBUTE3									      VARCHAR2(150)
    ,ATTRIBUTE4									      VARCHAR2(150)
    ,ATTRIBUTE5									      VARCHAR2(150)
    ,ATTRIBUTE6									      VARCHAR2(150)
    ,ATTRIBUTE7									      VARCHAR2(150)
    ,ATTRIBUTE8									      VARCHAR2(150)
    ,ATTRIBUTE9									      VARCHAR2(150)
    ,ATTRIBUTE10									  VARCHAR2(150)
    ,ATTRIBUTE11									  VARCHAR2(150)
    ,ATTRIBUTE12									  VARCHAR2(150)
    ,ATTRIBUTE13									  VARCHAR2(150)
    ,ATTRIBUTE14									  VARCHAR2(150)
    ,ATTRIBUTE15									  VARCHAR2(150)
    ,ATTRIBUTE_NUMBER1								  NUMBER
    ,ATTRIBUTE_NUMBER2								  NUMBER
    ,ATTRIBUTE_NUMBER3								  NUMBER
    ,ATTRIBUTE_NUMBER4								  NUMBER
    ,ATTRIBUTE_NUMBER5								  NUMBER
    ,ATTRIBUTE_DATE1								  DATE
    ,ATTRIBUTE_DATE2								  DATE
    ,ATTRIBUTE_DATE3								  DATE
    ,ATTRIBUTE_DATE4								  DATE
    ,ATTRIBUTE_DATE5								  DATE
);

--
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPLAN_DTYPE_STG
PROMPT
--

CREATE TABLE XXMX_HCM_GPLAN_DTYPE_STG
(
    FILE_SET_ID							                VARCHAR2(30)   
	,MIGRATION_SET_ID					                NUMBER
	,MIGRATION_SET_NAME 					            VARCHAR2(150)
	,MIGRATION_STATUS					                VARCHAR2(50)
	,BG_NAME   							                VARCHAR2(240)
	,BG_ID            					                NUMBER(15)
	,BATCH_NAME							                VARCHAR2(300)
	,METADATA							                VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                VARCHAR2(150) DEFAULT 'GoalPlanDocTypes' 
	--
	,DOC_TYPE_ID										NUMBER (18)
    ,GOAL_PLAN_DOC_TYPE_ID							    NUMBER (18)
    ,GOAL_PLAN_ID										NUMBER (18)
    ,GOAL_PLAN_EXTERNAL_ID								VARCHAR2(250)
    ,DOC_TYPE_NAME										VARCHAR2(240)
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
PROMPT Create Table XXMX_HCM_GPLAN_GP_GOALS_STG
PROMPT
--
--
CREATE TABLE XXMX_HCM_GPLAN_GP_GOALS_STG
(
     FILE_SET_ID							            VARCHAR2(30)   
	,MIGRATION_SET_ID					                NUMBER
	,MIGRATION_SET_NAME 					            VARCHAR2(150)
	,MIGRATION_STATUS					                VARCHAR2(50)
	,BG_NAME   							                VARCHAR2(240)
	,BG_ID            					                NUMBER(15)
	,BATCH_NAME							                VARCHAR2(300)
	,METADATA							                VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                VARCHAR2(150) DEFAULT 'GoalPlanGoal' 
	--
   ,GOAL_ID											    NUMBER (18)
   ,GOAL_PLAN_GOAL_ID									NUMBER (18)
   ,GOAL_PLAN_ID										NUMBER (18)
   ,GOAL_PLAN_SET_ID									NUMBER (18)
   ,PRIORITY_CODE										VARCHAR2(30)
   ,SOURCE_SYSTEM_ID									VARCHAR2(2000)
   ,SOURCE_SYSTEM_OWNER									VARCHAR2(30)
   ,WEIGHTING											NUMBER (5)
   ,GOAL_ASSIGNMENT_NUMBER								VARCHAR2(30)
   ,GOAL_ORGANIZATION_NAME								VARCHAR2(240)
   ,GOAL_NAME											VARCHAR2(400)
   ,GOAL_START_DATE										DATE
   ,GOAL_TARGET_COMPLETION_DATE							DATE
   ,GOAL_TYPE_CODE										VARCHAR2(30)
   ,GOAL_VERSION_TYPE_CODE								VARCHAR2(30)
   ,GOAL_PERSON_NUMBER									VARCHAR2(30)
   ,GOAL_PLAN_EXTERNAL_ID								VARCHAR2(250)
   ,GOAL_PLAN_SET_EXTERNAL_ID							VARCHAR2(250)
   ,DISPLAY_SEQUENCE									NUMBER(9)
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
PROMPT Create Table XXMX_HCM_GPLAN_MASS_REQ_STG
PROMPT
--
--
CREATE TABLE XXMX_HCM_GPLAN_MASS_REQ_STG
(
     FILE_SET_ID							            VARCHAR2(30),   
	 MIGRATION_SET_ID					                NUMBER,
	 MIGRATION_SET_NAME 					            VARCHAR2(150),
	 MIGRATION_STATUS					                VARCHAR2(50),
	 BG_NAME   							                VARCHAR2(240),
	 BG_ID            					                NUMBER(15),
	 BATCH_NAME							                VARCHAR2(300),
	 METADATA							                VARCHAR2(150) DEFAULT 'MERGE',
	 OBJECTNAME							                VARCHAR2(150) DEFAULT 'MassRequest',
	--
	GOAL_PLAN_ID	                                    NUMBER (18),
    MASS_REQUEST_ID	                                    NUMBER (18),
    REQ_SUBMITTED_BY_PERSON_ID	                        NUMBER (18),
    REQUESTSUBMISSIONDATE	                            DATE,
    SOURCE_SYSTEM_ID	                                VARCHAR2(2000),
    SOURCE_SYSTEM_OWNER	                                VARCHAR2(30),
    GOAL_PLAN_EXTERNAL_ID	                            VARCHAR2(250),
    REQ_SUBMITTED_BY_PERSON_NUMBER	                    VARCHAR2(30),
    ATTRIBUTE_CATEGORY									VARCHAR2(150),
    ATTRIBUTE1											VARCHAR2(150),
    ATTRIBUTE2											VARCHAR2(150),
    ATTRIBUTE3											VARCHAR2(150),
    ATTRIBUTE4											VARCHAR2(150),
    ATTRIBUTE5											VARCHAR2(150),
    ATTRIBUTE6											VARCHAR2(150),
    ATTRIBUTE7											VARCHAR2(150),
    ATTRIBUTE8											VARCHAR2(150),
    ATTRIBUTE9											VARCHAR2(150),
    ATTRIBUTE10											VARCHAR2(150),
    ATTRIBUTE11											VARCHAR2(150),
    ATTRIBUTE12											VARCHAR2(150),
    ATTRIBUTE13											VARCHAR2(150),
    ATTRIBUTE14											VARCHAR2(150),
    ATTRIBUTE15											VARCHAR2(150),
    ATTRIBUTE_NUMBER1	                                NUMBER,
    ATTRIBUTE_NUMBER2	                                NUMBER,
    ATTRIBUTE_NUMBER3	                                NUMBER,
    ATTRIBUTE_NUMBER4	                                NUMBER,
    ATTRIBUTE_NUMBER5	                                NUMBER,
    ATTRIBUTE_DATE1	                                    DATE,
    ATTRIBUTE_DATE2	                                    DATE,
    ATTRIBUTE_DATE3	                                    DATE,
    ATTRIBUTE_DATE4	                                    DATE,
    ATTRIBUTE_DATE5	                                    DATE
);
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPLAN_EO_PROF_STG
PROMPT
--
--
CREATE TABLE XXMX_HCM_GPLAN_EO_PROF_STG
(
     FILE_SET_ID							            	VARCHAR2(30)   
	,MIGRATION_SET_ID					                	NUMBER
	,MIGRATION_SET_NAME 					            	VARCHAR2(150)
	,MIGRATION_STATUS					                	VARCHAR2(50)
	,BG_NAME   							                	VARCHAR2(240)
	,BG_ID            					                	NUMBER(15)
	,BATCH_NAME							                	VARCHAR2(300)
	,METADATA							                	VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	VARCHAR2(150) DEFAULT 'EligibilityProfileObject' 
	--
   ,ELGBLTY_PROFILE_OBJECT_ID	                            NUMBER(18)
   ,ELIGYPRFL_ID	                                        NUMBER(18)
   ,OBJECT_ID	                                            NUMBER(18)
   ,REQUIRED_FLAG	                                        VARCHAR2(1)
   ,SOURCE_SYSTEM_ID	                                    VARCHAR2(2000)
   ,SOURCE_SYSTEM_OWNER	                                    VARCHAR2(30)
   ,ELIGIBILITY_PROFILE_NAME	                            VARCHAR2(240)
   ,GOAL_PLAN_EXTERNAL_ID	                                VARCHAR2(250)
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
PROMPT Create Table XXMX_HCM_GPLAN_MR_ASGN_STG
PROMPT
--
--
CREATE TABLE XXMX_HCM_GPLAN_MR_ASGN_STG
(
     FILE_SET_ID							            	    VARCHAR2(30)   
	,MIGRATION_SET_ID					                	    NUMBER
	,MIGRATION_SET_NAME 					            	    VARCHAR2(150)
	,MIGRATION_STATUS					                	    VARCHAR2(50)
	,BG_NAME   							                	    VARCHAR2(240)
	,BG_ID            					                	    NUMBER(15)
	,BATCH_NAME							                	    VARCHAR2(300)
	,METADATA							                	    VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	    VARCHAR2(150) DEFAULT 'MassRequestAssignment' 
	--
   ,MASS_REQ_ASSIGNMENT_ID	                                    NUMBER (18)   
   ,MASS_REQUEST_ID	                                            NUMBER (18)   
   ,ORGANIZATION_ID	                                            NUMBER (18)   
   ,ORGANIZATION_NAME	                                        VARCHAR2(240)
   ,GOAL_PLAN_EXTERNAL_ID	                                    VARCHAR2(250)
   ,SOURCE_SYSTEM_OWNER	                                        VARCHAR2(30)
   ,SOURCE_SYSTEM_ID	                                        VARCHAR2(2000)
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
PROMPT Create Table XXMX_HCM_GPLAN_MR_HIER_STG
PROMPT
--
--

CREATE TABLE XXMX_HCM_GPLAN_MR_HIER_STG
(
     FILE_SET_ID							            	    VARCHAR2(30)   
	,MIGRATION_SET_ID					                	    NUMBER
	,MIGRATION_SET_NAME 					            	    VARCHAR2(150)
	,MIGRATION_STATUS					                	    VARCHAR2(50)
	,BG_NAME   							                	    VARCHAR2(240)
	,BG_ID            					                	    NUMBER(15)
	,BATCH_NAME							                	    VARCHAR2(300)
	,METADATA							                	    VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	    VARCHAR2(150) DEFAULT 'MassRequestHierarchy' 
	--
	,CASCADING_LEVEL	                                        NUMBER (18)
    ,MANAGER_ASSIGNMENT_ID	                                    NUMBER (18)
    ,MANAGER_ID	                                                NUMBER (18)
    ,MASS_REQUEST_HIERARCHY_ID	                                NUMBER (18)
    ,MASS_REQUEST_ID	                                        NUMBER (18)
    ,SOURCE_SYSTEM_ID	                                        VARCHAR2(2000)
    ,SOURCE_SYSTEM_OWNER	                                    VARCHAR2(30)
    ,MANAGER_ASSIGNMENT_NUMBER	                                VARCHAR2(30)
    ,GOAL_PLAN_EXTERNAL_ID	                                    VARCHAR2(250)
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
    ,ATTRIBUTE10												VARCHAR2(150)
    ,ATTRIBUTE11												VARCHAR2(150)
    ,ATTRIBUTE12												VARCHAR2(150)
    ,ATTRIBUTE13												VARCHAR2(150)
    ,ATTRIBUTE14												VARCHAR2(150)
    ,ATTRIBUTE15												VARCHAR2(150)
    ,ATTRIBUTE_NUMBER1											NUMBER
    ,ATTRIBUTE_NUMBER2											NUMBER
    ,ATTRIBUTE_NUMBER3											NUMBER
    ,ATTRIBUTE_NUMBER4											NUMBER
    ,ATTRIBUTE_NUMBER5											NUMBER
    ,ATTRIBUTE_DATE1										    DATE
    ,ATTRIBUTE_DATE2										    DATE
    ,ATTRIBUTE_DATE3										    DATE
    ,ATTRIBUTE_DATE4										    DATE
    ,ATTRIBUTE_DATE5										    DATE
);
--
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPLAN_MR_EXEM_STG
PROMPT
--
--

CREATE TABLE XXMX_HCM_GPLAN_MR_EXEM_STG
(
     FILE_SET_ID							            	    VARCHAR2(30)   
	,MIGRATION_SET_ID					                	    NUMBER
	,MIGRATION_SET_NAME 					            	    VARCHAR2(150)
	,MIGRATION_STATUS					                	    VARCHAR2(50)
	,BG_NAME   							                	    VARCHAR2(240)
	,BG_ID            					                	    NUMBER(15)
	,BATCH_NAME							                	    VARCHAR2(300)
	,METADATA							                	    VARCHAR2(150) DEFAULT 'MERGE'
	,OBJECTNAME							                	    VARCHAR2(150) DEFAULT 'MassRequestExemption' 
	--
	,ASSIGNMENT_ID												NUMBER (18)
    ,MASS_REQUEST_EXEMPTIONID									NUMBER (18)
    ,MASS_REQUEST_HIERARCHY_ID									NUMBER (18)
    ,MASS_REQUEST_ID											NUMBER (18)
    ,PERSON_ID													NUMBER (18)
    ,SOURCE_SYSTEM_ID											VARCHAR2(2000)
    ,SOURCE_SYSTEM_OWNER									    VARCHAR2(30)
    ,WORKER_ASSIGNMENT_NUMBER									VARCHAR2(30)
    ,GOAL_PLAN_EXTERNAL_ID										VARCHAR2(250)
    ,MANAGER_ID													NUMBER(18)
    ,MANAGER_ASSIGNMENT_ID										NUMBER(18)
    ,MANAGER_ASSIGNMENT_NUMBER									VARCHAR2(30)
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



CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_STG for XXMX_HCM_GPLAN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_ASGN_STG for XXMX_HCM_GPLAN_ASGN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_DTYPE_STG for XXMX_HCM_GPLAN_DTYPE_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_GP_GOALS_STG for XXMX_HCM_GPLAN_GP_GOALS_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_MASS_REQ_STG for XXMX_HCM_GPLAN_MASS_REQ_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_EO_PROF_STG for XXMX_HCM_GPLAN_EO_PROF_STG ;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_MR_ASGN_STG for XXMX_HCM_GPLAN_MR_ASGN_STG ;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_MR_HIER_STG for XXMX_HCM_GPLAN_MR_HIER_STG ;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPLAN_MR_EXEM_STG for XXMX_HCM_GPLAN_MR_EXEM_STG ;

--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--
GRANT ALL ON XXMX_HCM_GPLAN_STG  TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_ASGN_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_DTYPE_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_GP_GOALS_STG TO XXMX_CORE;
GRANT ALL ON XXMX_HCM_GPLAN_MASS_REQ_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_EO_PROF_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_MR_ASGN_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_MR_HIER_STG  TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPLAN_MR_EXEM_STG TO XXMX_CORE; 
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

