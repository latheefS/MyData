--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_ASSIGN_GRADE_STEP_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_ASSIGN_GRADE_STEP_V" ("GDS_MIGRATION_SET_ID", "GDS_PERSON_ID", "GDS_ASSIGNMENT_ID", "GDS_ASSIGNMENT_NUMBER", "GDS_GRADESTEPNAME", "GDS_GRADESTEPID", "GDS_GRADEID", "GDS_EFFECTIVE_START_DATE", "GDS_EFFECTIVE_END_DATE", "GDS_MIGRATION_STATUS", "GDS_BG_NAME") AS 
  SELECT DISTINCT
         gds.migration_set_id                                  gds_migration_set_id
        ,gds.person_id                                         gds_person_id
        ,gds.assignment_id                                     gds_assignment_id
        ,gds.assignment_number                                 gds_assignment_number --AssignmentNumber
        ,nvl(gds.newgradestep,gds.gradestepname)               gds_gradestepname   --GradeStepName
        ,gds.gradestepid                                       gds_gradestepid
        ,gds.gradeid                                           gds_gradeid
        ,TO_CHAR(gds.effective_start_date,'RRRR/MM/DD')        gds_effective_start_date-- EffectiveStartDate
        ,TO_CHAR(gds.effective_end_date,'RRRR/MM/DD')          gds_effective_end_date -- EffectiveEndDate
        ,gds.migration_status                                  gds_migration_status -- ActionCode - Leave blank if value does not exist
        ,gds.bg_name                                           gds_bg_name
    FROM   xxmx_asg_gradestep_xfm gds
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_ASSIGN_GRADE_STEP_V" TO "XXMX_READONLY";
