--------------------------------------------------------
--  DDL for Package XXMX_AP_INV_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_AP_INV_PKG" AUTHID CURRENT_USER
AS
     --
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_stg
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_xfm
     ********************************
     */
     --
     PROCEDURE ap_invoice_hdr_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_stg
     **********************************
     */
     --
     PROCEDURE ap_invoice_lines_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: ap_invoice_lines_xfm
     **********************************
     */
     --
     PROCEDURE ap_invoice_lines_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
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
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
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
END xxmx_ap_inv_pkg;

/
