/******************
** ZX CUSTOMERS TAX
******************/
--
/*
** ZX Customer Party Tax Profile
*/
--
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
         ,simple_xfm_performed_by
         ,xfm_procedure_name
         ,xfm_table
         ,file_gen_performed_by
         ,file_gen_procedure_name
         ,data_file_name
         ,data_file_extension
         ,file_group_number
         ,enabled_flag
         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 
         ,'FIN'                                 
         ,'ZX'                                  
         ,:vn_BusinessEntitySeq                 
         ,'CUSTOMERS_TAX'                           
         ,:vn_SubEntitySeq                      
         ,'TAX_PROFILE'                             
         ,'xxmx_customer_tax_profile_pkg'               
         ,NULL                                  
         ,'party_tax_profile_stg'                      
         ,'XXMX_ZX_TAX_PROFILE_STG'                 
         ,'OIC'                                 
         ,NULL                      
         ,'XXMX_ZX_TAX_PROFILE_XFM'                 
         ,NULL                                 
         ,NULL                      
         ,'PartyTaxProfileControls'                     
         ,'csv'                                 
         ,1                                    
         ,'Y'                                   
         );
--
--** ZX Customer Tax Registrations
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
         ,simple_xfm_performed_by
         ,xfm_procedure_name
         ,xfm_table
         ,file_gen_performed_by
         ,file_gen_procedure_name
         ,data_file_name
         ,data_file_extension
         ,file_group_number
         ,enabled_flag
         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 
         ,'FIN'                                 
         ,'ZX'                                  
         ,:vn_BusinessEntitySeq                 
         ,'CUSTOMERS_TAX'                           
         ,:vn_SubEntitySeq                      
         ,'TAX_REGISTRATION'                             
         ,'xxmx_customer_tax_profile_pkg'               
         ,NULL                                  
         ,'party_tax_profile_stg'                      
         ,'XXMX_ZX_TAX_REGISTRATION_STG'                 
         ,'OIC'                                 
         ,NULL                      
         ,'XXMX_ZX_TAX_REGISTRATION_XFM'                 
         ,NULL                                 
         ,NULL                      
         ,'TaxRegistrations'                     
         ,'csv'                                 
         ,1                                    
         ,'Y'                                   
         );
--
--** ZX Customer Party Classifications
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
         ,simple_xfm_performed_by
         ,xfm_procedure_name
         ,xfm_table
         ,file_gen_performed_by
         ,file_gen_procedure_name
         ,data_file_name
         ,data_file_extension
         ,file_group_number
         ,enabled_flag
         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 
         ,'FIN'                                 
         ,'ZX'                                  
         ,:vn_BusinessEntitySeq                 
         ,'CUSTOMERS_TAX'                           
         ,:vn_SubEntitySeq                      
         ,'PARTY_CLASSIFIC'                             
         ,'xxmx_customer_tax_profile_pkg'               
         ,NULL                                  
         ,'party_tax_profile_stg'                      
         ,'XXMX_ZX_PARTY_CLASSIFIC_STG'                 
         ,'OIC'                                 
         ,NULL                      
         ,'XXMX_ZX_PARTY_CLASSIFIC_XFM'                 
         ,NULL                                 
         ,NULL                      
         ,'PartyClassifications'                     
         ,'csv'                                 
         ,1                                    
         ,'Y'                                   
         );