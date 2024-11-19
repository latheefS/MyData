     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_hcm_current_asg_scope_mv.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Pallavi Kanajar
     **
     ** PURPOSE   :  This script include scope view for HCM Objects
     **
     ** NOTES     :
     **
     ******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **
     ** If this script is to be executed as part of an installation script, ensure
     ** that the installation script performs the following tasks prior to calling
     ** this script.
     **
     ** Task  Description
     ** ----  ---------------------------------------------------------------------
     ** 1.    Run the installation script to create all necessary database objects
     **       and Concurrent definitions:
     **
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_xfm_dbi.sql
     **
     ** If this script is not to be executed as part of an installation script,
     ** ensure that the tasks above are, or have been, performed prior to executing
     ** this script.
     ******************************************************************************
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxcust_common_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-AUG-2022  Pallavi Kanajar     Created for Maximise.
     **
     **
     ******************************************************************************
     */
DECLARE
   PROCEDURE DropView (pView IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || pView ;
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -12003 THEN
         RAISE;
      END IF;
   END DropVIew ;
BEGIN
    DropView ('XXMX_HCM_CURRENT_ASG_SCOPE_MV') ;
END;
/

  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_HCM_CURRENT_ASG_SCOPE_MV" ("ASSIGNMENT_ID", "EFFECTIVE_START_DATE", "EFFECTIVE_END_DATE", "BUSINESS_GROUP_ID", "RECRUITER_ID", "GRADE_ID", "POSITION_ID", "JOB_ID", "ASSIGNMENT_STATUS_TYPE_ID", "PAYROLL_ID", "LOCATION_ID", "PERSON_REFERRED_BY_ID", "SUPERVISOR_ID", "SPECIAL_CEILING_STEP_ID", "PERSON_ID", "RECRUITMENT_ACTIVITY_ID", "SOURCE_ORGANIZATION_ID", "ORGANIZATION_ID", "PEOPLE_GROUP_ID", "SOFT_CODING_KEYFLEX_ID", "VACANCY_ID", "PAY_BASIS_ID", "ASSIGNMENT_SEQUENCE", "ASSIGNMENT_TYPE", "PRIMARY_FLAG", "APPLICATION_ID", "ASSIGNMENT_NUMBER", "CHANGE_REASON", "COMMENT_ID", "DATE_PROBATION_END", "DEFAULT_CODE_COMB_ID", "EMPLOYMENT_CATEGORY", "FREQUENCY", "INTERNAL_ADDRESS_LINE", "MANAGER_FLAG", "NORMAL_HOURS", "PERF_REVIEW_PERIOD", "PERF_REVIEW_PERIOD_FREQUENCY", "PERIOD_OF_SERVICE_ID", "PROBATION_PERIOD", "PROBATION_UNIT", "SAL_REVIEW_PERIOD", "SAL_REVIEW_PERIOD_FREQUENCY", "SET_OF_BOOKS_ID", "SOURCE_TYPE", "TIME_NORMAL_FINISH", "TIME_NORMAL_START", "REQUEST_ID", "PROGRAM_APPLICATION_ID", "PROGRAM_ID", "PROGRAM_UPDATE_DATE", "ASS_ATTRIBUTE_CATEGORY", "ASS_ATTRIBUTE1", "ASS_ATTRIBUTE2", "ASS_ATTRIBUTE3", "ASS_ATTRIBUTE4", "ASS_ATTRIBUTE5", "ASS_ATTRIBUTE6", "ASS_ATTRIBUTE7", "ASS_ATTRIBUTE8", "ASS_ATTRIBUTE9", "ASS_ATTRIBUTE10", "ASS_ATTRIBUTE11", "ASS_ATTRIBUTE12", "ASS_ATTRIBUTE13", "ASS_ATTRIBUTE14", "ASS_ATTRIBUTE15", "ASS_ATTRIBUTE16", "ASS_ATTRIBUTE17", "ASS_ATTRIBUTE18", "ASS_ATTRIBUTE19", "ASS_ATTRIBUTE20", "ASS_ATTRIBUTE21", "ASS_ATTRIBUTE22", "ASS_ATTRIBUTE23", "ASS_ATTRIBUTE24", "ASS_ATTRIBUTE25", "ASS_ATTRIBUTE26", "ASS_ATTRIBUTE27", "ASS_ATTRIBUTE28", "ASS_ATTRIBUTE29", "ASS_ATTRIBUTE30", "LAST_UPDATE_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_LOGIN", "CREATED_BY", "CREATION_DATE", "TITLE", "OBJECT_VERSION_NUMBER", "BARGAINING_UNIT_CODE", "LABOUR_UNION_MEMBER_FLAG", "HOURLY_SALARIED_CODE", "CONTRACT_ID", "COLLECTIVE_AGREEMENT_ID", "CAGR_ID_FLEX_NUM", "CAGR_GRADE_DEF_ID", "ESTABLISHMENT_ID", "NOTICE_PERIOD", "NOTICE_PERIOD_UOM", "EMPLOYEE_CATEGORY", "WORK_AT_HOME", "JOB_POST_SOURCE_NAME", "APPLICANT_RANK", "POSTING_CONTENT_ID", "PERIOD_OF_PLACEMENT_DATE_START", "VENDOR_ID", "VENDOR_EMPLOYEE_NUMBER", "VENDOR_ASSIGNMENT_NUMBER", "ASSIGNMENT_CATEGORY", "PROJECT_TITLE", "GRADE_LADDER_PGM_ID", "SUPERVISOR_ASSIGNMENT_ID", "VENDOR_SITE_ID", "PO_HEADER_ID", "PO_LINE_ID", "PROJECTED_ASSIGNMENT_END", "EMPLOYEE_NUMBER", "EXPENSE_CHECK_SEND_TO_ADDRESS", "NPW_NUMBER", "PERSON_TYPE_ID", "SYSTEM_PERSON_TYPE", "USER_PERSON_TYPE", "LAST_NAME", "FIRST_NAME", "INTERNAL_LOCATION", "PROJECTED_START_DATE", "CURRENT_EMPLOYEE_FLAG", "DATE_START", "FINAL_PROCESS_DATE", "PPOS_ID", "PAY_SYSTEM_STATUS", "PER_SYSTEM_STATUS")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING TRUSTED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS 
  SELECT * FROM (
   SELECT
        per_all_assignments_f.*,
        nvl(person.employee_number,person.npw_number) employee_number,
        person.expense_check_send_to_address,
        person.npw_number,
        person.person_type_id,
        person.system_person_type,
        person.user_person_type,
        person.last_name,
        person.first_name,
        person.internal_location,
        person.projected_start_date,
		  person.current_employee_flag,
        per_periods_of_service.date_start,
        per_periods_of_service.final_process_date,
        per_periods_of_service.period_of_service_id ppos_id,
        per_assignment_status_types.pay_system_status,
        per_assignment_status_types.per_system_status
    FROM
        per_all_assignments_f@MXDM_NVIS_EXTRACT  	per_all_assignments_f,
        per_periods_of_service@MXDM_NVIS_EXTRACT 	per_periods_of_service,
        xxmx_per_persons_stg                	 	personstg,
        xxmx_hcm_person_scope_mv          			person,
        per_assignment_status_types@MXDM_NVIS_EXTRACT	per_assignment_status_types,
		(SELECT DISTINCT
                            haou.organization_id bg_id,
                            haou.name bg_name
                     FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT      haou
                           ,apps.hr_organization_information@MXDM_NVIS_EXTRACT    hoi
                     WHERE   1 = 1
                     AND     hoi.organization_id   = haou.organization_id
                     AND     hoi.org_information1  = 'HR_BG'
                     AND     haou.name IN( Select parameter_value 
                                           from xxmx_migration_parameters 
                                           where application = 'HR' 
                                           and parameter_code = 'BUSINESS_GROUP_NAME'
                                           and enabled_flag = 'Y')
                                          ) bg
    WHERE per_all_assignments_f.assignment_type = 'E'  
    AND ( per_periods_of_service.actual_termination_date IS NULL
             OR per_periods_of_service.actual_termination_date > (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_FROM'
															and enabled_flag = 'Y'))  
    --AND per_all_assignments_f.primary_flag = 'Y'
    AND per_periods_of_service.person_id = per_all_assignments_f.person_id
    AND per_periods_of_service.period_of_service_id = nvl(per_all_assignments_f.period_of_service_id, per_periods_of_service.period_of_service_id)
    AND personstg.person_id = per_all_assignments_f.person_id
    AND personstg.person_id = person.person_id
    AND per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
	 AND per_all_assignments_f.effective_start_date >= (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_FROM'
															and enabled_flag = 'Y')
    AND per_all_assignments_f.effective_end_date  <= (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_TO'
															and enabled_flag = 'Y')
    AND per_all_assignments_f.business_group_id   = bg.bg_id
UNION ALL
   SELECT
        per_all_assignments_f.*,
        nvl(person.employee_number,person.npw_number) employee_number,
        person.expense_check_send_to_address,
        person.npw_number,
        person.person_type_id,
        person.system_person_type,
        person.user_person_type,
        person.last_name,
        person.first_name,
        person.internal_location,
        person.projected_start_date,
		  person.current_employee_flag,
        per_periods_of_placement.date_start,
        per_periods_of_placement.final_process_date,
        per_periods_of_placement.period_of_placement_id,
        per_assignment_status_types.pay_system_status,
        per_assignment_status_types.per_system_status
    FROM
        per_all_assignments_f@MXDM_NVIS_EXTRACT     per_all_assignments_f,
        per_periods_of_placement@MXDM_NVIS_EXTRACT  per_periods_of_placement,
        xxmx_per_persons_stg                		personstg,
        xxmx_hcm_person_scope_mv          			person,
        per_assignment_status_types@MXDM_NVIS_EXTRACT 	per_assignment_status_types,
		(SELECT DISTINCT
                            haou.organization_id bg_id,
                            haou.name bg_name
                     FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                           ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
                     WHERE   1 = 1
                     AND     hoi.organization_id   = haou.organization_id
                     AND     hoi.org_information1  = 'HR_BG'
                     AND     haou.name IN( Select parameter_value 
                                           from xxmx_migration_parameters 
                                           where application = 'HR' 
                                           and parameter_code = 'BUSINESS_GROUP_NAME'
                                           and enabled_flag = 'Y')
                                          ) bg
    WHERE
        per_all_assignments_f.assignment_type = 'C'
    AND ( per_periods_of_placement.actual_termination_date IS NULL
          OR per_periods_of_placement.actual_termination_date > (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_FROM'
															and enabled_flag = 'Y'))  
    --AND per_all_assignments_f.primary_flag = 'Y'          
    AND personstg.person_id = per_all_assignments_f.person_id
    AND personstg.person_id = person.person_id
    AND per_periods_of_placement.person_id = per_all_assignments_f.person_id
	 AND per_all_assignments_f.effective_start_date >= (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_FROM'
															and enabled_flag = 'Y')
    AND per_all_assignments_f.effective_end_date  <= (Select TO_DATE(parameter_value,'RRRR-MM-DD')
															from xxmx_migration_parameters 
															where application = 'HR' 
															and parameter_code ='MIGRATE_DATE_TO'
															and enabled_flag = 'Y')
	 AND per_all_assignments_f.business_group_id  = bg.bg_id
);
   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_HCM_CURRENT_ASG_SCOPE_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_HCM_CURRENT_ASG_SCOPE_MV';

