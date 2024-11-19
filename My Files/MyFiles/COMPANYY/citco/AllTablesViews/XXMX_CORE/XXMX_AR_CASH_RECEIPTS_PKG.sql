--------------------------------------------------------
--  DDL for Package XXMX_AR_CASH_RECEIPTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_AR_CASH_RECEIPTS_PKG" AUTHID CURRENT_USER 
AS
-- ================================================================================
-- | VERSION1 |
-- =============================================================================
--
-- FILENAME
-- XXMX_AR_CASH_RECEIPTS_PKG.sql
--
-- DESCRIPTION
-- AR cash receipts extract
-- -----------------------------------------------------------------------------
--
-- Change List
-- ===========
--
-- Date       Author            Comment
-- ---------- ----------------- -------------------- ----------------------------
-- 29/06/2022 Michal Arrowsmith NEW: ar_original_cash_receipts_stg
-- 27/07/2023 Michal Arrowsmith Add mapping procedure
-- 31/07/2023 Michal Arrowsmith move the processing of lockbox and other cal/format columns to G2
-- =============================================================================
--
PROCEDURE ar_original_cash_receipts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
--
PROCEDURE ar_original_cash_receipts_xfm
(
    pt_i_ApplicationSuite       in varchar2,
    pt_i_Application            in varchar2,
    pt_i_BusinessEntity         in varchar2,
    pt_i_StgPopulationMethod    in varchar2,
    pt_i_FileSetID              in varchar2,
    pt_i_MigrationSetID         in number,
    pv_o_ReturnStatus           out varchar2
);
--
PROCEDURE stg_main
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
procedure generate_csv_file
    (
         pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_BusinessEntity            IN      xxmx_migration_metadata.business_entity%TYPE
        ,pt_i_FileName                  IN      xxmx_migration_metadata.data_file_name%TYPE
        ,pt_i_SubEntity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
    );
--

procedure map_operating_unit
( 
    pt_i_ApplicationSuite       in varchar2,
    pt_i_Application            in varchar2,
    pt_i_BusinessEntity         in varchar2,
    pt_i_StgPopulationMethod    in varchar2,
    pt_i_FileSetID              in varchar2,
    pt_i_MigrationSetID         in number,
    pv_o_ReturnStatus           out varchar2
);
--
end xxmx_ar_cash_receipts_pkg;

/
