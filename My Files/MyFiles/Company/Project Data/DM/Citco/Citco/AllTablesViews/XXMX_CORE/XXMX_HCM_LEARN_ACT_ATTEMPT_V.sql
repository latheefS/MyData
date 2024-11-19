--------------------------------------------------------
--  DDL for View XXMX_HCM_LEARN_ACT_ATTEMPT_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_LEARN_ACT_ATTEMPT_V" ("METADATA") AS 
  SELECT 'METADATA|LearningRecordActivityAttempt|LearningRecordNumber|ActivityNumber|ActivityAttemptDate|ActivityAttemptStatus' METADATA FROM DUAL
UNION ALL
SELECT 'MERGE|LearningRecordActivityAttempt|LR_NUM_'||ENROLLMENT_NUMBER||'|ILT-'||COURSE_CODE||'-'||dense_rank() over (partition by course_code order by event_id)||'|'||
to_char(to_date(CLASS_START_DATE,'DD-MON-RRRR HH24:MI:SS'),'YYYY/MM/DD')||'|ORA_ASSN_TASK_NOT_COMPLETED'
FROM XXMX_LEARNER_RECORDS_STG WHERE COURSE_CODE IN(SELECT COURSE_NUMBER FROM XXMX_OLM_CLASS_STG )
and enrollment_status ='Enrolled'
;
