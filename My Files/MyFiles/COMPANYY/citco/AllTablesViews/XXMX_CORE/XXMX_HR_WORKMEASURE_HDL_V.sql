--------------------------------------------------------
--  DDL for View XXMX_HR_WORKMEASURE_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_WORKMEASURE_HDL_V" ("METADATA") AS 
  select 'METADATA|AssignmentWorkMeasure|SourceSystemId|SourceSystemOwner|AssignmentNumber|EffectiveEndDate|EffectiveStartDate|Unit|Value' METADATA 
  from dual
union ALL
select DISTINCT 'MERGE|AssignmentWorkMeasure|Assignment-'||nvl(max_asg_num,ASSIGNMENT_NUMBER)||'_FTE|EBS|'||nvl(max_asg_num,ASSIGNMENT_NUMBER)||'|'||
to_CHAR(a.EFFECTIVE_END_DATE,'YYYY/MM/DD')||'|'||
CASE WHEN UPPER(SYSTEM_PERSON_TYPE) = 'CWK' THEN to_CHAR(p.START_DATE,'YYYY/MM/DD') 
ELSE to_CHAR(a.EFFECTIVE_START_DATE,'YYYY/MM/DD') END
||'|FTE|'||NVL(ROUND(NORMAL_HOURS/decode(a.business_unit_name,'IE1520',39,'IE2690',40,'IE4350',40,'IE5500',40,'SG6770',40,
'BM2300',35,'BS7920',35,'IE3220',40,'BS4400',40,'BS2270',35,'BM7600',40,'SG2750',37.5,'IE2470',40,leh.working_hours),2 ),1)
FROM XXMX_PER_ASSIGNMENTS_M_XFMA a, 
    XXMX_PER_PERSONS_STG p, xxmx_hcm_le_hours leh
    ,XX_HISTORY_MAX_ASG_NUM s
where a.action_code IN ('CURRENT') 
and a.person_id= p.person_id
and s.person_number(+)= a.personnumber
and substr(a.position_code,1,2) =leh.legislation_code
UNION ALL
select DISTINCT 'MERGE|AssignmentWorkMeasure|Assignment-'||nvl(max_asg_num,ASSIGNMENT_NUMBER)||'_HEAD|EBS|'||nvl(max_asg_num,ASSIGNMENT_NUMBER)||'|'||
to_CHAR(a.EFFECTIVE_END_DATE,'YYYY/MM/DD')||'|'||CASE WHEN UPPER(SYSTEM_PERSON_TYPE) = 'CWK' THEN to_CHAR(p.START_DATE,'YYYY/MM/DD') 
ELSE to_CHAR(a.EFFECTIVE_START_DATE,'YYYY/MM/DD') END
||'|HEAD|'||decode(ASS_ATTRIBUTE2,'F',0,1)
FROM XXMX_PER_ASSIGNMENTS_M_XFMA a, XXMX_PER_PERSONS_STG p, XX_HISTORY_MAX_ASG_NUM s
where a.action_code IN ('CURRENT')
and s.person_number(+)= a.personnumber
and a.person_id= p.person_id
;
