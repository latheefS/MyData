--------------------------------------------------------
--  DDL for View XXMX_PPM_LBR_COSTS_CSV_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_PPM_LBR_COSTS_CSV_V" ("OUTPUT", "BATCHNAME") AS 
  SELECT
                      '"'|| transaction_type            ||'"'
               ||','||'"'|| business_unit                       ||'"'
               ||','||'"'|| NULL                       ||'"'  --org_id
               ||','||'"'|| user_transaction_source      ||'"'
               ||','||'"'|| transaction_source_id        ||'"'
               ||','||'"'|| document_name                ||'"'
               ||','||'"'|| document_id                  ||'"'
               ||','||'"'|| doc_entry_name               ||'"'
               ||','||'"'|| doc_entry_id                 ||'"'
               ||','||'"'|| exp_batch_name                   ||'"'
               ||','||'"'|| to_char(batch_ending_date, 'YYYY/MM/DD')             ||'"'
               ||','||'"'|| batch_description            ||'"'
               ||','||'"'|| to_char(expenditure_item_date, 'YYYY/MM/DD')        ||'"'
--               ||','||'"'|| '2022/02/28'        ||'"'
               ||','||'"'|| person_number             ||'"'
               ||','||'"'|| null                  ||'"'  --person_name
               ||','||'"'|| null                    ||'"' --person_id
               ||','||'"'|| null          ||'"' --hcm_assignment_name
               ||','||'"'|| null            ||'"' --hcm_assignment_id
               ||','||'"'|| project_number               ||'"'
               ||','||'"'|| null                           ||'"'   --project_name
               ||','||'"'|| null                  ||'"'
               ||','||'"'|| task_number                  ||'"'
--               ||','||'"'|| task_name                    ||'"'
               ||','||'"'|| ''                           ||'"'   --task_name
               ||','||'"'|| null                      ||'"'  --task_id
--               ||','||'"'|| expenditure_type             ||'"'
               ||','||'"'|| expenditure_type     ||'"'
               ||','||'"'|| null          ||'"'
               ||','||'"'|| organization_name            ||'"'
               ||','||'"'|| null              ||'"'
--               ||','||'"'|| non_labor_resource           ||'"'
--               ||','||'"'|| non_labor_resource_id        ||'"'
--               ||','||'"'|| non_labor_resource_org       ||'"'
--               ||','||'"'|| non_labor_resource_org_id    ||'"'
               ||','||'"'|| quantity                     ||'"'
               ||','||'"'|| null                         ||'"'  --unit_of_measure_name
               ||','||'"'|| nvl(unit_of_measure,'HOURS')              ||'"'  --unit_of_measure
               ||','||'"'|| null                    ||'"'   --work_type
               ||','||'"'|| null               ||'"'        --work_type_id
               ||','||'"'|| billable_flag                ||'"'
               ||','||'"'|| capitalizable_flag           ||'"'
--               ||','||'"'|| accrual_flag                 ||'"'
--               ||','||'"'|| supplier_number              ||'"'
--               ||','||'"'|| supplier_name                ||'"'
--               ||','||'"'|| vendor_id                    ||'"'
--               ||','||'"'|| inventory_item_name          ||'"'
--               ||','||'"'|| inventory_item_id            ||'"'
--               ||','||'"'|| orig_transaction_reference   ||'"'
               ||','||'"'|| nvl(orig_transaction_reference,'BLANK_VALUE')                    ||'"'   --orig_transaction_reference
               ||','||'"'|| unmatched_negative_txn_flag  ||'"'
               ||','||'"'|| reversed_orig_txn_reference  ||'"'
               ||','||'"'|| replace(REGEXP_REPLACE(expenditure_comment, '[^[:print:]]',''),'"','')         ||'"'
               ||','||'"'|| to_char(nvl(gl_date,sysdate), 'YYYY/MM/DD')                       ||'"'
--               ||','||'"'|| '2022/11/24'                     ||'"' 
               ||','||'"'|| denom_currency_code          ||'"'
               ||','||'"'|| denom_currency               ||'"'
               ||','||'"'|| denom_raw_cost               ||'"'
               ||','||'"'|| null          ||'"'  --denom_burdened_cost
               ||','||'"'|| raw_cost_cr_ccid             ||'"'
               ||','||'"'|| raw_cost_cr_account          ||'"'
               ||','||'"'|| raw_cost_dr_ccid             ||'"'
               ||','||'"'|| raw_cost_dr_account          ||'"'
               ||','||'"'|| burdened_cost_cr_ccid        ||'"'
               ||','||'"'|| burdened_cost_cr_account     ||'"'
               ||','||'"'|| burdened_cost_dr_ccid        ||'"'
               ||','||'"'|| burdened_cost_dr_account     ||'"'
               ||','||'"'|| burden_cost_cr_ccid          ||'"'
               ||','||'"'|| burden_cost_cr_account       ||'"'
               ||','||'"'|| burden_cost_dr_ccid          ||'"'
               ||','||'"'|| burden_cost_dr_account       ||'"'
               ||','||'"'|| acct_currency_code           ||'"'
               ||','||'"'|| acct_currency                ||'"'
               ||','||'"'|| acct_raw_cost                ||'"'
               ||','||'"'|| null           ||'"'  --acct_burdened_cost
               ||','||'"'|| decode(acct_rate_type,'Spot','User','User','User',null,null,acct_rate_type)               ||'"'  --acct_rate_type
               ||','||'"'|| to_char(acct_rate_date, 'YYYY/MM/DD')               ||'"'
               ||','||'"'|| acct_rate_date_type          ||'"'
               ||','||'"'|| acct_exchange_rate           ||'"'
               ||','||'"'|| acct_exchange_rounding_limit ||'"'
--               ||','||'"'|| receipt_currency_code        ||'"'
--               ||','||'"'|| receipt_currency             ||'"'
--               ||','||'"'|| receipt_currency_amount      ||'"'
--               ||','||'"'|| receipt_exchange_rate        ||'"'
               ||','||'"'|| converted_flag               ||'"'
               ||','||'"'|| context_category             ||'"'
               ||','||'"'|| user_def_attribute1          ||'"'
               ||','||'"'|| user_def_attribute2          ||'"'
               ||','||'"'|| user_def_attribute3          ||'"'
               ||','||'"'|| user_def_attribute4          ||'"'
               ||','||'"'|| user_def_attribute5          ||'"'
               ||','||'"'|| user_def_attribute6          ||'"'
               ||','||'"'|| user_def_attribute7          ||'"'
               ||','||'"'|| user_def_attribute8          ||'"'
               ||','||'"'|| user_def_attribute9          ||'"'
               ||','||'"'|| user_def_attribute10         ||'"'               
               ||','||'"'|| reserved_attribute1          ||'"'
               ||','||'"'|| reserved_attribute2          ||'"'
               ||','||'"'|| reserved_attribute3          ||'"'
               ||','||'"'|| reserved_attribute4          ||'"'
               ||','||'"'|| reserved_attribute5          ||'"'
               ||','||'"'|| reserved_attribute6          ||'"'
               ||','||'"'|| reserved_attribute7          ||'"'
               ||','||'"'|| reserved_attribute8          ||'"'
               ||','||'"'|| reserved_attribute9          ||'"'
               ||','||'"'|| reserved_attribute10         ||'"'
               ||','||'"'|| attribute_category           ||'"'
               ||','||'"'|| attribute1                   ||'"'
               ||','||'"'|| attribute2                   ||'"'
               ||','||'"'|| attribute3                   ||'"'
               ||','||'"'|| attribute4                   ||'"'
               ||','||'"'|| attribute5                   ||'"'
               ||','||'"'|| attribute6                   ||'"'
               ||','||'"'|| attribute7                   ||'"'
               ||','||'"'|| attribute8                   ||'"'
               ||','||'"'|| attribute9                   ||'"'
               ||','||'"'|| attribute10                  ||'"'
               ||','||'"'|| contract_number              ||'"'
               ||','||'"'|| contract_name                ||'"'
               ||','||'"'|| contract_id                  ||'"'
               ||','||'"'|| funding_source_number        ||'"'
               ||','||'"'|| funding_source_name          ||'"'
        OUTPUT,
        exp_batch_name batchname
    FROM XXMX_PPM_PRJ_lbrcost_xfm
    where 1=1 --exp_batch_name = 'UNBILLED'
--and attribute1 not in (select ORIG_TRANSACTION_REFERENCE from xxmx_ppm_unbilled_dev4_loaded_temp)
--and orig_transaction_reference not in (select ORIG_TRANSACTION_REFERENCE from xxmx_ppm_fusion_loaded_costs) --added by Rafik for delta load SIT 
--and exp_batch_name='OPEN_AR_1' --added by Rafik for delta load SIT
;
