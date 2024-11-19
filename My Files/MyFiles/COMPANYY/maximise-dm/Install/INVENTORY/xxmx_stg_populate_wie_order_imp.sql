--******************************************************************************
--**
--** xxmx_stg_populate_wie_order_imp.sql HISTORY
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_BATCHES',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_BATCHES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_BATCHES_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_HEADER',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_HEADER_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_HEADER_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPERATIONS',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_OPERATIONS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_OPERATIONS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_RES',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_RESOURCES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_RESOURCES_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_RES_INST',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_OPN_RES_INSTANCES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_OPN_RES_INSTANCES_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPN_MAT',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_MATERIALS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_MATERIALS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_OPR_OUTPUT',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_OUTPUTS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_OPERATION_OUTPUTS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'WIE_ORDER_IMP',
    pt_i_SubEntity => 'WO_PROD_LOTS',
    pt_import_data_file_name => 'XXMX_SCM_WORK_ORDER_PRODUCT_LOT_NUMBERS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_ORDER_PRODUCT_LOT_NUMBERS_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
