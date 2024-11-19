--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_CARRYOVER_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_CARRYOVER_V" ("HDL_DATA") AS 
  select 
'METADATA|PersonAccrualDetail|PersonNumber|WorkTermsNumber|PlanName|AccrualType|ProcdDate|Value|AdjustmentReason' hdl_data
FROM DUAL
UNION all
SELECT DISTINCT
'MERGE|PersonAccrualDetail|'
||a.personnumber||'|'||WORKTERMSNUMBER||'|'||
decode(substr(b.position_code,1,2)
    , 'NL', 'Vacation Plan - Statutory'
    ,'US'
    ,decode(m.output_code_1, 'Citco Technology Management, Inc.','Vacation Plan Group1' 
                ,'Citco Fund Services (USA) Inc.','Vacation Plan Group1' 
                ,'Citco Fund Services (San Francisco), Inc.','Vacation Plan Group2' 
                ,'Citco Fund Services (Malvern) Inc.','Vacation Plan Group4'
                ,'Citco Corporate Services Inc., Miami','Vacation Plan Group1'
                ,'Vacation Plan'
            )
,'Vacation Plan'
)||'|'||
accrualtype||'|'||
TO_CHAR(PROCDDATE,'yyyy/mm/dd')||'|'||
VALUE||'|'||
'Data Migration - Carryover'
from xxmx_carry_over_xfma a
    , xx_position_map_temp b
    , xxmx_mapping_master  m
    ,xxmx_per_persons_xfm p
    , xxmx_per_assignments_m_xfm af
where --substr(b.position_code,1,2)  ='US'
a.personnumber =  b.gen1
--and personnumber='6912'
and category_code(+) = 'LE_BU' 
and a.bg_name = output_code_2(+)
and p.personnumber=a.personnumber
and af.personnumber = a.personnumber
and af.action_code='CURRENT'
and  a.bg_name is not null
and start_date < TO_date('01/01/2024','dd/mm/yyyy')
AND a.personnumber NOT IN
(select distinct person_number from xxmx_per_sal_hist_worker_stg
union
select distinct person_number from xxmx_per_ppm_worker_stg)
--GLB_TRANSFERS
/*  select 
'METADATA|PersonAccrualDetail|PersonNumber|WorkTermsNumber|PlanName|AccrualType|ProcdDate|Value|AdjustmentReason' hdl_data
FROM DUAL
UNION all
SELECT DISTINCT
'MERGE|PersonAccrualDetail|'
||a.personnumber||'|'||WORKTERMSNUMBER||'|'||
decode(substr(b.position_code,1,2)
    , 'NL', 'Vacation Plan - Statutory'
    ,'US'
    ,decode(m.output_code_1, 'Citco Technology Management, Inc.','Vacation Plan Group1' 
                ,'Citco Fund Services (USA) Inc.','Vacation Plan Group1' 
                ,'Citco Fund Services (San Francisco), Inc.','Vacation Plan Group2' 
                ,'Citco Fund Services (Malvern) Inc.','Vacation Plan Group4'
                ,'Citco Corporate Services Inc., Miami','Vacation Plan Group1'
                ,'Vacation Plan'
            )
,'Vacation Plan'
)||'|ADJOTH|'||
TO_CHAR(PROCDDATE,'yyyy/mm/dd')||'|'||
VALUE||'|'||'CITCO_8'
from xxmx_carry_over_xfma a
    , xx_position_map_temp b
    , xxmx_mapping_master  m
    ,xxmx_per_persons_xfm p
    , xxmx_per_assignments_m_xfm af
where --substr(b.position_code,1,2)  ='US'
a.personnumber =  b.gen1
--and personnumber='6912'
and category_code(+) = 'LE_BU' 
and a.bg_name = output_code_2(+)
and p.personnumber=a.personnumber
and af.personnumber = a.personnumber
and af.action_code='CURRENT'
and  a.bg_name is not null
and start_date < TO_date('01/01/2024','dd/mm/yyyy')
AND a.personnumber IN
(select distinct person_number from xxmx_per_sal_hist_worker_stg
union
select distinct person_number from xxmx_per_ppm_worker_stg);*/
;
