--------------------------------------------------------
--  DDL for View XXMX_HCM_LEARN_COURSE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_LEARN_COURSE_V" ("METADATA") AS 
  SELECT 'METADATA|CourseV3|FLEX:WLF_LEARNING_ITEM|CourseCategory(WLF_LEARNING_ITEM=Global Data Elements)|EffectiveStartDate|EffectiveEndDate|CourseNumber|Title|ShortDescription|OwnedByPersonNumber|SourceSystemOwner|SourceSystemId' METADATA from dual
union ALL
SELECT distinct 'MERGE|CourseV3|Global Data Elements|'|| REGEXP_REPLACE ( PRIMARY_CATEGORY, '[^[:print:]]', '' )||'|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|'||EFFECTIVE_END_DATE||'|'||
COURSE_NUMBER||'|'||REPLACE(TITLE,'|','-')||'|'||REGEXP_REPLACE (DESCRIPTION, '[^[:print:]]', '')||'|50'||'|EBS|COURSE-'||COURSE_NUMBER
FROM XXMX_OLM_COURSE_STG --where COURSE_NUMBER in (261,255507,259508,404511)
UNION ALL
SELECT 'METADATA|OfferingV3|EffectiveStartDate|EffectiveEndDate|OfferingNumber|Title|OfferingType|OfferingStartDate|OfferingEndDate|LanguageCode|CoordinatorNumber|CourseId(SourceSystemId)|OwnedByPersonNumber|PrimaryLocationNumber|SourceSystemOwner|SourceSystemId' METADATA from dual
UNION ALL
/*SELECT distinct 'MERGE|OfferingV3|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|4712/12/31|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'|'||REPLACE(TITLE,'|','-')
||'|ORA_SP|'||COURSE_START_DATE||'|'||NVL(COURSE_END_DATE,'4712/12/31')||'|US|50|'||'COURSE-'||COURSE_NUMBER||'|50'||'|OLC227581|EBS|CLASS-'||ACTIVITY_VERSION_ID
FROM XXMX_OLM_CLASS_STG WHERE COURSE_START_DATE < '07-JUNE-2023' ---PAST OFFERINGS
UNION ALL
SELECT distinct 'MERGE|OfferingV3|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|4712/12/31'||'|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'|'||REPLACE(TITLE,'|','-')
||'|ORA_ILT|'||COURSE_START_DATE||'|'||NVL(COURSE_END_DATE,'4712/12/31')||'|US|50|'||'COURSE-'||COURSE_NUMBER||'|50'||'|OLC227581|EBS|CLASS-'||ACTIVITY_VERSION_ID
FROM XXMX_OLM_CLASS_STG WHERE COURSE_START_DATE >= '07-JUNE-2023'
*/-- FUTURE DATED
SELECT distinct 'MERGE|OfferingV3|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|4712/12/31'||'|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'|'||REPLACE(TITLE,'|','-')
||'|ORA_ILT|'||COURSE_START_DATE||'|'||NVL(COURSE_END_DATE,'4712/12/31')||'|US|50|'||'COURSE-'||COURSE_NUMBER||'|50'||'|OLC227581|EBS|CLASS-'||ACTIVITY_VERSION_ID
FROM XXMX_OLM_CLASS_STG WHERE 1=1
UNION ALL
SELECT 'METADATA|OfferingActivitySectionV3|OfferingSectionNumber|OfferingNumber|Title|EffectiveStartDate|EffectiveEndDate|SequenceRuleType|SectionPosition|CompletionRuleType' METADATA FROM DUAL
UNION ALL
SELECT DISTINCT 'MERGE|OfferingActivitySectionV3|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'_SEC|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER
||'|'||REPLACE(TITLE,'|','\|')||'|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|4712/12/31|ORA_SECTION_ANYTIME|'||DENSE_RANK() over (partition by course_number order by ACTIVITY_VERSION_ID)||'|ORA_COMPLETION_ACTIVITY'
FROM XXMX_OLM_CLASS_STG-- WHERE COURSE_START_DATE >= '07-JUNE-2023'
UNION ALL
/*SELECT 'METADATA|SelfPacedActivityV3|EffectiveStartDate|ActivityNumber|ActivityPosition|Title|ExpectedEffort|SelfCompleteFlag|OfferingNumber|OfferingId(SourceSystemId)|SourceSystemOwner|SourceSystemId' METADATA from dual
UNION ALL
SELECT DISTINCT 'MERGE|SelfPacedActivityV3|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|SP-ACT-'||COURSE_NUMBER||'-'||REGEXP_REPLACE(COURSE_START_DATE,'[^0-9]','')||'|'||
dense_rank() over (partition by COURSE_NUMBER order by TO_DATE(COURSE_START_DATE,'RRRR/MM/DD'))||'|'||REPLACE(TITLE,'|','-')||'|8|N|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'|CLASS-'||ACTIVITY_VERSION_ID||'|EBS|SPA-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER
FROM XXMX_OLM_CLASS_STG WHERE COURSE_START_DATE < '09-MAY-2023' 
UNION ALL*/
SELECT 'METADATA|InstructorLedActivityV3|EffectiveStartDate|ActivityNumber|Title|ClassroomResourceNumber|ActivityPosition|ActivityDate|ActivityStartTime|ActivityEndTime|TimeZone|OfferingSectionNumber' METADATA from dual
UNION ALL
SELECT distinct 'MERGE|InstructorLedActivityV3|'||TO_CHAR(SYSDATE,'RRRR/MM/DD')||'|ILT-'||COURSE_NUMBER||'-'||DENSE_RANK() over (partition by course_number order by ACTIVITY_VERSION_ID)||'|'||
REPLACE(TITLE,'|','-')||'||'||DENSE_RANK() over (partition by course_number order by TO_DATE(COURSE_START_DATE,'RRRR/MM/DD'))
||'|'||COURSE_START_DATE||'|'||COURSE_START_TIME||'|'||COURSE_END_TIME||'|'||TIMEZONE||'|OFF-'||ACTIVITY_VERSION_ID||'-'||COURSE_NUMBER||'_SEC'
FROM XXMX_OLM_CLASS_STG-- WHERE COURSE_START_DATE >= '07-JUNE-2023'  
UNION ALL
SELECT 'METADATA|InstructorReservationV3|InstructorReservationNumber|InstructorResourceNumber|ActivityNumber' METADATA from dual
UNION ALL
select distinct  'MERGE|InstructorReservationV3|INSTR-'||COURSE_NUMBER||'-'||row_number() over (partition by course_number order by course_number)
||'|'||NVL(INSTRUCTOR_NUMBER,50)||'|ILT-'||COURSE_NUMBER||'-'||DENSE_RANK() over (partition by course_number order by ACTIVITY_VERSION_ID)
FROM XXMX_OLM_CLASS_STG --WHERE COURSE_START_DATE >= '07-JUNE-2023'
;
