--========================================================================================================
--== MXDM 1.0 HCM PLSQL Script
--========================================================================================================
--
--========================================================================================================
--== The following script installs HCM PLSQL in HCM CORE schema required for Cloudbridge 1.0 Toolkit. 
--========================================================================================================

--========================================================================================================
--== Log Header and timestamps
--========================================================================================================

set verify off
set termout off
set echo on

spool &1/hcmcore.log


column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;


--========================================================================================================
--== Calling HCM PLSQL to Extract HCM Data
--========================================================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script XXMX_HCM_HR_VIEWS
PROMPT ****************************************
PROMPT
--
--
@"&1/HCM/DBObjects/xxmx_hcm_hr_views.sql"
@"&1/HCM/DBObjects/xxmx_hcm_person_scope_mv.sql"
@"&1/HCM/DBObjects/xxmx_hcm_current_asg_scope_mv.sql"

--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script XXMX_PERSON_MIGR_TEMP_S
PROMPT ****************************************
PROMPT
--
--
--@xxmx_person_migr_temp_s.sql
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script XXMX_HDL_FILE_TEMP
PROMPT ****************************************
PROMPT
--
--
--@xxmx_hdl_file_temp.sql
--
--

PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_hcm_hdl_file_gen_pkg.pks
PROMPT ****************************************
PROMPT
--
--
@"&1/HCM/DBObjects/xxmx_hcm_hdl_file_gen_pkg.pks"
--
--

--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_hcm_hdl_file_gen_pkg.pkb
PROMPT ****************************************
PROMPT
--
--
@"&1/HCM/DBObjects/xxmx_hcm_hdl_file_gen_pkg.pkb"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script HCM Extract package 
PROMPT ****************************************
PROMPT
--

--
PROMPT  Run script HCM location
--
@"&1/HCM/DBObjects/xxmx_hr_location_pkg.pks"
@"&1/HCM/DBObjects/xxmx_hr_location_pkg.pkb"

--
@"&1/HCM/DBObjects/xxmx_kit_util_stg.pks"
@"&1/HCM/DBObjects/xxmx_kit_util_stg.pkb"
--
PROMPT  Run script HCM person
--
@"&1/HCM/DBObjects/xxmx_kit_person_stg.pks"
@"&1/HCM/DBObjects/xxmx_kit_person_stg.pkb"
--
PROMPT  Run script HCM Worker
--
@"&1/HCM/DBObjects/xxmx_kit_worker_stg.pks"
@"&1/HCM/DBObjects/xxmx_kit_worker_stg.pkb"
--
PROMPT  Run script HCM Bank/Branch
--
@"&1/CORE/DBObjects/xxmx_banks_and_branches_pkg.pksplb"
@"&1/CORE/DBObjects/xxmx_banks_and_branches_pkg.pkbplb"
--
--
--


SELECT to_char(SYSDATE,'DDMMRRRR HH24MISS') end_time from Dual;

spool off;

set verify on
set echo off
set termout on

exit


