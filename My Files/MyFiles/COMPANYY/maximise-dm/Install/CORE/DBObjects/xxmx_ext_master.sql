--======================================
--== MXDM 2.0 EXT Tables Creation Script
--== Add GL Journal, PO,Irecruitment EXT 
--======================================
--
--========================================================================================================
--== The following script installs Transformation tables in EXT schema required for Cloudbridge 1.0 Toolkit. 
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

@"&1/AP/DBObjects/xxmx_ap_inv_ext_dbi.sql"          
@"&1/AP/DBObjects/xxmx_ap_suppliers_ext_dbi.sql"    
@"&1/AR/DBObjects/xxmx_ar_customers_ext_dbi.sql"    
@"&1/AR/DBObjects/xxmx_ar_trx_ext_dbi.sql"          
@"&1/AR/DBObjects/xxmx_ar_cash_receipts_ext_dbi.sql"
@"&1/GL/DBObjects/xxmx_gl_balances_ext_dbi.sql"     
--@"&1/GL/DBObjects/xxmx_gl_journal_ext_dbi.sql"
@"&1/PO/DBObjects/xxmx_scm_po_ext_dbi.sql"
--@"&1/PA/DBObjects/xxmx_ppm_proj_ext_dbi.sql"
@"&1/FA/DBObjects/xxmx_fa_massadd_ext_dbi.sql"
@"&1/GL/DBObjects/xmxx_gl_daily_rates_ext_dbi.sql"


--==========================================================================
--== Calling HCM XFM tables 
--==========================================================================

--@"&1/HCM/DBObjects/xxmx_hcm_hr_xfm_dbi.sql"
--@"&1/RECRUIT/DBObjects/xxmx_hcm_rec_xfm_dbi.sql"
--@"&1/BEN/DBObjects/xxmx_hcm_ben_xfm_tab.sql"
--@"&1/LRN/DBObjects/xxmx_hcm_lrn_xfm_dbi.sql"

--==========================================================================
--== Calling PAYROLL XFM tables 
--==========================================================================

--@XXMX_HCM_PAY_XFM_TBL.sql

--@"&1/CORE/DBObjects/xxmx_core_synonyms_xfm_dbi.sql"
--@"&1/CORE/DBObjects/xxmx_fin_grant_xfm_dbi.sql"

spool off;

set verify on
set echo off
set termout on

EXIT


