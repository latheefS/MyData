
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_JOBVITE_JOB_DESC_HDL_V" ("METADATA") AS 
  select 'METADATA|TalentProfile|ProfileCode|Summary|Description|ProfileTypeCode|ProfileStatusCode|ProfileUsageCode|SourceSystemOwner|SourceSystemId' METADATA FROM DUAL
UNION ALL
SELECT UNIQUE 'MERGE|TalentProfile|'||PROFILE_CODE||'|About the Team '||'&'||' Business Line: Fund Administration is Citco''s core business, and our alternative asset and accounting service is one of the industry''s most respected. Our continuous investment in learning and technology solutions means our people are equipped to deliver a seamless client experience. As a core member of our Fund Accounting team, you will be working with some of the industry''s most accomplished professionals to deliver award-winning services for complex fund structures that our clients can depend upon.|'
||DESCRIPTION||'|POSITION|A|M|EBS|TP-'||PROFILE_CODE FROM XXMX_JOBVITE_JOB_DESC_STG WHERE POSITION_DESCRIPTION IS NOT NULL
and profile_code  in (select position_code from xxmx_positions_cloud)  
UNION ALL
SELECT 'METADATA|ProfileRelation|ProfileCode|RelationCode|BusinessUnitName|PositionCode|ObjectEffectiveStartDate|SourceSystemOwner|SourceSystemId' FROM DUAL
UNION ALL
SELECT UNIQUE 'MERGE|ProfileRelation|'||PROFILE_CODE||'|POSITION|'||SUBSTR(PROFILE_CODE,1,6)||'|'||PROFILE_CODE||'|2020/01/01|EBS|PR-'||PROFILE_CODE FROM XXMX_JOBVITE_JOB_DESC_STG
WHERE POSITION_DESCRIPTION IS NOT NULL and profile_code  in (select position_code from xxmx_positions_cloud)  
UNION ALL
SELECT 'METADATA|ModelProfileExtraInfo|ProfileCode|Description|Responsibilities|Qualifications|SourceSystemOwner|SourceSystemId' FROM DUAL
UNION ALL
SELECT UNIQUE 'MERGE|ModelProfileExtraInfo|'||PROFILE_CODE||'|'||POSITION_DESCRIPTION||'.html|'||POSITION_RESPONSIBILITY||'|'||POSITION_QUALIFICATION||'|EBS|MP-'||PROFILE_CODE
FROM XXMX_JOBVITE_JOB_DESC_STG WHERE POSITION_DESCRIPTION IS NOT NULL
and profile_code  in (select position_code from xxmx_positions_cloud);

