--======================================
--== MXDM 2.0 CORE PLSQL Script
--======================================
--
--========================================================================================================
--== The following script installs suporting PLSQL required in CORE schema to load Data Dictionary Tables
--== Source Data for MAXIMISE 2.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

set verify off
set termout off
set echo on

spool &1/updatexfmdd.log


column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

select to_char(sysdate,'DDMMRRRR HH24MISS') Start_time from dual;

--==========================================================================
--== Calling CORE PLSQL to populate xfm data dictionary tables.
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_xfm_update_columns_ap
PROMPT ****************************************
PROMPT
--
--

@"&1/AP/DBObjects/xxmx_xfm_update_columns_ap.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_xfm_update_columns_ar
PROMPT ****************************************
PROMPT
--
--

@"&1/AR/DBObjects/xxmx_xfm_update_columns_ar.sql"	
--
--
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_ppm
PROMPT ****************************************
PROMPT
--
--

@"&1/PA/DBObjects/xxmx_xfm_update_columns_ppm.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_fa
PROMPT ****************************************
PROMPT
--
--

@"&1/FA/DBObjects/xxmx_xfm_update_columns_fa.sql"       
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_gl
PROMPT ****************************************
PROMPT
--
--

@"&1/GL/DBObjects/xxmx_xfm_update_columns_gl.sql"                    
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_irec
PROMPT ****************************************
PROMPT
--
--

@"&1/RECRUIT/DBObjects/xxmx_xfm_update_columns_irec.sql"                                     
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_po
PROMPT ****************************************
PROMPT
--
--

@"&1/PO/DBObjects/xxmx_xfm_update_columns_po.sql"  
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_populate_po_rcpt
PROMPT ****************************************
PROMPT
--
--

@"&1/PO/DBObjects/xxmx_xfm_populate_po_rcpt.sql" 
@"&1/PO/DBObjects/xxmx_stg_populate_po_rcpt.sql"
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_xfm_update_columns_hr
PROMPT ****************************************
PROMPT
--
@"&1/HCM/DBObjects/xxmx_xfm_update_columns_hr.sql"
--
--
--
@"&1/CORE/DBObjects/xxmx_exec_update_dd.sql"
--
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


