--------------------------------------------------------
--  DDL for View XXMX_PPM_CREATE_ACC_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_CREATE_ACC_V" ("NAME", "FUSION_VALUE") AS 
  select a.name, b.fusion_value from gl_ledgers@xxmx_Extract a, xxmx_simple_Transforms b
     where category_code = 'LEDGER_ID'
    --and name like '%Lux%'
     and b.source_Value =  a.ledger_id
--     and exists ( select 1 from XXMX_PPM_CREATE_ACC c where c.fusion_Value = b.fusion_value
--                    and rown between 51 and 60)
--
;
