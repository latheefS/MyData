--------------------------------------------------------
--  DDL for View XXMX_PPM_BILLING_VW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_BILLING_VW" ("PROJECT_ID", "SEGMENT1", "TASK_ID", "CONNECTION_ID", "AGEING_ID", "DAYS", "QUANTITY", "BILL_TRANS_CURRENCY_CODE", "PROJECT_CURRENCY_CODE", "AMOUNT", "AMOUNT_PROJ_CUR", "AMOUNT_PROJ_FUNC_CUR", "AMOUNT_PROJ_EUR", "AMOUNT_PROJ_USD", "ITEM_DATE", "SCENARIO_ID", "INVOICE_ID", "PERIOD_ID") AS 
  SELECT
    e.project_id,
	(select segment1 from apps.pa_projects_all@xxmx_extract where project_id=e.project_id) segment1,
    e.task_id,
    '0_'
    || 'ev_'
    || e.event_id                                                          connection_id,
    CASE
        WHEN e.billed_flag = 'Y'                         THEN
            0
        WHEN round(sysdate - e.completion_date, 0) <= 0  THEN
            1
        WHEN round(sysdate - e.completion_date, 0) < 31  THEN
            2
        WHEN round(sysdate - e.completion_date, 0) < 61  THEN
            3
        WHEN round(sysdate - e.completion_date, 0) < 91  THEN
            4
        WHEN round(sysdate - e.completion_date, 0) < 121 THEN
            5
        WHEN round(sysdate - e.completion_date, 0) < 151 THEN
            6
        WHEN round(sysdate - e.completion_date, 0) < 181 THEN
            7
        WHEN round(sysdate - e.completion_date, 0) < 211 THEN
            8
        WHEN round(sysdate - e.completion_date, 0) < 241 THEN
            9
        WHEN round(sysdate - e.completion_date, 0) < 271 THEN
            10
        WHEN round(sysdate - e.completion_date, 0) < 301 THEN
            11
        WHEN round(sysdate - e.completion_date, 0) < 331 THEN
            12
        WHEN round(sysdate - e.completion_date, 0) < 361 THEN
            13
        ELSE
            14
    END                                                                    ageing_id,
    round(sysdate - e.completion_date, 0)                                  days,
    NULL                                                                   quantity,
    e.bill_trans_currency_code,
    e.project_currency_code,
    e.bill_trans_bill_amount                                               AS amount,
    CASE
        WHEN ( ( e.project_bill_amount IS NOT NULL )
               AND ( e.project_bill_amount <> 0 ) ) THEN
            e.project_bill_amount
        WHEN ( ( ( e.project_bill_amount IS NULL )
                 OR ( e.project_bill_amount = 0 ) )
               AND ( e.bill_trans_bill_amount IS NOT NULL )
               AND ( e.project_currency_code = e.bill_trans_currency_code ) ) THEN
            e.bill_trans_bill_amount
        WHEN ( ( ( e.project_bill_amount IS NULL )
                 OR ( e.project_bill_amount = 0 ) )
               AND ( e.bill_trans_bill_amount IS NOT NULL )
               AND ( e.project_currency_code <> e.bill_trans_currency_code ) ) THEN
            round((e.bill_trans_bill_amount * r.conversion_rate), 4)
        ELSE
            e.project_bill_amount
    END                                                                    AS amount_proj_cur,
    CASE
        WHEN e.bill_trans_currency_code = e.projfunc_currency_code THEN
            e.bill_trans_bill_amount
        ELSE
            round((e.bill_trans_bill_amount * r_func.conversion_rate), 4)
    END                                                                    AS amount_proj_func_cur,
    CASE
        WHEN e.bill_trans_currency_code = 'EUR' THEN
            e.bill_trans_bill_amount
        ELSE
            round((e.bill_trans_bill_amount * eur.conversion_rate), 4)
    END                                                                    AS amount_proj_eur,
    CASE
        WHEN e.bill_trans_currency_code = 'USD' THEN
            e.bill_trans_bill_amount
        ELSE
            round((e.bill_trans_bill_amount * usd.conversion_rate), 4)
    END                                                                    AS amount_proj_usd,
    e.completion_date                                                      item_date,
    0                                                                      AS scenario_id,
    CASE
        WHEN dii.draft_invoice_num IS NOT NULL THEN
            dii.project_id
            || '_'
            || dii.draft_invoice_num
        ELSE
            NULL
    END                                                                    invoice_id,
    EXTRACT(YEAR FROM pdi.gl_date) * 100 + EXTRACT(MONTH FROM pdi.gl_date) period_id
FROM
    pa.pa_events@xxmx_extract              e 
--inner join apps.pa_projects_all ppa on (e.project_id = ppa.project_id)        
--inner join apps.hr_operating_units  hou     on      (hou.organization_id = ppa.org_id)

    LEFT JOIN (
        SELECT
            from_currency,
            to_currency,
            conversion_date,
            conversion_type,
            conversion_rate
        FROM
            gl.gl_daily_rates@xxmx_extract 
    )                          r ON e.bill_trans_currency_code = r.from_currency
           AND e.project_currency_code = r.to_currency
           AND r.conversion_date = CASE
                                       WHEN trunc(e.completion_date) > trunc(sysdate) THEN
                                           trunc(sysdate)
                                       ELSE
                                           trunc(e.completion_date)
                                   END
           AND r.conversion_type = 'Spot'
    LEFT JOIN (
        SELECT
            from_currency,
            to_currency,
            conversion_date,
            conversion_type,
            conversion_rate
        FROM
            gl.gl_daily_rates@xxmx_extract 
    )                          eur ON e.bill_trans_currency_code = eur.from_currency
             AND eur.to_currency = 'EUR'
             AND eur.conversion_date = CASE
                                           WHEN trunc(e.completion_date) > trunc(sysdate) THEN
                                               trunc(sysdate)
                                           ELSE
                                               trunc(e.completion_date)
                                       END
             AND eur.conversion_type = 'Spot'
    LEFT JOIN (
        SELECT
            from_currency,
            to_currency,
            conversion_date,
            conversion_type,
            conversion_rate
        FROM
            gl.gl_daily_rates@xxmx_extract 
    )                          usd ON e.bill_trans_currency_code = usd.from_currency
             AND usd.to_currency = 'USD'
             AND usd.conversion_date = CASE
                                           WHEN trunc(e.completion_date) > trunc(sysdate) THEN
                                               trunc(sysdate)
                                           ELSE
                                               trunc(e.completion_date)
                                       END
             AND usd.conversion_type = 'Spot'
    LEFT JOIN (
        SELECT
            from_currency,
            to_currency,
            conversion_date,
            conversion_type,
            conversion_rate
        FROM
            gl.gl_daily_rates@xxmx_extract 
    )                          r_func ON e.bill_trans_currency_code = r_func.from_currency
                AND r_func.to_currency = e.projfunc_currency_code
                AND r_func.conversion_date = trunc(sysdate)
                AND r_func.conversion_type = 'Spot'
    LEFT JOIN (
        SELECT
            pdii.event_task_id,
            pdii.event_num,
            pdii.project_id,
            MAX(pdii.draft_invoice_num) AS draft_invoice_num
        FROM
            pa.pa_draft_invoice_items@xxmx_extract  pdii
        GROUP BY
            pdii.event_task_id,
            pdii.event_num,
            pdii.project_id
    )                          dii ON dii.project_id = e.project_id
             AND dii.event_num = e.event_num
             AND dii.event_task_id = e.task_id
    LEFT JOIN apps.pa_draft_invoices_all@xxmx_extract  pdi ON e.project_id = pdi.project_id
                                                AND dii.draft_invoice_num = pdi.draft_invoice_num
WHERE
        1 = 1
    AND e.bill_trans_bill_amount <> 0
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_PPM_BILLING_VW" TO "XXMX_READONLY";
