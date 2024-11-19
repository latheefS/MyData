--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_ASG_SAL_NON_IN_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_ASG_SAL_NON_IN_V" ("HDL_DATA") AS 
  SELECT 'METADATA|Salary|SourceSystemOwner|SourceSystemId|AssignmentNumber|DateFrom|DateTo|SalaryBasisName|SalaryAmount|ActionCode|MultipleComponents|SalaryApproved' hdl_data
  FROM DUAL
  UNION all
  select distinct 'MERGE|Salary|EBS|Salary-'||assignment_number||'-'||TO_CHAR(effective_start_date,'YYYYMMDD')||'|'||assignment_number||'|'||to_char(effective_start_date, 'yyyy/mm/dd') ||'|'||to_char(effective_end_date, 'yyyy/mm/dd')||'|'||name||'|'||proposed_salary||'|CHANGE_SALARY|'||MULTIPLE_COMPONENTS||'|'||APPROVED
  FROM xxmx_per_asg_salary_xfm
  WHERE NAME NOT LIKE 'IN%'
  AND ASSIGNMENT_NUMBER IN(SELECT ASSIGNMENT_NUMBER FROM XXMX_HR_HCM_FILE_SET_V1 )
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_ASG_SAL_NON_IN_V" TO "XXMX_READONLY";
