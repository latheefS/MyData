--------------------------------------------------------
--  DDL for View XXMX_JOBREQ_POST_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_JOBREQ_POST_HDL_V" ("COL1_HEADER") AS 
  SELECT 'METADATA|JobRequisition|RequisitionNumber|RequisitionTitle|RecruitingType|HiringManagerPersonNumber|RecruiterPersonNumber|PrimaryLocationName|PrimaryLocationId|BusinessUnitShortCode|CurrentPhaseCode|CurrentStateCode|DepartmentId|OrganizationCode|BaseLanguageCode|CandidateSelectionProcessCode|UnlimitedOpeningsFlag|ExternalApplyFlowCode|PositionCode|GradeCode|InternalDescription|InternalQual|InternalResp|JobCode|JobFamilyName|PrimaryWorkLocationId|PrimaryWorkLocationCode|FLEX:IRC_REQUISITIONS_DFF|businessCase(IRC_REQUISITIONS_DFF=Global Data Elements)|vacancyType(IRC_REQUISITIONS_DFF=Global Data Elements)|budgetedheadcount(IRC_REQUISITIONS_DFF=Global Data Elements)|replacementemail(IRC_REQUISITIONS_DFF=Global Data Elements)|LegalEmployerName|FullTimeOrPartTime' Col1_Header from dual
UNION ALL
SELECT 'MERGE|JobRequisition|'
||REQUISITION_NUMBER||'|'
||REQUISITION_TITLE
||'|ORA_PROFESSIONAL|'
||NVL(HIRING_MANAGER_PERSON_NUMBER,20352)||'|'||NVL(RECRUITER_PERSON_NUMBER,25049)||'||'
--||PRIMARY_LOCATION_NAME||'|'
||PRIMARY_LOCATION_ID
||'|'||BUSINESS_UNIT_SHORT_CODE
||'|REQUISITION_JOB_FORMATTING|REQUISITION_IN_PROGRESS|'
||DEPARTMENT_ID
||'|'||ORGANIZATION_CODE
||'|US|Citco_Candidate_Selection_Process_V2|Y|Citco_Job_Application_Flow|'
||POSITION_CODE||'|'
||GRADE_CODE||'|'
--POSITION_DESCRIPTION
||'||'--||--POSITION_QUALIFICATION
--||'|'
--||POSITION_RESPONSIBILITY
||'|'
||Job_Code||'|'
||Job_Family_Name||'|' 
||primary_work_location_id||'||'
--|| primary_work_location_code||'|'
||'Global Data Elements|'
||substr(business_case,1,100)||'|'
||vacancy_type||'|Yes|'
||if_replacement_name||'|'
||legal_employer_name||'|'
||decode(fulltime_or_parttime,'Either','Full Time',fulltime_or_parttime)  HDL1_DATA 
FROM XXMX_HCM_IREC_JOB_REQ_XFM
WHERE POSITION_CODE IS NOT NULL 
/*UNION ALL
SELECT 'METADATA|PostingDetails|ExternalOrInternal|RequisitionNumber|StartDate|EndDate|PostingStatus'  Col2_Header from dual
UNION ALL
SELECT 'MERGE|PostingDetails|ORA_INTERNAL|'||REQUISITION_NUMBER||'|'
||START_DATE||'||' HDL2_DATA FROM XXMX_HCM_IREC_JR_POST_DET_XFM
WHERE REQUISITION_NUMBER IN(SELECT REQUISITION_NUMBER
FROM XXMX_HCM_IREC_JOB_REQ_XFM 
WHERE POSITION_CODE IS NOT NULL)
UNION ALL
SELECT 'MERGE|PostingDetails|ORA_EXTERNAL|'||REQUISITION_NUMBER
||'|'||START_DATE
||'||' HDL2_DATA 
FROM XXMX_HCM_IREC_JR_POST_DET_XFM
WHERE REQUISITION_NUMBER IN(SELECT REQUISITION_NUMBER
      FROM XXMX_HCM_IREC_JOB_REQ_XFM 
      WHERE POSITION_CODE IS NOT NULL)*/
UNION ALL
SELECT 'METADATA|BackgroundCheckConfiguration|AccountUserName|PartnerName|RequisitionNumber|MultipleRequestFlag' col3_header from dual
UNION ALL
select 'MERGE|BackgroundCheckConfiguration|TOR068|Hireright|'||REQUISITION_NUMBER||'|Y' FROM XXMX_HCM_IREC_JR_POST_DET_XFM
WHERE REQUISITION_NUMBER IN(SELECT REQUISITION_NUMBER
FROM XXMX_HCM_IREC_JOB_REQ_XFM 
WHERE POSITION_CODE IS NOT NULL)
;