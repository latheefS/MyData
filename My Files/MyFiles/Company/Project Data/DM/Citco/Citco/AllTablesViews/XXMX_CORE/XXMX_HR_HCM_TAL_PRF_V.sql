--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_TAL_PRF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_TAL_PRF_V" ("HDL_DATA") AS 
  SELECT 'METADATA|TalentProfile|ProfileCode|ProfileStatusCode|ProfileUsageCode|SourceSystemOwner|SourceSystemId|PersonNumber|ProfileTypeCode' hdl_data
  FROM DUAL
  UNION all
  select distinct 'MERGE|TalentProfile|'||
 -- profile_id||'|'||
  'PERF_RATING_'||person_number||'|'||
  'A|P|||'||
  person_number
  ||'|PERSON'
  FROM XXMX_PER_PROFILE_ITEM_XFM
  union all
 select 'METADATA|ProfileItem|ContentTypeId|DateFrom|DateTo|ProfileCode|SourceType|SourceSystemOwner|SourceSystemId|RatingModelCode1|RatingLevelCode1|SectionId'
  from dual
  union ALL
  select 
  'MERGE|ProfileItem|'||
  CONTENTTYPEID||'|'||
  to_char(datefrom, 'yyyy/mm/dd') ||'|'||
  to_char(dateto, 'yyyy/mm/dd') ||'|'||
  'PERF_RATING_'||person_number||'|'||
  'HRA|EBS|'||
  'ProfileItem-'||person_number||'-'||to_char(datefrom, 'yyyy/mm/dd')
  ||'|PERFORMANCE|'
  ||ratinglevelcode1||'|'  
  ||'12501'
  FROM XXMX_PER_PROFILE_ITEM_XFM
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_TAL_PRF_V" TO "XXMX_READONLY";
