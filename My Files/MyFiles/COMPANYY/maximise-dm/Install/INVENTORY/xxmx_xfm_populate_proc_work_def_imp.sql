--******************************************************************************
--**
--** xxmx_xfm_populate_proc_work_def_imp.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Import Batches
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'IMPORT_BATCHES',
    pt_fusion_template_name => 'WisProcWdBatches.csv',
    pt_fusion_template_sheet_name => 'WisProcWdBatches',
    pt_fusion_template_sheet_order => 1,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Work Definition Header
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'WORK_DEFINITION_HDR',
    pt_fusion_template_name => 'WisProcWorkDefinitionsInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWorkDefinitionsInt',
    pt_fusion_template_sheet_order => 2,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Work Definition Operations
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'WORK_DEFINITION_OPR',
    pt_fusion_template_name => 'WisProcWdOperationsInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWdOperationsInt',
    pt_fusion_template_sheet_order => 3,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Operation Items
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_ITEMS',
    pt_fusion_template_name => 'WisProcWdOperationMaterialsInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWdOperationMaterialsInt',
    pt_fusion_template_sheet_order => 4,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/


-- ************************
-- **Operation Outputs
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_OUTPUTS',
    pt_fusion_template_name => 'WisProcWdOperationOutputsInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWdOperationOutputsInt',
    pt_fusion_template_sheet_order => 5,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Operation Resources
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_RESOURCES',
    pt_fusion_template_name => 'WisProcWdOperationResourcesInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWdOperationResourcesInt',
    pt_fusion_template_sheet_order => 6,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Operation Alternate Resources
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_ALT_RES',
    pt_fusion_template_name => 'WisProcWdOperationAltResInt.csv',
    pt_fusion_template_sheet_name => 'WisProcWdOperationAltResInt',
    pt_fusion_template_sheet_order => 7,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
