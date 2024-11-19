--------------------------------------------------------
--  File created - Friday-April-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Package XXMX_GL_BALANCES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_GL_BALANCES_PKG" 
AS
     --
     --
     --*****************************
     --** PROCEDURE: gl_balances_stg
     --*****************************
     --
     PROCEDURE gl_balances_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
                    --
                    --
     --** END PROCEDURE gl_balances_stg
     --
     --
	 --**Commented by Shireesha TR, this was developed by SMBC 
     /*
     *****************************
     ** PROCEDURE: gl_balances_xfm
     *****************************
     */
     --
    /* PROCEDURE gl_balances_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );
                    --
                    --
	 */				
     --** END PROCEDURE gl_balances_xfm
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
                    --
     --** END PROCEDURE stg_main
     --
     --
	 --**Commented by Shireesha TR, this was developed by SMBC 
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     /* PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_ID%TYPE
                    );
	 */				
                    --
                    --
     --** END PROCEDURE xfm_main
     --
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
     --** END PROCEDURE purge
     --
     --
     --*******************
     --** PROCEDURE: purge
     --*******************
     --
   /*  PROCEDURE update_accounted_values
                   (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
                   --
                   --
    */               
     --** END PROCEDURE purge
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


end xxmx_gl_balances_pkg;

/
