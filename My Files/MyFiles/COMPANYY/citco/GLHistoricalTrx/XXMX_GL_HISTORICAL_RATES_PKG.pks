create or replace PACKAGE xxmx_gl_historical_rates_pkg AUTHID CURRENT_USER
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Historical Rates Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 08-11-2022     Meenakshi Rajendran        Initial version
-- ===========================================================================*/
     --
     --
     --*****************************
     --** PROCEDURE: gl_historicalrates_stg
     --*****************************
     --
     procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );

     PROCEDURE gl_historical_rates_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     --*****************************
     --** PROCEDURE: gl_historicalrates_xfm
     --*****************************
     --
     PROCEDURE gl_historical_rates_xfm
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
     --
     --
     --*******************
     --** PROCEDURE: purge
     --*******************

     PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );


     --** END PROCEDURE purge

end xxmx_gl_historical_rates_pkg;
