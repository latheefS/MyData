--------------------------------------------------------
--  DDL for Table XXMX_PER_ASG_WORKSCH_EXP_STG
--------------------------------------------------------

  CREATE TABLE "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" NUMBER, 
	"MIGRATION_STATUS" NUMBER, 
	"BG_NAME" NUMBER, 
	"BG_ID" VARCHAR2(30 BYTE), 
	"SCHEDULEEXCEPTIONID" VARCHAR2(18 BYTE), 
	"ASSIGNMENT_NUMBER" VARCHAR2(80 BYTE), 
	"ASSIGNMENTSCHEDULENAME" VARCHAR2(240 BYTE), 
	"BUSINESSUNITNAME" VARCHAR2(264 BYTE), 
	"CALENDAREVENTSHORTCODE" VARCHAR2(150 BYTE), 
	"DEPARTMENT_NAME" VARCHAR2(150 BYTE), 
	"WORKTERMSASSIGNMENTNUMBER" VARCHAR2(30 BYTE), 
	"ENDDATE" DATE, 
	"ENDDATETIME" VARCHAR2(10 BYTE), 
	"ENTERPRISENAME" VARCHAR2(150 BYTE), 
	"EXCEPTIONCODE" VARCHAR2(30 BYTE), 
	"EXCEPTIONTYPE" VARCHAR2(30 BYTE), 
	"INTERNALLOCATIONCODE" VARCHAR2(150 BYTE), 
	"JOB_CODE" VARCHAR2(150 BYTE), 
	"JOBSETCODE" VARCHAR2(150 BYTE), 
	"LEGAL_EMPLOYER_NAME" VARCHAR2(150 BYTE), 
	"LOCATIONSETCODE" VARCHAR2(150 BYTE), 
	"POSITION_CODE" VARCHAR2(150 BYTE), 
	"RESOURCEEXCEPTIONNAME" VARCHAR2(150 BYTE), 
	"RESOURCETYPE" VARCHAR2(30 BYTE), 
	"SCHEDULENAME" VARCHAR2(240 BYTE), 
	"STARTDATE" DATE, 
	"STARTDATETIME" VARCHAR2(10 BYTE), 
	"SCHEDULEASSIGNMENTID" VARCHAR2(18 BYTE), 
	"ASSIGNMENTSCHEDULEID" VARCHAR2(18 BYTE), 
	"AVAILABILITYCODE" VARCHAR2(30 BYTE), 
	"CALENDAREVENTID" VARCHAR2(18 BYTE), 
	"EXCEPTIONID" VARCHAR2(18 BYTE), 
	"RESOURCEASSIGNMENTID" VARCHAR2(18 BYTE), 
	"RESOURCEDEPARTMENTID" VARCHAR2(18 BYTE), 
	"RESOURCEENTERPRISEID" VARCHAR2(18 BYTE), 
	"RESOURCEEXCEPTIONID" VARCHAR2(18 BYTE), 
	"RESOURCEID" VARCHAR2(18 BYTE), 
	"RESOURCEJOBID" VARCHAR2(18 BYTE), 
	"RESOURCELEGALEMPLOYERID" VARCHAR2(18 BYTE), 
	"RESOURCELOCATIONID" VARCHAR2(18 BYTE), 
	"RESOURCEPOSITIONID" VARCHAR2(18 BYTE), 
	"RESOURCEWORKTERMSID" VARCHAR2(18 BYTE), 
	"SCHEDULEID" VARCHAR2(18 BYTE), 
	"METADATA" VARCHAR2(10 BYTE) DEFAULT 'MERGE', 
	"OBJECTNAME" VARCHAR2(10 BYTE), 
	"SOURCESYSTEMID" VARCHAR2(2000 BYTE), 
	"SOURCESYSTEMOWNER" VARCHAR2(50 BYTE), 
	"ATTRIBUTE1" VARCHAR2(150 BYTE), 
	"ATTRIBUTE2" VARCHAR2(150 BYTE), 
	"ATTRIBUTE3" VARCHAR2(150 BYTE), 
	"ATTRIBUTE4" VARCHAR2(150 BYTE), 
	"ATTRIBUTE5" VARCHAR2(150 BYTE), 
	"ATTRIBUTE6" VARCHAR2(150 BYTE), 
	"ATTRIBUTE7" VARCHAR2(150 BYTE), 
	"ATTRIBUTE8" VARCHAR2(150 BYTE), 
	"ATTRIBUTE9" VARCHAR2(150 BYTE), 
	"ATTRIBUTE10" VARCHAR2(150 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_STG" ;
  GRANT SELECT ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_READONLY";
  GRANT FLASHBACK ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT READ ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";
  GRANT ALTER ON "XXMX_STG"."XXMX_PER_ASG_WORKSCH_EXP_STG" TO "XXMX_CORE";