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

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool /home/oracle/maximise/version1/MXDM/install/log/oiccoredbi_&spool_date.log
select to_char(sysdate,'DDMMRRRR HH24MISS') Start_time from dual;
set verify off

--==========================================================================
--== Calling CORE PLSQL to support OIC Data Migration
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_create_arch_dbi_script
PROMPT ****************************************
PROMPT
--
--

@xxmx_create_arch_dbi_script.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_dm_entity_table_map_v
PROMPT ****************************************
PROMPT
--
--
@xxmx_dm_entity_table_map_v.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_ftp_directory_create_scripts
PROMPT ****************************************
PROMPT
--
--

@xxmx_ftp_directory_create_scripts.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_oic_table_dbi
PROMPT ****************************************
PROMPT
--
--

@xxmx_oic_table_dbi.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_temp_file_names_v
PROMPT ****************************************
PROMPT
--
--

@xxmx_temp_file_names_v.sql
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

EXIT

spool off;


