--======================================
--== MXDM 1.0 CORE PLSQL Script
--======================================
--
--========================================================================================================
--== The following script installs suporting PLSQL required in CORE schema to extract EBS/HCM/PAYROLL 
--== Source Data for MAXIMISE 1.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool /home/oracle/maximise/version1/MXDM/install/log/mastercore_&spool_date.log
select to_char(sysdate,'DDMMRRRR HH24MISS') Start_time from dual;
set verify off

--==========================================================================
--== Calling CORE PLSQL to support EBS Data extraction
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_utilities_dbi
PROMPT ****************************************
PROMPT
--
--

@xxmx_utilities_dbi.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_dynamic_sql
PROMPT ****************************************
PROMPT
--
--
@xxmx_dynamic_sql_pkg.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_gl_utilities_dbi
PROMPT ****************************************
PROMPT
--
--

@xxmx_gl_utilities_dbi.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_hcm_tansform_ssid
PROMPT ****************************************
PROMPT
--
--

@xxmx_hcm_tansform_ssid.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_utilities_pkg
PROMPT ****************************************
PROMPT
--
--

@xxmx_utilities_pkg.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_gl_utilities_pkg
PROMPT ****************************************
PROMPT
--
--
-- Has DB LINK Reference
--@xxmx_gl_utilities_pkg.sql  
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_metadata
PROMPT ****************************************
PROMPT
--
--

@xxmx_populate_metadata.sql       
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_file_groups
PROMPT ****************************************
PROMPT
--
--

@xxmx_populate_file_groups.sql                    
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_fusion_job_defs
PROMPT ****************************************
PROMPT
--
--

@xxmx_populate_fusion_job_defs.sql                
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_lookups
PROMPT ****************************************
PROMPT
--
--

@xxmx_populate_lookups.sql                        
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_file_locations
PROMPT ****************************************
PROMPT
--
--

@xxmx_populate_file_locations.sql                
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_populate_operating_units
PROMPT ****************************************
PROMPT
--
--
-- Has DB LINK Reference
--@xxmx_populate_operating_units.sql                
--
--
PROMPT
PROMPT **********************************************************
PROMPT  Run script xxmx_populate_default_migration_parameters
PROMPT **********************************************************
PROMPT
--
--

@xxmx_populate_default_migration_parameters.sql   
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script XXMX_FILE_GROUPS_V
PROMPT ****************************************
PROMPT
--
--

@xxmx_file_groups_v.sql    
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_oic_utilities_pkg
PROMPT ****************************************
PROMPT
--
--

@xxmx_oic_utilities_pkg.sql 
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_request_scheduling_dbi
PROMPT ****************************************
PROMPT
--
--

@xxmx_request_scheduling_dbi.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_request_scheduling_pkg
PROMPT ****************************************
PROMPT
--
--

@xxmx_request_scheduling_pkg.sql

--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_core_synonyms_dbi
PROMPT ****************************************
PROMPT
--
--
@xxmx_core_synonyms_dbi.sql

--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_fin_stg_extract_pkg
PROMPT ****************************************
PROMPT
--
--
@xxmx_fin_stg_extract_pkg.sql

--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_hcm_stg_extract_pkg
PROMPT ****************************************
PROMPT
--
--
@xxmx_hcm_stg_extract_pkg.sql
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


