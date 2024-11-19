
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CUSTOMER_SCOPE_V" ("ORG_ID", "OPERATING_UNIT_NAME", "CUST_ACCOUNT_ID", "ACCOUNT_NUMBER", "ACCOUNT_PARTY_ID", "CUST_ACCT_SITE_ID", "PARTY_NAME", "PARTY_SITE_ID", "PARTY_SITE_NUMBER", "PARTY_SITE_NAME", "LOCATION_ID") AS 
  with
-- ================================================================================
-- | VERSION1 |
-- ================================================================================
--
-- FILENAME
-- xxmx_ar_customer_scope_v.sql
--
-- DESCRIPTION
-- Create the custmer scope view
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ----------------------------
-- 20/01/2022 Michal Arrowsmith initial version
-- 25/01/2022 Michal Arrowsmith join between org and projets (1)
-- 25/01/2022 Michal Arrowsmith Add a select to return the internal customers (2)
-- 15/06/2023 Michal Arrowsmith Exclude account 999999
-- 31/08/2023 Michal Arrowsmith Exclude BANK usage in hz_party_usg_assignments
-- 13/10/2023 Meenakshi Rajendran Bug Fix - Refer JIRA ORACLD - 19490
-- 21/11/2023 Meenakshi Rajendran  Undo the change Exclude BANK usage in hz_party_usg_assignments (JIRA Ref - 19482)
-- =============================================================================*/
eligible_org_id_list as
(
select /*+ driving_site(haou) */ distinct
    haou.organization_id                                as org_id,
    haou.name                                           as operating_unit_name
from
    apps.hr_all_organization_units@xxmx_extract    haou,
    apps.hr_organization_information@xxmx_extract  hoi
where   1 = 1
and     hoi.organization_id   = haou.organization_id
and     hoi.org_information1  = 'OPERATING_UNIT'
and     haou.name            in
(
    select xsou.source_operating_unit_name
    from   xxmx_core.xxmx_source_operating_units  xsou
    where  nvl(xsou.CUST_migration_enabled_flag, 'N') = 'Y'
)
)
select /*+ driving_site(hzca) */
    hzcasa.org_id, 
    orgs.operating_unit_name, 
    hzca.cust_account_id, 
    hzca.account_number, 
    hzca.party_id account_party_id, 
    hzcasa.cust_acct_site_id,
    hzp.party_name, 
    hzcasa.party_site_id, 
    hzps.party_site_number, 
    hzps.party_site_name, 
    hzps.location_id
from
    eligible_org_id_list                            orgs,
    apps.hz_cust_accounts@xxmx_extract              hzca,
    apps.hz_cust_acct_sites_all@xxmx_extract        hzcasa,
    apps.hz_party_sites@xxmx_extract                hzps,
    apps.hz_parties@xxmx_extract                    hzp
where   hzca.status                             = 'A'
and     hzcasa.cust_account_id                  = hzca.cust_account_id
and     hzcasa.status                           = 'A'
and     hzps.party_site_id                      = hzcasa.party_site_id
and     orgs.org_id                             = hzcasa.org_id
and     hzp.party_id                            = hzps.party_id
and     hzca.account_number                     !='999999'
AND     hzca.party_id                           = hzp.party_id
and     exists
(
    select /*+ driving_site(papa) */ 1
    from
        apps.pa_projects_all@xxmx_extract       papa,
        apps.pa_proj_statuses_v@xxmx_extract    paps,
        apps.pa_project_customers@xxmx_extract  papc
    where   papa.org_id                     = hzcasa.org_id -- (1)
    and     papc.customer_id                = hzca.cust_account_id
    and     papa.project_id                 = papc.project_id
    and     paps.project_status_code        = papa.project_status_code
    and     paps.project_status_name        in ('Active','Inactive','Prospect','Outgoing')
)
--and		not exists
--(
--    select /*+ driving_site(papa) */ 1
--	from
--		hz_party_usg_assignments@xxmx_extract	hzpua
--	where	hzpua.party_id	=	hzp.party_id
--	and		hzpua.party_usage_code	= 'BANK'
--)
union
--
-- (2) Select below fetch all Internal active customers regardless of projects
select /*+ driving_site(hzca) */
    hzcasa.org_id, orgs.operating_unit_name, hzca.cust_account_id, hzca.account_number, hzca.party_id account_party_id, hzcasa.cust_acct_site_id,
    hzp.party_name, hzcasa.party_site_id, hzps.party_site_number, hzps.party_site_name, hzps.location_id
from
    eligible_org_id_list                            orgs,
    apps.hz_cust_accounts@xxmx_extract              hzca,
    apps.hz_cust_acct_sites_all@xxmx_extract        hzcasa,
    apps.hz_party_sites@xxmx_extract                hzps,
    apps.hz_parties@xxmx_extract                    hzp
where   hzca.status                             = 'A'
and     hzca.customer_type                      = 'I'
and     hzcasa.cust_account_id                  = hzca.cust_account_id
and     hzcasa.status                           = 'A'
and     hzps.party_site_id                      = hzcasa.party_site_id
and     orgs.org_id                             = hzcasa.org_id
and     hzp.party_id                            = hzps.party_id
AND     hzca.party_id                           = hzp.party_id;

