--******************************************************************************
--**
--** xxmx_stg_populate_sales_orders.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  19-SEP-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- **************
-- ** Order Headers Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_HEADERS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_HEADERS_ALL_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Lines Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_LINES_ALL_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_LINES_ALL_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Addresses Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_ADDRESSES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_ADDRESSES_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_ADDRESSES_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Transaction Attributes Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_TRANSACTION_ATTRIBUTES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_TXN_ATTRIBUTES_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Sales Credits Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_SALES_CREDITS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_SALES_CREDITS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Payments Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_PAYMENTS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_PAYMENTS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_PAYMENTS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Lot Serials Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LOT_SERIALS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_LOT_SERIALS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Document References Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_DOCUMENT_REFERENCES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_DOC_REFERENCES_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Charges Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGES_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_CHARGES_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_CHARGES_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Charge Components Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGE_COMPONENTS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_CHARGE_COMPS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Billing Plans Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_BILLING_PLANS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_BILLING_PLANS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Manual Price Adjustment Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_MANUAL_PRICE_ADJUSTMENT_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_MANUAL_PRICE_ADJ_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Header Extensible Flexfields Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_HEADER_EXTENSIBLE_FLEXFIELDS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_HDRS_ALL_EFF_B_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Line Extensible Flexfields Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINE_EXTENSIBLE_FLEXFIELDS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_LINES_ALL_EFF_B_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Line Projects Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINE_PROJECTS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_PROJECTS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_PROJECTS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Terms Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_TERMS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_TERMS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_TERMS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

-- **************
-- ** Order Charge Tiers Import
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

  xxmx_dynamic_sql_pkg.stg_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGE_TIERS_IMPORT',
    pt_import_data_file_name => 'XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_STG.csv',
    pt_control_file_name => 'XXMX_SCM_DOO_ORDER_CHARGE_TIERS_INT_STG.ctl',
    pt_control_file_delimiter => '|',
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

