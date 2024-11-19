/************************************
** HCM Metadata (TM) - GOAL PLAN
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_goal_plan_stg'          
         ,'XXMX_HCM_GPLAN_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
---
EXECUTE :vn_SubEntitySeq := :vn_SubEntitySeq + 1;
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_GOAL'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_goal_plan_goal_stg'          
         ,'XXMX_HCM_GPLAN_GP_GOALS_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_GP_GOALS_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_mass_req_stg'          
         ,'XXMX_HCM_GPLAN_MASS_REQ_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_MASS_REQ_XFM'          
         , NULL
         ,'GoalPlan.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);
/
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'ELIGIBILITY_PROFILE_OBJECT'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_eo_prof_stg'          
         ,'XXMX_HCM_GPLAN_EO_PROF_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_EO_PROF_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST_ASSIGNMENT'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_mr_asgn_stg'          
         ,'XXMX_HCM_GPLAN_MR_ASGN_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_MR_ASGN_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST_HIERARCHY'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_mr_hier_stg'          
         ,'XXMX_HCM_GPLAN_MR_HIER_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_MR_HIER_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'MASS_REQUEST_EXEMPTION'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_mr_exem_stg'          
         ,'XXMX_HCM_GPLAN_MR_EXEM_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_MR_EXEM_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_DOC_TYPES'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_dtype_stg'          
         ,'XXMX_HCM_GPLAN_DTYPE_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_DTYPE_XFM'          
         , NULL
         ,'GoalPlan.dat'
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
         ,'GOAL_PLAN'
         ,:vn_SubEntitySeq
         ,'GOAL_PLAN_ASSIGNMENT'
         ,'xxmx_hcm_goal_plan_pkg'
         , NULL
         ,'hcm_gplan_asgn_stg'          
         ,'XXMX_HCM_GPLAN_ASGN_STG'
         , NULL
         ,'XXMX_HCM_GPLAN_ASGN_XFM'          
         , NULL
         ,'GoalPlan.dat'
         ,'dat'
         ,1
         ,'Y'
         ,NULL
         ,NULL
         ,NULL
         ,NULL
         ,NULL
		);