--------------------------------------------------------
--  DDL for View XXMX_AR_RECEIPTS_REF_DATA_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_AR_RECEIPTS_REF_DATA_V" ("LOAD_REQUEST_ID", "BU_ID", "BU_NAME", "BATCH_NAME", "LOCKBOX_NUMBER", "TRANSMISSION_FORMAT_ID", "LOCKBOX_ID") AS 
  SELECT distinct  c.load_request_id, a.BU_ID,a.BU_NAME ,b.batch_name  , b.lockbox_number     , c.transmission_format_id, c.lockbox_id
        FROM xxmx_dm_fusion_das a, xxmx_ar_cash_receipts_xfm b,
        xxmx_ar_receipts_ref_data c
        where a.bu_name = b.operating_unit_name
        and c.lockbox_number =  b.lockbox_number
        and b.lockbox_number <> 'L635948591_DM'
;
