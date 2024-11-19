UPDATE XXMX_XFM_TABLES


SET COMMON_LOAD_COLUMN = 'USER_CONVERSION_TYPE'


WHERE TABLE_NAME IN ('XXMX_GL_DAILY_RATES_XFM');


exec xxmx_gl_daily_rates_pkg.stg_main ('MXM','TST110322');


Begin



XXMX_FIN_STG_EXTRACT_PKG.stg_main
(
pt_i_BusinessEntity => 'DAILY_RATES'
,pt_i_FileSetID => 0
,pt_iteration => 'SIT'
);

END;


select * from xxmx_migration_metadata where application like 'GL';

select * from xxmx_migration_parameters where application like 'GL';

select COMMON_LOAD_COLUMN from XXMX_XFM_TABLES


desc XXMX_GL_DAILY_RATES_XFM;

select * from  XXMX_GL_DAILY_RATES_XFM;

select * from  XXMX_GL_DAILY_RATES_STG;

select * from xxmx_dm_file_batch;

select * from xxmx_csv_file_temp where FILE_NAME like '%Daily%';


select * from XXMX_FILE_LOCATIONS where application like 'GL' and BUSINESS_ENTITY like 'DAILY_RATES';

select * from dba_directories where DIRECTORY_NAME like 'DAILY%';

exec XXMX_UTILITIES_PKG.xxmx_write_dbcs('DAILY_RATES');

select distinct SEQUENCEBATCH from xxmx_dm_file_batch where TABLENAME like 'XXMX_GL_DAILY_RATES_STG';

drop table XXMX_XFM.XXMX_GL_DAILY_RATES_XFM_ARCH;

select * from XXMX_GL_DAILY_RATES_XFM_ARCH;

select * from xxmx_module_messages order by 1 desc;

select * from xxmx_xfm_tables where table_name like '%GL_DAILY%';
select * from xxmx_xfm_table_columns where xfm_table_id = 1747;

update xxmx_xfm_table_columns
set INCLUDE_IN_OUTBOUND_FILE = 'Y'
where XFM_TABLE_ID = 1747;

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'GL',
pt_i_BusinessEntity=> 'DAILY_RATES',
pt_i_SubEntity=> 'DAILY_RATES',
pt_import_data_file_name => 'XXMX_GL_DAILY_RATES.csv',
pt_control_file_name => 'XXMX_GL_DAILY_RATES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/