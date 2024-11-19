--========================================================================================================
--== MXDM 1.0 IREC PLSQL Script
--========================================================================================================
--
--========================================================================================================
--== The following script installs IREC PLSQL in IREC schema required for Cloudbridge 1.0 Toolkit. 
--========================================================================================================

--========================================================================================================
--== Log Header and timestamps
--========================================================================================================

set verify off
set termout off
set echo on

spool &1/irec.log


column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;


--========================================================================================================
--== Calling IREC PLSQL to Extract IREC Data
--========================================================================================================
--
--
PROMPT  Run script HCM Irec Geo
--
@"&1/RECRUIT/DBObjects/xxmx_irec_geo_hier_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irec_geo_hier_stg.pkb"
--
PROMPT  Run script HCM Referral
--
@"&1/RECRUIT/DBObjects/xxmx_irec_job_referral_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irec_job_referral_stg.pkb"
--
PROMPT  Run script HCM Job Req
--
@"&1/RECRUIT/DBObjects/xxmx_irec_job_requisition_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irec_job_requisition_stg.pkb"
--
PROMPT  Run script HCM Cand Pool
--
@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_pool_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_pool_stg.pkb"
--
PROMPT  Run script HCM Candidate
--
@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irecruit_cand_stg.pkb"
--
PROMPT  Run script HCM Prospect
--
@"&1/RECRUIT/DBObjects/xxmx_irecruit_prospect_stg.pks"
@"&1/RECRUIT/DBObjects/xxmx_irecruit_prospect_stg.pkb"
--
--


SELECT to_char(SYSDATE,'DDMMRRRR HH24MISS') end_time from Dual;

spool off;

set verify on
set echo off
set termout on

exit


