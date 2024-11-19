
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CANDIDATE_HDL_V" ("COL_HEADER") AS 
  SELECT 'METADATA|Candidate|CandidateNumber|ObjectStatus|AvailabilityDate|StartDate|ConfirmedFlag|CandPrefLanguageCode|SourceSystemOwner|SourceSystemId' col1_header from dual
UNION ALL
SELECT DISTINCT 'MERGE|Candidate|'||CANDIDATE_NUMBER||'|'
||DECODE(OBJECT_STATUS,'ACTIVE','ORA_ACTIVE','ORA_INACTIVE')||'|'||AVAILABILITY_DATE
||'|'||START_DATE||'|'||CONFIRMED_FLAG||'|'||CAND_PREF_LANGUAGE_CODE||'|EBS|CAND_'
||CANDIDATE_NUMBER COL_DATA FROM XXMX_HCM_IREC_CAN_XFM r
where TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS') = (select max(TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS')) from XXMX_HCM_IREC_CAN_XFM where candidate_number= r.candidate_number)
UNION ALL
SELECT 'METADATA|CandidateEmail|PersonId(SourceSystemId)|DateFrom|EmailAddress|EmailType|SourceSystemOwner|SourceSystemId' col_header from dual
UNION ALL
/*SELECT DISTINCT 'MERGE|CandidateEmail|CAND_'||CANDIDATE_NUMBER
||'|'||START_DATE||'|'||CANDIDATE_NUMBER||'erpdev4@citco.com'
||'|'||'H1'||'|EBS|EMAIL_'||CANDIDATE_NUMBER COL_DATA  FROM XXMX_HCM_IREC_CAN_XFM r
where TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS') = (select max(TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS')) from XXMX_HCM_IREC_CAN_XFM where candidate_number= r.candidate_number)
*/
SELECT DISTINCT 'MERGE|CandidateEmail|CAND_'||CANDIDATE_NUMBER
||'|'||DATE_FROM||'|'||EMAIL_ADDRESS||'|'||DECODE(EMAIL_TYPE,'Work Email','W1','H1')
||'|EBS|EMAIL_'||CANDIDATE_NUMBER COL_DATA FROM XXMX_HCM_IREC_CAN_EMAIL_XFM r
where TO_DATE(DATE_FROM,'RRRR/MM/DD')  = (select max(TO_DATE(DATE_FROM,'RRRR/MM/DD')) from XXMX_HCM_IREC_CAN_EMAIL_XFM x where x.candidate_number= r.candidate_number)

UNION ALL
SELECT 'METADATA|CandidateName|PersonId(SourceSystemId)|EffectiveStartDate|CandidateNumber|NameType|FirstName|LastName|SourceSystemOwner|SourceSystemId' col2_header from dual
UNION ALL
SELECT DISTINCT 'MERGE|CandidateName|CAND_'||CANDIDATE_NUMBER||'|'
||EFFECTIVE_START_DATE||'|'||CANDIDATE_NUMBER||'|GLOBAL|'||FIRST_NAME||'|'
||LAST_NAME||'|EBS|NAME_'||CANDIDATE_NUMBER COL_DATA 
FROM XXMX_HCM_IREC_CAN_NAME_XFM r
where TO_DATE(EFFECTIVE_START_DATE,'RRRR/MM/DD') = (select max(TO_DATE(EFFECTIVE_START_DATE,'RRRR/MM/DD')) from XXMX_HCM_IREC_CAN_NAME_XFM where candidate_number= r.candidate_number)
UNION ALL
SELECT 'METADATA|CandidateAddress|CandidateNumber|AddressLine1|TownOrCity|Country|PostalCode|EffectiveStartDate|AddressType|SourceSystemOwner|SourceSystemId' FROM DUAL
UNION ALL
SELECT DISTINCT 'MERGE|CandidateAddress|'||CANDIDATE_NUMBER||'|'||ADDRESS_LINE_1
||'|'||TOWN_OR_CITY||'|'||COUNTRY||'|'||POSTAL_CODE||'|'||EFFECTIVE_START_DATE
||'|HOME|EBS|ADD_'||CANDIDATE_NUMBER COL_DATA
FROM XXMX_HCM_IREC_CAN_ADDRESS_XFM r
where TO_DATE(EFFECTIVE_START_DATE,'RRRR/MM/DD') = (select max(TO_DATE(EFFECTIVE_START_DATE,'RRRR/MM/DD')) from XXMX_HCM_IREC_CAN_ADDRESS_XFM where candidate_number= r.candidate_number)
UNION ALL
SELECT 'METADATA|CandidatePhone|PersonId(SourceSystemId)|LegislationCode|CountryCodeNumber|AreaCode|PhoneNumber|PhoneType|DateFrom|SourceSystemOwner|SourceSystemId' col3_header from dual
UNION ALL
SELECT DISTINCT 'MERGE|CandidatePhone|CAND_'||CANDIDATE_NUMBER
||'|'||LEGISLATION_CODE||'|'||COUNTRY_CODE_NUMBER||'|'||AREA_CODE
||'|'||phone_number||'|'||PHONE_TYPE||'|'||DATE_FROM||'|EBS|PHONE_'
||CANDIDATE_NUMBER COL_DATA FROM XXMX_HCM_IREC_CAN_PHONE_XFM r
where TO_DATE(DATE_FROM,'RRRR/MM/DD') = (select max(TO_DATE(DATE_FROM,'RRRR/MM/DD')) from XXMX_HCM_IREC_CAN_PHONE_XFM where candidate_number= r.candidate_number)
UNION ALL
SELECT 'METADATA|CandidateExtraInfo|EFF_CATEGORY_CODE|FLEX:PER_PERSON_EIT_EFF|cancelFilledRequisitionNumber(PER_PERSON_EIT_EFF=Candidate_Jobvite_Submission)|candidateJobviteNotes(PER_PERSON_EIT_EFF=Candidate_Jobvite_Submission)|candidateJobviteSource(PER_PERSON_EIT_EFF=Candidate_Jobvite_Submission)|candidateJobviteSourceMedium(PER_PERSON_EIT_EFF=Candidate_Jobvite_Submission)|candidateJobviteSubmissionDate(PER_PERSON_EIT_EFF=Candidate_Jobvite_Submission)|EffectiveStartDate|InformationType|CandidateNumber|SourceSystemOwner|SourceSystemId' col4_header
from dual
UNION ALL
SELECT DISTINCT 'MERGE|CandidateExtraInfo|PER_EIT|Candidate_Jobvite_Submission|'
||requisition_number||'|'||substr(notes,1,100)||'|'
||decode(SOURCE,'Employee Referral',source,'Agency Name',source,null)||'|'||decode(source_medium,'Referred by Agency',source_medium,'Jobvite Referral',source_medium,null)||'|'||TO_CHAR(TO_DATE(availability_date,'RRRR/MM/DD HH24:MI:SS'),'rrrr/mm/dd')||'|'
||TO_CHAR(TO_DATE(availability_date,'RRRR/MM/DD HH24:MI:SS'),'rrrr/mm/dd')||'|'
||'Candidate_Jobvite_Submission|'||CANDIDATE_NUMBER||'|EBS|CAND_EI_'||CANDIDATE_NUMBER COL_DATA
FROM XXMX_HCM_IREC_CAN_XFM r
where TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS') = (select max(TO_DATE(AVAILABILITY_DATE,'RRRR/MM/DD HH24:MI:SS')) from XXMX_HCM_IREC_CAN_XFM where candidate_number= r.candidate_number)
--AND source in ('Employee Referral','Agency Name')
;

