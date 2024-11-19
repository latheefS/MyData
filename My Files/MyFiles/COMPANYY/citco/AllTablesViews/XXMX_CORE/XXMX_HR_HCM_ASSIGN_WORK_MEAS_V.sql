--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_ASSIGN_WORK_MEAS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_ASSIGN_WORK_MEAS_V" ("WM_MIGRATION_SET_ID", "WM_PERSON_ID", "WM_EFFECTIVE_START_DATE", "WM_EFFECTIVE_END_DATE", "WM_UNIT", "WM_VALUE", "WM_ASSIGNMENT_ID", "WM_ASSIGNMENT_NUMBER", "WM_LEGISLATION_CODE", "WM_BG_NAME") AS 
  SELECT DISTINCT
         wm.migration_set_id                           wm_migration_set_id
        ,wm.person_id                                  wm_person_id
        ,TO_CHAR(wm.effective_start_date,'RRRR/MM/DD') wm_effective_start_date
        ,TO_CHAR(wm.effective_end_date,'RRRR/MM/DD')   wm_effective_end_date
        ,wm.unit                                       wm_unit
        ,wm.value                                      wm_value
        ,wm.assignment_id                              wm_assignment_id
        ,wm.assignment_number                          wm_assignment_number
        ,wm.legislation_code                           wm_legislation_code
        ,wm.bg_name                                    wm_bg_name
    FROM   xxmx_asg_workmsure_xfm wm
  ORDER BY wm.person_id, wm.unit
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_ASSIGN_WORK_MEAS_V" TO "XXMX_READONLY";
