--------------------------------------------------------
--  DDL for View XXMX_HCM_GOAL_ASSIGNMENTS_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_GOAL_ASSIGNMENTS_HDL_V" ("METADATA") AS 
  SELECT 'METADATA|GoalPlanAssignment|SourceSystemId|SourceSystemOwner|GoalPlanExternalId|WorkerAssignmentNumber|Status' METADATA FROM DUAL
UNION ALL
SELECT UNIQUE 'MERGE|GoalPlanAssignment|GPA_'||PERSONNUMBER||'_1|EBS|300000060760247|'||ASSIGNMENT_NUMBER||'|ACTIVE' 
FROM xxmx_per_goal_stg
;
