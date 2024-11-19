--=================================================================================================
--== MXDM 1.0 STG Tables Creation Script
--=================================================================================================
--
--=================================================================================================
--== The following script installs staging tables in STG schema required for MAXIMISE 1.0 Toolkit. 
--=================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool /home/oracle/maximise/version1/MXDM/install/log/stgmaster_&spool_date.log
select to_char(sysdate,'DDMMRRRR HH24MISS') start_time from dual;
set verify off

--==========================================================================
--== Calling FIN STG tables 
--==========================================================================
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script PPM STG table creation
PROMPT *************************************
--

@xxmx_ppm_proj_stg_dbi.sql
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script AP STG table creation
PROMPT *************************************
--
@xxmx_ap_inv_stg_dbi.sql
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script SUPPLIER STG table creation
PROMPT *************************************
--
@xxmx_ap_suppliers_stg_dbi.sql
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script CASH RECEIPTS STG table creation
PROMPT *************************************
--
@xxmx_ar_cash_receipts_stg_dbi.sql
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script CUSTOMER STG table creation
PROMPT *************************************
--
@xxmx_ar_customers_stg_dbi.sql 
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script FIXED ASSETS STG table creation
PROMPT *************************************
--
@xxmx_fa_massadd_stg_dbi.sql   
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script AR TRANSACTIONS STG table creation
PROMPT *************************************
--
@xxmx_ar_trx_stg_dbi.sql          
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script GL BALANCES STG table creation
PROMPT *************************************
--
@xxmx_gl_balances_stg_dbi.sql  
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script GL JOURNALS STG table creation
PROMPT *************************************
--
@xxmx_gl_journal_stg_dbi.sql   
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script PURCHASE ORDERS STG table creation
PROMPT *************************************
--
@xxmx_scm_po_stg_dbi.sql

--==========================================================================
--== Calling HCM STG tables 
--==========================================================================
--
--
PROMPT
PROMPT
PROMPT ***********************************
PROMPT ** Run Script HCM Table Creation
PROMPT ***********************************
--
--
@xxmx_hcm_hr_stg_dbi.sql
--
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script BENEFITS Table Creation
PROMPT *************************************
--
--
@xxmx_hcm_ben_stg_tab.sql
--
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script LEARNING TABLE CREATION
PROMPT *************************************
--
--
@xxmx_hcm_lrn_stg_tab.sql

--
--
PROMPT
PROMPT
PROMPT *************************************
PROMPT ** Run Script IREC TABLE CREATION
PROMPT *************************************
--
--
@xxmx_hcm_rec_stg_dbi.sql

--==========================================================================
--== Calling PAYROLL STG tables 
--==========================================================================

--@XXMX_HCM_PAY_STG_TBL.sql

select to_char(sysdate,'DDMMRRRR HH24MISS') end_time from dual;

EXIT

spool off;

