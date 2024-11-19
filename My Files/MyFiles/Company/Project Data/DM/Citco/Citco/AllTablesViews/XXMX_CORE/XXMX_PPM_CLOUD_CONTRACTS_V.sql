--------------------------------------------------------
--  DDL for View XXMX_PPM_CLOUD_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_CLOUD_CONTRACTS_V" ("CONTRACT_ID", "CONTRACT_NUMBER", "STS_CODE", "UNDER_MIGRATION_FLAG", "INV_TRX_TYPE_ID", "AUTO_RELEASE_INVOICE", "ID") AS 
  select "CONTRACT_ID","CONTRACT_NUMBER","STS_CODE","UNDER_MIGRATION_FLAG","INV_TRX_TYPE_ID","AUTO_RELEASE_INVOICE","ID" from xxmx_ppm_cloud_contracts b --,  xxmx_ppm_projects_stg A
  where 1=1 
  --and a.organization_name <> 'DK5350'
  --and a.project_number =  b.contract_number
 -- and auto_release_invoice <> 'D'
  and sts_code = 'DRAFT'
;
