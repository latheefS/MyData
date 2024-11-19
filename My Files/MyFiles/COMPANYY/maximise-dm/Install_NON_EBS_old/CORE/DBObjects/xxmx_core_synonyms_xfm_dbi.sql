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
PROMPT Synonym: xxmx_gl_balances_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_gl_balances_xfm
           FOR xxmx_gl_balances_xfm;
--
--
/*
*********************************************************
** AP Syonyms
*********************************************************
*/
--
/*
** AP Suppliers
*/
--
PROMPT
PROMPT Synonym: xxmx_ap_suppliers_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_suppliers_xfm
           FOR xxmx_ap_suppliers_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supplier_sites_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supplier_sites_xfm
           FOR xxmx_ap_supplier_sites_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_site_assigns_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_site_assigns_xfm
           FOR xxmx_ap_supp_site_assigns_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_addrs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_addrs_xfm
           FOR xxmx_ap_supp_addrs_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_contacts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_contacts_xfm
           FOR xxmx_ap_supp_contacts_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_cont_addrs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_cont_addrs_xfm
           FOR xxmx_ap_supp_cont_addrs_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_3rd_pty_rels_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_3rd_pty_rels_xfm
           FOR xxmx_ap_supp_3rd_pty_rels_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_payees_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_payees_xfm
           FOR xxmx_ap_supp_payees_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_pmt_instrs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_pmt_instrs_xfm
           FOR xxmx_ap_supp_pmt_instrs_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_supp_bank_accts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_supp_bank_accts_xfm
           FOR xxmx_ap_supp_bank_accts_xfm;
--
--
/*
** AP Invoices
*/
--
PROMPT
PROMPT Synonym: xxmx_ap_invoices_xfm
PROMPT
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_invoices_xfm
           FOR xxmx_ap_invoices_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ap_invoice_lines_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ap_invoice_lines_xfm
           FOR xxmx_ap_invoice_lines_xfm;
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
PROMPT Synonym: xxmx_hz_cust_accounts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_accounts_xfm
           FOR xxmx_hz_cust_accounts_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_sites_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_sites_xfm
           FOR xxmx_hz_cust_acct_sites_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_site_uses_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_site_uses_xfm
           FOR xxmx_hz_cust_site_uses_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_contacts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_contacts_xfm
           FOR xxmx_hz_cust_acct_contacts_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_contact_points_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_contact_points_xfm
           FOR xxmx_hz_contact_points_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_acct_relate_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_acct_relate_xfm
           FOR xxmx_hz_cust_acct_relate_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_locations_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_locations_xfm
           FOR xxmx_hz_locations_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_org_contacts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_org_contacts_xfm
           FOR xxmx_hz_org_contacts_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_org_contact_roles_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_org_contact_roles_xfm
           FOR xxmx_hz_org_contact_roles_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_parties_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_parties_xfm
           FOR xxmx_hz_parties_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_sites_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_sites_xfm
           FOR xxmx_hz_party_sites_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_site_uses_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_site_uses_xfm
           FOR xxmx_hz_party_site_uses_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_cust_profiles_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_cust_profiles_xfm
           FOR xxmx_hz_cust_profiles_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_party_classifs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_party_classifs_xfm
           FOR xxmx_hz_party_classifs_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_person_language_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_person_language_xfm
           FOR xxmx_hz_person_language_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_relationships_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_relationships_xfm
           FOR xxmx_hz_relationships_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_hz_role_resps_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_hz_role_resps_xfm
           FOR xxmx_hz_role_resps_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_iby_cust_bank_accts_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_iby_cust_bank_accts_xfm
           FOR xxmx_iby_cust_bank_accts_xfm;
--
PROMPT
PROMPT Synonym: xxmx_ra_cust_rcpt_methods_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ra_cust_rcpt_methods_xfm
           FOR xxmx_ra_cust_rcpt_methods_xfm;
--
--
/*
** AR Invoices
*/
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_lines_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_lines_xfm
           FOR xxmx_ar_trx_lines_xfm;
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_dists_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_dists_xfm
           FOR xxmx_ar_trx_dists_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_trx_salescredits_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_trx_salescredits_xfm
           FOR xxmx_ar_trx_salescredits_xfm;
--
--
/*
** AR Cash Receipts
*/
--
PROMPT
PROMPT Synonym: xxmx_ar_cash_rcpts_rt5_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cash_rcpts_rt5_xfm
           FOR xxmx_ar_cash_rcpts_rt5_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_cash_rcpts_rt6_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cash_rcpts_rt6_xfm
           FOR xxmx_ar_cash_rcpts_rt6_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_cash_rcpts_rt8_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cash_rcpts_rt8_xfm
           FOR xxmx_ar_cash_rcpts_rt8_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_ar_cash_receipts_out
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_ar_cash_receipts_out
           FOR xxmx_ar_cash_receipts_out;
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
PROMPT Synonym: xxmx_po_headers_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_headers_xfm
           FOR xxmx_po_headers_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_lines_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_lines_xfm
           FOR xxmx_po_lines_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_line_locations_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_line_locations_xfm
           FOR xxmx_po_line_locations_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_distributions_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_distributions_xfm
           FOR xxmx_po_distributions_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_ga_org_assigns_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_ga_org_assigns_xfm
           FOR xxmx_po_ga_org_assigns_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_cpa_headers_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_cpa_headers_xfm
           FOR xxmx_po_bpa_cpa_headers_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_lines_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_lines_xfm
           FOR xxmx_po_bpa_lines_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_locations_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_locations_xfm
           FOR xxmx_po_bpa_locations_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_item_attrs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_item_attrs_xfm
           FOR xxmx_po_bpa_item_attrs_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_po_bpa_item_attr_trs_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_po_bpa_item_attr_trs_xfm
           FOR xxmx_po_bpa_item_attr_trs_xfm;
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
PROMPT Synonym: xxmx_banks_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_banks_xfm
           FOR xxmx_banks_xfm;
--
--
PROMPT
PROMPT Synonym: xxmx_bank_branches_xfm
PROMPT
--
CREATE OR REPLACE PUBLIC SYNONYM xxmx_bank_branches_xfm
           FOR xxmx_bank_branches_xfm;
--
--
/*
*********************************************************
** HCM Payroll
*********************************************************
*/
--
