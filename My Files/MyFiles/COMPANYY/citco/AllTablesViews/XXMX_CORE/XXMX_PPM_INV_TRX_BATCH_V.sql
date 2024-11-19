--------------------------------------------------------
--  DDL for View XXMX_PPM_INV_TRX_BATCH_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_INV_TRX_BATCH_V" ("BATCHNAME", "TRX_TYPE", "TRX_COUNT", "INV_COUNT") AS 
  select trx_inv."BATCHNAME",trx_inv.trx_type, trx_inv."TRX_COUNT",trx_inv."INV_COUNT" FROM (
  with trx as (  
  select  batchname ,trx_type,sum(count_) TRX_COUNT --,sum(inv_count) INV_COUNT
   from (
    select  exp_batch_name BATCHNAME,'OPENAR_LBR_COST' trx_type, count(*) count_ from XXMX_PPM_prj_LBRCOST_xfm where exp_batch_name like 'OPEN_AR%'
    and attribute3 is not null 
    group by exp_batch_name
    union
    select exp_batch_name, 'OPENAR_MISC_COST' trx_type, count(*) count_  from XXMX_PPM_prj_miscCOST_xfm where exp_batch_name like 'OPEN_AR%'
    and attribute3 is not null
    group by exp_batch_name
    union
    select attribute10,'EVENTS_OPEN_AR',count(*) count_  from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'OPEN_AR%'
    and attribute6 is not null
    group by attribute10
    union
    select attribute10,'EVENTS_CLOSED_AR',count(*) count_ from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'CLOSED_AR%'
    and attribute6 is not null
     group by attribute10
    union
     select  exp_batch_name BATCHNAME,'UNBILLED_LBR_COST',count(*) count_ from XXMX_PPM_prj_LBRCOST_xfm where exp_batch_name like 'UNBILLED%'
    and attribute3 is  null 
    group by exp_batch_name
    union
    select exp_batch_name, 'UNBILLED_MISC_COST',count(*) count_  from XXMX_PPM_prj_miscCOST_xfm where exp_batch_name like 'UNBILLED%'
    and attribute3 is  null
    group by exp_batch_name
    union
    select attribute10,'UNBILLED_EVENTS',count(*) count_  from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'UNBILLED%'
    and attribute6 is  null
    group by attribute10
    union       
    select attribute10,'REVENUE',count(*) count_  from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'REVENUE%'
    and attribute6 is  null
    group by attribute10
    UNION
    select attribute10,'CLOSED_AR_REVENUE',count(*) count_  from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'CLOSED%REVENUE%'
    and attribute6 is  null
    group by attribute10
    union       
    select attribute10,'REVACC',count(*) count_  from XXMX_PPM_prj_BILLEVENT_xfm where attribute10 like 'REVACC%'
    and attribute6 is  null
    group by attribute10
     )
     group by batchname,trx_type
     ),
      inv as (select * from   XXMX_PPM_INV_BATCH_V )
    select trx.batchname,trx.trx_type, trx.trx_count, inv.inv_count
    from trx, inv
     where inv.batchname(+) = trx.batchname
     ) trx_inv
     order by batchname asc
;
