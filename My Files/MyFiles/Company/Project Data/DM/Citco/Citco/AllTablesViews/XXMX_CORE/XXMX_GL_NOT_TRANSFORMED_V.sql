--------------------------------------------------------
--  DDL for View XXMX_GL_NOT_TRANSFORMED_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "XXMX_CORE"."XXMX_GL_NOT_TRANSFORMED_V" ("RAW_COST_CR_ACCOUNT") AS 
  select distinct raw_cost_cr_account
from (
select user_transaction_source, raw_cost_dr_account,
document_name, doc_entry_name, exp_batch_name, task_number,  
organization_name, raw_cost_cr_account, raw_cost_dr_account,
expenditure_type,
exp_batch_name,
attribute1,
attribute2,
attribute3,
attribute4,
attribute5,
attribute6,
attribute7,
attribute8,
attribute9,
attribute10,
gl_date
from xxmx_ppm_prj_lbrcost_xfm
where ( length(raw_cost_cr_account ) = 28 
or   
length(raw_cost_dr_account ) = 28 
)
)
union
select distinct raw_cost_cr_account
from (
select user_transaction_source, raw_cost_dr_account,
document_name, doc_entry_name, exp_batch_name, task_number,  
organization_name, raw_cost_cr_account, raw_cost_dr_account,
expenditure_type,
exp_batch_name,
attribute1,
attribute2,
attribute3,
attribute4,
attribute5,
attribute6,
attribute7,
attribute8,
attribute9,
attribute10,
gl_date
from xxmx_ppm_prj_misccost_xfm
where ( length(raw_cost_cr_account ) = 28 
or   
length(raw_cost_dr_account ) = 28 
)
)
;
