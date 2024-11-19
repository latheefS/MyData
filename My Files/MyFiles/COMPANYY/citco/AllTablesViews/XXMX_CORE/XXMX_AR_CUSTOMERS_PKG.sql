--------------------------------------------------------
--  DDL for Package XXMX_AR_CUSTOMERS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_AR_CUSTOMERS_PKG" AUTHID CURRENT_USER AS
-- =============================================================================
-- | VERSION1 |
-- =============================================================================
--
-- NAME
-- XXMX_AR_CUSTOMERS_PKG
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
-- =============================================================================
--
    --
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_parties_stg >----------------------------
    -- ------------------------------------------------------------------------------
    --
    PROCEDURE hz_parties_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_party_sites_stg >-----------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_party_sites_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_party_site_uses_stg >------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_party_site_uses_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- -------------------------------< hz_cust_accounts_stg >--------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_cust_accounts_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_cust_acct_sites_stg >--------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_cust_acct_sites_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hzr_account_site_uses_stg >----------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_account_site_uses_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_customer_profiles_stg >-------------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_customer_profiles_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_locations_stg >-------------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_locations_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_relationships_stg >---------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_relationships_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_cust_acct_contact_stg >----------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_cust_acct_contact_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_org_contacts_stg >-------------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_org_contacts_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_contact_roles_stg >--------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_contact_roles_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_contact_points_stg >-------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_contact_points_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_person_language_stg >----------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_person_language_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_party_classifs_stg >-------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_party_classifs_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_role_resps_stg >-------------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE hz_role_resps_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                         );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< hz_cust_acct_relate_stg >----------------------
    -- -----------------------------------------------------------------------------
    PROCEDURE hz_cust_acct_relate_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< ra_cust_rcpt_methods_stg >-------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE ra_cust_rcpt_methods_stg
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
    --
    -- ------------------------------------------------------------------------------
    -- ----------------------------------< ar_cust_banks_stg >-----------------------
    -- ------------------------------------------------------------------------------
    PROCEDURE ar_cust_banks_stg
                        (
                         pt_i_MigrationSetID   IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity        IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
         --
         --
         --******************
         --** PROCEDURE: stg_main
         --******************
         PROCEDURE stg_main
                        (
                         pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                        ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                        );
         --
         --
         --*******************
         --** PROCEDURE: purge
         --*******************
         --
         PROCEDURE purge
                       (
                         pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                        ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                       );
         --
         --
    END xxmx_ar_customers_pkg;

/
