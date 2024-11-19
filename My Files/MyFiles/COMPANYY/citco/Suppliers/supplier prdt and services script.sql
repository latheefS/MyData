-- for STG G1
select * from 
(select migration_set_id as batch_id,'CREATE' AS IMPORT_ACTION,supplier_name,'BROWSING'CATEGORY_TYPE,attribute2 
category_name
from xxmx_ap_suppliers_stg
where migration_set_id = :p_migration_set_id
union
select migration_set_id as batch_id,'CREATE' AS IMPORT_ACTION,supplier_name,'PURCHASING'CATEGORY_TYPE,attribute3 
category_name
from xxmx_ap_suppliers_stg
where migration_set_id= :p_migration_set_id
)
WHERE CATEGORY_name IS NOT NULL
ORDER BY 1,2,3,4,5;


-- for XFM G2
select * from 
(select migration_set_id as batch_id,'CREATE' AS IMPORT_ACTION,supplier_name,'BROWSING'CATEGORY_TYPE,attribute2 
category_name
from xxmx_ap_suppliers_xfm
where migration_set_id =:p_migration_set_id
union
select migration_set_id as batch_id,'CREATE' AS IMPORT_ACTION,supplier_name,'PURCHASING'CATEGORY_TYPE,attribute3 
category_name
from xxmx_ap_suppliers_xfm
where migration_set_id=:p_migration_set_id
)
WHERE CATEGORY_name IS NOT NULL
ORDER BY 1,2,3,4,5