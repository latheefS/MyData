select * from XXMX_SCM_PO_HEADERS_STD_STG;
select * from XXMX_SCM_PO_LINES_STD_STG;
select * from XXMX_SCM_PO_LINE_LOCATIONS_STD_STG;
select * from XXMX_SCM_PO_DISTRIBUTIONS_STD_STG;
select * from XXMX_SCM_PO_HEADERS_BPA_STG;
select * from XXMX_SCM_PO_LINES_BPA_STG;
select * from XXMX_SCM_PO_LINE_LOCATIONS_BPA_STG;
select * from XXMX_SCM_PO_HEADERS_CPA_STG;


select * from xxmx_gl_journal_stg;
select * from xxmx_gl_balances_stg;


SELECT * FROM XXMX_PPM_PROJECTS_STG;
SELECT * FROM XXMX_PPM_PRJ_TASKS_STG;
SELECT * FROM XXMX_PPM_PRJ_TRX_CONTROL_STG;
SELECT * FROM XXMX_PPM_PRJ_LBRCOST_STG;
SELECT * FROM XXMX_PPM_PRJ_SUPCOST_STG;
SELECT * FROM XXMX_PPM_PRJ_MISCCOST_STG;
SELECT * FROM XXMX_PPM_PRJ_NONLABCOST_STG;
SELECT * FROM XXMX_PPM_PRJ_BILLEVENT_STG;
SELECT * FROM XXMX_PPM_RESOURCES_STG;
SELECT * FROM XXMX_PPM_PLANRBS_HEADER_STG;
SELECT * FROM XXMX_PPM_PRJ_TEAM_MEM_STG;
SELECT * FROM XXMX_PPM_PRJ_CLASS_STG;


SELECT * FROM xxmx_fa_mass_additions_stg;
SELECT * FROM xxmx_fa_mass_addition_dist_stg;
SELECT * FROM xxmx_fa_mass_rates_stg;



SELECT * FROM XXMX_AP_SUPPLIERS_STG;
SELECT * FROM XXMX_AP_SUPP_ADDRS_STG;
SELECT * FROM XXMX_AP_SUPPLIER_SITES_STG;
SELECT * FROM XXMX_AP_SUPP_3RD_PTY_RELS_STG;
SELECT * FROM XXMX_AP_SUPP_CONT_ADDRS_STG;
SELECT * FROM XXMX_AP_SUPP_CONTACTS_STG;
SELECT * FROM XXMX_AP_SUPP_SITE_ASSIGNS_STG;
SELECT * FROM XXMX_AP_SUPP_PAYEES_STG;
SELECT * FROM XXMX_AP_SUPP_PMT_INSTRS_STG;
SELECT * FROM XXMX_AP_SUPP_BANK_ACCTS_STG;


select * from xxmx_ap_invoices_stg;
select * from xxmx_ap_invoice_lines_stg;


SELECT * FROM xxmx_hz_cust_acct_sites_stg;
SELECT * FROM xxmx_hz_cust_site_uses_stg;
SELECT * FROM xxmx_hz_cust_acct_relate_stg;
SELECT * FROM xxmx_hz_party_classifs_stg;
SELECT * FROM xxmx_hz_org_contacts_stg;
SELECT * FROM xxmx_hz_contact_points_stg;
SELECT * FROM xxmx_hz_org_contact_roles_stg;
SELECT * FROM xxmx_hz_cust_accounts_stg;
SELECT * FROM xxmx_hz_cust_acct_contacts_stg;
SELECT * FROM xxmx_iby_cust_bank_accts_stg;
SELECT * FROM xxmx_ra_cust_rcpt_methods_stg;
SELECT * FROM xxmx_hz_locations_stg;
SELECT * FROM xxmx_hz_party_sites_stg;
SELECT * FROM xxmx_hz_party_site_uses_stg;
SELECT * FROM xxmx_hz_parties_stg;
SELECT * FROM xxmx_hz_person_language_stg;
SELECT * FROM xxmx_hz_cust_profiles_stg;
SELECT * FROM xxmx_hz_relationships_stg;
SELECT * FROM xxmx_hz_role_resps_stg;
SELECT * FROM xxmx_ar_cust_banks_stg;

select * from xxmx_ar_cash_receipts_stg;			--- xxmx_ar_cash_rcpts_rt6_xfm


SELECT * FROM xxmx_ar_trx_lines_stg;
SELECT * FROM xxmx_ar_trx_dists_stg;
SELECT * FROM xxmx_ar_trx_salescredits_stg;


----------------------------------------------------------------------------------------------------------------------------------

HCM	- PAY		-	PAYROLL
	  BEN		-	BENEFITS
	  HR		-	WORKER
					ORGANIZATION
					JOB
					LOCATION
					POSITION
					BANKS_AND_BRANCHES
					GRADE
					PERSON
					TALENT
	  IREC		-	GEOGRAPHY_HIERARCHY
					JOB_REQUISITION
					CANDIDATE_POOL
					CANDIDATE
					JOB_REFERRAL
					PROSPECT
	  
OLC - LRN		-	LEARNING

SCM - PO		-	PURCHASE_ORDERS

FIN - GL		-	GENERAL_LEDGER
					BALANCES
	  AR		-	CUSTOMERS
					INVOICES (TRANSACTIONS)
					CASH_RECEIPTS
	  PPM		-	PRJ_RBS
					PROJECTS
					PRJ_BILL_EVNT
					PRJ_COST
	  AP		-	SUPPLIERS
					AP_INVOICES
	  FA		-	FIXED_ASSETS


=CONCATENATE(TRIM(A1)|",")