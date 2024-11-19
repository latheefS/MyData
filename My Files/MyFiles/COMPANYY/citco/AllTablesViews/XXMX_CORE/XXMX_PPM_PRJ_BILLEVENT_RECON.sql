--------------------------------------------------------
--  DDL for View XXMX_PPM_PRJ_BILLEVENT_RECON
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PRJ_BILLEVENT_RECON" ("FILE_SET_ID", "BATCH_ID", "BATCH_NAME", "MIGRATION_SET_ID", "MIGRATION_SET_NAME", "MIGRATION_STATUS", "INT_REC_ID", "LOAD_REQUEST_ID", "SOURCENAME", "SOURCEREF", "ORGANIZATION_NAME", "CONTRACT_TYPE_NAME", "CONTRACT_NUMBER", "CONTRACT_LINE_NUMBER", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE_CHAR11", "ATTRIBUTE_CHAR12", "ATTRIBUTE_CHAR13", "ATTRIBUTE_CHAR14", "ATTRIBUTE_CHAR15", "ATTRIBUTE_CHAR16", "ATTRIBUTE_CHAR17", "ATTRIBUTE_CHAR18", "ATTRIBUTE_CHAR19", "ATTRIBUTE_CHAR20", "ATTRIBUTE_CHAR21", "ATTRIBUTE_CHAR22", "ATTRIBUTE_CHAR23", "ATTRIBUTE_CHAR24", "ATTRIBUTE_CHAR25", "ATTRIBUTE_CHAR26", "ATTRIBUTE_CHAR27", "ATTRIBUTE_CHAR28", "ATTRIBUTE_CHAR29", "ATTRIBUTE_CHAR30", "ATTRIBUTE_NUMBER1", "ATTRIBUTE_NUMBER2", "ATTRIBUTE_NUMBER3", "ATTRIBUTE_NUMBER4", "ATTRIBUTE_NUMBER5", "ATTRIBUTE_NUMBER6", "ATTRIBUTE_NUMBER7", "ATTRIBUTE_NUMBER8", "ATTRIBUTE_NUMBER9", "ATTRIBUTE_NUMBER10", "ATTRIBUTE_DATE1", "ATTRIBUTE_DATE2", "ATTRIBUTE_DATE3", "ATTRIBUTE_DATE4", "ATTRIBUTE_DATE5", "ATTRIBUTE_DATE6", "ATTRIBUTE_DATE7", "ATTRIBUTE_DATE8", "ATTRIBUTE_DATE9", "ATTRIBUTE_DATE10", "ATTRIBUTE_TIMESTAMP1", "ATTRIBUTE_TIMESTAMP2", "ATTRIBUTE_TIMESTAMP3", "ATTRIBUTE_TIMESTAMP4", "ATTRIBUTE_TIMESTAMP5", "REVERSE_ACCRUAL_FLAG", "ITEM_EVENT_FLAG", "QUANTITY", "ITEM_NUMBER", "UNIT_OF_MEASURE", "UNIT_PRICE", "LOAD_STATUS", "CREATION_DATE", "LAST_UPDATE_DATE", "CREATED_BY", "LAST_UPDATED_BY", "LAST_UPDATE_LOGIN", "BILL_TRANS_REV_AMOUNT", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJECT_REVENUE_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_RATE_TYPE", "PROJFUNC_REV_RATE_DATE", "PROJFUNC_REV_EXCHANGE_RATE", "PROJFUNC_REVENUE_AMOUNT", "PROJFUNC_BILL_AMOUNT") AS 
  SELECT
        v."FILE_SET_ID",
        v."BATCH_ID",
        v."BATCH_NAME",
        v."MIGRATION_SET_ID",
        v."MIGRATION_SET_NAME",
        v."MIGRATION_STATUS",
        v."INT_REC_ID",
        v."LOAD_REQUEST_ID",
        v."SOURCENAME",
        v."SOURCEREF",
        v."ORGANIZATION_NAME",
        v."CONTRACT_TYPE_NAME",
        v."CONTRACT_NUMBER",
        v."CONTRACT_LINE_NUMBER",
        v."EVENT_TYPE_NAME",
        v."EVENT_DESC",
        v."COMPLETION_DATE",
        v."BILL_TRNS_CURRENCY_CODE",
        v."BILL_TRNS_AMOUNT",
        v."PROJECT_NUMBER",
        v."TASK_NUMBER",
        v."BILL_HOLD_FLAG",
        v."REVENUE_HOLD_FLAG",
        v."ATTRIBUTE_CATEGORY",
        v."ATTRIBUTE1",
        v."ATTRIBUTE2",
        v."ATTRIBUTE3",
        v."ATTRIBUTE4",
        v."ATTRIBUTE5",
        v."ATTRIBUTE6",
        v."ATTRIBUTE7",
        v."ATTRIBUTE8",
        v."ATTRIBUTE9",
        v."ATTRIBUTE10",
        v."ATTRIBUTE_CHAR11",
        v."ATTRIBUTE_CHAR12",
        v."ATTRIBUTE_CHAR13",
        v."ATTRIBUTE_CHAR14",
        v."ATTRIBUTE_CHAR15",
        v."ATTRIBUTE_CHAR16",
        v."ATTRIBUTE_CHAR17",
        v."ATTRIBUTE_CHAR18",
        v."ATTRIBUTE_CHAR19",
        v."ATTRIBUTE_CHAR20",
        v."ATTRIBUTE_CHAR21",
        v."ATTRIBUTE_CHAR22",
        v."ATTRIBUTE_CHAR23",
        v."ATTRIBUTE_CHAR24",
        v."ATTRIBUTE_CHAR25",
        v."ATTRIBUTE_CHAR26",
        v."ATTRIBUTE_CHAR27",
        v."ATTRIBUTE_CHAR28",
        v."ATTRIBUTE_CHAR29",
        v."ATTRIBUTE_CHAR30",
        v."ATTRIBUTE_NUMBER1",
        v."ATTRIBUTE_NUMBER2",
        v."ATTRIBUTE_NUMBER3",
        v."ATTRIBUTE_NUMBER4",
        v."ATTRIBUTE_NUMBER5",
        v."ATTRIBUTE_NUMBER6",
        v."ATTRIBUTE_NUMBER7",
        v."ATTRIBUTE_NUMBER8",
        v."ATTRIBUTE_NUMBER9",
        v."ATTRIBUTE_NUMBER10",
        v."ATTRIBUTE_DATE1",
        v."ATTRIBUTE_DATE2",
        v."ATTRIBUTE_DATE3",
        v."ATTRIBUTE_DATE4",
        v."ATTRIBUTE_DATE5",
        v."ATTRIBUTE_DATE6",
        v."ATTRIBUTE_DATE7",
        v."ATTRIBUTE_DATE8",
        v."ATTRIBUTE_DATE9",        
        v.ATTRIBUTE_DATE10,
       /* case when v.attribute10 = 'REVENUE' THEN (
            select (pdra.gl_date)
            FROM
                dual              g
                LEFT JOIN xxmx_pa_cust_event_rdl_all rev ON e.project_id = rev.project_id
                                                          AND e.task_id = rev.task_id
                                                          AND e.event_num = rev.event_num
                LEFT JOIN xxmx_pa_draft_revenues_all pdra ON pdra.project_id = rev.project_id
                                                           AND pdra.draft_revenue_num = rev.draft_revenue_num
            WHERE
                    1 = 1
                and rownum < 2
                AND v.attribute10 = 'REVENUE'
                AND pdra.transfer_status_code IN ( 'P', 'A', 'T' )
               )
         ELSE (
            select (pdi.gl_date)
            FROM
                dual             g
                LEFT JOIN xxmx_pa_draft_invoice_items pdii ON pdii.project_id = e.project_id
                                                            AND pdii.event_num = e.event_num
                                                            AND pdii.event_task_id = e.task_id
                LEFT JOIN xxmx_pa_draft_invoices_all  pdi ON pdii.draft_invoice_num = pdi.draft_invoice_num
                                                          AND pdii.project_id = pdi.project_id
            WHERE
                    1 = 1
                and rownum < 2
                AND v.attribute10 = 'BILLING'
                AND     coalesce(pdi.write_off_flag, 'A') <> 'Y'  
                AND pdi.transfer_status_code IN ( 'P', 'A', 'T' )
        ) 
        END ATTRIBUTE_DATE10,*/
        v."ATTRIBUTE_TIMESTAMP1",
        v."ATTRIBUTE_TIMESTAMP2",
        v."ATTRIBUTE_TIMESTAMP3",
        v."ATTRIBUTE_TIMESTAMP4",
        v."ATTRIBUTE_TIMESTAMP5",
        v."REVERSE_ACCRUAL_FLAG",
        v."ITEM_EVENT_FLAG",
        v."QUANTITY",
        v."ITEM_NUMBER",
        v."UNIT_OF_MEASURE",
        v."UNIT_PRICE",
        v."LOAD_STATUS",
        v."CREATION_DATE",
        v."LAST_UPDATE_DATE",
        v."CREATED_BY",
        v."LAST_UPDATED_BY",
        v."LAST_UPDATE_LOGIN",
        decode(v.attribute10,'REVENUE',e.bill_trans_rev_amount,null) bill_trans_rev_amount,
        e.project_currency_code,
        decode(v.attribute10,'BILLING',e.project_bill_amount,NULL)  project_bill_amount,
        decode(v.attribute10,'REVENUE',e.project_revenue_amount, NULL) project_revenue_amount,
        e.projfunc_currency_code,
        e.projfunc_rate_type,
        decode(v.attribute10,'REVENUE',e.projfunc_rev_rate_date,NULL) projfunc_rev_rate_date,
        decode(v.attribute10,'REVENUE',e.projfunc_rev_exchange_rate,NULL) projfunc_rev_exchange_rate,
        decode(v.attribute10,'REVENUE',e.projfunc_revenue_amount,null) projfunc_revenue_amount,
        decode(v.attribute10,'BILLING',e.projfunc_bill_amount, NULL) projfunc_bill_amount
    FROM
        xxmx_pa_events             e,
        xxmx_ppm_prj_billevent_stg v
    WHERE
        to_char(e.event_id(+)) = v.attribute3
;
  GRANT SELECT ON "XXMX_CORE"."XXMX_PPM_PRJ_BILLEVENT_RECON" TO "XXMX_READONLY";
