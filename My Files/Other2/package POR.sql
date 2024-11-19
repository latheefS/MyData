create or replace PACKAGE  xxrbkc_purchace_order_ext_pkg 
AS
--//=====================================================================================================
--// Object Name        :: xxrbkc_purchace_order_ext_pkg.pkh
--//
--//
--// Version Control
--//=====================================================================================================
--// Version      Author               Date               Description
--//-----------------------------------------------------------------------------------------------------
--// 1.0          Aishwarya           10/01/2024         Initial Build
--//=====================================================================================================
--
-- 
 /*
     ********************************
     ** PROCEDURE: - Defaulting the coulmns of Purchace order while importing data from EXT to STG
     ********************************
     */
--
--
	PROCEDURE default_purchace_order(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

end xxrbkc_purchace_order_ext_pkg;
/
create or replace PACKAGE BODY xxrbkc_purchace_order_ext_pkg 
AS
--//=====================================================================================================
--// Object Name        :: xxrbkc_purchace_order_ext_pkg.pkh
--//
--//
--// Version Control
--//=====================================================================================================
--// Version      Author               Date               Description
--//-----------------------------------------------------------------------------------------------------
--// 1.0          Aishwarya           10/01/2024         Initial Build
--//=====================================================================================================
     --
	 --
     /*
     ********************************
     ** PROCEDURE: default_purchace_order runs from Extract
     ********************************
     */
     --
     --

	PROCEDURE default_purchace_order(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	 IS
    BEGIN
        --

        Update XXMX_SCM_PO_HEADERS_STD_STG 
        set APPROVAL_ACTION = 'BYPASS',
			DOCUMENT_TYPE_CODE = 'STANDARD'	
        where migration_set_id = pt_i_MigrationSetID;

		
		--
		--
		Update XXMX_SCM_PO_LINES_STD_STG 
        set ACTION = 'ADD'
        where migration_set_id = pt_i_MigrationSetID;

		
		--
		--
		Update XXMX_SCM_PO_LINE_LOCATIONS_STD_STG 
        set DESTINATION_TYPE_CODE = 'EXPENSE'
        where migration_set_id = pt_i_MigrationSetID;

        

		--
		--
		Update XXMX_SCM_PO_DISTRIBUTIONS_STD_STG 
        set DISTRIBUTION_NUM = '1'
        where migration_set_id = pt_i_MigrationSetID;

        commit; 

  	END default_purchace_order;

end xxrbkc_purchace_order_ext_pkg;