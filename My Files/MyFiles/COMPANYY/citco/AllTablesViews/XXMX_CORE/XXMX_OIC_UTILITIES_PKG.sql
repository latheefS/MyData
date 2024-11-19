--------------------------------------------------------
--  DDL for Package XXMX_OIC_UTILITIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_OIC_UTILITIES_PKG" 
IS
     --
     --
     --***************
     --** GLOBAL TYPES
     --***************
     --
     TYPE g_ParamValueList_tt               IS TABLE OF xxmx_migration_parameters.parameter_value%TYPE;
     --
     --*******************
     --** GLOBAL CONSTANTS
     --*******************
     --
     --
     --*******************
     --** GLOBAL VARIABLES
     --*******************
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     gvv_UserName                                       VARCHAR2(100)   := UPPER(sys_context('userenv','OS_USER'));
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     gcn_BulkCollectLimit                      CONSTANT NUMBER := 1000;    -- cursor fetch limit
     --
     --**************************************
     --** PROCEDURE AND FUNCTION DECLARATIONS
     --**************************************
     --
     --**************************************************************
     --** The following procedure returns all the filenames and
	 --** directories required for migrating the data associated
	 --** associated with the related business/sub entity.
     --*************************************************************
     --
     PROCEDURE get_file_and_directory_details
					(
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_migration_metadata.file_group_number%TYPE
                    ,pv_o_OIC_Internal              OUT  VARCHAR2
                    ,pv_o_FTP_Data                  OUT  VARCHAR2
                    ,pv_o_FTP_Process               OUT  VARCHAR2
                    ,pv_o_FTP_Out                   OUT  VARCHAR2
                    ,pv_o_ZIP_Filename              OUT  VARCHAR2
                    ,pv_o_PROPERTY_Filename         OUT  VARCHAR2
					);
                    --
     --** END PROCEDURE get_file_and_directory_details
     --
     PROCEDURE get_chunk_size
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                  IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    ) ;
     --
     PROCEDURE get_chunk_size_msi
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID            IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    ) ;
     --
     PROCEDURE get_chunk_size_msi_lgr
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID            IN      VARCHAR2
                    ,pt_i_LedgerName                IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    ) ;
     --
     PROCEDURE get_chunk_size_msi_bu
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID            IN      VARCHAR2
                    ,pt_i_BUName                    IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    );
     --
     FUNCTION get_fusion_business_unit
                   (
                     pt_i_SourceOperatingUnitName   IN      VARCHAR2
                    )
     RETURN VARCHAR2;
     --
     FUNCTION upd_fusion_business_unit
                    (
                      pt_i_MigrationSetID           IN      VARCHAR2
                     ,pt_i_TableName                IN      VARCHAR2
                    )
     RETURN VARCHAR2;
     --
     FUNCTION upd_fusion_ledger_name
                    (
                      pt_i_MigrationSetID          IN      VARCHAR2
                    )
     RETURN VARCHAR2;
     --
END xxmx_oic_utilities_pkg;

/
