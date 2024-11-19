--------------------------------------------------------
--  DDL for View XXMX_PPM_CONTRACT_ACT_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_CONTRACT_ACT_V" ("OUTPUT") AS 
  select 'StsCode,ContractPuid,ContributionPercent' OUTPUT from dual
union all
select 'ACTIVE,'||PROJECT_NUMBER||'_HEK,100' from xxmx_ppm_projects_xfm where attribute1 <> '999999'
;
