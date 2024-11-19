--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_FILE_SET_V1
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_FILE_SET_V1" ("MIGRATION_SET_ID", "PERSON_ID", "ASSIGNMENT_NUMBER", "PERSON_NUMBER", "ACTION_CODE", "TERM_ACTION", "REASON_CODE", "PER_START_DATE", "PPOS", "LEGAL_EMP_NAME") AS 
  SELECT  DISTINCT
         asg.migration_set_id                                migration_set_id
        ,asg.person_id                                       person_id
        ,asg.assignment_number                               assignment_number
        ,p.personnumber                                     person_number
        ,asg.action_code
        ,CASE 
           WHEN ASG.REASON_CODE LIKE 'VOL%'
           THEN 'CITCO_VOLUNTARY_TERMINATION'
           WHEN ASG.REASON_CODE LIKE 'INVOL%'
           THEN 'INVOLUNTARY_TERMINATION'
         END TERM_ACTION
        ,ASG.ASS_ATTRIBUTE31 REASON_CODE
        ,to_char(p.start_Date,'RRRR/MM/DD')              per_start_date
        --,to_char(SYSDATE,'RRRR/MM/DD')              per_start_date
        ,asg.period_of_service_id                            ppos
        ,asg.legal_employer_name                             legal_emp_name
  FROM  XXMX_XFM.xxmx_per_assignments_m_xfm asg
       ,XXMX_XFM.xxmx_per_people_f_xfm  p
   where asg.person_id = p.person_id
     and p.personnumber is not null
     --  and  asg.location_code in (Select location_code 
                --                                        from xx_position_map_temp)
                          and asg.position_code in (Select position_code 
                                                        from xx_position_map_temp )
--AND ASG.USER_PERSON_TYPE NOT IN('Contingent Worker','External Professional','Board Member')
AND ASG.PERSONNUMBER NOT IN(SELECT UNIQUE PERSON_NUMBER FROM XXMX_PER_SAL_HIST_WORKER_STG)
AND ASG.PERSONNUMBER NOT IN(SELECT UNIQUE PERSON_NUMBER FROM XXMX_PER_PPM_WORKER_STG)
and asg.personnumber not in('34708','34715','34718','34754','34779','34783','34888','34908','34937','34945','34975'
,'35000','35001','35004','35013','35034','35034','35029') 
--AND ASG.ACTION_CODE LIKE 'TERM%'
 order by p.personnumber desc
;
