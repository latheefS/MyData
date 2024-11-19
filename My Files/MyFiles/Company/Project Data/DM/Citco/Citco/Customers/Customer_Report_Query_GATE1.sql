STG Address Validation:

In SQL Developer run the following commands
truncate table xxmx_entity_validation_errors;
execute XXMX_AR_CUSTOMERS_CM_PKG.validate_location_address_frmt('STG');
select * from xxmx_entity_validation_errors;

Run The following SQL then export to excel.
select 
column_name,error_message,location_orig_system_reference,country,address1,address2,address3,address4,city,state,province,county,postal_code
    from XXMX_STG.xxmx_hz_locations_stg stg ,xxmx_entity_validation_errors err
    where err.entity_code='CUSTOMERS' 
    and err.sub_entity_code='LOCATION'
    and err.key_value=stg.location_orig_system_reference;


STG - Double Quotes in extracted data:

Run The following SQL then export to excel.
select 'XXMX_HZ_PARTIES_STG' as table_name, 'ORGANIZATION_NAME' as column_name, 
organization_name as value 
from XXMX_STG.xxmx_hz_parties_stg where organization_name like '%"%'
union
select 'XXMX_HZ_CUST_ACCOUNTS_STG','ACCOUNT_NAME',account_name 
from XXMX_STG.xxmx_hz_cust_accounts_stg where account_name like '%"%'
union
select 'XXMX_HZ_LOCATIONS_STG','ADDRESS1',address1 
from XXMX_STG.xxmx_hz_locations_stg where address1 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_STG','ADDRESS2', address2 from XXMX_stg.xxmx_hz_locations_stg where address2 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_STG'    , 'ADDRESS3'         , address3 from XXMX_STG.xxmx_hz_locations_stg where address3 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_STG'    , 'ADDRESS4'         , address4 from XXMX_STG.xxmx_hz_locations_stg where address4 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_STG'    , 'CITY'             , city from XXMX_STG.xxmx_hz_locations_stg where city like '%"%'
;