XFM - Address Validation:

In SQL Developer run the following commands
truncate table xxmx_entity_validation_errors;
execute XXMX_AR_CUSTOMERS_CM_PKG.validate_location_address_frmt('XFM');
select * from xxmx_entity_validation_errors;

Run The following SQL then export to excel.
select 
column_name,error_message,location_orig_system_reference,country,address1,address2,address3,address4,city,state,province,county,postal_code
    from XXMX_XFM.xxmx_hz_locations_xfm xfm ,xxmx_entity_validation_errors err
    where err.entity_code='CUSTOMERS' 
    and err.sub_entity_code='LOCATION'
    and err.key_value=xfm.location_orig_system_reference


Double Quotes in extracted data:

Run The following SQL then export to excel.
select 'XXMX_HZ_PARTIES_XFM' as table_name, 'ORGANIZATION_NAME' as column_name, 
organization_name as value 
from XXMX_XFM.xxmx_hz_parties_xfm where organization_name like '%"%'
union
select 'XXMX_HZ_CUST_ACCOUNTS_XFM','ACCOUNT_NAME',account_name 
from XXMX_XFM.xxmx_hz_cust_accounts_xfm where account_name like '%"%'
union
select 'XXMX_HZ_LOCATIONS_XFM','ADDRESS1',address1 
from XXMX_XFM.xxmx_hz_locations_xfm where address1 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_XFM','ADDRESS2', address2 from XXMX_xfm.xxmx_hz_locations_xfm where address2 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_XFM'    , 'ADDRESS3'         , address3 from XXMX_XFM.xxmx_hz_locations_xfm where address3 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_XFM'    , 'ADDRESS4'         , address4 from XXMX_XFM.xxmx_hz_locations_xfm where address4 like '%"%'
union
select 'XXMX_HZ_LOCATIONS_XFM'    , 'CITY'             , city from XXMX_XFM.xxmx_hz_locations_xfm where city like '%"%'
;


Data Integrity Validation:

In SQL Developer run the following commands
truncate table xxmx_entity_validation_errors;
execute XXMX_AR_CUSTOMERS_CM_PKG.validate_hz_tab_ref_integrity(<migration_id>);
select * from xxmx_entity_validation_errors;

Run The following SQL then export to excel.
select * from xxmx_entity_validation_errors;