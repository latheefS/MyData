--
--
PROMPT
PROMPT
PROMPT *****************
PROMPT ** Creating Views
PROMPT *****************
--
--
PROMPT
PROMPT Creating View XXMX_HCM_LOAD_VIEWS
PROMPT
--
--------------------------------------------------------
--  DDL for View xxmx_supplier_scope_v
--------------------------------------------------------
--
   
 
  CREATE OR REPLACE  VIEW "XXMX_HR_HCM_WORK_ASSIGN_V" AS
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
 ORDER BY asg_person_id, asg_effective_start_date, asg_assignment_sequence;
   

  CREATE OR REPLACE  VIEW "XXMX_HR_HCM_WORK_REL_V"  AS 
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
  ORDER BY wrs_person_id, wrs_date_start;

 
  
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_HR_HCM_ASSIGN_GRADE_STEP_V" ("GDS_MIGRATION_SET_ID", "GDS_PERSON_ID", "GDS_ASSIGNMENT_ID", "GDS_ASSIGNMENT_NUMBER", "GDS_GRADESTEPNAME", "GDS_GRADESTEPID", "GDS_GRADEID", "GDS_EFFECTIVE_START_DATE", "GDS_EFFECTIVE_END_DATE", "GDS_MIGRATION_STATUS", "GDS_BG_NAME") AS 
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
    FROM   xxmx_asg_gradestep_xfm gds;

    
  
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_HR_HCM_ASSIGN_WORK_MEAS_V" ("WM_MIGRATION_SET_ID", "WM_PERSON_ID", "WM_EFFECTIVE_START_DATE", "WM_EFFECTIVE_END_DATE", "WM_UNIT", "WM_VALUE", "WM_ASSIGNMENT_ID", "WM_ASSIGNMENT_NUMBER", "WM_LEGISLATION_CODE", "WM_BG_NAME") AS 
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
  ORDER BY wm.person_id, wm.unit;

  
    
  CREATE OR REPLACE  VIEW "XXMX_HR_HCM_PERSON_V" AS 
  SELECT  DISTINCT 
         pp.migration_set_id                                migration_set_id
        ,pp.person_id                                       person_id
        ,TO_CHAR(pps.effective_start_date,'RRRR/MM/DD')     effective_start_date
        ,TO_CHAR(pps.effective_end_date,'RRRR/MM/DD')       effective_end_date
        ,pps.personnumber                                  pps_person_number
        ,TO_CHAR(PPS.start_date,'RRRR/MM/DD')               pps_start_date
        ,TO_CHAR(trunc(PP.date_of_birth),'RRRR/MM/DD')      dob
        ,pns.person_name_id                                 pns_person_name_id
        ,pns.legislation_code                               pns_legislation_code
        ,pns.name_type                                      pns_name_type
        ,RTRIM(pns.first_name)                              pns_first_name
        ,RTRIM(pns.middle_names)                            pns_middle_names
        ,RTRIM(pns.last_name)                               pns_last_name
        ,pns.honors                                         pns_honors
        ,pns.known_as                                       pns_known_as
        ,pns.pre_name_adjunct                               pns_pre_name_adjunct
        ,pns.military_rank                                  pns_military_rank
        ,RTRIM(pns.previous_last_name)                      pns_previous_last_name
        ,pns.suffix                                         pns_suffix
        ,INITCAP(pns.title)                                 pns_title
        ,paf.address_type                                   paf_address_type
        ,RTRIM(paf.address_line_1)                          paf_address_line_1
        ,RTRIM(paf.address_line_2)                          paf_address_line_2
        ,RTRIM(paf.address_line_3)                          paf_address_line_3
        ,RTRIM(paf.address_line_4)                          paf_address_line_4
        ,RTRIM(paf.town_or_city)                            paf_town_or_city
        ,paf.region_1                                       paf_region_1
        ,paf.region_2                                       paf_region_2
        ,paf.country_code                                   paf_country_code
        ,paf.postal_code                                    paf_postal_code
        ,paf.long_postal_code                               paf_long_postal_code
        ,paf.primary_flag                                   paf_primary_flag
        ,paf.address_style                                  paf_address_style
        ,paf.address_id                                     paf_address_id
        ,pemail.email_address_id                            pemail_email_address_id
        ,TO_CHAR(pemail.date_from,'RRRR/MM/DD')             pemail_date_from
        ,TO_CHAR(pemail.date_to,'RRRR/MM/DD')               pemail_date_to
        ,pemail.email_type                                  pemail_email_type
        ,pemail.email_address                               pemail_email_address
        ,pemail.primary_flag                                pemail_primary_flag  
        ,TO_CHAR(phone.date_from,'RRRR/MM/DD')              phone_date_from
        ,TO_CHAR(phone.date_to,'RRRR/MM/DD')                phone_date_to
        ,phone.phone_type                                   phone_phone_type
        ,phone.phone_number                                 phone_phone_number
        ,phone.legislation_code                             phone_legislation_code
        ,phone.primary_flag                                 phone_primary_flag
        ,phone.phone_id                                     phone_phone_id
        ,phone.validity                                     phone_validity
        ,pe.legislation_code                                pe_legislation_code
        ,pe.ethnicity                                       pe_ethnicity
        ,pe.primary_flag                                    pe_primary_flag
        ,pe.ethnicity_id                                    pe_ethnicity_id
        ,nid.national_identifier_id                         nid_national_identifier_id
        ,nid.legislation_code                               nid_legislation_code
        ,nid.national_identifier_type                       nid_national_identifier_type
        ,nid.national_identifier_number                     nid_national_identifier_number
        ,nid.primary_flag                                   nid_primary_flag
        ,TO_CHAR(nid.issue_date,'RRRR/MM/DD')               nid_issue_date
        ,TO_CHAR(nid.expiration_date,'RRRR/MM/DD')          nid_expiration_date        
        ,pass.legislationcode                               pass_legislationcode
        ,pass.passportnumber                                pass_passportnumber
        ,substr(pass.issuedate,1,10)                        pass_issue_date
        ,substr(pass.expirationdate,1,10)                   pass_expiration_date
        ,pass.issuingcountry                                pass_issuing_country
        ,cit.citizenship_id                                 cit_citizenship_id
        ,TO_CHAR(cit.date_from,'RRRR/MM/DD')                cit_date_from
        ,TO_CHAR(cit.date_to,'RRRR/MM/DD')                  cit_date_to
        ,cit.legislation_code                               cit_legislation_code
        ,cit.citizenship_status                             cit_citizenship_status 
        ,pld.person_legislative_id                          pld_person_legislative_id
        ,pld.legislation_code                               pld_legislation_code               
        ,pld.highest_education_level                        pld_highest_education_level 
        ,pld.sex                                            pld_sex
        ,pld.marital_status                                 pld_marital_status
        ,TO_CHAR(pld.marital_status_date,'RRRR/MM/DD')      pld_marital_status_date
        ,pp.BG_name                                         bg_name
        ,pp.bg_id                                           bg_id
          ,rel.RELIGION                                       religion
        ,rel.primary_flag                                   rel_primary_flag
		,pps.ATTRIBUTE1 									pps_ATTRIBUTE1 
		,pps.ATTRIBUTE2                                     pps_ATTRIBUTE2 
		,pps.ATTRIBUTE3                                     pps_ATTRIBUTE3 
		,pps.ATTRIBUTE4                                     pps_ATTRIBUTE4 
		,pps.ATTRIBUTE5                                     pps_ATTRIBUTE5 
		,pps.ATTRIBUTE6                                     pps_ATTRIBUTE6 
		,pps.ATTRIBUTE7                                     pps_ATTRIBUTE7 
		,pps.ATTRIBUTE8                                     pps_ATTRIBUTE8 
		,pps.ATTRIBUTE9                                     pps_ATTRIBUTE9 
		,pps.ATTRIBUTE10                                    pps_ATTRIBUTE10
		,pps.ATTRIBUTE11                                    pps_ATTRIBUTE11
		,pps.ATTRIBUTE12                                    pps_ATTRIBUTE12
		,pps.ATTRIBUTE13                                    pps_ATTRIBUTE13
		,pps.ATTRIBUTE14                                    pps_ATTRIBUTE14
		,pps.ATTRIBUTE15                                    pps_ATTRIBUTE15
		,pps.ATTRIBUTE_NUMBER1 								pps_ATTRIBUTE_NUMBER1 
		,pps.ATTRIBUTE_NUMBER2                              pps_ATTRIBUTE_NUMBER2 
		,pps.ATTRIBUTE_NUMBER3                              pps_ATTRIBUTE_NUMBER3 
		,pps.ATTRIBUTE_NUMBER4                              pps_ATTRIBUTE_NUMBER4 
		,pps.ATTRIBUTE_NUMBER5                              pps_ATTRIBUTE_NUMBER5 
		,pps.ATTRIBUTE_NUMBER6                              pps_ATTRIBUTE_NUMBER6 
		,pps.ATTRIBUTE_NUMBER7                              pps_ATTRIBUTE_NUMBER7 
		,pps.ATTRIBUTE_NUMBER8                              pps_ATTRIBUTE_NUMBER8 
		,pps.ATTRIBUTE_NUMBER9                              pps_ATTRIBUTE_NUMBER9 
		,pps.ATTRIBUTE_NUMBER10                             pps_ATTRIBUTE_NUMBER10
		,pps.ATTRIBUTE_NUMBER11                             pps_ATTRIBUTE_NUMBER11
		,pps.ATTRIBUTE_NUMBER12                             pps_ATTRIBUTE_NUMBER12
		,pps.ATTRIBUTE_NUMBER13                             pps_ATTRIBUTE_NUMBER13
		,pps.ATTRIBUTE_NUMBER14                             pps_ATTRIBUTE_NUMBER14
		,pps.ATTRIBUTE_NUMBER15                             pps_ATTRIBUTE_NUMBER15
		,pps.ATTRIBUTE_DATE1 								pps_ATTRIBUTE_DATE1 
		,pps.ATTRIBUTE_DATE2                                pps_ATTRIBUTE_DATE2 
		,pps.ATTRIBUTE_DATE3                                pps_ATTRIBUTE_DATE3 
		,pps.ATTRIBUTE_DATE4                                pps_ATTRIBUTE_DATE4 
		,pps.ATTRIBUTE_DATE5                                pps_ATTRIBUTE_DATE5 
		,pps.ATTRIBUTE_DATE6                                pps_ATTRIBUTE_DATE6 
		,pps.ATTRIBUTE_DATE7                                pps_ATTRIBUTE_DATE7 
		,pps.ATTRIBUTE_DATE8                                pps_ATTRIBUTE_DATE8 
		,pps.ATTRIBUTE_DATE9                                pps_ATTRIBUTE_DATE9 
		,pps.ATTRIBUTE_DATE10                               pps_ATTRIBUTE_DATE10
		,pps.ATTRIBUTE_DATE11                               pps_ATTRIBUTE_DATE11
		,pps.ATTRIBUTE_DATE12                               pps_ATTRIBUTE_DATE12
		,pps.ATTRIBUTE_DATE13                               pps_ATTRIBUTE_DATE13
		,pps.ATTRIBUTE_DATE14                               pps_ATTRIBUTE_DATE14
		,pps.ATTRIBUTE_DATE15                               pps_ATTRIBUTE_DATE15
		,pp.ATTRIBUTE1 									    pp_ATTRIBUTE1 
		,pp.ATTRIBUTE2                                      pp_ATTRIBUTE2 
		,pp.ATTRIBUTE3                                      pp_ATTRIBUTE3 
		,pp.ATTRIBUTE4                                      pp_ATTRIBUTE4 
		,pp.ATTRIBUTE5                                      pp_ATTRIBUTE5 
		,pp.ATTRIBUTE6                                      pp_ATTRIBUTE6 
		,pp.ATTRIBUTE7                                      pp_ATTRIBUTE7 
		,pp.ATTRIBUTE8                                      pp_ATTRIBUTE8 
		,pp.ATTRIBUTE9                                      pp_ATTRIBUTE9 
		,pp.ATTRIBUTE10                                     pp_ATTRIBUTE10
		,pp.ATTRIBUTE11                                     pp_ATTRIBUTE11
		,pp.ATTRIBUTE12                                     pp_ATTRIBUTE12
		,pp.ATTRIBUTE13                                     pp_ATTRIBUTE13
		,pp.ATTRIBUTE14                                     pp_ATTRIBUTE14
		,pp.ATTRIBUTE15                                     pp_ATTRIBUTE15
		,pp.ATTRIBUTE_NUMBER1 							    pp_ATTRIBUTE_NUMBER1 
		,pp.ATTRIBUTE_NUMBER2                               pp_ATTRIBUTE_NUMBER2 
		,pp.ATTRIBUTE_NUMBER3                               pp_ATTRIBUTE_NUMBER3 
		,pp.ATTRIBUTE_NUMBER4                               pp_ATTRIBUTE_NUMBER4 
		,pp.ATTRIBUTE_NUMBER5                               pp_ATTRIBUTE_NUMBER5 
		,pp.ATTRIBUTE_NUMBER6                               pp_ATTRIBUTE_NUMBER6 
		,pp.ATTRIBUTE_NUMBER7                               pp_ATTRIBUTE_NUMBER7 
		,pp.ATTRIBUTE_NUMBER8                               pp_ATTRIBUTE_NUMBER8 
		,pp.ATTRIBUTE_NUMBER9                               pp_ATTRIBUTE_NUMBER9 
		,pp.ATTRIBUTE_NUMBER10                              pp_ATTRIBUTE_NUMBER10
		,pp.ATTRIBUTE_NUMBER11                              pp_ATTRIBUTE_NUMBER11
		,pp.ATTRIBUTE_NUMBER12                              pp_ATTRIBUTE_NUMBER12
		,pp.ATTRIBUTE_NUMBER13                              pp_ATTRIBUTE_NUMBER13
		,pp.ATTRIBUTE_NUMBER14                              pp_ATTRIBUTE_NUMBER14
		,pp.ATTRIBUTE_NUMBER15                              pp_ATTRIBUTE_NUMBER15
		,pp.ATTRIBUTE_DATE1 							    pp_ATTRIBUTE_DATE1 
		,pp.ATTRIBUTE_DATE2                                 pp_ATTRIBUTE_DATE2 
		,pp.ATTRIBUTE_DATE3                                 pp_ATTRIBUTE_DATE3 
		,pp.ATTRIBUTE_DATE4                                 pp_ATTRIBUTE_DATE4 
		,pp.ATTRIBUTE_DATE5                                 pp_ATTRIBUTE_DATE5 
		,pp.ATTRIBUTE_DATE6                                 pp_ATTRIBUTE_DATE6 
		,pp.ATTRIBUTE_DATE7                                 pp_ATTRIBUTE_DATE7 
		,pp.ATTRIBUTE_DATE8                                 pp_ATTRIBUTE_DATE8 
		,pp.ATTRIBUTE_DATE9                                 pp_ATTRIBUTE_DATE9 
		,pp.ATTRIBUTE_DATE10                                pp_ATTRIBUTE_DATE10
		,pp.ATTRIBUTE_DATE11                                pp_ATTRIBUTE_DATE11
		,pp.ATTRIBUTE_DATE12                                pp_ATTRIBUTE_DATE12
		,pp.ATTRIBUTE_DATE13                                pp_ATTRIBUTE_DATE13
		,pp.ATTRIBUTE_DATE14                                pp_ATTRIBUTE_DATE14
		,pp.ATTRIBUTE_DATE15                                pp_ATTRIBUTE_DATE15
		,pns.NAM_INFORMATION1 								pns_NAM_INFORMATION1 
		,pns.NAM_INFORMATION2                               pns_NAM_INFORMATION2 
		,pns.NAM_INFORMATION3                               pns_NAM_INFORMATION3 
		,pns.NAM_INFORMATION4                               pns_NAM_INFORMATION4 
		,pns.NAM_INFORMATION5                               pns_NAM_INFORMATION5 
		,pns.NAM_INFORMATION6                               pns_NAM_INFORMATION6 
		,pns.NAM_INFORMATION7                               pns_NAM_INFORMATION7 
		,pns.NAM_INFORMATION8                               pns_NAM_INFORMATION8 
		,pns.NAM_INFORMATION9                               pns_NAM_INFORMATION9 
		,pns.NAM_INFORMATION10                              pns_NAM_INFORMATION10
		,pns.NAM_INFORMATION11                              pns_NAM_INFORMATION11
		,pns.NAM_INFORMATION12                              pns_NAM_INFORMATION12
		,pns.NAM_INFORMATION13                              pns_NAM_INFORMATION13
		,pns.NAM_INFORMATION14                              pns_NAM_INFORMATION14
		,pns.NAM_INFORMATION15                              pns_NAM_INFORMATION15
		,pns.ATTRIBUTE1 									pns_ATTRIBUTE1 
		,pns.ATTRIBUTE2                                     pns_ATTRIBUTE2 
		,pns.ATTRIBUTE3                                     pns_ATTRIBUTE3 
		,pns.ATTRIBUTE4                                     pns_ATTRIBUTE4 
		,pns.ATTRIBUTE5                                     pns_ATTRIBUTE5 
		,pns.ATTRIBUTE6                                     pns_ATTRIBUTE6 
		,pns.ATTRIBUTE7                                     pns_ATTRIBUTE7 
		,pns.ATTRIBUTE8                                     pns_ATTRIBUTE8 
		,pns.ATTRIBUTE9                                     pns_ATTRIBUTE9 
		,pns.ATTRIBUTE10                                    pns_ATTRIBUTE10
		,pns.ATTRIBUTE11                                    pns_ATTRIBUTE11
		,pns.ATTRIBUTE12                                    pns_ATTRIBUTE12
		,pns.ATTRIBUTE13                                    pns_ATTRIBUTE13
		,pns.ATTRIBUTE14                                    pns_ATTRIBUTE14
		,pns.ATTRIBUTE15                                    pns_ATTRIBUTE15
		,pns.NAM_INFORMATION_DATE1 							pns_NAM_INFORMATION_DATE1 
		,pns.NAM_INFORMATION_DATE2                          pns_NAM_INFORMATION_DATE2 
		,pns.NAM_INFORMATION_DATE3                          pns_NAM_INFORMATION_DATE3 
		,pns.NAM_INFORMATION_DATE4                          pns_NAM_INFORMATION_DATE4 
		,pns.NAM_INFORMATION_DATE5                          pns_NAM_INFORMATION_DATE5 
		,pns.NAM_INFORMATION_DATE6                          pns_NAM_INFORMATION_DATE6 
		,pns.NAM_INFORMATION_DATE7                          pns_NAM_INFORMATION_DATE7 
		,pns.NAM_INFORMATION_DATE8                          pns_NAM_INFORMATION_DATE8 
		,pns.NAM_INFORMATION_DATE9                          pns_NAM_INFORMATION_DATE9 
		,pns.NAM_INFORMATION_DATE10                         pns_NAM_INFORMATION_DATE10
		,pns.NAM_INFORMATION_DATE11                         pns_NAM_INFORMATION_DATE11
		,pns.NAM_INFORMATION_DATE12                         pns_NAM_INFORMATION_DATE12
		,pns.NAM_INFORMATION_DATE13                         pns_NAM_INFORMATION_DATE13
		,pns.NAM_INFORMATION_DATE14                         pns_NAM_INFORMATION_DATE14
		,pns.NAM_INFORMATION_DATE15                         pns_NAM_INFORMATION_DATE15
		,pns.ATTRIBUTE_NUMBER1 								pns_ATTRIBUTE_NUMBER1 
		,pns.ATTRIBUTE_NUMBER2                              pns_ATTRIBUTE_NUMBER2 
		,pns.ATTRIBUTE_NUMBER3                              pns_ATTRIBUTE_NUMBER3 
		,pns.ATTRIBUTE_NUMBER4                              pns_ATTRIBUTE_NUMBER4 
		,pns.ATTRIBUTE_NUMBER5                              pns_ATTRIBUTE_NUMBER5 
		,pns.ATTRIBUTE_NUMBER6                              pns_ATTRIBUTE_NUMBER6 
		,pns.ATTRIBUTE_NUMBER7                              pns_ATTRIBUTE_NUMBER7 
		,pns.ATTRIBUTE_NUMBER8                              pns_ATTRIBUTE_NUMBER8 
		,pns.ATTRIBUTE_NUMBER9                              pns_ATTRIBUTE_NUMBER9 
		,pns.ATTRIBUTE_NUMBER10                             pns_ATTRIBUTE_NUMBER10
		,pns.ATTRIBUTE_NUMBER11                             pns_ATTRIBUTE_NUMBER11
		,pns.ATTRIBUTE_NUMBER12                             pns_ATTRIBUTE_NUMBER12
		,pns.ATTRIBUTE_NUMBER13                             pns_ATTRIBUTE_NUMBER13
		,pns.ATTRIBUTE_NUMBER14                             pns_ATTRIBUTE_NUMBER14
		,pns.ATTRIBUTE_NUMBER15                             pns_ATTRIBUTE_NUMBER15
		,pns.ATTRIBUTE_DATE1 								pns_ATTRIBUTE_DATE1 
		,pns.ATTRIBUTE_DATE2                                pns_ATTRIBUTE_DATE2 
		,pns.ATTRIBUTE_DATE3                                pns_ATTRIBUTE_DATE3 
		,pns.ATTRIBUTE_DATE4                                pns_ATTRIBUTE_DATE4 
		,pns.ATTRIBUTE_DATE5                                pns_ATTRIBUTE_DATE5 
		,pns.ATTRIBUTE_DATE6                                pns_ATTRIBUTE_DATE6 
		,pns.ATTRIBUTE_DATE7                                pns_ATTRIBUTE_DATE7 
		,pns.ATTRIBUTE_DATE8                                pns_ATTRIBUTE_DATE8 
		,pns.ATTRIBUTE_DATE9                                pns_ATTRIBUTE_DATE9 
		,pns.ATTRIBUTE_DATE10                               pns_ATTRIBUTE_DATE10
		,pns.ATTRIBUTE_DATE11                               pns_ATTRIBUTE_DATE11
		,pns.ATTRIBUTE_DATE12                               pns_ATTRIBUTE_DATE12
		,pns.ATTRIBUTE_DATE13                               pns_ATTRIBUTE_DATE13
		,pns.ATTRIBUTE_DATE14                               pns_ATTRIBUTE_DATE14
		,pns.ATTRIBUTE_DATE15                               pns_ATTRIBUTE_DATE15
		,paf.ADDL_ADDRESS_ATTRIBUTE1						paf_ADDL_ADDRESS_ATTRIBUTE1
		,paf.ADDL_ADDRESS_ATTRIBUTE2                        paf_ADDL_ADDRESS_ATTRIBUTE2
		,paf.ADDL_ADDRESS_ATTRIBUTE3                        paf_ADDL_ADDRESS_ATTRIBUTE3
		,paf.ADDL_ADDRESS_ATTRIBUTE4                        paf_ADDL_ADDRESS_ATTRIBUTE4
		,paf.ADDL_ADDRESS_ATTRIBUTE5                        paf_ADDL_ADDRESS_ATTRIBUTE5
		,paf.ADDR_ATTRIBUTE1 								paf_ADDR_ATTRIBUTE1 
		,paf.ADDR_ATTRIBUTE2                                paf_ADDR_ATTRIBUTE2 
		,paf.ADDR_ATTRIBUTE3                                paf_ADDR_ATTRIBUTE3 
		,paf.ADDR_ATTRIBUTE4                                paf_ADDR_ATTRIBUTE4 
		,paf.ADDR_ATTRIBUTE5                                paf_ADDR_ATTRIBUTE5 
		,paf.ADDR_ATTRIBUTE6                                paf_ADDR_ATTRIBUTE6 
		,paf.ADDR_ATTRIBUTE7                                paf_ADDR_ATTRIBUTE7 
		,paf.ADDR_ATTRIBUTE8                                paf_ADDR_ATTRIBUTE8 
		,paf.ADDR_ATTRIBUTE9                                paf_ADDR_ATTRIBUTE9 
		,paf.ADDR_ATTRIBUTE10                               paf_ADDR_ATTRIBUTE10
		,paf.ADDR_ATTRIBUTE11                               paf_ADDR_ATTRIBUTE11
		,paf.ADDR_ATTRIBUTE12                               paf_ADDR_ATTRIBUTE12
		,paf.ADDR_ATTRIBUTE13                               paf_ADDR_ATTRIBUTE13
		,paf.ADDR_ATTRIBUTE14                               paf_ADDR_ATTRIBUTE14
		,paf.ADDR_ATTRIBUTE15                               paf_ADDR_ATTRIBUTE15
		,paf.ADDR_ATTRIBUTE_NUMBER1 						paf_ADDR_ATTRIBUTE_NUMBER1 
		,paf.ADDR_ATTRIBUTE_NUMBER2                         paf_ADDR_ATTRIBUTE_NUMBER2 
		,paf.ADDR_ATTRIBUTE_NUMBER3                         paf_ADDR_ATTRIBUTE_NUMBER3 
		,paf.ADDR_ATTRIBUTE_NUMBER4                         paf_ADDR_ATTRIBUTE_NUMBER4 
		,paf.ADDR_ATTRIBUTE_NUMBER5                         paf_ADDR_ATTRIBUTE_NUMBER5 
		,paf.ADDR_ATTRIBUTE_NUMBER6                         paf_ADDR_ATTRIBUTE_NUMBER6 
		,paf.ADDR_ATTRIBUTE_NUMBER7                         paf_ADDR_ATTRIBUTE_NUMBER7 
		,paf.ADDR_ATTRIBUTE_NUMBER8                         paf_ADDR_ATTRIBUTE_NUMBER8 
		,paf.ADDR_ATTRIBUTE_NUMBER9                         paf_ADDR_ATTRIBUTE_NUMBER9 
		,paf.ADDR_ATTRIBUTE_NUMBER10                        paf_ADDR_ATTRIBUTE_NUMBER10
		,paf.ADDR_ATTRIBUTE_NUMBER11                        paf_ADDR_ATTRIBUTE_NUMBER11
		,paf.ADDR_ATTRIBUTE_NUMBER12                        paf_ADDR_ATTRIBUTE_NUMBER12
		,paf.ADDR_ATTRIBUTE_NUMBER13                        paf_ADDR_ATTRIBUTE_NUMBER13
		,paf.ADDR_ATTRIBUTE_NUMBER14                        paf_ADDR_ATTRIBUTE_NUMBER14
		,paf.ADDR_ATTRIBUTE_NUMBER15                        paf_ADDR_ATTRIBUTE_NUMBER15
		,paf.ADDR_ATTRIBUTE_DATE1 							paf_ADDR_ATTRIBUTE_DATE1 
		,paf.ADDR_ATTRIBUTE_DATE2                           paf_ADDR_ATTRIBUTE_DATE2 
		,paf.ADDR_ATTRIBUTE_DATE3                           paf_ADDR_ATTRIBUTE_DATE3 
		,paf.ADDR_ATTRIBUTE_DATE4                           paf_ADDR_ATTRIBUTE_DATE4 
		,paf.ADDR_ATTRIBUTE_DATE5                           paf_ADDR_ATTRIBUTE_DATE5 
		,paf.ADDR_ATTRIBUTE_DATE6                           paf_ADDR_ATTRIBUTE_DATE6 
		,paf.ADDR_ATTRIBUTE_DATE7                           paf_ADDR_ATTRIBUTE_DATE7 
		,paf.ADDR_ATTRIBUTE_DATE8                           paf_ADDR_ATTRIBUTE_DATE8 
		,paf.ADDR_ATTRIBUTE_DATE9                           paf_ADDR_ATTRIBUTE_DATE9 
		,paf.ADDR_ATTRIBUTE_DATE10                          paf_ADDR_ATTRIBUTE_DATE10
		,paf.ADDR_ATTRIBUTE_DATE11                          paf_ADDR_ATTRIBUTE_DATE11
		,paf.ADDR_ATTRIBUTE_DATE12                          paf_ADDR_ATTRIBUTE_DATE12
		,paf.ADDR_ATTRIBUTE_DATE13                          paf_ADDR_ATTRIBUTE_DATE13
		,paf.ADDR_ATTRIBUTE_DATE14                          paf_ADDR_ATTRIBUTE_DATE14
		,paf.ADDR_ATTRIBUTE_DATE15                          paf_ADDR_ATTRIBUTE_DATE15
		,pemail.ATTRIBUTE1 									pemail_ATTRIBUTE1 
		,pemail.ATTRIBUTE2                                  pemail_ATTRIBUTE2 
		,pemail.ATTRIBUTE3                                  pemail_ATTRIBUTE3 
		,pemail.ATTRIBUTE4                                  pemail_ATTRIBUTE4 
		,pemail.ATTRIBUTE5                                  pemail_ATTRIBUTE5 
		,pemail.ATTRIBUTE6                                  pemail_ATTRIBUTE6 
		,pemail.ATTRIBUTE7                                  pemail_ATTRIBUTE7 
		,pemail.ATTRIBUTE8                                  pemail_ATTRIBUTE8 
		,pemail.ATTRIBUTE9                                  pemail_ATTRIBUTE9 
		,pemail.ATTRIBUTE10                                 pemail_ATTRIBUTE10
		,pemail.ATTRIBUTE11                                 pemail_ATTRIBUTE11
		,pemail.ATTRIBUTE12                                 pemail_ATTRIBUTE12
		,pemail.ATTRIBUTE13                                 pemail_ATTRIBUTE13
		,pemail.ATTRIBUTE14                                 pemail_ATTRIBUTE14
		,pemail.ATTRIBUTE15                                 pemail_ATTRIBUTE15
		,pemail.ATTRIBUTE_NUMBER1 							pemail_ATTRIBUTE_NUMBER1 
		,pemail.ATTRIBUTE_NUMBER2                           pemail_ATTRIBUTE_NUMBER2 
		,pemail.ATTRIBUTE_NUMBER3                           pemail_ATTRIBUTE_NUMBER3 
		,pemail.ATTRIBUTE_NUMBER4                           pemail_ATTRIBUTE_NUMBER4 
		,pemail.ATTRIBUTE_NUMBER5                           pemail_ATTRIBUTE_NUMBER5 
		,pemail.ATTRIBUTE_NUMBER6                           pemail_ATTRIBUTE_NUMBER6 
		,pemail.ATTRIBUTE_NUMBER7                           pemail_ATTRIBUTE_NUMBER7 
		,pemail.ATTRIBUTE_NUMBER8                           pemail_ATTRIBUTE_NUMBER8 
		,pemail.ATTRIBUTE_NUMBER9                           pemail_ATTRIBUTE_NUMBER9 
		,pemail.ATTRIBUTE_NUMBER10                          pemail_ATTRIBUTE_NUMBER10
		,pemail.ATTRIBUTE_NUMBER11                          pemail_ATTRIBUTE_NUMBER11
		,pemail.ATTRIBUTE_NUMBER12                          pemail_ATTRIBUTE_NUMBER12
		,pemail.ATTRIBUTE_NUMBER13                          pemail_ATTRIBUTE_NUMBER13
		,pemail.ATTRIBUTE_NUMBER14                          pemail_ATTRIBUTE_NUMBER14
		,pemail.ATTRIBUTE_NUMBER15                          pemail_ATTRIBUTE_NUMBER15
		,pemail.ATTRIBUTE_DATE1 							pemail_ATTRIBUTE_DATE1 
		,pemail.ATTRIBUTE_DATE2                             pemail_ATTRIBUTE_DATE2 
		,pemail.ATTRIBUTE_DATE3                             pemail_ATTRIBUTE_DATE3 
		,pemail.ATTRIBUTE_DATE4                             pemail_ATTRIBUTE_DATE4 
		,pemail.ATTRIBUTE_DATE5                             pemail_ATTRIBUTE_DATE5 
		,pemail.ATTRIBUTE_DATE6                             pemail_ATTRIBUTE_DATE6 
		,pemail.ATTRIBUTE_DATE7                             pemail_ATTRIBUTE_DATE7 
		,pemail.ATTRIBUTE_DATE8                             pemail_ATTRIBUTE_DATE8 
		,pemail.ATTRIBUTE_DATE9                             pemail_ATTRIBUTE_DATE9 
		,pemail.ATTRIBUTE_DATE10                            pemail_ATTRIBUTE_DATE10
		,pemail.ATTRIBUTE_DATE11                            pemail_ATTRIBUTE_DATE11
		,pemail.ATTRIBUTE_DATE12                            pemail_ATTRIBUTE_DATE12
		,pemail.ATTRIBUTE_DATE13                            pemail_ATTRIBUTE_DATE13
		,pemail.ATTRIBUTE_DATE14                            pemail_ATTRIBUTE_DATE14
		,pemail.ATTRIBUTE_DATE15                            pemail_ATTRIBUTE_DATE15
		,phone.ATTRIBUTE1 									phone_ATTRIBUTE1 
		,phone.ATTRIBUTE2                                   phone_ATTRIBUTE2 
		,phone.ATTRIBUTE3                                   phone_ATTRIBUTE3 
		,phone.ATTRIBUTE4                                   phone_ATTRIBUTE4 
		,phone.ATTRIBUTE5                                   phone_ATTRIBUTE5 
		,phone.ATTRIBUTE6                                   phone_ATTRIBUTE6 
		,phone.ATTRIBUTE7                                   phone_ATTRIBUTE7 
		,phone.ATTRIBUTE8                                   phone_ATTRIBUTE8 
		,phone.ATTRIBUTE9                                   phone_ATTRIBUTE9 
		,phone.ATTRIBUTE10                                  phone_ATTRIBUTE10
		,phone.ATTRIBUTE11                                  phone_ATTRIBUTE11
		,phone.ATTRIBUTE12                                  phone_ATTRIBUTE12
		,phone.ATTRIBUTE13                                  phone_ATTRIBUTE13
		,phone.ATTRIBUTE14                                  phone_ATTRIBUTE14
		,phone.ATTRIBUTE15                                  phone_ATTRIBUTE15
		,phone.ATTRIBUTE_NUMBER1 							phone_ATTRIBUTE_NUMBER1 
		,phone.ATTRIBUTE_NUMBER2                            phone_ATTRIBUTE_NUMBER2 
		,phone.ATTRIBUTE_NUMBER3                            phone_ATTRIBUTE_NUMBER3 
		,phone.ATTRIBUTE_NUMBER4                            phone_ATTRIBUTE_NUMBER4 
		,phone.ATTRIBUTE_NUMBER5                            phone_ATTRIBUTE_NUMBER5 
		,phone.ATTRIBUTE_NUMBER6                            phone_ATTRIBUTE_NUMBER6 
		,phone.ATTRIBUTE_NUMBER7                            phone_ATTRIBUTE_NUMBER7 
		,phone.ATTRIBUTE_NUMBER8                            phone_ATTRIBUTE_NUMBER8 
		,phone.ATTRIBUTE_NUMBER9                            phone_ATTRIBUTE_NUMBER9 
		,phone.ATTRIBUTE_NUMBER10                           phone_ATTRIBUTE_NUMBER10
		,phone.ATTRIBUTE_NUMBER11                           phone_ATTRIBUTE_NUMBER11
		,phone.ATTRIBUTE_NUMBER12                           phone_ATTRIBUTE_NUMBER12
		,phone.ATTRIBUTE_NUMBER13                           phone_ATTRIBUTE_NUMBER13
		,phone.ATTRIBUTE_NUMBER14                           phone_ATTRIBUTE_NUMBER14
		,phone.ATTRIBUTE_NUMBER15                           phone_ATTRIBUTE_NUMBER15
		,phone.ATTRIBUTE_DATE1 								phone_ATTRIBUTE_DATE1 
		,phone.ATTRIBUTE_DATE2                              phone_ATTRIBUTE_DATE2 
		,phone.ATTRIBUTE_DATE3                              phone_ATTRIBUTE_DATE3 
		,phone.ATTRIBUTE_DATE4                              phone_ATTRIBUTE_DATE4 
		,phone.ATTRIBUTE_DATE5                              phone_ATTRIBUTE_DATE5 
		,phone.ATTRIBUTE_DATE6                              phone_ATTRIBUTE_DATE6 
		,phone.ATTRIBUTE_DATE7                              phone_ATTRIBUTE_DATE7 
		,phone.ATTRIBUTE_DATE8                              phone_ATTRIBUTE_DATE8 
		,phone.ATTRIBUTE_DATE9                              phone_ATTRIBUTE_DATE9 
		,phone.ATTRIBUTE_DATE10                             phone_ATTRIBUTE_DATE10
		,phone.ATTRIBUTE_DATE11                             phone_ATTRIBUTE_DATE11
		,phone.ATTRIBUTE_DATE12                             phone_ATTRIBUTE_DATE12
		,phone.ATTRIBUTE_DATE13                             phone_ATTRIBUTE_DATE13
		,phone.ATTRIBUTE_DATE14                             phone_ATTRIBUTE_DATE14
		,phone.ATTRIBUTE_DATE15                             phone_ATTRIBUTE_DATE15
		,pe.ATTRIBUTE1 										pe_ATTRIBUTE1 
		,pe.ATTRIBUTE2                                      pe_ATTRIBUTE2 
		,pe.ATTRIBUTE3                                      pe_ATTRIBUTE3 
		,pe.ATTRIBUTE4                                      pe_ATTRIBUTE4 
		,pe.ATTRIBUTE5                                      pe_ATTRIBUTE5 
		,pe.ATTRIBUTE6                                      pe_ATTRIBUTE6 
		,pe.ATTRIBUTE7                                      pe_ATTRIBUTE7 
		,pe.ATTRIBUTE8                                      pe_ATTRIBUTE8 
		,pe.ATTRIBUTE9                                      pe_ATTRIBUTE9 
		,pe.ATTRIBUTE10                                     pe_ATTRIBUTE10
		,pe.ATTRIBUTE11                                     pe_ATTRIBUTE11
		,pe.ATTRIBUTE12                                     pe_ATTRIBUTE12
		,pe.ATTRIBUTE13                                     pe_ATTRIBUTE13
		,pe.ATTRIBUTE14                                     pe_ATTRIBUTE14
		,pe.ATTRIBUTE15                                     pe_ATTRIBUTE15
		,pe.ATTRIBUTE_NUMBER1 								pe_ATTRIBUTE_NUMBER1 
		,pe.ATTRIBUTE_NUMBER2                               pe_ATTRIBUTE_NUMBER2 
		,pe.ATTRIBUTE_NUMBER3                               pe_ATTRIBUTE_NUMBER3 
		,pe.ATTRIBUTE_NUMBER4                               pe_ATTRIBUTE_NUMBER4 
		,pe.ATTRIBUTE_NUMBER5                               pe_ATTRIBUTE_NUMBER5 
		,pe.ATTRIBUTE_NUMBER6                               pe_ATTRIBUTE_NUMBER6 
		,pe.ATTRIBUTE_NUMBER7                               pe_ATTRIBUTE_NUMBER7 
		,pe.ATTRIBUTE_NUMBER8                               pe_ATTRIBUTE_NUMBER8 
		,pe.ATTRIBUTE_NUMBER9                               pe_ATTRIBUTE_NUMBER9 
		,pe.ATTRIBUTE_NUMBER10                              pe_ATTRIBUTE_NUMBER10
		,pe.ATTRIBUTE_NUMBER11                              pe_ATTRIBUTE_NUMBER11
		,pe.ATTRIBUTE_NUMBER12                              pe_ATTRIBUTE_NUMBER12
		,pe.ATTRIBUTE_NUMBER13                              pe_ATTRIBUTE_NUMBER13
		,pe.ATTRIBUTE_NUMBER14                              pe_ATTRIBUTE_NUMBER14
		,pe.ATTRIBUTE_NUMBER15                              pe_ATTRIBUTE_NUMBER15
		,pe.ATTRIBUTE_DATE1 								pe_ATTRIBUTE_DATE1 
		,pe.ATTRIBUTE_DATE2                                 pe_ATTRIBUTE_DATE2 
		,pe.ATTRIBUTE_DATE3                                 pe_ATTRIBUTE_DATE3 
		,pe.ATTRIBUTE_DATE4                                 pe_ATTRIBUTE_DATE4 
		,pe.ATTRIBUTE_DATE5                                 pe_ATTRIBUTE_DATE5 
		,pe.ATTRIBUTE_DATE6                                 pe_ATTRIBUTE_DATE6 
		,pe.ATTRIBUTE_DATE7                                 pe_ATTRIBUTE_DATE7 
		,pe.ATTRIBUTE_DATE8                                 pe_ATTRIBUTE_DATE8 
		,pe.ATTRIBUTE_DATE9                                 pe_ATTRIBUTE_DATE9 
		,pe.ATTRIBUTE_DATE10                                pe_ATTRIBUTE_DATE10
		,pe.ATTRIBUTE_DATE11                                pe_ATTRIBUTE_DATE11
		,pe.ATTRIBUTE_DATE12                                pe_ATTRIBUTE_DATE12
		,pe.ATTRIBUTE_DATE13                                pe_ATTRIBUTE_DATE13
		,pe.ATTRIBUTE_DATE14                                pe_ATTRIBUTE_DATE14
		,pe.ATTRIBUTE_DATE15                                pe_ATTRIBUTE_DATE15
		,nid.ATTRIBUTE1 									nid_ATTRIBUTE1 
		,nid.ATTRIBUTE2                                     nid_ATTRIBUTE2 
		,nid.ATTRIBUTE3                                     nid_ATTRIBUTE3 
		,nid.ATTRIBUTE4                                     nid_ATTRIBUTE4 
		,nid.ATTRIBUTE5                                     nid_ATTRIBUTE5 
		,nid.ATTRIBUTE6                                     nid_ATTRIBUTE6 
		,nid.ATTRIBUTE7                                     nid_ATTRIBUTE7 
		,nid.ATTRIBUTE8                                     nid_ATTRIBUTE8 
		,nid.ATTRIBUTE9                                     nid_ATTRIBUTE9 
		,nid.ATTRIBUTE10                                    nid_ATTRIBUTE10
		,nid.ATTRIBUTE11                                    nid_ATTRIBUTE11
		,nid.ATTRIBUTE12                                    nid_ATTRIBUTE12
		,nid.ATTRIBUTE13                                    nid_ATTRIBUTE13
		,nid.ATTRIBUTE14                                    nid_ATTRIBUTE14
		,nid.ATTRIBUTE15                                    nid_ATTRIBUTE15
		,nid.ATTRIBUTE_NUMBER1 								nid_ATTRIBUTE_NUMBER1 
		,nid.ATTRIBUTE_NUMBER2                              nid_ATTRIBUTE_NUMBER2 
		,nid.ATTRIBUTE_NUMBER3                              nid_ATTRIBUTE_NUMBER3 
		,nid.ATTRIBUTE_NUMBER4                              nid_ATTRIBUTE_NUMBER4 
		,nid.ATTRIBUTE_NUMBER5                              nid_ATTRIBUTE_NUMBER5 
		,nid.ATTRIBUTE_NUMBER6                              nid_ATTRIBUTE_NUMBER6 
		,nid.ATTRIBUTE_NUMBER7                              nid_ATTRIBUTE_NUMBER7 
		,nid.ATTRIBUTE_NUMBER8                              nid_ATTRIBUTE_NUMBER8 
		,nid.ATTRIBUTE_NUMBER9                              nid_ATTRIBUTE_NUMBER9 
		,nid.ATTRIBUTE_NUMBER10                             nid_ATTRIBUTE_NUMBER10
		,nid.ATTRIBUTE_NUMBER11                             nid_ATTRIBUTE_NUMBER11
		,nid.ATTRIBUTE_NUMBER12                             nid_ATTRIBUTE_NUMBER12
		,nid.ATTRIBUTE_NUMBER13                             nid_ATTRIBUTE_NUMBER13
		,nid.ATTRIBUTE_NUMBER14                             nid_ATTRIBUTE_NUMBER14
		,nid.ATTRIBUTE_NUMBER15                             nid_ATTRIBUTE_NUMBER15
		,nid.ATTRIBUTE_DATE1 								nid_ATTRIBUTE_DATE1 
		,nid.ATTRIBUTE_DATE2                                nid_ATTRIBUTE_DATE2 
		,nid.ATTRIBUTE_DATE3                                nid_ATTRIBUTE_DATE3 
		,nid.ATTRIBUTE_DATE4                                nid_ATTRIBUTE_DATE4 
		,nid.ATTRIBUTE_DATE5                                nid_ATTRIBUTE_DATE5 
		,nid.ATTRIBUTE_DATE6                                nid_ATTRIBUTE_DATE6 
		,nid.ATTRIBUTE_DATE7                                nid_ATTRIBUTE_DATE7 
		,nid.ATTRIBUTE_DATE8                                nid_ATTRIBUTE_DATE8 
		,nid.ATTRIBUTE_DATE9                                nid_ATTRIBUTE_DATE9 
		,nid.ATTRIBUTE_DATE10                               nid_ATTRIBUTE_DATE10
		,nid.ATTRIBUTE_DATE11                               nid_ATTRIBUTE_DATE11
		,nid.ATTRIBUTE_DATE12                               nid_ATTRIBUTE_DATE12
		,nid.ATTRIBUTE_DATE13                               nid_ATTRIBUTE_DATE13
		,nid.ATTRIBUTE_DATE14                               nid_ATTRIBUTE_DATE14
		,nid.ATTRIBUTE_DATE15                               nid_ATTRIBUTE_DATE15
		,pass.ATTRIBUTE1 									pass_ATTRIBUTE1 
		,pass.ATTRIBUTE2                                    pass_ATTRIBUTE2 
		,pass.ATTRIBUTE3                                    pass_ATTRIBUTE3 
		,pass.ATTRIBUTE4                                    pass_ATTRIBUTE4 
		,pass.ATTRIBUTE5                                    pass_ATTRIBUTE5 
		,pass.ATTRIBUTE6                                    pass_ATTRIBUTE6 
		,pass.ATTRIBUTE7                                    pass_ATTRIBUTE7 
		,pass.ATTRIBUTE8                                    pass_ATTRIBUTE8 
		,pass.ATTRIBUTE9                                    pass_ATTRIBUTE9 
		,pass.ATTRIBUTE10                                   pass_ATTRIBUTE10
		,pass.ATTRIBUTE11                                   pass_ATTRIBUTE11
		,pass.ATTRIBUTE12                                   pass_ATTRIBUTE12
		,pass.ATTRIBUTE13                                   pass_ATTRIBUTE13
		,pass.ATTRIBUTE14                                   pass_ATTRIBUTE14
		,pass.ATTRIBUTE15                                   pass_ATTRIBUTE15
		,pass.ATTRIBUTE_NUMBER1 							pass_ATTRIBUTE_NUMBER1 
		,pass.ATTRIBUTE_NUMBER2                             pass_ATTRIBUTE_NUMBER2 
		,pass.ATTRIBUTE_NUMBER3                             pass_ATTRIBUTE_NUMBER3 
		,pass.ATTRIBUTE_NUMBER4                             pass_ATTRIBUTE_NUMBER4 
		,pass.ATTRIBUTE_NUMBER5                             pass_ATTRIBUTE_NUMBER5 
		,pass.ATTRIBUTE_NUMBER6                             pass_ATTRIBUTE_NUMBER6 
		,pass.ATTRIBUTE_NUMBER7                             pass_ATTRIBUTE_NUMBER7 
		,pass.ATTRIBUTE_NUMBER8                             pass_ATTRIBUTE_NUMBER8 
		,pass.ATTRIBUTE_NUMBER9                             pass_ATTRIBUTE_NUMBER9 
		,pass.ATTRIBUTE_NUMBER10                            pass_ATTRIBUTE_NUMBER10
		,pass.ATTRIBUTE_NUMBER11                            pass_ATTRIBUTE_NUMBER11
		,pass.ATTRIBUTE_NUMBER12                            pass_ATTRIBUTE_NUMBER12
		,pass.ATTRIBUTE_NUMBER13                            pass_ATTRIBUTE_NUMBER13
		,pass.ATTRIBUTE_NUMBER14                            pass_ATTRIBUTE_NUMBER14
		,pass.ATTRIBUTE_NUMBER15                            pass_ATTRIBUTE_NUMBER15
		,pass.ATTRIBUTE_DATE1 								pass_ATTRIBUTE_DATE1 
		,pass.ATTRIBUTE_DATE2                               pass_ATTRIBUTE_DATE2 
		,pass.ATTRIBUTE_DATE3                               pass_ATTRIBUTE_DATE3 
		,pass.ATTRIBUTE_DATE4                               pass_ATTRIBUTE_DATE4 
		,pass.ATTRIBUTE_DATE5                               pass_ATTRIBUTE_DATE5 
		,pass.ATTRIBUTE_DATE6                               pass_ATTRIBUTE_DATE6 
		,pass.ATTRIBUTE_DATE7                               pass_ATTRIBUTE_DATE7 
		,pass.ATTRIBUTE_DATE8                               pass_ATTRIBUTE_DATE8 
		,pass.ATTRIBUTE_DATE9                               pass_ATTRIBUTE_DATE9 
		,pass.ATTRIBUTE_DATE10                              pass_ATTRIBUTE_DATE10
		,pass.ATTRIBUTE_DATE11                              pass_ATTRIBUTE_DATE11
		,pass.ATTRIBUTE_DATE12                              pass_ATTRIBUTE_DATE12
		,pass.ATTRIBUTE_DATE13                              pass_ATTRIBUTE_DATE13
		,pass.ATTRIBUTE_DATE14                              pass_ATTRIBUTE_DATE14
		,pass.ATTRIBUTE_DATE15                              pass_ATTRIBUTE_DATE15
		,cit.ATTRIBUTE1 								    cit_ATTRIBUTE1 
		,cit.ATTRIBUTE2                                     cit_ATTRIBUTE2 
		,cit.ATTRIBUTE3                                     cit_ATTRIBUTE3 
		,cit.ATTRIBUTE4                                     cit_ATTRIBUTE4 
		,cit.ATTRIBUTE5                                     cit_ATTRIBUTE5 
		,cit.ATTRIBUTE6                                     cit_ATTRIBUTE6 
		,cit.ATTRIBUTE7                                     cit_ATTRIBUTE7 
		,cit.ATTRIBUTE8                                     cit_ATTRIBUTE8 
		,cit.ATTRIBUTE9                                     cit_ATTRIBUTE9 
		,cit.ATTRIBUTE10                                    cit_ATTRIBUTE10
		,cit.ATTRIBUTE11                                    cit_ATTRIBUTE11
		,cit.ATTRIBUTE12                                    cit_ATTRIBUTE12
		,cit.ATTRIBUTE13                                    cit_ATTRIBUTE13
		,cit.ATTRIBUTE14                                    cit_ATTRIBUTE14
		,cit.ATTRIBUTE15                                    cit_ATTRIBUTE15
		,cit.ATTRIBUTE_NUMBER1 							    cit_ATTRIBUTE_NUMBER1 
		,cit.ATTRIBUTE_NUMBER2                              cit_ATTRIBUTE_NUMBER2 
		,cit.ATTRIBUTE_NUMBER3                              cit_ATTRIBUTE_NUMBER3 
		,cit.ATTRIBUTE_NUMBER4                              cit_ATTRIBUTE_NUMBER4 
		,cit.ATTRIBUTE_NUMBER5                              cit_ATTRIBUTE_NUMBER5 
		,cit.ATTRIBUTE_NUMBER6                              cit_ATTRIBUTE_NUMBER6 
		,cit.ATTRIBUTE_NUMBER7                              cit_ATTRIBUTE_NUMBER7 
		,cit.ATTRIBUTE_NUMBER8                              cit_ATTRIBUTE_NUMBER8 
		,cit.ATTRIBUTE_NUMBER9                              cit_ATTRIBUTE_NUMBER9 
		,cit.ATTRIBUTE_NUMBER10                             cit_ATTRIBUTE_NUMBER10
		,cit.ATTRIBUTE_NUMBER11                             cit_ATTRIBUTE_NUMBER11
		,cit.ATTRIBUTE_NUMBER12                             cit_ATTRIBUTE_NUMBER12
		,cit.ATTRIBUTE_NUMBER13                             cit_ATTRIBUTE_NUMBER13
		,cit.ATTRIBUTE_NUMBER14                             cit_ATTRIBUTE_NUMBER14
		,cit.ATTRIBUTE_NUMBER15                             cit_ATTRIBUTE_NUMBER15
		,cit.ATTRIBUTE_DATE1 							    cit_ATTRIBUTE_DATE1 
		,cit.ATTRIBUTE_DATE2                                cit_ATTRIBUTE_DATE2 
		,cit.ATTRIBUTE_DATE3                                cit_ATTRIBUTE_DATE3 
		,cit.ATTRIBUTE_DATE4                                cit_ATTRIBUTE_DATE4 
		,cit.ATTRIBUTE_DATE5                                cit_ATTRIBUTE_DATE5 
		,cit.ATTRIBUTE_DATE6                                cit_ATTRIBUTE_DATE6 
		,cit.ATTRIBUTE_DATE7                                cit_ATTRIBUTE_DATE7 
		,cit.ATTRIBUTE_DATE8                                cit_ATTRIBUTE_DATE8 
		,cit.ATTRIBUTE_DATE9                                cit_ATTRIBUTE_DATE9 
		,cit.ATTRIBUTE_DATE10                               cit_ATTRIBUTE_DATE10
		,cit.ATTRIBUTE_DATE11                               cit_ATTRIBUTE_DATE11
		,cit.ATTRIBUTE_DATE12                               cit_ATTRIBUTE_DATE12
		,cit.ATTRIBUTE_DATE13                               cit_ATTRIBUTE_DATE13
		,cit.ATTRIBUTE_DATE14                               cit_ATTRIBUTE_DATE14
		,cit.ATTRIBUTE_DATE15                               cit_ATTRIBUTE_DATE15
		,pld.PER_INFORMATION1								pld_PER_INFORMATION1
		,pld.PER_INFORMATION2								pld_PER_INFORMATION2
		,pld.PER_INFORMATION3								pld_PER_INFORMATION3
		,pld.PER_INFORMATION4								pld_PER_INFORMATION4
		,pld.PER_INFORMATION5								pld_PER_INFORMATION5
		,pld.PER_INFORMATION6								pld_PER_INFORMATION6
		,pld.PER_INFORMATION7								pld_PER_INFORMATION7
		,pld.PER_INFORMATION8								pld_PER_INFORMATION8
		,pld.PER_INFORMATION9								pld_PER_INFORMATION9
		,pld.PER_INFORMATION10								pld_PER_INFORMATION10
		,pld.PER_INFORMATION11								pld_PER_INFORMATION11
		,pld.PER_INFORMATION12								pld_PER_INFORMATION12
		,pld.PER_INFORMATION13								pld_PER_INFORMATION13
		,pld.PER_INFORMATION14								pld_PER_INFORMATION14
		,pld.PER_INFORMATION15								pld_PER_INFORMATION15
		,pld.ATTRIBUTE1 									pld_ATTRIBUTE1 
		,pld.ATTRIBUTE2                                     pld_ATTRIBUTE2 
		,pld.ATTRIBUTE3                                     pld_ATTRIBUTE3 
		,pld.ATTRIBUTE4                                     pld_ATTRIBUTE4 
		,pld.ATTRIBUTE5                                     pld_ATTRIBUTE5 
		,pld.ATTRIBUTE6                                     pld_ATTRIBUTE6 
		,pld.ATTRIBUTE7                                     pld_ATTRIBUTE7 
		,pld.ATTRIBUTE8                                     pld_ATTRIBUTE8 
		,pld.ATTRIBUTE9                                     pld_ATTRIBUTE9 
		,pld.ATTRIBUTE10                                    pld_ATTRIBUTE10
		,pld.ATTRIBUTE11                                    pld_ATTRIBUTE11
		,pld.ATTRIBUTE12                                    pld_ATTRIBUTE12
		,pld.ATTRIBUTE13                                    pld_ATTRIBUTE13
		,pld.ATTRIBUTE14                                    pld_ATTRIBUTE14
		,pld.ATTRIBUTE15                                    pld_ATTRIBUTE15
		,pld.PER_INFORMATION_NUMBER1 						pld_PER_INFORMATION_NUMBER1 
		,pld.PER_INFORMATION_NUMBER2                        pld_PER_INFORMATION_NUMBER2 
		,pld.PER_INFORMATION_NUMBER3                        pld_PER_INFORMATION_NUMBER3 
		,pld.PER_INFORMATION_NUMBER4                        pld_PER_INFORMATION_NUMBER4 
		,pld.PER_INFORMATION_NUMBER5                        pld_PER_INFORMATION_NUMBER5 
		,pld.PER_INFORMATION_NUMBER6                        pld_PER_INFORMATION_NUMBER6 
		,pld.PER_INFORMATION_NUMBER7                        pld_PER_INFORMATION_NUMBER7 
		,pld.PER_INFORMATION_NUMBER8                        pld_PER_INFORMATION_NUMBER8 
		,pld.PER_INFORMATION_NUMBER9                        pld_PER_INFORMATION_NUMBER9 
		,pld.PER_INFORMATION_NUMBER10                       pld_PER_INFORMATION_NUMBER10
		,pld.PER_INFORMATION_NUMBER11                       pld_PER_INFORMATION_NUMBER11
		,pld.PER_INFORMATION_NUMBER12                       pld_PER_INFORMATION_NUMBER12
		,pld.PER_INFORMATION_NUMBER13                       pld_PER_INFORMATION_NUMBER13
		,pld.PER_INFORMATION_NUMBER14                       pld_PER_INFORMATION_NUMBER14
		,pld.PER_INFORMATION_NUMBER15                       pld_PER_INFORMATION_NUMBER15
		,TO_CHAR(pld.PER_INFORMATION_DATE1,'RRRR/MM/DD')	pld_PER_INFORMATION_DATE1
		,TO_CHAR(pld.PER_INFORMATION_DATE2,'RRRR/MM/DD')	pld_PER_INFORMATION_DATE2
		,TO_CHAR(pld.PER_INFORMATION_DATE3,'RRRR/MM/DD')	pld_PER_INFORMATION_DATE3
		,TO_CHAR(pld.PER_INFORMATION_DATE4,'RRRR/MM/DD') 	pld_PER_INFORMATION_DATE4 
		,TO_CHAR(pld.PER_INFORMATION_DATE5,'RRRR/MM/DD')    pld_PER_INFORMATION_DATE5 
		,TO_CHAR(pld.PER_INFORMATION_DATE6,'RRRR/MM/DD')    pld_PER_INFORMATION_DATE6 
		,TO_CHAR(pld.PER_INFORMATION_DATE7,'RRRR/MM/DD')    pld_PER_INFORMATION_DATE7 
		,TO_CHAR(pld.PER_INFORMATION_DATE8,'RRRR/MM/DD')    pld_PER_INFORMATION_DATE8 
		,TO_CHAR(pld.PER_INFORMATION_DATE9,'RRRR/MM/DD')    pld_PER_INFORMATION_DATE9 
		,TO_CHAR(pld.PER_INFORMATION_DATE10,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE10
		,TO_CHAR(pld.PER_INFORMATION_DATE11,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE11
		,TO_CHAR(pld.PER_INFORMATION_DATE12,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE12
		,TO_CHAR(pld.PER_INFORMATION_DATE13,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE13
		,TO_CHAR(pld.PER_INFORMATION_DATE14,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE14
		,TO_CHAR(pld.PER_INFORMATION_DATE15,'RRRR/MM/DD')   pld_PER_INFORMATION_DATE15
		,pld.ATTRIBUTE_NUMBER1 								pld_ATTRIBUTE_NUMBER1 
		,pld.ATTRIBUTE_NUMBER2                              pld_ATTRIBUTE_NUMBER2 
		,pld.ATTRIBUTE_NUMBER3                              pld_ATTRIBUTE_NUMBER3 
		,pld.ATTRIBUTE_NUMBER4                              pld_ATTRIBUTE_NUMBER4 
		,pld.ATTRIBUTE_NUMBER5                              pld_ATTRIBUTE_NUMBER5 
		,pld.ATTRIBUTE_NUMBER6                              pld_ATTRIBUTE_NUMBER6 
		,pld.ATTRIBUTE_NUMBER7                              pld_ATTRIBUTE_NUMBER7 
		,pld.ATTRIBUTE_NUMBER8                              pld_ATTRIBUTE_NUMBER8 
		,pld.ATTRIBUTE_NUMBER9                              pld_ATTRIBUTE_NUMBER9 
		,pld.ATTRIBUTE_NUMBER10                             pld_ATTRIBUTE_NUMBER10
		,pld.ATTRIBUTE_NUMBER11                             pld_ATTRIBUTE_NUMBER11
		,pld.ATTRIBUTE_NUMBER12                             pld_ATTRIBUTE_NUMBER12
		,pld.ATTRIBUTE_NUMBER13                             pld_ATTRIBUTE_NUMBER13
		,pld.ATTRIBUTE_NUMBER14                             pld_ATTRIBUTE_NUMBER14
		,pld.ATTRIBUTE_NUMBER15                             pld_ATTRIBUTE_NUMBER15
		,pld.ATTRIBUTE_DATE1 								pld_ATTRIBUTE_DATE1 
		,pld.ATTRIBUTE_DATE2                                pld_ATTRIBUTE_DATE2 
		,pld.ATTRIBUTE_DATE3                                pld_ATTRIBUTE_DATE3 
		,pld.ATTRIBUTE_DATE4                                pld_ATTRIBUTE_DATE4 
		,pld.ATTRIBUTE_DATE5                                pld_ATTRIBUTE_DATE5 
		,pld.ATTRIBUTE_DATE6                                pld_ATTRIBUTE_DATE6 
		,pld.ATTRIBUTE_DATE7                                pld_ATTRIBUTE_DATE7 
		,pld.ATTRIBUTE_DATE8                                pld_ATTRIBUTE_DATE8 
		,pld.ATTRIBUTE_DATE9                                pld_ATTRIBUTE_DATE9 
		,pld.ATTRIBUTE_DATE10                               pld_ATTRIBUTE_DATE10
		,pld.ATTRIBUTE_DATE11                               pld_ATTRIBUTE_DATE11
		,pld.ATTRIBUTE_DATE12                               pld_ATTRIBUTE_DATE12
		,pld.ATTRIBUTE_DATE13                               pld_ATTRIBUTE_DATE13
		,pld.ATTRIBUTE_DATE14                               pld_ATTRIBUTE_DATE14
		,pld.ATTRIBUTE_DATE15                               pld_ATTRIBUTE_DATE15
		,Rel.ATTRIBUTE1 									Rel_ATTRIBUTE1 
		,Rel.ATTRIBUTE2                                     Rel_ATTRIBUTE2 
		,Rel.ATTRIBUTE3                                     Rel_ATTRIBUTE3 
		,Rel.ATTRIBUTE4                                     Rel_ATTRIBUTE4 
		,Rel.ATTRIBUTE5                                     Rel_ATTRIBUTE5 
		,Rel.ATTRIBUTE6                                     Rel_ATTRIBUTE6 
		,Rel.ATTRIBUTE7                                     Rel_ATTRIBUTE7 
		,Rel.ATTRIBUTE8                                     Rel_ATTRIBUTE8 
		,Rel.ATTRIBUTE9                                     Rel_ATTRIBUTE9 
		,Rel.ATTRIBUTE10                                    Rel_ATTRIBUTE10
		,Rel.ATTRIBUTE11                                    Rel_ATTRIBUTE11
		,Rel.ATTRIBUTE12                                    Rel_ATTRIBUTE12
		,Rel.ATTRIBUTE13                                    Rel_ATTRIBUTE13
		,Rel.ATTRIBUTE14                                    Rel_ATTRIBUTE14
		,Rel.ATTRIBUTE15                                    Rel_ATTRIBUTE15
       FROM  xxmx_per_people_f_xfm      pps
           , xxmx_per_persons_xfm       pp
           , xxmx_per_names_f_xfm       pns
           , xxmx_per_address_f_xfm     paf
           , xxmx_per_email_f_xfm       pemail
           , xxmx_per_phones_xfm        phone
           , xxmx_per_ethnicities_xfm   pe
           , xxmx_per_nid_f_xfm         nid
           , xxmx_per_passport_xfm      pass
           , xxmx_citizenships_xfm      cit
           , xxmx_per_leg_f_xfm         pld
           , XXMX_PER_RELIGION_XFM      Rel
       WHERE pp.person_id = pps.person_id
         AND pp.BG_name = pps.BG_name
         AND pps.migration_set_id = pp.migration_set_id
         AND pp.person_id        = pns.person_id(+)
         AND pp.person_id        = paf.person_id(+)
         AND pp.person_id        = pemail.person_id(+)
         AND pp.person_id        = phone.person_id(+)
         AND pp.person_id        = pe.person_id(+)
         AND pp.person_id        = nid.person_id(+)
         AND pp.person_id        = pass.personid(+)
         AND pp.person_id        = cit.person_id(+)
         AND pp.person_id        = pld.person_id(+)
         AND pp.person_id        = rel.personid(+)
         AND pp.date_of_birth    IS NOT NULL
         AND NVL(paf.primary_flag,'Y')    = 'Y' 
         AND NVL(pemail.primary_flag,'Y') = 'Y' 
         AND NVL(phone.primary_flag,'Y')  = 'Y' 
         AND NVL(pe.PRIMARY_FLAG,'Y')     = 'Y' 
         AND NVL(nid.PRIMARY_FLAG,'Y')    = 'Y' 
 ORDER BY pp.person_id;
 

  CREATE OR REPLACE VIEW "XXMX_HR_HCM_FILE_SET_V1" AS 
  SELECT  DISTINCT
         asg.migration_set_id                                migration_set_id
        ,asg.person_id                                       person_id
        ,asg.assignment_number                               assignment_number
        ,p.personnumber                                     person_number
        ,asg.action_code  
        ,p.start_Date                                        per_start_date
        ,asg.period_of_service_id                            ppos
        ,asg.legal_employer_name                             legal_emp_name
  FROM  xxmx_per_assignments_m_xfm asg
       , xxmx_per_people_f_xfm  p
   where asg.person_id = p.person_id  
     and p.personnumber is not null
   --  and p.person_number >= 13000 and p.person_number <=13500 -- testing
     order by p.personnumber desc;
/

  
 
 
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_HR_HCM_CONTACTS_V" ("C_MIGRATION_STATUS", "C_PERSON_ID", "C_START_DATE", "C_PARTY_ID", "C_CORRESPONDENCE_LANGUAGE", "C_BLOOD_TYPE", "C_DATE_OF_BIRTH", "C_DATE_OF_DEATH", "C_COUNTRY_OF_BIRTH", "C_REGION_OF_BIRTH", "C_TOWN_OF_BIRTH", "C_USER_GUID", "C_NAMETYPE", "C_LAST_NAME", "C_FIRST_NAME", "C_MIDDLE_NAMES", "C_LEGISLATION_CODE", "C_TITLE", "C_PRE_NAME_ADJUNCT", "C_SUFFIX", "C_KNOWN_AS", "C_PREVIOUS_LAST_NAME", "CR_EFFECTIVESTARTDATE", "CR_EFFECTIVEENDDATE", "CR_CONTPERSONID", "CR_RELATEDPERSONID", "CR_RELATEDPERSONNUM", "CR_CONTACTTYPE", "CR_EMERGENCYCONTACTFLAG", "CR_PRIMARYCONTACTFLAG", "CR_EXISTINGPERSON", "CR_PERSONALFLAG", "CR_SEQUENCENUMBER", "CA_MIGRATION_STATUS", "CA_EFFECTIVESTARTDATE", "CA_EFFECTIVEENDDATE", "CA_CONTPERSONID", "CA_ADDRESSTYPE", "CA_ADDRESSLINE1", "CA_ADDRESSLINE2", "CA_ADDRESSLINE3", "CA_TOWNORCITY", "CA_REGION1", "CA_COUNTRY", "CA_POSTALCODE", "CA_PRIMARYFLAG", "CP_MIGRATION_STATUS", "CP_DATEFROM", "CP_DATETO", "CP_CONTPERSONID", "CP_LEGISLATIONCODE", "CP_COUNTRYCODENUMBER", "CP_PHONETYPE", "CP_PHONENUMBER", "CP_PRIMARYFLAG") AS 
  SELECT DISTINCT 
         c.migration_status                              c_migration_status                   
        ,c.person_id                	                 c_person_id                
        ,TO_CHAR(c.start_date,'RRRR/MM/DD')              c_start_date               
        ,c.party_id                 	                 c_party_id                 
        ,c.correspondence_language  	                 c_correspondence_language  
        ,c.blood_type               	                 c_blood_type               
        ,TO_CHAR(c.date_of_birth,'RRRR/MM/DD')           c_date_of_birth            
        ,TO_CHAR(c.date_of_death,'RRRR/MM/DD')           c_date_of_death            
        ,c.country_of_birth         	                 c_country_of_birth         
        ,c.region_of_birth          	                 c_region_of_birth          
        ,c.town_of_birth            	                 c_town_of_birth            
        ,c.user_guid                	                 c_user_guid                
        ,c.nametype                 	                 c_nametype                 
        ,c.last_name                	                 c_last_name                
        ,c.first_name               	                 c_first_name               
        ,c.middle_names             	                 c_middle_names             
        ,c.legislation_code         	                 c_legislation_code         
        ,c.title                    	                 c_title                    
        ,c.pre_name_adjunct         	                 c_pre_name_adjunct         
        ,c.suffix                   	                 c_suffix                   
        ,c.known_as                 	                 c_known_as                 
        ,c.previous_last_name       	                 c_previous_last_name       
        ,TO_CHAR(cr.effectivestartdate,'RRRR/MM/DD')     cr_effectivestartdate  
        ,TO_CHAR(cr.effectiveenddate,'RRRR/MM/DD')       cr_effectiveenddate    
        ,cr.contpersonid        	                      cr_contpersonid        
        ,cr.relatedpersonid     	                      cr_relatedpersonid     
        ,cr.relatedpersonnum    	                      cr_relatedpersonnum    
        ,cr.contacttype         	                      cr_contacttype         
        ,cr.emergencycontactflag	                      cr_emergencycontactflag
        ,NVL(cr.primarycontactflag,'Y')                   cr_primarycontactflag  
        ,cr.existingperson      	                      cr_existingperson      
        ,cr.personalflag        	                      cr_personalflag        
        ,cr.sequencenumber      	                      cr_sequencenumber      
        ,ca.migration_status   	                      ca_migration_status   
        ,TO_CHAR(ca.effectivestartdate,'RRRR/MM/DD')     ca_effectivestartdate 
        ,TO_CHAR(ca.effectiveenddate,'RRRR/MM/DD')       ca_effectiveenddate   
        ,ca.contpersonid       	                      ca_contpersonid       
        ,ca.addresstype        	                      ca_addresstype        
        ,ca.addressline1       	                      ca_addressline1       
        ,ca.addressline2       	                      ca_addressline2       
        ,ca.addressline3       	                      ca_addressline3       
        ,ca.townorcity         	                      ca_townorcity         
        ,ca.region1            	                      ca_region1            
        ,ca.country            	                      ca_country            
        ,ca.postalcode         	                      ca_postalcode         
        ,NVL(ca.primaryflag,'Y')                         ca_primaryflag        
        ,cp.migration_status                             cp_migration_status 
        ,TO_CHAR(cp.datefrom,'RRRR/MM/DD')               cp_datefrom         
        ,TO_CHAR(cp.dateto,'RRRR/MM/DD')                 cp_dateto           
        ,cp.contpersonid                                 cp_contpersonid     
        ,cp.legislationcode                              cp_legislationcode  
        ,cp.countrycodenumber                            cp_countrycodenumber
        ,cp.phonetype           	                      cp_phonetype        
        ,cp.phonenumber                                  cp_phonenumber      
        ,NVL(cp.primaryflag,'Y')                         cp_primaryflag      
    FROM XXMX_PER_CONTACTS_xfm c,
         XXMX_PER_CONTACT_PHONE_xfm cp,
         XXMX_PER_CONTACT_REL_xfm cr,
         XXMX_PER_CONTACT_ADDR_xfm  ca     
   WHERE c.person_id   = ca.contpersonid (+)      
     AND c.person_id   = cr.contpersonid            
     AND c.person_id    = cp.contpersonid   (+) 
   order by  cr_relatedpersonnum;
   
   
  CREATE OR REPLACE  VIEW "XXMX_HR_HCM_TAL_PRF_V" AS 
  select DISTINCT PRF_B.PROFILE_ID,
       prf_b.person_id,
       PR_ITM.PROFILE_ITEM_ID,
       PRF_B.PROFILE_CODE,
       CNT_ITEM.CONTENT_TYPE_ID,
       PRF_B.PROFILE_STATUS_CODE,
       PRF_B.PROFILE_USAGE_CODE,
       PRF_B.PROFILE_TYPE_ID,
       CNT_ITEM.CONTENT_ITEM_ID,
       CNT_ITEM.CONTENT_ITEM_CODE,
       CNT_ITEM.bg_id,
       (SELECT CNT_TL.NAME
       FROM XXMX_HRT_CNT_ITEMS_TL_STG CNT_TL
       where CNT_ITEM.Content_item_id = CNT_TL.Content_item_id
       AND CNT_ITEM.bg_id = CNT_TL.bg_id
       AND ROWNUM=1) NAME,
       TO_CHAR(to_date(PR_ITM.DATE_FROM,'DD-MON-RRRR'),'RRRR/MM/DD') DATE_FROM,
       to_CHAR(to_date(NVL(PR_ITM.DATE_TO,'31-DEC-4712'),'DD-MON-RRRR'),'RRRR/MM/DD')  DATE_TO,
       REPLACE(PN.FULL_NAME,',','') Person_Name,
       PR_ITM.SOURCE_ID
FROM  XXMX_HRT_PROFILE_B_STG  PRF_B,
      XXMX_HRT_PFL_ITEMS_STG  PR_ITM,
      XXMX_HRT_CNT_ITEMS_B_STG  CNT_ITEM,
      XXMX_PER_NAMES_F_STG PN
WHERE PRF_B.PROFILE_ID = PR_ITM.PROFILE_ID
AND PROFILE_TYPE_ID = 'PERSON'
and PN.person_id = prf_b.person_id
AND CNT_ITEM.CONTENT_ITEM_ID = PR_ITM.CONTENT_ITEM_ID
and CNT_ITEM.bg_id = PR_ITM.bg_id
Order by 1;

/
