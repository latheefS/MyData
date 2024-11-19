--------------------------------------------------------
--  DDL for View XXMX_PPM_COSTS_VW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_COSTS_VW" ("PROJECT_ID", "SEGMENT1", "TASK_ID", "EXPENDITURE_TYPE", "ORG_ID", "RECVR_ORG_ID", "NET_ZERO_ADJUSTMENT_FLAG", "CONNECTION_ID", "AGEING_ID", "DAYS", "QUANTITY", "BILL_TRANS_CURRENCY_CODE", "PROJECT_CURRENCY_CODE", "AMOUNT", "AMOUNT_PROJ_CUR", "AMOUNT_PROJ_FUNC_CUR", "AMOUNT_PROJ_EUR", "AMOUNT_PROJ_USD", "ITEM_DATE", "SCENARIO_ID", "INVOICE_ID", "PERIOD_ID") AS 
  with costs as  (
SELECT
    e.project_id,
    (select segment1 from apps.pa_projects_all@xxmx_extract where project_id=e.project_id) segment1,
    e.task_id,
    e.expenditure_type,
    e.org_id,
    e.RECVR_ORG_ID,
    e.NET_ZERO_ADJUSTMENT_FLAG,
    '0_'
    || 'exp_'
    || e.expenditure_item_id                                               connection_id,
    CASE
        WHEN rev.projfunc_revenue_amount IS NULL THEN
            0
        WHEN rev.projfunc_revenue_amount = 0                   THEN
            0
        WHEN round(sysdate - e.expenditure_item_date, 0) <= 0  THEN
            1
        WHEN round(sysdate - e.expenditure_item_date, 0) < 31  THEN
            2
        WHEN round(sysdate - e.expenditure_item_date, 0) < 61  THEN
            3
        WHEN round(sysdate - e.expenditure_item_date, 0) < 91  THEN
            4
        WHEN round(sysdate - e.expenditure_item_date, 0) < 121 THEN
            5
        WHEN round(sysdate - e.expenditure_item_date, 0) < 151 THEN
            6
        WHEN round(sysdate - e.expenditure_item_date, 0) < 181 THEN
            7
        WHEN round(sysdate - e.expenditure_item_date, 0) < 211 THEN
            8
        WHEN round(sysdate - e.expenditure_item_date, 0) < 241 THEN
            9
        WHEN round(sysdate - e.expenditure_item_date, 0) < 271 THEN
            10
        WHEN round(sysdate - e.expenditure_item_date, 0) < 301 THEN
            11
        WHEN round(sysdate - e.expenditure_item_date, 0) < 331 THEN
            12
        WHEN round(sysdate - e.expenditure_item_date, 0) < 361 THEN
            13
        ELSE
            14
    END                                                                    ageing_id,
    round(sysdate - e.expenditure_item_date, 0)                            days,
    e.quantity,
    e.bill_trans_currency_code,
    e.project_currency_code,
    e.bill_trans_bill_amount                                               amount,
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
    rev.projfunc_revenue_amount                                            amount_proj_func_cur,
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
    e.expenditure_item_date                                                item_date,
    0                                                                      AS scenario_id,
    CASE
        WHEN inv.draft_invoice_num IS NOT NULL THEN
            inv.project_id
            || '_'
            || inv.draft_invoice_num
        ELSE
            NULL
    END                                                                    invoice_id,
    EXTRACT(YEAR FROM pdi.gl_date) * 100 + EXTRACT(MONTH FROM pdi.gl_date) period_id
FROM
         pa.pa_expenditure_items_all@xxmx_extract e
--inner join apps.pa_projects_all ppa on (e.project_id = ppa.project_id)        
--inner join apps.hr_operating_units  hou     on      (hou.organization_id = ppa.org_id)
    INNER JOIN apps.pa_expenditures_all@xxmx_extract   ea ON e.expenditure_id = ea.expenditure_id
    LEFT JOIN (
        SELECT
            expenditure_item_id,
            project_id,
            MAX(draft_invoice_num)       draft_invoice_num,
            SUM(projfunc_revenue_amount) projfunc_revenue_amount
        FROM
            pa.pa_cust_rev_dist_lines_all@xxmx_extract
        WHERE
            draft_invoice_num IS NULL
        GROUP BY
            expenditure_item_id,
            project_id
    )                          rev ON e.expenditure_item_id = rev.expenditure_item_id
             AND e.project_id = rev.project_id
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
                                       WHEN trunc(e.expenditure_item_date) > trunc(sysdate) THEN
                                           trunc(sysdate)
                                       ELSE
                                           trunc(e.expenditure_item_date)
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
                                           WHEN trunc(e.expenditure_item_date) > trunc(sysdate) THEN
                                               trunc(sysdate)
                                           ELSE
                                               trunc(e.expenditure_item_date)
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
                                           WHEN trunc(e.expenditure_item_date) > trunc(sysdate) THEN
                                               trunc(sysdate)
                                           ELSE
                                               trunc(e.expenditure_item_date)
                                       END
             AND usd.conversion_type = 'Spot'
    LEFT JOIN (
        SELECT
            expenditure_item_id,
            project_id,
            MAX(draft_invoice_num)       draft_invoice_num,
            SUM(projfunc_revenue_amount) projfunc_revenue_amount
        FROM
            pa.pa_cust_rev_dist_lines_all@xxmx_extract
        GROUP BY
            expenditure_item_id,
            project_id
    )                          inv ON e.expenditure_item_id = inv.expenditure_item_id
             AND e.project_id = inv.project_id
    LEFT JOIN apps.pa_draft_invoices_all@xxmx_extract pdi ON e.project_id = pdi.project_id
                                                AND inv.draft_invoice_num = pdi.draft_invoice_num
WHERE
        1 = 1
    AND e.billable_flag = 'Y'
--and e.expenditure_item_id <=10000000;)
)
select 
--e.org_id,
  --  e.RECVR_ORG_ID,
    --count(*) count_costs
"PROJECT_ID","SEGMENT1","TASK_ID","EXPENDITURE_TYPE","ORG_ID","RECVR_ORG_ID","NET_ZERO_ADJUSTMENT_FLAG","CONNECTION_ID","AGEING_ID","DAYS","QUANTITY","BILL_TRANS_CURRENCY_CODE","PROJECT_CURRENCY_CODE","AMOUNT","AMOUNT_PROJ_CUR","AMOUNT_PROJ_FUNC_CUR","AMOUNT_PROJ_EUR","AMOUNT_PROJ_USD","ITEM_DATE","SCENARIO_ID","INVOICE_ID","PERIOD_ID"
from costs e
where -- project_id = 51209 
1=1
and (invoice_id is null OR NET_ZERO_ADJUSTMENT_FLAG = 'Y')
and nvl(amount,0) <> 0
--and expenditure_type = 'Labor'
--group by  e.org_id,
  --  e.RECVR_ORG_ID
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_PPM_COSTS_VW" TO "XXMX_READONLY";
