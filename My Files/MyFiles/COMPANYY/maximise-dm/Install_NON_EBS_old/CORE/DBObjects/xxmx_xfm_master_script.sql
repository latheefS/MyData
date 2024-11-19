--========================================================================================================
--== MXDM 1.0 XFM Tables Creation Script
--========================================================================================================
--
--========================================================================================================
--== The following script installs Transformation tables in XFM schema required for MAXIMISE 1.0 Toolkit. 
--========================================================================================================

--========================================================================================================
--== Log Header and timestamps
--========================================================================================================

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool /home/oracle/maximise/version1/MXDM/install/log/xfmmaster_&spool_date.log
select to_char(sysdate,'DDMMRRRR HH24MISS') Start_time from dual;
set verify off

--========================================================================================================
--== Calling FIN XFM tables 
--========================================================================================================

--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script PPM XFM Table Creation
PROMPT ******************************************************
--

@xxmx_ppm_proj_xfm_dbi.sql

--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script AP XFM Table Creation
PROMPT ******************************************************
--
@xxmx_ap_inv_xfm_dbi.sql   

--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script SUPPLIER XFM Table Creation
PROMPT ******************************************************
--       
@xxmx_ap_suppliers_xfm_dbi.sql  
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script AR CASH RECEIPTS XFM Table Creation
PROMPT ******************************************************
--  
@xxmx_ar_cash_receipts_xfm_dbi.sql
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script CUSTOMER XFM Table Creation
PROMPT ******************************************************
--
@xxmx_ar_customers_xfm_dbi.sql   
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script AR TRANSACTIONS XFM Table Creation
PROMPT ******************************************************
-- 
@xxmx_ar_trx_xfm_dbi.sql 
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script FIXED ASSET XFM Table Creation
PROMPT ******************************************************
--     
@xxmx_fa_massadd_xfm_dbi.sql 

--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script GL BALANCES XFM Table Creation
PROMPT ******************************************************
--   
@xxmx_gl_balances_xfm_dbi.sql 
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script GL JOURNAL XFM Table Creation
PROMPT ******************************************************
--
@xxmx_gl_journal_xfm_dbi.sql
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script PURCHASE ORDERS XFM Table Creation
PROMPT ******************************************************
--
@xxmx_scm_po_xfm_dbi.sql    


--========================================================================================================
--== Calling HCM XFM tables 
--========================================================================================================

--
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script HCM XFM table creation
PROMPT ******************************************************
--
--
@xxmx_hcm_hr_xfm_dbi.sql
--
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script BEN XFM table creation
PROMPT ******************************************************
--
--
@xxmx_hcm_ben_xfm_tab.sql
--
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script LRN XFM table creation
PROMPT ******************************************************
--
--
@xxmx_hcm_lrn_xfm_tab.sql

--
--
PROMPT
PROMPT
PROMPT ******************************************************
PROMPT ** Run Script IREC XFM table creation
PROMPT ******************************************************
--
--
@xxmx_hcm_rec_xfm_dbi.sql
--
PROMPT
PROMPT ****************************
PROMPT Provide Grants
PROMPT ****************************
--
--
@xxmx_fin_grant_dbi.sql


--========================================================================================================
--== Calling PAYROLL XFM tables 
--========================================================================================================

--@XXMX_HCM_PAY_XFM_TBL.sql

select to_char(sysdate,'DDMMRRRR HH24MISS') End_Time from dual;

EXIT

spool off;

