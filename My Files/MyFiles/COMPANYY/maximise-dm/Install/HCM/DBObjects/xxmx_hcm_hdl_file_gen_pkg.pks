create or replace PACKAGE xxmx_hcm_hdl_file_gen_pkg
AS
     --
     --//===============================================================================
     --// 
     --// $Id:$
     --//===============================================================================
     --// Object Name        :: xxmx_hcm_hdl_file_gen_pkg
     --//
     --// Object Type        :: Package Specification
     --//
     --// Object Description :: This package contains procedures for generating HCM 
     --//                            components for person Migration
     --//
     --//
     --// Version Control
     --//===============================================================================
     --// Version      Author               Date               Description
     --//-------------------------------------------------------------------------------
     --// 1.0          Jay McNeill          11/11/2020          Initial Build
     --//===============================================================================
     --
     --
     /**********************************
     ** FUNCTION: 
     **********************************/
     --
     --

     /*****************************************
     ** PROCEDURE: gen_worker_hire_file
     ******************************************/
	PROCEDURE gen_worker_hire_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    );	

     /*****************************************
     ** PROCEDURE: gen_worker_current_file
     ******************************************/
	PROCEDURE gen_worker_current_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    );	

     /*****************************************
     ** PROCEDURE: gen_worker_termination_file
     ******************************************/
	PROCEDURE gen_worker_termination_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE
                    );	

     /*****************************************
     ** PROCEDURE: gen_bank_file
     ******************************************/
	PROCEDURE gen_bank_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_bank_branches_file
     ******************************************/
	PROCEDURE gen_bank_branches_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_work_assign_superv_file
     ******************************************/
	PROCEDURE gen_work_assign_superv_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_extern_bank_acct_file
     ******************************************/
	PROCEDURE gen_extern_bank_acct_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_per_pay_method_file
     ******************************************/
	PROCEDURE gen_per_pay_method_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_assigned_payroll_file
     ******************************************/
	PROCEDURE gen_assigned_payroll_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_salary_file
     ******************************************/
	PROCEDURE gen_salary_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_contacts_file
     ******************************************/
     PROCEDURE gen_contacts_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_assignment_add_file
     ******************************************/
	PROCEDURE gen_assignment_add_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                   );

     /*****************************************
     ** PROCEDURE: gen_third_party_per_paym_file
     ******************************************/
	PROCEDURE gen_third_party_per_paym_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_third_party_org_paym_file
     ******************************************/
	PROCEDURE gen_third_party_org_paym_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );	

     /*****************************************
     ** PROCEDURE: gen_main
     ******************************************/
     PROCEDURE gen_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
                    
      PROCEDURE gen_abs_maternity_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );                    
      PROCEDURE gen_tal_prf_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );
                    
      PROCEDURE gen_images_file
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileName                   IN      xxmx_migration_metadata.data_file_name%TYPE                    
                    );

END xxmx_hcm_hdl_file_gen_pkg;
/