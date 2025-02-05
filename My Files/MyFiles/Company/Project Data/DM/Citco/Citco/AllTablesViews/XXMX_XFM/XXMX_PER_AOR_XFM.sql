--------------------------------------------------------
--  DDL for Table XXMX_PER_AOR_XFM
--------------------------------------------------------

  CREATE TABLE "XXMX_XFM"."XXMX_PER_AOR_XFM" 
   (	"FILE_SET_ID" VARCHAR2(30 BYTE), 
	"MIGRATION_SET_ID" NUMBER, 
	"MIGRATION_SET_NAME" NUMBER, 
	"MIGRATION_STATUS" NUMBER, 
	"BG_NAME" NUMBER, 
	"BG_ID" VARCHAR2(30 BYTE), 
	"ASGRESPONSIBILITYID" VARCHAR2(18 BYTE), 
	"PERSONNUMBER" VARCHAR2(30 BYTE), 
	"RESPONSIBILITYNAME" VARCHAR2(240 BYTE), 
	"ASSIGNMENTCATEGORY" VARCHAR2(30 BYTE), 
	"ASSIGNMENTID" VARCHAR2(18 BYTE), 
	"ASSIGNMENT_NUMBER" VARCHAR2(30 BYTE), 
	"BARGAININGUNIT" VARCHAR2(30 BYTE), 
	"BENEFITGROUPID" VARCHAR2(18 BYTE), 
	"BENEFITGROUPNAME" VARCHAR2(240 BYTE), 
	"BUSINESSUNITID" VARCHAR2(18 BYTE), 
	"BUSINESSUNITSHORTCODE" VARCHAR2(150 BYTE), 
	"COUNTRY" VARCHAR2(30 BYTE), 
	"DEPARTMENTHIERARCHYVERSIONNAME" VARCHAR2(240 BYTE), 
	"DEPARTMENTTREECODE" VARCHAR2(30 BYTE), 
	"WORKCONTACTSFLAG" VARCHAR2(30 BYTE), 
	"ENDDATE" DATE, 
	"LASTNAMESTART" VARCHAR2(30 BYTE), 
	"GRADE_CODE" VARCHAR2(30 BYTE), 
	"GRADEID" VARCHAR2(18 BYTE), 
	"GRADESETCODE" VARCHAR2(30 BYTE), 
	"HIERARCHYLEVELS" VARCHAR2(2 BYTE), 
	"INCLUDETOPHIERNODE" VARCHAR2(30 BYTE), 
	"JOB_CODE" VARCHAR2(30 BYTE), 
	"JOBFAMILYCODE" VARCHAR2(240 BYTE), 
	"JOBFAMILYID" VARCHAR2(18 BYTE), 
	"JOBFAMILY" VARCHAR2(240 BYTE), 
	"JOBFUNCTIONCODE" VARCHAR2(30 BYTE), 
	"JOBID" VARCHAR2(18 BYTE), 
	"JOBSETCODE" VARCHAR2(30 BYTE), 
	"LEGALEMPLOYERNAME" VARCHAR2(240 BYTE), 
	"LEGALENTITYID" VARCHAR2(18 BYTE), 
	"LEGISLATIVEDATAGROUPID" VARCHAR2(18 BYTE), 
	"LEGISLATIVEDATAGROUPNAME" VARCHAR2(240 BYTE), 
	"LOCATION_CODE" VARCHAR2(150 BYTE), 
	"LOCATIONID" VARCHAR2(18 BYTE), 
	"LOCATIONSETCODE" VARCHAR2(30 BYTE), 
	"TOPORGANIZATIONCLASSIFICATIONCODE" VARCHAR2(40 BYTE), 
	"TOPORGANIZATIONID" VARCHAR2(18 BYTE), 
	"TOPHIERARCHYORGANIZATIONNAME" VARCHAR2(240 BYTE), 
	"ORGANIZATIONTREECODE" VARCHAR2(30 BYTE), 
	"ORGANIZATIONHIERARCHYVERSIONNAME" VARCHAR2(30 BYTE), 
	"ORGANIZATIONID" VARCHAR2(18 BYTE), 
	"ORGANIZATIONNAME" VARCHAR2(240 BYTE), 
	"PAYROLLID" VARCHAR2(18 BYTE), 
	"PAYROLLNAME" VARCHAR2(80 BYTE), 
	"PAYROLLORGANIZATIONNAME" VARCHAR2(240 BYTE), 
	"PAYROLLSTATUNITID" VARCHAR2(18 BYTE), 
	"PERSONID" VARCHAR2(18 BYTE), 
	"POSITIONBUSINESSUNITSHORTCODE" VARCHAR2(150 BYTE), 
	"POSITION_CODE" VARCHAR2(30 BYTE), 
	"POSITIONHIERARCHYID" VARCHAR2(32 BYTE), 
	"POSITIONHIERARCHYVERSIONNAME" VARCHAR2(240 BYTE), 
	"POSITIONID" VARCHAR2(18 BYTE), 
	"POSITIONTREECODE" VARCHAR2(30 BYTE), 
	"RECRUITINGLOCHIERARCHY" VARCHAR2(360 BYTE), 
	"RECRUITINGLOCHIERARCHYID" VARCHAR2(18 BYTE), 
	"RECRUITINGORGHIERARCHY" VARCHAR2(240 BYTE), 
	"RECRUITINGORGHIERARCHYID" VARCHAR2(18 BYTE), 
	"RECRUITINGORGTREECODE" VARCHAR2(1000 BYTE), 
	"RECORGTREESTRUCTURECODE" VARCHAR2(80 BYTE), 
	"RECRUITINGORGTREEVER" VARCHAR2(1000 BYTE), 
	"RECRUITINGTYPECODE" VARCHAR2(30 BYTE), 
	"RESPONSIBILITYTYPE" VARCHAR2(30 BYTE), 
	"STARTDATE" DATE, 
	"STATUS" VARCHAR2(30 BYTE), 
	"TRU" VARCHAR2(240 BYTE), 
	"TAXREPORTINGUNITID" VARCHAR2(18 BYTE), 
	"LASTNAMEEND" VARCHAR2(30 BYTE), 
	"TOPDEPARTMENTID" VARCHAR2(18 BYTE), 
	"TOPHIERARCHYDEPARTMENTNAME" VARCHAR2(240 BYTE), 
	"TOPHIERARCHYPOSITIONBUSINESSUNITSHORTCODE" VARCHAR2(150 BYTE), 
	"TOPHIERARCHYPOSITIONCODE" VARCHAR2(30 BYTE), 
	"TOPMANAGERID" VARCHAR2(18 BYTE), 
	"TOPMANAGERNUMBER" VARCHAR2(30 BYTE), 
	"TOPPOSITIONID" VARCHAR2(18 BYTE), 
	"SOURCESYSTEMID" VARCHAR2(2000 BYTE), 
	"SOURCESYSTEMOWNER" VARCHAR2(50 BYTE), 
	"METADATA" VARCHAR2(10 BYTE), 
	"OBJECTNAME" VARCHAR2(10 BYTE), 
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
  TABLESPACE "XXMX_XFM" ;
  GRANT ALTER ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT DELETE ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT INDEX ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT INSERT ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT SELECT ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_READONLY";
  GRANT SELECT ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT UPDATE ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT REFERENCES ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT READ ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT ON COMMIT REFRESH ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT QUERY REWRITE ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT DEBUG ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
  GRANT FLASHBACK ON "XXMX_XFM"."XXMX_PER_AOR_XFM" TO "XXMX_CORE";
