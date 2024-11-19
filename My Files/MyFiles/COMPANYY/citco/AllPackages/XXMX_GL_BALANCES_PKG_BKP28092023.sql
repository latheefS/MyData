--------------------------------------------------------
--  DDL for Package XXMX_GL_BALANCES_PKG_BKP28092023
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_GL_BALANCES_PKG_BKP28092023" AUTHID CURRENT_USER
AS
-- =============================================================================
-- |                                  Version1                                 |
-- =============================================================================
--  DESCRIPTION
--    GL Balance Migration
-- -----------------------------------------------------------------------------
-- Change List
-- ===========
-- Date           Author                    Comment
-- -----------    --------------------      ------------------------------------
-- 27/02/2022     Prabhat Kumar Sahu        Initial version
-- 25/04/2022     Michal Arrowsmith         Changes to work with new version of MAXIMISE
-- 27/04/2022     Michal Arrowsmith         Changes to work with new version of MAXIMISE
-- ===========================================================================*/
--
--
--*****************************
--** PROCEDURE: gl_opening_balances_stg
--*****************************
--
PROCEDURE gl_opening_balances_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
--*****************************
--** PROCEDURE: gl_summarybalances_stg
--*****************************
--
PROCEDURE gl_summary_balances_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
--*****************************
--** PROCEDURE: gl_detail_balances_stg
--*****************************
--
PROCEDURE gl_detail_balances_stg
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
--
--
--**********************
--** PROCEDURE: stg_main
--**********************
--
PROCEDURE stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
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
end XXMX_GL_BALANCES_PKG_bkp28092023;

/
