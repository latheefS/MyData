/*********************************
** FIN Metadata (GL) - DAILY RATES
*********************************/
--
/*
** GL Daily Rates
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
          xxmx_migration_metadata_ids_s.NEXTVAL 	
         ,'FIN'                                 	
         ,'GL'                                  	
         ,:vn_BusinessEntitySeq                     
         ,'DAILY_RATES'                        	
         ,:vn_SubEntitySeq                          
         ,'DAILY_RATES'                  		
         ,'xxmx_gl_daily_rates_pkg'               	 			
         ,NULL                                  	
         ,'export_gl_daily_rates'             		
         ,'XXMX_GL_DAILY_RATES_STG'             
         ,NULL                                  	
         ,'XXMX_GL_DAILY_RATES_XFM'             
         ,NULL                           					
         ,'GlDailyRatesInterface'                      							
         ,'csv'                                 	
         ,1                                     	
         ,'Y'                                   	
		 ,NULL                                   	
		 ,NULL                                  	
		 ,NULL                                   	
         );
