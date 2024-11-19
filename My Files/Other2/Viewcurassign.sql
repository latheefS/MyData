
CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_HCM_CURRENT_ASG_SCOPE_V"
as
SELECT * FROM (
-- current_assignment
-- future assignment CHANGE
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
        xxmx_hcm_current_person_mv          		person,
        per_assignment_status_types@XXMX_EXTRACT 	per_assignment_status_types
    WHERE
        per_all_assignments_f.assignment_type = 'E'  
    AND ( per_periods_of_service.actual_termination_date IS NULL
             OR per_periods_of_service.actual_termination_date > TO_DATE('30-NOV-2021','DD-MON-YYYY'))   --Added on 27Apr2022
    AND per_all_assignments_f.primary_flag = 'Y'
    AND per_periods_of_service.person_id = per_all_assignments_f.person_id
    AND per_periods_of_service.period_of_service_id = nvl(per_all_assignments_f.period_of_service_id, per_periods_of_service.period_of_service_id)
    AND personstg.person_id = per_all_assignments_f.person_id
    AND personstg.person_id = person.person_id
    AND per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
    AND person.system_person_type 				  IN ( Select parameter_value 
														from xxmx_migration_parameters 
														where application = 'HR' 
														and parameter_code = 'PERSON_TYPE'
														and enabled_flag = 'Y')
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
    AND per_all_assignments_f.business_group_id   IN ( Select parameter_value 
														from xxmx_migration_parameters 
														where application = 'HR' 
														and parameter_code = 'BUSINESS_GROUP_ID'
														and enabled_flag = 'Y')
    /*AND (  
		 (
		 --trunc(sysdate) BETWEEN per_all_assignments_f.effective_start_date AND per_all_assignments_f.effective_end_date)
		 '30-NOV-21' BETWEEN per_all_assignments_f.effective_start_date AND per_all_assignments_f.effective_end_date)
		-- OR (trunc(per_all_assignments_f.effective_start_date) > trunc(sysdate))
		)*/
		
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
        per_all_assignments_f@MXDM_NVIS_EXTRACT  per_all_assignments_f,
        per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement,
        xxmx_per_persons_stg                personstg,
        xxmx_hcm_current_person_mv          person,
        per_assignment_status_types@XXMX_EXTRACT per_assignment_status_types
    WHERE
        per_all_assignments_f.assignment_type = 'C'
    AND ( per_periods_of_placement.actual_termination_date IS NULL
              OR per_periods_of_placement.actual_termination_date > TO_DATE('30-NOV-2021','DD-MON-YYYY'))  -- Added on 27Apr22
    AND per_all_assignments_f.primary_flag = 'Y'          
    AND personstg.person_id = per_all_assignments_f.person_id
    AND personstg.person_id = person.person_id
    AND per_periods_of_placement.person_id = per_all_assignments_f.person_id
    AND person.system_person_type 				  IN ( Select parameter_value 
														from xxmx_migration_parameters 
														where application = 'HR' 
														and parameter_code = 'PERSON_TYPE'
														and enabled_flag = 'Y')
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
	AND per_all_assignments_f.business_group_id   IN ( Select parameter_value 
														from xxmx_migration_parameters 
														where application = 'HR' 
														and parameter_code = 'BUSINESS_GROUP_ID'
														and enabled_flag = 'Y')
    /*AND (  
		 (
		 --trunc(sysdate) BETWEEN per_all_assignments_f.effective_start_date AND per_all_assignments_f.effective_end_date)
		 '30-NOV-21' BETWEEN per_all_assignments_f.effective_start_date AND per_all_assignments_f.effective_end_date)
		-- OR (trunc(per_all_assignments_f.effective_start_date) > trunc(sysdate))
		)*/	
    --AND   per_periods_of_placement.actual_termination_date IS NULL          -- Commented on 27Apr22		
);
/