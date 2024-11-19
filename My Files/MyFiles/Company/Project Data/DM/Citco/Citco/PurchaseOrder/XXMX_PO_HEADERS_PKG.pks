create or replace PACKAGE  XXMX_PO_HEADERS_PKG AS
    /****************************************************************
	----------------Export PO Headers--------------------------------
	*****************************************************************/
    PROCEDURE stg_main
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) ;

    PROCEDURE export_po_headers_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);


	PROCEDURE export_po_lines_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_line_locations_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_distributions_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_headers_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);


	PROCEDURE export_po_lines_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_line_locations_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_headers_cpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

END  XXMX_PO_HEADERS_PKG;


