--******************************************************************************
--**
--** xxmx_xfm_populate_cost_list.sql HISTORY
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_HEADER_IMPORT',
    pt_fusion_template_name => 'CostListsHeaders.csv',
    pt_fusion_template_sheet_name => 'CostListsHeaders',
    pt_fusion_template_sheet_order => 1,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_ACCESS_SETS_IMPORT',
    pt_fusion_template_name => 'CostListsSets.csv',
    pt_fusion_template_sheet_name => 'CostListsSets',
    pt_fusion_template_sheet_order => 2,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_ITEMS_IMPORT',
    pt_fusion_template_name => 'CostListsItems.csv',
    pt_fusion_template_sheet_name => 'CostListsItems',
    pt_fusion_template_sheet_order => 3,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'COST_LISTS',
    pt_i_SubEntity => 'COST_LIST_CHARGES_IMPORT',
    pt_fusion_template_name => 'CostListsCharges.csv',
    pt_fusion_template_sheet_name => 'CostListsCharges',
    pt_fusion_template_sheet_order => 4,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/
