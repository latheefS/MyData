
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HISTRATE_LEDGER_SCOPE_V" ("LEGAL_ENTITY_ID", "LEGAL_ENTITY", "LEDGER_NAME", "OPERATING_UNIT_NAME", "COUNTRY_CODE") AS 
  select null legal_entity_id,
null legal_entity,
parameter_value ledger_name,
null operating_unit_name,
null country_code 
from xxmx_migration_parameters 
where application_suite = 'FIN' 
and application = 'GL' 
and business_entity = 'HISTORICAL_RATES'
and parameter_code = 'LEDGER_NAME'
and sub_entity = 'HISTORICAL_RATES'
and enabled_flag = 'Y';


  GRANT SELECT ON "XXMX_CORE"."XXMX_HISTRATE_LEDGER_SCOPE_V" TO "XXMX_READONLY";
