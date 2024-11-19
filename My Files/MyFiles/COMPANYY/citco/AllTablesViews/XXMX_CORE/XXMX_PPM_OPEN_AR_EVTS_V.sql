--------------------------------------------------------
--  DDL for View XXMX_PPM_OPEN_AR_EVTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_OPEN_AR_EVTS_V" ("SOURCENAME", "SOURCEREF", "ORGANIZATION_NAME", "CONTRACT_TYPE_NAME", "CONTRACT_NUMBER", "CONTRACT_LINE_NUMBER", "EVENT_TYPE_NAME", "EVENT_DESC", "COMPLETION_DATE", "BILL_TRNS_CURRENCY_CODE", "BILL_TRNS_AMOUNT", "PROJECT_NUMBER", "TASK_NUMBER", "BILL_HOLD_FLAG", "REVENUE_HOLD_FLAG", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "PROJECT_CURRENCY_CODE", "PROJECT_BILL_AMOUNT", "PROJFUNC_CURRENCY_CODE", "PROJFUNC_BILL_AMOUNT") AS 
  SELECT 
             NULL                                                                SOURCENAME
            ,c.task_number                                                      SOURCEREF
         --   ,haou.name                                                         ORGANIZATION_NAME
            ,s.ORGANIZATION_NAME                                                                ORGANIZATION_NAME
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
            ,NULL                                                                CONTRACT_TYPE_NAME
            ,NULL                                                                CONTRACT_NUMBER
            ,NULL                                                                CONTRACT_LINE_NUMBER			
            ,c.event_type						   	 EVENT_TYPE_NAME
            ,c.description                                                       EVENT_DESC
            ,c.completion_date                                                    COMPLETION_DATE   --TBD
            --,last_day(sysdate)                                                   COMPLETION_DATE   --TBD
            ,c.BILL_TRANS_CURRENCY_CODE                                          BILL_TRNS_CURRENCY_CODE
            ,nvl((c.BILL_TRANS_BILL_AMOUNT),0)                                BILL_TRNS_AMOUNT
            ,s.project_number                                                        PROJECT_NUMBER
            ,c.task_number                                                      TASK_NUMBER
            ,NULL                                                                BILL_HOLD_FLAG
            ,NULL                                                                REVENUE_HOLD_FLAG
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
            ,NULL                                                                ATTRIBUTE_CATEGORY
            ,substr(c.reference1,1,20)                                           ATTRIBUTE1
            ,NULL                                                                ATTRIBUTE2
            ,to_char(c.event_id)                                                 ATTRIBUTE3
            ,to_char(c.event_num)                                                ATTRIBUTE4
            ,NULL                                                                ATTRIBUTE5
            ,c.INVOICE_AR_NUMBER                                                 ATTRIBUTE6
            ,'OPEN_AR'                                                           ATTRIBUTE7
            ,to_char(c.invoice_date,'DD-MON-YYYY')                               ATTRIBUTE8
            ,c.bill_group                                                        ATTRIBUTE9
            ,'BILLING'                                                           ATTRIBUTE10
            ,s.PROJECT_CURRENCY_CODE                                      PROJECT_CURRENCY_CODE
            ,0                                                            PROJECT_BILL_AMOUNT
            ,c.PROJFUNC_CURRENCY_CODE                                     PROJFUNC_CURRENCY_CODE
            ,(c.PROJFUNC_BILL_AMOUNT)                                     PROJFUNC_BILL_AMOUNT
from XXMX_OPEN_AR_PRJ_EVT c,  XXMX_PPM_PROJECTS_STG s
where 1=0  
and c.project_number = s.project_number
and c.INVOICE_AR_NUMBER in (select l.INVOICE_AR_NUMBER from xxmx_citco_open_ar_mv l WHERE l.status = 'Open')
and c.BILL_TRANS_BILL_AMOUNT <> 0
and c.BILL_TRANS_REV_AMOUNT <> C.BILL_TRANS_BILL_AMOUNT
--and c.BILL_TRANS_REV_AMOUNT = 0
union
--Billing: Billed and earned event
            SELECT 
             NULL                                                                SOURCENAME
            ,c.task_number                                                      SOURCEREF
         --   ,haou.name                                                         ORGANIZATION_NAME
            ,s.ORGANIZATION_NAME                                                                ORGANIZATION_NAME
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
            ,NULL                                                                CONTRACT_TYPE_NAME
            ,NULL                                                                CONTRACT_NUMBER
            ,NULL                                                                CONTRACT_LINE_NUMBER			
            ,c.event_type						   	 EVENT_TYPE_NAME
            ,c.description                                                       EVENT_DESC
            ,c.completion_date                                                    COMPLETION_DATE   --TBD
            --,last_day(sysdate)                                                   COMPLETION_DATE   --TBD
            ,c.BILL_TRANS_CURRENCY_CODE                                          BILL_TRNS_CURRENCY_CODE
            ,nvl((c.BILL_TRANS_BILL_AMOUNT),0)                                BILL_TRNS_AMOUNT
            ,s.project_number                                                        PROJECT_NUMBER
            ,c.task_number                                                      TASK_NUMBER
            ,NULL                                                                BILL_HOLD_FLAG
            ,NULL                                                                REVENUE_HOLD_FLAG
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
            ,NULL                                                                ATTRIBUTE_CATEGORY
            ,substr(c.reference1,1,20)                                           ATTRIBUTE1
            ,substr(c.reference1,1,20)                                           ATTRIBUTE2
            ,to_char(c.event_id)                                                 ATTRIBUTE3
            ,to_char(c.event_num)                                                ATTRIBUTE4
            ,'BOTH_BILL_REV_EVENT'                                               ATTRIBUTE5
            ,c.INVOICE_AR_NUMBER                                                 ATTRIBUTE6
            ,'OPEN_AR'                                                           ATTRIBUTE7
            ,to_char(c.invoice_date,'DD-MON-YYYY')                               ATTRIBUTE8
            ,c.bill_group                                                        ATTRIBUTE9
            ,'BILLING'                                                           ATTRIBUTE10
            ,s.PROJECT_CURRENCY_CODE                                     PROJECT_CURRENCY_CODE
            ,0                                                           PROJECT_BILL_AMOUNT
            ,c.PROJFUNC_CURRENCY_CODE                                    PROJFUNC_CURRENCY_CODE
            ,(c.PROJFUNC_BILL_AMOUNT)                                    PROJFUNC_BILL_AMOUNT
from XXMX_OPEN_AR_PRJ_EVT c,  XXMX_PPM_PROJECTS_STG s
where 1=1  
and c.project_number = s.project_number
--and c.INVOICE_AR_NUMBER in (select l.INVOICE_AR_NUMBER from xxmx_citco_open_ar_mv l WHERE l.status = 'Open')
and c.BILL_TRANS_BILL_AMOUNT <> 0
--and c.BILL_TRANS_REV_AMOUNT = c.BILL_TRANS_BILL_AMOUNT
union
--Revenue: Billed and earned event
            SELECT 
             NULL                                                                SOURCENAME
            ,c.task_number                                                      SOURCEREF
         --   ,haou.name                                                         ORGANIZATION_NAME
            ,s.ORGANIZATION_NAME                                                                ORGANIZATION_NAME
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
            ,NULL                                                                CONTRACT_TYPE_NAME
            ,NULL                                                                CONTRACT_NUMBER
            ,NULL                                                                CONTRACT_LINE_NUMBER			
            ,c.event_type						   	 EVENT_TYPE_NAME
            ,c.description                                                       EVENT_DESC
            ,c.completion_date                                                    COMPLETION_DATE   --TBD
            --,last_day(sysdate)                                                   COMPLETION_DATE   --TBD
            ,c.BILL_TRANS_CURRENCY_CODE                                          BILL_TRNS_CURRENCY_CODE
            ,nvl((c.BILL_TRANS_REV_AMOUNT),0)                                BILL_TRNS_AMOUNT
            ,s.project_number                                                        PROJECT_NUMBER
            ,c.task_number                                                      TASK_NUMBER
            ,NULL                                                                BILL_HOLD_FLAG
            ,NULL                                                                REVENUE_HOLD_FLAG
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
            ,NULL                                                                ATTRIBUTE_CATEGORY
            ,substr(c.reference1,1,20)                                           ATTRIBUTE1
            ,substr(c.reference1,1,20)                                           ATTRIBUTE2
            ,to_char(c.event_id)                                                 ATTRIBUTE3
            ,to_char(c.event_num)                                                ATTRIBUTE4
            ,'BOTH_BILL_REV_EVENT'                                               ATTRIBUTE5
            ,c.INVOICE_AR_NUMBER                                                 ATTRIBUTE6
            ,'OPEN_AR'                                                           ATTRIBUTE7
            ,to_char(c.invoice_date,'DD-MON-YYYY')                               ATTRIBUTE8
            ,c.bill_group                                                        ATTRIBUTE9
            ,'REVENUE'                                                           ATTRIBUTE10
            ,s.PROJECT_CURRENCY_CODE                                      PROJECT_CURRENCY_CODE
            ,0                                     PROJECT_BILL_AMOUNT
            ,c.PROJFUNC_CURRENCY_CODE                                            PROJFUNC_CURRENCY_CODE
            ,(c.PROJFUNC_REVENUE_AMOUNT)                                    PROJFUNC_BILL_AMOUNT
from XXMX_OPEN_AR_PRJ_EVT c,  XXMX_PPM_PROJECTS_STG s
where 1=1  
and c.project_number = s.project_number
--and c.INVOICE_AR_NUMBER in (select l.INVOICE_AR_NUMBER from xxmx_citco_open_ar_mv l WHERE l.status = 'Open')
and c.BILL_TRANS_REV_AMOUNT <> 0
--and c.BILL_TRANS_BILL_AMOUNT <> 0
--and c.BILL_TRANS_REV_AMOUNT = c.BILL_TRANS_BILL_AMOUNT
union
 --Revenue
 SELECT 
             NULL                                                                SOURCENAME
            ,e.task_number                                                      SOURCEREF
         --   ,haou.name                                                         ORGANIZATION_NAME
            ,s.ORGANIZATION_NAME                                                 ORGANIZATION_NAME
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
            ,NULL                                                                CONTRACT_TYPE_NAME
            ,NULL                                                                CONTRACT_NUMBER
            ,NULL                                                                CONTRACT_LINE_NUMBER			
            ,e.event_type						         EVENT_TYPE_NAME
            ,e.DESCRIPTION                                                       EVENT_DESC
            ,e.completion_date                                                   COMPLETION_DATE  
            --,last_day(sysdate)                                                 COMPLETION_DATE   --TBD
            ,e.BILL_TRANS_CURRENCY_CODE                                          BILL_TRNS_CURRENCY_CODE
            ,nvl((e.BILL_TRANS_REV_AMOUNT),0)                                    BILL_TRNS_AMOUNT
            ,e.project_number                                                    PROJECT_NUMBER
            ,e.task_number                                                       TASK_NUMBER
            ,NULL                                                                BILL_HOLD_FLAG
            ,NULL                                                                REVENUE_HOLD_FLAG
--            ,'N'                                                               BILL_HOLD_FLAG
--            ,'N'                                                               REVENUE_HOLD_FLAG
            ,NULL                                                                ATTRIBUTE_CATEGORY
            ,substr(cr.ebs_reference_1,1,20)                                              ATTRIBUTE1
            ,substr(cr.cr_reconciliation_number,1,20)                                        ATTRIBUTE2
            ,to_char(e.event_id)                                                          ATTRIBUTE3
            ,to_char(e.event_num)                                                         ATTRIBUTE4
            ,NULL                                                                ATTRIBUTE5
            ,(select i.INVOICE_AR_NUMBER
			from XXMX_OPEN_AR_PRJ_EVT i
              where i.project_number = e.project_number
              and i.task_number = e.task_number
			   and i.event_id =  e.event_id
			   and rownum < 2
              )                                                                  ATTRIBUTE6
            ,'OPEN_AR'                                                           ATTRIBUTE7
            ,(select to_char(i.INVOICE_DATE,'DD-MON-YYYY')  					
              from XXMX_OPEN_AR_PRJ_EVT i
              where i.project_number = e.project_number
              and i.task_number = e.task_number
			  and i.event_id =  e.event_id
			  and rownum < 2
              )                                                                  ATTRIBUTE8
            ,e.bill_group                                                        ATTRIBUTE9
            ,'REVENUE'                                                           ATTRIBUTE10
            ,e.PROJECT_CURRENCY_CODE                                      PROJECT_CURRENCY_CODE
            ,0                                                            PROJECT_BILL_AMOUNT
            ,e.PROJFUNC_CURRENCY_CODE                                      PROJFUNC_CURRENCY_CODE
            ,(e.PROJFUNC_REVENUE_AMOUNT)                                   PROJFUNC_BILL_AMOUNT
from xxmx_pa_events e, xxmx_contract_reg_map_data cr,  XXMX_PPM_PROJECTS_STG s
where (e.reference1 = cr.cr_reconciliation_number or e.event_id = cr.ebs_event_id)
and e.project_number = s.project_number
and exists (select null from xxmx_pa_events orphan_evt  where orphan_evt.reference1 = cr.ebs_reference_1)
and exists (select null from XXMX_OPEN_AR_PRJ_EVT oab 
            where oab.project_number = e.project_number
              and oab.task_number = e.task_number
              and oab.reference1 =  cr.EBS_REFERENCE_1
              --and oab.INVOICE_AR_NUMBER in (select l.INVOICE_AR_NUMBER from xxmx_citco_open_ar_mv l WHERE l.status = 'Open')
              )
--and cr.linetype='1'
--and e.event_type != 'Revenue Accrual'
and e.BILL_TRANS_REV_AMOUNT <> 0
--and e.BILL_TRANS_REV_AMOUNT <> e.BILL_TRANS_BILL_AMOUNT
union
--Tax Events   
 SELECT distinct 
             NULL                                                                SOURCENAME
            ,'TAX'                                                      SOURCEREF
         --   ,haou.name                                                         ORGANIZATION_NAME
            ,s.ORGANIZATION_NAME                                                                ORGANIZATION_NAME
           -- ,'Sell: Project Contract Type'                                     CONTRACT_TYPE_NAME
---            ,contr.contract_type                                              CONTRACT_TYPE_NAME
---            ,contr.contract_number                                            CONTRACT_NUMBER
---            ,contr.line_number                                                CONTRACT_LINE_NUMBER --Need to map(CL) Contract line number from lookup
            ,NULL                                                                CONTRACT_TYPE_NAME
            ,NULL                                                                CONTRACT_NUMBER
            ,NULL                                                                CONTRACT_LINE_NUMBER			
            ,'TAX-DM'						   				 EVENT_TYPE_NAME
            ,'DM Billing Tax Event'                                       EVENT_DESC
            --,'30-SEP-20'                                                       COMPLETION_DATE   --TBD
            ,c.invoice_date                                      COMPLETION_DATE   --TBD
            ,s.PROJECT_CURRENCY_CODE                                          BILL_TRNS_CURRENCY_CODE
            ,(select sum(l.extended_amount)
              from apps.ra_customer_trx_lines_all@XXMX_EXTRACT  l, apps.ra_customer_trx_all@XXMX_EXTRACT i
              where l.line_type = 'TAX'
                and i.customer_trx_id = l.customer_trx_id
                and i.trx_number = c.INVOICE_AR_NUMBER)                           BILL_TRNS_AMOUNT
            ,s.project_number                                                        PROJECT_NUMBER
            ,'TAX'                                                      TASK_NUMBER
            ,'N'                                                                BILL_HOLD_FLAG
            ,'N'                                                                REVENUE_HOLD_FLAG
            ,NULL                                                                ATTRIBUTE_CATEGORY
            ,NULL                                                                ATTRIBUTE1
            ,NULL                                                                ATTRIBUTE2
            ,'TAX'                                                               ATTRIBUTE3
            ,NULL                                                                ATTRIBUTE4
            ,NULL                                                                ATTRIBUTE5
            ,c.INVOICE_AR_NUMBER                                                 ATTRIBUTE6
            ,'OPEN_AR'                                                           ATTRIBUTE7
            ,to_char(c.invoice_date,'DD-MON-YYYY')                               ATTRIBUTE8
            ,c.bill_group                                                        ATTRIBUTE9
            ,'TAX'                                                               ATTRIBUTE10
            ,null                                     PROJECT_CURRENCY_CODE
            ,null                                     PROJECT_BILL_AMOUNT
            ,null                                     PROJFUNC_CURRENCY_CODE
            ,null                                     PROJFUNC_BILL_AMOUNT
from XXMX_OPEN_AR_PRJ_EVT c,  XXMX_PPM_PROJECTS_STG s
where 1=1  
and c.project_number = s.project_number
and c.BILL_TRANS_BILL_AMOUNT <> 0
;
