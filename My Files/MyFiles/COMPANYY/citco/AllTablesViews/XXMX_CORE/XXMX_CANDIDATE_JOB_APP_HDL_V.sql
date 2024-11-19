--------------------------------------------------------
--  DDL for View XXMX_CANDIDATE_JOB_APP_HDL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CANDIDATE_JOB_APP_HDL_V" ("METADATA") AS 
  SELECT 'METADATA|CandidateJobApplication|RequisitionNumber|CandidateNumber|CurrentPhaseCode|CurrentStateCode|SubmissionDate|SubmissionLanguageCode|SourceSystemOwner|SourceSystemId' 
  METADATA FROM DUAL
UNION ALL
SELECT distinct 'MERGE|CandidateJobApplication|'||REQUISITION_NUMBER
||'|'||CANDIDATE_NUMBER||'|'
||CURRENT_PHASE_CODE||'|'||CURRENT_STATE_CODE
--||'NEW'||'|'||'TO_BE_REVIEWED'
||'|'||AVAILABILITY_DATE
||'|US|EBS|'||CANDIDATE_NUMBER||REQUISITION_NUMBER||'_JA'
FROM XXMX_HCM_IREC_CAN_XFM
where 1=1
and current_state_code is not null
and  current_state_code <> 'TO_BE_REVIEWED'
AND current_phase_code <>'OFFER'-- or current_state_code is  null
 --AND REQUISITION_NUMBER in (select distinct REQUISITIONID from XXMX_JOBVITE_REQUISITION_STG where STATUS IN ('Draft','Open', 'On Hold') and REQUISITIONID like 'IRC%')
and REQUISITION_NUMBER in (SELECT REQUISITION_NUMBER FROM XXMX_HCM_IREC_JOB_REQ_XFM
                            WHERE REQUISITION_number not in (SELECT REQ_NUM FROM XX_JOB_REQ_ERR))
UNION ALL
SELECT 'METADATA|CandidateJobApplicationExtraInfo|EFF_CATEGORY_CODE|FLEX:PER_PERSON_EIT_EFF|jobviteNotes(PER_PERSON_EIT_EFF=Jobvite_Submission)|jobviteSource(PER_PERSON_EIT_EFF=Jobvite_Submission)|jobviteSourceMedium(PER_PERSON_EIT_EFF=Jobvite_Submission)|jobviteSubmissionDate(PER_PERSON_EIT_EFF=Jobvite_Submission)|CandidateNumber|RequisitionNumber|SubmissionId(SourceSystemId)|SourceSystemOwner|SourceSystemId' METADATA FROM DUAL
UNION ALL
SELECT DISTINCT 'MERGE|CandidateJobApplicationExtraInfo|PER_EIT|Jobvite_Submission|'||Notes||'|'||source||'|'
  ||SOURCE_MEDIUM||'|'||START_DATE||'|'||CANDIDATE_NUMBER||'|'||REQUISITION_NUMBER||'|'
  ||CANDIDATE_NUMBER||REQUISITION_NUMBER||'_JA'||'|EBS|'||CANDIDATE_NUMBER||REQUISITION_NUMBER||'_JAEI'
FROM XXMX_HCM_IREC_CAN_XFM
where 1=1
 --AND REQUISITION_NUMBER in (select distinct REQUISITIONID from XXMX_JOBVITE_REQUISITION_STG where STATUS IN ('Draft','Open', 'On Hold') and REQUISITIONID like 'IRC%')
and REQUISITION_NUMBER in (SELECT REQUISITION_NUMBER FROM XXMX_HCM_IREC_JOB_REQ_XFM
                            WHERE REQUISITION_number not in (SELECT REQ_NUM FROM XX_JOB_REQ_ERR))
and current_state_code is not null
and  current_state_code <> 'TO_BE_REVIEWED'
AND current_phase_code <>'OFFER'
;
