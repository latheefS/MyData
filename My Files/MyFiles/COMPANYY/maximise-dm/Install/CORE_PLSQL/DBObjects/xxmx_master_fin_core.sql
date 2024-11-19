--========================================================================================================
--== MXDM 2.0 FIN CORE PLSQL Script
--========================================================================================================
--
--========================================================================================================
--== The following script installs FINANCIAL PLSQL in CORE schema required for Cloudbridge 1.0 Toolkit. 
--========================================================================================================

--========================================================================================================
--== Log Header and timestamps
--========================================================================================================

set verify off
set termout off
set echo on

spool &1/fin.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

--========================================================================================================
--== Calling FIN PLSQL to Extract Financial EBS Data
--========================================================================================================
--
--
PROMPT **********************************
PROMPT Run script xxmx_ap_supplier_scope_v_dbi
PROMPT **********************************
--
--
@"&1/AP/DBObjects/xxmx_ap_supplier_scope_v_dbi.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_customer_scope_v
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_customer_scope_v.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_trx_scope_v_dbi
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_trx_scope_v_dbi.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_cash_receipts_scope_v_dbi
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_cash_receipts_scope_v_dbi.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ap_inv_scope_v
PROMPT **********************************
--
--
@"&1/AP/DBObjects/xxmx_ap_inv_scope_v.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_iby_payee_bank_accts_v
PROMPT **********************************
--
--
@"&1/AP/DBObjects/xxmx_iby_payee_bank_accts_v.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_purchase_order_scope_v
PROMPT **********************************
--
--
@"&1/PO/DBObjects/xxmx_purchase_order_scope_v.sql"
@"&1/PO/DBObjects/xxmx_scm_po_open_qty_mv.sql"
@"&1/PO/DBObjects/xxmx_po_open_quantity_v.sql"
@"&1/PO/DBObjects/xxmx_po_open_quantity_mv.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_gl_balances_view
PROMPT **********************************
--
--
@"&1/GL/DBObjects/xxmx_gl_opening_balance_v.sql"
@"&1/GL/DBObjects/xxmx_gl_balance_summary_v.sql"
--
--
--
PROMPT **********************************
PROMPT Run script xxmx_gl_balances_pkg
PROMPT **********************************
--
--
@"&1/GL/DBObjects/xxmx_gl_balances_pkg.sql" 
@"&1/GL/DBObjects/xxmx_validate_code_combinations_cvr_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_cash_receipts_pkg
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_cash_receipts_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ap_suppliers_pkg
PROMPT **********************************
--
--
@"&1/AP/DBObjects/xxmx_ap_suppliers_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_customers_pkg
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_customers_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ar_trx_pkg
PROMPT **********************************
--
--
@"&1/AR/DBObjects/xxmx_ar_trx_pkg.sql"      
--
--
PROMPT **********************************
PROMPT Run script xxmx_ap_inv_pkg
PROMPT **********************************
--
--
@"&1/AP/DBObjects/xxmx_ap_inv_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_fa_mass_additions_pkg
PROMPT **********************************
--
--
@"&1/FA/DBObjects/xxmx_fa_mass_additions_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_gl_journal_pkg
PROMPT **********************************
--
--
@"&1/GL/DBObjects/xxmx_gl_journal_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_gl_daily_rates_pkg
PROMPT **********************************
--
@"&1/GL/DBObjects/xxmx_gl_daily_rates_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_gl_historical_rates_pkg
PROMPT **********************************
--
@"&1/GL/DBObjects/xxmx_gl_historical_rates_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ppm_prj_billevent_pkg
PROMPT **********************************
--
--
@"&1/PA/DBObjects/xxmx_ppm_prj_billevent_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ppm_prj_rbs_pkg
PROMPT **********************************
--
--
@"&1/PA/DBObjects/xxmx_ppm_prj_rbs_pkg.sql"
--
--
PROMPT **********************************
PROMPT Run script xxmx_ppm_projects_pkg
PROMPT **********************************
--
--
@"&1/PA/DBObjects/xxmx_ppm_projects_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_po_headers_pkg
PROMPT **********************************
--
--

@"&1/PO/DBObjects/xxmx_po_headers_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_po_receipt_headers_pkg
PROMPT **********************************
--
--
@"&1/PO/DBObjects/xxmx_po_receipt_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_ap_supp_tax_pkg
PROMPT **********************************
--
@"&1/AP/DBObjects/xxmx_ap_supp_tax_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_zx_customer_tax_pkg
PROMPT **********************************
--
@"&1/AR/DBObjects/xxmx_zx_customer_tax_pkg.sql"
--
PROMPT **********************************
PROMPT Run script xxmx_hcm_simple_extract_pkg
PROMPT **********************************
--
--
@"&1/HCM/DBObjects/xxmx_hcm_simple_extract_pkg.pks"
@"&1/HCM/DBObjects/xxmx_hcm_simple_extract_pkg.pkb"
--
--
PROMPT **********************************
PROMPT Run script xxmx_hr_location_pkg
PROMPT **********************************
--
@"&1/HCM/DBObjects/xxmx_hr_location_pkg.pks"
@"&1/HCM/DBObjects/xxmx_hr_location_pkg.pkb"
--

select to_char(sysdate,'DDMMRRRR HH24MISS') End_time from dual;

spool off;

set verify on
set echo off
set termout on

EXIT


