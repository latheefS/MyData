--------------------------------------------------------
--  DDL for View XXMX_CLOUD_CONTRACTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CLOUD_CONTRACTS_V" ("CONTRACT_NUMBER", "CONTRACT_ID", "STS_CODE", "INV_TRX_TYPE_ID") AS 
  select distinct b.contract_number,b.contract_id , sts_code,inv_trx_type_id
from 
xxmx_ppm_cloud_contracts b
where 1=1
--and sts_code IN ('DRAFT','ACTIVE')
--and attribute10 LIKE  'CLOSED%'
--and a.contract_number =  b.contract_number
and contract_number = '4027744'
--and inv_trx_type_id = 300000064515203
and sts_code = 'ACTIVE'
;
