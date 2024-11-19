--------------------------------------------------------
--  DDL for View XXMX_HR_HCM_WORK_ASSIGN_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HR_HCM_WORK_ASSIGN_V" ("ASG_PERSON_ID", "PPS_START_DATE", "ASG_ASSIGNMENT_ID", "ASG_EFFECTIVE_START_DATE", "ASG_EFFECTIVE_END_DATE", "ASG_PERIOD_OF_SERVICE_ID", "ASG_ASSIGNMENT_TYPE", "ASG_ASSIGNMENT_NUMBER", "ASG_ASSIGNMENT_SEQUENCE", "ASG_PRIMARY_FLAG", "ASG_ORGANIZATION_ID", "ASG_JOB_ID", "ASG_LOCATION_ID", "ASG_POSITION_ID", "ASG_GRADE_ID", "ASG_GRADE_LADDER_PGM_ID", "ASG_WORKERCATEGORY", "ASG_PEOPLE_GROUP_ID", "ASG_COLLECTIVE_AGREEMENT_ID", "ASG_BARGAINING_UNIT_CODE", "ASG_LABOUR_UNION_MEMBER_FLAG", "ASG_CAGR_GRADE_DEF_ID", "ASG_CAGR_ID_FLEX_NUM", "ASG_CONTRACT_ID", "ASG_MANAGER_FLAG", "ASG_DATE_PROBATION_END", "ASG_PROBATION_PERIOD", "ASG_PROBATION_UNIT", "ASG_NORMAL_HOURS", "ASG_FREQUENCY", "ASG_WORK_AT_HOME", "ASG_TIME_NORMAL_FINISH", "ASG_TIME_NORMAL_START", "ASG_NOTICE_PERIOD", "ASG_NOTICE_PERIOD_UOM", "ASG_DEFAULT_CODE_COMB_ID", "ASG_EMPLOYEE_CATEGORY", "ASG_EMPLOYMENT_CATEGORY", "ASG_ESTABLISHMENT_ID", "ASG_HOURLY_SALARIED_CODE", "ASG_SAL_REVIEW_PERIOD", "ASG_SAL_REVIEW_PERIOD_FREQUENCY", "ASG_JOB_POST_SOURCE_NAME", "ASG_PROJECT_TITLE", "ASG_PERSON_REFERRED_BY_ID", "ASG_PO_HEADER_ID", "ASG_PO_LINE_ID", "ASG_RECRUITER_ID", "ASG_RECRUITMENT_ACTIVITY_ID", "ASG_VACANCY_ID", "ASG_APPLICANT_RANK", "ASG_POSTING_CONTENT_ID", "ASG_SOURCE_ORGANIZATION_ID", "ASG_SOURCE_TYPE", "ASG_PROJECTED_ASSIGNMENT_END", "ASG_SET_OF_BOOKS_ID", "ASG_SOFT_CODING_KEYFLEX_ID", "ASG_SPECIAL_CEILING_STEP_ID", "ASG_VENDOR_ASSIGNMENT_NUMBER", "ASG_VENDOR_EMPLOYEE_NUMBER", "ASG_VENDOR_ID", "ASG_VENDOR_SITE_ID", "ASG_WORK_TERMS_ASSIGNMENT_ID", "ASG_ACTION_CODE", "ASG_ASSIGNMENT_NAME", "ASG_ASSIGNMENT_STATUS_TYPE", "ASG_AUTO_END_FLAG", "ASG_DUTIES_TYPE", "ASG_EFFECTIVE_SEQUENCE", "ASG_EXPENSE_CHECK_ADDRESS", "ASG_INTERNAL_BUILDING", "ASG_INTERNAL_FLOOR", "ASG_INTERNAL_LOCATION", "ASG_INTERNAL_MAILSTOP", "ASG_INTERNAL_OFFICE_NUMBER", "ASG_LEGAL_EMPLOYER_NAME", "ASG_LINKAGE_TYPE", "ASG_PARENT_ASSIGNMENT_ID", "ASG_PERSON_TYPE_ID", "ASG_PRIMARY_WORK_TERMS_FLAG", "ASG_PRIMARY_ASSIGNMENT_FLAG", "ASG_PRIMARY_WORK_RELATION_FLAG", "ASG_PROJECTED_START_DATE", "ASG_REASON_CODE", "ASG_SYSTEM_PERSON_TYPE", "ASG_BUSINESS_UNIT_NAME", "ASG_BILLING_TITLE", "ASG_STEP_ENTRY_DATE", "ASG_TAX_ADDRESS_ID", "ASG_ACTION_OCCURRENCE_ID", "ASG_PROPOSED_WORKER_TYPE", "ASG_RETIREMENT_AGE", "ASG_RETIREMENT_DATE", "ASG_POSITION_OVERRIDE_FLAG", "ASG_EFFECTIVE_LATEST_CHANGE", "ASG_ALLOW_ASG_OVERRIDE_FLAG", "ASG_FREEZE_START_DATE", "ASG_FREEZE_UNTIL_DATE", "ASG_ID_FLEX_NUM", "ASG_GRADE_CODE", "ASG_GRADE_LADDER_PGM_NAME", "ASG_JOB_CODE", "ASG_POSITION_CODE", "ASG_LOCATION_CODE", "ASG_SPEC_CEILING_STEP", "ASG_PEOPLE_GROUP_NAME", "ASG_COLLECT_AGREE_NAME", "ASG_USER_PERSON_TYPE", "ASG_ASSIGNMENT_STATUS_TYPE_ID", "ASG_BG_ID", "ASG_MIN_EFF_START_DATE", "ASS_ATTRIBUTE1", "ASS_ATTRIBUTE2", "ASS_ATTRIBUTE3", "ASS_ATTRIBUTE4", "ASS_ATTRIBUTE5", "ASS_ATTRIBUTE6", "ASS_ATTRIBUTE7", "ASS_ATTRIBUTE8", "ASS_ATTRIBUTE9", "ASS_ATTRIBUTE10", "ASS_ATTRIBUTE11", "ASS_ATTRIBUTE12", "ASS_ATTRIBUTE13", "ASS_ATTRIBUTE14", "ASS_ATTRIBUTE15", "ASS_ATTRIBUTE16", "ASS_ATTRIBUTE17", "ASS_ATTRIBUTE18", "ASS_ATTRIBUTE19", "ASS_ATTRIBUTE20", "ASS_ATTRIBUTE21", "ASS_ATTRIBUTE_DATE1", "ASS_ATTRIBUTE_DATE2", "ASS_ATTRIBUTE_DATE3", "ASS_ATTRIBUTE_NUMBER1", "ASS_ATTRIBUTE_NUMBER2", "ASS_ATTRIBUTE_NUMBER3", "ASS_ATTRIBUTE_NUMBER4", "ASS_ATTRIBUTE_NUMBER5", "DEFAULT_EXPENSE_ACCOUNT") AS 
  SELECT  DISTINCT
         asg.person_id                                      asg_person_id
        ,TO_CHAR(pps.start_date,'RRRR/MM/DD')               pps_start_date
        ,asg.assignment_id                                  asg_assignment_id
        ,TO_CHAR(asg.effective_start_date,'RRRR/MM/DD')     asg_effective_start_date
        ,TO_CHAR(asg.effective_end_date,'RRRR/MM/DD')       asg_effective_end_date
        ,asg.period_of_service_id                           asg_period_of_service_id
        ,asg.assignment_type                                asg_assignment_type
        ,asg.assignment_number                              asg_assignment_number
        ,asg.assignment_sequence                            asg_assignment_sequence
        ,asg.primary_flag                                   asg_primary_flag
        ,asg.organization_id                                asg_organization_id
        ,asg.job_id                                         asg_job_id
        ,asg.location_id                                    asg_location_id
        ,asg.position_id                                    asg_position_id
        ,asg.grade_id                                       asg_grade_id
        ,asg.grade_ladder_pgm_id                            asg_grade_ladder_pgm_id
        ,asg.workercategory                                 asg_workercategory
        ,asg.people_group_id                                asg_people_group_id
        ,asg.collective_agreement_id                        asg_collective_agreement_id
        ,asg.bargaining_unit_code                           asg_bargaining_unit_code
        ,asg.labour_union_member_flag                       asg_labour_union_member_flag
        ,asg.cagr_grade_def_id                              asg_cagr_grade_def_id
        ,asg.cagr_id_flex_num                               asg_cagr_id_flex_num
        ,asg.contract_id                                    asg_contract_id
        ,asg.manager_flag                                   asg_manager_flag
        ,TO_CHAR(asg.date_probation_end,'RRRR/MM/DD')       asg_date_probation_end
        ,asg.probation_period                               asg_probation_period
        ,asg.probation_unit                                 asg_probation_unit
        ,asg.normal_hours                                   asg_normal_hours
        ,asg.frequency                                      asg_frequency
        ,asg.work_at_home                                   asg_work_at_home
        ,asg.time_normal_finish                             asg_time_normal_finish
        ,asg.time_normal_start                              asg_time_normal_start
        ,asg.notice_period                                  asg_notice_period
        ,asg.notice_period_uom                              asg_notice_period_uom
        ,asg.default_code_comb_id                           asg_default_code_comb_id
        ,asg.employee_category                              asg_employee_category
        ,asg.employment_category                            asg_employment_category
        ,asg.establishment_id                               asg_establishment_id
        ,asg.hourly_salaried_code                           asg_hourly_salaried_code
        ,asg.sal_review_period                              asg_sal_review_period
        ,asg.sal_review_period_frequency                    asg_sal_review_period_frequency
        ,asg.job_post_source_name                           asg_job_post_source_name
        ,asg.project_title                                  asg_project_title
        ,asg.person_referred_by_id                          asg_person_referred_by_id
        ,asg.po_header_id                                   asg_po_header_id
        ,asg.po_line_id                                     asg_po_line_id
        ,asg.recruiter_id                                   asg_recruiter_id
        ,asg.recruitment_activity_id                        asg_recruitment_activity_id
        ,asg.vacancy_id                                     asg_vacancy_id
        ,asg.applicant_rank                                 asg_applicant_rank
        ,asg.posting_content_id                             asg_posting_content_id
        ,asg.source_organization_id                         asg_source_organization_id
        ,asg.source_type                                    asg_source_type
        ,asg.projected_assignment_end                       asg_projected_assignment_end
        ,asg.set_of_books_id                                asg_set_of_books_id
        ,asg.soft_coding_keyflex_id                         asg_soft_coding_keyflex_id
        ,asg.special_ceiling_step_id                        asg_special_ceiling_step_id
        ,asg.vendor_assignment_number                       asg_vendor_assignment_number
        ,asg.vendor_employee_number                         asg_vendor_employee_number
        ,asg.vendor_id                                      asg_vendor_id
        ,asg.vendor_site_id                                 asg_vendor_site_id
        ,asg.work_terms_assignment_id                       asg_work_terms_assignment_id
        ,asg.action_code                                    asg_action_code
        ,asg.assignment_name                                asg_assignment_name
        ,asg.assignment_status_type                         asg_assignment_status_type
        ,asg.auto_end_flag                                  asg_auto_end_flag
        ,asg.duties_type                                    asg_duties_type
        ,asg.effective_sequence                             asg_effective_sequence
        ,asg.expense_check_address                          asg_expense_check_address
        ,asg.internal_building                              asg_internal_building
        ,asg.internal_floor                                 asg_internal_floor
        ,asg.internal_location                              asg_internal_location
        ,asg.internal_mailstop                              asg_internal_mailstop
        ,asg.internal_office_number                         asg_internal_office_number
        ,asg.legal_employer_name                            asg_legal_employer_name
        ,asg.linkage_type                                   asg_linkage_type
        ,asg.parent_assignment_id                           asg_parent_assignment_id
        ,asg.person_type_id                                 asg_person_type_id
        ,asg.primary_work_terms_flag                        asg_primary_work_terms_flag
        ,asg.primary_assignment_flag                        asg_primary_assignment_flag
        ,asg.primary_work_relation_flag                     asg_primary_work_relation_flag
        ,asg.projected_start_date                           asg_projected_start_date
        ,asg.reason_code                                    asg_reason_code
        ,asg.system_person_type                             asg_system_person_type
        ,asg.business_unit_name                             asg_business_unit_name
        ,asg.billing_title                                  asg_billing_title
        ,TO_CHAR(asg.step_entry_date,'RRRR/MM/DD')          asg_step_entry_date
        ,asg.tax_address_id                                 asg_tax_address_id
        ,asg.action_occurrence_id                           asg_action_occurrence_id
        ,asg.proposed_worker_type                           asg_proposed_worker_type
        ,asg.retirement_age                                 asg_retirement_age
        ,TO_CHAR(asg.retirement_date,'RRRR/MM/DD')          asg_retirement_date
        ,asg.position_override_flag                         asg_position_override_flag
        ,asg.effective_latest_change                        asg_effective_latest_change
        ,asg.allow_asg_override_flag                        asg_allow_asg_override_flag
        ,TO_CHAR(asg.freeze_start_date,'RRRR/MM/DD')        asg_freeze_start_date
        ,TO_CHAR(asg.freeze_until_date,'RRRR/MM/DD')        asg_freeze_until_date
        ,asg.id_flex_num                                    asg_id_flex_num
        ,asg.grade_code                                     asg_grade_code
        ,asg.grade_ladder_pgm_name                          asg_grade_ladder_pgm_name
        ,asg.job_code                                       asg_job_code
        ,asg.position_code                                  asg_position_code
        ,asg.location_code                                  asg_location_code
        ,asg.spec_ceiling_step                              asg_spec_ceiling_step
        ,asg.people_group_name                              asg_people_group_name
        ,asg.collect_agree_name                             asg_collect_agree_name
        ,asg.user_person_type                               asg_user_person_type
        ,asg.assignment_status_type_id                      asg_assignment_status_type_id
        ,asg.bg_id                                          asg_bg_id
        ,TO_CHAR(asg.min_eff_start_date,'RRRR/MM/DD')       asg_min_eff_start_date
        ,asg.ASS_ATTRIBUTE1
        ,asg.ASS_ATTRIBUTE2
        ,asg.ASS_ATTRIBUTE3
        ,asg.ASS_ATTRIBUTE4
        ,asg.ASS_ATTRIBUTE5
        ,asg.ASS_ATTRIBUTE6
        ,asg.ASS_ATTRIBUTE7
        ,asg.ASS_ATTRIBUTE8
        ,asg.ASS_ATTRIBUTE9
        ,asg.ASS_ATTRIBUTE10
        ,asg.ASS_ATTRIBUTE11
        ,asg.ASS_ATTRIBUTE12
        ,asg.ASS_ATTRIBUTE13
        ,asg.ASS_ATTRIBUTE14
        ,asg.ASS_ATTRIBUTE15
        ,asg.ASS_ATTRIBUTE16
        ,asg.ASS_ATTRIBUTE17
        ,asg.ASS_ATTRIBUTE18
        ,asg.ASS_ATTRIBUTE19
        ,asg.ASS_ATTRIBUTE20
        ,asg.ASS_ATTRIBUTE21
        ,asg.ASS_ATTRIBUTE_DATE1
        ,asg.ASS_ATTRIBUTE_DATE2
        ,asg.ASS_ATTRIBUTE_DATE3
        ,asg.ASS_ATTRIBUTE_NUMBER1
        ,asg.ASS_ATTRIBUTE_NUMBER2
        ,asg.ASS_ATTRIBUTE_NUMBER3
        ,asg.ASS_ATTRIBUTE_NUMBER4
        ,asg.ASS_ATTRIBUTE_NUMBER5
        ,asg.default_expense_account
       FROM  xxmx_per_assignments_m_xfm asg,
        xxmx_per_people_f_xfm      pps
       WHERE asg.person_id = pps.person_id
 ORDER BY asg_person_id, asg_effective_start_date, asg_assignment_sequence
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_HR_HCM_WORK_ASSIGN_V" TO "XXMX_READONLY";
