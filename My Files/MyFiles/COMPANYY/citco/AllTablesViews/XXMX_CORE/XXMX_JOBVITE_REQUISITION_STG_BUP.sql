--------------------------------------------------------
--  DDL for Table XXMX_JOBVITE_REQUISITION_STG_BUP
--------------------------------------------------------

  CREATE TABLE "XXMX_CORE"."XXMX_JOBVITE_REQUISITION_STG_BUP" 
   (	"TITLE" VARCHAR2(4000 BYTE), 
	"JOBID" VARCHAR2(1000 BYTE), 
	"REQUISITIONID" VARCHAR2(1000 BYTE), 
	"STATUS" VARCHAR2(1000 BYTE), 
	"CATEGORY" VARCHAR2(4000 BYTE), 
	"JOBTYPE" VARCHAR2(1000 BYTE), 
	"CANDIDATEACTIVE" VARCHAR2(500 BYTE), 
	"CANDIDATETOTAL" VARCHAR2(500 BYTE), 
	"EEOCATEGORY" VARCHAR2(1000 BYTE), 
	"COMPANYNAME" VARCHAR2(500 BYTE), 
	"AREACODE" VARCHAR2(1000 BYTE), 
	"CONTACTINFORMATION" VARCHAR2(1000 BYTE), 
	"DONOTCALL" VARCHAR2(1000 BYTE), 
	"DEPARTMENT" VARCHAR2(1000 BYTE), 
	"LOCATION" VARCHAR2(4000 BYTE), 
	"CITY" VARCHAR2(1000 BYTE), 
	"STATE" VARCHAR2(4000 BYTE), 
	"POSTALCODE" VARCHAR2(1000 BYTE), 
	"COUNTRY" VARCHAR2(1000 BYTE), 
	"COMPANY" VARCHAR2(1000 BYTE), 
	"INTERNALONLY" VARCHAR2(1000 BYTE), 
	"PRIVATE" VARCHAR2(1000 BYTE), 
	"CAREERSITE" VARCHAR2(1000 BYTE), 
	"NOTIFICATION" VARCHAR2(1000 BYTE), 
	"BONUS" VARCHAR2(1000 BYTE), 
	"BRIEFDESCRIPTION" VARCHAR2(4000 BYTE), 
	"DESCRIPTION" CLOB, 
	"CREATEDBY" VARCHAR2(4000 BYTE), 
	"RECRUITERS" CLOB, 
	"HIRINGMANAGERS" CLOB, 
	"APPROVERS" VARCHAR2(150 BYTE), 
	"CREATEDON" VARCHAR2(4000 BYTE), 
	"APPROVEDATE" VARCHAR2(1000 BYTE), 
	"LASTUPDATED" VARCHAR2(4000 BYTE), 
	"JOBOPENEDDATES" VARCHAR2(4000 BYTE), 
	"FILLEDON" VARCHAR2(1000 BYTE), 
	"STARTDATE" VARCHAR2(500 BYTE), 
	"ENDDATE" VARCHAR2(500 BYTE), 
	"CLOSEDATE" VARCHAR2(4000 BYTE), 
	"PRE_INTERVIEWFORM" VARCHAR2(1000 BYTE), 
	"WORKFLOW" VARCHAR2(1000 BYTE), 
	"DEPARTMENT42" VARCHAR2(1000 BYTE), 
	"EVALUATIONFORM" VARCHAR2(1000 BYTE), 
	"REFERRALBONUS" VARCHAR2(1000 BYTE), 
	"AGENCYACCESS" VARCHAR2(4000 BYTE), 
	"AGENCYACCESS46" VARCHAR2(4000 BYTE), 
	"EBS_VACANCY_STATUS" VARCHAR2(1000 BYTE), 
	"EBS_JOB_TITLE" VARCHAR2(4000 BYTE), 
	"CONFIDENTIAL_VACANCY" VARCHAR2(1000 BYTE), 
	"JOB_GRADE" VARCHAR2(2000 BYTE), 
	"VACANCY_TYPE" VARCHAR2(4000 BYTE), 
	"IF_REPLACEMENT_NAME" VARCHAR2(4000 BYTE), 
	"ORACLE_CODE_DEPARTMENT" VARCHAR2(4000 BYTE), 
	"BUSINESS_CASE" CLOB, 
	"JOB_FAMILY" VARCHAR2(1000 BYTE), 
	"TA_REGION" VARCHAR2(1000 BYTE), 
	"TYPE_OF_JOBVITE_VACANCY" VARCHAR2(1000 BYTE), 
	"PARENT_REQ_ID_FOR_POSTING_INTAKE" VARCHAR2(1000 BYTE), 
	"JOB_STRATEGY_MEETING_QUESTIONS" VARCHAR2(1000 BYTE), 
	"TA_PARTNER_CONDUCTING_JOB_STRATEGY_MEETING" VARCHAR2(1000 BYTE), 
	"JOB_STRATEGY_MEETING_DATE" VARCHAR2(1000 BYTE), 
	"JOB_STRATEGY_MEETING_COMPLETED" VARCHAR2(1000 BYTE), 
	"RESPONSIBILITIES_TYPICAL_DAY_FOR_PERSON_PERFORMING_THIS_ROLE" CLOB, 
	"TEAM_STRUCTURE" VARCHAR2(1000 BYTE), 
	"CAREER_PATH_FOR_THIS_ROLE" VARCHAR2(1000 BYTE), 
	"FORECAST_START_DATE" VARCHAR2(1000 BYTE), 
	"BUDGETED_SALARY" VARCHAR2(1000 BYTE), 
	"TARGET_SALARY_FOR_THE_ROLE" VARCHAR2(1000 BYTE), 
	"DESIRED_SKILLS_COMPETENCIES" VARCHAR2(4000 BYTE), 
	"NICE_TO_HAVE_SKILLS" VARCHAR2(1000 BYTE), 
	"WHAT_ATTRACTS_CANDIDATES_TO_THIS_ROLE_UNIQUE_FEATURES_OF_THE_ROLE" VARCHAR2(1000 BYTE), 
	"TYPICAL_HOURS_OT" VARCHAR2(1000 BYTE), 
	"TRAVEL" VARCHAR2(1000 BYTE), 
	"CONSIDERING_CANDIDATES_THAT_ARE" VARCHAR2(1000 BYTE), 
	"IF_INTERNAL_WHAT_OTHER_CITCO_GROUPS_TYPICALLY_HAVE_TRANSFERABLE_SKILLS" VARCHAR2(1000 BYTE), 
	"CONSIDERING_GLOBAL_CANDIDATES" VARCHAR2(1000 BYTE), 
	"COMPANIES_TO_TARGET" VARCHAR2(1000 BYTE), 
	"NUMBER_TYPES_OF_INTERVIEWS_INTERVIEWERS" VARCHAR2(4000 BYTE), 
	"ASSESSMENTS_REQUIRED_WHEN_IN_THE_PROCESS" VARCHAR2(1000 BYTE), 
	"POST_JOB" VARCHAR2(1000 BYTE), 
	"SOURCING_REQUIRED" VARCHAR2(1000 BYTE), 
	"AGENCY_USAGE" VARCHAR2(1000 BYTE), 
	"RECOMMENDED_AGENCIES" VARCHAR2(1000 BYTE), 
	"TA_PARTNER_COMMENTS" VARCHAR2(4000 BYTE), 
	"JOB_STRATEGY_MEETING_APPROVED_BY_HM" VARCHAR2(1000 BYTE), 
	"JOB_STRATEGY_MEETING_APPROVED_BY_HM_DATE" VARCHAR2(1000 BYTE), 
	"JOB_AD_IMAGE" VARCHAR2(1000 BYTE), 
	"LINKED_URL" VARCHAR2(1000 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" 
 LOB ("DESCRIPTION") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("RECRUITERS") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("HIRINGMANAGERS") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("BUSINESS_CASE") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("RESPONSIBILITIES_TYPICAL_DAY_FOR_PERSON_PERFORMING_THIS_ROLE") STORE AS SECUREFILE (
  TABLESPACE "XXMX_CORE" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
