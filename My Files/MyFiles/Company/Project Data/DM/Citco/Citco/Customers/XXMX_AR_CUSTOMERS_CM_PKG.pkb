create or replace PACKAGE BODY "XXMX_AR_CUSTOMERS_CM_PKG" AS
-- =============================================================================
-- | VERSION1 |
-- =============================================================================
--
-- FILENAME
-- XXMX_AR_CUSTOMERS_CM_PKG
--
-- DESCRIPTION
-- AR cash receipts extract
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ---------------------------
-- 10/10/2022 Michal Arrowsmith Set_code changed from Country code _CITCO to
--                              OU short code
-- 17/10/2022 Michal Arrowsmith Add procedure update_migration_set_id to update
--                              the migration_set_id
-- 10/11/2022 Michal Arrowsmith 1 - As per discussion that Gate1 values should match 
--                              EBS and only changed by Gate2 The following updates.
--                              no longer runnin the procedure update_start_end_date.
--                              have been removed:
--                              REF-10112022-1
--                              2 - update_customer_site_ebs_values: no longer required
--                              REF-10112022-2
--                              3 - SET_CODE willbe set in GATE2 and not here
--                              REF-10112022-3
--                              4 - Remove attribute1-3 from the party extract
--                              REF-10112022-4
-- 11/11/2022 Michal Arrowsmith 1 - DFF for xxmx_hz_parties_stg is no longer required
--                              REF-11112022-1
-- 21/11/2022 Michal Arrowsmith 1 - Procedure create_ebilling_contacts:
--                                  Insert into xxmx_hz_contact_points_stg
--                                  Replace these two values with null so it match to EBS
--                                  Instead those two values will be set by CITCO in GATE2
--                                  'EMAIL'      = contact_point_type,
--                                  'BUSINESS'   = contact_point_purpose,
--                               REF-21112022-1
--                              2. Procedure update_cusomer_ebs_party
--                                 attribute1 will hold the party name
--                              REF-21112022-2
-- 22/11/2022 Michal Arrowsmith 1 - Procedure create_ebilling_contacts:
--                                  insert into xxmx_hz_relationships_stg
--                                  Citco prefer to have this col null so it matches EBS
--                                  They willset it to 31/12/4712 in Gate2
--                              REF-22112022-2
-- 24/11/2022 Michal Arrowsmith 1 - Improve performance create_ebilling_contacts
--                              REF-24112022-1
-- 06/12/2022 Michal Arrowsmith update_dff no longer required in gate1 but 
--                              moved to gate2 to be updated by citco
--                              REF-06122022-1
-- =============================================================================
--

     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_ar_customers_cm_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CUSTOMERS';
     gct_OrigSystem                            CONSTANT VARCHAR2(10)                                 := 'ORACLER12';
     gct_DefaultEmail                          CONSTANT VARCHAR2(50)                                 := 'invoiceemail@version1.com';
     gct_DefaultEmailFmt                       CONSTANT VARCHAR2(20)                                 := 'MAILTEXT';     
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                                       NUMBER;
     gvn_message                                        varchar2(2000);
     --
     --
-- -------------------------------------------------------------------------- --
-- ------------------------ update_migration_set_id ------------------------- --
-- -------------------------------------------------------------------------- --
procedure update_migration_set_id is
    cursor c_update is
        select 'update '||table_name||' set migration_set_id=migration_set_id+1' update_stmt
            from all_tables
            where owner='XXMX_XFM'
            and   table_name like 'XXMX_HZ%_XFM';
begin
    for r_update in c_update loop
        execute immediate r_update.update_stmt;
    end loop;
    update xxmx_dm_ess_job_definitions 
        set 
            parameter1=(select max(migration_set_id) from XXMX_HZ_CUST_PROFILES_XFM), 
            parameter2='BATCH-'||(select max(migration_set_id) from XXMX_HZ_CUST_PROFILES_XFM)
        where load_name='CUSTOMERS';
    commit;
end update_migration_set_id;
-- -------------------------------------------------------------------------- --
-- ------------------------- remove_timezone_code ------------------------- --
-- -------------------------------------------------------------------------- --
procedure remove_timezone_code
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'remove_timezone_code';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START remove_timezone_code';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        update xxmx_hz_locations_stg
            set timezone_code = null
            where migration_set_id = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END remove_timezone_code';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
    end remove_timezone_code;
     --
     --
PROCEDURE update_set_code
(
    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
)
IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_set_code';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        update xxmx_hz_cust_acct_sites_stg
            set set_code = ou_name
            where migration_set_id = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        update XXMX_HZ_CUST_SITE_USES_STG
            set set_code = ou_name
            where migration_set_id = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_set_code;
--
PROCEDURE update_customer_pk_values_with_suffix
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_i_suffix                     IN      varchar2
                    )
     IS
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'reload_same_customers';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
BEGIN
        --
        update xxmx_hz_locations_stg    stg
        set
            stg.location_orig_system_reference = decode(stg.location_orig_system_reference,null,null,stg.location_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_parties_stg    stg
        set
            stg.party_number                = stg.party_number||pt_i_suffix,
            stg.party_orig_system_reference = stg.party_orig_system_reference||pt_i_suffix,
            stg.organization_name           = decode(stg.organization_name,null,null,stg.organization_name||pt_i_suffix),
            stg.person_first_name           = decode(stg.person_first_name,null,null,stg.person_first_name||pt_i_suffix),
            stg.person_last_name            = decode(stg.person_last_name,null,null,stg.person_last_name||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_party_sites_stg    stg
        set
            stg.party_site_number              = decode(stg.party_site_number,null,null,stg.party_site_number||pt_i_suffix),
            stg.party_orig_system_reference    = decode(stg.party_orig_system_reference,null,null,stg.party_orig_system_reference||pt_i_suffix),
            stg.site_orig_system_reference     = decode(stg.site_orig_system_reference,null,null,stg.site_orig_system_reference||pt_i_suffix),
            stg.location_orig_system_reference = decode(stg.location_orig_system_reference,null,null,stg.location_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_party_site_uses_stg    stg
        set
            stg.party_orig_system_reference = decode(stg.party_orig_system_reference,null,null,stg.party_orig_system_reference||pt_i_suffix),
            stg.site_orig_system_reference = decode(stg.site_orig_system_reference,null,null,stg.site_orig_system_reference||pt_i_suffix),
            stg.siteuse_orig_system_ref = decode(stg.siteuse_orig_system_ref,null,null,stg.siteuse_orig_system_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_accounts_stg    stg
        set
            stg.cust_orig_system_reference  = decode(stg.cust_orig_system_reference,null,null,stg.cust_orig_system_reference||pt_i_suffix),
            stg.party_orig_system_reference = decode(stg.party_orig_system_reference,null,null,stg.party_orig_system_reference||pt_i_suffix),
            stg.account_number              = decode(stg.account_number,null,null,stg.account_number||pt_i_suffix),
            stg.account_name                = decode(stg.account_number,null,null,stg.account_name||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_sites_stg     stg
        set
            stg.cust_orig_system_reference = decode(stg.cust_orig_system_reference,null,null,stg.cust_orig_system_reference||pt_i_suffix),
            stg.cust_site_orig_sys_ref     = decode(stg.cust_site_orig_sys_ref,null,null,stg.cust_site_orig_sys_ref||pt_i_suffix),
            stg.site_orig_system_reference = decode(stg.site_orig_system_reference,null,null,stg.site_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_site_uses_stg    stg
        set
            stg.cust_site_orig_sys_ref    = decode(stg.cust_site_orig_sys_ref,null,null,stg.cust_site_orig_sys_ref||pt_i_suffix),
            stg.cust_siteuse_orig_sys_ref = decode(stg.cust_siteuse_orig_sys_ref,null,null,stg.cust_siteuse_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_profiles_stg     stg
        set
            stg.party_orig_system_reference = decode(stg.party_orig_system_reference,null,null,stg.party_orig_system_reference||pt_i_suffix),
            stg.cust_orig_system_reference  = decode(stg.cust_orig_system_reference,null,null,stg.cust_orig_system_reference||pt_i_suffix),
            stg.cust_site_orig_sys_ref      = decode(stg.cust_site_orig_sys_ref,null,null,stg.cust_site_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_relationships_stg      stg
        set
            stg.sub_orig_system_reference = decode(stg.sub_orig_system_reference,null,null,stg.sub_orig_system_reference||pt_i_suffix),
            stg.obj_orig_system_reference = decode(stg.obj_orig_system_reference,null,null,stg.obj_orig_system_reference||pt_i_suffix),
            stg.rel_orig_system_reference = decode(stg.rel_orig_system_reference,null,null,stg.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_contacts_stg    stg
        set
            stg.cust_orig_system_reference  = decode(stg.cust_orig_system_reference,null,null,stg.cust_orig_system_reference||pt_i_suffix),
            stg.cust_site_orig_sys_ref      = decode(stg.cust_site_orig_sys_ref,null,null,stg.cust_site_orig_sys_ref||pt_i_suffix),
            stg.cust_contact_orig_sys_ref   = decode(stg.cust_contact_orig_sys_ref,null,null,stg.cust_contact_orig_sys_ref||pt_i_suffix),
            stg.rel_orig_system_reference   = decode(stg.rel_orig_system_reference,null,null,stg.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_org_contacts_stg      stg
        set
            stg.rel_orig_system_reference  = decode(stg.rel_orig_system_reference,null,null,stg.rel_orig_system_reference||pt_i_suffix),
            stg.contact_number             = decode(stg.contact_number,null,null,stg.contact_number||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update  xxmx_hz_org_contact_roles_stg         stg
        set
            stg.contact_role_orig_sys_ref  = decode(stg.contact_role_orig_sys_ref,null,null,stg.contact_role_orig_sys_ref||pt_i_suffix),
            stg.rel_orig_system_reference  = decode(stg.rel_orig_system_reference,null,null,stg.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update  xxmx_hz_contact_points_stg               stg
        set
            stg.cp_orig_system_reference    = decode(stg.cp_orig_system_reference,null,null,stg.cp_orig_system_reference||pt_i_suffix),
            stg.party_orig_system_reference = decode(stg.party_orig_system_reference,null,null,stg.party_orig_system_reference||pt_i_suffix),
            stg.site_orig_system_reference  = decode(stg.site_orig_system_reference,null,null,stg.site_orig_system_reference||pt_i_suffix),
            stg.rel_orig_system_reference   = decode(stg.rel_orig_system_reference,null,null,stg.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_role_resps_stg    stg
        set
            stg.cust_contact_orig_sys_ref = decode(stg.cust_contact_orig_sys_ref,null,null,stg.cust_contact_orig_sys_ref||pt_i_suffix),
            stg.role_resp_orig_sys_ref    = decode(stg.role_resp_orig_sys_ref,null,null,stg.role_resp_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_relate_stg    stg
        set
            stg.cust_orig_system_reference=decode(stg.cust_orig_system_reference,null,null,stg.cust_orig_system_reference||pt_i_suffix),
            stg.CUST_ACCT_REL_ORIG_SYS_REF=decode(stg.CUST_ACCT_REL_ORIG_SYS_REF,null,null,stg.CUST_ACCT_REL_ORIG_SYS_REF||pt_i_suffix),
            stg.RELATED_CUST_ORIG_SYS_REF =decode(stg.RELATED_CUST_ORIG_SYS_REF,null,null,stg.RELATED_CUST_ORIG_SYS_REF||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_zx_tax_profile_stg 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix 
        where migration_set_name = pt_i_MigrationSetName;
        --
        update XXMX_ZX_TAX_REGISTRATION_stg 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_zx_party_classific_stg 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix
        where migration_set_name = pt_i_MigrationSetName;
        --
        commit;
exception
    when others then raise;
end update_customer_pk_values_with_suffix;
--
--
PROCEDURE update_migration_set_id (p_migration_set_id in number) is
begin
update XXMX_HZ_CUST_ACCT_RELATE_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_PARTY_CLASSIFS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_PERSON_LANGUAGE_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_LOCATIONS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_ORG_CONTACTS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CUST_PROFILES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_ROLE_RESPS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CUST_SITE_USES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_ORG_CONTACT_ROLES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_RELATIONSHIPS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CUST_ACCT_SITES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_PARTIES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CONTACT_POINTS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_PARTY_SITES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_PARTY_SITE_USES_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CUST_ACCT_CONTACTS_XFM set migration_set_id=p_migration_set_id;
update XXMX_HZ_CUST_ACCOUNTS_XFM set migration_set_id=p_migration_set_id;
update XXMX_ZX_TAX_PROFILE_XFM set migration_set_id=p_migration_set_id;
update XXMX_ZX_TAX_REGISTRATION_XFM set migration_set_id=p_migration_set_id;
update XXMX_ZX_PARTY_CLASSIFIC_XFM set migration_set_id=p_migration_set_id;end;

PROCEDURE update_customer_pk_values_with_suffix_xfm
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_i_suffix                     IN      varchar2
                    )
     IS
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'reload_same_customers';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
BEGIN
        --
        update xxmx_hz_locations_xfm    xfm
        set
            xfm.location_orig_system_reference = decode(xfm.location_orig_system_reference,null,null,xfm.location_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_parties_xfm    xfm
        set
            xfm.party_number                = xfm.party_number||pt_i_suffix,
            xfm.party_orig_system_reference = xfm.party_orig_system_reference||pt_i_suffix,
            xfm.organization_name           = decode(xfm.organization_name,null,null,xfm.organization_name||pt_i_suffix),
            xfm.person_first_name           = decode(xfm.person_first_name,null,null,xfm.person_first_name||pt_i_suffix),
            xfm.person_last_name            = decode(xfm.person_last_name,null,null,xfm.person_last_name||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_party_sites_xfm    xfm
        set
            xfm.party_site_number              = decode(xfm.party_site_number,null,null,xfm.party_site_number||pt_i_suffix),
            xfm.party_orig_system_reference    = decode(xfm.party_orig_system_reference,null,null,xfm.party_orig_system_reference||pt_i_suffix),
            xfm.site_orig_system_reference     = decode(xfm.site_orig_system_reference,null,null,xfm.site_orig_system_reference||pt_i_suffix),
            xfm.location_orig_system_reference = decode(xfm.location_orig_system_reference,null,null,xfm.location_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_party_site_uses_xfm    xfm
        set
            xfm.party_orig_system_reference = decode(xfm.party_orig_system_reference,null,null,xfm.party_orig_system_reference||pt_i_suffix),
            xfm.site_orig_system_reference = decode(xfm.site_orig_system_reference,null,null,xfm.site_orig_system_reference||pt_i_suffix),
            xfm.siteuse_orig_system_ref = decode(xfm.siteuse_orig_system_ref,null,null,xfm.siteuse_orig_system_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_accounts_xfm    xfm
        set
            xfm.cust_orig_system_reference  = decode(xfm.cust_orig_system_reference,null,null,xfm.cust_orig_system_reference||pt_i_suffix),
            xfm.party_orig_system_reference = decode(xfm.party_orig_system_reference,null,null,xfm.party_orig_system_reference||pt_i_suffix),
            xfm.account_number              = decode(xfm.account_number,null,null,xfm.account_number||pt_i_suffix),
            xfm.account_name                = decode(xfm.account_number,null,null,xfm.account_name||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_sites_xfm     xfm
        set
            xfm.cust_orig_system_reference = decode(xfm.cust_orig_system_reference,null,null,xfm.cust_orig_system_reference||pt_i_suffix),
            xfm.cust_site_orig_sys_ref     = decode(xfm.cust_site_orig_sys_ref,null,null,xfm.cust_site_orig_sys_ref||pt_i_suffix),
            xfm.site_orig_system_reference = decode(xfm.site_orig_system_reference,null,null,xfm.site_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_site_uses_xfm    xfm
        set
            xfm.cust_site_orig_sys_ref    = decode(xfm.cust_site_orig_sys_ref,null,null,xfm.cust_site_orig_sys_ref||pt_i_suffix),
            xfm.cust_siteuse_orig_sys_ref = decode(xfm.cust_siteuse_orig_sys_ref,null,null,xfm.cust_siteuse_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_profiles_xfm     xfm
        set
            xfm.party_orig_system_reference = decode(xfm.party_orig_system_reference,null,null,xfm.party_orig_system_reference||pt_i_suffix),
            xfm.cust_orig_system_reference  = decode(xfm.cust_orig_system_reference,null,null,xfm.cust_orig_system_reference||pt_i_suffix),
            xfm.cust_site_orig_sys_ref      = decode(xfm.cust_site_orig_sys_ref,null,null,xfm.cust_site_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_relationships_xfm      xfm
        set
            xfm.sub_orig_system_reference = decode(xfm.sub_orig_system_reference,null,null,xfm.sub_orig_system_reference||pt_i_suffix),
            xfm.obj_orig_system_reference = decode(xfm.obj_orig_system_reference,null,null,xfm.obj_orig_system_reference||pt_i_suffix),
            xfm.rel_orig_system_reference = decode(xfm.rel_orig_system_reference,null,null,xfm.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_contacts_xfm    xfm
        set
            xfm.cust_orig_system_reference  = decode(xfm.cust_orig_system_reference,null,null,xfm.cust_orig_system_reference||pt_i_suffix),
            xfm.cust_site_orig_sys_ref      = decode(xfm.cust_site_orig_sys_ref,null,null,xfm.cust_site_orig_sys_ref||pt_i_suffix),
            xfm.cust_contact_orig_sys_ref   = decode(xfm.cust_contact_orig_sys_ref,null,null,xfm.cust_contact_orig_sys_ref||pt_i_suffix),
            xfm.rel_orig_system_reference   = decode(xfm.rel_orig_system_reference,null,null,xfm.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_org_contacts_xfm      xfm
        set
            xfm.rel_orig_system_reference  = decode(xfm.rel_orig_system_reference,null,null,xfm.rel_orig_system_reference||pt_i_suffix),
            xfm.contact_number             = decode(xfm.contact_number,null,null,xfm.contact_number||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update  xxmx_hz_org_contact_roles_xfm         xfm
        set
            xfm.contact_role_orig_sys_ref  = decode(xfm.contact_role_orig_sys_ref,null,null,xfm.contact_role_orig_sys_ref||pt_i_suffix),
            xfm.rel_orig_system_reference  = decode(xfm.rel_orig_system_reference,null,null,xfm.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update  xxmx_hz_contact_points_xfm               xfm
        set
            xfm.cp_orig_system_reference    = decode(xfm.cp_orig_system_reference,null,null,xfm.cp_orig_system_reference||pt_i_suffix),
            xfm.party_orig_system_reference = decode(xfm.party_orig_system_reference,null,null,xfm.party_orig_system_reference||pt_i_suffix),
            xfm.site_orig_system_reference  = decode(xfm.site_orig_system_reference,null,null,xfm.site_orig_system_reference||pt_i_suffix),
            xfm.rel_orig_system_reference   = decode(xfm.rel_orig_system_reference,null,null,xfm.rel_orig_system_reference||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_role_resps_xfm    xfm
        set
            xfm.cust_contact_orig_sys_ref = decode(xfm.cust_contact_orig_sys_ref,null,null,xfm.cust_contact_orig_sys_ref||pt_i_suffix),
            xfm.role_resp_orig_sys_ref    = decode(xfm.role_resp_orig_sys_ref,null,null,xfm.role_resp_orig_sys_ref||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_hz_cust_acct_relate_xfm    xfm
        set
            xfm.cust_orig_system_reference=decode(xfm.cust_orig_system_reference,null,null,xfm.cust_orig_system_reference||pt_i_suffix),
            xfm.CUST_ACCT_REL_ORIG_SYS_REF=decode(xfm.CUST_ACCT_REL_ORIG_SYS_REF,null,null,xfm.CUST_ACCT_REL_ORIG_SYS_REF||pt_i_suffix),
            xfm.RELATED_CUST_ORIG_SYS_REF =decode(xfm.RELATED_CUST_ORIG_SYS_REF,null,null,xfm.RELATED_CUST_ORIG_SYS_REF||pt_i_suffix)
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_zx_tax_profile_xfm 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix 
        where migration_set_name = pt_i_MigrationSetName;
        --
        update XXMX_ZX_TAX_REGISTRATION_xfm 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix
        where migration_set_name = pt_i_MigrationSetName;
        --
        update xxmx_zx_party_classific_xfm 
        set 
            party_number=party_number||pt_i_suffix,
            party_name=party_name||pt_i_suffix
        where migration_set_name = pt_i_MigrationSetName;
        --
        commit;
exception
    when others then raise;
end update_customer_pk_values_with_suffix_xfm;

     /*
     **************************************
     ** PROCEDURE: create_ebilling_contacts
     **
     ** v1.1 - removed not exist as missing
     **        some contacts 
     **************************************
     */
PROCEDURE create_ebilling_contacts(pt_i_MigrationSetID in xxmx_migration_headers.migration_set_id%TYPE)
IS
     v_message varchar2(500); 
     v_count number;
     v_ProcOrFuncName varchar2(50) := 'create_ebilling_contacts';
     v_phase  varchar2(10) := 'EXTRACT';
	 l_count1 number := 0; --MR
	 l_count2 number := 0; --MR
	 l_count3 number := 0; --MR
BEGIN
     --
     -- #1 Party Extract Contacts -- A/C Site Email Addresses - 1 per site
     --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_parties_stg.';
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
        --
        INSERT INTO xxmx_hz_parties_stg
        (
         migration_set_id,
         migration_set_name,
         migration_status,
         party_orig_system,
         party_orig_system_reference,
         party_type,
         party_number,
         party_usage_code,
         person_first_name,
         person_last_name  
        )
        select /*+ driving_site(hcp) */ distinct
               mhr.migration_set_id                             migration_set_id, 
               mhr.migration_set_name                         migration_set_name, 
               'EXTRACTED'                                     migratrion_status,
               gct_OrigSystem                                  party_orig_system,
               'XXDM-EB-EMAIL-'||hcp.owner_table_id  party_orig_system_reference,
               'PERSON'                                               party_type,
               'XXDM-EB-EMAIL-'||hcp.owner_table_id                 party_number,
               'ORG_CONTACT'                                    party_usage_code,
               'eBilling'                                      person_first_name,
               'Contact'                                        person_last_name
        FROM   (SELECT distinct party_site_id
                FROM XXMX_CUSTOMER_SCOPE_T)                selection
               ,xxmx_migration_headers                     mhr
               ,apps.hz_contact_points@XXMX_EXTRACT        hcp
        WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
        AND    hcp.owner_table_id          = selection.party_site_id
        AND    hcp.owner_table_name        = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.contact_point_type      = 'EMAIL'
        AND    hcp.primary_flag            = 'Y'
        and    hcp.email_address is not null
        ;
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_parties_stg='||SQL%rowcount;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
     --
     -- #2 Relationships - 1 per site
     --        
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_relationships_stg.';
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
        --
        INSERT INTO xxmx_hz_relationships_stg
        (
            migration_set_id, 
            migration_set_name, 
            migration_status,
            sub_orig_system,
            sub_orig_system_reference,
            obj_orig_system,
            obj_orig_system_reference,
            relationship_type,
            relationship_code,
            start_date,
            end_date,
            subject_type,
            object_type,
            rel_orig_system,
            rel_orig_system_reference
        )
        SELECT /*+ driving_site(hcp) */ DISTINCT
                  mhr.migration_set_id                          migration_set_id, 
                  mhr.migration_set_name                      migration_set_name, 
                  'EXTRACTED'                                   migration_status,
                  gct_OrigSystem                                 sub_orig_system,
                  'XXDM-EB-EMAIL-'||selection.party_site_id
                                                       sub_orig_system_reference,
                  gct_OrigSystem                                 obj_orig_system,
                  hpp.party_id                         obj_orig_system_reference,
                  'CONTACT'                                    relationship_type,
                  'CONTACT_OF'                                 relationship_code,
                  trunc(hcp.creation_date)                            start_date,
                  -- REF-22112022-2
                  -- to_date('31/12/4712','DD/MM/YYYY')                 end_date,
                  null                                                  end_date,
                  'PERSON'                                          subject_type,
                  hpp.party_type                                     object_type,
                  gct_OrigSystem                                 rel_orig_system,
                  'XXDM-EB-EMAIL-'||selection.party_site_id
                                                       rel_orig_system_reference
        FROM   (SELECT distinct party_site_id, account_party_id party_id
                FROM XXMX_CUSTOMER_SCOPE_T)                selection
               ,xxmx_migration_headers                     mhr
               ,apps.hz_contact_points@XXMX_EXTRACT        hcp
               ,apps.hz_parties@XXMX_EXTRACT               hpp
        WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
        AND    hcp.owner_table_id          = selection.party_site_id
        AND    hcp.owner_table_name        = 'HZ_PARTY_SITES'
        AND    hcp.status                  = 'A'
        AND    hcp.contact_point_type      = 'EMAIL'
        AND    hcp.primary_flag(+)         = 'Y'
        and    hcp.email_address           is not null
        AND    hpp.party_id                = selection.party_id
        ;
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_relationships_stg='||SQL%rowcount;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
    --
    -- #3 Account Contact Source System Reference
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_cust_acct_contacts_stg.';
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
        --
        INSERT INTO xxmx_hz_cust_acct_contacts_stg
        (
                         migration_set_id, 
                         migration_set_name, 
                         migration_status,
                         cust_orig_system,
                         cust_orig_system_reference,
                         cust_site_orig_system,
                         cust_site_orig_sys_ref,
                         cust_contact_orig_system,
                         cust_contact_orig_sys_ref,
                         role_type,
                         primary_flag,
                         rel_orig_system,
                         rel_orig_system_reference
         )
         SELECT /*+ driving_site(hcp) */ DISTINCT
                    mhr.migration_set_id                        migration_set_id, 
                    mhr.migration_set_name                    migration_set_name, 
                    'EXTRACTED'                                 migration_status,
                    gct_OrigSystem                              cust_orig_system,
                    selection.account_number          cust_orig_system_reference,
                    gct_OrigSystem                         cust_site_orig_system,
                    selection.cust_account_id||'-'||selection.cust_acct_site_id 
                                                          cust_site_orig_sys_ref,
                    gct_OrigSystem                      cust_contact_orig_system,
                    'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||selection.cust_acct_site_id  
                                                       cust_contact_orig_sys_ref,
                    'CONTACT'                                          role_type,
                    'N'                                             primary_flag,
                    gct_OrigSystem                               rel_orig_system,
                    'XXDM-EB-EMAIL-'||selection.party_site_id
                                                       rel_orig_system_reference
        FROM   (SELECT distinct 
                    party_site_id, account_party_id as party_id, account_number,
                    cust_account_id, cust_acct_site_id
                FROM XXMX_CUSTOMER_SCOPE_T)                selection
               ,xxmx_migration_headers                     mhr
               ,apps.hz_contact_points@XXMX_EXTRACT        hcp
               --,apps.hz_party_sites@XXMX_EXTRACT           hps
               --,apps.hz_parties@XXMX_EXTRACT               hpp
               --,apps.hz_cust_accounts@XXMX_EXTRACT         hca
               --,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas              
        WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
        AND    hcp.owner_table_id          = selection.party_site_id
        AND    hcp.owner_table_name        = 'HZ_PARTY_SITES'
        AND    hcp.status                  = 'A'
        AND    hcp.contact_point_type      = 'EMAIL'
        AND    hcp.primary_flag            = 'Y'
        and    hcp.email_address           is not null
        --AND    hps.party_Site_Id           = selection.party_site_id
        --AND    hpp.party_id                = hps.party_id
        --AND    hca.cust_account_id         = selection.cust_account_id
        --AND    hca.account_number          = selection.account_number
        --AND    hcas.cust_account_id        = hca.cust_account_id
        --AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        --AND    hcas.party_site_id          = selection.party_site_id
        --AND    hcas.org_id                 = selection.org_id
        ;
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_cust_acct_contacts_stg='||SQL%rowcount;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
    --
    -- #4 Account Contact Points - per site
    --
    insert into xxmx_object_summary 
        (MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, START_TIME )
        values 
        (pt_i_MigrationSetID,1,'XXMX_HZ_CONTACT_POINTS_STG', gcv_BusinessEntity,'CONTACT_ROLES',sysdate);
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_contact_points_stg.';
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    INSERT INTO xxmx_hz_contact_points_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             cp_orig_system,
             cp_orig_system_reference,
             party_orig_system,
             party_orig_system_reference,
             primary_flag,
             contact_point_type,
             contact_point_purpose,             
             email_address,
             email_format,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT /*+ driving_site(hcp) */ DISTINCT
                mhr.migration_set_id                                            migration_set_id, 
                mhr.migration_set_name                                          migration_set_name, 
                'EXTRACTED'                                                     migration_status,
                gct_OrigSystem                                                  cp_orig_system,
                'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||hcp.contact_point_id  cp_orig_system_reference,
                gct_OrigSystem                                                  party_orig_system,
                'XXDM-EB-EMAIL-'||selection.party_site_id                             party_orig_system_reference,
--                'N'                                                           primary_flag,
                hcp.primary_flag                                                primary_flag,
                -- REF-21112022-1
                -- 'EMAIL'                                                      contact_point_type,
                null                                                            contact_point_type,
                -- 'BUSINESS'                                                   contact_point_purpose,
                null                                                            contact_point_purpose,
                -- MA 05-12-2022 the default should be done in GATE2
                --nvl(hcp.email_address, gct_DefaultEmail)                      email_address,
                hcp.email_address                                               email_address,
                -- MA 05-12-2022 the default should be done in GATE2
                --nvl(hcp.email_format, gct_DefaultEmailFm                      email_format,
                hcp.email_format                                                email_format,
                gct_OrigSystem                                                  rel_orig_system,
                'XXDM-EB-EMAIL-'||selection.party_site_id                             rel_orig_system_reference                           
        FROM   (SELECT distinct 
                    account_party_id party_id, party_site_id, 
                    cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_T)                 selection
                ,xxmx_migration_headers                     mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
              -- REF-24112022-1 the following tables are not required for the query
                --,apps.hz_party_sites@XXMX_EXTRACT           hps
              --,apps.hz_parties@XXMX_EXTRACT               hpp
              --,apps.hz_cust_accounts@XXMX_EXTRACT         hca
              --,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas
         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         and    hcp.email_address is not null
         -- MA 25/03/2022 comment out below condition to allow all emails to be extracted not just primary one
         --         AND    hcp.primary_flag(+)         = 'Y'
         -- REF-24112022-1 tables are removed to improve performance
         --AND    hps.party_site_id           = selection.party_site_id
         --AND    hpp.party_id                = hps.party_id
         --AND    hca.cust_account_id         = selection.cust_account_id
         --AND    hca.account_number          = selection.account_number
         --AND    hcas.cust_account_id        = hca.cust_account_id
         --AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         --AND    hcas.party_site_id          = selection.party_site_id
         --AND    hcas.org_id                 = selection.org_id
         ;
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_contact_points_stg='||SQL%rowcount;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
     --
     -- #5 Contact Roles - 1 per site/role - SMBC = CONTACT / STMTS / DUN / BILL_TO
     --
    insert into xxmx_object_summary 
        (MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, START_TIME )
        values 
        (pt_i_MigrationSetID,1,'XXMX_HZ_ORG_CONTACT_ROLES_STG', gcv_BusinessEntity,'CONTACT_ROLES',sysdate);
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_org_contact_roles_stg.';
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    INSERT INTO xxmx_hz_org_contact_roles_stg
         (
                migration_set_id, 
                migration_set_name, 
                migration_status,
                contact_role_orig_system,
                contact_role_orig_sys_ref,
                rel_orig_system,
                rel_orig_system_reference,
                role_type,
                role_level,
                primary_flag,
                primary_contact_per_role_type
         )
         SELECT /*+ driving_site(hcp) */ DISTINCT
                mhr.migration_set_id                            migration_set_id, 
                mhr.migration_set_name                        migration_set_name, 
                'EXTRACTED'                                     migration_status,
                gct_OrigSystem                          contact_role_orig_system,
                'XXDM-EB-EMAIL-'||selection.party_site_id||'-CNTC' 
                                                       contact_role_orig_sys_ref,
                gct_OrigSystem                                   rel_orig_system,
                'XXDM-EB-EMAIL-'||selection.party_site_id 
                                                       rel_orig_system_reference,
                'CONTACT'                                              role_type,
                'N'                                                   role_level,
                'N'                                                 primary_flag,
                'N'                                primary_contact_per_role_type
        FROM   (SELECT distinct party_site_id
                    FROM XXMX_CUSTOMER_SCOPE_T)             selection
                ,xxmx_migration_headers                     mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
                -- REF-24112022-1 the following tables are not required for the query
                --,apps.hz_party_sites@XXMX_EXTRACT           hps
                --,apps.hz_parties@XXMX_EXTRACT               hpp
                --,apps.hz_cust_accounts@XXMX_EXTRACT         hca
                --,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas              
         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hcp.primary_flag(+)         = 'Y'
        and    hcp.email_address is not null
         -- REF-24112022-1 tables are removed to improve performance
         --AND    hps.party_Site_Id           = selection.party_site_id
         --AND    hpp.party_id                = hps.party_id
         --AND    hca.cust_account_id         = selection.cust_account_id
         --AND    hca.account_number          = selection.account_number
         --AND    hcas.cust_account_id        = hca.cust_account_id
         --AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         --AND    hcas.party_site_id          = selection.party_site_id
         --AND    hcas.org_id                 = selection.org_id
         ;
         /* MA 26/03/2022 not needed - contact role or just CONTACT is sufficiant to produce stmt and inv
         UNION
         SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migration_status,
               gct_OrigSystem contact_role_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id||'-STMTS' contact_role_orig_sys_ref,
               gct_OrigSystem rel_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
               'STMTS' role_type,
               'N' role_level,
               'N' primary_flag,
               'N' primary_contact_per_role_type
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_T) selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
                ,apps.hz_party_sites@XXMX_EXTRACT           hps
                ,apps.hz_parties@XXMX_EXTRACT               hpp
                ,apps.hz_cust_accounts@XXMX_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
         UNION
         SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migration_status,
               gct_OrigSystem contact_role_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id||'-BILLTO' contact_role_orig_sys_ref,
               gct_OrigSystem rel_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
               'BILL_TO' role_type,
               'N' role_level,
               'N' primary_flag,
               'N' primary_contact_per_role_type
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_T) selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
                ,apps.hz_party_sites@XXMX_EXTRACT           hps
                ,apps.hz_parties@XXMX_EXTRACT               hpp
                ,apps.hz_cust_accounts@XXMX_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID; */
    --
     v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_org_contact_roles_stg='||SQL%rowcount;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
    -- ---------------------------------------------------------------------------------- --
    -- ---------------------------------- ORG-CONTACTS ---------------------------------- --
    -- ---------------------------------------------------------------------------------- --
    -- #6 Relationship Source - Imp Contacts - per relationship
    insert into xxmx_object_summary 
        (MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, START_TIME )
        values 
        (pt_i_MigrationSetID,1,'XXMX_HZ_ORG_CONTACT_STG', gcv_BusinessEntity,'ORG_CONTACTS',sysdate);
    v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_org_contacts_stg.';
    xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );  

FOR i IN (
SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
                  mhr.migration_set_id                          migration_set_id, 
                  mhr.migration_set_name                      migration_set_name, 
                  'EXTRACTED'                                   migration_status,
                  gct_OrigSystem                                 rel_orig_system,
                  'XXDM-EB-EMAIL-'||hps.party_site_id  rel_orig_system_reference
        --FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id FROM XXMX_CUSTOMER_SCOPE_T) selection
         FROM   (SELECT distinct party_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
                ,xxmx_migration_headers                     mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
                ,apps.hz_party_sites@XXMX_EXTRACT           hps
         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         and    hcp.email_address           is not null
         )
LOOP
l_count1 := l_count1 +1	;	 
    --
    INSERT INTO xxmx_hz_org_contacts_stg
         (   
                migration_set_id, 
                migration_set_name, 
                migration_status,
                rel_orig_system,
                rel_orig_system_reference
         )	
		  VALUES( 

                     i.migration_set_id
					,i.migration_set_name
					,i.migration_status
					,i.rel_orig_system
					,i.rel_orig_system_reference

           );
 --Comment Start -- MR       
--         SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
--                  mhr.migration_set_id                          migration_set_id, 
--                  mhr.migration_set_name                      migration_set_name, 
--                  'EXTRACTED'                                   migration_status,
--                  gct_OrigSystem                                 rel_orig_system,
--                  'XXDM-EB-EMAIL-'||hps.party_site_id  rel_orig_system_reference
--        --FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id FROM XXMX_CUSTOMER_SCOPE_T) selection
--         FROM   (SELECT distinct party_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
--                ,xxmx_migration_headers                     mhr
--                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
--                ,apps.hz_party_sites@XXMX_EXTRACT           hps
--         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
--         AND    hcp.owner_table_id(+)       = selection.party_site_id
--         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
--         AND    hcp.status(+)               = 'A'
--         AND    hcp.primary_flag(+)         = 'Y'
--         AND    hcp.contact_point_type(+)   = 'EMAIL'
--         AND    hps.party_Site_Id           = selection.party_site_id
--         and    hcp.email_address           is not null
--         ;
 --Comment End -- MR 
END LOOP;
    --
     --v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_org_contacts_stg='||SQL%rowcount; --MR
	  v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_org_contacts_stg='||l_count1;
     xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
    -- ---------------------------------------------------------------------------------- --
    -- ----------------------------------- ROLE-RESP ------------------------------------ --
    -- ---------------------------------------------------------------------------------- --
    -- #7 Roles/Responsibility - 1 per site / role : DUN / STMTS / BILL_TO
    insert into xxmx_object_summary 
        (MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, START_TIME )
        values 
        (pt_i_MigrationSetID,1,'XXMX_HZ_ROLE_RESP_STG', gcv_BusinessEntity,'ROLES_AND_RESPONSIBILITIES',sysdate);
    v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_role_resps_stg.';
    xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );  

FOR j IN 
(
 SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
                  mhr.migration_set_id                          migration_set_id, 
                  mhr.migration_set_name                      migration_set_name, 
                 'EXTRACTED'                                    migration_status,
                 gct_OrigSystem                         cust_contact_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,                            
                 gct_OrigSystem                            role_resp_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id||'-B' role_resp_orig_sys_ref,
                 'BILL_TO'                                   responsibility_type,
                 'N'                                                primary_flag
        FROM   (SELECT distinct party_site_id, cust_acct_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
                ,xxmx_migration_headers                     mhr
                ,apps.hz_party_sites@XXMX_EXTRACT           hps
                ,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
        WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
        AND    hps.party_site_id           = selection.party_site_id
        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        AND    hcp.owner_table_id(+)       = selection.party_site_id
        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.primary_flag(+)         = 'Y'
        AND    hcp.contact_point_type(+)   = 'EMAIL'
        and    hcp.email_address is not null
  ) 
LOOP
l_count2 := l_count2 + 1;  
    --
    INSERT INTO xxmx_hz_role_resps_stg
         (
                  migration_set_id, 
                  migration_set_name, 
                  migration_status,
                  cust_contact_orig_system,
                  cust_contact_orig_sys_ref,                            
                  role_resp_orig_system,
                  role_resp_orig_sys_ref,
                  responsibility_type,
                  primary_flag
         )
		 VALUES 
		 (
                  j.migration_set_id, 
                  j.migration_set_name, 
                  j.migration_status,
                  j.cust_contact_orig_system,
                  j.cust_contact_orig_sys_ref,                            
                  j.role_resp_orig_system,
                  j.role_resp_orig_sys_ref,
                  j.responsibility_type,
                  j.primary_flag
         );
-- Comment Start --MR	 
--        SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
--                  mhr.migration_set_id                          migration_set_id, 
--                  mhr.migration_set_name                      migration_set_name, 
--                 'EXTRACTED'                                    migration_status,
--                 gct_OrigSystem                         cust_contact_orig_system,
--                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,                            
--                 gct_OrigSystem                            role_resp_orig_system,
--                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id||'-B' role_resp_orig_sys_ref,
--                 'BILL_TO'                                   responsibility_type,
--                 'N'                                                primary_flag
--        FROM   (SELECT distinct party_site_id, cust_acct_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
--                ,xxmx_migration_headers                     mhr
--                ,apps.hz_party_sites@XXMX_EXTRACT           hps
--                ,apps.hz_cust_acct_sites_all@XXMX_EXTRACT   hcas
--                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
--        WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
--        AND    hps.party_site_id           = selection.party_site_id
--        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
--        AND    hcp.owner_table_id(+)       = selection.party_site_id
--        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
--        AND    hcp.status(+)               = 'A'
--        AND    hcp.primary_flag(+)         = 'Y'
--        AND    hcp.contact_point_type(+)   = 'EMAIL'
--        and    hcp.email_address is not null
--    ;
-- Comment End --MR	
   -- v_count:=SQL%rowcount; --MR
END LOOP;
   v_count:=l_count2;
    update xxmx_object_summary set record_count=v_count 
        where migration_set_id=pt_i_MigrationSetID and business_entity='CUSTOMERS' and sub_entity='ROLE-RESP';
    --
    v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_role_resps_stg='||v_count;
    xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );  
FOR i IN (
	SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
                mhr.migration_set_id                            migration_set_id, 
                mhr.migration_set_name                        migration_set_name, 
                 'EXTRACTED'                                    migration_status,
                 gct_OrigSystem                         cust_contact_orig_system,
                 'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||selection.cust_acct_site_id 
                                                       cust_contact_orig_sys_ref,                           
                 gct_OrigSystem                            role_resp_orig_system,
                 'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||selection.cust_acct_site_id||'-S' 
                                                          role_resp_orig_sys_ref,
                 'STMTS'                                     responsibility_type,
                 'N'                                                primary_flag
        FROM   (SELECT distinct party_site_id, cust_acct_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
                ,xxmx_migration_headers                     mhr
                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         and    hcp.email_address is not null
)
LOOP		
l_count3 := l_count3 + 1;  
    --
    INSERT INTO xxmx_hz_role_resps_stg
         (
                  migration_set_id, 
                  migration_set_name, 
                  migration_status,
                  cust_contact_orig_system,
                  cust_contact_orig_sys_ref,                            
                  role_resp_orig_system,
                  role_resp_orig_sys_ref,
                  responsibility_type,
                  primary_flag
         )
		 VALUES 
		 (
                 i.migration_set_id, 
                 i.migration_set_name, 
                 i.migration_status,
                 i.cust_contact_orig_system,
                 i.cust_contact_orig_sys_ref,                            
                 i.role_resp_orig_system,
                 i.role_resp_orig_sys_ref,
                 i.responsibility_type,
                 i.primary_flag
         );
--Comment Start --MR
--        SELECT /*+ index(hcp HZ_CONTACT_POINTS_N6) driving_site(hcp) */ DISTINCT
--                mhr.migration_set_id                            migration_set_id, 
--                mhr.migration_set_name                        migration_set_name, 
--                 'EXTRACTED'                                    migration_status,
--                 gct_OrigSystem                         cust_contact_orig_system,
--                 'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||selection.cust_acct_site_id 
--                                                       cust_contact_orig_sys_ref,                           
--                 gct_OrigSystem                            role_resp_orig_system,
--                 'XXDM-EB-EMAIL-'||selection.party_site_id||'-'||selection.cust_acct_site_id||'-S' 
--                                                          role_resp_orig_sys_ref,
--                 'STMTS'                                     responsibility_type,
--                 'N'                                                primary_flag
--        FROM   (SELECT distinct party_site_id, cust_acct_site_id FROM XXMX_CUSTOMER_SCOPE_T) selection
--                ,xxmx_migration_headers                     mhr
--                ,apps.hz_contact_points@XXMX_EXTRACT        hcp
--         WHERE  mhr.migration_set_id        = pt_i_MigrationSetID
--         AND    hcp.owner_table_id(+)       = selection.party_site_id
--         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
--         AND    hcp.status(+)               = 'A'
--         AND    hcp.primary_flag(+)         = 'Y'
--         AND    hcp.contact_point_type(+)   = 'EMAIL'
--         and    hcp.email_address is not null
--         ;
    --
    --Comment End --MR
END LOOP;
   -- v_count:=SQL%rowcount; --MR
   v_count:=l_count3;
    update xxmx_object_summary set record_count=record_count+v_count, end_time=sysdate
        where migration_set_id=pt_i_MigrationSetID and business_entity='CUSTOMERS' and sub_entity='ROLE-RESP';
    v_message:='Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" insert into xxmx_hz_role_resps_stg='||v_count;
    xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          
    --
    commit;
    --
EXCEPTION
    when others then
       v_message:=substr(sqlerrm,1,500);
       xxmx_utilities_pkg.log_module_message
             (
              pt_i_ApplicationSuite => gct_ApplicationSuite
             ,pt_i_Application      => gct_Application
             ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => v_phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => v_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => v_message
             ,pt_i_OracleError         => NULL
             );          

END create_ebilling_contacts;          
     --
     --
PROCEDURE update_dff
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_dff';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START update_dff';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        -- REF-21112022-2
        update xxmx_hz_cust_accounts_stg upd
            set
                (upd.attribute1) = 
                (
                    select  organization_name
                    from    XXMX_HZ_PARTIES_STG 
                    where   migration_set_id              = upd.migration_set_id 
                    and     party_orig_system_reference   = upd.party_orig_system_reference 
                )
            where migration_set_id = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END update_dff';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_dff;
--
--
--
PROCEDURE update_customer_profile
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_customer_profile';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START update_customer_profile';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        update XXMX_HZ_CUST_PROFILES_STG u
        set 
            printing_option_code='PRI',
            statements          ='Y'
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Profile records updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_CUST_PROFILES_STG u
        set 
            TXN_DELIVERY_METHOD='EMAIL_INV',
            STMT_DELIVERY_METHOD='EMAIL'
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        and exists
        (
            select 1
            from 
            XXMX_HZ_CONTACT_POINTS_STG cp,
            XXMX_HZ_CUST_ACCT_CONTACTS_stg cac
            where cp.migration_set_id=u.migration_set_id
            and   cac.migration_set_id=cp.migration_set_id
            and   cp.rel_orig_system_reference=cac.rel_orig_system_reference
            and cac.cust_orig_system_reference=u.cust_orig_system_reference
            and cac.cust_site_orig_sys_ref=u.cust_site_orig_sys_ref
        );
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Profile records updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_CUST_PROFILES_STG u
        set 
            TXN_DELIVERY_METHOD='PRINT_INV'
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        and TXN_DELIVERY_METHOD is null;
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Profile records updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_CUST_PROFILES_STG u
        set 
            STMT_DELIVERY_METHOD='PRINT'
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        and STMT_DELIVERY_METHOD is null;
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Profile records updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        gvn_RowCount := SQL%rowcount;
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END update_customer_profile';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_customer_profile;
     --
     --
     --
PROCEDURE update_start_end_date
(
    pt_i_MigrationSetID             in      xxmx_migration_headers.migration_set_id%TYPE
)
is
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_start_end_date';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START update_start_end_date';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );

        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_LOCATIONS_STG u
        set 
            ADDRESS_EFFECTIVE_DATE=to_date('01/01/2015','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;

        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_PARTY_SITES_STG u
        set 
            START_DATE_ACTIVE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE_ACTIVE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_PARTY_SITE_USES_STG u
        set 
            START_DATE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_RELATIONSHIPS_STG u
        set 
            START_DATE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_CONTACT_POINTS_STG u
        set 
            START_DATE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_CUST_ACCOUNTS_STG u
        set 
            ACCOUNT_ESTABLISHED_DATE=to_date('01/01/2015','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_CUST_ACCT_SITES_STG u
        set 
            START_DATE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        -- REF-10112022-1 see changed in header
        update xxmx_stg.XXMX_HZ_CUST_SITE_USES_STG u
        set 
            START_DATE=to_date('01/01/2015','DD/MM/YYYY'),
            END_DATE  =to_date('31/12/4712','DD/MM/YYYY')
        where MIGRATION_SET_ID=pt_i_MigrationSetID
        ;
        --
        gvn_message := 'Procedure: END update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_start_end_date;
     --
     --
     --
PROCEDURE update_party_ebs_values
(
    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
)
IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_party_ebs_values';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        -- REF-11112022-1
        --update xxmx_hz_parties_stg upd
        --    set
        --        upd.attribute1 = party_orig_system_reference,
        --        upd.attribute2 = party_number,
        --        upd.attribute3 = organization_name
        --    where migration_set_id = pt_i_MigrationSetID;
        --gvn_RowCount := SQL%rowcount;
        --
        --
        gvn_message := 'Procedure: END update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_party_ebs_values;
--
--
--
PROCEDURE update_customer_site_ebs_values
(
    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
)
IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'update_customersite_ebs_values';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ACCOUNT';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
begin
        gvn_message := 'Procedure: START update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        update XXMX_HZ_CUST_ACCT_SITES_STG upd
            set
                upd.attribute1 = upd.CUST_ORIG_SYSTEM_REFERENCE,
                upd.attribute2 = upd.CUST_SITE_ORIG_SYS_REF,
                upd.attribute3 = upd.SITE_ORIG_SYSTEM_REFERENCE
            where migration_set_id = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END update_customer_party_number';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
end update_customer_site_ebs_values;
--
--
--
PROCEDURE create_one_party_for_each_cust
            (
                 pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
            )
IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'create_one_party_for_each_cust';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'PARTY';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
     begin
        gvn_message := 'Procedure: START create_one_party_for_each_cust';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        delete from xxmx_hz_parties_stg del
            where   del.party_usage_code    = 'CUSTOMER'
            and     del.migration_set_id    = pt_i_MigrationSetID;
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Parties deleted: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        insert into xxmx_hz_parties_stg
        (   migration_set_id,migration_set_name,migration_status,party_orig_system,party_orig_system_reference,insert_update_flag,
            party_type,party_number,party_usage_code,organization_name,attribute1,attribute2,attribute3
        )
            select
                acct.migration_set_id,acct.migration_set_name,acct.migration_status,acct.cust_orig_system,acct.cust_orig_system_reference,
                acct.insert_update_flag,'ORGANIZATION',acct.account_number,'CUSTOMER',acct.account_name,acct.party_orig_system_reference,
                acct.account_number,acct.account_name
            from    XXMX_HZ_CUST_ACCOUNTS_STG acct
            where migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Parties created: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_PARTY_SITES_STG    site
            set PARTY_ORIG_SYSTEM_REFERENCE=
                (
                    select CUST_ORIG_SYSTEM_REFERENCE
                    from    XXMX_HZ_CUST_ACCOUNTS_STG acct
                    where   acct.migration_set_id = site.migration_set_id
                    and     acct.attribute5       = site.PARTY_ORIG_SYSTEM_REFERENCE
                )
            where migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Party sites updated ceated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_PARTY_SITE_USES_STG    uses
            set PARTY_ORIG_SYSTEM_REFERENCE=
                (
                    select CUST_ORIG_SYSTEM_REFERENCE
                    from    XXMX_HZ_CUST_ACCOUNTS_STG acct
                    where   acct.migration_set_id = uses.migration_set_id
                    and     acct.attribute5       = uses.PARTY_ORIG_SYSTEM_REFERENCE
                )
            where migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Cutomer Accounts updated ceated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        update XXMX_HZ_CUST_ACCOUNTS_STG    uses
            set PARTY_ORIG_SYSTEM_REFERENCE=CUST_ORIG_SYSTEM_REFERENCE
            where migration_set_id = pt_i_MigrationSetID;
        --
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Party sites updated ceated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
        --
        gvn_message := 'Procedure: END create_one_party_for_each_cust';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
     end create_one_party_for_each_cust;
     --
     --
     PROCEDURE create_one_loc_for_each_site
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'create_one_loc_for_each_site';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'PARTY SITES';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
        cursor c_sites is
            select  distinct location_orig_system_reference, count(*) 
            from    XXMX_HZ_PARTY_SITES_STG 
            where   migration_set_id  = pt_i_MigrationSetID
            group by 
                location_orig_system_reference 
                having count(*)>1;
     begin
        gvn_message := 'Procedure: START create_one_loc_for_each_site';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        for r_site in c_sites loop
            insert into XXMX_HZ_LOCATIONS_stg
                (
                    migration_set_id, migration_set_name, migration_status,
                    location_orig_system, location_orig_system_reference,
                    insert_update_flag,country,address1,address2,address3,address4,city,state,
                    province,county,postal_code,postal_plus4_code,location_language,
                    description,short_description,sales_tax_inside_city_limits,timezone_code,address1_std,adapter_content_source,
                    addr_valid_status_code,date_validated,address_effective_date,address_expiration_date,validated_flag
                )
                    select 
                        loc.migration_set_id, loc.migration_set_name, loc.migration_status,
                        site.location_orig_system,site.location_orig_system_reference||'.'||rownum,
                        loc.insert_update_flag,loc.country,loc.address1,loc.address2,loc.address3,loc.address4,loc.city,loc.state,
                        loc.province,loc.county,loc.postal_code,loc.postal_plus4_code,loc.location_language,
                        loc.description,loc.short_description,loc.sales_tax_inside_city_limits,loc.timezone_code,loc.address1_std,loc.adapter_content_source,
                        loc.addr_valid_status_code,loc.date_validated,loc.address_effective_date,loc.address_expiration_date,loc.validated_flag
                    from  XXMX_HZ_LOCATIONS_STG loc, XXMX_HZ_PARTY_SITES_stg site
                    where   loc.migration_set_id                = pt_i_MigrationSetID
                    and     loc.location_orig_system_reference  = r_site.location_orig_system_reference
                    and     site.migration_set_id               = loc.migration_set_id
                    and     site.location_orig_system           = loc.location_orig_system
                    and     site.location_orig_system_reference = loc.location_orig_system_reference ;
                gvn_RowCount := SQL%rowcount;
                --
                gvn_message := 'INSERT Locations:'||r_site.location_orig_system_reference||' Count:'||gvn_RowCount;
                xxmx_utilities_pkg.log_module_message
                (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvn_message
                    ,pt_i_OracleError         => NULL
                );
                --
--            end loop;
            update XXMX_HZ_PARTY_SITES_stg
                set     location_orig_system_reference=location_orig_system_reference||'.'||rownum
                where   migration_set_id                = pt_i_MigrationSetID
                and     location_orig_system_reference  = r_site.location_orig_system_reference;
            gvn_RowCount := SQL%rowcount;
            --
            gvn_message := 'UPDATE Sites:'||r_site.location_orig_system_reference||' Count:'||gvn_RowCount;
            xxmx_utilities_pkg.log_module_message
               (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gcv_BusinessEntity
                    ,pt_i_SubEntity           => ct_SubEntity
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvn_message
                    ,pt_i_OracleError         => NULL
               );
            --
            delete from XXMX_HZ_LOCATIONS_stg
            where location_orig_system_reference=r_site.location_orig_system_reference;

        end loop;
     end create_one_loc_for_each_site;
     --
     PROCEDURE customers_cm_stg
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
        e_ModuleError                   EXCEPTION;
        --************************
        --** Constant Declarations
        --************************
        --
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'stg_main';
        ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE            := 'ALL';
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
        --
     BEGIN
        gvn_message := 'Procedure: Start';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
        --
        --
        --
        -- ================================================================================
	    -- Create ebilling contacts
        -- ================================================================================
        -- Migrate primary email address from EBS Party Site Level to new contact in fusion
        -- against Customer Site - responsibilities DUN / STMTS / BILL_TO
        -- 
        --
        gvv_ProgressIndicator := '-CM0010';
        --
        xxmx_utilities_pkg.log_module_message
             (
                 pt_i_ApplicationSuite => gct_ApplicationSuite
                ,pt_i_Application      => gct_Application
                ,pt_i_BusinessEntity   => gcv_BusinessEntity
             ,pt_i_SubEntity           => 'ALL'
             ,pt_i_MigrationSetID      => pt_i_MigrationSetID
             ,pt_i_Phase               => ct_Phase
             ,pt_i_PackageName         => gcv_PackageName
             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
             ,pt_i_Severity            => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
             ,pt_i_ModuleMessage       => 'Procedure "'||gcv_PackageName||'.'||'create_ebilling_contacts'||'" running.'
             ,pt_i_OracleError         => NULL
             );          
           --    
          create_ebilling_contacts(pt_i_MigrationSetID);
          COMMIT;
		  --         Other custtomisations
        remove_timezone_code(pt_i_MigrationSetID);
        -- REF-10112022-3
        -- update_set_code(pt_i_MigrationSetID);
        -- REF-10112022-4
        --update_party_ebs_values(pt_i_MigrationSetID);
        -- REF-06122022-1 update_dff no longer required in gate1 but moved to gate2 to be updated by citco
        --update_dff(pt_i_MigrationSetID);
        -- REF-10112022-2
        --update_customer_site_ebs_values(pt_i_MigrationSetID);
        update_customer_profile(pt_i_MigrationSetID);
        --update_start_end_date(pt_i_MigrationSetID);
        --
        --
        gvn_message := 'Procedure: End';
        xxmx_utilities_pkg.log_module_message
           (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gcv_BusinessEntity
                ,pt_i_SubEntity           => ct_SubEntity
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
           );
     EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                              ||'** ERROR_BACKTRACE: '
                                              ||dbms_utility.format_error_backtrace
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity => ct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
     END customers_cm_stg;
     --
     --
-- -------------------------------------------------------------------------- --
-- --------------------- validate_location_address_frmt --------------------- --
-- -------------------------------------------------------------------------- --
procedure validate_hz_tab_ref_integrity
(
    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
) is
    v_sql           varchar2(2000);
    v_count         number;
    cv_ProcOrFuncName       varchar2(30) := 'validate_hz_tab_ref_integrity';

    cursor c_sub_entity is
        select  business_entity,sub_entity,xfm_table
        from    xxmx_migration_metadata 
        where   business_entity     = 'CUSTOMERS'
        and     enabled_flag        = 'Y'
--        and     xfm_table not  in ('XXMX_AR_CUST_BANKS_XFM','XXMX_ZX_TAX_REGISTRATION_XFM','XXMX_ZX_PARTY_CLASSIFIC_XFM','XXMX_ZX_TAX_PROFILE_XFM')
        order by sub_entity_seq;
    --
    cursor c_mand_col is
        select  xt.schema_name, xt.table_name,xtc.column_name,md.business_entity,md.sub_entity
        from
            xxmx_xfm_table_columns      xtc,
			xxmx_xfm_tables             xt,
            xxmx_migration_metadata     md
        where   md.business_entity           = 'CUSTOMERS'
        and     md.metadata_id               = xt.metadata_id
		AND     xtc.xfm_table_id             = xt.xfm_table_id
		and     xtc.include_in_outbound_file = 'Y'
		and     xtc.mandatory                = 'Y';
begin
    delete from  xxmx_entity_validation_errors;
    for r_tab in c_sub_entity loop
        -- 
        -- Check that the migration_set_id in all tables are the same
        if r_tab.xfm_table is not null then
            v_sql := 'select count(*) from '||r_tab.xfm_table||' where migration_set_id!='||pt_i_MigrationSetID;
            execute immediate v_sql into v_count;
            if v_count>0 then
                insert into xxmx_entity_validation_errors
                    (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
                    values (r_tab.business_entity,r_tab.sub_entity,r_tab.xfm_table,'-','MIGRATION-ID',v_count,'Wrong MIGRATION_SET_ID in table');
            end if;
        end if;
        commit;
        --
        -- Check that all tables have records
        if r_tab.xfm_table is not null then
            v_sql := 'select count(*) from '||r_tab.xfm_table;
            execute immediate v_sql into v_count;
            if v_count = 0 then
                insert into xxmx_entity_validation_errors
                    (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
                    values (r_tab.business_entity,r_tab.sub_entity,r_tab.xfm_table,'-','COUNT',v_count,'No data found in table ');
            end if;
        end if;
        commit;
        --
        -- For Information only: Total of All tables
        if r_tab.xfm_table is not null then
            v_sql := 'select count(*) from '||r_tab.xfm_table;
            xxmx_utilities_pkg.log_module_message
                (
                    pt_i_ApplicationSuite      => gct_ApplicationSuite
                    ,pt_i_Application           => gct_Application
                    ,pt_i_BusinessEntity        => gcv_BusinessEntity
                    ,pt_i_SubEntity             => r_tab.sub_entity
                    ,pt_i_MigrationSetID        => pt_i_MigrationSetID
                    ,pt_i_Phase                 => 'EXTRACT'
                    ,pt_i_Severity              => 'NOTIFICATION'
                    ,pt_i_PackageName           => gcv_PackageName
                    ,pt_i_ProcOrFuncName        => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator     => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage         => v_sql
                    ,pt_i_OracleError           => NULL
                );
            execute immediate v_sql into v_count;
            insert into xxmx_entity_validation_errors
                (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
                values (r_tab.business_entity,r_tab.sub_entity,r_tab.xfm_table,'-','TOTAL',v_count,'-');
            commit;
            -- count of ORG+PERSON
            if r_tab.xfm_table = 'XXMX_HZ_PARTIES_XFM' then
                v_sql := 'select count(*) from '||r_tab.xfm_table||' where party_type=''ORGANIZATION''';
                execute immediate v_sql into v_count;
                insert into xxmx_entity_validation_errors
                    (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
                    values (r_tab.business_entity,r_tab.sub_entity,r_tab.xfm_table,'ORGANIZATION','TOTAL',v_count,'-');
                commit;
                v_sql := 'select count(*) from '||r_tab.xfm_table||' where party_type=''PERSON''';
                execute immediate v_sql into v_count;
                insert into xxmx_entity_validation_errors
                    (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
                    values (r_tab.business_entity,r_tab.sub_entity,r_tab.xfm_table,'PERSON','TOTAL',v_count,'-');
                commit;
            end if;
        end if;
    end loop;
    --
    -- XXMX_HZ_PARTY_SITES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES','XXMX_HZ_PARTY_SITES_XFM',PARTY_ORIG_SYSTEM_REFERENCE,'PARTY_ORIG_SYSTEM_REFERENCE',PARTY_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_PARTIES_XFM'
        from XXMX_HZ_PARTY_SITES_XFM where PARTY_ORIG_SYSTEM_REFERENCE not in (select PARTY_ORIG_SYSTEM_REFERENCE from XXMX_HZ_PARTIES_XFM);
    commit;
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES','XXMX_HZ_PARTY_SITES_XFM',LOCATION_ORIG_SYSTEM_REFERENCE,'LOCATION_ORIG_SYSTEM_REFERENCE',LOCATION_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_LOCATIONS_STG'
        from XXMX_HZ_PARTY_SITES_XFM where LOCATION_ORIG_SYSTEM_REFERENCE not in (select  LOCATION_ORIG_SYSTEM_REFERENCE from XXMX_HZ_LOCATIONS_XFM);
    commit;
    -- XXMX_HZ_PARTY_SITE_USES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES','XXMX_HZ_PARTY_SITES_XFM',PARTY_ORIG_SYSTEM_REFERENCE,'PARTY_ORIG_SYSTEM_REFERENCE',PARTY_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_PARTIES_XFM'
        from XXMX_HZ_PARTY_SITE_USES_XFM where PARTY_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from XXMX_HZ_PARTIES_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES_USES','XXMX_HZ_PARTY_SITES_XFM',SITE_ORIG_SYSTEM_REFERENCE,'SITE_ORIG_SYSTEM_REFERENCE',SITE_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_PARTIES_XFM'
        from XXMX_HZ_PARTY_SITE_USES_XFM where SITE_ORIG_SYSTEM_REFERENCE not in (select  SITE_ORIG_SYSTEM_REFERENCE from XXMX_HZ_PARTY_SITES_XFM);
    commit;
    -- XXMX_HZ_CUST_ACCOUNTS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACCOUNTS','XXMX_HZ_CUST_ACCOUNTS_XFM',PARTY_ORIG_SYSTEM_REFERENCE,'PARTY_ORIG_SYSTEM_REFERENCE',PARTY_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_PARTIES_XFM'
        from XXMX_HZ_CUST_ACCOUNTS_XFM where PARTY_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from XXMX_HZ_PARTIES_XFM);
    commit;
    -- XXMX_HZ_CUST_ACCT_SITES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACC-SITE','XXMX_HZ_CUST_ACCT_SITES_XFM',CUST_ORIG_SYSTEM_REFERENCE,'CUST_ORIG_SYSTEM_REFERENCE',CUST_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_CUST_ACCOUNTS_XFM'
        from XXMX_HZ_CUST_ACCT_SITES_XFM where CUST_ORIG_SYSTEM_REFERENCE not in (select  CUST_ORIG_SYSTEM_REFERENCE from XXMX_HZ_CUST_ACCOUNTS_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACC-SITE','XXMX_HZ_CUST_ACCT_SITES_XFM','<NULL>','SET_CODE','<NULL>','Value is missing for SET_CODE (MAND)'
        from XXMX_HZ_CUST_ACCT_SITES_XFM where SET_CODE is null;
    commit;
    --XXMX_HZ_CUST_SITE_USES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACC-SITE-USE','XXMX_HZ_CUST_SITE_USES_XFM',CUST_SITE_ORIG_SYS_REF,'CUST_SITE_ORIG_SYS_REF',CUST_SITE_ORIG_SYS_REF,'not in XXMX_HZ_CUST_ACCT_SITES_XFM'
        from XXMX_HZ_CUST_SITE_USES_XFM where CUST_SITE_ORIG_SYS_REF not in (select CUST_SITE_ORIG_SYS_REF from XXMX_HZ_CUST_ACCT_SITES_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACC-SITE-USE','XXMX_HZ_CUST_SITE_USES_XFM','<NULL>','SET_CODE','<NULL>','Value is missing for SET_CODE (MAND)'
        from XXMX_HZ_CUST_SITE_USES_XFM where SET_CODE is null;
    commit;
    -- XXMX_HZ_CUST_PROFILES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','ACC-SITE','XXMX_HZ_CUST_ACCT_SITES_XFM',CUST_ORIG_SYSTEM_REFERENCE,'CUST_ORIG_SYSTEM_REFERENCE',CUST_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_CUST_ACCOUNTS_XFM'
        from XXMX_HZ_CUST_PROFILES_XFM where CUST_ORIG_SYSTEM_REFERENCE not in (select  CUST_ORIG_SYSTEM_REFERENCE from XXMX_HZ_CUST_ACCOUNTS_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES','XXMX_HZ_PARTY_SITES_XFM',CUST_SITE_ORIG_SYS_REF,'CUST_SITE_ORIG_SYS_REF',CUST_SITE_ORIG_SYS_REF,'not in XXMX_HZ_CUST_ACCT_SITES_XFM'
        from XXMX_HZ_CUST_PROFILES_XFM where CUST_SITE_ORIG_SYS_REF not in (select CUST_SITE_ORIG_SYS_REF from XXMX_HZ_CUST_ACCT_SITES_XFM)
        and CUST_SITE_ORIG_SYS_REF is not null;
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY_SITES','XXMX_HZ_PARTY_SITES_XFM',CUST_SITE_ORIG_SYS_REF,'CUST_SITE_ORIG_SYS_REF',CUST_SITE_ORIG_SYS_REF,'STATEMENT_CYCLE_NAME/STATEMENT mismatch'
        from XXMX_HZ_CUST_PROFILES_XFM 
        where (STATEMENT_CYCLE_NAME is not null and nvl(statements,'N')<>'Y')
        or    (STATEMENT_CYCLE_NAME is null and nvl(statements,'N')='Y');
    commit;
    -- XXMX_HZ_RELATIONSHIPS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','RELATIONSHIPS','XXMX_HZ_RELATIONSHIPS_XFM',SUB_ORIG_SYSTEM_REFERENCE,'SUB_ORIG_SYSTEM_REFERENCE',SUB_ORIG_SYSTEM_REFERENCE,'not in PARTY_ORIG_SYSTEM_REFERENCE'
        from xxmx_hz_relationships_xfm where SUB_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from xxmx_hz_parties_xfm);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','RELATIONSHIPS','XXMX_HZ_RELATIONSHIPS_XFM',OBJ_ORIG_SYSTEM_REFERENCE,'OBJ_ORIG_SYSTEM_REFERENCE',OBJ_ORIG_SYSTEM_REFERENCE,'not in PARTY_ORIG_SYSTEM_REFERENCE'
        from xxmx_hz_relationships_xfm where OBJ_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from xxmx_hz_parties_xfm);
    --
    -- XXMX_HZ_CUST_ACCT_CONTACTS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CUST_ACCT_CONTACTS','XXMX_HZ_CUST_ACCT_CONTACTS_XFM',CUST_ORIG_SYSTEM_REFERENCE,'CUST_ORIG_SYSTEM_REFERENCE',CUST_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_CUST_ACCOUNTS_XFM'
        from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where CUST_ORIG_SYSTEM_REFERENCE not in ( select CUST_ORIG_SYSTEM_REFERENCE from XXMX_HZ_CUST_ACCOUNTS_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CUST_ACCT_CONTACTS','XXMX_HZ_CUST_ACCT_CONTACTS_XFM',CUST_SITE_ORIG_SYSTEM,'CUST_SITE_ORIG_SYSTEM',CUST_SITE_ORIG_SYSTEM,'not in XXMX_HZ_CUST_ACCT_SITES_XFM'
        from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where CUST_SITE_ORIG_SYSTEM not in ( select CUST_SITE_ORIG_SYSTEM from XXMX_HZ_CUST_ACCT_SITES_XFM) ;
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CUST_ACCT_CONTACTS','XXMX_HZ_CUST_ACCT_CONTACTS_XFM',REL_ORIG_SYSTEM_REFERENCE,'REL_ORIG_SYSTEM_REFERENCE',REL_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_RELATIONSHIPS_XFM'
        from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;
    --
    -- XXMX_HZ_CONTACT_POINTS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_CONTACT_POINTS_XFM',PARTY_ORIG_SYSTEM_REFERENCE,'PARTY_ORIG_SYSTEM_REFERENCE',PARTY_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_PARTIES_XFM for party of type PERSON'
        from XXMX_HZ_CONTACT_POINTS_XFM where PARTY_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from XXMX_HZ_PARTIES_XFM where party_type='PERSON');
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_CONTACT_POINTS_XFM',PARTY_ORIG_SYSTEM_REFERENCE,'PARTY_ORIG_SYSTEM_REFERENCE',PARTY_ORIG_SYSTEM_REFERENCE,'SITE_ORIG_SYSTEM must be null'
        from XXMX_HZ_CONTACT_POINTS_XFM where SITE_ORIG_SYSTEM is not null;
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_CONTACT_POINTS_XFM',REL_ORIG_SYSTEM_REFERENCE,'REL_ORIG_SYSTEM_REFERENCE',REL_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_RELATIONSHIPS_XFM'
        from XXMX_HZ_CONTACT_POINTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM);
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_CONTACT_POINTS_XFM','<NULL>','CONTACT_POINT_TYPE','<NULL>','not in XXMX_HZ_RELATIONSHIPS_XFM'
        from XXMX_HZ_CONTACT_POINTS_XFM where CONTACT_POINT_TYPE is null;
    -- XXMX_HZ_ORG_CONTACT_ROLES_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_ORG_CONTACT_ROLES_XFM',REL_ORIG_SYSTEM_REFERENCE,'REL_ORIG_SYSTEM_REFERENCE',REL_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_RELATIONSHIPS_XFM'
        from XXMX_HZ_ORG_CONTACT_ROLES_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;
    -- XXMX_HZ_ORG_CONTACTS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_ORG_CONTACTS_XFM',REL_ORIG_SYSTEM_REFERENCE,'REL_ORIG_SYSTEM_REFERENCE',REL_ORIG_SYSTEM_REFERENCE,'not in XXMX_HZ_RELATIONSHIPS_XFM'
        from XXMX_HZ_ORG_CONTACTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;
    -- XXMX_HZ_ROLE_RESPS_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','CONTACT_POINTS','XXMX_HZ_ROLE_RESPS_XFM',CUST_CONTACT_ORIG_SYS_REF,'CUST_CONTACT_ORIG_SYS_REF',CUST_CONTACT_ORIG_SYS_REF,'not in XXMX_HZ_CUST_ACCT_CONTACTS_XFM'
        from XXMX_HZ_ROLE_RESPS_XFM where CUST_CONTACT_ORIG_SYS_REF not in ( select CUST_CONTACT_ORIG_SYS_REF from XXMX_HZ_CUST_ACCT_CONTACTS_XFM) ;
    commit;
/*
select * from xxmx_hz_relationships_xfm;
select count(*) from XXMX_HZ_RELATIONSHIPS_XFM;
select * from xxmx_hz_relationships_xfm where SUB_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from xxmx_hz_parties_xfm);

select * from XXMX_HZ_CUST_ACCT_CONTACTS_XFM;
select count(*) from XXMX_HZ_CUST_ACCT_CONTACTS_XFM;
select * from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where CUST_ORIG_SYSTEM_REFERENCE not in ( select CUST_ORIG_SYSTEM_REFERENCE from XXMX_HZ_CUST_ACCOUNTS_XFM);
select * from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where CUST_SITE_ORIG_SYSTEM not in ( select CUST_SITE_ORIG_SYSTEM from XXMX_HZ_CUST_ACCT_SITES_XFM) ;
select * from XXMX_HZ_CUST_ACCT_CONTACTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;

select * from XXMX_HZ_CONTACT_POINTS_XFM;
select count(*) from XXMX_HZ_CONTACT_POINTS_XFM;
select * from XXMX_HZ_CONTACT_POINTS_XFM where PARTY_ORIG_SYSTEM_REFERENCE not in (select  PARTY_ORIG_SYSTEM_REFERENCE from xxmx_hz_parties_xfm);
select * from XXMX_HZ_CONTACT_POINTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;

select * from XXMX_HZ_ORG_CONTACT_ROLES_XFM;
select count(*) from XXMX_HZ_ORG_CONTACT_ROLES_XFM;
select * from XXMX_HZ_ORG_CONTACT_ROLES_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;

select * from XXMX_HZ_ORG_CONTACTS_XFM;
select count(*) from XXMX_HZ_ORG_CONTACTS_XFM;
select * from XXMX_HZ_ORG_CONTACTS_XFM where REL_ORIG_SYSTEM_REFERENCE not in ( select REL_ORIG_SYSTEM_REFERENCE from XXMX_HZ_RELATIONSHIPS_XFM) ;

select * from XXMX_HZ_ROLE_RESPS_XFM;
select count(*) from XXMX_HZ_ROLE_RESPS_XFM;
select * from XXMX_HZ_ROLE_RESPS_XFM where CUST_CONTACT_ORIG_SYS_REF not in ( select CUST_CONTACT_ORIG_SYS_REF from XXMX_HZ_CUST_ACCT_CONTACTS_XFM) ;
*/
    -- XXMX_ZX_PARTY_CLASSIFIC_XFM
    insert into xxmx_entity_validation_errors
        (entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)
        select 'CUSTOMERS','PARTY-CLASS','XXMX_ZX_PARTY_CLASSIFIC_XFM','<NULL>','CLASS_CATEGORY','<NULL>','Value is missing for CLASS_CATEGORY'
        from XXMX_ZX_PARTY_CLASSIFIC_XFM where CLASS_CATEGORY is null;
    --
end validate_hz_tab_ref_integrity;
-- -------------------------------------------------------------------------- --
-- --------------------- validate_location_address_frmt --------------------- --
-- -------------------------------------------------------------------------- --
procedure validate_location_address_frmt
(
    p_stage               in varchar2
)
is
        ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE                 := 'EXTRACT';
        cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                                    := 'validate_location_address_frmt';
        --
        v_sql                           varchar2(2000);
        v_insert                        varchar2(2000);
        r_rule                          sys_refcursor;
        r_no_rule                       sys_refcursor;
        r_ca_rule                       sys_refcursor;
		r_in_rule                       sys_refcursor;
		r_us_rule                       sys_refcursor;
		r_upc_rule                      sys_refcursor;
        v_attribute_code                varchar2(100);
        v_territory_code                varchar2(10);
		v_loc_orig_sys_ref              varchar2(100);
		v_attribute_value               varchar2(100);
        cursor c_rule is
            select territory_code,attribute_code
                from    apps.xxmx_fusion_postal_add_format@xxmx_extract 
                where   mandatory_flag='Y'
                and     territory_code in
                        ( select distinct country from xxmx_hz_locations_xfm );
        cursor c_no_rule is
            select distinct country 
                from    xxmx_hz_locations_xfm
                where   country not in
                ( select territory_code from apps.xxmx_fusion_postal_add_format@xxmx_extract);
begin
    if p_stage not in ('STG','XFM') then
        xxmx_utilities_pkg.log_module_message
            (
                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                 ,pt_i_Application         => gct_Application
                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                 ,pt_i_SubEntity           => 'LOCATION'
                 ,pt_i_Phase               => ct_Phase
                 ,pt_i_Severity            => 'ERROR'
                 ,pt_i_PackageName         => gcv_PackageName
                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage       => 'ERROR: invalid value for p_stage ('||p_stage||')'
                 ,pt_i_OracleError         => gvt_OracleError
            );
    else
        gvv_ProgressIndicator := '-CM0005';
        v_sql := 'delete from xxmx_entity_validation_errors where table_name = ''XXMX_HZ_LOCATIONS_'||p_stage||'''';
        execute immediate v_sql;
        -- ---------- Check those coutries addresses that have a rule ----------
        gvv_ProgressIndicator := '-CM0010';
        v_sql := 'select distinct territory_code,attribute_code from apps.xxmx_fusion_postal_add_format@xxmx_extract  '||
                'where mandatory_flag=''Y'' and territory_code in '||
                ' ( select distinct country from xxmx_hz_locations_'||p_stage||' )';
        open r_rule for v_sql;
            loop
                fetch r_rule into v_territory_code,v_attribute_code;
                exit when r_rule%notfound;
                v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
                    ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '''||
                    v_attribute_code||''',''<NULL>'', '''||v_attribute_code||' is mandatory in cloud but is null in migration table'''||
                    ' from xxmx_hz_locations_'||p_stage||' xhzlx where xhzlx.country = '''||v_territory_code||
                    ''' and xhzlx.'||v_attribute_code||' is null';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );    
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_rule;
        -- ---------- Check those coutries addresses that have no rule ----------
        gvv_ProgressIndicator := '-CM0020';
        v_sql := 'select distinct xhl.country from xxmx_hz_locations_'||p_stage||' xhl'||
           -- ' where country not in ( select territory_code from apps.xxmx_fusion_postal_add_format@xxmx_extract)';
            ' where not exists ( select 1 from apps.xxmx_fusion_postal_add_format@xxmx_extract
                                 where territory_code=xhl.country)';
        open r_no_rule for v_sql;
            loop
                fetch r_no_rule into v_territory_code;
                exit when r_no_rule%notfound;
                v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
                    ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '||
                    '''ADDRESS1'',''<NULL>'', ''ADDRESS1 is mandatory in cloud but is null in migration table'''||
                    ' from xxmx_hz_locations_'||p_stage||' xhzlx where xhzlx.country = '''||v_territory_code||
                    ''' and xhzlx.address1 is null';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );          
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
                v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
                    ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '||
                    '''CITY'',''<NULL>'', ''CITY is mandatory in cloud but is null in migration table'''||
                    ' from xxmx_hz_locations_'||p_stage||' xhzlx where xhzlx.country = '''||v_territory_code||
                    ''' and xhzlx.city is null';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );          
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_no_rule;

		--MR: START
		 -- ---------- check province & state values for IN/US/CA countries ----------
        gvv_ProgressIndicator := '-CM0030'; --CA country
  v_sql := 'select distinct src.country,src.location_orig_system_reference,address_format.attribute_code,src.province
            		from xxmx_hz_locations_'||p_stage||'  src, apps.xxmx_fusion_postal_add_format@xxmx_extract address_format '||
                 'where address_format.territory_code =  src.country '||
                 'and src.country = ''CA'' '||
                 'and address_format.attribute_code = ''PROVINCE'' '||
                 'and src.province not in (''AB'',''Alberta'',''BC'',''British Columbia'',''Colombie-Britannique'',''MB'',''Manitoba'',''NB'',''New Brunswick'',''Nouveau-Brunswick'',''NL'',''Newfoundland and Labrador'',''Terre-Neuve-et-Labrador'',
''NS'',''Nouvelle-Écosse'',''Nova Scotia'',''NT'',''Northwest Territories'',''NU'',''Nunavut'',''ON'',''Ontario'',''PE'',''Prince Edward Island'',''Île-du-Prince-Édouard'',''QC'',''Quebec'',''Québec'',''SK'',''Saskatchewan'',''YT'',''Yukon Territories'',''Yukón'')';

        open r_ca_rule for v_sql;
            loop
                fetch r_ca_rule into v_territory_code,v_loc_orig_sys_ref,v_attribute_code,v_attribute_value;
                exit when r_ca_rule%notfound;
          v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message) VALUES'||
                    '(''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''','''||v_loc_orig_sys_ref||''','''||
                    v_attribute_code||''','''||v_attribute_value||''', '''||v_attribute_value||' value is invalid in migration table'')';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );    
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_ca_rule;

		       gvv_ProgressIndicator := '-CM0040'; --IN country
           v_sql := 'select distinct src.country,src.location_orig_system_reference,address_format.attribute_code,src.state
            		from xxmx_hz_locations_'||p_stage||'  src, apps.xxmx_fusion_postal_add_format@xxmx_extract address_format '||
                 'where address_format.territory_code =  src.country '||
                 'and src.country = ''IN'' '||
                 'and address_format.attribute_code = ''STATE'' '||
                 'and src.state not in (''Andaman & Nicobar Islands'',''Andhra Pradesh'',''Arunachal Pradesh'',''Assam'',''Bihar'',''Chandigarh'',''Chhattisgarh'',''Dadra & Nagar Haveli & Daman & Diu'',''Delhi'',''Goa'',''Gujarat'',''Haryana'',''Himachal Pradesh'',
''Jammu & Kashmir'',''Jharkhand'',''Karnataka'',''Kerala'',''Ladakh'',''Lakshadweep'',''Madhya Pradesh'',''Maharashtra'',''Manipur'',''Meghalaya'',''Mizoram'',''Nagaland'',''Odisha'',''Puducherry'',''Punjab'',''Rajasthan'',''Sikkim'',''Tamil Nadu'',''Telangana'',
''Tripura'',''Uttar Pradesh'',''Uttarakhand'',''West Bengal'')';

        open r_in_rule for v_sql;
            loop
                fetch r_in_rule into v_territory_code,v_loc_orig_sys_ref,v_attribute_code,v_attribute_value;
                exit when r_in_rule%notfound;
          v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message) VALUES'||
                    '(''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''','''||v_loc_orig_sys_ref||''','''||
                    v_attribute_code||''','''||v_attribute_value||''', '''||v_attribute_value||' value is invalid in migration table'')';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );    
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_in_rule;

				       gvv_ProgressIndicator := '-CM0050'; --US country
           v_sql := 'select distinct src.country,src.location_orig_system_reference,address_format.attribute_code,src.state
            		from xxmx_hz_locations_'||p_stage||'  src, apps.xxmx_fusion_postal_add_format@xxmx_extract address_format '||
                 'where address_format.territory_code =  src.country '||
                 'and src.country = ''US'' '||
                 'and address_format.attribute_code = ''STATE'' '||
                 'and src.state not in (''AK'',''AL'',''AR'',''AS'',''AZ'',''CA'',''CO'',''CT'',''DC'',''DE'',''FL'',''FM'',''GA'',''GU'',''HI'',''IA'',''ID'',''IL'',''IN'',''KS'',''KY'',''LA'',''MA'',''MD'',''ME'',''MH'',''MI'',''MN'',''MO'',''MP'',''MS'',''MT'',''NC'',''ND'',''NE'',''NH'',''NJ'',
''NM'',''NV'',''NY'',''OH'',''OK'',''OR'',''PA'',''PR'',''PW'',''RI'',''SC'',''SD'',''TN'',''TX'',''UT'',''VA'',''VI'',''VT'',''WA'',''WI'',''WV'',''WY'')';

        open r_us_rule for v_sql;
            loop
                fetch r_us_rule into v_territory_code,v_loc_orig_sys_ref,v_attribute_code,v_attribute_value;
                exit when r_us_rule%notfound;
          v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message) VALUES'||
                    '(''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_'||p_stage||''','''||v_loc_orig_sys_ref||''','''||
                    v_attribute_code||''','''||v_attribute_value||''', '''||v_attribute_value||' value is invalid in migration table'')';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );    
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_us_rule;
		
					       gvv_ProgressIndicator := '-CM0060'; --Uppercase rule
		   v_sql  := 'select  distinct src.country,src.location_orig_system_reference,''CITY'',src.city
                      from xxmx_hz_locations_xfm src '||
                     'where src.city != upper(src.city) '||
                     'UNION '||
                     'select  distinct src.country,src.location_orig_system_reference,''COUNTRY'',src.country
                      from xxmx_hz_locations_xfm src '||
                     'where src.country != upper(src.country) '||
                     'UNION '||
                     'select  distinct src.country,src.location_orig_system_reference,''POSTAL_CODE'',src.postal_code '||
                     'from xxmx_hz_locations_xfm src '||
                     'where src.postal_code != upper(src.postal_code) '||
                     'UNION '||
                     'select  distinct src.country,src.location_orig_system_reference,''PROVINCE'',src.province '||
                     'from xxmx_hz_locations_xfm src '||
                     'where src.province != upper(src.province) '||
                     'and src.country != ''CA'' '||
                     'UNION '||
                     'select  distinct src.country,src.location_orig_system_reference,''STATE'',src.state '||
                     'from xxmx_hz_locations_xfm src '||
                     'where src.state != upper(src.state) '||
                     'and src.country not in (''US'',''IN'')';
                     
           

        open r_upc_rule for v_sql;
            loop
                fetch r_upc_rule into v_territory_code,v_loc_orig_sys_ref,v_attribute_code,v_attribute_value;
                exit when r_upc_rule%notfound;
          v_insert := 'insert into xxmx_entity_validation_errors'||
                    '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message) VALUES'||
                    '(''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_xfm'','''||v_loc_orig_sys_ref||''','''||
                    v_attribute_code||''','''||v_attribute_value||''', '''||v_attribute_value||' value should be in uppercase'')';
                xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_ApplicationSuite
                     ,pt_i_Application       => gct_Application
                     ,pt_i_BusinessEntity    => gcv_BusinessEntity
                     ,pt_i_SubEntity         => 'LOCATION'
                     ,pt_i_MigrationSetID    => 0
                     ,pt_i_Phase             => ct_Phase
                     ,pt_i_PackageName       => gcv_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_Severity          => 'NOTIFICATION'               
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => v_insert
                     ,pt_i_OracleError       => NULL
                     );    
                begin
                    execute immediate v_insert;
                exception
                    when others then
                        xxmx_utilities_pkg.log_module_message
                            (
                                  pt_i_ApplicationSuite    => gct_ApplicationSuite
                                 ,pt_i_Application         => gct_Application
                                 ,pt_i_BusinessEntity      => gcv_BusinessEntity
                                 ,pt_i_SubEntity           => 'LOCATION'
                                 ,pt_i_Phase               => ct_Phase
                                 ,pt_i_Severity            => 'ERROR'
                                 ,pt_i_PackageName         => gcv_PackageName
                                 ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                                 ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                 ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                                 ,pt_i_OracleError         => gvt_OracleError
                            );
                end;
            end loop;
        close r_upc_rule;
		
		
		--MR: END

    end if;

/*
    else if p_stage='XFM' then
    for r_rule in c_rule loop
        gvv_SQLStatement := 'insert into xxmx_entity_validation_errors'||
            '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
            ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_xfm'', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '''||
            r_rule.attribute_code||''',''<NULL>'', '''||r_rule.attribute_code||' is mandatory in cloud but is null in migration table'''||
            ' from xxmx_hz_locations_'||P_stage||' xhzlx where xhzlx.country = '''||r_rule.territory_code||
            ''' and xhzlx.'||r_rule.attribute_code||' is null';
        xxmx_utilities_pkg.log_module_message
            (
              pt_i_ApplicationSuite  => gct_ApplicationSuite
             ,pt_i_Application       => gct_Application
             ,pt_i_BusinessEntity    => gcv_BusinessEntity
             ,pt_i_SubEntity         => 'LOCATION'
             ,pt_i_MigrationSetID    => 0
             ,pt_i_Phase             => ct_Phase
             ,pt_i_PackageName       => gcv_PackageName
             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
             ,pt_i_Severity          => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
             ,pt_i_ModuleMessage     => gvv_SQLStatement
             ,pt_i_OracleError       => NULL
             );          
        begin
            execute immediate gvv_SQLStatement;
        exception
            when others then
                xxmx_utilities_pkg.log_module_message
                    (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => 'LOCATION'
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                         ,pt_i_OracleError         => gvt_OracleError
                    );
        end;
    end loop;
    for r_no_rule in c_no_rule loop
        gvv_SQLStatement := 'insert into xxmx_entity_validation_errors'||
            '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
            ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_xfm'', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '||
            '''ADDRESS1'',''<NULL>'', ''ADDRESS1 is mandatory in cloud but is null in migration table'''||
            ' from xxmx_hz_locations_'||p_stage||' xhzlx where xhzlx.country = '''||r_no_rule.country||
            ''' and xhzlx.address1 is null';
        xxmx_utilities_pkg.log_module_message
            (
              pt_i_ApplicationSuite  => gct_ApplicationSuite
             ,pt_i_Application       => gct_Application
             ,pt_i_BusinessEntity    => gcv_BusinessEntity
             ,pt_i_SubEntity         => 'LOCATION'
             ,pt_i_MigrationSetID    => 0
             ,pt_i_Phase             => ct_Phase
             ,pt_i_PackageName       => gcv_PackageName
             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
             ,pt_i_Severity          => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
             ,pt_i_ModuleMessage     => gvv_SQLStatement
             ,pt_i_OracleError       => NULL
             );          
        begin
            execute immediate gvv_SQLStatement;
        exception
            when others then
                xxmx_utilities_pkg.log_module_message
                    (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => 'LOCATION'
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                         ,pt_i_OracleError         => gvt_OracleError
                    );
        end;
        gvv_SQLStatement := 'insert into xxmx_entity_validation_errors'||
            '(entity_code,sub_entity_code,table_name,key_value,column_name,column_value,error_message)'||
            ' select ''CUSTOMERS'', ''LOCATION'', ''xxmx_hz_locations_xfm'', xhzlx.LOCATION_ORIG_SYSTEM_REFERENCE, '||
            '''CITY'',''<NULL>'', ''CITY is mandatory in cloud but is null in migration table'''||
            ' from xxmx_hz_locations_xfm xhzlx where xhzlx.country = '''||r_no_rule.country||
            ''' and xhzlx.city is null';
        xxmx_utilities_pkg.log_module_message
            (
              pt_i_ApplicationSuite  => gct_ApplicationSuite
             ,pt_i_Application       => gct_Application
             ,pt_i_BusinessEntity    => gcv_BusinessEntity
             ,pt_i_SubEntity         => 'LOCATION'
             ,pt_i_MigrationSetID    => 0
             ,pt_i_Phase             => ct_Phase
             ,pt_i_PackageName       => gcv_PackageName
             ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
             ,pt_i_Severity          => 'NOTIFICATION'               
             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
             ,pt_i_ModuleMessage     => gvv_SQLStatement
             ,pt_i_OracleError       => NULL
             );          
        begin
            execute immediate gvv_SQLStatement;
        exception
            when others then
                xxmx_utilities_pkg.log_module_message
                    (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => 'LOCATION'
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                         ,pt_i_OracleError         => gvt_OracleError
                    );
        end;
    end loop;
*/
exception
    when others then
                xxmx_utilities_pkg.log_module_message
                    (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => 'LOCATION'
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'ERROR:'||substr(sqlerrm,1,100)
                         ,pt_i_OracleError         => gvt_OracleError
                    );
                xxmx_utilities_pkg.log_module_message
                    (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gcv_BusinessEntity
                         ,pt_i_SubEntity           => 'LOCATION'
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => v_insert
                         ,pt_i_OracleError         => gvt_OracleError
                    );

end validate_location_address_frmt;
--
procedure truncate_tca_xfm_tables is
    cursor c_xfm_tab is
        select table_name
        from   xxmx_xfm_tables
        where  table_name like 'XXMX_HZ%_XFM'
        union
        select table_name
        from   xxmx_xfm_tables
        where  table_name like 'XXMX_ZX%_XFM';
    v_sql varchar2(60);
begin
    for r_table in c_xfm_tab loop
        v_sql := 'truncate table xxmx_xfm.'||r_table.table_name;
        execute immediate v_sql;
    end loop;
end truncate_tca_xfm_tables;

procedure update_gate1_summary is
    cursor c_stg_tab is
        select stg_table table_name, business_entity, sub_entity
        from   xxmx_migration_metadata
        where  business_entity='CUSTOMERS'
        and    enabled_flag = 'Y'
        and    stg_table is not null;
    v_sql varchar2(6000);
begin
    delete from XXMX_OBJECT_SUMMARY where gate=1 and business_entity='CUSTOMERS';
    for r_table in c_stg_tab loop
        begin
            v_sql := 
                'insert into XXMX_OBJECT_SUMMARY '||
                '(MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, RECORD_COUNT)'||
                ' select migration_set_id,1,'''||r_table.table_name||''','''||r_table.business_entity||''','''||r_table.sub_entity||''','||'count(*)'||
                ' from '||r_table.table_name||' group by migration_set_id';
            execute immediate v_sql;
        exception
            when others then
                null;
        end;
    end loop;
    commit;
end update_gate1_summary;

procedure update_gate2_summary is
    cursor c_xfm_tab is
        select xfm_table table_name, business_entity, sub_entity
        from   xxmx_migration_metadata
        where  business_entity='CUSTOMERS'
        and    enabled_flag = 'Y'
        and    xfm_table is not null;
    v_sql varchar2(6000);
begin
    delete from XXMX_OBJECT_SUMMARY where gate=2 and business_entity='CUSTOMERS';
    for r_table in c_xfm_tab loop
        begin
            v_sql := 
                'insert into XXMX_OBJECT_SUMMARY '||
                '(MIGRATION_SET_ID, GATE, TABLE_NAME, BUSINESS_ENTITY, SUB_ENTITY, RECORD_COUNT)'||
                ' select migration_set_id,2,'''||r_table.table_name||''','''||r_table.business_entity||''','''||r_table.sub_entity||''','||'count(*)'||
                ' from '||r_table.table_name||' group by migration_set_id';
            execute immediate v_sql;
        exception
            when others then
                null;
        end;
    end loop;
    commit;

end update_gate2_summary;

END xxmx_ar_customers_cm_pkg;