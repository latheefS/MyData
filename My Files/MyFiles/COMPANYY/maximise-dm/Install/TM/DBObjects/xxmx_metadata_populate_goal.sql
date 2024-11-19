/************************************
** HCM Metadata (TM) - GOAL 
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_stg'          
         ,'XXMX_HCM_GOAL_STG'
         , NULL
         ,'XXMX_HCM_GOAL_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_ACCESS'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_access_stg'          
         ,'XXMX_HCM_GOAL_ACCESS_STG'
         , NULL
         ,'XXMX_HCM_GOAL_ACCESS_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_ACTION'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_action_stg'          
         ,'XXMX_HCM_GOAL_ACTION_STG'
         , NULL
         ,'XXMX_HCM_GOAL_ACTION_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_ALIGNMENT'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_alignment_stg'          
         ,'XXMX_HCM_GOAL_ALIGNMENT_STG'
         , NULL
         ,'XXMX_HCM_GOAL_ALIGNMENT_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_MEASUREMENT'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_measurement_stg'          
         ,'XXMX_HCM_GOAL_MEASUREMENT_STG'
         , NULL
         ,'XXMX_HCM_GOAL_MEASUREMENT_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_GOAL'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_goal_plan_goal_stg'          
         ,'XXMX_HCM_GOAL_PLAN_GOAL_STG'
         , NULL
         ,'XXMX_HCM_GOAL_PLAN_GOAL_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_TARGET_OUTCOME'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_gtarget_outcme_stg'          
         ,'XXMX_HCM_GTARGET_OUTCOME_STG'
         , NULL
         ,'XXMX_HCM_GTARGET_OUTCOME_XFM'          
         , NULL
         ,'Goal.dat'
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
         ,'GOAL'
         ,:vn_SubEntitySeq
         ,'GOAL_TARGET_OUTCOME_PROFILE_ITEM'
         ,'xxmx_hcm_goal_pkg'
         , NULL
         ,'hcm_gtargt_outcme_profile_stg'          
         ,'XXMX_HCM_GTARGT_OUTCME_PROFILE_ITM_STG'
         , NULL
         ,'XXMX_HCM_GTARGT_OUTCME_PROFILE_ITM_XFM'          
         , NULL
         ,'Goal.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);