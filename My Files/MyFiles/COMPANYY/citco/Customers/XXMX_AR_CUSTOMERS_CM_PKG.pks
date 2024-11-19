create or replace PACKAGE XXMX_AR_CUSTOMERS_CM_PKG as
--
-- -------------------------------------------------------------------------- --
-- ------------------------ update_migration_set_id ------------------------- --
-- -------------------------------------------------------------------------- --
procedure update_migration_set_id;
--
  --
    --
    -- ------------------------------------------------------------------------------
    -- ------------------------------< customers_cm_stg >----------------------------
    -- ------------------------------------------------------------------------------
    --
PROCEDURE customers_cm_stg 
                        (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        );
--
procedure update_customer_pk_values_with_suffix
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_i_suffix                     IN      varchar2
                    );
--
procedure update_customer_pk_values_with_suffix_xfm
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_i_suffix                     IN      varchar2
                    );
--
PROCEDURE update_migration_set_id (p_migration_set_id in number);
--
PROCEDURE create_one_party_for_each_cust
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
    --
PROCEDURE create_one_loc_for_each_site
                    (
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
    --
procedure validate_location_address_frmt
(
    p_stage               in varchar2
);
--
procedure validate_hz_tab_ref_integrity
(
    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
);
--
procedure truncate_tca_xfm_tables;
procedure update_gate1_summary;
procedure update_gate2_summary;



END xxmx_ar_customers_cm_pkg;