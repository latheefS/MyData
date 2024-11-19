--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_ABSENCES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_ABSENCES_V" ("LINE_TYPE", "HDL_DATA") AS 
  select "LINE_TYPE","HDL_DATA" from (
         --'METADATA|PersonAbsenceEntry|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration';
         --'METADATA|PersonMaternityAbsenceEntry|PerAbsenceEntryId(SourceSystemId)|PersonNumber|StartDate|StartTime|PlannedStartDate|PlannedReturnDate|IntendToWork|ExpectedDateOfChildBirth|ExpectedEndDate|ActualStartDate|ActualReturnDate|ActualChildBirthDate|OpenEndedFlag';
 SELECT DISTINCT 0 line_type, 
             'METADATA|PersonMaternityAbsenceEntry|SourceSystemOwner|SourceSystemId|PerAbsenceEntryId(SourceSystemId)|PersonNumber|StartDate|StartTime|PlannedStartDate|PlannedReturnDate|IntendToWork|ExpectedDateOfChildBirth|ExpectedEndDate|ActualStartDate|ActualReturnDate|ActualChildBirthDate|OpenEndedFlag'
             hdl_data
    FROM DUAL
    union all
            SELECT  distinct  1 line_type,
            'MERGE|PersonMaternityAbsenceEntry|EBS|'||            
            abs.personnumber||'_'||abs.absencename||'_'||to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            'PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.personnumber||'|'||
            ''||'|'||
            ''||'|'||
            to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.enddate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.intendtoretflag||'|'||
            to_char(to_date(abs.due_date,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.actual_birth_date,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.ATTRIBUTE2 -- Open End Date Flag
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            WHERE  UPPER(abs.absencename) like '%MATERNITY%'
            -- and abs.personnumber = 17224
union all
--The below update statement is for uploading DFF for Sick Leave Certified or Uncertified DFF for below Countries 
--update xxmx_per_absence_xfm set migration_set_id = 301 WHERE LEGISLATIONCODE IN ('GB','GG','IE','JE','LU') AND UPPER(ABSENCENAME) LIKE 'SICK%CERT%';  --533 
SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration'
            from dual
union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8  --EndDateDuration            
           -- NVL(abs.StartDateDuration,0)||'|'|| 
           -- NVL(abs.EndDateDuration,0)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 300
---Added below HDL for CERTIFIED and UNCERTIFIED Dff
UNION ALL
  SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration|FLEX:ANC_PER_ABS_ENTRIES_DFF|certificationStatus(ANC_PER_ABS_ENTRIES_DFF=300000060800570)'  --GB
            from dual
  union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8||'|300000060800570|'||substr(absencename,instr(absencename,' ',1,2)+1,instr(absencename,' ',1,3)-instr(absencename,' ',1,2)-1)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 301
			  AND LEGISLATIONCODE = 'GB'
UNION ALL
  SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration|FLEX:ANC_PER_ABS_ENTRIES_DFF|certificationStatus(ANC_PER_ABS_ENTRIES_DFF=300000060784975)'  --GG
            from dual
  union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8||'|300000060784975|'||substr(absencename,instr(absencename,' ',1,2)+1,instr(absencename,' ',1,3)-instr(absencename,' ',1,2)-1)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 301
              AND LEGISLATIONCODE = 'GG'
UNION ALL
  SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration|FLEX:ANC_PER_ABS_ENTRIES_DFF|certificationStatus(ANC_PER_ABS_ENTRIES_DFF=300000060785080)'  --IE
            from dual
  union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8||'|300000060785080|'||substr(absencename,instr(absencename,' ',1,2)+1,instr(absencename,' ',1,3)-instr(absencename,' ',1,2)-1)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 301
              AND LEGISLATIONCODE = 'IE'
UNION ALL
  SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration|FLEX:ANC_PER_ABS_ENTRIES_DFF|certificationStatus(ANC_PER_ABS_ENTRIES_DFF=300000060800115)'  --JE
            from dual
  union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8||'|300000060800115|'||substr(absencename,instr(absencename,' ',1,2)+1,instr(absencename,' ',1,3)-instr(absencename,' ',1,2)-1)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 301
              AND LEGISLATIONCODE = 'JE'
UNION ALL
  SELECT DISTINCT 0 line_type,
            'METADATA|PersonAbsenceEntry|SourceSystemOwner|SourceSystemId|Employer|PersonNumber|AbsenceType|AbsenceReason|AbsenceStatus|ApprovalStatus|NotificationDate|ConfirmedDate|Comments|StartDate|StartTime|EndDate|EndTime|AssignmentNumber|StartDateDuration|EndDateDuration|FLEX:ANC_PER_ABS_ENTRIES_DFF|certificationStatus(ANC_PER_ABS_ENTRIES_DFF=300000060800185)'  --LU
            from dual
  union
select distinct 1 line_type,
            'MERGE|PersonAbsenceEntry|EBS|PersonAbsenceEntry-'||abs.personnumber||'-'||abs.absencename||'-'||to_char(to_date(abs.startdate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Legal_employer_name||'|'||
            abs.personnumber||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Paid','Maternity Leave'
                    ,'Maternity Leave Unpaid','Maternity Leave'
                    ,abs.absencetype))||'|'||
            trim(decode(abs.absencename
                    ,'Maternity Leave Unpaid','Unpaid'
                    ,'Maternity Leave Paid','Paid'
                    ,abs.absencereason))||'|'||            
            'SUBMITTED'||'|'||
            'APPROVED'||'|'|| 
            to_char(to_date(abs.date_notification,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            to_char(to_date(abs.ConfirmedDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.Comments||'|'||
            to_char(to_date(abs.StartDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            abs.StartTime||'|'||
            to_char(to_date(abs.EndDate,'DD-MON-RRRR HH24:MI:SS'),'RRRR/MM/DD')||'|'||
            DECODE (abs.EndDate, NULL, NULL, abs.EndTime)||'|'||
            '|'|| --Assignment Number
            8||'|'||  --StartDateDuration
            8||'|300000060800185|'||substr(absencename,instr(absencename,' ',1,2)+1,instr(absencename,' ',1,3)-instr(absencename,' ',1,2)-1)
            FROM XXMX_XFM.xxmx_per_absence_xfm abs
            where abs.migration_set_id = 301
              AND LEGISLATIONCODE = 'LU'
  )
;
