--------------------------------------------------------
--  DDL for View XXMX_PPM_CLOUD_CONT_BILLPLANS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_CLOUD_CONT_BILLPLANS_V" ("MIGRATION_SET_ID", "MIGRATION_SET_NAME", "MIGRATION_STATUS", "XFACE_REC_ID", "CONTRACT_NUMBER", "CONTRACT_TYPE", "PLAN_NAME", "PLAN_TYPE", "CONTRACT_LINE_NUMBER", "PROJECT_NUMBER", "TASK_NUMBER", "PERSON_NAME", "PERSON_NUMBER", "PERSON_EMAIL", "JOB_CODE", "EXPENDITURE_TYPE_NAME", "RATE", "CURRENCY_CODE", "START_DATE_ACTIVE", "END_DATE_ACTIVE", "RATE_OVERRIDE_REASON", "BATCH_NAME", "BATCH_ID", "LAST_UPDATED_BY", "CREATED_BY", "LAST_UPDATE_LOGIN", "LAST_UPDATE_DATE", "CREATION_DATE", "LOAD_STATUS", "IMPORT_STATUS", "DISCOUNT_PERCENTAGE", "MARKUP_PERCENTAGE", "OVERRIDE_TYPE", "CONTRACT_ID", "ID", "CONT_MAJOR_VERSION", "BILL_PLAN_ID", "BP_MAJOR_VERSION") AS 
  SELECT
        a.MIGRATION_SET_ID,
        a.MIGRATION_SET_NAME,
        a.MIGRATION_STATUS,
        a.XFACE_REC_ID,
        a.CONTRACT_NUMBER,
        a.CONTRACT_TYPE,
        a.PLAN_NAME,
        a.PLAN_TYPE,
        a.CONTRACT_LINE_NUMBER,
        a.PROJECT_NUMBER,
        a.TASK_NUMBER,
        a.PERSON_NAME,
/*        nvl((select person_id 
           from XXMX_CLOUD_PERSON_ID_DETAILS 
          where person_number = a.PERSON_NUMBER),a.PERSON_NUMBER) PERSON_NUMBER, */
        a.person_number person_number,
        a.PERSON_EMAIL,
        a.JOB_CODE,
        a.EXPENDITURE_TYPE_NAME,
        a.RATE,
        a.CURRENCY_CODE,
        a.START_DATE_ACTIVE,
        nvl(a.END_DATE_ACTIVE,to_date('31-DEC-2050','DD-MON-RRRR')),
        a.RATE_OVERRIDE_REASON,
        a.BATCH_NAME,
        a.BATCH_ID,
        a.LAST_UPDATED_BY,
        a.CREATED_BY,
        a.LAST_UPDATE_LOGIN,
        a.LAST_UPDATE_DATE,
        a.CREATION_DATE,
        a.LOAD_STATUS,
        a.IMPORT_STATUS,
        a.DISCOUNT_PERCENTAGE,
        a.MARKUP_PERCENTAGE,
        CASE
            WHEN a.job_code IS NOT NULL THEN
                'Job Override'
            WHEN a.person_number IS NOT NULL THEN
                'Person Override'
            ELSE
                'NonLabor Override'
        END override_type,
        b.contract_id,
        id,
        cont_major_version,
        bill_plan_id,
        bp_major_version
--        '100000013652452' person_id
    FROM
        xxmx_ppm_rate_overrides_xfm   a,
        xxmx_ppm_cloud_cont_billplans b
    WHERE
        a.project_number = b.contract_number (+)
    and a.person_number is null
     and b.contract_number not in('4041272','4027935')
;
