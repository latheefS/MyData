CREATE TABLE XXMX_CORE.XXMX_SUPPLIER_SCOPE AS
with
eligible_org_id_list as
(
select distinct
haou.organization_id as org_id,
haou.name as operating_unit_name
from
apps.hr_all_organization_units@xxmx_extract haou,
apps.hr_organization_information@xxmx_extract hoi
where 1 = 1
and hoi.organization_id = haou.organization_id
and hoi.org_information1 = 'OPERATING_UNIT'
and haou.name in
(
select distinct xsou.parameter_value
from -- xxmx_core.xxmx_source_operating_units xsou
xxmx_core.xxmx_migration_parameters xsou
where nvl(xsou.enabled_flag, 'N') = 'Y'
and application_suite = 'FIN'
and application = 'ALL'
and xsou.parameter_code = 'ORGANIZATION_NAME'
)

),
eligible_supplier_types_list as
(
select xmp3.parameter_value                             as vendor_type_lookup_code
from   xxmx_core.xxmx_migration_parameters  xmp3
where  xmp3.application_suite      = 'FIN'  
and    xmp3.application            = 'AP'
and    xmp3.business_entity        = 'SUPPLIERS'
and    xmp3.sub_entity             = 'ALL'
and    xmp3.parameter_code         = 'VENDOR_TYPE'
and    NVL(xmp3.enabled_flag, 'N') = 'Y'
)
select
    aps.vendor_id                            as vendor_id,
    aps.segment1                             as vendor_number,
    aps.vendor_name                          as vendor_name,
    aps.vendor_type_lookup_code              as vendor_type,
    aps.party_id                             as party_id,
    apssa.org_id                             as org_id,
    hraou.name                               as operating_unit_name,
    apssa.vendor_site_id                     as vendor_site_id,
    apssa.vendor_site_code                   as vendor_site_code,
    apssa.party_site_id                      as party_site_id
from
                eligible_supplier_types_list                    sup_type,
                eligible_org_id_list                            orgs,
                apps.ap_suppliers@xxmx_extract                  aps,
                apps.ap_supplier_sites_all@xxmx_extract         apssa,
                apps.hr_all_organization_units@xxmx_extract     hraou
where  aps.vendor_id = apssa.vendor_id
and    aps.enabled_flag                              = 'Y'                                         /* Enabled Suppliers */
and    nvl(aps.end_date_active,sysdate+1)            > sysdate                                     /* Active supplier  within start and end date */
and    NVL(aps.one_time_flag,'N')                    = 'N'                                         /* Omit One Time Suppliers */
and    nvl(apssa.inactive_date+1,sysdate+1)          > sysdate                                     /* Active supplier site */
and    hraou.organization_id                         = apssa.org_id
and    orgs.org_id                                   = apssa.org_id                                /* Eligible organisations */
and    sup_type.vendor_type_lookup_code              = NVL(aps.vendor_type_lookup_code, '#NULL')
and   (apssa.rfq_only_site_flag                     = 'Y'
       or
       apssa.purchasing_site_flag                   = 'Y'
       or
       apssa.pay_site_flag                          = 'Y'
       );