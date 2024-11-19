--========================================================================================================
--== MXDM 1.0 HCM PLSQL Script
--========================================================================================================
--
--========================================================================================================
--== The following script installs HCM PLSQL in HCM CORE schema required for MAXIMISE 1.0 Toolkit. 
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
PROMPT  Run script xxmx_hdl_utilities_pkg.pks
PROMPT ****************************************
PROMPT
--
--

@"&1/HCM/DBObjects/xxmx_hdl_utilities_pkg.pks"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_hdl_utilities_pkg.pkb
PROMPT ****************************************
PROMPT
--
--
@"&1/HCM/DBObjects/xxmx_hdl_utilities_pkg.pkb"

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
PROMPT  Run Script xxmx_fusion_load_gen_pkg
PROMPT ****************************************
PROMPT
--
--
@"&1/CORE/DBObjects/xxmx_fusion_load_gen_pkg.sql"
--
--
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script HCM Extract package 
PROMPT ****************************************
PROMPT
--
--
-- Has DB LINK Reference
--@"&1/HCM/DBObjects/xxmx_kit_util_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_util_stg.pkb"

--
PROMPT  Run script HCM Grade
--
--@"&1/HCM/DBObjects/xxmx_kit_grade_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_grade_stg.pkb"
--
PROMPT  Run script HCM job
--
--@"&1/HCM/DBObjects/xxmx_kit_job_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_job_stg.pkb"
--
PROMPT  Run script HCM location
--
--@"&1/HCM/DBObjects/xxmx_kit_location_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_location_stg.pkb"
--
PROMPT  Run script HCM Org
--
--@"&1/HCM/DBObjects/xxmx_kit_org_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_org_stg.pkb"
--
PROMPT  Run script HCM person
--
--@"&1/HCM/DBObjects/xxmx_kit_person_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_person_stg.pkb"
--
PROMPT  Run script HCM position
--
--@"&1/HCM/DBObjects/xxmx_kit_position_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_position_stg.pkb"
--
PROMPT  Run script HCM talent
--
--@"&1/HCM/DBObjects/xxmx_kit_talent_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_talent_stg.pkb"
--
PROMPT  Run script HCM Worker
--
--@"&1/HCM/DBObjects/xxmx_kit_worker_stg.pks"
--@"&1/HCM/DBObjects/xxmx_kit_worker_stg.pkb"
--
PROMPT  Run script HCM Bank/Branch
--
--@"&1/CORE/DBObjects/xxmx_banks_and_branches_pkg.pks"
--@"&1/CORE/DBObjects/xxmx_banks_and_branches_pkg.pkb"
--
PROMPT  Run script HCM Irec Geo
--
--@"&1/RECRUIT/DBObjects/xxmx_irec_geo_hier_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irec_geo_hier_stg.pkb"
--
PROMPT  Run script HCM Referral
--
--@"&1/RECRUIT/DBObjects/xxmx_irec_job_referral_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irec_job_referral_stg.pkb"
--
PROMPT  Run script HCM Job Req
--
--@"&1/RECRUIT/DBObjects/xxmx_irec_job_requisition_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irec_job_requisition_stg.pkb"
--
PROMPT  Run script HCM Cand Pool
--
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_pool_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_pool_stg.pkb"
--
PROMPT  Run script HCM Candidate
--
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_stg.pkb"
--
PROMPT  Run script HCM Prospect
--
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_prospect_stg.pks"
--@"&1/RECRUIT/DBObjects/xxmx_irecruit_prospect_stg.pkb"
--
--


SELECT to_char(SYSDATE,'DDMMRRRR HH24MISS') end_time from Dual;

spool off;

set verify on
set echo off
set termout on

exit


