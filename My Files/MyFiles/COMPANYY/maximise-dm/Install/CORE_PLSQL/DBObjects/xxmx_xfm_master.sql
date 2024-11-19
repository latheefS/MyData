--======================================
--== MXDM 2.0 XFM Tables Creation Script
--== Add GL Journal, PO,Irecruitment XFM 
--======================================
--
--========================================================================================================
--== The following script installs Transformation tables in XFM schema required for MAXIMISE 1.0 Toolkit. 
--========================================================================================================

set verify off
set termout off
set echo on

spool &1/xfm.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

CREATE OR REPLACE PROCEDURE DropTable (pTable IN VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ' || pTable ;
EXCEPTION
   WHEN OTHERS THEN
	  IF SQLCODE != -942 THEN
		 RAISE;
	  END IF;
END DropTable ;
/
CREATE OR REPLACE PROCEDURE DropSequence (pSequence IN VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pSequence ;
EXCEPTION
   WHEN OTHERS THEN
	  IF SQLCODE != -02289 THEN
		 RAISE;
	  END IF;
END DropSequence ;
/

--==========================================================================
--== Calling FIN XFM tables 
--==========================================================================

@"&1/AP/DBObjects/xxmx_ap_inv_xfm_dbi.sql"          
@"&1/AP/DBObjects/xxmx_ap_suppliers_xfm_dbi.sql"    
@"&1/AR/DBObjects/xxmx_ar_customers_xfm_dbi.sql"    
@"&1/AR/DBObjects/xxmx_ar_trx_xfm_dbi.sql"          
@"&1/AR/DBObjects/xxmx_ar_cash_receipts_xfm_dbi.sql"
@"&1/GL/DBObjects/xxmx_gl_balances_xfm_dbi.sql"     
@"&1/GL/DBObjects/xxmx_gl_journal_xfm_dbi.sql"
@"&1/PO/DBObjects/xxmx_scm_po_xfm_dbi.sql"
@"&1/PA/DBObjects/xxmx_ppm_projects_xfm_dbi.sql"
@"&1/FA/DBObjects/xxmx_fa_massadd_xfm_dbi.sql"
@"&1/GL/DBObjects/xmxx_gl_daily_rates_xfm_dbi.sql"
@"&1/GL/DBObjects/xmxx_gl_historical_rates_xfm_dbi.sql"
@"&1/PO/DBObjects/xxmx_scm_po_rcpt_xfm_dbi.sql"
@"&1/AP/DBObjects/xxmx_fin_ap_supp_tax_xfm_dbi.sql"
@"&1/AR/DBObjects/xxmx_zx_customer_tax_xfm_dbi.sql"


--==========================================================================
--== Calling HCM XFM tables 
--==========================================================================

@"&1/HCM/DBObjects/xxmx_hcm_hr_xfm_dbi.sql"
@"&1/RECRUIT/DBObjects/xxmx_hcm_rec_xfm_dbi.sql"
@"&1/BEN/DBObjects/xxmx_hcm_ben_xfm_dbi.sql"
@"&1/LRN/DBObjects/xxmx_hcm_lrn_xfm_dbi.sql"
@"&1/HCM/DBObjects/xxmx_hcm_hr_location_xfm_dbi.sql"
@"&1/PAY/DBObjects/xxmx_hcm_payroll_xfm_dbi.sql"
@"&1/TM/DBObjects/xxmx_hcm_goal_xfm_dbi.sql"
@"&1/TM/DBObjects/xxmx_hcm_gpset_xfm_dbi.sql"
@"&1/TM/DBObjects/xxmx_hcm_goal_plan_xfm_dbi.sql"
@"&1/TM/DBObjects/xxmx_hcm_performance_document_xfm_dbi.sql"


--==========================================================================
--== Calling PAYROLL XFM tables 
--==========================================================================

--@XXMX_HCM_PAY_XFM_TBL.sql

@"&1/CORE/DBObjects/xxmx_core_synonyms_xfm_dbi.sql"
@"&1/CORE/DBObjects/xxmx_fin_grant_xfm_dbi.sql"

spool off;

set verify on
set echo off
set termout on

EXIT


