--
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--** VERSION   :  2.0
--**
--** AUTHORS   :  Joe Lalor
--**
--** PURPOSE   :  MXDM 2.0 STG Tables Creation
--**
--** NOTES     :
--**
--******************************************************************************

set verify off
set termout off
set echo on

spool &1/stg.log

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
--== Calling FIN STG tables 
--==========================================================================
@"&1/PA/DBObjects/xxmx_ppm_proj_stg_dbi.sql"
@"&1/AP/DBObjects/xxmx_ap_inv_stg_dbi.sql"
@"&1/AP/DBObjects/xxmx_ap_suppliers_stg_dbi.sql"
@"&1/AR/DBObjects/xxmx_ar_customers_stg_dbi.sql" 
@"&1/AR/DBObjects/xxmx_ar_trx_stg_dbi.sql"
@"&1/GL/DBObjects/xxmx_gl_balances_stg_dbi.sql"     
@"&1/AR/DBObjects/xxmx_ar_cash_receipts_stg_dbi.sql"
@"&1/FA/DBObjects/xxmx_fa_massadd_stg_dbi.sql"   
@"&1/GL/DBObjects/xxmx_gl_journal_stg_dbi.sql"   
@"&1/PO/DBObjects/xxmx_scm_po_stg_dbi.sql"

--==========================================================================
--== Calling HCM STG tables 
--==========================================================================

@"&1/HCM/DBObjects/xxmx_hcm_hr_stg_dbi.sql"
@"&1/HCM/DBObjects/xxmx_hcm_ben_stg_tab.sql"
@"&1/HCM/DBObjects/xxmx_hcm_lrn_stg_tab.sql"
@"&1/RECRUIT/DBObjects/xxmx_hcm_rec_stg_dbi.sql"


--==========================================================================
--== Calling PAYROLL STG tables 
--==========================================================================

--@"&1/AP/DBObjects/XXMX_HCM_PAY_STG_TBL.sql"

@"&1/CORE/DBObjects/xxmx_core_synonyms_stg_dbi.sql"
@"&1/CORE/DBObjects/xxmx_fin_grant_stg_dbi.sql"

spool off;

set verify on
set echo off
set termout on

exit




