--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_CONTRACTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_CONTRACTS_PKG" 
AS
--//================================================================================
--// Version 1
--// $Id:$
--//================================================================================
--// Object Name        :: XXMX_PPM_CONTRACTS_PKG.pkb
--//
--// Object Type        :: Package Body 
--//
--// Object Description :: This package contains procedure for PPM Contracts Creation
--//
--// Version Control
--//================================================================================
--// Version      Author               Date               Description
--//--------------------------------------------------------------------------------
--// 1.0          Milind Shanbhag      30/06/2022         Initial Build
--//================================================================================
--
-- Package Type Variables
--g_batch_name                              CONSTANT  VARCHAR2(240) := 'Contracts_'||to_char(SYSDATE,'DDMMYYYYHHMISS') ;
g_batch_name                               VARCHAR2(240)  ;
gv_location      VARCHAR2(500) := NULL;
--g_account_number VARCHAR2(30)  := '376001';
--g_party_name     VARCHAR2(50)  := 'DM Project - For Contract';
--g_cont_admin     VARCHAR2(30)  := 'Christopher T Laird';
--g_bill_to_site_use_id        VARCHAR2(30)  := '300001135029231';
--
-- ------------------------------------------------------------------------------
-- --------------------------< pop_contract_HEADERS >---------------------------|
-- ------------------------------------------------------------------------------
procedure pop_contract_headers
is
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_headers - Start';

DELETE FROM XXMX_PPM_CONT_headers;

INSERT INTO XXMX_PPM_CONT_headers
SELECT DISTINCT NULL                                       AS  action_code
,       f.project_number||'HES'                            AS  ext_source
,       f.project_number||'HEK'                            AS  ext_key
,       'US'                                               AS  language
,       'Y'                                                AS  source_language_flag
,       NULL                                               AS  business_unit_id
-- Get fusion BU from project
,       f.unit_name                                        AS  business_unit_name --revist
,       NULL                                               AS  legal_entity_id
-- Get fusion LE from Project
,       f.legal_entity_name                                AS  legal_entity_name  --revisit
,       f.contract_number                                  AS  contract_number
--,       f.project_number                                   AS  contract_number
,       f.project_name                                     AS  contract_name
--,       to_char(to_date(trim(f.start_date) , 'DD-MM-YYYY'),'MM/DD/YYYY')                                    AS  start_date
,       trim(f.start_date)                                 AS  start_date
--,       to_char(to_date(trim(f.completion_date)   , 'DD-MM-YYYY'),'MM/DD/YYYY')                              AS  end_date
,       trim(f.completion_date)                            AS  end_date
,       f.description                                      AS  description
,       'DRAFT'                                            AS  status_code
,       ''                                                 AS  version_description
,       null                                               AS  amount -- From Business
,       f.PROJECT_CURRENCY_CODE                           AS  currency_code     -- From Business
,       NULL                                               AS  contract_type_id
,       'Citco Contract Type'                      AS  contract_type_name   -- Revisit
,       'INTERNAL'                                         AS  authoring_party_code
,       NULL                                               AS  inv_organization_id
,       NULL                                               AS  inv_organization_name --revisit
,       NULL                                               AS  amendment_effective_date  --Revisit
--,       'DK VAT STANDARD'                                  AS  tax_classification_code  -- from Business
,       (select TAXCLASSIFICATIONCODE from xxmx_ppm_cont_bu_lookups where bu_name = f.unit_name)           AS  tax_classification_code  -- from Business
,       NULL                                               AS  tax_classification
,       'S'                                                AS  exemption_handling_code
,       NULL                                               AS  exemption_handling
,       NULL                                               AS  exemption_certificate_number
,       NULL                                               AS  exemption_reason_code
,       NULL                                               AS  exemption_reason
,       c.bill_to_account_id                                               AS  bill_to_account_id
--,       c.bill_to_account_number                                           AS  bill_to_account_number
,       NULL                                           AS  bill_to_account_number
,       c.bill_to_site_use_id                                               AS  bill_to_site_use_id
--,       c.bill_to_site_use_location                                                AS  bill_to_site_use_location
,       null                                                AS  bill_to_site_use_location
,       c.ship_to_account_id                                               AS  ship_to_account_id
--,       c.ship_to_account_number                                           AS  ship_to_account_number
,       null                                           AS  ship_to_account_number
,       c.ship_to_site_use_id                                               AS  ship_to_site_use_id
--,       c.ship_to_site_use_location                                                AS  ship_to_site_use_location
,       null                                                AS  ship_to_site_use_location
,       NULL                                               AS  sold_to_account_id
,       NULL                                               AS  sold_to_account_number
,       NULL                                               AS  sold_to_site_id
,       NULL                                               AS  sold_to_site_number
,       NULL                                               AS  warehouse_id
,       NULL                                               AS  warehouse_name
,       '100'                                              AS  contribution_percent -- Provide 100 as it calculates in Fusion 0.01 if its 1
,       NULL                                               AS  billing_sequence
,       NULL                                               AS  po_number
,       NULL                                               AS  sales_person_id
,       NULL                                               AS  sales_person_name
,       'S'                                                AS  release_invoice_auto_flag  -- Revisit
,       NULL                                               AS  contract_organization_id
,       f.org_name                                         AS  contract_organization_name
,       'N'                                                AS  net_invoice_flag  --Revisit
,       NULL                                               AS  transaction_type_id
,       'CONV PA Invoice'                                       AS  transaction_type_name  -- Derivation Revisit
,       NULL                                               AS  orig_system_source_code
,       NULL                                               AS  orig_system_id1
,       NULL                                               AS  orig_system_reference1
,       NULL                                               AS  close_date
,       NULL                                               AS  close_reason_code
,       NULL                                               AS  close_reason_set_code
,       NULL                                               AS  close_reason_set_id
,       NULL                                               AS  cancel_date
,       NULL                                               AS  cancel_reason_code
,       NULL                                               AS  cancel_reason_set_code
,       NULL                                               AS  cancel_reason_set_id
,       NULL                                               AS  hold_date
,       NULL                                               AS  hold_reason_code
,       NULL                                               AS  hold_reason_set_code
,       NULL                                               AS  hold_reason_set_id
,       NULL                                               AS  inv_conv_rate_date
,      'Transaction date'                                  AS  inv_conv_rate_date_type
--,       NULL                                  AS  inv_conv_rate_date_type
,       NULL                                               AS  inv_conv_rate_date_type_code
,       'Spot'                                        AS  inv_conv_rate_type
--,       NULL                                        AS  inv_conv_rate_type
,       NULL                                               AS  user_inv_conv_rate_type
,       NULL                                               AS  date_approved   -- From Business
,       NULL                                               AS  date_signed   -- From Business
,       NULL                                               AS  project_id
,       f.project_number                                   AS  PROJECT_NUMBER
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName 
FROM    XXMX_PPM_CONT_PROJ_INT f,
        XXMX_PPM_CONT_CUST_INT c
WHERE   1=1  
  AND   f.project_number = c.project_number
  ;
-- check project is loaded into fusion
-- check project exists in billing or revenue event
    --
    COMMIT;
    gv_location := 'pop_contract_headers - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure XXMX_PPM_CONTs_pkg.pop_contract_headers');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_headers;
--
-- ------------------------------------------------------------------------------
-- --------------------------< pop_contract_LINES >-----------------------------|
-- ------------------------------------------------------------------------------
procedure pop_contract_lines
is
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_lines - Start';

DELETE FROM XXMX_PPM_CONT_lines;

INSERT INTO XXMX_PPM_CONT_lines
SELECT NULL                                                AS  action_code
--,      ppch.project_number||'ESL'
--       ||'-'|| to_char(row_number() over 
--       (partition by ppch.project_number order by task_id))   AS  ext_source
,      ppch.project_number||'ESL'
       ||'-'|| pt.task_number   AS  ext_source
--,      ppch.project_number||'EKL'
--       ||'-'|| to_char(row_number() over 
--       (partition by ppch.project_number order by task_id))   AS  ext_key
,      ppch.project_number||'EKL'
       ||'-'|| pt.task_number   AS  ext_key
,      ppch.project_number||'HES'                          AS  header_ext_source
,      ppch.project_number||'HEK'                          AS  header_ext_key
,      NULL                                                AS  line_ext_source
,      NULL                                                AS  line_ext_key
,      'US'                                                AS  language
,      'Y'                                                 AS  source_language_flag
,      'PROJECT'                                           AS  line_source_code
,      pt.task_name                                        AS  line_name
,      pt.description                                      AS  line_description
,      'DRAFT'                                             AS  status_code
--,      to_char(to_date(trim(pt.start_date) , 'DD-MM-YYYY'),'MM/DD/YYYY')                 AS  start_date
,      trim(pt.start_date)                                 AS  start_date
--,      to_char(to_date(trim(pt.completion_date) , 'DD-MM-YYYY'),'MM/DD/YYYY')            AS  end_date
,      trim(pt.completion_date)                            AS  end_date
--,      to_char(row_number() over 
--        (partition by ppch.project_number order by task_id))  AS  line_number
,      pt.task_number                                      AS  line_number
,      NULL                                                AS  item_id
,      pt.task_number                                                AS  item_name  --Revisit. Need to populate item name from item lines?
,      NULL                                                AS  uom
,      NULL                                                AS  uom_code
,      NULL                                                AS  price_unit
,      NULL                                                AS  line_quantity
,      0                                                   AS  line_amount
,      'Y'                                                 AS  at_risk_flag
,      NULL                                                AS  percent_complete
,      NULL                                                AS  comments              
,      ppch.ship_to_account_id                                                AS  ship_to_account_id
,      null                                                AS  ship_to_account_number
,      ppch.ship_to_site_use_id                                                AS  ship_to_site_use_id
,      null                                                AS  ship_to_site_use_location
,      NULL                                                AS  warehouse_id
,      NULL                                                AS  warehouse_name
,      NULL                                                AS  bill_plan_id
,      ppch.project_number ||'I'||ppch.bill_to_account_number||'BES'                   AS  bill_plan_ext_source
,      ppch.project_number ||'I'||ppch.bill_to_account_number||'BEK'                   AS  bill_plan_ext_key  -- Need to confirm 
--,      null                   AS  bill_plan_ext_source
--,      null                   AS  bill_plan_ext_key  -- Need to confirm 
,      NULL                                                AS  po_number
,      NULL                                                AS  tax_exemption_code
,      NULL                                                AS  tax_exemption
,      NULL                                                AS  exemption_certificate_number
,      NULL                                                AS  exemption_reason
,      NULL                                                AS  exemption_reason_code
,      NULL                                                AS  tax_classification_code
,      NULL                                                AS  tax_classification
,      NULL                                                AS  close_date
,      NULL                                                AS  close_reason_code
,      NULL                                                AS  close_reason_set_code
,      NULL                                                AS  close_reason_set_id
,      NULL                                                AS  hold_date
,      NULL                                                AS  hold_reason_code
,      NULL                                                AS  hold_reason_set_code
,      NULL                                                AS  hold_reason_set_id
,      ppch.project_number||'R'||ppch.bill_to_account_number||'BES'                           AS  revenue_plan_ext_source   
,      ppch.project_number||'R'||ppch.bill_to_account_number||'BEK'                           AS  revenue_plan_ext_key   -- Need to confirm 
--,      null                            AS  revenue_plan_ext_source   
--,      null                            AS  revenue_plan_ext_key   -- Need to confirm 
,      NULL                                                AS  revenue_plan_id
,      NULL                                                AS  payment_terms_name
,      NULL                                                AS  payment_terms_id
,      ppch.bill_to_account_id                                                AS  bill_to_account_id
,      NULL                                            AS  bill_to_account_number
,      ppch.bill_to_site_use_id                                                AS  bill_to_site_use_id
,      null                                                AS  bill_to_site_use_location --Revisit
,      NULL                                                AS  line_type_id
,      'Free-form, project'                                AS  line_type_name
,      NULL                                                AS  cancel_date   
,      NULL                                                AS  cancel_reason_code
,      NULL                                                AS  cancel_reason_set_code
,      NULL                                                AS  cancel_reason_set_id
,      NULL                                                AS  estimated_var_consider_amount
,      NULL                                                AS  standalone_selling_price
,      pt.task_number                                      AS  task_number
,      NULL                                                AS  task_id
,      NULL                                                AS  project_id
,      1    --pfc_util_pkg.gc_cust_batch_id
,      g_batch_name
,      sysdate
,      xxmx_utilities_pkg.gvv_UserName
,      sysdate
,      xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers    ppch
       ,XXMX_PPM_CONT_TASK_INT pt
       ,XXMX_PPM_CONT_PROJ_INT f
WHERE   1                    = 1
AND     ppch.project_number  = f.project_number
AND     ppch.project_number  = pt.project_number
;
-- check task is loaded into fusion
-- check task exists in billing or revenue events src
    --
    COMMIT;
    gv_location := 'pop_contract_lines - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure pop_contract_lines');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_lines;
--
-- ------------------------------------------------------------------------------
-- ------------------< pop_contract_project_associates >------------------------|
-- ------------------------------------------------------------------------------
PROCEDURE pop_contract_project_associates
IS
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_project_associates - Start';

DELETE FROM XXMX_PPM_CONT_proj_associates;

INSERT INTO XXMX_PPM_CONT_proj_associates
SELECT  NULL                                                             AS  action_code
,       ppch.project_number||'AESL'||'-'||ppcl.task_number 
        ||'-'||ppcl.line_number                                          AS  ext_source
,       ppch.project_number||'AESL'||'-'||ppcl.task_number 
        ||'-'||ppcl.line_number                                          AS  ext_key
,       ppch.project_number||'ESL' ||'-'||ppcl.line_number               AS  line_ext_source
,       ppch.project_number||'EKL' ||'-'||ppcl.line_number               AS  line_ext_key
,       NULL                                                             AS  project_id
,       ppch.project_number                                              AS  project_number
,       NULL                                                             AS  task_id
,       ppcl.task_number                                                 AS  task_number
,       '0'                                                              AS  funded_amount
,       NULL                                                             AS  percent_complete
,       'Y'                                                              AS  active_flag
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch
       ,XXMX_PPM_CONT_lines   ppcl
WHERE   1                               =  1
AND     ppch.ext_key      =  ppcl.header_ext_key;
    --
    COMMIT;
    gv_location := 'pop_contract_project_associates - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure pop_contract_project_associates');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_project_associates;
--
-- ------------------------------------------------------------------------------
-- --------------------< pop_contract_BILL_PLANS >------------------------------|
-- ------------------------------------------------------------------------------
procedure pop_contract_bill_plans
is
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_bill_plans - Start';

DELETE FROM XXMX_PPM_CONT_bill_plans; 

INSERT INTO XXMX_PPM_CONT_bill_plans
SELECT  NULL                                                             AS  action_code
,       ppch.project_number ||'R'||ppch.bill_to_account_number||'BES'     AS  ext_source
,       ppch.project_number ||'R'||ppch.bill_to_account_number||'BEK'     AS  ext_key
,       ppch.project_number||'HES'                                       AS  header_ext_source
,       ppch.project_number||'HEK'                                       AS  header_ext_key
,       'US'                                                             AS  language
,       'Y'                                                              AS  source_language_flag
,       'R'                                                              AS  plan_type
,       'Rev'                          AS  name
,       NULL                                                             AS  method_id
,       'As Incurred Revenue'                                           AS  method_name
,       'N'                                                              AS  on_hold_flag
,       NULL                                                             AS  bill_to_account_id
--,       c.bill_to_account_number                                         AS  bill_to_account_number
,       null                                         AS  bill_to_account_number
,       NULL                                                             AS  bill_to_contact_id
,       NULL                                                             AS  bill_to_contact_name
,       NULL                                                             AS  bill_to_contact_email_id
,       NULL                                                             AS  bill_to_site_use_id
,       null                                         AS  bill_to_site_use_location
--,       c.bill_to_site_use_location                                      AS  bill_to_site_use_location
,       NULL                                                             AS  billing_currency_type_code
,       NULL                                                             AS  billing_currency_type
,       NULL                                                             AS  billing_cycle_id
,       NULL                                                             AS  billing_cycle
,       NULL                                                             AS  payment_terms_id
,       NULL                                                             AS  payment_terms
,       NULL                                                             AS  first_bill_offset_days
,       NULL                                                             AS  bill_set
,       NULL                                                             AS  labor_format_id
,       NULL                                                             AS  labor_format
,       NULL                                                             AS  nonlabor_format_id
,       NULL                                                             AS  nonlabor_format
,       NULL                                                             AS  event_format_id
,       NULL                                                             AS  event_format
,       NULL                                                             AS  person_rate_schedule_id
,       null                                                             AS  person_rate_schedule
,       NULL                                                             AS  job_rate_schedule_id
,       null                                                             AS  job_rate_schedule
,       NULL                                                             AS  labor_rate_schedule_fixed_date
,       NULL                                                             AS  labor_discount_percentage
,       NULL                                                             AS  labor_rate_change_reason_code
,       NULL                                                             AS  labor_rate_change_reason
,       NULL                                                             AS  nonlabor_rate_schedule_id
,       null                                                             AS  nl_rate_schedule
,       NULL                                                             AS  nl_rate_schedule_fixed_date
,       NULL                                                             AS  nl_discount_percentage
,       NULL                                                             AS  nl_rate_change_reason_code
,       NULL                                                             AS  nl_rate_change_reason
,       NULL                                                             AS  burden_schedule_id
,       NULL                                                             AS  burden_schedule
,       NULL                                                             AS  burden_schedule_fixed_date
,       NULL                                                             AS  enable_labor_bill_extn_flag
,       NULL                                                             AS  enable_nl_bill_extn_flag
,       NULL                                                             AS  labor_tp_schedule_id
,       NULL                                                             AS  labor_tp_schedule
,       NULL                                                             AS  labor_tp_schedule_fixed_date
,       NULL                                                             AS  nl_tp_schedule_id
,       NULL                                                             AS  nl_tp_schedule
,       NULL                                                             AS  nl_tp_schedule_fixed_date
,       NULL                                                             AS  invoice_currency
,       NULL                                                             AS  invoice_curr_rate_type_code
,       NULL                                                             AS  invoice_curr_rate_type
,       NULL                                                             AS  invoice_curr_date_type_code
,       NULL                                                             AS  invoice_curr_date_type
,       NULL                                                             AS  invoice_curr_conversion_date
,       NULL                                                             AS  invoice_comment
,       NULL                                                             AS  billing_instructions
,       NULL                                                             AS  labor_cost_basis_code
,       NULL                                                             AS  labor_cost_basis
,       NULL                                                             AS  labor_markup_percentage
,       NULL                                                             AS  nonlabor_cost_basis_code
,       NULL                                                             AS  nonlabor_cost_basis
,       NULL                                                             AS  nonlabor_markup_percentage
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch
       ,XXMX_PPM_CONT_PROJ_INT f
	   ,XXMX_PPM_CONT_CUST_INT c
WHERE   1                 = 1
AND     ppch.project_number = f.project_number
AND     ppch.project_number = c.project_number
UNION
SELECT  NULL                                                             AS  action_code
,       ppch.project_number ||'I'||ppch.bill_to_account_number||'BES'     AS  ext_source
,       ppch.project_number ||'I'||ppch.bill_to_account_number||'BEK'     AS  ext_key
,       ppch.project_number||'HES'                                       AS  header_ext_source
,       ppch.project_number||'HEK'                                       AS  header_ext_key
,       'US'                                                             AS  language
,       'Y'                                                              AS  source_language_flag
,       'I'                                                              AS  plan_type
,       'Bill_1'                          AS  name
,       NULL                                                             AS  method_id
,       'Bill Rate Invoice'                                           AS  method_name
,       'N'                                                              AS  on_hold_flag
,       c.bill_to_account_id                                                             AS  bill_to_account_id
--,       c.bill_to_account_number                                         AS  bill_to_account_number
,       NULL                                         AS  bill_to_account_number
,       NULL                                                             AS  bill_to_contact_id
,       'eBilling Contact'                                                             AS  bill_to_contact_name
,       NULL                                                             AS  bill_to_contact_email_id
,       c.bill_to_site_use_id                                                             AS  bill_to_site_use_id
--,       c.bill_to_site_use_location                                      AS  bill_to_site_use_location
,       NULL                                        AS  bill_to_site_use_location
,       NULL                                                             AS  billing_currency_type_code
,       NULL                                                             AS  billing_currency_type
,       NULL                                                             AS  billing_cycle_id
,       'Immediate'                                                             AS  billing_cycle
,       NULL                                                             AS  payment_terms_id
--,       '45 NET'                                                             AS  payment_terms
--,       (select PAYMENTTERMNAME from xxmx_ppm_cont_bu_lookups where bu_name = f.unit_name)         AS  payment_terms
,       f.payment_term_name                                                             AS  payment_terms
,       NULL                                                             AS  first_bill_offset_days
,       NULL                                                             AS  bill_set
,       NULL                                                             AS  labor_format_id
,       'Labor Top Task'                                                             AS  labor_format
,       NULL                                                             AS  nonlabor_format_id
,       'Non Labor Top Task'                                                             AS  nonlabor_format
,       NULL                                                             AS  event_format_id
,       'Event Top Task'                                                             AS  event_format
,       NULL                                                             AS  person_rate_schedule_id
--,       'Cost Emp DK5350'                                                             AS  person_rate_schedule
,       (select EMPBILLRATESCHNAME from xxmx_ppm_cont_bu_lookups where bu_name = f.unit_name)         AS  person_rate_schedule
,       NULL                                                             AS  job_rate_schedule_id
--,       'Labor DK5350'                                                             AS  job_rate_schedule
,       (select JOBBILLRATESCHNAME from xxmx_ppm_cont_bu_lookups where bu_name = f.unit_name)         AS  job_rate_schedule
,       NULL                                                             AS  labor_rate_schedule_fixed_date
,       NULL                                                             AS  labor_discount_percentage
,       NULL                                                             AS  labor_rate_change_reason_code
,       NULL                                                             AS  labor_rate_change_reason
,       NULL                                                             AS  nonlabor_rate_schedule_id
--,       'Non Labor DK5350'                                                             AS  nl_rate_schedule
,       (select NLBILLRATESCHNAME from xxmx_ppm_cont_bu_lookups where bu_name = f.unit_name)        AS  nl_rate_schedule
,       NULL                                                             AS  nl_rate_schedule_fixed_date
,       NULL                                                             AS  nl_discount_percentage
,       NULL                                                             AS  nl_rate_change_reason_code
,       NULL                                                             AS  nl_rate_change_reason
,       NULL                                                             AS  burden_schedule_id
,       NULL                                                             AS  burden_schedule
,       NULL                                                             AS  burden_schedule_fixed_date
,       NULL                                                             AS  enable_labor_bill_extn_flag
,       NULL                                                             AS  enable_nl_bill_extn_flag
,       NULL                                                             AS  labor_tp_schedule_id
,       NULL                                                             AS  labor_tp_schedule
,       NULL                                                             AS  labor_tp_schedule_fixed_date
,       NULL                                                             AS  nl_tp_schedule_id
,       NULL                                                             AS  nl_tp_schedule
,       NULL                                                             AS  nl_tp_schedule_fixed_date
,       NULL                                                             AS  invoice_currency
,       NULL                                                             AS  invoice_curr_rate_type_code
,       NULL                                                             AS  invoice_curr_rate_type
,       NULL                                                             AS  invoice_curr_date_type_code
,       NULL                                                             AS  invoice_curr_date_type
,       NULL                                                             AS  invoice_curr_conversion_date
,       NULL                                                             AS  invoice_comment
,       NULL                                                             AS  billing_instructions
,       NULL                                                             AS  labor_cost_basis_code
,       NULL                                                             AS  labor_cost_basis
,       NULL                                                             AS  labor_markup_percentage
,       NULL                                                             AS  nonlabor_cost_basis_code
,       NULL                                                             AS  nonlabor_cost_basis
,       NULL                                                             AS  nonlabor_markup_percentage
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch
       ,XXMX_PPM_CONT_PROJ_INT f
	   ,XXMX_PPM_CONT_CUST_INT c
WHERE   1                 = 1
AND     ppch.project_number = f.project_number
AND     ppch.project_number = c.project_number
;

-- Bill Plan: Project Number - I , Method - Amount Based Invoice
-- Bill Plan: Project Number - R , Method - Amount Based Revenue
    --
    COMMIT;
    gv_location := 'pop_contract_bill_plans - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure pop_contract_bill_plans');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_bill_plans;
--
-- ------------------------------------------------------------------------------
-- --------------------< pop_contract_PARTY_ROLES >-----------------------------|
-- ------------------------------------------------------------------------------
procedure pop_contract_party_roles
is
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_party_roles - Start';

DELETE FROM XXMX_PPM_CONT_party_roles; 

INSERT INTO XXMX_PPM_CONT_party_roles
SELECT  NULL                                                             AS  action_code
,       ppch.project_number|| 'CPES'                          AS  ext_source
,       ppch.project_number|| 'CPEK'                          AS  ext_key
,       ppch.ext_source                                                  AS  header_ext_source
,       ppch.ext_key                                            		 AS  header_ext_key
,       NULL                                                             AS  line_ext_source
,       NULL                                                             AS  line_ext_key
,       'US'                                                             AS  language
,       'Y'                                                              AS  source_language_flag
,       'ELIGIBLE_CUSTOMER'                                                 		 AS  party_role_code
,       NULL                                                             AS  party_id
,       c.cust_name                                                      AS  party_name
,       NULL                                                             AS  signed_date
,       NULL                                                             AS  signed_by
,       NULL                                                             AS  signer_role
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch
	   ,XXMX_PPM_CONT_CUST_INT c
WHERE   1 =  1
AND     ppch.project_number = c.project_number
union
SELECT  NULL                                                             AS  action_code
,       ppch.project_number||'SPES'                          AS  ext_source
,       ppch.project_number||'SPEK'                          AS  ext_key
,       ppch.ext_source                                                  AS  header_ext_source
,       ppch.ext_key                                            		 AS  header_ext_key
,       NULL                                                             AS  line_ext_source
,       NULL                                                             AS  line_ext_key
,       'US'                                                             AS  language
,       'Y'                                                              AS  source_language_flag
,       'SUPPLIER'                                                 		 AS  party_role_code
,       NULL                                                             AS  party_id
,       ppch.business_unit_name				                             AS  party_name
,       NULL                                                             AS  signed_date
,       NULL                                                             AS  signed_by
,       NULL                                                             AS  signer_role
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch
WHERE   1 =  1;
    --
    COMMIT;
    gv_location := 'pop_contract_party_roles - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure pop_contract_party_roles');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_party_roles;
--
-- ------------------------------------------------------------------------------
-- --------------------< pop_contract_PARTY_CONTACTS >--------------------------|
-- ------------------------------------------------------------------------------
procedure pop_contract_party_contacts
is
--
BEGIN
--
gv_location := NULL;
    --
    gv_location := 'pop_contract_party_contacts - Start';

DELETE FROM XXMX_PPM_CONT_PARTY_CONTACTS; 

INSERT INTO XXMX_PPM_CONT_PARTY_CONTACTS
SELECT
 NULL                                               AS  action_code
 ,ppch.project_number|| 'CONTRACT_ADMIN' ||'SPCES'   AS  ext_source 
 , ppch.project_number|| 'CONTRACT_ADMIN' ||'SPCEK'  AS  ext_key 
,       ppch.ext_source                             AS  header_ext_source
,       ppch.ext_key                                AS  header_ext_key
,       ppcpr.ext_source                            AS  party_ext_source
,		ppcpr.ext_key                               AS  party_ext_key
,       'CONTRACT_ADMIN'                            AS  contact_role_code  -- Revisit
,       NULL                                        AS  contact_id
--,		g_cont_admin                                AS contact_name  -- Chris
--,		substr(f.manager,1,instr(f.manager,':') - 1)                     AS contact_name  -- PM
,		f.manager                                   AS contact_name  -- PM
,       'Y'                                                              AS  owner_flag   -- Revist
,       'FULL'                                                           AS  access_level
,       ppch.start_date                             AS  start_date   
,       NULL                                                             AS  end_date
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch, XXMX_PPM_CONT_party_roles ppcpr
       ,XXMX_PPM_CONT_PROJ_INT f
WHERE   1 =  1
AND ppch.ext_source   = ppcpr.header_ext_source
AND ppch.ext_key      = ppcpr.header_ext_key
AND ppcpr.party_role_code = 'SUPPLIER' 
AND   f.project_number = ppch.project_number
/*UNION
 SELECT
 NULL                                                             AS  action_code
 ,ppch.project_number|| 'CONTRACT_MANAGER' ||'SPCES'  AS  ext_source 
 , ppch.project_number|| 'CONTRACT_MANAGER' ||'SPCEK'  AS  ext_key 
,       ppch.ext_source                                                AS  header_ext_source
,       ppch.ext_key                                            AS  header_ext_key
,       ppcpr.ext_source                            AS  party_ext_source
,		ppcpr.ext_key                               AS  party_ext_key
,       'CONTRACT_MANAGER'                                               AS  contact_role_code  -- Revisit
,       NULL                                                             AS  contact_id
--,		substr(f.manager,1,instr(f.manager,':') - 1)                     AS contact_name  -- Project Manager
,		f.manager                                   AS contact_name  -- PM
,       'Y'                                                              AS  owner_flag   -- Revist
,       'FULL'                                                           AS  access_level
--,       substr(f.manager,instr(f.manager,':') + 1)                       AS  start_date   -- PM latest assignment start date
,       ppch.start_date                             AS  start_date   
,       NULL                                                             AS  end_date
,       1    --pfc_util_pkg.gc_cust_batch_id
,       g_batch_name
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
,       sysdate
,       xxmx_utilities_pkg.gvv_UserName
FROM    XXMX_PPM_CONT_headers ppch, XXMX_PPM_CONT_party_roles ppcpr
       ,XXMX_PPM_CONT_PROJ_INT f
WHERE   1 =  1
AND ppch.ext_source   = ppcpr.header_ext_source
AND ppch.ext_key   = ppcpr.header_ext_key
AND ppcpr.party_role_code = 'SUPPLIER' 
AND   f.project_number = ppch.project_number*/
;
    --
    COMMIT;
    gv_location := 'pop_contract_party_contacts - End';
    --
    EXCEPTION
        WHEN OTHERS
        THEN
            ROLLBACK;
            dbms_output.put_line('Error in Procedure pop_contract_party_contacts');
            dbms_output.put_line('Error Message :'||SQLERRM);
            dbms_output.put_line('Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            raise_application_error(-20111, 'Error text :' ||dbms_utility.format_error_backtrace||CHR(13)||'Location: '||gv_location);
            --
END pop_contract_party_contacts;
--
-- ------------------------------------------------------------------------------
-- -------------------------< INSERT_TRUNCATE_TABLE >----------------------------
-- ------------------------------------------------------------------------------

/*
PROCEDURE insert_truncate_table IS
-- SRC Archive and Truncate Table data
    CURSOR insert_src_truncate_cur
    IS
      SELECT DISTINCT table_name 
      FROM dba_tab_columns
      WHERE table_name IN ( 'XXMX_PPM_CONT_HEADERS'
                           ,'XXMX_PPM_CONT_LINES'
						   ,'XXMX_PPM_CONT_PROJ_ASSOCIATES'
						   ,'XXMX_PPM_CONT_BILL_PLANS'
						   ,'XXMX_PPM_CONT_PARTY_ROLES'
						   ,'XXMX_PPM_CONT_PARTY_CONTACTS'
                          ) ;
BEGIN
    --
        FOR rec_insert_src_truncate_cur IN insert_src_truncate_cur
        LOOP
        --  
            BEGIN
                    pfc_util_pkg.insert_into_arch_table(rec_insert_src_truncate_cur.table_name);
                    pfc_util_pkg.truncate_table(rec_insert_src_truncate_cur.table_name);  

            EXCEPTION
                WHEN OTHERS THEN
                dbms_output.put_line('Error : ' || SUBSTR(SQLERRM, 1, 250));
                ROLLBACK;
            END;
        END LOOP;
END insert_truncate_table;
*/
--
-- ----------------------------------------------------------------------------
-- |------------------------------< MAIN >------------------------------------|
-- ----------------------------------------------------------------------------
--
PROCEDURE main (p_batch_name in varchar2)
IS
    l_start_date timestamp;
    l_end_date timestamp;
BEGIN
    l_start_date := systimestamp;
    IF p_batch_name IS NULL THEN
        dbms_output.put_line('Please enter a value for batch name');
        RAISE_APPLICATION_ERROR(-20000, 'Please enter a value for batch name');
    END IF;
    g_batch_name := p_batch_name;
--
	-- ----------------------------------------------------------------------------
    --dbms_output.put_line('Calling INSERT_TRUNCATE_TABLE');
    -- ----------------------------------------------------------------------------
    --insert_truncate_table;
	-- ----------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_HEADERS');
    -- ----------------------------------------------------------------------------
    pop_contract_headers;
	-- ----------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_LINES');
    -- ----------------------------------------------------------------------------
    pop_contract_lines;
	-- ----------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_PROJECT_ASSOCIATES');
    -- ----------------------------------------------------------------------------
    pop_contract_project_associates;
    --	-- ------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_BILL_PLANS');
    -- ----------------------------------------------------------------------------
    pop_contract_bill_plans;
    --	-- ------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_PARTY_ROLES');
    -- ----------------------------------------------------------------------------
    pop_contract_party_roles;
    --	-- ------------------------------------------------------------------------
    dbms_output.put_line('Calling pop_contract_PARTY_CONTACTS');
    -- ----------------------------------------------------------------------------
    pop_contract_party_contacts;
    --	
    --
   COMMIT;
	--
   l_end_date := systimestamp;
   dbms_output.put_line('Elapsed in Seconds:' ||TO_CHAR(l_end_date-l_start_date, 'SSSS.FF'));
--   
END main;
--
END XXMX_PPM_CONTRACTS_PKG;

/
