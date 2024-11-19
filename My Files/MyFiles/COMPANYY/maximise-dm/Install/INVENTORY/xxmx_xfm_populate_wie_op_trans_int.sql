--******************************************************************************
--**
--** xxmx_xfm_populate_wie_op_trans_int.sql HISTORY
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_OP_TRANS_INT',
    pt_i_SubEntity => 'BATCH_DETAILS',
    pt_fusion_template_name => 'WieOpTxnBatches.csv',
    pt_fusion_template_sheet_name => 'WieOpTxnBatches',
    pt_fusion_template_sheet_order => 1,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_OP_TRANS_INT',
    pt_i_SubEntity => 'OPERATION_TRANSACTION_HEADER',
    pt_fusion_template_name => 'WieOpTxns.csv',
    pt_fusion_template_sheet_name => 'WieOpTxns',
    pt_fusion_template_sheet_order => 2,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
