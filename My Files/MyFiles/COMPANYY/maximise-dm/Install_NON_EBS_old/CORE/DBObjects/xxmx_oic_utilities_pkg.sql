CREATE OR REPLACE PACKAGE xxmx_oic_utilities_pkg
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


CREATE OR REPLACE PACKAGE BODY xxmx_oic_utilities_pkg
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
					)
    AS
        vt_DataFileName                 xxmx_migration_metadata.data_file_name%TYPE;
    BEGIN
        pv_o_OIC_Internal := xxmx_utilities_pkg.get_file_location(pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'OIC','DATA','OIC_INTERNAL');
        pv_o_FTP_Data     := xxmx_utilities_pkg.get_file_location(pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'OIC','DATA','FTP_DATA');                  
        pv_o_FTP_Process  := xxmx_utilities_pkg.get_file_location(pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'OIC','DATA','FTP_PROCESS');                
        pv_o_FTP_Out      := xxmx_utilities_pkg.get_file_location(pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'OIC','DATA','FTP_OUTPUT');                
        pv_o_ZIP_Filename := xxmx_utilities_pkg.gen_file_name('ZIP',pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'xxx');                  
        pv_o_PROPERTY_Filename := xxmx_utilities_pkg.gen_file_name('PROPERTIES',pt_i_ApplicationSuite,pt_i_Application,pt_i_BusinessEntity,pt_i_FileGroupNumber,'XXX');
    END;
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
                    ) IS
    Cursor c_avg_rec(p_FileName in VARCHAR2) is 
        SELECT avg_row_len
        FROM   all_tables
        WHERE  owner = pt_i_Owner --'xxmx_xfm'
        AND    table_name = upper(ltrim(rtrim(p_FileName)));

        v_BufferSize   NUMBER := 9.5*1024*1024; -- in 9.5 MB in bytes
        v_RecLen       NUMBER := 0;
        v_TotalRecs    NUMBER := -1;
        v_Chunk        NUMBER := 0;
        v_Status       VARCHAR2(3);
     BEGIN
        v_Status := 'S';

        OPEN c_avg_rec(pt_i_FileName);
        FETCH c_avg_rec into v_RecLen;
        IF c_avg_rec%NOTFOUND THEN
           v_RecLen := 0;
        END IF;
        CLOSE c_avg_rec;

        IF (v_Status = 'S' and v_RecLen > 0) THEN
           v_TotalRecs := XXMX_UTILITIES_PKG.GET_ROW_COUNT(pt_i_Owner,ltrim(rtrim(pt_i_FileName)),''); -- Get Total Records
           v_Chunk     := trunc(v_BufferSize / v_RecLen); -- Chunk Size to remain under 10M
        END IF;

        pt_o_ChunkSize := v_Chunk;  -- 500
        pt_o_TotalRecs := v_TotalRecs;
        pt_o_Status    := v_Status;
     EXCEPTION
        WHEN OTHERS THEN
           pt_o_ChunkSize := 0;
           pt_o_TotalRecs := -1;
           pt_o_Status    := 'E';
     END;
     --
     PROCEDURE get_chunk_size_msi
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID            IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    ) IS
    Cursor c_avg_rec(p_FileName in VARCHAR2) is 
        SELECT avg_row_len
        FROM   all_tables
        WHERE  owner = pt_i_Owner --'xxmx_xfm'
        AND    table_name = upper(ltrim(rtrim(p_FileName)));

        v_BufferSize   NUMBER := 9.5*1024*1024; -- in 9.5 MB in bytes
        v_RecLen       NUMBER := 0;
        v_TotalRecs    NUMBER := -1;
        v_Chunk        NUMBER := 0;
        v_Status       VARCHAR2(3);
     BEGIN
        v_Status := 'S';

        OPEN c_avg_rec(pt_i_FileName);
        FETCH c_avg_rec into v_RecLen;
        IF c_avg_rec%NOTFOUND THEN
           v_RecLen := 0;
        END IF;
        CLOSE c_avg_rec;

        IF (v_Status = 'S' and v_RecLen > 0) THEN
           v_TotalRecs := XXMX_UTILITIES_PKG.GET_ROW_COUNT(pt_i_Owner,ltrim(rtrim(pt_i_FileName)),pt_i_MigrationSetID); -- Get Total Records
           v_Chunk     := trunc(v_BufferSize / v_RecLen); -- Chunk Size to remain under 10M
        END IF;

        pt_o_ChunkSize := v_Chunk;  -- 500
        pt_o_TotalRecs := v_TotalRecs;
        pt_o_Status    := v_Status;
     EXCEPTION
        WHEN OTHERS THEN
           pt_o_ChunkSize := 0;
           pt_o_TotalRecs := -1;
           pt_o_Status    := 'E';
     END;
     --
     PROCEDURE get_chunk_size_msi_lgr
                    (
                     pt_i_Owner                     IN      VARCHAR2
                    ,pt_i_FileName                 IN      VARCHAR2
                    ,pt_i_MigrationSetID            IN      VARCHAR2
                    ,pt_i_LedgerName                IN      VARCHAR2
                    ,pt_o_ChunkSize                OUT      VARCHAR2
                    ,pt_o_TotalRecs                OUT      VARCHAR2
                    ,pt_o_Status                   OUT      VARCHAR2
                    ) IS
    Cursor c_avg_rec(p_FileName in VARCHAR2) is 
        SELECT avg_row_len
        FROM   all_tables
        WHERE  owner = pt_i_Owner --'xxmx_xfm'
        AND    table_name = upper(ltrim(rtrim(p_FileName)));

        v_BufferSize NUMBER := 9.5*1024*1024; -- in 9.5 MB in bytes
        v_RecLen     NUMBER := 0;
        v_TotalRecs  NUMBER := -1;
        v_Chunk      NUMBER := 0;
        v_Status     VARCHAR2(3);
     BEGIN
        v_Status := 'S';

        OPEN c_avg_rec(pt_i_FileName);
        FETCH c_avg_rec into v_RecLen;
        IF c_avg_rec%NOTFOUND THEN
           v_RecLen := 0;
        END IF;
        CLOSE c_avg_rec;

        IF (v_Status = 'S' and v_RecLen > 0) THEN
           IF upper(ltrim(rtrim(pt_i_FileName))) = 'XXMX_AP_INVOICE_LINES_XFM' THEN
              select count(1) into v_TotalRecs
              from  xxmx_ap_invoices_xfm h,
                    xxmx_ap_invoice_lines_xfm l
              where l.migration_set_id = pt_i_MigrationSetID
              and   h.migration_set_id = l.migration_set_id
              and   h.invoice_id = l.invoice_id
              and   h.fusion_ledger_name = pt_i_LedgerName;
           ELSE
              v_TotalRecs := XXMX_UTILITIES_PKG.GET_ROW_COUNT(pt_i_Owner,ltrim(rtrim(pt_i_FileName)),pt_i_MigrationSetID,'AND FUSION_LEDGER_NAME = '''||pt_i_LedgerName||'''','','','',''); -- Get Total Records
           END IF;
           v_Chunk     := trunc(v_BufferSize / v_RecLen); -- Chunk Size to remain under 10M
        END IF;

        pt_o_ChunkSize := v_Chunk;  -- 500
        pt_o_TotalRecs := v_TotalRecs;
        pt_o_Status    := v_Status;
     EXCEPTION
        WHEN OTHERS THEN
           pt_o_ChunkSize := 0;
           pt_o_TotalRecs := -1;
           pt_o_Status    := 'E';
     END;
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
                    ) IS
    Cursor c_avg_rec(p_FileName in VARCHAR2) is 
        SELECT avg_row_len
        FROM   all_tables
        WHERE  owner = pt_i_Owner --'xxmx_xfm'
        AND    table_name = upper(ltrim(rtrim(p_FileName)));

        v_BufferSize NUMBER := 9.5*1024*1024; -- in 9.5 MB in bytes
        v_RecLen     NUMBER := 0;
        v_TotalRecs  NUMBER := -1;
        v_Chunk      NUMBER := 0;
        v_Status     VARCHAR2(3);
     BEGIN
        v_Status := 'S';

        OPEN c_avg_rec(pt_i_FileName);
        FETCH c_avg_rec into v_RecLen;
        IF c_avg_rec%NOTFOUND THEN
           v_RecLen := 0;
        END IF;
        CLOSE c_avg_rec;

        v_TotalRecs := XXMX_UTILITIES_PKG.GET_ROW_COUNT(pt_i_Owner,ltrim(rtrim(pt_i_FileName)),pt_i_MigrationSetID,'AND FUSION_BUSINESS_UNIT = '''||pt_i_BUName||'''','','','',''); -- Get Total Records
        v_Chunk     := trunc(v_BufferSize / v_RecLen); -- Chunk Size to remain under 10M

        pt_o_ChunkSize := v_Chunk;  -- 500
        pt_o_TotalRecs := v_TotalRecs;
        pt_o_Status    := v_Status;
     EXCEPTION
        WHEN OTHERS THEN
           pt_o_ChunkSize := 0;
           pt_o_TotalRecs := -1;
           pt_o_Status    := 'E';
     END;
     --
     --
     --
     FUNCTION get_fusion_business_unit
                   (
                     pt_i_SourceOperatingUnitName   IN      VARCHAR2
                    )
     RETURN VARCHAR2 IS
        v_BusName   VARCHAR2(255);
        v_BusID     NUMBER;
        v_Status    VARCHAR2(255);
        v_Msg       VARCHAR2(255);
     BEGIN
        xxmx_utilities_pkg.get_fusion_business_unit
        (
           pt_i_SourceOperatingUnitName => pt_i_SourceOperatingUnitName
          ,pt_o_FusionBusinessUnitName  => v_BusName
          ,pt_o_FusionBusinessUnitID    => v_BusID
          ,pv_o_ReturnStatus            => v_Status
          ,pt_o_ReturnMessage           => v_Msg
        );          
     --
        IF v_Status = 'S' THEN
           RETURN v_BusName;
        ELSE
           RETURN 'NO_MAPPING';
        END IF;
     --
     EXCEPTION
        WHEN OTHERS THEN
           RETURN 'PKG_ERROR';
     END;
     --     
     FUNCTION upd_fusion_business_unit
                    (
                      pt_i_MigrationSetID           IN      VARCHAR2
                     ,pt_i_TableName                IN      VARCHAR2
                    ) 
     RETURN VARCHAR2 IS
     BEGIN
        IF pt_i_TableName = 'DISTS' THEN
           UPDATE  XXMX_AR_TRX_DISTS_XFM
           SET    fusion_business_unit = xxmx_oic_utilities_pkg.get_fusion_business_unit(fusion_business_unit)
           WHERE  migration_set_id = pt_i_MigrationSetID;
        ELSIF pt_i_TableName = 'LINES' THEN
           UPDATE  XXMX_AR_TRX_LINES_XFM
           SET    fusion_business_unit = xxmx_oic_utilities_pkg.get_fusion_business_unit(fusion_business_unit)
           WHERE  migration_set_id = pt_i_MigrationSetID;
        ELSIF pt_i_TableName = 'SALESCREDITS' THEN
           UPDATE  XXMX_AR_TRX_SALESCREDITS_XFM
           SET    fusion_business_unit = xxmx_oic_utilities_pkg.get_fusion_business_unit(fusion_business_unit)
           WHERE  migration_set_id = pt_i_MigrationSetID;
        END IF;

        RETURN 'S';
     EXCEPTION
        WHEN OTHERS THEN
           RETURN 'E';
     END;
     --
     FUNCTION upd_fusion_ledger_name
                    (
                      pt_i_MigrationSetID          IN      VARCHAR2
                    ) 
     RETURN VARCHAR2 IS
     BEGIN
        UPDATE  XXMX_AR_TRX_DISTS_XFM d
        SET    d.fusion_ledger_name = xxmx_utilities_pkg.get_transform_fusion_value(pt_i_ApplicationSuite => 'FIN'
                                                                                   ,pt_i_Application      => 'GL'
                                                                                   ,pt_i_CategoryCode     => 'LEDGER_NAME'
                                                                                   ,pt_i_SourceValue      => d.fusion_ledger_name)
        WHERE  d.migration_set_id = pt_i_MigrationSetID;

        RETURN 'S';
     EXCEPTION
        WHEN OTHERS THEN
           RETURN 'E';
     END;     
END xxmx_oic_utilities_pkg;
/
