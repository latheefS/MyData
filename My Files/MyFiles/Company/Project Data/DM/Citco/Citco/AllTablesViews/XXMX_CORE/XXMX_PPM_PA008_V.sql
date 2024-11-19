--------------------------------------------------------
--  DDL for View XXMX_PPM_PA008_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_PA008_V" ("OU_NAME", "ORGANIZATION_ID", "PROJECT_CURRENCY_CODE", "PROJECT_FUNC_CURRENCY_CODE", "TRANS_CURRENCY_CODE", "PROJECT_OWN_ORG_ID", "PROJECT_OWNING_ORGANIZATION", "PROJECT_NUMBER", "PROJECT_ID", "CUSTOMER_NAME", "CUSTOMER_NUMBER", "NAME", "PROJECT_LONG_NAME", "TASK_ID", "TASK_NUMBER", "BILL_TO_DATE_PROJ_FUNC", "BILL_TO_DATE_PROJ", "BILL_TO_DATE_TRANS", "EARNED_TO_DATE_PROJ_FUNC", "EARNED_TO_DATE_PROJ", "EARNED_TO_DATE_TRANS") AS 
  SELECT            
                  ou.name ou_name,
                  ou.organization_id, 
                  ppa.project_currency_code,
                  gsob.currency_code project_func_currency_code,
                  Coalesce(inv.trans_currency_code, rev.trans_currency_code ) as trans_currency_code,
                  ppa.carrying_out_organization_id project_own_org_id,
                  haou.name project_owning_organization,
                  ppa.segment1 project_number,
                  ppa.project_id,
                  hp.party_name customer_name,
                  hp.party_number customer_number,
                  ppa.name,
                  ppa.long_name project_long_name,  
                  pt.task_id, 
                  pt.task_number,               
                  (SELECT SUM(pdii.projfunc_bill_amount)
                     FROM pa.pa_draft_invoice_items@xxmx_Extract pdii ,
                             pa.pa_draft_invoices_all@xxmx_Extract pdi
                    WHERE pdii.project_id = pdi.project_id
					AND coalesce(pdi.write_off_flag, 'A') <> 'Y'                          
                      AND pdii.draft_invoice_num = pdi.draft_invoice_num              
                      AND pdii.project_id = ppa.project_id
                      AND pdii.task_id = pt.task_id
                      AND TRUNC(pdi.gl_date) <= NVL((SELECT distinct TRUNC(end_date)
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-22'),TRUNC(pdi.gl_date))
                                                       AND pdi.transfer_status_code in ('P','A','T'))  bill_to_date_proj_func ,
                  
                  (SELECT SUM(pdii.project_bill_amount)
                     FROM pa.pa_draft_invoice_items@xxmx_Extract pdii ,
                             pa.pa_draft_invoices_all@xxmx_Extract pdi
                    WHERE pdii.project_id = pdi.project_id
					AND coalesce(pdi.write_off_flag, 'A') <> 'Y'                         					
                      AND pdii.draft_invoice_num = pdi.draft_invoice_num              
                      AND pdii.project_id = ppa.project_id
                      AND pdii.task_id = pt.task_id
                      AND TRUNC(pdi.gl_date) <= NVL((SELECT distinct TRUNC(end_date)
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-22'),TRUNC(pdi.gl_date))
                                                       AND pdi.transfer_status_code in ('P','A','T'))  bill_to_date_proj,
 	(SELECT SUM(pdii.amount)
                     FROM pa.pa_draft_invoice_items@xxmx_Extract pdii ,
                             pa.pa_draft_invoices_all@xxmx_Extract pdi
                    WHERE pdii.project_id = pdi.project_id
					AND coalesce(pdi.write_off_flag, 'A') <> 'Y'                         						
                      AND pdii.draft_invoice_num = pdi.draft_invoice_num              
                      AND pdii.project_id = ppa.project_id
                      AND pdii.task_id = pt.task_id
                      AND TRUNC(pdi.gl_date) <= NVL((SELECT distinct TRUNC(end_date)
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-21'),TRUNC(pdi.gl_date))
                                                       AND pdi.transfer_status_code in ('P','A','T'))  bill_to_date_trans,
                  
                  (SELECT SUM(pdri.amount)
                     FROM pa.pa_draft_revenue_items@xxmx_Extract pdri ,
                          pa.pa_draft_revenues_all@xxmx_Extract pdr
                    WHERE pdri.project_id = pdr.project_id
                      AND pdri.draft_revenue_num = pdr.draft_revenue_num              
                      AND pdri.project_id = ppa.project_id
                      AND pdri.task_id = pt.task_id 
                      AND TRUNC(pdr.gl_date) <= NVL((SELECT distinct TRUNC(end_date) 
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-21'),TRUNC(pdr.gl_date))
                                                     AND pdr.transfer_status_code in ('P','A'))  earned_to_date_proj_func,
                                                     
                                              
                  
                   (SELECT SUM(pdri.project_revenue_amount)
                     FROM pa.pa_draft_revenue_items@xxmx_Extract pdri ,
                          pa.pa_draft_revenues_all@xxmx_Extract pdr
                    WHERE pdri.project_id = pdr.project_id
                      AND pdri.draft_revenue_num = pdr.draft_revenue_num              
                      AND pdri.project_id = ppa.project_id
                      AND pdri.task_id = pt.task_id 
                      AND TRUNC(pdr.gl_date) <= NVL((SELECT distinct TRUNC(end_date) 
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-21'),TRUNC(pdr.gl_date))
                                                     AND pdr.transfer_status_code in ('P','A'))  earned_to_date_proj, 
                    
                    (SELECT SUM(pdri.revtrans_amount)
                     FROM pa.pa_draft_revenue_items@xxmx_Extract pdri ,
                          pa.pa_draft_revenues_all@xxmx_Extract pdr
                    WHERE pdri.project_id = pdr.project_id
                      AND pdri.draft_revenue_num = pdr.draft_revenue_num              
                      AND pdri.project_id = ppa.project_id
                      AND pdri.task_id = pt.task_id 
                      AND TRUNC(pdr.gl_date) <= NVL((SELECT distinct TRUNC(end_date) 
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                      WHERE period_name = 'JUN-21'),TRUNC(pdr.gl_date))
                                                     AND pdr.transfer_status_code in ('P','A'))  earned_to_date_trans
                                            
             FROM apps.hr_operating_units@xxmx_Extract ou
                  inner join pa.pa_projects_all@xxmx_Extract ppa on ou.organization_id = ppa.org_id
                  inner join apps.gl_sets_of_books@xxmx_Extract gsob on ou.set_of_books_id = gsob.set_of_books_id
                  inner join hr.hr_all_organization_units@xxmx_Extract haou on haou.organization_id =   ppa.carrying_out_organization_id
                  inner join pa.pa_project_customers@xxmx_Extract ppc on  ppa.project_id = ppc.project_id
                  inner join ar.hz_cust_accounts@xxmx_Extract hca on ppc.customer_id = hca.cust_account_id
                  inner join ar.hz_parties@xxmx_Extract hp on  hca.party_id =  hp.party_id 
                  inner join pa.pa_tasks@xxmx_Extract pt on ppa.project_id = pt.project_id
                  inner join pa.pa_all_organizations@xxmx_Extract pao on  ou.organization_id = pao.org_id and haou.organization_id = pao.organization_id and pao.pa_org_use_type = 'PROJECTS'   
                  inner join pa.pa_project_types_all@xxmx_Extract ppta on ppta.project_type = ppa.project_type  AND ppta.project_type_class_code = 'CONTRACT' 
                  left join (SELECT pdii.project_id, pdii.task_id, max(pdi.INV_CURRENCY_CODE) as trans_currency_code
                                    FROM pa.pa_draft_invoice_items@xxmx_Extract pdii ,
                                     pa.pa_draft_invoices_all@xxmx_Extract pdi
                                     WHERE pdii.project_id = pdi.project_id
									 	AND coalesce(pdi.write_off_flag, 'A') <> 'Y'                         	
                                           AND pdii.draft_invoice_num = pdi.draft_invoice_num              
                                           AND TRUNC(pdi.gl_date) <= NVL((SELECT  distinct TRUNC(end_date)
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                           WHERE period_name = 'JUN-21'),TRUNC(pdi.gl_date))
                                           AND pdi.transfer_status_code in ('P','A','T')
                            GROUP BY pdii.project_id, pdii.task_id
                            
                                                       
                            ) inv on inv.project_id = ppa.project_id AND inv.task_id = pt.task_id 
                  left join (SELECT  pdri.project_id,  pdri.task_id, max(pdri.revtrans_currency_code) as trans_currency_code
                                     FROM pa.pa_draft_revenue_items@xxmx_Extract pdri ,
                                          pa.pa_draft_revenues_all@xxmx_Extract pdr
                                     WHERE pdri.project_id = pdr.project_id
                                         AND pdri.draft_revenue_num = pdr.draft_revenue_num              
                                         AND TRUNC(pdr.gl_date) <= NVL((SELECT distinct TRUNC(end_date) 
                                                       FROM gl.gl_periods@xxmx_Extract 
                                                       WHERE period_name = 'JUN-21'),TRUNC(pdr.gl_date))
                                                       AND pdr.transfer_status_code in ('P','A')
                                             GROUP BY  pdri.project_id,  pdri.task_id
                            ) rev on rev.project_id = ppa.project_id AND rev.task_id = pt.task_id 
                                                     
            where inv.project_id is not null or rev.project_id is not null
;
