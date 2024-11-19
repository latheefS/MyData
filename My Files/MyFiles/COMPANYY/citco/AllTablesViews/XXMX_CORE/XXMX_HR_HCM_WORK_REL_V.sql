--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_WORK_REL_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_WORK_REL_V" ("WRS_PERSON_ID", "WRS_DATE_START", "WRS_ORIGINAL_DATE_OF_HIRE", "WRS_ACTUAL_TERMINATION_DATE", "WRS_PERIOD_TYPE", "WRS_LEGAL_EMPLOYER_NAME", "WRS_ATTRIBUTE1", "WRS_ATTRIBUTE2", "WRS_LEGISLATION_CODE", "WRS_PRIMARY_FLAG", "WRS_BG_NAME", "WRS_PERSON_NUMBER", "WRS_WORKER_TYPE", "WRS_PPOS") AS 
  SELECT  DISTINCT
         wrs.person_id                                      wrs_person_id
        ,TO_CHAR(wrs.date_start,'RRRR/MM/DD')               wrs_date_start
        ,TO_CHAR(wrs.original_date_of_hire,'RRRR/MM/DD')    wrs_original_date_of_hire
        ,TO_CHAR(wrs.actual_termination_date,'RRRR/MM/DD')  wrs_actual_termination_date
        ,wrs.period_type                                    wrs_period_type
        ,RTRIM(wrs.legal_employer_name)                     wrs_legal_employer_name
        ,NVL(wrs.attribute1,'HIRE')                         wrs_attribute1
        ,wrs.attribute2                                     wrs_attribute2
        ,wrs.legislation_code                               wrs_legislation_code
        ,wrs.primary_flag                                   wrs_primary_flag
        ,wrs.bg_name                                        wrs_bg_name
        ,wrs.WORKER_NUMBER                                  wrs_person_number
        ,'Employee'                                         wrs_worker_type
        ,wrs.period_of_service_id                           wrs_ppos
     FROM  xxmx_per_pos_wr_xfm       wrs
  ORDER BY wrs_person_id, wrs_date_start
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_WORK_REL_V" TO "XXMX_READONLY";
