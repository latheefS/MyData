--------------------------------------------------------
--  DDL for View XXMX_PPM_INV_BATCH_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_INV_BATCH_V" ("BATCHNAME", "INV_COUNT") AS 
  SELECT batchname,count(distinct inv_number) inv_count
    FROM (
    select exp_batch_name BATCHNAME, attribute3 inv_number from XXMX_PPM_prj_LBRCOST_xfm where exp_batch_name like 'OPEN_AR%'
    and attribute3 is not null    
    union
    select  exp_batch_name, attribute3 from XXMX_PPM_prj_miscCOST_xfm where exp_batch_name like 'OPEN_AR%'
    and attribute3 is not null
    union
    select attribute10,attribute6 from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'OPEN_AR%'
    and attribute6 is not null
    union
    select attribute10,attribute6 from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'CLOSED_AR%'
    and attribute6 is not null
    )
    group by batchname
;
