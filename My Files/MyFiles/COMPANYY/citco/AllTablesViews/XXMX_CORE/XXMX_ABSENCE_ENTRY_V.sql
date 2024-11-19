--------------------------------------------------------
--  DDL for View XXMX_ABSENCE_ENTRY_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_ABSENCE_ENTRY_V" ("HDL_DATA") AS 
  SELECT
    'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate'||
    '|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration' HDL_DATA
FROM
    dual
UNION ALL
SELECT
    'MERGE'||'|'
	||'PersonAbsenceEntry'
	||'|EBS'||'|'  --SourceSystemOwner
    || abs.personnumber|| '-'|| abs.absencetype|| '-'|| abs.absencereason|| '-'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRRMMDD') --SourceSystemId
    || '|'|| abs.legal_employer_name --Employer
    || '|'|| abs.personnumber  --PersonNumber
    || '|'|| abs.absencetype
    || '|'|| abs.absencereason
    || '|'|| 'SUBMITTED' --AbsenceStatus
    || '|'|| 'APPROVED'  --ApprovalStatus
    || '|'|| to_char(to_date(abs.date_notification, 'DD-MON-RRRR'), 'RRRR/MM/DD') --NotificationDate
    || '|'|| to_char(to_date(abs.confirmeddate, 'DD-MON-RRRR'), 'RRRR/MM/DD') --ConfirmedDate
    || '|'|| abs.comments
    || '|'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRR/MM/DD')
    || '|'|| abs.starttime
    || '|'|| to_char(to_date(abs.enddate, 'DD-MON-RRRR'), 'RRRR/MM/DD')
    || '|'|| abs.endtime
    || '|'|| '|' --Assignment Number
    ||'1'||'|'||  --StartDateDuration
     '1'  --EndDateDuration
FROM
    xxmx_xfm.xxmx_per_absence_xfm abs
   -- where nvl(absencereason,'X') <> 'Maternity Leave'
UNION ALL
SELECT 'METADATA|PersonMaternityAbsenceEntry|SourceSystemOwner|SourceSystemId|PerAbsenceEntryId(SourceSystemId)|PersonNumber|StartDate|StartTime|'||
    'PlannedStartDate|PlannedReturnDate|IntendToWork|ExpectedDateOfChildBirth|ExpectedEndDate|ActualStartDate|ActualReturnDate|ActualChildBirthDate|OpenEndedFlag'
FROM DUAL
UNION ALL
SELECT
    'MERGE'||'|'
	||'PersonMaternityAbsenceEntry'
	||'|EBS'||'|'  --SourceSystemOwner
    || abs.personnumber|| '-'|| abs.absencetype|| '-'|| abs.absencereason|| '-'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRRMMDD')||'-M'||'|' --SourceSystemId
	|| abs.personnumber|| '-'|| abs.absencetype|| '-'|| abs.absencereason|| '-'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRRMMDD') --PerAbsenceEntryId(SourceSystemId)
    || '|'|| abs.personnumber  --PersonNumber
	|| '|'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRR/MM/DD')
	|| '|'|| abs.starttime
	|| '|'|| to_char(to_date(abs.startdate, 'DD-MON-RRRR'), 'RRRR/MM/DD')  --PlannedStartDate
	|| '|'||plannedenddate
	|| '|'||INTENDTORETFLAG--IntendToWork
	||'|'||to_char(to_date(abs.due_date, 'DD-MON-RRRR'), 'RRRR/MM/DD')  --ExpectedDateOfChildBirth
	||'|'--ExpectedEndDate
	||'|'--ActualStartDate
	||'|'--ActualReturnDate
	||'|'--ActualChildBirthDate
	||'|N'--OpenEndedFlag
FROM
    xxmx_xfm.xxmx_per_absence_xfm abs
    where nvl(absencetype,'X') = 'Maternity Leave'
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_ABSENCE_ENTRY_V" TO "XXMX_READONLY";
