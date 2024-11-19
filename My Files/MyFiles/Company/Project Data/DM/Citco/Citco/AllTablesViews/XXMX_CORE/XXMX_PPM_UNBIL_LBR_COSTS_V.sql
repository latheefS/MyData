--------------------------------------------------------
--  DDL for View XXMX_PPM_UNBIL_LBR_COSTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_UNBIL_LBR_COSTS_V" ("TRANSACTION_TYPE", "BUSINESS_UNIT", "ORG_ID", "USER_TRANSACTION_SOURCE", "TRANSACTION_SOURCE_ID", "DOCUMENT_NAME", "DOCUMENT_ID", "DOC_ENTRY_NAME", "DOC_ENTRY_ID", "EXP_BATCH_NAME", "BATCH_ENDING_DATE", "BATCH_DESCRIPTION", "EXPENDITURE_ITEM_DATE", "PERSON_NUMBER", "PERSON_NAME", "PERSON_ID", "HCM_ASSIGNMENT_NAME", "HCM_ASSIGNMENT_ID", "PROJECT_NUMBER", "PROJECT_NAME", "PROJECT_ID", "TASK_NUMBER", "TASK_NAME", "TASK_ID", "EXPENDITURE_TYPE", "EXPENDITURE_TYPE_ID", "ORGANIZATION_NAME", "ORGANIZATION_ID", "NON_LABOR_RESOURCE", "NON_LABOR_RESOURCE_ID", "NON_LABOR_RESOURCE_ORG", "NON_LABOR_RESOURCE_ORG_ID", "QUANTITY", "UNIT_OF_MEASURE_NAME", "UNIT_OF_MEASURE", "WORK_TYPE", "WORK_TYPE_ID", "BILLABLE_FLAG", "CAPITALIZABLE_FLAG", "ACCRUAL_FLAG", "SUPPLIER_NUMBER", "SUPPLIER_NAME", "VENDOR_ID", "INVENTORY_ITEM_NAME", "INVENTORY_ITEM_ID", "ORIG_TRANSACTION_REFERENCE", "UNMATCHED_NEGATIVE_TXN_FLAG", "REVERSED_ORIG_TXN_REFERENCE", "EXPENDITURE_COMMENT", "GL_DATE", "DENOM_CURRENCY_CODE", "DENOM_CURRENCY", "DENOM_RAW_COST", "DENOM_BURDENED_COST", "RAW_COST_CR_CCID", "RAW_COST_CR_ACCOUNT", "RAW_COST_DR_CCID", "RAW_COST_DR_ACCOUNT", "BURDENED_COST_CR_CCID", "BURDENED_COST_CR_ACCOUNT", "BURDENED_COST_DR_CCID", "BURDENED_COST_DR_ACCOUNT", "BURDEN_COST_CR_CCID", "BURDEN_COST_CR_ACCOUNT", "BURDEN_COST_DR_CCID", "BURDEN_COST_DR_ACCOUNT", "ACCT_CURRENCY_CODE", "ACCT_CURRENCY", "ACCT_RAW_COST", "ACCT_BURDENED_COST", "ACCT_RATE_TYPE", "ACCT_RATE_DATE", "ACCT_RATE_DATE_TYPE", "ACCT_EXCHANGE_RATE", "ACCT_EXCHANGE_ROUNDING_LIMIT", "RECEIPT_CURRENCY_CODE", "RECEIPT_CURRENCY", "RECEIPT_CURRENCY_AMOUNT", "RECEIPT_EXCHANGE_RATE", "CONVERTED_FLAG", "CONTEXT_CATEGORY", "USER_DEF_ATTRIBUTE1", "USER_DEF_ATTRIBUTE2", "USER_DEF_ATTRIBUTE3", "USER_DEF_ATTRIBUTE4", "USER_DEF_ATTRIBUTE5", "USER_DEF_ATTRIBUTE6", "USER_DEF_ATTRIBUTE7", "USER_DEF_ATTRIBUTE8", "USER_DEF_ATTRIBUTE9", "USER_DEF_ATTRIBUTE10", "RESERVED_ATTRIBUTE1", "RESERVED_ATTRIBUTE2", "RESERVED_ATTRIBUTE3", "RESERVED_ATTRIBUTE4", "RESERVED_ATTRIBUTE5", "RESERVED_ATTRIBUTE6", "RESERVED_ATTRIBUTE7", "RESERVED_ATTRIBUTE8", "RESERVED_ATTRIBUTE9", "RESERVED_ATTRIBUTE10", "ATTRIBUTE_CATEGORY", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE9", "ATTRIBUTE8", "ATTRIBUTE10", "CONTRACT_NUMBER", "CONTRACT_NAME", "CONTRACT_ID", "FUNDING_SOURCE_NUMBER", "FUNDING_SOURCE_NAME", "COST_TYPE", "BILL_GROUP", "AR_INVOICE_NUMBER", "PROJECT_CURRENCY_CODE", "PROJECT_RAW_COST") AS 
  select  Transaction_type --  LABOR, NONLABOR
                ,business_unit --Nullify we consider BU based on Project Number
                ,org_id
                ,user_transaction_source
                ,transaction_source_id
                ,document_name
                ,document_id
                ,doc_entry_name
                ,doc_entry_id
                ,exp_batch_name
                ,batch_ending_date
                ,batch_description
                ,expenditure_item_date
                ,person_number
                ,person_name
                ,person_id
                ,hcm_assignment_name
                ,hcm_assignment_id
                ,project_number
                ,project_name
                ,project_id
                ,task_number
                ,task_name
                ,task_id
                ,expenditure_type
                ,expenditure_type_id
                ,organization_name                                                               --Organization_name
                ,organization_id
                ,non_labor_resource
                ,non_labor_resource_id
                ,non_labor_resource_org
                ,non_labor_resource_org_id
                ,quantity            
                ,unit_of_measure_name
                ,unit_of_measure
                ,work_type
                ,work_type_id
                ,billable_flag
                ,capitalizable_flag
                ,accrual_flag
                ,supplier_number
                ,supplier_name
                ,vendor_id
                ,inventory_item_name
                ,inventory_item_id
                ,orig_transaction_reference
                ,unmatched_negative_txn_flag
                ,reversed_orig_txn_reference
                ,expenditure_comment
                ,gl_date
                ,denom_currency_code
                ,denom_currency
                ,denom_raw_cost
                ,denom_burdened_cost
                ,raw_cost_cr_ccid
                ,raw_cost_cr_account
                ,raw_cost_dr_ccid
                ,raw_cost_dr_account
                ,burdened_cost_cr_ccid
                ,burdened_cost_cr_account
                ,burdened_cost_dr_ccid
                ,burdened_cost_dr_account
                ,burden_cost_cr_ccid
                ,burden_cost_cr_account
                ,burden_cost_dr_ccid
                ,burden_cost_dr_account
                ,acct_currency_code
                ,acct_currency
                ,acct_raw_cost
                ,acct_burdened_cost
                ,acct_rate_type 
                ,acct_rate_date
                ,acct_rate_date_type
                ,acct_exchange_rate
                ,acct_exchange_rounding_limit
                ,receipt_currency_code
                ,receipt_currency
                ,receipt_currency_amount
                ,receipt_exchange_rate
                ,converted_flag
                ,context_category
                ,user_def_attribute1
                ,user_def_attribute2
                ,user_def_attribute3
                ,user_def_attribute4
                ,user_def_attribute5
                ,user_def_attribute6
                ,user_def_attribute7
                ,user_def_attribute8
                ,user_def_attribute9
                ,user_def_attribute10
                ,reserved_attribute1
                ,reserved_attribute2
                ,reserved_attribute3
                ,reserved_attribute4
                ,reserved_attribute5
                ,reserved_attribute6
                ,reserved_attribute7
                ,reserved_attribute8
                ,reserved_attribute9
                ,reserved_attribute10
                ,attribute_category
                ,attribute1
                ,attribute2
                ,attribute3
                ,attribute4
                ,attribute5
                ,attribute6
                ,attribute7
                ,attribute9
                ,attribute8
                ,attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
                ,contract_number
                ,contract_name
                ,contract_id
                ,funding_source_number
                ,funding_source_name                                                                                                          funding_source_name
				,cost_type
                ,bill_group
                ,ar_invoice_number
                ,project_currency_code
                ,project_raw_cost            
           from(    SELECT   --Added to extract Costs against Open AR Invoices 
             'LABOR'                                                                                                              transaction_type --  LABOR, NONLABOR
            ,pa_costs.business_unit                                                                                           business_unit --Nullify as we consider BU based on Project Number
            ,NULL                                                                                                             org_id
            ,null                                                                                                             user_transaction_source
            ,NULL                                                                                                             transaction_source_id
            ,NULL                                                                                                             document_name
            ,NULL                                                                                                             document_id
            ,NULL                                                                                                             doc_entry_name
            ,NULL                                                                                                             doc_entry_id
            --  'Data Migration'                                                                                              exp_batch_name
            ,pa_costs.exp_batch_name                                                                 exp_batch_name
            ,pa_costs.batch_ending_date                                                                 batch_ending_date
            ,pa_costs.batch_description                                                                 batch_description
            ,pa_costs.expenditure_item_date                                                                                       expenditure_item_date
            ,pa_costs.person_number                                                                                                             person_number
            ,NULL                                                                                                             person_name
            ,NULL                                                                                                             person_id
            ,j.name                                                                                                             hcm_assignment_name
            ,NULL                                                                                                             hcm_assignment_id
            ,ppa.project_number                                                                                               project_number
            ,NULL                                                                                                 project_name
            ,NULL                                                                                                             project_id
            ,pa_costs.task_number                                                                                                   task_number
            ,NULL                                                                                                     task_name
            ,NULL                                                                                                             task_id
            ,pa_costs.expenditure_type                                                                                            expenditure_type
            ,NULL                                                                                                             expenditure_type_id
            ,pa_costs.organization_name                                                               organization_name
            ,NULL                                                                                                             organization_id -- POO from Project Number Mapped in EDQ
            ,NULL                                                                                                             non_labor_resource
            ,NULL                                                                                                             non_labor_resource_id
            ,null                                                                                                             non_labor_resource_org
            ,NULL                                                                                                             non_labor_resource_org_id
            ,pa_costs.quantity                                                                                                    quantity
            ,NULL                                                                                                             unit_of_measure_name
            ,pa_costs.unit_of_measure                                                                                             unit_of_measure
            ,pa_costs.work_type                                                                    work_type
            ,NULL                                                                                                             work_type_id
            ,pa_costs.billable_flag                                                                                               billable_flag
            ,NULL                                                                                                             capitalizable_flag
            ,NULL                                                                                                             accrual_flag
            ,NULL                                                                                                             supplier_number
            ,NULL                                                                                                             supplier_name
            ,NULL                                                                                                             vendor_id
            ,NULL                                                                                                             inventory_item_name
            ,NULL                                                                                                             inventory_item_id
            ,pa_costs.orig_transaction_reference                                                                              orig_transaction_reference
            ,NULL                                                                                                             unmatched_negative_txn_flag
            ,NULL                                                                                                             reversed_orig_txn_reference
            ,pa_costs.expenditure_comment                                                                                     expenditure_comment
            ,pa_costs.gl_date                                                                                                    gl_date
           -- ,NULL                                                                                                  gl_date
            ,pa_costs.denom_currency_code                                                                                         denom_currency_code
            ,NULL                                                                                                             denom_currency
            ,pa_costs.denom_raw_cost                                                                                              denom_raw_cost
            ,pa_costs.denom_burdened_cost                                                                                         denom_burdened_cost
            ,NULL                                                                                                             raw_cost_cr_ccid
            ,pa_costs.raw_cost_cr_account                                                                                                             raw_cost_cr_account
            ,NULL                                                                                                             raw_cost_dr_ccid
            ,pa_costs.raw_cost_dr_account                                                                                                             raw_cost_dr_account
            ,NULL                                                                                                             burdened_cost_cr_ccid
            ,NULL                                                                                                             burdened_cost_cr_account
            ,NULL                                                                                                             burdened_cost_dr_ccid
            ,NULL                                                                                                             burdened_cost_dr_account
            ,NULL                                                                                                             burden_cost_cr_ccid
            ,NULL                                                                                                             burden_cost_cr_account
            ,NULL                                                                                                             burden_cost_dr_ccid
            ,NULL                                                                                                             burden_cost_dr_account
            ,pa_costs.acct_currency_code                                                                                          acct_currency_code
            ,NULL                                                                                                             acct_currency
            ,pa_costs.acct_raw_cost                                                                                               acct_raw_cost  -- based on UAT recon from business recon report
            ,pa_costs.acct_burdened_cost                                                                                          acct_burdened_cost
            ,pa_costs.acct_rate_type                                                                                              acct_rate_type
            ,pa_costs.acct_rate_date                                                                                              acct_rate_date
            ,NULL                                                                                                             acct_rate_date_type
            ,pa_costs.acct_exchange_rate                                                                                          acct_exchange_rate
            ,NULL                                                                                                             acct_exchange_rounding_limit
            ,NULL                                                                                                             receipt_currency_code
            ,NULL                                                                                                             receipt_currency
            ,NULL                                                                                                             receipt_currency_amount
            ,NULL                                                                                                             receipt_exchange_rate
            ,pa_costs.converted_flag                                                                                              converted_flag
            ,NULL                                                                                                             context_category
            ,NULL                                                                                                             user_def_attribute1
            ,NULL                                                                                                             user_def_attribute2
            ,NULL                                                                                                             user_def_attribute3
            ,NULL                                                                                                             user_def_attribute4
            ,NULL                                                                                                             user_def_attribute5
            ,NULL                                                                                                             user_def_attribute6
            ,NULL                                                                                                             user_def_attribute7
            ,NULL                                                                                                             user_def_attribute8
            ,NULL                                                                                                             user_def_attribute9
            ,NULL                                                                                                             user_def_attribute10
            ,NULL                                                                                                             reserved_attribute1
            ,NULL                                                                                                             reserved_attribute2
            ,NULL                                                                                                             reserved_attribute3
            ,NULL                                                                                                             reserved_attribute4
            ,NULL                                                                                                             reserved_attribute5
            ,NULL                                                                                                             reserved_attribute6
            ,NULL                                                                                                             reserved_attribute7
            ,NULL                                                                                                             reserved_attribute8
            ,NULL                                                                                                             reserved_attribute9
            ,NULL                                                                                                             reserved_attribute10
            ,NULL                                                                                                             attribute_category
            ,pa_costs.expenditure_item_id                                                                                     attribute1
            ,NULL                                                                                                             attribute2
            ,NULL                                                                                                             attribute3
            ,NULL                                                                                                             attribute4
            ,NULL                                                                                                             attribute5
            ,NULL                                                                                                             attribute6
            ,NULL                                                                                                             attribute7
            ,NULL                                                                                                             attribute9
            ,NULL                                                                                                             attribute8
            ,null                                                                                                             attribute10 -- to split costs Labor, NonLabor and Misc in EDQ
            ,NULL                                                                                                             contract_number
            ,NULL                                                                                                             contract_name
            ,NULL                                                                                                             contract_id
            ,NULL                                                                                                             funding_source_number
            ,NULL                                                                                                             funding_source_name
            ,'UNBILLED' cost_type
            ,pa_costs.bill_group  bill_group
            ,null ar_invoice_number--pa_costs.ar_invoice_number
            ,pa_costs.ACCT_CURRENCY_CODE project_currency_code
            ,pa_costs.ACCT_RAW_COST      project_raw_cost
            FROM  xxmx_ppm_projects_stg                               ppa
			 --    ,xxmx_open_ar_costs                                  pa_costs
                ,  xxmx_pa_costs pa_costs
                 --,XXMX_PA_EXPENDITURE_ITEMS_ALL                       e
                 ,xxmx_unbilled_exp_items e
                 , xxmx_hcm_asg_jobs j
            WHERE 1                                       = 1
              and pa_costs.project_id                     = ppa.project_id
			  and pa_costs.expenditure_type              = 'Labor'
              and e.EXPENDITURE_ITEM_ID = pa_costs.EXPENDITURE_ITEM_ID
              and j.EXPENDITURE_ITEM_ID = e.EXPENDITURE_ITEM_ID
              --AND nvl(e.net_zero_adjustment_flag,'N') <> 'Y'
               --AND j.person_number = pa_costs.person_number
               --and nvl(e.bill_amount , -1 ) <> 0
            --  AND e.expenditure_item_Date between j.effective_start_Date and j.effective_End_Date              
           -- AND NOT EXISTS ( SELECT 1 FROM apps.pa_tasks@xxmx_extract b WHERE b.parent_task_id=e.task_id)
           --   and pa_costs.ar_invoice_number in (select l.INVOICE_AR_NUMBER from xxmx_citco_open_ar_mv l WHERE l.status = 'Open')
       )
;
