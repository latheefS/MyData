--------------------------------------------------------
--  DDL for View XXMX_PPM_VALID_PERSONS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_VALID_PERSONS_V" ("EFFECTIVE_START_DATE", "EFFECTIVE_END_DATE", "PERSON_ID", "BUSINESS_GROUP_ID", "SYSTEM_PERSON_TYPE", "USER_PERSON_TYPE", "CURRENT_OR_LEAVER", "EMAIL_ADDRESS", "EMPLOYEE_NUMBER", "ORIGINAL_DATE_OF_HIRE", "REHIRE_REASON", "REHIRE_AUTHORIZOR", "START_DATE", "PARTY_ID", "CORRESPONDENCE_LANGUAGE", "BLOOD_TYPE", "DATE_OF_BIRTH", "DATE_OF_DEATH", "COUNTRY_OF_BIRTH", "REGION_OF_BIRTH", "TOWN_OF_BIRTH", "PERSON_ID_CONTACT", "NAME_TYPE", "LAST_NAME", "FIRST_NAME", "MIDDLE_NAMES", "FULL_NAME", "TITLE", "PRE_NAME_ADJUNCT", "SUFFIX", "KNOWN_AS", "HONORS", "PREVIOUS_LAST_NAME", "CURRENT_EMPLOYEE_FLAG", "APPLICANT_NUMBER", "PERSON_TYPE_ID", "NATIONAL_IDENTIFIER", "NATIONALITY", "PER_INFORMATION_CATEGORY", "INTERNAL_LOCATION", "PROJECTED_START_DATE", "EXPENSE_CHECK_SEND_TO_ADDRESS", "NPW_NUMBER", "PER_INFORMATION1", "PER_INFORMATION2", "PER_INFORMATION3", "PER_INFORMATION4", "PER_INFORMATION5", "PER_INFORMATION6", "PER_INFORMATION7", "PER_INFORMATION8", "PER_INFORMATION9", "PER_INFORMATION10", "PER_INFORMATION11", "PER_INFORMATION12", "PER_INFORMATION13", "PER_INFORMATION14", "PER_INFORMATION15", "PER_INFORMATION16", "PER_INFORMATION17", "PER_INFORMATION18", "PER_INFORMATION19", "PER_INFORMATION20", "PER_INFORMATION21", "PER_INFORMATION22", "PER_INFORMATION23", "PER_INFORMATION24", "PER_INFORMATION25", "PER_INFORMATION26", "PER_INFORMATION27", "PER_INFORMATION28", "PER_INFORMATION29", "PER_INFORMATION30", "SEX", "MARITAL_STATUS", "REHIRE_RECOMMENDATION", "ON_MILITARY_SERVICE", "FAST_PATH_EMPLOYEE", "DATE_EMPLOYEE_DATA_VERIFIED", "ATTRIBUTE8") AS 
  select "EFFECTIVE_START_DATE","EFFECTIVE_END_DATE","PERSON_ID","BUSINESS_GROUP_ID","SYSTEM_PERSON_TYPE","USER_PERSON_TYPE","CURRENT_OR_LEAVER","EMAIL_ADDRESS","EMPLOYEE_NUMBER","ORIGINAL_DATE_OF_HIRE","REHIRE_REASON","REHIRE_AUTHORIZOR","START_DATE","PARTY_ID","CORRESPONDENCE_LANGUAGE","BLOOD_TYPE","DATE_OF_BIRTH","DATE_OF_DEATH","COUNTRY_OF_BIRTH","REGION_OF_BIRTH","TOWN_OF_BIRTH","PERSON_ID_CONTACT","NAME_TYPE","LAST_NAME","FIRST_NAME","MIDDLE_NAMES","FULL_NAME","TITLE","PRE_NAME_ADJUNCT","SUFFIX","KNOWN_AS","HONORS","PREVIOUS_LAST_NAME","CURRENT_EMPLOYEE_FLAG","APPLICANT_NUMBER","PERSON_TYPE_ID","NATIONAL_IDENTIFIER","NATIONALITY","PER_INFORMATION_CATEGORY","INTERNAL_LOCATION","PROJECTED_START_DATE","EXPENSE_CHECK_SEND_TO_ADDRESS","NPW_NUMBER","PER_INFORMATION1","PER_INFORMATION2","PER_INFORMATION3","PER_INFORMATION4","PER_INFORMATION5","PER_INFORMATION6","PER_INFORMATION7","PER_INFORMATION8","PER_INFORMATION9","PER_INFORMATION10","PER_INFORMATION11","PER_INFORMATION12","PER_INFORMATION13","PER_INFORMATION14","PER_INFORMATION15","PER_INFORMATION16","PER_INFORMATION17","PER_INFORMATION18","PER_INFORMATION19","PER_INFORMATION20","PER_INFORMATION21","PER_INFORMATION22","PER_INFORMATION23","PER_INFORMATION24","PER_INFORMATION25","PER_INFORMATION26","PER_INFORMATION27","PER_INFORMATION28","PER_INFORMATION29","PER_INFORMATION30","SEX","MARITAL_STATUS","REHIRE_RECOMMENDATION","ON_MILITARY_SERVICE","FAST_PATH_EMPLOYEE","DATE_EMPLOYEE_DATA_VERIFIED","ATTRIBUTE8" from (
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
					AND TO_DATE('07-DEC-2023','DD-MON-YYYY') BETWEEN papf.effective_start_date AND papf.effective_end_date 
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
					AND trunc(papf.effective_start_date) > TO_DATE('07-DEC-2023','DD-MON-YYYY')
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
                    AND papf.person_type_id = ppt.person_type_id
					AND ppt.person_type_id = pptu.person_type_id
					AND papf.effective_start_date BETWEEN pptu.effective_start_date AND pptu.effective_end_date
					AND ( upper(ppt.user_person_type) = 'APPLICANT'
						AND papf.effective_start_date >= TO_DATE('07-DEC-2023','DD-MON-YYYY')- 90-- trunc(sysdate-90)
						AND papf.effective_end_date > TO_DATE('07-DEC-2023','DD-MON-YYYY')
						)	
                    AND not exists (select 1 from per_all_people_f@xxmx_extract f 
                                    where f.person_id = papf.person_id
                                    and person_type_id <> '1118')
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
)
;
