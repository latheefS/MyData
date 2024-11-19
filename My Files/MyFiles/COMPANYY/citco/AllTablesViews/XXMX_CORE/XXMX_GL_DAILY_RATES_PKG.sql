--------------------------------------------------------
--  DDL for Package XXMX_GL_DAILY_RATES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_GL_DAILY_RATES_PKG" AUTHID CURRENT_USER
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Daily Rates Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 09/02/2022     Prabhat Kumar Sahu        Initial version
-- 05/05/2022     Michal Arrowsmith         add a date parameter
-- ===========================================================================*/
     --
     --
     --*****************************
     --** PROCEDURE: gl_dailyrates_stg
     --*****************************
     --
     procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );

     PROCEDURE gl_daily_rates_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     --*****************************
     --** PROCEDURE: gl_dailyrates_xfm
     --*****************************
     --
     PROCEDURE gl_daily_rates_xfm
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
--                    ,pv_cutoffdate IN VARCHAR2
                    );
     --
     --
     --**********************
     --** PROCEDURE: stg_main
     --**********************
     --
--     PROCEDURE stg_main
--                    (
--                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
--                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
--                    );
                    --
                    --
     --** END PROCEDURE stg_main
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
--     PROCEDURE xfm_main
--                    (
--                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
--                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_ID%TYPE
--                    );
                    --
                    --
     --** END PROCEDURE xfm_main
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

end xxmx_gl_daily_rates_pkg;

/
