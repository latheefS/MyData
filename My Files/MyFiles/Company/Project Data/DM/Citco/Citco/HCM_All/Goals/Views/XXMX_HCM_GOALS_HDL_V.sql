
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_GOALS_HDL_V" ("METADATA") AS 
  SELECT 'METADATA|Goal|GoalTypeCode|GoalName|LongDescriptionFile|GoalVersionTypeCode|StartDate|TargetCompletionDate|WorkerPersonNumber|WorkerAssignmentNumber|AssignedByPersonNumber|PrivateFlag|GoalSourceCode|CategoryCode|StatusCode|PriorityCode|SuccessCriteriaFile|CommentsFile|SourceSystemOwner|SourceSystemId|AllowKeyAttrUpdateFlag' METADATA FROM DUAL
UNION ALL
SELECT 'MERGE|Goal|PERFORMANCE|'||REPLACE(REPLACE(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),'''',''''''),'|','\|')||'|'||PERSONNUMBER||'_'||NAME_1||'_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,name_1)
||'.html|ACTIVE|'||START_DATE||'|'||TARGET_DATE||'|'||PERSONNUMBER||'|'||ASSIGNMENT_NUMBER||'|'||ASSIGNED_BY_PERSON_NUM||'|'||PRIVATE_FLAG||'|'||GOAL_SOURCE_CODE
||'|'||CATEGORY_CODE||'|'||STATUS_CODE||'|'||PRIORITY_CODE||'|'||
CASE WHEN SUCCESS_CRITERIA IS NOT NULL THEN PERSONNUMBER||'_'||SC_NAME||'_SC_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,SC_NAME)||'.html' ELSE NULL END||'|'||
CASE WHEN COMMENTS IS NOT NULL THEN PERSONNUMBER||'_'||CMT_NAME||'_CMT_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,CMT_NAME)||'.html' ELSE NULL END||
'|EBS|G_'||PERSONNUMBER||'_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,NAME)||'|'||ALLOWKEYFLAG
  FROM
(SELECT NAME,SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25) NAME_1
      , PERSONNUMBER,TO_CHAR(START_DATE,'RRRR/MM/DD') START_DATE,TO_CHAR(TARGET_DATE,'RRRR/MM/DD') TARGET_DATE,ASSIGNMENT_NUMBER,ASSIGNED_BY_PERSON_NUM,PRIVATE_FLAG,GOAL_SOURCE_CODE
      , COMMENTS, SUCCESS_CRITERIA
      ,case when SUCCESS_CRITERIA is not null 
            then SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25)
       else null end SC_NAME
       ,case when COMMENTS is not null 
            then SUBSTR(REGEXP_REPLACE(replace(REGEXP_REPLACE (NAME, '[^[:print:]]', ''),' ',''),'[^A-Z]','',1,0,'i'),1,25)
       else null end CMT_NAME,ALLOWKEYFLAG
  ,DECODE(CATEGORY,'CV','CITCO_VALUES','PER','CITCO_PERSONAL_OBJECTIVE',NULL) CATEGORY_CODE,STATUS_CODE,PRIORITY_CODE
  FROM (SELECT UNIQUE NAME, DETAIL, START_DATE, TARGET_DATE, PERSONNUMBER, ASSIGNMENT_NUMBER, PRIORITY_CODE, CATEGORY, WEIGHTING_PERCENT, SUCCESS_CRITERIA, COMMENTS
       ,STATUS_CODE,ALLOWKEYFLAG,GOAL_SOURCE_CODE,PRIVATE_FLAG,ASSIGNED_BY_PERSON_NUM
  FROM xxmx_per_goal_XFM ST 
  WHERE PERSONNUMBER='10007'
  ))
UNION ALL
SELECT 'METADATA|GoalPlanGoal|SourceSystemId|SourceSystemOwner|GoalId(SourceSystemId)|GoalPlanName|Weighting|GoalPlanStartDate|GoalPlanEndDate' METADATA FROM DUAL
UNION ALL
SELECT 'MERGE|GoalPlanGoal|GP_'||PERSONNUMBER||'_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,NAME)||'|EBS|G_'||PERSONNUMBER||'_'||row_number() over (partition by PERSONNUMBER order by PERSONNUMBER,NAME)
||'|2024 Citco Annual Performance Goal Plan|'||WEIGHTING_PERCENT||'|2023/11/01|2024/10/31' METADATA
FROM (SELECT UNIQUE ST.* FROM xxmx_per_goal_XFM ST 
--WHERE PERSONNUMBER='10007'
);

