--------------------------------------------------------
--  DDL for View XXMX_PPM_REVACC_EVTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_REVACC_EVTS_V" ("SOURCENAME", "SOURCEREF", "ORGANIZATION_NAME", "CONTRACT_TYPE_NAME", "CONTRACT_NUMBER", "CONTRACT_LINE_NUMBER", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BILL_AMOUNT") AS 
  SELECT DISTINCT
                NULL                               sourcename,
                e.task_number                      sourceref,
                s.organization_name                organization_name
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                ,
                NULL                               contract_type_name,
                NULL                               contract_number,
                NULL                               contract_line_number,
                e.event_type                       event_type_name,
                e.description                      event_desc,
                e.completion_date                  COMPLETION_DATE,
                --last_day(sysdate)                  completion_date,   --TBD
                e.bill_trans_currency_code         bill_trns_currency_code,
                e.bill_trans_rev_amount            bill_trns_amount,
                s.project_number                   project_number,
                e.task_number                      task_number,
                e.BILL_HOLD_FLAG                   bill_hold_flag,
                e.REVENUE_HOLD_FLAG                revenue_hold_flag
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
                ,
                NULL                               attribute_category,
                NULL                              attribute1,
                NULL                              attribute2,
                to_char(e.event_id)                             attribute3,
                to_char(e.event_num)                             attribute4,
                NULL                              attribute5,
                NULL                              attribute6,
                'REVACC'                              attribute7,
                NULL                              attribute8,
                NULL                              attribute9,
                'REVENUE'                              attribute10,
                NULL            project_currency_code,
                NULL            project_bill_amount,
                NULL            projfunc_currency_code,
                NULL            projfunc_bill_amount
            FROM
                xxmx_pa_events e,
                xxmx_ppm_projects_stg    s
            WHERE
                    1 = 1
                and e.event_type = 'Revenue Accrual'
                --and (e.event_type = 'Revenue Accrual' or (e.event_type != 'Revenue Accrual' and e.description like 'Accrued income%'))
                and e.REVENUE_DISTRIBUTED_FLAG = 'Y'
                AND e.project_number = s.project_number
                AND e.bill_trans_rev_amount <> 0
                --and trunc(e.creation_date) >  to_date('05-APR-2023')
                --and trunc(e.completion_date) between to_date('01-APR-2023') and to_date('30-APR-2023')
                --and (e.description like '%April 2023%' or e.description like '%Apr-23%')
                and exists (select null from xxmx_pa_cust_event_rdl_all r, xxmx_pa_draft_revenues_all g
                            where r.project_id = e.project_id
                            and r.task_id = e.task_id
                            and r.event_num = e.event_num
                            and r.project_id = g.project_id
                            and r.draft_revenue_num = g.draft_revenue_num
                            --and g.gl_date >= to_date( '01-JAN-2021','DD-MON-RRRR')
                            and g.gl_date <= to_date( '30-NOV-2023','DD-MON-RRRR')
                            --and g.gl_period_name = 'APR-23'
                            )
;
