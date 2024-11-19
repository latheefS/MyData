--xxmx_map_tca_tbl insert script
insert into xxmx_map_tca_tbl (
select stg.table_name,xfm.table_name 
from xxmx_stg_tables stg,xxmx_xfm_tables xfm
where 1=1
and stg.xfm_table_id=xfm.xfm_table_id
and ((stg.table_name like 'XXMX_HZ%') OR (xfm.table_name like'XXMX_ZX%'))
and stg.table_name not in ('XXMX_HZ_CUST_ACCT_RELATE_STG','XXMX_HZ_PARTY_CLASSIFS_STG','XXMX_HZ_PERSON_LANGUAGE_STG')
);