--AR CUSTOMER

GRANT ALL ON  xxmx_hz_parties_xfm               to XXMX_CORE;
GRANT ALL ON  xxmx_hz_party_sites_xfm           to XXMX_CORE;
GRANT ALL ON  xxmx_hz_party_site_uses_xfm       to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_accounts_xfm         to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_acct_sites_xfm       to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_site_uses_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_profiles_xfm         to XXMX_CORE;
GRANT ALL ON  xxmx_hz_locations_xfm             to XXMX_CORE;
GRANT ALL ON  xxmx_hz_relationships_xfm         to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_acct_contacts_xfm    to XXMX_CORE;
GRANT ALL ON  xxmx_hz_org_contacts_xfm          to XXMX_CORE;
GRANT ALL ON  xxmx_hz_org_contact_roles_xfm     to XXMX_CORE;
GRANT ALL ON  xxmx_hz_contact_points_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_hz_person_language_xfm       to XXMX_CORE;
GRANT ALL ON  xxmx_hz_party_classifs_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_hz_role_resps_xfm            to XXMX_CORE;
GRANT ALL ON  xxmx_hz_cust_acct_relate_xfm      to XXMX_CORE;
GRANT ALL ON  xxmx_ra_cust_rcpt_methods_xfm     to XXMX_CORE;
GRANT ALL ON  xxmx_iby_cust_bank_accts_xfm            to XXMX_CORE;

--AP SUPPLIERS

GRANT ALL ON  xxmx_ap_suppliers_xfm			    to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_addrs_xfm            to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supplier_sites_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_3rd_pty_rels_xfm     to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_site_assigns_xfm     to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_contacts_xfm         to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_cont_addrs_xfm       to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_payees_xfm           to XXMX_CORE;
GRANT ALL ON  xxmx_ap_supp_bank_accts_xfm       to XXMX_CORE;
GRANT ALL ON  XXMX_AP_SUPP_PMT_INSTRS_xfm       to XXMX_CORE;

--GL BALANCES                                             
GRANT ALL ON  xxmx_gl_balances_xfm              to XXMX_CORE;

--AP INVOICES                                             
GRANT ALL ON  xxmx_ap_invoices_xfm              to XXMX_CORE;
GRANT ALL ON  xxmx_ap_invoice_lines_xfm         to XXMX_CORE;

--AR TRANSACTION                                          

GRANT ALL ON  xxmx_ar_trx_dists_xfm             to XXMX_CORE;
GRANT ALL ON  xxmx_ar_trx_lines_xfm             to XXMX_CORE;
GRANT ALL ON  xxmx_ar_trx_salescredits_xfm      to XXMX_CORE;

--AR CASH RECEIPTS                                        

GRANT ALL ON  xxmx_ra_cust_rcpt_methods_xfm     to XXMX_CORE;
GRANT ALL ON  xxmx_ar_cash_rcpts_rt5_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_ar_cash_rcpts_rt6_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_ar_cash_rcpts_rt8_xfm        to XXMX_CORE;
GRANT ALL ON  xxmx_ar_cash_receipts_out         to XXMX_CORE;

grant all on xxmx_ar_cash_rcpts_rt6_xfm TO XXMX_CORE;
grant all on xxmx_ar_cash_rcpts_rt5_xfm TO XXMX_CORE;
grant all on xxmx_ar_cash_rcpts_rt8_xfm TO XXMX_CORE;
grant all on xxmx_ar_cash_receipts_out TO XXMX_CORE;

grant all on xxmx_ap_invoices_xfm TO XXMX_CORE;
grant all on xxmx_ap_invoice_lines_xfm TO XXMX_CORE;

grant all on xxmx_ar_trx_lines_xfm TO XXMX_CORE;
grant all on xxmx_ar_trx_dists_xfm TO XXMX_CORE;
grant all on xxmx_ar_trx_salescredits_xfm TO XXMX_CORE;
grant all on xxmx_ar_trx_lines_xfm TO XXMX_CORE;
/
