--------------------------------------------------------
--  DDL for View XXMX_EXTRACT_SCRIPT_POSITION_CODES_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_EXTRACT_SCRIPT_POSITION_CODES_V" ("PERSONNUMBER", "EFFECTIVE_START_DATE", "EFFECTIVE_END_DATE", "LOCATION_CODE", "GRADE_CODE", "JOB_CODE", "COMPANY", "DEPARTMENT", "ASSIGNMENT_NUMBER", "ORIGINAL_DATE_OF_HIRE", "TERMINATION_DATE", "RECORD_TYPE", "EXTRACT_TYPE") AS 
  SELECT UNIQUE PERSONNUMBER,EFFECTIVE_START_DATE,EFFECTIVE_END_DATE,LOCATION_CODE,GRADE_CODE,JOB_CODE,NULL COMPANY,NULL DEPARTMENT
,ASSIGNMENT_NUMBER,(SELECT START_DATE FROM XXMX_PER_PERSONS_STG WHERE PERSONNUMBER=STG.PERSONNUMBER) ORIGINAL_DATE_OF_HIRE
,NULL TERMINATION_DATE,NULL RECORD_TYPE,'Active_Workers' Extract_Type
FROM XXMX_PER_ASSIGNMENTS_M_STG STG
WHERE ACTION_CODE='CURRENT'
--ORDER BY TO_NUMBER(PERSONNUMBER);
--------------------------------
--Salary_History Workers
--------------------------------
UNION ALL
SELECT "EMPLOYEE_NUMBER","EFFECTIVE_START_DATE","EFFECTIVE_END_DATE","LOCATION","GRADE","JOB","COMPANY","DEPARTMENT","ASSIGNMENT_NUMBER","ORIGINAL_DATE_OF_HIRE","TERMINATION_DATE","RECORD_TYPE","EXTRACT_TYPE" FROM
(SELECT UNIQUE NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) EMPLOYEE_NUMBER
,PA.EFFECTIVE_START_DATE,PA.EFFECTIVE_END_DATE
,(SELECT LOCATION_CODE FROM hr_locations@xxmx_extract WHERE LOCATION_ID=PA.LOCATION_ID) LOCATION
,(SELECT name FROM per_grades@xxmx_extract WHERE GRADE_ID = PA.GRADE_ID) GRADE
,(SELECT NAME FROM PER_JOBS@XXMX_EXTRACT WHERE JOB_ID = PA.JOB_ID ) JOB
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.ass_attribute2) company
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.organization_id) department 
,PA.ASSIGNMENT_NUMBER,PAPF.ORIGINAL_DATE_OF_HIRE
,(SELECT ACTUAL_TERMINATION_DATE FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT 
WHERE PERIOD_OF_SERVICE_ID = PA.PERIOD_OF_SERVICE_ID
 and pa.assignment_status_type_id = 3) TERMINATION_DATE
 , 'HIRE' RECORD_TYPE,'Salary_History' Extract_Type
FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT PA
, PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF
WHERE PA.PERSON_ID = PAPF.PERSON_ID
AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) IN(SELECT PERSONNUMBER FROM
                                                  (SELECT PERSONNUMBER,COUNT(UNIQUE NAME) FROM xxmx_per_asg_salary_STG 
                                                  GROUP BY PERSONNUMBER
                                                  HAVING COUNT(UNIQUE NAME)>1))
AND PA.EFFECTIVE_START_DATE =(SELECT MIN(EFFECTIVE_START_DATE) 
                                FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT
                               WHERE PERSON_ID = PA.PERSON_ID)
AND PA.EFFECTIVE_END_DATE =(SELECT MIN(EFFECTIVE_END_DATE) 
                                FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT
                               WHERE PERSON_ID = PA.PERSON_ID)
UNION ALL
SELECT UNIQUE NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) EMPLOYEE_NUMBER
,PA.EFFECTIVE_START_DATE,PA.EFFECTIVE_END_DATE
,(SELECT LOCATION_CODE FROM hr_locations@xxmx_extract WHERE LOCATION_ID=PA.LOCATION_ID) LOCATION
,(SELECT name FROM per_grades@xxmx_extract WHERE GRADE_ID = PA.GRADE_ID) GRADE
,(SELECT NAME FROM PER_JOBS@XXMX_EXTRACT WHERE JOB_ID = PA.JOB_ID ) JOB
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.ass_attribute2) company
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.organization_id) department
,PA.ASSIGNMENT_NUMBER,NULL ORIGINAL_DATE_OF_HIRE
,(SELECT ACTUAL_TERMINATION_DATE FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT 
WHERE PERIOD_OF_SERVICE_ID = PA.PERIOD_OF_SERVICE_ID
 and pa.assignment_status_type_id = 3) TERMINATION_DATE
, 'ASG_CHANGE' RECORD_TYPE,'Salary_History' Extract_Type
FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT PA
, PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF
WHERE PA.PERSON_ID = PAPF.PERSON_ID
AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND PA.ASSIGNMENT_NUMBER IS NOT NULL
AND NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) IN(SELECT PERSONNUMBER FROM
                                                (SELECT PERSONNUMBER,COUNT(UNIQUE NAME) FROM xxmx_per_asg_salary_STG 
                                                GROUP BY PERSONNUMBER
                                                HAVING COUNT(UNIQUE NAME)>1))
AND TO_DATE(PA.EFFECTIVE_START_DATE,'DD-MON-RR')>=TO_DATE('01/01/2020','DD/MM/RRRR')
)
--ORDER BY TO_NUMBER(EMPLOYEE_NUMBER)
UNION ALL
--------------------------------------------
--PPM Workers EXTRACT
--------------------------------------------
--Hire Record
SELECT "EMPLOYEE_NUMBER","EFFECTIVE_START_DATE","EFFECTIVE_END_DATE","LOCATION","GRADE","JOB","COMPANY","DEPARTMENT","ASSIGNMENT_NUMBER","ORIGINAL_DATE_OF_HIRE","TERMINATION_DATE","RECORD_TYPE","EXTRACT_TYPE" FROM(
SELECT UNIQUE NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) EMPLOYEE_NUMBER
,PA.EFFECTIVE_START_DATE,PA.EFFECTIVE_END_DATE
,(SELECT LOCATION_CODE FROM hr_locations@xxmx_extract WHERE LOCATION_ID=PA.LOCATION_ID) LOCATION
,(SELECT name FROM per_grades@xxmx_extract WHERE GRADE_ID = PA.GRADE_ID) GRADE
,(SELECT NAME FROM PER_JOBS@XXMX_EXTRACT WHERE JOB_ID = PA.JOB_ID ) JOB
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.ass_attribute2) company
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.organization_id) department 
,PA.ASSIGNMENT_NUMBER,PAPF.ORIGINAL_DATE_OF_HIRE
,NULL TERMINATION_DATE,'HIRE' RECORD_TYPE
 ,'PPM_Workers' Extract_Type
FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT PA
, PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF
WHERE PA.PERSON_ID = PAPF.PERSON_ID
AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) IN(SELECT UNIQUE PERSON_NUMBER FROM xxmx_ppm_prj_lbrcost_STG)
AND PA.EFFECTIVE_START_DATE =(SELECT MIN(EFFECTIVE_START_DATE) 
                                FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT
                               WHERE PERSON_ID = PA.PERSON_ID)
--AND PA.EFFECTIVE_END_DATE =(SELECT MIN(EFFECTIVE_END_DATE) FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT WHERE PERSON_ID = PA.PERSON_ID)
UNION ALL  --Assignment_Records
--SELECT VAL.*,decode(DENSE_RANK() over (partition by EMPLOYEE_NUMBER order by EMPLOYEE_NUMBER,LOCATION),1,'No','Yes') Legal_Employer_Change FROM
SELECT UNIQUE NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) EMPLOYEE_NUMBER
,PA.EFFECTIVE_START_DATE,PA.EFFECTIVE_END_DATE
,(SELECT LOCATION_CODE FROM hr_locations@xxmx_extract WHERE LOCATION_ID=PA.LOCATION_ID) LOCATION
,(SELECT name FROM per_grades@xxmx_extract WHERE GRADE_ID = PA.GRADE_ID) GRADE
,(SELECT NAME FROM PER_JOBS@XXMX_EXTRACT WHERE JOB_ID = PA.JOB_ID ) JOB
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.ass_attribute2) company
,(select name from hr_all_organization_units@xxmx_extract where organization_id=pa.organization_id) department
,PA.ASSIGNMENT_NUMBER,NULL ORIGINAL_DATE_OF_HIRE
,(SELECT ACTUAL_TERMINATION_DATE FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT 
WHERE PERIOD_OF_SERVICE_ID = PA.PERIOD_OF_SERVICE_ID
 and pa.assignment_status_type_id = 3) TERMINATION_DATE,'ASG_CHANGE' RECORD_TYPE
 ,'PPM_Workers' Extract_Type
FROM PER_ALL_ASSIGNMENTS_F@XXMX_EXTRACT PA
, PER_ALL_PEOPLE_F@XXMX_EXTRACT PAPF
WHERE PA.PERSON_ID = PAPF.PERSON_ID
AND SYSDATE BETWEEN PAPF.EFFECTIVE_START_DATE AND PAPF.EFFECTIVE_END_DATE
AND PA.ASSIGNMENT_NUMBER IS NOT NULL
AND NVL(PAPF.EMPLOYEE_NUMBER,PAPF.NPW_NUMBER) IN(SELECT UNIQUE PERSON_NUMBER FROM xxmx_ppm_prj_lbrcost_STG)
AND TO_DATE(PA.EFFECTIVE_START_DATE,'DD-MON-RR')>=TO_DATE('01/01/2020','DD/MM/RRRR')
) VAL
--ORDER BY to_number(EMPLOYEE_NUMBER),EFFECTIVE_START_DATE ASC
;
