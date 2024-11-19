create or replace PACKAGE XXMX_CUSTOMER_TAX_PROFILE_PKG AUTHID CURRENT_USER AS
-- =============================================================================
-- | VERSION1 |
-- =============================================================================
--
-- NAME
-- XXMX_CUSTOMER_TAX_PROFILE_PKG
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
-- 08/11/2022 Michal Arrowsmith hz_cust_acct_sites_stg:
--                              The customer_account and the party_site_number
--                              are null as they are not needed for the FBDI.
--                              Just need to change the RECON report to reflect that.
-- =============================================================================
--
--
--
PROCEDURE party_tax_profile_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
    --
     PROCEDURE party_tax_classific_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     PROCEDURE xxmx_zx_tax_registration_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
    --
    PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
    --
    PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
     --
     PROCEDURE purge
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
                    --
                    --
     --
     --
END xxmx_customer_tax_profile_pkg;