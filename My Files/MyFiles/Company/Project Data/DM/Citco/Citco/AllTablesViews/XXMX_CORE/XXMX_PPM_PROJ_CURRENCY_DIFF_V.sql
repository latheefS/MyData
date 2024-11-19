--------------------------------------------------------
--  DDL for View XXMX_PPM_PROJ_CURRENCY_DIFF_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PROJ_CURRENCY_DIFF_V" ("PROJECT_NUMBER") AS 
  select distinct project_number from xxmx_ppm_projects_Stg p
where  exists (
select 1 from xxmx_ppm_prj_lbrcost_stg l
where denom_currency_code <>  project_currency_code
and p.project_number =  l.project_number
)
or exists (
select 1 from xxmx_ppm_prj_misccost_stg m
where m.denom_currency_code <> p.project_currency_code
and p.project_number =  m.project_number
)
or exists (
select 1 from xxmx_ppm_prj_billevent_stg b
where b.bill_trns_currency_code <> p.project_currency_code
and p.project_number =  b.project_number
)
;
