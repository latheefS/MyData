select DATA_FILE_NAME from xxmx_migration_metadata where business_entity like 'FIXED_ASSETS';

Update xxmx_migration_metadata
set DATA_FILE_NAME = 'PoHeadersInterface.csv' 
where DATA_FILE_NAME = 'PO_HEADERS_INTERFACE.csv';

select * from xxmx_migration_metadata where business_entity like 'FIXED_ASSETS';




Select XFM_TABLE_ID,TABLE_NAME,FUSION_TEMPLATE_NAME,FUSION_TEMPLATE_SHEET_NAME from xxmx_xfm_tables where FUSION_TEMPLATE_NAME like '%.csv%';



Update XXMX_XFM_TABLES
set FUSION_TEMPLATE_NAME = 'GlInterface.csv' , FUSION_TEMPLATE_SHEET_NAME ='GL_INTERFACE'
where xfm_Table_id = 883;


select distinct APPLICATION_SUITE,BUSINESS_ENTITY,SUB_ENTITY,fusion_template_name, xfm_table
from XXMX_XFM_TABLES xt ,XXMX_MIGRATION_METADATA mm
where mm.stg_table is not null
AND mm.enabled_flag = 'Y'
AND mm.metadata_id = xt.metadata_id
AND application = 'AR';



select * from xxmx_fusion_job_definitions where business_entity like 'FIXED_ASSETS';



select METADATA_ID,BUSINESS_ENTITY,SUB_ENTITY,DATA_FILE_NAME from xxmx_migration_metadata where business_entity like 'LEARNING';

Update xxmx_migration_metadata
set DATA_FILE_NAME = 'Prospect' 
where METADATA_ID = 3660;




Select XFM_TABLE_ID,TABLE_NAME,FUSION_TEMPLATE_NAME,FUSION_TEMPLATE_SHEET_NAME from xxmx_xfm_tables where FUSION_TEMPLATE_NAME like '%.dat%';



Update XXMX_XFM_TABLES
set FUSION_TEMPLATE_NAME = 'PjcTxnXfaceStageAll.csv' --,FUSION_TEMPLATE_SHEET_NAME='PJC_TXN_XFACE_STAGE_ALL'
where xfm_Table_id = 1540;




select DATA_FILE_NAME from xxmx_migration_metadata where DATA_FILE_NAME like '%.dat%' ; 







select * from xxmx_xfm_tables where FUSION_TEMPLATE_NAME is null;




select * from xxmx_xfm_tables where table_name like '%XXMX_HZ_CUST_ACCT_SITES_XFM%';

select * from xxmx_xfm_table_columns where XFM_TABLE_ID = 902;



select * from xxmx_module_messages order by 1 desc;




exec xxmx_utilities_pkg.call_fusion_load_gen('FIN','SUPPLIERS','SUPPLIER_ADDRESSES');

Select distinct file_name from xxmx_csv_file_temp where UPPER(file_name) like '%%';


Exec xxmx_fusion_load_gen_pkg.main('FIN','CASH_RECEIPTS','ALL');

------------------------------------------------------------

UPDATE xxmx_stg_tables a
set metadata_id = (SELECT METADATA_ID FROM XXMX_MIGRATION_METADATA WHERE UPPER(STG_TABLE) = a.table_name and STG_TABLE IN ( 'XXMX_HZ_PARTIES_STG',
'XXMX_HZ_PARTY_SITES_STG',
'XXMX_HZ_PARTY_SITE_USES_STG',
'XXMX_HZ_CUST_ACCOUNTS_STG',
'XXMX_HZ_CUST_ACCT_SITES_STG',
'XXMX_HZ_CUST_SITE_USES_STG',
'XXMX_HZ_CUST_PROFILES_STG',
'XXMX_HZ_LOCATIONS_STG',
'XXMX_HZ_RELATIONSHIPS_STG',
'XXMX_HZ_CUST_ACCT_CONTACTS_STG',
'XXMX_HZ_ORG_CONTACTS_STG',
'XXMX_HZ_ORG_CONTACT_ROLES_STG',
'XXMX_HZ_CONTACT_POINTS_STG',
'XXMX_HZ_PERSON_LANGUAGE_STG',
'XXMX_HZ_PARTY_CLASSIFS_STG',
'XXMX_HZ_ROLE_RESPS_STG',
'XXMX_HZ_CUST_ACCT_RELATE_STG',
'XXMX_RA_CUST_RCPT_METHODS_STG',
'XXMX_AR_CUST_BANKS_STG'))
where stg_table_id IN (Select stg_table_id from xxmx_stg_tables where table_name IN ( 'XXMX_HZ_PARTIES_STG',
'XXMX_HZ_PARTY_SITES_STG',
'XXMX_HZ_PARTY_SITE_USES_STG',
'XXMX_HZ_CUST_ACCOUNTS_STG',
'XXMX_HZ_CUST_ACCT_SITES_STG',
'XXMX_HZ_CUST_SITE_USES_STG',
'XXMX_HZ_CUST_PROFILES_STG',
'XXMX_HZ_LOCATIONS_STG',
'XXMX_HZ_RELATIONSHIPS_STG',
'XXMX_HZ_CUST_ACCT_CONTACTS_STG',
'XXMX_HZ_ORG_CONTACTS_STG',
'XXMX_HZ_ORG_CONTACT_ROLES_STG',
'XXMX_HZ_CONTACT_POINTS_STG',
'XXMX_HZ_PERSON_LANGUAGE_STG',
'XXMX_HZ_PARTY_CLASSIFS_STG',
'XXMX_HZ_ROLE_RESPS_STG',
'XXMX_HZ_CUST_ACCT_RELATE_STG',
'XXMX_RA_CUST_RCPT_METHODS_STG',
'XXMX_AR_CUST_BANKS_STG'));

------------------------------------------------------------

Select XFM_TABLE_ID,TABLE_NAME,FUSION_TEMPLATE_NAME,FUSION_TEMPLATE_SHEET_NAME from xxmx_xfm_tables where TABLE_NAME like 'XXMX_AR_TRX_LINES_XFM';

select XFM_TABLE from xxmx_migration_metadata where Business_entity like 'TRANSACTIONS';



select * from xxmx_xfm_tables where TABLE_NAME like 'XXMX_AP_SUPP_BANK_ACCTS_XFM';

select COLUMN_NAME,MANDATORY,INCLUDE_IN_OUTBOUND_FILE from xxmx_xfm_table_columns where XFM_TABLE_ID = 873;

--MANDATORY = 'N', COLUMN_NAME like '%ATTRIBUTE%';

Update xxmx_xfm_table_columns
set  INCLUDE_IN_OUTBOUND_FILE = 'N'
where xfm_Table_id = 873 and  COLUMN_NAME like '%SEGMENT%';--COLUMN_NAME IN ('MIGRATION_SET_ID','MIGRATION_SET_NAME','MIGRATION_STATUS');

select * from xxmx_xfm_tables where XFM_TABLE_ID = 874, 873, 875;


Select XFM_TABLE_ID,TABLE_NAME,FUSION_TEMPLATE_NAME,FUSION_TEMPLATE_SHEET_NAME from xxmx_xfm_tables where TABLE_NAME like '%XXMX_AP_%'; where FUSION_TEMPLATE_NAME like '%.csv%';





select * from xxmx_module_messages order by 1 desc;


Select distinct file_name from xxmx_csv_file_temp where file_name like '%Ra%';


Exec xxmx_fusion_load_gen_pkg.main('FIN','TRANSACTIONS','ALL');

select *
from
dba_scheduler_job_run_details
order by actual_start_date desc

------------------------------------------------------------------
exec XXMX_EXT_TBL_SCRIPT('FIN','AR');

select * from xxmx_migration_metadata where application like 'AR';

select * from all_objects where OBJECT_NAME like '%hz%EXT%' and OBJECT_TYPE like'TABLE';DESC XXMX_AP_SUPPLIERS_STG;

DESC XXMX_AP_SUPP_ADDRS_STG;
DESC XXMX_AP_SUPPLIER_SITES_STG;
DESC XXMX_AP_SUPP_3RD_PTY_RELS_STG;
DESC XXMX_AP_SUPP_CONT_ADDRS_STG;
DESC XXMX_AP_SUPP_CONTACTS_STG;
DESC XXMX_AP_SUPP_SITE_ASSIGNS_STG;
DESC XXMX_AP_SUPP_PAYEES_STG;
DESC XXMX_AP_SUPP_PMT_INSTRS_STG;
DESC XXMX_AP_SUPP_BANK_ACCTS_STG;
DESC xxmx_ap_invoices_stg;
DESC xxmx_ap_invoice_lines_stg;

DESC XXMX_AP_SUPP_ADDRS_EXT;
DESC XXMX_AP_SUPPLIER_SITES_EXT;
DESC XXMX_AP_SUPP_BANK_ACCTS_EXT;
DESC XXMX_AP_SUPP_CONT_ADDRS_EXT;
DESC XXMX_AP_SUPP_PAYEES_EXT;
DESC XXMX_AP_SUPP_PMT_INSTRS_EXT;
DESC XXMX_AP_SUPPLIERS_EXT;
DESC XXMX_AP_SUPP_3RD_PTY_RELS_EXT;
DESC XXMX_AP_SUPP_CONTACTS_EXT;
DESC XXMX_AP_SUPP_SITE_ASSIGNS_EXT;
DESC XXMX_AP_INVOICES_EXT;
DESC XXMX_AP_INVOICE_LINES_EXT;

select * from xxmx_stg_tables where TABLE_NAME like '%XXMX_HZ%';

------------------------------


DeclareBeginUpdate xxmx_xfm_update_columns
set column_name = UPPER(TRIM(column_name))
,table_name = UPPER(TRIM(TABLE_NAME))
,fusion_template_field_name = UPPER(TRIM(fusion_template_field_name))
,fusion_template_sheet_name = UPPER(TRIM(fusion_template_sheet_name));--Update Data Dictionary Tables
xxmx_dynamic_sql_pkg.xfm_update_columns(p_table_name => NULL);END;
/
Commit ;
/

xxmx_dynamic_sql_pkg.xfm_update_columns(p_table_name => NULL); 




Declare

Begin

Update xxmx_xfm_update_columns
set column_name = UPPER(TRIM(column_name))
,table_name = UPPER(TRIM(TABLE_NAME))
,fusion_template_field_name = UPPER(TRIM(fusion_template_field_name))
,fusion_template_sheet_name = UPPER(TRIM(fusion_template_sheet_name));


--Update Data Dictionary Tables
xxmx_dynamic_sql_pkg.xfm_update_columns(p_table_name => NULL);



END;
/
Commit ;
/