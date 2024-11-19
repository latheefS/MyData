--******************************************************************************
--**
--** xxmx_stg_populate_wie_material_trans.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Interface Batch
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'INTERFACE_BATCH',
    pt_import_data_file_name => 'XXMX_SCM_INTERFACE_BATCH_STG.csv',
    pt_control_file_name => 'XXMX_SCM_INTERFACE_BATCH_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Material Transaction Header
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_HDR',
    pt_import_data_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_HEADER_STG.csv',
    pt_control_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_HEADER_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Material Transaction Lots
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_LOTS',
    pt_import_data_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_LOTS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_LOTS_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Material Transaction Serials
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_SERIALS',
    pt_import_data_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_SERIALS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_MATERIAL_TRANSACTION_SERIALS_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
