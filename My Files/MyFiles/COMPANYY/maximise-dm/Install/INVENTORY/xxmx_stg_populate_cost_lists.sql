--******************************************************************************
--**
--** xxmx_stg_populate_cost_lists.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **Cost List Header Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_HEADER_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_QP_COST_LISTS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_QP_COST_LISTS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Cost List Access Sets Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_ACCESS_SETS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_QP_COST_LIST_SETS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_QP_COST_LIST_SETS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Cost List Items Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_ITEMS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_QP_COST_LIST_ITEMS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_QP_COST_LIST_ITEMS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- ************************
-- **Cost List Charges Import
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_CHARGES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_QP_COST_LIST_CHARGES_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_QP_COST_LIST_CHARGES_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
