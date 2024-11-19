create or replace PACKAGE XXMX_AR_CASH_RECEIPTS_EXT_pkg AUTHID CURRENT_USER
AS
      PROCEDURE transform_cash(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

END XXMX_AR_CASH_RECEIPTS_EXT_pkg;


create or replace PACKAGE BODY XXMX_AR_CASH_RECEIPTS_EXT_pkg
AS

	PROCEDURE transform_cash(
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

        Update XXMX_AR_CASH_RECEIPTS_STG a
        set Document_Number = (Select SAP_Document_number 
                                        from XXMX_AR_CASH_RECEIPTS_EXT b
                                        where a.Receipt_Number = b.Receipt_Number),
        Reference_Type =(select SAP_Document_type
								from XXMX_AR_CASH_RECEIPTS_EXT b
								where a.Receipt_Number = b.Receipt_Number)
        where migration_set_id = pt_i_MigrationSetID;

        commit; 

  	END transform_cash;
	 --
   	 --
	 --
END XXMX_AR_CASH_RECEIPTS_EXT_pkg;