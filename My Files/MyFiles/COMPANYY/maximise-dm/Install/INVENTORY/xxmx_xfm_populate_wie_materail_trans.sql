--******************************************************************************
--**
--** xxmx_xfm_populate_wie_materail_trans.sql HISTORY
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'INTERFACE_BATCH',
    pt_fusion_template_name => 'WieMtlTxnBatches.csv',
    pt_fusion_template_sheet_name => 'WieMtlTxnBatches',
    pt_fusion_template_sheet_order => 1,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_HDR',
    pt_fusion_template_name => 'WieMtlTxns.csv',
    pt_fusion_template_sheet_name => 'WieMtlTxns',
    pt_fusion_template_sheet_order => 2,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_LOTS',
    pt_fusion_template_name => 'WieMtlTxnLots.csv',
    pt_fusion_template_sheet_name => 'WieMtlTxnLots',
    pt_fusion_template_sheet_order => 3,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_MATERIAL_TRANS',
    pt_i_SubEntity => 'MAT_TRANSAC_SERIALS',
    pt_fusion_template_name => 'WieMtlTxnSerials.csv',
    pt_fusion_template_sheet_name => 'WieMtlTxnSerials',
    pt_fusion_template_sheet_order => 4,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
