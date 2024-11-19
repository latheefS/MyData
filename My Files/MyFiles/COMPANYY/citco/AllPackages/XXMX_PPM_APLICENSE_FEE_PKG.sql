--------------------------------------------------------
--  DDL for Package XXMX_PPM_APLICENSE_FEE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_PPM_APLICENSE_FEE_PKG" AUTHID CURRENT_USER
AS
     --
     --
     /*
     ********************************
     ** PROCEDURE: ap_invoice_hdr_stg
     ********************************
     */
     --
     PROCEDURE lic_unpaid_stg
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
     PROCEDURE lic_unpaid_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
      --
      --
END XXMX_PPM_APLICENSE_FEE_PKG;

/
