--------------------------------------------------------
--  DDL for View XXMX_PPM_UNBIL_EVTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_UNBIL_EVTS_V" ("SOURCENAME", "SOURCEREF", "ORGANIZATION_NAME", "CONTRACT_TYPE_NAME", "CONTRACT_NUMBER", "CONTRACT_LINE_NUMBER", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BILL_AMOUNT") AS 
  SELECT
        src.sourcename,
        src.sourceref,
        src.organization_name,
        src.contract_type_name,
        src.contract_number,
        src.contract_line_number,
        src.event_type_name,
        src.event_desc,
        src.completion_date,
        src.bill_trns_currency_code,
        src.bill_trns_amount,
        src.project_number,
        src.task_number,
        src.bill_hold_flag,
        src.revenue_hold_flag,
        src.attribute_category,
        src.attribute1,
        src.attribute2,
        src.attribute3,
        src.attribute4,
        src.attribute5,
        src.attribute6,
        src.attribute7,
        src.attribute8,
        src.attribute9,
        src.attribute10,
        project_currency_code,
        project_bill_amount,
        projfunc_currency_code,
        projfunc_bill_amount
    FROM
        (
            SELECT 
                NULL                               sourcename,
                c.task_number                      sourceref,
                s.organization_name                organization_name
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                ,
                NULL                               contract_type_name,
                NULL                               contract_number,
                NULL                               contract_line_number,
                c.event_type                       event_type_name,
                c.description                      event_desc,
                c.completion_date                  COMPLETION_DATE,
                --last_day(sysdate)                  completion_date,   --TBD
                c.bill_trans_currency_code            bill_trns_currency_code,
                nvl((c.bill_trans_bill_amount), 0) bill_trns_amount,
                s.project_number                   project_number,
                c.task_number                      task_number,
                e.bill_hold_flag                   bill_hold_flag,
                'N'                                revenue_hold_flag
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
                ,
                NULL                               attribute_category,
                substr(e.reference1,1,20)         attribute1,
                NULL                              attribute2,
                to_char(e.event_id)                             attribute3,
                to_char(e.event_num)                             attribute4,
                NULL                              attribute5,
                NULL                              attribute6,
                'UNBILLED'                              attribute7,
                NULL                              attribute8,
                NULL                              attribute9,
                'BILLING'                              attribute10,
                s.project_currency_code            project_currency_code,
                ( e.project_bill_amount )          project_bill_amount,
                e.projfunc_currency_code           projfunc_currency_code,
                ( e.projfunc_bill_amount )         projfunc_bill_amount
            FROM
                xxmx_prj_unbilled_events c, xxmx_pa_events e,
                xxmx_ppm_projects_stg    s
            WHERE
                    1 = 1
                AND c.project_number = s.project_number
                and e.event_id = c.event_id
                AND c.bill_trans_bill_amount <> 0 
                --AND (c.bill_trans_bill_amount <> 0 or (c.bill_trans_bill_amount = 0 and c.bill_trans_rev_amount = 0))
               -- and not exists (select 1 from XXMX_PPM_OPEN_AR_EVTS_V op where op.attribute3 = to_char(e.event_id))
               --  and not exists (select 1 from XXMX_PPM_DI_EVTS_V op where op.attribute3 = to_char(e.event_id))
            UNION
            SELECT 
                NULL                              sourcename,
                c.task_number                     sourceref,
                s.organization_name               organization_name
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                ,
                NULL                              contract_type_name,
                NULL                              contract_number,
                NULL                              contract_line_number,
                e.event_type                      event_type_name,
                e.description                     event_desc,
                e.completion_date                  COMPLETION_DATE,
                c.bill_trans_currency_code           bill_trns_currency_code,
                nvl((e.bill_trans_rev_amount), 0) bill_trns_amount,
                s.project_number                  project_number,
                c.task_number                     task_number,
                'N'                               bill_hold_flag,
                e.revenue_hold_flag               revenue_hold_flag
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
                ,
                NULL                              attribute_category,
                NULL                              attribute1,
                NULL                              attribute2,
                to_char(e.event_id)               attribute3,
                to_char(e.event_num)              attribute4,
                NULL                              attribute5,
                NULL                              attribute6,
                'UNBILLED'                              attribute7,
                NULL                              attribute8,
                NULL                              attribute9,
                'REVENUE'                              attribute10,
                s.project_currency_code           project_currency_code,
                ( e.project_revenue_amount )      project_bill_amount,
                e.projfunc_currency_code          projfunc_currency_code,
                ( e.projfunc_revenue_amount )     projfunc_bill_amount
            FROM
                xxmx_prj_unbilled_events c, xxmx_pa_events e,
                xxmx_ppm_projects_stg        s
            WHERE
                    1 = 1
                AND c.project_number = s.project_number
                and e.event_id = c.event_id
                and e.bill_trans_rev_amount <> 0
                --AND e.bill_trans_bill_amount = e.bill_trans_rev_amount
                --and not exists (select 1 from XXMX_PPM_OPEN_AR_EVTS_V op where op.attribute3 = to_char(e.event_id))
               --  and not exists (select 1 from XXMX_PPM_DI_EVTS_V op where op.attribute3 = to_char(e.event_id))
 /*               and not exists (select null from xxmx_contract_reg_map_data cr 
                                where (e.reference1 = cr.ebs_reference_1)
                                )
                and not exists (select null from xxmx_contract_reg_map_data cr 
                                where (e.reference1 = cr.cr_reconciliation_number)
                                )
                and not exists (select null from xxmx_contract_reg_map_data cr 
                                where (e.event_id = cr.ebs_event_id)
                                )  */
            UNION
            SELECT 
                NULL                              sourcename,
                e.task_number                     sourceref,
                s.organization_name               organization_name
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
                ,
                NULL                              contract_type_name,
                NULL                              contract_number,
                NULL                              contract_line_number,
                e.event_type                      event_type_name,
                e.description                     event_desc,
                e.completion_date                  COMPLETION_DATE,
                e.bill_trans_currency_code           bill_trns_currency_code,
                nvl((e.bill_trans_rev_amount), 0) bill_trns_amount,
                s.project_number                  project_number,
                e.task_number                     task_number,
                'N'                              bill_hold_flag,
                e.revenue_hold_flag               revenue_hold_flag
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
                ,
                NULL                              attribute_category,
                substr(cr.ebs_reference_1,1,20)            attribute1,
                substr(cr.cr_reconciliation_number,1,20)   attribute2,
                to_char(e.event_id)                             attribute3,
                to_char(e.event_num)                             attribute4,
                NULL                              attribute5,
                NULL                              attribute6,
                'UNBILLED'                              attribute7,
                NULL                              attribute8,
                NULL                              attribute9,
                'REVENUE'                              attribute10,
                s.project_currency_code           project_currency_code,
                ( e.project_revenue_amount  )     project_bill_amount,
                e.projfunc_currency_code          projfunc_currency_code,
                 e.projfunc_revenue_amount      projfunc_bill_amount
            FROM
                 --xxmx_prj_unbilled_events c,
                 xxmx_contract_reg_map_data cr, xxmx_pa_events e,
                xxmx_ppm_projects_stg        s
            WHERE
                    1 = 1
                --AND c.event_id = e.event_id
                AND e.project_number = s.project_number
                and (e.reference1 = cr.cr_reconciliation_number or e.event_id = cr.ebs_event_id)
                and e.bill_trans_rev_amount <> 0
                --and not exists (select 1 from XXMX_PPM_OPEN_AR_EVTS_V op where op.attribute3 = to_char(e.event_id))
                 -- and not exists (select 1 from XXMX_PPM_DI_EVTS_V op where op.attribute3 = to_char(e.event_id))
                and exists (select null from xxmx_pa_events orphan_evt  
                            where orphan_evt.project_number = e.project_number
                            and   orphan_evt.task_number = e.task_number
                            and   orphan_evt.reference1 = cr.ebs_reference_1
                            and exists (select 1 from xxmx_prj_unbilled_events ec where ec.event_id =  orphan_evt.event_id)
                            --AND   orphan_evt.bill_trans_bill_amount <> 0
                            )
                --and e.event_id = c.event_id
                --and exists (select null from xxmx_contract_reg_map_data cr where e.reference1 = cr.reconciliation_number and cr.revenue_amount <> 0)
        ) src
    WHERE   src.bill_trns_amount <> 0
;
