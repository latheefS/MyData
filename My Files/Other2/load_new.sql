begin

XXMX_FUSION_LOAD_GEN_PKG.generate_csv_file
                    (
                     pt_i_MigrationSetID             => 839
                    ,pt_i_FileSetID                  => NULL
                    ,pt_i_BusinessEntity             => 'PURCHASE_ORDERS'
                    ,pt_i_FileName                   => 'PO_HEADERS_INTERFACE.csv'
                   );
end;


select * from xxmx_scm_po_headers_std_stg;

select * from xxmx_scm_po_headers_std_xfm;

select * from xxmx_xfm_tables where TABLE_NAME like '%XXMX_SCM_PO%';

select * from xxmx_lookup_values where LOOKUP_TYPE like 'BUSINESS_ENTITIES';

select * from xxmx_xfm_table_columns where xfm_table_id = 1446;

update xxmx_xfm_table_columns
set MANDATORY = 'N'
where xfm_table_id = 1446;




SELECT *
          --INTO   gvn_ExistenceCheckCount
          FROM   xxmx_lookup_types  xlt
          WHERE  1 = 1
          AND    xlt.lookup_type = 'BUSINESS_ENTITIES';
          
          SELECT *
               FROM   xxmx_lookup_values  xlv
               WHERE  1 = 1
               AND    xlv.lookup_type            = 'BUSINESS_ENTITIES'
               AND    xlv.lookup_code            = 'PURCHASE_ORDERS'
               AND    NVL(xlv.enabled_flag, 'N') = 'Y';
               
select * from xxmx_module_messages order by 1 desc;  

			 
delete from xxmx_migration_metadata where application like 'PO' and APPLICATION_SUITE like 'FIN' ;

select * from xxmx_migration_metadata where application like 'PO';

select * from xxmx_scm_po_headers_std_xfm;

select * from dba_directories;

drop DIRECTORY HCM_BENEFITS;

CREATE or REPLACE DIRECTORY PO_STD AS '/home/oracle/scm/po/purchase_orders1/output/';
/scm/po/purchase_orders1/output
grant all on DIRECTORY PO_STD to xxmx_core;

select * from xxmx_file_locations where application like 'PO';
delete from xxmx_file_locations where APPLICATION_SUITE like 'FIN'and application like 'PO';

update xxmx_file_locations
set FILE_LOCATION = replace (FILE_LOCATION,'fin','scm')
where APPLICATION_SUITE like 'SCM'and application like 'PO';


grant all on DIRECTORY PO_STD to xxmx_core; --in stg schema			 
			 
			 
			 
			 

select * from xxmx_xfm_tables where TABLE_NAME like '%XXMX_SCM_PO%';

select * from xxmx_xfm_table_columns where xfm_table_id = 1446;

update xxmx_xfm_table_columns
set MANDATORY = 'N'
where xfm_table_id = 1446
and COLUMN_NAME = 'PAY_ON_CODE';


update xxmx_xfm_table_columns
set MANDATORY = 'N'
where xfm_table_id = 1449
and COLUMN_NAME in ('INTERFACE_DISTRIBUTION_KEY',
'INTERFACE_LINE_LOCATION_KEY',
'DISTRIBUTION_NUM',
'DELIVER_TO_LOCATION',
'DELIVER_TO_PERSON_FULL_NAME',
'DESTINATION_CONTEXT',
'PROJECT',
'TASK',
'PJC_EXPENDITURE_ITEM_DATE',
'EXPENDITURE_TYPE',
'EXPENDITURE_ORGANIZATION',
'RATE',
'RATE_DATE');			 


 SELECT directory_name
                    INTO vv_file_dir
                    from all_directories
                    WHERE directory_path like '%'||pv_i_directory_name||'%';
					
					
select * from XXMX_FILE_LOCATIONS where APPLICATION_SUITE like 'FIN' and application like 'GL' and BUSINESS_ENTITY like 'GENERAL_LEDGER';

update XXMX_FILE_LOCATIONS
set USED_BY = 'PLSQL'
where FILE_LOCATION_TYPE = 'FTP_OUTPUT' and application_suite like 'FIN' and application like 'GL' and BUSINESS_ENTITY like 'GENERAL_LEDGER';


select * from dba_directories where directory_path = '/home/oracle/fin/gl/general_ledger1/output';
					
sudo su - root
cd /home/root
mv file /home/opc
chown file


select * from XXMX_CSV_FILE_TEMP;

Select * from xxmx_csv_file_temp where file_name like 'FA_MASS%' and line_type = 'File Header';

Select * from xxmx_csv_file_temp where file_name like 'FA_MASS%' and line_type = 'File Detail';					