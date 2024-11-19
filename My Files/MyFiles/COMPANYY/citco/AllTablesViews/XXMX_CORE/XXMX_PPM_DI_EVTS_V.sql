--------------------------------------------------------
--  DDL for View XXMX_PPM_DI_EVTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_DI_EVTS_V" ("SOURCENAME", "SOURCEREF", "ORGANIZATION_NAME", "CONTRACT_TYPE_NAME", "CONTRACT_NUMBER", "CONTRACT_LINE_NUMBER", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BILL_AMOUNT") AS 
  SELECT "SOURCENAME","SOURCEREF","ORGANIZATION_NAME","CONTRACT_TYPE_NAME","CONTRACT_NUMBER","CONTRACT_LINE_NUMBER","EVENT_TYPE_NAME","EVENT_DESC","COMPLETION_DATE","BILL_TRNS_CURRENCY_CODE","BILL_TRNS_AMOUNT","PROJECT_NUMBER",
"TASK_NUMBER","BILL_HOLD_FLAG","REVENUE_HOLD_FLAG","ATTRIBUTE_CATEGORY","ATTRIBUTE1","ATTRIBUTE2","ATTRIBUTE3","ATTRIBUTE4","ATTRIBUTE5","ATTRIBUTE6","ATTRIBUTE7","ATTRIBUTE8","ATTRIBUTE9","ATTRIBUTE10","PROJECT_CURRENCY_CODE",
"PROJECT_BILL_AMOUNT","PROJFUNC_CURRENCY_CODE","PROJFUNC_BILL_AMOUNT" FROM (
  WITH ebs_event_id_not0 AS (
    SELECT
        o.cr_reconciliation_number,
        o.ebs_reference_1,
        o.project_number,
        o.ebs_event_id
    FROM
        xxmx_contract_reg_map_data o,
        xxmx_contract_reg_scope    crs
    WHERE
            o.ebs_reference_1 = crs.ebs_reference_1
        AND o.ebs_event_id <> 0
), ebs_event_id_0 AS (
    SELECT
        o.cr_reconciliation_number,
        o.ebs_reference_1,
        o.project_number
    FROM
        xxmx_contract_reg_map_data o,
        xxmx_contract_reg_scope    crs
    WHERE
            o.ebs_reference_1 = crs.ebs_reference_1
        AND o.ebs_event_id = 0
),
events_scope
as(
SELECT
    s.organization_name,
    e.*,
    ebsn0.ebs_reference_1,
    ebsn0.cr_reconciliation_number
FROM
    xxmx_pa_events        e,
    xxmx_ppm_projects_stg s,
    ebs_event_id_not0        ebsn0
WHERE
        e.project_number = s.project_number
    AND e.bill_trans_bill_amount <> e.bill_trans_rev_amount
    AND ebsn0.project_number = s.project_number
    AND e.event_id = ebsn0.ebs_event_id
    AND EXISTS (
        SELECT
            NULL
        FROM
            xxmx_pa_events orphan_evt
        WHERE
            orphan_evt.reference1 = ebsn0.ebs_reference_1
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM
            xxmx_open_ar_prj_evt op
        WHERE
            op.event_id = e.event_id
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM
            xxmx_prj_unbilled_events op
        WHERE
            op.event_id = e.event_id
    )
	--AND NVL(e.billed_flag,'N') = 'Y'
UNION ALL
SELECT
    s.organization_name,
    e.*,
    ebs0.ebs_reference_1,
    ebs0.cr_reconciliation_number
FROM
    xxmx_pa_events        e,
    xxmx_ppm_projects_stg s,
    ebs_event_id_0     ebs0
WHERE
        e.project_number = s.project_number 
    AND e.bill_trans_bill_amount <> e.bill_trans_rev_amount
    AND ebs0.project_number = s.project_number
    AND e.reference1 = ebs0.cr_reconciliation_number
    AND EXISTS (
        SELECT
            NULL
        FROM
            xxmx_pa_events orphan_evt
        WHERE
            orphan_evt.reference1 = ebs0.ebs_reference_1
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM
            xxmx_open_ar_prj_evt op
        WHERE
            op.event_id = e.event_id
    )
    AND NOT EXISTS (
        SELECT
            1
        FROM
            xxmx_prj_unbilled_events op
        WHERE
            op.event_id = e.event_id
    )
--	AND NVL(e.billed_flag,'N') = 'Y'
	)
		
	SELECT null SOURCENAME
                ,src.TASK_NUMBER SOURCEREF
                ,src.ORGANIZATION_NAME
                ,null CONTRACT_TYPE_NAME
                ,null CONTRACT_NUMBER
                ,null CONTRACT_LINE_NUMBER
                ,src.event_type EVENT_TYPE_NAME
                ,src.description EVENT_DESC
                --,last_day(sysdate) COMPLETION_DATE
                ,src.completion_date COMPLETION_DATE 
                ,src.BILL_TRANS_CURRENCY_CODE       BILL_TRNS_CURRENCY_CODE
			/*	, decode(  substr(src.ebs_reference_1,1,20) , 
							substr(src.cr_reconciliation_number,1,20),
							to_number(src.bill_trans_bill_amount),
							to_number(src.bill_trans_rev_amount)
						)	 BILL_TRNS_AMOUNT	*/
                 ,src.bill_trans_bill_amount       BILL_TRNS_AMOUNT      
			   /*,CASE WHEN abs(to_number(src.bill_trans_bill_amount)) > abs(to_number(src.bill_trans_rev_amount)) THEN to_number(src.bill_trans_bill_amount)
                      ELSE to_number(src.bill_trans_rev_amount)
                 END BILL_TRNS_AMOUNT*/
                ,src.PROJECT_NUMBER
                ,src.TASK_NUMBER TASK_NUMBER
                ,src.BILL_HOLD_FLAG
                ,src.REVENUE_HOLD_FLAG
                ,null ATTRIBUTE_CATEGORY
                ,substr(src.ebs_reference_1,1,20)               ATTRIBUTE1
                ,substr(src.cr_reconciliation_number,1,20)               ATTRIBUTE2
                ,to_char(src.event_id) ATTRIBUTE3
                ,to_char(src.event_num) ATTRIBUTE4
                ,null ATTRIBUTE5
                ,(select max(i.INVOICE_AR_NUMBER) from XXMX_CLOSED_AR_PRJ_DI_EVT i
                  where i.project_number = src.project_number
                  and i.task_number = src.task_number
                  and i.event_id = src.event_id
                  ) ATTRIBUTE6
                ,'CLOSED_AR' ATTRIBUTE7
                ,(select to_char(max(i.INVOICE_DATE),'DD-MON-YYYY') from XXMX_CLOSED_AR_PRJ_DI_EVT i
                  where i.project_number = src.project_number
                  and i.task_number = src.task_number
                  and i.event_id = src.event_id
                  )  ATTRIBUTE8
                ,(select max(i.BILL_GROUP) from XXMX_CLOSED_AR_PRJ_DI_EVT i
                  where i.project_number = src.project_number
                  and i.task_number = src.task_number
                  and i.event_id = src.event_id
                  ) ATTRIBUTE9
                ,'BILLING'	 ATTRIBUTE10			
				/*,CASE WHEN abs(to_number(src.bill_trans_bill_amount)) > abs(to_number(src.bill_trans_rev_amount)) THEN  'BILLING'
                      ELSE 'REVENUE'
                 END  ATTRIBUTE10*/
                ,null PROJECT_CURRENCY_CODE
                ,to_number(null) PROJECT_BILL_AMOUNT
                ,null PROJFUNC_CURRENCY_CODE
                ,to_number(null) PROJFUNC_BILL_AMOUNT
	FROM events_scope src
    WHERE src.bill_trans_bill_amount <> 0
    UNION
    	SELECT null SOURCENAME
                ,src.TASK_NUMBER SOURCEREF
                ,src.ORGANIZATION_NAME
                ,null CONTRACT_TYPE_NAME
                ,null CONTRACT_NUMBER
                ,null CONTRACT_LINE_NUMBER
                ,src.event_type EVENT_TYPE_NAME
                ,src.description EVENT_DESC
                --,last_day(sysdate) COMPLETION_DATE
                ,src.completion_date COMPLETION_DATE 
                ,src.BILL_TRANS_CURRENCY_CODE       BILL_TRNS_CURRENCY_CODE
			/*	, decode(  substr(src.ebs_reference_1,1,20) , 
							substr(src.cr_reconciliation_number,1,20),
							to_number(src.bill_trans_bill_amount),
							to_number(src.bill_trans_rev_amount)
						)	 BILL_TRNS_AMOUNT	*/
                ,src.bill_trans_rev_amount       BILL_TRNS_AMOUNT         
			   /*,CASE WHEN abs(to_number(src.bill_trans_bill_amount)) > abs(to_number(src.bill_trans_rev_amount)) THEN to_number(src.bill_trans_bill_amount)
                      ELSE to_number(src.bill_trans_rev_amount)
                 END BILL_TRNS_AMOUNT*/
                ,src.PROJECT_NUMBER
                ,src.TASK_NUMBER TASK_NUMBER
                ,src.BILL_HOLD_FLAG
                ,src.REVENUE_HOLD_FLAG
                ,null ATTRIBUTE_CATEGORY
                ,substr(src.ebs_reference_1,1,20)               ATTRIBUTE1
                ,substr(src.cr_reconciliation_number,1,20)               ATTRIBUTE2
                ,to_char(src.event_id) ATTRIBUTE3
                ,to_char(src.event_num) ATTRIBUTE4
                ,null ATTRIBUTE5
                ,NULL ATTRIBUTE6
                ,'CLOSED_AR' ATTRIBUTE7
                ,NULL  ATTRIBUTE8
                ,NULL ATTRIBUTE9
                ,'REVENUE'  ATTRIBUTE10			
				/*,CASE WHEN abs(to_number(src.bill_trans_bill_amount)) > abs(to_number(src.bill_trans_rev_amount)) THEN  'BILLING'
                      ELSE 'REVENUE'
                 END  ATTRIBUTE10*/
                ,null PROJECT_CURRENCY_CODE
                ,to_number(null) PROJECT_BILL_AMOUNT
                ,null PROJFUNC_CURRENCY_CODE
                ,to_number(null) PROJFUNC_BILL_AMOUNT
	FROM events_scope src
    WHERE src.bill_trans_rev_amount <> 0  
  )
;
