
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_LEARN_CERTIFICATION_V" ("METADATA") AS 
  SELECT 'METADATA|Specialization|EffectiveStartDate|EffectiveEndDate|SpecializationNumber|Title|'||
  'OwnedByPersonNumber|SourceSystemOwner|SourceSystemId' METADATA from dual
union all
SELECT distinct 'MERGE|Specialization|'||enrollment_date||'||CERT-'||
certification_name||'|'||CERTIFICATION_NAME||'|'||'50001'
||'|EBS|CERT-'||certification_name
from (
select certification_name, min (enrollment_date) enrollment_date from XXMX_OLM_CERTIFICATION_XFM group by certification_name)
union all
SELECT 'METADATA|SpecializationSection|EffectiveStartDate|SpecializationSectionNumber|Title'||
'|SectionPosition|NumberOfActivitiesToComplete|InitialAssignmentStatusOfActivities|SpecializationNumber'
FROM DUAL
union all
SELECT 'MERGE|SpecializationSection|EffectiveStartDate|SpecializationSectionNumber|Title'||
'|SectionPosition|NumberOfActivitiesToComplete|InitialAssignmentStatusOfActivities|SpecializationNumber'
FROM XXMX_OLM_CERTIFICATION_XFM
union all
SELECT 'METADATA|SpecializationSectionActivity|EffectiveStartDate|ActivityNumber|ActivityPosition'||
'|SpecializationSectionNumber|LearningItemNumber'
FROM DUAL;


  GRANT SELECT ON "XXMX_CORE"."XXMX_HCM_LEARN_CERTIFICATION_V" TO "XXMX_READONLY";
