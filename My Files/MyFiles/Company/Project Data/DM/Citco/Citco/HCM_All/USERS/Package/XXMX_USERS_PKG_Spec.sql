create or replace PACKAGE XXMX_USERS_PKG AUTHID CURRENT_USER AS
--
procedure stg_main
(
    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
);
procedure purge
(
                         pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                        ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
);
procedure users_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID            in      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
);
--
procedure resp_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID            in      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
);
--
procedure data_access_stg
(
     p_bg_name                      in      VARCHAR2
    ,p_bg_id                        in      NUMBER
    ,pt_i_MigrationSetID            in      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          in      xxmx_migration_headers.migration_set_name%TYPE
);
--
procedure map_responsibilities 
( 
    pt_i_applicationsuite      IN    xxmx_seeded_extensions.application_suite%TYPE,
    pt_i_application           IN    xxmx_seeded_extensions.application%TYPE,
    pt_i_businessentity        IN    xxmx_seeded_extensions.business_entity%TYPE,
    pt_i_stgpopulationmethod   IN    xxmx_core_parameters.parameter_value%TYPE,
    pt_i_filesetid             IN    xxmx_migration_headers.file_set_id%TYPE,
    pt_i_migrationsetid        IN    xxmx_migration_headers.migration_set_id%TYPE,
    pv_o_returnstatus          OUT   VARCHAR2
);
--
end xxmx_users_pkg;