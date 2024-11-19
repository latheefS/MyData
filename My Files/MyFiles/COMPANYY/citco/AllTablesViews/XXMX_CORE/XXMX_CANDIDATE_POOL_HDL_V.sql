--------------------------------------------------------
--  DDL for View XXMX_CANDIDATE_POOL_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CANDIDATE_POOL_HDL_V" ("COL_HEADER") AS 
  SELECT 'METADATA|CandidatePool|PoolName|PoolTypeCode|Description|Status|OwnerPersonNumber|SourceSystemOwner|SourceSystemId|OwnershipType' col1_header from dual
UNION ALL
SELECT DISTINCT  'MERGE|CandidatePool|'||
                 requisition_number||'|CANDIDATE|'||requisition_number||
                 '|A|34195|EBS|'||requisition_number||
                 '_CAND_POOL|ORA_PUBLIC' COL_DATA 
FROM XXMX_HCM_IREC_CAN_XFM r
where 1=1
AND requisition_number not like 'IRC%'
UNION ALL
SELECT 'METADATA|CandidatePoolMember|CurrentPhaseCode|CurrentStateCode|PoolName|Status|SourceSystemId|SourceSystemOwner|CandidateNumber' col1_header from dual
UNION ALL
select distinct 'MERGE|CandidatePoolMember|'
      ||'CANDIDATE_'||current_phase_code||'|'
      ||current_state_code||'|'
      ||requisition_number||'|A|'
      ||requisition_number||'_'||Candidate_number||'_CPMEM'
      ||'|EBS|'||Candidate_number
 COL_DATA 
FROM XXMX_HCM_IREC_CAN_XFM r
where 1=1--rowid = (select max(ROWID) from XXMX_HCM_IREC_CAN_XFM where candidate_number= r.candidate_number)
AND requisition_number not like 'IRC%'
and current_phase_code in ('NOT_CONTACTED','REVIEWED','ENGAGED')
;
