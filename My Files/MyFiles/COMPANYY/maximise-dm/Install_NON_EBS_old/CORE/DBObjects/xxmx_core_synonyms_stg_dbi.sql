--
--
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           M	illennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_core_synonyms_dbi.sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the XXMX_CORE Synonyms to the XXMX_STG
--**              and XXMX_XFM schema tables.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    None
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  07-JAN-2021  Ian S. Vickerstaff  Created for Maximise.
--**
--**   1.1  10-FEB-2021  Ian S. Vickerstaff  Synonyms added.
--**
--**   1.2  16-FEB-2021  Ian S. Vickerstaff  Synonyms added.
--**
--**   1.3  14-JUL-2021  Ian S. Vickerstaff  Header comment updates.
--**
--******************************************************************************
--
--
PROMPT
PROMPT
PROMPT ************************************************************************
PROMPT **
PROMPT ** Performing Grants and Creating Synonyms for the Maximise Core Objects
PROMPT **
PROMPT ************************************************************************
PROMPT
PROMPT
--
--
/*
*********************************************************
** GL Syonyms
*********************************************************
*/
--
PROMPT
PROMPT Synonym: xxmx_gl_balances_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_gl_balances_stg
           FOR xxmx_gl_balances_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_suppliers_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_suppliers_stg
           FOR xxmx_ap_suppliers_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supplier_sites_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supplier_sites_stg
           FOR xxmx_ap_supplier_sites_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_site_assigns_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_site_assigns_stg
           FOR xxmx_ap_supp_site_assigns_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_addrs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_addrs_stg
           FOR xxmx_ap_supp_addrs_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_contacts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_contacts_stg
           FOR xxmx_ap_supp_contacts_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_cont_addrs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_cont_addrs_stg
           FOR xxmx_ap_supp_cont_addrs_stg;
--
--
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_3rd_pty_rels_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_3rd_pty_rels_stg
           FOR xxmx_ap_supp_3rd_pty_rels_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_payees_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_payees_stg
           FOR xxmx_ap_supp_payees_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_pmt_instrs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_pmt_instrs_stg
           FOR xxmx_ap_supp_pmt_instrs_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_bank_accts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_bank_accts_stg
           FOR xxmx_ap_supp_bank_accts_stg;
--
--
/*
** AP Invoices
*/
--
PROMPT
PROMPT Synonym: xxmx_ap_invoices_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_invoices_stg
           FOR xxmx_ap_invoices_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_invoice_lines_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_invoice_lines_stg
           FOR xxmx_ap_invoice_lines_stg;
--
--
/*
*********************************************************
** AR Syonyms
*********************************************************
*/
--
/*
** AR Customers
*/
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_accounts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_accounts_stg
           FOR xxmx_hz_cust_accounts_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_sites_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_sites_stg
           FOR xxmx_hz_cust_acct_sites_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_site_uses_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_site_uses_stg
           FOR xxmx_hz_cust_site_uses_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_contacts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_contacts_stg
           FOR xxmx_hz_cust_acct_contacts_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_contact_points_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_contact_points_stg
           FOR xxmx_hz_contact_points_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_relate_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_relate_stg
           FOR xxmx_hz_cust_acct_relate_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_locations_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_locations_stg
           FOR xxmx_hz_locations_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_org_contacts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_org_contacts_stg
           FOR xxmx_hz_org_contacts_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_org_contact_roles_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_org_contact_roles_stg
           FOR xxmx_hz_org_contact_roles_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_parties_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_parties_stg
           FOR xxmx_hz_parties_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_sites_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_sites_stg
           FOR xxmx_hz_party_sites_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_site_uses_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_site_uses_stg
           FOR xxmx_hz_party_site_uses_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_profiles_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_profiles_stg
           FOR xxmx_hz_cust_profiles_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_classifs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_classifs_stg
           FOR xxmx_hz_party_classifs_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_person_language_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_person_language_stg
           FOR xxmx_hz_person_language_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_relationships_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_relationships_stg
           FOR xxmx_hz_relationships_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_role_resps_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_role_resps_stg
           FOR xxmx_hz_role_resps_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_iby_cust_bank_accts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_iby_cust_bank_accts_stg
           FOR xxmx_iby_cust_bank_accts_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ra_cust_rcpt_methods_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ra_cust_rcpt_methods_stg
           FOR xxmx_ra_cust_rcpt_methods_stg;

CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cust_banks_stg
           FOR xxmx_ar_cust_banks_stg;
--
--
/*
** AR Invoices
*/
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_lines_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_lines_stg
           FOR xxmx_ar_trx_lines_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_dists_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_dists_stg
           FOR xxmx_ar_trx_dists_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_salescredits_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_salescredits_stg
           FOR xxmx_ar_trx_salescredits_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_salescredits_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_salescredits_xfm
           FOR  xxmx_ar_trx_salescredits_xfm;
--
--
/*
** AR Cash Receipts
*/
--
PROMPT
PROMPT Synonym: xxmx_ar_cash_receipts_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cash_receipts_stg
           FOR xxmx_ar_cash_receipts_stg;
--
--
/*
*********************************************************
** PO Syonyms
*********************************************************
*/
--
/*
** PO Purchase Orders
*/
--
/*
** AP Suppliers
*/
--
PROMPT
PROMPT Synonym: xxmx_po_headers_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_headers_stg
           FOR xxmx_po_headers_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_lines_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_lines_stg
           FOR xxmx_po_lines_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_line_locations_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_line_locations_stg
           FOR xxmx_po_line_locations_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_distributions_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_distributions_stg
           FOR xxmx_po_distributions_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_ga_org_assigns_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_ga_org_assigns_stg
           FOR xxmx_po_ga_org_assigns_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_cpa_headers_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_cpa_headers_stg
           FOR xxmx_po_bpa_cpa_headers_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_lines_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_lines_stg
           FOR xxmx_po_bpa_lines_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_locations_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_locations_stg
           FOR xxmx_po_bpa_locations_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_item_attrs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_item_attrs_stg
           FOR xxmx_po_bpa_item_attrs_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_item_attr_trs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_item_attr_trs_stg
           FOR xxmx_po_bpa_item_attr_trs_stg;
--
--
/*
*********************************************************
** HCM Global HR Syonyms
*********************************************************
*/
--
/*
** HCM Banks and Branches
*/
--
PROMPT
PROMPT Synonym: xxmx_banks_stg
PROMPT
CREATE OR REPLACE PUBLIC SYNONYM xxmx_banks_stg
           FOR xxmx_banks_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_bank_branches_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_bank_branches_stg
           FOR xxmx_bank_branches_stg;
--
--
/*
*********************************************************
** HCM Payroll
*********************************************************
*/
--
PROMPT
PROMPT Synonym: xxmx_pay_elem_entries_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_elem_entries_stg
           FOR xxmx_pay_elem_entries_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_cost_allocs_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_cost_allocs_stg
           FOR xxmx_pay_cost_allocs_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_balances_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_balances_stg
           FOR xxmx_pay_balances_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_calc_cards_sd_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_calc_cards_sd_stg
           FOR xxmx_pay_calc_cards_sd_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_calc_cards_pae_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_calc_cards_pae_stg
           FOR xxmx_pay_calc_cards_pae_stg;
--
--
PROMPT
PROMPT Synonym: xxxmx_pay_calc_cards_bp_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxxmx_pay_calc_cards_bp_stg
           FOR xxxmx_pay_calc_cards_bp_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_calc_cards_sl_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_calc_cards_sl_stg
           FOR xxmx_pay_calc_cards_sl_stg;
--
--
PROMPT
PROMPT Synonym: xxmx_pay_calc_cards_nsd_stg
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_pay_calc_cards_nsd_stg
           FOR xxmx_pay_calc_cards_nsd_stg;
--
--


