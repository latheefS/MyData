--------------------------------------------------------
--  DDL for Package XXMX_SUPPLIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_SUPPLIER_PKG" AUTHID CURRENT_USER
AS
     --
     --
     /*
     ******************************
     ** PROCEDURE: ap_suppliers_stg
     ******************************
     */
     --
     PROCEDURE ap_suppliers_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ***************************************
     ** PROCEDURE: ap_supplier_addresses_stg
     ***************************************
     */
     --
     PROCEDURE ap_supplier_addresses_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ***********************************
     ** PROCEDURE: ap_supplier_sites_stg
     ***********************************
     */
     --
     PROCEDURE ap_supplier_sites_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supp_3rd_party_rels_stg
     ****************************************
     */
     --
     PROCEDURE ap_supp_3rd_party_rels_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supp_site_assigns_stg
     **************************************
     */
     --
     PROCEDURE ap_supp_site_assigns_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **************************************
     ** PROCEDURE: ap_supplier_contacts_stg
     **************************************
     */
     --
     PROCEDURE ap_supplier_contacts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     *******************************************
     ** PROCEDURE: ap_supplier_contact_addrs_stg
     *******************************************
     */
     --
     PROCEDURE ap_supplier_contact_addrs_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ************************************
     ** PROCEDURE: ap_supplier_payees_stg
     ************************************
     */
     --
     PROCEDURE ap_supplier_payees_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_bank_accts_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_bank_accts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ****************************************
     ** PROCEDURE: ap_supplier_pmt_instrs_stg
     ****************************************
     */
     --
     PROCEDURE ap_supplier_pmt_instrs_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
     */
     --
     PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --
     PROCEDURE purge
                   (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
      --
      --
END xxmx_supplier_pkg;

/
