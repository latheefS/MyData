--------------------------------------------------------
--  DDL for View XXMX_PPM_RATE_OVERRIDES_XFM_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_RATE_OVERRIDES_XFM_V" ("CONTRACT_NUMBER", "CONTRACT_ID", "CONT_MAJOR_VERSION", "BILL_PLAN_ID", "BP_MAJOR_VERSION", "PROJECT_NUMBER") AS 
  select pccb.contract_number,
       pccb.contract_id,
       pccb.cont_major_version,
       pccb.bill_plan_id,
       pccb.bp_major_version,
       pao.project_number 
from xxmx_ppm_rate_overrides_stg pao,
xxmx_ppm_cloud_cont_billplans pccb
where pao.project_number = pccb.contract_number
;
