--======================================
--== MXDM 2.0 CORE PLSQL Script
--======================================
--
--========================================================================================================
--== The following script installs suporting PLSQL required in CORE schema to load Data Dictionary Tables
--== Source Data for Cloudbridge 2.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

set verify off
set termout off
set echo on

spool &1/masterstgdd.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

select to_char(sysdate,'DDMMRRRR HH24MISS') Start_time from dual;
set verify off

--==========================================================================
--== Calling CORE PLSQL to populate stg data dictionary tables.
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_stg_populate_ap_inv
PROMPT ****************************************
PROMPT
--
--

@"&1/AP/DBObjects/xxmx_stg_populate_ap_inv.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_stg_populate_ap_supp
PROMPT ****************************************
PROMPT
--
--

@"&1/AP/DBObjects/xxmx_stg_populate_ap_supp.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_stg_populate_ar_cash_rcpts
PROMPT ****************************************
PROMPT
--
--

@"&1/AR/DBObjects/xxmx_stg_populate_ar_cash_rcpts.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_ar_customers
PROMPT ****************************************
PROMPT
--
--

@"&1/AR/DBObjects/xxmx_stg_populate_ar_customers.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_ar_inv
PROMPT ****************************************
PROMPT
--
--

@"&1/AR/DBObjects/xxmx_stg_populate_ar_inv.sql"       
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_fa_massadd
PROMPT ****************************************
PROMPT
--
--

@"&1/FA/DBObjects/xxmx_stg_populate_fa_massadd.sql"                    
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_gl_balances
PROMPT ****************************************
PROMPT
--
--              
@"&1/GL/DBObjects/xxmx_stg_populate_gl_balances.sql"    

--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_gl_daily_rates
PROMPT ****************************************
PROMPT
--
@"&1/GL/DBObjects/xxmx_stg_populate_gl_daily_rates.sql" 
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_gl_historical_rates
PROMPT ****************************************
PROMPT
--
@"&1/GL/DBObjects/xxmx_stg_populate_gl_historical_rates.sql"               
                       
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_irec
PROMPT ****************************************
PROMPT
--
--

@"&1/CORE/DBObjects/xxmx_stg_populate_irec.sql"                
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_po
PROMPT ****************************************
PROMPT
--
--

@"&1/PO/DBObjects/xxmx_stg_populate_po.sql" 
--

PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_po_rcpt
PROMPT ****************************************

--   
@"&1/PO/DBObjects/xxmx_stg_populate_po_rcpt.sql"            
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_ppm
PROMPT ****************************************
PROMPT
--
--

@"&1/CORE/DBObjects/xxmx_stg_populate_ppm.sql"    
--
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_supp_tax
PROMPT ****************************************
--
@"&1/AP/DBObjects/xxmx_stg_populate_supp_tax.sql"
--
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_zx_customer_tax
PROMPT ****************************************
--
@"&1/AR/DBObjects/xxmx_stg_populate_zx_customer_tax.sql"
--
--
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_zx_customer_tax
PROMPT ****************************************
--
@"&1/AR/DBObjects/xxmx_stg_populate_zx_customer_tax.sql"
--
--
PROMPT ****************************************
PROMPT Run script xxmx_stg_populate_hr
PROMPT ****************************************
--
@"&1/HCM/DBObjects/xxmx_stg_populate_hr.sql"
--
PROMPT
PROMPT ****************************************
PROMPT  Scripts Executions Completed
PROMPT ****************************************
PROMPT
--
--

select to_char(sysdate,'DDMMRRRR HH24MISS') End_time from dual;

spool off;

set verify on
set echo off
set termout on

EXIT

