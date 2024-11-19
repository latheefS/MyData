--
/*********************************************************************************/
--
/*******************
** FIN Metadata (FA)
********************/
--
/*
** FA Mass Additions 
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

         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 	-- metadata_id
         ,'FIN'                                 	-- application_suite
         ,'FA'                                  	-- application
         ,:vn_BusinessEntitySeq                     -- business_entity_seq
         ,'PURCHASE_ORDERS'                        	-- business_entity
         ,:vn_SubEntitySeq                          -- sub_entity_seq
         ,'PO_HEADERS_STD'                  		-- sub_entity
         ,'XXMX_PO_HEADERS_PKG'               	 	-- entity_package_name		
         ,NULL                                  	-- sql_load_name
         ,'export_po_headers_std'             		-- stg_procedure_name
         ,'XXMX_SCM_PO_HEADERS_STD_STG'             -- stg_table
         ,NULL                                  	-- xfm_procedure_name
         ,'XXMX_SCM_PO_HEADERS_STD_XFM'             -- xfm_table
         ,NULL                           			-- file_gen_procedure_name		
         ,NULL                      				-- data_file_name			
         ,'csv'                                 	-- data_file_extension
         ,1                                     	-- file_group_number
         ,'Y'                                   	-- enabled_flag
		 ,NULL                                   	-- simple_xfm_performed_by
		 ,NULL                                  	-- file_gen_performed_by
		 ,NULL                                   	-- file_gen_package
         );
--
/*
** FA Mass Addition Distributions
*/
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

         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 	-- metadata_id
         ,'SCM'                                 	-- application_suite
         ,'PO'                                  	-- application
         ,:vn_BusinessEntitySeq                     -- business_entity_seq
         ,'PURCHASE_ORDERS'                        	-- business_entity
         ,:vn_SubEntitySeq                          -- sub_entity_seq
         ,'PO_LINES_STD'                  			-- sub_entity
         ,'XXMX_PO_HEADERS_PKG'               	 	-- entity_package_name		
         ,NULL                                  	-- sql_load_name
         ,'export_po_lines_std'             		-- stg_procedure_name
         ,'XXMX_SCM_PO_LINES_STD_STG'             	-- stg_table
         ,NULL                                  	-- xfm_procedure_name
         ,'XXMX_SCM_PO_LINES_STD_XFM'               -- xfm_table
         ,NULL                           			-- file_gen_procedure_name		
         ,NULL                      				-- data_file_name			
         ,'csv'                                 	-- data_file_extension
         ,1                                     	-- file_group_number
         ,'Y'                                   	-- enabled_flag
		 ,NULL                                   	-- simple_xfm_performed_by
		 ,NULL                                  	-- file_gen_performed_by
		 ,NULL                                   	-- file_gen_package
         );
--
/*
** FA Mass Rates
*/
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

         )
VALUES
         (
          xxmx_migration_metadata_ids_s.NEXTVAL 	-- metadata_id
         ,'SCM'                                 	-- application_suite
         ,'PO'                                  	-- application
         ,:vn_BusinessEntitySeq                     -- business_entity_seq
         ,'PURCHASE_ORDERS'                        	-- business_entity
         ,:vn_SubEntitySeq                          -- sub_entity_seq
         ,'PO_LINE_LOCATIONS_STD'                  	-- sub_entity
         ,'XXMX_PO_HEADERS_PKG'               	 	-- entity_package_name		
         ,NULL                                  	-- sql_load_name
         ,'export_po_line_locations_std'            -- stg_procedure_name
         ,'XXMX_SCM_PO_LINE_LOCATIONS_STD_STG'      -- stg_table
         ,NULL                                  	-- xfm_procedure_name
         ,'XXMX_SCM_PO_LINE_LOCATIONS_STD_XFM'      -- xfm_table
         ,NULL                           			-- file_gen_procedure_name		
         ,NULL                      				-- data_file_name			
         ,'csv'                                 	-- data_file_extension
         ,1                                     	-- file_group_number
         ,'Y'                                   	-- enabled_flag
		 ,NULL                                   	-- simple_xfm_performed_by
		 ,NULL                                  	-- file_gen_performed_by
		 ,NULL                                   	-- file_gen_package
         );