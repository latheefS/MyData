
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CANDIDATE_JOBAPPL_ATTACHMENT_V" ("COL_HEADER") AS 
  select 'METADATA|Attachment|DataTypeCode|Title|CandidateNumber|RequisitionNumber|File|URLorFileName|Category' metadata from dual
union all
select unique 'MERGE|Attachment|FILE|'||substr(originaldocument,1,instr(originaldocument,'.')-1)||
'|'||candidate_number||'|'||requisition_number||'|'||originaldocument
||'|'||originaldocument||'|IRC_CANDIDATE_RESUME'
FROM XXMX_HCM_IREC_CAN_XFM
where 1=1
and current_state_code is not null
AND current_phase_code <>'OFFER'
and REQUISITION_NUMBER in(select requisitionID from XXMX_JOBVITE_REQUISITION_STG);

