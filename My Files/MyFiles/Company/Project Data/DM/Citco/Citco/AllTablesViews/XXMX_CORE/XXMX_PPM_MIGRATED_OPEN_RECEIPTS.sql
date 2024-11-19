--------------------------------------------------------
--  DDL for View XXMX_PPM_MIGRATED_OPEN_RECEIPTS
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_MIGRATED_OPEN_RECEIPTS" ("INVOICE_NUMBER") AS 
  select distinct ar_invoice_number from xxmx_ppm_prj_lbrcost_stg
                where cost_type like 'OPEN_AR'
            union
            select distinct ar_invoice_number  from xxmx_ppm_prj_misccost_stg
                where cost_type like 'OPEN_AR'
            union
            select distinct attribute6 ar_invoice_number from xxmx_ppm_prj_billevent_stg
                where attribute7 like 'OPEN_AR'
;
