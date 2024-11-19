--------------------------------------------------------
--  DDL for Materialized View XXMX_PPM_UNBIL_EVTS_MV
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_UNBIL_EVTS_MV" ("SOURCEREF", "ORGANIZATION_NAME", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE7", "ATTRIBUTE10", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BILL_AMOUNT")
  SEGMENT CREATION IMMEDIATE
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "XXMX_CORE" 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH FORCE ON DEMAND
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE ON QUERY COMPUTATION DISABLE QUERY REWRITE
  AS SELECT
      --  sourcename,
        sourceref,
        organization_name,
      --  contract_type_name,
      --  contract_number,
      --  contract_line_number,
        event_type_name,
        event_desc,
        completion_date,
        bill_trns_currency_code,
        bill_trns_amount,
        project_number,
        task_number,
        bill_hold_flag,
        revenue_hold_flag,
      --  attribute_category,
        attribute1,
        attribute2,
        attribute3,
        attribute4,
--        attribute5,
--        attribute6,
        attribute7,
      --  attribute8,
      --  attribute9,
        attribute10,
        project_currency_code,
        project_bill_amount,
        projfunc_currency_code,
        projfunc_bill_amount
from XXMX_PPM_UNBIL_EVTS_V;

   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_UNBIL_EVTS_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_PPM_UNBIL_EVTS_MV';
