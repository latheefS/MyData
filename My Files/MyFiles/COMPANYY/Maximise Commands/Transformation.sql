--Populating Metadata
-----------------------

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
         ,41                                 		-- business_entity_seq
         ,'FIXED_ASSETS'                        	-- business_entity
         ,1                                   		-- sub_entity_seq
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






Populate XFM tables:
--------------------


DECLARE



pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_STD',
pt_fusion_template_name=> 'FA_MASS_ADDITIONS.csv',
pt_fusion_template_sheet_name => 'FA_MASS_ADDITIONS',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);



END ;
/


Populate STG tables:
--------------------


DECLARE



pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PO',
pt_i_BusinessEntity=> 'PURCHASE_ORDERS',
pt_i_SubEntity=> 'PO_HEADERS_STD',
pt_import_data_file_name => 'XXMX_FA_MASS_ADDITIONS.dat',
pt_control_file_name => 'XXMX_FA_MASS_ADDITIONS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);



END ;
/


--Commands to check data--
-----------------------------

select * from xxmx_xfm_tables where table_name like '%XXMX_SCM_PO%' order by 1 asc;

select * from xxmx_xfm_table_columns where XFM_TABLE_ID = 1447 order by 1 asc;
select * from xxmx_xfm_table_columns where xfm_table_id =139 order by XFM_COLUMN_SEQ;


select * from xxmx_stg_tables where table_name like '%XXMX_SCM_PO%' order by 1 asc;

select * from xxmx_stg_table_columns where STG_TABLE_ID = 1599 order by STG_COLUMN_SEQ asc;

--------------------------------------------------------------------------

update xxmx_xfm_tables
set FIELD_DELIMITER = '|'
where XFM_TABLE_ID = 1453;

update xxmx_stg_tables
set CONTROL_FILE_DELIMITER = ','
where STG_TABLE_ID = 1605;

--------------------------------------------------------------------------

--Query to extract the data from tables to update 

select  MANDATORY,
        INCLUDE_IN_CONTROL_FILE,
        COLUMN_NAME
        --TABLE_NAME
       -- APPL_NAME
from    xxmx_stg_table_columns where STG_TABLE_ID = 1599 order by STG_COLUMN_SEQ asc;

-- Perform updation in Excel sheet and import them to respective tables  xxmx_xfm_update_columns and xxmx_stg_update_columns and execute them.

/*Upating the data dictionary tables:*/
-------------------------------------
execute xxmx_dynamic_sql_pkg.xfm_update_columns('xxmx_xfm_update_columns');
select * from xxmx_xfm_update_columns;
exec xfm_update_columns;


select * from xxmx_stg_update_columns;
exec stg_update_columns;

--------------------------------------------------------------------------

--Generate CTL

DECLARE



pv_o_ReturnStatus VARCHAR2(3000);
BEGIN



xxmx_dynamic_sql_pkg.generate_ctl( 
 pt_i_ApplicationSuite => 'SCM'
,pt_i_Application => 'PO'
,pt_i_BusinessEntity => 'PURCHASE_ORDERS'
,pt_i_SubEntity => 'PO_HEADERS_STD'
,pt_i_FileSetID => 0
,pv_o_ReturnStatus => pv_o_ReturnStatus);



END ;
/

--------------------------------------------------------------------------


--Simple Mapping--

select * from xxmx_simple_transforms;

INSERT INTO xxmx_simple_transforms
VALUES('SCM','PO','LINE_TYPE','Goods','GDS','NULL','LINE_TYPE1');
/

--------------------------------------------------------------------------
--iNSERT INTO LOOKUP VALUES-------
select * from xxmx_lookup_values where lookup_type like 'BUSINESS_ENTITIES';

insert into xxmx_lookup_values
values('XXMX','BUSINESS_ENTITIES','GENERAL_LEDGER','GL Journal','','Y','Y','');

--------------------------------------------------------------------------

--	Transformation

Begin



XXMX_FIN_STG_EXTRACT_PKG.xfm_main
(
pt_i_BusinessEntity => 'PURCHASE_ORDERS'
,pt_i_FileSetID => 0
,pt_i_MigrationSetID => 843
);

END;

--------------------------------------------------------------------------
--	To check log messages

select * from XXMX_MODULE_MESSAGES order by 1 desc;

--------------------------------------------------------------------------

select BUSINESS_ENTITY from xxmx_migration_metadata minus select BUSINESS_ENTITY from new_meta;

select SUB_ENTITY from xxmx_migration_metadata minus select SUB_ENTITY from new_meta;



xxmx_migration_headers
xxmx_migration_lines




--->

Declare



Begin



UPDATE xxmx_xfm_update_columns
SET COLUMN_NAME = UPPER(TRIM(COLUMN_NAME))
,TABLE_NAME = UPPER(TRIM(TABLE_NAME))
,Fusion_template_field_name= TRIM(Fusion_template_field_name);



--Update Data Dictionary Tables
xxmx_dynamic_sql_pkg.xfm_update_columns(p_table_name => NULL);              



END;
/
Commit ;
/