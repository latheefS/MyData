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
--** FILENAME  :  xxmx_hcm_gpset_stg_dbi.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/STG
--**
--** VERSION   :  1.1
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Ian S. Vickerstaff, Robert Murphy
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
--** [1.0 	20-SEP-2023	 Soundarya Kamatagi		Adding stg script for Hcm Talent Management Goal Plan Set]
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
EXEC DropTable ('XXMX_HCM_GPSET_STG')
EXEC DropTable ('XXMX_HCM_GPSET_PLAN_STG')
EXEC DropTable ('XXMX_HCM_GPSET_MASS_REQ_STG')
EXEC DropTable ('XXMX_HCM_GPSET_EO_PROF_STG')
EXEC DropTable ('XXMX_HCM_GPSET_MR_HIER_STG')
EXEC DropTable ('XXMX_HCM_GPSET_MR_EXEM_STG')
--
--
--
PROMPT
PROMPT Create Table XXMX_HCM_GPSET_STG
PROMPT
--


CREATE TABLE XXMX_HCM_GPSET_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'GoalPlanSet',
	--
	GOAL_PLAN_SET_ID					NUMBER(18) NOT NULL ENABLE,
    GOAL_PLAN_SET_EXTERNAL_ID 			VARCHAR2(250) NOT NULL ENABLE,
    GOAL_PLAN_SET_ACTIVE_FLAG 			VARCHAR2(30),
    REQUEST_SUBMISSION_DATE				DATE,
    DESCRIPTION 						VARCHAR2(4000),
    END_DATE    						DATE NOT NULL ENABLE,
    GOAL_PLAN_SET_NAME					VARCHAR2(400) NOT NULL ENABLE,
    REQ_SUBMITTED_BY_PERSON_ID			VARCHAR2(150),
    REQ_SUBMITTED_BY_PERSON_NUMBER      VARCHAR2(30),
    REVIEW_PERIOD_ID    				NUMBER(18),
    REVIEW_PERIOD_NAME 					VARCHAR2(400),
    START_DATE							DATE NOT NULL ENABLE,
    SOURCE_SYSTEM_ID					VARCHAR2(2000),
    SOURCE_SYSTEM_OWNER					VARCHAR2(30),
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
	ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
    ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE, 
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
);

--
PROMPT
PROMPT Create Table XXMX_HCM_GPSET_PLAN_STG
PROMPT
--

CREATE TABLE XXMX_HCM_GPSET_PLAN_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'GoalPlanSetPlan',
	--
	GOAL_PLAN_ID	                    NUMBER(18) NOT NULL ENABLE,
    GOAL_PLAN_SET_ID	                    NUMBER(18) NOT NULL ENABLE,
    GOAL_PLAN_SET_PLAN_ID					NUMBER(18) NOT NULL ENABLE,
    WEIGHTING							NUMBER(5),
    GOAL_PLAN_SET_EXTERNAL_ID				VARCHAR2(250),
    GOAL_PLAN_EXTERNAL_ID					VARCHAR2(250),
    SOURCE_SYSTEM_OWNER					VARCHAR2(256),
	SOURCE_SYSTEM_ID					VARCHAR2(2000),
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
	ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
	ATTRIBUTE_NUMBER1 					NUMBER, 
	ATTRIBUTE_NUMBER2 					NUMBER, 
	ATTRIBUTE_NUMBER3 					NUMBER, 
	ATTRIBUTE_NUMBER4 					NUMBER, 
	ATTRIBUTE_NUMBER5 					NUMBER, 
	ATTRIBUTE_DATE1 					DATE, 
	ATTRIBUTE_DATE2 					DATE, 
	ATTRIBUTE_DATE3 					DATE, 
	ATTRIBUTE_DATE4 					DATE, 
	ATTRIBUTE_DATE5 					DATE
);
--  
   

--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
CREATE TABLE XXMX_HCM_GPSET_MASS_REQ_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MassRequest',
	--
	MASS_REQUEST_ID	                	NUMBER(18) NOT NULL ENABLE,
    GOAL_PLAN_SET_EXTERNAL_ID			VARCHAR2(250),
    GOAL_PLAN_SET_ID					NUMBER(18) NOT NULL ENABLE,
    REQ_SUBMITTED_BY_PERSON_ID				NUMBER(18) NOT NULL ENABLE,
    REQUEST_SUBMISSION_DATE				DATE NOT NULL ENABLE,
    SOURCE_SYSTEM_ID						VARCHAR2(2000),
    SOURCE_SYSTEM_OWNER					VARCHAR2(30),
    REQ_SUBMITTED_BY_PERSON_NUMBER			VARCHAR2(30),
    ATTRIBUTE_CATEGORY					VARCHAR2(150),
    ATTRIBUTE1	                        VARCHAR2(150),
    ATTRIBUTE2	                        VARCHAR2(150),
    ATTRIBUTE3	                        VARCHAR2(150),
    ATTRIBUTE4	                        VARCHAR2(150),
    ATTRIBUTE5	                        VARCHAR2(150),
    ATTRIBUTE6	                        VARCHAR2(150),
    ATTRIBUTE7	                        VARCHAR2(150),
    ATTRIBUTE8	                        VARCHAR2(150),
    ATTRIBUTE9	                        VARCHAR2(150),
    ATTRIBUTE10	                        VARCHAR2(150),
    ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
    ATTRIBUTE_NUMBER1	                NUMBER (15),
    ATTRIBUTE_NUMBER2	                NUMBER (15),
    ATTRIBUTE_NUMBER3	                NUMBER (15),
    ATTRIBUTE_NUMBER4	                NUMBER (15),
    ATTRIBUTE_NUMBER5	                NUMBER (15),
    ATTRIBUTE_DATE1	                    DATE,
    ATTRIBUTE_DATE2	                    DATE,
    ATTRIBUTE_DATE3	                    DATE,
    ATTRIBUTE_DATE4	                    DATE,
    ATTRIBUTE_DATE5	                    DATE
 );

PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
CREATE TABLE XXMX_HCM_GPSET_EO_PROF_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'EligibilityProfileObject',
	--
	ELGBLTY_PROFILE_OBJECT_ID			NUMBER(18) NOT NULL ENABLE,
	ELIGY_PRFL_ID						NUMBER(18) NOT NULL ENABLE,
	OBJECT_ID							NUMBER(18) NOT NULL ENABLE,
    REQUIRED_FLAG						VARCHAR2(1) NOT NULL ENABLE,
    ELIGIBILITY_PROFILE_NAME			VARCHAR2(240),
    GOAL_PLAN_SET_EXTERNAL_ID			VARCHAR2(250),
    SOURCE_SYSTEM_OWNER					VARCHAR2(30),
    SOURCE_SYSTEM_ID					VARCHAR2(2000),
    ATTRIBUTE_CATEGORY					VARCHAR2(150),
    ATTRIBUTE1	                        VARCHAR2(150),
    ATTRIBUTE2	                        VARCHAR2(150),
    ATTRIBUTE3	                        VARCHAR2(150),
    ATTRIBUTE4	                        VARCHAR2(150),
    ATTRIBUTE5	                        VARCHAR2(150),
    ATTRIBUTE6	                        VARCHAR2(150),
    ATTRIBUTE7	                        VARCHAR2(150),
    ATTRIBUTE8	                        VARCHAR2(150),
    ATTRIBUTE9	                        VARCHAR2(150),
    ATTRIBUTE10	                        VARCHAR2(150),
    ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
    ATTRIBUTE_NUMBER1	                NUMBER (15),
    ATTRIBUTE_NUMBER2	                NUMBER (15),
    ATTRIBUTE_NUMBER3	                NUMBER (15),
    ATTRIBUTE_NUMBER4	                NUMBER (15),
    ATTRIBUTE_NUMBER5	                NUMBER (15),
    ATTRIBUTE_DATE1	                    DATE,
    ATTRIBUTE_DATE2	                    DATE,
    ATTRIBUTE_DATE3	                    DATE,
    ATTRIBUTE_DATE4	                    DATE,
    ATTRIBUTE_DATE5	                    DATE
);

--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
CREATE TABLE XXMX_HCM_GPSET_MR_HIER_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MassRequestHierarchy',
	--
	MASS_REQUEST_HIERARCHY_ID			NUMBER(18) NOT NULL ENABLE,
    MASS_REQUEST_ID						NUMBER(18) NOT NULL ENABLE,
    MANAGER_ASSIGNMENT_NUMBER			VARCHAR2(30),
    GOAL_PLAN_SET_EXTERNAL_ID			VARCHAR2(250),
    MANAGER_ASSIGNMENT_ID				VARCHAR2(30) NOT NULL ENABLE,
    MANAGER_ID							NUMBER(18) NOT NULL ENABLE,
	CASCADING_LEVEL	                    NUMBER(18),
    SOURCESYSTEM_ID	                    VARCHAR2(2000),
    SOURCESYSTEM_OWNER					VARCHAR2(30),
	--
    ATTRIBUTE_CATEGORY					VARCHAR2(150),
    ATTRIBUTE1	                        VARCHAR2(150),
    ATTRIBUTE2	                        VARCHAR2(150),
    ATTRIBUTE3	                        VARCHAR2(150),
    ATTRIBUTE4	                        VARCHAR2(150),
    ATTRIBUTE5	                        VARCHAR2(150),
    ATTRIBUTE6	                        VARCHAR2(150),
    ATTRIBUTE7	                        VARCHAR2(150),
    ATTRIBUTE8	                        VARCHAR2(150),
    ATTRIBUTE9	                        VARCHAR2(150),
    ATTRIBUTE10	                        VARCHAR2(150),
    ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
    ATTRIBUTE_NUMBER1	                NUMBER (15),
    ATTRIBUTE_NUMBER2	                NUMBER (15),
    ATTRIBUTE_NUMBER3	                NUMBER (15),
    ATTRIBUTE_NUMBER4	                NUMBER (15),
    ATTRIBUTE_NUMBER5	                NUMBER (15),
    ATTRIBUTE_DATE1	                    DATE,
    ATTRIBUTE_DATE2	                    DATE,
    ATTRIBUTE_DATE3	                    DATE,
    ATTRIBUTE_DATE4	                    DATE,
    ATTRIBUTE_DATE5	                    DATE
);

--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
--
CREATE TABLE XXMX_HCM_GPSET_MR_EXEM_STG
   (
    FILE_SET_ID							VARCHAR2(30),
	MIGRATION_SET_ID					NUMBER,
	MIGRATION_SET_NAME 					VARCHAR2(150),
	MIGRATION_STATUS					VARCHAR2(50),
	MIGRATION_ACTION					VARCHAR2(10),
	BG_NAME   							VARCHAR2(240), 
	BG_ID            					NUMBER(15),	
	BATCH_NAME  						VARCHAR2(300),
	METADATA							VARCHAR2(150) DEFAULT 'MERGE',
	OBJECTNAME							VARCHAR2(150) DEFAULT 'MassRequestExemption',
	--
	ASSIGNMENT_ID						NUMBER(18) NOT NULL ENABLE,
	MASS_REQUEST_EXEMPTION_ID			NUMBER(18) NOT NULL ENABLE,
	MASS_REQUEST_HIERARCHY_ID			NUMBER(18) NOT NULL ENABLE,
    MASS_REQUEST_ID						NUMBER(18) NOT NULL ENABLE,
    PERSON_ID						    NUMBER(18) NOT NULL ENABLE,
    WORKER_ASSIGNMENT_NUMBER	        VARCHAR2(30),
    GOAL_PLAN_SET_EXTERNAL_ID	        VARCHAR2(250),
    MANAGER_ID							VARCHAR2(150),
    MANAGER_ASSIGNMENT_ID				VARCHAR2(150),
    MANAGER_ASSIGNMENT_NUMBER			VARCHAR2(30),
    SOURCE_SYSTEM_OWNER					VARCHAR2(30),
    SOURCE_SYSTEM_ID					VARCHAR2(2000),
    ATTRIBUTE_CATEGORY					VARCHAR2(150),
    ATTRIBUTE1	                        VARCHAR2(150),
    ATTRIBUTE2	                        VARCHAR2(150),
    ATTRIBUTE3	                        VARCHAR2(150),
    ATTRIBUTE4	                        VARCHAR2(150),
    ATTRIBUTE5	                        VARCHAR2(150),
    ATTRIBUTE6	                        VARCHAR2(150),
    ATTRIBUTE7	                        VARCHAR2(150),
    ATTRIBUTE8	                        VARCHAR2(150),
    ATTRIBUTE9	                        VARCHAR2(150),
    ATTRIBUTE10	                        VARCHAR2(150),
    ATTRIBUTE11	                        VARCHAR2(150),
    ATTRIBUTE12	                        VARCHAR2(150),
    ATTRIBUTE13	                        VARCHAR2(150),
    ATTRIBUTE14	                        VARCHAR2(150),
    ATTRIBUTE15	                        VARCHAR2(150),
    ATTRIBUTE_NUMBER1	                 NUMBER (15),
    ATTRIBUTE_NUMBER2	                 NUMBER (15),
    ATTRIBUTE_NUMBER3	                 NUMBER (15),
    ATTRIBUTE_NUMBER4	                 NUMBER (15),
    ATTRIBUTE_NUMBER5	                 NUMBER (15),
    ATTRIBUTE_DATE1	                     DATE,
    ATTRIBUTE_DATE2	                     DATE,
    ATTRIBUTE_DATE3	                     DATE,
    ATTRIBUTE_DATE4	                     DATE,
    ATTRIBUTE_DATE5	                     DATE
);


--------------------------
---SYNONYMS AND GRANTS
--------------------------


--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** CREATE OR REPLACE SYNONYM
PROMPT ***********************
--
--


CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_STG for XXMX_HCM_GPSET_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_PLAN_STG for XXMX_HCM_GPSET_PLAN_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_MASS_REQ_STG for XXMX_HCM_GPSET_MASS_REQ_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_EO_PROF_STG for XXMX_HCM_GPSET_EO_PROF_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_MR_HIER_STG for XXMX_HCM_GPSET_MR_HIER_STG;
CREATE OR REPLACE PUBLIC SYNONYM XXMX_HCM_GPSET_MR_EXEM_STG  for XXMX_HCM_GPSET_MR_EXEM_STG ;

--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting permissions
PROMPT ***********************
--
--


GRANT ALL ON XXMX_HCM_GPSET_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPSET_PLAN_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPSET_MASS_REQ_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPSET_EO_PROF_STG TO XXMX_CORE;
GRANT ALL ON XXMX_HCM_GPSET_MR_HIER_STG TO XXMX_CORE; 
GRANT ALL ON XXMX_HCM_GPSET_MR_EXEM_STG TO XXMX_CORE; 





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

