--******************************************************************************
--**
--** xxmx_xfm_populate_sales_orders.sql HISTORY
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_HEADERS_IMPORT',
    pt_fusion_template_name => 'DooOrderHeadersAllInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderHeadersAllInt',
    pt_fusion_template_sheet_order => 1,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINES_IMPORT',
    pt_fusion_template_name => 'DooOrderLinesAllInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderLinesAllInt',
    pt_fusion_template_sheet_order => 2,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_ADDRESSES_IMPORT',
    pt_fusion_template_name => 'DooOrderAddressesInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderAddressesInt',
    pt_fusion_template_sheet_order => 3,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_TRANSACTION_ATTRIBUTES_IMPORT',
    pt_fusion_template_name => 'DooOrderTxnAttributesInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderTxnAttributesInt',
    pt_fusion_template_sheet_order => 4,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_SALES_CREDITS_IMPORT',
    pt_fusion_template_name => 'DooOrderSalesCreditsInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderSalesCreditsInt',
    pt_fusion_template_sheet_order => 5,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_PAYMENTS_IMPORT',
    pt_fusion_template_name => 'DooOrderPaymentsInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderPaymentsInt',
    pt_fusion_template_sheet_order => 6,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LOT_SERIALS_IMPORT',
    pt_fusion_template_name => 'DooOrderLotSerialsInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderLotSerialsInt',
    pt_fusion_template_sheet_order => 7,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_DOCUMENT_REFERENCES_IMPORT',
    pt_fusion_template_name => 'DooOrderDocReferencesInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderDocReferencesInt',
    pt_fusion_template_sheet_order => 8,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGES_IMPORT',
    pt_fusion_template_name => 'DooOrderChargesInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderChargesInt',
    pt_fusion_template_sheet_order => 9,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGE_COMPONENTS_IMPORT',
    pt_fusion_template_name => 'DooOrderChargeCompsInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderChargeCompsInt',
    pt_fusion_template_sheet_order => 10,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_BILLING_PLANS_IMPORT',
    pt_fusion_template_name => 'DooOrderBillingPlansInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderBillingPlansInt',
    pt_fusion_template_sheet_order => 11,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_MANUAL_PRICE_ADJUSTMENT_IMPORT',
    pt_fusion_template_name => 'DooOrderManualPriceAdjInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderManualPriceAdjInt',
    pt_fusion_template_sheet_order => 12,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_HEADER_EXTENSIBLE_FLEXFIELDS_IMPORT',
    pt_fusion_template_name => 'DooOrderHdrsAllEffBInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderHdrsAllEffBInt',
    pt_fusion_template_sheet_order => 13,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINE_EXTENSIBLE_FLEXFIELDS_IMPORT',
    pt_fusion_template_name => 'DooOrderLinesAllEffBInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderLinesAllEffBInt',
    pt_fusion_template_sheet_order => 14,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_LINE_PROJECTS_IMPORT',
    pt_fusion_template_name => 'DooProjectsInt.csv',
    pt_fusion_template_sheet_name => 'DooProjectsInt',
    pt_fusion_template_sheet_order => 15,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_TERMS_IMPORT',
    pt_fusion_template_name => 'DooOrderTermsInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderTermsInt',
    pt_fusion_template_sheet_order => 16,
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

  xxmx_dynamic_sql_pkg.xfm_populate(
    pt_i_ApplicationSuite => 'SCM',
    pt_i_Application => 'OM',
    pt_i_BusinessEntity => 'SALES_ORDERS',
    pt_i_SubEntity => 'ORDER_CHARGE_TIERS_IMPORT',
    pt_fusion_template_name => 'DooOrderChargeTiersInt.csv',
    pt_fusion_template_sheet_name => 'DooOrderChargeTiersInt',
    pt_fusion_template_sheet_order => 17,
    pv_o_ReturnStatus => pv_o_ReturnStatus
  );
END;
/

