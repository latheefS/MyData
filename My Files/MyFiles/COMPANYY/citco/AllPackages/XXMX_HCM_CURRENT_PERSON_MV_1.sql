--------------------------------------------------------
--  DDL for Procedure XXMX_HCM_CURRENT_PERSON_MV_1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "XXMX_CORE"."XXMX_HCM_CURRENT_PERSON_MV_1" as
begin
drop materialized view  XXMX_HCM_CURRENT_PERSON_MV;

drop table xxmx_hcm_workers_scope;

  CREATE TABLE xxmx_hcm_workers_scope
   AS
  select * from (
			 WITH current_workers AS (
				SELECT
					papf.effective_start_date,
					papf.effective_end_date,
					papf.person_id,
					papf.business_group_id,
					ppt.system_person_type,
					ppt.user_person_type,
					'CURRENT'                    current_or_leaver,
					papf.email_address,
					papf.employee_number,
					papf.original_date_of_hire,
					papf.rehire_reason,
					papf.rehire_authorizor,
					papf.start_date,
					papf.party_id,
					papf.correspondence_language correspondence_language,
					papf.blood_type,
					papf.date_of_birth           date_of_birth,
					papf.date_of_death           date_of_death,
					papf.country_of_birth        country_of_birth,
					papf.region_of_birth         region_of_birth,
					papf.town_of_birth           town_of_birth,
					papf.person_id || '_PERSON'  person_id_contact,
					'GLOBAL'                     name_type,
					papf.last_name,
					papf.first_name,
					papf.middle_names,
					papf.full_name,
					papf.title,
					papf.pre_name_adjunct,
					papf.suffix,
					papf.known_as,
					papf.honors,
					papf.previous_last_name,
					papf.current_employee_flag,
					papf.applicant_number,
					papf.person_type_id,
					papf.national_identifier,
					nationality,
					per_information_category,
					internal_location,
					projected_start_date,
					expense_check_send_to_address,
					npw_number,
					papf.per_information1,
					papf.per_information2,
					papf.per_information3,
					papf.per_information4,
					papf.per_information5,
					papf.per_information6,
					papf.per_information7,
					papf.per_information8,
					papf.per_information9,
					papf.per_information10,
					papf.per_information11,
					papf.per_information12,
					papf.per_information13,
					papf.per_information14,
					papf.per_information15,
					papf.per_information16,
					papf.per_information17,
					papf.per_information18,
					papf.per_information19,
					papf.per_information20,
					papf.per_information21,
					papf.per_information22,
					papf.per_information23,
					papf.per_information24,
					papf.per_information25,
					papf.per_information26,
					papf.per_information27,
					papf.per_information28,
					papf.per_information29,
					papf.per_information30,
					papf.sex,
					papf.marital_status,
					papf.rehire_recommendation,
					papf.on_military_service,
					papf.fast_path_employee,
					papf.date_employee_data_verified,
					papf.attribute8
				FROM
					per_all_people_f@xxmx_extract         papf,
					per_person_type_usages_f@xxmx_extract pptu,
					per_person_types@xxmx_extract         ppt
				WHERE
					   /* ( ( trunc(papf.effective_start_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_end_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_start_date) < trunc(sysdate)
							   AND trunc(papf.effective_end_date) > '01-JAN-2021' ) )
						AND */
						papf.person_id = pptu.person_id
					AND ppt.person_type_id = pptu.person_type_id
					AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
					AND '11-JUL-22' BETWEEN papf.effective_start_date AND papf.effective_end_date 
					--AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date 
					AND ( upper(ppt.user_person_type) IN ( 'EMPLOYEE'
														, 'FORMER SPOUSE'
														, 'FORMER DOMESTIC PARTNER'
														, 'CONTINGENT WORKER'
														, 'BOARD MEMBER'
														, 'CONTACT'
														, 'EXTERNAL PROFESSIONAL'
														, 'UNPAID INTERN' 
														)
					)

			), future_starters AS (
				SELECT
					papf.effective_start_date,
					papf.effective_end_date,
					papf.person_id,
					papf.business_group_id,
					ppt.system_person_type,
					ppt.user_person_type,
					'CURRENT'                    current_or_leaver,
					papf.email_address,
					papf.employee_number,
					papf.original_date_of_hire,
					papf.rehire_reason,
					papf.rehire_authorizor,
					papf.start_date,
					papf.party_id,
					papf.correspondence_language correspondence_language,
					papf.blood_type,
					papf.date_of_birth           date_of_birth,
					papf.date_of_death           date_of_death,
					papf.country_of_birth        country_of_birth,
					papf.region_of_birth         region_of_birth,
					papf.town_of_birth           town_of_birth,
					papf.person_id || '_PERSON'  person_id_contact,
					'GLOBAL'                     name_type,
					papf.last_name,
					papf.first_name,
					papf.middle_names,
					papf.full_name,
					papf.title,
					papf.pre_name_adjunct,
					papf.suffix,
					papf.known_as,
					papf.honors,
					papf.previous_last_name,
					papf.current_employee_flag,
					papf.applicant_number,
					papf.person_type_id,
					papf.national_identifier,
					nationality,
					per_information_category,
					internal_location,
					projected_start_date,
					expense_check_send_to_address,
					npw_number,
					papf.per_information1,
					papf.per_information2,
					papf.per_information3,
					papf.per_information4,
					papf.per_information5,
					papf.per_information6,
					papf.per_information7,
					papf.per_information8,
					papf.per_information9,
					papf.per_information10,
					papf.per_information11,
					papf.per_information12,
					papf.per_information13,
					papf.per_information14,
					papf.per_information15,
					papf.per_information16,
					papf.per_information17,
					papf.per_information18,
					papf.per_information19,
					papf.per_information20,
					papf.per_information21,
					papf.per_information22,
					papf.per_information23,
					papf.per_information24,
					papf.per_information25,
					papf.per_information26,
					papf.per_information27,
					papf.per_information28,
					papf.per_information29,
					papf.per_information30,
					papf.sex,
					papf.marital_status,
					papf.rehire_recommendation,
					papf.on_military_service,
					papf.fast_path_employee,
					papf.date_employee_data_verified,
					papf.attribute8
				FROM
					per_all_people_f@xxmx_extract         papf,
					per_person_type_usages_f@xxmx_extract pptu,
					per_person_types@xxmx_extract         ppt
				WHERE
					   /* ( ( trunc(papf.effective_start_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_end_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_start_date) < trunc(sysdate)
							   AND trunc(papf.effective_end_date) > '01-JAN-2021' ) )
						AND */
						papf.person_id = pptu.person_id
					AND ppt.person_type_id = pptu.person_type_id
					AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
					AND trunc(papf.effective_start_date) > '11-JUL-22'
					AND ( upper(ppt.user_person_type) IN ( 'EMPLOYEE'
														, 'FORMER SPOUSE'
														, 'FORMER DOMESTIC PARTNER'
														, 'CONTINGENT WORKER'
														, 'BOARD MEMBER'
														, 'CONTACT'
														, 'EXTERNAL PROFESSIONAL'
														, 'UNPAID INTERN' 
														)
					)					
			),
			pending_workers AS (
				SELECT
					papf.effective_start_date,
					papf.effective_end_date,
					papf.person_id,
					papf.business_group_id,
					ppt.system_person_type,
					ppt.user_person_type,
					'CURRENT'                    current_or_leaver,
					papf.email_address,
					papf.employee_number,
					papf.original_date_of_hire,
					papf.rehire_reason,
					papf.rehire_authorizor,
					papf.start_date,
					papf.party_id,
					papf.correspondence_language correspondence_language,
					papf.blood_type,
					papf.date_of_birth           date_of_birth,
					papf.date_of_death           date_of_death,
					papf.country_of_birth        country_of_birth,
					papf.region_of_birth         region_of_birth,
					papf.town_of_birth           town_of_birth,
					papf.person_id || '_PERSON'  person_id_contact,
					'GLOBAL'                     name_type,
					papf.last_name,
					papf.first_name,
					papf.middle_names,
					papf.full_name,
					papf.title,
					papf.pre_name_adjunct,
					papf.suffix,
					papf.known_as,
					papf.honors,
					papf.previous_last_name,
					papf.current_employee_flag,
					papf.applicant_number,
					papf.person_type_id,
					papf.national_identifier,
					nationality,
					per_information_category,
					internal_location,
					projected_start_date,
					expense_check_send_to_address,
					npw_number,
					papf.per_information1,
					papf.per_information2,
					papf.per_information3,
					papf.per_information4,
					papf.per_information5,
					papf.per_information6,
					papf.per_information7,
					papf.per_information8,
					papf.per_information9,
					papf.per_information10,
					papf.per_information11,
					papf.per_information12,
					papf.per_information13,
					papf.per_information14,
					papf.per_information15,
					papf.per_information16,
					papf.per_information17,
					papf.per_information18,
					papf.per_information19,
					papf.per_information20,
					papf.per_information21,
					papf.per_information22,
					papf.per_information23,
					papf.per_information24,
					papf.per_information25,
					papf.per_information26,
					papf.per_information27,
					papf.per_information28,
					papf.per_information29,
					papf.per_information30,
					papf.sex,
					papf.marital_status,
					papf.rehire_recommendation,
					papf.on_military_service,
					papf.fast_path_employee,
					papf.date_employee_data_verified,
					papf.attribute8
				FROM
					per_all_people_f@xxmx_extract         papf,
					per_person_type_usages_f@xxmx_extract pptu,
					per_person_types@xxmx_extract         ppt
				WHERE
					   /* ( ( trunc(papf.effective_start_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_end_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_start_date) < trunc(sysdate)
							   AND trunc(papf.effective_end_date) > '01-JAN-2021' ) )
						AND */
						papf.person_id = pptu.person_id
					AND ppt.person_type_id = pptu.person_type_id
					AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
					AND ( upper(ppt.user_person_type) = 'APPLICANT'
						AND papf.effective_start_date >= TO_DATE('11-JUL-22','DD-MON-RR')- 90-- trunc(sysdate-90)
						AND papf.effective_end_date > TO_DATE('11-JUL-22','DD-MON-RR')
						)										
			)
            , leaver_workers AS (
				SELECT
					papf.effective_start_date,
					papf.effective_end_date,
					papf.person_id,
					papf.business_group_id,
					ppt.system_person_type,
					ppt.user_person_type,
					'LEAVER'                    current_or_leaver,
					papf.email_address,
					papf.employee_number,
					papf.original_date_of_hire,
					papf.rehire_reason,
					papf.rehire_authorizor,
					papf.start_date,
					papf.party_id,
					papf.correspondence_language correspondence_language,
					papf.blood_type,
					papf.date_of_birth           date_of_birth,
					papf.date_of_death           date_of_death,
					papf.country_of_birth        country_of_birth,
					papf.region_of_birth         region_of_birth,
					papf.town_of_birth           town_of_birth,
					papf.person_id || '_PERSON'  person_id_contact,
					'GLOBAL'                     name_type,
					papf.last_name,
					papf.first_name,
					papf.middle_names,
					papf.full_name,
					papf.title,
					papf.pre_name_adjunct,
					papf.suffix,
					papf.known_as,
					papf.honors,
					papf.previous_last_name,
					papf.current_employee_flag,
					papf.applicant_number,
					papf.person_type_id,
					papf.national_identifier,
					nationality,
					per_information_category,
					internal_location,
					projected_start_date,
					expense_check_send_to_address,
					npw_number,
					papf.per_information1,
					papf.per_information2,
					papf.per_information3,
					papf.per_information4,
					papf.per_information5,
					papf.per_information6,
					papf.per_information7,
					papf.per_information8,
					papf.per_information9,
					papf.per_information10,
					papf.per_information11,
					papf.per_information12,
					papf.per_information13,
					papf.per_information14,
					papf.per_information15,
					papf.per_information16,
					papf.per_information17,
					papf.per_information18,
					papf.per_information19,
					papf.per_information20,
					papf.per_information21,
					papf.per_information22,
					papf.per_information23,
					papf.per_information24,
					papf.per_information25,
					papf.per_information26,
					papf.per_information27,
					papf.per_information28,
					papf.per_information29,
					papf.per_information30,
					papf.sex,
					papf.marital_status,
					papf.rehire_recommendation,
					papf.on_military_service,
					papf.fast_path_employee,
					papf.date_employee_data_verified,
					papf.attribute8
				FROM
					per_all_people_f@xxmx_extract         papf,
					per_person_type_usages_f@xxmx_extract pptu,
					per_person_types@xxmx_extract         ppt,
                    per_periods_of_service@xxmx_extract pos
				WHERE
					   /* ( ( trunc(papf.effective_start_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_end_date) BETWEEN '01-JAN-2021' AND trunc(sysdate) )
						  OR ( trunc(papf.effective_start_date) < trunc(sysdate)
							   AND trunc(papf.effective_end_date) > '01-JAN-2021' ) )
						AND */
						papf.person_id = pptu.person_id
					AND ppt.person_type_id = pptu.person_type_id
					AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
					AND '11-JUL-22' BETWEEN papf.effective_start_date AND papf.effective_end_date 
                    AND  papf.person_id= pos.person_id 
                    AND PERIOD_OF_SERVICE_ID = (select max (PERIOD_OF_SERVICE_ID) 
                                              from  per_periods_of_service@xxmx_extract ppos
                                              where ppos.person_id=pos.person_id)
                    AND ACTUAL_TERMINATION_DATE is not null
					--AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date 
					AND ( upper(ppt.user_person_type) IN ( 'EX-EMPLOYEE' 
														)
					)

			)
			SELECT
				*
			FROM
				current_workers
			UNION ALL
			SELECT
				*
			FROM
				future_starters	
			WHERE NOT EXISTS (
						SELECT
							1
						FROM
							current_workers
						WHERE
							current_workers.person_id = future_starters.person_id
					)
			UNION ALL
			SELECT
				*
			FROM
				pending_workers
          UNION ALL
          SELECT * FROM leaver_workers
); 


  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_HCM_CURRENT_PERSON_MV" 
    BUILD IMMEDIATE 
  REFRESH FORCE ON DEMAND  
  AS
 SELECT * FROM xxmx_hcm_workers_scope; 
 END;

/
