--------------------------------------------------------
--  DDL for Materialized View XXMX_PPM_PROJECTS_SCOPE_MV
--------------------------------------------------------

  CREATE MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_PROJECTS_SCOPE_MV" ("PROJECT_ID", "NAME", "SEGMENT1", "LAST_UPDATE_DATE", "LAST_UPDATED_BY", "CREATION_DATE", "CREATED_BY", "LAST_UPDATE_LOGIN", "PROJECT_TYPE", "CARRYING_OUT_ORGANIZATION_ID", "PUBLIC_SECTOR_FLAG", "PROJECT_STATUS_CODE", "DESCRIPTION", "START_DATE", "COMPLETION_DATE", "CLOSED_DATE", "DISTRIBUTION_RULE", "LABOR_INVOICE_FORMAT_ID", "NON_LABOR_INVOICE_FORMAT_ID", "RETENTION_INVOICE_FORMAT_ID", "RETENTION_PERCENTAGE", "BILLING_OFFSET", "BILLING_CYCLE", "LABOR_STD_BILL_RATE_SCHDL", "LABOR_BILL_RATE_ORG_ID", "LABOR_SCHEDULE_FIXED_DATE", "LABOR_SCHEDULE_DISCOUNT", "NON_LABOR_STD_BILL_RATE_SCHDL", "NON_LABOR_BILL_RATE_ORG_ID", "NON_LABOR_SCHEDULE_FIXED_DATE", "NON_LABOR_SCHEDULE_DISCOUNT", "LIMIT_TO_TXN_CONTROLS_FLAG", "PROJECT_LEVEL_FUNDING_FLAG", "INVOICE_COMMENT", "UNBILLED_RECEIVABLE_DR", "UNEARNED_REVENUE_CR", "REQUEST_ID", "PROGRAM_ID", "PROGRAM_APPLICATION_ID", "PROGRAM_UPDATE_DATE", "SUMMARY_FLAG", "ENABLED_FLAG", "SEGMENT2", "SEGMENT3", "SEGMENT4", "SEGMENT5", "SEGMENT6", "SEGMENT7", "SEGMENT8", "SEGMENT9", "SEGMENT10", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "COST_IND_RATE_SCH_ID", "REV_IND_RATE_SCH_ID", "INV_IND_RATE_SCH_ID", "COST_IND_SCH_FIXED_DATE", "REV_IND_SCH_FIXED_DATE", "INV_IND_SCH_FIXED_DATE", "LABOR_SCH_TYPE", "NON_LABOR_SCH_TYPE", "OVR_COST_IND_RATE_SCH_ID", "OVR_REV_IND_RATE_SCH_ID", "OVR_INV_IND_RATE_SCH_ID", "TEMPLATE_FLAG", "VERIFICATION_DATE", "CREATED_FROM_PROJECT_ID", "TEMPLATE_START_DATE_ACTIVE", "TEMPLATE_END_DATE_ACTIVE", "ORG_ID", "PM_PRODUCT_CODE", "PM_PROJECT_REFERENCE", "ACTUAL_START_DATE", "ACTUAL_FINISH_DATE", "EARLY_START_DATE", "EARLY_FINISH_DATE", "LATE_START_DATE", "LATE_FINISH_DATE", "SCHEDULED_START_DATE", "SCHEDULED_FINISH_DATE", "BILLING_CYCLE_ID", "ADW_NOTIFY_FLAG", "WF_STATUS_CODE", "OUTPUT_TAX_CODE", "RETENTION_TAX_CODE", "PROJECT_CURRENCY_CODE", "ALLOW_CROSS_CHARGE_FLAG", "PROJECT_RATE_DATE", "PROJECT_RATE_TYPE", "CC_PROCESS_LABOR_FLAG", "LABOR_TP_SCHEDULE_ID", "LABOR_TP_FIXED_DATE", "CC_PROCESS_NL_FLAG", "NL_TP_SCHEDULE_ID", "NL_TP_FIXED_DATE", "CC_TAX_TASK_ID", "BILL_JOB_GROUP_ID", "COST_JOB_GROUP_ID", "ROLE_LIST_ID", "WORK_TYPE_ID", "CALENDAR_ID", "LOCATION_ID", "PROBABILITY_MEMBER_ID", "PROJECT_VALUE", "EXPECTED_APPROVAL_DATE", "RECORD_VERSION_NUMBER", "INITIAL_TEAM_TEMPLATE_ID", "JOB_BILL_RATE_SCHEDULE_ID", "EMP_BILL_RATE_SCHEDULE_ID", "COMPETENCE_MATCH_WT", "AVAILABILITY_MATCH_WT", "JOB_LEVEL_MATCH_WT", "ENABLE_AUTOMATED_SEARCH", "SEARCH_MIN_AVAILABILITY", "SEARCH_ORG_HIER_ID", "SEARCH_STARTING_ORG_ID", "SEARCH_COUNTRY_CODE", "MIN_CAND_SCORE_REQD_FOR_NOM", "NON_LAB_STD_BILL_RT_SCH_ID", "INVPROC_CURRENCY_TYPE", "REVPROC_CURRENCY_CODE", "PROJECT_BIL_RATE_DATE_CODE", "PROJECT_BIL_RATE_TYPE", "PROJECT_BIL_RATE_DATE", "PROJECT_BIL_EXCHANGE_RATE", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BIL_RATE_DATE_CODE", "PROJFUNC_BIL_RATE_TYPE", "PROJFUNC_BIL_RATE_DATE", "PROJFUNC_BIL_EXCHANGE_RATE", "FUNDING_RATE_DATE_CODE", "FUNDING_RATE_TYPE", "FUNDING_RATE_DATE", "FUNDING_EXCHANGE_RATE", "BASELINE_FUNDING_FLAG", "PROJFUNC_COST_RATE_TYPE", "PROJFUNC_COST_RATE_DATE", "INV_BY_BILL_TRANS_CURR_FLAG", "MULTI_CURRENCY_BILLING_FLAG", "SPLIT_COST_FROM_WORKPLAN_FLAG", "SPLIT_COST_FROM_BILL_FLAG", "ASSIGN_PRECEDES_TASK", "PRIORITY_CODE", "RETN_BILLING_INV_FORMAT_ID", "RETN_ACCOUNTING_FLAG", "ADV_ACTION_SET_ID", "START_ADV_ACTION_SET_FLAG", "REVALUATE_FUNDING_FLAG", "INCLUDE_GAINS_LOSSES_FLAG", "TARGET_START_DATE", "TARGET_FINISH_DATE", "BASELINE_START_DATE", "BASELINE_FINISH_DATE", "SCHEDULED_AS_OF_DATE", "BASELINE_AS_OF_DATE", "LABOR_DISC_REASON_CODE", "NON_LABOR_DISC_REASON_CODE", "SECURITY_LEVEL", "ACTUAL_AS_OF_DATE", "SCHEDULED_DURATION", "BASELINE_DURATION", "ACTUAL_DURATION", "LONG_NAME", "BTC_COST_BASE_REV_CODE", "ASSET_ALLOCATION_METHOD", "CAPITAL_EVENT_PROCESSING", "CINT_RATE_SCH_ID", "CINT_ELIGIBLE_FLAG", "CINT_STOP_DATE", "SYS_PROGRAM_FLAG", "STRUCTURE_SHARING_CODE", "ENABLE_TOP_TASK_CUSTOMER_FLAG", "ENABLE_TOP_TASK_INV_MTH_FLAG", "REVENUE_ACCRUAL_METHOD", "INVOICE_METHOD", "PROJFUNC_ATTR_FOR_AR_FLAG", "PJI_SOURCE_FLAG", "ALLOW_MULTI_PROGRAM_ROLLUP", "PROJ_REQ_RES_FORMAT_ID", "PROJ_ASGMT_RES_FORMAT_ID", "FUNDING_APPROVAL_STATUS_CODE", "REVTRANS_CURRENCY_TYPE", "DATE_EFF_FUNDS_CONSUMPTION", "AR_REC_NOTIFY_FLAG", "AUTO_RELEASE_PWP_INV", "BILL_LABOR_ACCRUAL", "ADJ_ON_STD_INV", "CBS_VERSION_ID", "IC_LABOR_TP_SCHEDULE_ID", "IC_LABOR_TP_FIXED_DATE", "IC_NL_TP_SCHEDULE_ID", "IC_NL_TP_FIXED_DATE", "OLAP_GROUP", "OLAP_TASK_ID", "DEFERRED_ROLLUP_ENABLED_FLAG", "PJT_ROLLUP_ENABLED_FLAG", "POBG_FLAG", "RMCS_INTEGRATION_FLAG", "SLA_ACC_END_DATE", "ORGANIZATION_ID", "ORGANIZATION_NAME", "PROJ_OWNING_ORG", "LEGAL_ENTITY_NAME", "SOURCE_TEMPLATE_NUMBER", "SCHEDULE_NAME", "PROJECT_MANAGER_NUMBER", "PROJECT_MANAGER_NAME", "PROJECT_STATUS_NAME", "WORK_TYPE_NAME")
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
        *
    FROM
        (
            WITH project_manager AS (
                SELECT 
                     nvl(papf.employee_number, papf.npw_number) project_manager_number,
                    papf.last_name
                    || ', '
                    || papf.first_name                         project_manager_name,
                    ppp.project_id            
                FROM
                           
                       xxpa_project_parties_stg	ppp,     			 
                 
				       xxper_all_people_f_stg papf,
                 
				       xxpa_project_role_types_stg pprt
                WHERE 
                    ( trunc(sysdate) BETWEEN ppp.start_date_active AND nvl(ppp.end_date_active, trunc(sysdate)) )
                    and TRUNC(SYSDATE) between papf.effective_start_date AND papf.effective_End_Date
                   AND ppp.resource_source_id = papf.person_id                   
                    AND pprt.project_role_id = ppp.project_role_id
                    AND pprt.project_role_type = 'PROJECT MANAGER'
                    and papf.person_id =  ppp.resource_source_id                    

            )
  /*          SELECT
                ppa.*,
                org.source_org_id                    as organization_id,
                org.source_operating_unit_name       as organization_name,
                hou.name            proj_owning_org,
                xep.name            legal_entity_name,
                ppa2.segment1       source_template_number,
                pppv.work_type_name schedule_name,
                pm.project_manager_number,
                pm.project_manager_name,
                ppsl.project_status_name,
                pppv.work_type_name
            FROM
				xxpa_projects_all_stg                       ppa,
				xxpa_projects_all_stg                       ppa2,
				xxpa_proj_statuses_v_stg                    ppsl,
				xxmx_core.xxmx_source_operating_units       org,
                xxmx_hr_all_organization_units              hou,
				xxxle_entity_profiles_stg                   xep,
                xxhr_operating_units_stg                    hrou,
                xxpa_projects_prm_v_stg                     pppv,
                project_manager                             pm
            WHERE	ppa.template_flag                       = 'N'
                AND ppa.closed_date                         IS NULL
                AND ppsl.project_status_code                = ppa.project_status_code
                AND ppsl.project_status_name                IN ( 'Active', 'Prospect', 'Inactive', 'Outgoing' )
                AND ppa.org_id                              = org.source_org_id
				AND nvl(org.ppm_migration_enabled_flag,'N') = 'Y'
                AND hou.organization_id                     = ppa.carrying_out_organization_id
                AND xep.legal_entity_id                     = hrou.default_legal_context_id
                AND hrou.organization_id                    = org.source_org_id
                AND ppa2.project_id                         = ppa.created_from_project_id
                AND pppv.project_id                         = ppa.project_id (+)
                AND pppv.calendar_id                        = ppa.calendar_id (+)
                -- AND pppv.work_type_id                    = ppa.work_type_id(+)
                AND pm.project_id(+)                           = ppa.project_id 
            UNION  */
              SELECT 
                ppa.*,
                hrou.organization_id                 as organization_id,
                hrou.name                            as organization_name,
                hou.name                             as proj_owning_org,
                xep.name                             as legal_entity_name,
                ppa2.segment1                        as source_template_number,
                --pppv.work_type_name                  as schedule_name,
                'NULL'                  as schedule_name,
                'NULL'                                 as project_manager_number,
                'NULL'                                 as project_manager_name,
                ppsl.project_status_name             as project_status_name,   
                --pppv.work_type_name                  as work_type_name
                'NULL'                  as work_type_name                
            FROM
                xxpa_projects_all_stg                      ppa,
                xxpa_projects_all_stg                      ppa2,
                xxpa_proj_statuses_v_stg                   ppsl,
				--xxmx_core.xxmx_source_operating_units      org,
                xxmx_hr_all_organization_units             hou,
                xxxle_entity_profiles_stg                  xep,
                xxhr_operating_units_stg                   hrou
               -- ,xxpa_projects_prm_v_stg                    pppv
            WHERE   ppa.template_flag                       = 'N'
                --AND ppa.closed_date                         IS NULL
                --AND ( trunc(nvl(ppa.completion_date,sysdate+1)) >= trunc(sysdate) )
                AND ( trunc(nvl(ppa.completion_date,sysdate+1)) >= to_date('30-NOV-2023','DD-MON-YYYY') )
                AND ppsl.project_status_code                = ppa.project_status_code
                AND ppsl.project_status_name                IN ( 'Active', 'Prospect', 'Inactive', 'Outgoing' )
                --AND ppa.org_id                              = org.source_org_id
				--AND nvl(org.ppm_migration_enabled_flag,'N') = 'Y'
                AND hou.organization_id                     = ppa.carrying_out_organization_id
                AND xep.legal_entity_id                     = hrou.default_legal_context_id
                AND ppa2.project_id                         = ppa.created_from_project_id
                AND hrou.organization_id                    = ppa.org_id
                and hrou.date_to is null --OUs that are closed will get ignored              
                --AND pppv.project_id                         = ppa.project_id (+)
                --AND pppv.calendar_id                        = ppa.calendar_id (+)
        );

   COMMENT ON MATERIALIZED VIEW "XXMX_CORE"."XXMX_PPM_PROJECTS_SCOPE_MV"  IS 'snapshot table for snapshot XXMX_CORE.XXMX_PPM_PROJECTS_SCOPE_MV';
