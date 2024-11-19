--******************************************************************************
--**
--** xxmx_stg_populate_proc_work_def_imp.sql HISTORY
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'IMPORT_BATCHES',
    pt_import_data_file_name => 'XXMX_SCM_IMPORT_BATCHES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_IMPORT_BATCHES_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'WORK_DEFINITION_HDR',
    pt_import_data_file_name => 'XXMX_SCM_WORK_DEFINITION_HEADERS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_DEFINITION_HEADERS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'WORK_DEFINITION_OPR',
    pt_import_data_file_name => 'XXMX_SCM_WORK_DEFINITION_OPERATIONS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_WORK_DEFINITION_OPERATIONS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_ITEMS',
    pt_import_data_file_name => 'XXMX_SCM_OPERATION_ITEMS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_OPERATION_ITEMS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_OUTPUTS',
    pt_import_data_file_name => 'XXMX_SCM_OPERATION_OUTPUTS_STG.csv',
    pt_control_file_name => 'XXMX_SCM_OPERATION_OUTPUTS_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_RESOURCES',
    pt_import_data_file_name => 'XXMX_SCM_OPERATION_RESOURCES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_OPERATION_RESOURCES_STG.ctl',
    pt_control_file_delimiter => '|',
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

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'MF',
    pt_i_BusinessEntity => 'PROC_WORK_DEF_IMP',
    pt_i_SubEntity => 'OPERATION_ALT_RES',
    pt_import_data_file_name => 'XXMX_SCM_OPERATION_ALTERNATE_RESOURCES_STG.csv',
    pt_control_file_name => 'XXMX_SCM_OPERATION_ALTERNATE_RESOURCES_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
