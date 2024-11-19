--******************************************************************************
--**
--** xxmx_xfm_populate_wie_order_imp.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Work Order Batches
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_BATCHES',
    pt_fusion_template_name => 'WieWoBatches.csv',
    pt_fusion_template_sheet_name => 'WieWoBatches',
    pt_fusion_template_sheet_order => 1,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Work Order Header
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_HEADER',
    pt_fusion_template_name => 'WieWoHeaders.csv',
    pt_fusion_template_sheet_name => 'WieWoHeaders',
    pt_fusion_template_sheet_order => 2,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Work Order Operations
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPERATIONS',
    pt_fusion_template_name => 'WieWoOperations.csv',
    pt_fusion_template_sheet_name => 'WieWoOperations',
    pt_fusion_template_sheet_order => 3,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Work Order Operation Resources
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_RES',
    pt_fusion_template_name => 'WieWoOperationResources.csv',
    pt_fusion_template_sheet_name => 'WieWoOperationResources',
    pt_fusion_template_sheet_order => 4,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Work Order Operation Resource Instances
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_RES_INST',
    pt_fusion_template_name => 'WieWoOperationResInstances.csv',
    pt_fusion_template_sheet_name => 'WieWoOperationResInstances',
    pt_fusion_template_sheet_order => 5,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Work Order Operation Materials
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_MAT',
    pt_fusion_template_name => 'WieWoOperationMaterials.csv',
    pt_fusion_template_sheet_name => 'WieWoOperationMaterials',
    pt_fusion_template_sheet_order => 6,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Work Order Operation Outputs
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPR_OUTPUT',
    pt_fusion_template_name => 'WieWoOperationOutputs.csv',
    pt_fusion_template_sheet_name => 'WieWoOperationOutputs',
    pt_fusion_template_sheet_order => 7,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Work Order Production Lots
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_PROD_LOTS',
    pt_fusion_template_name => 'WieWoLots.csv',
    pt_fusion_template_sheet_name => 'WieWoLots',
    pt_fusion_template_sheet_order => 8,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

