--******************************************************************************
--**
--** xxmx_stg_populate_wie_op_trans_int.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Batch Details
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_OP_TRANS_INT',
    pt_i_SubEntity => 'BATCH_DETAILS',
    pt_import_data_file_name => 'XXMX_SCM_BATCH_DETAILS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_BATCH_DETAILS_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Operation Transaction Header
-- ************************

DECLARE

  pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_OP_TRANS_INT',
    pt_i_SubEntity => 'OPERATION_TRANSACTION_HEADER',
    pt_import_data_file_name => 'XXMX_SCM_OPERATION_TRANSACTION_HEADER_STG.csv',
    pt_control_file_name => 'XXMX_SCM_OPERATION_TRANSACTION_HEADER_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
