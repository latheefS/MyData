--------------------------------------------------------
--  DDL for Materialized View XXMX_PPM_PROJ_TRX_CTL_MV
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_PROJ_TRX_CTL_MV" ("PROJECT_ID", "START_DATE_ACTIVE", "CHARGEABLE_FLAG", "BILLABLE_INDICATOR", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_LOGIN", "TASK_ID", "PERSON_ID", "EXPENDITURE_CATEGORY", "EXPENDITURE_TYPE", "NON_LABOR_RESOURCE", "END_DATE_ACTIVE", "SCHEDULED_EXP_ONLY", "EMPLOYEES_ONLY_FLAG", "WORKPLAN_RES_ONLY_FLAG", "TASK_NUMBER", "TASK_NAME")
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
  AS select ptc.*, pt.task_number, pt.task_name
 FROM  
                    --apps.pa_transaction_controls@xxmx_extract    ptc
					  xxpa_transaction_controls_stg ptc
				  , xxmx_ppm_prj_tasks_Stg pt
                WHERE  ptc.project_id                              = pt.attribute6
                AND ptc.task_id                                 = pt.attribute5
                --AND to_date('30-JUN-2022','DD-MON-YYYY')  BETWEEN TRUNC(nvl(ptc.start_date_active,sysdate-1)) 
                --      AND TRUNC(nvl(ptc.end_date_active,sysdate+1))
union all
select ptc.*, null, null
FROM  
                    -- apps.pa_transaction_controls@xxmx_extract    ptc
					   xxpa_transaction_controls_stg ptc
                    ,xxmx_ppm_projects_stg s
                WHERE  ptc.task_id                   IS NULL
                and ptc.project_id = s.project_id
                --AND to_date('30-JUN-2022','DD-MON-YYYY')  BETWEEN TRUNC(nvl(ptc.start_date_active,sysdate-1)) 
                --                                              AND TRUNC(nvl(ptc.end_date_active,sysdate+1));

   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_PROJ_TRX_CTL_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_PPM_PROJ_TRX_CTL_MV';
