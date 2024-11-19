
  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_FA_SCOPE_V" ("ASSET_NUMBER", "ASSET_ID") AS 
  select 	fab.asset_number, 
		fth.asset_id 
from 
		apps.fa_additions_b@xxmx_extract fab,
		apps.fa_transaction_headers@xxmx_extract fth
where 	1=1
and		fab.asset_id = fth.asset_id
and 	fth.transaction_header_id 	= 
(
	select max (transaction_header_id) 
	from apps.fa_transaction_headers@xxmx_extract
	where  asset_id = fth.asset_id
)
and 	transaction_type_code not in 'FULL RETIREMENT';


  GRANT SELECT ON "XXMX_CORE"."XXMX_FA_SCOPE_V" TO "XXMX_READONLY";
