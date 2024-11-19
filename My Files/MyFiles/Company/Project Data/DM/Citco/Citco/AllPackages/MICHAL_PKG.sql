--------------------------------------------------------
--  DDL for Package MICHAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."MICHAL_PKG" AUTHID CURRENT_USER 
is
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
-- =============================================================================
--
PROCEDURE ar_original_cash_receipts_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
--
--
end michal_pkg;

/
