--------------------------------------------------------
--  DDL for Package XXMX_PROJECT_TRANSACTION_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_PROJECT_TRANSACTION_EXT_PKG" AUTHID CURRENT_USER
AS
--//======================================================================================================
--// Version1
--// $Id:$
--//======================================================================================================
--// Object Name        :: xxmx_project_transaction_ext_pkg.pkh
--//
--// Object Type        :: Package Header
--//
--// Object Description :: This package contains Procedures for applying transformation rules after
--//                       copying from STG and applying simple transforms
--//
--// Version Control
--//======================================================================================================
--// Version      Author               Date               Description
--//------------------------------------------------------------------------------------------------------
--// 1.0          Rafikahmada Mujawar  25/01/2022         Initial Build
--//======================================================================================================
--
-- -------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform Costs
-- -------------------------------------------------------------------------------------------------------
--
      PROCEDURE transform_costs (
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
--
---------------------------------------------------------------------------------------------------------
-- PROCEDURE: Transform Billing Events
---------------------------------------------------------------------------------------------------------
--
	PROCEDURE transform_events(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
					);
--
END xxmx_project_transaction_ext_pkg;

/