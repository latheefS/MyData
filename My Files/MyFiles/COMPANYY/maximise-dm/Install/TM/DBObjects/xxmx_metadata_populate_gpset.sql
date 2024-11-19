/************************************
** HCM Metadata (TM) - GOAL PLAN SET
************************************/
EXECUTE :vn_BusinessEntitySeq := :vn_BusinessEntitySeq + 1;
EXECUTE :vn_SubEntitySeq := 0;
--
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
--
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_SET'
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gplan_set_stg'          
         ,'XXMX_HCM_GPSET_STG'
         , NULL
         ,'XXMX_HCM_GPSET_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);

---
---
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
---
---
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_SET_PLAN '
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gplan_set_plan_stg'          
         ,'XXMX_HCM_GPSET_PLAN_STG'
         , NULL
         ,'XXMX_HCM_GPSET_PLAN_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
--
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
--
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST'
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gpset_mass_request_stg'          
         ,'XXMX_HCM_GPSET_MASS_REQ_STG'
         , NULL
         ,'XXMX_HCM_GPSET_MASS_REQ_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
--
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
--
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'ELIGIBILITY_PROFILE_OBJECT'
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gpset_epo_stg'          
         ,'XXMX_HCM_GPSET_EO_PROF_STG'
         , NULL
         ,'XXMX_HCM_GPSET_EO_PROF_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
--
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
--
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST_HIERARCHY'
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gpset_mrh_stg'          
         ,'XXMX_HCM_GPSET_MR_HIER_STG'
         , NULL
         ,'XXMX_HCM_GPSET_MR_HIER_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
--
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
--
INSERT
INTO   xxmx_core.xxmx_migration_metadata
         (
         metadata_id
		,application_suite
		,application
		,business_entity_seq
		,business_entity
		,sub_entity_seq
		,sub_entity
		,entity_package_name
		,sql_load_name
		,stg_procedure_name
		,stg_table
		,xfm_procedure_name
		,xfm_table
		,file_gen_procedure_name
		,data_file_name
		,data_file_extension
		,file_group_number
		,enabled_flag
		,simple_xfm_performed_by
		,file_gen_performed_by
		,file_gen_package
		,batch_load
		,seq_in_fbdi_data
		 )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL
         ,'HCM'
         ,'TM'
         ,:vn_BusinessEntitySeq
         ,'GOAL_PLAN_SET'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST_EXEMPTION'
         ,'xxmx_hcm_goal_plan_set_pkg'
         , NULL
         ,'hcm_gpset_mre_stg'          
         ,'XXMX_HCM_GPSET_MR_EXEM_STG'
         , NULL
         ,'XXMX_HCM_GPSET_MR_EXEM_XFM'          
         , NULL
         ,'GoalPlanSet.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
--
--
