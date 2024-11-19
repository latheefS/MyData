--======================================
--== MXDM 1.0 CORE OIC Script
--======================================
--
--========================================================================================================
--== The following script installs supporting OIC required in CORE schema to extract EBS/HCM/PAYROLL 
--== Source Data for MAXIMISE 2.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

set verify off
set termout off
set echo on

spool &1/oiccore.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;



--==========================================================================
--== Calling CORE PLSQL to support OIC Data Migration
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_project_transaction_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_project_transaction_ext_pkg.pkh"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_project_transaction_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_project_transaction_ext_pkg.pkb"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_project_foundation_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_project_foundation_ext_pkg.pkh"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_project_foundation_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_project_foundation_ext_pkg.pkb"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_fa_massadd_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_fa_massadd_ext_pkg.pkh"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_fa_massadd_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_fa_massadd_ext_pkg.pkb"
--
--
PROMPT
PROMPT **********************************************************
PROMPT  Run script xxmx_ar_trx_ext_pkg
PROMPT **********************************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ar_trx_ext_pkg.pkh"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_ar_trx_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ar_trx_ext_pkg.pkb"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_ar_cust_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ar_cust_ext_pkg.pkh"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_ar_cust_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ar_cust_ext_pkg.pkb"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_ap_supp_ext_pkg
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ap_supp_ext_pkg.pkh"

--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_ap_supp_ext_pkg
PROMPT ****************************************
PROMPT
--
--
@"&1/EXTENSION/xxmx_ap_supp_ext_pkg.pkb"

--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_ap_inv_ext_pkg
PROMPT ****************************************
PROMPT
--
--
@"&1/EXTENSION/xxmx_ap_inv_ext_pkg.pkh"

--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_ap_inv_ext_pkg
PROMPT ****************************************
PROMPT
--
--
@"&1/EXTENSION/xxmx_ap_inv_ext_pkg.pkb"
--
--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_populate_subentity_filemap
PROMPT ****************************************
PROMPT
--
--
@"&1/EXTENSION/xxmx_populate_subentity_filemap.sql"
--
@"&1/PO/DBObjects/xxmx_xfm_update_columns_po.sql"
--
@"&1/CORE/DBObjects/xxmx_exec_update_dd.sql"
--
PROMPT
PROMPT ****************************************
PROMPT  Scripts Executions Completed
PROMPT ****************************************
PROMPT
--
--

select to_char(sysdate,'DDMMRRRR HH24MISS') End_time from dual;

EXIT

spool off;


