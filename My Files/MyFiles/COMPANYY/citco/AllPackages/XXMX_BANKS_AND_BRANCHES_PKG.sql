--------------------------------------------------------
--  DDL for Package XXMX_BANKS_AND_BRANCHES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_BANKS_AND_BRANCHES_PKG" AUTHID CURRENT_USER
AS
     --
     --
     /*
     ***********************
     ** PROCEDURE: banks_stg
     ***********************
     */
     --
     PROCEDURE banks_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
                    --
                    --
     --** END PROCEDURE banks_stg
     --
     --
     /*
     *******************************
     ** PROCEDURE: bank_branches_stg
     *******************************
     */
     --
     PROCEDURE bank_branches_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
                    --
                    --
     --** END PROCEDURE bank_branches_stg
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
     --** END PROCEDURE bank_branches_stg
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
     --** END PROCEDURE purge
     --
     --
END xxmx_banks_and_branches_pkg;

/
