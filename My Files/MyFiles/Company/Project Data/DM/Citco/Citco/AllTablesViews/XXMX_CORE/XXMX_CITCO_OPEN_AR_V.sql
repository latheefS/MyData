--------------------------------------------------------
--  DDL for View XXMX_CITCO_OPEN_AR_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_CITCO_OPEN_AR_V" ("CUSTOMER_TRX_ID", "INVOICE_ID", "DRAFT_NUMBER", "BILL_THROUGH_DATE", "INVOICE_DATE", "INVOICE_CLASS", "INVOICE_CURRENCY", "APPROVED_DATE", "APPROVED_BY_PERSON", "CREATION_DATE", "CREATED_BY_USER", "CREATED_BY_PERSON", "RELEASED_DATE", "RELEASED_BY_PERSON", "INVOICE_AR_NUMBER", "CREDITED_DRAFT_INVOICE", "CREDITED_AR_NUMBER", "STATUS", "GL_DATE_CLOSED", "COLLECTION_DAYS", "DUE_DATE", "PRINTED") AS 
  SELECT 
         trall.customer_trx_id
        ,pdi.project_id ||'_'||pdi.DRAFT_INVOICE_NUM invoice_id
        ,pdi.DRAFT_INVOICE_NUM draft_number
        ,trunc(pdi.BILL_THROUGH_DATE) bill_through_date
        ,trunc(p.TRX_DATE) invoice_date
        ,LK3.MEANING invoice_class
        ,pdi.INV_CURRENCY_CODE invoice_currency
        ,trunc(pdi.APPROVED_DATE) APPROVED_DATE
        ,app_per.full_name Approved_by_Person
        ,trunc(pdi.CREATION_DATE)  CREATION_DATE
        ,fnd_usr.USER_NAME Created_by_User
        ,cre_per.full_name Created_by_Person
        ,trunc(pdi.RELEASED_DATE)  RELEASED_DATE
        ,rel_per.full_name Released_by_Person
        ,pdi.RA_INVOICE_NUMBER Invoice_AR_number
        ,pdi.DRAFT_INVOICE_NUM_CREDITED Credited_draft_invoice
        ,car.RA_INVOICE_NUMBER Credited_AR_number
        ,case when nvl(p.status,'N\A')='CL' 
		      then 'Closed' 
			  else 
              case when nvl(p.status,'N\A')='OP' 
			       then 'Open' 
				   else 'Non Applicable' 
			  end 
	     end status
        ,case when trunc(p.gl_date_closed) =to_date('31-12-4712','DD-MM-RRRR') 
		      then null 
			  else trunc(p.gl_date_closed) 
		  end as gl_date_closed
        ,case when trunc(p.gl_date_closed) =to_date('31-12-4712','DD-MM-RRRR') 
		      then null 
			  else  trunc(p.gl_date_closed) - trunc(p.TRX_DATE) 
		  end  as collection_days
        ,trunc(p.due_date) as due_date
        ,case when trall.printing_pending = 'Y' 
		      then 'No' 
			  else 'Yes'  
		  end as Printed
    from  pa_draft_invoices_all@xxmx_extract pdi 
        inner join  pa_projects_all@xxmx_extract ppa 
		        on (pdi.project_id = ppa.project_id)
        inner join  hr_operating_units@xxmx_extract  hou     
		        on (hou.organization_id = ppa.org_id)
         left join ar.AR_PAYMENT_SCHEDULES_ALL@xxmx_extract p  
		        on pdi.ra_invoice_number=p.trx_number
         left join (select project_id, DRAFT_INVOICE_NUM, max(RA_INVOICE_NUMBER) RA_INVOICE_NUMBER,
                    max(CANCELED_FLAG) CANCELED_FLAG 
                    from pa.pa_draft_invoices_all@xxmx_extract 
                    where DRAFT_INVOICE_NUM_CREDITED is null
                    group by project_id, DRAFT_INVOICE_NUM ) car 
		        on car.project_id=pdi.PROJECT_ID 
                   and pdi.DRAFT_INVOICE_NUM_CREDITED=car.DRAFT_INVOICE_NUM
         left join  PER_ALL_PEOPLE_F@xxmx_extract app_per 
		        ON (app_per.person_id = pdi.APPROVED_BY_PERSON_ID) AND  (trunc(SYSDATE) BETWEEN app_per.effective_start_date AND app_per.effective_end_date)
         left join  PER_ALL_PEOPLE_F@xxmx_extract rel_per 
		        ON (rel_per.person_id = pdi.RELEASED_BY_PERSON_ID) AND  (trunc(SYSDATE) BETWEEN rel_per.effective_start_date AND rel_per.effective_end_date)
         left join  FND_USER@xxmx_extract fnd_usr 
		        ON ( pdi.CREATED_BY =  fnd_usr.USER_ID) 
         left join  PER_ALL_PEOPLE_F@xxmx_extract cre_per 
		        ON (cre_per.person_id = fnd_usr.employee_id) AND  (trunc(SYSDATE) BETWEEN cre_per.effective_start_date AND cre_per.effective_end_date)
         left join  pa_lookups@xxmx_extract lk on lk.lookup_type = 'INVOICE/REVENUE STATUS' AND lk.lookup_code =
        decode(pdi.generation_error_flag, 'Y', 'GENERATION ERROR',
        decode(pdi.approved_date, NULL, 'UNAPPROVED',
        decode(pdi.released_date, NULL, 'APPROVED',
        decode(pdi.transfer_status_code,
        'P', 'RELEASED',
        'X', 'REJECTED IN TRANSFER',
        'T', 'TRANSFERRED',
        'A', 'ACCEPTED',
        'R', 'REJECTED'
        ))))
        left join  PA_LOOKUPS@xxmx_extract LK3
               ON LK3.LOOKUP_TYPE = 'INVOICE_CLASS'
        AND LK3.LOOKUP_CODE = DECODE(car.CANCELED_FLAG, 'Y', 'CANCEL'
        , DECODE(pdi.WRITE_OFF_FLAG, 'Y', 'WRITE_OFF'
        , DECODE(pdi.CONCESSION_FLAG, 'Y', 'CONCESSION'
        , DECODE(NVL(pdi.DRAFT_INVOICE_NUM_CREDITED, 0), 0, 'INVOICE', 'CREDIT_MEMO'))))
        AND LK3.ENABLED_FLAG = 'Y'
        AND TRUNC(SYSDATE) BETWEEN TRUNC(NVL(LK3.START_DATE_ACTIVE, SYSDATE - 1))
        AND TRUNC(NVL(LK3.END_DATE_ACTIVE, SYSDATE))
        left join AR.RA_CUSTOMER_TRX_ALL@xxmx_extract trall on p.CUSTOMER_TRX_ID = trall.customer_trx_id
    where (p.class<>'PMT' or p.class is null) and pdi.project_id is not null
;
