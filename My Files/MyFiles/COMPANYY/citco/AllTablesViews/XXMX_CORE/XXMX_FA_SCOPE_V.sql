--------------------------------------------------------
--  DDL for View XXMX_FA_SCOPE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_FA_SCOPE_V" ("ASSET_NUMBER", "ASSET_ID") AS 
  SELECT fab.asset_number, fth.asset_id
     FROM apps.fa_additions_b@xxmx_extract fab,
          apps.fa_transaction_headers@xxmx_extract fth
    WHERE     1 = 1
          AND fab.asset_id = fth.asset_id
          AND fth.transaction_header_id = (SELECT MAX (transaction_header_id)
                                             FROM apps.fa_transaction_headers@xxmx_extract
                                            WHERE asset_id = fth.asset_id)
          AND transaction_type_code NOT IN 'FULL RETIREMENT'
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_FA_SCOPE_V" TO "XXMX_READONLY";
